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

2. Deploy to a target machine:

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#agent \
  root@<target-ip>
```

## What's included

- claude-code
- git, gh, curl, jq, ripgrep, fd
- python3, nodejs 22, bun, go, gcc
- nix-ld for FHS binary compat
- SSH root login (pubkey only)

## Personas

The `personas/` directory contains system prompts for multi-agent workflows:

- **WORKER.md** - Executes tasks, writes output to `output/`, documents work in `summary.md`
- **REVIEWER.md** - Reviews worker output, provides feedback via `review.md`

Task definitions go in `tasks/`.
