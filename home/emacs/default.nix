{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
# "sourced" from https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix
{
  config = lib.mkIf config.ppd.emacs.enable {
    # emacs packages
    programs.emacs = {
      enable = true;
      package =
    };
    services.emacs.enable = true;

    home.packages = with pkgs; [
      ## Emacs itself
      (emacsWithPackagesFromUsePackage {
        package = emacs29.override {
          withGTK3 = true;
          withWebP = true;
          withSQLite3 = true;
          withPgtk = true;
          withTreeSitter = true;
          withSmallJaDic = true;
          withImageMagick = true;
        };
	config = ./emacs.org;
	defaultInitFile = true;
	alwaysTangle = true;
      })
      binutils # native-comp needs 'as', provided by this

      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (lib.mkIf (config.services.gpg-agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      ispell
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang nix
      age
    ];
  };
}
