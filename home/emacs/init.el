;; TODO: add unload-feature

(defun ppd/reload-emacs ()
  (interactive)
  (delete-file (expand-file-name "emacs.el" user-emacs-directory))
  (org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
  (delete-file (expand-file-name "emacs.el" user-emacs-directory))
  )

(ppd/reload-emacs)
