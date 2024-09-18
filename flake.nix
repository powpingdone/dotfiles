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
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    emacs-overlay,
    ...
  } @ inputs: {
    nixosConfigurations = nixpkgs.lib.genAttrs ["PPD-ARMTOP" "PPD-TOWER"] (hostName: (
      let
        ppdOpts = (import ./hosts/${hostName}/options.nix {}).ppd;
        system = ppdOpts.system;
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            ppdOpts.overlays
            emacs-overlay.overlays.default
          ];
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {inherit inputs hostName;};

          modules = [
            # host specific
            {networking.hostName = hostName;}
            ./hosts/${hostName}
            ./hosts/${hostName}/options.nix

            # general
            ./options.nix
            ./modules
            inputs.nixpkgs.nixosModules.notDetected

            # home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs hostName;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.powpingdone = import ./home/ppd.nix;
            }
          ];
        }
    ));
  };
}
