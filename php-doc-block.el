;;; php-doc-block.el --- Php DocBlock generator

;; Copyright (C) 2016 Dmitriy Moskalyov

;; Author: Dmitriy Moskalyov <moskalyovd@gmail.com>
;; Keywords: php docblock
;; Version: 0.0.1

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

;;; Code:

(defun php-doc-block-var-or-attr (tag-type type name value)
    "Insert doc block for a property or an attribute"
    (cond
      ((and value (= (string-width type) 0))
       (cond
         ((string-match "^=\s*\\(array(.*)\\|\\[\.*\]\\)" value) (setq type "array")) 
         ((string-match "^=\s*\[0-9\]*\\.\[0-9\]+$" value)  (setq type "float"))
         ((string-match "^=\s*\[0-9\]+$" value) (setq type "int"))
         ((string-match "^=\s*\['\"]" value) (setq type "string"))
         ((string-match "^=\s*\\(true\\|false\\)" value) (setq type "bool"))))

      ((and (= (string-width type) 0) (not value))
       (setq type "mixed")))

    (insert "* @" tag-type " " type  " " name "\n"))

(defun php-doc-block-function (name arguments return-type)
    "Insert php docblock for function"
    (insert "* " name "\n* \n")
    (when (> (string-width arguments) 0)
        (dolist (arg (split-string arguments "\s*,\s*"))
            (string-match "\s*\\(\[a-zA-Z0-9_\]*\\)?\s*\\($\[a-zA-Z0-9_\]+\\)\s*\\(=.*\\)?" arg)
            (php-doc-block-var-or-attr "param" (match-string 1 arg) (match-string 2 arg) (match-string 3 arg))))

    (when (> (string-width return-type) 0)
        (insert "* \n * @return " return-type "\n")))

(defun php-doc-block-class (type name)
    "Insert php doc block for class, interface etc."
    (insert "* " name " " type "\n* \n"))


(defun php-doc-block ()
    "Insert php docblock"
    (interactive)
    (beginning-of-line)
    (let ((line (thing-at-point 'line)))
        (open-line 1)
        (insert "/**\n")

        (cond
          ((string-match "function\s*\\([A-Za-z0-9_]+\\)(\\(.*\\))\s*:*\s*\\(\[A-Za-z0-9_\]*\\)" line)
           (php-doc-block-function (match-string 1 line) (match-string 2 line) (match-string 3 line)))
          ((string-match "\s*\\([a-zA-Z0-9_]+\\)?\s*\\($\[a-zA-Z0-9_\]+\\)\s*\\(=\[^;\]*\\)?" line)
           (php-doc-block-var-or-attr "var" "" (match-string 2 line) (match-string 3 line)))
          ((string-match "\\(class\\|interface\\|trait\\|abstract class\\)\s+\\(\[a-zA-Z0-9_\]+\\)" line)
           (php-doc-block-class (match-string 1 line) (match-string 2 line))))

    (insert "*/")))

(provide 'php-doc-block)
;;; php-doc-block.el ends here
