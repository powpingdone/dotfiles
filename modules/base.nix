{
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "powpingdone"];
    };
    channel.enable = false;
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 2;
  };

  boot.tmp.cleanOnBoot = true;

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
    plugins = lib.mkForce [];
  };

  # base packages that I *always* need.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    htop
    git
  ];

  # base overrides
  ppd.overlays = [
    (final: prev: {
      # use clang, because it uses less ram during compiles
      webkitgtk = prev.webkitgtk.override {stdenv = pkgs.llvmPackages.stdenv;};
      webkitgtk_4_1 = prev.webkitgtk_4_1.override {stdenv = pkgs.llvmPackages.stdenv;};
      webkitgtk_6_0 = prev.webkitgtk_6_0.override {stdenv = pkgs.llvmPackages.stdenv;};
    })
  ];

  # the funny shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      strategy = ["match_prev_cmd" "history"];
    };
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
    shellInit = ''
      . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    '';
  };
  programs.starship = {
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [pkgs.zsh];

  # user stuff outside of home-manager
  users.users."powpingdone" = {
    isNormalUser = true;
    home = "/home/powpingdone";
    extraGroups = ["wheel" "networkmanager"];
  };

  # being able to use security keys is a big thing
  services.pcscd.enable = true;

  # nh is a nice frontend
  programs.nh = {
    enable = true;
    flake = "/etc/nixos"; # typically, flake is here
  };
}
