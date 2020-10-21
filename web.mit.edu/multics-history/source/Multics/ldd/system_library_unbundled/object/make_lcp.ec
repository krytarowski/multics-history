&  **************************************************************
&  *                                                            *
&  * Copyright, (C) Massachusetts Institute of Technology, 1982 *
&  *                                                            *
&  **************************************************************
&  This ec makes the saved environment for the lisp compiler.  It starts with the
&  lisp_nostartup environment (see lisp_standard_environment_.ec), and loads
&  lcp_init_, lcp_semant_, and lcp_cg_, in that order.  It takes up to five
&  arguments.  The first two are required, and will be prompted for if not given.
&  The first is the compiler version printed by the compiler when it is invoked.
&  The second is the directory where lcp will be installed; it is used for the
&  historian autoload property.  The others are directory pathnames for the three
&  files it loads.  If these arguments are nonblank, they will be used in the
&  (load ...) forms.  The saved environment is compiler.sv.lisp, created in the
&  working directory.
&
&command_line off
&if [and [exists argument &1] [exists argument &2]]
&then &goto OK
&if [exists argument &2]
&then ec &r0 [response "Compiler version?" -non_null] &rf2
&else ec &r0 [response "Compiler version?" -non_null] [response "Directory to be installed in?" -non_null] &rf3
&quit



&label OK
discard_output -osw error_output "tmr (lcp_cg_ lcp_semant_ lcp_init_)"
&
&input_line off
&attach
lisp lisp_nostartup

(ioc w)

(gctwa nil)	; don't collect truly worthless atoms.

&if [exists argument &3]
&then (load "&q3>lcp_init_")
&else (load "lcp_init_")

(cond ((getl 'uread '(fsubr fexpr)))
      ((get 'uread 'autoload) (load (get 'uread 'autoload))))

(use compiler-obarray)

(setq compiler-revision &r1)

(defprop historian "&q2>lcp_historian_" autoload)

&if [exists argument &4]
&then (load "&q4>lcp_semant_")
&else (load "lcp_semant_")

&if [exists argument &5]
&then (load "&q5>lcp_cg_")
&else (load "lcp_cg_")

(*rset nil)
(record-compiler-history)

(use working-obarray)

(*rset nil)
(gctwa)
(gc)
(sstatus uuolinks t)
(save compiler)
&print LCP Version &1 saved.
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
