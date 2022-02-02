;;; GAMS.EL --- Major mode for editting and viewing GAMS program files.

;; Copyright (C) 2001 Shiro Takeda

;; Author: Shiro Takeda <ged9203@srv.cc.hit-u.ac.jp>
;; Maintainer: Shiro Takeda <ged9203@srv.cc.hit-u.ac.jp>
;; Time-stamp: <2001-08-25 19:50:33 ged9203>
;; Version: 1.03

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; A copy of the GNU General Public License can be obtained from this
;; program's author (send electronic mail to
;; ged9203@srv.cc.hit-u.ac.jp) or from the Free Software Foundation,
;; Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Acknowledgments:
;; 
;; To write this lisp program, I have used a lot of excellent emacs lisp
;; codes written by other people.  They include `YaTeX' (Yet Another LaTeX
;; mode), `EPO' (Editing Process Organizer), `font-latex.el', and
;; `lisp-mode.el' etc.  In particular, I would like to express
;; acknowledgments to Yuuji Hirose who is the author of `YaTeX' and `EPO'
;; packages (they are available at
;; `http://www.gentei.org/~yuuji/software').  He also have written other
;; lots of cool lisp programs.  You will be happy if you visit to his web
;; site :-)
;;

;;; Commentary:
;;
;; This is a major mode for editting GAMS program files in Emacs.
;;
;; This program include two major modes (GAMS mode and GAMS-LST mode).
;; GAMS mode is for editting GMS files and GAMS-LST mode for viewing GAMS
;; LST files.
;;

;;; Main features:
;;
;; * GAMS mode:
;;
;; + Insert GAMS statements with completion.
;; + Automatic registration of new statements.
;; + Run GAMS in an Emacs buffer.
;; + Colorize a GAMS file with font-lock.
;;
;; 
;; * GAMS-LST mode:
;;
;; + Show an error place and its meaning at the same time.
;; + Jump to various places in a file easily.
;; + Jump to an error point in the original GMS file.
;; + Colorize a LST file buffer.
;;

;;; Requirements:
;;
;; This program is only tested with FSF Emacs 20.7.1 (NT Emacs).  In other
;; environments, it may not work well.  Bug reports are welcome.
;;

;;; Installation:
;;
;; (1) Put "gams.el" in one of the directories listed in `load-path'.  You
;; can see the contents of `load-path' by entering `M-x customize-option
;; <RET> load-path'.
;;
;; (2) Add the following into your ~/.emacs.el startup file
;;
;;
;;	(setq auto-mode-alist
;;		(cons (cons "\\.\\(GMS\\|gms\\)$" 'gams-mode) auto-mode-alist))
;;	(setq auto-mode-alist
;;		(cons (cons "\\.\\(LST\\|lst\\)$" 'gams-lst-mode) auto-mode-alist))
;;
;;	(autoload 'gams-mode "gams" "Enter GAMS mode" t)
;;	(autoload 'gams-lst-mode "gams" "Enter GAMS-LST mode" t)
;;
;;
;; Then, if you open GSM file (or LST file), GAMS mode (or GAMS-LST mode)
;; will start automatically.
;;
;; If you want to colorize an Emacs buffer, add the following, too.
;;
;;
;;	(require 'font-lock)
;;	(global-font-lock-mode t)
;;
;;
;; There are several lisp variables which decide important behavior of
;; GAMS and GAMS mode.  So, Please read the custumization part below, too.
;;

;;; Usage:
;;
;;  Read `gams-sample.gms' file, too.
;;
;;  GAMS mode:
;;
;;	key-binding	Command explanation
;;
;;	C-ck		Insert GAMS statement with completion.
;;	C-cd or $	Insert GAMS dollar control option with completion.
;;	C-ct		Start GAMS or Kill GAMS process.
;;	C-u C-ct	Edit command and start GAMS.
;;	C-cv		Switch to the LST file and show errors if exist.
;;	C-cj		Switch to the LST file.
;; 
;;	"		Insert double quotations.
;;	`		Insert single quotations.
;;	(		Insert parenthesis.
;;
;;	C-co		Insert user defined comment template.
;;
;;
;;  GAMS-LST mode:
;;
;;	e		Jump to the error and show its number and meaning.
;;	g		Jump back to the error place in the GMS file.
;;	j		Jump to the GMS file.
;;	k		Jump to the GMS file.
;;	q		Close the buffer.
;; 
;;	s		Jump to the next SOLVER SUMMARY.
;;	S		Jump to the previous SOLVER SUMMARY.
;;	r		Jump to the next REPORT SUMMARY.
;;	R		Jump to the previous REPORT SUMMARY.
;;	v		Jump to the next VAR entry.
;;	V		Jump to the previous VAR entry.
;;	a		Jump to the next EQU entry.
;;	A		Jump to the previous EQU entry.
;;	p		Jump to the next PARAMETER entry.
;;	P		Jump to the previous PARAMETER entry.
;;	l		Jump to a line you specify.
;;	L		Jump to a line.
;; 
;;	SPACE		Scroll up.
;;	DELETE		Scroll down.
;;	1		Widen the window.
;;	2		Split the window.
;;	m		Move frame.
;;	f		Resize frame.
;;

;;; Customization:
;;
;;  You can custumize the following variables.  Default value is given in
;;  parenthesis ().
;;
;;  You can change the value of these variables by adding your ~/.emacs,
;;  for example,
;;
;;
;;	(setq gams:process-command-name "c:/GAMS20.0/gams.exe")
;;
;;
;;  GAMS mode:
;;
;;	Important variables:
;;
;;      `gams:process-command-name'
;;      GAMS command name.  If you does not include GAMS system directory
;;      in PATH variable, you must set the full path to GAMS in this
;;      variable like "c:/GAMS20.0/gams.exe".  ("gams")
;;      
;;      `gams:process-command-option'
;;      Command line options passed to GAMS.
;;	("ll=0 lo=3 pagesize=9999")
;;      
;;      `gams-statement-file'
;;	In this file, user specific statements are stored.  ("~/.gams-statement")
;;
;;      `gams-statement-upcase'
;;      Non-nil means statement is inserted in upper case.  If you want to
;;      use lower case, set nil to this variable.  (t)
;;      
;;      `gams-dollar-control-upcase'
;;      Non-nil means dollar control option is inserted in upper case.  If you
;;      want to use lower case, set nil to this variable.  (t)
;;
;;      `gams-use-mpsge'
;;	If you use MPSGE, set non-nil to this variable.
;;	if non-nil, you can insert MPSGE statement with completion.  (nil).
;;
;;      `gams-fill-column'
;;      Fill-column used for fill-paragraph and auto-fill-mode.
;;	(74)
;;
;;
;;	Other variables:
;;
;;	`gams-mode-hook'
;;	Hook run when gams-mode starts.
;;
;;      `gams-close-paren-always'
;;      Close parenthesis if non-nil.  (t)
;;      
;;      `gams-close-double-quotation-always'
;;      Close double quotation if non-nil.  (t)
;;      
;;      `gams-close-single-quotation-always'
;;      Close quotation if non-nil.  (t)
;;      
;;      `gams-user-comment'
;;	User defined comment template.
;;	You can insert the comment template defined in this variable by executing
;;	`gams-insert-comment'.  % indicates the cursor place and will dissappear
;;	after template insertion.  For the default value, see the definition of
;;	`gams-user-comment' below.
;;
;;      `gams-statement-up'
;;      List of GAMS statements.
;;      
;;      `gams-dollar-control-up'
;;      List of GAMS dollar control options.
;;      
;;      `gams-font-lock-keywords'
;;      List of regular expression for font-lock.
;;      
;;      `gams-default-pop-window-height'
;;      Default process buffer height.  If integer, sets the
;;      window-height of process buffer.  If string, sets the
;;      percentage of it.  If nil, use default pop-to-buffer.  (10)
;;      
;;      `gams-comment-prefix'
;;      GAMS comment prefix.  ("*")
;;      
;;      `gams-fill-prefix'
;;      fill-prefix used for auto-fill-mode.  (nil)
;;      
;;      `gams-run-key'
;;      Key for starting GAMS process.  (?s)
;;      
;;      `gams-kill-key'
;;      Key for stopping GAMS process.  (?k)
;;      


;;  GAMS-LST mode:
;;
;;      `gams-lst-mode-hook'
;;      GAMS-LST mode hooks.  (nil)
;;      
;;      `gams-lst-gms-extention'
;;      GAMS program file extention.  ("gms")
;;      
;;      `gams-lst-font-lock-keywords'
;;      

;;; Change Log:
;;
;; Version 1.03 (Sat Aug 25, 2001)
;;
;;  * Made a process window not disappear.
;;  * Made a little change on `gams-start-menu'.
;;  * Add a function `gams-insert-comment' and a variable
;;    `gams-user-comment' to insert user defined comment template.
;;  * Set the auto-fill-mode off by defualt.
;;
;;
;; Version 1.02 (Thu Aug 23, 2001)
;;
;;  * Fixed the bug in `gams-insert-parens' reported by Steven Dirkse.
;;  * Fixed other various bugs.
;;  * Add a variable `gams-statement-regexp-default' for font locking
;;    (colorization).
;;  * Changed the default value of `gams:process-command-option'.
;;  * Add a variable `gams-use-mpsge'.
;;
;;
;; Version 1.01 (Tue Aug 21, 2001)
;;
;;  * Fixed the bug reported by Tor-Martin Tveit and Steven Dirkse.
;;  * Changed `gams-insert-statement' and `gams-insert-dollar-control'.
;;  * More items added to `gams-statement-up' by Steven Dirkse.
;;
;;

;;; TODO:
;;
;;  * Font locking (colorization) like GAMS IDE.
;;    It is a difficult task and will take some time.  Please wait :-)
;;  * Define original face for GAMS mode.
;;  * Automatic indentation.
;;  * 
;;

;;; Misc.
;;
;;  * Bug reports and suggestions are welcome!  Shiro Takeda
;;    <ged9203@srv.cc.hit-u.ac.jp>.
;;
;;


;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;	Code fo GAMS mode.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst gams-el-version-number "1.03"
  "Version of gams.el")

;;; from epop.el
(defvar gams:process-command-name "gams"
  "*GAMS command name.
If you does not include the GAMS system directory in PATH variable,
you must set the full path to GAMS in this variable.")

(defvar gams:process-command-option "ll=0 lo=3 pagesize=9999"
  "*Command line options passed to GAMS")

(defvar gams-statement-file "~/.gams-statement"
  "*In this file, user specific statements are stored.")

(defvar gams-statement-upcase t
  "*Non-nil means statement is inserted in upper case.
If you want to use lower case, set nil to this variable.")

(defvar gams-dollar-control-upcase t
  "*Non-nil means dollar control option is inserted in upper case.
If you want to use lower case, set nil to this variable.")

(defvar gams-use-mpsge nil
  "*If you use MPSGE, set non-nil to this variable.
MPSGE statement completion and colorization.  nil by default.")

(defvar gams-mode-hook  nil
  "*GAMS mode hooks.")

;;; from yatex.el
(defvar gams-close-paren-always t
  "*Close parenthesis if non-nil")

(defvar gams-close-double-quotation-always t
  "*Close double quotation if non-nil")

(defvar gams-close-single-quotation-always t
  "*Close quotation if non-nil")

(defvar gams-comment-prefix "*"
  "*GAMS comment prefix.")

(defvar gams-fill-column 74
  "*fill-column used for auto-fill-mode.")

(defvar gams-fill-prefix nil
  "*fill-prefix used for auto-fill-mode.
The default value is nil.")

(defvar gams-lst-extention "lst"
  "GAMS LST file extention.")

(defvar gams-run-key ?s
  "*GAMS run key")

(defvar gams-kill-key ?k
  "*GAMS kill key")

(defvar gams-user-comment
  "*------------------------------------------------------------------------	
* %       
*------------------------------------------------------------------------
"
  "*User defined comment template.
You can insert the comment template defined in this variable by executing
`gams-insert-comment'.  % in the string indicates the cursor place and will
 dissappear after template insertion.")

(defvar gams-fill-prefix nil
  "*fill-prefix used for auto-fill-mode.
The default value is nil.")

(defvar gams-statement-up
      '("SET" "SETS" "SCALAR" "SCALARS" "TABLE" "PARAMETER" "PARAMETERS"
	"EQUATION" "EQUATIONS" "VARIABLE" "VARIABLES"
	"POSITIVE VARIABLE" "POSITIVE VARIABLES"
	"NEGATIVE VARIABLE" "NEGATIVE VARIABLES"
	"INTEGER VARIABLE" "INTEGER VARIABLES"
	"BINARY VARIABLE" "BINARY VARIABLES"
	"ALIAS"
	"OPTION"
	"SOLVE" "MODEL" "DISPLAY" "LOOP" "IF" "SUM" "PROD"
	)
      "The list of GAMS statements.  Used for completion inserting")

(defvar gams-dollar-control-up
  '("BATINCLUDE" "EXIT" "INCLUDE" "LIBINCLUDE"
    "OFFTEXT" "ONTEXT" "SETGLOBAL" "SYSINCLUDE"
    "TITLE"
    ))

(defvar gams-statement-mpsge
    ; MPSGE
  '("MODEL:" "COMMODITIES:" "CONSUMERS:" "SECTORS:" "PROD:"
    "DEMAND:" "REPORT:" "CONSTRAINT:" "AUXILIARY:"
    ))

(defvar gams-statement-regexp-default
  '("ABORT"
    "ACRONYM" "ACRONYMS"
    "ALIAS"
    "ALL"
    "AND"
    "ASSIGN"
    "CARD"
    "DIAG"
    "DISPLAY"
    "EPS"
    "EQ"
    "GE"
    "GT"
    "INF"
    "LE"
    "LOOP"
    "LT"
    "MAXIMAZING"
    "MINIMIZING"
    "MODEL[S]?"
    "NA"
    "NE"
    "NOT"
    "OPTION[S]?"
    "OR"
    "ORD"
    "PROD"
    "SAMEAS"
    "SCALAR[S]?"
    "SET[S]?"
    "SMAX"
    "SMIN"
    "SOS1"
    "SOS2"
    "SUM"
    "SYSTEM"
    "TABLE[S]?"
    "USING"
    "XOR"
    "YES"
    "REPEAT"
    "UNTIL"
    "WHILE"
    "IF"
    "THEN"
    "ELSE"
    "SEMICONT"
    "SEMIINT"
    "FILE"
    "FILES"
    "PUTPAGE"
    "PUTTL"
    "FREE"
    "NO"
    "SOLVE"
    "FOR"
    "PARAMETER[S]?"
    "EQUATION[S]?"
    "\\(POSITIVE\\|NEGATIVE\\|BINARY\\|INTEGER\\)[ \t]+VARIABLE[S]?"
    "VARIABLE[S]?"
    )
  "The list of GAMS statements (reserved words) for font-lock (colorization).
These statements are colorized only if they lie at the beginning of a line.")

(defvar gams-font-lock-keywords
      (list
       ; ontext - offtext pair.
       (list "^$\\(ontext\\|ONTEXT\\)[^$]*\\($offtext\\|$OFFTEXT\\)"
	     '(0 font-lock-comment-face t t))
       ; Commented out text by *
       (list "^\\(*\\).*$" '(0 font-lock-comment-face))
       ; dollor control option.
       (list "[ \n\t]+\$[a-zA-Z]+[ \t\n]"
	     '(0 font-lock-type-face))
       (list "^\$[a-zA-Z]+[ \t\n]"
	     '(0 font-lock-type-face))
       ; semicolon
       (list ";" '(0 font-lock-warning-face))
       ; Standard GAMS statement.
       '(gams-statement-regexp-func
	 . font-lock-keyword-face)
       ; MPSGE syntax.
       (list "\\($model\\|$MODEL\\|$commodities\\|$COMMODITIES\\|$consumers\\|$CONSUMERS\\|$sectors\\|$SECTORS\\|$prod\\|$PROD\\|$demand\\|$DEMAND\\|$report\\|$REPORT\\|$CONSTRAINT\\|$constraint\\|$auxiliary\\|$AUXILIARY\\)"
	     '(0 font-lock-string-face))
       ; Commented out text by !
       (list "\\([!]\\).*$" '(0 font-lock-comment-face))
    ))


;;; from epolib.el
(defvar gams-default-pop-window-height 10
    "Default process buffer height.
If integer, sets the window-height of process buffer.
If string, sets the percentage of it.
If nil, use default pop-to-buffer.")

(defun gams-list-downcase (list-name)
  (let* (list-new ele)
    (while list-name
      (setq ele (downcase (car list-name)))
      (setq list-new (cons ele list-new))
      (setq list-name (cdr list-name)))
    list-new))

(defvar gams-user-statement-list nil)
(defvar gams-user-dollar-control-list nil)

; (defvar gams-dos (memq system-type '(ms-dos windows-nt OS/2)))
; (defvar gams-xemacs-19
;   (and (not (null (save-match-data 
;                     (string-match "XEmacs\\|Lucid" emacs-version))))
;        (= 19 emacs-major-version)))
; (defvar gams-xemacs-20
;   (and (not (null (save-match-data 
;                     (string-match "XEmacs\\|Lucid" emacs-version))))
;        (<= 20 emacs-major-version)))    ;xemacs-beta-20.5 sets it to version 21
; (defvar gams-emacs-19
;   (and (not gams-xemacs-19) 
;        (not gams-xemacs-20) 
;        (= 19 emacs-major-version)))
; (defvar gams-emacs-20
;   (and (not gams-xemacs-19) 
;        (not gams-xemacs-20) 
;        (= 20 emacs-major-version)))

(defvar gams*command-process-buffer "*Running GAMS*")

(defvar gams-statement-down
  (gams-list-downcase gams-statement-up))

(defvar gams-dollar-control-down
  (gams-list-downcase gams-dollar-control-up))

(defvar gams-statement-alist nil)
(defvar gams-dollar-control-alist nil)

(defvar gams-statement-regexp nil)

;(defvar gams:current-process-buffer nil)

;;; From EPO. 
(defconst gams:frame-feature-p
  (and (fboundp 'make-frame) window-system))

;;; I don't understand this yet.
(defvar gams:shell-c
  (or (and (boundp 'shell-command-switch) shell-command-switch)
      (and (boundp 'shell-command-option) shell-command-option)
      (and (string-match "command.com\\|cmd.exe\\|start.exe" shell-file-name)
	   "/c")
      "-c")
  "*Command option for shell")

(if (fboundp 'buffer-substring-no-properties)
    (fset 'gams*buffer-substring 'buffer-substring-no-properties)
  (fset 'gams*buffer-substring 'buffer-substring))

(cond
 ((fboundp 'screen-height)
  (fset 'gams*screen-height 'screen-height)
  (fset 'gams*screen-width 'screen-width))
 ((fboundp 'frame-height)
  (fset 'gams*screen-height 'frame-height)
  (fset 'gams*screen-width 'frame-width))
 (t (error "I don't know how to run GAMS on this Emacs...")))


; key assignment.
(defvar gams-mode-map (make-keymap) "keymap for gams-mode")
(let ((map gams-mode-map))
  (define-key map "\C-ck" 'gams-insert-statement)
  (define-key map "\C-cv" 'gams-view-lst)
  (define-key map "\C-cj" 'gams-jump-to-lst)    
  (define-key map "$" 'gams-insert-dollar-control)
  (define-key map "\C-cd" 'gams-insert-dollar-control)
  (define-key map "\C-ct" 'gams-start-menu)
  (define-key map "(" 'gams-insert-parens)
  (define-key map "\"" 'gams-insert-double-quotation)
  (define-key map "`" 'gams-insert-single-quotation)

  (define-key map "\C-co" 'gams-insert-comment)
  )

;;; 
(defun gams-mode ()
  "Major mode for editing GAMS program file.

Also, you can execute GAMS from Emacs buffer.

The following commands are available in the GAMS-LST mode:
'\\[gams-insert-statement]' - Insert GAMS statement with completion.
'\\[gams-insert-dollar-control]' - Insert GAMS statement (dollar control option).
'\\[gams-view-lst]  - Switch to the LST file and show errors if exist.
'\\[gams-jump-to-lst]' - Switch to the LST file.
'\\[gams-start-menu]' - Run GAMS on a file you are editting or Kill GAMS process.

'\\[gams-insert-parens]' - Insert parenthesis.
'\\[gams-insert-double-quotation]' - Insert double quotations.
'\\[gams-insert-single-quotation]' - Insert single quotations.

'\\[gams-insert-comment]' - Insert comment template.

NB:

+ This program assumes that the extension of GAMS program file is `.gms'.

"
  (interactive)
  (kill-all-local-variables)  
  (setq major-mode 'gams-mode)
  (setq mode-name "GAMS")
  (use-local-map gams-mode-map)
;  (easy-menu-add todo-menu)
;  (setq paragraph-separate "\*/\*")
  (setq fill-prefix "\t\t")
;  (setq outline-regexp "\\*/\\*")
;  (outline-minor-mode 1)
;  (hide-other)
;  (auto-fill-mode 1)

; mapcar is a built-in function.

; Apply FUNCTION to each element of SEQUENCE, and make a list of the results.
; The result is a list just as long as SEQUENCE.
; SEQUENCE may be a list, a vector, a bool-vector, or a string.
; (mapcar FUNCTION SEQUENCE)
  (mapcar
   'make-local-variable
   '(fill-column
     fill-prefix
;      paragraph-start
;      paragraph-separate
;      indent-line-function
     comment-start
     comment-start-skip
	    ))
  (setq
   fill-column gams-fill-column
   fill-prefix gams-fill-prefix
;    paragraph-start    gams-paragraph-start
;    paragraph-separate gams-paragraph-separate
;    indent-line-function 'gams-indent-line
   comment-start gams-comment-prefix
   comment-end ""
   comment-start-skip "^*+[ \t]*"
   )

  ; Create the alist of statements.  Is this necessary?
  ; See `gams-statement-update'.
  (setq gams-statement-alist
	(gams-statement-to-alist
	 (if gams-statement-upcase
	     gams-statement-up
	   gams-statement-down)))
  
  ; Create the alist of dollar control options.  Is this necessary?
  ; See `gams-statement-update'.  
  (if gams-use-mpsge
      ; Use mpsge.
      (progn
	(setq gams-dollar-control-alist
	      (gams-statement-to-alist
	       (if gams-dollar-control-upcase
		   (append gams-dollar-control-up gams-statement-mpsge)
		 (append gams-dollar-control-down
			 (gams-list-downcase gams-statement-mpsge))))))
    ; Not use mpsge
    (setq gams-dollar-control-alist
	  (gams-statement-to-alist
	   (if gams-dollar-control-upcase
	       gams-dollar-control-up
	     gams-dollar-control-down))))

  ; Font-lock
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(gams-font-lock-keywords t t))

  ; 
  (if (file-exists-p gams-statement-file)
      (load-file gams-statement-file))

  ; Update.
  (gams-statement-update)

  ; Run hook
  (run-hooks 'gams-mode-hook))
;;; gams-mode ends.


(defun gams-statement-to-alist (list)
  "Transform list to alist."
    (let ((list-name list)
	  gams-alist)
      (if (null gams-statement-upcase)
	  (setq list-name (gams-list-downcase list-name))
	nil)
      (while list-name
	(setq gams-alist
	      (cons (list (car list-name)) gams-alist))
	(setq list-name (cdr list-name)))
    gams-alist))

(defun gams-statement-update ()
  "Update gams-statement-alist and gams-dollar-control-alist."
  (interactive)

  ; Update `gams-statement-alist'.
  (setq gams-statement-alist
	(gams-statement-to-alist
	 (append gams-statement-up
		 gams-user-statement-list)))

  ; Update `gams-dollar-control-alist'.
  (setq gams-dollar-control-alist
	(gams-statement-to-alist
	 (if gams-use-mpsge		; If use MPSGE,
	     (append gams-dollar-control-up
		     gams-statement-mpsge		     
		     gams-user-dollar-control-list)
	   (append gams-dollar-control-up
		   gams-user-dollar-control-list)))))


(defun gams-insert-statement ()
  "Insert GAMS statement with completion.
List of candidates is created from elements of `gams-statement-up'
and `gams-user-statement-list'."
  
  (interactive)
  (gams-statement-update)
  (let ((gams-alist gams-statement-alist)
	(completion-ignore-case t)
	statement-name key1)

    (setq statement-name
	  (completing-read "Insert statement: " gams-alist nil nil nil))

    (if gams-statement-upcase
	(setq statement-name (upcase statement-name))
      (setq statement-name (downcase statement-name)))

    ; Register or not?
    (if (null (member (list statement-name) gams-statement-alist))
	(progn
	  (message "Store `%s' for future use?  Type `y' if yes: " statement-name)
	  (setq key1 (read-char))
	  (if (equal key1 ?y)
	      (progn
		(setq statement-name (upcase statement-name))
		(gams-register-statement statement-name))
	    nil))
      nil)

    ; Insert.
    (if gams-statement-upcase
	(setq statement-name (upcase statement-name))
      (setq statement-name (downcase statement-name)))
    (insert-string statement-name)
    ))


(defun gams-register-statement (statement-name)
  ""
  (interactive)
  (let ((file-name gams-statement-file)
	(cur-buff (current-buffer))
	)
    (set-buffer (find-file-noselect file-name))
    (goto-char (point-min))
    (if (re-search-forward "gams-user-statement-list" nil t)
	(progn
	  (next-line 1)
	  (beginning-of-line)
	  (open-line 1)
	  (insert-string
	   (concat (char-to-string 34)
		   (upcase statement-name)
		   (char-to-string 34)))
	  (goto-char (point-min))
	  (eval-buffer))
      (insert-string
       (concat
	"(setq gams-user-statement-list '(\n"
	(char-to-string 34)
	(upcase statement-name)
	(char-to-string 34)
	"\n"
	"))\n")))
    (save-buffer)
    (kill-buffer nil)

    (gams-statement-update)

    (set-buffer cur-buff)
    ))


(defun gams-register-dollar-control (statement-name)
  (interactive)
  (let ((file-name gams-statement-file)
	(cur-buff (current-buffer))
	)
    (set-buffer (find-file-noselect file-name))
    (goto-char (point-min))
    (if (re-search-forward "gams-user-dollar-control-list" nil t)
	(progn
	  (next-line 1)
	  (beginning-of-line)
	  (open-line 1)
	  (insert-string
	   (concat (char-to-string 34)
		   (upcase statement-name)
		   (char-to-string 34)))
	  (goto-char (point-min))
	  (eval-buffer))
      (insert-string
       (concat
	"(setq gams-user-dollar-control-list '(\n"
	(char-to-string 34)
	(upcase statement-name)
	(char-to-string 34)
	"\n"
	"))\n")))
    (save-buffer)
    (kill-buffer nil)

    (gams-statement-update)

    (set-buffer cur-buff)
    ))


(defun gams-insert-dollar-control ()
  "Insert GAMS dollar control option with completion.
List of candidates is created from elements of `gams-dollar-control-up'
and `gams-user-dollar-control-list' (and `gams-statement-mpsge'
if `gams-use-mpsge' is non-nil."
  
  (interactive)
  (gams-statement-update)
  (let ((gams-alist gams-dollar-control-alist)
	(completion-ignore-case t)
	statement-name key1)

    (setq statement-name
	  (completing-read "Insert dollar control option: $" gams-alist nil nil))

    (if gams-dollar-control-upcase
	(setq statement-name (upcase statement-name))
      (setq statement-name (downcase statement-name)))

    (cond
     ((equal statement-name "")
      t)
     ((null (member (list statement-name) gams-dollar-control-alist))
      (progn
	(message "Store `$%s' for future use?  Type `y' if yes: " statement-name)
	(setq key1 (read-char))
	(if (equal key1 ?y)
	      (progn
		(setq statement-name (upcase statement-name))
		(gams-register-dollar-control statement-name))
	  nil)))
     (t))
    (if gams-statement-upcase
	(setq statement-name (upcase statement-name))
      (setq statement-name (downcase statement-name)))
    (insert-string (concat "$" statement-name))
    ))


(defun gams-create-regexp (list-name)
  "Create the regular expression from a list."
  (interactive)
  (let ((list list-name)
	new-list)
    (while list
      (setq new-list (concat "\\|" (car list) new-list))
      (setq list (cdr list)))
    new-list))
  

(defun gams-regexp-update ()
  "Update font lock regular expression for GAMS statement
from `gams-user-statement-list' and `gams-statement-up'" 
  (setq gams-statement-regexp
	(concat
	 "^[ \n\t]*\\(zzz"
; 	 (gams-create-regexp gams-statement-up)
; 	 (gams-create-regexp
; 	  (gams-list-downcase gams-statement-up))
 	 (gams-create-regexp gams-user-statement-list)
 	 (gams-create-regexp
 	  (gams-list-downcase gams-user-statement-list))
	 (gams-create-regexp gams-statement-regexp-default)
	 (gams-create-regexp
	  (gams-list-downcase gams-statement-regexp-default))
	 "\\)\\([ \t\n$(]+\\)"
	 )))


;;; This function is from `font-latex.el'.
(defun gams-statement-regexp-func (limit)
  "Font lock regular expression for GAMS statement"
  (gams-regexp-update)
  (when (re-search-forward
	 gams-statement-regexp limit t)
    (let ((beg (match-beginning 1))
	  (end (match-end 1)))
      (store-match-data (list beg end))
      t)))


(defun gams-get-lst-filename ()
"Return the LST file name correspoing to the current GMS file buffer."
  (let ((file-buffer-gms (buffer-file-name))
	(ext-up (concat "." (upcase gams-lst-extention)))
	(ext-down (concat "." (downcase gams-lst-extention)))
	dir-gms	file-noext file-lst file-gms)

    ; store GMS file name.
    (setq dir-gms (file-name-directory file-buffer-gms))
    (setq file-gms (file-name-nondirectory file-buffer-gms))
    (setq file-noext (file-name-sans-extension file-gms))

    ; search LST file name
    (cond
     ((file-exists-p
       (concat dir-gms file-noext ext-down))
      (setq file-lst (concat dir-gms file-noext ext-down)))
     ((file-exists-p
       (concat dir-gms file-noext ext-up))
      (setq file-lst (concat dir-gms file-noext ext-up)))
     ((file-exists-p
       (concat dir-gms (upcase file-noext) ext-down))
      (setq file-lst (concat dir-gms (upcase file-noext) ext-down)))
     ((file-exists-p
       (concat dir-gms (upcase file-noext) ext-up))
      (setq file-lst (concat dir-gms (upcase file-noext) ext-up)))
     ((file-exists-p
       (concat dir-gms (downcase file-noext) ext-down))
      (setq file-lst (concat dir-gms (downcase file-noext) ext-down)))
     ((file-exists-p
       (concat dir-gms (downcase file-noext) ext-up))
      (setq file-lst (concat dir-gms (downcase file-noext) ext-up)))
     (t
      (message "LST file does not exist!")))
    file-lst))


(defun gams-view-lst ()
  "Switch to the LST file buffer and show the error message if any."
  (interactive)
  (let ((file-lst (gams-get-lst-filename)))

    (if file-lst
	
	; LST file exist.
	(progn
	 (let
	     ((lst-buffer))
	   (if (get-file-buffer file-lst)
	       ; if file-lst is already opened.
	       (progn
		 (save-excursion
		   (set-buffer (get-file-buffer file-lst))
		   (set-buffer-modified-p nil)
		   (kill-buffer (get-file-buffer file-lst))))
	     ; if file-lst isn't opened, do nothing.
	     ))

	 ; open file-lst and switch the buffer.
	 (find-file file-lst)
	 (goto-char (point-min))
	 (gams-lst-mode)

	 ; view error
	 (gams-lst-view-error)
	 )

      ; LST file not exits. 
    (message "The LST file does not exist!")
    )))


(defun gams-jump-to-lst ()
  "Switch to the LST file buffer."
  (interactive)
  (let ((file-lst (gams-get-lst-filename)))
    (if file-lst

	; LST file exists
	(progn
	  ; open lst file in the buffer.
	  (let
	      ((lst-buffer))
	    (if (get-file-buffer file-lst)

	    ;if file-lst is already opened, switch to it.
		(pop-to-buffer (get-file-buffer file-lst))

	  ; if file-lst isn't opened, open it.
	      (find-file file-lst)
	      ))
	  
	  (gams-lst-mode)
	  (recenter))
      
      ; LST file does not exits.
      (message "The LST file does not exist!")
      )))


;;; Comment insertion.
(defun gams-insert-comment ()
  "Insert a comment template defined by `gams-user-comment'."
  (interactive)
  (let ((point-a (point))
	(use-comment gams-user-comment)
	point-b point-c)
    (insert-string gams-user-comment)
    (setq point-b (point))

    (goto-char point-a)
    (if (re-search-forward "%" point-b t)
	(progn
	  (setq point-c (match-beginning 0))
	  (replace-match ""))
      (goto-char point-b))
    ))


;;; From yatex.el
(defun gams-insert-parens (arg)
  "Insert parenthesis pair."
  (interactive "p")
  (if gams-close-paren-always
      (progn
	(insert "()")
	(backward-char 1))
    (insert "(")))

(defun gams-insert-double-quotation (arg)
  "Insert double quotation pair."
  (interactive "p")
  (if gams-close-double-quotation-always
      (progn
	(insert "\"\"")
	(backward-char 1))
    (insert "\"")))

(defun gams-insert-single-quotation (arg)
  "Insert single quotation pair."
  (interactive "p")
  (if gams-close-single-quotation-always
      (progn
	(insert "`'")
	(backward-char 1))
    (insert "`")))


;;; Fill paragraph function.  This is from `lisp-mode.el'.  I just changed
;;; ";" in the original function to "\\(*\\)".  This function is likely
;;; not to work well in many cases.

(defun gams-fill-paragraph (&optional justify)
  "Like \\[fill-paragraph], but handle GAMS comment.
If any of the current line is a comment, fill the comment or the
paragraph of it that point is in, preserving the comment's indentation
and initial semicolons."
  (interactive "P")
  (let (
	;; Non-nil if the current line contains a comment.
	has-comment

	;; Non-nil if the current line contains code and a comment.
	has-code-and-comment

	;; If has-comment, the appropriate fill-prefix for the comment.
	comment-fill-prefix
	)

    ;; Figure out what kind of comment we are looking at.
    (save-excursion
      (beginning-of-line)
      (cond

       ;; A line with nothing but a comment on it?
       ((looking-at "[ \t]*\\(*\\)[\\(*\\) \t]*")
	(setq has-comment t
	      comment-fill-prefix (buffer-substring (match-beginning 0)
						    (match-end 0))))

       ;; A line with some code, followed by a comment?  Remember that the
       ;; semi which starts the comment shouldn't be part of a string or
       ;; character.
       ((condition-case nil
	    (save-restriction
	      (narrow-to-region (point-min)
				(save-excursion (end-of-line) (point)))
	      (while (not (looking-at "\\(*\\)\\|$"))
		(skip-chars-forward "^\\(*\\)\n\"\\\\?")
		(cond
		 ((eq (char-after (point)) ?\\) (forward-char 2))
		 ((memq (char-after (point)) '(?\" ??)) (forward-sexp 1))))
	      (looking-at "\\(*\\)+[\t ]*"))
	  (error nil))
	(setq has-comment t has-code-and-comment t)
	(setq comment-fill-prefix
	      (concat (make-string (/ (current-column) 8) ?\t)
		      (make-string (% (current-column) 8) ?\ )
		      (buffer-substring (match-beginning 0) (match-end 0)))))))

    (if (not has-comment)
        ;; `paragraph-start' is set here (not in the buffer-local
        ;; variable so that `forward-paragraph' et al work as
        ;; expected) so that filling (doc) strings works sensibly.
        ;; Adding the opening paren to avoid the following sexp being
        ;; filled means that sexps generally aren't filled as normal
        ;; text, which is probably sensible.  The `;' and `:' stop the
        ;; filled para at following comment lines and keywords
        ;; (typically in `defcustom').
	(let ((paragraph-start (concat paragraph-start
                                       "\\|\\s-*[\(\\(*\\):\"]")))
          (fill-paragraph justify))

      ;; Narrow to include only the comment, and then fill the region.
      (save-excursion
	(save-restriction
	  (beginning-of-line)
	  (narrow-to-region
	   ;; Find the first line we should include in the region to fill.
	   (save-excursion
	     (while (and (zerop (forward-line -1))
			 (looking-at "^[ \t]*\\(*\\)")))
	     ;; We may have gone too far.  Go forward again.
	     (or (looking-at ".*\\(*\\)")
		 (forward-line 1))
	     (point))
	   ;; Find the beginning of the first line past the region to fill.
	   (save-excursion
	     (while (progn (forward-line 1)
			   (looking-at "^[ \t]*\\(*\\)")))
	     (point)))

	  ;; Lines with only semicolons on them can be paragraph boundaries.
	  (let* ((paragraph-start (concat paragraph-start "\\|[ \t\\(*\\)]*$"))
		 (paragraph-separate (concat paragraph-start "\\|[ \t\\(*\\)]*$"))
		 (paragraph-ignore-fill-prefix nil)
		 (fill-prefix comment-fill-prefix)
		 (after-line (if has-code-and-comment
				 (save-excursion
				   (forward-line 1) (point))))
		 (end (progn
			(forward-paragraph)
			(or (bolp) (newline 1))
			(point)))
		 ;; If this comment starts on a line with code,
		 ;; include that like in the filling.
		 (beg (progn (backward-paragraph)
			     (if (eq (point) after-line)
				 (forward-line -1))
			     (point))))
	    (fill-region-as-paragraph beg end
				      justify nil
				      (save-excursion
					(goto-char beg)
					(if (looking-at fill-prefix)
					    nil
					  (re-search-forward comment-start-skip)
					  (point))))))))
    t))


;;; Process handling.

;;; Most of the codes for process handling are from epo.el ,epolib.el,
;;; epop.el in `EPO' package written by Yuuji Hirose.  I modified them
;;; slightly.

;;; From epolib.el
(defun gams*window-list ()
  (let*((curw (selected-window)) (win curw) (wlist (list curw)))
    (while (not (eq curw (setq win (next-window win))))
      (or (eq win (minibuffer-window))
	  (setq wlist (cons win wlist))))
    wlist))

(defun gams*smart-split-window (height)
  "Split current window wight specified HEIGHT.
If HEIGHT is number, make a new window that has HEIGHT lines.
If HEIGHT is string, make a new window that occupies HEIGT % of screen height.
Otherwise split window conventionally."
  (if (one-window-p t)
      (split-window
       (selected-window)
       (max
        (min
         (- (gams*screen-height)
            (if (numberp height)
                (+ height 2)
              (/ (* (gams*screen-height)
                    (string-to-int height))
                 100)))
         (- (gams*screen-height) window-min-height 1))
        window-min-height))))

(defun gams*showup-buffer (buffer &optional select)
  "Make BUFFER show up in certain window (except selected window).
Non-nil for optional argument SELECT keeps selection to the target window."
  (let (w)
    (or
     ;;if already visible
     (if gams:frame-feature-p
	 (if (setq w (get-buffer-window buffer t))
	     (if select
		 (progn
		   (raise-frame (select-frame (window-frame w)))
		   (set-mouse-position (selected-frame) 0 -1))
	       w))
       ;;no frames
       (if (setq w (get-buffer-window buffer))
	   (if select (select-window w) w)))
     ;;not visible
     (let ((sw (selected-window))
	   (wlist (gams*window-list)))
       (cond
	((eq (current-buffer) (get-buffer buffer)) nil)
	((one-window-p)
	 (gams*smart-split-window gams-default-pop-window-height)
	 (select-window (next-window nil 1))
	 (switch-to-buffer (get-buffer-create buffer)))
	((= (length wlist) 2)
	 (select-window (get-lru-window))
	 (switch-to-buffer (get-buffer-create buffer)))
	(t   ;more than 2windows
	 (select-window (next-window nil 1))
	 (switch-to-buffer (get-buffer-create buffer))))
       (or select (select-window sw))))))


;;; From epop.el
(defun gams*process-sentinel (proc mess)
  "Display the end of process buffer."
  (cond
   ((memq (process-status proc) '(signal exit))
    (save-excursion
      (let ((sw (selected-window)) w)
	(set-buffer (process-buffer proc))
	(goto-char (point-max))
	(insert
	 (format "\nProcess %s finished at %s" proc (current-time-string)))
	(cond
	 ((and gams:frame-feature-p
	       (setq w (get-buffer-window (current-buffer) t)))
	  (select-frame (window-frame w))
	  (select-window w)
	  (goto-char (point-max))
	  (recenter -1))
	 ((setq w (get-buffer-window (current-buffer)))
	  (select-window w)
	  (goto-char (point-max))
	  (recenter -1)))
	(select-window sw))
      (message "done")))))


(defun gams*start-process-other-window (name commandline)
  "Start command line (via shell) in the next window."
  (let (
;	(b (get-buffer-create "*Running GAMS*"))
	(sw (selected-window)) p
	(dir default-directory))
;    (set (make-local-variable 'gams:current-process-buffer) b)
    (get-buffer-create gams*command-process-buffer)
    (gams*showup-buffer gams*command-process-buffer t) ;popup buffer and select it.
    (kill-all-local-variables)
    (erase-buffer)
    (cd dir)
    (setq default-directory dir)
    (insert commandline "\n ")
    (set (make-local-variable 'gams:process-command-name) name)
    (set-process-sentinel
     (setq p (start-process
	      name
	      gams*command-process-buffer
	      shell-file-name
	      gams:shell-c commandline))
     'gams*process-sentinel)
    (set-marker (process-mark p) (1- (point)))
    (setq major-mode 'gams-process-mode)
;    (use-local-map gams-process-mode-map)
    (select-window sw)))


(defun gams*get-builtin (keyword)
  "Get built-in string specified by KEYWORD in current buffer."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (if (search-forward
	   (concat
	    comment-start	   ;buffer local variable in any buffer
	    keyword) nil t)
	  (let ((peol (progn (end-of-line) (point))))
	    (gams*buffer-substring
	     (progn
	       (goto-char (match-end 0))
	       (skip-chars-forward " \t")
	       (point))
	     (if (and comment-end
		      (stringp comment-end)
		      (string< "" comment-end)
		      (re-search-forward
		       (concat (regexp-quote comment-end)
			       "\\|$")
		       peol 1))
		 (match-beginning 0)
	       peol)))))))

(defun gams*update-builtin (keyword newdef)
  "Update built-in KEYWORD to NEWDEF"
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (if (search-forward (concat comment-start keyword) nil t)
	  (let ((peol (progn (end-of-line) (point))))
	    (goto-char (match-end 0))
	    (skip-chars-forward " \t")
	    (delete-region
	     (point)
	     (if (and comment-end (stringp comment-end)
		      (string< "" comment-end)
		      (search-forward comment-end peol t))
		 (progn (goto-char (match-beginning 0)) (point))
	       peol))
	    (insert newdef))
	(while (and (progn (skip-chars-forward " \t")
			   (looking-at (regexp-quote comment-start)))
		    (not (eobp)))
	  (forward-line 1))
	(open-line 1)
	(insert comment-start keyword newdef comment-end)))))

(defun gams*start-processor (&optional ask)
  "Start GAMS on the current file."
  (let*(
	prompt
	(builtin "#!")
	(command "compile")
	arg
	string
	newarg
	)
    (setq arg
	  (or
	   ;; if built-in processor specified, use it
	   (and builtin (gams*get-builtin builtin))

	   (concat gams:process-command-name
		   " "
		   (file-name-nondirectory buffer-file-name)
		   " "
		   gams:process-command-option)))
    (basic-save-buffer)
    ;(setq arg (concat command " " arg))
    (gams*start-process-other-window
     command
     (cond
      (prompt
       (read-string "Execute: " arg))
      (ask
       (setq newarg (read-string "Edit statement if you want:  " arg))
       (if (and builtin
		(not (string= newarg arg))
		(y-or-n-p "Use this statement also in the future? "))
	   (gams*update-builtin builtin newarg))
       newarg)
      (t arg)))))

(defun gams*kill-processor ()
  "Stop (kill) GAMS process."
  (let*((b gams*command-process-buffer)
	p)
    (setq p (get-buffer-process (set-buffer b)))
    (if t
;	(and p (memq process-status '(run)))
	(progn
	  (interrupt-process p)
	  ;; Should I watch the process status?
	  )
      (message "Process %s already exited."))))


(defun gams-start-menu (&optional ask)
  "Process starting menu.
"
  (interactive "P")
  (let ((mess
	 (format "Start GAMS (%c) or Kill GAMS process (%c): "
		 gams-run-key
		 gams-kill-key))
	c)
    (message "%s" mess)
    (setq c (read-char))
    (cond
     ((equal c gams-run-key)
      (gams*start-processor ask))
     ((equal c gams-kill-key)
      (gams*kill-processor))
     (t
      (message "No such choice `%c'" c)))))


;;;	From yatex.el

;;; autoload
(defun substitute-all-key-definition (olddef newdef keymap)
  "Replace recursively OLDDEF with NEWDEF for any keys in KEYMAP now
defined as OLDDEF. In other words, OLDDEF is replaced with NEWDEF
where ever it appears."
    (mapcar
     (function (lambda (key) (define-key keymap key newdef)))
     (where-is-internal olddef keymap)))
;;-------------------- Final hook jobs --------------------
(substitute-all-key-definition
 'fill-paragraph 'gams-fill-paragraph gams-mode-map)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;	Code for GAMS-LST mode.
;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar gams-lst-mode-hook  nil
  "*GAMS mode hooks.")

(defvar gams-lst-gms-extention  "gms"
  "*GAMS program file extention.")

(defvar gams-lst-font-lock-keywords
  '(
    ("^\\*\\*\\*\\*[^\n]+" . font-lock-warning-face)
    ))

; key assignment.
(defvar gams-lst-mode-map (make-keymap) "Keymap for gams-lst-mode")
(let ((map gams-lst-mode-map))
;  (define-key map "" 'gams-lst-insert-statements)
  (define-key map "e" 'gams-lst-view-error)
  (define-key map "g" 'gams-lst-view-gms)
  (define-key map "j" 'gams-lst-jump-to-gms)  
  (define-key map "k" 'gams-lst-jump-to-gms-2)  
  (define-key map "s" 'gams-lst-solve-summary)
  (define-key map "r" 'gams-lst-report-summary)    
  (define-key map "S" 'gams-lst-solve-summary-back)
  (define-key map "R" 'gams-lst-report-summary-back)    
  (define-key map "l" 'gams-lst-query-jump-to-line)    
  (define-key map "L" 'gams-lst-jump-to-line)    
  (define-key map "1" 'gams-lst-widen-window)    
  (define-key map "2" 'gams-lst-split-window)
  (define-key map "m" 'gams-lst-move-frame)    
  (define-key map "f" 'gams-lst-resize-frame)    
  (define-key map "v" 'gams-lst-next-variable)    
  (define-key map "V" 'gams-lst-previous-variable)    
  (define-key map "a" 'gams-lst-next-equation)    
  (define-key map "A" 'gams-lst-previous-equation)    
  (define-key map "p" 'gams-lst-next-parameter)    
  (define-key map "P" 'gams-lst-previous-parameter)    
  (define-key map "q" 'gams-lst-kill-buffer)    
  (define-key map "?" 'gams-lst-help)    
  (define-key map " " 'gams-lst-scroll-up)    
  (define-key map [delete] 'gams-lst-scroll-down)    
  )

; '\\[gams-lst-solve-summary]' - Jump to the next SOLVER SUMMARY.
; '\\[gams-lst-solve-summary-back]' - Jump to the previous SOLVER SUMMARY.
; '\\[gams-lst-report-summary]' - Jump to the next REPORT SUMMARY.
; '\\[gams-lst-report-summary-back]' - Jump to the previous REPORT SUMMARY.
; '\\[gams-lst-next-variable]' - Jump to the next VAR entry.
; '\\[gams-lst-previous-variable]' - Jump to the previous VAR entry.
; '\\[gams-lst-next-equation]' - Jump to the next EQU entry.
; '\\[gams-lst-previous-equation]' - Jump to the previous EQU entry.
; '\\[gams-lst-next-parameter]' - Jump to the next PARAMETER entry.
; '\\[gams-lst-previous-parameter]' - Jump to the previous PARAMETER entry.

(defun gams-lst-mode ()
  "Major mode for viewing gams LST file. 

The following commands are available in the GAMS-LST mode:

'\\[gams-lst-view-error]' - Jump to the error and show its number and meaning.
'\\[gams-lst-view-gms]' - Jump back to the error place in the GMS file.
'\\[gams-lst-jump-to-gms]  - Jump to the GMS file.
'\\[gams-lst-jump-to-gms-2]  - Jump to the GMS file.
'\\[gams-lst-kill-buffer]' - Close the buffer.
'\\[gams-lst-help]' - Display this help.

'\\[gams-lst-solve-summary](\\[gams-lst-solve-summary-back])' - Jump to the next (previous) SOLVER SUMMARY.
'\\[gams-lst-report-summary](\\[gams-lst-report-summary-back])' - Jump to the next (previous) REPORT SUMMARY.
'\\[gams-lst-next-variable](\\[gams-lst-previous-variable])' - Jump to the next (previous) VAR entry.
'\\[gams-lst-next-equation](\\[gams-lst-previous-equation])' - Jump to the next (previous) EQU entry.
'\\[gams-lst-next-parameter](\\[gams-lst-previous-parameter])' - Jump to the next (previous) PARAMETER entry.

'\\[gams-lst-query-jump-to-line]' - Jump to a line you specify.
'\\[gams-lst-jump-to-line]' - Jump to a line.

'\\[gams-lst-scroll-up]' - Scroll up.
'\\[gams-lst-scroll-down]' - Scroll down.
'\\[gams-lst-widen-window]' - Widen the window.
'\\[gams-lst-split-window]' - Split the window.
'\\[gams-lst-move-frame]' - Move frame.
'\\[gams-lst-resize-frame]' - Resize frame.

"
  (interactive)
  (setq major-mode 'gams-lst-mode)
  (setq mode-name "GAMS-LST")
  (use-local-map gams-lst-mode-map)
;  (easy-menu-add todo-menu)
;  (outline-minor-mode 1)
;  (hide-other)
  (setq buffer-read-only t) ;make the buffer read-only.
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(gams-lst-font-lock-keywords t nil))
  (font-lock-fontify-buffer)
  (run-hooks 'gams-lst-mode-hook))

(defun gams-lst-help ()
  "Display help for GAMS-LST mode"
  (interactive)    
  (describe-function 'gams-lst-mode))

(defun gams-lst-kill-buffer ()
  "Close the LST buffer"
  (interactive)    
  (kill-buffer nil))

(defun gams-lst-view-error ()
  "Move to the error place.
 and show its meaning in another window if error number is displayed.
"
  (interactive)
  (goto-char (point-min))
  (let (error-num error-place error-mes-place)

    ; First search syntax error. 
    (if (re-search-forward "\\*\\*\\*\\* [ ]+\\$\\([0-9]+\\)[$]?" nil
			   t)
	(progn
	  (goto-char (match-beginning 1))
	  (setq error-place (point))
	  ; set `error-num' the found error number. It is nil if no error.
	  (setq error-num
		(buffer-substring
		 (match-beginning 1)
		 (match-end 1)))
	  (message "If you want to jump to the error place in GMS file, push `g'.")
	  (if error-num
	      (progn
		(if (null (re-search-forward "Error Messages" nil t))
		    (message "cannot find `Error Messages'!")
		  (setq error-mes-place
			(re-search-forward error-num nil t))))
	    ; if error-num is nil, go to the top of the buffer.
	    (goto-char (point-min)))

	  ; Display syntax error message.
	  (if error-mes-place
	      (progn
		(delete-other-windows)
		(split-window)
		(goto-char error-place)
		(recenter)
		(other-window 1)
		(goto-char error-mes-place)
		(recenter 0)
		(other-window 1))))

      ; Search another type of errors.
      (if (catch 'found
	    (while (re-search-forward "\\*\\*\\*\\* " nil t)
	      (progn
		(beginning-of-line)
		(setq a-point (point))
		(end-of-line)
		(setq b-point (point))
		(goto-char a-point)

		; The following lines are not regarded as errors and
		; skipped.  Is this right behavior?
		(if (not (or (re-search-forward "\\*\\*\\*\\* SOLVER STATUS"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* MODEL STATUS"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* REPORT SUMMARY"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* REPORT FILE SUMMARY"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* LIST OF STRAY NAMES"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* STRAY NAME "
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* FILE SUMMARY"
					    b-point t)
			     (re-search-forward "\\*\\*\\*\\* OBJECTIVE VALUE"
					    b-point t)))
		    (throw 'found t)
		  (next-line 1)))))
	  (progn
	    (goto-char (match-beginning 0))
	    (message "Error is found!"))

	; When no error is found.
	(progn
	  (message "No error message is found!")
	  (goto-char (point-min)))
	))))


(defun gams-lst-jump-to-error ()
  "Jump to the error place."
  (interactive)
  (let ((current-point (point)))
    (goto-char (point-min))
    (if	(re-search-forward "\\*\\*\\*\\* [ ]+\\$\\([0-9]+\\)[$]?" nil
			   t)
	(progn
	  (goto-char (match-beginning 1))
	  (beginning-of-line))
      (progn
	(goto-char current-point)
	(message "No error is found!")))))


(defun gams-lst-get-gms-filename ()
  "Get the GMS file name associated to the current LST file

This function assumes that GMS file has a extention gms or GMS
and that GMS file exists in the current directory.
"
  (let ((file-buffer-lst (buffer-file-name))
	(ext-up (concat "." (upcase gams-lst-gms-extention)))
	(ext-down (concat "." (downcase gams-lst-gms-extention)))
	dir-lst file-noext file-gms file-lst)
    
    ; Store LST file name.
    (setq dir-lst (file-name-directory file-buffer-lst))
    (setq file-lst (file-name-nondirectory file-buffer-lst))
    (setq file-noext (file-name-sans-extension file-lst))

    ; Search GMS file name.  GMS file name is stored in file-gms.
    (cond
     ((file-exists-p
       (concat dir-lst file-noext ext-down))
      (setq file-gms (concat dir-lst file-noext ext-down)))
     ((file-exists-p
       (concat dir-lst file-noext ext-up))
      (setq file-gms (concat dir-lst file-noext ext-up)))
     ((file-exists-p
       (concat dir-lst (upcase file-noext) ext-down))
      (setq file-gms (concat dir-lst (upcase file-noext) ext-down)))
     ((file-exists-p
       (concat dir-lst (upcase file-noext) ext-up))
      (setq file-gms (concat dir-lst (upcase file-noext) ext-up)))
     ((file-exists-p
       (concat dir-lst (downcase file-noext) ext-down))
      (setq file-gms (concat dir-lst (downcase file-noext) ext-down)))
     ((file-exists-p
       (concat dir-lst (downcase file-noext) ext-up))
      (setq file-gms (concat dir-lst (downcase file-noext) ext-up)))
     (t
      (message "GMS file does not exist!")))
    file-gms))


(defun gams-lst-save-string ()
  ""
  (let ((times 2)
	(check 0)
	(current-buffer (buffer-name))
	(work-buffer (get-buffer-create "*temp*")) ; Create temporary buffer
	point-beg point-end list-string string
	a-point b-point)
    
	; save string in list-string
	(while (and (> times 0) (< check 50))
	  (forward-line -1)
	  (beginning-of-line)
	  (setq point-beg (point))
	  (end-of-line)
	  (setq point-end (point))
	  (goto-char point-beg)
	  (if (re-search-forward "^[ ]*[0-9]+  " point-end t)
	      (progn
		(setq list-string
		      (cons
		       (if (equal
			    (buffer-substring (match-end 0) point-end) " ")
			   ;if t, return "" not " ".
			   ""
			 ; if nil, return the matched.
			 (buffer-substring (match-end 0) point-end))
		       list-string))
		(setq times (- times 1)))
	    (setq check (+ check 1))
	    ))
	;
	(setq string
	      (concat
	       (car list-string) "\n"
	       (car (cdr list-string)) "\n"
	       (car (cdr (cdr list-string)))))

	; Switch to the temporary buffer.
	(set-buffer work-buffer)
	(insert string)
	(goto-char (point-min))

	; Replace several strings with regular expression.
	(goto-char (point-min))
	(while (re-search-forward "\\(\\\\\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[\\\\]"))
	(goto-char (point-min))
	(while (re-search-forward "\\(\\+\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[\+]"))
	(goto-char (point-min))
	(while (re-search-forward "\\(\\?\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[\?]"))
	(goto-char (point-min))
	(while (re-search-forward "\\([ ]+\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[ \t]+"))
	(goto-char (point-min))
	(while (re-search-forward "\\(\\.\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "\."))
	(goto-char (point-min))     
	(while (re-search-forward "\\(\\$\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "\$"))
	(goto-char (point-min))
	(while (re-search-forward "\\(\\*\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[\*]"))
	(goto-char (point-min))
	(while (re-search-forward "\\(\n\\)" nil t)
	  (setq a-point (match-beginning 1))
	  (setq b-point (match-end 1))
	  (replace-match "[ \t]*\n"))

	; Store regular expression to string.
	(setq string (buffer-substring (point-min) (point-max)))
	(insert string)
	(switch-to-buffer current-buffer)

	; Delete temporary buffer.
	(kill-buffer work-buffer)
	; Return the content of string.
	string))


(defun gams-lst-view-gms()
  "Jump back to the error place in the GMS file.

NB: It may not work properly.  It is difficult to implement this function
perfectly...
"
  (interactive)
  (let ((file-gms (gams-lst-get-gms-filename))
	string)
    
    ; Jump to the error place.
    (gams-lst-jump-to-error)

    ; Save the string around error place.
    (setq string (gams-lst-save-string))

    ; open GMS file.
    (if (get-file-buffer file-gms)
	(switch-to-buffer (get-file-buffer file-gms))
      (find-file file-gms))

    (goto-char (point-min))

    ; Search the error place.
    (if (re-search-forward string nil t)
	(progn
	  (recenter)
	  (beginning-of-line))
      (message "Error place is not found!"))
    ))


(defun gams-lst-jump-to-gms ()
  "Switch to the GMS file buffer."
  (interactive)
  (let ((file-gms (gams-lst-get-gms-filename)))
    ;
    ; open lst file in the buffer.
    (if (get-file-buffer file-gms)
	(switch-to-buffer (get-file-buffer file-gms))
      (find-file file-gms))

    (recenter)
    ))

(defun gams-lst-jump-to-gms-2()
  "Jump back to the error place in the GMS file.

"
  (interactive)
  (let ((file-gms (gams-lst-get-gms-filename))
	string point-here)
    
    ; Save the string around error place.
    (setq string (gams-lst-save-string))

    ; open GMS file.
    (if (get-file-buffer file-gms)
	(switch-to-buffer (get-file-buffer file-gms))
      (find-file file-gms))

    (setq point-here (point))

    (goto-char (point-min))

    ; Search.
    (if (re-search-forward string nil t)
	(progn
	  (recenter)
	  (beginning-of-line))
      (goto-char point-here)
    )))
  


(defun gams-lst-solve-summary ()
  "Jump to the next SOLVE SUMMARY"
  (interactive)
  (end-of-line)
  (if (re-search-forward "S O L V E      S U M M A R Y" nil t)
      (progn
	(message "The next SOLVE SUMMARY")
	(recenter)
	(beginning-of-line))
    (message "No more `S O L V E      S U M M A R Y'"))
  )

(defun gams-lst-solve-summary-back ()
  "Jump to the previous SOLVE SUMMARY"
  (interactive)
  (if (re-search-backward "S O L V E      S U M M A R Y" nil t)
      (progn
	(message "The previous SOLVE SUMMARY")
	(recenter)
	(beginning-of-line)))
  )

(defun gams-lst-report-summary ()
  "Jump to the next REPORT SUMMARY"  
  (interactive)
  (end-of-line)
  (if (re-search-forward "\\*\\*\\*\\* REPORT SUMMARY" nil t)
      (progn
	(recenter)
	(beginning-of-line))
    (message "No more `REPORT SUMMARY'"))
  )

(defun gams-lst-report-summary-back ()
  "Jump to the previous REPORT SUMMARY"
  (interactive)
  (if (re-search-backward "\\*\\*\\*\\* REPORT SUMMARY" nil t)
      (progn
	(recenter)
	(beginning-of-line)))
  )

(defun gams-lst-next-variable ()
  "Jump to the next VAR entry"
  (interactive)
  (end-of-line)
  (if (re-search-forward "^---- VAR " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more VAR entry")
    ))

(defun gams-lst-previous-variable ()
  "Jump to the previous VAR entry"
  (interactive)
  (if (re-search-backward "^---- VAR " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more VAR entry")
    ))

(defun gams-lst-next-equation ()
  "Jump to the next EQU entry"  
  (interactive)
  (end-of-line)
  (if (re-search-forward "^---- EQU " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more EQU entry!")
    ))

(defun gams-lst-previous-equation ()
  "Jump to the next EQU entry"  
  (interactive)
  (if (re-search-backward "^---- EQU " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more EQU entry!")
    ))

(defun gams-lst-next-parameter ()
  "Jump to the next PARAMETER entry"  
  (interactive)
  (end-of-line)
  (if (re-search-forward "[0-9]+ PARAMETER " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more PARAMETER entry!")
    ))

(defun gams-lst-previous-parameter ()
  "Jump to the next PARAMETER entry"  
  (interactive)
  (if (re-search-backward "[0-9]+ PARAMETER " nil t)
      (progn
	(beginning-of-line)
	(recenter))
    (message "No more PARAMETER entry!")
    ))

(defun gams-lst-widen-window ()
  "Make the window fill its frame.  Same as `delete-other-window'."  
  (interactive)
  (delete-other-windows)
  (recenter)
  (message "Winden window.")
  )

(defun gams-lst-split-window ()
  "Split current window into two windows.  Same as `split-window-vertically'."  
  (interactive)
  (split-window-vertically)  
  (recenter)
  (message "Split window."))


(defun gams-lst-query-jump-to-line (line-num)
  "Jump to the line you specify."
  (interactive "sInput line number: ")
  (let (temp-num)
    (setq temp-num
	  (concat "^[ ]*" line-num))
    (goto-char (point-min))
    (re-search-forward temp-num nil t)
    (beginning-of-line)    
    ))

(defun gams-lst-jump-to-line ()
  "Jump to the line indicated by the number you are on.

If you execute this command on a line like

**** Exec Error 0 at line 32 .. Division by zero

you can jump to line 32.
"
  (interactive)
  (let (line-num)
    ;	Get the line number.
    (beginning-of-line)
    (re-search-forward "at line \\([0-9]+\\)" nil t)
    (setq line-num
	  (concat "^[ ]*"
		  (buffer-substring
		   (match-beginning 1)
		   (match-end 1))))
    ;	Go to the beginning of the buffer
    (goto-char (point-min))
    ;	Search line.
    (re-search-forward line-num nil t)
    (beginning-of-line)
    (message "If you want to jump to the GMS file, push `k'.")
    ))

(defun gams-lst-scroll-up ()
  "Scroll up in the LST buffer."
  (interactive)
  (message "Scrol up.")
  (scroll-up))

(defun gams-lst-scroll-down ()
  "Scroll down in the LST buffer."
  (interactive)
  (message "Scrol down.")  
  (scroll-down))


;; From the emasc lisp book written by Yuuji Hirose.
(defun gams-lst-resize-frame ()
  "Resize frame by keyboard.

n - Widen vertically
p - Narrow vertically
f - Widen horizontally
b - Narrow horizontally
Any other key - quit

To put Control key simultaneously makes movement faster.
"
  (interactive)
  (let (key
	(width (frame-width))
	(height (frame-height)))
    (catch 'quit
      (while t
	(message "Resize frame by [(C-)npfb] (%dx%d): " width height)
	(setq key (read-char))
	(cond
	 ((eq key ?n) (setq height (+ 1 height)))
	 ((eq key 14) (setq height (+ 5 height)))
	 ((eq key ?p) (setq height (- height 1)))
	 ((eq key 16) (setq height (- height 5)))
	 ((eq key ?f) (setq width (+ 1 width)))
	 ((eq key 6) (setq width (+ 5 width)))
	 ((eq key ?b) (setq width (- width 1)))
	 ((eq key 2) (setq width (- width 5)))
	 (t (throw 'quit t)))
	(modify-frame-parameters
	 nil (list (cons 'width width) (cons 'height height)))))
    (message "End...")))


;;; From the emacs lisp book written by Yuuji Hirose.
(defun gams-lst-move-frame ()
  "Move frame by keyboard.

n - Move upward
p - Move downward
f - Move rightward
b - Move leftward
Any other key - quit

To put Control key simultaneously makes movement faster.
"
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
;	      (message "Can't move upward anymore!")
	      (setq top 5)))
	(if (and (or (eq key ?b) (eq key 2)) (<= left 5))
	    (progn
;	      (message "Can't move left anymore!")
	      (setq left 5)))
	(modify-frame-parameters
	 nil (list (cons 'top top) (cons 'left left )))))
    (message "End...")))

;;;

(provide 'gams)

;;; GAMS.EL ends here
;Local variables:
;mode: emacs-lisp
;syntax: elisp
;End:
