&  ***********************************************************
&  *                                                         *
&  * Copyright, (C) Honeywell Information Systems Inc., 1985 *
&  *                                                         *
&  ***********************************************************
& Modified August 1981 by F. W. Martinson for MR9.0
& Modified July 1982 by R. Holmstedt for MR10.0
& Modified 85 May 5 by Art Beattie to correct instruction for starting part 2.
&
& exec com to set up directories and daemon queues
& for volume backup/reload system.
&
&command_line off
&goto &ec_name
&label setup_volume_reloader
&if [not [exists directory >sc1>volume_backup_accounts]] &then cd >sc1>volume_backup_accounts
&if [not [exists directory >ddd>volume_retriever]] &then cd >ddd>volume_retriever
&if [not [exists directory >ddd>volume_backup]] &then cd >ddd>volume_backup
&if [not [exists directory >ddd>volume_backup>pvolog]] &then cd >ddd>volume_backup>pvolog
&if [not [exists directory >ddd>volume_backup>contents]] &then cd >ddd>volume_backup>contents
&if [not [exists segment >ddd>volume_retriever>volume_retriever_3.ms]] &then mscr >ddd>volume_retriever>volume_retriever_3
&if [not [exists segment >ddd>volume_retriever>volume_retriever_2.ms]] &then mscr >ddd>volume_retriever>volume_retriever_2
&if [not [exists segment >ddd>volume_retriever>volume_retriever_1.ms]] &then mscr >ddd>volume_retriever>volume_retriever_1
&if [not [exists segment >sc1>vinc.message]] &then cr >sc1>vinc.message
&if [not [exists segment >sc1>vcons.message]] &then cr >sc1>vcons.message
&if [not [exists segment >sc1>vcomp.message]] &then cr >sc1>vcomp.message
&
& setting default access on message segments and volume_backup_accounts
&
sa >sc1>(vinc vcons vcomp).message rw *.SysDaemon.* rw *.Daemon.* null *
sis >sc1>volume_backup_accounts rew *.SysDaemon.* rew *.Daemon.* rew *.SysAdmin.* rew *.SysMaint.* r *
sis >daemon_dir_dir>volume_backup rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
sis >daemon_dir_dir>volume_backup>contents rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
sis >daemon_dir_dir>volume_backup>pvolog rew *.SysDaemon rew *.Daemon rew *.SysAdmin rew *.SysMaint
sa >sc1>volume_backup_accounts sma *.SysDaemon.* sma *.Daemon.* sma *.SysAdmin.* sma *.SysMaint.* s *
sa >ddd>volume_backup sma *.SysDaemon.* sma *.Daemon.* sma *.SysAdmin.* sma *.SysMaint.* s *
sa >ddd>volume_retriever sma *.SysDaemon.* sma *.Daemon.* sma *.SysAdmin.* sma *.SysMaint.* s *
sa >ddd>volume_backup>pvolog sma *.SysDaemon.* sma *.Daemon.* sma *.SysAdmin.* sma *.SysMaint.* s *
sa >ddd>volume_backup>contents sma *.SysDaemon.* sma *.Daemon.* sma *.SysAdmin.* s *.SysMaint.* s *
mssa >ddd>volume_retriever>*.ms adros *.SysDaemon.* adros *.Daemon.* adros *.SysAdmin.* adros *.SysMaint.* aros *
cwd >ddd>volume_backup
manage_volume_pool free dm001 dm002
manage_volume_pool d dm001 dm002
dl -bf *.volog dmpr_err.** *.*.control
answer yes dl -bf >ddd>volume_backup>contents>**
answer yes dl -bf >ddd>volume_backup>pvolog>**
&
&print Now, using an editor, create dump file sys_vols.dump
&print containing names of  volumes to be dumped.  This file
&print should be of the form:
&print
&print (one entry per line)
&print
&print lv,<lvname> or
&print pv,<pvname> 
&print
&print After you have created this dump file continue initialization
&print of volume dumper by typing "ec >t>setup_volume_reloader_2".
&quit
&label setup_volume_reloader_2
& This part of setup initializes vtoces for incremental and
& consolidated dumps.  All output is discarded.
&
&print Now beginning incremental dump setup.
&
&print Creating dummy volume pool.
manage_volume_pool u >ddd>volume_backup>Volume_Dumper
manage_volume_pool a dm001 dm002
incremental_volume_dump -control sys_vols -operator Init -output_volume_desc discard_ -no_object -no_update -auto -error_on -wakeup 480 -wd
end_volume_dump
&print Initialization complete for incremental dumper.
&print Now beginning consolidated dump setup.
consolidated_volume_dump -control sys_vols -operator Init -output_volume_desc discard_ -no_object -no_update -auto -error_on -wd
&print Initialization complete for consolidated dumper.
&
& This section completes initialization by deleting
& all dummy segments created by the initialization process.  At
& completion use of the volume dumper/reloader system can begin.
manage_volume_pool free dm001 dm002
manage_volume_pool d dm001 dm002
dl -bf *.volog dmpr_err.** *.*.control
answer yes dl -bf >ddd>volume_backup>contents>**
answer yes dl -bf >ddd>volume_backup>pvolog>**
sa >udd>Daemon>Volume_Dumper sma Volume_Dumper.* 
sis >udd>Daemon>Volume_Dumper rew Volume_Dumper.* 
answer yes copy sys_vols.dump >udd>Daemon>Volume_Dumper>sys_vols.dump
delete sys_vols.dump
&print Initialization of Volume Dumper/Reloader system
&print is now complete.  You must now use the manage_volume_pool
&print to register the tape volumes you will be using
&print for volume dumping/reloading.  To use this system operator
&print should type:
&print
&print x vinc <initials>  to start incremental dump
&print x vcons <initials> to start consolidated dump
&print x vcomp <initials> to start complete dump
&print
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
