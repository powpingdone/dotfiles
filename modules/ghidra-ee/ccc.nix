{
  lib,
  cmake,
  stdenv,
  fetchFromGitHub,
}: let
  rev = "c025ca94735d75cd366b29a10f924010ce43353d";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "chaoscc";
    version = rev;

    src = fetchFromGitHub {
      owner = "chaoticgd";
      repo = "ccc";
      inherit rev;
      hash = "sha256-66lhBwLYHNGJlHs1rwZoH/EaR2U/YCLQBlmSQLInFVg=";
    };

    nativeBuildInputs = [cmake];

    # cmake can't install these files because install isn't defined
    # so, install them manually
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mv {objdump,stdump,uncc,demangle} $out/bin
      mv ../ghidra_scripts/CCCDecompileAllFunctions.java $out/

      runHook postInstall
    '';
  })
