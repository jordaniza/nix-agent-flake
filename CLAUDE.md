# CLAUDE.md

This repo is scaffolding for running multi-agent workflows on ephemeral Hetzner VPS instances using Claude Code. Everything aside from the task definitions in `tasks/` is infrastructure.

## Repo layout

```
.
├── Makefile                  # Orchestration: provision, deploy, run, fetch, teardown
├── run.sh                    # Pipeline executor — runs ON the VPS
├── setup-task.sh             # Deploys personas, task files, and pipeline to VPS
├── tail-logs.sh              # Live log streaming from VPS to local terminal
├── agents.md                 # Registry of active servers (auto-managed by Makefile)
├── .env.template             # Required env vars for service credentials
│
├── personas/                 # Agent role definitions (deployed as CLAUDE.md on VPS)
│   ├── WORKER.md             # Executes tasks, writes output, documents in summary.md
│   ├── REVIEWER.md           # Fact-checks, writes feedback, approves via review-log.md
│   ├── DESIGNER.md           # Refines UI/UX, creates design spec, modifies output
│   └── EDITOR.md             # Refines tone/readability, never changes meaning
│
├── tasks/                    # One directory per task
│   └── <TASK>/
│       ├── pipeline           # Stage definitions (plain text, one line per stage)
│       ├── worker.md          # Main task brief, deliverables, quality criteria
│       ├── reviewer.md        # Task-specific review instructions
│       ├── designer.md        # Task-specific design criteria (optional)
│       └── editor.md          # Task-specific editorial guidance (optional)
│
├── results/                  # Fetched outputs from completed runs (gitignored)
│
├── configuration.nix         # NixOS system config (packages, SSH, users)
├── disk-config.nix           # Disk partitioning (GPT, ext4)
├── flake.nix                 # Nix flake entry point
├── flake.lock                # Pinned dependencies
└── keys.nix                  # SSH public keys for VPS access
```

## How it works

### Infrastructure lifecycle

All commands go through the Makefile. The typical flow:

1. `make deploy TASK=SKY` — tears down any existing server with that name, provisions a Hetzner cx23 instance, installs NixOS via nixos-anywhere, runs `setup-task.sh` to copy personas + task files + pipeline to the VPS
2. `make run TASK=SKY` — SSHes into the VPS and executes `run.sh`, which reads the pipeline file to determine stages
3. `make fetch-results TASK=SKY` — rsyncs `output/` back to `./results/SKY/`
4. `make teardown` — deletes the server, deregisters from agents.md

### Execution loop (run.sh)

`run.sh` runs on the VPS. It reads `pipeline` to determine stages. Each stage defines a pair of agents and a max round count. The pipeline file is plain text, one line per stage:

```
build 5 worker reviewer
design 3 designer reviewer
```

For each stage, `run.sh` runs a feedback loop: the first agent (doer) works, the second agent (reviewer) checks it. If the second agent writes `APPROVED` to `review-log.md`, the stage exits early. Otherwise it runs for the full round count. Progress is tracked in `state.log` (one line per completed round), enabling resume on re-run.

All agents run with `claude --dangerously-skip-permissions` and log full JSONL to `logs/`.

### VPS task structure

`setup-task.sh` creates one directory per persona on the server:

```
~/tasks/<TASK>/
├── task.md                    # Copied from tasks/<TASK>/worker.md
├── pipeline                   # Copied from tasks/<TASK>/pipeline
├── log.md                     # Shared project log — all agents append here
├── output/                    # Shared deliverables directory
├── logs/                      # JSONL execution logs (stage-agent-rN.jsonl)
├── worker/
│   ├── CLAUDE.md              # Copied from personas/WORKER.md
│   ├── instructions.md        # Copied from tasks/<TASK>/worker.md (if exists)
│   ├── summary.md             # Private work log (created by agent)
│   └── review.md              # Feedback from reviewer (created by reviewer)
├── reviewer/
│   ├── CLAUDE.md              # Copied from personas/REVIEWER.md
│   ├── instructions.md        # Copied from tasks/<TASK>/reviewer.md (if exists)
│   └── review-log.md          # Private review scratchpad (created by agent)
├── designer/
│   ├── CLAUDE.md              # Copied from personas/DESIGNER.md
│   ├── instructions.md        # Copied from tasks/<TASK>/designer.md (if exists)
│   ├── summary.md             # Private work log (created by agent)
│   ├── design-spec.md         # Design specification (created by agent)
│   └── review.md              # Feedback from reviewer (created by reviewer)
└── editor/
    ├── CLAUDE.md              # Copied from personas/EDITOR.md
    ├── instructions.md        # Copied from tasks/<TASK>/editor.md (if exists)
    ├── edit-log.md            # Private edit log (created by agent)
    └── review.md              # Feedback from reviewer (created by reviewer)
```

### Coordination: log.md

`log.md` is the shared project log at the task root. `run.sh` writes stage/round headers before each agent runs. Every agent reads it for full context and appends a brief summary after their work. This is how agents discover what other agents have done across stages — the reviewer reads it to find who the current doer is, the designer reads it to see what the worker built, etc.

Private detailed logs stay in each agent's directory (summary.md, review-log.md, design-spec.md, edit-log.md). The shared log contains high-level summaries with pointers to these details.

The reviewer writes `review.md` into the **doer's** directory (e.g. `../designer/review.md` during the design stage), so feedback always lands where the doer will find it.

### Agent roles

**Worker** (`personas/WORKER.md`): Does the work. Reads task.md, writes deliverables to `../output/`, appends decisions and progress to `summary.md`. Reads review.md for feedback. Appends summary to `../log.md`.

**Reviewer** (`personas/REVIEWER.md`): Quality gate. Reads `../log.md` to discover the current doer, then reads their summary.md and everything in output/. Fact-checks links, verifies claims, checks that code runs. Appends private findings to `review-log.md`, actionable feedback to the doer's `review.md`. Writes `APPROVED` to `review-log.md` and appends a deliverables manifest to `../deliverables.md` when satisfied. Never modifies files in `output/`. Appends summary to `../log.md`.

**Designer** (`personas/DESIGNER.md`): Product designer. Creates a design spec (target persona, design principles, visual direction), then refines output files for UI/UX quality. Backs up originals before modifying. Every change traces back to a design principle. Reads review.md for feedback. Appends summary to `../log.md`.

**Editor** (`personas/EDITOR.md`): Formatting pass. Edits output files for tone, readability, and consistency. Backs up originals to `output/backups/`, logs changes in `edit-log.md`. Never changes meaning or removes information. Reads review.md for feedback. Appends summary to `../log.md`.

## Creating a new task

1. Create a directory in `tasks/<TASK>/` with:
   - `pipeline` — stage definitions (one line per stage: `name max-rounds agent1 agent2`)
   - `worker.md` — deliverables, sources, quality criteria
   - `reviewer.md` — what to verify, how to fact-check
   - `designer.md` — design criteria (optional, only if pipeline includes designer)
   - `editor.md` — formatting, tone, conventions (optional, only if pipeline includes editor)

2. Deploy and run:
   ```bash
   make deploy TASK=MYTASK
   make run TASK=MYTASK
   ```

### Example tasks

**SKY** (`tasks/SKY-worker.md`): Apply Aragon's Ownership Token Framework to the SKY governance token. Deliverables: research report with sourced claims (contract addresses + GitHub line numbers), metrics JSON matching framework schema, source list, governance flow diagram.

**CRV** (`tasks/CRV-worker.md`): Build a static dashboard comparing CRV, veCRV, and cvxCRV. Deliverables: price chart, yield chart, hosted on port 80. Uses Python for data fetching and vanilla HTML/JS with CDN charting.

## Key Makefile variables

```makefile
SSH_KEY      ?= ~/.ssh/agent-vm    # SSH key for VPS access
SERVER_TYPE  ?= cx23               # Hetzner server type
TASK         ?= SKY                # Default task name
```

## NixOS config

`configuration.nix` sets up the VPS with:
- Packages: claude-code, supabase-cli, git, gh, curl, jq, ripgrep, fd, python3, nodejs 22, bun, yarn, go, gcc, and more
- SSH: root + agent user, pubkey-only auth (keys from `keys.nix`)
- nix-ld enabled for FHS binary compatibility
- Nix flakes enabled

## Conventions

- `log.md` is the shared project ledger — all agents append, none overwrite. `run.sh` writes stage headers
- Private agent logs are append-only (summary.md, review-log.md, edit-log.md, etc.)
- Reviewer writes `review.md` to the doer's directory, not its own
- Deliverables always go in `output/`
- Designer and editor back up originals to `output/backups/` before modifying
- Reviewer signals approval by writing `APPROVED` to `review-log.md` and appending to `../deliverables.md`
- `state.log` tracks completed rounds for resume support (`stage:round [approved|exhausted]`)
- JSONL logs capture full Claude Code interactions for audit (named `stage-agent-rN.jsonl`)
- Servers are tracked in `agents.md` (auto-managed, don't edit manually)
- Results fetched to `./results/<TASK>/`
- Service credentials (GitHub, Vercel, Supabase) delivered via `.env` file copied to VPS at deploy time
