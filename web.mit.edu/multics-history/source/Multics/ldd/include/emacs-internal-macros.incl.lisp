;;; BEGIN INCLUDE FILE emacs-internal-macros.incl.lisp

;;; Loads in e_internal_macros_

;;; HISTORY COMMENTS:
;;;  1) change(85-01-06,Margolin), approve(86-02-24,MCR7186),
;;;     audit(86-08-20,Harvey), install(86-08-20,MR12.0-1136):
;;;     Created.
;;;                                                      END HISTORY COMMENTS

(%include defstruct)
(%include setf)

(eval-when (compile eval)
  (or (status feature e-internal-macros)
      (load (catenate (car (namelist (truename infile)))
		  ">e_internal_macros_")))
  (sstatus feature e-internal-macros))

(declare
  (*expr e$get_temporary_seg e$release_temporary_seg
         e_lap_$ggcharn e_lap_$gsubstr e_lap_$return-string e_lap_$rtrim
         e_lap_$segnlindex e_lap_$write-string
         exists-buffer get-buffer-state map-over-emacs-buffers
         order-mark-last))

(declare
  (special buffer-file-dtcm		;DTCM of the file associated with the current buffer
	 buffer-tempsegs		;list of temp segs for current buffer
	 buffer-uid		;Multics UID of segment this buffer is "eq" to
				;for arch. comp, (UID . compname)
	 curline			;current line
	 curlinel			;length of current line
	 curpointpos		;# of chars to left of cursor on line
	 curstuff			;the current line (string or filecons)
	 firstline		;first line of buffer
	 known-buflist		;list of defined buffers
	 lastline			;last line of current buffer
	 minibufferp		;non-nil if in minibuffer
	 tty-no-upmotionp		;non-display terminal
	 work-string		;black-magic string containing open line
	 ))

;;; END INCLUDE FILE emacs-internal-macros.incl.lisp
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