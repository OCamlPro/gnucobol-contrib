       >>source free
*>
*> CONFIGURATION SETTINGS: Set these switches / values before compiling:
*>  GnuCOBOL CONSTANTS section.
*>=========================================================
*>The program uses the field Compiler-Line-Cnt to hold the default
*> cobc page size of 55 so if you change the one in cobc sources etc,
*> change this field in cobxref to match before compiling it by
*> change the value in C-Compiler-Line-Cnt currently 55
*>-----------------------------------------------------
*>
>>DEFINE CONSTANT C-Compiler-Line-Cnt   AS 55
*>
*> Used in printcbl
*>
*>  Operating system path delimiter - set for *nix, for NATIVE windows change to "\".
*>      NATIVE means if compiled GnuCOBOL using Visual Studio ONLY.
*>
>>DEFINE CONSTANT C-OS-Delimiter  AS "/"           *> *nix and Win 10 others ?
*>
>>DEFINE CONSTANT C-Testing-1   AS 0    *> Not testing (default), change to AS 1 if wanted.
>>DEFINE CONSTANT C-Testing-2   AS 0    *> Not testing (default), change to AS 1 if wanted.
>>DEFINE CONSTANT C-Testing-3   AS 0    *> Not testing (default), change to AS 1 if wanted.
>>DEFINE CONSTANT C-Testing-4   AS 0    *> Not testing (default), change to AS 1 if wanted.
*>
*> Used in cobxref  -  produces a lot of screen output displays from printcbl & cobxref modules
*>    This can be over ridden by Param 5 use of -TEST
*>
>>DEFINE CONSTANT X-Testing     AS "N"  *> Not testing (default) change to AS "Y" if wanted.
*>
*> Usage of the testing options can and will produce a LOT of output.
*>    100's of megs.
*>  Only use if requested by the programmer / Development team.
*>
*>----
*> END CONFIGURATION SETTINGS
*>
 Identification division.
 program-id.            cobxref.
 author.                Vincent Bryan Coen, Applewood Computers, FBCS,
*>                      17 Stag Green Avenue, Hatfield, Herts, AL9 5EB, UK.
 Date-Written.          28 July 1983 with code going back to 1967.
*> Date-Rewriten.       10 March 2007 with code going back to 1983.
 Date-Compiled.         Today & Dont forget to update prog-name for builds.
*> Security.            Copyright (C) 1967-2019, Vincent Bryan Coen.
*>                      Distributed under the GNU General Public License
*>                      v2.0. Only. See the file COPYING for details but
*>                      for use with GnuCOBOL ONLY.
*>
*> Usage.               Cobol Cross Referencer for GNU Cobol
*>                      code reflects for v2.n and v3.
*>
*>                      Please read all of the notes before use!!!
*>                      Notes transferred to a manual in LibreOffice & PDF formats.
*>
*>                      Make sure that you have tested the GnuCobol compiler by running
*>                      make checkall and that you get no errors what so ever
*>                      otherwise you might get compiler induced errors when running.
*>
*>                      This version (v1.99.nn and v2.00+ ) used (ONLY)
*>                      as a stand alone tool see the readme and manual
*>                      for more parameter details but can be run as
*>                      cobxref sourcefilename.cbl FREE
*>                      ===================== WARNING =====================
*>                      Must only be used after running the source file
*>                      that is to be cross referenced, through the compiler
*>                      that results in an warning and error free run.
*>                      ^^^^^^^^^^^^^^^^^^^^^ WARNING ^^^^^^^^^^^^^^^^^^^^^
*>**
*> Calls.               get-reserved-lists
*>                      printcbl
*>                          which are at end of source file.
*>
*>                      compile with supplied script comp-cobxref.sh or :
*>                      cobc -x cobxref.cbl -fmissing-statement=ok
*>                      ==========================================
*>**
*> Changes.             See Changelog & Prog-Name.
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of Cobxref AND GNU Cobol and is copyright
*> (c) Vincent B Coen 1967-2019. This version bears no resemblance to the
*> original versions running on ICL 1501/1901 and IBM 1401 & 360/30 in the
*> 1960's and 70's.
*>
*> A version for running with MVS 3.8J and ANSI Cobol is available for those
*> users running IBM emulation with Hercules.
*> This uses a modified version of the original code from the 60s and will
*>  ONLY run with ANSI Cobol.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 3 (and later) ONLY within GnuCOBOL,
*> providing the package continues to be issued or marketed as GnuCOBOL and
*> is available FREE OF CHARGE AND WITH FULL SOURCE CODE.
*>
*> It cannot be included or used with any other Compiler without the
*> written Authority by the copyright holder, Vincent B Coen. See the
*> manual for contact details.
*>
*> Cobxref is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endevor
*> to fix it, providing you tell me about the problem.
*>
*> You should have received a copy of the GNU General Public License along
*> with Cobxref; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>*************************************************************************
*>
 environment division.
 configuration section.
 source-computer.      linux.
 object-computer.      linux.
 special-names.                                     *> only here to help test cobxref
     switch-1 is sn-Test-1 on snt1-on off snt1-off  *> against itself.
     currency sign is "£".
*>
 input-Output section.
 file-control.
*>
*>  These 2 are needed as GC (& many others) does NOT support real
*>    variable length tables and they can get very large
*>            They are also very handy for debugging during testing.
*>            These two files are not deleted at EOJ but code is present
*>            currently remarked out to do so.
*>            These files may well be created at /tmp or /home/username/tmp
*>            depending on your system settings.
*>
     select   Supplemental-Part2-In assign Supp-File-2
              organization line sequential.
*>
     select   Supplemental-Part1-Out assign Supp-File-1
              organization line sequential.
*>
     select   Source-Listing assign Print-FileName
              organization   line sequential
              file status    FS-Reply.
*>
     select   SourceInput  assign SourceFileName           *> This is the o/p file from
              organization line sequential                 *> the called module printcbl
              file status  FS-Reply.
*>
*> Used to o/p source with copy includes, currently only during testing
*>  this file is free format, stripped of more than one space between words.
*>    Similar (ok the same as produced for a filename.i file via cobc
*>      when using command / steering --save-temps, with comments removed
*>        and blank lines
*>
     select CopySourceInput2 assign CopySourceFileName2
         organization line sequential
         file status fs-reply.
*>
     select   SortFile assign Sort1tmp.
*>
 i-o-control.
*>
     same record area for Supplemental-Part1-Out
                          Supplemental-Part2-In.
*>
 data division.
 file section.
 fd  Source-Listing.
 01  Source-List.
     03  sl-Gen-RefNo1     pic z(5)9bb.
     03  SourceOutput      pic x(256).
*>
 01  PrintLine.
     03  XrDataName        pic x(32).
     03  XrDefn            pic 9(6).
     03  XrType            pic x.
     03  XrCond            pic x.
     03  filler            pic x.
     03  filler     occurs 8.
         05  XrReference   pic 9(6).
         05  filler        pic x.
     03  filler            pic x(62).
*>
 01  Printline-Overflow.                 *> For long datanames > 32 chars
     03  XrDataName-Long   pic x(63).    *> & xrdataname blank
*>
 01  filler.
     03  filler            pic x(42).
     03  PL-Prog-Name      pic x(64).    *> 12/5/19 2.02
*>
 01  PrintLine2.
     03  P-Conditions      pic x(32).
     03  P-Variables       pic x(32).
*>
 01  PrintLine3.                         *> for called procedures System or User
     03  PL4-Name          pic x(30).    *> use PL-overflow for long names
     03  filler            pic xx.       *> with PL4-Name blank.
     03  PL4-Type          pic x(7).     *> Can be SYSTEM or USER
     03  filler     occurs 8.
         05  PL4-Reference pic 9(6).
         05  filler        pic x.
*>
 fd  SourceInput.
 01  SourceRecIn           pic x(256).
*>
 fd  CopySourceInput2.
*>
 01  CopySourceRecIn2      pic x(160).
*>
 fd  Supplemental-Part1-Out.
 01  SortRecord.
     03  SkaProgramName    pic x(32).   *> 27/2/19 added program name max 31+1 chars
     03  SkaDataName       pic x(64).   *> updated 12/5/19 for 63 chars (rounded to 64)
     03  SkaWSorPD         pic 9.       *>  for word boundary.
     03  SkaWSorPD2        pic 9.
     03  SkaRefNo          pic 9(6).
*>
 fd  Supplemental-Part2-In.
 01  filler                pic x(104).  *> updated 12/5/19.
*>
 sd  SortFile.
 01  filler.
     03  SdSortKey         pic x(104).   *> 12/5/19 dataname chgd to 64.
*>
 working-storage section.
 77  Prog-Name             pic x(13) value "Xref v2.02.01".
 77  Page-No               Binary-long  value zero.
 77  String-Pointer        Binary-long  value 1.
 77  String-Pointer2       Binary-long  value 1.
 77  S-Pointer             Binary-long  value zero.
 77  S-Pointer2            Binary-long  value zero.
 77  S-Pointer3            Binary-long  value zero.
 77  Line-Count            Binary-char  value 70.
 77  Compiler-Line-Cnt     Binary-char  value C-Compiler-Line-Cnt.
 77  ws-Return-Code        binary-char  value zero.
 77  Word-Length           Binary-long  value zero.
 77  Line-End              Binary-long  value zero.
 77  Source-Line-End       Binary-long  value zero.
 77  Source-Words          Binary-long  value zero.
 77  F-Pointer             Binary-long  value zero.
 77  HoldFoundWord2-Size   binary-long  value zero.
 77  HoldFoundWord2-Type   binary-long  value zero.
 77  a                     Binary-Long  value zero.
 77  a1                    Binary-Long  value zero.
 77  a2                    Binary-char  value zero.
 77  b                     Binary-Long  value zero.
 77  c                     Binary-Long  value zero.
 77  d                     Binary-Long  value zero.
 77  d2                    Binary-Long  value zero.
 77  e                     Binary-Long  value zero.
 77  s                     Binary-Long  value zero.
 77  s2                    Binary-Long  value zero.
 77  t                     Binary-Long  value zero.
 77  t2                    Binary-Long  value zero.
 77  t3                    Binary-Long  value zero.
 77  y                     Binary-Long  value zero.
 77  z                     Binary-Long  value zero.
 77  z2                    Binary-Long  value zero.
 77  z3                    Binary-Long  value zero.
 77  q                     Binary-Long  value zero.
 77  q2                    Binary-Long  value zero.
*>
*> System parameters control how xref works or reports
*>  May be add extra func for default.conf ?
*>
 77  sw-1                  pic x           value "N".
*>  command line input -G
     88 All-Reports                        value "A".
 77  sw-2                  pic x           value "Y".
     88 List-Source                        value "Y".
 77  SW-3                  pic x           value "N".
*> command line input -E
     88  Create-Compressed-Src             value "Y".
*>
 77  sw-4                  pic 9           value zero.
     88  Dump-Reserved-Words               value 1.
 77  sw-5                  pic x           value X-Testing.         *>  "N".
     88 We-Are-Testing                     value "Y".
 77  sw-6                  pic 9           value zero.
     88  Reports-In-Lower                  value 1.
*> XREF reporting at end of all sources                      -  NOT YET IMPLEMENTED.
 77  SW-7                  pic x           value "N".          *> Needed ???
     88  Xrefs-At-End                      value "Y".
*>
 77  SW-8                  pic x           value "N".          *> Y = free, N = Fixed
     88 SW-Free                            value "Y".
     88 SW-Fixed                           value "N".
*>   set if free/fixed used as against defaulting
 77  sw-8-usd              pic x           value "N".
     88 sw-8-inuse                         value "Y".
 77  sw-9                  pic x           value "N".
     88 No-Table-Update-displays           value "Y".
 77  sw-11                 pic x           value "N".
     88 Verbose-Output                     value "Y".
*>
*> Switches used during processing
*>
*> And these two are the size of any Cobol word currently set
*> to value specified in PL22.4 20xx
*> There still a limit of the WS data size used for any
*>   and this is fixed.
*>
 78  Cobol-Word-Size                       value 31.
 78  CWS                                   value Cobol-Word-Size.
*>
 77  sw-Source-Eof         pic 9           value 0.
     88 Source-Eof                         value 1.
*> got end of program
 77  sw-End-Prog           pic 9           value zero.
     88 End-Prog                           value 1.
*> Had end of program (nested) - Confused yet? you will be!
 77  sw-Had-End-Prog       pic 9           value zero.
     88 Had-End-Prog                       value 1.
*> We have found a Global verb
 77  sw-Git                pic 9           value zero.
     88 Global-Active                      value 1.
*> We have found a External verb
 77  SW-External           pic 9           value zero.    *> New 3/2/19
     88  External-Active                   value 1.
*>
 77  SW-Found-External     pic 9           value zero.
*>
*>  Multi modules in one source file flag
*>
 77  sw-Nested             pic 9           value zero.
     88 Have-Nested                        value 1.
*>
 77  Arg-Number            pic 99          value zero.
 77  Gen-RefNo1            pic 9(6)        value zero.
 77  Build-Number          pic 99          value zero.
 77  GotEndProgram         pic 9           value zero.
 77  GotPicture            pic 9           value zero.
 77  WasPicture            pic 9           value zero.
 77  Currency-Sign         pic X           value "£".
 77  HoldWSorPD            pic 9           value zero.
 77  HoldWSorPD2           pic 9           value zero.
 77  Word-Delimit          pic x           value space.
 77  Word-Delimit2         pic x           value space.
 77  OS-Delimiter          pic x           value space.
 77  GotASection           pic x           value space.
*> section name + 8 chars
 77  HoldFoundWord         pic x(72)       value spaces. *> this and next 3 increased by 32 char.
 77  HoldFoundWord2        pic x(72)       value spaces.
 77  SaveSkaDataName       pic x(64)       value spaces.
 77  Saved-Variable        pic x(64)       value spaces.
 77  SaveSkaWSorPD         pic 9           value zero.
 77  SaveSkaWSorPD2        pic 9           value zero.
 77  WS-Anal1              pic 9           value zero.
 77  FS-Reply              pic 99          value zeros.
 77  SourceFileName        pic x(64)       value spaces.
 77  Print-FileName        pic x(64)       value spaces.
 77  Print-FileName-2      pic x(64)       value spaces.
 77  Prog-BaseName         pic x(64)       value spaces.
*>
*> In theory Linux can go to 4096 and Windoz 32,767 chars
*>
 77  Temp-Pathname         pic x(1024)     value spaces.
 77  Supp-File-1           pic x(1036)     value spaces.
 77  Supp-File-2           pic x(1036)     value spaces.
 77  Sort1tmp              pic x(1036)     value spaces.
 77  Global-Current-Word   pic x(64)       value spaces.  *> + 32 char
 77  Global-Current-Refno  pic 9(6)        value zero.
 77  Global-Current-Level  pic 99          value zero.
 77  FoundFunction         pic 9           value zero.
*>
 01  HoldID                pic x(64)       value spaces. *> +32 char & next.
 01  HoldID-Module         pic x(64)       value spaces.
*>
 01  SourceInWS.
     03  Sv1what           pic x(16).
     03  filler            pic x(240).
*>
 01  SourceInWS2           pic x(65).   *> for fixed format - temp area.
*>
 01  wsFoundWord.
     03  wsf1-3.
         05  wsf1-2.
             07  wsf1-1    pic x.
                 88  wsf1-1-Number    values 0 1 2 3 4 5 6 7 8 9.
             07  wsf2-1    pic x.
         05  filler        pic x.
     03  filler            pic x(253).
*>
 01  wsFoundWord2 redefines wsFoundWord.
     03  wsf3-1            pic 9.                      *> only used for Build-Number
         88 wsf3-1-Numeric           values 0 thru 9.
     03  wsf3-2            pic 9.                      *>   processing
     03  filler            pic x(254).
*>
 01  wsFoundNewWord        pic x(64).  *> this  & 2, 4, 6 increased by 32. 12/5/19
 01  wsFoundNewWord2       pic x(64).
 01  wsFoundNewWord3       pic x(256).  *> WAS 1024 max size quot lit 1 lin
 01  wsFoundNewWord4       pic x(64).
 01  wsFoundNewWord5       pic x(256).  *> WAS 1024 space removal source i/p
 01  wsFoundNewWord6       pic x(64).
*>
 01  HDR1.
     03  filler            pic X(10) value "ACS Cobol ".
     03  H1Prog-Name       pic x(23) value spaces.
     03  filler            pic x(20) value "Dictionary File for ".
     03  h1programid       pic x(64) value spaces.
     03  filler            pic x(7)  value "  Page ".
     03  H1-Page           pic zzz9.
*>
 01  HDR2.
     03  filler            pic X(33) value "All Data/Proc Names".
     03  filler            pic X(19) value "Defn     Reference".
*>
 01  hdr3.
     03  filler            pic x(31) value all "-".
     03  filler            pic x     value "+".
     03  filler            pic x(63) value all "-".
*>
 01  hdr4.
     03  filler            pic x(31) value all "-".
     03  filler            pic x     value "+".
     03  filler            pic x(56) value all "-".
*>
 01  hdr5-symbols.
     03  filler            pic x(19) value "Symbols of Module: ".
     03  hdr5-Prog-Name    pic x(67) value spaces.
*>
 01  hdr6-symbols.
     03  filler            pic x(19) value all "-".
*>
*> below is replaced with hyphens to size of Prog-Name
*>
     03  hdr6-hyphens      pic x(67) value spaces.
*>
 01  hdr7-ws.
     03  filler            pic x(14) value "Data Section (".
     03  hdr7-variable     pic x(18) value spaces.
     03  filler            pic x(9)  value "Defn".
     03  filler            pic x(9)  value "Locations".
*>
 01  hdr8-ws.
     03  hdr8-hd           pic x(9)  value "Procedure".
     03  filler            pic x(23) value spaces.
     03  filler            pic x(9)  value "Defn".
     03  filler            pic x(9)  value "Locations".
*>
 01  hdr9.
     03  filler            pic x(36) value "Unreferenced Working Storage Symbols".
*>
 01  hdr9B.
     03  filler            pic x(38) value "Unreferenced Globals throughout Source".
*>
 01  hdr10.
     03  filler            pic x(23) value "Unreferenced Procedures".
*>
 01  hdr11.
     03  filler            pic x(16) value "Variable Tested".
     03  hdr11a-sorted     pic xxx   value spaces.
     03  filler            pic x(12) value spaces.
     03  filler            pic x(8)  value "Symbol (".
     03  filler            pic x(15) value "88-Conditions)".
     03  hdr11b-sorted     pic xxx   value spaces.
     03  filler            pic x(5)  value spaces.
*>
 01  hdr12-hyphens.
     03  filler            pic x(62) value all "-".
*>
 01  hdr13.
     03  filler            pic x(32)  value "Called Procedures".
     03  filler            pic x(7)   value "Type".
     03  filler            pic x(9)   value "Locations".
*>
 01  hdtime                          value spaces.
     03  hd-hh             pic xx.
     03  hd-mm             pic xx.
     03  hd-ss             pic xx.
     03  hd-uu             pic xx.
 01  hddate                          value spaces.
     03  HD-C              pic xx.
     03  hd-y              pic xx.
     03  hd-m              pic xx.
     03  hd-d              pic xx.
*>
 01  hd-date-time.
     03  HD2-Date.
         05  hd2-d         pic xx.
         05  filler        pic x     value "/".
         05  hd2-m         pic xx.
         05  filler        pic x     value "/".
         05  HD2-C         pic xx.
         05  hd2-y         pic xx.
     03  HD2-Time.
         05  filler        pic xx    value spaces.
         05  hd2-hh        pic xx.
         05  filler        pic x     value ":".
         05  hd2-mm        pic xx.
         05  filler        pic x     value ":".
         05  hd2-ss        pic xx.
         05  filler        pic x     value ":".
         05  hd2-uu        pic xx.
*>
 01  WS-When-Compiled.
     03  WS-WC-YY          pic 9(4).
     03  filler            pic x(17).
*>
 01  WS-Locale             pic x(16) value spaces.     *> Holds o/p from env var. LC_TIME but only uses 1st 5 chars
 01  WS-Local-Time-Zone    pic 9     value 3.          *> Defaults International, See below !
*>
*> Sets WS-Local-Time-Zone ^~^ to one of these 88 values according to
*>    your local requirements
*> NOTE Environment var. LC_TIME is checked for "en_GB" for UK (1)
*>                                          and "en_US" for USA (2)  OTHERWISE its 3 for *nix format
*>   at start of program.
*>   For any other, you can add yours if different but let the Lead Programmer
*>     know, so it can be added to the master sources otherwise default will
*>      be Unix format
*>
*>    Note that 'implies' does NOT mean the program does anything e.g.,
*>        changes page sizing in the report.
*>
     88  LTZ-UK                           value 1. *> dd/mm/ccyy  [en_GB] Also implies A4 Paper for prints
     88  LTZ-USA                          value 2. *> mm/dd/ccyy  [en_US] Also implies US Letter Paper for prints
     88  LTZ-Unix                         value 3. *> ccyy/mm/dd  Also implies A4 Paper for prints
*>
 01  Error-messages.
     03 Msg1      pic x(31) value "Msg1  Aborting: No input stream".
     03 Msg2      pic x(35) value "Msg2  Aborting: Early eof on source".
     03 Msg4      pic x(48) value "Msg4  Logic Error:Lost1 wsFoundWord2 numeric? = ".
     03 Msg5      pic x(38) value "Msg5  Logic Error:Lost2 wsFoundWord2 =".
     03 Msg6      pic x(40) value "Msg6  Error: Con table size needs > 5000".
     03 Msg7      pic x(30) value "Msg7  bb050 Error: Logic error".
     03 Msg8      pic x(32) value "Msg8  Error: Eof on source again".
     03 Msg9      pic x(40) value "Msg9  Error: File not present Try Again!".
     03 Msg10     pic x(42) value "Msg10 Error: Git Table size exceeds 10,000".
*> Msg11 - 16 in get-reserved-lists with Msg17 spare
     03 Msg18     pic x(71) value "Msg18 Error: Eof on source possible logic error at aa047 ASSUMING again".
     03 Msg19     pic x(79) value "Msg19 Possible prob. with cobc and therefore with no reserved word list updates".
*> Msg21 - 31 in printcbl
*>
 01  SectTable.
     03  filler            pic x(9) value "FWLKCRSPI".
 01  filler  redefines SectTable.
     03  LSect             pic x  occurs 9.
*> Keep track of sections used in analysed module
 01  Section-Used-Table  value zeros.
     03  USect             pic 9  occurs 9.
*> holds program parameter values from command line
 01  Arg-Vals                       value spaces.
     03  Arg-Value         pic x(128)  occurs 12.
*>
 01  Section-Names-Table.
     03  filler pic x(24) value "FILE SECTION.           ".
     03  filler pic x(24) value "WORKING-STORAGE SECTION.".
     03  filler pic x(24) value "LOCAL-STORAGE SECTION.  ".
     03  filler pic x(24) value "LINKAGE SECTION.        ".
     03  filler pic x(24) value "COMMUNICATION SECTION.  ".   *> #5 replace with CALL routines ?
     03  filler pic x(24) value "REPORT SECTION.         ".
     03  filler pic x(24) value "SCREEN SECTION.         ".
     03  filler pic x(24) value "PROCEDURE DIVISION.     ".
 01  filler   redefines Section-Names-Table.
     03  Full-Section-Name          occurs 8.
*>                  ascending key Section-Name indexed by Full-Section-Name-Idx. *> cant use as its NOT sorted
         05  Section-Name  pic x(16).
         05  filler        pic x(08).
*>
 01  Section-Short-Names-Table.
     03  filler pic x(16) value "FILE            ".
     03  filler pic x(16) value "WORKING-STORAGE ".
     03  filler pic x(16) value "LOCAL-STORAGE   ".
     03  filler pic x(16) value "LINKAGE         ".
     03  filler pic x(16) value "COMMUNICATION   ".      *> #5 Replace with CALL routines ?
     03  filler pic x(16) value "REPORT          ".
     03  filler pic x(16) value "SCREEN          ".
     03  filler pic x(16) value "PROCEDURE       ".
 01  filler   redefines Section-Short-Names-Table.
     03  Short-Section-Name          occurs 8.
         05  Sht-Section-Name  pic x(16).
*>
*> Here for cb_intrinsic_table in GC see :
*>  cobc/reserved.c in the gnuCOBOL source directory but Totally ingoring
*>   the system_table as not needed/used by xref
*>
*> Also note that the number 0 or 1 indicates if the function/reserved word
*>  is implemented in gnuCOBOL but xref treats all as being reserved as
*>   they are still so, in someone's compiler
*>
 01  Function-Table.                                     *> updated by Get-Reserved-Lists
     03  filler pic x(31) value "1ABS                        ".
     03  filler pic x(31) value "1ACOS                       ".
     03  filler pic x(31) value "1ANNUITY                    ".
     03  filler pic x(31) value "1ASIN                       ".
     03  filler pic x(31) value "1ATAN                       ".
     03  filler pic x(31) value "0BOOLEAN-OF-INTEGER         ".
     03  filler pic x(31) value "1BYTE-LENGTH                ".
     03  filler pic x(31) value "1CHAR                       ".
     03  filler pic x(31) value "0CHAR-NATIONAL              ".
     03  filler pic x(31) value "1COMBINED-DATETIME          ".
     03  filler pic x(31) value "1CONCATENATE                ".
     03  filler pic x(31) value "1COS                        ".
     03  filler pic x(31) value "1CURRENT-DATE               ".
     03  filler pic x(31) value "1DATE-OF-INTEGER            ".
     03  filler pic x(31) value "1DATE-TO-YYYYMMDD           ".
     03  filler pic x(31) value "1DAY-OF-INTEGER             ".
     03  filler pic x(31) value "1DAY-TO-YYYYDDD             ".
     03  filler pic x(31) value "0DISPLAY-OF                 ".
     03  filler pic x(31) value "0E                          ".
     03  filler pic x(31) value "1EXCEPTION-FILE             ".
     03  filler pic x(31) value "0EXCEPTION-FILE-N           ".
     03  filler pic x(31) value "1EXCEPTION-LOCATION         ".
     03  filler pic x(31) value "0EXCEPTION-LOCATION-N       ".
     03  filler pic x(31) value "1EXCEPTION-STATEMENT        ".
     03  filler pic x(31) value "1EXCEPTION-STATUS           ".
     03  filler pic x(31) value "1EXP                        ".
     03  filler pic x(31) value "1EXP10                      ".
     03  filler pic x(31) value "1FACTORIAL                  ".
     03  filler pic x(31) value "1FRACTION-PART              ".
     03  filler pic x(31) value "0HIGHEST-ALGEBRAIC          ".
     03  filler pic x(31) value "1INTEGER                    ".
     03  filler pic x(31) value "0INTEGER-OF-BOOLEAN         ".
     03  filler pic x(31) value "1INTEGER-OF-DATE            ".
     03  filler pic x(31) value "1INTEGER-OF-DAY             ".
     03  filler pic x(31) value "1INTEGER-PART               ".
     03  filler pic x(31) value "1LENGTH                     ".
     03  filler pic x(31) value "0LOCALE-COMPARE             ".
     03  filler pic x(31) value "1LOCALE-DATE                ".
     03  filler pic x(31) value "1LOCALE-TIME                ".
     03  filler pic x(31) value "1LOCALE-TIME-FROM-SECONDS   ".
     03  filler pic x(31) value "1LOG                        ".
     03  filler pic x(31) value "1LOG10                      ".
     03  filler pic x(31) value "1LOWER-CASE                 ".
     03  filler pic x(31) value "0LOWEST-ALGEBRAIC           ".
     03  filler pic x(31) value "1MAX                        ".
     03  filler pic x(31) value "1MEAN                       ".
     03  filler pic x(31) value "1MEDIAN                     ".
     03  filler pic x(31) value "1MIDRANGE                   ".
     03  filler pic x(31) value "1MIN                        ".
     03  filler pic x(31) value "1MOD                        ".
     03  filler pic x(31) value "1MODULE-CALLER-ID           ".
     03  filler pic x(31) value "1MODULE-DATE                ".
     03  filler pic x(31) value "1MODULE-FORMATTED-DATE      ".
     03  filler pic x(31) value "1MODULE-ID                  ".
     03  filler pic x(31) value "1MODULE-PATH                ".
     03  filler pic x(31) value "1MODULE-SOURCE              ".
     03  filler pic x(31) value "1MODULE-TIME                ".
     03  filler pic x(31) value "0NATIONAL-OF                ".
     03  filler pic x(31) value "1NUMVAL                     ".
     03  filler pic x(31) value "1NUMVAL-C                   ".
     03  filler pic x(31) value "0NUMVAL-F                   ".
     03  filler pic x(31) value "1ORD                        ".
     03  filler pic x(31) value "1ORD-MAX                    ".
     03  filler pic x(31) value "1ORD-MIN                    ".
     03  filler pic x(31) value "0PI                         ".
     03  filler pic x(31) value "1PRESENT-VALUE              ".
     03  filler pic x(31) value "1RANDOM                     ".
     03  filler pic x(31) value "1RANGE                      ".
     03  filler pic x(31) value "1REM                        ".
     03  filler pic x(31) value "1REVERSE                    ".
     03  filler pic x(31) value "1SECONDS-FROM-FORMATTED-TIME".
     03  filler pic x(31) value "1SECONDS-PAST-MIDNIGHT      ".
     03  filler pic x(31) value "1SIGN                       ".
     03  filler pic x(31) value "1SIN                        ".
     03  filler pic x(31) value "1SQRT                       ".
     03  filler pic x(31) value "0STANDARD-COMPARE           ".
     03  filler pic x(31) value "1STANDARD-DEVIATION         ".
     03  filler pic x(31) value "1STORED-CHAR-LENGTH         ".
     03  filler pic x(31) value "1SUBSTITUTE                 ".
     03  filler pic x(31) value "1SUBSTITUTE-CASE            ".
     03  filler pic x(31) value "1SUM                        ".
     03  filler pic x(31) value "1TAN                        ".
     03  filler pic x(31) value "1TEST-DATE-YYYYMMDD         ".
     03  filler pic x(31) value "1TEST-DAY-YYYYDDD           ".
     03  filler pic x(31) value "0TEST-NUMVAL                ".
     03  filler pic x(31) value "0TEST-NUMVAL-C              ".
     03  filler pic x(31) value "0TEST-NUMVAL-F              ".
     03  filler pic x(31) value "1TRIM                       ".
     03  filler pic x(31) value "1UPPER-CASE                 ".
     03  filler pic x(31) value "1VARIANCE                   ".
     03  filler pic x(31) value "1WHEN-COMPILED              ".
     03  filler pic x(31) value "1YEAR-TO-YYYY               ".  *>  92
     03  filler    values high-values.
         05  filler pic x(31) occurs 164.                        *> pad to 256 entries
*>
 01  Function-Table-R redefines Function-Table.                  *> updated by Get-Reserved-Lists
     03  All-Functions       occurs 256 ascending key P-Function indexed by All-Fun-Idx.
         05  P-gc-implemented pic x.
         05  P-Function       pic x(30).
 01  Function-Table-Size      pic s9(5)  comp  value 92.          *> updated by Get-Reserved-Lists
*>
 01  System-Table.
     03  filler pic x(30) value "SYSTEM              ".
     03  filler pic x(30) value "CBL_AND             ".
     03  filler pic x(30) value "CBL_CHANGE_DIR      ".
     03  filler pic x(30) value "CBL_CHECK_FILE_EXIST".
     03  filler pic x(30) value "CBL_CLOSE_FILE      ".
     03  filler pic x(30) value "CBL_COPY_FILE       ".
     03  filler pic x(30) value "CBL_CREATE_DIR      ".
     03  filler pic x(30) value "CBL_CREATE_FILE     ".
     03  filler pic x(30) value "CBL_DELETE_DIR      ".
     03  filler pic x(30) value "CBL_DELETE_FILE     ".
     03  filler pic x(30) value "CBL_EQ              ".
     03  filler pic x(30) value "CBL_ERROR_PROC      ".
     03  filler pic x(30) value "CBL_EXIT_PROC       ".
     03  filler pic x(30) value "CBL_FLUSH_FILE      ".
     03  filler pic x(30) value "CBL_GET_CSR_POS     ".
     03  filler pic x(30) value "CBL_GET_CURRENT_DIR ".
     03  filler pic x(30) value "CBL_GET_SCR_SIZE    ".
     03  filler pic x(30) value "CBL_IMP             ".
     03  filler pic x(30) value "CBL_NIMP            ".
     03  filler pic x(30) value "CBL_NOR             ".
     03  filler pic x(30) value "CBL_NOT             ".
     03  filler pic x(30) value "CBL_OPEN_FILE       ".
     03  filler pic x(30) value "CBL_OR              ".
     03  filler pic x(30) value "CBL_READ_FILE       ".
     03  filler pic x(30) value "CBL_READ_KBD_CHAR   ".
     03  filler pic x(30) value "CBL_RENAME_FILE     ".
     03  filler pic x(30) value "CBL_SET_CSR_POS     ".
     03  filler pic x(30) value "CBL_TOLOWER         ".
     03  filler pic x(30) value "CBL_TOUPPER         ".
     03  filler pic x(30) value "CBL_WRITE_FILE      ".
     03  filler pic x(30) value "CBL_XOR             ".
     03  filler pic x(30) value "CBL_GC_FORK         ".
     03  filler pic x(30) value "CBL_GC_GETOPT       ".
     03  filler pic x(30) value "CBL_GC_HOSTED       ".
     03  filler pic x(30) value "CBL_GC_NANOSLEEP    ".
     03  filler pic x(30) value "CBL_GC_PRINTABLE    ".
     03  filler pic x(30) value "CBL_GC_WAITPID      ".
     03  filler pic x(30) value "CBL_OC_GETOPT       ".
     03  filler pic x(30) value "CBL_OC_HOSTED       ".
     03  filler pic x(30) value "CBL_OC_NANOSLEEP    ".
     03  filler pic x(30) value "C$CALLEDBY          ".
     03  filler pic x(30) value "C$CHDIR             ".
     03  filler pic x(30) value "C$COPY              ".
     03  filler pic x(30) value "C$DELETE            ".
     03  filler pic x(30) value "C$FILEINFO          ".
     03  filler pic x(30) value "C$GETPID            ".
     03  filler pic x(30) value "C$JUSTIFY           ".
     03  filler pic x(30) value "C$MAKEDIR           ".
     03  filler pic x(30) value "C$NARG              ".
     03  filler pic x(30) value "C$PARAMSIZE         ".
     03  filler pic x(30) value "C$PRINTABLE         ".
     03  filler pic x(30) value "C$SLEEP             ".
     03  filler pic x(30) value "C$TOLOWER           ".
     03  filler pic x(30) value "C$TOUPPER           ".
     03  filler pic x(30) value "EXTFH               ".  *> 55
     03  filler pic x(30) value "91".
     03  filler pic x(30) value "E4".
     03  filler pic x(30) value "E5".
     03  filler pic x(30) value "F4".
     03  filler pic x(30) value "F5".                  *> 60
     03  filler    values high-values.
         05  filler pic x(30) occurs 68.                        *> pad to 128 entries
*>
 01  System-Table-R redefines System-Table.                  *> updated by Get-Reserved-Lists
     03  All-Systems      occurs 128 ascending key P-System indexed by All-System-Idx.
         05  P-System       pic x(30).
 01  System-Table-Size      pic s9(5)  comp  value 60.        *> updated by Get-Reserved-Lists
*>
*> Here for all reserved words in GC see: struct reserved reserved_words
*>   in cobc/reserved.c in the open-cobol source directory
*>
 01  Additional-Reserved-Words.                                   *> updated by Get-Reserved-Lists
     03  filler pic x(31) value "1ACCEPT".
     03  filler pic x(31) value "1ACCESS".
     03  filler pic x(31) value "0ACTIVE-CLASS".
     03  filler pic x(31) value "1ADD".
     03  filler pic x(31) value "1ADDRESS".
     03  filler pic x(31) value "1ADVANCING".
     03  filler pic x(31) value "1AFTER".
     03  filler pic x(31) value "0ALIGNED".
     03  filler pic x(31) value "1ALL".
     03  filler pic x(31) value "1ALLOCATE".
     03  filler pic x(31) value "1ALPHABET".
     03  filler pic x(31) value "1ALPHABETIC  ".
     03  filler pic x(31) value "1ALPHABETIC-LOWER".
     03  filler pic x(31) value "1ALPHABETIC-UPPER".
     03  filler pic x(31) value "1ALPHANUMERIC".
     03  filler pic x(31) value "1ALPHANUMERIC-EDITED".
     03  filler pic x(31) value "1ALSO".
     03  filler pic x(31) value "1ALTER".
     03  filler pic x(31) value "1ALTERNATE".
     03  filler pic x(31) value "1AND".
     03  filler pic x(31) value "1ANY".
     03  filler pic x(31) value "0ANYCASE".
     03  filler pic x(31) value "1ARE".
     03  filler pic x(31) value "1AREA".
     03  filler pic x(31) value "1AREAS".
     03  filler pic x(31) value "1ARGUMENT-NUMBER".
     03  filler pic x(31) value "1ARGUMENT-VALUE".
     03  filler pic x(31) value "0ARITHMETIC".
     03  filler pic x(31) value "1AS".
     03  filler pic x(31) value "1ASCENDING".
     03  filler pic x(31) value "1ASCII".
     03  filler pic x(31) value "1ASSIGN".
     03  filler pic x(31) value "1AT".
     03  filler pic x(31) value "0ATTRIBUTE".
     03  filler pic x(31) value "1AUTO".
     03  filler pic x(31) value "1AUTO-SKIP".
     03  filler pic x(31) value "1AUTOMATIC".
     03  filler pic x(31) value "1AUTOTERMINATE".
     03  filler pic x(31) value "1AWAY-FROM-ZERO".
     03  filler pic x(31) value "0B-AND".
     03  filler pic x(31) value "0B-NOT".
     03  filler pic x(31) value "0B-OR".
     03  filler pic x(31) value "0B-XOR".
     03  filler pic x(31) value "1BACKGROUND-COLOR".
     03  filler pic x(31) value "1BACKGROUND-COLOUR".
     03  filler pic x(31) value "1BASED".
     03  filler pic x(31) value "1BEEP".
     03  filler pic x(31) value "1BEFORE".
     03  filler pic x(31) value "1BELL".
     03  filler pic x(31) value "1BINARY".
     03  filler pic x(31) value "1BINARY-C-LONG".
     03  filler pic x(31) value "1BINARY-CHAR".
     03  filler pic x(31) value "1BINARY-DOUBLE".
     03  filler pic x(31) value "1BINARY-INT".
     03  filler pic x(31) value "1BINARY-LONG".
     03  filler pic x(31) value "1BINARY-LONG-LONG".
     03  filler pic x(31) value "1BINARY-SHORT".
     03  filler pic x(31) value "0BIT".
     03  filler pic x(31) value "1BLANK".
     03  filler pic x(31) value "1BLINK".
     03  filler pic x(31) value "1BLOCK".
     03  filler pic x(31) value "0BOOLEAN".
     03  filler pic x(31) value "1BOTTOM".
     03  filler pic x(31) value "1BY".
     03  filler pic x(31) value "0BYTE-LENGTH".
     03  filler pic x(31) value "1CALL".
     03  filler pic x(31) value "1CANCEL".
     03  filler pic x(31) value "0CAPACITY".
     03  filler pic x(31) value "0CD".
     03  filler pic x(31) value "0CENTER".
     03  filler pic x(31) value "1CF".
     03  filler pic x(31) value "1CH".
     03  filler pic x(31) value "0CHAIN".
     03  filler pic x(31) value "1CHAINING".
     03  filler pic x(31) value "1CHARACTER".
     03  filler pic x(31) value "1CHARACTERS".
     03  filler pic x(31) value "1CLASS".
     03  filler pic x(31) value "0CLASS-ID".
     03  filler pic x(31) value "0CLASSIFICATION".
     03  filler pic x(31) value "1CLOSE".
     03  filler pic x(31) value "1COB-CRT-STATUS".
     03  filler pic x(31) value "1CODE".
     03  filler pic x(31) value "1CODE-SET".
     03  filler pic x(31) value "1COL".
     03  filler pic x(31) value "1COLLATING".
     03  filler pic x(31) value "1COLS".
     03  filler pic x(31) value "1COLUMN".
     03  filler pic x(31) value "1COLUMNS".
     03  filler pic x(31) value "1COMMA".
     03  filler pic x(31) value "1COMMAND-LINE".
     03  filler pic x(31) value "1COMMIT".
     03  filler pic x(31) value "1COMMON".
     03  filler pic x(31) value "0COMMUNICATION".
     03  filler pic x(31) value "1COMP".
     03  filler pic x(31) value "1COMP-1".
     03  filler pic x(31) value "1COMP-2".
     03  filler pic x(31) value "1COMP-3".
     03  filler pic x(31) value "1COMP-4".
     03  filler pic x(31) value "1COMP-5".
     03  filler pic x(31) value "1COMP-X".
     03  filler pic x(31) value "1COMPUTATIONAL".
     03  filler pic x(31) value "1COMPUTATIONAL-1".
     03  filler pic x(31) value "1COMPUTATIONAL-2".
     03  filler pic x(31) value "1COMPUTATIONAL-3".
     03  filler pic x(31) value "1COMPUTATIONAL-4".
     03  filler pic x(31) value "1COMPUTATIONAL-5".
     03  filler pic x(31) value "1COMPUTATIONAL-X".
     03  filler pic x(31) value "1COMPUTE".
     03  filler pic x(31) value "0CONDITION".
     03  filler pic x(31) value "1CONFIGURATION".
     03  filler pic x(31) value "1CONSTANT".
     03  filler pic x(31) value "1CONTAINS".
     03  filler pic x(31) value "1CONTENT".
     03  filler pic x(31) value "1CONTINUE".
     03  filler pic x(31) value "1CONTROL".
     03  filler pic x(31) value "1CONTROLS".
     03  filler pic x(31) value "1CONVERTING".
     03  filler pic x(31) value "1COPY".
     03  filler pic x(31) value "1CORR".
     03  filler pic x(31) value "1CORRESPONDING".
     03  filler pic x(31) value "1COUNT".
     03  filler pic x(31) value "1CRT".
     03  filler pic x(31) value "1CRT-UNDER".
     03  filler pic x(31) value "1CURRENCY".
     03  filler pic x(31) value "1CURSOR".
     03  filler pic x(31) value "1CYCLE".
     03  filler pic x(31) value "1DATA".
     03  filler pic x(31) value "0DATA-POINTER".
     03  filler pic x(31) value "1DATE".
     03  filler pic x(31) value "1DAY".
     03  filler pic x(31) value "1DAY-OF-WEEK".
     03  filler pic x(31) value "1DE".
     03  filler pic x(31) value "1DEBUGGING".
     03  filler pic x(31) value "1DECIMAL-POINT".
     03  filler pic x(31) value "1DECLARATIVES".
     03  filler pic x(31) value "1DEFAULT".
     03  filler pic x(31) value "1DELETE".
     03  filler pic x(31) value "1DELIMITED".
     03  filler pic x(31) value "1DELIMITER".
     03  filler pic x(31) value "1DEPENDING".
     03  filler pic x(31) value "1DESCENDING".
     03  filler pic x(31) value "0DESTINATION".
     03  filler pic x(31) value "1DETAIL".
     03  filler pic x(31) value "0DISABLE".
     03  filler pic x(31) value "1DISK".
     03  filler pic x(31) value "1DISPLAY".
     03  filler pic x(31) value "1DIVIDE".
     03  filler pic x(31) value "1DIVISION".
     03  filler pic x(31) value "1DOWN".
     03  filler pic x(31) value "1DUPLICATES".
     03  filler pic x(31) value "1DYNAMIC".
     03  filler pic x(31) value "1EBCDIC".
     03  filler pic x(31) value "0EC".
     03  filler pic x(31) value "0EGI".
     03  filler pic x(31) value "1ELSE".
     03  filler pic x(31) value "0EMI".
     03  filler pic x(31) value "1EMPTY-CHECK".
     03  filler pic x(31) value "0ENABLE".
     03  filler pic x(31) value "1END".
     03  filler pic x(31) value "1END-ACCEPT".
     03  filler pic x(31) value "1END-ADD".
     03  filler pic x(31) value "1END-CALL".
     03  filler pic x(31) value "1END-COMPUTE".
     03  filler pic x(31) value "1END-DELETE".
     03  filler pic x(31) value "1END-DISPLAY".
     03  filler pic x(31) value "1END-DIVIDE".
     03  filler pic x(31) value "1END-EVALUATE".
     03  filler pic x(31) value "1END-IF".
     03  filler pic x(31) value "1END-MULTIPLY".
     03  filler pic x(31) value "1END-OF-PAGE".
     03  filler pic x(31) value "1END-PERFORM".
     03  filler pic x(31) value "1END-READ".
     03  filler pic x(31) value "0END-RECEIVE".
     03  filler pic x(31) value "1END-RETURN".
     03  filler pic x(31) value "1END-REWRITE".
     03  filler pic x(31) value "1END-SEARCH".
     03  filler pic x(31) value "1END-START".
     03  filler pic x(31) value "1END-STRING".
     03  filler pic x(31) value "1END-SUBTRACT".
     03  filler pic x(31) value "1END-UNSTRING".
     03  filler pic x(31) value "1END-WRITE".
     03  filler pic x(31) value "1ENTRY".
     03  filler pic x(31) value "0ENTRY-CONVENTION".
     03  filler pic x(31) value "1ENVIRONMENT".
     03  filler pic x(31) value "1ENVIRONMENT-NAME".
     03  filler pic x(31) value "1ENVIRONMENT-VALUE".
     03  filler pic x(31) value "0EO".
     03  filler pic x(31) value "1EOL".
     03  filler pic x(31) value "1EOP".
     03  filler pic x(31) value "1EOS".
     03  filler pic x(31) value "1EQUAL".
     03  filler pic x(31) value "1EQUALS".
     03  filler pic x(31) value "1ERASE".
     03  filler pic x(31) value "1ERROR".
     03  filler pic x(31) value "1ESCAPE".
     03  filler pic x(31) value "0ESI".
     03  filler pic x(31) value "1EVALUATE".
     03  filler pic x(31) value "1EXCEPTION".
     03  filler pic x(31) value "0EXCEPTION-OBJECT".
     03  filler pic x(31) value "1EXCLUSIVE".
     03  filler pic x(31) value "1EXIT".
     03  filler pic x(31) value "0EXPANDS".
     03  filler pic x(31) value "1EXTEND".
     03  filler pic x(31) value "1EXTERNAL".
     03  filler pic x(31) value "0FACTORY".
     03  filler pic x(31) value "1FALSE".
     03  filler pic x(31) value "1FD".
     03  filler pic x(31) value "1FILE".
     03  filler pic x(31) value "1FILE-CONTROL".
     03  filler pic x(31) value "1FILE-ID".
     03  filler pic x(31) value "1FILLER".
     03  filler pic x(31) value "1FINAL".
     03  filler pic x(31) value "1FIRST".
     03  filler pic x(31) value "0FLOAT-BINARY-16".
     03  filler pic x(31) value "0FLOAT-BINARY-34".
     03  filler pic x(31) value "0FLOAT-BINARY-7".
     03  filler pic x(31) value "0FLOAT-DECIMAL-16".
     03  filler pic x(31) value "0FLOAT-DECIMAL-34".
     03  filler pic x(31) value "0FLOAT-EXTENDED".
     03  filler pic x(31) value "1FLOAT-LONG".
     03  filler pic x(31) value "1FLOAT-SHORT".
     03  filler pic x(31) value "1FOOTING".
     03  filler pic x(31) value "1FOR".
     03  filler pic x(31) value "1FOREGROUND-COLOR".
     03  filler pic x(31) value "1FOREGROUND-COLOUR".
     03  filler pic x(31) value "1FOREVER".
     03  filler pic x(31) value "0FORMAT".
     03  filler pic x(31) value "1FREE".
     03  filler pic x(31) value "1FROM".
     03  filler pic x(31) value "1FULL".
     03  filler pic x(31) value "1FUNCTION".
     03  filler pic x(31) value "1FUNCTION-ID".
     03  filler pic x(31) value "0FUNCTION-POINTER".
     03  filler pic x(31) value "1GENERATE".
     03  filler pic x(31) value "0GET".
     03  filler pic x(31) value "1GIVING".
     03  filler pic x(31) value "1GLOBAL".
     03  filler pic x(31) value "1GO".
     03  filler pic x(31) value "1GOBACK".
     03  filler pic x(31) value "1GREATER".
     03  filler pic x(31) value "1GROUP".
     03  filler pic x(31) value "0GROUP-USAGE".
     03  filler pic x(31) value "1HEADING".
     03  filler pic x(31) value "1HIGH-VALUE".
     03  filler pic x(31) value "1HIGH-VALUES".
     03  filler pic x(31) value "1HIGHLIGHT".
     03  filler pic x(31) value "1I-O".
     03  filler pic x(31) value "1I-O-CONTROL".
     03  filler pic x(31) value "1ID".
     03  filler pic x(31) value "1IDENTIFICATION".
     03  filler pic x(31) value "1IF".
     03  filler pic x(31) value "1IGNORE".
     03  filler pic x(31) value "1IGNORING".
     03  filler pic x(31) value "0IMPLEMENTS".
     03  filler pic x(31) value "1IN".
     03  filler pic x(31) value "1INDEX".
     03  filler pic x(31) value "1INDEXED".
     03  filler pic x(31) value "1INDICATE".
     03  filler pic x(31) value "0INDIRECT".
     03  filler pic x(31) value "0INFINITY".
     03  filler pic x(31) value "0INHERITS".
     03  filler pic x(31) value "1INITIAL".
     03  filler pic x(31) value "1INITIALISE".
     03  filler pic x(31) value "1INITIALISED".
     03  filler pic x(31) value "1INITIALIZE".
     03  filler pic x(31) value "1INITIALIZED".
     03  filler pic x(31) value "0INITIATE".
     03  filler pic x(31) value "1INPUT".
     03  filler pic x(31) value "1INPUT-OUTPUT".
     03  filler pic x(31) value "1INSPECT".
     03  filler pic x(31) value "0INTERFACE".
     03  filler pic x(31) value "0INTERFACE-ID".
     03  filler pic x(31) value "1INTO".
     03  filler pic x(31) value "0INTRINSIC".
     03  filler pic x(31) value "1INVALID".
     03  filler pic x(31) value "0INVOKE".
     03  filler pic x(31) value "1IS".
     03  filler pic x(31) value "1JUST".
     03  filler pic x(31) value "1JUSTIFIED".
     03  filler pic x(31) value "1KEPT".
     03  filler pic x(31) value "1KEY".
     03  filler pic x(31) value "1KEYBOARD".
     03  filler pic x(31) value "1LABEL".
     03  filler pic x(31) value "1LAST".
     03  filler pic x(31) value "0LC_ALL".
     03  filler pic x(31) value "0LC_COLLATE".
     03  filler pic x(31) value "0LC_CTYPE".
     03  filler pic x(31) value "0LC_MESSAGES".
     03  filler pic x(31) value "0LC_MONETARY".
     03  filler pic x(31) value "0LC_NUMERIC".
     03  filler pic x(31) value "0LC_TIME".
     03  filler pic x(31) value "1LEADING".
     03  filler pic x(31) value "1LEFT".
     03  filler pic x(31) value "0LEFT-JUSTIFY".
     03  filler pic x(31) value "1LEFTLINE".
     03  filler pic x(31) value "1LENGTH".
     03  filler pic x(31) value "1LENGTH-CHECK".
     03  filler pic x(31) value "1LESS".
     03  filler pic x(31) value "1LIMIT".
     03  filler pic x(31) value "1LIMITS".
     03  filler pic x(31) value "1LINAGE".
     03  filler pic x(31) value "1LINAGE-COUNTER".
     03  filler pic x(31) value "1LINE".
     03  filler pic x(31) value "1LINE-COUNTER".
     03  filler pic x(31) value "1LINES".
     03  filler pic x(31) value "1LINKAGE".
     03  filler pic x(31) value "1LOCAL-STORAGE".
     03  filler pic x(31) value "1LOCALE".
     03  filler pic x(31) value "1LOCK".
     03  filler pic x(31) value "1LOW-VALUE".
     03  filler pic x(31) value "1LOW-VALUES".
     03  filler pic x(31) value "0LOWER".
     03  filler pic x(31) value "1LOWLIGHT".
     03  filler pic x(31) value "1MANUAL".
     03  filler pic x(31) value "1MEMORY".
     03  filler pic x(31) value "1MERGE".
     03  filler pic x(31) value "0MESSAGE".
     03  filler pic x(31) value "0METHOD".
     03  filler pic x(31) value "0METHOD-ID".
     03  filler pic x(31) value "1MINUS".
     03  filler pic x(31) value "1MODE".
     03  filler pic x(31) value "1MOVE".
     03  filler pic x(31) value "1MULTIPLE".
     03  filler pic x(31) value "1MULTIPLY".
     03  filler pic x(31) value "1NATIONAL".
     03  filler pic x(31) value "1NATIONAL-EDITED".
     03  filler pic x(31) value "1NATIVE".
     03  filler pic x(31) value "1NEAREST-AWAY-FROM-ZERO".
     03  filler pic x(31) value "1NEAREST-EVEN".
     03  filler pic x(31) value "1NEAREST-TOWARD-ZERO".
     03  filler pic x(31) value "1NEGATIVE".
     03  filler pic x(31) value "0NEGATIVE-INFINITY".
     03  filler pic x(31) value "0NESTED".
     03  filler pic x(31) value "1NEXT".
     03  filler pic x(31) value "1NO".
     03  filler pic x(31) value "1NO-ECHO".
     03  filler pic x(31) value "0NONE".
     03  filler pic x(31) value "1NORMAL".
     03  filler pic x(31) value "1NOT".
     03  filler pic x(31) value "0NOT-A-NUMBER".
     03  filler pic x(31) value "1NULL".
     03  filler pic x(31) value "1NULLS".
     03  filler pic x(31) value "1NUMBER".
     03  filler pic x(31) value "1NUMBER-OF-CALL-PARAMETERS".
     03  filler pic x(31) value "1NUMBERS".
     03  filler pic x(31) value "1NUMERIC".
     03  filler pic x(31) value "1NUMERIC-EDITED".
     03  filler pic x(31) value "0OBJECT".
     03  filler pic x(31) value "1OBJECT-COMPUTER".
     03  filler pic x(31) value "0OBJECT-REFERENCE".
     03  filler pic x(31) value "1OCCURS".
     03  filler pic x(31) value "1OF".
     03  filler pic x(31) value "1OFF".
     03  filler pic x(31) value "1OMITTED".
     03  filler pic x(31) value "1ON".
     03  filler pic x(31) value "1ONLY".
     03  filler pic x(31) value "1OPEN".
     03  filler pic x(31) value "1OPTIONAL".
     03  filler pic x(31) value "0OPTIONS".
     03  filler pic x(31) value "1OR".
     03  filler pic x(31) value "1ORDER".
     03  filler pic x(31) value "1ORGANISATION".
     03  filler pic x(31) value "1ORGANIZATION".
     03  filler pic x(31) value "1OTHER".
     03  filler pic x(31) value "1OUTPUT".
     03  filler pic x(31) value "1OVERFLOW".
     03  filler pic x(31) value "1OVERLINE".
     03  filler pic x(31) value "0OVERRIDE".
     03  filler pic x(31) value "1PACKED-DECIMAL".
     03  filler pic x(31) value "1PADDING".
     03  filler pic x(31) value "1PAGE".
     03  filler pic x(31) value "1PAGE-COUNTER".
     03  filler pic x(31) value "1PARAGRAPH".
     03  filler pic x(31) value "1PERFORM".
     03  filler pic x(31) value "0PF".
     03  filler pic x(31) value "0PH".
     03  filler pic x(31) value "1PIC".
     03  filler pic x(31) value "1PICTURE".
     03  filler pic x(31) value "1PLUS".
     03  filler pic x(31) value "1POINTER".
     03  filler pic x(31) value "1POSITION".
     03  filler pic x(31) value "1POSITIVE".
     03  filler pic x(31) value "0POSITIVE-INFINITY".
     03  filler pic x(31) value "0PREFIXED".
     03  filler pic x(31) value "0PRESENT".
     03  filler pic x(31) value "1PREVIOUS".
     03  filler pic x(31) value "1PRINTER".
     03  filler pic x(31) value "0PRINTING".
     03  filler pic x(31) value "1PROCEDURE".
     03  filler pic x(31) value "1PROCEDURE-POINTER".
     03  filler pic x(31) value "1PROCEDURES".
     03  filler pic x(31) value "1PROCEED".
     03  filler pic x(31) value "1PROGRAM".
     03  filler pic x(31) value "1PROGRAM-ID".
     03  filler pic x(31) value "1PROGRAM-POINTER".
     03  filler pic x(31) value "1PROHIBITED".
     03  filler pic x(31) value "1PROMPT".
     03  filler pic x(31) value "0PROPERTY".
     03  filler pic x(31) value "0PROTOTYPE".
     03  filler pic x(31) value "0PURGE".
     03  filler pic x(31) value "0QUEUE".
     03  filler pic x(31) value "1QUOTE".
     03  filler pic x(31) value "1QUOTES".
     03  filler pic x(31) value "0RAISE".
     03  filler pic x(31) value "0RAISING".
     03  filler pic x(31) value "1RANDOM".
     03  filler pic x(31) value "0RD".
     03  filler pic x(31) value "1READ".
     03  filler pic x(31) value "0RECEIVE".
     03  filler pic x(31) value "1RECORD".
     03  filler pic x(31) value "1RECORDING".
     03  filler pic x(31) value "1RECORDS".
     03  filler pic x(31) value "1RECURSIVE".
     03  filler pic x(31) value "1REDEFINES".
     03  filler pic x(31) value "1REEL".
     03  filler pic x(31) value "1REFERENCE".
     03  filler pic x(31) value "1REFERENCES".
     03  filler pic x(31) value "0RELATION".
     03  filler pic x(31) value "1RELATIVE".
     03  filler pic x(31) value "1RELEASE".
     03  filler pic x(31) value "1REMAINDER".
     03  filler pic x(31) value "1REMOVAL".
     03  filler pic x(31) value "1RENAMES".
     03  filler pic x(31) value "1REPLACE".
     03  filler pic x(31) value "1REPLACING".
     03  filler pic x(31) value "0REPORT".
     03  filler pic x(31) value "0REPORTING".
     03  filler pic x(31) value "0REPORTS".
     03  filler pic x(31) value "1REPOSITORY".
     03  filler pic x(31) value "0REPRESENTS-NOT-A-NUMBER".
     03  filler pic x(31) value "1REQUIRED".
     03  filler pic x(31) value "1RESERVE".
     03  filler pic x(31) value "1RESET".
     03  filler pic x(31) value "0RESUME".
     03  filler pic x(31) value "0RETRY".
     03  filler pic x(31) value "1RETURN".
     03  filler pic x(31) value "1RETURN-CODE".
     03  filler pic x(31) value "1RETURNING".
     03  filler pic x(31) value "1REVERSE-VIDEO".
     03  filler pic x(31) value "1REVERSED".
     03  filler pic x(31) value "1REWIND".
     03  filler pic x(31) value "1REWRITE".
     03  filler pic x(31) value "0RF".
     03  filler pic x(31) value "0RH".
     03  filler pic x(31) value "1RIGHT".
     03  filler pic x(31) value "0RIGHT-JUSTIFY".
     03  filler pic x(31) value "1ROLLBACK".
     03  filler pic x(31) value "1ROUNDED".
     03  filler pic x(31) value "0ROUNDING".
     03  filler pic x(31) value "1RUN".
     03  filler pic x(31) value "1SAME".
     03  filler pic x(31) value "1SCREEN".
     03  filler pic x(31) value "1SD".
     03  filler pic x(31) value "1SEARCH".
     03  filler pic x(31) value "0SECONDS".
     03  filler pic x(31) value "1SECTION".
     03  filler pic x(31) value "1SECURE".
     03  filler pic x(31) value "0SEGMENT".
     03  filler pic x(31) value "1SEGMENT-LIMIT".
     03  filler pic x(31) value "1SELECT".
     03  filler pic x(31) value "0SELF".
     03  filler pic x(31) value "0SEND".
     03  filler pic x(31) value "1SENTENCE".
     03  filler pic x(31) value "1SEPARATE".
     03  filler pic x(31) value "1SEQUENCE".
     03  filler pic x(31) value "1SEQUENTIAL".
     03  filler pic x(31) value "1SET".
     03  filler pic x(31) value "1SHARING".
     03  filler pic x(31) value "1SIGN".
     03  filler pic x(31) value "1SIGNED".
     03  filler pic x(31) value "1SIGNED-INT".
     03  filler pic x(31) value "1SIGNED-LONG".
     03  filler pic x(31) value "1SIGNED-SHORT".
     03  filler pic x(31) value "1SIZE".
     03  filler pic x(31) value "1SORT".
     03  filler pic x(31) value "1SORT-MERGE".
     03  filler pic x(31) value "1SORT-RETURN".
     03  filler pic x(31) value "1SOURCE".
     03  filler pic x(31) value "1SOURCE-COMPUTER".
     03  filler pic x(31) value "0SOURCES".
     03  filler pic x(31) value "1SPACE".
     03  filler pic x(31) value "0SPACE-FILL".
     03  filler pic x(31) value "1SPACES".
     03  filler pic x(31) value "1SPECIAL-NAMES".
     03  filler pic x(31) value "1STANDARD".
     03  filler pic x(31) value "1STANDARD-1".
     03  filler pic x(31) value "1STANDARD-2".
     03  filler pic x(31) value "0STANDARD-BINARY".
     03  filler pic x(31) value "0STANDARD-DECIMAL".
     03  filler pic x(31) value "1START".
     03  filler pic x(31) value "0STATEMENT".
     03  filler pic x(31) value "1STATIC".
     03  filler pic x(31) value "1STATUS".
     03  filler pic x(31) value "1STDCALL".
     03  filler pic x(31) value "1STEP".
     03  filler pic x(31) value "1STOP".
     03  filler pic x(31) value "1STRING".
     03  filler pic x(31) value "0STRONG".
     03  filler pic x(31) value "0SUB-QUEUE-1".
     03  filler pic x(31) value "0SUB-QUEUE-2".
     03  filler pic x(31) value "0SUB-QUEUE-3".
     03  filler pic x(31) value "1SUBTRACT".
     03  filler pic x(31) value "1SUM".
     03  filler pic x(31) value "0SUPER".
     03  filler pic x(31) value "1SUPPRESS".
     03  filler pic x(31) value "0SYMBOL".
     03  filler pic x(31) value "1SYMBOLIC".
     03  filler pic x(31) value "1SYNC".
     03  filler pic x(31) value "1SYNCHRONISED".
     03  filler pic x(31) value "1SYNCHRONIZED".
     03  filler pic x(31) value "0SYSTEM-DEFAULT".
     03  filler pic x(31) value "0TABLE".
     03  filler pic x(31) value "1TALLYING".
     03  filler pic x(31) value "1TAPE".
     03  filler pic x(31) value "0TERMINAL".
     03  filler pic x(31) value "1TERMINATE".
     03  filler pic x(31) value "1TEST".
     03  filler pic x(31) value "0TEXT".
     03  filler pic x(31) value "1THAN".
     03  filler pic x(31) value "1THEN".
     03  filler pic x(31) value "1THROUGH".
     03  filler pic x(31) value "1THRU".
     03  filler pic x(31) value "1TIME".
     03  filler pic x(31) value "0TIME-OUT".
     03  filler pic x(31) value "0TIMEOUT".
     03  filler pic x(31) value "1TIMES".
     03  filler pic x(31) value "1TO".
     03  filler pic x(31) value "1TOP".
     03  filler pic x(31) value "1TOWARD-GREATER".
     03  filler pic x(31) value "1TOWARD-LESSER".
     03  filler pic x(31) value "1TRAILING".
     03  filler pic x(31) value "0TRAILING-SIGN".
     03  filler pic x(31) value "1TRANSFORM".
     03  filler pic x(31) value "1TRUE".
     03  filler pic x(31) value "1TRUNCATION".
     03  filler pic x(31) value "1TYPE".
     03  filler pic x(31) value "0TYPEDEF".
     03  filler pic x(31) value "0UCS-4".
     03  filler pic x(31) value "1UNDERLINE".
     03  filler pic x(31) value "1UNIT".
     03  filler pic x(31) value "0UNIVERSAL".
     03  filler pic x(31) value "1UNLOCK".
     03  filler pic x(31) value "1UNSIGNED".
     03  filler pic x(31) value "1UNSIGNED-INT".
     03  filler pic x(31) value "1UNSIGNED-LONG".
     03  filler pic x(31) value "1UNSIGNED-SHORT".
     03  filler pic x(31) value "1UNSTRING".
     03  filler pic x(31) value "1UNTIL".
     03  filler pic x(31) value "1UP".
     03  filler pic x(31) value "1UPDATE".
     03  filler pic x(31) value "1UPON".
     03  filler pic x(31) value "0UPPER".
     03  filler pic x(31) value "1USAGE".
     03  filler pic x(31) value "1USE".
     03  filler pic x(31) value "0USER-DEFAULT".
     03  filler pic x(31) value "1USING".
     03  filler pic x(31) value "0UTF-16".
     03  filler pic x(31) value "0UTF-8".
     03  filler pic x(31) value "0VAL-STATUS".
     03  filler pic x(31) value "0VALID".
     03  filler pic x(31) value "0VALIDATE".
     03  filler pic x(31) value "0VALIDATE-STATUS".
     03  filler pic x(31) value "1VALUE".
     03  filler pic x(31) value "1VALUES".
     03  filler pic x(31) value "1VARYING".
     03  filler pic x(31) value "1WAIT".
     03  filler pic x(31) value "1WHEN".
     03  filler pic x(31) value "1WITH".
     03  filler pic x(31) value "1WORDS".
     03  filler pic x(31) value "1WORKING-STORAGE".
     03  filler pic x(31) value "1WRITE".
     03  filler pic x(31) value "1YYYYDDD".
     03  filler pic x(31) value "1YYYYMMDD".
     03  filler pic x(31) value "1ZERO".
     03  filler pic x(31) value "0ZERO-FILL".
     03  filler pic x(31) value "1ZEROES".
     03  filler pic x(31) value "1ZEROS".     *>  577 to here
*>
     03  filler    value high-values.
         05  filler  pic x(31)  occurs 1471.   *> total of 2048
*>
 01  Additional-Reserved-Words-R redefines Additional-Reserved-Words.      *> updated by Get-Reserved-Lists.cbl
     03  Reserved-Names       occurs 2048 ascending key Resvd-Word indexed by Resvd-Idx.
         05  Resvd-Implemented pic x.
         05  Resvd-Word        pic x(30).
 01  Resvd-Table-Size          pic s9(5)   comp    value 577.   *> updated by Get-Reserved-Lists.cbl
*>
 01  Condition-Table                           value high-values.
     03  Con-Tab-Blocks occurs 10 to 5001 depending on Con-Tab-Size.
*> +1 used, when testing for max table size
         05  Conditions      pic x(32).
         05  Variables       pic x(32).
         05  CT-In-Use-Flag  pic x.
         05  filler          pic x.
 01  Con-Tab-Size          Binary-Long value 10.
 01  Con-Tab-Count         Binary-Long value zero.
*>
 01  Global-Item-Table                         value high-values.
     03  Git-Elements  occurs 10 to 10001 depending on Git-Table-Size.
*> +1 used, when testing for max table size
         05  Git-Word        pic x(32).
         05  Git-Prog-Name   pic x(64).   *> + 32  12/5/19
         05  Git-RefNo       pic 9(6).
         05  Git-HoldWSorPD  pic 9.
         05  Git-HoldWSorPD2 pic 9.
         05  Git-Build-No    pic 99.
         05  Git-In-Use-Flag pic x.
         05  Git-External    pic x.     *> space or Y
*>
 01  Git-Table-Size        Binary-Long value 10.
 01  Git-Table-Count       Binary-Long value zero.
*>
*>==================================
*> 01  Linked-Data
*>
 01  LS-Source-File     pic x(64).            *> For cobxref call P1
 01  LS-Prog-BaseName   pic x(64).            *>  Ditto P2
 01  LS-Prog-Format     pic x.                *>  Ditto P3
 01  LS-SW-11           pic x     value "N".  *>  Ditto P4
*>
 procedure division.
 aa000-xref-Data    section.
*>**************************
*>  TODO & BUGS:
*>************************************************************************
*> AAnnn Section:
*>  THIS ENTIRE SECTION NEEDS A REWRITE, TOO MUCH TAKEN FROM THE VERY OLD
*>   CODE BASE. DOES READ-A-WORD CATER FOR MULTIPLE STATEMENTS PER LINE
*>    WITH PERIODS ENDING EACH STATEMENT? IF SO, WHY ARE WE CHECKING FOR
*>     WORD-DELIMIT = "." THEN.
*>  THIS ALL NEEDS A GOOD LOOK AT, SO MUST BE DONE SOON but with fresh eyes
*> SUGGEST COMMON CODE LEFT HERE WITH NEW SECTIONS DEALING WITH EACH
*>  SECTION OR MAIN ENTRY
*> Also
*>  routines for source reads, get a word, parsers and tokeniser must be rewritten,
*>   they are still a mess.
*>
*>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
*>
*>  Quesions, Questions, Questions,  all I have, is questions!
*>************************************************************************
*>
*>
     perform  zz190-Init-Program thru zz190-Exit.
     move     high-values to Global-Item-Table.
*>
     perform  zz180-Open-Source-File thru zz180-Exit.
     if       No-Table-Update-displays
              move       36 to WS-Return-Code     *> Turn off table updating
     else
              move     zero to ws-Return-Code.
     call     "get-reserved-lists" using ws-Return-Code
                                         Function-Table-R
                                         Function-Table-Size
                                         Additional-Reserved-Words-R
                                         Resvd-Table-Size
                                         System-Table-R
                                         System-Table-Size.
*>
     if       ws-Return-Code not = zero
              display Msg19.         	*> Possible problem with cobc not in path
*>
*> Just in case someones added names in source code (or in cobc) out of sort order
*>  We MUST have all tables in sorted order
*>
     sort     Reserved-Names ascending Resvd-Word.
     sort     All-Functions ascending P-Function.
     sort     All-Systems ascending P-System.
*>
*>  If requested, Dump All reserved words from tables to screen, nothing fancy then stop.
*>
     if       Dump-Reserved-Words
              display space
              display "Reserved Word Table"
              display space
              perform varying a from 1 by 1 until a > Resvd-Table-Size
                    display Resvd-Word (a)
                    end-display
              end-perform
              display space
              display "Function Table"
              display space
              perform varying a from 1 by 1 until a > Function-Table-Size
                    display P-Function (a)
                    end-display
              end-perform
              display space
              display "System Table"
              display space
              perform varying a from 1 by 1 until a > System-Table-Size
                    display P-System (a)
                    end-display
              end-perform
              close SourceInput
              move zero to return-code
              goback
     end-if
     open output Source-Listing
*>
     if       Reports-In-Lower
              move function lower-case (Prog-BaseName (1:CWS)) to HoldID
     else
              move function upper-case (Prog-BaseName (1:CWS)) to HoldID
     end-if
     move     HoldID to HoldID-Module.
     move     spaces to Arg-Vals.
*>
*> get program id frm source filename in case prog-id not present
*>
     if       Create-Compressed-Src
          and not End-Prog
              string Prog-BaseName delimited by space
                     ".src" delimited by size
                     into CopySourceFileName2
              open output CopySourceInput2.
*>
 aa020-Bypass-Open.
     open     output Supplemental-Part1-Out.
*>
*> Now add in contents of Global table if processing nested modules
*>   and we have processed first one by loading sort file
*>
     if       Git-Table-Count not = zero
              initialize SortRecord
              perform varying a from 1 by 1 until a > Git-Table-Count
                   move Git-HoldWSorPD  (a) to SkaWSorPD
                   move Git-HoldWSorPD2 (a) to SkaWSorPD2
                   if Reports-In-Lower
                      move function lower-case (Git-Word (a)) to SkaDataName
                   else
                      move Git-Word (a) to SkaDataName
                   end-if
                   move Git-RefNo (a) to SkaRefNo
                   move 1 to USect (Git-HoldWSorPD (a))
                   move HoldID  to SkaProgramName
                   if  SkaDataName not = spaces
                       write SortRecord
                   end-if
              end-perform
     end-if
*>
*> HoldID gets updated with program-id name when found later
*>   but we can print 1st report headings using the sourcefile name
*>    we are assuming the user knows what s/he is doing......:)
*>
     move     Prog-Name to H1Prog-Name.
     if       List-Source
              perform  zz150-WriteHdb.
*>
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
     move     1 to q S-Pointer F-Pointer.
*>
 aa030-ReadLoop1.
     if       Source-Eof
           or End-Prog
              display Msg2
              close Supplemental-Part1-Out Source-Listing
              close SourceInput
              move 16 to return-code
              goback.
     perform  zz110-Get-A-Word thru zz110-Exit.
     IF       SourceInWS = "DATA DIVISION.  "
                       or  "FILE SECTION.   "
                       or  "WORKING-STORAGE SECTION."
                       or  "PROCEDURE DIVISION."
              go to aa060-ReadLoop3a.
*>
*> The above should never happen, as all modules have a program-id
*>   but who knows what new standards will allow
*>
     if       wsFoundWord2 not = "PROGRAM-ID"
         and               not = "FUNCTION-ID"
              go to aa030-ReadLoop1.
     perform  zz110-Get-A-Word thru zz110-Exit.
*>
*> got program or function name so if 1st prog id -> hold-id
*>               else -> holdid-module (for reports)
*>  but 1st check if its a literal & if so remove quotes and use 1st CWS chars
*>
     if       wsf1-1 = quote or = "'"
              unstring wsFoundWord2 (2:32) delimited by quote or "'"  into wsFoundNewWord
              end-unstring
              move wsFoundNewWord (1:CWS) to  wsFoundWord2
     end-if
     if       not Have-Nested
        if       Reports-In-Lower
                 move function lower-case (wsFoundWord2)  to HoldID
        else
                 move function upper-case (wsFoundWord2)  to HoldID
        end-if
        move     HoldID  to HoldID-Module                *> For sort keys
     end-if
     if       Have-Nested            *> found more than 1 module in source
        if       Reports-In-Lower
                 move function lower-case (wsFoundWord2) to HoldID-Module
        else
                 move function upper-case (wsFoundWord2) to HoldID-Module.
*>
*> We now have the program-id name so update our info, for reports
*> WARNING: we are ignoring optional AS literal sub-clause
*>
*> Next block of interest is special-names and then file-control
*>
 aa040-ReadLoop2.
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
     if       SourceInWS (1:14) = "SPECIAL-NAMES."
       if We-Are-Testing display "Found aa040 SPECIAL-NAMES" end-if
              go to aa041-Get-SN.
     if       SourceInWS (1:13) = "FILE-CONTROL."   *> selects
       if We-Are-Testing display "Found aa040 FILE-CONTROL" end-if
              go to aa047-GetIO.
     if       SourceInWS (1:12) = "I-O-CONTROL."    *> same area etc
       if We-Are-Testing display "Found aa040 I-O-CONTROL" end-if
              go to aa048-GetIOC.
     if       SourceInWS (1:12) = "DATA DIVISIO"
       if We-Are-Testing display "Found aa040 DATA DIVISIO" end-if
              go to aa041-Get-SN.
     perform  aa045-Test-Section thru aa045-Exit.
*>
*> if not zero we have got Data Div onwards otherwise ignore everything else.
*>
     if       a not = zero
              go to aa060-ReadLoop3a.
     go       to aa040-ReadLoop2.
*>
 aa041-Get-SN.
*>
*> Get special names
*>
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
     perform  aa045-Test-Section thru aa045-Exit.
     if       a not = zero
              go to aa060-ReadLoop3a.
     if       SourceInWS (1:13) = "INPUT-OUTPUT " or = "DATA DIVISION"
       if We-Are-Testing display "Found aa041 I-O or DATA DIV" end-if
              go to aa041-Get-SN.
     IF       SourceInWS (1:13) = "FILE-CONTROL."
       if We-Are-Testing display "Found aa041 FILE-CONTROL" end-if
              go to aa047-GetIO.
     IF       SourceInWS (1:12) = "I-O-CONTROL."
       if We-Are-Testing display "Found aa041 I_O_CONTROL" end-if
              go to aa048-GetIOC.
*>
 aa042-Getword.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       Word-Delimit = "."
              go to aa041-Get-SN.
     if       wsFoundWord2 (1:9) = "CURRENCY "
              perform aa046-Get-Currency
              go to aa042-Getword.
     if       wsFoundWord2 (1:3) not = "IS "
              go to aa042-Getword.
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsf1-1 = quote or = "'" or wsf1-1-number
              go to aa042-Getword.
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a not = zero
              go to aa042-Getword.
     move     wsFoundWord2 (1:CWS) to Saved-Variable.
*>
 aa044-Getword3.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       Word-Delimit = "."
              go to aa041-Get-SN.
     if       wsFoundWord2 (1:9) = "CURRENCY "
              perform aa046-Get-Currency
              go to aa044-Getword3.
     if       wsFoundWord2 (1:2) not = "ON"
          and wsFoundWord2 (1:3) not = "OFF"
              go to aa044-Getword3.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsf1-1 = quote or = "'" or wsf1-1-number
              go to aa044-Getword3.
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a not = zero
              go to aa044-Getword3.
*>
     if       Con-Tab-Size not < Con-Tab-Count
              add 10 to Con-Tab-Size.
     add      1 to Con-Tab-Count.

     if       Reports-In-Lower
              move function lower-case (Saved-Variable) to  Variables (Con-Tab-Count)
              move function lower-case (wsFoundWord2 (1:CWS)) to Conditions (Con-Tab-Count)
     else
              move Saved-Variable to Variables (Con-Tab-Count)
              move wsFoundWord2 (1:CWS) to Conditions (Con-Tab-Count)
     end-if
     move     Space  to CT-In-Use-Flag (Con-Tab-Count).
     if       Word-Delimit = "."
              go to aa041-Get-SN.
     go       to aa044-Getword3.
*>
 aa045-Test-Section.
     perform  varying a from 1 by 1 until a > 8
              if SourceInWS (1:24) = Full-Section-Name (a)
                  exit perform
              end-if
     end-perform.
     if       a > 8
              move zero to a.
*>
 aa045-Exit.
     exit.
*>
 aa046-Get-Currency.
*>
*> Got 'Currency', so process as needed for pic tests in zz110
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsFoundWord2 (1:5) = "SIGN "
           or wsFoundWord2 (1:3) = "IS "
              go to aa046-Get-Currency.
*>
*> Now Ive got the literal "x"
*>
     move     wsFoundWord2 (2:1) to Currency-Sign.
     if we-are-testing
        display " Now got currency = " Currency-Sign
     end-if.
*>
 aa047-GetIO.
*>
*> now got file control so its SELECT ..
*>
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
     perform  aa045-Test-Section thru aa045-Exit.
     if       a not = zero
              go to aa060-ReadLoop3a.
     IF       SourceInWS (1:12) = "I-O-CONTROL."
       if We-Are-Testing display "Found aa047 I-O-CONTROL" end-if
              go to aa048-GetIOC.
     if       SourceInWS (1:12) = "DATA DIVISIO"
       if We-Are-Testing display "Found aa047 DATA DIVISIO" end-if
              go to aa050-ReadLoop3.
     if       SourceInWS (1:12) = "FILE SECTION"
       if We-Are-Testing display "Found aa047 FILE SECTION" end-if
              go to aa060-ReadLoop3a.
*>  go to aa047-getio.   *> skip selects during test
*>
 aa047-Getword.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       Word-Delimit = "."
              go to aa047-GetIO.
*>
*> now looking at selects: so looking for non reserved words
*>
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a not = zero
              go to aa047-Getword.
     if       Word-Delimit = "."
              go to aa047-GetIO.
*> Now have filename-1
     move     1 to HoldWSorPD.
     move     0 to HoldWSorPD2.
     perform  zz030-Write-Sort.
*>
 aa047-Getword2.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       Source-Eof
              display Msg18
              close Supplemental-Part1-Out Source-Listing
              close SourceInput
              move 16 to return-code
              goback.
*>
*> should have assign
*>
     if       wsFoundWord2 (1:7) not = "ASSIGN "
              go to aa047-Getword2.
*>
 aa047-Getword3.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       (wsf1-1 = quote or = "'") AND Word-Delimit = "."
              go to aa047-GetIO.                               *> End of a SELECT
     if       wsf1-1 = quote or = "'" or wsf1-1-number
              go to aa047-Getword3.
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a not = zero and Word-Delimit = "."
              go to aa047-GetIO.
     if       a not = zero
              go to aa047-Getword3.
     if       word-length = zero
              go to aa047-GetIO.
*>
*> Now have filename
*> filenames / datanames declared in Selects are shown as in data division
*>
     move     1 to HoldWSorPD.
     move     0 to HoldWSorPD2.
     perform  zz030-Write-Sort.
     if       Word-Delimit = "."
              go to aa047-GetIO.
     go       to aa047-Getword3.
*>
 aa048-GetIOC.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsf1-1 = quote or = "'" or wsf1-1-number
              go to aa048-GetIOC.
 aa048-Get-Next.
     if       Word-Delimit = "."
              perform zz100-Get-A-Source-Record thru zz100-Exit
              perform aa045-Test-Section thru aa045-Exit
              if      a not = zero
                      go to aa060-ReadLoop3a
              else
                      perform  zz110-Get-A-Word thru zz110-Exit
              end-if
     end-if
     if       wsFoundWord2 (1:5) not = "SAME "
              go to aa048-GetIOC.
*>
 aa049-Getword.
     perform  zz110-Get-A-Word thru zz110-Exit.
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a not = zero
              go to aa049-Getword.
*> Now have filename
     move     1 to HoldWSorPD.
     move     0 to HoldWSorPD2.
     perform  zz030-Write-Sort.
     if       Word-Delimit = "."
              go to aa048-Get-Next.
     go       to aa049-Getword.
*>
 aa050-ReadLoop3.
*>
*>    Now for the data division or beyond
*>
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
*>
 aa060-ReadLoop3a.
     perform  zz170-Check-4-Section thru zz170-Exit.
     if       GotASection = "Y"
        and   HoldWSorPD < 8
              go to aa050-ReadLoop3.
     if       HoldWSorPD > zero and < 8
              move 1 to S-Pointer2
              perform ba000-Process-WS.
*>
     if       HoldWSorPD = zero
              go to aa050-ReadLoop3.
*>
     perform  bb000-Process-Procedure.
     if       End-Prog
              close Supplemental-Part1-Out
     else
              close SourceInput Supplemental-Part1-Out.
     perform  bc000-Last-Act.
     if       not End-Prog
              perform  bc620-Do-Global-Conditions thru bc629-Exit
              close Source-Listing.
*>
     if       Create-Compressed-Src
      and not End-Prog
              close CopySourceInput2.
*>
     go       to  aa070-Bypass-File-Deletes.   *> Remark out when testing finished.
*>
*>**************************************************************************************
*>
*>
*>  If deleting the Supp files remove all of the '*>' except for the SourceFileName line
*>    as that could be for a normal input file and not the o/p from the compiler
*>      which is in the form sourcefile.i
*>**************************************************************************************
*>
     if       not We-Are-Testing
          and not End-Prog
              call "CBL_DELETE_FILE" using SourceFileName  *>  basename + .pro, o/p from printcbl
*> kill temp input file (anything else?) but not yet, Use when in QAR.
              call "CBL_DELETE_FILE" using Supp-File-2
              call "CBL_DELETE_FILE" using Supp-File-1
     end-if.
*>
 aa070-Bypass-File-Deletes.
     if       End-Prog
              perform  zz190-Init-Program thru zz190-Exit
              move  spaces to PrintLine
              write PrintLine
              write PrintLine
              write PrintLine
              add  3 to Line-Count
              move  zero to sw-End-Prog
              go    to aa020-Bypass-Open
     end-if
     move     zero to return-code.
     goback.
*>
 ba000-Process-WS Section.
 ba020-GetAWord.
*>
*> this should be getting first word of source record
*>   but JIC test for section
*>
     if       GotASection = "Y"                     *> check for Proc. Div
         and  HoldWSorPD = 8
              go to ba000-Exit.                     *> done, so process proc. div
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       word-length = zero
              go to ba020-GetAWord.
     if       GotASection = "Y"                     *> check for Proc. Div
         and  HoldWSorPD = 8
              go to ba000-Exit.                     *> done, so process proc. div
     if       GotASection = "Y"
              move space to GotASection
              perform zz100-Get-A-Source-Record thru zz100-Exit
              go to ba020-GetAWord.
*>
*> lets get a file section element out of the way
*>
     if       wsFoundWord2 (1:3) = "FD " or = "RD "
              move zero to Global-Current-Level     *> Global only
     else
      if      wsFoundWord2 (1:3) = "CD " or = "SD " *> not these
              move 99 to Global-Current-Level.
*>
*> Clears Global-Active
*>
*> note that for CD & SD setting Global-current-* not needed
*>                           is it a problem
     if       wsFoundWord2 (1:3) = "FD " or = "SD " or = "RD " or = "CD "
              perform zz110-Get-A-Word thru zz110-Exit  *> get fn
              move zero to HoldWSorPD2
              move zero to sw-Git SW-External           *> reset Global flag
              move wsFoundWord2 (1:32) to Global-Current-Word
              move Gen-RefNo1          to Global-Current-RefNo
              perform zz030-Write-Sort
              perform ba040-Clear-To-Next-Period thru ba049-Exit
              go to ba020-GetAWord.
*>
*> we now have basic ws records, ie starting 01-49,66,77,78,88 etc
*>
      if      wsFoundWord2 (1:Word-Length) not numeric
              display "ba020:" Msg4 wsFoundWord2 (1:Word-Length) " prog = " HoldID
                      " line = " Gen-RefNo1
              close Source-Listing SourceInput
                    Supplemental-Part1-Out
              move 16 to return-code
              goback.    *> if here, its broke
*>
*> word = Build-Number
*>
      perform zz160-Clean-Number thru zz160-Exit.
      if      Build-Number > 0 and < 50
              move spaces to Saved-Variable.
*>
      if      Build-Number = 01
         and  (Global-Current-Level = 99
           or HoldWSorPD > 1)
              move zero to sw-Git
              move 1 to Global-Current-Level.
*>
      if      Build-Number = 88 or = 78 or = 77 or = 66
                                or (Build-Number > 0 and < 50)
              go to ba050-Get-User-Word.
*>
*> getting here Should never happen
*>
      display "ba020:" Msg5 "bld=" Build-Number " word=" wsFoundWord2 (1:CWS) " prog = " HoldID " line = " Gen-RefNo1.
     close    Source-Listing
              SourceInput
              Supplemental-Part1-Out.
     move     20 to return-code.
     goback.                            *> if here, its broke
*>
 ba040-Clear-To-Next-Period.
     if       Word-Delimit = "."
          and S-Pointer2 not < Source-Line-End
              add 1 to S-Pointer2
              move space to Word-Delimit
              go to ba049-Exit.
     if       Word-Delimit = "."
              go to ba049-Exit.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       WasPicture = 1     *> current word is a pic sub-clause
              move zero to WasPicture
              go to ba040-Clear-To-Next-Period.
     if       wsFoundWord2 (1:7) = "GLOBAL "
              move    1   to sw-Git
              move   zero to SW-Found-External
              perform zz200-Load-Git thru zz200-Exit
              go to ba040-Clear-To-Next-Period.
*>
     if       wsFoundWord2 (1:9) = "EXTERNAL "
              move 1 to sw-Git
                        SW-External
                        SW-Found-External
              perform zz200-Load-Git thru zz200-Exit
              go to ba040-Clear-To-Next-Period.
*>
     if       wsFoundWord2 (1:8) = "INDEXED "
              perform ba052-After-Index
              go to ba040-Clear-To-Next-Period.
     if       wsFoundWord2 (1:10) = "DEPENDING "
              perform ba053-After-Depending
              go to ba040-Clear-To-Next-Period.
     if       HoldWSorPD = 7 and
              (wsFoundWord2 (1:6) = "TO    " or "FROM  " or "USING ")
              perform zz110-Get-A-Word thru zz110-Exit
              inspect wsFoundWord2 tallying a for all "("
              if a not = zero
                 move wsFoundWord2 to wsFoundNewWord5
                 unstring wsFoundNewWord5 delimited by "(" into wsFoundWord2
              end-if
              perform zz030-Write-Sort
              go to ba040-Clear-To-Next-Period.
*>
*> Now looking for other non res words but not literals or numerics
*>
     if       wsf1-1 = quote or = "'"
              go to ba040-Clear-To-Next-Period.
     if       wsf1-1 = "-" or = "+"
              go to ba040-Clear-To-Next-Period.
     if       z > zero
          and wsFoundWord2 (1:z) numeric
              go to ba040-Clear-To-Next-Period.
     if       wsf1-1-number
              go to ba040-Clear-To-Next-Period.
     if       wsf1-1 = "("
              go to ba040-Clear-To-Next-Period.
*> dont have literals or numerics
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
     if       a > zero              *> reserved word
              go to ba040-Clear-To-Next-Period.
*>
*> if here must have user defined word (unless I have forgotten anything)
*>     no check for global  or  external
*>
     perform  zz030-Write-Sort.
     go       to ba040-Clear-To-Next-Period.
*>
 ba049-Exit.
     exit.
*>
 ba050-Get-User-Word.
*>
*> to here with nn ^ word but word could be pic/value etc ie no dataname
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsFoundWord2 (1:7) = "FILLER "
              move "FILLER" to Saved-Variable
              go to ba051-After-DataName.
     perform  zz130-Extra-Reserved-Word-Check thru zz130-Exit.
*>
*> Trap for no dataname, ie reserved word
*>   this [the 'if'] MUST be left in here
*>
     if       a not = zero
              move "FILLER" to Saved-Variable
              go to ba051-After-New-Word.
*>
*> not a reserved word AND a 88, looking for 01 - 49 [ or 77]
*>
     if       (Build-Number > 0 and < 50) or Build-Number = 77
              move wsFoundWord2 (1:CWS) to Saved-Variable.
*>
     if       Build-Number = 88
          and Con-Tab-Count not < Con-Tab-Size
              add 10 to    Con-Tab-Size.
     if       Con-Tab-Size > 5000
              move 5001 to Con-Tab-Size           *> just in case
              display Msg6
              go to ba050-Bypass-Add-2-Con-Table.
*>
*> add 88 dataname to constant table
*>
     if       Build-Number = 88
          and Con-Tab-Count < Con-Tab-Size
              add 1 to Con-Tab-Count
              if  Reports-In-Lower
                  move function lower-case (Saved-Variable) to  Variables (Con-Tab-Count)
                  move function lower-case (wsFoundWord2 (1:CWS)) to Conditions (Con-Tab-Count)
              else
                  move Saved-Variable to Variables (Con-Tab-Count)
                  move wsFoundWord2 (1:CWS) to Conditions (Con-Tab-Count)
              end-if
     end-if.
*>
 ba050-Bypass-Add-2-Con-Table.
*>
*> we dont have a reserved word! a = 0 = no
*>
      if      Global-Current-Level not = 99
              move Gen-RefNo1          to Global-Current-RefNo
              move wsFoundWord2 (1:32) to Global-Current-Word.
*>
      perform zz030-Write-Sort.
*>
 ba051-After-DataName.
     if       Word-Delimit = "."
          and Build-Number not = 66 and not = 77 and not = 78
          and Saved-Variable not = "FILLER"
          and (Global-Active or External-Active)
              perform zz200-Load-Git thru zz200-Exit.
     if       Word-Delimit = "."
              go to ba020-GetAWord.
     if       (Global-Active or External-Active)
          and Build-Number = 88
              perform zz200-Load-Git thru zz200-Exit
              perform ba040-Clear-To-Next-Period thru ba049-Exit
              go to ba020-GetAWord.
     perform  zz110-Get-A-Word thru zz110-Exit.
*>
 ba051-After-New-Word.
     if       wsFoundWord2 (1:10) = "REDEFINES " or
              wsFoundWord2 (1:8) = "RENAMES "
              perform zz110-Get-A-Word thru zz110-Exit
              perform zz030-Write-Sort
     else
      if      wsFoundWord2 (1:7) = "GLOBAL "
              move 1 to sw-Git
              perform zz200-Load-Git thru zz200-Exit
      else
       if     wsFoundWord2 (1:9) = "EXTERNAL "
              move 1 to sw-Git
                        SW-External
              perform zz200-Load-Git thru zz200-Exit
       else
       if     (Global-Active or External-Active)
          and Build-Number not = 66 and not = 77 and not = 78
          and Saved-Variable not = "FILLER"
              perform zz200-Load-Git thru zz200-Exit.
*>
     if       HoldWSorPD = 7 and
              (wsFoundWord2 (1:6) = "TO    " or "FROM  " or "USING ")
              perform zz110-Get-A-Word thru zz110-Exit
              inspect wsFoundWord2 tallying a for all "("
              if a not = zero
                 move wsFoundWord2 to wsFoundNewWord5
                 unstring wsFoundNewWord5 delimited by "(" into wsFoundWord2
              end-if
              perform zz030-Write-Sort
     end-if
*>
     perform  ba040-Clear-To-Next-Period thru ba049-Exit.
     go       to ba020-GetAWord.
*>
 ba052-After-Index.
*>
*> if Index found ignore 'by' if present
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsFoundWord2 (1:3) = "BY "
              go to ba052-After-Index.
*>
*> Should have index name and might be global / external
*>
     perform  zz030-Write-Sort.
     if       Global-Active or External-Active
              move wsFoundWord2 (1:32) to Global-Current-Word
              perform zz200-Load-Git thru zz200-Exit.
*>
 ba053-After-Depending.
*>
*> If depending found ignore 'on' if present, no global processing
*>
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       wsFoundWord2 (1:3) = "ON "
              go to ba053-After-Depending.
*>
*> Should have depending name
*>
     perform  zz030-Write-Sort.
*>
 ba000-Exit.
     exit.
*>
 bb000-Process-Procedure Section.
 bb010-New-Record.
*>
*> at this point we need to get a word but have PROCEDURE (as in DIVISION) as wsFoundWord2
*> but 1st, sort Global  table prior to running search(es) and I know it will happen for
*>  every module in src after 1st one
*>    this needs a rewrite as well as process a word etc is now a complete mess
*>
     if       Git-Table-Count > 1
              sort  Git-Elements ascending Git-Word.
*>
 bb020-GetAWord.
     perform  zz110-Get-A-Word thru zz110-Exit.
     if       End-Prog
              go to bb000-Exit.
     if       Source-Eof
              go to bb000-Exit.
     if       Word-Delimit = "."
         and  wsf1-1 = space
              go to bb020-GetAWord.
*>
 bb030-Chk1.
     if       wsFoundWord2 (1:1) alphabetic
              perform zz130-Extra-Reserved-Word-Check thru zz130-Exit
     else
              move zero to a.
*>
     if       a > zero
         and  wsFoundWord2 (1:5) = "CALL "
              perform zz110-Get-A-Word thru zz110-Exit
              if       wsFoundWord2 (1:1) = quote or = "'"
                       unstring wsFoundWord2 (2:30) delimited by quote or "'"
                             into wsFoundNewWord6
              else
                       move wsFoundWord2 to wsFoundNewWord6
              end-if
              move 5 to SkaWSorPD
              move wsFoundNewWord6 to SkaDataName
              if       Reports-In-Lower
                       move function lower-case (wsFoundWord2 (1:CWS)) to SkaDataName
              end-if
              move Gen-RefNo1 to SkaRefNo
              move 1 to USect (SkaWSorPD)                 *> Track for analysis - Needed?
              move HoldID-Module to SkaProgramName
              perform zz135-System-Check thru zz135-Exit  *> sets PD2 1 or 2
              if we-are-testing
                 display "After 'CALL' got " SkaDataName
                            " with PD2 = " SkaWSorPD2
              end-if
              if  SkaDataName not = spaces
                  write SortRecord
              end-if
     end-if.
*>
*> Do we have a reserved word? a = 0 means no or a number so ignore
*>
     if       a > zero
              go to bb020-GetAWord.
     if       wsf1-1-Number
              go to bb020-GetAWord.
     if       (wsf1-1 = "-" or = "+")
        and   wsFoundWord2 (2:1) numeric
              go to bb020-GetAWord.
     if       wsf1-1 = quote or = "'"
              go to bb020-GetAWord.
     if       (wsf1-1 = "X" or = "H")
        and   (wsFoundWord2 (2:1) = quote or = "'")
              go to bb020-GetAWord.
     if       wsf1-1 = ":"
        and   Word-Length = 1
              go to bb020-GetAWord.
     if       wsf1-1 = "("
              go to bb050-Check-SubScripts.
*>
 bb040-chk2.
*>
*> check for arithmetic operators
*>
     if       wsf1-3 = "-  " or = "+  " or = "*  " or = "/  " or = "** "
              go to bb020-GetAWord.
*>
*> check for relational Conditions
*>
     if       wsf1-2 = "> " or = "< " or = "= "
              go to bb020-GetAWord.
     if       wsf1-3 = ">= " or = "<= " or = "<> "
              go to bb020-GetAWord.
*>
*> we have a dataname and are we at word one with period delimiter
*> is it a paragraph?
*>
     move     2 to HoldWSorPD2.
     if       Word-Delimit = "."
          and Source-Words = 1
              move zero to HoldWSorPD2.
*>
*> Check if we have a section name if so set wdorpd2 = 1
*>
     string   wsFoundWord2 (1:Word-Length) delimited by size
              " SECTION" delimited by size
                   into HoldFoundWord.
     add      Word-Length 8 giving a.
     if       HoldWSorPD2 not = zero
         and  SourceInWS (1:a) = HoldFoundWord (1:a)
              move 1 to HoldWSorPD2.
     if       wsFoundWord2 (Word-Length:1) = ")"
              move space to wsFoundWord2 (Word-Length:1)
              if  Word-Length > 1
                  subtract 1 from Word-Length
              end-if
              go to bb030-Chk1
     end-if
     perform  zz030-Write-Sort.
     go       to bb020-GetAWord.
*>
 bb050-Check-SubScripts.
*>
*> arrives here with (xxxx) or any variation ie (((xxx etc
*>   xxx)))
*>
     move     spaces to wsFoundNewWord3.
     move     zero to a c d q y s s2 z2 z3.
     move     1 to s.                   *> Working Word start point
     move     Word-Length to z z2.      *> Working Word Length
 bb051-Clear-Left-Brace.
     if       z2 < 1                    *>  Should never happen but!
              go to bb020-GetAWord.
     if       wsFoundWord2 (s:1) = "("
              add      1 to s
              subtract 1 from z2
              go to bb051-clear-Left-brace.
*>
*> Now we have abcde))) or "abcd"))) or word:word)) or sim.
*>
 bb052-Clear-Right-Brace.
     if       z2 < 1                    *>  Should never happen but!
              go to bb020-GetAWord.     *>  ie empty braces
     if       wsFoundWord2 (z:1) = ")"
              move space to wsFoundWord2 (z:1)
              subtract 1 from z
              subtract 1 from z2
              subtract 1 from Word-Length
              go to bb052-Clear-Right-Brace.
*>
*> s  = left char pos         in wsFoundWord2
*> z  = right most char pos   in wsFoundWord2
*> z2 = current word length   in wsFoundWord2
*> WL = orig length minus No. of ')'
*>
 bb053-numerics.                        *> not interested in
     if       wsFoundWord2 (s:z2) numeric
              go to bb020-GetAWord.
     if       s < z
              subtract 1 from z2 giving z3
              add 1 s giving s2
              if  (wsFoundWord2 (s:1) = "+" or = "-")
               and wsFoundWord2 (s2:z3) numeric
                   go to bb020-GetAWord
              end-if
     end-if
*>
*> Next will clear word):xyz for later processing (bb100) 2014-11-05/14
*>
     inspect  wsFoundWord2 (s:z2) replacing all ")" by space.
*>
     inspect  wsFoundWord2 (s:z2) tallying a for all "(".
     inspect  wsFoundWord2 (s:z2) tallying a for all ")".
     if       a > zero                  *> should not have braces now
              display "bb053:Logic Error (A=" a " B=" b " Z2= " Z2 " on " wsFoundWord2 (1:80)
              go to bb020-GetAWord
     end-if
*>
     inspect  wsFoundWord2 (s:z2) tallying y for all quote.
     inspect  wsFoundWord2 (s:z2) tallying y for all "'".
*>
     if       y > zero                  *> quotes?
              move  zero to b      q t
              subtract 1 from s giving a
              go to bb060-Scan4-Quotes
     end-if
     inspect  wsFoundWord2 (s:z2) tallying c for all ":".
     if       c > zero                  *> a colon?
              move  zero to b q t
              go to bb100-scan4-colon.
*>
 bb054-spaces.
*>  left over from old code ??
     inspect  wsFoundWord2 (s:z2) tallying d for all space.
     if       d = zero
              move spaces to wsFoundNewWord
              if   z2 < 33
                   move wsFoundWord2 (s:z2) to wsFoundNewWord
              else
                   move wsFoundWord2 (s:32) to wsFoundNewWord
                   if we-are-testing
                      display "bb054:logic err?: " wsFoundWord2 (s:32)
                   end-if
              end-if
              move wsFoundNewWord to wsFoundWord2
              perform zz130-Extra-Reserved-Word-Check thru zz130-Exit
              if  a > zero              *> reserved word
                      go to bb020-GetAWord
              end-if
              perform zz030-Write-Sort
              go to bb020-GetAWord
     end-if
*> cockup trap
     display Msg7.
     display "bb054b: wsfw2=" wsFoundWord2 (1:64).
     go to bb020-GetAWord.
*>
 bb060-Scan4-Quotes.
*>
*> we are testing if more than 1 word present inc. a literal but it shouldnt
*>
     add      1 to a.        *>  q now a = field start,  s now b, z = rightmost char
     if       a not > z      *> check for end of data in field
        and   wsFoundWord2 (a:1) not = quote and not = "'"
              add 1 to b
              move wsFoundWord2 (a:1) to wsFoundNewWord3 (b:1)
              go to bb060-Scan4-Quotes.
*>
*> wsFoundNewWord3 = non quoted field so far
*>
 bb070-Got-Quote.        *> starts at 1st quote
     add      1 to a.
     add      1 to t.  *> t = literal length (no quotes)
     if       a > z                       *> Word-Length
              go to bb090-Recover-Word.
     if       wsFoundWord2 (a:1) not = quote and not = "'"
              go to bb070-Got-Quote.
     add      1 to a. *> a = next char after 2nd quote
     add      1 to t.
*>
*> t = quoted lit length including quotes
*>   and we are now at end quote + 1
 bb080-Quote-Clean.
     if       a > z                       *> Word-Length
              go to bb090-Recover-Word.
     if we-are-testing
         display "bb080: found 2nd word in scan=" wsFoundWord2
     end-if
     add      1 to b.
     move     wsFoundWord2 (a:1) to wsFoundNewWord3 (b:1).
     add      1 to a.
     go       to bb080-Quote-Clean.
*>
 bb090-Recover-Word.
*>
*> Word-Length and wsFoundWord2 less quoted field could be > 1 word in wsfnw3
*>
     subtract t from Word-Length.
     if       Word-Length < 1
              go to bb020-GetAWord.
     move     wsFoundNewWord3 (1:CWS) to wsFoundWord2 (1:CWS).
     go       to bb050-Check-SubScripts.
*>
 bb100-scan4-colon.
*>
*> now we can have num:num DataName:DN num:DN DN:num
*> z2 = current WL, s = leftmost char & z= rightmost char in wsFW2
*>
     move     spaces to wsFoundNewWord wsFoundNewWord2.
     move     1 to t.
     unstring wsFoundWord2 (s:z2) delimited by ":" into wsFoundNewWord count q pointer t.
*> t now : +1
     unstring wsFoundWord2 (s:z2) delimited by " " into wsFoundNewWord2 count b pointer t.
     if     t not > z2 or not = Word-Length
            display "bb100 Error: t=" t " word-len="
            Word-Length " z2=" z2.
*> this numeric test may not work?
     if       wsFoundNewWord (1:q) not numeric
         and  wsFoundNewWord (1:1) not = "-" and not = "+"
              move spaces to wsFoundWord2
              move wsFoundNewWord (1:q) to wsFoundWord2
              perform zz030-Write-Sort.
*> this numeric test may not work?
     if       b > zero
        and   wsFoundNewWord2 (1:b) not numeric
         and  wsFoundNewWord2 (1:1) not = "-" and not = "+"
              move spaces to wsFoundWord2
              move wsFoundNewWord2 (1:b) to wsFoundWord2
              perform zz030-Write-Sort.
     go       to bb020-GetAWord.
*>
 bb000-Exit.  exit.
*>
 bc000-Last-Act Section.
*>*********************
*>
*>  Report Phase
*>
     sort     SortFile
              ascending key SdSortKey
              using  Supplemental-Part1-Out
              giving Supplemental-Part2-In.
     if       Git-Table-Count > 1
              sort  Git-Elements ascending Git-Word.
*>
*> Print order:
*> Note that although some sections are not supported in GC they
*>       are, in cobxref.
*>   Xrefd -
*>     At bc090 = In order: File Section, Working-Storage, Local-Storage,
*>                 Linkage, Communication, Report, Screen
*>     At bc600 = Globals (in nested modules)
*>     At bc190 = Special-names & Conditions (& linked variables),
*>     At bc300 = Functions,
*>     At bc200 = Procedure Div,
*>     At bc400 = Unreferenced: File & WS,
*>     At bc500 = Unreferenced Procedure,
*>     At bc620 = Unreferenced Globals (throughout source)
*>     At bc700 = Called functions.
*>
     if       not All-Reports
              go to bc090-Last-Pass2.
*>
*>*************************************************************
*>    PROGRAMMING NOTE
*>
*>  Will use STORED-CHAR-LENGTH to check user names for size.
*>
*>
*> produce group W-S xref & procedure used in testing
*>  and taken from original code circa 1983.
*>  ------- Leave in just in case needed for testing ----
*>
 bc010-group-report.
     move     spaces to saveSkaDataName.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb8 thru zz150-Exit.
     move     zero to q.
     go       to bc030-IsX.
*>
 bc020-Read-Sorter.
     read     Supplemental-Part2-In at end
              perform bc050-Check-Q
              close Supplemental-Part2-In
              go to bc000-Exit.
*>              go to bc090-Last-Pass2.
*>
 bc030-IsX.
     if       SkaDataName = spaces
              go to bc020-Read-Sorter.
     perform  bc040-PrintXRef thru bc080-Exit.
     go       to bc020-Read-Sorter.
*>
 bc040-PrintXRef.
     if       SkaDataName = saveSkaDataName
              go to bc070-ConnectD.
     move     SkaDataName to saveSkaDataName.
*>
 bc050-Check-Q.
     if       XrDataName not = spaces
         and  q = zero
              move 1 to q.
     if       q > zero
              write PrintLine after 1
              add   1 to Line-Count
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb8 thru zz150-Exit
              end-if
              move zero to q
              move spaces to PrintLine.
*>
 bc060-ConnectC.
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move     SkaDataName to XrDataName-Long
              add      1 to Line-Count
              write    PrintLine-OverFlow after 1
              move     spaces to PrintLine
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
     move     LSect (SkaWSorPD) to XrType.
     go       to bc080-Exit.
*>
 bc070-ConnectD.
     if       q > 7
              perform bc050-Check-Q.
     add      1 to q.
     move     SkaRefNo to XrReference (q).
*>
 bc080-Exit.
     Exit.
*>
 bc090-Last-Pass2.
*>****************
*> printout W-S section blocks as needed
*> Check if any w-s used in module if not, do conditions, functions etc
*>
     move     70 to Line-Count.
     if       Section-Used-Table not = zeros
              move  1 to WS-Anal1
              perform bc100-Working-Storage-Report thru bc180-Exit 7 times.
*>
     if       Git-Table-Count > zero
              perform bc600-Print-Globals thru bc600-Exit.
     go       to bc190-Do-Conditions.
*>
 bc100-Working-Storage-Report.
*>****************************
*>  skip section if no data
*>
     if       USect (WS-Anal1) = zero
        or    WS-Anal1 = 5                   *> Omit Comms
              add 1 to WS-Anal1
              go to bc180-Exit.
*>
     move     spaces to saveSkaDataName.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb2 thru zz150-Exit.
     move     zero to q.
*>
*> group report
*>
     go       to bc120-IsX2.
*>
 bc110-Read-Sorter.
     read     Supplemental-Part2-In at end
              add 1 to WS-Anal1
              perform  bc140-Check-Q
              close Supplemental-Part2-In
              go to bc180-Exit.
*>
 bc120-IsX2.
     if       SkaDataName = spaces
              go to bc110-Read-Sorter.
     perform  bc130-PrintXRef2 thru bc170-Exit.
     go       to bc110-Read-Sorter.
*>
 bc130-PrintXRef2.
*>      test was 8
     if       SkaDataName = saveSkaDataName
              go to bc160-ConnectD2.
*>
     if       SkaWSorPD > WS-Anal1
              go to bc170-Exit.
     if       SkaWSorPD not = WS-Anal1
              go to bc170-Exit.
*>
*> new variable groups 1 thru 7
*>
     move     SkaDataName to saveSkaDataName.
     move     SkaWSorPD   to saveSkaWSorPD.
     move     SkaWSorPD2  to saveSkaWSorPD2.
*>
 bc140-Check-Q.
     if       XrDataName not = spaces
         and  q = zero
              move 1 to q.
     if       q > zero
              write PrintLine after 1
              add   1 to Line-Count
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb2 thru zz150-Exit
              end-if
              move zero to q
              move 1 to q2
              move spaces to PrintLine.
*>
 bc150-ConnectC2.
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move  SkaDataName to XrDataName-Long
              add   1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to PrintLine
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
     move     LSect (SkaWSorPD) to XrType.
     go       to bc170-Exit.
*>
 bc160-ConnectD2.
     if       q > 7
              perform bc140-Check-Q.
     add      1 to q.
     move     SkaRefNo to XrReference (q).
*>
 bc170-Exit.
     exit.
*>
 bc180-Exit.
     exit.
*>
 bc190-Do-Conditions.
*>
*> Start with sorted variables
*>
     if       Con-Tab-Count = zero
              go to bc195-Done.
     if       Con-Tab-Count > 1
              sort  Con-Tab-Blocks ascending Variables.
     move     "[S]" to hdr11a-sorted.
     move     spaces to hdr11b-sorted.
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb7 thru zz150-Exit.
     move     zero to a.
     perform  bc192-Print-Conditions.
     go       to bc194-Now-Reverse.
*>
 bc192-Print-Conditions.
     if       a < Con-Tab-Count
              add 1 to a
              move spaces to PrintLine2
              move  Conditions (a) to P-Variables
              move  Variables (a) to P-Conditions
              write PrintLine2 after 1
              add   1 to Line-Count
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb7 thru zz150-Exit
              end-if
              go to bc192-Print-Conditions.
*>
 bc194-Now-Reverse.
*>
*> Now sort conditions if more than 1 element in table
*>   and print else dont
*>
     if       Con-Tab-Count > 1
              sort  Con-Tab-Blocks ascending Conditions
              move     "[S]" to hdr11b-sorted
              move     spaces to hdr11a-sorted
              perform  zz150-WriteHdb thru zz150-Exit
              perform  zz150-WriteHdb7 thru zz150-Exit
              move     zero to a
              perform  bc192-Print-Conditions.
     move     spaces to PrintLine2.
*>
 bc195-Done.
     perform  bc300-Last-Pass4 thru bc399-Exit.
     perform  bc700-Do-Calls thru bc799-Exit.
*>
*> now pass3 (fall thru)
*>
 bc200-Last-Pass3.
*>****************
*> now do procedure div and ref to procedure div but no functions
*>
     move     spaces to saveSkaDataName.
     move     zero to saveSkaWSorPD saveSkaWSorPD2 q2.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     perform  zz150-WriteHdb thru zz150-Exit.
     move     "Procedure" to hdr8-hd
     perform  zz150-WriteHdb3 thru zz150-Exit.
     move     zero to q.
     go       to bc220-IsX3.
*>
 bc210-Read-Sorter3.
     read     Supplemental-Part2-In at end
              perform bc280-Check-Q
              close Supplemental-Part2-In
              if   q2 = zero
                   move spaces to PrintLine
                   move "None" to XrDataName
                   write PrintLine after 1
                   add   1 to Line-Count
              end-if
              go to bc400-Last-Pass5.
*>
 bc220-IsX3.
     if       SkaDataName = spaces
              go to bc210-Read-Sorter3.
     perform  bc230-PrintXRef3 thru bc270-Exit.
     go       to bc210-Read-Sorter3.
*>
 bc230-PrintXRef3.
*>
*> ignore all working-storage
*>
     if       SkaDataName not = saveSkaDataName
         and  SkaWSorPD not = 8
              move  SkaDataName to saveSkaDataName
              move  SkaWSorPD   to saveSkaWSorPD
              move  SkaWSorPD2  to saveSkaWSorPD2
              go to bc270-Exit.
*>
*> catch any redefines
*>
     if       SkaDataName = saveSkaDataName
         and  saveSkaWSorPD not = 8
              go to bc270-Exit.
*>
*> catch any procedure followed by functions
*>   dont think this can happen
*>
     if       SkaDataName = saveSkaDataName
         and  saveSkaWSorPD = 8
         and  SkaWSorPD > 8
              go to bc270-Exit.
*>
     if       SkaDataName = saveSkaDataName
              go to bc260-ConnectD3.
     move     SkaDataName to saveSkaDataName.
     move     SkaWSorPD   to saveSkaWSorPD.
     move     SkaWSorPD2  to saveSkaWSorPD2.
     perform  bc280-Check-Q.
*>
 bc250-ConnectC3.
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move SkaDataName to XrDataName-Long
              add  1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to Printline
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
*>
*> process sections
*>
     if       SkaWSorPD2 not = 1
              move LSect (SkaWSorPD) to XrType
     else
              move "S" to XrType.
     go       to bc270-Exit.
*>
 bc260-ConnectD3.
     if       q > 7
              perform bc280-Check-Q.
     add      1 to q.
     move     SkaRefNo to XrReference (q).
*>
 bc270-Exit.
     exit.
*>
 bc280-Check-Q.
     if       XrDataName not = spaces
         and  q = zero
              move 1 to q.
     if       q > zero
              write PrintLine after 1
              add   1 to Line-Count
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  move     "Procedure" to hdr8-hd
                  perform  zz150-WriteHdb3 thru zz150-Exit
              end-if
              move zero to q
              move 1 to q2
              move spaces to PrintLine.
*>
 bc300-Last-Pass4.
*>****************
*> now do Functions
*>
     if       USect (9) = zero
              go to bc399-Exit.
     move     spaces to saveSkaDataName.
     move     zero to saveSkaWSorPD saveSkaWSorPD2 q2.
     move     70 to Line-Count.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     move     zero to q.
     go       to bc320-IsX4.
*>
 bc310-Read-Sorter4.
     read     Supplemental-Part2-In at end
              perform bc335-Check-Q
              close Supplemental-Part2-In
              go to bc399-Exit.
*>
 bc320-IsX4.
     if       SkaDataName = spaces
              go to bc310-Read-Sorter4.
     perform  bc330-PrintXRef4 thru bc360-Exit.
     go       to bc310-Read-Sorter4.
*>
 bc330-PrintXRef4.
*>
*> ignore all working-storage & procedure
*>
     if       SkaWSorPD not = 9
              go to bc360-Exit.
*>
     if       Line-Count > Compiler-Line-Cnt
              move "Functions" to hdr8-hd
              move zero to Line-Count
              perform zz150-WriteHdb thru zz150-Exit
              perform zz150-WriteHdb3 thru zz150-Exit.
*>
     if       SkaDataName = saveSkaDataName
              go to bc350-ConnectD4.
     move     SkaDataName to saveSkaDataName.
*>
 bc335-Check-Q.
     if       XrDataName not = spaces
         and  q = zero
              move 1 to q.
     if       q > zero
              write PrintLine after 1
              add   1 to Line-Count
              move zero to q
              move 1 to q2
              move spaces to PrintLine.
*>
 bc340-ConnectC4.
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move SkaDataName to XrDataName-Long
              add  1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to Printline
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
     move     LSect (SkaWSorPD) to XrType.
     go       to bc360-Exit.
*>
 bc350-ConnectD4.
     if       q > 7
              perform bc335-Check-Q.
     add      1 to q.
     move     SkaRefNo to XrReference (q).
*>
 bc360-Exit.
     exit.
*>
 bc399-Exit.
     exit.
*>
 bc400-Last-Pass5.
*>****************
*> now do non referenced ws but ignore references of zero (Globals).
*>
     move     spaces to saveSkaDataName.
     move     zero to saveSkaWSorPD saveSkaWSorPD2 S-Pointer.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb4 thru zz150-Exit.
     move     zero to q.
     go       to bc420-IsX5.
*>
 bc410-Read-Sorter5.
     read     Supplemental-Part2-In at end
              perform bc440-Check-4Old
              close Supplemental-Part2-In
              if   S-Pointer = zero
                   move spaces to PrintLine
                   move "None" to XrDataName
                   add   1 to Line-Count
                   write PrintLine after 1
              end-if
              go to bc500-Last-Pass6.
*>
 bc420-IsX5.
*>
*> ignore zero refs = Globals  ??????????
*>
     if       SkaDataName = spaces
           or SkaRefNo = zeros
              go to bc410-Read-Sorter5.
     perform  bc430-PrintXRef5 thru bc450-Exit.
     go       to bc410-Read-Sorter5.
*>
 bc430-PrintXRef5.
*>
*> ignore redefines - No I wont
*>
*>     if       SkaDataName = saveSkaDataName
*>         and  SkaWSorPD < 8
*>              go to bc450-Exit.
     if       SkaDataName = saveSkaDataName
              move 2 to q
              go to bc450-Exit.
*> 1st copy of a name cant be non w-s
     if       SkaWSorPD > 7
              go to bc450-Exit.
*> print Only occurance then store new one
     perform  bc440-Check-4Old.
*>
     move     SkaDataName to saveSkaDataName.
*>
*> first record for a given name
*>
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move SkaDataName to XrDataName-Long
              add  1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to Printline
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
     move     LSect (SkaWSorPD) to XrType.
     move     1 to q.
     go       to bc450-Exit.
*>
 bc440-Check-4Old.
     if       q = 1
              move 1 to S-Pointer
              add   1 to Line-Count
              write PrintLine after 1
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb4 thru zz150-Exit
              end-if.
*>
 bc450-Exit.
     exit.
*>
 bc500-Last-Pass6.
*>****************
*> now do non referenced procedure paragraphs.
*>
     move     spaces to saveSkaDataName.
     move     zero to saveSkaWSorPD S-Pointer.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb5 thru zz150-Exit.
     move     zero to q.
     go       to bc520-IsX6.
*>
 bc510-Read-Sorter6.
     read     Supplemental-Part2-In at end
              perform bc540-Check-4Old
              perform bc540-Check-4Old6
              close Supplemental-Part2-In
              go to bc000-Exit.
*>
 bc520-IsX6.
     if       SkaDataName = spaces
              go to bc510-Read-Sorter6.
     perform  bc530-PrintXRef6 thru bc550-Exit.
     go       to bc510-Read-Sorter6.
*>
 bc530-PrintXRef6.
*>
*> ignore all non procedure
*>
     if       SkaDataName = saveSkaDataName
              move zero to q
              go to bc550-Exit.
*> print only occurance then store new one
     if       q = 1
        and   saveSkaWSorPD = 8
              move 1 to S-Pointer
              add   1 to Line-Count
              write PrintLine after 1
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb5 thru zz150-Exit
              end-if.
     move     SkaDataName to saveSkaDataName.
     move     SkaWSorPD to saveSkaWSorPD.
*>
*> first record for a given name
*>
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move SkaDataName to XrDataName-Long
              add  1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to Printline
     else
              move     SkaDataName to XrDataName.
     move     SkaRefNo to XrDefn.
     if       SkaWSorPD2 not = 1
              move LSect (SkaWSorPD) to XrType
     else
              move "S" to XrType.
     move     1 to q.
     go       to bc550-Exit.
*>
 bc540-Check-4Old.
     if       q = 1
          and saveSkaWSorPD = 8
              move 1 to S-Pointer
              add   1 to Line-Count
              write PrintLine after 1
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb5 thru zz150-Exit
              end-if.
*>
 bc540-Check-4Old6.
     if       S-Pointer = zero
              move spaces to PrintLine
              move "None" to XrDataName
              add   1 to Line-Count
              write PrintLine  after 1.
 bc550-Exit.
     exit.
*>
 bc600-Print-Globals.
*>*******************
*>  Print Global List for all xrefd modules & try to do Externals ONCE - 1st module.
*>
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb2b thru zz150-Exit.
     move     spaces to PrintLine.
     perform  varying a from 1 by 1 until a > Git-Table-Count
              move Git-RefNo (a)      to XrDefn
              move Git-HoldWSorPD (a) to b
              if Reports-In-Lower
                  move function lower-case (Git-Word (a))      to XrDataName
                  move function lower-case (Git-Prog-Name (a)) to PL-Prog-Name
              else
                  move Git-Word (a)      to XrDataName
                  move Git-Prog-Name (a) to PL-Prog-Name
              end-if
              if   XrDataName (1:3) = spaces   *> Only printed once
                   exit perform cycle
              end-if
              move LSect (b) to XrType
              if   Git-External (a) = space
                   move "G" to XrCond
              else
                   move "E" to XrCond
                   move spaces to Git-Word (a)  *> so its only done once
              end-if
              add   1 to Line-Count
              write PrintLine after 1
              if  Line-Count > Compiler-Line-Cnt
                  perform  zz150-WriteHdb thru zz150-Exit
                  perform  zz150-WriteHdb2b thru zz150-Exit
              end-if
     end-perform.
*>
 bc600-Exit.
     exit.
*>
 bc620-Do-Global-Conditions.
*>**************************
*> Produce report of unused Global Conditions if any but not sure it is valid !
*>
     if       Git-Table-Count = zero
              go to bc629-Exit.
*>
     perform  zz150-WriteHdb thru zz150-Exit.
     perform  zz150-WriteHdb6 thru zz150-Exit.
     move     zero to a b.
     perform  varying a from 1 by 1 until a > Git-Table-Count
              if    Git-In-Use-Flag (a) = space
                    move  spaces to PrintLine
                    move  Git-Word (a)  to XrDataName
                    move  git-RefNo (a) to XrDefn
                    move LSect (Git-HoldWsorPD (a)) to XrType
                    if  Git-Build-No (a) = 88
                        move "C" to XrCond
                    else
                        move space to XrCond
                    end-if
                    move 1 to b
                    add   1 to Line-Count
                    write PrintLine after 1
                    if  Line-Count > Compiler-Line-Cnt
                        perform  zz150-WriteHdb thru zz150-Exit
                        perform  zz150-WriteHdb6 thru zz150-Exit
                    end-if
              end-if
     end-perform
     if       b = zero
              move spaces to PrintLine
              move "None" to XrDataName
              add   1 to Line-Count
              write PrintLine after 1.
*>
 bc629-Exit.
     exit.
*>
 bc700-Do-Calls.
*>**************
*>
*>   Process all CALL "abcd" etc both system and user defined
*>
     if       USect (5) = zero
              go to bc799-Exit.
     move     spaces to saveSkaDataName.
     move     zero to saveSkaWSorPD saveSkaWSorPD2.
     move     70 to Line-Count.
     open     input Supplemental-Part2-In.
     read     Supplemental-Part2-In at end
              display Msg1
              go to bc000-Exit.
     move     zero to q.
     go       to bc720-IsX4.
*>
 bc710-Read-Sorter4.
     read     Supplemental-Part2-In at end
              perform bc735-Check-Q
              close Supplemental-Part2-In
              go to bc799-Exit.
*>
 bc720-IsX4.
     if       SkaDataName = spaces
              go to bc710-Read-Sorter4.
     perform  bc730-PrintXRef4 thru bc760-Exit.
     go       to bc710-Read-Sorter4.
*>
 bc730-PrintXRef4.
*>
*> ignore all other than 5 ( CALLS )
*>
     if       SkaWSorPD not = 5
              go to bc760-Exit.
*>
     if       Line-Count > Compiler-Line-Cnt
              move zero to Line-Count
              perform zz150-WriteHdb thru zz150-Exit
              perform zz150-WriteHdb9 thru zz150-Exit.
*>
     if       SkaDataName = saveSkaDataName
              go to bc750-ConnectD4.
     move     SkaDataName to saveSkaDataName.
*>
 bc735-Check-Q.
     if       PL4-Name not = spaces
         and  q = zero
              move 1 to q            *> data present so force print
     end-if
     if       q > zero
              write PrintLine after 1
              add   1 to Line-Count
              move zero to q
              move spaces to PrintLine.
*>
 bc740-ConnectC4.
     move     spaces to PrintLine.
     if       function Stored-Char-Length (SkaDataName) > 32
              move SkaDataName to XrDataName-Long
              add  1 to Line-Count
              write Printline-Overflow after 1
              move  spaces to Printline
     else
              move     SkaDataName   to PL4-Name.
     if       SkaWSorPD2 = 1
              move "SYSTEM" to PL4-Type.
     if       SkaWSorPD2 = 2
              move "USER  " to PL4-Type.
*>
 bc750-ConnectD4.
     if       q > 7
              perform bc735-Check-Q.
     add      1 to q.
     move     SkaRefNo to PL4-Reference (q).
*>
 bc760-Exit.
     exit.
*>
 bc799-Exit.  exit.
*>
 bc000-Exit.
     exit.
*>
 zz000-Routines Section.
 zz000-Inc-CobolRefNo.
     add      1 to Gen-RefNo1.
*>
 zz000-OutputSource.
     if       List-Source
              move  spaces to Source-List
              move  SourceRecIn to SourceOutput
              move  Gen-RefNo1 to sl-Gen-RefNo1
              add   1 to Line-Count
              write Source-List after 1
              if       Line-Count > Compiler-Line-Cnt
                       perform zz150-WriteHdb.
*>
 zz030-Write-Sort.
     move     HoldWSorPD to SkaWSorPD.
     move     HoldWSorPD2 to SkaWSorPD2.
     move     wsFoundWord2 (1:CWS) to wsFoundNewWord4.
     if       Reports-In-Lower
              move function lower-case (wsFoundWord2 (1:CWS)) to wsFoundNewWord4.
     if       HoldWSorPD > 7
              perform zz140-Function-Check thru zz140-Exit.
*>
*> stops dups on same fn and refno
*>move 9 to SkaWSorPD
     if       wsFoundNewWord4 not = SkaDataName
         or   Gen-RefNo1 not = SkaRefNo
              move wsFoundNewWord4 to SkaDataName
              move HoldID-Module to SkaProgramName
              move Gen-RefNo1 to SkaRefNo
              move 1 to USect (SkaWSorPD)
              if  SkaDataName not = spaces
                  write SortRecord
              end-if
              if   HoldWSorPD > 7  *> only do for proc div
                   perform zz220-Check-For-Globals thru zz229-Exit
              end-if
     end-if.
*>
 zz100-Get-A-Source-Record.
*>*************************
*> reads a source record, ignoring comments cleans out excessive
*>   spaces, ';', ',' etc
*>
     if       Had-End-Prog
              move zero to sw-Had-End-Prog
              go to zz100-New-Program-point.
     if       End-Prog
              go to zz100-Exit.
     if       Source-Eof
              display Msg8
              go to zz100-Exit.
*>
     move     spaces to SourceRecIn SourceInWS.
     read     SourceInput at end
              move 1 to sw-Source-Eof
              GO TO zz100-Exit.
     move     function upper-case (SourceRecIn) to SourceInWS.
*>
*>  New code to support FIXED format sources so do comment tests 1st
*>   then move cc8-72 to cc1 in record area for further processing.
*>
*> change tabs to spaces prior to printing & remove GC comment lines eg '#'
*>
     if       (SourceInWS (1:1) = "#" or = "$")
              go to zz100-Get-A-Source-Record.
*>
     if       SW-Fixed
        and   (SourceInWS (7:1) = "*" or = "/")
              perform zz000-Inc-CobolRefNo
              perform zz000-Outputsource
              go to zz100-Get-A-Source-Record.
*>
*> remove unwanted chars and all multi spaces so that unstrings
*>  can work easier Includes literals " " etc
*> Doesnt matter if literals get screwed up in this way
*>
     inspect  SourceInWS replacing all x"09" by space.
     inspect  SourceInWS replacing all ";" by space.
*>
*> This could cause a problem in ws so do in proc div
*>
     if       HoldWSorPD = 8           *> chk 4 comma
              inspect SourceInWS replacing all "," by space
     end-if
     inspect  SourceInWS replacing all "&" by space.
*>
*>  First test if we have a >>SOURCE line from cc8.
*>   then set sw-8 etc to fixed/free. MUST do before next
*>     test
*>
    move      zero to T2 T3.
    if        SourceInWS (8:9) = ">>SOURCE "
              inspect SourceInWS tallying T2 for all "FIXED"
              inspect SourceInWS tallying T3 for all "FREE"
              if      T2 > zero
                      set SW-8-InUse to true
                      Set SW-Fixed to true
              end-if
              if      T3 > zero
                      set SW-Free to true
                      set SW-8-InUse to true
              end-if
     end-if
*>
*> Now if src is fixed move left 7 chars via space filled intermediary store
*>   We WILL lose hyphen in cc7
*>
     if       SW-Fixed
              move SourceInWS (8:65) to SourceInWS2
              move spaces            to SourceInWS
              move SourceInWS2       to SourceInWS
     end-if
     perform  zz120-Replace-Multi-Spaces thru zz120-Exit.
     move     Line-End to Source-Line-End.
*>
*> Count but and O/P blank lines
*>
     if       d < 1
              perform zz000-Inc-CobolRefNo
              perform zz000-Outputsource
              go to zz100-Get-A-Source-Record
     end-if
*>
*> Will not process comment or CDF command (other than SOURCE earlier)
*>
     if       SourceInWS (1:2) = "*>" or = ">>"
              perform zz000-Inc-CobolRefNo
              perform zz000-Outputsource
              go to zz100-Get-A-Source-Record
     end-if
*>
*> Now clear out comment heads in id div but will take up a lot of cpu cycles!!
*>   so is it really NEEDED ??? - Only to match up with cobc.
*>
     if       SourceInWS (1:7)  = "AUTHOR."
           or SourceInWS (1:8)  = "REMARKS."
           or SourceInWS (1:9)  = "SECURITY."
           or SourceInWS (1:13) = "INSTALLATION."
           or                   = "DATE-WRITTEN."
           or SourceInWS (1:14) = "DATE-COMPILED."
              perform zz000-Inc-CobolRefNo
              perform zz000-Outputsource
              go to zz100-Get-A-Source-Record
     end-if
*>
*> Now clear trailing comments from src - cuts down get-a-word hits
*>   and matches cobc
*>
     perform  varying d from 1 by 1 until d > 250 or SourceInWS (d:2) = "*>"
     end-perform
     if       d > 1 and < 250
         and  SourceInWS (d:2) = "*>"
              subtract d from 256 giving d2
              add 1 to d2
              move spaces to SourceInWS (d:d2)
     end-if
*>
     if       Create-Compressed-Src
              write CopySourceRecIn2 from SourceInWS
     end-if
*>
     if       SourceInWS (1:12) = "END PROGRAM "
              perform zz000-Inc-CobolRefNo
              perform zz000-Outputsource
              go to zz100-Get-A-Source-Record
     end-if
*>
     if       HoldWSorPD > 7
        and   (SourceInWS (1:12) = "ID DIVISION."
         or    SourceInWS (1:20) = "IDENTIFICATION DIVIS")
              move 1 to sw-End-Prog sw-Had-End-Prog sw-Nested
              move 1 to S-Pointer2
              go to zz100-Exit
     end-if.
*>
 zz100-New-Program-point.
     perform  zz000-Inc-CobolRefNo.
     perform  zz000-Outputsource.
     move     1 to S-Pointer2.
     move     zero to Source-Words.
*>
*> == cobol85/NC/NC113M.CBL
*> Check if we have a section name or proc. 1st word name only
*> ie SECTION or DIVISION is on next line
*> but that cant happen if line-end > 15
*>
     if       Source-Line-End > 15
              move zero to HoldFoundWord2-Size
                           HoldFoundWord2-Type
              perform  zz170-Check-4-Section thru zz170-Exit
              go to zz100-Exit
     end-if
*>
*> now it could be the 1st word, 2nd word and . for line 2 or 3.
*> Got it? Good, now explain it to me !
*>
     if       HoldFoundWord2-Size = zero
              perform  varying d from 1 by 1 until d > 8
               if Sht-Section-Name (d) = SourceInWS (1:Source-Line-End)
                 move Spaces               to HoldFoundWord2
                 move Sht-Section-Name (d) to HoldFoundWord2
                 add 1 Source-Line-End giving HoldFoundWord2-Size
                 go to zz100-Get-A-Source-Record
               end-if
              end-perform
     else
            if   HoldFoundWord2-Type > zero
             and (SourceInWS (1:7) = "SECTION" or = "DIVISIO")
                 add 1 HoldFoundWord2-Size giving d
                 string SourceInWS (1:Line-End) delimited by size into HoldFoundWord2  pointer d
                 move HoldFoundWord2 to SourceInWS
                 move zero to HoldFoundWord2-Size
            end-if
     end-if.
*>
*> Ignoring fact if period missing, ASSUMING get-a-word covers it
*>   Here I go, Ass-uming again
*>
*> need this here
     perform  zz170-Check-4-Section thru zz170-Exit.
*>
 zz100-Exit.
     exit.
*>
 zz110-Get-A-Word.
*>****************
*>  S-Pointer2 must be set to => 1 prior to call
*> pointer is a tally of init leading spaces
*>
     if       Source-Eof
          or  End-Prog
              go to zz110-Exit.
     if       S-Pointer2 not < Source-Line-End
         and  SourceInWS (S-Pointer2:1) = "."
              move "." to Word-Delimit
              move zero to Word-Length
              move space to SourceInWS (S-Pointer2:1)
              move spaces to wsFoundWord2
              go to zz110-Exit
     end-if
*>     if       S-Pointer2 < Source-Line-End
*>              inspect SourceInWS tallying S-Pointer2 for leading spaces.
*>
     if       S-Pointer2 > Source-Line-End
          or  S-Pointer2 > 256       *> Was 1024
              go to zz110-Get-A-Word-OverFlow
     end-if.
*>
*> S-Pointer2 = 1st non space
*>
 zz110-Get-A-Word-Unstring.
     move     spaces to wsFoundWord2.
     move     S-Pointer2 to s.
*>*****************************************************************
*> Note that after unstring sp2 will be at 1st char AFTER delimiter
*>*****************************************************************
     unstring SourceInWS delimited by " " or "." into wsFoundWord2
               delimiter Word-Delimit pointer S-Pointer2.
*> check 1st char
     if       S-Pointer2 > 255       *> was 1024
              go to zz110-Get-A-Word-OverFlow.
     if       wsf1-1 = space
         and  SourceInWS (S-Pointer2:1) = "."
              move "." to Word-Delimit
              move zero to Word-Length
              move spaces to wsFoundWord2
              go to zz110-Exit.
     if       wsf1-1 = space
              go to zz110-Get-A-Word-Unstring.
     if       wsf1-3 = ">>D"                      *> if debug continue ignoring ">>D"
              go to zz110-Get-A-Word-Unstring.
     if       wsf1-2 = ">>"                       *> Ignore rest of CDF line
              go to zz110-Get-A-Word-OverFlow.    *> as next WORD/s not in reserved lists
     if       wsf1-2 = "*>"                       *> rest of line is comment so ignore
              go to zz110-Get-A-Word-OverFlow.
     if       (wsf1-1-Number
           or wsf1-1 = "-"
           or wsf1-1 = "+")
         and  SourceInWS (S-Pointer2:1) not = space
              move s to S-Pointer2
              unstring SourceInWS delimited by " " into wsFoundWord2
                         delimiter Word-Delimit pointer S-Pointer2.
*>
     subtract 2 from S-Pointer2 giving e.
     if       Word-Delimit = space
         and  SourceInWS (e:1) = "."
              move "." to Word-Delimit.
*>
     if       GotPicture = 1
          and SourceInWS (s:3) not = "IS "
*> this next test may not be needed ????
*>**************        and   Word-Delimit = "."
        and   (SourceInWS (s:1) = "$" or = Currency-Sign
                             or = "/" or = "B" or = "0" or = "."
                             or = "," or = "+" or = "-" or = "C"
                             or = "D" or = "*" or = "Z" or = "9"
                             or = "X" or = "A" or = "S" or = "V"
                             or = "P" or = "1" or = "N" or = "E")
              move s to S-Pointer2
              unstring SourceInWS delimited by " " into wsFoundWord2 delimiter Word-Delimit pointer S-Pointer2
              end-unstring
              subtract 2 from S-Pointer2 giving e
              if  SourceInWS (e:1) = "."
                   move "." to Word-Delimit
              end-if
              move 1 to WasPicture
     end-if
*>
*> This could cause a problem ??????
*>
     if       GotPicture = zero
              inspect  wsFoundWord2 replacing all "," by space
     end-if
*>
     if       wsf1-1 = "("
         and (wsFoundWord2 (2:1) = quote or = "'")
              add 2 to s giving S-Pointer2
              move wsFoundWord2 (2:1) to wsFoundWord2 (1:1) Word-Delimit2
              go to zz110-Get-A-Word-Literal2.
*>
     if       wsf1-1 = "("
         and  wsFoundWord2 (2:1) = space
              add 1 to S-Pointer2
              go to zz110-Get-A-Word.
     if       wsf1-1 = ")"
              go to zz110-Get-A-Word.
*>
*> Support for X"abc" etc where X = H,X,Z etc
*>
     if       (wsf1-1 = "H" or "X" or "Z")
         and  (wsf2-1 = quote or = "'")
              add 2 to s giving S-Pointer2
              move wsFoundWord2 (2:1) to wsFoundWord2 (1:1) Word-Delimit2
              go to zz110-Get-A-Word-Literal2.
*>
     if       (wsf1-1 not = quote and not = "'")
        and   (wsf2-1 not = quote and not = "'")
              perform  varying z from 256 by -1  until wsFoundWord2 (z:1) not = space
                                                 or z < 2
              end-perform
              move z to Word-Length
              go to zz110-Get-A-Word-Copy-Check
     end-if.
*>
 zz110-Get-A-Word-Literal.
     if       wsf1-1 = quote or = "'"
              move     wsf1-1 to Word-Delimit2
              add      1 to s giving S-Pointer2.
*>
 zz110-Get-A-Word-Literal2.
     move     spaces to wsFoundWord2 (2:255).   *> was 1023
     unstring SourceInWS delimited by Word-Delimit2
               into wsFoundWord2 (2:255)
                    delimiter Word-Delimit
                    pointer   S-Pointer2.       *> was 1023
*>
*> so S-Pointer2 = " +1 & s = starter "   have we another Word-Delimit?
*>
     if       Word-Delimit not = Word-Delimit2
              perform  varying z from 256 by -1 until wsFoundWord2 (z:1) not = space  *> was 1024
                                                 or z < 2
              end-perform
              add 1 to z
     else
              subtract s from S-Pointer2 giving z.
     move     Word-Delimit2 to wsFoundWord2 (z:1).
     move     z to Word-Length.
*>
*>  word is quoted literal or word so we are done
*>
     go       to zz110-Get-A-Word-Copy-Check.
*>
 zz110-Get-A-Word-OverFlow.
     move     1 to S-Pointer2.
     perform  zz100-Get-A-Source-Record thru zz100-Exit.
     if       Source-Eof
              go to zz110-Exit.
     go       to zz110-Get-A-Word.
*>
 zz110-Get-A-Word-Copy-Check.
*>
     add      1 to Source-Words.
     if we-are-testing
       and word-length > zero
        display "zz110: WD=" word-delimit
                " WSF2=" wsfoundword2 (1:word-length).
     if       Word-Length < 1
              display "zz110-GAWCH: Oops, zero length word"
                " WSF2=" wsfoundword2 (1:20)
              display " Report this to support".
*>
*> if the leading char check when delim is period dont work
*>   then this will be tested higher up in code !
*>
     if       wsFoundWord2 (1:3) not = "IS "
          and GotPicture = 1
              move zero to GotPicture.
*>
     if       wsFoundWord2 (1:4) = "PIC "
           or wsFoundWord2 (1:8) = "PICTURE "
              move 1 to GotPicture.
 zz110-Exit.
     exit.
*>
 zz120-Replace-Multi-Spaces.
*>**************************
*> remove any multi spaces within a source line
*>   find actual length of record in d
*>
*> run profiler against these routines and tidy them up if needed
*>
     perform  varying d from 256 by -1 until SourceInWS (d:1) not = space
                                       or d < 2
     end-perform
     if       d < 1                   *> Blank line found
              go to zz120-Exit.
*>
     move     zero to a b c.
     move     spaces to wsFoundNewWord5.
     perform  zz120-Kill-Space thru zz120-Kill-Space-Exit.
     move     spaces to SourceInWS.
     move     wsFoundNewWord5 (1:b) to SourceInWS.
     move     b to Line-End d.
     if we-are-testing
        display "zz120A b=" b " after=" SourceInWS (1:b).
     go       to zz120-Exit.
*>
 zz120-Kill-Space.
     add      1 to a.
     if       a > d
              go to zz120-Kill-Space-Exit.
     if       SourceInWS (a:1) = space and c = 1
              add 1 to b
              move zero to c
              go to zz120-Kill-Space.
*>
     if       SourceInWS (a:1) = space
              go to zz120-Kill-Space.
     subtract 1 from a giving e.         *> a will always be 2 or more here
     if       SourceInWS (a:1) = "("
         and  SourceInWS (e:1) not = space
         and  HoldWSorPD > 7
              add 2 to b
     else
              add 1 to b.
     move     SourceInWS (a:1) to wsFoundNewWord5 (b:1).
     move     1 to c.
     go       to zz120-Kill-Space.
*>
 zz120-Kill-Space-Exit.
     exit.
*>
 zz120-Exit.
     exit.
*>
 zz130-Extra-Reserved-Word-Check.
*>*******************************
*>  Check for any other reserved words not in other checks
*>  note that max reserved word is 30 characters, so compare like 4 like
*>
     move     zero to a.
     search   all Reserved-Names at end go to zz130-exit
              when Resvd-Word (Resvd-Idx) = wsFoundWord2 (1:30)
                    set a to Resvd-Idx.
     if       a not = zero
        and   wsFoundWord2 (1:8) = "FUNCTION" or = "function"
              move 1 to FoundFunction
     else
              move zero to FoundFunction.
*>
 zz130-Exit.
     exit.
*>
 zz135-System-Check.
*>*****************
*> CALLS:  Only after moving all values to SortRecord and before write verb.
*>
*> Do we have an System (call) name or a user one?
*>           if so modify sort rec for section printing
*>
     move     zero to S-Pointer3.
     move     2 to SkaWSorPD2.
     search   all All-Systems  at end  go to zz135-exit
              when P-System (All-System-Idx) = function upper-case (SkaDataName)
                  move 1 to SkaWSorPD2
                  set S-Pointer3 to All-System-Idx.
*>
 zz135-Exit.
     exit.
*>
 zz140-Function-Check.
*>********************
*> CALLS:  Only after moving all values to SortRecord and before write verb.
*>
*> Do we have an intrinsic function name
*>           if so modify sort rec for section printing
*> Note that P-oc-implemented = zero if not implemented,
*>    but treated as the same as its still a reserved word
*>
     move     zero to F-Pointer.
     search   all All-Functions  at end go to zz140-exit
              when P-function (All-Fun-Idx) = function upper-case (wsFoundNewWord4)
                  move 9 to SkaWSorPD
                  move 1 to SkaWSorPD2
                  set F-Pointer to All-Fun-Idx.
*>
 zz140-Exit.
     exit.
*>
*>   Heading and sub heading routines.
*>
 zz150-WriteHdb.
*> Have a blank line for users reading the listing file avoiding the ugly header placement.
     move     spaces to PrintLine.
     if       Page-No not = zero
              write PrintLine after 1
     end-if
*>
     move     spaces to h1programid.
     accept   hddate from date YYYYMMDD.     *> 1.01.21
*>
*>  Here we adjust date format for country but is Windoz playing nice
*>   i.e., compatible with *nix?  Soon find out from users.
*>
     if       hddate not = "00000000"
              perform  zz240-Convert-Date thru zz240-Exit.
     accept   hdtime from time.
     if       hdtime not = "00000000"
              move hd-hh to hd2-hh
              move hd-mm to hd2-mm
              move hd-ss to hd2-ss
              move hd-uu to hd2-uu.
     if       HoldID = HoldID-Module
              string   HoldID delimited by space
                       "    " delimited by size
                       hd-date-time delimited by size into h1programid
     else
              string   HoldID delimited by space
                       " (" delimited by size
                       HoldID-Module delimited by space
                       ") "  delimited by size
                       hd-date-time delimited by size into h1programid
     end-if
     add      1 to Page-No.
     move     Page-No to H1-Page.
     if       Page-No = 1
              write PrintLine from hdr1 after 1
     else
              write PrintLine from hdr1 after page
     end-if
     move     spaces to PrintLine.
     write    PrintLine after 1.
     move     2 to Line-count.
*>
 zz150-WriteHdb1.
     move     spaces to Hdr5-Prog-Name.
     string   HoldID delimited by space
              " (" delimited by size
              HoldID-Module delimited by space
              ")"  delimited by size
              into Hdr5-Prog-Name.
     move     Hdr5-Prog-Name to Hdr6-Hyphens.
     inspect  hdr6-hyphens replacing characters by "-"
              before initial "  ".
     write    PrintLine from hdr5-symbols.
     write    PrintLine from hdr6-symbols.
     add      2 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb2.
     move     spaces to PrintLine.
     write    PrintLine.
     move     spaces to hdr7-variable.
     string   Full-Section-Name (WS-Anal1) delimited space
                                       ")" delimited by size into hdr7-variable.
     write    PrintLine from hdr7-ws.
     write    PrintLine from hdr3.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      3 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb2b.
     move     spaces to PrintLine.
     write    PrintLine.
     move    "ALL GLOBALS)" to hdr7-variable.
     write    PrintLine from hdr7-ws.
     write    PrintLine from hdr3.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      3 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb2c.           *> Not used yet.
     move     spaces to PrintLine.
     write    PrintLine.
     move    "ALL EXTERNALS)" to hdr7-variable.
     write    PrintLine from hdr7-ws.
     write    PrintLine from hdr3.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      3 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb3.
     write    PrintLine from hdr8-ws.
     write    PrintLine from hdr3.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      2 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb4.
     write    PrintLine from hdr9.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      1 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb5.
     write    PrintLine from hdr10.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      1 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb6.
     write    PrintLine from hdr9B.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      1 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb7.
     write    PrintLine from hdr11.
     write    PrintLine from hdr12-hyphens.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      2 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb8.
     write    PrintLine from hdr2.
     write    PrintLine from hdr3.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      2 to Line-Count
     go       to zz150-Exit.
*>
 zz150-WriteHdb9.
     write    PrintLine from hdr13.
     write    Printline from hdr4.
     move     spaces to PrintLine.
 *>    write    PrintLine.
     add      2 to Line-Count.
     go       to zz150-Exit.
*>
 zz150-Exit.
     exit.
*>
 zz160-Clean-Number.
      move    zero to Build-Number.
      if      Word-Length = 1
              move wsf3-1 to Build-Number
              go to zz160-Exit.
      if      Word-Length = 2
              compute Build-Number = (wsf3-1 * 10) + wsf3-2.
*>
 zz160-Exit.
     exit.
*>
 zz170-Check-4-Section.
     move     space to GotASection.
     if       HoldWSorPD = 8
              go to zz170-Exit.
*>
     perform  varying a2 from 1 by 1 until a2 > 8
              if sv1What = Section-Name (a2)
                  move a2 to HoldWSorPD
                  move "Y" to GotASection
       if We-Are-Testing display "Found zz170 " sv1What  end-if
                  if a2 = 8
                      move zero to HoldWSorPD2
                  end-if
                  exit perform
              end-if
     end-perform
*>
*> Changed section so we can clear Global flag
*>
     if       GotASection = "Y"
              move zero to sw-Git
                           SW-External
     end-if.
*>
 zz170-Exit.
     exit.
*>
 zz180-Open-Source-File.
*>*********************
*> get source filename
*>
     accept   Arg-Number from argument-number.
     if       Arg-Number > zero
              move zero to String-Pointer
              perform zz180-Get-Program-Args Arg-Number times
     else     go to zz180-Check-For-Param-Errors.
*>
*> setup source filename
*>    dont need the pointers - kill it after next test
     move     1 to String-Pointer.
     unstring Arg-Value (1) delimited by spaces into SourceFileName pointer String-Pointer.
*>
*> Now get temp environment variable & build temp sort file names
*>
     perform  zz182-Get-Env-Set-TempFiles thru zz182-Exit.
*>
 zz180-Check-For-Param-Errors.
     if       SourceFileName = spaces or
              String-Pointer < 5
              display Prog-Name
              move function current-date to WS-When-Compiled
              display "Copyright (c) 1967-" no advancing
              display WS-WC-YY no advancing
              display " Vincent Bryan Coen"
              display " "
              display "Parameters are"
              display " "
              display " 1: Source File name (Mandatory)"
              display " 2: -FREE  Source format otherwise it is set to FIXED"
              display " 3: -R     Do NOT print out source code prior to xref listings"
              display " 4: -L     Reports in lowercase otherwise in upper"
              display " 5: -DR    Display All reserved words & stop"
              display " 6: -VT    Do not display messages when updating any reserved word tables"
              display " 7: -E     Create compressed source file (same as cobc -E)"
              display " 8: -AX    Produce Xrefs at end of all program listings"
              display "           Not yet implemented - Depends on requests for it"
              display " 9: -G     Produce only group xref: Comp. MF"
              display "10: -TEST  Produces testing info (for programmers use only)"
              display "           also produces free format src in source filename.src"
              display "11: -V     Verbose output - for testing only"
              display "12: -H     Display this help message"
              display "   --H     as -H"
              move zero to return-code
              goback.
*>
     move     1 to String-Pointer String-Pointer2.
     perform  varying a from 128 by -1 until Sourcefilename (a:1) not = space
     end-perform
     move     a to b.
  *>
     perform  varying b from b by -1 until b < 2 or SourceFileName (b:1) = "."
     end-perform
     if       b not < 2
              subtract 1 from b
              move SourceFileName (1:b) to Prog-BaseName
              add 1 to b
     end-if

*>     unstring Arg-Value (1) delimited by "." into Prog-BaseName
*>              with pointer String-Pointer.
*>
     if       Prog-BaseName = SourceFileName
              string  Prog-BaseName  delimited by space
              ".pre"        delimited by size into SourceFileName.
*>
     string   Prog-BaseName delimited by space
              ".lst"        delimited by size into Print-FileName
              with pointer String-Pointer2.
*>
*> Can now convert to upper-case as source filename is processed
*>
     move     function upper-case (Arg-Vals) to Arg-Vals.
*>
*> Check if help requested
*>
     if       "-H" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4)
              move zero to String-Pointer
              go to zz180-Check-For-Param-Errors.
     if       "--H" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4)
              move zero to String-Pointer
              go to zz180-Check-For-Param-Errors.
*>
*> Check v4 if we are dumping all reserved words then quitting
*>
     if       "-DR" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move 1 to sw-4
              go to zz180-Exit.
*>
*> Check v2 if we are NOT listing the source
*>
     if      "-R" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "N" to sw-2.
*>
*> Check if we are producing compressed src
*>
     if      "-E" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "Y" to sw-3.
*>
*> Check v5 if we are testing
*>
     if       "-TEST" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              display " extra information for testing"
              move "Y" to sw-5.
*>
*> Check v6 if we are are doing Lower case reports insted of upper
*>
     if       "-L" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move 1 to sw-6.
*>
*> Check if xrefs all at end of source listings  -  NOT YET IMPLEMENTED
*>
     if      "-AX" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "Y" to sw-7.
*>
*> Check v8 if we are using free source format (default is fixed)
*>    if found then sw-8-inuse will be (sw-8-usd) true
*>
     if       "-FREE" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "Y" to sw-8
                          sw-8-usd.
*>
*> Check if displays for updating reserved word tables are not wanted.
*>
     if       "-VT" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "Y" to sw-9.
*>
*> Check v11 if verbose output required
*>
     if       "-V" = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "Y" to sw-11.
*>
     if       Verbose-Output
              display  "Using input = " SourceFileName
              display  "  list file = " Print-FileName.
*>
*>***************************************************************
*>  THIS BLOCK FOR TESING and Comparing listing against MF etc  *
*>***************************************************************
*>
*> Check v1 if we are are only doing a group xref ie W-S and procedure
*>
     if       "-G " = Arg-Value (2) or Arg-Value (3)
           or Arg-Value (4) or Arg-Value (5) or Arg-Value (6)
           or Arg-Value (7) or Arg-Value (8) or Arg-Value (9)
           or Arg-Value (10) or Arg-Value (11)
              move "A" to sw-1.
*>
*>***************************************************************
*>    END OF SPECIAL TEST BLOCK but with bc030 - bc080 also     *
*>***************************************************************
*>
*>  Set WS-Locale-Time-Zone from LC_TIME - Default [3] to Intl (ccyymmdd)
*>
     accept   WS-Locale from Environment "LC_TIME" on exception
              move    3 to WS-Local-Time-Zone.
     if       WS-Locale (1:5) = "en_GB"
              move    1 to WS-Local-Time-Zone
     else
      if      WS-Locale (1:5) = "en_US"
              move    2 to WS-Local-Time-Zone.   *> others before the period
*>
     if       not Verbose-Output
              go to zz180-Test.
*>
     if       sw-Free                      *>  = "Y"
              display " Free Format source"
      else
              display " Fixed Format source".
     if       Reports-In-Lower
              display " Reports in Lower Case"
      else
              display " Reports in Upper Case".
*>
 zz180-Test.
*>
*> Now to process and call printcbl
*>
     move     SourceFileName to LS-Source-File.
     move     Prog-BaseName  to LS-Prog-BaseName.     *> o/p = prog-basename + ".pro"
     move     sw-8           to LS-Prog-Format.
     move     sw-11          to LS-SW-11.
*>
     call     "printcbl" using LS-Source-File
                               LS-Prog-BaseName
                               LS-Prog-Format
                               LS-SW-11
                               return-code.
*>
*>=================================================================================
*> CAN adjust call params & chg printcbl to return o/p name in LS-Source-File
*>=================================================================================
*>
     if       return-code > 31              *> Issue with i/p file in printcbl (Msg26) EOJ
              goback.
     string   Prog-BaseName delimited by space
              ".pro"        delimited by size
                     into SourceFileName.         *> created by printcbl with copybooks.
*>
*> RETAIN i/p source FILE but will need to be deleted when testing complete.
*>
     open     input SourceInput.
     if       FS-Reply not = zero
              display Msg9
              move 16 to return-code
              goback.
     go       to zz180-Exit.
*>
 zz180-Get-Program-Args.
     add      1 to String-Pointer.
     accept   Arg-Value (String-Pointer) from argument-value.
*>
 zz182-Get-Env-Set-TempFiles.
*>**************************
     accept   Temp-PathName from Environment "TMPDIR".
     if       Temp-PathName = spaces
              accept Temp-PathName from Environment "TMP"
              if  Temp-PathName = spaces
                  accept Temp-PathName from Environment "TEMP"
                  if  Temp-PathName = spaces
                      move "/tmp" to Temp-PathName.
     if       Temp-PathName (1:1) = "/"   *> Its Linux/Unix
              move "/" to OS-Delimiter.
     if       Temp-PathName (1:1) = "\"   *> Its Windoz *> "
              inspect Temp-PathName replacing all "/" by "\"   *> in case of /tmp "
              move "\" to OS-Delimiter.  *> "
     string   Temp-PathName delimited by space
               OS-Delimiter delimited by size
                "Part1.tmp" delimited by size   into Supp-File-1.
     string   Temp-PathName delimited by space
               OS-Delimiter delimited by size
                "Part2.tmp" delimited by size   into Supp-File-2.
     string   Temp-PathName delimited by space
               OS-Delimiter delimited by size
                 "Sort1tmp" delimited by size   into Sort1tmp.
     if we-are-testing
           display  "Temp path used is " Temp-PathName.
*>
 zz182-Exit.
     Exit.
*>
 zz180-Exit.
     exit.
*>
 zz190-Init-Program.
*>
*>****************************************************************
*> initialise all Variables should we be processing nested modules
*>****************************************************************
*>
     move     spaces to PrintLine Global-Current-Word SortRecord
              saveSkaDataName SourceFileName Print-FileName
              wsFoundNewWord4 wsFoundNewWord3
              wsFoundNewWord2 wsFoundNewWord.
     move     high-values to Condition-Table.
     move     10 to Con-Tab-Size.
     move     zeros to GotEndProgram sw-Source-Eof Section-Used-Table
              HoldWSorPD HoldWSorPD2 Con-Tab-Count.
     move     1 to S-Pointer F-Pointer S-Pointer2.
*>
 zz190-Exit.
     exit.
*>
 zz200-Load-Git.
*>
*> Load the Global Item Table with item associated with 01/FD Global
*>
     if       Global-Current-Level = 99
              go to zz200-Exit.
     add      1 to Git-Table-Count.
     if       Git-Table-Count > Git-Table-Size
         and  Git-Table-Size < 10000
              add 10 to Git-Table-Size.
     if       Git-Table-Size > 10000
              move 10001 to Git-Table-Size        *> just in case
              display Msg10
              go to zz200-Exit.
     move     Global-Current-Word  to Git-Word (Git-Table-Count).
     move     space                to Git-In-Use-Flag (Git-Table-Count)
     move     Global-Current-RefNo to Git-RefNo (Git-Table-Count).
     move     Build-Number         to Git-Build-No (Git-Table-Count).
     move     HoldID               to Git-Prog-Name (Git-Table-Count).
     move     HoldWSorPD           to Git-HoldWSorPD (Git-Table-Count).
     move     HoldWSorPD2          to Git-HoldWSorPD2 (Git-Table-Count).
     if       SW-Found-External = 1
              move "Y"             to Git-External (Git-Table-Count)
     else
              move space           to Git-External (Git-Table-Count).
     move     zero  to SW-Found-External.
*>
 zz200-Exit.
     exit.
*>
 zz220-Check-For-Globals.
*>**********************
     move zero to a1.
     perform  varying a1 from 1 by 1 until a1 > Git-Table-Count
              if  Git-Word (a1) = wsFoundNewWord4
                  move "1" to Git-In-Use-Flag (a1)
                  exit perform
              end-if
     end-perform.
*>
 zz229-Exit.
     exit.
*>
 zz240-Convert-Date.
*>*****************
*>
*>  Converts date from Accept DATE YYYYMMDD to UK/USA/Intl date format
*>****************************************************
*> Input:   HDDate
*> output:  HD2-Date  as UK/US/Intl date format or more as required.
*>
     if       WS-Local-Time-Zone = zero or > 3
              move 3 to WS-Local-Time-Zone.   *> Intl - ccyy/mm/dd - force if not set but it should be.
*>
     if       LTZ-UK
              move "dd/mm/ccyy" to HD2-date
              move HD-C to HD2-C
              move hd-y to hd2-y
              move hd-m to hd2-m
              move hd-d to hd2-d
     else
      if      LTZ-USA                *> swap month and days
              move "mm/dd/ccyy" to HD2-date
              move hd-m to hd2-Date (1:2)
              move hd-d to hd2-Date (4:2)
              move HD-C to HD2-C
              move hd-y to hd2-y
      else
*>
*> So its International date format
*>
       if     LTZ-Unix
              move "ccyy/mm/dd" to HD2-Date
              move HD-C  to HD2-Date (1:2)
              move HD-Y  to HD2-Date (3:2)
              move HD-M  to HD2-Date (6:2)
              move HD-D  to HD2-Date (9:2).
*>
 zz240-Exit.
     exit.
*>
*> End of cobxref source
*>
 Identification division.
*>**********************
 program-id.            get-reserved-lists.
*>**
 Author.                Vincent Bryan Coen, Applewood Computers, FBCS.
*>                      Stag Green Avenue, Hatfield, Hertfordshire, UK.
*>**
*>    Date-Written.     26 September 2010.
*>**
*>    Security.         Copyright (C) 2010- forever, Vincent Bryan Coen.
*>                      Distributed under the GNU General Public License
*>                      v2.0. Only. See the file COPYING for details but
*>                      for use within GnuCOBOL ONLY.
*>**
*>    Usage.            Get the reserved word lists from GnuCOBOL
*>                      cobc, from v2.n, v3 for Intrinsic, reserved words
*>                      and system functions.
*>                      Note that Mnemonics - devices, features and switch names
*>                      are NOT obtained so that they can appear in xref listings.
*>                     Updated (03/02/2019) to also give System functions.
*>**
*>    Called by.
*>                      cobxref
*>**
*>    Calls.
*>                      cobc
*>                      CBL_DELETE_FILE
*>                      SYSTEM
*>
*>    Changes.          See Changelog & Prog-Name.
*>
*>*************************************************************************
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of Cobxref AND GnuCOBOL and is copyright
*> (c) Vincent B Coen 2010 - forever.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 ONLY within GnuCOBOL, providing
*> the package continues to be issued or marketed as 'GnuCOBOL' and
*> is available FREE OF CHARGE AND WITH FULL SOURCE CODE.
*>
*> It cannot be included or used with any other Compiler without the
*> written Authority by the copyright holder, Vincent B Coen.
*>
*> Cobxref is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endevor
*> to fix it, providing you tell me about the problem.
*>
*> You should have received a copy of the GNU General Public License along
*> with Cobxref; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>*************************************************************************
*>
 environment division.
*> configuration section.
*> source-computer.      linux.
*> object-computer.      linux.
 input-Output section.
 file-control.
*>
     select   Reserve-Stream   assign  "res.tmp"
              organization     line sequential
              status           FS-Reply.
     select   Intrinsic-Stream assign  "int.tmp"
              organization     line sequential
              status           FS-Reply.
     select   System-Stream    assign  "sys.tmp"
              organization     line sequential
              status           FS-Reply.
*>
 data division.
 file section.
*>***********
*>
*> CAUTION: These files can and probably do contain Tab chars
*>
 fd  Reserve-Stream.
 01  Res-Record            pic x(128).
*>
 fd  Intrinsic-Stream.
 01  Int-Record            pic x(128).
*>
 fd  System-Stream.
 01  Sys-Record            pic x(128).
*>
 working-storage section.
*>**********************
 77  Prog-Name              pic x(27)       value "get-reserved-lists v1.00.04".
 77  S-Ptr                  Binary-long     value zero.
 77  Res-Start              Binary-char     value zero.
 77  ws-Function-Table-Size pic s9(5)  comp value zero.
 77  ws-Resvd-Table-Size    pic s9(5)  comp value zero.
 77  ws-System-Table-Size   pic s9(5)  comp value zero.
 77  FS-Reply               pic 99.
 77  WS-Display             pic 9           value zero.
     88  SW-No-Display                      value 1.
*>
 01  Placement-Res          pic x(30).
 01  Placement-Res-State    pic x.
*>
 01  Error-messages.
*> Msg1 thru 10, 18 & 19 in cobxref
     03 Msg11     pic x(60) value "Msg11 Cannot run 'cobc --list-intrinsics', cobc not in path?".
     03 Msg12     pic x(58) value "Msg12 Cannot run 'cobc --list-reserved', cobc not in path?".
     03 Msg13     pic x(51) value "Msg13 Intrinsic word table was successfully updated".
     03 Msg14     pic x(49) value "Msg14 Reserve word table was successfully updated".
     03 Msg15     pic x(55) value "Msg15 Cannot run 'cobc --list-sytem', cobc not in path?".
     03 Msg16     pic x(48) value "Msg16 System word table was successfully updated".
*>
 Linkage section.
*>**************
*> On entry if WS-Return-Code preset with 36 the table update messages will not appear.
*>
 01  ws-Return-Code          binary-char.
*>
*> Here for cb_intrinsic_table in GC see cobc/reserved.c in the GnuCOBOL source directory but
*>    Totally ingoring the system_table as not needed/used by xref
*>
*> Also note that the number 0 or 1 indicates if the function/reserved word is implemented in
*> GnuCOBOL but xref treats all, as being reserved as they are so (reserved that is)
*>
 01  Function-Table-R.
     03  All-Functions                 occurs 256 ascending key P-Function indexed by All-Fun-Idx.
         05  P-oc-implemented  pic x.
         05  P-Function        pic x(30).
 01  Function-Table-Size       pic s9(5)  comp.
*>
*> Note that system names are omitted so that they turn up in the cross refs
*>
*> Here for all reserved words in GC see :
*>           struct reserved reserved_words in cobc/reserved.c in the GnuCOBOL source directory
*>
 01  Additional-Reserved-Words-R.
     03  Reserved-Names                occurs 2048 ascending key Resvd-Word indexed by Resvd-Idx.
         05  Resvd-Implemented pic x.
         05  Resvd-Word        pic x(30).
 01  Resvd-Table-Size          pic s9(5)   comp.
*>
 01  System-Table-R.
     03  All-Systems                   occurs 128 ascending key P-System indexed by All-System-Idx.
         05  P-System          pic x(30).
 01  System-Table-Size         pic s9(5)  comp.
*>
 procedure division using ws-Return-Code
                          Function-Table-R
                          Function-Table-Size
                          Additional-Reserved-Words-R
                          Resvd-Table-Size
                          System-Table-R
                          System-Table-Size.
*>===================================================
 aa000-startup section.
 aa010-Init.
     if       WS-Return-Code = 36
              move 1 to WS-Display                 *> Turn off table update msgs
     end-if
     call     "SYSTEM" using "cobc --list-intrinsics > int.tmp".
     call     "SYSTEM" using "cobc --list-reserved > res.tmp".
     call     "SYSTEM" using "cobc --list-system > sys.tmp".
     move     zero to ws-return-code.
     perform  ba000-Get-Intrinsics-Words.
     if       ws-return-code not zero
              exit program.
     perform  ca000-Get-Reserved-Words.
     if       ws-return-code not zero
              exit program.
     perform  da000-Get-System-Words.
     call     "CBL_DELETE_FILE" using "res.tmp". *> delete temp files
     call     "CBL_DELETE_FILE" using "int.tmp".
     call     "CBL_DELETE_FILE" using "sys.tmp".
     exit     program.
*>
 ba000-Get-Intrinsics-Words section.
 ba010-init.
     open     input Intrinsic-Stream.
     if       FS-Reply = 35
              display Msg11.
     if       FS-Reply not = zero
              move FS-Reply to ws-return-code
              exit section.
*>
     move     Function-Table-Size to ws-Function-Table-Size.  *> keep old
     move     high-values to Function-Table-R.                *> there is a data stream so we can clear the table
     move     zero to Function-Table-Size.
*>
 ba020-get-thru-base-data.
     move     spaces to Int-Record.
     read     Intrinsic-Stream at end
              move zero to ws-return-code
              close Intrinsic-Stream
              if    Function-Table-Size > ws-Function-Table-Size
                and not SW-No-Display
                    display Msg13
              end-if
              exit section.
*>
     if       Int-Record (1:1) = space                        *> blank line
       or     Int-Record (1:18) = "Intrinsic Function"        *> header
              go to ba020-get-thru-base-data.
*>
*>  This point we now have data
*>
     move     1 to S-Ptr.
     move     spaces to Placement-Res Placement-Res-State.
     unstring Int-Record delimited by all x"09" or all spaces into Placement-Res pointer S-Ptr.
     unstring Int-Record delimited by all x"09" or all spaces into Placement-Res-State pointer S-Ptr.
     if       Placement-Res (1:1) = space or = high-value
              go to ba020-Get-Thru-Base-Data.
     add      1 to Function-Table-Size.
     move     Placement-Res to P-Function (Function-Table-Size).
     If       Placement-Res-State = "Y"
              move "1" to P-oc-implemented (Function-Table-Size)
     else
              move "0" to P-oc-implemented (Function-Table-Size).
*>
     go to ba020-get-thru-base-data.
*>
 ca000-Get-Reserved-Words section.
 ca010-init.
     open     input Reserve-Stream.
     if       FS-Reply = 35
              display Msg12.
     if       FS-Reply not = zero
              move FS-Reply to ws-return-code
              exit section.
*>
     move     Resvd-Table-Size to ws-Resvd-Table-Size.
     move     high-values to Additional-Reserved-Words-R.  *> there is a data stream so we can clear the table
     move     zero to Resvd-Table-Size.
     move     zero to Res-Start.
*>
 ca020-get-thru-base-data.
     move     spaces to Res-Record.
     read     Reserve-Stream at end
              go to ca030-Clean-Up.
*>
     if       Res-Record (1:1) = space                        *> blank line
       or     Res-Record (1:14) = "Reserved Words"            *> header
              go to ca020-get-thru-base-data
     end-if
     if       Res-Record (1:16) = "Extra (obsolete)"
 *>             perform  forever
 *>                read Reserve-Stream at end
 *>                     go to ca030-Clean-Up
 *>                end-read
            or Res-Record (1:14) = "Internal registers"
                    move 1 to Res-Start      *> Dont have res-State set to 1 so help to make it so
                    go to ca020-get-thru-base-data
 *>       end-if
 *>             end-perform
     end-if
*>
*>  This point we now have data
*>
     move     1 to S-Ptr.
     move     spaces to Placement-Res Placement-Res-State.
     unstring Res-Record delimited by all x"09" or all spaces into Placement-Res pointer S-Ptr.
     unstring Res-Record delimited by all x"09" or all spaces into Placement-Res-State pointer S-Ptr.
*>
*> Ignore bad 'reserved' names such as 'LENGTH OF' and 'ADDRESS OF as 1st word present.
*>
     if       Placement-Res = "'LENGTH"
       or                   = "'ADDRESS"
              go to ca020-get-thru-base-data.
*>
     add      1 to Resvd-Table-Size.
     move     Placement-Res to Resvd-Word (Resvd-Table-Size).
     If       Placement-Res-State = "Y"
              move "1" to Resvd-Implemented (Resvd-Table-Size)
     else
      if      Placement-Res-State = "N"
              move "0" to Resvd-Implemented (Resvd-Table-Size)
      else
       If     Res-Start = 1                         *> have a Extra internal with no implemented flag
              move "1" to Resvd-Implemented (Resvd-Table-Size)
       else
              move "0" to Resvd-Implemented (Resvd-Table-Size)
       end-if
      end-if
     end-if
*>
     go to ca020-get-thru-base-data.
*>
 ca030-Clean-Up.
     move     zero to ws-return-code.
     close    Reserve-Stream.
     if       Resvd-Table-Size > ws-Resvd-Table-Size
          and not SW-No-Display
              display Msg14
     end-if
     exit     section.
*>
 da000-Get-System-Words section.
 da010-init.
     open     input System-Stream.
     if       FS-Reply = 35
              display Msg15.
     if       FS-Reply not = zero
              move FS-Reply to ws-return-code
              exit section.
*>
     move     System-Table-Size to ws-System-Table-Size.  *> keep old
     move     high-values to System-Table-R.              *> there is a data stream so we can clear the table
     move     zero to System-Table-Size.
*>
 da020-get-thru-base-data.
     move     spaces to Sys-Record.
     read     System-Stream at end
              move zero to ws-return-code
              close System-Stream
              if    System-Table-Size > ws-System-Table-Size
                and not SW-No-Display
                    display Msg16
              end-if
              exit section.
*>
     if       Sys-Record (1:1) = space                    *> blank line
       or     Sys-Record (1:14) = "System routine"        *> header
              go to da020-get-thru-base-data.
*>
*>  This point we now have data
*>
     move     1 to S-Ptr.
     move     spaces to Placement-Res.
     if       Sys-Record (1:2) = 'X"'
              move Sys-Record (3:2) to Placement-Res (1:2)
              move 2 to S-Ptr
     else
              unstring Sys-Record delimited by space
                    into Placement-Res pointer S-Ptr.
     if       Placement-Res (1:1) = space or = high-value
              go to da020-Get-Thru-Base-Data.
     add      1 to System-Table-Size.
     move     Placement-Res (1:S-Ptr) to P-System (System-Table-Size).
     go       to da020-get-thru-base-data.
*>
 end program get-reserved-lists.
*>
*>
 identification division.
*>**********************
 program-id.    printcbl.
*>
*>  ===============================================================
*>   WARNING ANY CHANGES TO printcbl.cbl should be also considered
*>      Here as well, both ways.
*>  ===============================================================
*>
*> CONFIGURATION SETTINGS: Set these switches before compiling:
*>  GnuCOBOL CONSTANTS section.
*>
*> Temporary for testing program args etc, (We-Are-Testing) will display prog arguments at start.
*>  Set to 1 to be active
*>
*>>>>>>>DEFINE CONSTANT C-Testing-1   AS 0    *> Not testing (default), change to AS 1 if wanted.
*>
*>   Others removed as NOT NEEDED IN MODULE MODE for cobxref.
*>
*>-
*> END CONFIGURATION SETTINGS
*>
*>
*> Author.      Vincent B Coen New rewritten version v2.01.18+)
*>                See Changelog file for all changes.
*> Copyright.   Vincent B Coen 2011-2019 Rewritten.
*>              [Jim C. Currey 2009-2011 Conceptual original programmer,]
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 and later.
*>
*> Cobxref and Printcbl is distributed in the hope that it will be useful, but
*> WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*> or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endeavour
*> to fix it, providing you tell me about the problem.
*>
*> You should have received a copy of the GNU General Public License along
*> with Cobxref & PrintCbl; see the file Copying.pdf.
*>  If not, write to the Free Software Foundation,
*>    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>
*> Testing Level 1/2
*>*****************
*>
*> 17/05/12 vbc - Copy                working
*> 18/05/12 vbc - 'Suppress'          working
*> 18/05/12 vbc - 'Suppress printing' working
*> 01/06/12 vbc - 'REPLACING'         working
*>
*>  WARNING: Minimum compiler version is v2.0.
*>
*>  Please read all of the notes before use!!!
*>   Notes transferred to a manual in LibreOffice & PDF formats.
*>
*>  Make sure that you have tested the GnuCOBOL compiler by running
*>   make checkall and that you get no errors what so ever
*>    otherwise you might get compiler induced errors when running.
*>
*>*************************************************************
*> Purpose:
*>         Produces a updated source file) of a
*>      Cobol source program with all of its copy books included.
*>        using the Print-File that is passed to cobxref.
*>===============================================================
*>
*>  See manual for more information
*>
*>***************************************************************
*>
 environment division.
 input-output section.
 file-control.
     select Print-File     assign to WS-Print-File-Name
                           organization line sequential.
*>
 data division.
 file section.
*>
 fd  Print-File.
 01  Formatted-Line          pic x(160).
*>
 working-storage section.
*>======================
*>
 01  WS-Name-Program        pic x(25) value "Prtcbl (in xref) v2.01.37".  *> ver.rel.build
*>
 01  PL-Text                pic x(160).       *> printcbl.cbl has 248
*>
*>   **************************************
*>   *     User changeable values here:  **
*>   **************************************
*>
*> Temporary for testing program args etc, (We-Are-Testing) will
*>   display prog arguments at start. SET via CDF at start of src.
*>  Useful to have anyway!
*>
 77  filler                 pic 9 value C-Testing-1.                 *> Taken from CDF value start of src
     88 We-Are-Testing            value 1.
*>
 77  filler                 pic 9 value C-Testing-2.   *> 0.
     88 We-Are-Testing2           value 1
                               False is 0.
 77  filler                 pic 9 value C-Testing-3.   *> 0.
     88 We-Are-Testing3           value 1
                               False is 0.
 77  filler                 pic 9 value C-Testing-4.   *> 0.
     88 We-Are-Testing4           value 1
                               False is 0.
*>
*>  Operating system path delimiter set to Linux by default changeable
*>       in CDF facility at start of sources.
*>
 77  OS-Delimiter           pic x          value C-OS-Delimiter.
*>
*>   **************************************
*>   *    End of User Changeable Values   ****************************************************
*>   **************************************
*>
 01  WS-Print-File-Name     pic x(64)      value spaces.
 01  WS-Input-File-Name     pic x(64)      value spaces.
 01  WS-Copy-File-Name      pic x(768)     value spaces.
 01  WS-Hold-Copy-File-Name pic x(768)     value spaces.
 01  WS-Error-Count         pic 999   comp value zero.
 01  WS-Caution-Count       pic 999   comp value zero.
 01  filler                 pic 9          value zero.
     88 WS-Print-Open                      value 1      False is 0.
*>
 01  Found-Quote-in-Copy    pic 9          value zero.
*>
 01  filler                 pic 9          value 1.
     88  No-Printing                       value 1  False is 0.    *>   found in 1st rec
*>
 01  WS-Quote-Used          pic x          value space.   *> used in  zz010-Check-for-Extended-Record
 01  filler                 pic 9          value zero.
     88  WS-Need-Leading-Quote             value 1  False is 0.
*>
 01  filler                 pic 9          value zero.
     88  WS-We-Have-Replaced               value 1  False is 0.
*>
 *> 01  Found-In               pic 9          value zero.  *> Not used yet
 01  filler                 pic 9          value zero.
     88  Found-Word                        value 1      False is 0.
 01  Filler                 pic 9          value zero.
     88  Found-Number                      value 1      False is 0.
 01  Hold-Word1             pic x(256)     value space.
 01  Hold-Word2             pic x(256)     value space.
 01  WS-Free                pic 9          value zero.  *> Source code format
     88  WS-Fixed-Set                      value zero.
     88  WS-Free-Set                       value 1.
 01  filler                 pic 9          value zero.  *> Search in copy libs
     88  No-Search                         value 1.     *> Dont, as we are using source file
     88  Yes-Search                        value zero.  *> Do so, as we are using Copy files
 01  WS-Number-Test.
     03  WS-Number          pic 9.
*>
*>   Used in Copy Table
*>
 01  Word-Delimit           pic x          value space.
 01  Word-Delimit2          pic xx         value spaces.  *> Of copyfilename, space or ". "
 01  WS-P1                  pic s9(7) comp value zero.    *> Used for small buffers
 01  WS-P2                  pic s9(7) comp value zero.    *>    ---- ditto ----
 01  WS-P3                  pic s9(7) comp value zero.
 01  WS-P4                  pic s9(7) comp value zero.
 01  WS-P5                  pic s9(7) comp value zero.
 01  WS-P6                  pic s9(7) comp value zero.
 01  WS-P7                  pic s9(7) comp value zero.
 01  WS-P8                  pic s9(7) comp value zero.
 01  WS-P11                 pic s9(7) comp value zero.
 01  WS-P12                 pic s9(7) comp value zero.
 01  WS-P13                 pic s9(7) comp value zero.
 01  WS-P14                 pic s9(7) comp value zero.
 01  WS-P15                 pic s9(7) comp value zero.
 01  WS-P16                 pic s9(7) comp value zero.
 01  WS-P17                 pic s9(7) comp value zero.
 01  WS-P18                 pic s9(7) comp value zero.
 01  WS-P19                 pic s9(7) comp value zero.    *> used in  zz010-Check-for-Extended-Record
 01  WS-P20                 pic s9(7) comp value zero.
 01  WS-P21                 pic s9(7) comp value zero.    *> used in  zz010-Check-for-Extended-Record
 01  WS-P25                 pic s9(7) comp value zero.    *>   thru to P35
 01  WS-P27                 pic s9(7) comp value zero.
 01  WS-P28                 pic s9(7) comp value zero.
 01  WS-P29                 pic s9(7) comp value zero.
 01  WS-P30                 pic s9(7) comp value zero.
 01  WS-P40                 pic s9(7) comp value zero.
 01  WS-End                 pic s9(7) comp value zero.    *> Normal end of record, eg, 256 or 72
 01  WS-Disp                pic z9.
 01  WS-Disp2               pic zz9.
 01  WS-Disp3               pic ----9.
 01  WS-Disp4               pic z(6)9.
 01  a                      pic s9(5) comp value zero.
 01  e                      pic s9(5) comp value zero.
 01  f                      pic s9(5) comp value zero.
 01  g                      pic s9(7) comp value zero.
*>
 01  fn                     pic 999  comp  value zero.
 01  u                      pic 999  comp  value zero.
 01  x                      pic 9(4) comp  value zero.
 01  xx                     pic 9(4) comp  value zero.
 01  y                      pic 99   comp  value zero.
 01  z                      pic 99   comp  value zero.
*>
*>   ******************************************************************
*>   *  Contents of COBC Env vars if set but usually only one of both *
*>   *  if both exist AND the same only use one - COBCPY              *
*>   ******************************************************************
*>
 01  Uns-Delimiter          pic x          value space.
 01  Cobcpy                 pic x(500)     value spaces.
 01  Cob_Copy_Dir           pic x(500)     value spaces.
 01  Copy-Dirs-Block.                                    *> Could be larger but if you need it, you have
*>                                                          some serious project control issues !!
     03  No-Of-Copy-Dirs    pic s99  comp  value zero.
     03  Copy-Lib           pic x(500)                 occurs 10.
*>
*>   *****************************************************
*>   *  Holds program parameter values from command line *
*>   *****************************************************
*>
 *> 01  Arg-Number             pic 9          value zero.
 *> 01  Arg-Vals                              value spaces.
 *>     03  Arg-Value          pic x(515)                 occurs 5.
 01  Arg-Test               pic x(515)     value spaces.
*>
*>   *******************************************
*>   *  Variables/Tables for Copy input files  *
*>   *******************************************
*>
*>   +==========================================================+
*>   | NOTE that some data and code taken from Profiler (v0.01) |
*>   |     and Cobxref                                          |
*>   | SO copy any bugs fixes here to them !!                   |
*>   +==========================================================+
*>
*>   Starting with Error Messages
*>
 01  Error-messages.
     03  Msg21              pic x(40) value "Msg21 Error: Too many levels (9) of COPY".
     03  Msg22              pic x(33) value "Msg22 Error: Copy File Not Found ".
     03  Msg23              pic x(28) value "Msg23 Error: File Not Found ".
     03  Msg24              pic x(30) value "Msg24 (P): File Not Closed? = ".
     03  Msg25              pic x(31) value "Msg25 (P): On Read. Ret.code = ".
     03  Msg26              pic x(41) value "Msg26 Error: When opening I/P file got = ".
     03  Msg27              pic x(58) value "Msg27 Error: Cannot Find File, & tried six different .Exts".
     03  Msg28              pic x(34) value "Msg28 Error: Abnormal end of input".
     03  Msg29              pic x(54) value "Msg29 Caution: One or more replacing sources not found".
 *>    03  Msg30              pic x(39) value "Msg30 Error: Invalid Format, try again!".
     03  Msg31              pic x(35) value "Msg31 (P): Bad RT on Get-Directory ".
     03  Msg32              pic x(40) value "Msg32 Error: Recursive Copy File Name = ".
*>
*>   ***************************************
*>   | List of possible source file .exts, |
*>   |  First one is ALWAYS space.         |
*>   ***************************************
*>
 01  Extention-Table        pic x(28)     value "    .cpy.CPY.cbl.CBL.cob.COB".
 01  filler redefines Extention-Table.
     03  File-Ext           pic x(4)  occurs 7.
 01  Ext-Table-Size         pic 9         value 7.
*>
*>   **********************************************************    NOTE: that GC only goes 2-5
*>   *  Now follows the tables needed for the 9 depth levels  *          or does it
*>   *  that support the copy verb  within a copy verb.       *
*>   *  First is ALWAYS the source file.                      *
*>   **********************************************************
*>
 01  Input-Record.
     05  IR-Buffer          pic x(256).
 01  IR-Buffer-Data-Size    pic 999     comp       value zero.
 01  Temp-Input-Record.
     03  TIR                pic x(256).
*>
*>   WARNING: Do NOT alter these Structures or Formats!
*>
*>   Many variables are present but not currently used, but when
*>     extra coding is added to provide extra COPY verb support
*>     that will change.
*>
 01  Copy-Depth             pic 99                 value zero.
 01  Max-Copy-Depth         pic 99                 value zero.
*>
 01  Copy-Max-Length        pic 9(6)    comp       value 65536.      *> Is this too high? NOT USED
*>
 01  File-Handle-Tables.                                             *>  1st occurrence is for orig source file.
     03  FHT                            occurs 1 to 10 depending on Fht-Table-Size.
         05  Fht-Byte-Count        pic x(4)    comp-x  value 1048576.
         05  Fht-Var-Block.
             07  Fht-File-Handle   pic x(4).
             07  Fht-File-OffSet   pic x(8)    comp-x  value zero.
             07  Fht-File-Size     pic x(8)    comp-x  value zero.
             07  Fht-Block-OffSet  pic x(8)    comp-x  value zero.
             07  Fht-Pointer       pic s9(7)   comp    value zero.
             07  Fht-P1            pic s9(7)   comp    value zero.   *> WS-P1 Storage Not yet used
             07  Fht-P2            pic s9(7)   comp    value zero.   *> WS-P2 Storage Not yet used
             07  Fht-Copy-Line-End pic s9(5)   comp    value zero.   *>  All new not programmed
             07  Fht-Copy-Words    pic s9(5)   comp    value zero.   *>  All new not programmed
             07  Fht-SW-Eof        pic 9               value zero.
                 88  Fht-Eof                           value 1     False is 0.
             07  Fht-Copy-Found    pic 9               value zero.   *>  All new not programmed
             07  Fht-Replace-Found pic 9               value zero.   *>      ----- ' --------
             07  Fht-Literal-Found pic 9               value zero.   *>      ----- ' --------
             07  Fht-Continue      pic 9               value zero.   *>      ----- ' --------
             07  Fht-Quote-Found   pic 9               value zero.   *>      ----- ' --------
             07  Fht-Quote-Type    pic x               value space.  *>      ----- ' --------
             07  Fht-Source-Format pic 9               value zero.
                 88  Fht-Fixed                         value 0.
                 88  Fht-Free                          value 1.
             07  Fht-Block-Status  pic 9               value zero.
                 88  Fht-Block-Eof                     value 1.
         05  Fht-Current-Rec       pic x(256)          value spaces. *> Max size of free recs + 1
         05  Fht-File-Name         pic x(768)          value spaces.
         05  Fht-Buffer.
             07  filler            pic x(1024)  occurs 1024.         *> same as Fht-Buffer-Size
             07  filler            pic x.                            *> Fht-Buffer-Size + 1
         05  filler                pic x               value x"FF".  *> Trap for buffer overflow Hopefully!
*>
 01  Fht-Buffer-Size               pic s9(7)   comp    value 1048576.
 01  Fht-Table-Size                pic s999    comp    value zero.
 01  Fht-Max-Table-Size            pic 999     comp    value 10.     *> same as occurs in (above) FHT.
 01  CRT-Replace-Arguments-Size    pic 999     comp    value 50.     *> Same as occurs in WS- | CRT-Replace-Arguments
 01  CRT-Table-Size                pic 999     comp    value zero.
 01  Copy-Replacing-Table.                                           *>  occurs per copy file
     03  CRT-Instance        occurs 1 to 10 depending on CRT-Table-Size. *> well nine is correct figure ..
         05  CRT-Active-Flag       pic 9               value zero.
             88  CRT-Active                            value 1     False is 0.
         05  CRT-Copy-Found-Flag   pic 9               value zero.
             88  CRT-Copy-Found                        value 1     False is 0.
         05  CRT-Copy-Library-Flag pic 9               value zero.
             88  CRT-COPY-Lib-Found                    value 1     False is 0.
         05  CRT-Copy-Fname-Ext-Flag pic 9             value zero.
             88  CRT-Copy-Fname-Ext                    value 1     False is 0.
         05  CRT-Replace-Found-Flag   pic 9            value zero.
             88  CRT-Replace-Found                     value 1     False is 0.
         05  CRT-Quote-Found-Flag     pic 9            value zero.
             88  CRT-Quote-Found                       value 1     False is 0.
         05  CRT-Quote-Type        pic x               value space.
         05  CRT-Literal-Found-Flag   pic 9            value zero.   *>  All new not programmed
             88  CRT-Literal-Found                     value 1     False is 0. *> not programmed
         05  CRT-Continue-Flag     pic 9               value zero.   *>  All new not programmed
             88  CRT-Continue                          value 1     False is 0. *> not programmed
         05  CRT-Within-Comment    pic 9               value zero.   *>  All new not programmed
         05  CRT-Within-Bracket    pic 9               value zero.   *>  All new not programmed
         05  CRT-Need-Quotation-Flag  pic 9            value zero.   *>  All new not programmed
         05  CRT-Need-Continuation pic 9               value zero.   *>  All new not programmed
         05  CRT-Replace-Space     pic 9               value zero.   *>  All new not programmed
         05  CRT-Suppress-Flag     pic 9               value zero.
             88  CRT-Suppress                          value 1     False is 0.
         05  CRT-Consecutive-Quotation pic 9           value zero.   *>  All new not programmed
         05  CRT-Newline-Count     pic 999     comp    value zero.   *>  All new not programmed
         05  CRT-Replacing-Count   pic 999     comp    value zero.
         05  CRT-Copy-Length       pic 9(7)    comp    value zero.   *>  All new not programmed [ used in testing 4 prints]
         05  CRT-Copy-Statement                        value spaces. *> The entire copy statement but not really needed
             07  filler            pic x(1024)  occurs 1024.         *> 1 MB                      except during testing
         05  CRT-Copy-FileName     pic x(256)          value spaces.
         05  CRT-Copy-Library      pic x(512)          value spaces.
         05  CRT-Replace-Arguments      occurs  50.                  *>  Fixed size, Usage is CRT-Replacing-Count.
             07  CRT-Leading-Flag  pic 9               value zero.
                 88  Crt-Leading                       value 1     False is 0.
             07  CRT-Trailing-Flag pic 9               value zero.
                 88  Crt-Trailing                      value 1     False is 0.
             07  CRT-Replace-Type  pic 9               value zero.
                 88  CRT-RT-Lit                        value 1.
                 88  CRT-RT-Pseudo                     value 2.
                 88  CRT-RT-Else                       value 3.
                 88  CRT-RT-Oops                       value 0.
             07  CRT-Found-Src     pic 99              value zero.    *> non zero if a replacing target is found
             07  CRT-Source-Size   pic 9(4)            value zero.    *> these sizes relate to the replacing-source and target
             07  CRT-Target-Size   pic 9(4)            value zero.    *>   - - - -  ditto - - - -
*>
*>  On paper these can be as large as 65,535 BUT coding can only cope if literal or word is on same source line
*>     So not relevant at this time (30 April 2012) v02.01.*
*>
             07  CRT-Replacing-Source  pic x(2048)     value spaces.  *> Make larger if required (coding changes also needed)
             07  CRT-Replacing-Target  pic x(2048)     value spaces.  *> ditto
*>
 01  Cbl-File-Fields.
     03  Cbl-File-name      pic x(768).
     03  Cbl-Access-Mode    pic x          comp-x  value 1.
     03  Cbl-Deny-Mode      pic x          comp-x  value 3.
     03  Cbl-Device         pic x          comp-x  value zero.
     03  Cbl-Flags          pic x          comp-x  value zero.       *> normal 0 or 128 returns filesize in file offset
     03  Cbl-File-Handle    pic x(4)               value zero.
     03  Cbl-File-OffSet    pic x(8)       comp-x  value zero.
*>
 01  Cbl-File-Details.
     03  Cbl-File-Size      pic x(8)       comp-x  value zero.
     03  Cbl-File-Date.
         05  Cbl-File-Day   pic x          comp-x  value zero.
         05  Cbl-File-Mth   pic x          comp-x  value zero.
         05  Cbl-File-Year  pic xx         comp-x  value zero.
     03  Cbl-File-time.
         05  Cbl-File-Hour  pic x          comp-x  value zero.
         05  Cbl-File-Min   pic x          comp-x  value zero.
         05  Cbl-File-Sec   pic x          comp-x  value zero.
         05  Cbl-File-Hund  pic x          comp-x  value zero.
*>
*>  Extra Buffers needed for replacing  For Active Copy
*>
 01  IB-Size                pic 9(7)               value zero.
 01  Input-Buffer.
     03  filler             pic x(1024)    occurs 1024.  *> 1 MB buffers
 01  CInput-Buffer.                                      *> Converted to uppercase for test
     03  filler             pic x(1024)    occurs 1024.  *> 1 MB buffers
 01  OB-Size                pic 9(7)               value zero.
 01  Temp-Replacing-Source  pic x(2048).                 *> same as size of CRT-Replacing-Source
 01  Temp-Replacing-Target  pic x(2048).                 *>  - - Ditto for Target
 01  Temp-Record            pic x(256).
*>
*> Copy of current Copy table block to save accessing a table when processing COPY
*>
 01  WS-CRT-Active-Copy-Table     pic s999    comp    value zero.    *> taken from CRT-Table-Size
 01  WS-CRT-Instance.
     03  WS-CRT-Active-Flag       pic 9               value zero.
         88  WS-CRT-Active                            value 1     False is 0.
     03  WS-CRT-Copy-Found-Flag   pic 9               value zero.
         88  WS-CRT-Copy-Found                        value 1     False is 0.
     03  WS-CRT-Copy-Library-Flag pic 9               value zero.
         88  WS-CRT-COPY-Lib-Found                    value 1     False is 0.
     03  filler                   pic 9           value zero.
         88  WS-CRT-Copy-Fname-Ext                    value 1     False is 0.
     03  WS-CRT-Replace-Found-Flag    pic 9           value zero.
         88  WS-CRT-Replace-Found                     value 1     False is 0.
     03  WS-CRT-Quote-Found-Flag  pic 9               value zero.
         88  WS-CRT-Quote-Found                       value 1     False is 0.
     03  WS-CRT-Quote-Type        pic x               value space.
     03  WS-CRT-Literal-Found-Flag    pic 9           value zero.
         88  WS-CRT-Literal-Found                     value 1     False is 0.
     03  WS-CRT-Continue-Flag     pic 9               value zero.
         88  WS-CRT-Continue                          value 1     False is 0.
     03  WS-CRT-Within-Comment    pic 9               value zero.    *>  All new not programmed
     03  WS-CRT-Within-Bracket    pic 9               value zero.    *>  All new not programmed
     03  WS-CRT-Need-Quotation-Flag   pic 9           value zero.    *>  All new not programmed
     03  WS-CRT-Need-Continuation pic 9               value zero.    *>  All new not programmed
     03  WS-CRT-Replace-Space     pic 9               value zero.    *>  All new not programmed
     03  WS-CRT-Suppress-Flag     pic 9               value zero.
         88  WS-CRT-Suppress                          value 1     False is 0.
     03  WS-CRT-Consecutive-Quotation pic 9           value zero.    *>  All new not programmed
     03  WS-CRT-Newline-Count     pic 999     comp    value zero.    *>  All new not programmed
     03  WS-CRT-Replacing-Count   pic 999     comp    value zero.
     03  WS-CRT-Copy-Length       pic 9(7)    comp    value zero.
     03  WS-CRT-Copy-Statement                        value spaces.
         05  filler               pic x(1024)  occurs 1024.          *> 1 MB
     03  WS-CRT-Copy-FileName     pic x(256)          value spaces.
     03  WS-CRT-Copy-Library      pic x(512)          value spaces.
     03  WS-CRT-Replace-Arguments      occurs  50.                   *>  Usage WS-CRT-Replacing-Count
         05  WS-CRT-Leading-Flag  pic 9               value zero.
             88  WS-CRT-Leading                       value 1     False is 0.
         05  WS-CRT-Trailing-Flag pic 9               value zero.
             88  WS-CRT-Trailing                      value 1     False is 0.
         05  WS-CRT-Replace-Type  pic 9               value zero.
             88  WS-CRT-RT-Lit                        value 1.
             88  WS-CRT-RT-Pseudo                     value 2.
             88  WS-CRT-RT-Else                       value 3.
             88  WS-CRT-RT-Oops                       value 0.
         05  WS-CRT-Found-Src     pic 99              value zero.    *> non zero if a replacing target is found
         05  WS-CRT-Source-Size   pic 9(4)            value zero.    *> these sizes relate to the replacing-source and target
         05  WS-CRT-Target-Size   pic 9(4)            value zero.    *>   - - - -  ditto - - - -
         05  WS-CRT-Replacing-Source  pic x(2048)     value spaces.  *> Make larger if required
         05  WS-CRT-Replacing-Target  pic x(2048)     value spaces.  *> ditto
*>
 linkage section.
*>
 01  LS-Source-File     pic x(64).     *> from cobxref call P1
 01  LS-Prog-BaseName   pic x(64).     *>  Ditto P2
 01  LS-Prog-Format     pic x.         *>  Ditto P3
     88  LS-SW-Free               value "Y".
 01  LS-SW-11           pic x.         *>  Ditto P4
     88  LS-Verbose-Output        value "Y".
 01  LS-Return-Code        binary-char  value zero.
*>
 Procedure Division using LS-Source-File
                          LS-Prog-BaseName
                          LS-Prog-Format
                          LS-SW-11
                          LS-return-code.
*>========================================
*>
 AA-Main Section.
*>**************
*>
     perform  aa000-Initialization.
     if       return-code not = zero
              move return-code to LS-Return-Code
              goback.
     perform  ba000-Process.
     perform  ca000-End-of-Job.
     exit     program.
     goback.                               *> It might be called
*>
 aa000-Initialization section.
*>***************************
*>
     perform  zz020-Get-Program-Args.
     if       return-code not = zero
              display "Errors: Note and Hit return to quit "
              accept  Hold-Word1 (1:1)
              move    space to Hold-Word1 (1:1)
              move    128 to Return-Code
              go      to aa000-Exit.
*>
 aa030-Bypass-Accepts.
     set     No-Printing to true.
*>
     set      No-Search to true.
     move     WS-Input-File-Name to WS-Copy-File-Name.
     if       not WS-Print-Open
              open output Print-File
              set WS-Print-Open to true
     end-if.
*>
 aa040-Open-Main.
     perform  zz300-Open-File thru zz300-Exit.
     if       Return-Code  = 26
              display Msg23 at 1301 with foreground-color 3
              move 32 to Return-Code
              close Print-File
              go      to aa000-Exit.
*>
*> Next, this should not occur !!
*>
     if       Return-Code not = zero
              display Msg26          at 1301 with foreground-color 3 highlight
              display Return-Code    at 1336 with foreground-color 3 highlight
              move 32 to Return-Code
              close Print-File
              go      to aa000-Exit.
*>
     set      Yes-Search to true.          *>  ?????   <<<< IS IT?
     move     WS-Free to Fht-Source-Format (Fht-Table-Size).   *> copy format to current table record
*>
 aa000-Exit.
     Exit     Section.
*>
 ba000-Process Section.
*>********************
*>
*>   This loop for main source file and copy files as well
*>
     if       Fht-Table-Size = zero
               perform  bd000-Test-For-Messages
              go to ba999-exit                              *> EOJ
     end-if
     perform  zz600-Read-File thru zz600-Exit.
     if       Fht-Eof (Fht-Table-Size)
*>        and   Fht-Block-Eof (Fht-Table-Size)
        and   Fht-Table-Size < 2                            *> closing source file
              perform zz500-Close-File thru zz500-Exit
               perform  bd000-Test-For-Messages
              go to ba999-exit                              *> EOJ
     end-if
*>
     if       Fht-Eof (Fht-Table-Size)                      *> EOF on current copy file
         or   Return-Code = -1
              perform zz500-Close-File thru zz500-Exit
              perform bc000-Test-For-Missing-Replace
              go to ba000-Process.
*>
     move     Fht-Current-Rec (Fht-Table-Size) to Input-Record.
*>
*>  Lets see if current source line has a >>SOURCE declaration if so change fixed/free attribute.
*>
     perform  da000-Check-For-Source.
     if       Fht-Free (Fht-Table-Size)
              set WS-Free-Set to true
              move 256 to WS-End
     else
              set WS-Fixed-Set to true
              move 72  to WS-End
     end-if
*>
*> Find size of source record (max = 255 as per specs) & start of source
*>
     perform  varying IR-Buffer-Data-Size from WS-End by -1 until
                           IR-Buffer (IR-Buffer-Data-Size:1) not = " "
                        or IR-Buffer-Data-Size < 2
     end-perform
     if       IR-Buffer (IR-Buffer-Data-Size:1) = x"0D" or x"00"
              subtract 1 from IR-Buffer-Data-Size
     end-if
     if       (WS-Free-Set  and IR-Buffer-Data-Size < 2)              *> Blank line PRINT
        or    (WS-Fixed-Set and IR-Buffer-Data-Size < 9)
              move     Input-Record To PL-Text
              perform  zz010-Write-Print-Line2
              go to ba000-Process.
*>
     move     zero to WS-P2.
     move     1    to WS-P1                                         *> Force Free format in case!!
                      WS-P5.
     if       WS-Fixed-Set                                          *> Free set above
              move  7 to WS-P1 WS-P5.
*>CHANGED for xref
*>
     perform  zz900-Process-Replace.
     move     Input-Record To PL-Text.
     if       WS-We-Have-Replaced            *> chgd 8/3/19
              perform zz010-Check-for-Extended-Record
     else
              perform zz010-Write-Print-Line1     *> chgd 8/3/19
     end-if
*>
*>
*> If comments, we are done with line
*>
     if       (ws-Fixed-Set and IR-Buffer (7:1) = "*")
         or   (ws-Fixed-Set and IR-Buffer (7:1) = "$")  *> ex MF source/lists
         or   (ws-Fixed-Set and IR-Buffer (7:1) = "#")  *> can we get them here cc7 ?
         or   (WS-Fixed-Set and (IR-Buffer (7:1) = "D" or = "d"))     *> Debug with COPY  ????
         or   (ws-Free-Set  and IR-Buffer (1:2) = "*>")
         or   (ws-Free-Set  and IR-Buffer (2:2) = "*>")  *> could have space then *>
         or   (ws-Free-Set  and IR-Buffer (7:2) = "*>")  *> floater format in fixed,
         or   (ws-Free-Set  and IR-Buffer (1:1) = "$")
         or   (ws-Free-Set  and IR-Buffer (1:1) = "#")
              go to ba000-Process
     end-if
*>
     set      Found-Word   to false.
     set      Found-Number to false.
*>
 ba010-Compare-Loop.
     if       IR-Buffer (WS-P1:3) = "*> "              *> Floating '*>', applies to both Free & Fixed
          or  = " *> "
              go to ba000-Process.
*>
*>   Try to make sure we dont use COPY word in a 'display' but
*>     accept one after a possible level number. This is NOT bullet proof
*>       so may need more code!
*>
     if       NOT Found-Number and Found-Word
        and   (function upper-case (IR-Buffer (WS-P1:6)) = " COPY "
         or   WS-P1 = 1 and function upper-case (IR-Buffer (1:5)) = "COPY ")
              add      1 to WS-P1
              if       WS-P1 < IR-Buffer-Data-Size - 6
                       go to ba010-Compare-Loop
              else
                       go to ba000-Process
              end-if
     end-if
     if       IR-Buffer (WS-P1:1) = quote or "'"
              add 1 to WS-P1
              perform varying WS-P1 from WS-P1 by 1
                                until IR-Buffer (WS-P1:1) = quote
                                  or "'"
                                  or WS-P1 > IR-Buffer-Data-Size - 7
              end-perform                                      *> loose the literal or line
              if   WS-P1 > IR-Buffer-Data-Size - 7
                   go to ba000-Process
              end-if
     end-if
*>
     if       function upper-case (IR-Buffer (WS-P1:6)) = " COPY "
       or     (WS-P1 = 1 and function upper-case (IR-Buffer (1:5)) = "COPY ")
              move zero to Found-Quote-in-Copy
              go to ba020-Copy.
*>
     move     IR-Buffer (WS-P1:1) to WS-Number-Test.
     if       WS-Number numeric
              set Found-Number to true.
     if       WS-Number-Test is Alphabetic
        and   WS-Number-Test not = space
              set Found-Word   to true.
*>
     add      1 to WS-P1.
     if       WS-P1 < IR-Buffer-Data-Size - 6
              go to ba010-Compare-Loop.

     go       to ba000-Process.
*>
 ba020-Copy.
     move     spaces to WS-Copy-File-Name
                        Input-Buffer.
     move     zero to IB-Size.
     move     Fht-Table-Size to CRT-Table-Size.
     initialize CRT-Instance (CRT-Table-Size).                 *> occurs matches in fht
*>
     initialize WS-CRT-Instance.
     move     CRT-Table-Size to WS-CRT-Active-Copy-Table.
*>
*> Preprocess copy statement
*>
     perform  bb000-Copy-Setup.                          *> copy is now in table so move to ws active copy
*>
     move     spaces to Hold-Word1 Hold-Word2.
*>
 ba030-Copy-Lib.
*>
*>  Deal with copy library if "IN" or "OF" used.
*>
     if       WS-CRT-Copy-Lib-Found
              perform varying WS-P17 from 510 by -1
                      until WS-CRT-Copy-Library (WS-P17:1) not = space
              end-perform
              move    1    to WS-P18
              if      WS-CRT-Copy-Library (1:1) = quote or = "'"
                      move 2 to WS-P18
                      subtract 1 from WS-P17
                      move spaces to Hold-Word1
                      unstring WS-CRT-Copy-Library (WS-P18:WS-P17)
                                 delimited by space or quote or "'"
                                       into Hold-Word1
                      end-unstring
              else
                      move WS-CRT-Copy-Library (1:WS-P17) to Hold-Word1   *> without quotes!
              end-if
     end-if
     move     zero to e.
*>
*>   WS-CRT-Copy-Filename is without quotes
*>
*>   We can have "abcd.abc"; abcd.abc; abcd - NO Trailing period..
*>
     inspect  WS-CRT-Copy-Filename tallying e for all ".".
     if       e > zero                                        *> its a .ext
              set WS-CRT-Copy-Fname-Ext to true
     end-if
     move     WS-CRT-Copy-Filename to WS-Copy-File-Name.
 *>
    if we-are-testing
           display "ba030: HCFN2 = " WS-Copy-File-Name
    end-if
 *>
     Move     WS-Copy-File-Name To WS-Hold-Copy-File-Name.
*>
*> Check for in "../../foo". clause (quotes have been removed) and think about replacing clause
*>
     if       WS-CRT-Copy-Lib-Found
              move     spaces to Arg-Test
              move     WS-Copy-File-Name to Hold-Word2
              string   Hold-Word1        delimited by space
                       OS-Delimiter      delimited by size
                       Hold-Word2        delimited by space into Arg-Test
              end-string
              move     Arg-Test to WS-Copy-File-Name
     end-if.                                        *> At this point we have content of Lib and filename
*>
 ba040-Open-CopyFile.
*>
     if we-are-testing
            display "ba040: CFN3 = " WS-Copy-File-Name
     end-if
*>
     perform  zz300-Open-file thru zz300-Exit.
     if       Return-Code = 24                                 *> RT 24 file table limit exceeded
              move spaces to PL-Text
              add  1      to WS-Error-Count
              string "*>> "
                      Msg21 into PL-Text
              end-string
              perform zz010-Write-Print-Line2
              go     to ba000-process
     end-if
     if       Return-Code = 23                                 *> RT 23 recursive copy filenames
              move spaces to PL-Text
              add 1 to WS-Error-Count
              string "*>>>* "
                          Msg32                                 delimited by size
                          WS-Copy-File-Name                     delimited by space
                         " - Above is IGNORED"                  delimited by size   into PL-Text
              end-string
              perform zz010-Write-Print-Line2
              go     to ba000-Process
     end-if
     if       Return-Code not = zero                           *> not found
      and     WS-CRT-Copy-Fname-Ext
              go to ba050-Try-CopyPaths                        *> no changes to FN
     end-if
     if       return-code = zero
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> We now are processing "
                         Fht-File-Name (Fht-Table-Size) into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              go to ba070-Print-Loop.
*>
*> Here for RT not zero
*>
     if       Return-Code = 26                            *> goto code to o/p msg22 and abandon this copylib
         and  WS-CRT-Copy-Lib-Found                           *>  as copy lib was included in COPY (IN | OF)
              go to  ba060-CopyPaths-End.
*>
 ba050-Try-CopyPaths.
     perform  varying x from 1 by 1 until x > No-Of-Copy-Dirs
              string Copy-Lib (x)           delimited by space
                     OS-Delimiter           delimited by size
                     WS-Hold-Copy-File-Name delimited by space into WS-Copy-File-Name
              end-string
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> We are looking for "
                         WS-Copy-File-Name (1:120) into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              perform  zz300-Open-file thru zz300-Exit
              if     Return-Code = zero
                     if we-are-testing2
                         move spaces to PL-Text
                         string "*>> We have found "
                                Fht-File-Name (Fht-Table-Size) (1:117) into PL-Text
                         end-string
                         perform zz010-Write-Print-Line2
                     end-if
                     exit perform
              end-if
     end-perform.
*>
 ba060-CopyPaths-End.
     if       Return-Code = 26                                 *> foo.ext not found (error 26)!
              add  1 to WS-Error-Count
              move spaces to PL-Text
              if   No-Printing
                   string "*>> "
                          Msg22 into PL-Text
                   end-string
              else
                   move   Msg22   to PL-Text
              end-if
     end-if
     if       Return-Code = 25                       *>'copy foo', NO .ext can be found on this copy lib path
              add  1 to WS-Error-Count                         *>    RT 25 - file not found
              move spaces to PL-Text
              if   No-Printing
                   string "*>> "
                          Msg27 into PL-Text
                   end-string
              else
                   move   Msg27   to PL-Text
              end-if
     end-if
     if       Return-Code not = zero
              perform zz010-Write-Print-Line2
              go     to ba000-process
     end-if.
*>
 ba070-Print-Loop.                                             *> process COPY lib source
*>
     move     WS-Free to Fht-Source-Format (Fht-Table-Size).   *> copy format to current table record
     go       to ba000-process.
*>
 ba999-Exit.
     exit     section.
*>
 bb000-Copy-Setup Section.
*>***********************
*>
*>   **********************************************************************
*>   * Here a ' copy ' word has now been found, we build Input-buffer     *
*>   *  containing the entire copy statement instead of reading over      *
*>   *  multiple source records.                                          *
*>   * While doing so we can set the found-Replacing flag.                *
*>   *    and other related fields so we can process the full copy        *
*>   *        statement in one hit.  Well thats the theory !!             *
*>   *                                                                    *
*>   *  Then return to main process loop to act on it having set index    *
*>   *  to point at next word after 'COPY '                               *
*>   *                       NOT SURE OF THIS BIT AT ALL!!                *
*>   *====================================================================*
*>   * As the standard is that ALL COPY statements end in a period, the   *
*>   * search will terminate on finding one at the end of a input record. *
*>   *                                                                    *
*>   **********************************************************************
*>
 bb000-Start.
*>
*>  Get rid of noise chars, eg tab, ; and , then pack it, replacing all continuous
*>    multi-spaces to only one
*>
     inspect  Input-Record replacing all x"09" by space   *> TAB
                                         X"0D" by space   *> CR
                                         x"00" by space   *> null
                                         " ; " by "   "
                                         " , " by "   "
                                         ": "  by "  "
                                         ", "  by "  ".
     move     zero to WS-P3 WS-P4.
     move     spaces to Temp-Input-Record.
     if       WS-Fixed-Set
              move 7 to WS-P5
     else
              move 1 to WS-P5
     end-if
*>
*>   WE ARE NOT (YET) SUPPORTING CONTINUE LINES WITH '&' or '-' in cc7 etc in copy statement
*>       or source but is there a real need ??
*>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
*>
     perform  varying WS-P3 from WS-P5 by 1 until WS-P3 > IR-Buffer-Data-Size
              if     IR-Buffer (WS-P3:1) = quote or "'"
                     add 1 to WS-P4
                     move IR-Buffer (WS-P3:1) to TIR (WS-P4:1)
                     perform forever
                            add   1 to WS-P3
                            add   1 to WS-P4
                            move  IR-Buffer (WS-P3:1) to TIR (WS-P4:1)
                            if    IR-Buffer (WS-P3:1) = quote or "'"
                                  add 1 to WS-P3
                                  exit perform
                            end-if
                            if    WS-P3 > IR-Buffer-Data-Size
                                  exit perform
                            end-if
                     end-perform
              end-if                                          *> Done quoted literals
              if     WS-P3 > IR-Buffer-Data-Size
                     exit perform
              end-if
              if     IR-Buffer (WS-P3:2) = "*>"
                     exit perform
              end-if
              if     WS-Fixed-Set
                and  WS-P3 = 7
                and  IR-Buffer (7:1) = "*"
                     exit perform
              end-if
              if     IR-Buffer (WS-P3:1) not = space
                     add    1 to WS-P4
                     move   IR-Buffer (WS-P3:1) to TIR (WS-P4:1)
              end-if
              if    IR-Buffer (WS-P3:1) = space
                    add 1 to WS-P4
                    add 1 to WS-P3
                    perform until IR-Buffer (WS-P3:1) not = space
                               or WS-P3 > IR-Buffer-Data-Size
                                  add 1 to WS-P3
                    end-perform
                    subtract 1 from WS-P3
              end-if
     end-perform
*>
*>  Now we have no excessive spaces
*>
     move     Temp-Input-Record to Input-Record.
     move     WS-P4 to IR-Buffer-Data-Size.
*>
 bb010-Start-Complete.
*>
     move     zero to IB-Size.
     perform  varying WS-P3 from 1 by 1 until WS-P3 > IR-Buffer-Data-Size
              if     function upper-case (IR-Buffer (WS-P3:5)) = "COPY "
                     set CRT-Copy-Found (CRT-Table-Size) to true
                     set CRT-Active (CRT-Table-Size)    to true
                     compute WS-P4 = IR-Buffer-Data-Size - (WS-P3 - 1)
                     add 1 to IB-Size
                     move IR-Buffer (WS-P3:WS-P4) to Input-Buffer (IB-Size:WS-P4)
                     add WS-P4  to IB-Size
                     subtract 1 from IB-Size
                     if  IR-Buffer (IR-Buffer-Data-Size:2) = ". "    *> End of Copy statement
                      or IR-Buffer (IR-Buffer-Data-Size - 1:2) = ". "
                      or Input-Buffer (IB-Size:1) = "."
                         go to bb030-Got-Full-Copy-Statement
                     end-if
                     exit perform
              end-if
     end-perform
     if       Fht-Eof (Fht-Table-Size)
              go to bb030-Got-Full-Copy-Statement.
*>
 bb020-Get-More-Copy.
*>
*> Now get rest of copy line 2 onwards
*>
     perform  zz600-Read-File thru zz600-Exit.
     if       Fht-Eof (Fht-Table-Size)                             *> Should not happen if copy end with '.'
              perform zz500-Close-File thru zz500-Exit
              if  Fht-Table-Size > zero
                  move CRT-Instance (CRT-Table-Size) to WS-CRT-Instance  *> restore active table
                  move CRT-Table-Size to WS-CRT-Active-Copy-Table
              else
                  initialize WS-CRT-Instance           *> THIS Should never happen as it means no more data
                  display Msg28                         *> for source file unless the user/programmer cocked up (no '.')!!
                  move spaces to PL-Text
                  if   No-Printing
                       if   WS-Free-Set
                            string "*>> "
                                   Msg28 into PL-Text
                            end-string
                       else
                            string "      ** "
                                   Msg28 into PL-Text
                            end-string
                       end-if
                  else
                       move Msg28  to PL-Text
                  end-if
                  perform zz010-Write-Print-Line2
                  go to ba999-Exit
              end-if
              if  WS-Fixed-Set                         *> Now to cover butt & make sure a '.' is in record
                  move "." to Input-Buffer (72:1)
              else
                  move "." to Input-Buffer (255:1)
              end-if
              go to bb030-Got-Full-Copy-Statement
     end-if
*>
     move     Fht-Current-Rec (Fht-Table-Size) to Input-Record.
     perform  da000-Check-For-Source.                  *> JIC >>source inside copy
     if       Fht-Free (Fht-Table-Size)
              set WS-Free-Set to true
     else
              set WS-Fixed-Set to true
     end-if
*>
*> Find size of source record (max = 255 as per specs) & start of source
*>
     perform  varying IR-Buffer-Data-Size from WS-End by -1
                      until  IR-Buffer (IR-Buffer-Data-Size:1) not = " "
                          or IR-Buffer-Data-Size < 2
     end-perform
     perform  varying IR-Buffer-Data-Size from IR-Buffer-Data-Size by -1
              until IR-Buffer (IR-Buffer-Data-Size:1) not = X"0D"
                                                  and not = X"00"
                          or IR-Buffer-Data-Size < 2
     end-perform
*>
     Move     Input-Record To PL-Text.
     perform  zz010-Write-Print-Line3.
*>
     perform  bb000-Start.                       *>  WE NEED TO CONSIDER CODE FOR Lit continuation (-) etc
     perform  varying WS-P3 from 1 by 1 until WS-P3 > IR-Buffer-Data-Size
                                           or IR-Buffer (WS-P3:2) = ". "
              if     function upper-case (IR-Buffer (WS-P3:3)) = "IN " or = "OF "
               or    function upper-case (IR-Buffer (WS-P3:9)) = "SUPPRESS "
               or    function upper-case (IR-Buffer (WS-P3:10)) = "REPLACING "
                     compute WS-P4 = IR-Buffer-Data-Size - (WS-P3 - 1)
                     add 2 to IB-Size                              *> leave a space before next chars
                     move IR-Buffer (WS-P3:WS-P4) to Input-Buffer (IB-Size:WS-P4)
                     add WS-P4 to IB-Size
                     if  IR-Buffer (IR-Buffer-Data-Size:2) = ". "  *> End of copy
                         go to bb030-Got-Full-Copy-Statement
                     end-if
                     exit perform
              end-if
              if     IR-Buffer (WS-P3:1) not = space
                     compute WS-P4 = IR-Buffer-Data-Size - (WS-P3 - 1)
                     add 2 to IB-Size
                     move IR-Buffer (WS-P3:WS-P4) to Input-Buffer (IB-Size:WS-P4)
                     add WS-P4 to IB-Size
                     if  IR-Buffer (IR-Buffer-Data-Size:2) = ". "   *> End of copy
                         go to bb030-Got-Full-Copy-Statement
                     end-if
                     exit perform
              end-if
     end-perform
     if       Fht-Eof (Fht-Table-Size)
              go to bb030-Got-Full-Copy-Statement.
     go       to bb020-Get-More-Copy.
*>
 bb030-Got-Full-Copy-Statement.
*>
*> Now process Copy buffer and store elements of it into CRT table for later processing
*>
     move     Input-Buffer to CRT-Copy-Statement (CRT-Table-Size).  *> NEEDED - not yet??
     move     IB-Size      to CRT-Copy-Length (CRT-Table-Size).
*>
     move     function upper-case (Input-Buffer) to CInput-Buffer.   *> 4 testing upper-case reserved words
     move     CRT-Instance (CRT-Table-Size) to WS-CRT-Instance.      *> copied 2 current copy area 4 easier working
*>
     perform  varying WS-P3 from 1 by 1 until WS-P3 not < IB-Size
                                           or CInput-Buffer (WS-P3:2) = ". "
              if      CInput-Buffer (WS-P3:1) = " "
                      exit perform cycle
              end-if
              if      CInput-Buffer (WS-P3:5)  = "COPY "
                      add 5 to WS-P3                                     *> now process copyfilename
                      perform varying WS-P3 from WS-P3 by 1              *> skip leading spaces
                                 until Input-Buffer (WS-P3:1) not = " "
                                    or WS-P3 not < IB-Size
                      end-perform
                      if      WS-P3 not < IB-Size
                              exit perform
                      end-if
                      move     zero  to WS-P20
                      move     spaces to WS-CRT-Copy-Filename
                      if       Input-Buffer (WS-P3:1) not = quote and not = "'"
                               unstring Input-Buffer
                                          delimited by ". " or " "   *> Will be getting word
                                            into WS-CRT-Copy-FileName
                                              delimiter Word-Delimit2
                                              count     WS-P20
                                              pointer   WS-P3
                               end-unstring
                               set  WS-CRT-Copy-Fname-Ext to false   *> may get changed in ba030+
                      else
                               add      1 to WS-P3             *> Skip quote
                               unstring Input-Buffer
                                          delimited by quote or "'"   *> Will be getting word ex quotes
                                            into WS-CRT-Copy-FileName
                                              delimiter Word-Delimit2
                                              count     WS-P20
                                              pointer   WS-P3
                               end-unstring
                               set  WS-CRT-Copy-Fname-Ext to true         *> set regardless so dont check for others
                      end-if
                        if We-Are-Testing4
                           move WS-P3 to ws-disp4
                           move WS-P20 to ws-disp3
                           display "In COPY we have fn = "
                                   WS-CRT-Copy-FileName (1:WS-P20) " Delim = " Word-Delimit2
                                   " pointer = " ws-disp4
                                   " count = "   ws-disp3
                                   " Buffer = " Input-Buffer (1:IB-Size)
                        end-if
 *>
                      if       Word-Delimit2 = quote or = "'"
                               set WS-CRT-Quote-Found to false          *> have removed the quote
                               move space to WS-CRT-Quote-Type
                      end-if
 *>
                      if We-Are-Testing
                           display "Found CopyFileName " WS-CRT-Copy-FileName
                                     " with " WS-CRT-Quote-Type " and " Word-Delimit2
                      end-if
*>
                      if       Word-Delimit2 = "."
                        or     Input-Buffer (WS-P3:1) = "."
                               exit perform
                      end-if
              end-if
              if      WS-P3 not < IB-Size
                      exit perform
              end-if
              if      CInput-Buffer (WS-P3:3) = "IN " or "OF "
                      add 3 to WS-P3
                      set WS-CRT-COPY-Lib-Found to true
                      if   CInput-Buffer (WS-P3:1) = "'" or quote
                           add 1 to WS-P3
                      end-if
                      unstring Input-Buffer delimited by space or "'" or quote      *> Use original
                                 into WS-CRT-Copy-Library
                                   pointer WS-P3
                      end-unstring
                      add 1 to WS-P3
 *>             else
 *>                     set WS-CRT-Copy-Lib-Found to false
              end-if
              if      CInput-Buffer (WS-P3:18) = " SUPPRESS PRINTING" *> so same as no print OF COPYLIB
                      set WS-CRT-Suppress to true                     *> NOT copy statement
                      add 18 to WS-P3
              end-if
              if      CInput-Buffer (WS-P3:17) = "SUPPRESS PRINTING"  *> so same as no print OF COPYLIB
                      set WS-CRT-Suppress to true                     *> NOT copy statement
                      add 17 to WS-P3
              end-if
              if      CInput-Buffer (WS-P3:9) = " SUPPRESS"           *> so same as no print OF COPYLIB
                      set WS-CRT-Suppress to true
                      add 9 to WS-P3
              end-if
              if      CInput-Buffer (WS-P3:8) = "SUPPRESS"            *> so same as no print OF COPYLIB
                      set WS-CRT-Suppress to true
                      add 8 to WS-P3
              end-if
              if      CInput-Buffer (WS-P3:10) = "REPLACING "
                      set   WS-CRT-Replace-Found to true
                      add   10 to WS-P3
              end-if
              if      CInput-Buffer (WS-P3:1) not = " "
                      add   1 to WS-CRT-Replacing-Count
                      if    CInput-Buffer (WS-P3:8) = "LEADING "
                            add 8 to WS-P3
                            set WS-CRT-Leading (WS-CRT-Replacing-Count) to true
                      end-if
                      if    CInput-Buffer (WS-P3:9) = "TRAILING "
                            add 9 to WS-P3
                            set WS-CRT-Trailing (WS-CRT-Replacing-Count) to true
                      end-if
                      if    Input-Buffer (WS-P3:2) = "=="
                            set WS-CRT-RT-Pseudo (WS-CRT-Replacing-Count) to true
                      else
                       if   Input-Buffer (WS-P3:1) = quote or = "'"
                            set WS-CRT-RT-Lit (WS-CRT-Replacing-Count) to true
                       else                                          *> covers programmer variable
                            set WS-CRT-RT-Else (WS-CRT-Replacing-Count) to true
                       end-if
                      end-if
                      if       Input-Buffer (WS-P3:2) = "=="
                               set WS-CRT-RT-Pseudo (WS-CRT-Replacing-Count) to true
                               add 2 to WS-P3
                               unstring Input-Buffer delimited by "=="
                                          into WS-CRT-Replacing-Source (WS-CRT-Replacing-Count)
                                             count   WS-CRT-Source-Size (WS-CRT-Replacing-Count)
                                             pointer WS-P3
                               end-unstring
                               add 1 to WS-P3             *> bypass space
                       else
                               unstring Input-Buffer delimited by space       *> Use original
                                          into WS-CRT-Replacing-Source (WS-CRT-Replacing-Count)
                                             count   WS-CRT-Source-Size (WS-CRT-Replacing-Count)
                                             pointer WS-P3
                               end-unstring
                      end-if
                      if  we-are-testing3
                          move spaces to formatted-line
                          move ws-crt-source-size (ws-crt-replacing-count) to ws-disp3
                          string "*>>ES count="
                                 ws-disp3
                                 " for = "
                                 WS-CRT-Replacing-Source (WS-CRT-Replacing-Count)
                                     into Formatted-Line
                          end-string
                          write formatted-line
                      end-if
                      perform  varying ws-P3 from Ws-P3 by 1 until Input-Buffer (WS-P3:1) not = " "
                                                               or WS-P3 not < IB-Size
                      end-perform
                      if       WS-P3 not < IB-Size                           *> chgd 28/2/19
                               exit perform cycle
                      end-if
                      if       CInput-Buffer (WS-P3:3) = "BY "                *> chgd 28/2/19
                               add 3 to WS-P3
                      end-if
                      perform  varying ws-P3 from Ws-P3 by 1 until Input-Buffer (WS-P3:1) not = " "
                                                               or  WS-P3 not < IB-Size
                      end-perform
                      if       Input-Buffer (WS-P3:2) = "=="
                               add 2 to WS-P3
                               move spaces to WS-CRT-Replacing-Target (WS-CRT-Replacing-Count)
                               unstring Input-Buffer delimited by "=="
                                          into WS-CRT-Replacing-Target (WS-CRT-Replacing-Count)
                                             delimiter Word-Delimit2
                                             count     WS-CRT-Target-Size (WS-CRT-Replacing-Count)
                                             pointer   WS-P3
                               end-unstring              *> next is period or space
                      else
                               move spaces to WS-CRT-Replacing-Target (WS-CRT-Replacing-Count)
                               unstring Input-Buffer delimited by space or "."
                                          into WS-CRT-Replacing-Target (WS-CRT-Replacing-Count)
                                             delimiter Word-Delimit2
                                             count     WS-CRT-Target-Size (WS-CRT-Replacing-Count)
                                             pointer   WS-P3
                               end-unstring               *> next is END or new repl.
                      end-if
                      if  we-are-testing3
                          move spaces to formatted-line
                          move ws-crt-Target-size (ws-crt-replacing-count) to ws-disp3
                          string "*>>ET count="
                                 ws-disp3
                                 " for = "
                                 WS-CRT-Replacing-target (WS-CRT-Replacing-Count)
                                 " delim = "
                                 Word-Delimit2
                                     into Formatted-Line
                          end-string
                          write formatted-line
                      end-if
              end-if
              if      Input-Buffer (WS-P3:1) not = " "
                      subtract 1 from WS-P3                  *> perform will add 1 so will miss a char
              end-if                                         *> if last not pseudo
     end-perform.
*>
 bb040-Clean-Up.
     move     WS-CRT-Instance to CRT-Instance (CRT-Table-Size).     *> copied to current copy area
*>
     if       We-Are-Testing3    *> Print the COPY statement from copy buffer in FULL
       and    WS-CRT-Active
              perform varying WS-P4 from 1 by 160 until WS-P4 > WS-CRT-Copy-Length
                       move spaces to Formatted-Line
                       string "*>>> "
                             WS-CRT-Copy-Statement (ws-P4:160) into Formatted-Line
                       write Formatted-Line
              end-perform
              move    spaces to Formatted-Line
              string  "*>>> "
                    WS-CRT-Copy-FileName  into Formatted-Line
              write Formatted-Line
              move    spaces to Formatted-Line
              move    WS-CRT-Replacing-Count  to WS-Disp2
              string  "*>>> "
                 "CP Fnd = "
                  WS-CRT-Copy-Found-Flag
                  " Rep Fnd = "
                  WS-CRT-Replace-Found-Flag
                  " QoT Fnd = "
                  WS-CRT-Quote-Found-Flag
                  " QoT Typ = "
                  WS-CRT-Quote-Type
                  " Lit Fnd = "
                  WS-CRT-Literal-Found-Flag
                  " Cont Fnd = "
                  WS-CRT-Continue-Flag
                  " Sup Flag = "
                  WS-CRT-Suppress-Flag
                  " Repl Cnt = "
                  WS-Disp2          into Formatted-Line
              write Formatted-Line
              if      WS-CRT-Copy-Lib-Found
                      move    spaces to Formatted-Line
                      string   "*>>> IN/OF = "
                               WS-CRT-Copy-Library into Formatted-Line
                      write Formatted-Line
              end-if
              perform varying WS-P4 from 1 by 1 until WS-P4 > WS-CRT-Replacing-Count
                      move    spaces to Formatted-Line
                      move 1 to xx
                      move  WS-P4   to WS-Disp
                      string "*>>> "
                             "Rep "
                        WS-Disp
                        " Lead Fnd = "
                        WS-CRT-Leading-Flag (WS-P4)
                        " Tral Fnd = "
                        WS-CRT-Trailing-Flag (WS-P4)
                        " Rep Type = "               into Formatted-Line
                                                       pointer xx
                      end-string
                      if   WS-CRT-RT-Lit (WS-P4)
                           string "Lit"   into Formatted-Line pointer xx
                      else
                       if  WS-CRT-RT-Pseudo (WS-P4)
                           string "Pse" into Formatted-Line pointer xx         *>  (46:3)
                       else
                        if WS-CRT-RT-Else (WS-P4)
                           string "Els" into Formatted-Line   pointer xx    *> (46:3)
                        else
                           string "Ops" into Formatted-Line pointer xx      *>  (46:3)
                        end-if
                       end-if
                      end-if
                      move  WS-CRT-Source-Size (WS-P4) to WS-Disp2
                      string  " Src size = "                                *> into Formatted-Line (49:12)
                              WS-Disp2                                      *> to Formatted-Line (61:3)
                             " Tgt size = " into Formatted-Line pointer xx  *> (64:12)
                      move  WS-CRT-Target-Size (WS-P4) to WS-Disp2
                      string  WS-Disp2  into Formatted-Line pointer xx      *> (76:3)
                      write Formatted-Line
                      move    spaces to Formatted-Line
                      string  "*>>>Src "
                               WS-CRT-Replacing-Source  (WS-P4) (1:160) into Formatted-Line
                      write Formatted-Line
                      move  spaces to Formatted-Line
                      string "*>>>Tgt "
                             WS-CRT-Replacing-Target  (WS-P4) (1:160) into Formatted-Line
                      write Formatted-Line
              end-perform
     end-if
*>
*> Now we have dumped out the copy statement from source, concatenated source
*>       and as broken down in table.
*>
     go to bb000-Exit.
*>
 bb000-Exit.
     exit     section.
*>
 bc000-Test-For-Missing-Replace Section.
*>*************************************
*>
*>  We have CLOSED the file and table-size is now 1 less, so ...
*>
*>  WARNING IF DEBUG ON, NEXT LINE WILL FAIL !!!
*>
     move CRT-Instance (Fht-Table-Size + 1) to WS-CRT-Instance.    *> copy file closed so sames as fht ???
     if       WS-CRT-Replacing-Count = zero
              go to bc999-Exit.
     perform  varying WS-P11 from 1 by 1 until WS-P11 > WS-CRT-Replacing-Count
                                            or WS-CRT-Replacing-Count > CRT-Replace-Arguments-Size
*>              if       WS-CRT-Leading (WS-P11)
*>                or     WS-CRT-Trailing (WS-P11)
*>                       exit perform cycle
*>              end-if
              if       WS-CRT-Found-Src (WS-P11) = zero
                       move spaces to PL-Text
                       if   No-Printing
                            string "*>>W "
                                   Msg29 into PL-Text
                            end-string
                       else
                            move   Msg29   to PL-Text
                       end-if
                       perform zz010-Write-Print-Line2
                       add 1 to WS-Caution-Count
                       exit perform
              end-if
     end-perform.
*>
 bc999-Exit.
     exit     section.
*>
 bd000-Test-For-Messages Section.
*>******************************
*>
     move spaces to Formatted-Line.
     move  7 to a.
     string   "*>>>Info: Total Copy Depth Used = " delimited by size
              Max-Copy-Depth                    delimited by size
                      into Formatted-Line pointer a.
     if       WS-Error-Count > zero
              move WS-Error-Count  to WS-Disp2
              string  ";  Files not Found = "   delimited by size
                      WS-Disp2                  delimited by size
                           into Formatted-Line pointer a
              end-string
     end-if
     if       WS-Caution-Count > zero
              move    WS-Caution-Count to WS-Disp2
              string  ";  Caution messages issued = " delimited by size
                      WS-Disp2                  delimited by size
                           into Formatted-Line pointer a
              end-string
     end-if
     write    Formatted-Line.
*>
 bd999-Exit.
     Exit     Section.
*>
 ca000-End-of-Job Section.
*>***********************
*>
     close    print-file.
     exit     section.
*>
 da000-Check-For-Source section.
*>*****************************
*>
*> Check for existance of >>SOURCE in line at cc8 and if found looks
*> for FREE or FIXED, then changes free/fixed mode for the current file
*>      in Input-Record
*>
     move     zero to WS-P7
                      WS-P8.
     move     function upper-case (Input-Record) to Temp-Input-Record.
     if       Temp-Input-Record (8:8) not = ">>SOURCE"
              go to da000-Exit.
*> DISPLAY "Found >>SOURCE as " Temp-input-record (8:48) end-display
     inspect  Temp-Input-Record tallying WS-P7 for all "FREE".
     inspect  Temp-Input-Record tallying WS-P8 for all "FIXED".
     if       WS-P8 > zero
              set Fht-Fixed (Fht-Table-Size) to true
              move 72   to WS-End
*>           DISPLAY " Setting fixed"
     end-if
     if       WS-P7 > zero
              set  Fht-Free (Fht-Table-Size) to true
              move 256  to WS-End
*>           DISPLAY " Setting free"
     end-if
     move     zero to WS-P7 WS-P8.
*>
 da000-Exit.
     exit     section.
*>
 zz010-Write-Print-Line1 Section.
*>******************************
*>
*> These 3 changed for xref as always no-printing
*>
     perform  zz030-Test-For-Copy.
     if       WS-P6 not = zero                           *>  Got a COPY verb
              move PL-Text to Formatted-Line             *>    if then if does not always work
              if  WS-Fixed-Set
                  move PL-Text to Formatted-Line
                  move "*" to Formatted-Line (7:1)
              else
                  move spaces to Formatted-Line
                  string "*>C "    delimited by size
                           PL-Text delimited by size into Formatted-Line
                  end-string
              end-if
     else
              move  PL-Text to Formatted-Line
     end-if
     write    Formatted-Line.
     move     zero to WS-P6.
*>
 zz010-Check-for-Extended-Record section.
*>**************************************
*>
*> We could have a replace exceeding fixed length.
*>  so need to write out shorter blocks for Fixed (cc72)
*>
*> Programmer notes:
*>  Temp-Record is 1024 bytes.
*> Input-Record and IR-Buffer is 256.
*> PL-Text & PL-Text2 is 248.
*>
 *>  done before entering zz010-Check
     if       not WS-We-Have-Replaced                        *> Nope
              perform zz010-Write-Print-Line1
              go to zz010-Exit1.                      *>  not the best way for testing but should work
*>
     perform  varying WS-P21 from 255 by -1              *> get size of Input-Record
                  until Input-Record (WS-P21:1) not = space
     end-perform.
 *>    move   WS-P21 to ws-disp3.
 *>    display "IR size = " ws-disp3.
*>
     move     space to WS-Quote-Used.
     set      WS-Need-Leading-Quote to false.
     move     1     to WS-P30.                        *> temp-rec pointer
     move     69  to WS-P25.                          *> DEFAULTS - allows to add '" &' cc70 then quote on new line
     move     12  to WS-P29.                          *> DEFAULTS - FIXED pl-text  pointer
*>
     if       WS-Free-Set                             *> set starting point for target presets
              move      2  to WS-P29
              move    115  to WS-P25                  *> max length for O/P
     end-if
     move     WS-P29   to WS-P19.
*>
     move     zero   to WS-P27.                       *> holds count of quotes in current o/p line
     move     spaces to PL-Text.                      *> but use this one
 *>      display  "IR = " Input-Record (1:WS-P21).
*>
*> 1st skip leading spaces as we will position output
*>
     perform  varying WS-P30 from 1 by 1
               until Input-Record (WS-P30:1) not = space
     end-perform.
 *>      display "IR2 = " Input-Record (WS-P30:WS-P21 - (WS-P30 - 1)).
     perform  test after varying WS-P30 from WS-P30 by 1   *> WS-P30 by 1
                until WS-P30 > WS-P21             *> data length in i/p field
*>
              if       WS-P19 = WS-P29                *> for rec 2 onwards is there a odd quote
                 and   WS-Need-Leading-Quote
                       move    WS-Quote-Used to PL-Text (WS-P19:1)
                       add     1         to WS-P19
                       set     WS-Need-Leading-Quote to false
              end-if
*>
              move     Input-Record (WS-P30:1) to PL-Text (WS-P19:1)
              if       Input-Record (WS-P30:1) = quote or = "'"
                       add   1 to WS-P27
                       move  Input-Record (WS-P30:1) to WS-Quote-Used   *> Track last quote type used
              end-if
*>
*>  Test for end of current replacing text line signalled by 2 spaces
*>
              subtract 1 from WS-P30 giving WS-P40
              if       WS-P27 not = zero
                       divide  2 into WS-P27 giving WS-P16 remainder WS-P28
              else
                       move zero to WS-P28
              end-if
              if       WS-P19 > WS-P29
                and    WS-P40 > zero
                and    Input-Record (WS-P40:2) = "  "       *> test for end of replace line within block
                 and   WS-P28 = zero
 *>                      display "divide > " PL-Text (1:WS-P19)
                       perform zz010-Write-Print-Line1
                       move     spaces to PL-Text
                       move     WS-P29 to WS-P19
                       move     zero   to WS-P27
                       exit perform cycle
              end-if
*>
*> Test for Src end of text and PL-Text has text
*>
              if       WS-P30 not < WS-P21            *> current Src data ptr,  data rec size
                and    WS-P19 > WS-P29                *> data in pl-text
 *>                        display "Src EoT> " PL-Text (1:50)
                       perform zz010-Write-Print-Line1
                       move     spaces to PL-Text
                       move     WS-P29 to WS-P19
                       move     zero   to WS-P27
                       exit perform cycle
              end-if
*>
*> Test for PL-Text data ptr < max data length in pl-text & Src data ptr < data rec size
*>
              if       WS-P19 < WS-P25
                 and   WS-P30 < WS-P21
                       add      1 to WS-P19
                       exit perform cycle             *> go move another
              end-if
*>
*> Test for PL-Text data ptr not < max data length in pl-text
*>           OR Src data ptr not < data rec size
*>
              if       WS-P19 not < WS-P25            *> end of max data allowed  for target
                       divide  2 into WS-P27 giving WS-P16 remainder WS-P28
                       if      WS-P28 not = zero      *> odd quotes and this applies to
                                                      *> the NEXT record not this one
                               set WS-Need-Leading-Quote to true
                               add   1 to WS-P19
                               string WS-Quote-Used delimited size
                                      " &"          delimited size
                                        into PL-Text (WS-P19:3)
                               end-string
                       else
                               set WS-Need-Leading-Quote to false
                       end-if
 *>             if       WS-P30 not < WS-P21            *> end of src data ?
 *>
 *>                      if  PL-Text not = spaces
 *>                          perform  zz010-Write-Print-Line1
 *>                          move     spaces to PL-Text
 *>                          move     WS-P29   to WS-P19
 *>                          move zero to WS-P27
 *>                          exit perform cycle
 *>                      end-if
 *>             end-if
              end-if
              add      1 to WS-P19
     end-perform.
     if       WS-P19 > WS-P29
          if  PL-Text (1:40) not = spaces
              perform    zz010-Write-Print-Line1
              move     spaces to PL-Text
          end-if
     end-if.
*>
 zz010-Exit1.
     exit section.
*>
 zz010-Write-Print-Line2 Section.
*>******************************
*>
     move     PL-Text to Formatted-Line.
     write    Formatted-Line.
*>
 zz010-Write-Print-Line3 Section.
*>******************************
*>
*> Only called when processing a COPY statements sub-clauses
*>
     if       WS-Fixed-Set
              move PL-Text to Formatted-Line
              move "*" to Formatted-Line (7:1)
     else
              move spaces to Formatted-Line
              string "*>C "     delimited by size
                      PL-Text delimited by size into Formatted-Line
              end-string
     end-if
     write Formatted-Line.
*>
 zz020-Get-Program-Args     section.
*>*********************************
*>
 zz020a-start.
*>
*> Get Env. Variables
*>
*> Changes here for cobxref.
*>
     accept   Cobcpy        from Environment "COBCPY".
     accept   Cob_Copy_Dir  from Environment "COB_COPY_DIR".
 *>
     if       Cobcpy = Cob_Copy_Dir
              move spaces to Cob_Copy_Dir
     end-if
*>
     move     LS-Source-File to WS-Input-File-Name.
     if       LS-SW-Free
              set ws-free-set to true
     else
              set ws-fixed-set to true
     end-if
*>
*> Testing only
*>
     if       LS-Verbose-Output
              set We-Are-Testing to true
     end-if
*>
     string   LS-Prog-BaseName delimited by space
              ".pro"           delimited by space
                  into  WS-Print-File-Name.
*>
 zz020-Bypass-Args.
     call    "CBL_GET_CURRENT_DIR" using by value 0
                                         by value 512
                                         by reference Arg-Test
     end-call
     if       Return-Code not zero
              move    return-code to WS-Disp3
              display Msg31 " " WS-Disp3
              move zero to z
     else
              move 5 to z
     end-if
     perform  zz020d-Process-CopyLibs thru zz020f-Get-CobCopyDir.
     move     zero to x z.
*>
 zz020c-Disp-Data.
     if       not We-Are-Testing
              move   zero to x y z
              go     to zz020-exit.
     display  " Program Args found:".
     display  "Input  = " WS-Input-File-Name.
     display  "Output = " WS-Print-File-Name.
     display  "Format = " no advancing.
     if       ws-Fixed-Set
              display "Fixed"
     else
      if      ws-free-set
              display "Free"
      end-if
     end-if.
     display  "Copy Libraries to search:".
     move     No-Of-Copy-Dirs to y.
     perform  varying z from 1 by 1 until z > No-Of-Copy-Dirs
              move Copy-Lib (z) to Arg-Test
              display z "/" y " " Arg-Test (1:72)   *> restrict total display line to 79 (stops wrapping)
     end-perform.
     display  " ".
     move     zero to x y z.
     go       to zz020-exit.
*>
 zz020d-Process-CopyLibs.
*>
*> If arg 5 exists, it will supersede values from COBCPY / COB_COPY_DIR
*>  as 1ist path
*>
     initialize Copy-Dirs-Block.
     move     zero to No-Of-Copy-Dirs.
     move     "Z" to Uns-Delimiter.
     if       z not = 5
              go to zz020e-get-cobcpy  *> skip P4 procesing
     end-if
*>
     move 1 to x.
     perform  forever
              if    Uns-Delimiter = " "
               or   x > 498
               or   No-Of-Copy-Dirs > 9
                    exit perform
              end-if
              add   1 to No-Of-Copy-Dirs
              unstring Arg-Test delimited by ":" or " " into Copy-Lib (No-Of-Copy-Dirs)
                              delimiter Uns-Delimiter
                              pointer   x
              end-unstring
     end-perform
     move     "Z" to Uns-Delimiter.
*>
 zz020e-Get-CobCpy.
*>
*> Done P5, now do Env Vars
*>
     if       Cobcpy (1:1) not = " "
              move 1 to x
              perform forever
                      if   Uns-Delimiter = " "
                       or  x > 498
                       or  No-Of-Copy-Dirs > 9
                           exit perform
                      end-if
                      add  1 to No-Of-Copy-Dirs
                      unstring Cobcpy   delimited by ":" or " "  into Copy-Lib (No-Of-Copy-Dirs)
                                   delimiter Uns-Delimiter
                                   pointer   x
                      end-unstring
              end-perform
     end-if
     move     "Z" to Uns-Delimiter.
*>
 zz020f-Get-CobCopyDir.
     if       cob_copy_dir (1:1) not = " "
              move 1 to x
              perform forever
                    if   Uns-Delimiter = " "
                     or  x > 498
                     or  No-Of-Copy-Dirs > 9
                         exit perform
                    end-if
                    add  1 to No-Of-Copy-Dirs
                    unstring Cob_Copy_Dir delimited by ":" or " " into Copy-Lib (No-Of-Copy-Dirs)
                                 delimiter Uns-Delimiter
                                 pointer   x
                    end-unstring
              end-perform
     end-if.
*>
 zz020-Exit.
     exit     section.
*>
 zz030-Test-For-Copy section.
     move     zero to WS-P6.                         *> non zero indicates copy statement present
     if       not No-Printing
              go to zz030-Exit.
     if       (WS-Fixed-Set and IR-Buffer (7:1) = "*")
         or   (WS-Fixed-Set and IR-Buffer (7:1) = "-")                  *> Literal
         or   (WS-Fixed-Set and (IR-Buffer (7:1) = "D" or = "d"))     *> Debug with COPY  ????
         or   (WS-Free-Set and IR-Buffer (1:2) = "*>")                  *> >>D (free) is processed.
         or   (ws-Free-Set and IR-Buffer (2:2) = "*>")
         or   (WS-Free-Set and IR-Buffer (1:1) = "$")
         or   (WS-Free-Set and IR-Buffer (1:1) = "#")
              go to zz030-Exit.
     inspect  function upper-case (IR-Buffer) tallying WS-P6 for all "COPY ".
     if       WS-P6 = zero
              go to zz030-Exit.
*>
*> We have a COPY?   [ WS-P1 = 1 or 7 ( free or fixed format )
*>
     set      Found-Word   to false.
     set      Found-Number to false.
*>
     perform  varying WS-P6 from 1 by 1 until WS-P6 > IR-Buffer-Data-Size - 7
              if       IR-Buffer (WS-P6:2) = "*>"      *> found comment before COPY
                       move zero to WS-P6
                       exit perform
              end-if
              if       NOT Found-Number and Found-Word
                and    function upper-case (IR-Buffer (WS-P6:6)) = " COPY "
  *>              or     (WS-P1 = 1                                         *> Free format
  *>                 and function upper-case (IR-Buffer (1:5)) = "COPY ")   *> chg 25/2/19
                       move zero to WS-P6
                       exit perform
              end-if
              if       IR-Buffer (WS-P6:1) = quote or "'"
                       add 1 to WS-P6
                       perform varying WS-P6 from WS-P6 by 1 until IR-Buffer (WS-P6:1) = quote
                                                                or = "'"
                                                                or WS-P6 > IR-Buffer-Data-Size - 7
                       end-perform                     *> loose the literal or line
                       if   WS-P6 > IR-Buffer-Data-Size - 7
                            move zero to WS-P6
                            exit perform
                       end-if
              end-if
              if       function upper-case (IR-Buffer (WS-P6:6)) = " COPY "
                       exit perform
              end-if
              if       WS-P1 = 1 and function upper-case (IR-Buffer (1:5)) = "COPY "
                       exit perform
              end-if
              move     IR-Buffer (WS-P6:1) to WS-Number-Test
              if       WS-Number numeric
                       set Found-Number to true
              end-if
              if       WS-Number-Test is Alphabetic
                 and   WS-Number-Test not = space
                       set Found-Word   to true
              end-if
     end-perform.
*>
 zz030-Exit.
     exit section.
*>
 zz300-Copy-Control Section.
*>*************************
*>=======================================================================
*>
*> zz300, zz400, zz500 & zz600 all relate to copy files/libraries via the COPY verb
*>
*>  this code allows for 9 levels of COPY, plus source file
*>
 zz300-Open-File.
*>**************
*> Open a Copy file using CBL-OPEN-File
*>  filename is using Cbl-File-name
*>
     move     zero to Return-Code.
     if       Fht-Table-Size not < Fht-Max-Table-Size            *> 10
              move 24 to Return-Code                             *> RT 24 file table limit exceeded
              display Msg21
              go to zz300-Exit
     end-if
*>
*>   First test that we do NOT have duplicate copy's (within copy's)
*>
     if       Fht-Table-Size not = zero
              perform  varying fn from 1 by 1 until fn > Fht-Table-Size
                       if    Fht-File-Name (fn) = WS-Copy-File-Name
                             move 23 to Return-Code              *> RT 23 recursive copy filenames
                             go to zz300-Exit                    *> Prevents dead lock in prtcbl
                       end-if
              end-perform
     end-if
*>
*> set up New entry in File Table
*>
     add      1 to Fht-Table-Size.
     move     Fht-Table-Size to e.
     initialize Fht-Var-Block (e).
     move     Fht-Buffer-Size  to   Fht-Byte-Count (e).
     move     spaces to Fht-Current-Rec (e)
                        Fht-Buffer (e).
     move     1      to Fht-pointer (e).
*>
     perform  zz400-Check-File-Exists thru zz400-Exit.
     if       Return-Code not = zero             *> Could have 26, 25, 35 = no file found
                                                 *> 24 = table exceeded or another?
              subtract 1 from Fht-Table-Size
              go to zz300-Exit.
*>
     move     Fht-Table-Size to e.               *> just in case its been altered or used etc
     move     Cbl-File-Size to Fht-File-Size (e).
     move     Cbl-File-Name to Fht-File-Name (e).
     move     1    to Cbl-Access-Mode
                      Cbl-Deny-Mode.             *> deny write
     move     zero to Cbl-Device
                      Cbl-File-Handle.
     move     zero to Return-Code.
     call     "CBL_OPEN_FILE" using
              Cbl-File-name
              Cbl-Access-Mode
              Cbl-Deny-Mode
              Cbl-Device
              Cbl-File-Handle
     end-call
     if       Return-Code not = zero
              display Msg23 cbl-File-name (1:59)
              display "zz300 - This should not happen here"
              subtract 1 from Fht-Table-Size
              go to zz300-exit
     end-if
*>
     move     Cbl-File-Handle to Fht-File-Handle (e).
     add      1 to Copy-Depth.
     if       Copy-Depth > Max-Copy-Depth           *> Keep track of how deep we went!
              move Copy-Depth to Max-Copy-Depth.
 zz300-Exit.
     exit.
*>
 zz400-Check-File-Exists.
*>
*> Check for correct filename and extention, taken from COPY verb
*>
*>  Input : WS-Copy-File-Name     ( A copy lib path could precede FN )
*> Output : Return-Code = 0  :    Cbl-File-Details & Cbl-File-name
*>          Return-Code = 25/26 : Failed fn in WS-Copy-File-Name
*>
     move     99 to Return-Code.
     move     zero to f.
     inspect  WS-Copy-File-Name tallying f for all ".".
     if       f not = zero                           *> We have 'copy foo.ext' or 'copy path/foo.ext'
        or    No-Search
              go to zz400-Try1
     end-if
     perform  varying a from 1 by 1  until Return-Code = zero
                                      or a > Ext-Table-Size
              move   spaces to Cbl-File-name
              string WS-Copy-File-Name delimited by space
                     File-Ext (a)      delimited by size into Cbl-File-name
              end-string
              move   zero to Return-Code
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> Checking for "
                         Cbl-File-Name into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              call   "CBL_CHECK_FILE_EXIST" using
                                            Cbl-File-name
                                            Cbl-File-Details
              end-call
              if   Return-Code not = zero
               and a = Ext-Table-Size                           *> error 35 (well it should be)
                     exit perform                               *> and we tried all combinations
              end-if
     end-perform
     if       Return-Code not = zero    *> On, 'copy foo', NO .ext can be found on this copy lib path
              move 25 to Return-Code                            *> RT 25 - file not found
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> Not found "
                         Cbl-File-Name into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              go to zz400-Exit
     end-if
*>                                                                 OK, file now found
     go       to zz400-Exit.
*>
 zz400-Try1.
*>
*> We have 'copy foo.ext' or 'copy path/foo.ext' OR it could be the main source file
*>
     move     WS-Copy-File-Name to Cbl-File-Name.
     move     zero to Return-Code.
     call     "CBL_CHECK_FILE_EXIST" using
              Cbl-File-name
              Cbl-File-Details
     end-call
     if       Return-Code not = zero
              move 26 to Return-Code             *> foo.ext not found (error 26)!
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> We cant find "
                         Cbl-File-Name into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              go to zz400-Exit.
*>
*> OK, file now found
*>
        if we-are-testing2
            move spaces to PL-Text
            string "*>>> We have found "
                   Cbl-File-Name into PL-Text
            end-string
            perform zz010-Write-Print-Line2
        end-if.
*>
 zz400-Exit.  exit.
*>
 zz500-Close-File.
     call     "CBL_CLOSE_FILE" using Fht-File-Handle (Fht-Table-Size).
     if       Return-Code not = zero
              move return-code to WS-Disp3
              display Msg24 WS-Disp3
              display " on " Fht-File-Name (Fht-Table-Size)
     end-if
     subtract 1 from Fht-Table-Size.
*>
     subtract 1 from Copy-Depth.
     move     zero to Return-Code.
     go       to zz500-Exit.
*>
 zz500-Exit.  exit.
*>
 zz600-Read-File.
*>**************
*> Called using file-handle returning  Fht-Current-Rec (Fht-Table-Size)
*>
*> If buffer enpty read a block and regardless,
*>     move record terminated by x"0a" to Fht-Current-Rec (Fht-Table-Size)
*>
     if       Fht-Eof (Fht-Table-Size) and Fht-Block-Eof (Fht-Table-Size)
*>              perform zz500-Close-File thru zz500-Exit
              go to zz600-Exit.
*>
     if       Fht-File-OffSet (Fht-Table-Size) = zero
         and  Fht-Block-OffSet (Fht-Table-Size) = zero
              perform zz600-Read-A-Block thru zz600-Read-A-Block-Exit
              if      Return-Code = -1 or = 10
                      set Fht-Block-Eof (Fht-Table-Size) to true
                      go to zz600-Exit
              end-if
              go to zz600-Get-A-Record.
*>
 zz600-Get-A-Record.
*>*****************
*> Now to extract a record from buffer and if needed read a block
*>         then extract
*>
     if       Fht-Eof (Fht-Table-Size)
         and  Fht-Block-Eof (Fht-Table-Size)
              go to zz600-Exit.
*>
     move     spaces to Fht-Current-Rec (Fht-Table-Size).
     add      1 to Fht-Block-OffSet (Fht-Table-Size) giving g.
*>
*> note size is buffer size + 1
*>
     unstring Fht-Buffer (Fht-Table-Size) (1:Fht-Buffer-Size + 1)
                delimited by x"0A" or x"FF"
                into         Fht-Current-Rec (Fht-Table-Size)
                delimiter    Word-Delimit
                pointer      g.
*>
*> Get next Block of data ?
*>
     if       Word-Delimit = x"FF"
          and g not <  Fht-Buffer-Size + 1
              add Fht-Block-OffSet (Fht-Table-Size) to Fht-File-OffSet (Fht-Table-Size)
              perform zz600-Read-A-Block thru zz600-Read-A-Block-Exit
              if      Return-Code = -1 or Fht-Block-Eof (Fht-Table-Size)
                      set Fht-Eof (Fht-Table-Size) to true
                      if we-are-testing2
                         move spaces to PL-Text
                         string "*>> Blk/Rec EOF on "
                                Fht-File-Name (Fht-Table-Size) into PL-Text
                         end-string
                         perform zz010-Write-Print-Line2
                      end-if
                      go to zz600-Exit
              end-if
              go to zz600-Get-A-Record.
*> EOF?
     move     1 to Fht-Pointer (Fht-Table-Size).
     if       Word-Delimit = x"FF"
              set Fht-Eof (Fht-Table-Size) to true
              go to zz600-Exit.
*> So. now tidy up
     subtract 1 from g giving Fht-Block-OffSet (Fht-Table-Size).
     go       to zz600-exit.
*>
 zz600-Read-A-Block.
*>*****************
     if       Fht-Block-Eof (Fht-Table-Size)
*>              set Fht-Eof (Fht-Table-Size) to true
              go to zz600-Read-A-Block-Exit.
     move     all x"FF" to Fht-Buffer (Fht-Table-Size).  *> next 2 put back
     if       Fht-File-Size (Fht-Table-Size) < Fht-Byte-Count (Fht-Table-Size) and not = zero   *> 4096
              move Fht-File-Size (Fht-Table-Size) to Fht-Byte-Count (Fht-Table-Size).
*>
     call     "CBL_READ_FILE" using
              Fht-File-Handle (Fht-Table-Size)
              Fht-File-OffSet (Fht-Table-Size)
              Fht-Byte-Count (Fht-Table-Size)
              Cbl-Flags
              Fht-Buffer (Fht-Table-Size)
     end-call
     if       Return-Code = -1 or = 10
              set Fht-Block-Eof (Fht-Table-Size) to true
              if we-are-testing2
                  move spaces to PL-Text
                  string "*>> Blk EOF on "
                         Fht-File-Name (Fht-Table-Size) into PL-Text
                  end-string
                  perform zz010-Write-Print-Line2
              end-if
              go to zz600-Read-A-Block-Exit
     end-if
     if       Return-Code not = zero              *> Could be indicating EOF (-1 ? )
              set Fht-Block-Eof (Fht-Table-Size) to true
              move Return-Code to WS-Disp3
              move spaces to PL-Text
              if   No-Printing
                   string "*>>P "
                          Msg25
                          WS-Disp3 into PL-Text
                   end-string
              else
                   string Msg25
                          WS-Disp3 into PL-Text
                   end-string
              end-if
              perform zz010-Write-Print-Line2
              go to zz600-Read-A-Block-Exit
     end-if
*> just in case all ff does not work
     move     x"FF" to Fht-Buffer (Fht-Table-Size) (Fht-Buffer-Size + 1:1)
     move     zero to Fht-Block-OffSet (Fht-Table-Size).
     subtract Fht-Byte-Count (Fht-Table-Size) from Fht-File-Size (Fht-Table-Size).
*>
 zz600-Read-A-Block-Exit.
     exit.
*>
 zz600-Exit.  exit.
*>
 zz900-Process-Replace  Section.
*>*****************************
*>
*> Now we have read a RECORD first check if table < 2 (not a copylib)
*>  and check if active copy (active-table) has replacing active!
*>   IR-Buffer-Data-Size  contains size of record
*>
     move     spaces to Temp-Record.
     set      WS-We-Have-Replaced to false.
*>
     if       CRT-Table-Size < 1
              go to zz900-Exit.
     if       Fht-Table-Size > 1
              move CRT-Instance (Fht-Table-Size - 1) to WS-CRT-Instance
     else
              go to zz900-Exit
     end-if
     if       not WS-CRT-Replace-Found
              go to zz900-Exit.
*>
*> Process one at a time, Cannot see how to do it in one sweep !!
*>
     perform  varying WS-P11 from 1 by 1 until WS-P11 > WS-CRT-Replacing-Count
                                            or WS-CRT-Replacing-Count > CRT-Replace-Arguments-Size
*>
*>   For non Psuedo and not lit add space before and after to ensure only processing whole word
*>     and not text within text - should be ok for Psuedo & Lit
*>
              if       WS-CRT-RT-Else (WS-P11)
                       move   spaces to Temp-Replacing-Source
                       move   spaces to Temp-Replacing-Target
                       string " "
                              WS-CRT-Replacing-Source (WS-P11)
                                 into Temp-Replacing-Source
                       end-string
                       string " "
                              WS-CRT-Replacing-Target (WS-P11)
                                 into Temp-Replacing-Target
                       end-string
              else
                       move  WS-CRT-Replacing-Source (WS-P11) to Temp-Replacing-Source
                       move  WS-CRT-Replacing-Target (WS-P11) to Temp-Replacing-Target
              end-if
*>
*>  See if we have comment line
*>
              move     zero to WS-P14
              move     zero to WS-P15
              inspect  Input-Record tallying WS-P14 for all "*>"
              if       WS-P14 not = zero
                       perform varying WS-P14 from 1 by 1
                              until Input-Record (WS-P14:2) = "*>"
                                           or WS-P14 not < IR-Buffer-Data-Size
                       end-perform
                       if       WS-P14 < IR-Buffer-Data-Size
                                subtract 1 from WS-P14
                       end-if
              else
                       move IR-Buffer-Data-Size to WS-P14
              end-if
              move     spaces to Temp-Record
*>
              move WS-CRT-Source-Size (WS-P11) to WS-P12
              move WS-CRT-Target-Size (WS-P11) to WS-P13
*>
              if    WS-CRT-RT-Lit (WS-P11)                *> THIS IS CASE SPECIFIC in INSPECT !!!
                    move     zero to WS-P15
                    inspect  Input-Record (1:WS-P14) tallying WS-P15
                                  for all Temp-Replacing-Source  (1:WS-P12)
                    if       WS-P15 not = zero
                             move     function substitute (Input-Record (1:WS-P14)            *> Copy Record
                                      Temp-Replacing-Source  (1:WS-P12)
                                      Temp-Replacing-Target  (1:WS-P13)) to Temp-Record
                             if       Input-Record not = Temp-Record (1:256)
                                      set WS-We-Have-Replaced to true
                             end-if
                             move     Temp-Record to Input-Record
                             if  We-Are-Testing3
                                 move spaces to Formatted-Line
                                 move  ws-p12 to ws-disp
                                 move  ws-p13 to ws-disp2
                                 string "*>>> Rep (LIT) Was ="
                                         Temp-Replacing-Source (1:WS-P12)
                                         " ("
                                         ws-disp
                                         ")"
                                         " Now = "
                                         Temp-Replacing-Target (1:WS-P13)
                                         " ("
                                         ws-disp2
                                         ")"
                                               into Formatted-Line
                                 end-string
                                 write Formatted-Line
                             end-if
                    end-if
              end-if
              if    WS-CRT-RT-Pseudo (WS-P11)
                    move     zero to WS-P15
                    if       WS-CRT-Leading (WS-P11)           *> Proces Leading but only if src & Tgt same size
                      and    WS-P12 = WS-P13
                             inspect  Input-Record
                                      replacing LEADING Temp-Replacing-Source (1:WS-P12)
                                                   by   Temp-Replacing-Target (1:WS-P13)
                    else
                      if     WS-CRT-Trailing (WS-P11)          *> Proces Trailing but only if src & Tgt same size
                      and    WS-P12 = WS-P13
                             inspect  Input-Record
                                      replacing TRAILING Temp-Replacing-Source (1:WS-P12)
                                                    by   Temp-Replacing-Target (1:WS-P13)
                      else
                             inspect  function upper-case (Input-Record (1:WS-P14)) tallying WS-P15
                                                for all function upper-case (Temp-Replacing-Source (1:WS-P12))
                             perform  varying WS-P16 from 1 by 1 until WS-P16 > WS-P15
                                      if       WS-P15 not = zero
                                               move     function SUBSTITUTE-CASE (Input-Record (1:WS-P14)
                                                        Temp-Replacing-Source  (1:WS-P12)
                                                        Temp-Replacing-Target  (1:WS-P13)) to Temp-Record
                                               if       Input-Record not = Temp-Record (1:256)
                                                        set WS-We-Have-Replaced to true
                                               end-if
                                               move     Temp-Record to Input-Record
                                               if  We-Are-Testing3
                                                   move spaces to Formatted-Line
                                                   move  ws-p12 to ws-disp
                                                   move  ws-p13 to ws-disp2
                                                   move  ws-p15 to ws-disp3
                                                   string "*>>> Rep (Pseudo) Was ="
                                                           Temp-Replacing-Source (1:WS-P12)
                                                           " ("
                                                           ws-disp
                                                           ")"
                                                           " Now = "
                                                           Temp-Replacing-Target (1:WS-P13)
                                                           " ("
                                                           ws-disp2
                                                           ") "
                                                           ws-disp3
                                                           " Times"
                                                                 into Formatted-Line
                                                   end-string
                                                   write Formatted-Line
                                               end-if
                                      end-if
                             end-perform
                      end-if
                    end-if
              end-if
              if    WS-CRT-RT-Else (WS-P11)
                    add      1 to WS-P12                 *> add 2 for added space before and after texts
                    add      1 to WS-P13                 *>  ditto
                    move     zero to WS-P15
                    inspect  function upper-case (Input-Record (1:WS-P14)) tallying WS-P15
                                  for all function upper-case (Temp-Replacing-Source (1:WS-P12))
                    if       WS-P15 not = zero
                             move     function SUBSTITUTE-CASE (Input-Record (1:WS-P14)
                                      Temp-Replacing-Source (1:WS-P12)
                                      Temp-Replacing-Target (1:WS-P13)) to Temp-Record
                             if       Input-Record not = Temp-Record (1:256)
                                      set WS-We-Have-Replaced to true
                             end-if
                             move     Temp-Record to Input-Record
                             if  We-Are-Testing3
                                 move spaces to Formatted-Line
                                 move  ws-p12 to ws-disp
                                 move  ws-p13 to ws-disp2
                                 string "*>>> Rep (Var) Was ="
                                         Temp-Replacing-Source (1:WS-P12)
                                         " ("
                                         ws-disp
                                         ")"
                                         " Now = "
                                         Temp-Replacing-Target (1:WS-P13)
                                         " ("
                                         ws-disp2
                                         ") found "
                                            WS-P15
                                            " Times"
                                               into Formatted-Line
                                 end-string
                                 write Formatted-Line
                             end-if
                    end-if
              end-if
              move  WS-P15 to WS-CRT-Found-Src (WS-P11)        *> records if source was found for given copy
              add   WS-CRT-Found-Src (WS-P11) to CRT-Found-Src (Fht-Table-Size - 1, WS-P11)
     end-perform.
     go       to zz900-Exit.
*>
 zz900-Exit.  Exit section.
*>*********   ************
*>
 end program printcbl.
 end program cobxref.
