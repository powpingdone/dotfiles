{
  description = "PPD's flake for nixos";

  inputs = {
    # generic nixos stuff
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # external flakes
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "";
    };

    # external deps
    x1e-nixos-config = {
      url = "github:kuruczgy/x1e-nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    emacs-overlay,
    nix-index-database,
    dwarffs,
    x1e-nixos-config,
    ...
  } @ inputs: {
    nixosConfigurations = nixpkgs.lib.genAttrs ["PPD-POWERTOP" "PPD-ARMTOP" "PPD-TOWER"] (hostName: (
      let
        ppdOpts = (import ./hosts/${hostName}/options.nix {}).ppd;
        system = ppdOpts.system;
        pkgs_patched =
          (import inputs.nixpkgs {
            inherit system;
          })
          .applyPatches {
            name = "ppd-patches";
            src = inputs.nixpkgs;
            patches = [
            ];
          };
        pkgs = import pkgs_patched {
          inherit system;
          config.allowUnfree = true;
          overlays =
            [
              emacs-overlay.overlays.default
            ]
            ++ (
              if ppdOpts ? overlays
              then ppdOpts.overlays
              else []
            )
            ++ (
              if ppdOpts ? idevice.enable && ppdOpts.idevice.enable
              then [(import options/idevice.nix)]
              else []
            );
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {inherit inputs hostName ppdOpts;};

          modules =
            [
              # host specific
              {networking.hostName = hostName;}
              ./hosts/${hostName}
              ./hosts/${hostName}/options.nix

              # general
              {nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];}
              ./modules
              nixpkgs.nixosModules.notDetected
              nix-index-database.nixosModules.nix-index
              ./options

              # home-manager
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit inputs hostName ppdOpts;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.powpingdone = import ./home/ppd.nix;
              }
            ]
            ++ (
              if (hostName == "PPD-ARMTOP")
              then [
                x1e-nixos-config.nixosModules.x1e
              ]
              else []
            );
        }
    ));
  };
}
