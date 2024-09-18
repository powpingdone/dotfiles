{
  doom-git,
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  name = "ppd-doom";
  src = doom-git;
  nativeBuildInputs = [ programs.emacs.package pkgs.ppd-doomdir ];
  buildPhase = ''
    bin/doom install --doomdir ${pkgs.ppd-doomdir}
  '';
  installPhase = ''

  '';
}
