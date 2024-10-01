;; TODO: add unload-feature

(defun ppd/reload-emacs ()
  (interactive)
  (condition-case nil 
    (delete-file (expand-file-name "emacs.el" user-emacs-directory))
    (error nil))
  (org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
  (delete-file (expand-file-name "emacs.el" user-emacs-directory))
  )

(ppd/reload-emacs)
