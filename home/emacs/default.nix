{
  config,
  lib,
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
        vertico
        consult
        consult-eglot
        consult-flycheck
        orderless
        # APPEARANCE
        doom-themes
        doom-modeline
        tree-sitter
        tree-sitter-langs
        treesit-auto
        treesit-grammars.with-all-grammars
        beacon
        olivetti
        rainbow-delimiters
        # TOOLS
        nov
        pdf-tools
        sudo-edit
        undo-tree
        magit
        # ORG MODE
        ob-async
        org-make-toc
        org-noter
        org-appear
        org-super-agenda
        # PROGRAMMING
        corfu
        eglot
        flycheck
        flycheck-eglot
        format-all
        nix-mode
        rust-mode
        direnv
      ]);
in {
  config = lib.mkIf config.ppd.emacs.enable {
    programs.emacs = {
      enable = true;
      package = emacs-pkg;
    };

    xdg.configFile = {
      "emacs/early-init.el".source = ./early-init.el;
      "emacs/init.el".source = ./init.el;
      "emacs/emacs.org".source = ./emacs.org;
    };

    # emacs packages
    home.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      ## magit 
      git
      # consult
      ripgrep
      # tls
      gnutls

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (lib.mkIf (config.services.gpg-agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression
      unzip # nov.el

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      ispell
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      (texlive.combine {
        inherit
          (texlive)
          scheme-medium
          dvisvgm
          dvipng # for preview and export as html
          wrapfig
          amsmath
          ulem
          hyperref
          capt-of
          etoolbox
          ;
      })
      # :lang nix
      nixd
      alejandra
    ];
  };
}
