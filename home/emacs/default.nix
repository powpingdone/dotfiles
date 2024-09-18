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
        emacs-pgtk.emacsWithPackages
        (epkgs:
          with epkgs; [
            treesit-grammars.with-all-grammars
            vterm
          ]);
    };

    user.packages = with pkgs; [
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
      (mkIf (config.programs.gnupg.agent.enable)
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
    system.userActivationScripts = {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           git clone --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$XDG_CONFIG_HOME/emacs"
           ln -s "${./doom}" "$XDG_CONFIG_HOME/doom"
        fi
      '';
    };
  };
}
