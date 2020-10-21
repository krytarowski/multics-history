;;; BEGIN INCLUDE FILE e-macros.incl.lisp

;;; Declares for use by Emacs programs and extenstions.  Also loads
;;; in e_macros_, which contains macro definitions.

;;; HISTORY COMMENTS:
;;;  1) change(85-01-01,Margolin), approve(86-02-24,MCR7186),
;;;     audit(86-08-12,Harvey), install(86-08-20,MR12.0-1136):
;;;     Written: New Year's Day 1985, by excerpting the old e-macros.incl.lisp
;;;     and leaving out all the definitions and qwerty junk (don't ask).
;;;  2) change(86-02-24,Margolin), approve(86-02-24,MCR7325),
;;;     audit(86-08-12,Harvey), install(86-08-20,MR12.0-1136):
;;;     Alphabetized declarations, and added more declarations for documented
;;;     functions, and also for some undocumented functions.
;;;                                                      END HISTORY COMMENTS

(%include backquote)

(declare					;basic editor stuff
  (*expr apply-catenate
         assert-minor-mode backward-char backward-n-chars charlisten
         charset-member command-abort command-quit
         copy-region cur-hpos curline-as-string curbuf-as-string curchar
         curline-as-string delete-char delete-word destroy-buffer-contents
         dont-notice-modified-buffer e_cline_ e_lap_$reverse-search-string
         e_lap_$trim empty-buffer-p error_table_ establish-local-var
         exchange-point-and-mark firstlinep forward-char forward-n-chars
         forward-regexp-search-in-line forward-search forward-search-in-line
         get-char get-search-string go-to-beginning-of-buffer
         go-to-beginning-of-line go-to-buffer go-to-end-of-buffer
         go-to-end-of-line go-to-hpos go-to-mark go-to-or-create-buffer
         insert-char insert-string kill-backwards-to-mark kill-forward-to-mark
         kill-pop kill-to-end-of-line killsave-string lastlinep loadfile
         looking-at lowercase map-over-emacs-commands mark-on-current-line-p
         mark-reached merge-kills-forward merge-kills-reverse move-mark
         minibuf-response minibuffer-clear
         negate-minor-mode new-line next-line nullstringp pathname_
         pathname_$component point-mark-to-string
         point>markp prev-line printable process-char produce-named-mark-list
         read-in-file release-mark reverse-search
         register-local-var reverse-search-in-line
         search-back-first-charset-line
         search-back-first-not-charset-line search-failure-annunciator
         search-for-first-charset-line search-for-first-not-charset-line
         set-emacs-epilogue-handler set-buffer-self-destruct set-key
         set-mark-here set-mark set-perm-key set-the-mark set-the-mark-here
         skip-to-whitespace skip-to-whitespace-in-line
         wipe-point-mark wipe-region write-out-file
         trim-minibuf-response yesp yank)
  (*fexpr define-autoload-lib))

(declare					;redisplay stuff
  (*expr end-local-displays init-local-displays ring-tty-bell
         local-display-generator local-display-generator-nnl
         next-screen prev-screen local-display-current-line
         find-buffer-in-window select-buffer-window window-info
         select-buffer-find-window select-other-window select-window
         buffer-on-display-in-window redisplay full-redisplay))

(declare					;extended stuff
  (*expr forward-word backward-word skip-over-whitespace skip-back-whitespace
         skip-over-whitespace-in-line skip-back-whitespace-in-line
         skip-back-to-whitespace skip-to-whitespace rubout-char date
         display-buffer-as-printout delete-white-sides lefthand-char
         format-to-col whitespace-to-hpos line-is-blank decimal-rep
         register-option minibuffer-clear))

(declare (*lexpr display-error display-com-error display-error-noabort
	       display-error-remark comout-get-output
	       display-com-error-noabort minibuffer-print
	       minibuffer-response trim-minibuffer-response
	       intern-minibuffer-response minibuffer-remark
	       minibuffer-print-noclear report-error report-error-noabort))

(declare (special TAB NL SPACE ESC curpointpos current-buffer dont-stash
	        numarg der-wahrer-mark fpathname fill-column completion-list
	        curlinel BACKSPACE read-only-flag buffer-modified-flag
	        previous-buffer current-buffer-mode env-dir process-dir
	        minibuffer-end-string NLCHARSTRING undo null-pointer))

;;; Load in macro packages
(eval-when (eval compile)
  (or (status feature e-defcom)
      (progn (load (catenate (car (namelist (truename infile))) ">e_define_command_"))
	   (sstatus feature e-defcom)))
  (or (status feature e-macros)
      (load (catenate (car (namelist (truename infile))) ">e_macros_"))))

;;; END INCLUDE FILE e-macros.incl.lisp
;;
;;
;;
;;                                          -----------------------------------------------------------
;;
;;
;; Historical Background
;;
;; This edition of the Multics software materials and documentation is provided and donated
;; to Massachusetts Institute of Technology by Group Bull including Bull HN Information Systems Inc. 
;; as a contribution to computer science knowledge.  
;; This donation is made also to give evidence of the common contributions of Massachusetts Institute of Technology,
;; Bell Laboratories, General Electric, Honeywell Information Systems Inc., Honeywell Bull Inc., Groupe Bull
;; and Bull HN Information Systems Inc. to the development of this operating system. 
;; Multics development was initiated by Massachusetts Institute of Technology Project MAC (1963-1970),
;; renamed the MIT Laboratory for Computer Science and Artificial Intelligence in the mid 1970s, under the leadership
;; of Professor Fernando Jose Corbato. Users consider that Multics provided the best software architecture
;; for managing computer hardware properly and for executing programs. Many subsequent operating systems
;; incorporated Multics principles.
;; Multics was distributed in 1975 to 2000 by Group Bull in Europe , and in the U.S. by Bull HN Information Systems Inc., 
;; as successor in interest by change in name only to Honeywell Bull Inc. and Honeywell Information Systems Inc. .
;;
;;                                          -----------------------------------------------------------
;;
;; Permission to use, copy, modify, and distribute these programs and their documentation for any purpose and without
;; fee is hereby granted,provided that the below copyright notice and historical background appear in all copies
;; and that both the copyright notice and historical background and this permission notice appear in supporting
;; documentation, and that the names of MIT, HIS, Bull or Bull HN not be used in advertising or publicity pertaining
;; to distribution of the programs without specific prior written permission.
;;    Copyright 1972 by Massachusetts Institute of Technology and Honeywell Information Systems Inc.
;;    Copyright 2006 by Bull HN Information Systems Inc.
;;    Copyright 2006 by Bull SAS
;;    All Rights Reserved
;;