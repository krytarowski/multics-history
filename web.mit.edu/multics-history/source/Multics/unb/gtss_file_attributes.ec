&version 2
&- ***********************************************************
&- *                                                         *
&- * Copyright, (C) Honeywell Information Systems Inc., 1983 *
&- *                                                         *
&- ***********************************************************
&- Author:    Ron Barstad	1982
&- Modified:  Ron Barstad	1982	Added mode parameter
&- Modified:  Ron Barstad	83-04-18	Changed max size to 20 times current
&trace &command off
&trace &input off
&if [exists argument &1] &then &goto cont
string USAGE: ec &ec_name GCOS_FILE_NAME {mode}
&quit

&label cont
&if [exists branch &1] &then &goto cont2
string &ec_name.ec: Segment &1 unknown. Quiting.
&quit

&label cont2
&goto &ec_name

&label query_init
&label attr
add_name &1 &1.mode.[response "mode: r or s?"]
add_name &1 &1.maxl.[response "maxl: #llinks?"]
add_name &1 &1.curl.[response "curl: #llinks?"]
add_name &1 &1.attr.[response "attr: 12octal?"]
add_name &1 &1.busy.[response "busy: yes or no?"]
add_name &1 &1.null.[response "null: yes or no?"]
add_name &1 &1.noal.[response "noal: #allocations?"]
add_name &1 &1.crdt.[response "crdt: MMDDYY?"]
&quit

&label init
&label gcos_file_attributes
&label gtss_file_attributes
&label gfa
&default &undefined s
&if &[equal &[search &2 rs] 1] &then &goto add_n
string &ec_name.ec: Mode "&r2" unknown, must be r or s. Quiting.
&quit

&label add_n
&set llinks [ceil [quotient [times [status &1 -cl] 1024] 320]]
add_name &1 &1.mode.[substr &2 1 1]
add_name &1 &1.maxl.[times &(llinks) 20]
add_name &1 &1.curl.&(llinks)
add_name &1 &1.attr.0
add_name &1 &1.busy.no
add_name &1 &1.null.no
add_name &1 &1.noal.0
add_name &1 &1.crdt.[substr [date] 1 2][substr [date] 4 2][substr [date] 7 2]
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
