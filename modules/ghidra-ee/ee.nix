{
  lib,
  gradle,
  ghidra,
  ant,
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
      hash = "sha256-f2mEsZDsDEQpXtraslLwvFQuE2D7F3vnilJOtXpkp/s=";
    };

    nativeBuildInputs = [ ant ];

    configurePhase = ''
      runHook preConfigure

      # this doesn't really compile, it compresses sinc into sla
      pushd data
      ant -f build.xml -Dghidra.install.dir=${ghidra}/lib/ghidra sleighCompile
      popd

      runHook postConfigure
    '';

    mitmCache = gradle.fetchDeps {
      pkg = finalAttrs.finalPackage;
      data = ./deps.json;
    };

    meta.sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  })
