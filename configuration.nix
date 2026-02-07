{pkgs, ...}: let
  keys = import ./keys.nix;
in {
  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];

  # Networking
  networking.hostName = "agent";
  networking.networkmanager.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = keys.authorizedKeys;
    };
    # claude not a fan of sudo
    agent = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = keys.authorizedKeys;
    };
  };

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
    vim

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
    supabase-cli
  ];
  environment.variables.EDITOR = "vim";

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}
