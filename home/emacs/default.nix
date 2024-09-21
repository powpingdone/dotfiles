{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.ppd.emacs.enable {
    services.emacs.enable = true;

    # emacs packages
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
	extraEmacsPackages = epkgs: (with epkgs; [
          treesit-grammars.with-all-grammars
	]);
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
