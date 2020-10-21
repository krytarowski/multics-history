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
&- utility functions for system admin operations
&- 
&- Modification history:
&- Modified 1984-12-11, BIM: summarize_sys_log, new value, V2
&- Modified 1985-02-18, E. Swenson: Prevent eor from asking questions
&-   when there are problems with the segment to be printed.
&-
&trace &command off
&goto &1
&-
&label del
&if &[not [exists argument &2]] &then &quit
&if &[exists file &2] &then answer yes -bf delete &2
&quit
&-
&label dp
&label dprint
&if &[not [value_defined -pn sys_admin &3_addr]] &then &quit
&if &[not [exists argument &2]] &then &quit
&if &[not [exists file &2]] &then &quit
set_acl &2 r IO.SysDaemon
answer no eor -bf -he [value_get -pn sys_admin &3_addr] -ds [value_get -pn sys_admin &3_dest] &2 -q [default default &4]
&quit
&-
&label check_access 
&- usage: ec util check_access OBJECT MODE {name}
&if [exists argument &4] &then &set USER "-user &4"
&else &set USER ""
&set ACCESS &[get_effective_access &2 &(USER)]
&set X 1
&label _loop_check_access
&if &[ngreater &(X) [length &3]] &then &goto _done_check_access
&if &[equal 0 [index &(ACCESS) [substr &3 &(X) 1]]]
&then &do
      &if &is_af &then &return false
      &else &do
            &print Warning: &[default You &4] lack &[substr &3 &(X) 1] access to &2.
            &quit
      &end
&end
&set X &[plus &(X) 1]
&goto _loop_check_access
&label _done_check_access
&if &is_af &then &return true
&quit

&label &1
&print Invalid call to util.ec -- first argument &1
&quit
&- end
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
