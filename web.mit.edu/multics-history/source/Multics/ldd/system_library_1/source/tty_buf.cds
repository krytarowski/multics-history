/* ***********************************************************
   *                                                         *
   * Copyright, (C) Honeywell Bull Inc., 1987                *
   *                                                         *
   * Copyright, (C) Honeywell Information Systems Inc., 1982 *
   *                                                         *
   * Copyright (c) 1972 by Massachusetts Institute of        *
   * Technology and Honeywell Information Systems, Inc.      *
   *                                                         *
   *********************************************************** */


tty_buf:	 proc;
	 

/* Program to create ring-0 tty_buf segment

   Written Jan. 81 by J. Bongiovanni								*/
	 

dcl 1 cdsa like cds_args aligned;
dcl code fixed bin (35);
dcl p ptr;
	 

dcl my_name char (7) init ("tty_buf") int static options (constant);
	 

%include cds_args;
%include tty_buf;

dcl com_err_ entry options (variable);
dcl create_data_segment_ entry (ptr, fixed bin(35));
dcl get_temp_segment_ entry (char(*), ptr, fixed bin(35));
dcl release_temp_segment_ entry entry options(variable);

dcl cleanup condition;



     ttybp = null();
     on cleanup call release_temp_segment_ (my_name, ttybp, code);
     
     call get_temp_segment_ (my_name, ttybp, code);
     if code ^= 0 then do;
	call com_err_ (code, my_name, "Getting temp segment");
	return;
     end;
     
     unspec (cdsa) = ""b;
     cdsa.have_text = "1"b;
     cdsa.p (1) = ttybp;
     cdsa.len (1) = size (tty_buf);
     cdsa.struct_name (1), cdsa.seg_name = my_name;
     cdsa.num_exclude_names = 0;
     cdsa.exclude_array_ptr = null();

     call create_data_segment_ (addr (cdsa), code);
     if code ^= 0 then call com_err_ (code, my_name, "Creating data segment");
     
     call release_temp_segment_ (my_name, ttybp, code);
     
end tty_buf;


*/
                                          -----------------------------------------------------------


Historical Background

This edition of the Multics software materials and documentation is provided and donated
to Massachusetts Institute of Technology by Group Bull including Bull HN Information Systems Inc. 
as a contribution to computer science knowledge.  
This donation is made also to give evidence of the common contributions of Massachusetts Institute of Technology,
Bell Laboratories, General Electric, Honeywell Information Systems Inc., Honeywell Bull Inc., Groupe Bull
and Bull HN Information Systems Inc. to the development of this operating system. 
Multics development was initiated by Massachusetts Institute of Technology Project MAC (1963-1970),
renamed the MIT Laboratory for Computer Science and Artificial Intelligence in the mid 1970s, under the leadership
of Professor Fernando Jose Corbato. Users consider that Multics provided the best software architecture for 
managing computer hardware properly and for executing programs. Many subsequent operating systems 
incorporated Multics principles.
Multics was distributed in 1975 to 2000 by Group Bull in Europe , and in the U.S. by Bull HN Information Systems Inc., 
as successor in interest by change in name only to Honeywell Bull Inc. and Honeywell Information Systems Inc. .

                                          -----------------------------------------------------------

Permission to use, copy, modify, and distribute these programs and their documentation for any purpose and without
fee is hereby granted,provided that the below copyright notice and historical background appear in all copies
and that both the copyright notice and historical background and this permission notice appear in supporting
documentation, and that the names of MIT, HIS, Bull or Bull HN not be used in advertising or publicity pertaining
to distribution of the programs without specific prior written permission.
    Copyright 1972 by Massachusetts Institute of Technology and Honeywell Information Systems Inc.
    Copyright 2006 by Bull HN Information Systems Inc.
    Copyright 2006 by Bull SAS
    All Rights Reserved

*/
