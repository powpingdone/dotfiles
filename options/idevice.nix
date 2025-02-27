# overlay for mobile devices
final: prev: {
  libplist = prev.libplist.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.7.0-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libplist";
      rev = "44099d4b79c8d6a7d599d652ebef62db8dae6696";
      hash = "sha256-fJKdqFs36MA61nI08OZ1bDL9DSeSlpovI/QcHLMQkkQ=";
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
      rev = "fe28a576b65f6fdcccb0f85721d79b9d3965faa9";
      hash = "sha256-+dm31Lgt88LEwrdctt2P9voYLyRt/fWkY4+zqsJRjNY=";
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
      rev = "f61a3bb6329009c71a32be3fe372edd9094ccbdc";
      hash = "sha256-jXtlvYXYbtFQzkSCkD6/8P7tP5LZd2GHVWIDO7SPLcM=";
    };
    propagatedBuildInputs = [final.libtatsu] ++ prevAttrs.propagatedBuildInputs;
    patches = null;
  });
  libirecovery = prev.libirecovery.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.2.2-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "libirecovery";
      rev = "6462ea1506fb133ebbf79c3e1660d84a94ae703f";
      hash = "sha256-jcO0VvDAdAD2hHx/yoblVH0FGClwsrwkMRcQta6o16M=";
    };
  });
  idevicerestore = prev.idevicerestore.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.0.0-git";
    src = prev.fetchFromGitHub {
      owner = "libimobiledevice";
      repo = "idevicerestore";
      rev = "bb5591d690a057fbc6533df2617189005ea95f40";
      hash = "sha256-u9H1k9VRlbhPIXN0XKOzJ1amCo5TrNa1Tvu6om8ue2E=";
    };
    buildInputs = [final.libtatsu] ++ prevAttrs.buildInputs;
  });
}
