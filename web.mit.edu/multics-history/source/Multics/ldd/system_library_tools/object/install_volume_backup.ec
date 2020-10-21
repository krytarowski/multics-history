& Modified August 1981 by F. W. Martinson for MR9.0
& ec to install changes of directory structure and file
& organization for new MR9 volume backup subsystem
&command_line off
&if [equal [user name] Volume_Dumper] &then &else &goto err1
&if  [not [exists dir >daemon_dir_dir>volume_retriever]] &then  goto err
cd >daemon_dir_dir>volume_backup
cd >daemon_dir_dir>volume_backup>contents
cd >daemon_dir_dir>volume_backup>pvolog
sis >daemon_dir_dir>volume_backup rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
sis >daemon_dir_dir>volume_backup>contents rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
sis >daemon_dir_dir>volume_backup>pvolog rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
mv *.contents >daemon_dir_dir>volume_backup>contents>==
mv *.pvolog >daemon_dir_dir>volume_backup>pvolog>==
mv *.volog >daemon_dir_dir>volume_backup>==
mv *.volumes >daemon_dir_dir>volume_backup>==
&quit
&label err
&print ">daemon_dir_dir>volume_retriever" does not exist"
&quit
&label err1
&print This exec_com must be executed by Volume_Dumper personid
&print from the Volume_Dumper home_dir.
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
