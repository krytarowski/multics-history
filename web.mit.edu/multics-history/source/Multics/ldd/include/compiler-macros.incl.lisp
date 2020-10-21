
;;; BEGIN INCLUDE FILE compiler-macros.incl.lisp

;;; This file contains useful macros used by the lisp_compiler.

;    (defun compiler-displace macro (l) 
;        ((lambda (a1 a2) (rplaca a1 (car a2)) (rplacd a1 (cdr a2)) (list 'quote a1))
;            (eval (cadr l))
;            (eval (caddr l))))
    (defun barf macro (x) 
	(displace x (list 'printmes (cadr x) (caddr x) (list 'quote (cadddr x))) ))

    (defun warn macro (x) (displace x (list 'printmes (cadr x) (caddr x) ''warn)))
    (defun specialp macro (x) (displace x  (list 'get (cadr x) '(quote special))))

    (defun memq-max macro (x) (displace x (list 'quote 11.)))	;   optimize (memq x '(...)) into
						;   an or of 10. or fewer clauses.

    (defun assq-max macro (x) (displace x (list 'quote  4)))	;max 3-dotted-pair inline assq
    (defun push macro (x) 
        (displace x (list 'setq (caddr x) (list 'cons (cadr x) (caddr x))))) 
    (defun pop macro (x) (displace x (list 'setq (cadr x) (list 'cdr (cadr x)))))
    (defun pnamep macro (x) (displace x (subst (cadr x) 'x '(eq (typep x) 'symbol))))


;;; END INCLUDE FILE compiler-macros.incl.lisp

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