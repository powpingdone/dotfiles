{
  pkgs,
  nixpkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [{device = "/swap/swapfile";}];

  # specific quirks regarding this laptop

  # this saves battery
  powerManagement.cpuFreqGovernor = "conservative";

  # part of firmware
  systemd.services.pd-mapper = {
    enable = true;
    description = "Qualcomm PD mapper service";
    serviceConfig = {
      ExecStart = "${pkgs.pd-mapper}/bin/pd-mapper";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };

  hardware.deviceTree = {
    enable = true;
    name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
  };
  
  boot.kernelPatches = [
    {
      name = "drm-qrcode-get-zlib";
      patch = pkgs.fetchpatch {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/drivers?id=2ad84af4cff9121827d3dd35e293478bdb0b58bb";
        hash = "sha256-NH2yz9vzsPgMSuWrrvhJawQxXfFM1KR5c/o2Cnl55XY=";
      };
    }
  ];
}
