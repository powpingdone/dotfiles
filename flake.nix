{
  description = "PPD's flake for nixos";

  inputs = {
    # generic nixos stuff
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # external flakes
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, unstable, flake-utils, emacs-overlay } @ inputs: {
    nixosConfigurations = {
      PPD-ARMTOP = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs nixpkgs emacs-overlay;
        };
        system = "aarch64-linux";
        modules = [
          ./modules
          ./hosts/armtop
	  inputs.nixpkgs.nixosModules.notDetected
          inputs.home-manager.nixosModules.home-manager 
        ];
      };
      PPD-TOWER = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs nixpkgs emacs-overlay;
        };
        system = "x86_64-linux";
        modules = [
          ./modules
          ./hosts/tower
	  inputs.nixpkgs.nixosModules.notDetected
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
