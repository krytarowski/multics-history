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
ast_lock_meter_seg:
     proc;					/* AST_LOCK_METER_SEG - Metering data for the Global AST Lock

   Written November 1981 by J. Bongiovanni

*/

/*  Automatic  */


dcl	1 cdsa		aligned like cds_args;
dcl	code		fixed bin (35);

/*  Static  */

dcl	EXCLUDE_PAD	(1) char (32) aligned int static options (constant) init ("pad*");
dcl	MYNAME		char (32) int static options (constant) init ("ast_lock_meter_seg");


/*  Entry  */

dcl	com_err_		entry options (variable);
dcl	create_data_segment_
			entry (ptr, fixed bin (35));
dcl	get_temp_segment_	entry (char (*), ptr, fixed bin (35));
dcl	release_temp_segment_
			entry (char (*), ptr, fixed bin (35));

/*  Condition  */

dcl	cleanup		condition;
%page;
	ast_lock_meter_segp = null ();

	on cleanup goto CLEAN_UP;

	call get_temp_segment_ (MYNAME, ast_lock_meter_segp, code);
	if code ^= 0
	then do;
		call com_err_ (code, MYNAME, "Getting temp segment");
		return;
	     end;

	ast_lock_meters.n_entries = 1;
	ast_lock_meters.max_n_entries = 1024;
	ast_lock_meters.meters (1).caller = null ();

	unspec (cdsa) = "0"b;
	cdsa.sections (1).p = ast_lock_meter_segp;
	cdsa.sections (1).len = currentsize (ast_lock_meters);
	cdsa.sections (1).struct_name = "ast_lock_meters";

	cdsa.seg_name = "ast_lock_meter_seg";
	cdsa.num_exclude_names = 1;
	cdsa.exclude_array_ptr = addr (EXCLUDE_PAD);

	cdsa.switches.have_text = "1"b;

	call create_data_segment_ (addr (cdsa), code);
	if code ^= 0
	then call com_err_ (code, MYNAME);

CLEAN_UP:
	if ast_lock_meter_segp ^= null ()
	then call release_temp_segment_ (MYNAME, ast_lock_meter_segp, code);


%page;
%include cds_args;
%page;
%include ast_lock_meters;
     end ast_lock_meter_seg;


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
