# emacs-php-doc-block
PhpDocBlock generator

# Features
* Generate docblocks for `classes`, `class properties` and `functions`
* Guessing variable type by value
* Guessing variable type by argument type (`array`, `int`, `ClassName` etc.)
* Guessing function return by returning type declaration (PHP7)

# Installation
Clone or download from [here](https://github.com/moskalyovd/emacs-php-doc-block.git). Then add following code to your config file (.emacs or init.el)
```lisp
(add-to-list 'load-path "~/.emacs.d/emacs-php-doc-block")
(require 'php-doc-block)
```

# How to use
Bind `php-doc-block` command to any key your like in php-mode
```lisp
(add-hook 'php-mode-hook
          (lambda ()
              (local-set-key (kbd "<C-tab>") 'php-doc-block)))
```
or globally 
```lisp
(global-set-key (kbd "<C-tab>") 'php-doc-block)
```

This command will **NOT** generate docblock for entire file, it will generate docblock only for function, var or class which on the same line with cursor

# License
GPLv3
