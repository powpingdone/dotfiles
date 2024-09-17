{
  description = "PPD's flake for nixos";

  inputs = {
    # generic nixos stuff
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # external flakes
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay= {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "";
    };
  };

  outputs = 
    { self, nixpkgs, home-manager, ... } @ inputs: {
      nixosConfigurations =
        let
          def_mods = [
            ./modules
            inputs.nixpkgs.nixosModules.notDetected
	    home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users = {
	        imports = [
                  ./modules
		];
	        powpingdone = ./home/ppd.nix;
	      };
	    }
          ];
        in
        {
          PPD-ARMTOP = nixpkgs.lib.nixosSystem {
            specialArgs = inputs;
            system = "aarch64-linux";
            modules = [ ./hosts/armtop ] ++ def_mods;
          };
          PPD-TOWER = nixpkgs.lib.nixosSystem {
            specialArgs = inputs;
            system = "x86_64-linux";
            modules = [ ./hosts/tower ] ++ def_mods;
          };
        };
    };
}
