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
  perl5,
  perl5Packages,
  pkg-config,
  portaudio,
  qt5,
  sndio,
  stdenv,
  suil,
  wineWowPackages,
  withOptionals ? false,
  withWine ? false,
}: let
  winePackage =
    if lib.isDerivation wineWowPackages
    then wineWowPackages
    else wineWowPackages.minimal;
  rev = "441fd905bee745a56de6f838812584306daa6add";
in
  stdenv.mkDerivation {
    pname = "lmms";
    version = "0-git-${rev}";

    src = fetchFromGitHub {
      owner = "LMMS";
      repo = "lmms";
      inherit rev;
      hash = "sha256-ts68Ds4h4BWrhtwIvmqotgcHhrry6aBln+ks0b3lXi8=";
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
        lame
        libgig
        libjack2
        libogg
        libpulseaudio
        libsoundio
        libvorbis
        lilv
        lv2
        perl5
        perl5Packages.ListMoreUtils
        perl5Packages.XMLParser
        portaudio
        sndio
        suil
      ]
      ++ lib.optionals withWine [
        glibc_multi
        winePackage
      ];

    cmakeFlags =
      lib.optionals withOptionals [
        "-DWANT_WEAKJACK=OFF"
      ]
      ++ lib.optionals withWine [
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
      platforms =
        [
          "x86_64-linux"
        ]
        ++ optionals (!withWine) [
          "aarch64-linux"
        ];
      maintainers = with maintainers; [wizardlink];
    };
  }
