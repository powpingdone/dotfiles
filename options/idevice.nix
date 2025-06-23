# overlay for mobile devices
final: prev: {
  libplist = prev.libplist.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.7.0-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libplist";
      rev = "cf5897a71ea412ea2aeb1e2f6b5ea74d4fabfd8c";
      hash = "sha256-Rc1KwJR+Pb2lN8019q5ywERrR7WA2LuLRiEvNsZSxXc=";
    };
  });
  libtatsu = prev.stdenv.mkDerivation rec {
    pname = "libtatsu";
    version = "1.0.5-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libtatsu";
      rev = "42329cb756682535c7c0f087987b78d1dd5b16c8";
      hash = "sha256-vf4xBTTGDJCTj4TMLOhojjAfzSbkx+ogGBnf+UeumG0=";
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
      rev = "aef2bf0f5bfe961ad83d224166462d87b1df2b00";
      hash = "sha256-cUcJARbZV9Yaqd9TP3NVmF9p8Pjz88a3GmAh4c4sEHo=";
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
      rev = "adf9c22b9010490e4b55eaeb14731991db1c172c";
      hash = "sha256-o1EFY/cv+pQrGexvPOwMs5mz9KRcffnloXCQXMzbmDY=";
    };
  });
  libimobiledevice = prev.libimobiledevice.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.3.1-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libimobiledevice";
      rev = "34b170f03ab97b7c9ab6cf009cd8da280c6db97c";
      hash = "sha256-0Ovwh8izxE+EtybmSxklvlEWiq4mhp+hJo6sdv2jCpE=";
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
      rev = "8061f08b4e0a8f0ab5d1548b7e9978f3cc8647a2";
      hash = "sha256-u/W0rvtPj5bJNt2jaYe6B69pxAUM7lBCejd/0O3AMi4=";
    };
    buildInputs = [final.libtatsu] ++ prevAttrs.buildInputs;
  });
}
