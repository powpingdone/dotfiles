# overlay for mobile devices
final: prev: {
  libplist = prev.libplist.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.7.0-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libplist";
      rev = "d031e94d7aee14c4e7646e67623c94e6164b99e3";
      hash = "sha256-A5YBY2cqym0E7m7jBhWCOO3gbVtkpuIjelk/8WDV1U4=";
    };
  });
  libtatsu = prev.stdenv.mkDerivation rec {
    pname = "libtatsu";
    version = "1.0.5-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libtatsu";
      rev = "7e1647b9883ff1daa6363de20af2c4129ed45dcd";
      hash = "sha256-+KaoqBJWJ3LHn736eZiw9b9SIZK2lfajfd57nO2m4Ao=";
    };
    enableParallelBuilding = true;
    buildInputs = [
      final.curl
      final.libplist
    ];
    nativeBuildInputs = [
      final.pkg-config
      final.autoreconfHook
    ];
    patchPhase = ''
      echo "${version}" > .tarball-version
    '';
  };
  libimobiledevice-glue = prev.libimobiledevice-glue.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.3.2-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libimobiledevice-glue";
      rev = "c915351cb322d041afabc04f780eb35142cdaea5";
      hash = "sha256-lgTwURnBO3Os2Rg72s9BVCm5XWouZfCyuUfZ900SxkE=";
    };
  });
  usbmuxd = prev.usbmuxd.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.1.2-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "usbmuxd";
      rev = "523f7004dce885fe38b4f80e34a8f76dc8ea98b5";
      hash = "sha256-U8SK1n1fLjYqlzAH2eU4MLBIM+QMAt35sEbY9EVGrfQ=";
    };
  });
  libusbmuxd = prev.libusbmuxd.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.1.1-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libusbmuxd";
      rev = "19d6bec393c9f9b31ccb090059f59268da32e281";
      hash = "sha256-W2R/wDQ+Gh3yXNWOwoQ7HjZ66letDIOJM3pW23jsfpc=";
    };
  });
  libimobiledevice = prev.libimobiledevice.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.3.1-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libimobiledevice";
      rev = "a6b6c35d1550acbd2552d49c2fe38115deec8fc0";
      hash = "sha256-dZpRuUP71LnBFIYRlxNYnEgeeVXdpwuCje/EJ2JHxHE=";
    };
    propagatedBuildInputs = [final.libtatsu] ++ prevAttrs.propagatedBuildInputs;
    patches = null;
  });
  libirecovery = prev.libirecovery.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.2.2-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libirecovery";
      rev = "638056a593b3254d05f2960fab836bace10ff105";
      hash = "sha256-loIbNSbwiVE8/jDVIbCVReV7ZkEOxIC7g8zPaSbOA3E=";
    };
  });
  idevicerestore = prev.idevicerestore.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.0.0-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "idevicerestore";
      rev = "a5905b7f905fc3cc83033ebd963f0dcba071e512";
      hash = "sha256-syzGhQhLoQ0d4EMsmQ9HertPvWYRJ5gpb6unM547w3g=";
    };
    buildInputs = [final.libtatsu] ++ prevAttrs.buildInputs;
  });
}
