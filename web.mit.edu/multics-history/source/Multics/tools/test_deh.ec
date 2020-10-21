&  ******************************************************
&  *                                                    *
&  *                                                    *
&  * Copyright (c) 1972 by Massachusetts Institute of   *
&  * Technology and Honeywell Information Systems, Inc. *
&  *                                                    *
&  *                                                    *
&  ******************************************************
&
&command_line off
ioa_ ^|
&command_line on
deh_test_admin  deh_test1$simfault

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$sf

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$gate_error

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$ge

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$out_of_bounds

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$ob

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  "delete gupazkq"

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$pl1_op2

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$plop2

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test_gate_$gplop2

&command_line off
ioa_  "*********************************************************************"
&command_line on

deh_test_admin  deh_test5$pl1_op1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$fixedoverflow

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$fo

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test_gate_$gfo

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test8

&command_line off
ioa_  "*********************************************************************"
&command_line on


copy  &1>deh_test7 deh_test7_copy_


setacl  deh_test7_copy_ n


deh_test_admin  deh_test8

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test7_copy_$def

&command_line off
ioa_  "*********************************************************************"
&command_line on


setacl  deh_test7_copy_ w


deh_test_admin  deh_test8

&command_line off
ioa_  "*********************************************************************"
&command_line on


setacl  deh_test7_copy_ r


deh_test_admin  deh_test8

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin deh_test7_copy_$def

&command_line off
ioa_  "*********************************************************************"
&command_line on


setacl deh_test7_copy_  re


deh_test_admin  deh_test8


setacl deh_test7_copy_ rewa


deh_test_admin  deh_test1$seg_fault_error

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$bound_call

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$bc

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$fault_tag_1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$ft1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test_gate_$gft1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  ioa_ [get_pathname gloppppp]"

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$oncode_error

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$conversion_error

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test4

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test5$conv_err1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test5$fault_tag_1

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test9

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$zerodivide

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$zd

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$overflow

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$of

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$underflow

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$uf

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test1$trap_before_link

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$tbl

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test2$illegal_mod

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test2$crt

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test2$lockup

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test2$illegal_op

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$iop

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  deh_test2$privileged

&command_line off
ioa_  "*********************************************************************"
&command_line on


deh_test_admin  call_deh_test_gate$pv

&command_line off
ioa_  "*********************************************************************"
&command_line on
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
