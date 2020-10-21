&  ***********************************************************
&  *                                                         *
&  * Copyright, (C) Honeywell Information Systems Inc., 1982 *
&  *                                                         *
&  ***********************************************************
&
&   ******************************************************
&   *                                                    *
&   *                                                    *
&   * Copyright (c) 1981 by Massachusetts Institute of   *
&   * Technology and Honeywell Information Systems, Inc. *
&   *                                                    *
&   *                                                    *
&   ******************************************************
&
& Exec Com to dump the Emacs Lisp environments.
&
&  Written:  6 May      1981 RMSoley from many old tries.
& Modified: 17 June     1981 RMSoley for Emacs reorganization.
& Modified: 22 June     1981 RMSoley to fix alternate-key-bindings.
& Modified:  1 July     1981 RMSoley to compile search list file.
& Modified:  8 July     1981 RMSoley to dump version-named save file.
& Modified: 13 August   1981 RMSoley for emacs/emacs_ compatibility.
& Modified:  5 November 1981 RMSoley for "both" argument.
& Modified:  8 November 1981 RMSoley for "no-break" initialization.
& Modified: 12 April    1982 RMSoley for new site-dir, get rid of tty-ctl-dir.
& Modified: 23 January  1984 Barmar  for e_option_defaults_.
& Modified: 29 September 1984 Barmar to move e_self_documentor_ to regular Emacs.
&
& ARGUMENTS:
& This EC takes two arguments, the first of which must be "emacs" or "emacs_",
& specifying which kind of environment to dump.  The second must be
& "unb", "exl", or "test", specifying which kind of exposure.
&
&command_line off
&input_line off
&
&if [equal &n 2] &then &goto right_argno
&print Syntax: make_emacs <emacs | emacs_ | both> <exl | test | unb>
&quit
&
&label right_argno
&if [equal &1 emacs]  &then &goto good_e_name
&if [equal &1 emacs_] &then &goto good_e_name
&if [equal &1 both]   &then &goto good_e_name
&print First argument must be "emacs", "emacs_", or "both".
&quit
&
&label good_e_name
&if [equal &2 exl]  &then &goto good_name
&if [equal &2 test] &then &goto good_name
&if [equal &2 unb]  &then &goto good_name
&print Second argument must be "exl", "test", or "unb".
&quit
&
&label good_name
&
& Recurse if &1=both.
&
&if [not [equal &1 both]] &then &goto not_both
&
exec_com &ec_dir>&ec_name (emacs emacs_) &2
&quit
&
&
&label not_both
&
&attach
lisp
&
(do ((in (read) (read))) ((eq in 'applesauce) '||) (eval in))
&
(sstatus feature Emacs)
(setq NowDumpingEmacs t nobreak-functions ())
(*array '*VIRGIN-OBARRAY* 'obarray t)
&
&if [not [equal &2 exl]] &then &goto skip_exl
(setq env-dir		">exl>emacs_dir>executable"
      lisp-system-dir	">exl>lisp_dir>executable"
      documentation-dir	">exl>emacs_dir>info"
      site-dir		">exl>emacs_dir>executable"
      include-dir		">exl>include")
&
&goto got_dirs
&label skip_exl
&if [not [equal &2 test]] &then &goto skip_test
(setq env-dir		">exl>emacs_dir>Test_Emacs"
      lisp-system-dir	">exl>lisp_dir>executable"
      documentation-dir	">exl>emacs_dir>info"
      site-dir		">exl>emacs_dir>executable"
      include-dir		">exl>emacs_dir>include")
&
&goto got_dirs
&label skip_test
(setq env-dir		">system_library_unbundled"
      lisp-system-dir	">system_library_unbundled"
      documentation-dir	">documentation>subsystem>emacs_dir"
      site-dir		">system_library_unbundled"
      include-dir		">library_dir_dir>include")
&
&label got_dirs
&
(defun &loader& (l)
       (mapc '(lambda (x)
		  (terpri)
		  (princ "Loading ")
		  (princ x)
		  (princ " ....")
		  (load x))
	   l))
&
& Load in basic emacs.
&
(&loader& '(e_defpl1_		e_lap_
	  e_interact_		e_multics_files_
	  e_binding_table_		e_option_defaults_
	  e_redisplay_		e_basic_
	  e_window_mgr_		e_listen_interface_
	  e_self_documentor_))
&
& Fix up alternate-key-bindings.
&
(do a 0 (1+ a) (= a 2)
    (do b 0 (1+ b) (= b 128.)
        (and (eq (key-bindings b a) 'self-insert)
	   (store (alternate-key-bindings b a) 'self-insert))))
(store (alternate-key-bindings 33 0) 'escape)
&
& Load full emacs if dumping complete emacs.
&
&if [equal &1 emacs_] &then &goto no_unb
&
&print
&print
&print Dumping full emacs.
&
(&loader& '(e_macops_))
&
&label no_unb
&
& Get current version number.
(setq emacs-version (e_lap_$rtrim (emacs$get_version)))
&
& Check for experimental installation.
&
&if [not [equal &2 unb]] &then &goto exl_dump
&
&print
&print
&print Dumping standard emacs.
&
(setq mode-line-herald (catenate "Emacs " emacs-version))
&
&goto join
&
&label exl_dump
&
&print
&print
&print Dumping experimental emacs.
&
(setq mode-line-herald (catenate "Emacs " emacs-version " EXL"))
&
(*rset t)
(sstatus uuolinks t)
&
&label join
&
&if [equal &2 unb] &then &goto no_carry
& For the sake of Carry, create saved environment segment 
&
(cline (catenate "if [not [exists entry &1." emacs-version ".sv.lisp]]"
	" -then ""create &1." emacs-version ".sv.lisp"""))
&
&label no_carry
&
(setplist '&loader& ())
(remob '&loader&)
&
(setq errlist (cons '(hcs_$initiate_count env-dir 'e_pl1_ 'e_pl1_ 0)
		errlist)) ;fix supdup output bug.
(setq NowDumpingEmacs nil)
(gctwa)
(gc)
(sstatus gctime 0)
&
applesauce
&
(eval (list 'save (catenate "&1." emacs-version)))
&detach
&print
&print Finished.
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
