{
  pkgs,
  nixpkgs,
  unstable,
  lib,
  fetchpatch,
  fetchurl,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [{device = "/swap/swapfile";}];

  # This is not secure, but it makes diagnosing errors easier.
  boot.initrd.systemd.emergencyAccess = true;

  # this saves battery
  powerManagement.cpuFreqGovernor = "conservative";

  # specific quirks regarding this laptop
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

  # kernel
  boot.initrd.availableKernelModules = lib.mkForce [
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
  ];

  boot.initrd.kernelModules = [
    "i2c_hid"
    "i2c_hid_of"
    "i2c_qcom_geni"
  ];

  boot.blacklistedKernelModules = ["qcom_edac"];

  boot.kernelParams = [
    "pd_ignore_unused"
    "clk_ignore_unused"
  ];

  hardware.firmware = [
    pkgs.x1e80100-lenovo-yoga-slim7x-firmware
    pkgs.x1e80100-lenovo-yoga-slim7x-firmware-json
  ];

  hardware.deviceTree = {
    enable = true;
    name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
  };

  boot.kernelPackages = pkgs.x1e80100-kernel;
}
