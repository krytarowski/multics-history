&  ******************************************************
&  *                                                    *
&  *                                                    *
&  * Copyright (c) 1972 by Massachusetts Institute of   *
&  * Technology and Honeywell Information Systems, Inc. *
&  *                                                    *
&  *                                                    *
&  ******************************************************
&
& setup_arpanet.ec: Set up the ARPA network support on Multics.
&	Written by C. Hornig, February 1980.
&
&if [nequal &n 0] &then &else &goto args_ok
&
&print Usage: ec setup_arpanet &HOST {test}
&quit
&
&label args_ok
&attach
&
&if [equal x&r2 x] &then &else &goto testing
change_wdir >
&
&goto &ec_name
&
&label testing
&
new_user$new_user_test [wd]>udd>SysAdmin>admin
install$install_init [wd]>system_control_dir
copy >system_library_network>net_host_table_ system_library_network>== -all -acl
initiate system_library_network>net_host_table_ -force
initiate >system_library_network>nhi_update_ net_admin_ -force
&
&goto &ec_name
&
&label setup_arpanet
&
&print $ Begin ARPA setup for host &1.
&
& set up process environment
&
add_search_rules >system_library_tools >system_library_network
&
& Register daemon users
&
new_user
*System, Network Operation
Machine Room
none
Daemon
nd
nd

Network_Daemon
yes
yes
*System, Network Services
Machine Room
none
Daemon
ns
ns

Network_Server
yes
yes
*System, Network Mail
Machine Room
none
Daemon
NETML
NETML

NETML
yes
no
&
& Make links so that Initializer can run net stuff
&
do "(link copy_names) system_library_network>&(1) system_library_tools>==" (bound_net_status_ bound_network_logger_)
&
& set up >udd>Daemon
&
add_name udd>Daemon CNet
change_wdir udd>Daemon
&
answer yes create_dir mailboxes
move_quota mailboxes 1
set_acl mailboxes s *.*.*
&
answer yes create_dir send_mail_pool
move_quota send_mail_pool 100
set_acl send_mail_pool sma Network_Server.* sa *.*
set_iacl_seg send_mail_pool r Network_Server.*
&
&if [exists entry Network_Server] &then &else answer yes create_dir Network_Server
&
add_name Network_Server ns
set_acl Network_Server sma Network_Server.*
set_iacl_seg Network_Server rw Network_Server.*
change_wdir Network_Server
&
create net_mailer_com_seg
add_name net_mailer_com_seg server_com_seg
set_acl net_mailer_com_seg rw Network_Server.* r *.*
&
create mailing_list
set_acl mailing_list rw Network_Server.*
debug
/mailing_list/
1=34100
2=1604
3=2
4=16040
5=30
.q
&
qedx
i
!&!command_line off
run_net_mailer
!&!quit
\f
1,$s/!//
w start_up.ec
q
set_acl start_up.ec r Network_Server.*
&
ms_create outgoing_mail
ms_set_acl outgoing_mail adros Network_Server.* aos *.*
&
change_wdir <
create Network_Server>net_log
&
&if [exists entry Network_Daemon] &then &else answer yes create_dir Network_Daemon
&
add_name Network_Daemon nd
set_acl Network_Daemon sma Network_Daemon.*
set_iacl_seg Network_Daemon rw Network_Daemon.*
create Network_Daemon>net_log
&
&if [exists entry NETML] &then &else answer yes create_dir NETML
&
set_acl NETML sma NETML.*
set_iacl_seg NETML rw NETML.*
create NETML>net_log
&
change_wdir <<
&
& set up >sc1
&
change_wdir system_control_dir
answer yes create net_log
answer yes create log_tbl
ed_installation_parms
c ARPA &1
w
q
&
answer yes create_dir ncp
set_acl ncp s *.*
change_wdir ncp
&
create connect.acs
set_max_length connect.acs 0
set_acl connect.acs rw *.*
&
create AS_logger
set_max_length AS_logger 0
delete_acl AS_logger -all
delete_acl AS_logger *.SysDaemon.*
set_acl AS_logger rw Initializer.SysDaemon.z null *.*.*
&
add_name AS_logger socket.(1 3 23).acs
add_name AS_logger socket_group.([index_set 255]).acs
&
change_wdir <<
&
& set up admin databases
&
change_wdir udd>SysAdmin>admin
qedx
r CMF
/^end;/i
name: net001-net010;  service: login;  baud: none;  line_type: TELNET;
name: ftp201-ftp210;  service: ftp;  baud: none;  line_type: TELNET;
\f
w
q
cv_cmf CMF
install CMF.cdt
&
& Register on the Daemon project
&
change_wdir udd>SysAdmin>admin
archive x pmf Daemon
qedx
r Daemon
/^end;/i
personid:		Network_Daemon;	initproc:	network_exec_;
personid:		Network_Server;
personid:		NETML;		initproc:	netml_responder_;	attributes: ^vinitproc, ^vhomedir, ^nostartup, ^daemon, multip;
\f
w
q
cv_pmf Daemon
install Daemon.pdt
delete Daemon.pdt
archive ud pmf Daemon
&
& make the host table
&
qedx
a
/* Initial ARPANET host table */

Host:		167772166;
 official_name:	 MIT-Multics;
 abbreviation:	 mit;
 attribute:	 Communicate, Server, Multics;

Host:		168034335;
 official_name:	 MIT-devMultics;
 abbreviation:	 cisl;
 attribute:	 Communicate, Server, Multics;
\f
w net_host_table.ascii
q
update_host_table net_host_table.ascii -reset -all
&
change_wdir <<<
&
&quit
&
& & & & & & & & & & & & & & & & & & & &
&
& This part reverts everything done above
&
& & & & & & & & & & & & & & & & & & & &
&
&label revert_ARPAnet
&
delete_dir udd>Daemon>send_mail_pool -force
delete_dir udd>Daemon>mailboxes -force
delete_dir udd>Daemon>NETML -force
delete_dir udd>Daemon>Network_Server -force
delete_dir udd>Daemon>Network_Daemon -force
&
delete_name udd>CNet
&
change_wdir udd>SysAdmin>admin
archive x pmf Daemon
qedx
r Daemon
/NETML/d
/Network_Server/d
/Network_Daemon/d
w
q
cv_pmf Daemon
install Daemon.pdt
archive ud pmf Daemon
&
remove_user NETML
remove_user Network_Server
remove_user Network_Daemon
&
change_wdir <<<
&
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
