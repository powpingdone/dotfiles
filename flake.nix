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
      #url = "github:kuruczgy/x1e-nixos-config";
      url = "github:powpingdone/x1e-nixos-config/try-audio";
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
        pkgs = import inputs.nixpkgs {
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
              if ppdOpts.idevice.enable
              then [
                (
                  final: prev: {
                    libplist = prev.libplist.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git-44099d4";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libplist";
                        rev = "44099d4b79c8d6a7d599d652ebef62db8dae6696";
                        hash = "sha256-fJKdqFs36MA61nI08OZ1bDL9DSeSlpovI/QcHLMQkkQ=";
                      };
                    });
                    libtatsu = prev.stdenv.mkDerivation {
                      pname = "libtatsu";
                      version = "1.0.4-git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libtatsu";
                        rev = "3f768d0f0470c651e611d679a2fbb54027f8f6ed";
                        hash = "sha256-ZuTk4av23VdS784ADN1jd/ijH4FeXw44xq314O/2Ez4=";
                      };
                      enableParallelBuilding = true;
                      buildInputs = [
                        pkgs.curl
                        pkgs.libplist
                      ];
                      nativeBuildInputs = [
                        pkgs.pkg-config
                        pkgs.autoreconfHook
                      ];
                      patchPhase = ''
                        echo "1.0.4-git" > .tarball-version
                      '';
                    };
                    libimobiledevice-glue = prev.libimobiledevice-glue.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libimobiledevice-glue";
                        rev = "1d9046fbd02482cf44138038779847b9ea67c867";
                        hash = "sha256-w0z9HnSE34qIyza7cBDtYcCtW7eZAPin29LsJE6Sjns=";
                      };
                    });
                    usbmuxd = prev.usbmuxd.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "usbmuxd";
                        rev = "0cdf92d60a140659942521ec27a1d1b7e004bc03";
                        hash = "sha256-0dRjjIEC+1JR+D0ztqRkJWezYyZCIPMS215GVFzxaWM=";
                      };
                    });
                    libusbmuxd = prev.libusbmuxd.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libusbmuxd";
                        rev = "3fdaed78de8000af3b5d19d953eccd80a208ae2c";
                        hash = "sha256-zNI5FswpUv3aX+rhf3jeNrNfe6Lfa8ABPYWhkS+2b8g=";
                      };
                    });
                    libimobiledevice = prev.libimobiledevice.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libimobiledevice";
                        rev = "c8cdf20fe20b0c46ed7d9a9386bed03301ddbfa5";
                        hash = "sha256-gxInkOdbLDvn6fe+AEAjIHXXOsoqtbndPwescn8pKWM=";
                      };
                      propagatedBuildInputs = [final.libtatsu] ++ prevAttrs.propagatedBuildInputs;
                      patches = null;
                    });
                    libirecovery = prev.libirecovery.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "libirecovery";
                        rev = "0f0928a20ae18fe41969673e214ed52450ed78c0";
                        hash = "sha256-jHAS2WS9jvaDt6zCaDA61iJsbUaasSxQ/8x3qdU+wnU=";
                      };
                    });
                    idevicerestore = prev.idevicerestore.overrideAttrs (finalAttrs: prevAttrs: {
                      version = "git";
                      src = prev.fetchFromGitHub {
                        owner = "libimobiledevice";
                        repo = "idevicerestore";
                        rev = "bb5591d690a057fbc6533df2617189005ea95f40";
                        hash = "sha256-u9H1k9VRlbhPIXN0XKOzJ1amCo5TrNa1Tvu6om8ue2E=";
                      };
                      buildInputs = [final.libtatsu] ++ prevAttrs.buildInputs;
                    });
                  }
                )
              ]
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
              ./options.nix
              ./modules
              nixpkgs.nixosModules.notDetected
              nix-index-database.nixosModules.nix-index

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
