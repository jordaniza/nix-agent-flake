# CLAUDE.md

This repo is scaffolding for running multi-agent workflows on ephemeral Hetzner VPS instances using Claude Code. Everything aside from the task definitions in `tasks/` is infrastructure.

## Repo layout

```
.
├── Makefile                  # Orchestration: provision, deploy, run, fetch, teardown
├── run.sh                    # Execution loop (worker/reviewer rounds) — runs ON the VPS
├── tail-logs.sh              # Live log streaming from VPS to local terminal
├── agents.md                 # Registry of active servers (auto-managed by Makefile)
│
├── personas/                 # Agent role definitions (deployed as CLAUDE.md on VPS)
│   ├── WORKER.md             # Executes tasks, writes output, documents in summary.md
│   ├── REVIEWER.md           # Fact-checks, writes feedback, approves with "DONE"
│   └── EDITOR.md             # Refines tone/readability, never changes meaning
│
├── tasks/                    # Task definitions (3 files per task)
│   ├── <TASK>-worker.md      # Main task brief, deliverables, quality criteria
│   ├── <TASK>-reviewer.md    # Task-specific review instructions
│   └── <TASK>-editor.md      # Task-specific editorial guidance
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

1. `make deploy TASK=SKY` — tears down any existing server with that name, provisions a Hetzner cx23 instance, installs NixOS via nixos-anywhere, copies task files + personas + run.sh to the VPS
2. `make run TASK=SKY ROUNDS=5` — SSHes into the VPS and executes `run.sh`
3. `make fetch-results TASK=SKY` — rsyncs `output/` back to `./results/SKY/`
4. `make teardown` — deletes the server, deregisters from agents.md

### Execution loop (run.sh)

`run.sh` runs on the VPS. For each round (up to MAX_ROUNDS):

1. **Worker** runs in `~/tasks/<TASK>/worker/` — Claude reads CLAUDE.md (the worker persona), reads `../task.md`, does the work, writes files to `../output/`, appends progress to `summary.md`. If `review.md` exists from a previous round, it implements the feedback.
2. **Reviewer** runs in `~/tasks/<TASK>/reviewer/` — Claude reads CLAUDE.md (the reviewer persona), reads `../task.md` and `../worker/summary.md`, examines `../output/`, writes private notes to `review-log.md`, writes actionable feedback to `../worker/review.md`.
3. If `worker/review.md` starts with `DONE`, the loop exits. Otherwise the next round begins.

Both agents run with `claude --dangerously-skip-permissions` and log full JSONL to `logs/`.

### VPS task structure

`make setup-task` creates this on the server:

```
~/tasks/<TASK>/
├── task.md                    # Copied from tasks/<TASK>-worker.md
├── output/                    # Shared deliverables directory
├── logs/                      # JSONL execution logs
├── worker/
│   └── CLAUDE.md              # Copied from personas/WORKER.md
├── reviewer/
│   ├── CLAUDE.md              # Copied from personas/REVIEWER.md
│   └── review-instructions.md # Copied from tasks/<TASK>-reviewer.md
└── editor/
    ├── CLAUDE.md              # Copied from personas/EDITOR.md
    └── editor-instructions.md # Copied from tasks/<TASK>-editor.md
```

### Agent roles

**Worker** (`personas/WORKER.md`): Does the work. Reads task.md, writes deliverables to `../output/`, appends decisions and progress to `summary.md`. If review.md exists, implements the requested changes. Never reads `../reviewer/`.

**Reviewer** (`personas/REVIEWER.md`): Quality gate. Reads task.md, worker's summary.md, and everything in output/. Fact-checks links, verifies claims, checks that code runs. Appends private findings to `review-log.md`, actionable feedback to `../worker/review.md`. Writes "DONE - Approved for human review." when satisfied. Never modifies files in `output/`.

**Editor** (`personas/EDITOR.md`): Formatting pass. Edits output files for tone, readability, and consistency. Backs up originals to `backups/`, logs changes in `edit-log.md`. Never changes meaning or removes information.

## Creating a new task

1. Create three files in `tasks/`:
   - `<TASK>-worker.md` — deliverables, sources, quality criteria
   - `<TASK>-reviewer.md` — what to verify, how to fact-check
   - `<TASK>-editor.md` — formatting, tone, conventions

2. Deploy and run:
   ```bash
   make deploy TASK=MYTASK
   make run TASK=MYTASK ROUNDS=5
   ```

### Example tasks

**SKY** (`tasks/SKY-worker.md`): Apply Aragon's Ownership Token Framework to the SKY governance token. Deliverables: research report with sourced claims (contract addresses + GitHub line numbers), metrics JSON matching framework schema, source list, governance flow diagram.

**CRV** (`tasks/CRV-worker.md`): Build a static dashboard comparing CRV, veCRV, and cvxCRV. Deliverables: price chart, yield chart, hosted on port 80. Uses Python for data fetching and vanilla HTML/JS with CDN charting.

## Key Makefile variables

```makefile
SSH_KEY      ?= ~/.ssh/agent-vm    # SSH key for VPS access
SERVER_TYPE  ?= cx23               # Hetzner server type
TASK         ?= SKY                # Default task name
ROUNDS       ?= 5                  # Max worker/reviewer rounds (passed to run.sh)
```

## NixOS config

`configuration.nix` sets up the VPS with:
- Packages: claude-code, git, gh, curl, jq, ripgrep, fd, python3, nodejs 22, bun, yarn, go, gcc, and more
- SSH: root + agent user, pubkey-only auth (keys from `keys.nix`)
- nix-ld enabled for FHS binary compatibility
- Nix flakes enabled

## Conventions

- All agent logs are append-only (summary.md, review.md, review-log.md, edit-log.md)
- Deliverables always go in `output/`
- Editor backs up originals to `backups/` before modifying
- JSONL logs capture full Claude Code interactions for audit
- Servers are tracked in `agents.md` (auto-managed, don't edit manually)
- Results fetched to `./results/<TASK>/`
