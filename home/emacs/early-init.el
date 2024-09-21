(setopt package-enable-at-startup nil)

(setopt use-package-ensure-function 'ignore)

(setopt package-archives nil)

(setq gc-cons-threshold (* 80 1024 1024))

(require 'xdg)
(startup-redirect-eln-cache
 (expand-file-name  "emacs/eln-cache/" (xdg-cache-home)))
