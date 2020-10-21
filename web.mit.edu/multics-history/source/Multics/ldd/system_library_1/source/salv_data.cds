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


/* format: style3 */

salv_data:
     procedure;

/* salv_data		- Salvager Ring Zero Data Base. */
/* Converted to create_data_segment_ April 6, 1976 by Bernard Greenberg */
/* fault-producer added BIM 2/82 */
/* Scavenger items added, July 1982, J. Bongiovanni */

dcl	1 salv_data	aligned,			/* salv data structure */
	  2 lock		aligned,
	    3 pid		bit (36) aligned init (""b),
	    3 event	bit (36) aligned init ("777777777776"b3),
	    3 flags	aligned,
	      4 notify_sw	bit (1) unaligned init ("0"b),
	      4 pad	bit (35) unaligned init (""b),
	  2 debug		bit (1) aligned init ("0"b),	/* want printout of normal deletion stuff */
	  2 dump		bit (1) aligned init ("0"b),	/* switch to dump dirs on error */
	  2 print_path	bit (1) aligned init ("0"b),	/* switch to print pathnames */
	  2 on_line	bit (1) aligned init ("0"b),	/* switch for on-line salvaging */
	  2 rpv		bit (1) aligned init ("0"b),	/* switch for rpv mode */
	  2 vol_read_ahead	fixed bin init (4),		/* page read ahead param */
	  2 debugging_fault_dir_checker
			bit (1) aligned init ("0"b),	/* If this is turned on, salv_dir_checker_ will intentionally take a fault! */
	  2 error_severity	fixed bin init (3),		/* syserr severity for fatal scavenger errors */
	  2 end		bit (0);


dcl	create_data_segment_
			entry (ptr, fixed bin (35));
dcl	com_err_		entry options (variable);
dcl	code		fixed bin (35);
dcl	1 cdsa		like cds_args aligned;
dcl	cleanup		condition;

dcl	excl		char (32) dim (3) init ("pad*", "end", "mark*");
dcl	(addr, currentsize, hbound, string, null)
			builtin;


	string (cdsa.switches) = "0"b;
	cdsa.have_text = "1"b;
	cdsa.sections (1).struct_name = "salv_data";
	cdsa.seg_name = "salv_data";
	cdsa.sections (1).p = addr (salv_data);
	cdsa.sections (1).len = currentsize (salv_data);
	cdsa.exclude_array_ptr = addr (excl);
	cdsa.num_exclude_names = hbound (excl, 1);
	call create_data_segment_ (addr (cdsa), code);
	if code ^= 0
	then call com_err_ (code, "salv_data", "creating data segment");
	return;

%include cds_args;
     end salv_data;


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
