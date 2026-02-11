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
│   ├── WORKER.md             # Generic worker — executes tasks, writes output
│   ├── REVIEWER.md           # Generic reviewer — fact-checks, approves via review-log.md
│   ├── SPECWRITER.md         # Writes technical specifications from source code
│   ├── SPECREVIEWER.md       # Reviews specs against source code and contracts
│   ├── BACKEND.md            # Backend developer — APIs, data pipelines, deployment
│   ├── FRONTEND.md           # Frontend developer — interactive web interfaces
│   ├── DESIGNER.md           # Refines UI/UX, creates design spec, modifies output
│   └── EDITOR.md             # Refines tone/readability, never changes meaning
│
├── tasks/                    # One directory per task
│   └── <TASK>/
│       ├── pipeline           # Stage definitions (plain text, one line per stage)
│       ├── task.md            # Shared task brief (falls back to worker.md)
│       ├── <persona>.md       # Task-specific instructions per persona (optional)
│       └── ...                # e.g. specwriter.md, reviewer.md, editor.md
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
spec 5 specwriter specreviewer
backend 10 backend reviewer
design 3 designer reviewer
```

Agent names in the pipeline must match the lowercase filename (without `.md`) of a persona in `personas/`.

For each stage, `run.sh` runs a feedback loop: the first agent (doer) works, the second agent (reviewer) checks it. If the second agent writes `APPROVED` to `review-log.md`, the stage exits early. Otherwise it runs for the full round count. Progress is tracked in `state.log` (one line per completed round), enabling resume on re-run.

All agents run with `claude --dangerously-skip-permissions` and log full JSONL to `logs/`.

### VPS task structure

`setup-task.sh` creates one directory per persona on the server:

```
~/tasks/<TASK>/
├── task.md                    # Copied from tasks/<TASK>/task.md (or worker.md)
├── pipeline                   # Copied from tasks/<TASK>/pipeline
├── log.md                     # Shared project log — all agents append here
├── output/                    # Shared deliverables directory
├── logs/                      # JSONL execution logs (stage-agent-rN.jsonl)
├── <persona>/                  # One directory per persona in personas/
│   ├── CLAUDE.md              # Copied from personas/<PERSONA>.md
│   ├── instructions.md        # Copied from tasks/<TASK>/<persona>.md (if exists)
│   ├── summary.md             # Private work log (created by doer agents)
│   ├── review.md              # Feedback from reviewer (created by reviewer agents)
│   └── review-log.md          # Private review scratchpad (reviewer agents only)
└── ...
```

### Coordination: log.md

`log.md` is the shared project log at the task root. `run.sh` writes stage/round headers before each agent runs. Every agent reads it for full context and appends a brief summary after their work. This is how agents discover what other agents have done across stages — the reviewer reads it to find who the current doer is, the designer reads it to see what the worker built, etc.

Private detailed logs stay in each agent's directory (summary.md, review-log.md, design-spec.md, edit-log.md). The shared log contains high-level summaries with pointers to these details.

The reviewer writes `review.md` into the **doer's** directory (e.g. `../designer/review.md` during the design stage), so feedback always lands where the doer will find it.

### Agent roles

Personas are either **doers** (produce output) or **reviewers** (verify and approve). Any persona can be paired with any other in the pipeline.

#### Doers

**Worker** (`WORKER.md`): Generic task executor. Reads task.md, writes to `../output/`, documents in summary.md.

**Spec Writer** (`SPECWRITER.md`): Writes technical specifications from source code. Reads repos and contracts, produces spec documents with diagrams, invariants, and edge case coverage.

**Backend** (`BACKEND.md`): Backend developer. Builds services, APIs, and data pipelines from specifications. Writes tests alongside code, enforces invariants as assertions.

**Frontend** (`FRONTEND.md`): Frontend developer. Builds interactive web interfaces. Works from the API and spec, uses real data, tests on desktop and mobile.

**Designer** (`DESIGNER.md`): Product designer. Creates a design spec, then refines output files for UI/UX. Backs up originals before modifying. Every change traces back to a design principle.

**Editor** (`EDITOR.md`): Editorial pass. Edits output for tone, readability, and consistency. Backs up originals, logs changes. Never changes meaning or removes information.

#### Reviewers

**Reviewer** (`REVIEWER.md`): Generic quality gate. Reads the doer's work and `../output/`, fact-checks, verifies code builds and tests pass. Writes feedback to the doer's `review.md`.

**Spec Reviewer** (`SPECREVIEWER.md`): Specification reviewer. Verifies specs against actual source code — traces every claim to a function/event, checks edge cases, walks through invariants with concrete examples.

## Creating a new task

1. Create a directory in `tasks/<TASK>/` with:
   - `pipeline` — stage definitions (one line per stage: `name max-rounds agent1 agent2`)
   - `task.md` — shared task brief read by all agents (falls back to `worker.md` if no `task.md`)
   - `<persona>.md` — task-specific instructions per persona (optional, copied as `instructions.md`)

2. Deploy and run:
   ```bash
   make deploy TASK=MYTASK
   make run TASK=MYTASK
   ```

### Example tasks

**SKY** (`tasks/SKY/`): Apply Aragon's Ownership Token Framework to the SKY governance token. Deliverables: research report with sourced claims (contract addresses + GitHub line numbers), metrics JSON matching framework schema, source list, governance flow diagram.

**CRV** (`tasks/CRV/`): Build a static dashboard comparing CRV, veCRV, and cvxCRV. Deliverables: price chart, yield chart, hosted on port 80. Uses Python for data fetching and vanilla HTML/JS with CDN charting.

**DELEGATION** (`tasks/DELEGATION/`): Indexing service for delegate voting breakdowns in Aragon's ve-governance system. 5-stage pipeline: spec writing, editorial polish, backend API with Supabase caching, interactive frontend, design pass.

## Sending feedback mid-run

Write a `feedback.md` in the task directory (`tasks/<TASK>/feedback.md`), then:

```bash
make feedback TASK=MYTASK              # appends to log.md (all agents see it)
make feedback TASK=MYTASK TO=backend   # appends to backend/review.md
```

If a stage is already complete, reset it and everything after it:

```bash
make reset-stage TASK=MYTASK STAGE=backend
make run TASK=MYTASK
```

`tail-logs` does not exit when the pipeline completes — it keeps tailing so you can reset and re-run without restarting it.

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
