&  **************************************************************
&  *                                                            *
&  * Copyright, (C) Massachusetts Institute of Technology, 1982 *
&  *                                                            *
&  **************************************************************
&  This ec has two entrypoints, lisp_standard_environment_ and lisp_nostartup.
&  They take one argument which is the directory which will contain the installed
&  lisp.  This argument is used to set up autoload properties for tracing, grinding
&  and editing.  The only difference between the two entrypoints is that
&  lisp_nostartup does not initialize the environment to run [hd]>start_up.lisp
&  when it is loaded.  This environment is used to initialize the saved environments
&  for lcp and lap.  The lisp_standard_environment_ entrypoint accepts an additional
&  argument.  If this argument is present, it stops just before saving the 
&  environment, so you can poke around.  The saved environment is named
&  lisp_standard_environment_, which is special cased.  The lisp_nostartup
&  environment is called lisp_nostartup.sv.lisp.
&
&if [exists argument &1]
&then &goto OK
&print You must give an argument which is the library directory
&quit
&
&label OK
&command_line off
&input_line off
&attach
lisp -boot
& note next thing makes sure obarray exists as a true array...
(progn (putprop 'obarray obarray 'array)
       (putprop 'readtable readtable 'array)
       (setq prin1 nil)
       (setq evalhook nil)
       (setq defun nil)
       (*rset t)

; set up user interrupt service functions

(prog2 nil nil
       (setq ^a				nil
	   zunderflow			nil
	   internal_interrupt_0_atom_ 	nil
	   ^b				'*internal-^b-break
	   internal_interrupt_2_atom_		nil
	   alarmclock			nil
	   errset				nil
	   undf-fnctn			'*internal-undf-fnctn-break
	   unbnd-vrbl			'*internal-unbnd-vrbl-break
	   wrng-type-arg			'*internal-wrng-type-arg-break
	   unseen-go-tag			'*internal-unseen-go-tag-break
	   wrng-no-args			'*internal-wrng-no-args-break
	   fail-act			'*internal-fail-act-break
	   pdl-overflow			'*internal-pdl-overflow-break
	   gc-lossage			'*internal-gc-lossage-break
	   internal_interrupt_14_atom_	nil
	   internal_interrupt_15_atom_	nil
	   internal_interrupt_16_atom_	nil
	   gc-daemon			nil
	   internal_autoload_atom_		'*internal-autoload-trap
	   *rset-trap			'*internal-*rset-break)

       (putprop 'stack-loss t 'break-tag)	;this has to stay in the obarray.  break-tag will be remob'ed.

;;; set up self - loading trace and grind packages

       (defprop lap "&1>lap_" autoload)
       (defprop trace "&1>lisp_trace_" autoload)

       (defprop grind "&1>lisp_gfile_" autoload)

       (defprop grindef "&1>lisp_gfn_" autoload)

       (defprop grind0 "&1>lisp_gfile_" autoload)

       (defprop sprinter "&1>lisp_gfn_" autoload)

;;; Set up self-loading editor.

       (mapc '(lambda (x) (putprop x "&1>lisp_editor_" 'autoload))
	   '(editf editp editv edit))


;;; This hack sets up (status features)

       (setq internal_semicolon_macro_ '(sort string fasload newio bignum H6180 Multics maclisp))

;;;this hack is for (status spcnames)

       (setq internal_quote_macro_ '(list markedpdl unmarkedpdl))	;do not change the order

;now remove those atoms we wanted uninterned....

       (defun fremob fexpr (fremob) (mapc 'remob fremob))
       (fremob internal_quote_macro_ internal_semicolon_macro_ internal_vertical_bar_macro_
	     cruft	;used to fill obsolete cells in lisp_static_vars_
	     err-break errprint? break-tag
	     internal_interrupt_0_atom_ internal_interrupt_2_atom_
	     internal_interrupt_14_atom_ internal_interrupt_15_atom_ internal_interrupt_16_atom_
	     *internal-^b-break *internal-undf-fnctn-break *internal-unbnd-vrbl-break
	     *internal-wrng-type-arg-break *internal-unseen-go-tag-break
	     *internal-wrng-no-args-break *internal-fail-act-break *internal-pdl-overflow-break
	     *internal-gc-lossage-break *internal-autoload-trap *internal-*rset-break
	     internal_autoload_atom_ autoload_remob)

       (setq ^d nil nouuo nil)

         (mapc '(lambda (x) (putprop x "&1>lisp_old_io_" 'autoload))
	     '(uread fasload uwrite ufile ukill crunit uappend uprobe))
       (fremob fremob)
       ) ; end of moby prog2
)        ; end of moby progn
;here is where we set up for reading start_up.lisp's


;;; code to run a start_up.lisp in home dir, if there is one.

&if [equal &ec_name lisp_nostartup]
&then &goto NOSTARTUP

(prog2
  (setq errlist
        '((setq errlist nil)	;once-only code, used only when lisp command with no args is given.

	(and (allfiles (list (status udir) 'start_up 'lisp))
	     (load (namestring (list (status udir) 'start_up 'lisp))))))
  "errlist setup for start_up.lisp"
  (gctwa) (gc))


&if [exists argument &r2]
&then &quit
(save standard/.new)
&detach
answer yes -brief "rename standard.new.sv.lisp lisp_standard_environment_"
&quit

&label NOSTARTUP
(gctwa)
(gc)
(save lisp_nostartup)
&quit
&
&
&                                          -----------------------------------------------------------
&
& 
& 
& Historical Background
& 
& This edition of the Multics software materials and documentation is provided and donated
& to Massachusetts Institute of Technology by Group Bull including Bull HN Information Systems Inc. 
& as a contribution to computer science knowledge.  
& This donation is made also to give evidence of the common contributions of Massachusetts Institute of Technology,
& Bell Laboratories, General Electric, Honeywell Information Systems Inc., Honeywell Bull Inc., Groupe Bull
& and Bull HN Information Systems Inc. to the development of this operating system. 
& Multics development was initiated by Massachusetts Institute of Technology Project MAC (1963-1970),
& renamed the MIT Laboratory for Computer Science and Artificial Intelligence in the mid 1970s, under the leadership
& of Professor Fernando Jose Corbato. Users consider that Multics provided the best software architecture for
& managing computer hardware properly and for executing programs. Many subsequent operating systems
& incorporated Multics principles.
& Multics was distributed in 1975 to 2000 by Group Bull in Europe , and in the U.S. by Bull HN Information Systems Inc., 
& as successor in interest by change in name only to Honeywell Bull Inc. and Honeywell Information Systems Inc. .
& 
&                                          -----------------------------------------------------------
&
& Permission to use, copy, modify, and distribute these programs and their documentation for any purpose and without
& fee is hereby granted,provided that the below copyright notice and historical background appear in all copies
& and that both the copyright notice and historical background and this permission notice appear in supporting
& documentation, and that the names of MIT, HIS, Bull or Bull HN not be used in advertising or publicity pertaining
& to distribution of the programs without specific prior written permission.
&     Copyright 1972 by Massachusetts Institute of Technology and Honeywell Information Systems Inc.
&     Copyright 2006 by Bull HN Information Systems Inc.
&     Copyright 2006 by Bull SAS
&     All Rights Reserved
& 
&
