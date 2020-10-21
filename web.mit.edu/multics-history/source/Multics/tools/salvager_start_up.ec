&  ***********************************************************
&  *                                                         *
&  * Copyright, (C) Honeywell Information Systems Inc., 1982 *
&  *                                                         *
&  ***********************************************************
&
&	start_up.ec for Salvager.SysDaemon
&	B. Greenberg 9/13/77
&
do -absentee
&goto &1
&label login
&if [equal [user device_channel] s99] &then &goto mpabort
&command_line off
delete [user device_channel].fileout -brief
rdf
&if [equal [user device_channel] s0] &then date_deleter -wd 14 salv_output.* salv_online.*
io attach user_fileout vfile_ [user device_channel].fileout
io open user_fileout stream_output
iocall attach broadcast broadcast_ user_fileout
iocall attach broadcast broadcast_ user_i/o
syn_output user_fileout -ssw error_output
syn_output broadcast
&if [equal [user device_channel] s0] &then [io get_line user_input -nq]
&else do_subtree -slave
&
ro;ro -ssw error_output
io close user_fileout
io detach user_fileout
&if [equal [user device_channel] s0] &then &else logout
&
&	Collate the output
&
adjust_bit_count ([segs *.salvout] [segs *.fileout]) -ch
io attach salv_output vfile_ salv_output.[date].[time];io open salv_output so
io put_chars salv_output -sm ([segs *.salvout])
io close salv_output
io attach online_output vfile_ online_salvout.[date].[time];io open online_output so
io put_chars online_output -sm ([segs *.fileout])
io close online_output

ec &ec_dir>&ec_name sortout [io attach_desc online_output -nq]
do "dprint -he ""SALV OUTPUT"" &(2)" [io attach_desc salv_output -nq]
do "dprint -he ""SALV ONLINE"" &(2)" [io attach_desc online_output -nq]
io detach online_output;io detach salv_output
delete *.salvout *.fileout -brief
logout

&label mpabort
&command_line off
do_subtree$abort
logout
&label new_proc
&quit          & leave ec on new proc
&
&     Recursive entry to sort cumulated salv output, if not
&     msf. Called with spread attach description, as in..
&     ec start_up sortout vfile_ salv_output.09/14/77.12:53
&                 &1      &2     &3
&
&label sortout
&if [exists segment &3] &then &else &quit
&if [nequal [status &3 -bit_count] 0] &then &quit
&command_line off
&input_line off
&attach
qedx
r&3
1,$s/^$//
$a

\f
w
q
&detach
dco -osw error_output sort_seg &3 -dm "" -replace
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
