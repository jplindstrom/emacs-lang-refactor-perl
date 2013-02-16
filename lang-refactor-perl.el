;;; lang-refactor-perl.el --- Simple refactorings, primarily for Perl

;; Copyright © 2013 Johan Linsdtrom
;;
;; Author: Johan Lindstrom <buzzwordninja not_this_bit@googlemail.com>
;; URL: https://github.com/jplindstrom/emacs-lang-refactor-perl
;; Version: 0.1.1

;;
;; It's probably useful to bind it to a key. Make sure it ends with "e
;; v" (for Extract Variable) to make sure your reflexes are compatible
;; with future refactorings.
;;


;;; Code:


;; TODO: defcustom
(defvar lr-extract-variable-face
  '(:background "bisque"))

;; (defvar lr/extract-variable-restore-face
;;   '(:background 'inherit))

;; to reset
;; (setq lr-extract-variable-face
;;   '(:background "bisque"))
;; (setq lr/extract-variable-restore-face
;;   '(:background "red"))


(defun lr/open-line-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))

(defun lr/get-variable-name (expression)
    (if (string-match "\\([[:alnum:]_]+?\\)\\([^[:alnum:]_]+?\\)?$" expression)
        (format  "$%s" (match-string-no-properties 1 expression))
      (error "Could not find a variable name in (%s)" expression)
      )
  )

(defun lr/replace-all-buffer (search-for replace-with)
  (goto-char (point-min))
  ;; TODO: match word boundary to avoid substring matches
  (while (search-forward search-for nil t)
    (replace-match replace-with nil nil))
  )

(defun lr/goto-earliest-usage (variable-name)
  (goto-char (point-min))
  ;; TODO: match word boundary to avoid substring matches
  (search-forward variable-name nil t)

  ;; if possible, find previous statement terminator ; or closing block }
  (when (search-backward-regexp "[;}]" nil t)
      (forward-line)
      ;; TODO: skip forward over empty lines
      )
  )

(defun lr/insert-declaration (variable-declaration)
  (lr/open-line-above)
  (insert variable-declaration)
  (beginning-of-line)
  (search-forward "= " nil t)
  )

(defun lr-extract-variable (beg end)
  "Do refactoring 'extract Perl variable' of active region.

Ask the user for a variable name to extract the active region
into.

Replace all occurences in the current defun with the variable and
insert a variable declarion (initialized with the region text).

Push the mark and then leave point at the new variable
declaration (you'll need to ensure this is a reasonable location
before jumping back).

By default, only the current defun is changed. Invoke with the
prefix arg to change the entire buffer.

Both replacements and the declaration are highlighted."
  (interactive "r")
  ;; TODO: timer to remove highlighting after x seconds
  ;; TODO:     using a nice fade
  (unless (and transient-mark-mode mark-active)
    (error "Select a self-contained piece of code to extract"))
  (set-mark-command nil)
  (let*
      ((should-narrow-to-defun (not current-prefix-arg))
       (expression (buffer-substring-no-properties beg end))
       (variable-name-suggestion (lr/get-variable-name expression))
       (variable-name (read-string
                       (format "Extract (%s) to variable: " expression)
                       variable-name-suggestion nil))
       (formatted-variable-name (propertize variable-name
                                            'font-lock-face lr-extract-variable-face
                                            'category 'lr-edit
                                            ))
       (variable-declaration (format "my %s = %s;" formatted-variable-name expression))
       )
    (save-restriction
      (when should-narrow-to-defun
        (narrow-to-defun))
      (lr/replace-all-buffer expression formatted-variable-name)
      (lr/goto-earliest-usage variable-name)
      (lr/insert-declaration variable-declaration)
      )
    )
  )


(provide 'lang-refactor-perl)

;;; lang-refactor-perl.el ends here


