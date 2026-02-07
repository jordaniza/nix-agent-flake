# agents

> **This repo is Claude-friendly.** There is a `CLAUDE.md` at the root with full context on how everything works. Point Claude Code at this repo and it can help you create tasks, debug runs, write personas, and manage infrastructure.

Scaffolding for running multi-agent workflows on ephemeral Hetzner VPS instances. Provisions a NixOS server, deploys a task with configurable agent personas, runs a multi-stage pipeline via Claude Code, and fetches the results.

## How it works

Each task runs on a fresh VPS with agent roles defined in `personas/`:

- **Worker** — executes the task, writes deliverables to `output/`, documents progress in `summary.md`
- **Reviewer** — scrutinizes output, fact-checks claims, writes feedback. Writes `APPROVED` to `status.tmp` when satisfied
- **Designer** — creates a design spec, then refines UI/UX in output files. Backs up originals
- **Editor** — refines tone, readability, and formatting without changing meaning

A `pipeline` file defines stages. Each stage pairs two agents in a feedback loop (or runs one agent solo). Example:

```
build 5 worker reviewer
design 3 designer reviewer
```

## Quick start

```bash
make ssh-keygen                    # one-time: create SSH key + register with Hetzner
make deploy TASK=SKY               # provision server, install NixOS, push task files
make run TASK=SKY                  # run the pipeline remotely
make tail-logs TASK=SKY            # (in another terminal) stream live agent output
make fetch-results TASK=SKY        # pull deliverables back to ./results/SKY/
make teardown                      # delete the server
```

## Commands

Run `make help` to see all commands:

```
  ssh-keygen        Generate an ed25519 SSH keypair and register it with Hetzner
  provision         Create a Hetzner cloud server
  install           Install NixOS on the server via nixos-anywhere
  connect           SSH into the server
  setup-task        Create task dirs and copy persona/task/runner files to server
  run               Run the pipeline remotely (TASK=SKY)
  tail-logs         Stream live agent output from the server (POLL=2)
  fetch-results     Pull output files from the server
  fetch-all         Pull entire task directory including all agent logs
  fetch-logs        Pull just the logs directory
  deploy            Tear down existing server (if any), provision, install NixOS, and push task
  rebuild           Teardown and redeploy from scratch
  teardown          Delete the server
  status            Check which agents are actually running on Hetzner
  list              Show active agents
```

Override defaults with env vars:

```bash
make provision SERVER=agent-02 SERVER_TYPE=cx32
```

## Setup

1. Add your SSH public key to `keys.nix`:

```nix
{
  authorizedKeys = [
    "ssh-ed25519 AAAA... your-actual-key"
  ];
}
```

2. Ensure `hcloud` CLI is configured with your Hetzner API token.

3. Run `make ssh-keygen` to generate and register the VM keypair.

## VPS task structure

`setup-task.sh` creates one directory per persona on the server:

```
~/tasks/<TASK>/
├── task.md                          # main task brief (from tasks/<TASK>/worker.md)
├── pipeline                         # stage definitions (from tasks/<TASK>/pipeline)
├── output/                          # shared output directory for deliverables
├── logs/                            # JSONL execution logs (stage-agent-rN.jsonl)
├── worker/
│   ├── CLAUDE.md                    # from personas/WORKER.md
│   └── instructions.md              # from tasks/<TASK>/worker.md (if exists)
├── reviewer/
│   ├── CLAUDE.md                    # from personas/REVIEWER.md
│   └── instructions.md              # from tasks/<TASK>/reviewer.md (if exists)
├── designer/
│   ├── CLAUDE.md                    # from personas/DESIGNER.md
│   └── instructions.md              # from tasks/<TASK>/designer.md (if exists)
└── editor/
    ├── CLAUDE.md                    # from personas/EDITOR.md
    └── instructions.md              # from tasks/<TASK>/editor.md (if exists)
```

## Creating a new task

Create a directory `tasks/<TASK>/` with:

- `pipeline` — stage definitions (one line per stage: `name max-rounds agent1 agent2`)
- `worker.md` — the main task brief (deliverables, sources, quality criteria)
- `reviewer.md` — task-specific review instructions (what to verify, how to fact-check)
- `designer.md` — task-specific design criteria (optional)
- `editor.md` — task-specific editorial guidance (optional)

Then deploy and run:

```bash
make deploy TASK=MYTASK
make run TASK=MYTASK
```

See `tasks/SKY/` and `tasks/CRV/` for examples.

## Personas

The `personas/` directory contains role definitions deployed as `CLAUDE.md` files:

- **WORKER.md** — executes tasks, writes to `output/`, appends to `summary.md`, implements reviewer feedback
- **REVIEWER.md** — reads output, fact-checks, writes feedback to the primary agent's `review.md`, writes `APPROVED` to `status.tmp` when satisfied
- **DESIGNER.md** — creates design spec (persona, principles, visual direction), refines output for UI/UX, backs up originals
- **EDITOR.md** — edits output for tone/readability, backs up originals to `backups/`, logs changes in `edit-log.md`

## Execution loop (`run.sh`)

`run.sh` reads the `pipeline` file and executes stages sequentially. Each stage pairs two agents in a feedback loop:

1. First agent (doer) runs in its directory, reads `CLAUDE.md` and `../task.md`, does its work
2. Second agent (reviewer) runs in its directory, examines output, writes feedback
3. If the reviewer writes `APPROVED` to `../status.tmp`, the stage exits early
4. Otherwise continues for up to `max-rounds`

All Claude Code output is logged as JSONL to `logs/` (e.g. `build-worker-r1.jsonl`, `design-designer-r2.jsonl`).

## What's on the VPS

The NixOS config (`configuration.nix`) includes:

- claude-code, supabase-cli, git, gh, curl, jq, ripgrep, fd, tree, btop, vim
- python3, nodejs 22, bun, yarn, go, gcc, gnumake, pkg-config, openssl
- nix-ld for FHS binary compat
- SSH root login (pubkey only)

## Server tracking

Active servers are tracked in `agents.md`. The Makefile auto-registers on deploy and deregisters on teardown. Run `make list` to see active agents or `make status` to query Hetzner directly.

## Results

Fetched results land in `./results/<TASK>/`. Use:

- `make fetch-results` — just `output/` (the deliverables)
- `make fetch-all` — full task directory (worker logs, reviewer notes, everything)
- `make fetch-logs` — just the JSONL execution logs
