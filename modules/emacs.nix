{config, ...}: {
  config = lib.mkIf config.ppd.emacs.enable {
    # emacs likes taking up open files
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "2048";
      }
    ];
  };
}
