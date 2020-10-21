/* ***********************************************************
   *                                                         *
   *                                                         *
   * Copyright, (C) Honeywell Information Systems Inc., 1981 *
   *                                                         *
   *                                                         *
   *********************************************************** */

/**** format: ind3,ll80,initcol6,indattr,^inddcls,dclind4,idind16	       */
/**** format: struclvlind2,^ifthenstmt,^ifthendo,^ifthen,^indnoniterdo       */
/**** format: ^inditerdo,^indnoniterend,^indthenelse,case,^indproc,^indend   */
/**** format: ^delnl,^insnl,comcol41,^indcom,^indblkcom,linecom,^indcomtxt   */

xdw_defaults_: procedure;

/* automatic */

dcl code		fixed binary (35);
dcl wdir		char (168);

dcl 1 cdsa	aligned like cds_args;

dcl 1 lists	aligned,
      2 xdw,
        3 name_count fixed binary,
        3 path_count fixed binary,
        3 names	(1) char (32),
        3 paths	(2) like search_path;

/* based */

dcl 1 search_path	based,
      2 type	fixed binary,
      2 pathname	char (168);

dcl (addr, hbound, null, size, unspec) builtin;

/* entry */

dcl com_err_	entry options (variable);
dcl create_data_segment_ entry (pointer, fixed binary (35));
dcl get_wdir_	entry () returns (char (168));

%include sl_info;
%include cds_args;

/* program */

      lists.xdw.name_count = hbound (lists.xdw.names, 1);
      lists.xdw.path_count = hbound (lists.xdw.paths, 1);
      lists.xdw.names (1) = "xdw";
      lists.xdw.paths (1).type = REFERENCING_DIR;
      lists.xdw.paths (1).pathname = "-referencing_dir";
      lists.xdw.paths (2).type = WORKING_DIR;
      lists.xdw.paths (2).pathname = "-working_dir";

      unspec (cdsa) = ""b;
      cdsa.sections (1).p = addr (lists);
      cdsa.sections (1).len = size (lists);
      cdsa.sections (1).struct_name = "lists";
      cdsa.sections (2).p = null;
      cdsa.sections (2).struct_name = "";
      cdsa.seg_name = "xdw_defaults_";
      cdsa.exclude_array_ptr = null;
      cdsa.switches.have_text = "1"b;

      call create_data_segment_ (addr (cdsa), code);
      if code ^= 0
      then do;
         call com_err_ (code, "xdw_defaults_");
         return;
      end;

      wdir = get_wdir_ ();

      call add_search_names (lists.xdw.names (*));

      return;

add_search_names: proc (name_array);

dcl name_array	dimension (*) char (32) aligned parameter;

dcl hbound	builtin;
dcl lbound	builtin;

dcl error_table_$segnamedup fixed bin (35) ext static;

dcl hcs_$chname_file entry (char (*), char (*), char (*), char (*),
		fixed bin (35));

dcl i		fixed bin;
dcl extra_name	char (32);

      do i = lbound (name_array, 1) to hbound (name_array, 1);
         extra_name = rtrim (name_array (i)) || ".search";
         call hcs_$chname_file (wdir, "xdw_defaults_", "", extra_name, code);
         if code ^= 0
         then if code ^= error_table_$segnamedup
	    then call com_err_ (code, "xdw_defaults_", "Adding name ^a",
		  extra_name);
      end;

      return;
   end add_search_names;

   end xdw_defaults_;


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
