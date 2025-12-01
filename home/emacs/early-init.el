(setopt package-enable-at-startup nil)

;; ignore use-package :ensure
(setopt use-package-ensure-function 'ignore)

;; disable use-package package archives
(setopt package-archives nil)

;; gc optimization
(setq gc-cons-threshold (* 80 1024 1024))

;; on using native-comp
(when (native-comp-available-p)
  (require 'xdg)
  (require 's)
  (setq native-comp-jit-compilation t)
  
  ;; set emacs cache to be based on the fingerprint of emacs itself
  (startup-redirect-eln-cache
   (expand-file-name
    (string-trim
     (concat "emacs/eln-cache" (s-trim (shell-command-to-string "emacs -Q --fingerprint")) "/"))
    (xdg-cache-home)))
)
