
{
  lib,
  gradle,
  ghidra,
  fetchFromGitHub,
}: let
  rev = "ae013ee1475dc970db4fdeba3ec88def6b933d43";
in
  ghidra.buildGhidraExtension
  (finalAttrs: {
    pname = "ghidra-switch-loader";
    version = rev;
    src = fetchFromGitHub {
      owner = "chaoticgd";
      repo = "ghidra-emotionengine-reloaded";
      inherit rev;
    };

    mitmCache = gradle.fetchDeps {
      pkg = finalAttrs.finalPackage;
      data = ./deps.json;
    };

    meta.sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  })
