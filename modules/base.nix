{ pkgs, lib, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };

  boot.initrd.systemd.enable = true;

  hardware.enableRedistributableFirmware = true;

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enable some SysRq keys (80 = sync + process kill)
  # See: https://docs.kernel.org/admin-guide/sysrq.html
  boot.kernel.sysctl."kernel.sysrq" = 80;

  # i18n
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver = {
    # Configure keymappkgs
    xkb.layout = "us";
  };

  # networkmanager is good
  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [ ];
  };

  # base packages that I *always* need.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    htop
    git
  ];

  # base overrides
  nixpkgs.overlays = [
    (final: prev: {
      # use clang, because it uses less ram during compiles
      webkitgtk = prev.webkitgtk.override { stdenv = pkgs.llvmPackages.stdenv; };
      webkitgtk_4_1 = prev.webkitgtk_4_1.override { stdenv = pkgs.llvmPackages.stdenv; };
      webkitgtk_6_0 = prev.webkitgtk_6_0.override { stdenv = pkgs.llvmPackages.stdenv; };
    })
  ];

  # the funny shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  programs.starship = {
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
}
