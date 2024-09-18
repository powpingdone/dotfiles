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
        (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages
        (epkgs:
          with epkgs; [
            treesit-grammars.with-all-grammars
            vterm
          ]);
    };

    home.packages = with pkgs; [
      ## Emacs itself
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
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang nix
      age
    ];

    # add doom
    home.sessionPath = ["$XDG_CONFIG_HOME/emacs/bin"];

    # auto install doom emacs
    home.activation = {
      installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           run git clone $VERBOSE_ARG --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$XDG_CONFIG_HOME/emacs"
           run ln -s $VERBOSE_ARG "${./doom}" "$XDG_CONFIG_HOME/doom"
        fi
      '';
    };
  };
}
