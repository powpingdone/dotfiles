(setopt package-enable-at-startup nil)

(setopt use-package-ensure-function 'ignore)

(setopt package-archives nil)

(setq gc-cons-threshold (* 80 1024 1024))

(when (native-comp-available-p)
(require 'xdg)
(setq native-comp-jit-compilation t)
(startup-redirect-eln-cache
 (expand-file-name
  (string-trim
   (concat "emacs/eln-cache" (s-trim (shell-command-to-string "emacs -Q --fingerprint")) "/"))
  (xdg-cache-home)))
)
