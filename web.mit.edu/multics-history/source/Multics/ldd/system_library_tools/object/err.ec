&version 2
&-  ***********************************************************
&-  *                                                         *
&-  * Copyright, (C) Honeywell Information Systems Inc., 1982 *
&-  *                                                         *
&-  * Copyright (c) 1972 by Massachusetts Institute of        *
&-  * Technology and Honeywell Information Systems, Inc.      *
&-  *                                                         *
&-  ***********************************************************
&-
&-  Modification history:
&-  Modified 1984-12-11 BIM: new value segments.
&-
&trace &command off
&goto &1
&-
&label crank_abort
&print --> A PREVIOUS CRANK ABORTED. MAKE SURE EVERYTHING IS OK.
sm [value_get -pn sys_admin admin_online] "CRANK ABORTED"
&goto common
&-
&label not_user
&print --> ERROR User &2 is not registered
&goto common
&-
&label fatal
&print --> ERROR Serious error. Get help
&goto common
&-
&label no_pmf
&print --> ERROR Project &2 master file not found (may be delegated or misspelled)
&goto common
&-
&label try_again
&print --> ERROR Try again
&goto common
&-
&label noarg
&print --> ERROR Not enough arguments
&goto common
&-
&label noarg_nolock
&print --> ERROR Not enough arguments
&goto common1
&-
&label nofile
&print --> ERROR File missing: &2
&goto common
&-
&label many_arg
&print --> ERROR Too many Arguments
&goto common
&-
&label quote_arg
&print --> ERROR Argument must be enclosed in quotes
&goto common
&-
&label badcom
&print --> ERROR Invalid command: &2
&goto common
&-
&label already_delegated
&print --> ERROR Proj &2 already delegated
&goto common
&-
&label noproj
&print --> ERROR Project &2 does not exist
&goto common
&-
&label already_proj
&print --> ERROR Project &2 already exists
&goto common
&-
&label crank_absout_missing
&print --> ERROR crank.absout not found.
&print 'day' may have been done already or crank may have failed to run.
&goto common
&-
&label common
admin_util unlock
&label common1
signal master_ec_error_ -info_string "An error occured in the master.ec"
&- program_interrupt would be a noop in the normal Multics environment
&goto common1 &- we mean this.
&quit
&-
&label &1
&print --> ERROR &1 &2 &3 &4 &5
&goto common
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
