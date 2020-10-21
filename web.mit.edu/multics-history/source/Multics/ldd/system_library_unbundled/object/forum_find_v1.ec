&version 2
&- **************************************************************
&- *                                                            *
&- * Copyright, (C) Massachusetts Institute of Technology, 1985 *
&- *                                                            *
&- **************************************************************
&-
&trace &command off
&goto &ec_name
&label ffv1
&label forum_find_v1
&default &undefined &[working_dir]
&if &[not [exists argument &1]] &then &do
  &print Usage:  ec ffv1 SUBTREE_ROOT {RESULT_DIR}
  &quit
&end
cwd &2
do "if [exists segment &&1] -then ""delete &&1"" " (LINKS MEETINGS LINK_ERRORS MEETING_ERRORS)
&-
io attach (forum_links_ forum_meetings_ forum_meeting_errors_ forum_link_errors_) vfile_ (LINKS MEETINGS MEETING_ERRORS LINK_ERRORS)
io open (forum_links_ forum_meetings_ forum_meeting_errors_ forum_link_errors_) stream_output
forum_find_v1$init_search
&-
file_output ERRORS -ssw error_output -truncate
walk_subtree &1 "forum_find_v1" -brief
revert_output -ssw error_output
io close (forum_links_ forum_meetings_ forum_meeting_errors_ forum_link_errors_)
io detach (forum_links_ forum_meetings_ forum_meeting_errors_ forum_link_errors_)
&quit
&-
&-
&-
&label convert_meetings
&default &undefined &[working_dir]
&if &[not [exists argument &1]] &then &do
  &print Usage:  ec convert_meetings MEETING_LIST {RESULT_DIR}
  &quit
&end
&-
io attach meeting_list vfile_ &(1)
io open meeting_list stream_input
&-
&set init_failed false
&on command_error &begin
     &set init_failed true
     &exit &continue
&end
&-
convert_meetings$init_convert
&-
&revert command_error
&if &(init_failed) &then &quit
&-
&on active_function_error &begin
  &goto no_more_meetings
&end
&-
file_output CONVERT_ERRORS -ssw error_output -truncate
&label next_meeting_
convert_meetings$convert_one_meeting [io get_line meeting_list]
&goto next_meeting_
&-
&label no_more_meetings
&revert active_function_error
revert_output -ssw error_output
io (close detach destroy) meeting_list
convert_meetings$cleanup_convert
&quit
&-
&-
&-
&-
&-
&label update_links
&default &undefined &[working_dir]
&if &[not [exists argument &1]] &then &do
  &print Usage:  ec update_links DIR_LIST {RESULT_DIR}
  &quit
&end
&-
io attach dir_list vfile_ &(1)
io open dir_list stream_input
&-
&on active_function_error &begin
  &goto no_more_dirs
&end
&-
file_output UPDATE_ERRORS -ssw error_output -truncate
&-
&on command_error &begin
     &if &(first_error_this_dir) &then &do
	io put_chars error_output ""
	io put_chars error_output "Errors for &(DIR):"
	io put_chars error_output ""
	&set first_error_this_dir false
     &end
     &exit &continue
&end
&-
&label next_dir_
&set first_error_this_dir true
&set DIR &[io get_line dir_list]
discard_output forum_add_meeting -dr &(DIR) -update
&goto next_dir_
&-
&label no_more_dirs
&revert active_function_error
revert_output -ssw error_output
io (close detach destroy) dir_list
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
