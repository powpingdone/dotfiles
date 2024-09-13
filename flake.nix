{
  description = "PPD's flake for nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    let
      desktop = import ./desktop;
      base = import ./base;
      hwcfg = ./hardware-configuration.nix;
    in nixosConfigurations = {
      ppd-armpc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          desktop
          hwcfg
          import ./hosts/armpc;
          # inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
