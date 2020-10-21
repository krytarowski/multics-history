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


active_all_rings_data: procedure;

/* CDS source for the former active_all_rings_data.alm */
/* This data is only accessable out to ring 5. */
/* coded by Benson I. Margulies April 1981. */
/* the data is in the text section, but it gets patched in initialization */
/* Modified November 1984 by Keith Loepere to move pam flush stuff to
   active_hardcore_data. */
/* format: style2 */

%include cds_args;
	declare 1 cdsa		 aligned like cds_args;

	declare com_err_		 entry () options (variable);
	declare create_data_segment_	 entry (ptr, fixed bin (35));

	declare code		 fixed bin (35);
	declare (addr, currentsize, string, unspec)
				 builtin;

	declare 1 aard		 aligned,		/* automatic structure */
		2 system_id	 character (32),	/* sysid from system tape. */
		2 version_id	 character (32),	/* supervisor version, = MIT system # */
		2 initializer_tty	 character (32),	/* initial console attachment name. */
		2 initializer_dim	 character (32),	/* initial console io module */
		2 hcscnt		 fixed bin (35),	/* # of hardcore segments */
		2 default_max_segno	 fixed bin (35),	/* dseg size by default */
		2 max_segno	 fixed bin (35),	/* max Multics can do */
		2 maxlinks	 fixed bin (35),	/* we will not chase past this many */
		2 max_tree_depth	 fixed bin (35),	/* this many greater thans */
		2 stack_base_segno	 fixed bin (35);	/* stack 0 */

	unspec (aard) = ""b;

	aard.max_tree_depth = 15;			/* that many >'s in a pathname */

/* These next two should be filled in by generate_mst, but
   this puts something recognizable in just in case */

	aard.system_id, aard.version_id = "Unknown";

/* otw_ is a magic thing that means to call ocdcm_ through hphcs_
   to share a console with the hardcore. other things would allow
   the use of, say, lcc channels. */

	aard.initializer_tty = "otw_";

/* ocd_ runs a console. FNP channels cannot be used because 
   they are not loaded in ring 1. */

	aard.initializer_dim = "ocd_";

	aard.default_max_segno = 1023;
	aard.max_segno = 4093;
	aard.maxlinks = 10;
	aard.max_tree_depth = 15;

	cdsa.sections (1).p = addr (aard);
	cdsa.sections (1).len = currentsize (aard);
	cdsa.sections (1).struct_name = "aard";
	cdsa.seg_name = "active_all_rings_data";
	cdsa.num_exclude_names = 0;			/* no pad fields to flush */
	string (cdsa.switches) = ""b;
	cdsa.switches.have_text = "1"b;
	call create_data_segment_ (addr (cdsa), code);
	if code ^= 0
	then call com_err_ (code, "active_all_rings_data");
	return;
     end active_all_rings_data;



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
