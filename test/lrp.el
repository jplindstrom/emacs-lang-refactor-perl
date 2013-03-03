;;; test/lrt.el --- Test for lang-refactor-perl.el

;; Copyright © 2013 Johan Linsdtrom
;;
;; Author: Johan Lindstrom <buzzwordninja not_this_bit@googlemail.com>
;; URL: https://github.com/jplindstrom/emacs-lang-refactor-perl
;; Version: 0.1.3
;; Keywords: languages, refactoring, perl

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.


(require 'ert)


(defun lrt-data-file (file)
  "Return file name of test data FILE"
  (concat default-directory "data/" file))

(defun lrt-data-file-string (file)
  "Return the contents of data FILE as a string."
  (with-temp-buffer
    (insert-file-contents (lrt-data-file file))
    (buffer-string)))

(defmacro with-lrt-perl-file (file &rest body)
  `(with-temp-buffer
     (insert-file-literally (lrt-data-file ,file))
     (cperl-mode)
     ,@body))

(ert-deftest lrt-extract-variable--happy-path ()
  "Perform extract variable and check that everything lookd alright"
  (with-lrt-perl-file
   "before_01.pl"
   ;; Find the last occurrence
   (goto-char (point-max))
   (let* ((code-to-extract "$oLocation->rhProperty")
          (beg (search-backward code-to-extract))
          (end (search-forward code-to-extract))
          )
     ;; Select region of the text to extract
     (push-mark beg)
     (push-mark end  nil t)
     (lr-extract-variable beg end "$rhProperty")
     )

   ;; Extraction did the right thing
   (should
    (string=
     (buffer-substring-no-properties (point-min) (point-max))
     (lrt-data-file-string "after_01.pl")))

   ;; Point located at extraction point
   (should (looking-back "my $rhProperty = "))
   (should (looking-at "$oLocation->rhProperty;"))

   ;; Check we left a mark at starting point; Jump back
   (pop-to-mark-command)
   (should (looking-back "$rhProperty"))
   (should (looking-at "->{podSection} = $podSection;"))
   )
  )


;;; test/ert.el ends here
