{ ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };

  boot.initrd.systemd.enable = true;
  hardware.graphics.enable = true;

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
    # Configure keymap
    xkb.layout = "us";
  };

  # emacs likes taking up open files
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "2048";
    }
  ];

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

  # the funny shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.users.powpingdone = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ];
     shell = pkgs.zsh;
  };
}
