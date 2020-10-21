&version 2
&-
&- HISTORY COMMENTS:
&-  1) change(87-07-27,GDixon), approve(87-07-27,MCR7679),
&-     audit(87-07-27,Brunelle), install(87-08-04,MR12.1-1055):
&-     Created.
&-                                                      END HISTORY COMMENTS
&-
&set WDIR &[wd]
cwd &ec_dir

&print Sort info segments in the directory.
l_set_ring_brackets ** 4 5 5
create_dir &!
move **.info &!>== -force
cwd &!
move ([sort_strings -asc [segments **]]) <== -force
cwd <
delete_dir &! -force
l_set_ring_brackets ** 1 5 5

&print Relink the links in the directory.
unlink **.info -brief
do "link >doc>subsystem>ssu.&&1.info &&1.info;
&+  addname &&1.info -brief
&+   [after ([status -names >doc>subsystem>ssu.&&1.info]) ssu.]"
&+ (answer do execute_string help if list_help list_requests)
link >doc>info>pause.info
do "link >doc>subsystem>ssu.&&1.info &&1.info;
&+  addname &&1.info -brief
&+   [after ([status -names >doc>subsystem>ssu.&&1.info]) ssu.]"
&+ (quit ready ready_off ready_on substitute_arguments subsystem_name
&+  subsystem_version)
link >doc>info>user.info
cwd &(WDIR)
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
