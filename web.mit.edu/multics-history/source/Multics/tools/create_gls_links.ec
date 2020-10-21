&  ***********************************************************
&  *                                                         *
&  * Copyright, (C) Honeywell Information Systems Inc., 1982 *
&  *                                                         *
&  ***********************************************************

& 
& 
&  HISTORY COMMENTS:
&   1) change(86-12-18,Fawcett), approve(86-12-18,PBF7517),
&      audit(86-12-18,GDixon), install(87-01-05,MR12.0-1257):
&      Remove BOS for MR12.0.
&                                                       END HISTORY COMMENTS
& 
& 
&
&  Modified 85 May 7 by Art Beattie to remove add_name commands that referenced
&    languages and network libraries.
&
&command_line off
link >system_library_tools>unbundled.object.control
link >system_library_tools>unbundled.control
link >system_library_tools>tools.object.control
link >system_library_tools>tools.control
link >system_library_tools>standard.object.control
link >system_library_tools>standard.control
link >system_library_tools>online_systems.object.control
link >system_library_tools>online_systems.control
link >system_library_tools>info_files.control
link >system_library_tools>include.control
link >system_library_tools>hardcore.control
link >system_library_tools>hardcore.object.control
link >system_library_tools>communications.object.control
link >system_library_tools>communications.control
add_name unbundled.object.control unb.o.control
add_name unbundled.control unb.control
add_name tools.object.control t.o.control
add_name tools.control t.control
add_name standard.object.control sss.o.control
add_name standard.control sss.control
add_name online_systems.object.control os.o.control
add_name online_systems.control os.control
add_name info_files.control info.control
add_name include.control incl.control
add_name hardcore.control hard.control h.control
add_name hardcore.object.control hard.o.control h.o.control
add_name communications.object.control com.o.control
add_name communications.control com.control
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
