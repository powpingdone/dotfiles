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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    emacs-overlay,
    nix-index-database,
    nixos-wsl,
    ...
  } @ inputs: {
    nixosConfigurations =
      nixpkgs.lib.genAttrs [
        "PPD-POWERTOP"
        "PPD-ARMTOP"
        "PPD-TOWER"
        "PPD-WSL-ARM64"
        "PPD-WSL-INTEL"
      ] (hostName: (
        let
          # import the skeleton config.pdd
          ppdOpts = (import ./hosts/${hostName}/options.nix {}).ppd;
          system = ppdOpts.system;
          # extra nixpkgs patches
          pkgs_patched =
            (import inputs.nixpkgs {
              inherit system;
            })
          .applyPatches {
              name = "ppd-patches";
              src = inputs.nixpkgs;
              patches =
                [
                ]
                ++ (
                  if system != "x86_64-linux"
                  then [./no32bitsteam.patch]
                  else []
                );
            };
          # then setting pkgs
          pkgs = import pkgs_patched {
            inherit system;
            config.allowUnfree = true;
            overlays =
              [
                emacs-overlay.overlays.default
              ]
              # my overlays
              ++ (
                if ppdOpts ? overlays
                then ppdOpts.overlays
                else []
              )
              # idevice overlay
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

            modules = [
              # host specific, import from ./hosts
              {networking.hostName = hostName;}
              ./hosts/${hostName}
              ./hosts/${hostName}/options.nix

              # general
              {
                nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
                system.stateVersion = "25.05";
              }
              ./modules
              nixpkgs.nixosModules.notDetected
              nix-index-database.nixosModules.nix-index
              nixos-wsl.nixosModules.default
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
            ];
          }
      ));
  };
}
