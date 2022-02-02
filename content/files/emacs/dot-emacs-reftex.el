;;; Settings for reftex.
;
;  Copy and paste the content of this file into `~/.emacs' file.
;
;  Type M-x reftex RET in the LaTeX (or YaTeX) mode.
;
;  C-c[  ---  Citation.
;  C-c(  ---  Label.
;  C-c)  ---  Reference.
;

; If you use AUC-TeX.
(add-hook 'LaTeX-mode-hook
	  '(lambda ()
	     (require 'reftex)
	     (reftex-mode)
	     ))

; If you use YaTeX.
; (add-hook 'yatex-mode-hook
; 	  '(lambda ()
; 	     (require 'reftex)
;	     (reftex-mode)
; 	     ))

(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
;(setq reftex-cite-format 'harvard) ; if you use harvard.sty
(setq reftex-cite-format 'natbib) ; if you use natbib.sty
;(setq reftex-bib-path "~/TeX/")
