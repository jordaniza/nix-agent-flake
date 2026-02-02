{
  description = "Agent VM";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # we use this so nixos-anywhere can format the distro on the remote vm
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    disko,
  }: {
    nixosConfigurations.agent = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        # tbd
        # ./disk-config.nix
        # ./configuration.nix
      ];
    };
  };
}
