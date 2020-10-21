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


sst_seg: procedure ();

/* This creates the sst_seg database. Because there are no initializations performed herein,
   the sst is simply declared as an automatic buffer, since it is not necessary to take
   base-relative offsets. */

/* Rewritten 04/19/81, W. Olin Sibert */

dcl  code fixed bin (35);
dcl 1 cdsa like cds_args aligned;
dcl 1 sst_automatic aligned like sst automatic;

dcl  create_data_segment_ entry (ptr, fixed bin (35));
dcl  com_err_ entry options (variable);

dcl  WHOAMI char (32) internal static options (constant) init ("sst_seg");
dcl  EXCLUDE_ARRAY (1) char (32) internal static options (constant) init ("pad*");

dcl (addr, dimension, null, size) builtin;

/*  */

	sstp = addr (sst_automatic);			/* Fill our automatic copy with zeros */
	unspec (sst) = ""b;

	if size (sst) ^= 512 then do; 		/* Bad */
	     call com_err_ (0, WHOAMI, "The sst structure must be exactly 512 words long, not ^d.", size (sst));
	     return;
	     end;

	unspec (cdsa) = ""b;
	cdsa.have_text = "1"b;
	cdsa.p (1) = sstp;
	cdsa.len (1) = size (sst);
	cdsa.struct_name (1) = "sst";

	cdsa.seg_name = WHOAMI;
	cdsa.num_exclude_names = dimension (EXCLUDE_ARRAY, 1);
	cdsa.exclude_array_ptr = addr (EXCLUDE_ARRAY);

	call create_data_segment_ (addr (cdsa), code);

	if code ^= 0 then
	     call com_err_ (code, WHOAMI, "Creating sst_seg.");

	return;

%page; %include cds_args;
%page; %include sst;

	end sst_seg;


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
