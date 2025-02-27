{
  pkgs,
  lib,
  config,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "powpingdone"];
      max-jobs = config.ppd.jobs;
      cores = config.ppd.cores;
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

  # https://consoledonottrack.com/
  environment.variables."DO_NOT_TRACK" = "1";

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
    killall
    # used encryption stuff (secrets in this repo)
    git-crypt
  ];

  # nix-ld for stuffs that is not nix
  programs.nix-ld.enable = true;

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

  # enable gnupg
  programs.gnupg = {
    dirmngr.enable = true;
    agent = with pkgs; {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      pinentryPackage =
        if config.ppd.emacs.enable
        then pinentry-emacs
        else
          (
            if config.ppd.desktop.enable
            then pinentry-gnome3
            else pinentry-curses
          );
    };
  };

  # disable ssh agent because gnupg is taken over
  programs.ssh.startAgent = false;

  # add some yubikey udev rules
  services.udev.packages = [pkgs.yubikey-personalization];

  # nh is a nice frontend
  programs.nh = {
    enable = true;
    flake = "/etc/nixos"; # typically, flake is here
  };

  # rasdaemon is for hardware monitoring 
  hardware.rasdaemon.enable = true;
}
