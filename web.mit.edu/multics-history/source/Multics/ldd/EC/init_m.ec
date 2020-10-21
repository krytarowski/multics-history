&         MCS MODIFICATION EXEC_COMs
&
&goto &ec_name


&  CREATE MCS MODIFICATION AND LISTING DIRECTORIES
&
&label init_m
&command_line off
&if [ nequal &n 1 ] &then &else &goto init_mUSAGE
&if [ equal &1 help ] &then &goto init_mUSAGE
&if [ nequal 0 [ index &1 . ] ] &then &goto BAD_VERSION
& &if [ nless [ length &1 ] 4 ] &then &goto BAD_VERSION
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &goto MCS_VERSION_EXISTS

&print
&print _________________________________
&print
&if [ query "Create MCS modification directory for MCS Version &1?" ] &then &else &quit
&print
&print
&print Creating MCS modification directory, >ldd>mcs>mcs.&1.
&print
create_dir >ldd>mcs>mcs.&1
delete_acl >ldd>mcs>mcs.&1
set_iacl_seg >ldd>mcs>mcs.&1 rew *.SysLib rew *.SysMaint

&print Creating MCS listings directory, >ldd>listings>mcs>&1.
&print
create_dir >ldd>listings>mcs.&1
delete_acl >ldd>listings>mcs.&1
set_iacl_seg >ldd>listings>mcs.&1 rw *.SysLib rw *.SysMaint

change_wdir >ldd>mcs>mcs.&1
&print
&print &ec_name:  You are now in the MCS &1 modification directory.
&print
&print _________________________________
&print
&quit

&label init_mUSAGE
&print
&print Usage is:    ec init_m MCS_VERSION
&print where:       MCS_VERSION is version number of new MCS system being created.
&print example:     ec init_m 2.02
&quit

&label MCS_VERSION_EXISTS
&print
&print &ec_name:  Directory already exists.  >ldd>mcs>mcs.&1
&print Modification directories for MCS Version &1 have already been created.
&quit

&label BAD_VERSION
&print
&print &ec_name:  &1 is a bad MCS version number.  It must have the form-
&print              major_no.minor_no
&print    like:  2.02
&print
&quit
&   
&  COMPILE MCS SOURCE AND MACRO SEGMENTS
&
&label compile_m
&command_line off

&if [ ngreater &n 1 ] &then &else &goto compile_mUSAGE
&if [ equal &1 help ] &then &goto compile_mUSAGE
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &else &goto NO_MOD_DIR
&if [ exists directory >ldd>listings>mcs.&1 ] &then &else &goto NO_LIST_DIR
change_wdir >ldd>mcs>mcs.&1
&print
exec_com >LDD>EC>compile_mcs_seg >ldd>listings>mcs.&1 (&f2)
&print
&print _________________________________
&print
&print &ec_name: Compilations done.
&quit

&label NO_MOD_DIR
&print
&print &ec_name:  Directory not found.  >ldd>mcs>mcs.&1
&print Use >LDD>EC>init_m.ec to create MCS modification directory.
&quit

&label NO_LIST_DIR
&print
&print &ec_name:  Directory not found.  >ldd>listings>mcs.&1
&print Use >LDD>EC>init_m.ec to create MCS listings directory.
&quit

&label compile_mUSAGE
&print
&print Usage is:    ec compile_m MCS_VERSION source_names
&print where:       source_names are names of MCS programs to be compiled,
&print    including the map355 suffix.
&quit
&  
&  COMPILE A SINGLE MCS SOURCE OR MACRO SEGMENT
&
&label compile_mcs_seg
&command_line off
&if [ nequal &n 2 ] &then &else &goto compile_mcs_segUSAGE
&if [ equal &1 help ] &then &goto compile_mcs_segUSAGE
&print _________________________________
&print

&  check suffix and name of source
&
&if [ exists argument [ suffix &2 ] ] &then &else &goto NO_SUFFIX_GIVEN
&if [ equal [ suffix &2 ] map355 ] &then &else &goto UNKNOWN_SOURCE_TYPE
&if [ equal &2 macros.map355 ] &then &goto COMPILE_MACROS

&  compile source segment
&
&command_line on
&if [ exists segment 355_macros ]
&then map355 &2 -list -macro_file 355_macros
&else map355 &2 -list
&print
&print
&command_line off

&  move listings to MCS listings directory
&
exec_com >LDD>EC>MOVE_LISTING_ &1 [ entry [ strip &2 map355 ].list ]
&quit

&label compile_mcs_segUSAGE
&print
&print Usage is:    ec compile_mcs_seg listing_path source_name
&print where:       listing_path is directory where compilation listings are put, and
&print    source_name is name of MCS segment to be compiled, including map355 suffix.
&quit

&label NO_SUFFIX_GIVEN
&print
&print &ec_name:  No suffix was given for source segment.  &2
&print Assuming map355 suffix.  &2.map355
&print
&print
exec_com &ec_dir>&ec_name &1 &2.map355 &f3
&quit

&label UNKNOWN_SOURCE_TYPE
&print
&print &ec_name:  Source type unknown. &2
&print &ec_name does not know how to compile the segment.
&print
&print
&quit
&  
&  COMPILE AN MCS MACRO SEGMENT
&
&label COMPILE_MACROS
&if [ exists segment 355_macros ]               &then delete 355_macros
&if [ exists segment macros_asm.sysprint ]      &then delete macros_asm.sysprint
&if [ exists segment macros_asm.sysprint.list ] &then delete macros_asm.sysprint.list
&command_line on
&if [ exists segment macros_asm ]
&then gcos macros_asm -list -lower_case -brief -truncate
&else gcos >ldd>mcs>info>macros_asm -list -lower_case -brief -truncate
&print
&print
&command_line off

&  rename macro listings segment; move it to listings dir
&if [ exists segment 355_macros.list ] &then delete 355_macros.list -force
&if [ exists segment macros_asm.sysprint.list ]
&then rename macros_asm.sysprint.list 355_macros.list
exec_com >LDD>EC>MOVE_LISTING_ &1 355_macros.list
&if [ exists segment macros_asm.sysprint.list ] &then delete macros_asm.sysprint.list
&quit
&  
&  MOVE MCS COMPILATION LISTING TO LISTINGS DIRECTORY
&
&label MOVE_LISTING_
&label COPY_LISTING_
&command_line off
&if [ exists segment &2 ] &then &else &goto NO_LISTING
&if [ equal [wd] &1 ] &then &quit
&if [ exists segment &1>&2 ] &then delete &1>&2 -force
copy &2 &1>&2 -name

&  make sure copy was successful
&
&if [ equal &ec_name COPY_LISTING_ ] &then &goto COPY_CHECK
&if [ compare &2 &1>&2 ] &then delete &2 -force
&else &goto COPY_ERROR
&quit

&label COPY_CHECK
&if [ compare &2 &1>&2 ] &then
&else &goto COPY_ERROR
&quit

&label NO_LISTING
&print
&print &ec_name:  Expected listing not found. &1
&quit

&label COPY_ERROR
&print
&print &ec_name:  Error in copying &2 to &1>&2.
&print Contents of copied segment differs from original.
&print Original segment has not been deleted.
&quit
&  
&  BIND MCS OBJECT SEGMENTS INTO A CORE IMAGE SEGMENT
&
&label bind_m
&command_line off
&if [ nequal &n 2 ] &then &else &goto bind_mUSAGE
&if [ equal &1 help ] &then &goto bind_mUSAGE
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &else &goto NO_MOD_DIR
&if [ exists directory >ldd>listings>mcs.&1 ] &then &else &goto NO_LIST_DIR
&print
&print _________________________________
&print

&  check for bind suffix
&
&if [ exists argument [ suffix &2 ] ] &then &else &goto NO_BIND_SUFFIX
&if [ equal [ suffix &2 ] bind_fnp ] &then &else &goto UNKNOWN_BIND_SUFFIX
change_wdir >ldd>mcs>mcs.&1

&  bind the core image
&
&command_line on
answer no ac x >ldd>mcs>o>([segs >ldd>mcs>o>*.archive])
& no search list so use whats in the directory.
&if [ exists segment &2 ]
&then bind_fnp &2 -list
&else bind_fnp >ldd>mcs>info>&2 -list
&print
&print
&command_line off

&  print analysis of bind listing to make sure we got everything
&
exec_com >LDD>EC>ANALYZE_BIND_LISTING_M_ &1 [ strip &2 bind_fnp ].list
&print

&  copy listing to listing dir; leave copy in mod dir for installation
&
exec_com >LDD>EC>COPY_LISTING_ >ldd>listings>mcs.&1 [ entry [ strip &2 bind_fnp ].list ]
&print
&print &ec_name:  Binding done.
&print
&print _________________________________
&print
&quit

&label bind_mUSAGE
&print
&print Usage is:    ec bind_m MCS_VERSION BINDFILE.bind_fnp
&print where:       BINDFILE is name of modified or existing bindfile which
&print    defines the core image, including the bind_fnp suffix.
&print    Bindfile in MCS modification directory is used if it exists;
&print    otherwise, bindfile in >ldd>mcs>info is used.
&quit

&label NO_BIND_SUFFIX
&print
&print &ec_name:  No suffix was given for bindfile segment.  &2
&print Assuming bind_fnp suffix.  &2.bind_fnp
&print
&print
exec_com &ec_dir>&ec_name &1 &2.bind_fnp &f3
&quit

&label UNKNOWN_BIND_SUFFIX
&print
&print &ec_name:  Bindfile type unknown. &2
&print &ec_name does not know how to bind the segment.
&print
&print
&quit
&  
&  PRINT STATISTICS FROM MCS BIND LISTING
&
&label ANALYZE_BIND_LISTING_M_
&input_line off
&command_line off
&if [ exists segment &2 ] &then &else &goto NO_LISTING
&attach
qedx
r &2
e ioa_ "Core image name and version-"
1p
1/version:/p
eioa_ "^2/MCS programs included in this core image-"
1/order:/;/;/p
e ioa_ "^2/MCS programs from the modification for MCS Version &1^/which are included in this core image-"
1/^Component/;$gp/&1/
q
&detach
&quit
&  
&  INSTALL MCS MODIFICATION INTO MCS LIBRARY
&
&label install_m
&command_line off

&if [ nequal &n 2 ] &then &else &goto install_mUSAGE
&if [ equal &1 help ] &then &goto install_mUSAGE
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &else &goto NO_MOD_DIR
change_wdir >ldd>mcs>mcs.&1
set_com_line 1000
&goto _INSTALL_&2_

&  PREPARE TO INSTALL MODIFICATION IN MCS LIBRARY
&
&label _INSTALL_prepare_
&print _________________________________
&print
&if [ query "&ec_name:  Do you want to &2 the installation of MCS Version &1?"] &then &else &quit

& cleanup from any previous installation attempt
&
&if [ exists segment mcs.&1.io ] &then delete mcs.&1.io -force
&if [ exists segment mcs.&1.il ] &then delete mcs.&1.il -force
&if [ exists segment not_installable.segs.ec ] &then delete not_installable.segs.ec -force
&if [ exists segment installable.segs.ec ] &then delete installable.segs.ec -force

& check for segments which must be installed with each modification
&
&if [ exists segment mcs ] &then &else &goto INSTALL_1
&if [ exists segment site_mcs ] &then &goto INSTALL_3
&print
&print &ec_name:  ERROR--  Segment mcs is being installed without changes to
&print    the site_mcs segment.  These segments must be modified in parallel.
&print
&print _________________________________
&print
&quit
&label INSTALL_1
&if [ exists segment site_mcs ] &then &else &goto INSTALL_2
&print
&print &ec_name:  ERROR--  Segment site_mcs is being installed without changesto
&print    the mcs segment.  These segments must be modified in parallel.
&print
&print _________________________________
&print
&quit
&label INSTALL_2
&if [ exists segment gicb ] &then &goto INSTALL_3
&print
&print &ec_name:  ERROR--  None of the segments mcs, site_mcs, or gicb is being
&print    installed by the MCS &1 modification.  Without installation of one of
&print    these segments, the modification cannot have any affect.
&print
&print _________________________________
&print
&quit

& check for segments which cannot be installed.
&
&label INSTALL_3
file_output not_installable.segs.ec
&command_line   off
list -sm -pri -nm -bf -nhe -ex *.map355 -ex *.objdk -ex 355_macros -ex macros_asm -ex mcs -ex site_mcs -ex gicb -ex mcs.list -ex site_mcs.list -ex *.bind_fnp -ex sys.runoff -ex **.info -ex not_installable.segs.ec -ex &1.del_list
console_output
&command_line   on
&command_line off
&if [ nequal 72 [ status -bc not_installable.segs.ec ] ] &then &else &goto INSTALL_ERR_1
&if [ equal "Segs=0" [ string [ all not_installable.segs.ec ] ] ]
&then &goto INSTALL_4
&label INSTALL_ERR_1
&print
&print &ec_name:  ERROR--  The following segments cannot be installed.  The installation
&print    of the modification cannot proceed until they are removed
&print    from the MCS modification directory, >ldd>mcs>mcs.&1.
&print
print not_installable.segs.ec 1
&print _________________________________
&print
delete not_installable.segs.ec
&quit

& check for segments to be deleted
&
&label INSTALL_4
&if [ exists segment &1.del_list ] &then &goto INSTALL_5
&if [ query "&ec_name:  Are any segments to be deleted by MCS &1?" ]
&then &else &goto INSTALL_5
&print Then create &1.del_list, containing the names of segments
&print to be deleted, and try installing the modification again.
&print
&print _________________________________
&print
&quit

& submit segments for installation
&
&label INSTALL_5
delete not_installable.segs.ec
ac udf ([segs **.archive])
update_seg initiate mcs.&1 
&if [ exists segment macros.map355 ] &then rename macros.map355 =.=.hold
exec_com &ec_dir>INSTALL_M_ >ldd>mcs>source *.map355
&if [ exists segment macros.map355.hold ] &then rename macros.map355.hold =.=
exec_com &ec_dir>INSTALL_M_ >ldd>mcs>object (*.archive mcs site_mcs gicb)
exec_com &ec_dir>INSTALL_M_ >ldd>mcs>info *.bind_fnp
&if [ exists segment macros.map355 ]
&then exec_com &ec_dir>INSTALL_M_ >ldd>mcs>info 355_macros
&if [ exists segment macros_asm ]
&then exec_com &ec_dir>INSTALL_M_ >ldd>mcs>info macros_asm
&if [ exists segment mcs.list ]
&then exec_com &ec_dir>INSTALL_M_ >ldd>mcs>info mcs.list &1.mcs.list
&if [ exists segment site_mcs.list ]
&then exec_com &ec_dir>INSTALL_M_ >ldd>mcs>info site_mcs.list &1.site_mcs.list
&if [ exists segment &1.del_list ]
&then exec_com &ec_dir>DELETE_M_ &1 ([all &1.del_list])

& generate installation listing segment, inform user
&
update_seg list -long
&print
&print To check the installation before installing, type:
&print    us print -brief
&print or dprint >ldd>mcs>mcs.&1>mcs.&1.il
&print
&print When you are sure the modification is correct, type:
&print    ec install_m MCS_VERSION install
&print
&print &ec_name:  Preparation of the MCS &1 installation is complete.
&print
&print _________________________________
&print
&quit

&label install_mUSAGE
&print
&print Usage is:    ec install_m MCS_VERSION OPERATION
&print where:       OPERATION may be:  prepare, install, or de_install
&print    Segments to be deleted given in MCS_VERSION.del_list.
&print
&quit
& 
& SUBMIT ONE OR MORE MCS SEGMENTS FOR INSTALLATION
&
&label INSTALL_M_
&command_line off
&if [ exists segment &2 ] &then &else &quit
exec_com &ec_dir>INSTALL_M_1_ &1 ([segs &2]) &f3
&quit

& SUBMIT A SINGLE MCS SEGMENT FOR INSTALLATION
&
&label INSTALL_M_1_
&command_line off
&if [ ngreater &n 2 ] &then &goto CHECK_3

& check for segment additions when 2 args given
&
&if [ exists segment &1>&2 ] &then &goto REPL_2
&if [ query "&ec_name:  Do you want to add &2 to &1?" ] &then &goto ADD_2
&print
&print &ec_name:  ERROR--  &2 not installed.
&print
&quit

& check for segment additions when 3 args given
&
&label CHECK_3
&if [ exists segment &1>&3 ] &then &goto REPL_3
&if [ query "&ec_name:  Do you want to add &2 to &1 with name &3?" ] &then &goto ADD_3
&print
&print &ec_name:  ERROR--  &2 (&3) not installed.
&print
&quit

&label REPL_2
update_seg replace &2 &1>&2
&quit

&label REPL_3
update_seg replace &2 &1>&3 -add_name &3
&quit

&label ADD_2
update_seg add &2 &1>&2    -acl r * -rb 4 5 5
&quit

&label ADD_3
update_seg add &2 &1>&2 -add_name &3    -acl r * -rb 4 5 5
&quit
&  
& SUBMIT ONE OR MORE MCS SEGMENTS FOR DELETION
&
&label DELETE_M_
&command_line off

& check for files to be deleted in each MCS Library directory.
&
&if [ exists entry >ldd>mcs>source>&2 ] &then &goto DELETE_SOURCE
&if [ exists entry >ldd>mcs>object>&2 ] &then &goto DELETE_OBJECT
&if [ exists entry >ldd>mcs>info>&2 ] &then &goto DELETE_INFO
&goto NO_DELETE

& delete files which were found.
&
&label DELETE_SOURCE
exec_com &ec_dir>DELETE_M_1_ >ldd>mcs>source ([files >ldd>mcs>source>&2]) &f3
&label DELETE_OBJECT
exec_com &ec_dir>DELETE_M_1_ >ldd>mcs>object ([files >ldd>mcs>object>&2]) &f3
&label DELETE_INFO
exec_com &ec_dir>DELETE_M_1_ >ldd>mcs>info ([files >ldd>>info>&2]) &f3
&quit

&label NO_DELETE
&print
&print &ec_name:  ERROR--  &2 does not match any MCS library segment.
&print      &2 has not been deleted.
&print
&quit

&  SUBMIT A SINGLE MCS LIBRARY SEGMENT FOR DELETION
&
&label DELETE_M_1_
&command_line off
update_seg delete &1>&2
&quit
&  
&  INSTALL THE MODIFICATION INTO THE MCS LIBRARY
&    OR
&  DE_INSTALL THE MODIFICATION FROM THE MCS LIBRARY
&
&label _INSTALL_install_
&label _INSTALL_de_install_
&if [ exists segment mcs.&1.io ] &then &else &goto NO_IO_SEG
&print
&print _________________________________
&print
&if [ query "&ec_name:  Do you want to &2 MCS Version &1?" ] &then &else &quit

& install or de_install the modification
&
&print
&command_line on
update_seg &2 mcs.&1.io -sv 2
&print
update_seg list -long
&command_line off
&if [ equal &2 install ]
&then add_name mcs.&1.io mcs.&1.installed.io
&else delete_name mcs.&1.installed.io

&
& update >ldd>mcs>info>mcs_system_dates
&
&if [equal &2 install]
&then sys_dates_$add >ldd>mcs mcs &1
&if [equal &2 install]
&then sa >ldd>mcs>mcs.&1>** r *


& notify people
&
&if [query "Notify CISL of action?"] &then exec_com &ec_dir>notify mcs "MCS Version &1 has been &2ed (updated)."
&print
&print Modify >udd>m>lib>info>util_sys.info to reflect MCS &2ation.
&if [ equal &2 de_install ] &then &goto DE_INSTALL
&print Use listings_m.ec to dprint MCS listings.
&print Use doc_m.ec      to document the MCS modification.
&if [query "Carry system?"] &then exec_com >ldd>ec>carry mcs.&1
&label DE_INSTALL
&print
ioa_ "^(^a ^)" The &2ation of MCS Version &1 is complete at  [date_time]
&print
&print _________________________________
&print
&quit

&label NO_IO_SEG
&print
&print &ec_name:  mcs.&1.io does not exist.
&print You must prepare the installation by typing-
&print    ec install_m MCS_VERSION prepare
&print
&quit

&label _INSTALL_&2_
&print
&print &ec_name:    &2 is an invalid operation.
&goto install_mUSAGE
&  
&   DPRINT MCS LISTINGS
&
&label listings_m
&command_line off
&if [ nless &n 1 ] &then &goto listings_mUSAGE
&if [ equal &1 help ] &then &goto listings_mUSAGE
&if [ exists directory >ldd>listings>mcs.&1 ] &then &else &goto NO_LIST_DIR
change_wdir >ldd>listings>mcs.&1

&  make alphabetical list of listings
&
&print
&print _________________________________
&print
&print &ec_name:  Begin dprinting listings for MCS Version &1.
&print
&if [ exists segment &1.listings ] &then delete &1.listings -force
create &1.listings
ioa_$nnl "In >ldd>listings>mcs.&1, there are "
list -total -file -lk -brief
&print
file_output &1.listings
list -names -brief -nhe -primary -sort names -file -link
console_output

&  dprint listings in the list
&
scl 1000
dprint -ds "     MCS"  -he "    &1" &f2 [all &1.listings]
change_wdir >ldd>mcs>mcs.&1
&print
&print &ec_name:  Done dprinting MCS listings.
&print
&print _________________________________
&print
&quit

&label listings_mUSAGE
&print
&print Usage is:    ec &ec_name MCS_VERSION {DPRINT_ARGS}
&print
&quit
&  
&  DPRINT A FEW MCS LISTINGS
&
&label listing_subset_m
&command_line off
&if [ nless &n 2 ] &then &goto listing_subset_mUSAGE
&if [ equal &1 help ] &then &goto listing_subset_mUSAGE
&if [ exists directory >ldd>listings>mcs.&1 ] &then &else &goto NO_LIST_DIR
change_wdir >ldd>listings>mcs.&1

&  dprint the given listings
&
&print
&print _________________________________
&print
&print &ec_name:  Dprint only a given subset of the MCS listings.
&print
dprint -ds "     MCS" -he "     &1" &f2
change_wdir >ldd>mcs>mcs.&1
&print
&print &ec_name:  Done dprinting MCS listings.
&print
&print _________________________________
&print
&quit

&label listing_subset_mUSAGE
&print
&print Usage is:    ec &ec_name MCS_VERSION {DPRINT_ARGS} MCS_LISTINGS_TO_BE_DPRINTED
&print
&quit
&  
&  GENERATE AND DPRINT MCS SYSTEM BOOK
&
&label make_book_m
&command_line off
&if [ nless &n 1 ] &then &goto make_book_mUSAGE
&if [ equal &1 help ] &then &goto make_book_mUSAGE
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &else &goto NO_MOD_DIR
&if [ exists segment >ldd>mcs>mcs.&1>mcs.&1.installed.io ] &then &else &goto MOD_NOT_INSTALLED
change_wdir >ldd>mcs>info
&print
&print _________________________________
&print
&print &ec_name:  Making system book for MCS &1.
&print

&  run library_map on MCS Libraries.
&
&print Running library_map on MCS Library.
library_map -descriptor multics_libraries_ -lb com.* -error -nm -new_line -level -dtcm -pn -tp -link_target -of mcs.new -fo "MCS &1 MAP" -he "MCS Library -Version &1"
&if [exists segment mcs.map] &then lfree_name ([status -nm mcs.map]); add_namemcs.map.1 [unique]
rename mcs.new.map mcs.map
add_name mcs.map mcs.&1.map
&print
&print Running library_print on MCS Library info directory.
library_print -descriptor multics_libraries_ -lb com.info *.list -of mcs.new -fo "MCS &1 INFO" -he "MCS Library - Version &1"
&if [ exists segment mcs.print ] &then lfree_name ([status -nm mcs.print]); add_name mcs.print.1 [unique]
rename mcs.new.print mcs.print
add_name mcs.print mcs.&1.print
&print

&  dprint the book
&
dprint -ds " System Book" -header "  MCS &1" &f2 mcs_system_book
change_wdir >ldd>mcs>mcs.&1
&print
&print &ec_name:  System book done.
&print
&print _________________________________
&print
&quit

&label make_book_mUSAGE
&print
&print Usage is:    &ec_name MCS_VERSION DPRINT_ARGS
&print
&quit

&label MOD_NOT_INSTALLED
&print
&print &ec_name:  MCS Version &1 has not been installed.  Exec_com &ec_name
&print    cannot be run for this version until it has been installed.
&print
&quit
&  
&  DOCUMENTING THE MODIFICATION
&
&label document_m
&command_line off
&if [ nless &n 1 ] &then &goto document_mUSAGE
&if [ equal &1 help ] &then &goto document_mUSAGE
&if [ exists directory >ldd>mcs>mcs.&1 ] &then &else &goto NO_MOD_DIR
&if [ exists segment >ldd>mcs>mcs.&1>mcs.&1.installed.io ] &then &else &goto MOD_NOT_INSTALLED
&if [ exists segment >ldd>mcs>mcs.&1>sys.runoff ] &then &else &goto NO_MOD_SUMMARY
&print
&print _________________________________
&print
&if [ query "&ec_name:  Document modification for MCS &1?" ] &then &else &quit
&print
change_wdir >LDD>smag>mib
&print
&print Changing to MIB directory, >LDD>smag>mib.
&print

&  create an installation listings segment if none exists.
&
&if [ exists segment >ldd>mcs>mcs.&1>mcs.&1.il ] &then &goto DOC_M_1
&print Creating modification listing segment, >ldd>mcs>mcs.&1>mcs.&1.il
update_seg list >ldd>mcs>mcs.&1>mcs.&1 -long
&if [ exists segment >ldd>mcs>mcs.&1>mcs.&1.il ] &then &else &goto DOC_LIST_ERR
&print

&  invoke documentation subroutine with long date, author name as arguments.
&
&label DOC_M_1
exec_com &ec_dir>DOCUMENT_M_ &1 [long_date] [user name] &f2
&print
&print &ec_name:  MIB documenting MCS &1 has been created.
&print
&print _________________________________
&print
&quit

&label document_mUSAGE
&print
&print Usage is:    ec &ec_name MCS_VERSION OTHER-VERSIONS-DOCUMENTED-WITH-THIS-VERSION
&print where:       documentation of segments in these other version will be done by hand.
&print
&quit

&label NO_MOD_SUMMARY
&print
&print &ec_name:  Modification summary not found for MCS &1
&print    (>ldd>mcs>mcs.&1>sys.runoff).
&print    This segment should be created using the runoff macros
&print    documented in >LDD>info>sys.runoff.info
&quit

&label DOC_LIST_ERR
&print
&print &ec_name:  ERROR--  Unable to create modification listing segment.
&print    Correct the problem reported above and try again.
&print
&print _________________________________
&print
&quit
&  
&  SUBROUTINE TO CREATE MIB RUNOFF SEGMENTS DOCUMENTING MCS INSTALLATION
&
&label DOCUMENT_M_
&command_line off
&print Creating mcs.&1.segments.runoff.
&attach
&input_line off
qedx
r >ldd>mcs>mcs.&1>mcs.&1.il
1,/^SUMMARY OF THE INSTALLATION:/d
/^NO ERRORS OCCURRED DURING INSTALLATION./;$d
gd/^$/
$a
.as        !!!!
.by        !!!!
.Add       !!!!
.Delete    !!!!
.Replace   !!!!
\f
gd/^.as/
gd/^.by/
1,$s/^.Add.*$/&A/
1,$s/^.Delete.*$/&D/
1,$s/^.Replace.*$/&R/
1,$s/..*>//
1,$s/.$/                                  &/
1,$s/^................................../&XX/
1,$s/XX *//
gd/!!!!/
gd.list/
gd.objdk/
w mcs.&1.segments.runoff
q
sort_seg mcs.&1.segments.runoff
&print

&  copy introduction, and format the MIB.
&
&if [ exists segment mcs.&1.intro.runoff ] &then           ioa_ "Using mcs.&1>intro.runoff which already exists..^/"
&else copy >ldd>mcs>mcs.&1>sys.runoff mcs.&1.intro.runoff; ioa_ "Copying mcs.&1.intro.runoff from >ldd>mcs>mcs.&1>sys.runoff.^/"
&print Creating mcs.&1.mib.runoff.
qedx
r mcs.mib_template
&if [ nless &n 4 ]
&then 1,$s/WWWW/&1/
&else 1,$s/WWWW/&1, &f4/
1,$s/XXXX/&1/
1,$s/YYYY/&2/
1,$s/ZZZZ/&3/
w mcs.&1.mib.runoff
q
&print
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
