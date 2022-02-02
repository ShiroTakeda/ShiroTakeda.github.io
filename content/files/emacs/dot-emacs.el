;;; .EMACS.EL --- A sample of .emacs.el

;; Copyright (C) 2001 Shiro Takeda

;; Time-stamp: <2007-08-06 11:47:36 Shiro Takeda>
;; Version: 1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; A copy of the GNU General Public License can be obtained from this
;; program's author
;; or from the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
;; 02139, USA.

;;; Notice:
;;
;; The settings in this file work only in the GNU Emacs 20.X. and not work
;; in GNU Emacs of older version or XEmacs.
;;

;;; Basic command:
;
; C-x u     Undo
; C-g       Cancel
; C-x C-s   Save file
; C-x C-f   Open file
; C-x C-c   Close Emacs


;;; debug
;
; If you set this variable `non-nil', you can get logs of errors.
;
(setq debug-on-error t)
;(setq debug-on-error nil) 


;;; Use font-lock
;
(require 'font-lock)
(global-font-lock-mode t)


;;; load-path setting.
;
; To add a load-path (for example `~/lisp'), you should add
;
; (setq load-path
;       (cons (expand-file-name "~/lisp")
; 	    load-path))


;;; Unbind `C-@' and make `C-@' my own prefix key.
;
(global-unset-key "\C-@")
(global-unset-key "\C-@\C-c")


;;; Shell and shell mode.
;
; Settings for shell.  You need a shell to execute various external
; processes from Emacs.  MS windows 9X/Me has a default shell
; (command.com).  But you had better install bash provided by Cygwin
; "http://cygwin.com".  To install bash, download and run
; "http://cygwin.com/setup.exe".  Moreover you had better read
; "http://www.gnu.org/software/emacs/windows/faq7.html#shell".
; 
(setq shell-file-name "bash.exe")
; Path to bash.
(set-variable (quote explicit-shell-file-name) "/bin/bash.exe")
(modify-coding-system-alist 'process ".*sh//exe" 'undecided-unix)
(setq shell-command-option "-c")
(add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t) 
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
(setq comint-process-echoes nil)
(setq shell-font-lock-keywords
      '((eval cons shell-prompt-pattern 'font-lock-string-face)
	("[ 	]\\([+-][^ 	\n]+\\)" 1 font-lock-comment-face)
	("^[^ 	\n]+:.*" . font-lock-string-face)
	("^\\[[1-9][0-9]*\\]" . font-lock-string-face)))


;;; Language and Character code.
;
; For Japanese users.
;
; (set-language-environment "Japanese")
; (set-default-coding-systems 'japanese-shift-jis-dos)
; (set-terminal-coding-system    'sjis-unix)
; (set-clipboard-coding-system 'sjis-dos)
; (setq default-process-coding-system '(sjis-dos . sjis-unix))
; (setq coding-system-for-mime-charset-iso-2022-jp-3 'iso-2022-jp-3)))


;;; abbrev
;
; Bind `M-SPC' for M-x expand-abbrev.
(cond
 ((file-exists-p "~/.abbrev_defs")
  (read-abbrev-file "~/.abbrev_defs")
  (define-key esc-map  " " 'expand-abbrev) ; M-SPC
  ))


;;; Dynamic abbreviation.
;
; Dynamic abbreviation is extremely useful function!  I bind it to `C-o'.
;
(global-unset-key "\C-o")
(global-set-key "\C-o" 'dabbrev-expand)


;;; Line number display limit.
;
; In a large file, line number is not displayed in a mode line by default.
;
;(setq line-number-display-limit 10000000)


;;; Toggle automatic file compression and uncompression.
;
; If Non-nil, compressed files are automatically decompressed when you
; open them.
;
(auto-compression-mode t)


;;; the number of caracters in a line.
;
; A variable `fill-column' is a buffer local variable.  So, if you set a
; value to fill-column in a buffer, it is assigned another value in
; another buffer.  setq-default is a function which determines a default
; value of a buffer local variable.
;
(setq-default fill-column 74)


;;; default-major-mode setting.
;
(setq default-major-mode 'lisp-interaction-mode)


;;; text-mode hook.
(setq text-mod-hook '(lambda ()
		       (auto-fill-mode 1)
		       (setq fill-column 80)))


;;; How can I color a region of text in Emacs?
;
;   If you are using a windowing system such as X, you can cause the region
;   to be highlighted when the mark is active by including
;
(setq transient-mark-mode t)



;;; Home Directory.
;
; "~" takes the value defined by the enviormental variable `HOME'.
;
(cd "~/")


;;;;; Key binding


;;; bind delete key for delete-char
(if
    (eq window-system 'nil)
    (keyboard-translate ?\C-? ?\C-d))
(if
    (eq window-system 'x)
    (global-set-key [delete] 'delete-char))


;;; Bind C-h to Backspace.
(global-set-key "\C-h" 'backward-delete-char-untabify)


;;; Unbind `C-x f'.
(global-unset-key "\C-xf")


;;; auto indent
(define-key global-map "\C-m" 'newline-and-indent)
(setq indent-line-function 'indent-relative-maybe)


;;; goto-line
(global-set-key "\M-g" 'goto-line)
;(global-set-key [(meta g)] 'goto-line)


;;; Bind `C-t' for open-line.
(global-unset-key "\C-t")
(global-set-key "\C-t" 'open-line)


;;; Bind `C-@c' for comment-region
(global-set-key "\C-@c" 'comment-region)


;;; call last keyboard macro
(global-unset-key "\C-q")
(global-set-key "\C-q" 'call-last-kbd-macro)


;;; Bind C-j to eval-print-last-sexp
(global-unset-key "\C-j")
(global-set-key "\C-j" 'eval-print-last-sexp)


;;; Bind C-@d to edebug-defun
(global-unset-key "\C-@d")
(global-set-key "\C-@d" 'edebug-defun)


;;; Bind my-delete-word
(global-unset-key "\C-@j")
(global-set-key "\C-@j" 'my-delete-word)

(defun my-delete-word ()
  (interactive)
  (forward-word -1)
  (kill-word 1))


;;; Set up some function key shortcuts


;;; F1
(global-set-key [f1]		'help)
(global-set-key [(shift f1)]	'man)


;;; Bind `F2'
(global-set-key [f2] 'my-insert-tab)

(defun my-insert-tab ()
  (interactive)
  (insert "	"))


;;; Bind C-@p.
(global-unset-key "\C-@p")
(global-set-key "\C-@p" 'my-eliminate-space)

(defun my-eliminate-space ()
  (interactive)
  (save-excursion
    (let (point-beg point-end)
      (forward-word -1)
      (re-search-forward "\\([ \t]+\\)" nil t)
      (setq point-beg (match-beginning 1))
      (re-search-forward "\\([^ \t]+\\)" nil t)
      (setq point-end (match-beginning 1))
      (delete-region point-beg point-end)
      )))


;;; SET CUA (windows-style) KEY BINDINGS.  Moving cursor down at
;;; bottom scrolls only a single line, not half page.
;;; default is nil (unix style).
(setq scroll-step 1)


;;;
; (global-set-key [insert] 'scroll-other-window)
; (global-set-key [pause] 'scroll-other-window-down)


;;; Replace string.
(global-unset-key "\C-@u")
(global-set-key "\C-@u" 'query-replace-regexp)


;;; Go to the end of the buffer.
(global-unset-key "\C-@e")
(global-set-key "\C-@e" 'end-of-buffer)


;;; Go to the top of the buffer.
(global-unset-key "\C-@t")
(global-set-key "\C-@t" 'beginning-of-buffer)


;;; Recenter the cursor.
(global-unset-key "\C-l")
(global-set-key "\C-l" 'recenter)


;;; Turn on or off auto-fill-mode.
(global-unset-key "\C-@\C-cf")
(global-set-key "\C-@\C-cf" 'auto-fill-mode)


;;; Scroll up and down keeping cursor position constant.

(autoload 'View-scroll-line-forward "view" nil t)
(autoload 'View-scroll-line-backward "view" nil t)

(defun my-scroll-line-forward ()
  (interactive)
  (save-excursion
    (View-scroll-line-forward)))

(defun my-scroll-line-backward ()
  (interactive)
  (save-excursion
    (View-scroll-line-backward)))

(global-unset-key "\M-n")
(global-set-key "\M-n" 'my-scroll-line-forward)

(global-unset-key "\M-p")
(global-set-key "\M-p" 'my-scroll-line-backward)


;;; TEXT SELECTION
;
; highlight during query
(setq query-replace-highlight t)
;
; highlight incremental search
(setq search-highlight t)               


;;; This makes cursor not go beyond EOF.
(setq next-line-add-newlines nil)


;;; Line and column number mode.
;
; The line number and column number appear in the mode line.
;
(line-number-mode t)
(column-number-mode t)



;;; Truncate lines.
;
; *Non-nil means truncate lines in all windows less than full frame wide.
;
(setq truncate-partial-width-windows nil)


;;; Set bell off.
;
(setq visible-bell t)
;(setq visible-bell nil)



;;; buffer-menu
;
(define-key ctl-x-map "\C-b" 'buffer-menu)


;;; dired-mode setting
(require 'dired)
(add-hook  'dired-mode-hook
	   '(lambda ()
	      (require 'dired-x)
	      (require 'dired-aux)
	      (font-lock-mode -1)))

; 
(setq dired-listing-switches "-al")


;;; Start process in a dired mode.
(define-key dired-mode-map "(" 'my-start-process)

(defun my-start-process ()
  (interactive)
  (let
      ((file-name (dired-get-filename))
       (buf (buffer-name))
       proc)
    (setq proc
	  (start-process "execute" buf file-name " &"))
    ))
  

; User-defined alist of rules for suggested commands in dired-mode.
;
; User-defined alist of rules for suggested commands. These rules take
; precedence over the predefined rules in the variable.  Try to type `!'
; in the dired mode buffer.  fiber is a program which has the following
; functions: 1) Inspect the specified file and decide its file type.  2)
; Execute a file by `File Association' provided by Windows.  fiber.exe is
; available at ftp://ftp.mew.org/pub/Mew/Win32/tool/

(setq dired-guess-shell-alist-user
      '(("\\_tar\\.gz$" "tar zxvf *&")
	("\\_tar\\.gz$" "tar ztvf *&")
	("\\.tgz$" "tar zxvf *&")
	("\\.tgz$" "tar ztvf *&")
	("\\.TGZ$" "tar zxvf *&")
	("\\.TGZ$" "tar ztvf *&")
	("\\.tar\\.gz$" "tar zxvf *&") 
	("\\.Z$" "gunzip *&") 
	("\\.z$" "gunzip *&")
	("\\.zip$" "unzip *&")    
	("\\.gz$" "gunzip *&")
	("\\.GZ$" "gunzip *&")    
	("\\.bz2$" "bunzip2 *&")
	("\\.BZ2" "bunzip2 *&")    
	("\\.\\(g\\|\\)z" "zcat *&")
	("\\.lzh$" "lha32 x  *&")
	("\\.mgp$" "mgp * &")
	("\\.MGP$" "mgp * &")    
	("\\.gms$" "gams * &")
	("\\.GMS$" "gams * &")    
	("\\.dvi$" "fiber * &")
	("\\.ps$" "fiber *&")
	("\\.PS$" "fiber *&")    
	("\\.pdf$" "fiber *&")
	("\\.PDF$" "fiber *&")
	("\\.tex$" "latexmk -f *&")
	("\\.m$" "octave * &")
	("\\.M$" "octave * &")
	("\\.\\(e\\|\\)ps$" "gsview32 * &")    
	("\\.plt$" "gnuplot *&") 
	("\\.jp[e]?g$" "fiber * &")
	("\\.JP[E]?G$" "fiber * &")
	("\\.png$" "fiber * &")
	("\\.PNG$" "fiber * &")
	("\\.gif$" "fiber * &")
	("\\.GIF$" "fiber * &")    
	("\\.bmp$" "fiber * &")
	("\\.BMP$" "fiber * &")
	("\\.html$" "fiber *&")
	("\\.htm$" "fiber *&")	  
	("\\.HTML$" "fiber *&")
	("\\.HTM$" "fiber *&")
	("\\.xls$" "fiber *&")
	("\\.XLS$" "fiber *&")	  	  	  
	("\\.123$" "fiber *&")
	("\\.lwp$" "fiber *&")	  	  	  
	("\\.LWP$" "fiber *&")
	("\\.doc$" "fiber *&")	  	  	  
	("\\.DOC$" "fiber *&")
	("\\.mpg$" "fiber *&")	  	  	  
	("\\.mpg$" "fiber *&")
	))




;;; Insert my name.
;
; A function which insert my name.  Binded to `C-@n'.
;
(setq user-full-name "Shiro Takeda")	; Change this to your name.
(defun user-full-name () user-full-name)
(defun my-full-name ()
  (interactive) 
  (insert user-full-name))
(global-set-key "\C-@n" 'my-full-name)


;;; rmail 
(setq rmail-summary-window-size 7)


;;; command to connect lines.
;
(defun connect-lines-region (begin end)
  (interactive "r")
  (let ((newline begin))
    (save-excursion
      (goto-char begin)
      (while (and (setq newline (search-forward "\n" end t))
		  (> end newline))
	(replace-match "")
	(setq end (1- end))))))

;;; Prefix for citation in mail mode.
;
(setq mail-yank-prefix "> ")


;;; Hook for bibtex mood.
;
(add-hook 'bibtex-mood-hook
	  (lambda ()
	    (auto-fill-mode 1)))



;;; time-stamp.el
;
; By using time-stamp.el, you can insert last-modified time where
; time-stamp:<>.  time-stamp:<> must be placed within 8th line from the
; biginning of the buffer.
;
(if (not (memq 'time-stamp write-file-hooks))
    (setq write-file-hooks
	  (cons 'time-stamp write-file-hooks)))
;(setq time-stamp-format
;          '(time-stamp-yyyy/mm/dd time-stamp-hh:mm:ss))



;;; Commentary:
;
; Automatically save place in files, so that visiting them later
; (even during a different Emacs session) automatically moves point
; to the saved position, when the file is first found.  Uses the
; value of buffer-local variable save-place to determine whether to
; save position or not.
;
; Thanks to Stefan Schoef, who sent a patch with the
; `save-place-version-control' stuff in it.
;
(require 'saveplace)
(setq-default save-place t)
(setq save-place-limit 30)


;;; fast-lock.el -- Acceleration for font-lock
;
; Automagic text properties caching for fast Font Lock mode.
(setq font-lock-support-mode 'fast-lock-mode)
; Font-lock-cache
(let* ((file-dir "~/.emacs-flc"))
  (if (file-exists-p file-dir); ~/.emacs-flc
      (setq fast-lock-cache-directories (list file-dir))))



;;; bibtex.el
(setq bibtex-comment-start "% ")


;;; Need not type yes or no. Just y or n.
(fset 'yes-or-no-p 'y-or-n-p)


;;; speedbar
(global-set-key [(f4)] 'speedbar-get-focus)


;; MOUSE SET UP. Paste at point NOT at cursor
(setq mouse-yank-at-point 't)


;; Scroll Bar gets dragged by mouse butn 1
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)


;; Rebind mouse-2 events to mouse-1 in various places:
;; Completion list
(add-hook 'completion-list-mode-hook
  '(lambda() (define-key completion-list-mode-map [down-mouse-1] 
	       'mouse-choose-completion)))


;; Buffer Menu
(add-hook 'buffer-menu-mode-hook
  '(lambda() (define-key Buffer-menu-mode-map [down-mouse-1] 
	       'Buffer-menu-mouse-select)))


(setq mouse-yank-at-point t)	;Fix so button 2 pastes at cursor, not Point
;(global-unset-key [mouse-2])	;disable intellimouse wheel


;;; paren.el
(load "paren")


;;; kill emacs
(setq kill-emacs-query-functions
      (cons (lambda () (yes-or-no-p "Really kill Emacs? "))
	    kill-emacs-query-functions))


;;; Info directory
;
; (setq Info-default-directory-list
;       (append '("/usr/local/info/") Info-default-directory-list))
; (setq Info-directory-list Info-default-directory-list)


;;; double-scroll

(defun double-scroll-line-up ()
  (interactive)
  (let ((point-a (point)))
    (View-scroll-line-forward)
    (other-window 1)
    (View-scroll-line-forward)
    (other-window 1)
    (goto-char point-a)))

(defun double-scroll-line-down ()
  (interactive)
  (let ((point-a (point)))
    (View-scroll-line-backward)
    (other-window 1)
    (View-scroll-line-backward)
    (other-window 1)
    (goto-char point-a)))

(defun double-scroll-up ()
  (interactive)
  (let ((point-a (point)))
    (scroll-up)
    (other-window 1)
    (scroll-up)
    (other-window 1)
    (goto-char point-a)))

(defun double-scroll-down ()
  (interactive)
  (let ((point-a (point)))
    (scroll-down)
    (other-window 1)
    (scroll-down)
    (other-window 1)
    (goto-char point-a)))

(global-set-key [(f9)]     'double-scroll-line-up)
(global-set-key [(f10)]    'double-scroll-line-down)
(global-set-key [(meta f9)]     'double-scroll-up)
(global-set-key [(meta f10)]    'double-scroll-down)

;;;
;
;
;
(defun my-scroll-line-forward ()
  (interactive)
  (save-excursion
    (View-scroll-line-forward)))

(defun my-scroll-line-backward ()
  (interactive)
  (save-excursion
    (View-scroll-line-backward)))

(global-unset-key [f11])
(global-set-key [f11] 'my-scroll-line-forward)

(global-unset-key [f12])
(global-set-key [f12] 'my-scroll-line-backward)


(global-unset-key [(meta f11)])
(global-set-key [(meta f11)] 'scroll-up)

(global-unset-key [(meta f12)])
(global-set-key [(meta f12)] 'scroll-down)


(global-unset-key [f7])
(global-set-key [f7] 'scroll-up)

(global-unset-key [f8])
(global-set-key [f8] 'scroll-down)

;;; From Yuuji Hirose's book.

;;; Resize a frame by keyboard.
;
; Binded to `C-@r'
;
(defun resize-frame-interactively ()
  (interactive)
  (let (key
	(width (frame-width))
	(height (frame-height)))
    (catch 'quit
      (while t
	(message "Resize frame by [(C-)npfb] (%dx%d): " width height)
	(setq key (read-char))
	(cond
	 ((or (eq key ?n) (eq key 14)) (setq height (1+ height)))
	 ((or (eq key ?p) (eq key 16)) (setq height (1- height)))
	 ((or (eq key ?f) (eq key 6)) (setq width (1+ width)))
	 ((or (eq key ?b) (eq key 2)) (setq width (1- width)))
	 (t (throw 'quit t)))
	(modify-frame-parameters
	 nil (list (cons 'width width) (cons 'height height)))))
    (message "End.")))

(global-unset-key "\C-@r")
(global-set-key "\C-@r" 'resize-frame-interactively)


;;; Move a frame by keyboard.
;
; Binded to `C-@h'
;
(defun move-frame-interactively ()
  (interactive)
  (let (key
	(top (frame-parameter nil 'top))
	(left (frame-parameter nil 'left)))
    (if (listp top)
	(setq top (car (cdr top))))
    (if (listp left)
	(setq left (car (cdr left))))
    (catch 'quit
      (while t
	(message "Move frame by [(C-)npfb] (%dx%d): " top left)
	(setq key (read-char))
	(cond
	 ((eq key ?n) (setq top (+ 10 top)))
	 ((eq key ?p) (setq top (- top 10)))
	 ((eq key ?f) (setq left (+ 10 left)))
	 ((eq key ?b) (setq left (- left 10)))
	 ((eq key 14) (setq top (+ 20 top)))
	 ((eq key 16) (setq top (- top 20)))
	 ((eq key 6) (setq left (+ 20 left)))
	 ((eq key 2) (setq left (- left 20)))
	 (t (throw 'quit t)))
	(if (and (or (eq key ?p) (eq key 16)) (<= top 5))
	    (progn
	      (setq top 5)))
	(if (and (or (eq key ?b) (eq key 2)) (<= left 5))
	    (progn
	      (setq left 5)))
	(modify-frame-parameters
	 nil (list (cons 'top top) (cons 'left left )))))
    (message "End.")))

(global-unset-key "\C-@h")
(global-set-key "\C-@h" 'move-frame-interactively)


;;; Font lock setting
;
; If you want to use default colors, set nil to the variable
; `my-color-yes' like (setq my-color-yes nil).
;
(setq my-color-yes t)

(if my-color-yes
    (progn
      (custom-set-faces
       '(font-lock-keyword-face ((t (:foreground "Cyan1"))))
       '(font-lock-comment-face ((t (:foreground "green"))))
       '(font-lock-warning-face ((t (:bold t :foreground "#ff0000"))))
       '(font-lock-constant-face ((t (:foreground "#22ffff"))))
       '(font-lock-type-face ((t (:bold t :foreground "yellow"))))
       '(font-lock-string-face ((t (:foreground "#ff88cc"))))
       '(font-lock-variable-name-face ((t (:foreground "#ffff00"))))
       '(font-lock-function-name-face ((t (:bold t :foreground "#ffff00"))))
       '(modeline ((t (:bold t :foreground "#ffee55" :background "#2f1f00"))))
       '(highlight ((t (:bold t :foreground "#ffff66" :background "#330033"))))
       '(region ((t (:bold t :foreground "#ccff00" :background "#220022"))))
       '(secondary-selection
	 ((t (:bold nil :foreground "#ffff33" :background "#200020"))))
       '(underline
	 ((t (:underline t :bold nil :foreground "#ffff77" :background "black"))))
       '(ediff-current-diff-face-B
	 ((t (:foreground "pale green" :background "#550000"))))
       '(ediff-current-diff-face-A
	 ((t (:bold t :foreground "pale green" :background "#550000"))))
       '(ediff-odd-diff-face-B ((t (:foreground "light grey" :background "grey20"))))
       '(ediff-odd-diff-face-A ((t (:foreground "light grey" :background "grey20"))))
       '(ediff-fine-diff-face-B ((t (:foreground "yellow" :background "#000055"))))
       '(ediff-fine-diff-face-A ((t (:foreground "yellow" :background "#000055"))))
       '(ediff-even-diff-face-Ancestor
	 ((t (:foreground "white" :background "#005555"))))

       '(mc-directory-face ((t (:bold t :foreground "green"))))
       '(x-face-mule-highlight-x-face ((t (:foreground "black" :background "white"))))
       '(html-tag-face ((t (:foreground "cyan"))))
       '(holiday-face ((t (:foreground "green" :background "black"))))

       '(show-paren-mismatch-face ((t (:bold t :foreground "purple"))))
       '(show-paren-match-face ((t (:bold t :foreground "turquoise"))))
       '(paren-face-match ((t (:bold t :foreground "MediumVioletRed" :background "black"))))
       '(custom-changed-face ((t (:foreground "white" :background "navy"))))

       '(ediff-current-diff-face-B ((((class color)) (:foreground "pale green" :background "#550000"))))
       '(ediff-current-diff-face-A ((((class color)) (:bold t :foreground "pale green" :background "#550000"))))
       '(ediff-fine-diff-face-B ((((class color)) (:foreground "yellow" :background "#000055"))))
       '(ediff-fine-diff-face-A ((((class color)) (:foreground "yellow" :background "#000055"))))
       '(ediff-even-diff-face-Ancestor ((((class color)) (:foreground "white" :background "#005555"))))
       '(ediff-odd-diff-face-B ((((class color)) (:foreground "light grey" :background "grey20"))))
       '(ediff-odd-diff-face-A ((((class color)) (:foreground "light grey" :background "grey20")))))

      (set-foreground-color "white")
      (set-background-color "black")
      (set-cursor-color "yellow")
      ))
      

;;; Default frame setting.
;
(if my-color-yes
    (setq default-frame-alist
	  (append (list
		   '(width . 70)
		   '(height . 35)
		   '(top . 0)
		   '(left . 0)
		   '(vertical-scroll-bars . t)
		   '(foreground-color . "white")
		   '(background-color . "black")
		   '(border-color     . "red")
		   '(mouse-color      . "green")
		   '(cursor-color     . "yellow")
		   default-frame-alist)))
    (setq default-frame-alist
	  (append (list
		   '(width . 70)
		   '(height . 35)
		   '(top . 0)
		   '(left . 0)
		   '(vertical-scroll-bars . t)
		   default-frame-alist))))
  

;;; Font.
;
; If you are using NT Emacs, type SHIFT + MOUSE LEFT BUTTON.
;
; Try the next, too. 
; (setq w32-use-w32-font-dialog nil)


;;; Display menu bar if ARG is positive.
;
; Menu bar is on.
;
(menu-bar-mode 1)


;;; Scroll-bar
;
; A scroll-bar is on the right side.
;
(set-scroll-bar-mode 'right)
;(set-scroll-bar-mode 'left)
;(setq set-scroll-bar-mode nil) ; no scroll bar


;;; .EMACS.EL ends here
;Local variables:
;mode: emacs-lisp
;syntax: elisp
;End:
