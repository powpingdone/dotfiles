{ nixpkgs, unstable, lib, ... }:
{
  networking.hostName = "PPD-ARMTOP";

  modules.ppdesktop.enable = true;

  imports = [
    ./hardware-configuration.nix
  ];

  # specific quirks regarding this laptop
  nixpkgs.overlays = [
    (final: prev: {
      # custom firmware needed
      x1e80100-lenovo-yoga-slim7x-firmware = final.callPackage ./x1e80100-lenovo-yoga-slim7x-firmware.nix { };
      x1e80100-lenovo-yoga-slim7x-firmware-json = final.callPackage ./x1e80100-lenovo-yoga-slim7x-firmware-json.nix { };

      # along with loader for the firmware
      libqrtr = final.callPackage ./libqrtr.nix { };
      pd-mapper = final.callPackage ./pd-mapper.nix { };

      # mesa >= 24.2 needed
      mesa = unstable.mesa;
    })
  ];

  # This is not secure, but it makes diagnosing errors easier.
  boot.initrd.systemd.emergencyAccess = true;

  # this saves battery
  powerManagement.cpuFreqGovernor = "conservative";

  # part of firmware
  systemd.services.pd-mapper = {
    enable = true;
    description = "Qualcomm PD mapper service";
    serviceConfig = {
      ExecStart = "${nixpkgs.pd-mapper}/bin/pd-mapper";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # kernel
  boot.initrd.availableKernelModules = lib.mkForce ([
    # Needed by the NixOS iso for booting in general
    "squashfs"
    "iso9660"
    "uas"
    "overlay"

    # Definitely needed for USB:
    "usb_storage"
    "phy_qcom_qmp_combo"
    "phy_qcom_snps_eusb2"
    "phy_qcom_eusb2_repeater"
    "tcsrcc_x1e80100"

    # From jhovold defconfig commit msg:
    "leds_qcom_lpg"
    "pwm_bl"
    "qrtr"
    "pmic_glink_altmode"
    "gpio_sbu_mux"
    "gpucc_sc8280xp"
    "dispcc_sc8280xp"
    "phy_qcom_edp"
    "panel_edp"
    "msm"

    # Copied from:
    # https://github.com/colemickens/nixos-snapdragon-elite/blob/c4817fe8609690350a01513ebc851a393baaae50/snapdragon.nix#L50
    # "Required to boot"
    "nvme"
    "phy_qcom_qmp_pcie"
    "pcie_qcom"
    "phy_qcom_qmp_ufs"
    "ufs_qcom"

    # keyboard
    "i2c_hid_of"
    "i2c_qcom_geni"

    # display
    "leds_qcom_lpg"
    "pwm_bl"
    "qrtr"
    "pmic_glink_altmode"
    "gpio_sbu_mux"
    "phy_qcom_qmp_combo"
    "gpucc_sc8280xp"
    "dispcc_sc8280xp"
    "dispcc-x1e80100"
    "gpucc-x1e80100"
    "tcsrcc-x1e80100"
    "phy_qcom_edp"
    "panel_edp"
    "msm"
    "phy-qcom-qmp-usb"
    "phy-qcom-qmp-usbc"
    "phy-qcom-usb-hs"
    "phy-qcom-usb-hsic"
    "phy-qcom-usb-ss"
    "qcom_pmic_tcpm"
    "qcom_usb_vbus-regulator"

    # random other things?
    "uas"
    "r8152"
    "lzo_rle"
    "dwc3-qcom"
    "evdev"
  ]);

  boot.initrd.kernelModules = [
    "i2c_hid"
    "i2c_hid_of"
    "i2c_qcom_geni"
  ];

  boot.blacklistedKernelModules = [ "qcom_edac" ];

  boot.kernelParams = [
    "pd_ignore_unused"
    "clk_ignore_unused"
  ];

  hardware.firmware = [
    nixpkgs.x1e80100-lenovo-yoga-slim7x-firmware
    nixpkgs.x1e80100-lenovo-yoga-slim7x-firmware-json
  ];

  hardware.deviceTree.name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";

  boot.kernelPackages = nixpkgs.linuxPackagesFor (nixpkgs.buildLinux {
    src = nixpkgs.fetchFromGitHub {
      owner = "jhovold";
      repo = "linux";
      rev = "b9c3748baa16efa16536bbb20b2ff2d2d02b28b5";
      hash = "sha256-p5DcTD5Vt1ME3jb9d+QPBjoOpbpV371sucK7bb+V3JA=";
    };
    version = "6.11.0-rc7";
    defconfig = "johan_defconfig";

    structuredExtraConfig = with lib.kernel; {
      MAGIC_SYSRQ = yes;
    };

    kernelPatches = [
      {
        name = "driver core: Set deferred probe timeout to 0 if modules are disabled";
        patch = nixpkgs.fetchpatch {
          url = "https://github.com/linux-surface/kernel/commit/fd9dc26bac9b2ca2331f6ca35c9180efcec82aed.patch";
          hash = "sha256-xMM5ibO9BcdhZ7HJbu22KVXs1Prg9+jqtx7jCYA7f7E=";
        };
      }
      {
        name = "driver core: Add fw_devlink.timeout param to stop waiting for devlinks ";
        patch = nixpkgs.fetchpatch {
          url = "https://github.com/linux-surface/kernel/commit/431363f94cc23fc3a923cc73758b619a657b75f9.patch";
          hash = "sha256-9TXoOzmt0OpWHVGa0iaNXrBFvWWTuWFjLwU74cvOED0=";
        };
      }
      {
        name = "driver core: Disable driver deferred probe timeout by default";
        patch = nixpkgs.fetchpatch {
          url = "https://github.com/linux-surface/kernel/commit/caa65dd351ed735b33371f26fbbd02d37a1d2098.patch";
          hash = "sha256-yGZ1hn/1nj0M4wn4mNwYzPkaV46JDaU2uZvAQvQ5lQY=";
        };
      }
    ];
  });
}
