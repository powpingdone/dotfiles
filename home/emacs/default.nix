{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  emacs-pkg =
    (pkgs.emacsPackagesFor (pkgs.emacs29.override {
      withGTK3 = true;
      withWebP = true;
      withSQLite3 = true;
      withPgtk = true;
      withTreeSitter = true;
      withSmallJaDic = true;
      withImageMagick = true;
    }))
    .emacsWithPackages (epkgs:
      with epkgs; [
        # PRIORITY LOAD
        evil
        evil-collection
        evil-tutor
        which-key
        general
        # APPEARANCE
        doom-themes
        doom-modeline
        treesit-auto
        treesit-grammars.with-all-grammars
        beacon
        # TOOLS
        pdf-tools
        sudo-edit
        undo-tree
        magit
        # ORG MODE
        ob-async
        org-modern
        (trivialBuild {
          packageRequires = [compat org org-modern];
          pname = "org-modern-indent";
          src = inputs.org-modern-indent;
          version = "0.1.4";
        })
        org-make-toc
        org-roam
        org-noter
        org-appear
        org-super-agenda
      ]);
in {
  config = lib.mkIf config.ppd.emacs.enable {
    services.emacs = {
      enable = true;
      package = emacs-pkg;
      socketActivation.enable = true;
    };

    xdg.configFile = {
      "emacs/early-init.el".source = ./early-init.el;
      "emacs/init.el".source = ./init.el;
      "emacs/emacs.org".source = ./emacs.org;
    };

    # restart emacs service if these files change
    systemd.user.services.emacs = {
      Service = {
        ExecReload = "${emacs-pkg}/bin/emacsclient -e '(ppd/reload-emacs)'";
      };
      Unit = {
        X-Restart-Triggers = with builtins; [
          (hashFile "sha256" ./early-init.el)
          (hashFile "sha256" ./init.el)
          (hashFile "sha256" ./emacs.org)
        ];
        X-SwitchMethod = "reload";
      };
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
