# agents

Minimal NixOS config for running Claude Code on a remote machine via nixos-anywhere.

## Setup

1. Add your SSH public key to `keys.nix`:

```nix
{
  authorizedKeys = [
    "ssh-ed25519 AAAA... your-actual-key"
  ];
}
```

2. Run `make help` to see available commands:

```
  ssh-keygen        Generate an ed25519 SSH keypair and register it with Hetzner
  provision         Create a Hetzner cloud server
  install           Install NixOS on the server via nixos-anywhere
  connect           SSH into the server
  setup-task        Create task dirs and copy persona/task files to server
  fetch-results     Pull results back from the server
  deploy            Tear down existing server (if any), provision, install NixOS, and push task
  rebuild           Teardown and redeploy from scratch
  teardown          Delete the server
```

Typical workflow:

```bash
make ssh-keygen                    # one-time: create key + register with Hetzner
make deploy TASK=my-task           # provision, install NixOS, and push task files
make connect                       # SSH in and run agents
make fetch-results TASK=my-task    # pull results back
make teardown                      # delete the server
```

`setup-task` creates this structure on the VPS:

```
~/tasks/<TASK>/
├── task.md                          # main task brief
├── output/                          # shared output directory
├── worker/
│   └── CLAUDE.md                    # worker persona
├── reviewer/
│   ├── CLAUDE.md                    # reviewer persona
│   └── review-instructions.md       # task-specific review notes
└── editor/
    ├── CLAUDE.md                    # editor persona
    └── editor-instructions.md       # task-specific editor notes
```

Override defaults with env vars:

```bash
make provision SERVER=agent-02 SERVER_TYPE=cx32
```

## What's included

- claude-code
- git, gh, curl, jq, ripgrep, fd
- python3, nodejs 22, bun, go, gcc
- nix-ld for FHS binary compat
- SSH root login (pubkey only)

## Personas

The `personas/` directory contains system prompts deployed as `CLAUDE.md` files for each agent:

- **WORKER.md** - Executes tasks, writes output to `output/`, documents work in `summary.md`
- **REVIEWER.md** - Reviews worker output, fact-checks claims, provides feedback via `review.md`
- **EDITOR.md** - Edits output for tone, readability, and consistency

Task definitions live in `tasks/` with the naming convention `<TASK>-worker.md`, `<TASK>-reviewer.md`, `<TASK>-editor.md`.
