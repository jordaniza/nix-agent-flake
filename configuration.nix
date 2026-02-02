{pkgs, ...}: let
  keys = import ./keys.nix;
in {
  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  # Networking
  networking.hostName = "agent";
  networking.networkmanager.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  users.users.root.openssh.authorizedKeys.keys = keys.authorizedKeys;

  # FHS compat for random binaries
  programs.nix-ld.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # Core
    git
    gh
    curl
    wget
    jq
    ripgrep
    fd
    tree
    btop

    # Languages
    python3
    nodejs_22
    bun
    yarn
    go
    gcc
    gnumake
    pkg-config
    openssl

    # The point of all this
    claude-code
  ];

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}
