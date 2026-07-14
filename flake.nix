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

    # patches
    nixpkgs-pr = {
      url = "https://github.com/NixOS/nixpkgs/commit/0ab4968115459c3ad208a6014723b9cc3181cbe8.diff?full_index=1";
      flake = false;
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
      inputs.nixpkgs.lib.genAttrs [
        "PPD-POWERTOP"
        "PPD-ARMTOP"
        "PPD-TOWER"
        "PPD-WSL-ARM64"
        "PPD-WSL-INTEL"
      ] (hostName: (
        let
          # import the ppd skeleton config
          ppdOpts = (import ./hosts/${hostName}/options.nix {}).ppd;
          system = ppdOpts.system;

          # initially import nixpkgs to get fetchPatch2 and applyPatches
          pkgs_init = import nixpkgs {
            inherit system;
          };

          # Now, patch nixpkgs
          nixpkgs' = pkgs_init
            .applyPatches {
            name = "ppd-patches";
            src = inputs.nixpkgs;
            patches = with inputs; [
              nixpkgs-pr
            ];
          };

          # then actually fully import it
          pkgs = import nixpkgs' {
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
