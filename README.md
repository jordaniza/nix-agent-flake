# agents

> **This repo is Claude-friendly.** There is a `CLAUDE.md` at the root with full context on how everything works. Point Claude Code at this repo and it can help you create tasks, debug runs, write personas, and manage infrastructure.

Scaffolding for running multi-agent workflows on ephemeral Hetzner VPS instances. Provisions a NixOS server, deploys a task with configurable agent personas, runs a multi-stage pipeline via Claude Code, and fetches the results.

## How it works

Each task runs on a fresh VPS with agent roles defined in `personas/`. Personas are either **doers** (produce output) or **reviewers** (verify and approve):

**Doers:**
- **Worker** — generic task executor
- **Spec Writer** — writes technical specifications from source code
- **Backend** — backend developer (APIs, data pipelines, deployment)
- **Frontend** — frontend developer (interactive web interfaces)
- **Designer** — creates a design spec, refines UI/UX in output files
- **Editor** — refines tone, readability, and formatting without changing meaning

**Reviewers:**
- **Reviewer** — generic quality gate (fact-checks, verifies builds/tests)
- **Spec Reviewer** — verifies specifications against source code and contracts

A `pipeline` file defines stages. Each stage pairs two agents in a feedback loop (or runs one agent solo). Example:

```
spec 5 specwriter specreviewer
backend 10 backend reviewer
design 3 designer reviewer
```

Agent names in the pipeline match the lowercase filename (without `.md`) of a persona in `personas/`.

All agents coordinate via a shared `log.md` at the task root. Each agent reads it for context and appends a summary after their work. Reviewers write feedback to the doer's `review.md`.

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
├── task.md                          # from tasks/<TASK>/task.md (or worker.md)
├── pipeline                         # stage definitions
├── log.md                           # shared project log (created by run.sh)
├── output/                          # shared deliverables directory
├── logs/                            # JSONL execution logs (stage-agent-rN.jsonl)
└── <persona>/                       # one per persona in personas/
    ├── CLAUDE.md                    # from personas/<PERSONA>.md
    └── instructions.md              # from tasks/<TASK>/<persona>.md (if exists)
```

Agents create additional files during execution: `summary.md` (doers), `review-log.md` (reviewers), `review.md` (written by reviewers into the doer's directory).

## Creating a new task

Create a directory `tasks/<TASK>/` with:

- `pipeline` — stage definitions (one line per stage: `name max-rounds agent1 agent2`)
- `task.md` — shared task brief read by all agents (falls back to `worker.md` if no `task.md`)
- `<persona>.md` — task-specific instructions per persona (optional, copied as `instructions.md`)

Then deploy and run:

```bash
make deploy TASK=MYTASK
make run TASK=MYTASK
```

See `tasks/SKY/`, `tasks/CRV/`, and `tasks/DELEGATION/` for examples.

## Execution loop (`run.sh`)

`run.sh` reads the `pipeline` file and executes stages sequentially. Each stage pairs two agents in a feedback loop:

1. `run.sh` writes a stage/round header to `log.md`
2. First agent (doer) runs in its directory, reads `CLAUDE.md` and `../task.md`, does its work, appends to `../log.md`
3. Second agent (reviewer) runs in its directory, reads `../log.md` to find the doer, examines output, writes feedback to the doer's `review.md`, appends to `../log.md`
4. If the reviewer writes `APPROVED` to `review-log.md`, the stage exits early
5. Otherwise continues for up to `max-rounds`

All Claude Code output is logged as JSONL to `logs/` (e.g. `spec-specwriter-r1.jsonl`, `backend-reviewer-r2.jsonl`).

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
