:;exec emacs -batch -Q -l "$0" -f main "$@"
(require 'cl)
(toggle-debug-on-error)
(defun main ()
  (interactive)
  (destructuring-bind (package &optional elpa-parent) command-line-args-left
    (message "elpa-parent is: %S" elpa-parent)
    ;; Make the elpa dir for this if we need to.
    (when (and elpa-parent
               (not (file-exists-p elpa-parent)))
      (make-directory elpa-parent t))
    ;; Package stuff
    (setq package-user-dir
          (concat
           (file-name-as-directory
            (if elpa-parent
                (concat elpa-parent "/")
                (make-temp-file "emacs-test-package" t)))
           ".elpa"))
    (setq package-archives
          '(("gnu" . "http://elpa.gnu.org/packages/")
            ("marmalade" . "http://marmalade-repo.org/packages/")))
    (package-initialize)
    (package-refresh-contents)
    (if (and (expand-file-name package)
             (not (file-directory-p (expand-file-name package))))
        (package-install-file (expand-file-name package))
        ;; Else must just be a package
        (package-install (intern package)))))

;; End
