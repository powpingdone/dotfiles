;; TODO: add unload-feature

(defun ppd/reload-emacs ()
  (interactive)
  (condition-case nil 
    (delete-file (expand-file-name "emacs.el" user-emacs-directory))
    (error nil))
  (org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
  (delete-file (expand-file-name "emacs.el" user-emacs-directory))
  ; when reloading, this config part will reload org properly
  (dolist (buf (buffer-list))
   (with-current-buffer buf
     (when (derived-mode-p 'org-mode) (org-reload))))
  )

(ppd/reload-emacs)
