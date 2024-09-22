{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let emacs-pkg = 
      (pkgs.emacsPackagesFor (pkgs.emacs29.override {
          withGTK3 = true;
          withWebP = true;
          withSQLite3 = true;
          withPgtk = true;
          withTreeSitter = true;
          withSmallJaDic = true;
          withImageMagick = true;
        }))
	.emacsWithPackages(epkgs: (with epkgs; [
	  evil
	  which-key
          treesit-grammars.with-all-grammars
	]));
      
in {
  config = lib.mkIf config.ppd.emacs.enable {
    xdg.configFile = {
      "emacs/early-init.el".source = ./early-init.el;
      "emacs/init.el".source = ./init.el;
      "emacs/emacs.org".source = ./emacs.org;
    };

    services.emacs = {
      enable = true;
      package = emacs-pkg;
    };

    # emacs packages
    home.packages = with pkgs; [
      ## Emacs itself
      emacs-pkg
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
