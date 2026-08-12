{
  lib,
  gradle,
  ghidra,
  fetchFromGitHub,
}: let
  rev = "183b0a0b8dca2dff23ab1c650fd77277297360ff";
in
ghidra.buildGhidraExtension
  (finalAttrs: {
    pname = "ghidra-switch-loader";
    version = rev;
    src = fetchFromGitHub {
      owner = "Adubbz";
      repo = "ghidra-switch-loader";
      inherit rev;
      hash = "sha256-gHKFKS+RQD0CYuO7LrZt8Sse8C9coHemHFdp2uemCF4=";
    };

    # workaround the ext wanting the rev
    GSL_COMMIT = rev;
    patches = [./gsl-commit.patch];

    mitmCache = gradle.fetchDeps {
      pkg = finalAttrs.finalPackage;
      data = ./deps.json;
    };

    meta.sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  })
