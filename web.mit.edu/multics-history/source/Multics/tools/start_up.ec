&  ******************************************************
&  *                                                    *
&  * Copyright, (C) Honeywell Bull Inc., 1987           *
&  *                                                    *
&  * Copyright (c) 1972 by Massachusetts Institute of   *
&  * Technology and Honeywell Information Systems, Inc. *
&  *                                                    *
&  ******************************************************

& 
& 
&  HISTORY COMMENTS:
&   1) change(87-08-12,GDixon), approve(88-08-15,MCR7969),
&      audit(88-08-03,Lippard), install(88-08-29,MR12.2-1093):
&      Change to call print_motd instead of using the print command to print
&      the message of the day. (phx15921)
&                                                       END HISTORY COMMENTS
& 
&
& start_up.ec -- default start_up for >sc1
& this exec com just prints the motd to duplicate the old behavior of
& process_overseer_.
&
& It is executed by all users (with standard process overseers) who
& lack start_up.ec in their homedir and project dir.
&
&command_line off
&goto &ec_name

&label start_up
&if [equal &1 login] &then print_motd
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
