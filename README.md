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
