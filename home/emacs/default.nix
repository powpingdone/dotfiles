{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  emacs-pkg =
    (pkgs.emacsPackagesFor (pkgs.emacs30.override {
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
	      # early-init.el require
        s

        # PRIORITY LOAD
        evil
        evil-collection
        evil-tutor

        general

        vertico

        consult
        consult-eglot
        consult-flycheck

        orderless

        # APPEARANCE
        doom-themes

        doom-modeline
	      nerd-icons
        shrink-path
        
        treesit-auto
        treesit-grammars.with-all-grammars
        tree-sitter
        tree-sitter-langs

        beacon

        olivetti

        rainbow-delimiters

        # TOOLS
        nov

        pdf-tools

        sudo-edit

        undo-tree

        magit
	      llama
        with-editor

        vterm
        
        # ORG MODE
        
        ob-async
        
        org-make-toc
        
        org-noter
        
        org-appear
        
        org-super-agenda
        ht
        ts
 
        citeproc
        f
        parsebib
        
        # PROGRAMMING
        corfu

        eglot

        flycheck
        flycheck-eglot

        format-all

        nix-mode

        rust-mode
        cargo-mode

        python-mode

        direnv

        web-mode
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
      (lib.mkIf (nixosConfig.programs.gnupg.agent.enable)
        pinentry-emacs) # in-emacs gnupg prompts
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
          ieeeconf
          biblatex-ieee
          ieeetran
          ;
      })
      # :lang nix
      nixd
      alejandra
    ];
    
    # since we're using vterm, add this to the zsh init
    programs.zsh.initExtra = ''
    vterm_printf() {
        if [ -n "$TMUX" ] \
            && { [ "$${TERM%%-*}" = "tmux" ] \
                || [ "$${TERM%%-*}" = "screen" ]; }; then
            # Tell tmux to pass the escape sequences through
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "$${TERM%%-*}" = "screen" ]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }
    vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
    }
    setopt PROMPT_SUBST
    PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
    '';
  };
}
