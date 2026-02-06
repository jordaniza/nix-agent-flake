# agents

> **This repo is Claude-friendly.** There is a `CLAUDE.md` at the root with full context on how everything works. Point Claude Code at this repo and it can help you create tasks, debug runs, write personas, and manage infrastructure.

Scaffolding for running multi-agent workflows on ephemeral Hetzner VPS instances. Provisions a NixOS server, deploys a task with worker/reviewer/editor personas, runs a feedback loop via Claude Code, and fetches the results.

## How it works

Each task runs on a fresh VPS with three agent roles:

- **Worker** — executes the task, writes deliverables to `output/`, documents progress in `summary.md`
- **Reviewer** — scrutinizes the worker's output, fact-checks claims, writes feedback to `worker/review.md`
- **Editor** — refines tone, readability, and formatting without changing meaning

The worker and reviewer run in a loop (`run.sh`). Each round, the worker does its work, then the reviewer checks it. If the reviewer writes `DONE`, the loop exits. Otherwise it continues for up to N rounds.

## Quick start

```bash
make ssh-keygen                    # one-time: create SSH key + register with Hetzner
make deploy TASK=SKY               # provision server, install NixOS, push task files
make run TASK=SKY ROUNDS=5         # run the worker/reviewer loop remotely
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
  run               Run the worker/reviewer loop remotely (TASK=SKY, ROUNDS=5)
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

`setup-task` creates this layout on the server:

```
~/tasks/<TASK>/
├── task.md                          # main task brief (from tasks/<TASK>-worker.md)
├── output/                          # shared output directory for deliverables
├── logs/                            # JSONL execution logs per round
├── worker/
│   └── CLAUDE.md                    # worker persona (from personas/WORKER.md)
├── reviewer/
│   ├── CLAUDE.md                    # reviewer persona (from personas/REVIEWER.md)
│   └── review-instructions.md       # task-specific review notes
└── editor/
    ├── CLAUDE.md                    # editor persona (from personas/EDITOR.md)
    └── editor-instructions.md       # task-specific editor notes
```

## Creating a new task

Add three files to `tasks/`:

- `<TASK>-worker.md` — the main task brief (deliverables, sources, quality criteria)
- `<TASK>-reviewer.md` — task-specific review instructions (what to verify, how to fact-check)
- `<TASK>-editor.md` — task-specific editorial guidance (formatting, tone, conventions)

Then deploy and run:

```bash
make deploy TASK=MYTASK
make run TASK=MYTASK ROUNDS=5
```

See `tasks/SKY-worker.md` and `tasks/CRV-worker.md` for examples.

## Personas

The `personas/` directory contains role definitions deployed as `CLAUDE.md` files:

- **WORKER.md** — executes tasks, writes to `output/`, appends to `summary.md`, implements reviewer feedback
- **REVIEWER.md** — reads worker output, fact-checks, appends findings to `review-log.md`, writes actionable feedback to `worker/review.md`, writes `DONE` when satisfied
- **EDITOR.md** — edits output for tone/readability, backs up originals to `backups/`, logs changes in `edit-log.md`

## Execution loop (`run.sh`)

For each round:
1. Worker runs in `tasks/<TASK>/worker/`, reads `CLAUDE.md` and `../task.md`, produces output
2. Reviewer runs in `tasks/<TASK>/reviewer/`, reads worker's `summary.md` and `output/`, writes feedback
3. If `worker/review.md` starts with `DONE`, the loop exits early
4. Otherwise continues to the next round

All Claude Code output is logged as JSONL to `logs/worker-r1.jsonl`, `logs/reviewer-r1.jsonl`, etc.

## What's on the VPS

The NixOS config (`configuration.nix`) includes:

- claude-code, git, gh, curl, jq, ripgrep, fd, tree, btop, vim
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
