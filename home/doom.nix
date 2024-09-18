{
  config,
  lib,
  inputs,
  ...
}:
# "sourced" from https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix
let
  doomdir = ../../.doom.d;
  pkgs = import inputs.nixpkgs {
    overlays = [inputs.emacs-overlay.overlays.default];
  };
in {
  config = lib.mkIf ppd.emacs.enable {
    # emacs packages
    user.packages = with pkgs; [
      ## Emacs itself
      emacs-pgtk.emacsWithPackages
      (epkgs:
        with epkgs; [
          treesit-grammars.with-all-grammars
          vterm
        ])
      binutils # native-comp needs 'as', provided by this

      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity

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
    environment.variables.PATH = ["$XDG_CONFIG_HOME/emacs/bin"];

    # nerd fonts stuff
    fonts.packages = [
      (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    # auto install doom emacs
    system.userActivationScripts = {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           git clone --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$XDG_CONFIG_HOME/emacs"
           ln -s "${doomdir}" "$XDG_CONFIG_HOME/doom"
        fi
      '';
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
  };
}
