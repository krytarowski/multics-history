/* ***********************************************************
   *                                                         *
   * Copyright, (C) Honeywell Information Systems Inc., 1984 *
   *                                                         *
   *********************************************************** */

cache_threshold_defaults_:
     proc;

/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  * */
/*									*/
/* cache_threshold_defaults_ - this segment contains the default cache threshold values	*/
/* as defined by HIS (LCPD HW Eng.) as an acceptable error rate for the cache memory in	*/
/* the  L68, DPS68 and DPS8 processors.						*/
/*									*/
/* Created: 2/84 by GA Texada							*/
/*									*/
/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  * */


/* format: style1,ind2,^inddcls,ifthenstmt,dclind2,declareind2,ifthendo,ifthen*/

dcl code		     fixed bin (35),
  1 cdsa		     aligned like cds_args,
  1 cache_threshold_defaults_ aligned like cache_threshold_data;

dcl (addr, null, size, string, unspec) builtin;

dcl com_err_	     entry () options (variable),
  create_data_segment_   entry (ptr, fixed bin (35));


	unspec (cache_threshold_defaults_) = ""b;	/* start clean				*/
	cache_threshold_defaults_.pri_dir_parity = 4;	/* L68 use only				*/
	cache_threshold_defaults_.port_buffer(*) = 1;	/* HW Eng. said .2, but...			*/
	cache_threshold_defaults_.pri_dir = 2;
	cache_threshold_defaults_.wno_parity_any_port = 1;/* HW Eng. said .4 but...			*/
	cache_threshold_defaults_.dup_dir_parity(*) = 1;
	cache_threshold_defaults_.dup_dir_multimatch = 0; /* These are NOT acceptable			*/

	cdsa.sections (1).p = addr (cache_threshold_defaults_);
	cdsa.sections (1).len = size (cache_threshold_defaults_);
	cdsa.sections (1).struct_name = "cache_threshold_defaults_";
	cdsa.seg_name = "cache_threshold_defaults_";
	cdsa.num_exclude_names = 0;
	cdsa.exclude_array_ptr = null ();
	string (cdsa.switches) = "0"b;
	cdsa.switches.have_text = "1"b;
	call create_data_segment_ (addr (cdsa), code);
	if code ^= 0 then call com_err_ (code, "cache_threshold_defaults_");
	return;

%include cache_threshold_data;

%include cds_args;
     end cache_threshold_defaults_;


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
