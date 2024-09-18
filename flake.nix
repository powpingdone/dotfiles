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
    { self, nixpkgs, home-manager, flake-utils, ... } @ inputs: {
      nixosConfigurations = 
	nixpkgs.lib.genAttrs [ "PPD-ARMTOP" "PPD-TOWER" ] (hostName: 
	  (nixpkgs.lib.nixosSystem {
	    specialArgs = { inherit inputs; };
	    
	    modules = [
	      # host specific
	      { networking.hostName = hostName; }
	      ./hosts/${hostName}
	      ./hosts/${hostName}/options.nix
	      
	      # general 
	      ./options.nix
	      ./modules
              inputs.nixpkgs.nixosModules.notDetected
	      
	      # home-manager
	      home-manager.nixosModules.home-manager {
                home-manager.extraSpecialArgs = { 
		  inherit inputs; 
		};
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.powpingdone = import ./home/ppd.nix;
	      }
	    ];
	  }));

	  formatter = flake-utils.lib.eachSystem flake-utils.allSystems (system: {
	    ${system} = nixpkgs.legacyPackages.${system}.alejandra;
	  });
        };
}
