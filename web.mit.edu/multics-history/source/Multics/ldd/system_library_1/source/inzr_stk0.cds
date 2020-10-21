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



inzr_stk0: proc;

/* This program is the initializer's stack during initialization */
/* This is so called because it must be found in bootstrap1's magic name 
   table, which limits names to 8 recognizable characters. */

/* Automatic */

dcl 1 cdsa aligned like cds_args;
dcl  code fixed bin (35);

/* Static */

dcl  name char (32) aligned static init ("inzr_stk0") options (constant);
dcl  exclude_pad (1) char (32) aligned static options (constant) init ("*");

/* Builtins */

dcl (addr, baseptr, bin, bit, hbound, mod, null, ptr, rel, size, string) builtin;

/* Entries */

dcl  com_err_ entry options (variable);
dcl  create_data_segment_ entry (ptr, fixed bin (35));


/* The initialization stack definition */


dcl 1 inzr_stk0 aligned,
    2 header like stack_header,
    2 frame like stack_frame;

/*  */

	 unspec (inzr_stk0) = ""b;

/* Initialize the stack header pointers. */

	inzr_stk0.header.stack_begin_ptr
	     = ptr (null (), bin (rel (addr (inzr_stk0.frame)))
			     - bin (rel (addr (inzr_stk0))));
	inzr_stk0.header.stack_end_ptr = inzr_stk0.header.stack_begin_ptr;

/* Now set up call to create data segment */

	cdsa.sections (1).p = addr (inzr_stk0);
	cdsa.sections (1).len = size (inzr_stk0);
	cdsa.sections (1).struct_name = "inzr_stk0";

	cdsa.seg_name = name;
	cdsa.num_exclude_names = 1;
	cdsa.exclude_array_ptr = addr (exclude_pad);

	string (cdsa.switches) = "0"b;
	cdsa.switches.have_text = "1"b;

	call create_data_segment_ (addr (cdsa), code);
	return;


% include cds_args;
% include stack_header;
% include stack_frame;
     end inzr_stk0;


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
