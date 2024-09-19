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
    ppd.overlays = [
      (
        final: prev: {
          final.emacs =
            (prev.emacsPackagesFor (
              prev.emacs29.override {
                withGTK3 = true;
                withWebP = true;
                withSQLite3 = true;
                withPgtk = true;
                withTreeSitter = true;
                withSmallJaDic = true;
                withImageMagick = true;
              }
            ))
            .emacsWithPackages (epkgs:
              with epkgs; [
                treesit-grammars.with-all-grammars
                vterm
              ]);
        }
      )
    ];

    # emacs packages
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };
    services.emacs.enable = true;

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
    home.sessionPath = ["$HOME/.config/emacs/bin"];

    # auto install doom emacs
    home.activation = {
      installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "$HOME/.config/emacs" ]; then
           run nix-shell -p git --run 'git clone $VERBOSE_ARG --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$HOME/.config/emacs"'
        fi
        run rm -f $VERBOSE_ARG "$HOME/.config/doom"
        run ln -s $VERBOSE_ARG "${../../.doom.d}" "$HOME/.config/doom"
	# setup path for doom to install
        export PATH="$PATH:${pkgs.emacs}/bin:${pkgs.git}/bin:${pkgs.ripgrep}/bin"
        if [ ! -d "$HOME/.config/emacs" ]; then
          run $HOME/.config/emacs/bin/doom install $VERBOSE_ARG --aot
        fi
        run $HOME/.config/emacs/bin/doom sync -u $VERBOSE_ARG --aot
        run $HOME/.config/emacs/bin/doom env $VERBOSE_ARG
        run emacsclient --eval "(eval-buffer (pdf-tools-install 't))"
      '';
    };
  };
}
