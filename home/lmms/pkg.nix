{
  SDL2,
  alsa-lib,
  carla,
  cmake,
  fetchFromGitHub,
  fftwFloat,
  fltk,
  fluidsynth,
  git,
  glibc_multi,
  lame,
  lib,
  libgig,
  libjack2,
  libogg,
  libpulseaudio,
  libsForQt5,
  libsamplerate,
  libsndfile,
  libsoundio,
  libvorbis,
  lilv,
  lv2,
  perl540,
  perl540Packages,
  pkg-config,
  portaudio,
  qt5,
  sndio,
  stdenv,
  suil,
  wineWowPackages,
  withOptionals ? false,
}: let
  winePackage =
    if lib.isDerivation wineWowPackages
    then wineWowPackages
    else wineWowPackages.minimal;
in
  stdenv.mkDerivation {
    pname = "lmms";
    version = "0-unstable";

    src = fetchFromGitHub {
      owner = "LMMS";
      repo = "lmms";
      rev = "f0cb32ff088c604cb77a2cc4b35a53db761bcd65";
      hash = "sha256-PdPDGWFpPg/tn5EXy93lps0sQmJSlX4Bgi3xDe8YBF8=";
      fetchSubmodules = true;
    };

    enableParallelBuilding = true;
    
    nativeBuildInputs = [
      cmake
      libsForQt5.qt5.qttools
      pkg-config
      qt5.wrapQtAppsHook
      git
    ];

    buildInputs =
      [
        fftwFloat
        libsForQt5.qt5.qtbase
        libsForQt5.qt5.qtx11extras
        libsamplerate
        libsndfile
      ]
      ++ lib.optionals withOptionals [
        SDL2
        alsa-lib
        carla
        fltk
        fluidsynth
        glibc_multi
        lame
        libgig
        libjack2
        libogg
        libpulseaudio
        libsoundio
        libvorbis
        lilv
        lv2
        perl540
        perl540Packages.ListMoreUtils
        perl540Packages.XMLParser
        portaudio
        sndio
        suil
        winePackage
      ];

    cmakeFlags = lib.optionals withOptionals [
      "-DWANT_WEAKJACK=OFF"
      "-DWINE_INCLUDE_DIR=${winePackage}/include"
      "-DWINE_BUILD=${winePackage}/bin/winebuild"
      "-DWINE_CXX=${winePackage}/bin/wineg++"
      "-DWINE_GCC=${winePackage}/bin/winegcc"
      "-DWINE_32_LIBRARY_DIRS=${winePackage}/lib/wine/i386-unix"
      "-DWINE_64_LIBRARY_DIRS=${winePackage}/lib/wine/x86_64-windows"
    ];

    meta = with lib; {
      description = "DAW similar to FL Studio (music production software)";
      mainProgram = "lmms";
      homepage = "https://lmms.io";
      license = licenses.gpl2Plus;
      platforms = [
        "x86_64-linux"
      ];
      maintainers = with maintainers; [wizardlink];
    };
  }
