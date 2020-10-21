&command_line off
&input_line off
&ready off
&comment_line off
&control_line off
&goto ENTRY &ec_name


This ec is used to create a new lisp from scratch, or as close to scratch as we
ever care to come.  Since it would take SO long to compile the compiler
interpretively, we cheat and use the existing lisp compiler.  This ec exists to
handle the various peculiarities of the installation procedure; for example,
that none of the pl1 programs that actually make up the interpreter can be
compiled with -optimize.

This ec takes no command line arguments; it prompts for everything it needs.
If you read all the comments that precede the third executable statement, you
will understand how to use this ec, via its main entrypoint:

		make_lisp_interpreter.ec

The subroutine entrypoints are designed to be used to facilitate lisp
development; don't call them directly unless you know how the ec works.  It is
pretty self contained; it adds all the names to itself that it needs.  Note
that leaving out all the comment chars in this document not only made it easier
to edit, but significantly improves the performance of this ec.

This ec produces the following six object programs to be installed in a system
library:

		bound_lisp_intrprtr_
		bound_lisp_compiler_
		bound_lisp_library_
		lisp_standard_environment_
		compiler.sv.lisp
		lap.sv.lisp

It also produces three directories, which respectively contain the source
archives, the object archives, and the include files.  This contents of these
directories are to be installed in various places in LDD.  The archives are
ready for installation; the names of all the archive components are on the
archives, they have been sorted, and the bound segments have been produced
using the object archives as they are.

Not all of the include files need be installed; all the include files which are
specific to lisp will be in the directory; a list of changed include files
which must be replaced is produced by the ec as it runs.  Any include file
which has "lisp" as part of its name, and perhaps others, which do not appear
in this directory are obsolete and may be deleted.  Consult installation
instructions, if any, for a list of such segments, if any.


Written:  14 January 1980 by J. Spencer Love
This ec uses the following programs which are not part of standard service:

     memory (mem)	  The RDMS variable managing program for exec_coms.  This
		  can be found in >libraries>rdms at MIT.  It must be used
		  until either an exec_com with variables is ready or until
		  Honeywell installs an acceptable substitute.

     match (nomatch)  These functions starmatch their first argument against
		  all the rest of their arguments, and return all the
		  strings that meet the named criterion.  They can be found
		  in >udd>p>jsl>s at MIT.  They must be used until the
		  arguments active function can be completed and installed.

     target	  This function returns the pathname of the target of a
		  link.  It differs from status -link_path in that it
		  always returns a branch, and works correctly if given a
		  branch.  Versions exist at MIT in the AML and in the
		  Multics project library.  Maybe this will make standard
		  service some day.

It also depends on the nested &if feature of the exec_com command in >exl>ecd.
If this ec is run in an absentee process, the directions outlined in
>exl>info>exec_com.usage.info must be followed.  This exec_com exists on both
MIT and System M, and will be installed in SSS at some time in the future.

The object files for lisp itself (the six object files created by this ec) and
for these four programs must be shipped to all sites where Multics Lisp is to
be brought up, subject to changes in this ec outlined above.  Naturally, if
lisp is not to be recompiled at the site, only the six object programs produced
by this ec need be shipped.
		
The following memory variables are used:

     newsourcedir	This directory contains the source being picked up, in
		archives.  The names must be of the form bound*_.**.s.archive,
		the first component must be the same as the associated bound
		segment name, and all the names of components must be on the
		archive segments.  Also, the include files which are used must
		be in the segment include_files.archive, in this directory.
		The bind files must be in this directory, either free
		standing or as part of an archive.  Links in this directory
		can be used to pick up non-include files from the online
		libraries or anywhere else.  Note that, if a file is part of
		an archive, the primary  name of the segment or link must end
		in ".archive" so the file will be extracted, not copied.
		This is prompted for.

     version	This is the version number printed out by the new lcp when
		invoked.  This is prompted for.

     workdir	This directory will be the working directory during the
		execution of this ec.  It will be created if it does not
		already exist, and it must be initially empty (it will ask
		permission to clear it if it isn't), so this ec cannot reside
		there.  At the end, it will contain all the executable
		objects to be installed.  It will also contain three
		subdirectories which contain the source and object archives
		and all the include files, which are respectively to be
		installed various places in LDD.  This is prompted for.
     listdir	This directory contains all the compilation listings.  It
		should have lots of quota.  It will also contain copies of
		the ec's, for dprinting.  This directory is not created as
		a subdir of workdir since about 2000 records of quota are
		needed to store the listings, and thus better control over
		this directory may be desired.  This is prompted for.
		
     cmplrdir	This directory contains the lisp compiler used to compile the
		compiler.  This is prompted for.

     envdir	This directory WILL CONTAIN the new lisp library when it is
		installed.  It is used for autoload initialization.  It is
		very important that this be correct, or tracing, the
		grinder and the lap function (not eq to the lap command)
		will not initialize properly.  This is prompted for.

     sourcedir	This directory will contain the source archives in
		installable form and the file include_files.archive, which
		contains all the include files to be installed in LDD.
		This directory is automatically created as a subdirectory
		of workdir.

     objectdir	This directory will contain the object archives in
		installable form.  This directory is automatically created
		as a subdirectory of workdir.

     incldir	This directory will contain all the include files to be
		installed in LDD.  This directory is automatically created
		as a subdir of workdir.

     retry_later	This is a list of pl1 programs which compiled with severity
		greater than zero.  The arguments to the compile_sources
		entrypoint and this become the value of sources when the
		compile_sources entrypoint is used.

     sources	This is a list of all the pl1, alm, and lisp programs to
		compile.  It is used by the compile_sources entrypoint.

     source	Name of the source archive or freestanding file, with the
		value of sourcedir prepended.

     object	Name of the object archive, or the first component of the
		name of the freestanding file, with the value of objectdir
		prepended.

     command	Unsuffixed name of the file currently being processed.
&label ENTRY
&print You are using the wrong version of exec_com.  Initiate the EXL version by typing "in >exl>ecd>ec -fc -a", then retry.
&quit


&label ENTRY get_for_lisp
&
memory set source [status -pri ||[mem newsourcedir]>&r1]
memory set object ||[spe ||[mem source]]
&if [equal &r1 ||[mem source]]
&then &goto NOT_IN_ARCHIVE &ec_name
answer yes -brief "archive x ||[mem newsourcedir]>||[mem source] ||[mem workdir]>&r1"
memory set object ||[spe ||[mem object] s].archive
&goto HAVE_SOURCE &ec_name

&label NOT_IN_ARCHIVE get_for_lisp
answer yes -brief "copy ||[mem newsourcedir]>&r1 ||[mem workdir]>=="
&
&label HAVE_SOURCE get_for_lisp
&if [not [exists entry &r1]]	
&then &goto ABORT
memory set command [spe &r1]
&quit


&label ENTRY get_for_bootstrap
&
memory set source [status -pri ||[mem sourcedir]>&r1]
memory set object ||[spe ||[mem source]]
&if [equal &r1 ||[mem source]]
&then &goto NOT_IN_ARCHIVE &ec_name
answer yes -brief "archive x ||[mem sourcedir]>||[mem source] ||[mem workdir]>&r1"
memory set object ||[spe ||[mem object] s].archive
&goto HAVE_SOURCE &ec_name

&label NOT_IN_ARCHIVE get_for_bootstrap
answer yes -brief "copy ||[mem sourcedir]>&r1 ||[mem workdir]>=="
&
&label HAVE_SOURCE get_for_bootstrap
&if [not [exists entry &r1]]
&then &goto ABORT
memory set command [spe &r1]
&quit


&label ENTRY save_for_lisp
&
&if [equal .[suffix ||[mem &r1]] .archive]
&then archive [default rd &r3] ||[mem &r1dir]>||[mem &r1] &r2
&else &if [exists argument &r3]
&then answer yes -brief "copy &r2 ||[mem &r1dir]>=="
&else answer yes -brief "move &r2 ||[mem &r1dir]>=="
&quit
&label ENTRY compile_for_lisp
&
ec &ec_dir>get_for_lisp &r2
&goto COMPILE

&label ENTRY compile_for_bootstrap
ec &ec_dir>get_for_bootstrap &r2
&
&label COMPILE
&if [not [exists argument &r3]] &then &goto COMPILE_NOLIST
link ||[mem listdir]>||[mem command].list
ioa_ "^/Compiling ^a" &r2
&rf1
unlink ||[mem command].list
&goto EXIT &ec_name

&label COMPILE_NOLIST
&
ioa_ "^/Compiling ^a" &r2
&rf1
&goto EXIT &ec_name

&label EXIT compile_for_lisp
&
&if [equal &r1 pl1]
&then &if [ngreater [severity &r1] 0]
&then memory set retry_later ||[do "&rf(1)" &r2 |[mem retry_later]]
&
ec &ec_dir>save_for_lisp source &r2
ec &ec_dir>save_for_lisp object ||[mem command]
memory set sources ||[&ec_dir>nomatch &r2 |[mem sources]]
&quit

&label EXIT compile_for_bootstrap
&
&if [equal &r1 pl1]
&then &if [ngreater [severity &r1] 0]
&then memory set retry_later ||[do "&rf(1)" &r2 |[mem retry_later]]
&
delete &r2
ec &ec_dir>save_for_lisp object ||[mem command]
memory set bootsources ||[&ec_dir>nomatch &r2 |[mem bootsources]]
&quit
&label ENTRY bind_for_lisp
&
&if [exists argument [&ec_dir>match &r2.bind [archive_table (|[segs ||[mem objectdir]>&r2.**.archive -absolute_pathname])]]]
&then &goto HAVE_BINDFILE
&
ec &ec_dir>get_for_lisp &r2.bind
&if [exists segment ||[mem objectdir]>&r2.1.archive]
&then archive ad ||[mem objectdir]>&r2.1 &r2.bind
&else archive ad ||[mem objectdir]>&r2 &r2.bind
ec &ec_dir>process_archive (|[segs ||[mem objectdir]>&r2.**.archive -absolute_pathname])
&
&label HAVE_BINDFILE
&print
bind |[segs ||[mem objectdir]>&r2.**.archive -absolute_pathname]
delete_acl &r2 .. *.SysDaemon.*
set_acl &r2 re *.*.*
answer yes -brief "move &r2 ||[mem executabledir]>=="
memory set &r1 ||[&ec_dir>nomatch &r2.bind |[mem &r1]]
&quit


&label ENTRY process_archive
&
archive_sort &r1
delete_name [directory &r1]>([&ec_dir>nomatch **.*.archive [status -name &r1]])
add_name &r1 [archive_table &r1]
&quit
&label ENTRY rdc_pl1_macro
&
ec &ec_dir>get_for_lisp &r1.rd
ioa_ "^/Compiling ^a.rd" &r1
rdc &r1
ec &ec_dir>save_for_lisp source &r1.rd
&
link ||[mem listdir]>&r1.list
ioa_ "^/Compiling ^a.pl1" &r1
pl1 &r1 -map -optimize
&if [ngreater [severity pl1] 1]
&then &goto ABORT
unlink &r1.list
ec &ec_dir>save_for_lisp object &r1 r
&
ec &ec_dir>get_for_lisp &r2.macro
initiate &r1 -force
ioa_ "^/Compiling ^a.macro" &r2
&r1 &r2.macro
delete &r1.pl1 &r1
ec &ec_dir>save_for_lisp source &r2.macro
&
&if [not [exists segment &r2.alm]]
&then &goto SAVE_INCLUDE
&
link ||[mem listdir]>&r2.list
ioa_ "^/Compiling ^a.alm" &r2
alm &r2 -list
unlink &r2.list
delete &r2.alm
ec &ec_dir>save_for_lisp object &r2
&
memory set sources ||[&ec_dir>nomatch &r2.macro |[mem sources]]
&quit
&
&label SAVE_INCLUDE
answer yes -brief "move &r2.incl.alm ||[mem incldir]>=="
&
memory set sources ||[&ec_dir>nomatch &r2.macro |[mem sources]]
&quit
&label ENTRY initialize
&
initiate &ec_dir>memory memory mem -force
&
&if [or [equal "&q1" (-restart -rs)]] &then &goto SKIP_INIT
&if [exists argument &r1] &then &goto ABORT
&
memory set newsourcedir [path ||[response "New source directory?"]]
memory set version ||[response "Compiler version?"]
memory set workdir [path ||[response "Staging directory?"]]
memory set listdir [path ||[response "Listing directory?"]]
memory set cmplrdir [path ||[response "Existing lisp directory?"]]
memory set envdir [path ||[response "Directory to be installed in?"]]
&
memory set sources ||[do "&rf(1)" [archive_table ([segs ||[mem newsourcedir]>bound*.**.s.archive -absolute_pathname])] [segs ||[mem newsourcedir]>*.bind]]
memory set retry_later ""
&
&if [not [exists directory ||[mem listdir]]]
&then on command_error,command_question "" -brief "create_dir ||[mem listdir]"
&
&if [not [exists directory ||[mem workdir]]]
&then &if [on command_error,command_question "" "create_dir ||[mem workdir]"]
&then &goto ABORT
&
change_wdir ||[mem workdir]
&if [exists entry **]
&then &if [query "Clear staging directory?"]
&then answer yes -brief "delete ** -brief; delete_dir ** -brief; unlink ** -brief"
&else &goto ABORT
&
&if [not [exists directory ||[mem listdir]]]
&then &if [on command_error,command_question "" "create_dir ||[mem listdir]"]
&then &goto ABORT
&
memory set (source object executable incl)dir ||[mem workdir]>(source object executable include)
create_dir ||[mem (source object executable incl)dir]
add_name (||[mem (source object executable incl)dir]) (s o e incl)
&
&label SKIP_INIT
&
memory set sources ||[do "&rf(1)" |[mem retry_later] |[mem sources]]
memory set retry_later ""
&
&if [exists argument |[&ec_dir>match *.lisp |[mem sources]]]
&then memory set bootsources ||[do "&rf(1)" [archive_table ([segs ||[mem newsourcedir]>bound*.**.s.archive -absolute_pathname])] [segs ||[mem newsourcedir]>*.bind]]
&if [exists argument |[mem bootsources]]
&then memory set cobsources ||[match *.lisp [archive_table ([segments ||[mem newsourcedir]>*.**.s.archive -absolute_pathname])]]
&
&if [exists entry ||[mem incldir]>**.*.incl.*]
&then &goto SKIP_EXTRACT
change_wdir ||[mem incldir]
archive x ||[mem newsourcedir]>include_files.archive
&if [not [exists entry lisp_backquote_]]
&then link ||[mem cmplrdir]>lisp_backquote_
&label SKIP_EXTRACT
&						NOTE: THE FOLLOWING DEPENDS ON THE INCLUDE LIBRARY ORGANIZATION
&						      IF THIS CHANGES, IT MUST BE REFLECTED HERE.
set_search_paths translator ||[mem incldir] >ldd>include
&
change_wdir ||[mem workdir]
&
&quit
&label ENTRY make_lisp_interpreter
&
discard_output -osw error_output "add_name [&ec_dir>target &r0] (compile_for_lisp.ec rdc_pl1_macro.ec make_environments.ec get_for_lisp.ec bind_for_lisp.ec save_for_lisp.ec process_archive.ec initialize.ec cob_lcp_lisp_module.ec get_for_bootstrap.ec compile_for_bootstrap.ec)"
&
ec &ec_dir>initialize &r1
&
&if [exists argument [match lisp_subr_tv_.macro |[mem sources]]]
&then ec &ec_dir>rdc_pl1_macro compile_lisp_subr_tv lisp_subr_tv_
&
&if [exists argument [match lisp_error_table_.macro |[mem sources]]]
&then ec &ec_dir>rdc_pl1_macro compile_lisp_error_table lisp_error_table_
&
ec &ec_dir>compile_for_lisp pl1 ([match *.pl1 |[mem sources]]) -map -brief_table
&
ec &ec_dir>compile_for_lisp alm ([match *.alm |[mem sources]]) -list
&
initiate ||[mem cmplrdir]>bound_lisp_(intrprtr compiler library)_ -all -force
ec &ec_dir>compile_for_lisp lcp ([match *.lisp |[mem sources]])
&
ec &ec_dir>bind_for_lisp sources ([spe ([match *.bind [mem sources]]) bind])
&
&if [exists argument |[mem bootsources]]
&then ec &ec_dir>make_environments ||[mem version]
& ***Append version with X if to be installed in EXL***
ec &ec_dir>process_archive ([segments ||[mem sourcedir]>**.*.archive -absolute_pathname])
&
&print ^/Starting bootstrap.^/
unlink ||[mem incldir]>lisp_backquote_
link ||[mem executabledir]>lisp_backquote_ ||[mem incldir]>==
initiate ||[mem executabledir]>bound_lisp_(intrprtr compiler library)_ -all -force

&
& The following code is to be executed only if new c/g strategies are introcued
& in lcp, it doesn't work correctly and should be fixed if used
&
& ec &ec_dir>compile_for_bootstrap lcp ([match *.lisp [mem bootsources]]) -list
& &
& ec &ec_dir>bind_for_lisp bootsources ([spe ([match *.bind [mem bootsources]]) bind])
& &
& ec &ec_dir>make_environments ||[mem version]
& &

& The following statement causes all the lisp programs in lcp
& to be compiled and compared 
ec &ec_dir>cob_lcp_lisp_module ([mem cobsources])
&



&if [exists entry ||[mem sourcedir]>make_lisp_interpreter.ec]
&then &if [nequal [status ||[mem sourcedir]>make_lisp_interpreter.ec -uid] [status &r0 -uid]]
&then &quit
&else delete ||[mem sourcedir]>make_lisp_interpreter.ec
answer yes -brief "copy &r0 ||[mem sourcedir]>make_lisp_interpreter.ec"
&
delete_acl (||[mem (source object incl)dir])>** .. *.SysDaemon.*
set_acl (||[mem (source object incl)dir])>** r *.*.*
&
&print ^/Done.^/
&print The directory which contains backquote.incl.lisp must have a link to the 
&print installed version of lisp_backquote_ (in bound_lisp_library_).
&
&quit

&label ENTRY make_environments
&
initiate ||[mem executabledir]>bound_lisp_(intrprtr compiler library)_ -all -force
ec &ec_dir>get_for_lisp lisp_standard_environment_.ec
answer yes -brief "add_name lisp_standard_environment_.ec lisp_nostartup.ec"
&print ^/Compiling lisp_nostartup.sv.lisp
ec lisp_nostartup ||[mem envdir] ||[mem executabledir]
&print ^/Compiling lisp_standard_environment_
ec lisp_standard_environment_ ||[mem envdir] ||[mem executabledir]
&if [not [exists entry ||[mem listdir]>lisp_standard_environment_.ec]]
&then copy ||[mem workdir]>lisp_standard_environment_.ec ||[mem listdir]>==
ec &ec_dir>save_for_lisp source lisp_standard_environment_.ec
delete_acl lisp_standard_environment_ .. *.SysDaemon.*
set_acl lisp_standard_environment_ r *.*.*
answer yes -brief "move lisp_standard_environment_ ||[mem executabledir]>=="
&
initiate ||[mem executabledir]>bound_lisp_(intrprtr compiler library)_ -all -force
ec &ec_dir>get_for_lisp make_lcp.ec
&print ^/Compiling compiler.sv.lisp
ec make_lcp &r1 ||[mem envdir] ||[mem executabledir] ||[mem executabledir] ||[mem executabledir]
&if [not [exists entry ||[mem listdir]>make_lcp.ec]]
&then copy ||[mem workdir]>make_lcp.ec ||[mem listdir]>==
ec &ec_dir>save_for_lisp source make_lcp.ec
delete_acl compiler.sv.lisp .. *.SysDaemon.*
set_acl compiler.sv.lisp r *.*.*
answer yes -brief "move compiler.sv.lisp ||[mem executabledir]>=="
&
initiate ||[mem executabledir]>bound_lisp_(intrprtr compiler library)_ -all -force
ec &ec_dir>get_for_lisp make_lap.ec
&print ^/Compiling lap.sv.lisp
ec make_lap ||[mem executabledir]
&if [not [exists entry ||[mem listdir]>make_lap.ec]]
&then copy ||[mem workdir]>make_lap.ec ||[mem listdir]>==
ec &ec_dir>save_for_lisp source make_lap.ec
delete_acl lap.sv.lisp .. *.SysDaemon.*
set_acl lap.sv.lisp r *.*.*
answer yes -brief "move lap.sv.lisp ||[mem executabledir]>=="
&
delete lisp_nostartup.sv.lisp
&
&print ^/Finished making environments.^/
&quit
&label ENTRY cob_lcp_lisp_module
&
ioa_ "^/Compiling ^a" &r1
&
ec &ec_dir>get_for_bootstrap &r1
&
file_output ||[mem listdir]>||[mem command].cob -truncate
&
initiate ||[mem executabledir]>bound_lisp_(intrprtr compiler library)_ -all -force
lcp &r1
&
rename ||[mem command] ===.new
ac x ||[mem objectdir]>||[mem object] ||[mem command]
&
ioa_ "^2/Comparing ^a.boot1 with ^a.boot2:^/" &r1 &r1
ioa_$ioa_stream user_i/o "Comparing ^a" &r1
&
compare_object ||[mem command] ||[mem command].new
&
revert_output
&
delete ||[mem command] ||[mem command].new &r1
memory set cobsources ||[&ec_dir>nomatch &r1 |[mem cobsources]]
&
&quit


&label ABORT
signal can't_make_lisp
&goto ABORT
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
