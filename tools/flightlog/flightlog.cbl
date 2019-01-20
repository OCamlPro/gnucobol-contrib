       >>source free
*>****************************************************************
*>                                                               *
*>         F L I G H T  L O G  B O O K  S Y S T E M              *
*>                                                               *
*>****************************************************************
*>
 IDENTIFICATION    DIVISION.
 PROGRAM-ID.       FLIGHTLOG.
*>**
 AUTHOR.           V.B.COEN MBCS.
*>**
 DATE-WRITTEN.     17th NOVEMBER 1986.
 *> DATE-UPDATED.    September - December 2018. Major update from MF version.
*>**
 DATE-COMPILED.    TO-DAY.   *> GC does NOT update.
*>**
*> Security.       Copyright (C) 1986-2019, Vincent Bryan Coen.
*>                 Distributed under the GNU General Public License
*>                 v2.0. Only. See the file COPYING for details.
*>**
 REMARKS.          Personal Flight Log Book Program.
*>                 For all air crew including PPL, CPL, ATPL,
*>                 military and other crew members including
*>                 Engineers, Radio, Radar operators, GIBs etc.
*>                 Reports only released AFTER closing program
*>                 as all files only closed at end with all reports
*>                 being cumulative.
*>
*>                 WARNING: The data files used for this version are NOT
*>                 compatible with the original (version 1.0 series that
*>                 was issued between 1986 and 2012) nor prior versions
*>                 dated from 1976 with versions before 1.00.
*>
*>                 NOTE this program creates a report file that
*>                 you can pass through a word processing program
*>                 such as LibreOffice or Microsoft Word to change
*>                 page layout such as margins (1.5cm), Landscape
*>                 and font size (9pt) and Duplex long edge before
*>                 printing. the file name is logbook.rpt.
*>                 As the program used is not known, it is to the
*>                 user to set these changes up prior to printing
*>                 as each word processor is different but only
*>                 involves a minute or so to change settings for
*>                 producing a report.
*>
*>                 A script is provided called prtpdf.sh for Linux users
*>                 to do this but you might want or need to modify the
*>                 settings within it if needed to suit paper used although
*>                 there are two versions with one for A4 and other for Letter.
*>
*>                 To help automate using this script, you need to
*>                 install some additional packages, enscript,
*>                 Postscript.
*>
*>                 Many of the notes herein are to remind me to include them
*>                 in the user manual for Flightlog and will be stripped out
*>                 once done - may be.
*>**
*>  VERSION.       See PROG-NAME in ws.
*>**
*>  Specific program or compiler settings.
*>                 If using a different COBOL compiler other than
*>                 GnuCOBOL v3 you must check that these features are
*>                 included to minimise error or warning messages
*>                 when compiling.
*>
*>  Environment Variables used:
*>                 COB_SCREEN_EXCEPTIONS  -  Set in program.  Used for GnuCOBOL for accepting F keys.
*>                 COB_SCREEN_ESC         -  Set in program.   -  ditto  -
*>                 COB_EXIT_WAIT          -  Set in program.   -  ditto  -
*>                 LC_TIME                -  Program checks for 1st five chars of values :
*>                                           en_GB (dd/mm/ccyy),
*>                                           en_US (mm/dd/ccyy),
*>                                           or unset for *nix
*>                                            which gives ccmm/mm/dd.
*>                                          as all other settings will be treated as UNIX.
*>                 If needed, a callable script that runs flightlog should be
*>                 used to set LC_TIME and then call the program.
*>                 See sample script/s for this that also does a backup,
*>                 if using Windows you will have to write a batch file for doing the same.
*>                 This operation will NOT affect your system settings as
*>                 it is a temporary setting during Flightlog execution.
*>**
*>  Terminal settings:
*>                 Minimum size of 106 wide and 24 depth
*>                     (but will make use of deeper) to
*>                        display information.
*>**
*>  Called Internal Library Modules:
*>                 CBL_DELETE_FILE
*>                 CBL_CHECK_FILE_EXIST
*>**
*>  Called Cobol Functions:
*>                 Upper-case.
*>                 Current-Date.
*>                 Escape code sequence capture within Screen handling and
*>                 Screen Colour within Screen handling * See 78's
*>                          for both, below accept-terminator-array.
*>                 Screen save and restore using:
*>                 scr_dump
*>                 scr_restore  -  Used when Functions keys F1 and F3 used
*>                                 for displaying F1=Airfields & F3=Aircraft.
*>                 This works under Linux and on a Raspberry Pi 3B+
*>                  but NOT yet tested under any other
*>                 operating systems such as OSX, Windows.
*>**
*>  Called Modules.
*>                 None.
*>**
*>  Switches used (88):
*>                  NO-PRINT-YET of PRINT-FLAG and other internals.
*>**
*>  Called parameters:
*>                 P1 - NONIGHT | NONITE - To stop program from calculating when
*>                                 night time starts.
*>                  E.g.,  flightlog NOLIGHT
*>                      NIGHT | NITE     - To do night time calcs use when P2 is used.
*>                      CSV-TEST         - Test displays (with pause) in csv processing after unstring
*>                                         Useful to check for mistakes in CSV-config rec 1
*>                                         problems. Otherwise do not use.
*>                 P2 - CSV= path and file name of CSV configuration file- Note it starts with 'CSV='
*>                 P3 - ACFT-DATE = Produces report by lsat Date used.
*>                 Above parameters can be entered in any order (other than HELP)
*>                 P1 = HELP | help | -H | -h  - Produces a Help screen then
*>                      exists (after return).
*>                 Note that | means OR = Choices for the same thing.
*>******
*>  Program Error messages used:  Supplied in English.
*>  -------------------------------------------------
*>  Programming Errors in file sizing:
*>                 SY001 thru SY009.  Report all as a major programming defect.
*>**
*>  Terminal size Errors:
*>                 SY010 and SY012.   Reset your terminal program to required values
*>                                    then hit return.
*>**
*>  CSV Warning or Error messages:
*>                 SY021 thru SY024.  Config Data or CSV data incorrect.
*>=
*>  Operational, Warning or Error Messages:
*>                 FL001 thru FL050.  Flightlog usage issues. (FL018 not used)
*>**
*>  CHANGES.       All old changes saved to file Changelog as list is getting long!
*>                  last two digits (.nn) is build number.
*>
*> 29/12/18 vbc       .04 Problem with end of line that is not there so data
*>                        is one big block. This will not work less plan 2 can be
*>                        created and no, no idea at the moment.
*>                        AS this issue cannot be resolved when using a normal data
*>                        processing for ASCII data records as Line Sequential this
*>                        function is being removed (Data conversion EBCDIC to ASCII).
*>                        Likewise P4 usage so now only 3 parameters maximum used when
*>                        starting program.
*> 02/01/19 vbc       .05 No data test if trying to run options that expect data to be present. FL016.
*>                        Silly omission but user could try it!
*>
*> TODO maybe ? (outstanding):
*>
*>  20/10/18            4. Consider using Mysql RDB for all data used on a per pilot
*>                     basis. Worth doing ?.
*>                     Would allow for extra statistics using SQL queries but again is
*>                     this useful ?.
*>                     If application used as a web based system allows for multi
*>                     pilots by using one database per pilot by name via a login
*>                     facility.    Priority LOW / MEDIUM as would require users
*>                     to install Mysql package, bit ITT for low exp. users.
*>                     Could consider using Sqlite but err, why ?
*>**
*>  07/11/18            6. Consider using a web browser interface for display
*>                     and accepting data. Could be linked to (4).
*>                     THIS IS A HIGH TIME work load though, so unlikely.
*>                     Priority LOW.
*>**
*>  17/12/18            8. Consider re-introducing on data entry day and night landings
*>                     for the T & G flights but there again it should be specified
*>                     in Remarks so is it really needed for the 90 Day CoE ?.
*>                     CAA / FAA requirement ?
*>                     The problem with it is that it is not used for commercial or
*>                     military aircrew.
*>**
*>****************************************************************************************
*> Copyright Notice.
*>*****************
*>
*> This program is time recording software for air crew as private,
*> commercial (i.e., holding a CPL or ATPL) and military, World wide and is
*> Copyright (c) Vincent B Coen. 1986-2019 and later. The supplied copyright
*> notices that are displayed and printed MUST be maintained at all times.
*>
*> This program as OS (Open Source) is free software; you can redistribute
*> it and/or modify it under the terms of the GNU General Public License
*> as published by the Free Software Foundation; version 2 ONLY.
*> This means that the source code used to produce the program MUST be
*> supplied along with any executable / Binary programs supplied, in
*> any form and that the source MUST be able to create
*> the same executable or binary programs.
*>
*> As supplied, it is set up to use the GnuCOBOL compiler that is also free
*> to obtain and use along with any run time elements to do so.
*> This is available at https://sourceforge.net/projects/open-cobol under
*> Files then gnu-cobol with the current version being 3.0.
*>
*> This will allow any user to build the compiler then the Flightlog program
*> under Windows, Linux, OSX, or any other *nix system within a short
*> space of time.  For more information see the supplied documentation and
*> that supplied with the COBOL compiler. For support with the COBOL
*> compiler go to the url listed above.
*>
*> For support for Flightlog go to the sourceforge url listed in the manual
*> or at www.sourceforge.net/p/flightlogc
*>
*> Flightlog is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endeavour
*> to fix it, providing you tell me about the problem. When doing so please
*> specify the version used which is displayed on the menu and reports.
*> This only allows usage for personal use, that means not commercially Nor
*> can it be sold without permission of the author/programmer.
*>  See manual inside front cover for contact information.
*>
*> You should have received a copy of the GNU General Public License along
*> with FlightLog; see the file Copying.pdf.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>*************************************************************************
*>
 ENVIRONMENT        DIVISION.
*>==========================
*>
 CONFIGURATION SECTION.
*>---------------------
 SOURCE-COMPUTER.        FX8350.
 OBJECT-COMPUTER.        FX8350.
 SPECIAL-NAMES.
     CONSOLE IS CRT.
*>       Alphabet Alpha is ASCII.    *> When this works can get rid of the table-ascii and table-ebcdic
*>       Alphabet Beta  is EBCDIC.
*>
 INPUT-OUTPUT        SECTION.
*>--------------------------
*>
 FILE-CONTROL.
*>-----------
*>
     SELECT FLIGHTLOG-FILE   ASSIGN       "flitelog.dat"
                             ACCESS       DYNAMIC
                             ORGANIZATION INDEXED
                             STATUS       FS-REPLY
                             RECORD KEY   FLT-DATE-TIME-KEY.
     SELECT FLIGHTLOGBACKUP-FILE
                             ASSIGN       "flitelog.seq"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
     SELECT AIRFIELD-FILE    ASSIGN       "airfield.dat"
                             ACCESS       DYNAMIC
                             ORGANIZATION INDEXED
                             STATUS       FS-REPLY
                             RECORD KEY   ICAO-CODE.
     select Airfieldbackup-file
                             assign       "airfield.seq"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
     SELECT AIRCRAFT-FILE    ASSIGN       "aircraft.dat"
                             ACCESS       DYNAMIC
                             ORGANIZATION INDEXED
                             STATUS       FS-REPLY
                             RECORD KEY   Aircraft-Type.
     SELECT AircraftBackup-FILE
                             ASSIGN       "aircraft.seq"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
     SELECT PRINT-FILE       ASSIGN       "logbook.rpt"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
*>  File name default is "csv-flitelog" overridden by CSV rec type 3
*>
     SELECT CSV-Data-File    ASSIGN       CSV-File-Name
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
     SELECT CSV-Layout-File  assign       CSV-Config-Name          *> default is "csv-conf.txt"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
 DATA  DIVISION.
*>==============
*>
 FILE SECTION.
*>-----------
*>
*>   File Definition for the Flight Log Book File
*>   Rec size 112 bytes
*>
 FD  FLIGHTLOG-FILE.
 01  FLIGHTLOG-RECORD.
     03  FLT-Date-Time-Key.
         05  FLT-DATE        PIC 9(8).  *> ccyymmdd
         05  FLT-START       PIC 9(4).  *> In minutes
     03  FLT-END             PIC 9(4).  *>  ditto
     03  FLT-AC-TYPE         PIC X(8).  *> 24
     03  FLT-AC-REG.                       *>      *> Using 1st 5 digits for Nth American a/c ignore 1st char 'N'
         05  flt-ac-reg1-2   pic xx.               *>   but include 'N' for printing.
         05  filler          pic xxxx.     *> last digit not used see above.
     03  FLT-CAPTAIN         PIC X(15). *> 45
     03  FLT-CAPACITY        PIC XXX.
     03  FLT-FROM            PIC X(4).  *> ICAO airfield code
     03  FLT-TO              PIC X(4).  *> Ditto
     03  FLT-MS              PIC X.     *> 57
     03  filler                             OCCURS 2.   *> x(20)
*>
*>*****************************************
*>         (1) Day,      (2) Night        *
*>*****************************************
*>
         05  FLT-P1          PIC 9(4).   *> Stored as minutes, and the next 2.
         05  FLT-P23         PIC 9(4).
     03  FLT-INSTRUMENT      PIC 9(4).   *> 77
     03  FLT-REMARKS         PIC X(32).  *> 109
     03  filler              pic xxx.    *> unused - for poss. expansion - 112.
*>
 FD  FLIGHTLOGBACKUP-FILE.
 01  FLIGHTLOGBACKUP-RECORD PIC X(112).
*>
 FD  AIRFIELD-FILE.                      *> Name changed 20 to 36 19/12/18. NEED To run proram afldconv1
 01  AIRFIELD-RECORD.                    *>  to update file using .seq file as input.
     03  ICAO-CODE           PIC X(4).
     03  AFLD-Name           pic x(36).
     03  AFLD-Last-Flt       pic 9(8).
*>
 FD  AIRFIELDBackup-FILE.
 01  AIRFIELDBackup-RECORD   pic x(48).
*>
 FD  AIRCRAFT-FILE.
 01  AIRCRAFT-RECORD.
     03  Aircraft-Type       PIC X(8).
     03  AIRCRAFT-MS         PIC X.
     03  Aircraft-Complex    pic x.     *> Y or (space / N).
     03  Aircraft-Last-Reg   pic x(6).
     03  Aircraft-Last-Flt   pic 9(8).
 *>    03  Aircraft-Man        pic x(20).
 *>    03  Aircraft-Name       pic x(20).
*>
 fd  AircraftBackup-File.
 01  AircraftBackup-Record   pic x(24).
 *> 01  AircraftBackup-Record   pic x(64).
*>
 FD  PRINT-FILE.
 01  PRINT-RECORD            PIC X(160).
*>
 01  filler.             *> Print-Head1.
     03  PH1-Prog            PIC X(23).
     03  PH1-TITLE1          PIC X(28).
     03  PH1-NAME            PIC X(40).
     03  FILLER              PIC X(9).
     03  PH1-DATE            PIC X(12).
     03  PH1-TIME            PIC X(12).
     03  PH1-TITPAG          PIC X(5).
     03  PH1-PAGE            PIC ZZ9.
*>
 01  filler.             *> Print-Head2.
     03  FILLER              PIC X(11).
     03  PH2-LIT1            PIC X(14).
     03  FILLER              PIC X(17).
     03  PH2-LIT2            PIC X(51). *> 93
*>
 01  filler.             *> Print-Head3.
     03  FILLER              PIC XX.
     03  PH3-LIT1            PIC X(32).
     03  FILLER              PIC X(7).
     03  PH3-LIT2            PIC X(92).   *> 133
*>
 01  Print-Heads-Ext-Line2.             *> Print-Head2. NEEDS CHANGES
     03  FILLER              PIC X(11).
     03  PH12-LIT1           PIC X(14).    *> same lit. as PH2-lit1
     03  FILLER              PIC X(17).
     03  PH12-LIT2           PIC X(58).    *> 100
*>
 01  Print-Heads-Ext-Line3.             *> Print-Head3.Longest print line 142
     03  FILLER              PIC XX.
     03  PH13-LIT1           PIC X(32).   *> Same lit. as PH3-Lit1
     03  FILLER              PIC X(7).
     03  PH13-LIT2           PIC X(102). *> increased by 10 - 143
*>
 01  filler.
     03  PR1-DATE            PIC X(10)B.
     03  PR1-AC-TYPE         PIC X(9).
     03  PR1-AC-REG          PIC X(7).
     03  PR1-CAPTAIN         PIC X(15).     *> 42
     03  PR1-CAPACITY        PIC X(4).      *> 46
     03  PR1-FROM            PIC X(5).      *> 51
     03  PR1-TO              PIC X(6).      *> 57
     03  PR1-START           PIC 99.99B.    *> 63
     03  PR1-END             PIC 99.99B.    *> 69
     03  PR1-P1              PIC Z9.99    BLANK WHEN ZERO OCCURS 2.  *> 74,79 P1, P2/3
     03  PR1-P2              PIC Z9.99    BLANK WHEN ZERO OCCURS 2.  *> 84,89 P1, P2/3
     03  PR1-IFR             PIC Z9.99    BLANK WHEN ZERO.           *> 94
     03  PR1-MULTI           PIC Z9.99B   BLANK WHEN ZERO.           *> 100 Multi engine
     03  PR1-REMARKS         PIC X(32).                              *> 132 138 -
*>
 01  Print-Extended-Log.
     03  PR11-DATE            PIC X(10)B.
     03  PR11-AC-TYPE         PIC X(9).
     03  PR11-AC-REG          PIC X(7).
     03  PR11-CAPTAIN         PIC X(15).     *> 42
     03  PR11-CAPACITY        PIC X(4).      *> 46
     03  PR11-FROM            PIC X(15)b.        *> 51 +11 = 62   Using 1st 15 chars
     03  PR11-TO              PIC X(15)b.        *> 57 +10 = 78   - - ditto - -
     03  PR11-START           PIC 99.99B.    *> 63  84
     03  PR11-END             PIC 99.99B.    *> 69  90
     03  PR11-Day-P           PIC Z9.99    BLANK WHEN ZERO.           *> 74 =
 *>    03  PR11-Day-TG          pic zz9      blank when zero.
     03  PR11-Nite-P          PIC Z9.99    BLANK WHEN ZERO.           *> 79 = 100
 *>    03  PR11-Nit-TG          pic zz9      blank when zero.     *> increase size by 6
     03  PR11-IFR             PIC Z9.99    BLANK WHEN ZERO.           *> 94 = 105
     03  PR11-MULTI           PIC Z9.99B   BLANK WHEN ZERO.           *> 100 Multi engine = 111
     03  PR11-REMARKS         PIC X(32).                              *> 132   =  143
*>
 01  PRINT-RECORD2.                    *> Used for displays
     03  PR2-AIRCRAFT        PIC X(9).                                *> 9
     03  PR2-P               PIC Z(4)9.99  BLANK WHEN ZERO OCCURS 6.  *> 17,25,33,41,49,57
     03  PR2-TOTAL           PIC Z(4)9.99.                            *> 65
     03  PR2-IFR             PIC Z(4)9.99  BLANK WHEN ZERO.           *> 73
     03  PR2-MULTI           PIC Z(5)9.99  BLANK WHEN ZERO.           *> 82
     03  PR2-INST            pic z(5)9.99  Blank when zero.           *> 91
     03  filler              pic x(4).
     03  PR2-Last-Flt        pic X(10).                               *> 105 + 42 if man & name added so not for displays.
*>
 01  Filler.
     03  PR3-Data1           pic x(115).
     03  PR3-DATA2           PIC X(17).
*>
 01  Print-Record4.      *> Airfields as ICAO and Name 4+20 from table + cnt and lst-flt.
     03  PR4-AFld-Group                 occurs 2.   *> from 3
         05  PR4-ICAO        pic x(5).
         05  PR4-Afld-Name   pic x(36).
         05  PR4-Afld-Cnt    pic zzzzBB.
         05  PR4-Afld-Lt-Flt pic X(10).
         05  filler          pic x(4).
*>
 01  CoE-Lines.
     03  PCoE-Type           pic x(8).
     03  PCoE-Day-P1         pic zzzz9.99.                      *>  15 +1
     03  PCoE-Day-P2         pic zzzz9.99    Blank when zero.   *>  22 +2
     03  PCoE-Day-P3         pic zzz9.99.                       *>  29
     03  PCoE-Day-Ins        pic zzz9.99     BLANK WHEN ZERO.   *>  36
     03  PCoE-Day-Flts       pic z(4)9.                         *>  41
     03  PCoE-Nite-P1        pic zzzz9.99.                      *>  48 +3
     03  PCoE-Nite-P2        pic zzzz9.99    blank when zero.   *>  55 +4
     03  PCoE-Nite-P3        pic zzz9.99.                       *>  62
     03  PCoE-Nite-Ins       pic zzz9.99     BLANK WHEN ZERO.   *>  69
     03  PCoE-Nite-Flts      pic z(4)9.                         *>  74
     03  PCoE-Total          pic zzzzz9.99.                     *>  82 +5
     03  PCoE-IFR            pic zzzzz9.99   blank when zero.   *>  90 +6
     03  PCoE-Single         pic zzzzz9.99.                     *>  98 +7
     03  PCoE-Multi          pic zzzzz9.99   blank when zero.   *> 106 +8
     03  PCoE-Inst           pic zzzzz9.99   blank when zero.   *> 114 +9
*>
 FD  CSV-Data-File.                              *> File name in CSV-File-Name via rec type 3.
 01  CSV-Data-Record         pic x(512).         *> Maximum record data size so increase if needed
                                                 *>  also field WS-CSV-Rec-Size.
*>
 FD  CSV-Layout-File.
*>
*>  This record must always be present when importing data log book data and is specific for one
*>   Airline, Flight training establishment or executive a/c hire centre.
*>
*> Records for new airport or new aircraft only needed if a new one may be in current data.
*>   Entries will be checked that they are not currently held and if not will be added to data bases.
*>
*>  Record types can be in any order, i.e., records 1, 2, 3, Optional: 6, and
*>      if needed 4 and/or 5 as required.
*>   Compulsory fields are 1, 2, 3  with 6, 4 & 5 as needed.
*>
 01  CSV-Logbook-Layout-Definitions.           *> This record MUST ALWAYS be present for data imports.
     03  CSV-Record-type     pic X.             *> '1' for field definitions for flightlog record.
     03  CSV-Src-Position    pic 99.             *> Field # starts with 1, leading zero as needed - Must
                                                 *>  always be 2 numeric digits and ALL CSV fields
                                                 *>   must be accounted for (No OMISSIONS).
     03  filler              pic x.              *> '=' but don't care.
     03  CSV-Target-Fld-No   pic 99.             *> As per field position in the flightlog file
                                                 *>  00 = ignore (OMIT) CSV field
                                                 *> I.e, FLT-Date = 1, FLT-Start = 2, FLT-End = 3,
                                                 *>  FLT-Capacity = 7, etc.
 *>    03  CSV-Src-No-Quotes   pic x.              *> Y = no quotes present. NOT USED.
*>
 01  CSV-Logbook-Formats.                      *> This record MUST ALWAYS be present for data imports.
     03  filler              pic x.             *> '2' for field format definitions.
     03  CSV-Date            pic x(10).          *> Input Date format can be yyyy/mm/dd, dd/mm/yyyy,
                                                 *> mm/dd/yyyy and year can be yyyy or yy, delimiters
                                                 *> not present or another character such as '.' ','
                                                 *>  '\' or none, e.g., yyyymmdd, ddmmyyyy etc
                                                 *>  field must be trailing spaces such 'as ddmmyy    '.
*>
     03  CSV-Time-1          pic x(5).           *> Time format as - mmmm, hhmm, hh.mm (& same as hh:mm).
                                                 *> Note delimiter between HH and MM can be any .: etc
                                                 *> Time format applies to all times flight start & end
                                                 *> Use Time-2 for P1, P2 etc if included in data,
                                                 *> otherwise P1, 2, 3 times will be computed.
                                                 *> based on end and start times.
                                                 *> Aircraft registration data max of 6 characters
                                                 *> (MUST NOT be a flight number.)
*>
     03  CSV-Time-2          pic x(5).           *> Same as Time-1, used for P1/2/3, Inst flight time
                                                 *>   (Day and Night).
                                                 *> If these value not present Computed figures for
                                                 *>   day/night may well not be accurate.
*>
 01  CSV-Data-File-Name-Record.                    *> Record must be present to read flight data file.
     03  filler              pic x.              *> '3' for importing CSV flight data file.
     03  CSV-Data-Format     pic x.              *> set to A or space but currently ignored.
                                                 *> we may process if EBCDIC data files are provided to users.
     03  CSV-Delimiter       pic x.              *> Delimiter used in data file = single or double quote
     03  CSV-FName           pic x(64).          *> File name to be imported if not it is 'csv-flitelog'.
*>
*> Rec types 4 & 5 can be input without and other data - i.e., just to load Airfields
*>
*>  ONLY needed ONCE if a NEW airfield is included in log book data you can add them in advance of being used.
*>    If airfield already recorded then only updated if name is different otherwise ignored.
*>
 01  CSV-Airfield-Definitions.                     *> These only needed once for a NEW airport.
     03  filler              pic X.              *> '4' for NEW airport data.
     03  CSV-Airfield-Code   pic x(4).           *> ICAO code for NEW airport.
     03  filler              pic x.              *> Fixed value is comma ','.
     03  CSV-Airfield-Name   pic x(20).          *> Airport name up to 20 characters and trailing spaces.
*>
*>  ONLY needed ONCE if a NEW aircraft type used in log book data you can add them in advance of being used.
*>   If aircraft type already present and if present record is updated with MS and complex fields.
*>
 01  CSV-Aircraft-Definitions.                     *> These only needed once for a NEW aircraft type.
     03  filler              pic X.              *> '5' for NEW aircraft type data.
     03  CSV-Acft-Type       pic x(8).           *> 8 char code for NEW aircraft type as used in logbook data.
     03  filler              pic x.              *> fixed data is comma ','.
     03  CSV-Acft-MS         pic x.              *> M for multi-engine or S for single engine.
     03  CSV-Acft-Complex    pic x.              *> 'Y' for (yes) for all multi-engine (Default)
                                                 *>   'N' (or space) for simple single engine A/C with fixed gear and propeller.
*>
*> This record only needed if CSV file contains records for other pilots say when coming from A/C Technical. logs
*>    and field 2 used to replacing a given name in CSV-Captain-Search with one in CSV-Replace-Captain.
*>
*> Here useful if CSV file contains the Pilots name but s/he wishes to change it to another such as
*>    SELF which is more normal for one's log book.
*>
*>   The CSV-Captain-Search field can be spaces in which case all instances of capacity P1 or P2
*>     are changed to CSV-Replace-Captain. NOTE that for P3 no change is made.
*>
*>  WARNING:  You MUST use upper-case characters as needed i.e., field Search must exactly match
*>    name as on CSV file, e.g., 'COEN, V.B.' and field Replace must be as required
*>      but usually upper-case e.g., SELF.  NOTE that Data Entry changes captain to upper case.
*>
*>  Leave fields 3, 4 and 5 blank when flying as as other than P2
*>    When flying as P2 or P3 fields 4 used used for CSV source field to locate P2/3 pilot name in
*>     search as again the default of target as 06 (Captain).
*>
 01  CSV-Captain-Search-Record.
     03  filler              pic x.              *> '6' for Captain search criteria in CSV recs.
     03  CSV-Replace-Captain pic x(15).          *> F2 = Name to substitute for field 5 when found, E.g., SELF
                                                 *>  with trailing spaces. Converted to Upper Case.
     03  filler              pic x.              *> F3 = fixed value '(' or space, but ignored.
     03  CSV-Rec-Pos4Search.                     *> F4
         05  CSV-Rec-Pos4Search9 pic 99.         *> Actual source field position to find field 6.
     03  filler              pic x.              *> F5 = ')' or space but ignored.
     03  CSV-New-Cap         pic xx.             *> F6 = Non P1 capacity if in search mode outside of Captain.
     03  CSV-Captain-Search  pic x(30).          *> F7 = Pilot to search and only include for, in CSV data
                                                 *>  (with trailing spaces). Converted to Upper Case.
*>
 WORKING-STORAGE SECTION.
*>----------------------
 77  PROG-NAME               PIC X(18) VALUE "LOG BOOK (2.02.05)".
 77  WS-CSV-Rec-Size         pic 9999 comp  value 512. *> This is the maximum record size for CSV logbook
                                                       *> data records [see manual]. If unsure leave as is
                                                       *>  It is more likely to be smaller i.e., 256.
 77  WS-CSV-Table-Max-Size   pic 99   comp  value 96.  *> See table WS-Group - MUST be same value.
                                                       *> This is the maximum number of fields that can
                                                       *> be in a CSV record although most will not be
                                                       *> used as there are only 16 fields used in the
                                                       *>  flightlog flight data record.
*>
 77  WS-CSV-Data-Def-Min-Cnt pic 99         value 9.   *> Change to minimum fields required to work, i.e.
                                                       *> Date, start time, end time, Captain, Capacity
                                                       *> A/c Type, A/C reg, Afld From, Afld To,
                                                       *> THIS IS THE MINIMUM type 1 records defined and is
                                                       *>  part of a check for valid data in this file.
                                                       *>  Anything less than this would restrict the usage
                                                       *>   of taking data from a CSV file and only manual
                                                       *>   data entry will suffice.
                                                       *>
*>
 77  WS-Line-Cnt-Size-1      pic 99   comp  value 52.  *> If needed change to match paper depth.
 77  WS-Line-Cnt-Size-2      pic 99   comp  value 48.  *> If needed change to match paper depth.
*>
 77  A                       PIC 9999 COMP  VALUE ZERO.
 77  B                       PIC 9999 COMP  VALUE ZERO.
 77  C                       PIC 9999 COMP  VALUE ZERO.
 77  D                       PIC 9999 COMP  VALUE ZERO.
 77  Z                       PIC 99   COMP  VALUE ZERO.
 77  Y                       PIC 99   COMP  VALUE ZERO.  *> used to count FLT fields in CSV config.
 77  CSV-Recs-In             pic 9(4)       value zero.
 77  CSV-Recs-Out            pic 9(4)       value zero.
 77  CSV-Recs-Exist          pic 9(4)       value zero.
 77  INS-FLAG                PIC 9    COMP  VALUE ZERO.
 77  DISPLAY-FLAG            PIC 9    COMP  VALUE ZERO.
 77  MONTHLY-ANAL-FLAG       PIC 9    COMP  VALUE ZERO.
 77  ANALYSIS-ONLY-FLAG      PIC 9    COMP  VALUE ZERO.
 77  SHORT-PRINT             PIC 9    COMP  VALUE ZERO.
 77  PRINT-FLAG              PIC 9    COMP  VALUE ZERO.
     88 NO-PRINT-YET                        VALUE 1.
 77  Print-Report-Type       pic 9    comp  value zero.    *> for 2.02.00
     88  Extended-Report                    value 1.
 77  Aircraft-Rep-Flag       pic 9    comp  value zero.
 77  ERROR-CODE              PIC 9999 COMP  VALUE ZERO.
 77  LINE-CNT                PIC 99   COMP  VALUE ZERO.
 77  PAGE-CNT                PIC 99   COMP  VALUE ZERO.
 77  WS-Zero-Time            pic 99.99      value zero.
 77  WS-Elapsed-HHMM         pic 99.99      value zero.
 77  WS-Time-Remaining-HHMM  pic 99.99      value zero.
 77  WS-ELAPSED-TIME         PIC 9(4) COMP  VALUE ZERO.
 77  WS-CALC-TIME            PIC 9(4) COMP  VALUE ZERO.
 77  WS-Time-Remaining       pic 9(4) comp  value zero.
 77  PRINT-START             PIC 9(8) COMP  VALUE ZERO.
 77  Print-Start-Time        pic 9(4).
 77  PRINT-END               PIC 9(8) COMP  VALUE ZERO.
 77  SAVE-FLT-Mth            PIC 99   COMP  VALUE ZERO.  *> used in anal and enter start/end times.
 77  SAVE-FLT-HH             PIC 99   COMP  VALUE ZERO.  *> used in anal and enter start/end times.
 77  SAVE-FLT-MM             PIC 99   COMP  VALUE ZERO.  *> used in anal and enter start/end times 4 CSV.
 77  WS-WORK1                PIC 9(5) COMP  VALUE ZERO.
 77  WS-WORKA REDEFINES WS-WORK1
                             PIC 999V99 COMP.
 77  WS-WORK2                PIC 9(5)  COMP  VALUE ZERO.
 77  WS-WORK3                PIC 9(8)  COMP  VALUE ZERO.
 77  WS-WORKB  REDEFINES WS-WORK3
                             PIC 9(6)V99 COMP.
 77  WS-WORK4                PIC 9(8)  COMP  VALUE ZERO.
 77  WS-Rec-Length-1         pic 9(5)  comp  value zero.
 77  WS-Rec-Length-2         pic 9(5)  comp  value zero.
 77  MENU-REPLY              PIC X           VALUE SPACE.
 77  Menu-Option             pic x           value space.       *> taken from menu-reply
 77  SW-Its-Night            pic 9           value zero.        *> 1 = its night else zero.
 77  SW-Escaped              pic 9           value zero.        *> 1 is escape pressed.
 77  SW-ACFT-Date            pic 9           value zero.        *> via P3 or P4
 77  SW-EBCDIC-Conv          pic 9           value zero.        *> via P3 or P4 not yet coded.
 77  SW-AFLD-Used            pic 9           value zero.        *> Only print used Airfields.
 77  SW-Test                 pic 9           value zero.
     88  SW-Testing                          value 1.
 77  WS-ICAO-CODE            PIC X(4)        VALUE SPACES.
 77  WS-AFLD-NAME            PIC X(36)       VALUE SPACES.
 77  WS-New-ICAO-CODE        PIC X(4)        VALUE SPACES.
 77  WS-Old-AC-Type          pic x(8)        value spaces.
 77  WS-New-AC-Type          pic x(8)        value spaces.
 77  WS-Tmp-Afld             pic x(4)        value spaces.
 77  WS-Tmp-Afld2            pic x(4)        value spaces.
 77  WS-Tmp-Afld-Last-Flt    pic 9(8)        value zero.
 77  WS-Tmp-Captain          pic x(15)       value spaces.      *> Used for CSV data inporting.
 77  WS-Reply                pic x.
 77  WS-TIME                 PIC X(8)        VALUE SPACES.
 77  WS-DISPLAY4             PIC 9999        VALUE ZERO.
 77  WS-USER                 PIC X(40)       value spaces.
 77  CSV-File-Name           pic x(64)       value "csv-flitelog".  *> name in config rec type 3.
 77  CSV-Config-Name         pic x(64)       value "csv-conf.txt".
 77  WS-Data-Delim           pic xx          value "',".
 77  WS-Data-Format          pic x           value "A".         *> Not used but for ASCII and maybe E for EBCDIC.
 77  WS-Scrn-BE-Start        pic 9(4)        value 0302.
 77  WS-Scrn-BE-Length       pic 9(4)        value 2000.
 77  WS-Scrn-BE-Cnt          pic 99   Comp   Value 19.
 77  WS-Scrn-BE-Head         pic 9(4)        value 0202.
 77  WS-Scrn-BE-Curs         pic 9(4)        value zero.
*>
 77  WS-Dft-Scrn-BE-Length   pic 9(4)        value 2000.        *> updated by (ws-lines x 100) - 400
 77  WS-Dft-Scrn-BE-Cnt      pic 99   Comp   Value 19.          *> updated by WS-lines - 5
*>
 01  NO-NIGHT-Calcs          pic 9          value zero.
     88  NONIGHT                            value 1.
 01  P1                      pic x(64)     value spaces.       *> P for NONIGHT|NONITE
 01  P2                      pic x(64)     value spaces.       *> P for path/filename of CSV data file
 01  P3                      pic x(64)     value spaces.       *> P for AFLD-DATE
 01  P-Temp                  pic x(64)     value spaces.       *> temp for P2.
*>
 01  WS-Locale               pic x(16)      value spaces.       *> Holds o/p from env var.
*>                                                                 LC_TIME but only uses 1st 5 chars
 01  WS-Local-Time-Zone      pic 9          value 3.            *> Defaults to International, See comments below !
*>
*> Sets WS-Local-Time-Zone ^~^ to one of these 88 values according to
*>    your local requirements
*> NOTE Environment var. LC_TIME is checked for "en_GB" for UK (1)
*>                                          and "en_US" for USA (2)  OTHERWISE its 3 for *nix format
*>   At start of program.
*>   For any other, you can add yours if different but let the Lead Programmer
*>     know, so it can be added to the master sources otherwise default will
*>      be Unix format.   THIS is used to define the format of Dates for display
*>       and printing. Internal format does NOT change remains as *nix format
*>          ccyymmdd.
*>
*>    Note that 'implies' does NOT mean the program does anything e.g.,
*>      changes page sizing in the report. It does not !
*>
     88  LTZ-UK                           value 1. *> dd/mm/ccyy  [en_GB] Also implies A4 Paper for prints
     88  LTZ-USA                          value 2. *> mm/dd/ccyy  [en_US] Also implies US Letter Paper for prints
     88  LTZ-Unix                         value 3. *> ccyy/mm/dd  Also implies A4 Paper for prints
*>
 01  ws-date-formats.                      *> ALL OF THEM BUT SOME MAY NO LONGER BE USED.
     03  WS-TODAY            PIC 9(8).     *> Intl
     03  ws-Test-Date.                     *> I/p to zz050-validate-date
         05  WS-Test-Date9   pic 9(10).
     03  WS-Test-Intl        pic 9(8).     *> in zz050 convert to for testing
     03  U-Bin               pic 9.        *> Zero  = good date, 1 = bad. from zz050
     03  ws-date             pic x(10).    *> o/p from zz050-validate-date
     03  ws-UK redefines ws-date.
         05  ws-days         pic 99.
         05  filler          pic x.
         05  ws-month        pic 99.
         05  filler          pic x.
         05  ws-year         pic 9(4).
     03  ws-USA redefines ws-date.
         05  ws-usa-month    pic 99.
         05  filler          pic x.
         05  ws-usa-days     pic 99.
         05  filler          pic x.
         05  filler          pic 9(4).
     03  ws-Intl redefines ws-date.
         05  ws-intl-year    pic 9(4).
         05  filler          pic x.
         05  ws-intl-month   pic 99.
         05  filler          pic x.
         05  ws-intl-days    pic 99.
*>
     03  WS-Tmp-Date7        pic 9(7).
     03  WS-Tmp-Date8        pic 9(8).
*>
     03  WSA-DATE.                            *> Used in date test routine returned value
         05  WSA-YY          PIC 9999.
         05  WSA-MM          PIC 99.
         05  WSA-DD          PIC 99.
     03  WSA-DATE2  REDEFINES WSA-DATE        *> passed to flitelog data
                             PIC 9(8).
*>
     03  WSE-Date-Block.
         05  WSE-Date.
             07  WSE-Year        pic 9(4).
             07  WSE-Month       pic 99.
             07  WSE-Days        pic 99.
         05  WSE-Date9 redefines WSE-Date
                                 pic 9(8).
         05  WSE-Timex.
             07  WSE-HH9         pic 99.
             07  WSE-MM9         pic 99.
             07  WSE-SS9         pic 99.
         05  filler              pic x(7).
*>
     03  WSF-Date                pic x(10).          *> For print Heads converted to LOCALE format.
*>
*>  FLT date must be => than, for inclusion in the totals tables.
*>    All computations are based on month periods only.
*>
     03  Active-CoE-Date     pic x(10).
     03  CoE-Earliest-Dates            value zeros.  *> All intl dates
         05  CoE-1-Mth       pic 9(8).
         05  CoE-Quarter     pic 9(8).
         05  CoE-6-Mths      pic 9(8).
         05  CoE-13-Mths     pic 9(8).
*>
 01  Save-FLT-Date-Time-Key.
     03  SAVE-FLT-DATE       PIC 9(8)        VALUE ZERO.
     03  SAVE-FLT-START      PIC 9(4)        VALUE ZERO.
 01  WS-Backup-Date-Time-Key pic 9(12).
*>
 01  File-Status-Flags                       value zeros.  *> Used in D000 file set routine.
     03  Flightlog-Dat-Exists pic 9.
     03  Aircraft-Dat-Exists  pic 9.
     03  Airfield-Dat-Exists  pic 9.
     03  Flightlog-Seq-Exists pic 9.
     03  Aircraft-Seq-Exists  pic 9.
     03  Airfield-Seq-Exists  pic 9.
*>
 01  filler.                 *> In English but change to your language if needed.
*>
*> THIS BLOCK SHOULD NOT OCCUR ASSUMING PROGRAMMER DEFINED THE FILE RECORDS CORRECTLY.
*>
     03  SY001          pic x(40) value "SY001 Fltlog length not same as back up ".
     03  SY002          pic x(42) value "SY002 Airfield length not same as back up ".
     03  SY003          pic x(47) value "SY003 Aircraft file length not same as back up ".
     03  SY004          pic x(13) value "Flight log = ".
     03  SY005          pic x(11) value "Airfield = ".
     03  SY006          pic x(11) value "Aircraft = ".
     03  SY007          pic x(14) value "Flight Bkup = ".
     03  SY008          pic x(19) value "Airfield Bkup = ".
     03  SY009          pic x(16) value "Aircraft bkup = ".
*>
*> THESE TWO IF TERMINAL PROGRAM SET UP TOO SMALL, MUST BE WIDTH => 106
*>                                               , LENGTH =>24
*>
     03  SY010          pic x(46) value "SY010 Terminal program not set to length => 24".
 *>    03  SY011          pic x(47) value "SY011 Terminal program not set to Columns => 92".
     03  SY012          pic x(43) value "SY012 Cannot display menu option F as < 106".
*>
*>  THESE ARE ONLY FOR CSV DEFINITION OR DATA ERRORS
*>
     03  SY021          pic x(46) value "SY021 Bad data in CSV layout record - Aborting".
     03  SY022          pic x(44) value "SY022 Too many type 1 recs (> 96) - Aborting".
     03  SY023          pic x(38) value "SY023 Bad CSV type 2 record - Aborting".
     03  SY024          pic x(46) value "SY024 Not enough CSV fields defined - Aborting".
*>
*> PRIMARY PROGRAM ERROR AND WARNING MESSAGES.
*>
     03  FL001          pic x(39) value "FL001 Hit return when ready to continue".
     03  FL002          pic x(51) value "FL002 record does NOT exist. Hit return to continue".
     03  FL003          pic x(53) value "FL003 record error on rewrite. Hit return to continue".
     03  FL004          pic x(19) value "FL004 Record Exists".
     03  FL005          pic x(49) value "is a new entry. Enter Y if ok, else N to re-enter".
     03  FL006          pic x(29) value "Hit return to abort Correctly".
     03  FL007          pic x(53) value "is a new entry. Enter spaces to re-enter or give name".
     03  FL008          pic x(37) value "FL008 MS not compatible with Capacity".
     03  FL009          pic x(39) value "FL009 Log time > Elapsed time Try again".
     03  FL010          pic x(71) value "FL010 Error on (re)WRITE flightlog file. Hit return to continue - ABORT".
     03  FL011          pic x(35) value "Or to re-enter, press ESCape or F10".
     03  FL012          pic x(32) value "FL012 Give Pilots name & Lic no.".
     03  FL013          pic x(68) value "FL013 Reading logbook, have found Aircraft type not on file, created".
     03  FL014          pic x(16) value "FL014 Date Error".
     03  FL015          pic x(38) value "FL015 Re-Adjust screen then hit return".
     03  FL016          pic x(50) value "FL016 Flight Data not present yet - option aborted".
     03  FL017          pic x(28) value "FL017 Hit return to continue".
 *>    03  FL018          pic x(46) value "FL018 Correct problem & run fix it routine NOW".
     03  FL019          pic x(41) value "FL019 CSV delimiter used from data record".
     03  FL020          pic x(23) value "FL020 Enter Y or N only".
     03  FL021          pic x(23) value "FL021 Enter M or S only".
     03  FL022          pic x(44) value "FL022 or Inst. time > Elapsed time try again".
     03  FL023          pic x(24) value "FL023 Airfield not found".
     03  FL024          pic x(27) value "FL024 Record does not exist".
     03  FL025          pic x(65) value "FL025 Error on rewriting aircraft record. Hit return to continue.".
     03  FL026          pic x(63) value "FL026 Aircraft table limit reached, Increase size and recompile".
     03  FL027          pic x(63) value "FL027 Airfield table limit reached, Increase size and recompile".
     03  FL028          pic x(60) value "FL028 ISAM Data files do not exist, but Seq does - Recreate?".
     03  FL029          pic x(41) value "FL029 Error on writing Flightlog Seq file".
     03  FL030          pic x(40) value "FL030 Error on writing Aircraft Seq file".
     03  FL031          pic x(40) value "FL031 Error on writing Airfield Seq file".
     03  FL032          pic x(41) value "FL032 Error on writing Flightlog Dat file".
     03  FL033          pic x(40) value "FL033 Error on writing Aircraft Dat file".
     03  FL034          pic x(40) value "FL034 Error on writing Airfield Dat file".
     03  FL035          pic x(24) value "FL035 Aircraft not found".
     03  FL036          pic x(18) value "To Delete press F4".
     03  FL037          pic x(52) value "FL037 No CSV Param file present. Hit return for menu".
     03  FL038          pic x(43) value "FL038 Invalid CSV record type - not = 1 - 6".
     03  FL039          pic x(60) value "FL039 CSV rec type 1 not found or bad, CSV process cancelled".
     03  FL040          pic x(49) value "FL040 CSV import file not found - Aborting import".
     03  FL041          pic x(37) value "FL041 Flight log entry already exists".
     03  FL042          pic x(40) value "FL042 Writing flitelog from CSV Error ->".
     03  FL043          pic x(31) value "FL043 Bad CSV Start/End time - ".
     03  FL044          pic x(54) value "FL044 No A/c type present or no match on Aircraft file".
     03  FL045          pic x(38) value "FL045 No x1,2 or 3 data present/set up".
     03  FL046          pic x(41) value "FL046 Computed value may not be accurate.".
     03  FL047          pic x(37) value "FL047 No IFR time data present/set up".
     03  FL048          pic x(43) value "FL048 Flight Capacity data NOT x1, x2 or x3".
     03  FL049          pic x(44) value "Note that dates are checked for valid format".
     03  FL050          pic x(65) value "Spaces for dates gives ALL & space for last, means ALL from start".
*>
 01  WS-Data.
     03  WS-Env-Columns pic 999               value zero. *> chks for > 95 & 105
     03  WS-Env-Lines   pic 999               value zero. *> chks for > 23
     03  ws-Lines        binary-char unsigned value zero.
     03  ws-18-Lines     binary-char unsigned value zero.  *> 19/20 for testing only.
     03  ws-19-Lines     binary-char unsigned value zero.  *> 19/20 for testing only.
     03  ws-20-Lines     binary-char unsigned value zero.
     03  ws-21-Lines     binary-char unsigned value zero.
     03  ws-22-Lines     binary-char unsigned value zero.
     03  ws-23-Lines     binary-char unsigned value zero.
     03  WS-Data-Lines   binary-char unsigned value zero.
*>
*> For saving and restoring screen for Afld and Aircraft display lists (function keys F1 and F3).
*>
  01  wScreenName             pic x(256).
  01  wInt                    binary-long.
*>
 01  accept-terminator-array pic 9(4)         value zero.    *> most unused, removed to marked out.
  *>   copy "screenio.cpy".
 *> 78  cob-color-black     value 0.
 *> 78  COB-COLOR-BLUE      VALUE 1.
 78  COB-COLOR-GREEN     VALUE 2.
 78  COB-COLOR-CYAN      VALUE 3.
 78  COB-COLOR-RED       VALUE 4.
 *> 78  COB-COLOR-MAGENTA   VALUE 5.
 78  COB-COLOR-YELLOW    VALUE 6.
 78  COB-COLOR-WHITE     VALUE 7.
*>
*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS) F13-64 omitted.
*> Normal return - Value 0000
 *> 78  COB-SCR-OK          VALUE 0.
*>  Function keys - Values 1xxx
 78  COB-SCR-F1          VALUE 1001.
 78  COB-SCR-F2          VALUE 1002.
 78  COB-SCR-F3          VALUE 1003.
 78  COB-SCR-F4          VALUE 1004.
 78  COB-SCR-F5          VALUE 1005.
 *> 78  COB-SCR-F6          VALUE 1006.
 *> 78  COB-SCR-F7          VALUE 1007.
 *> 78  COB-SCR-F8          VALUE 1008.
 *> 78  COB-SCR-F9          VALUE 1009.
 78  COB-SCR-F10         VALUE 1010.
 *>  Exception keys - Values 2xxx  - unused removed
 78  COB-SCR-ESC         VALUE 2005.
*>  The following exception keys are currently *only* returned on ACCEPT OMITTED
 *> 78  COB-SCR-INSERT      VALUE 2011.
 *> 78  COB-SCR-DELETE      VALUE 2012.
*>
 01  WS-Scrn-Prompt3         PIC X(0079) VALUE " Any key for more,  Escape to quit".
 01  WS-Scrn-Prompt4         PIC X(0079) VALUE " Return to finish".
 01  WS-Scrn-Prompt5         PIC X(0079) VALUE
     "F1=View Afld, F2=Next Rec, F3=View Acft, F4=Delete, F10=Prev field, Esc=Quit".
 01  WS-Scrn-Prompt5B        PIC X(0079) VALUE
     "F1=View Afld,              F3=View Acft, F5=Save,   F10=Prev field, Esc=Quit".
 01  WS-Scrn-Prompt6         PIC X(0079) VALUE
     "F1=View Afld,              F3=View Acft             F10=Prev field, Esc=Quit".
*>
*> Used for checking for existing data and SEQ files.
*>
 01  Cbl-File-Details.
     03  Cbl-File-Size      pic x(8)       comp-x  value zero.
     03  Cbl-File-Date      pic x(4)       comp-x  value zero.
     03  Cbl-File-time      pic x(4)       comp-x  value zero.
*>
 01  WS-TIMES.
     03  WSB-TIME.
         05  WSB-HH          PIC 99.
         05  WSB-MM          PIC 99.
         05  WSB-SS          PIC 99.
         05  FILLER          PIC XX.
     03  WSD-TIME.
         05  WSD-HH          PIC 99.
         05  filler          PIC X  VALUE ":".
         05  WSD-MM          PIC 99.
         05  filler          PIC X  VALUE ":".
         05  WSD-SS          PIC 99.
     03  WSE-TIME            PIC 99.99 VALUE ZERO.
     03  WSF-TIME REDEFINES WSE-TIME.
         05  WSF-HH          PIC 99.
         05  WSF-DOT         PIC X.
         05  WSF-MM          PIC 99.
     03  WSH-TIME            PIC 9(4)  VALUE ZERO.  *> was comp
*>
 01  FS-REPLY.
     03  S1                  PIC X.
     03  S2                  PIC X.
*>
 01  CURS                    PIC 9(4).   *> Hold cursor position
*>
 01  SYS-MESSAGE             PIC X(38).  *> for File I/O errors
*>
*>  TABLES SECTION
*>  ==============
*>
*>  Estimate of when night fails in any month but of course it moves, around
*>    2 minutes per day.  Data used for start time only.
*>   These figures are for southern UK so change if it is not where you are
*>  THESE ARE A GUIDE ONLY - and very rough, All times are Zulu/GMT/UTC+0.
*>    data is (in order) from January to December and time for each month is when it MUST be Night.
*>       but calcs deduct 1 hour first in order to try and make sure!
*>  Figures below are based on change of sunset is 60 minutes per month (2 mins per day)
*>
 01  Night-In-Month          pic x(24) value "161718192021212019181716".
 01  filler REDEFINES Night-In-Month.
     03  NIM                 pic 99   occurs 12.
*>
*>  Analysis table blocks
*>
 01  AIRCRAFT-TABLE.               *> Should be well above that required for an ATPL.
     03  WST-AIRCRAFT-SIZE   PIC 9999   COMP   VALUE ZERO.
     03  WST-AC-MAX          PIC 9999   COMP   VALUE 1000.
     03  WST-AIRCRAFT-TABLE                    VALUE spaces.
         05  WST-ACFT-Groups                occurs 1000
                                               ASCENDING Key WST-Aircraft  INDEXED BY QQ.
             07  WST-AIRCRAFT    PIC X(8).
             07  WST-AC-Last-FLT pic 9(8).
             07  WST-AC-Last-Reg pic x(6).
             07  WST-AC-MS       PIC X.
             07  WST-AC-Complex  pic x.
             07  WS-AC-Group.                        *> Group moved from WS-AC-ANALYSIS-TOTALS for sorting.
                 09  filler OCCURS 2.
                     11  WS-AC-P1    PIC 9(6)  COMP.
                     11  WS-AC-P2    PIC 9(6)  COMP.
                     11  WS-AC-P3    PIC 9(6)  COMP.
                 09  WS-AC-IFR       PIC 9(6)  COMP.
                 09  WS-AC-INST      PIC 9(6)  COMP.   *> (Giving) Instruction
                 09  WS-AC-MULTI     PIC 9(6)  COMP.
*>
 01  AIRFIELD-TABLE.               *> Should be well above that required for an ATPL - holds afld and stat data
     03  WST-AIRFIELD-SIZE   PIC 9999   COMP   VALUE ZERO.
     03  WST-AFLD-MAX        PIC 9999   COMP   VALUE 2000.
     03  WST-AIRFIELD-TABLE                    VALUE SPACES.
         05  WST-ICAO                    OCCURS 2000
                                             Ascending key WST-AIRFIELD INDEXED BY QQQ.
             07  WST-AIRFIELD      PIC X(4).
             07  WST-AFLD-NAME     PIC X(36).
             07  WST-Afld-Last-Flt pic 9(8).                *> These two are for stat reporting.
             07  WST-Afld-Cnt      pic 9(4).
*>
 01  WS-TOTALS                              value zeros.
     03  WS-ANALYSIS   OCCURS 2.
         05  WS-P1           PIC 9(8)  COMP.
         05  WS-P23          PIC 9(8)  COMP.
         05  WS-INS          PIC 9(8)  COMP.
     03  WS-INSTRUMENT       PIC 9(8)  COMP.
     03  WS-MULTI            PIC 9(8)  COMP.
     03  WS-INSX             PIC 9(8)  COMP.
*>
 01  WS2-TOTALS                              value zeros.
     03  WS2-ANALYSIS  OCCURS 2.
         05  WS2-P1          PIC 9(8)  COMP.
         05  WS2-P23         PIC 9(8)  COMP.
         05  WS2-INS         PIC 9(8)  COMP.
     03  WS2-INSTRUMENT      PIC 9(8)  COMP.
     03  WS2-MULTI           PIC 9(8)  COMP.
     03  WS2-INSX            PIC 9(8)  COMP.
*>
*> This table for certificate of Experience at 30, 91, 182 & 13 mths (as 395 days)
*>  with flitelog read in REVERSE (using 'previous') printing out in order of shortest time.
*>     Recording for tt, night, min. night flights, day and min. day flights
*>                   Instructor, IFR single and multi.
*>   Value added as minutes from flightlog records.
*>
 01  WS4-Totals                            value zeros.  *> Recording time in minutes.
     03  WS4-Analysis  Occurs 2.
         05  WS4-P1          PIC s9(8)  COMP.
         05  WS4-P2          PIC s9(8)  COMP.
         05  WS4-P3          PIC s9(8)  COMP.
         05  WS4-INS         PIC s9(8)  COMP.
     03  WS4-INSTRUMENT      PIC s9(8)  COMP.
     03  WS4-MULTI           PIC s9(8)  COMP.
     03  WS4-Single          pic s9(8)  comp.
     03  WS4-INSX            PIC s9(8)  COMP.
     03  WS4-Nite-Flights    pic s9(6)  comp.       *> Will only show flights
     03  WS4-Day-Flights     pic s9(6)  comp.       *>  ditto.
     03  WS4-Total           pic s9(8)  comp.
*>
*>  CSV Data table type 1, as read from file and held while processing - all others processed as read in.
*>
 01  WS-CSV-Logbook-Data-Definitions.
     03  WS-CSV-Table-Size    pic 99            value zero.
     03  SW-CSV-Date-Received pic 9             value zero.
         88  SW-CSV-Received-Date               value 1.
     03  SW-CSV-Data-Received pic 9             value zero.
         88  SW-CSV-Received-Data               value 1.
     03  WS-CSV-Date-Format   pic 99            value zero.   *> See value in WS-CSV-Held-Date-Time-Formats
     03  WS-CSV-Time-1-Format pic 9             value zero.   *> See value in WS-CSV-Held-Time1-Format
     03  WS-CSV-Time-2-Format pic 9             value zero.   *> See value in WS-CSV-Held-Time2-Format
     03  WS-CSV-Work                            value spaces. *> FLT file is max of 32 (Remarks)
         05  WS-CSV-Work9     pic 9(8).                       *> max size of date or time
         05  filler           pic x(56).
     03  WS-CSV-WorkX  redefines WS-CSV-Work
                              pic x(64).
     03  WS-CSV-Tmp-Work9     pic 9(8).
     03  WS-CSV-Work-Delim    pic xx.
     03  WS-CSV-Work-Count    pic 9(4)          value zero.   *> but will be less than 33
     03  WS-CSV-Test-Time-Format  pic 9.
     03  WS-Tmp-Delim         pic xx.
*>
     03  WS-Group.
       04  filler                             occurs 96.
         05  WS-CSV-Src-Position    pic 99.       *> Field # start with 1, leading zero as needed - Must always be 2 numeric digits.
         05  WS-CSV-Target-Fld-Pos  pic 99.       *> position from 1, for FLT file data record otherwise zeros.
 *>        05  WS-CSV-Src-No-Quotes   pic 9.        *>  1 = no quotes around field.  NOT USED.
*>
 01  WS-CSV-Held-Date-Time-Formats                  value spaces. *> CSV Data table type 2 date/time formats
     03  WS-CSV-Held-Date-Format  pic x(10).
     03  WS-CSV-Held-Time1-Format pic x(5).
     03  WS-CSV-Held-Time2-Format pic x(5).
*>
 01  filler.                       *> WS-CSV-Captain-Subsitute.
     03  WS-CSV-Held-Cap     pic x(30)         value spaces.
     03  WS-CSV-Cap-Sub-Name pic x(15)         value spaces.
     03  WS-CSV-Rec-Pos4Search
                             pic 99            value zeros.
     03  WS-CSV-New-Cap      pic xx            value spaces.
*>
*>  Display and reports
*>  ===================
*>
 01  D-Display1                                VALUE SPACES.
     03  D-ICAO-CODE         PIC X(4).
     03  FILLER              PIC X.
     03  D-AFLD-NAME         PIC X(36).
*>
 01  D-Display2                                VALUE SPACES.
     03  D-Aircraft          PIC X(8).
     03  FILLER              PIC XXX.
     03  D-Ac-MS             PIC X.
     03  FILLER              PIC XXX.
*>
*> Must be here as created during other print output creation & would be over written.
*>
 01  SUB-REPORT1.
     03  SR1-ZAP-INS.
         05  sr1-lit1a       pic x(4)         value spaces.
         05  sr1-ins1        pic z(4)9B       value spaces.
         05  sr1-lit1b       pic x(5)         value spaces.
         05  sr1-ins2        pic z(4)9B       value spaces.
         05  SR1-LIT1        PIC X(5)         VALUE SPACES.
         05  SR1-INS         PIC Z(4)9B       VALUE SPACES.
     03  SR1-DISP.
         05  SR1-FIL1        PIC X(6)         VALUE "Grand".
         05  SR1-GRAND       PIC Z(4)9.
         05  filler          PIC X(2)         VALUE SPACES.
         05  SR1-LIT2        PIC X(23).
         05  SR1-P1          PIC Z(4)9   OCCURS 2.
         05  SR1-P2          PIC Z(4)9   OCCURS 2.
         05  SR1-IFR         PIC Z(4)9.
         05  SR1-MULTI       PIC Z(4)9BB.
         05  FILLER          PIC X(4)         VALUE "Hrs".
*>
  01  SUB-REPORT2.
     03  SR2-ZAP-INS                          value spaces.
         05  sr2-lit1a       pic x(4).
         05  sr2-ins1        pic zzz99B.
         05  sr2-lit1b       pic x(5).
         05  sr2-ins2        pic zzz99B.
         05  SR2-LIT1        PIC X(5).
         05  SR2-INS         PIC ZZZ99B.
     03  SR2-DISP.
         05  filler          PIC X(09)        VALUE "Total".
         05  SR2-GRAND       PIC 99.
         05  filler          PIC X(2)         VALUE SPACES.
         05  SR2-LIT2        PIC X(23).
         05  SR2-P1          PIC Z(3)99  OCCURS 2.
         05  SR2-P2          PIC Z(3)99  OCCURS 2.
         05  SR2-IFR         PIC Z(3)99.
         05  SR2-MULTI       PIC Z(3)99BB.
         05  FILLER          PIC X(4)         VALUE "Mins".
*>
*> Tables for data conversion between EBCDIC and ASCII
*>  for use within CSV format conversion.
*>
 *> 01  Table-ASCII.
 *>    03  T-ACSII-Def.
 *>        05  filler          pic x(16)         value
 *>            X"2227272E2C2826293B2F3C3E3F3A3D5C".                                *> " ' ' . , ( & ) ; / < > ? : = \
 *>        05  filler          pic x(63)         value
 *>            " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ".
 *>    03  T-ASCII-Itm redefines T-ACSII-Def
 *>                            pic x         occurs 79.
 *> 01  Table-EBCDIC.
 *>    03  T-EBCDIC-Def.
 *>        05  filler              pic x(16)     value
 *>            X"7F797D4B6B4D505D5E614C6E6F7A7EE0".                             *> " ' ' . , ( & ) ; / < > ? : = \ "79" in case mistyped but is a `
 *>        05  filler              pic x(11)     value
 *>            X"40F0F1F2F3F4F5F6F7F8F9".                 *> SPACE, 0123456789
 *>        05  filler              pic x(9)      value
 *>            X"C1C2C3C4C5C6C7C8C9".                     *> ABCDEFGHI
 *>        05  filler              pic x(9)      value
 *>            X"D1D2D3D4D5D6D7D8D9".                     *> JKLMNOPQR
 *>        05  filler              pic x(8)      value
 *>            X"E2E3E4E5E6E7E8E9".                       *> STUVWXYZ
 *>        05  filler              pic x(9)      value
 *>            X"818283848586878889".                     *> abcdefghi
 *>        05  filler              pic x(9)      value
 *>            X"919293949596979899".                     *> jklmnopqr
 *>        05  filler              pic x(8)      value
 *>            X"A2A3A4A5A6A7A8A9".                       *> stuvwxyz
 *>    03  T-EBCDIC-Itm     redefines T-EBCDIC-Def
 *>                                pic x     occurs 79.
*>
 PROCEDURE DIVISION chaining P1 P2 P3.
*>===================================
 A000-CONTROL       SECTION.
     move     function length (FLIGHTLOG-Record)       to WS-Rec-Length-1.
     move     function length (FLIGHTLOGBACKUP-RECORD) to WS-Rec-Length-2.
     if       WS-Rec-Length-1 not = WS-Rec-Length-2
              display SY001 at 0101 with erase eos
              move    ws-rec-length-1  to ws-display4
              display SY004  ws-display4 at 0201
              move    ws-rec-length-2  to ws-display4
              display SY007 ws-display4 at 0301
              goback.
*>
     move     function length (Airfield-Record)       to WS-Rec-Length-1.
     move     function length (AirfieldBackup-RECORD) to WS-Rec-Length-2.
     if       WS-Rec-Length-1 not = WS-Rec-Length-2
              display SY002 at 0401 with erase eos
              move    ws-rec-length-1  to ws-display4
              display SY005  ws-display4 at 0501
              move    ws-rec-length-2  to ws-display4
              display SY008 ws-display4 at 0601
              goback.
*>
     move     function length (Aircraft-Record)       to WS-Rec-Length-1.
     move     function length (AircraftBACKUP-RECORD) to WS-Rec-Length-2.
     if       WS-Rec-Length-1 not = WS-Rec-Length-2
              display SY003 at 0701 with erase eos
              move    ws-rec-length-1  to ws-display4
              display SY006 ws-display4 at 0801
              move    ws-rec-length-2  to ws-display4
              display SY009 ws-display4 at 0901
              goback.
*>
*>  Now that any programming errors on file layout has been checked lets start the program.
*>     Force Esc, PgUp, PgDown, PrtSC to be detected and, stop program end wait msg.
*>
     set      ENVIRONMENT "COB_SCREEN_EXCEPTIONS" to "Y".
     set      ENVIRONMENT "COB_SCREEN_ESC" to "Y".
     set      ENVIRONMENT "COB_EXIT_WAIT"  to "N".
*>
     if       P1 (1:2) = "HE" or "he" or "-H" or "-h"
              display "Parameter Help for " at 0101 with erase eos
              display Prog-Name at 0120
              display "P1 = NONIGHT or NONITE for no night time calcs against table" at 0301
              display "P2 = 'CSV=' CSV path and file name for Config file if not default"   at 0401
              display "P3 = ACFT-DATE for report excludes unused Aircraft"           at 0501
              display "P4 = EBCDIC conversion of CSV data [NOT CURRENTLY IN USE]"    at 0601
              display FL006 at 0801
              accept ws-reply at 0831
              goback.
*>
     if       P1 (1:8) = "CSV-TEST"
              set SW-Testing to true
     end-if.
     if       "NONIGHT" = P1 or = P2 or = P3
              move 1 to NO-NIGHT-Calcs.
     if       "NONITE" = P1 or = P2 or = P3
     move     spaces to P-Temp.
     if       P1 (1:4) = "CSV="  move P1 (5:60) to P-Temp.
     if       P2 (1:4) = "CSV="  move P2 (5:60) to P-Temp.
     if       P3 (1:4) = "CSV="  move P3 (5:60) to P-Temp.
     if       P-Temp (1:8) not = spaces
              move P-Temp to CSV-Config-Name.
 *>    if       "NIGHT" or "NITE" = P1 or = P2 or = P3
 *>             move zero to NO-NIGHT-Calcs.
*>
     if       "ACFT-DATE" = P3 or = P2 or = P1
              move 1 to SW-ACFT-Date.
*>
*>  Set WS-Locale-Time-Zone from LC_TIME - Default [3] to Intl (ccyymmdd)
*>
     accept   WS-Locale from Environment "LC_TIME" on exception
              move    3 to WS-Local-Time-Zone.    *> Intl / Unix
     if       WS-Locale (1:5) = "en_GB" or "EN_GB"
              move    1 to WS-Local-Time-Zone
     else
      if      WS-Locale (1:6) = "en_US " or "EN_USA"
              move    2 to WS-Local-Time-Zone    *> others before the period
      else
              move    3 to WS-Local-Time-Zone.    *> Intl / Unix
*>
     move     function current-date to WSE-Date-Block.
     perform  ZQ000-Convert-Date.     *> O/P in WSF-Date in LOCALE format
     ACCEPT   WSA-DATE FROM DATE YYYYMMDD.
     if       WSE-Date9 not = 00000000
              move WSE-Date9 to WS-Today.    *> Intl     - - YYYY needed for some routines.
*>
 A010-Get-Screen-Attr.
*> 1st make sure running in screen of columns 91 (or 106 for display anal (F)
*>     by 24 lines or better.
*>
     accept   WS-Env-Columns from Columns.
     if       WS-Env-Columns < 106
              display SY012    at 0101 with erase eos
              display FL015    at 0201
              accept  ws-reply at 0240
              go to A010-Get-Screen-Attr.
     accept   WS-Env-Lines   from lines.
     if       WS-Env-Lines < 24
              display SY010    at 0101 with erase eos
              display FL015    at 0201
              accept  ws-reply at 0240
              go to A010-Get-Screen-Attr.
     move     WS-Env-Lines to ws-Lines.
*>
     subtract 1 from ws-Lines giving ws-23-Lines.
     subtract 2 from ws-Lines giving ws-22-Lines.
     subtract 3 from ws-Lines giving ws-21-Lines.
     subtract 4 from ws-Lines giving WS-Data-Lines.
     subtract 4 from ws-Lines giving WS-20-Lines.      *> TESTING ONLY and the next one.
     subtract 5 from ws-Lines giving WS-19-Lines.
     subtract 6 from ws-Lines giving WS-18-Lines.
*>
*> Set up afld display counts from ws-lines using WS-Dft-Scrn-BE-xxx
*>
     subtract 5 from WS-Lines giving WS-Dft-Scrn-BE-Cnt.
     subtract 4 from WS-Lines giving WS-Dft-Scrn-BE-Length.
     multiply 100 by WS-Dft-Scrn-BE-Length.
*>
*> Get date and time of last flight Open and/or Read REVERSED would have been easier!
*>   Date will be used initially for log book date entry.
*>
     move     zeros to Save-Flt-Date  Save-FLT-Start.
     open     Input Flightlog-File.
     if       FS-Reply = "00"
              start    Flightlog-File last
              read     Flightlog-File next record  *> if no data then next two will be zeros
              move     FLT-Date   to Save-FLT-Date
              move     FLT-Start  to Save-FLT-Start
              close    Flightlog-File
     end-if.
*>
     perform  D000-Setup-Datafiles.    *> created if not exist then left closed
     open     output Print-File.       *> Note that printed o/p will be released only after CLOSE at EOJ.
     open     I-O Airfield-File Aircraft-File Flightlog-File.
*>
 A020-DISPLAY-MENU.
     DISPLAY  SPACE at 0101 with erase eos.
     DISPLAY  "Copyright (c) 1986-2299 Vincent B Coen FMBS, Applewood Computers, Hatfield, UK"
                        line ws-Lines col 01 WITH foreground-color COB-COLOR-Red.
     display  WSE-Year  line ws-Lines col 20 with foreground-color COB-COLOR-RED.
     DISPLAY  PROG-NAME AT 0101 WITH foreground-color COB-COLOR-GREEN.
*>
     ACCEPT   WSB-TIME FROM TIME.
     IF       WSB-TIME NOT = "00000000"
              MOVE WSB-HH TO WSD-HH
              MOVE WSB-MM TO WSD-MM
              MOVE WSB-SS TO WSD-SS
              MOVE WSD-TIME TO WS-TIME
              DISPLAY "at " AT 0155 WITH foreground-color COB-COLOR-Green
              DISPLAY WSD-TIME AT 0158 WITH foreground-color COB-COLOR-Green.
*>
     DISPLAY  "on " AT 0167 WITH foreground-color COB-COLOR-Green.
     DISPLAY  WSF-Date AT 0170 WITH foreground-color COB-COLOR-Green.
     move     space to Menu-Reply.
*>
 A030-DISPLAY-GO.
     perform  C000-EDIT-LOG-BOOK.
     go       to A900-EOJ.
*>
 A050-Get-User-Details.
     DISPLAY  FL012 AT line ws-22-Lines col 01 WITH foreground-color COB-COLOR-Yellow with erase eol.
     DISPLAY  "[" AT line ws-23-Lines col 01 WITH foreground-color COB-COLOR-Yellow with erase eol.
     DISPLAY  "]" AT line ws-23-Lines col 42 WITH foreground-color COB-COLOR-Yellow.
     ACCEPT   WS-USER AT line ws-23-Lines col 02 with update.
     display  space at line ws-22-Lines col 01 with erase eol.
     display  space at line ws-23-Lines col 01 with erase eol.
*>
 A900-EOJ.
     close    Print-File Airfield-File Aircraft-File Flightlog-File.
     goback.
*>
 B000-EDIT-AIRFIELD-DATA   SECTION.
*>=================================
*>
 B020-DISPLAY-AFLD-MENU.
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Airfield Edit Program" AT 0130 WITH foreground-color COB-COLOR-Green.
     DISPLAY  "+-------------+"       AT 1264 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| ACTIONS     |"       AT 1364 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| A = Amend   |"       AT 1464 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| D = Delete  |"       AT 1564 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| I = Insert  |"       AT 1664 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| L = List    |"       AT 1764 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| V = View    |"       AT 1864 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| X = Quit    |"       AT 1964 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "| Esc = Quit  |"       AT 2064 WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  "+-------------+"       AT 2164 WITH foreground-color COB-COLOR-GREEN.
     MOVE     SPACES TO MENU-REPLY.
     PERFORM  ZB000-LOAD-AIRFIELDS.
     if       Return-code not = zero
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to B999-Exit.
*>
 B030-DISPLAY-AFLD-MENU2.
     DISPLAY  "ICAO" AT 0641 WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "Action    Code    Airfield Name" AT 0731 WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  " [ ]     [    ]   ["             AT 0831 WITH foreground-color COB-COLOR-Yellow.
     display  "]"                               at 0886 WITH foreground-color COB-COLOR-Yellow.
     display  "ICAO code spaces for options V and L" at 1040 with foreground-color COB-Color-Yellow.
     DISPLAY  SPACE AT line ws-22-Lines col 01 with erase eol.
     DISPLAY  SPACE AT line ws-23-Lines col 01 with erase eol.
*>
 B040-EDIT-AFLD-FUNCTION.
     ACCEPT   MENU-REPLY AT 0833 auto.
     move     function upper-case (MENU-REPLY) to MENU-REPLY.
     IF       MENU-REPLY = "X"
       or     Cob-Crt-Status = Cob-Scr-Esc
              perform  ZP000-SAVE-AIRFIELDS
              GO TO B999-EXIT.
*>
 B050-EDIT-AFLD-GET-CODE.
     MOVE     SPACES TO WS-ICAO-CODE.
     ACCEPT   WS-ICAO-CODE AT 0841.              *> Used for List and View
     move     function upper-case (WS-ICAO-Code) to WS-ICAO-Code.
*>
     IF       MENU-REPLY = "L"
              move zero to SW-AFLD-Used
              PERFORM CCD000-Airfield-Lists
              GO TO B030-DISPLAY-AFLD-MENU2.
*>
     IF       MENU-REPLY = "V"
              move 0202 to WS-Scrn-BE-Head
              move 0302 to WS-Scrn-BE-Start
              move WS-Dft-Scrn-BE-Length to WS-Scrn-BE-Length
              move WS-Dft-Scrn-BE-Cnt    to WS-Scrn-BE-Cnt
              PERFORM BE000-VIEW-AFLD
              GO TO B020-DISPLAY-AFLD-MENU.
*>
     IF       WS-ICAO-CODE = SPACES
              GO TO B040-EDIT-AFLD-FUNCTION.
*>
     IF       MENU-REPLY = "A"
              PERFORM BB000-AMEND-AFLD
              GO TO B030-DISPLAY-AFLD-MENU2.
*>
     IF       MENU-REPLY = "D"
              PERFORM BC000-DELETE-AFLD
              GO TO B030-DISPLAY-AFLD-MENU2.
*>
     IF       MENU-REPLY NOT = "I"
              GO TO B030-DISPLAY-AFLD-MENU2.
*>
*> B060-EDIT-AFLD-GET-NAME.
     MOVE     SPACES TO WS-AFLD-NAME.
     ACCEPT   WS-AFLD-NAME AT 0850.
     IF       WS-AFLD-NAME = SPACES
          or  WS-AFLD-NAME not alphabetic
              GO TO B050-EDIT-AFLD-GET-CODE.
*>
     PERFORM  BD000-INSERT-AFLD.
     GO       TO B030-DISPLAY-AFLD-MENU2.
*>
 B999-EXIT.   exit section.
*>
 BB000-AMEND-AFLD      SECTION.
*>============================
*>
     MOVE     WS-ICAO-CODE TO ICAO-CODE.
     READ     AIRFIELD-FILE INVALID KEY   MOVE HIGH-VALUES TO FS-REPLY.
*>
     IF       FS-REPLY NOT = "00"
              DISPLAY FL002 at line ws-22-Lines col 01
              accept  ws-reply at line ws-22-Lines col 61
              GO TO BB999-EXIT.
*>
     ACCEPT   AFLD-NAME AT 0850 with update.
     REWRITE  AIRFIELD-RECORD INVALID KEY   MOVE HIGH-VALUES TO FS-REPLY.
*>
     IF       FS-REPLY NOT = "00"
              DISPLAY FL003 at line ws-22-Lines col 01
              accept ws-reply at line ws-22-Lines col 63.
*>
 BB999-EXIT.  exit section.
*>
 BC000-DELETE-AFLD     SECTION.
*>============================
*>
     MOVE     WS-ICAO-CODE TO ICAO-CODE.
     DELETE   AIRFIELD-FILE INVALID KEY
              DISPLAY FL002 at line ws-22-Lines col 01
              accept ws-reply at line ws-22-Lines col 63.
*>
 BC999-EXIT.  exit section.
*>
 BD000-INSERT-AFLD     SECTION.
*>============================
*>
*>  Got ws-afld-name already
*>
     if       WS-Afld-Name not alphabetic
         or   WS-ICAO-Code not alphabetic
              move 4 to Return-Code
              go to BD999-Exit.
     MOVE     WS-AFLD-NAME TO AFLD-NAME.
     MOVE     WS-ICAO-CODE TO ICAO-CODE.
     move     zeros        to AFLD-Last-Flt.
*>
     WRITE    AIRFIELD-RECORD INVALID KEY
              DISPLAY FL004 AT line ws-22-Lines col 01 with foreground-color COB-COLOR-RED
              move 8 to Return-Code
          NOT INVALID KEY display space at line ws-22-Lines col 01 with erase eol
              move zero to Return-Code.
*>
 BD999-EXIT.  exit section.
*>
 BE000-VIEW-AFLD      SECTION.
*>============================
*>
     MOVE     ZERO TO PAGE-CNT Line-cnt ERROR-CODE ICAO-CODE.
     Move     WS-Scrn-BE-Start to curs.
     PERFORM  BE040-VIEW-AFLD-HEADS.
*>
     If       WS-ICAO-Code = spaces
              START    AIRFIELD-FILE FIRST
     else
              Move     WS-ICAO-Code to ICAO-Code
              START    AIRFIELD-FILE KEY not < ICAO-CODE Invalid key  MOVE HIGH-VALUES TO FS-REPLY.
*>
     Inspect  WS-ICAO-Code replacing all spaces by "Z".
*>
 BE020-VIEW-AFLD3.
     READ     AIRFIELD-FILE NEXT RECORD AT END
              GO TO BE060-VIEW-AFLD-END.
     IF       ICAO-Code > WS-ICAO-Code
              GO TO BE060-VIEW-AFLD-END.
     MOVE     ICAO-CODE TO D-ICAO-CODE.
     MOVE     AFLD-NAME TO D-AFLD-NAME.
*>
     DISPLAY  D-DISPLAY1 AT CURS with foreground-color COB-COLOR-CYAN.
     ADD      100 TO CURS.
     ADD      1 TO LINE-CNT.
*>
     If       line-cnt > WS-Scrn-BE-Cnt
        and   page-cnt > 1
              go to BE050-View-Afld5.
*>
     IF       LINE-CNT > WS-Scrn-BE-Cnt
              MOVE ZERO TO LINE-CNT
              add 1 to page-cnt
              add 42 to curs
              subtract WS-Scrn-BE-Length from curs.
     GO       TO BE020-View-AFLD3.
*>
 BE040-VIEW-AFLD-HEADS.
     DISPLAY  SPACE at 0101 with erase eos.
     move     WS-Scrn-BE-Head to WS-Scrn-BE-Curs.
     DISPLAY  "ICAO AIRFIELD" AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      42 to WS-Scrn-BE-Curs.
     DISPLAY  "ICAO AIRFIELD" AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      42 to WS-Scrn-BE-Curs.
     DISPLAY  "ICAO AIRFIELD" AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  WS-Scrn-Prompt3 line ws-Lines col 01 WITH foreground-color COB-COLOR-White.
*>
 BE050-VIEW-AFLD5.
     move     space to menu-reply.
     accept   menu-reply line ws-Lines col 36.
     If       Cob-Crt-Status = Cob-Scr-Esc
              go to BE999-Exit.
     move     WS-Scrn-BE-Start to curs.
     move     zero to line-cnt page-cnt.
     perform  BE040-View-Afld-Heads.
     GO       TO BE020-VIEW-AFLD3.
*>
 BE060-VIEW-AFLD-END.
     DISPLAY  WS-Scrn-Prompt4 line ws-Lines col 01 WITH foreground-color COB-COLOR-White.
     move     space to menu-reply.
     Accept   menu-reply line ws-Lines col 19.
*>
 BE999-EXIT.  exit section.
*>
 C000-EDIT-LOG-BOOK    SECTION.
*>============================
*>
*>
 C020-DISPLAY-LOG-MENU.
     MOVE     ZERO TO DISPLAY-FLAG        MONTHLY-ANAL-FLAG
                      ANALYSIS-ONLY-FLAG  INS-FLAG.
     MOVE     SPACE TO MENU-REPLY.
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Flight Log Book Program" AT 0130 WITH foreground-color COB-COLOR-Green.
     DISPLAY  "Select one of the following by letter  :- [ ]" AT 0401 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(A)  Enter Log Book Data"            AT 0615 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(B)  Amend Log Book Data"            AT 0715 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(C)  Log Book Reports"               AT 0815 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(D)  Log Book Report & Monthly Analysis" AT 0915 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(E)  Analysis & Totals Report"       AT 1015 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(F)  Analysis & Totals Display"      AT 1115 WITH foreground-color COB-COLOR-CYAN.
     display  "(G)  Cert of Ext. Analysis Report"   at 1215 WITH foreground-color COB-COLOR-CYAN.
     display  "(H)  Change Log Book Airfield Code"  at 1415 WITH foreground-color COB-COLOR-CYAN.
     display  "(J)  Change Log Book Aircraft Type"  at 1515 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(K)  Edit Airfield Name"             AT 1615 WITH FOREGROUND-COLOUR 3.
     display  "(S)  Create Sequential files from ISAM" at 1815 with FOREGROUND-COLOUR 3.
     display  "(T)  Import CSV Data and Parameters" at 1915 WITH foreground-color COB-COLOR-CYAN.
     display  "(U)  Enter User details for Reports" at 2015 WITH foreground-color COB-COLOR-CYAN.
     DISPLAY  "(X)  Quit Log Book System"           AT 2215 WITH foreground-color COB-COLOR-CYAN.
*>
 C030-ACCEPT-LOGBOOK.
     move     zero to Print-Report-Type.
     ACCEPT   MENU-REPLY AT 0444 with auto.
     move     function upper-case (MENU-REPLY) to MENU-REPLY  Menu-Option.
*>
     IF       MENU-REPLY = "X"
        or    Cob-Crt-Status = Cob-Scr-Esc
              DISPLAY SPACE at 0101 with erase eos
              GO TO   C999-EXIT.
*>
     IF       MENU-REPLY = "A" or "B"
              PERFORM CA000-ENTER-LOGBOOK
              GO TO C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "C"
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     if       Menu-Reply = "3"
              move 1 to Print-Report-Type
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "D"
              MOVE 1 TO MONTHLY-ANAL-FLAG
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     if       Menu-Reply = "4"
              move 1 to Print-Report-Type
              MOVE 1 TO MONTHLY-ANAL-FLAG
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "E"
              MOVE 1 TO ANALYSIS-ONLY-FLAG
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "F"
              MOVE 1 TO DISPLAY-FLAG ANALYSIS-ONLY-FLAG
              PERFORM CC000-LOG-BOOK-REPORT
              GO TO C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "G"
              perform CCE000-CoE-Analysis
              GO TO C020-DISPLAY-LOG-MENU.
*>
     if       Menu-Reply = "H"
              perform  CD000-Amend-Airfield-Code
              GO TO C020-DISPLAY-LOG-MENU.
*>
     if       Menu-Reply = "J"
              perform  CE000-Amend-Aircraft-Type
              GO TO C020-DISPLAY-LOG-MENU.
*>
     if       Menu-Reply = "T"
              perform F000-Import-CSV-Data
              go to C020-DISPLAY-LOG-MENU.
*>
     IF       Menu-Reply = "U"
              perform A050-Get-User-Details
              go to C020-DISPLAY-LOG-MENU.
*>
     IF       MENU-REPLY = "K"
              PERFORM B000-EDIT-AIRFIELD-DATA
              go to C020-DISPLAY-LOG-MENU.
*>
     IF       Menu-Reply = "S"
              perform ZL000-Create-Seq-Files
              go to C020-DISPLAY-LOG-MENU.
*>
              GO       TO C030-ACCEPT-LOGBOOK.
*>
 C999-EXIT.   exit section.
*>
 CA000-ENTER-LOGBOOK   SECTION.
*>============================
*>
     MOVE     SPACE TO MENU-REPLY.
     move     "00" to FS-Reply.
*>
     move     0202 to WS-Scrn-BE-Head.
     move     0302 to WS-Scrn-BE-Start.                            *> used from here only in CAA000-view-afld!
     move     WS-Dft-Scrn-BE-Length to WS-Scrn-BE-Length.          *> These could be adjusted to match
     move     WS-Dft-Scrn-BE-Cnt    to WS-Scrn-BE-Cnt.             *>   values from screen length - 25/10/18
     move     spaces to WS-ICAO-Code.
*>
 CA020-ENTER-LOGBK-DISPLAY.
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Log Book Data Entry" AT 0128 WITH foreground-color COB-COLOR-GREEN.   *> 'Entry" at cc42
     DISPLAY  "ICAO    ICAO" AT 0352 WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  " Flite Date   A/C Type  A/C Reg   Captain          From     To    Start    End  " AT 0401
              WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "[DD/MM/CCYY] [abcdefgh] [Gabcd] [AAABBBCCCDDDEEE] [YYYY]  [XXXX] [99.99] [99.99]" AT 0501
              WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "          -----Day------      ----Night-----      Inst"       AT 0801 WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "M/S  Cap    P1     P2/3         P1    P2/3          IFR     ------ Remarks ----- - - - - - -" AT 0901
              WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "[X] [XXX] [99.99] [99.99]     [99.99] [99.99]     [99.99]  [" AT 1001 WITH foreground-color COB-COLOR-Yellow.
     display  "]" at 1093  WITH foreground-color COB-COLOR-Yellow.
*>
     if       Menu-Option = "B"
              display "Amend" at 0142 WITH foreground-color COB-COLOR-GREEN.
     if       Menu-Option = "A"
        and   Save-FLT-Date not = zero
              MOVE     Save-FLT-DATE TO WS-Test-Intl
              perform  ZZ060-Convert-Date
     end-if.
*>
 CA030-ENTER-LOGBK-DATE.
     MOVE     ZERO TO A.                       *> For Amends
     if       Menu-Option = "A"
              Display WS-Scrn-Prompt6 at line ws-Lines col 01 with foreground-color COB-COLOR-White with erase eol
     else
              display WS-Scrn-Prompt5 at line ws-Lines col 01 with foreground-color COB-COLOR-White with erase eol
              DISPLAY FL036 AT  0601 WITH foreground-color COB-COLOR-CYAN with erase eol
     end-if.
     ACCEPT   WS-Test-Date AT 0502 with update.
     move     function upper-case (WS-Test-Date) to WS-Test-Date.    *> Needed for NEXT test in (Amend).
*>
     IF       Cob-Crt-Status = Cob-Scr-Esc
          or  WS-Test-Date = SPACES
              GO TO CA999-Exit.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to ca030-enter-logbk-date.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to ca030-enter-logbk-date.
*>
     if       Menu-Option = "B"
        and   Cob-Crt-Status = Cob-Scr-F2
              GO TO CA032-GET-NEXT.
*>
     PERFORM  ZA000-DATE-CHECK.
     perform  ZZ060-Convert-Date.
     display  WS-Test-Date at 0502.
*>
     IF       ERROR-CODE NOT = ZERO
              DISPLAY FL014 AT 1201 with foreground-color COB-COLOR-RED
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     move     WSA-MM to Save-FLT-Mth.           *> for day/night comp.
     DISPLAY  SPACE AT 1201 with erase eol.
     if       Menu-Option = "A"
              MOVE     WSA-DATE2 TO FLT-DATE
              go       to CA040-Enter-LOGBK-AC-TYPE.
     if       Menu-Option = "B"        *> AMEND
              MOVE     WSA-DATE2 TO SAVE-FLT-DATE
                                    FLT-DATE
              go       to CA034-Amend-LOGBK-Get-Time.
*>
 CA032-GET-NEXT.
     READ     FLIGHTLOG-FILE next record AT END  MOVE 2 TO A.
*>
     if       fs-reply not = "00" and not = "10"
              perform  zza-file-status
              go to ca030-Enter-LogBk-Date.
*>
     IF       A > 1
              GO TO CA036-AMEND-LOGBK-GET-RECORD.
*>
     MOVE     FLT-DATE TO WS-Test-Intl.
     perform  ZZ060-Convert-Date.      *> O/p is ws-test-date
     GO       TO CA038-DISPLAY-RECORD.
*>
 CA034-AMEND-LOGBK-GET-TIME.
     display  space at 1201 with erase eol.
     ACCEPT   WSF-TIME AT 0567.
     if       Cob-Crt-Status = Cob-Scr-F10
           or Cob-Crt-Status = Cob-Scr-Esc
              go to CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA034-AMEND-LOGBK-GET-TIME.
*>
     If       Cob-Crt-Status = Cob-Scr-F2
              GO TO CA032-GET-NEXT.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA034-AMEND-LOGBK-GET-TIME.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA034-AMEND-LOGBK-GET-TIME.
     MOVE     WSH-TIME TO SAVE-FLT-START
                          FLT-START.
*>
 CA036-AMEND-LOGBK-GET-RECORD.
     IF       A > 1
              DISPLAY FL002 AT 1201
              GO TO CA030-Enter-LOGBK-DATE.
*>
     READ     FLIGHTLOG-FILE invalid key   move zero to FLT-Date.
     IF       FLT-DATE not = SAVE-FLT-DATE
              DISPLAY FL024 AT 1201 with erase eol
              GO TO CA030-Enter-LOGBK-DATE.
*>
 CA038-DISPLAY-RECORD.
     DISPLAY  WS-Test-Date      AT 0502.
     DISPLAY  FLT-AC-TYPE  AT 0515.
     DISPLAY  FLT-AC-REG (1:5) AT 0526.
     DISPLAY  FLT-CAPTAIN  AT 0534.
     DISPLAY  FLT-FROM     AT 0552.
     DISPLAY  FLT-TO       AT 0560.
     DISPLAY  FLT-MS       AT 1002.
     DISPLAY  FLT-CAPACITY AT 1006.
     DISPLAY  FLT-REMARKS  AT 1061.
     DIVIDE   FLT-START BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     move     "." to wsf-dot.
     DISPLAY  WSE-TIME  AT 0567.
     DIVIDE   FLT-END BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 0575.
     DIVIDE   FLT-P1 (1) BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 1012.
     DIVIDE   FLT-P23 (1) BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 1020.
     DIVIDE   FLT-P1 (2) BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 1032.
     DIVIDE   FLT-P23 (2) BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 1040.
     DIVIDE   FLT-INSTRUMENT BY 60 GIVING WSF-HH REMAINDER WSF-MM.
     DISPLAY  WSE-TIME  AT 1052.
*>
 CA039-AMEND-LOGBK-DATE.          *> Amend date then time by rewrite
     display  space at 1201 with erase eol.
     ACCEPT   WS-Test-Date AT 0502 with update.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA039-AMEND-LOGBK-DATE.
*>
     If       Cob-Crt-Status = Cob-Scr-F2
              go to CA032-Get-Next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA039-AMEND-LOGBK-DATE.
*>
     IF       WS-Test-Date = SPACES
           or Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA999-Exit.
*>
     IF       Cob-Crt-Status = Cob-Scr-F4
         and  Menu-Option = "B"
              DISPLAY "Delete Record - Are you sure [ ]" AT line ws-22-Lines col 01
              ACCEPT MENU-REPLY AT line ws-22-Lines col 31
              IF       (MENU-REPLY = "Y" or "y")
                       MOVE ZEROS TO Save-Flt-Date Save-Flt-Start
                       DELETE FLIGHTLOG-FILE RECORD
                       DISPLAY SPACE AT line ws-22-Lines col 01 with erase eol
                       GO TO CA030-Enter-LOGBK-DATE
              end-if
     end-if
*>
     IF       WS-Test-Date9 = ZEROS or WS-Test-Date = spaces
              DISPLAY SPACE AT line ws-22-Lines col 01 with erase eol
              GO TO CA030-Enter-LOGBK-DATE.
*>
     PERFORM  ZA000-DATE-CHECK.
     perform  ZZ060-Convert-Date.
     display  WS-Test-Date at 0502.
     IF       ERROR-CODE NOT = ZERO
              DISPLAY FL014 AT 1201
              GO TO CA039-AMEND-LOGBK-DATE.
*>
     DISPLAY  space AT  0601 with erase eol.                *> F4, Delete no longer available
     display  "          " at line ws-Lines col 01.
     move     WS-Test-Intl (5:2) to Save-FLT-Mth.           *> for day/night comp & here if date was changed.
     DISPLAY  SPACE AT 1201 with erase eol.
     MOVE     WS-Test-Intl TO FLT-DATE.
*>
 CA040-ENTER-LOGBK-AC-TYPE.
     ACCEPT   FLT-AC-TYPE AT 0515 with update.
     move     function upper-case (FLT-AC-TYPE) to FLT-AC-TYPE.
     display  FLT-AC-Type at 0515.
     IF       Cob-Crt-Status = Cob-Scr-Esc   or   Cob-Crt-Status = Cob-Scr-F10
              GO TO CA030-Enter-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to ca040-enter-logbk-ac-type.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to ca040-enter-logbk-ac-type.
*>
     if       flt-ac-type = spaces
              go to ca040-Enter-Logbk-AC-Type.
*>
     PERFORM  ZH000-SEARCH-FOR-AIRCRAFT.
     if       C not = zero                  *> Record found On file
        and   Aircraft-Last-Reg not = spaces
              move Aircraft-Last-Reg to FLT-AC-Reg
              move Aircraft-MS       to FLT-MS
              GO TO CA060-ENTER-LOGBK-AC-REG.
*>
     IF       C NOT = ZERO
              GO TO CA060-ENTER-LOGBK-AC-REG.
*>
     DISPLAY  FLT-AC-TYPE AT 1201.
     DISPLAY  FL005 AT 1210.
     DISPLAY  "[ ]" AT 1261.
     display  "M or S - [ ]" at 1266.
*>
 CA050-ENTER-LOGBK-AC-TYPE2.                 *> Could add in a/c man and name needed ???
     ACCEPT   MENU-REPLY AT 1262.
     move     function upper-case (MENU-REPLY) to MENU-REPLY.
     IF       MENU-REPLY = "N"
              DISPLAY  SPACE AT 1201 with erase eol
              DISPLAY  SPACE AT 1301 with erase eol
              GO TO CA040-ENTER-LOGBK-AC-TYPE.
     IF       MENU-REPLY NOT = "Y"
              display FL020 at 1340 with erase eol
              GO TO CA050-ENTER-LOGBK-AC-TYPE2.
*>
 CA055-Enter-MS.
     move     "S" to FLT-MS.
     accept   FLT-MS at 1276 with update.
     move     function upper-case (FLT-MS) to FLT-MS.
     if       FLT-MS not = "S" and not = "M"
              display FL021 at 1355 with erase eol
              go to CA055-Enter-MS.
*>
 CA057-Enter-Complex.
     move     "N" to Menu-Reply.
     if       FLT-MS = "S"
              display  "Complex Y or N - [ ]" at 1310
              accept   Menu-Reply at 1328 with update
              move     function upper-case (MENU-REPLY) to MENU-REPLY
              if       Menu-Reply not = "Y" and not = "N"
                       go to CA057-Enter-Complex
              end-if
     else
              move "Y" to Menu-Reply.     *> all multi engines are Complex!
*>
     DISPLAY  SPACE AT 1201 with erase eol.
     DISPLAY  SPACE AT 1301 with erase eol.
     MOVE     FLT-AC-TYPE TO Aircraft-Type.
     MOVE     FLT-MS      TO Aircraft-MS.
     MOVE     SPACES      to Aircraft-Last-Reg.
     move     Menu-Reply  to Aircraft-Complex.
     move     zeros       to Aircraft-Last-Flt.          *> Updated in CA230-ENTER-LOGBK-REMARKS para.
     write    Aircraft-Record.
*>
 CA060-ENTER-LOGBK-AC-REG.
     ACCEPT   FLT-AC-REG (1:5) AT 0526 with update.
     move     function upper-case (FLT-AC-REG) to FLT-AC-REG.
     display  FLT-AC-Reg (1:5) at 0526.
     If       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to Ca060-Enter-Logbk-Ac-Reg.
*>
     if       Menu-Option = "B"
         and  Cob-Crt-Status = Cob-Scr-F2
              go to CA032-Get-Next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to Ca060-Enter-Logbk-Ac-Reg.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA040-ENTER-LOGBK-AC-TYPE.
*>
     if       FLT-AC-Reg = spaces
              go to CA060-Enter-Logbk-Ac-Reg.
     move     FLT-AC-Reg to Aircraft-Last-Reg.
     rewrite  Aircraft-Record.
*>
 CA070-ENTER-LOGBK-CAPTAIN.
     ACCEPT   FLT-CAPTAIN AT 0534 with update.
     move     function upper-case (FLT-CAPTAIN) to FLT-CAPTAIN.
     if       FLT-Captain (1:2) = "S "
              move "SELF" to FLT-Captain.
     display  FLT-Captain at 0534.
     if       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to ca070-enter-logbk-captain.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to ca070-enter-logbk-captain.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA060-ENTER-LOGBK-AC-REG.
*>
     if       FLT-Captain = spaces
              go to ca070-enter-logbk-captain.
     if       FLT-Captain = "SELF"
              move "P1 "  to FLT-Capacity.
*>
 CA080-ENTER-LOGBK-FROM.
     if       Menu-Option = "A"
       and    FLT-TO not = spaces
              MOVE     FLT-TO TO FLT-FROM.
     ACCEPT   FLT-FROM AT 0552 with update.
     move     function upper-case (FLT-FROM) to FLT-FROM.
     if       FLT-From not alphabetic
              go to CA080-Enter-Logbk-From.
     display  FLT-From at 0552.
     if       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to ca080-enter-logbk-from.
*>
     if       Menu-Option = "B"
        and   Cob-Crt-Status = Cob-Scr-F2
              go to CA032-Get-Next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to ca080-enter-logbk-from.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA070-ENTER-LOGBK-CAPTAIN.
*>
     if       FLT-From = spaces
              go to ca080-enter-logbk-from.
*>
     if       Menu-Option = "A"
              MOVE     FLT-FROM TO FLT-TO.
     move     FLT-From to WS-ICAO-CODE.
     PERFORM  ZE000-SEARCH-FOR-ICAO.
*>
     IF       ERROR-CODE NOT = ZERO
        and   Menu-Option = "A"           *> record found
              move FLT-From to FLT-To.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA100-ENTER-LOGBK-TO.
*>
 CA090-ENTER-LOGBK-FROM2.
     DISPLAY  FLT-FROM AT 1201 with erase eol.
     DISPLAY  FL007 AT 1206.
     DISPLAY  "[" AT 1301 with erase eol.
     DISPLAY  "]" AT 1338.
     display  FL011 at 1347.
*>
     if       Menu-Option = "B"
              move     Spaces to Ws-afld-name.
     ACCEPT   WS-AFLD-NAME AT 1302 with update.
     DISPLAY  SPACE AT 1201 with erase eol.
     DISPLAY  SPACE AT 1301 with erase eol.
     IF       WS-AFLD-NAME = SPACES
          or  Cob-Crt-Status = Cob-Scr-Esc
          or  Cob-Crt-Status = Cob-Scr-F10
              move spaces to FLT-From
              GO TO CA080-ENTER-LOGBK-FROM.
     if       WS-Afld-Name not alphabetic
              move spaces to WS-Afld-Name
              GO TO CA090-ENTER-LOGBK-FROM2.
     PERFORM  BD000-INSERT-AFLD.
     if       Return-Code not = zero
              move zero to Return-Code
              go to CA080-ENTER-LOGBK-FROM.
*>
 CA100-ENTER-LOGBK-TO.
     ACCEPT   FLT-TO AT 0560 with update.
     move     function upper-case (FLT-TO) to FLT-TO.
     display  FLT-TO at 0560.
     if       FLT-From not alphabetic
              go to CA100-Enter-Logbk-To.
     if       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     if       Menu-Option = "B"
        and   Cob-Crt-Status = Cob-Scr-F2
              go to CA032-get-next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              go to ca100-enter-logbk-to.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              go to ca100-enter-logbk-to.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA080-ENTER-LOGBK-FROM.
*>
     IF       FLT-FROM = FLT-TO
              GO TO CA120-ENTER-LOGBK-START.
     if       flt-to = spaces
              go to ca100-enter-logbk-to.
*>
     MOVE     FLT-TO TO WS-ICAO-CODE.
     PERFORM  ZE000-SEARCH-FOR-ICAO.
*>
     IF       ERROR-CODE NOT = ZERO
              GO TO CA120-ENTER-LOGBK-START.
*>
 CA110-ENTER-LOGBK-TO2.
     DISPLAY  FLT-TO AT 1201.
     DISPLAY  FL007 AT 1206.
     DISPLAY  "[" AT 1301.
     DISPLAY  "]" AT 1338.
     display  FL011 at 1347.
*>
     Move     spaces to Ws-afld-name.
     ACCEPT   WS-AFLD-NAME AT 1302 with update.
     DISPLAY  SPACE AT 1201 with erase eol.
     DISPLAY  SPACE AT 1301 with erase eol.
     IF       WS-AFLD-NAME = SPACES
          or  Cob-Crt-Status = Cob-Scr-Esc
          or  Cob-Crt-Status = Cob-Scr-F10
              move spaces to FLT-To
              GO TO CA100-ENTER-LOGBK-TO.
     if       WS-Afld-Name not alphabetic
              move spaces to WS-Afld-Name
              GO TO CA110-ENTER-LOGBK-To2.
     PERFORM  BD000-INSERT-AFLD.
     if       Return-Code not = zero
              move zero to Return-Code
              go to CA100-ENTER-LOGBK-To.
*>
 CA120-ENTER-LOGBK-START.
     move     99  to Save-FLT-HH.
     if       Menu-Option = "A"
              move     zeros to WSE-Time
     else
              DIVIDE   FLT-Start BY 60 GIVING WSF-HH REMAINDER WSF-MM
     end-if                                    *> WSE & WSF same
     ACCEPT   WSF-TIME AT 0567 with update.
     if       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA120-ENTER-LOGBK-START.
*>
     if       Menu-Option = "B"
        and   Cob-Crt-Status = Cob-Scr-F2
              go to CA032-get-next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA120-ENTER-LOGBK-START.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA100-ENTER-LOGBK-TO.
*>
     if       Menu-Option = "B"
              PERFORM  ZF000-CONVERT-LOGBK-TIME
              IF       ERROR-CODE NOT = ZERO
                       GO TO CA120-Enter-LOGBK-START
              end-if
              IF       WSH-TIME = ZERO
                       GO TO CA120-Enter-LOGBK-Start
              end-if
              MOVE     WSH-TIME TO FLT-START
     else    *> option = "A"
              if       WSE-Time not = zero
                       PERFORM  ZF000-CONVERT-LOGBK-TIME
                       IF       ERROR-CODE NOT = ZERO
                                GO TO CA120-ENTER-LOGBK-START
                       end-if
                       MOVE     WSH-TIME TO FLT-START
              else
                       move zero to FLT-Start FLT-End
                                    WS-Elapsed-Time
                       go to CA120-Enter-LogBK-Start.
*>
     move     WSF-HH  to Save-FLT-HH.
     DISPLAY  space AT line ws-22-Lines col 01 with erase eol.
     DISPLAY  space AT line ws-23-Lines col 01 with erase eol.
*>
 *> CA125-Check-No-Record.
     if       Menu-Option = "B"                         *> not for Amending
              go to CA130-ENTER-LOGBK-END.
     read     Flightlog-File invalid key                *> Expected as should not be present
              go to CA130-ENTER-LOGBK-END.
     display  FL004 at 1201 with erase eol foreground-color COB-COLOR-RED.
     go       to CA030-ENTER-LOGBK-DATE.
*>
 CA130-ENTER-LOGBK-END.
     if       Menu-Option = "A"
              move     zeros to WSE-Time
     else
              DIVIDE   FLT-END BY 60 GIVING WSF-HH REMAINDER WSF-MM
     end-if
     ACCEPT   WSF-TIME AT 0575 with update.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA130-ENTER-LOGBK-END.
*>
     if       Menu-Option = "B"
       and    Cob-Crt-Status = Cob-Scr-F2
              go to CA032-get-next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA130-ENTER-LOGBK-END.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA120-ENTER-LOGBK-START.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.      *> passed as WSH 9(4) in minutes
     IF       ERROR-CODE NOT = ZERO
              GO TO CA130-ENTER-LOGBK-END.
     if       Menu-Option = "B"   and  WSE-TIME = ZERO
              GO TO CA120-Enter-LOGBK-START.
     MOVE     WSH-TIME TO FLT-END.
*>
 CA140-ENTER-LOGBK-TOT-TIM-CALC.
     IF       FLT-END NOT > FLT-START        *> Flight ends after midnight
              ADD 1440 TO WSH-TIME.
     SUBTRACT FLT-START FROM WSH-Time GIVING WS-ELAPSED-TIME.
     move     WS-Elapsed-Time to WS-Time-Remaining.
     divide   WS-Elapsed-Time by 60 giving WSF-HH remainder WSF-MM.
     move     WSE-Time to WS-Elapsed-HHMM.              *> end - start as HHMM
     move     WSE-Time to WS-Time-Remaining-HHMM.       *> end - start as HHMM
     move     zero to WS-Calc-Time.                     *> as 9(4) minutes
*>
 CA150-ENTER-LOGBK-MULTI.
     ACCEPT   FLT-MS AT 1002 with update.
     move     function upper-case (FLT-MS) to FLT-MS.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA150-ENTER-LOGBK-MULTI.
*>
     if       Menu-Option = "B"
       and    Cob-Crt-Status = Cob-Scr-F2
              go to CA032-get-next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA150-ENTER-LOGBK-MULTI.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA130-ENTER-LOGBK-END.
*>
     IF       FLT-MS NOT = "M" AND "S"
              GO TO CA150-ENTER-LOGBK-MULTI.
     IF       FLT-MS = "S"
              DISPLAY "Single" AT 0727 WITH foreground-color COB-COLOR-CYAN
      ELSE    DISPLAY "Multi " AT 0727 WITH foreground-color COB-COLOR-CYAN.
*>
     IF       Aircraft-MS  = SPACE           *> Should NOT happen but left in.
        or    Aircraft-MS not = FLT-MS
              MOVE FLT-MS TO Aircraft-MS     *> will be updated at end of CA230 remarks
              GO TO CA160-ENTER-LOGBK-CAP.
*>
 CA160-ENTER-LOGBK-CAP.
     ACCEPT   FLT-Capacity AT 1006 with update.
     move     function upper-case (FLT-CAPACITY) to FLT-CAPACITY.
     if       FLT-Capacity (1:1) = "I"       *> support for Instructor (P)
              move "P1I" to FLT-Capacity.
     if       FLT-Capacity (1:1) = "T"       *> support for Trainer - Commercial (P).
              move "P1T" to FLT-Capacity.
     display  Flt-Capacity at 1006.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA160-ENTER-LOGBK-CAP.
*>
     if       Menu-Option = "B"
       and    Cob-Crt-Status = Cob-Scr-F2
              go to CA032-get-next.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA160-ENTER-LOGBK-CAP.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA150-ENTER-LOGBK-MULTI.
     IF       FLT-CAPACITY = "PUT"
              MOVE "P3 " TO FLT-CAPACITY.
     if       FLT-Capacity = "U/S"
              move "P1S" to FLT-Capacity
     IF       FLT-CAPACITY NOT = "P1 " AND "P1S" AND "P1I" AND "P1T" AND "P2 " AND "P3 "
                             and "E1 " and "E2 " and "N1 " and "N2 " and "R1 " and "R2 "
                             and "T1 " and "T2 "
              GO TO CA160-ENTER-LOGBK-CAP.
     IF       FLT-CAPACITY = "P2 "
        AND   FLT-MS = "S"
              DISPLAY FL008 AT line ws-22-Lines col 01 with foreground-color COB-COLOR-RED
              GO TO CA150-ENTER-LOGBK-MULTI.
     DISPLAY  space AT line ws-22-Lines col 01 with erase eol.
*>
     MOVE     ZERO TO FLT-INSTRUMENT.
     MOVE     ZERO TO FLT-P1 (1) FLT-P1 (2) FLT-P23 (1) FLT-P23 (2).
*>
  *> WSE-Time = ws-elapsed-time-hhmm & ws-time-remaining-hhmm
*>
*> Try and work out if flight starts at night using table but only for data entry NOT amend
*>  Remember Aviation definition of night is 30 minutes(ish) earlier than as
*>    defined for night Sun being 12 degrees below horizon. This could be different
*>     in some latitudes of the earth.
*>
     if       SW-Escaped = 1
              move zero to sw-escaped
              go to CD165-Bypass-Nite-Tests.
*>
 *> CD162-Test-For-Nite-Time.
     if       Save-FLT-Mth numeric
        and   NOT NONIGHT
        and   Save-Flt-HH numeric
        and   Save-FLT-HH < 24
        and   (NIM (SAVE-FLT-Mth) - 1) < Save-FLT-HH   *> deduct an hour so now must be night in any minute
              move 1 to SW-Its-Night
     else
              move zero to SW-Its-Night
     end-if
     move     zero to SW-Escaped.                 *> reset it.
*>
 CD165-Bypass-Nite-Tests.
*>                                          *> Add F5, Save to prompt removing F2 & F4 (Next rec and Delete)
     display  WS-Scrn-Prompt5B at line ws-Lines col 01 with foreground-color COB-COLOR-White with erase eol
     move     WS-Zero-Time to WSE-Time.
     display  WSF-Time at 1012.    *> P1  day
     display  WSF-Time at 1020.    *> p23 day
     display  WSF-Time at 1032.    *> p1  night
     display  WSF-Time at 1040.    *> P23 Night
     IF       (FLT-CAPACITY = "P3 " OR "P2 " or "E2 " or "E3 " or "R2 " or "R3 ")
         and  SW-Its-Night = zero
              GO TO CA180-ENTER-LOGBK-DAY-P23.
     IF       (FLT-CAPACITY = "P3 " OR "P2 " or "E2 " or "E3 " or "R2 " or "R3 ")
         and  SW-Its-Night = 1
              go to CA200-Enter-Logbk-Night-P23.
     if       SW-Its-Night = 1               *> Must be P1
              go to CA190-ENTER-LOGBK-NIGHT-P1.
*>
 CA170-ENTER-LOGBK-DAY-P1.
     MOVE     ZERO TO WS-CALC-TIME.
     move     WS-Time-Remaining-HHMM to WSE-Time.    *> based on end & start times & recalc if Amend
     display  "00.00" at 1032.
     ACCEPT   WSF-TIME AT 1012 with update.
     if       WSF-Time (1:1) = "Z" or "z"
              move zeros to WSE-Time
              DISPLAY wsf-time at 1012.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA170-ENTER-LOGBK-DAY-P1.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA170-ENTER-LOGBK-DAY-P1.
*>
     IF       Cob-Crt-Status = Cob-Scr-F5
          and Menu-Option = "B"
              GO TO CA235-Enter-Logbk-Save.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA160-ENTER-LOGBK-Cap.
     IF       WSE-TIME = ZERO
              move  zero to FLT-P1 (1)          *> is in Amend code
              GO TO CA190-ENTER-LOGBK-NIGHT-P1.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA170-ENTER-LOGBK-DAY-P1.
*>
     MOVE     WSH-TIME TO FLT-P1 (1).
     move     WSH-TIME TO WS-CALC-TIME.     *> in minutes
     perform  ZK000-Calc-Remaining.
     go       to  CA190-ENTER-LOGBK-NIGHT-P1.   *> now using time-remaining
*>
 CA180-ENTER-LOGBK-DAY-P23.
     MOVE     ZERO TO WS-CALC-TIME.
     move     WS-Time-Remaining-HHMM to WSE-Time.      *> based on end & start times.
     display  "00.00" at 1040.
     ACCEPT   WSF-TIME AT 1020 with update.
     if       WSF-Time (1:1) = "Z" or "z"
              move zeros to WSE-Time
              DISPLAY wsf-time at 1020.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA180-ENTER-LOGBK-DAY-P23.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA180-ENTER-LOGBK-DAY-P23.
*>
     IF       Cob-Crt-Status = Cob-Scr-F5
          and Menu-Option = "B"
              GO TO CA235-Enter-Logbk-Save.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA160-ENTER-LOGBK-cap.
*>
     IF       WSE-TIME = ZERO
              move zero to FLT-P23 (1)   *> as in Amend code
              GO TO CA200-ENTER-LOGBK-NIGHT-P23.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA180-ENTER-LOGBK-DAY-P23.
*>
     MOVE     WSH-TIME TO FLT-P23 (1).
     move     WSH-TIME TO WS-CALC-TIME.
     perform  ZK000-Calc-Remaining.
     go       to  CA200-ENTER-LOGBK-NIGHT-P23.   *> now using time-remaining
*>
 CA190-ENTER-LOGBK-NIGHT-P1.
     if       WS-Time-Remaining = zero
              go to CA210-ENTER-LOGBK-IFR.
*>
     move     WS-Time-Remaining-HHMM to WSE-Time.             *> based on end & start times.
     ACCEPT   WSF-TIME AT 1032 with update.
     if       WSF-Time (1:1) = "Z" or "z"
              move zeros to WSE-Time
              DISPLAY wsf-time at 1032.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA190-ENTER-LOGBK-NIGHT-P1.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA190-ENTER-LOGBK-NIGHT-P1.
*>
     IF       Cob-Crt-Status = Cob-Scr-F5
          and Menu-Option = "B"
              GO TO CA235-Enter-Logbk-Save.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              move 1 to sw-escaped
              GO TO CA170-ENTER-LOGBK-DAY-P1.
     IF       WSE-TIME = ZERO            *> no night time entered
              move  zero to FLT-P1 (2)   *> in amend code
              GO TO CA210-ENTER-LOGBK-IFR.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA190-ENTER-LOGBK-NIGHT-P1.
*>
     MOVE     WSH-TIME TO FLT-P1 (2).
     ADD      WSH-TIME TO WS-CALC-TIME.
     GO       TO CA210-ENTER-LOGBK-IFR.
*>
 CA200-ENTER-LOGBK-NIGHT-P23.
     if       WS-Time-Remaining = zero
              go to CA210-ENTER-LOGBK-IFR.
*>
     move     WS-Elapsed-HHMM to WSE-Time.             *> based on end & start times.
     ACCEPT   WSF-TIME AT 1040 with update.
     if       WSF-Time (1:1) = "Z" or "z"
              move zeros to WSE-Time
              DISPLAY wsf-time at 1040.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA200-ENTER-LOGBK-NIGHT-P23.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA200-ENTER-LOGBK-NIGHT-P23.
*>
     IF       Cob-Crt-Status = Cob-Scr-F5
          and Menu-Option = "B"
              GO TO CA235-Enter-Logbk-Save.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              move 1 to sw-escaped
              GO TO CA180-ENTER-LOGBK-day-p23.
     IF       WSE-TIME = ZERO
              move zero to FLT-P23 (2)
              GO TO CA210-ENTER-LOGBK-IFR.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA200-ENTER-LOGBK-NIGHT-P23.
*>
     MOVE     WSH-TIME TO FLT-P23 (2).
     ADD      WSH-TIME TO WS-CALC-TIME.
*>
 CA210-ENTER-LOGBK-IFR.
     MOVE     ZERO TO WSE-TIME.
     ACCEPT   WSF-TIME AT 1052 with update.
     if       WSF-Time (1:1) = "Z" or "z"
              move zeros to WSE-Time
              DISPLAY wsf-time at 1052.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA210-ENTER-LOGBK-IFR.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA210-ENTER-LOGBK-IFR.
*>
     IF       Cob-Crt-Status = Cob-Scr-F5
          and Menu-Option = "B"
              GO TO CA235-Enter-Logbk-Save.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10           *> go back to DAY entry P!
        and   (flt-p1 (1) not = zero or  flt-p1 (2) not = zero)
              subtract flt-p1 (1) flt-p1 (2) from ws-calc-time
              GO TO CA170-ENTER-LOGBK-Day-p1.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10           *> go back to DAY entry P23
        and   (flt-p23 (1) not = zero or  flt-p23 (2) not = zero)
              subtract flt-p23 (1) flt-p23 (2) from ws-calc-time
              GO TO CA180-ENTER-LOGBK-Day-p23.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10          *> to CAP entry if no times present.
              GO TO CA160-ENTER-LOGBK-cap.
     IF       WSE-TIME = ZERO
              move zero to FLT-Instrument    *> in Amend code
              GO TO CA215-ENTER-LOGBK-Inst-Test.
*>
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              GO TO CA210-ENTER-LOGBK-IFR.
*>
     MOVE     WSH-TIME TO FLT-INSTRUMENT.
*>
 CA215-Enter-Logbk-Inst-Test.
     DISPLAY  SPACE AT line ws-22-Lines col 01 with erase eol.
*>
*>   Instrument time must be not be > than total time logged
*>
     IF       FLT-INSTRUMENT not > WS-ELAPSED-TIME
        AND   WS-ELAPSED-TIME = WS-CALC-TIME
              GO TO CA230-ENTER-LOGBK-REMARKS.
*>
*>  Something is wrong
*>
     IF       WS-ELAPSED-TIME > WS-CALC-TIME
         and  FLT-Capacity not = "P3 "
              MOVE "PD;" TO FLT-REMARKS
              GO TO CA230-ENTER-LOGBK-REMARKS.
*>
     IF       WS-ELAPSED-TIME < WS-CALC-TIME
              GO TO CA220-ENTER-LOGBK-TIME-ERROR.
*>
     IF       FLT-INSTRUMENT < WS-ELAPSED-TIME
              GO TO CA230-ENTER-LOGBK-REMARKS.
*>
 CA220-ENTER-LOGBK-TIME-ERROR.
     DISPLAY  FL009 AT line ws-22-Lines col 01 with foreground-color COB-color-Red.
     DISPLAY  FL022 AT line ws-23-Lines col 01 with foreground-color COB-color-Red.
     GO       TO CA120-ENTER-LOGBK-START.
*>
 CA230-ENTER-LOGBK-REMARKS.
     if       Menu-Option = "A"
              ACCEPT   FLT-REMARKS AT 1061
     else
              accept   FLT-Remarks at 1061 with update.
     IF       Cob-Crt-Status = Cob-Scr-Esc
              GO TO CA030-ENTER-LOGBK-DATE.
*>
     IF       Cob-Crt-Status = Cob-Scr-F1
              perform CA240-display-AFLD
              GO TO CA230-ENTER-LOGBK-Remarks.
*>
     IF       Cob-Crt-Status = Cob-Scr-F3
              perform CA250-display-acft
              GO TO CA230-ENTER-LOGBK-Remarks.
*>
     IF       Cob-Crt-Status = Cob-Scr-F10
              GO TO CA210-ENTER-LOGBK-IFR.
*>
 CA235-Enter-Logbk-Save.
*>
*>  Update Aircraft and airfield (from and to if different) last flt dates.
*>   but only for if date > than stored - read it with rewrite for reg processing.
*>
       if     FLT-Date > Aircraft-Last-Flt
              move     FLT-Date to Aircraft-Last-Flt
              rewrite  Aircraft-Record invalid key          *> More for testing as should NOT happen
                       display FL025 at 1201 with erase eol
                       accept  ws-reply at 1267
                       display space at 1201 with erase eol
              end-rewrite.
*>
*> Now Airfields, but only do date update if later - in case of Amend mode.
*>
     move     FLT-From to WS-ICAO-Code
     perform  ZE000-SEARCH-FOR-ICAO
     if       Error-Code = 1
       and    FLT-Date > AFLD-Last-Flt
              move FLT-Date to AFLD-Last-Flt
              rewrite Airfield-Record
     end-if
     if       FLT-From not = FLT-To
              move     FLT-TO to WS-ICAO-Code
              perform  ZE000-SEARCH-FOR-ICAO
              if       Error-Code = 1
                and    FLT-Date > AFLD-Last-Flt
                       move FLT-Date to AFLD-Last-Flt
                       rewrite Airfield-Record
              end-if
     end-if
*>
*> Now the flight record
*>
     if       Menu-Option = "A"
              WRITE    FLIGHTLOG-RECORD
     else
      if      Menu-Option = "B"
          and Save-Flt-Date-Time-Key = FLT-Date-Time-Key
              rewrite  Flightlog-Record
      else
              write  Flightlog-Record              *> create new rec for NEW date/time
      end-if
     end-if
     IF       FS-REPLY NOT = "00"                   *> should not happen but JIC
              perform  zza-file-status
              DISPLAY FL010 at line ws-22-Lines col 01  with foreground-color COB-color-Red
              accept  ws-reply at line ws-22-Lines col 73
              GO TO CA999-Exit.
*>
*> If menu-option "B" and date-time changed, delete OLD record but save current new date-time.
*>  and restore after deleting
*>
     move     FLT-Date-Time-Key to WS-Backup-Date-Time-Key.       *> save current flt date-time
     if       Menu-Option = "B"
        and   Save-FLT-Date-Time-Key not = FLT-Date-Time-Key
              move Save-FLT-Date-Time-Key to FLT-Date-Time-Key
              delete Flightlog-File Record                        *> Delete the old rec date-time
              move WS-Backup-Date-Time-Key to Save-FLT-Date-Time-Key   *> restore current date-time
     end-if
*>
     display  space at line ws-22-Lines col 01 with erase eol.
     display  space at line ws-23-Lines col 01 with erase eol.
*>
     GO       TO CA030-ENTER-LOGBK-Date.
*>
 CA240-DISPLAY-AFLD.
     perform  CA300-Save-Screen.
     move     spaces to WS-ICAO-Code.
     perform  be000-View-Afld.
     perform  CA301-Restore-Screen.
*>
 CA250-DISPLAY-ACFT.
     perform  CA300-Save-Screen.
     perform  CAA000-View-Acft.
     perform  CA301-Restore-Screen.
*>
 CA300-Save-Screen.
     move     z"flg-temp.scr"  to wScreenName.
     call     "scr_dump"    using wScreenName returning wInt.
*>
 CA301-Restore-Screen.
     call     "scr_restore" using wScreenName returning wInt.
     call     "CBL_DELETE_FILE" using "flg-temp.scr".
*>
 CA999-EXIT.  EXIT.
*>
 CAA000-VIEW-ACFT       SECTION.
*>=============================
*>
     MOVE     ZERO TO PAGE-CNT Line-cnt ERROR-CODE Aircraft-Type.
     Move     WS-Scrn-BE-Start to curs.
     PERFORM  CAA030-VIEW-ACFT-HEADS.
     start    Aircraft-File FIRST.
*>
 CAA020-VIEW-ACFT.
     read     Aircraft-File at end
              GO TO CAA050-VIEW-ACFT-END.
     MOVE     AIRCRAFT-Type  TO D-AIRCRAFT.
     MOVE     Aircraft-MS    TO D-AC-MS.
*>
     DISPLAY  D-DISPLAY2 AT CURS with foreground-color COB-COLOR-CYAN.
     ADD      100 TO CURS.
     ADD      1 TO LINE-CNT.
*>
     If       line-cnt > WS-Scrn-BE-Cnt
         and  page-cnt > 3
              go to CAA040-view-acft.
*>
     IF       LINE-CNT > WS-Scrn-BE-Cnt
              MOVE ZERO TO LINE-CNT
              add 1 to page-cnt
              add 15 to curs
              subtract WS-Scrn-BE-Length from curs.
     GO       TO CAA020-view-ACFT.
*>
 CAA030-VIEW-ACFT-HEADS.
     DISPLAY  SPACE at 0101 erase eos.
     move     WS-Scrn-BE-Head to WS-Scrn-BE-Curs.
     DISPLAY  "AIRCRAFT  M/S"  AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      15 to WS-Scrn-BE-Curs.
     DISPLAY  "AIRCRAFT  M/S"  AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      15 to WS-Scrn-BE-Curs.
     DISPLAY  "AIRCRAFT  M/S"  AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      15 to WS-Scrn-BE-Curs.
     DISPLAY  "AIRCRAFT  M/S"  AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     add      15 to WS-Scrn-BE-Curs.
     DISPLAY  "AIRCRAFT  M/S" AT WS-Scrn-BE-Curs WITH foreground-color COB-COLOR-GREEN.
     DISPLAY  WS-Scrn-Prompt3  line ws-Lines col 01 WITH foreground-color COB-COLOR-White.
*>
 CAA040-VIEW-ACFT.
     move     space to menu-reply.
     accept   menu-reply line ws-Lines col 36.
     If       Cob-Crt-Status = Cob-Scr-Esc
              go to caa999-exit.
     move     WS-Scrn-BE-Start to curs.
     move     zero to line-cnt page-cnt.
     perform  caa030-view-acft-heads.
     GO       TO CAA020-VIEW-ACFT.
*>
 CAA050-VIEW-ACFT-END.
     DISPLAY  WS-Scrn-Prompt4 line ws-Lines col 01 WITH foreground-color COB-COLOR-White.
     move     space to menu-reply.
     Accept   menu-reply line ws-Lines col 19.
*>
 CAA999-EXIT. exit section.
*>
 CC000-LOG-BOOK-REPORT SECTION.
*>============================
*>
*> Routine called for Menu options C, D, E & F:
*>   Logbook only report (C), Logbook and Anal (D), Anal & Totals rep (E), Anal & Tots display (F)
*>
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Flight Log Reports" AT 0130 WITH foreground-color COB-COLOR-GREEN.
     MOVE     ZEROS TO PRINT-START PRINT-FLAG  SHORT-PRINT Print-Start-Time.
     MOVE     20991231 TO PRINT-END.
*>
*> Force Re/Load Airfield & aircraft tables for the stats.
*>
     perform  ZC000-LOAD-AIRCRAFT
     if       Return-Code > 3
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CC999-Exit.
     PERFORM  ZB000-LOAD-AIRFIELDS
     if       Return-Code > 3
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CC999-Exit.
*>
     IF       DISPLAY-FLAG NOT = ZERO
              GO TO CC040-LBR-DDB.
     If       Menu-Option = "E" or = "F" or = "G"      *> does not require start/end dating
              go to CC040-LBR-DDB.
*>
*>  Regular or extended report request disp and accept
*>   extended select by menu options 3 (C) and 4 (D)
*>----------------------------------------------------
*>
*> rem out display for 1st date field as gets overwritten by ws-test-date asit may contain
*>    an old date from previously entered record
*>
     DISPLAY  "Start Date  [dd.mm.ccyy]" AT 2001 WITH foreground-color COB-COLOR-Yellow.
     DISPLAY  "End Date    [dd.mm.ccyy]" AT 2031 WITH foreground-color COB-COLOR-Yellow.
     if       LTZ-USA
              display "mm.dd" at 2044 WITH foreground-color COB-COLOR-Yellow.
     if       LTZ-Unix
              display "ccyy.mm.dd" at 2044 WITH foreground-color COB-COLOR-Yellow.
*>
     display  FL049 at line ws-21-Lines col 05.       *> Info msgs
     display  FL050 at line ws-22-Lines col 05.
     move     zero to Print-Start  Print-Start-Time  Print-End.
*>
 CC020-LBR-DD.
     ACCEPT   WS-Test-Date AT 2014.
     IF       WS-Test-Date (1:2) = SPACES
              GO TO CC030-LBR-DDA.
*>
     PERFORM  ZA000-DATE-CHECK.
     IF       ERROR-CODE = ZERO       *> Date good and not spaces
              MOVE 1 TO PRINT-FLAG SHORT-PRINT
              MOVE WS-Test-Intl TO PRINT-START
     ELSE     GO TO CC020-LBR-DD.
*>
 CC030-LBR-DDA.
     ACCEPT   WS-Test-Date AT 2044 with update.
     IF       WS-Test-Date (1:2) = SPACES
              GO TO CC032-Get-Time.       *> Could be partial print
*>
     PERFORM  ZA000-DATE-CHECK.
     IF       ERROR-CODE = ZERO
              MOVE 1 TO PRINT-FLAG SHORT-PRINT
              MOVE WS-Test-Intl TO PRINT-END
      ELSE    GO TO CC030-LBR-DDA.
*>
 CC032-Get-Time.                               *> For a specific start date and time.
     if       Print-Start not = ZEROS          *> check for a start date AND time
        and   Print-End = zeros                *> if end date zero get start time
              display  space line ws-21-Lines col 01 with erase eos
              display  "Start after time point  [hh:mm]" line ws-21-Lines col 01 WITH foreground-color COB-COLOR-Yellow
              move     zeros to WSE-Time
              ACCEPT   WSF-TIME line ws-21-Lines col 26 with update
              if       WSF-Time (1:2) not = zero
                       PERFORM  ZF000-CONVERT-LOGBK-TIME
                       IF       ERROR-CODE NOT = ZERO
                                GO TO CC032-Get-Time
                       end-if
                       MOVE     WSH-TIME TO Print-Start-Time  *> save as minutes (same for logbook data
              else
                       move zeros to Print-Start-Time
     end-if.
*>
 CC040-LBR-DDB.
     display  space at 2001 with erase eos.
     IF       DISPLAY-FLAG = ZERO
         and  WS-User = spaces
              perform A050-Get-User-Details.
*>
     MOVE     ZERO TO ERROR-CODE PAGE-CNT INS-FLAG
                      SAVE-FLT-DATE SAVE-FLT-START.
     initialise WS-Totals.
     MOVE     ZERO TO A B.
     MOVE     SPACES TO SR1-ZAP-INS SR2-ZAP-INS.
*>
     Initialise ws2-totals.
     PERFORM  WST-AIRCRAFT-SIZE TIMES
              ADD      1 TO A
              initialise WS-AC-Group (A)
     end-perform.
*>
     MOVE     66 TO LINE-CNT.
     if       Print-Start not = zero
              move     Print-Start to FLT-Date
              move     Print-Start-Time to FLT-Start
              start    Flightlog-File key not < FLT-Date-Time-Key
     else
              start    FLIGHTLOG-FILE FIRST.
     if       FS-Reply not = "00"               *> no data, should have been found loading aflds & acft.
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CC999-Exit.
*>
 CC050-LBR-READ.
     READ     FLIGHTLOG-FILE next record AT END
              GO TO CC070-LBR-EOF.
     if       Print-End not = zeros
       and    FLT-Date > Print-End       *> Reduced reporting
              go to CC070-LBR-EOF.
     PERFORM  CCA000-LBR-PRINT-DATA.
     PERFORM  CCB000-LBR-ANALYSIS.
     GO       TO CC050-LBR-READ.
*>
 CC070-LBR-EOF.
     IF       DISPLAY-FLAG NOT = ZERO
              DISPLAY SPACE at 0101 with erase eos.
     PERFORM  CCA040-LBR-SUBS thru CCA050-Subs.
     if       Menu-Option not = "E" and not = "F" and not = "G"
              move 1 to SW-AFLD-Used
 *>             sort WST-ICAO on descending key WST-Afld-Last-Flt
              perform  CCD000-Airfield-Lists
 *>             sort WST-ICAO on ascending key WST-AIRFIELD
     end-if
 *>    if       Analysis-Only-flag = 1
 *>       or    Menu-Option = "D" or "4"         *> Extended
              PERFORM  CCC000-LBR-AIRCRAFT-ANALYSIS.
*>
     IF       DISPLAY-FLAG NOT = ZERO
              DISPLAY FL001 line ws-Lines col 01
              accept ws-reply line ws-Lines col 41.
*>
     perform  ZP000-SAVE-AIRFIELDS.            *> save any updated last-flt dates
 *>
 CC999-EXIT.  exit section.
*>
 CCA000-LBR-PRINT-DATA SECTION.
*>============================
*>
     IF       SHORT-PRINT = 1                  *> with ISAM and start/end dates used shouldnt happen
       IF     FLT-DATE NOT < PRINT-START
        AND   FLT-DATE NOT > PRINT-END
              MOVE ZERO TO PRINT-FLAG
       ELSE
              MOVE 1 TO PRINT-FLAG.
*>
     IF       LINE-CNT > WS-Line-Cnt-Size-2    *> 50
       AND    DISPLAY-FLAG = ZERO
        AND   ANALYSIS-ONLY-FLAG = ZERO
         AND  NOT NO-PRINT-YET
              PERFORM CCA030-LBR-HEADS.
*>
     IF       NO-PRINT-YET
       OR     DISPLAY-FLAG NOT = ZERO
        OR    ANALYSIS-ONLY-FLAG NOT = ZERO
              GO TO CCA020-LBR-ACCUM1.
*>
     if       monthly-anal-flag = zero
              go to CCA015-Setprint.
*>
     move     FLT-Date to WSA-Date2.
     if       SAVE-Flt-Mth = zeros
              move WSA-MM   to SAVE-FLT-Mth.
     if       SAVE-FLT-Mth not = WSA-MM
              perform CCA100-Print-Subs
              move WSA-MM   to SAVE-FLT-Mth.
*>
     ADD      FLT-INSTRUMENT TO WS2-INSTRUMENT.
     ADD      FLT-P1 (1)  TO WS2-P1 (1).
     ADD      FLT-P23 (1) TO WS2-P23 (1).
     ADD      FLT-P1 (2)  TO WS2-P1 (2).
     ADD      FLT-P23 (2) TO WS2-P23 (2).
*>
     IF       FLT-MS = "M"                   *> Multi eng totals
              ADD FLT-P1 (1) FLT-P1 (2) FLT-P23 (1) FLT-P23 (2) GIVING WS-WORK1
              ADD WS-WORK1 TO WS2-MULTI.
*> changed to support other categories other than P ie, E, N, R and T
      IF      FLT-CAPACITY (2:2) = "1I" or "1T"  *> Instructor/trainer totals within P1 time.
              add flt-p1 (1) to ws2-ins (1)
              add flt-p1 (2) to ws2-ins (2)
              ADD FLT-P1 (1) FLT-P1 (2) TO WS2-INSX.
*>
 CCA015-Setprint.
     if       not Extended-Report
              MOVE     SPACES TO PRINT-RECORD
     else
              move spaces to Print-Extended-Log
     end-if
     MOVE     FLT-DATE TO WS-Test-Intl.
     perform  ZZ060-Convert-Date.
     MOVE     WS-Test-Date TO PR1-DATE.
     MOVE     FLT-AC-TYPE TO PR1-AC-TYPE.
     MOVE     FLT-AC-REG TO PR1-AC-REG.
     if       FLT-AC-Reg1-2 numeric                          *> Have a Nth American registered A/C
              move 1 to c                                      *>  BUT IS THIS A PROBLEM FOR MIL A/Cs ??
              string "N" delimited by size
              FLT-AC-Reg (1:5) delimited by size
                      into PR1-AC-Reg with pointer c.        *> Yes this does do a overlapping move
     MOVE     FLT-CAPTAIN TO PR1-CAPTAIN.
     MOVE     FLT-CAPACITY TO PR1-CAPACITY.
*>
*> Common print to here for std and extended
*>
     if       not Extended-Report
              MOVE     FLT-FROM TO PR1-FROM
              MOVE     FLT-TO TO PR1-TO
              MOVE     FLT-REMARKS TO PR1-REMARKS
     else
              MOVE     FLT-FROM TO WS-ICAO-CODE
              perform  ZN000-SEARCH-FOR-ICAO
              if       Error-Code not = zero
                       move WST-Afld-Name (error-Code) to PR11-From
              else
                       move "NAME MISSING" to PR11-From
              end-if
              if       FLT-From = FLT-To
                       move PR11-From to PR11-To
              else
                       MOVE     FLT-TO TO WS-ICAO-CODE
                       perform  ZN000-SEARCH-FOR-ICAO
                       if       Error-Code not = zero
                                move WST-Afld-Name (error-Code) to PR11-TO
                       else
                                move "NAME MISSING" to PR11-TO
                       end-if
              end-if
              MOVE     FLT-REMARKS TO PR11-REMARKS
     end-if
*>
     MOVE     FLT-START TO WS-WORK1.
     PERFORM  ZG000-RESTORE-LOGBK-TIME.
     if       not Extended-Report
              MOVE     WS-WORKA TO PR1-START
     else
              MOVE     WS-WORKA TO PR11-START
     end-if
     MOVE     FLT-END TO WS-WORK1.
     PERFORM  ZG000-RESTORE-LOGBK-TIME.
     if       not Extended-Report
              MOVE     WS-WORKA TO PR1-END
     else
              MOVE     WS-WORKA TO PR11-END
     end-if
     MOVE     FLT-INSTRUMENT TO WS-WORK1.
     PERFORM  ZG000-RESTORE-LOGBK-TIME.
     if       not Extended-Report
              MOVE     WS-WORKA TO PR1-IFR
     else
              MOVE     WS-WORKA TO PR11-IFR
     end-if
*>
     if       not Extended-Report
              MOVE     FLT-P1 (1) TO WS-WORK1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR1-P1 (1)
              MOVE     FLT-P23 (1) TO WS-WORK1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR1-P1 (2)
              MOVE     FLT-P1 (2) TO WS-WORK1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR1-P2 (1)
              MOVE     FLT-P23 (2) TO WS-WORK1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR1-P2 (2)
     else
              MOVE     FLT-P1 (1) TO WS-WORK1
              add      FLT-P23 (1) to WS-Work1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR11-Day-P
              MOVE     FLT-P1  (2) TO WS-WORK1
              add      FLT-P23 (2) TO WS-WORK1
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              MOVE     WS-WORKA TO PR11-Nite-P
     end-if.
*>
 CCA020-LBR-ACCUM1.
     ADD      FLT-INSTRUMENT TO WS-INSTRUMENT.
     ADD      FLT-P1 (1)  TO WS-P1 (1).
     ADD      FLT-P23 (1) TO WS-P23 (1).
     ADD      FLT-P1 (2)  TO WS-P1 (2).
     ADD      FLT-P23 (2) TO WS-P23 (2).
*>
     IF       FLT-MS = "M"
              ADD FLT-P1 (1) FLT-P1 (2) FLT-P23 (1) FLT-P23 (2) GIVING WS-WORK1
              ADD WS-WORK1 TO WS-MULTI
              PERFORM  ZG000-RESTORE-LOGBK-TIME
              if       not Extended-Report
                       MOVE WS-WORKA TO PR1-MULTI
              else
                       move WS-WorkA to PR11-Multi
              end-if
     ELSE
              if       Not Extended-Report
                       MOVE ZEROS TO PR1-MULTI
              else
                       move zeros to PR11-Multi
              end-if
     end-if
*>
     IF       FLT-CAPACITY = "P1I" or "P1T"
              MOVE 1 TO INS-FLAG
              add flt-p1 (1) to ws-ins (1)
              add flt-p1 (2) to ws-ins (2)
              ADD FLT-P1 (1) FLT-P1 (2) TO WS-INSX.
*>
     MOVE     FLT-DATE  TO SAVE-FLT-DATE.
     MOVE     FLT-START TO SAVE-FLT-START.
*>
     IF       DISPLAY-FLAG = ZERO
        AND   ANALYSIS-ONLY-FLAG = ZERO
        AND   NOT NO-PRINT-YET
              ADD 1 TO LINE-CNT
              if     not Extended-Report
                     WRITE  PRINT-RECORD AFTER 1
              else
                     write  Print-Extended-Log after 1
              end-if
     end-if
*>
     GO       TO CCA999-EXIT.
*>
 CCA030-LBR-HEADS.
     IF       LINE-CNT NOT = 66
              PERFORM CCA040-LBR-SUBS thru cca050-subs.
     MOVE     SPACES TO PRINT-RECORD.
     move     Prog-Name  to PH1-Prog.
     MOVE     "Personal Flying Log Book of" TO PH1-TITLE1.
     MOVE     WS-USER TO PH1-NAME.
     MOVE     WSF-Date TO PH1-DATE.
     ACCEPT   WSB-TIME FROM TIME.
     IF       WSB-TIME NOT = "00000000"
              MOVE WSB-HH TO WSD-HH
              MOVE WSB-MM TO WSD-MM
              MOVE WSB-SS TO WSD-SS
              MOVE WSD-TIME TO WS-TIME.
     MOVE     WS-TIME TO PH1-TIME.
     ADD      1 TO PAGE-CNT.
     MOVE     ZERO TO LINE-CNT.
     MOVE     "Page" TO PH1-TITPAG.
     MOVE     PAGE-CNT TO PH1-PAGE.
     if       Page-Cnt > 1
              WRITE    PRINT-RECORD AFTER PAGE
     else
              write    Print-Record before 1.
     MOVE     SPACES TO Print-Heads-Ext-Line3.
     MOVE     "-- Aircraft--" TO PH2-LIT1.
     if       not Extended-Report
              MOVE     "OP   JOURNEY   DEPART ARR     - DAY -    NIGHT" TO PH2-LIT2
              if       Page-Cnt > 1
                       WRITE    PRINT-RECORD AFTER 2
              else
                       write    PRINT-RECORD AFTER 1
              end-if
     else
              MOVE     "OP    - - - - - JOURNEY - - - - -   DEPART ARR" TO PH12-LIT2
              if       Page-Cnt > 1
                       WRITE    Print-Heads-Ext-Line2 AFTER 2
              else
                       write    Print-Heads-Ext-Line2 AFTER 1
              end-if
     end-if
     MOVE     SPACES TO Print-Heads-Ext-Line3.
     MOVE     " DATE    TYPE     REG    CAPTAIN" TO PH3-LIT1.
     if       not Extended-Report
              MOVE     " CAP FROM  TO   TIME  TIME    P1  P2/3  P1  P2/3 IFR  MULT ------- REMARKS ---- - - - - - -"
                         TO PH3-LIT2
              WRITE    PRINT-RECORD AFTER 1
     else
              MOVE     " CAP FROM            TO              TIME  TIME   DAY  NITE IFR  MULT ------- REMARKS ---- - - - - - -"
                         TO PH13-LIT2
              WRITE    Print-Heads-Ext-Line3 AFTER 1
     end-if
     MOVE     SPACES TO Print-Heads-Ext-Line3.
     PERFORM  CCA040-LBR-SUBS thru CCA050-Subs.
*>
 CCA040-LBR-SUBS.
     MOVE     SPACES TO SR1-LIT2 SR2-LIT2 PRINT-RECORD.
     if       display-flag = zero
              add 1 to Line-Cnt
              WRITE PRINT-RECORD AFTER 1.
     MOVE     ZERO TO WS-WORK1.
     IF       LINE-CNT > 1
              MOVE "Totals Carried Forward" TO SR2-LIT2
      ELSE
              MOVE "Totals Brought Forward" TO SR1-LIT2.
*>
     DIVIDE   WS-MULTI BY 60 GIVING SR1-MULTI    REMAINDER SR2-MULTI.
     DIVIDE   WS-INSTRUMENT BY 60 GIVING SR1-IFR REMAINDER SR2-IFR.
     DIVIDE   WS-P1 (1) BY 60 GIVING SR1-P1 (1)  REMAINDER SR2-P1 (1).
     DIVIDE   WS-P23 (1) BY 60 GIVING SR1-P1 (2) REMAINDER SR2-P1 (2).
     DIVIDE   WS-P1 (2) BY 60 GIVING SR1-P2 (1)  REMAINDER SR2-P2 (1).
     DIVIDE   WS-P23 (2) BY 60 GIVING SR1-P2 (2) REMAINDER SR2-P2 (2).
     ADD      WS-P1 (1) WS-P1 (2) WS-P23 (1) WS-P23 (2)  GIVING WS-WORK1.
     DIVIDE   WS-WORK1 BY 60 GIVING SR1-GRAND    REMAINDER SR2-GRAND.
*>
     IF       INS-FLAG NOT = ZERO
              MOVE "Total" TO SR2-LIT1
              MOVE "Ins" TO SR1-LIT1 sr2-lit1a sr2-lit1b
              move "Day" to sr1-lit1a
              move "Nite" to sr1-lit1b
              DIVIDE WS-INSX BY 60 GIVING SR1-INS     REMAINDER SR2-INS
              DIVIDE WS-INS (1) BY 60 GIVING SR1-INS1 REMAINDER SR2-INS1
              DIVIDE WS-INS (2) BY 60 GIVING SR1-INS2 REMAINDER SR2-INS2.
*>
 cca050-Subs.
     IF       DISPLAY-FLAG = ZERO
              MOVE  SUB-REPORT1 TO Pr3-data1
              WRITE PRINT-RECORD AFTER 1
              MOVE  SUB-REPORT2 TO Pr3-data1
              WRITE PRINT-RECORD AFTER 1
              move spaces to Print-Record
              if   Line-Cnt < 2                     *> If printing BF add a line
                   write Print-Record after 1
                   add  3  to Line-Cnt
              else
                   add  2 to Line-Cnt
              end-if
      ELSE
              DISPLAY SR1-DISP AT 0101
              DISPLAY SR2-DISP AT 0201.
*>
     MOVE     SPACES TO PRINT-RECORD.
*>
 cca100-Print-Subs.
     MOVE     SPACES TO SR2-LIT2 pr3-data2.
     move     all "-" to pr3-data1.
     WRITE    PRINT-RECORD AFTER 1.
     MOVE     ZERO TO WS-WORK1.
     MOVE     "Months Sub Totals" TO SR1-LIT2.
     move     "Sub" to sr1-fil1.
*>
     DIVIDE   WS2-MULTI BY 60 GIVING SR1-MULTI    REMAINDER SR2-MULTI.
     DIVIDE   WS2-INSTRUMENT BY 60 GIVING SR1-IFR REMAINDER SR2-IFR.
     DIVIDE   WS2-P1 (1) BY 60 GIVING SR1-P1 (1)  REMAINDER SR2-P1 (1).
     DIVIDE   WS2-P23 (1) BY 60 GIVING SR1-P1 (2) REMAINDER SR2-P1 (2).
     DIVIDE   WS2-P1 (2) BY 60 GIVING SR1-P2 (1)  REMAINDER SR2-P2 (1).
     DIVIDE   WS2-P23 (2) BY 60 GIVING SR1-P2 (2) REMAINDER SR2-P2 (2).
     ADD      WS2-P1 (1) WS2-P1 (2) WS2-P23 (1) WS2-P23 (2)  GIVING WS-WORK1.
     DIVIDE   WS-WORK1 BY 60 GIVING SR1-GRAND     REMAINDER SR2-GRAND.
*>
     IF       INS-FLAG NOT = ZERO
              MOVE "Total" TO SR2-LIT1
              MOVE "Ins"   TO SR1-LIT1 sr2-lit1a sr2-lit1b
              move "Day"   to sr1-lit1a
              move "Nite"  to sr1-lit1b
              DIVIDE WS2-INSX BY 60 GIVING SR1-INS     REMAINDER SR2-INS
              DIVIDE WS2-INS (1) BY 60 GIVING SR1-INS1 REMAINDER SR2-INS1
              DIVIDE WS2-INS (2) BY 60 GIVING SR1-INS2 REMAINDER SR2-INS2.
     perform  cca050-subs.
     move     "Grand" to sr1-fil1.
     move     all "=" to pr3-data1.
     WRITE    PRINT-RECORD AFTER 1.
     move     spaces to print-record.
     initialize WS2-Totals.
     add      2 to line-cnt.
     if       line-cnt > WS-Line-Cnt-Size-2  *> 49
              perform CCA030-LBR-Heads.
*>
 CCA999-EXIT. exit section.
*>
 CCB000-LBR-ANALYSIS   SECTION.
*>============================
*>
*> Accumulate Aircraft Stats
*>
     PERFORM  ZJ000-SEARCH-FOR-AIRCRAFT.               *> changed from ZH000 as THIS uses the table
     MOVE     C TO A.
     IF       C = ZERO                                 *> changed as excessive  - only doing the 1 aircraft.
              display  FL013 at line ws-21-lines col 01 with erase eol
              perform  CCB010-Save-New-Aircraft          *> C updated by resorted table & size
              PERFORM  ZJ000-SEARCH-FOR-AIRCRAFT        *> so must search again, for new entry
              move C  to  A.                            *>  and not be zero
*>
     ADD      FLT-P1 (1) TO WS-AC-P1 (A, 1).
     ADD      FLT-P1 (2) TO WS-AC-P1 (A, 2).
     if       FLT-MS  =  "M"                           *> Multi Engine time total for all Capacities.
              add FLT-P1 (1) FLT-P1 (2)  FLT-P23 (1) FLT-P23 (2) to WS-AC-Multi (A).
     ADD      FLT-INSTRUMENT TO WS-AC-IFR (A).
*>
*>   Now lets sort out p2 & p3 for Analysis
*>
     IF       FLT-CAPACITY (2:1) = "2"
              ADD  FLT-P23 (1) TO WS-AC-P2 (A, 1)
              ADD  FLT-P23 (2) TO WS-AC-P2 (A, 2)
     ELSE
       if     FLT-CAPACITY (2:1) = "3"
              ADD  FLT-P23 (1) TO WS-AC-P3 (A, 1)
              ADD  FLT-P23 (2) TO WS-AC-P3 (A, 2).
*>
     IF       FLT-CAPACITY = "P1I" or "P1T"
              ADD FLT-P1 (1) FLT-P1 (2) TO WS-AC-INST (A).
*>
*>  Accumulate airfield stats   -  Adding a missing airfield to both file and table.
*>
     move     FLT-From to WS-ICAO-Code.
     perform  ZN000-SEARCH-FOR-ICAO.
     move     Error-Code to A.
     if       A = zero
              perform CCB020-Create-Airfield thru CCB030-Exit.
*>
     if       A not = zero
              move FLT-Date to WST-Afld-Last-Flt (A)
              add  1        to WST-Afld-Cnt (A).
     if       FLT-From not = FLT-To
              move FLT-To to WS-ICAO-Code
              perform  ZN000-SEARCH-FOR-ICAO
              move     Error-Code to A
              if       A = zero
                       perform CCB020-Create-Airfield thru CCB030-Exit
              end-if
              if       A not = zero
                       move FLT-Date to WST-Afld-Last-Flt (A)
                       add  1        to WST-Afld-Cnt (A).
*>
     GO       TO CCB999-EXIT.
*>
 CCB010-Save-New-Aircraft.                    *> to file & table then sort table after updating).
     ADD      1 TO WST-AIRCRAFT-SIZE.
     move     FLT-AC-Type to Aircraft-Type     WST-AIRCRAFT    (WST-AIRCRAFT-SIZE).
     move     FLT-AC-Reg  to Aircraft-Last-Reg WST-AC-Last-Reg (WST-AIRCRAFT-SIZE).
     move     FLT-Date    to Aircraft-Last-Flt WST-AC-Last-Flt (WST-AIRCRAFT-SIZE).
     move     FLT-MS      to Aircraft-MS       WST-AC-MS       (WST-AIRCRAFT-SIZE).
     if       FLT-MS = "M"
              move     "Y"    to Aircraft-Complex WST-AC-Complex (WST-AIRCRAFT-SIZE)
     else
              move     space  to Aircraft-Complex WST-AC-Complex (WST-AIRCRAFT-SIZE).
*>
     write    Aircraft-Record.
     sort     WST-ACFT-Groups on ascending key  WST-AIRCRAFT.
*>
 CCB020-Create-Airfield.                   *> Shouldn't happen but user could have deleted record or file?
     initialise Airfield-Record.           *>  such will appear of afld lists with missing names.
     move     "NAME MISSING" to AFLD-Name.
     move     WS-ICAO-Code   to ICAO-Code.
     move     FLT-Date       to Afld-Last-Flt.
     write    Airfield-Record.                  *> ingnoring any invalid key - may be had another bad rec & now created.
*>
     add      1 to WST-AIRFIELD-SIZE.           *> update table then sort it.
     MOVE     WS-ICAO-CODE  TO WST-AIRFIELD  (WST-AIRFIELD-SIZE).
     MOVE     AFLD-NAME     TO WST-AFLD-NAME (WST-AIRFIELD-SIZE).
     sort     WST-ICAO on Ascending key WST-AIRFIELD.
     perform  ZN000-Search-For-ICAO.                *> must get the table entry after sorting so error-code set.
     move     Error-Code to A.
*>
 CCB030-Exit. exit.
*>
 CCB999-EXIT. exit section.
*>
 CCC000-LBR-AIRCRAFT-ANALYSIS SECTION.
*>===================================
*>
     MOVE     66 TO LINE-CNT.
     move     spaces to Print-Record.
     write    Print-Record after 1.                  *> Clear anything in buffer chgd to after!
 *>    PERFORM  CCA040-LBR-SUBS thru cca050-subs.
     MOVE     ZERO TO A.
*>
 CCC020-LBR-HH-HEADS.
     ACCEPT   WSB-TIME FROM TIME.
     IF       WSB-TIME NOT = "00000000"
              MOVE WSB-HH TO WSD-HH
              MOVE WSB-MM TO WSD-MM
              MOVE WSB-SS TO WSD-SS
              MOVE WSD-TIME TO WS-TIME.
*>
     IF       LINE-CNT > WS-Line-Cnt-Size-1   *> 55
       AND    DISPLAY-FLAG = ZERO
              ADD 1 TO PAGE-CNT
              MOVE ZERO TO LINE-CNT
              MOVE SPACES TO PRINT-RECORD
              move     Prog-Name  to PH1-Prog
              MOVE " FULL Aircraft ANALYSIS FOR" to ph1-title1
              MOVE WS-USER  TO PH1-NAME
              MOVE "PAGE" TO Ph1-TITPAG
              MOVE PAGE-CNT TO Ph1-PAGE
              MOVE WS-TIME TO Ph1-TIME
              MOVE WSF-Date TO Ph1-DATE
              if       Page-Cnt > 1
                       WRITE    PRINT-RECORD AFTER PAGE
              else
                       write    Print-Record after 1
              end-if
              MOVE "AIRCRAFT  ----- DAY FLYING -----  --- NIGHT FLYING -----" TO PRINT-RECORD
              WRITE PRINT-RECORD AFTER 2
              MOVE "  TYPE       P1      P2      P3      P1      P2      P3     TOTAL   IFR      Multi    Inst.     Last Flt"
                                               TO PRINT-RECORD
              WRITE PRINT-RECORD AFTER 1
              MOVE SPACES TO PRINT-RECORD
              WRITE PRINT-RECORD AFTER 1.
*>
     IF       DISPLAY-FLAG NOT = ZERO
              MOVE ZERO TO LINE-CNT
              MOVE 0201 TO CURS.
*>
     if       SW-ACFT-Date = 1
              sort WST-ACFT-Groups  on descending key WST-AC-Last-FLT.
 CCC030-LBR-HH-GET-REC.
     ADD      1 TO A.
     IF       A > WST-AIRCRAFT-SIZE
              move 1 to Aircraft-Rep-Flag
              sort WST-ACFT-Groups on ascending key WST-Aircraft     *> reset sort order
              GO TO CCC999-EXIT.
*>
     if       SW-ACFT-Date = 1                      *> Ignore aircraft not flown
         and  WST-AC-Last-Flt (A) = zero
              go to CCC030-LBR-HH-GET-REC.
     IF       LINE-CNT > WS-Line-Cnt-Size-1
              PERFORM CCC020-LBR-HH-HEADS.
*>
     MOVE     WST-AIRCRAFT (A) TO PR2-AIRCRAFT.
     MOVE     WS-AC-P1 (A, 1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (1).
*>
     MOVE     WS-AC-P2 (A, 1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (2).
*>
     MOVE     WS-AC-P3 (A, 1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (3).
*>
     MOVE     WS-AC-P1 (A, 2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (4).
*>
     MOVE     WS-AC-P2 (A, 2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (5).
*>
     MOVE     WS-AC-P3 (A, 2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-P (6).
*>
     ADD      WS-AC-P1 (A, 1) WS-AC-P2 (A, 1) WS-AC-P3 (A, 1)
              WS-AC-P1 (A, 2) WS-AC-P2 (A, 2) WS-AC-P3 (A, 2)
                 GIVING WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-TOTAL.
*>
     MOVE     WS-AC-IFR (A) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-IFR.
*>
     MOVE     WS-AC-MULTI (A) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-MULTI.
*>
     move     WS-AC-Inst (A) to WS-Work3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PR2-INST.
*>
     MOVE     WST-AC-Last-Flt (A) TO WS-Test-Intl.
     perform  ZZ060-Convert-Date.
     MOVE     WS-Test-Date TO PR2-Last-Flt.
     IF       DISPLAY-FLAG = ZERO
              WRITE  PRINT-RECORD AFTER 1
              ADD 1 TO LINE-CNT
              GO TO CCC030-LBR-HH-GET-REC.
*>
     ADD      100 TO CURS.
     IF       CURS > WS-DFT-Scrn-BE-Length                *> Was   2301   20/11/18
              DISPLAY "Hit return when ready for next screen" line ws-Lines col 01
              accept  ws-reply line ws-Lines col 40
              MOVE 101 TO CURS
              DISPLAY SPACE at 0101 with erase eos.   *> This may be wrong !!!
*>
     DISPLAY  PRINT-RECORD2 AT CURS.
     GO       TO CCC030-LBR-HH-GET-REC.
*>
 CCC040-RESTORE-ANAL-TOTS.
     MOVE     ZERO TO ERROR-CODE.
     DIVIDE   WS-WORK3 BY 60 GIVING WS-WORK3 REMAINDER WS-WORK4  ON SIZE ERROR MOVE 1 TO ERROR-CODE.
     MULTIPLY 100 BY WS-WORK3.
     ADD      WS-WORK4 TO WS-WORK3.
*>
 CCC999-EXIT. EXIT  section.
*>
 CCD000-Airfield-Lists SECTION.
*>============================
*>
     MOVE     66 TO LINE-CNT.         *> Force new heads
     MOVE     ZERO TO ERROR-CODE ICAO-CODE Z WS-Tmp-Afld2.
     PERFORM  CCD040-LIST-AFLD-HEADS.
*>
 CCD010-START.
     if       Error-Code > zero                       *> save last afld else use zero
              move WST-Airfield (Error-Code) to WS-Tmp-Afld2.
 *>
     if       Z > 1
              write Print-Record4 after 1
              move  zero to Z
              add   1 to Line-Cnt
              move  spaces to Print-Record
              perform CCD040-List-Afld-Heads
     end-if
     add      1 to Error-Code.
     if       Error-Code > WST-Airfield-Size
              if  Z  >  zero
                  write Print-Record4 after 1
                  move  spaces to Print-Record
              end-if
              go to CCD999-Exit
     end-if
*>
     if       SW-AFLD-Used = 1                              *> when set AFLD-Used (1)
       and    WST-Afld-Last-Flt (Error-Code) = zero         *> Ignore airfields not used.
              go to CCD010-Start.                           *> JIC user added country/world wide fields
     move     WST-Airfield (error-code) to WS-Tmp-Afld.
     add      1 to Z.
     if       Error-Code < 2            *> Ignore above test if error-code = 1 - 1st afld
              move 1 to Z.
     if       Z > 2
              write Print-Record4 after 1
              add   1 to Line-Cnt
              move  spaces to Print-Record
              perform CCD040-List-Afld-Heads
     end-if
     MOVE     WST-AIRFIELD  (ERROR-CODE) TO PR4-ICAO (Z).
     MOVE     WST-AFLD-NAME (ERROR-CODE) TO PR4-AFLD-NAME (Z).
     MOVE     WST-Afld-Last-Flt (ERROR-CODE) TO WS-Test-Intl.
     perform  ZZ060-Convert-Date.
     MOVE     WS-Test-Date               TO PR4-Afld-Lt-Flt (Z).
     move     WST-Afld-Cnt (ERROR-CODE)  to PR4-Afld-Cnt (Z).
*>
     go       to CCD010-Start.
*>
 CCD040-LIST-AFLD-HEADS.
     IF       LINE-CNT > WS-Line-Cnt-Size-1
              move spaces to Print-Record
              ADD  1         TO PAGE-CNT
              MOVE ZERO      TO LINE-CNT
              move spaces    to Print-Record
              move PROG-NAME to PH1-Prog
              MOVE " ICAO Airfield Report for  " TO PH1-Title1
              MOVE WS-USER   TO PH1-NAME
              MOVE "PAGE"    TO Ph1-TITPAG
              MOVE PAGE-CNT  TO PH1-PAGE
              MOVE WS-TIME   TO PH1-TIME
              MOVE WSF-Date  TO PH1-DATE
              if       Page-Cnt > 1
                       WRITE    PRINT-RECORD AFTER PAGE
              else
                       write    Print-Record after 1
              end-if
              move spaces to Print-Record
              MOVE "ICAO      Airfield                        Cnt   Last Flt " TO PR4-Afld-Group (1)
                                                                  PR4-Afld-Group (2)
              WRITE PRINT-RECORD4 AFTER 2
              MOVE SPACES TO PRINT-RECORD
              WRITE PRINT-RECORD4 AFTER 1
     end-if.
*>
 CCD999-EXIT. exit section.
*>
 CCE000-CoE-Analysis  section.
*>===========================
*>
*>  Now for analysis for CoE by shortest period.
*>   The computations are done one at a time and are cumlative.
*>    That is the Additions for each CoE are added too from the previous total:
*>
*> This means that the comps for 3 months are added to the previous
*>     1 month plus two, then for 6 months plus another 7, for 13 months.
*>    this way the file is only read the once.
*>
*>    log book read in reversed order
*>
     start    Flightlog-File LAST.      *> we are reading backwards (previous)
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CCE999-Exit.
     initialise WS4-Totals.
     move     spaces to CoE-Lines.
*>
 CCE010-Get-N-Compute-Days.
     display  "Specify from date to use for Cert. of Experience info"
                                           at line ws-21-lines col 01 with erase eol.
     display  "Date to use - [dd/mm/ccyy]" at line ws-22-lines col 11.
     if       LTZ-USA
              display "mm/dd" at line ws-22-lines col 26
      else
       if     LTZ-Unix
              display "ccyy/mm/dd" at line ws-22-lines col 26.
     move     Save-FLT-Date to WS-Test-Intl.
     perform  ZZ060-Convert-Date.
     ACCEPT   WS-Test-Date AT line ws-22-lines col 26 with update.
     PERFORM  ZA000-DATE-CHECK.   *> O/P as WS-Test-Intl and WSA-Date/WSA-Date2
*>
     IF       ERROR-CODE NOT = ZERO     *> date has error
              DISPLAY FL014 AT line ws-23-lines col 01 with foreground-color COB-COLOR-RED
              GO TO CCE010-Get-N-Compute-Days.
     display  space at line ws-21-lines col 01 with erase eol.
     display  space at line ws-22-lines col 01 with erase eol.
     display  space at line ws-23-lines col 01 with erase eol.
     move     WS-Test-Intl to WSA-Date2.
     move     WS-Test-Date to Active-CoE-Date.  *> as LOCALE date
*>
*> redo start for date + 1
*>
     add      1 to WS-Test-Intl giving FLT-Date.                *> 1st read will be the date needed or earlier.
     move     zero to FLT-Start.
     start    Flightlog-File key not > FLT-Date-Time-Key.
*>
 *> CCE015-Compute-CoE.
*>
*> now work out the # months for each CoE  using WSA-MM and WSA-Date2
*>  as one, 3, 6 and 13 months. Fields CoE-xxxx will have the earliest date
*>    within requested range for each CoE. these dates are INTL
*>
     perform  CCE100-Deduct-A-Month.
     move     WSA-Date2 to CoE-1-Mth.
     perform  CCE100-Deduct-A-Month 2 times.
     move     WSA-Date2 to CoE-Quarter.
     perform  CCE100-Deduct-A-Month 3 times.
     move     WSA-Date2 to CoE-6-Mths.
     perform  CCE100-Deduct-A-Month 7 times.
     move     WSA-Date2 to CoE-13-Mths.
*>
*> Get the print headings out of the way
*>
     move     spaces to print-record.
     ACCEPT   WSB-TIME FROM TIME.
     IF       WSB-TIME NOT = "00000000"
              MOVE WSB-HH TO WSD-HH
              MOVE WSB-MM TO WSD-MM
              MOVE WSB-SS TO WSD-SS
              MOVE WSD-TIME TO WS-TIME.
*>
     add      1  to Page-Cnt.
     MOVE     ZERO TO LINE-CNT.
     MOVE     SPACES TO PRINT-RECORD.
     move     Prog-Name  to PH1-Prog.
     MOVE     "   Cert. of Experiences for" to ph1-title1.
     MOVE     WS-USER  TO PH1-NAME.
     MOVE     "PAGE" TO Ph1-TITPAG.
     MOVE     PAGE-CNT TO Ph1-PAGE.
     MOVE     WS-TIME TO Ph1-TIME.
     MOVE     WSF-Date TO Ph1-DATE.
     if       Page-Cnt > 1
              WRITE    PRINT-RECORD AFTER PAGE
     else
              write    Print-Record after 1.
     move     " The following to be read in conjuction with the Aircraft report page/s" TO PRINT-RECORD.
     write    Print-Record after 2.
     move     spaces to Print-Record.
     string   "      Active date used for all Certificate of Experience data is "
              Active-CoE-Date   into Print-Record.
     write    Print-Record after 1.
     MOVE     "            -------- DAY FLYING ---------      ------- NIGHT FLYING --------" TO PRINT-RECORD.
     WRITE    PRINT-RECORD AFTER 2.
     MOVE     "CoE Type    P1      P2     P3    Inst. Flts    P1      P2     P3    Inst. Flts    TOTAL     (IFR   Single    Multi   Inst.)"
                   TO PRINT-RECORD.
     WRITE    PRINT-RECORD AFTER 1.
     MOVE     SPACES TO PRINT-RECORD.
     WRITE    PRINT-RECORD AFTER 1.
*>
 CCE020-Compute-for-Mths.
     read     Flightlog-File PREVIOUS at end
              move "99" to FS-Reply.
     if       FS-Reply not = "00"
              perform CCE140-Do-CoE-1-Mth
              go to CCE900-We-are-done.
     if       FLT-Date > WS-Test-Intl                *> record is too new. Need to keep reading
                                                     *>   backwards but should not now happen.
              go to CCE020-Compute-for-Mths.
     if       FLT-Date not < CoE-1-Mth
              perform CCE130-WS4-Additions
              go to CCE020-Compute-for-Mths.
     perform  CCE140-Do-CoE-1-Mth.
     go       to CCE035-Test.   *> Bypass read as we have a rec
*>
 CCE030-Compute-for-Quarter.
     if       FS-Reply not = "00"
              move spaces to Print-Record
              string "No data for Quarter experience for "
                     CoE-Quarter
                       into print-record
              write    Print-Record after 1
              go to CCE900-We-are-done.
     read     Flightlog-File PREVIOUS at end
              move "99" to FS-Reply.
     if       FS-Reply not = "00"
              perform CCE150-Do-CoE-Quarter
              go to CCE900-We-are-done.
*>
 CCE035-Test.
     if       FLT-Date not < CoE-Quarter
              perform CCE130-WS4-Additions
              go to CCE030-Compute-for-Quarter.
     perform  CCE150-Do-CoE-Quarter.
     go       to CCE045-Test.   *> Bypass read as we have a rec
*>
 CCE040-Compute-for-6-Mths.
     if       FS-Reply not = "00"
              move spaces to Print-Record
              string "No data for 6 months experience for "
                     CoE-6-Mths
                          into print-record
              write    Print-Record after 1
              go to CCE900-We-are-done.
     read     Flightlog-File PREVIOUS at end
              move "99" to FS-Reply.
     if       FS-Reply not = "00"
              perform CCE160-Do-CoE-6-Mths
              go to CCE900-We-are-done.
*>
 CCE045-Test.
     if       FLT-Date not < CoE-6-Mths
              perform CCE130-WS4-Additions
              go to CCE040-Compute-for-6-Mths.
     perform  CCE160-Do-CoE-6-Mths.
     go       to CCE055-Test.   *> Bypass read as we have a rec
*>
 CCE050-Compute-for-13-Mths.
     if       FS-Reply not = "00"
              move spaces to Print-Record
              string "No data for 13 months experience for "
                     CoE-13-Mths
                           into print-record
              write    Print-Record after 1
              go to CCE900-We-are-done.
     read     Flightlog-File PREVIOUS at end
              move "99" to FS-Reply.
     if       FS-Reply not = "00"
              perform CCE170-Do-CoE-13-Mths
              go to CCE900-We-are-done.
*>
 CCE055-Test.
    if        FLT-Date not < CoE-13-Mths
              perform CCE130-WS4-Additions
              go to CCE050-Compute-for-13-Mths.
     perform  CCE170-Do-CoE-13-Mths.
     go       to CCE900-We-are-Done.
*>
 CCE100-Deduct-A-Month.
     subtract 1 from WSA-MM.
     if       WSA-MM < 1
              subtract 1 from WSA-YY
              move    12   to WSA-MM.
*>
 CCE130-WS4-Additions.
     if       FLT-Capacity (2:1) = "1"
              add     FLT-P1 (1) to WS4-P1 (1)
              add     FLT-P1 (2) to WS4-P1 (2)
     end-if
     if       FLT-Capacity  = "P1I" or "P1T"
              add     FLT-P1 (1) to WS4-INSX
              add     FLT-P1 (2) to WS4-INSX
              add     FLT-P1 (1) to WS4-INS (1)
              add     FLT-P1 (2) to WS4-INS (2)
     end-if
     if       FLT-Capacity (2:1) = "2"
              add     FLT-P23 (1) to WS4-P2 (1)
              add     FLT-P23 (2) to WS4-P2 (2)
     end-if
     if       FLT-Capacity (2:1) = "3"
              add     FLT-P23 (1) to WS4-P3 (1)
              add     FLT-P23 (2) to WS4-P3 (2)
     end-if
     if       FLT-MS = "S"
              add     FLT-P1 (1)  FLT-P1 (2)  FLT-P23 (1) FLT-P23 (2)  to WS4-Single
     else
              add     FLT-P1 (1)  FLT-P1 (2)  FLT-P23 (1) FLT-P23 (2)  to WS4-Multi
     end-if
     add      FLT-Instrument to WS4-Instrument.
     if       FLT-P1  (1) not = zero
         or   FLT-P23 (1) not = zero
              add  1 to WS4-Day-Flights
     end-if
     if       FLT-P1  (2) not = zero
         or   FLT-P23 (2) not = zero
              add  1 to WS4-Nite-Flights
     end-if.
*>
 CCE140-Do-CoE-1-Mth.
     move     "1 Month "       to PCoE-Type.
     perform  CCE200-Do-CoE.
*>
 CCE150-Do-CoE-Quarter.
     move     "3 Months"       to PCoE-Type.
     perform  CCE200-Do-CoE.
*>
 CCE160-Do-CoE-6-Mths.
     move     "6 Months"       to PCoE-Type.
     perform  CCE200-Do-CoE.
*>
 CCE170-Do-CoE-13-Mths.
     move     "13 Mths"       to PCoE-Type.
     perform  CCE200-Do-CoE.
*>
 CCE200-Do-CoE.
*>
*> Have data for the CoE so print it
*>
     MOVE     WS4-Day-Flights  TO PCoE-Day-Flts.
     MOVE     WS4-Nite-Flights TO PCoE-Nite-Flts.
     MOVE     WS4-INSX TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Inst.
     MOVE     WS4-Single TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Single.
     MOVE     WS4-Multi TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Multi.
     MOVE     WS4-INSTRUMENT TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-IFR.
     MOVE     WS4-P1 (1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Day-P1.
     MOVE     WS4-P2 (1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Day-P2.
     MOVE     WS4-P3 (1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Day-P3.
     MOVE     WS4-P1 (2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Nite-P1.
     MOVE     WS4-P2 (2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Nite-P2.
     MOVE     WS4-P3 (2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Nite-P3.
     MOVE     WS4-INS (1) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Day-Ins.
     MOVE     WS4-INS (2) TO WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Nite-Ins.
     ADD      WS4-P1 (1)  WS4-P1 (2)  WS4-P2 (1)
              WS4-P2 (2)  WS4-P3 (1)  WS4-P3 (2)   giving WS4-Total.
     move     WS4-Total    to WS-WORK3.
     PERFORM  CCC040-RESTORE-ANAL-TOTS.
     MOVE     WS-WORKB TO PCoE-Total.
     write    CoE-Lines after 1.
*>
 CCE900-We-are-Done.
     if       Aircraft-Rep-Flag = zero
              MOVE 1 TO ANALYSIS-ONLY-FLAG
              PERFORM CC000-LOG-BOOK-REPORT.
*>
 CCE999-Exit. exit section.
*>
 CD000-Amend-Airfield-Code  SECTION.
*>=================================
*>
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Change Airfield ICAO code" AT 0128 WITH foreground-color COB-COLOR-GREEN.   *> 'Entry" at cc42
     display  "ICAO Code " at 0301
     display  " Old    New    Name" at 0401.
     display  "[abcd] [abcd] [abcdefghijklmnopqrst]" at 0501.
     display  "Spaces in Old will terminate function & in New will request again" at 0801 with foreground-color COB-COLOR-CYAN.
*>
 CD010-Get-Code.
     move     spaces to WS-ICAO-Code.
     accept   WS-ICAO-Code at 0502.
     move     function upper-case (WS-ICAO-Code) to WS-ICAO-Code ICAO-Code.
     if       WS-ICAO-Code (1:1) = space
              go to CD999-Exit.
     display  ICAO-Code at 0502.
     accept   WS-New-ICAO-Code at 0509.
     move     function upper-case (WS-New-ICAO-Code) to WS-New-ICAO-Code.
     if       WS-New-ICAO-Code = space
              go to CD010-Get-Code.
     display  WS-New-ICAO-Code at 0509.
*>
*> Now go through the flightlog records and see if old airfield code is used.
*>
     start    Flightlog-File FIRST.
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CD999-Exit.
*>
 CD020-Read-Flitelog.
     read     Flightlog-File next record at end
              go to CD030-Proc-Afld-File.
     if       FLT-From = WS-ICAO-Code
              move WS-New-ICAO-CODE to FLT-From.
     if       FLT-TO   = WS-ICAO-Code
              move WS-New-ICAO-CODE to FLT-TO.
     rewrite  Flightlog-Record.
     if       FS-Reply not = "00"
              display    FL003 at 0801  foreground-color COB-COLOR-RED
              accept     WS-Reply at 0855
              display    space at 0801 with erase eol
              go to CD999-Exit.                        *> serious problem somewhere, no disk space ?
     go       to CD020-Read-Flitelog.
*>
 CD030-Proc-Afld-File.
     move     WS-ICAO-Code to ICAO-Code.
     Read     Airfield-File key ICAO-Code          INVALID KEY
              display    FL023 at 0901 with foreground-color COB-COLOR-RED
              display    FS-Reply at 0960
              display    space at 0901 with erase eol
              initialize Airfield-Record
              move       spaces to WS-Afld-Name
              move       zero to WS-Tmp-Afld-Last-Flt   NOT INVALID KEY
              move       AFLD-Name to WS-Afld-Name
              move       Afld-Last-Flt to WS-Tmp-Afld-Last-Flt
     end-read.
     accept   WS-Afld-Name  at 0516 with update.
     if       FS-Reply = "00"                           *> only do if rec found
              delete   Airfield-File record
     end-if.
     move     WS-New-ICAO-Code to ICAO-Code.
     move     WS-Afld-Name to AFLD-Name.                *> Yes retaining last-flt date as that will be still be valid
     move     WS-Tmp-Afld-Last-Flt to Afld-Last-Flt.
     write    Airfield-Record  INVALID KEY              *> exists so read and update
              go to CD040-Read-Existing.
     go       to CD010-Get-Code.
*>
 CD040-Read-Existing.
     read     Airfield-File key WS-New-ICAO-Code NOT INVALID KEY
              move       WS-Afld-Name to AFLD-Name
              move       WS-Tmp-Afld-Last-Flt to Afld-Last-Flt
              rewrite    Airfield-Record.
     go       to CD010-Get-Code.
*>
 CD999-Exit.  exit  section.
*>
 CE000-Amend-Aircraft-Type section.
*>================================
*>
     PERFORM  A020-DISPLAY-MENU.
     DISPLAY  "Change Aircraft type" AT 0128 WITH foreground-color COB-COLOR-GREEN.   *> 'Entry" at cc42
     display  "- - - - Type - - - -" at 0301
     display  " Old        New" at 0401.
     display  "[abcdefgh] [abcdefgh]" at 0501.
     display  "Spaces in Old will terminate function & in New will request again" at 0801 with foreground-color COB-COLOR-CYAN.
*>
 CE010-Get-Type.
     move     spaces to WS-Old-AC-Type.
     accept   WS-Old-AC-Type at 0502.
     move     function upper-case (WS-Old-AC-Type) to WS-Old-AC-Type Aircraft-Type.
     if       WS-Old-AC-Type (1:1) = space
              go to CE999-Exit.
     display  WS-Old-AC-Type at 0502.
     accept   WS-New-AC-Type at 0513.
     move     function upper-case (WS-New-AC-Type) to WS-New-AC-Type.
     if       WS-New-AC-Type = space
              go to CE010-Get-Type.
     display  WS-New-AC-Type at 0513.
     start    Flightlog-File FIRST.
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to CE999-Exit.
*>
 CE020-Read-Flitelog.
     read     Flightlog-File next record at end
              go to CE030-Proc-Acft-File.
     if       FLT-AC-Type = WS-Old-AC-Type
              move WS-New-AC-Type to FLT-AC-Type
              rewrite    Flightlog-Record
              if         FS-Reply not = "00"
                         display FL003 at 0801  foreground-color COB-COLOR-RED
                         accept  WS-Reply at 0855
                         display  space at 0801 with erase eol
                         go to CE999-Exit.                        *> serious problem somewhere, no disk space ?
     go       to CE020-Read-Flitelog.
*>
 CE030-Proc-Acft-File.
     move     WS-Old-AC-Type to Aircraft-Type.
     Read     Aircraft-File key Aircraft-Type      INVALID KEY
              display    FL035 at 0901 with foreground-color COB-COLOR-RED
              display    FS-Reply at 0960
              display    space at 0901 with erase eol
              initialize Aircraft-Record.
*>
     if       FS-Reply = "00"                         *> only do if rec found
              delete     Airfield-File record.
     move     WS-New-AC-Type to Aircraft-Type.
     write    Airfield-Record.
     go       to CE010-Get-Type.
*>
 CE999-Exit.  exit section.
*>
 D000-SETUP-DATAFILES  SECTION.
*>============================
*>
*> First test for existance of ISAM files then SEQ files and process or setup accordingly
*>
     move     zeros to File-Status-Flags.
     CALL     "CBL_CHECK_FILE_EXIST" USING "flightlog.dat" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Flightlog-dat-Exists.
     CALL     "CBL_CHECK_FILE_EXIST" USING "airfield.dat" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Airfield-dat-Exists.
     CALL     "CBL_CHECK_FILE_EXIST" USING "aircraft.dat" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Aircraft-dat-Exists.
     CALL     "CBL_CHECK_FILE_EXIST" USING "flightlog.seq" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Flightlog-Seq-Exists.
     CALL     "CBL_CHECK_FILE_EXIST" USING "airfield.seq" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Airfield-Seq-Exists.
     CALL     "CBL_CHECK_FILE_EXIST" USING "aircraft.seq" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Aircraft-Seq-Exists.
     if       Flightlog-Dat-Exists = 1
         and  Aircraft-Dat-Exists = 1
         and  Airfield-Dat-Exists = 1
              go to D000-Exit.
*>
*> So no data files present - chk for sequential ones
*>
     if       Flightlog-Seq-Exists = 1
         and  Aircraft-Seq-Exists = 1
         and  Airfield-Seq-Exists  = 1
              display FL028 at 1201 with erase eol foreground-color COB-COLOR-GREEN
              display FL020 at 1401 with erase eol foreground-color COB-COLOR-GREEN
              display "[ ]" at 1427 with foreground-color COB-COLOR-GREEN
              accept     WS-Reply at 1428
              if         WS-Reply = "Y" or "y"
                         perform ZM000-Recreate-Dat-Files
                         go to D000-Exit
              end-if
     end-if.
     OPEN     I-O FLIGHTLOG-FILE.
     if       FS-Reply not = "00"           *> As open I-O on does not create if not present.
              close FLIGHTLOG-FILE
              open  output FLIGHTLOG-FILE
              close FLIGHTLOG-FILE.
     open     I-O AIRFIELD-FILE
     if       FS-Reply not = "00"
              close AIRFIELD-FILE
              open  output AIRFIELD-FILE
              close AIRFIELD-FILE.
     open     I-O AIRCRAFT-FILE.
     if       FS-Reply not = "00"
              close AIRCRAFT-FILE
              open  output AIRCRAFT-FILE
              close AIRCRAFT-FILE.
*>
 D000-EXIT.   exit section.
*>
 F000-Import-CSV-Data Section.
*>===========================
*>
*>  This will 1st read in the CSV set up data as type 1, 2 & 3 saving
*>   data read into tables in WS-CSV etc, setting SW-CSV-Data-Received.
*>   Like wise reads type 6 and stores the fields if not spaces.
*>
*>  Then read and processes any type 4 (airfield/ports)
*>   and type 5 Aircraft types (any order).  These two could be reentered
*>    so ignore any errors on write.
*>
*> These records can be entered in any order but recommended 1, 2, 3 & 6 if needed
*>   followed by 4 & 5 as required.
*>
*>  At which point it will read in the CSV flight data if
*>  SW-CSV-Data-Received set and store in to the
*>  flight log file, checking for any duplicate flights
*>   reporting on screen such problems, subject to flag to ignore
*>    such duplicates and in this mode dups will be just ignored.
*>
*>  Precoding for inspect converting in case EBCDIC need to be changed to ACSII
*>  when reading the CSV data file but should use converting Beta to Alpha - dont work
*>   due to compiler fault.
*>
     initialise
              WS-CSV-Logbook-Data-Definitions
              WS-CSV-Held-Date-Time-Formats
              SW-CSV-Date-Received      *> CSV Date format record read
              SW-CSV-Data-Received      *> CSV pos. records read
              Return-Code
              A B Y.
*>
     open     input CSV-Layout-File.
     if       FS-Reply not = "00"
              display FL037 at line ws-23-lines col 01 with erase eol
              accept ws-reply at line ws-23-lines col 54
              display space at line ws-23-lines col 01 with erase eol
              go to F998-Finished-Params.
*>
 F020-Read-Data.
     read     CSV-Layout-File at end
              go to F030-Cont-Test.
*>
     if       CSV-Record-type = "1"
              perform F100-Process-Layouts thru F199-Exit
              if    Return-Code not = zero
                    go to F998-Finished-Params
              else
                    go to F020-Read-Data
              end-if
     end-if
     if       CSV-Record-type = "2"
              perform F200-Process-Date-Time-Formats thru F299-exit
              if    Return-Code not = zero
                    go to F998-Finished-Params
              else
                    move 1 to SW-CSV-Date-Received
                    go to F020-Read-Data
              end-if
     end-if
     if       CSV-Record-Type = "3"          *> If not present filename is "CSV-Flitelog"
         and  CSV-FName not = spaces
              move     CSV-FName to CSV-File-Name
              move     CSV-Data-Format to WS-Data-Format
              if       CSV-Delimiter not = quote and not = "'"
                       display FL019 at line ws-22-lines col 01 with erase eol
                       display FL017 at line ws-23-lines col 01 with erase eol
                       accept ws-reply at line ws-23-lines col 30
                       display space at line ws-22-lines col 01 with erase eol
                       display space at line ws-23-lines col 01 with erase eol
              end-if
              move     CSV-Delimiter to WS-Data-Delim (1:1) *> (1:2) for all but last
              go       to F020-Read-Data
     end-if
     if       CSV-Record-type = "4"
              perform F300-Process-New-Afld-Type thru F399-exit
              go to F020-Read-Data
     end-if
     if       CSV-Record-type = "5"
              perform F400-Process-New-Acft-Type thru F499-exit
              go to F020-Read-Data
     end-if
*>
*> if not spaces Held-Cap name to only include data everything else ignored.
*> if not spaces Cap-Sub-Name name to replace such as 'SELF' converted to uppercase
*> if not spaces Rec-Pos4search    save to search for P2/3 pilots name in specific CSV field
*>    as pilots name not in as Captain.
*>
     if       CSV-Record-type = "6"
              move function upper-case (CSV-Captain-Search)  to WS-CSV-Held-Cap
              move function upper-case (CSV-Replace-Captain) to WS-CSV-Cap-Sub-Name
              move function upper-case (CSV-New-Cap)         to WS-CSV-New-Cap
              if       CSV-Rec-Pos4Search numeric
                 and   CSV-Rec-Pos4Search9 > zero and < 97
                       move  CSV-Rec-Pos4Search9 to WS-CSV-Rec-Pos4Search
              end-if
              go to F020-Read-Data
     end-if
     if       CSV-Record-type = space
              go to F020-Read-Data.       *> Ignore blank data records types.
*>
*> Bad CSV Rec. type
*>
     display  FL038 at line ws-22-lines col 01 with erase eol.
     display  FL006 at line ws-23-lines col 01 with erase eol.
     accept   ws-reply at line ws-23-lines col 32.
     display  space at line ws-22-lines col 01 with erase eol.
     display  space at line ws-23-lines col 01 with erase eol.
     go       to F998-Finished-Params.
*>
 F030-Cont-Test.
*>
*>  All params now read in and pre-processed (check) so can process the CSV file.
*>    but first check that date and data has been readin as if not then it has
*>     only processed airfield and/or aircraft data so skip error msgs.
*>
     if       not SW-CSV-Received-Date
        and   not SW-CSV-Received-Data
              go to F998-Finished-Params.
*>
     if       not SW-CSV-Received-Date
              display SY023 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              accept ws-reply at 1332
              move 8 to Return-Code
              go to  F998-Finished-Params.
*>
     if       not SW-CSV-Received-Data
              display FL039 at 1201 with erase eos foreground-color COB-COLOR-RED
              display FL006 at 1301 with erase eol
              accept ws-reply at 1332
              go  to F998-Finished-Params.
     if       Y < WS-CSV-Data-Def-Min-Cnt
              display SY024 at 1201 with erase eos foreground-color COB-COLOR-RED
              display FL006 at 1301 with erase eol
              accept ws-reply at 1332
              go  to F998-Finished-Params.
*>
     move     zero to C.
     perform  varying B from 1 by 1 until B > WS-CSV-Table-Size
              if     WS-CSV-Target-Fld-Pos (B) > 10 and  < 16
                     add    1 to C            *> only counting Pn and inst. entries, max 5.
              end-if
              exit perform cycle
     end-perform.
     if       C < 4
              display FL045 at 1601 with erase eol
              display C     at 1641
              display FL046 at 1701 with erase eol
              display FL017 at 1801 with erase eol
              accept  ws-reply at 1830
              display space at 1601 with erase eol
              if      C < 5
                      display FL047 at 1701 with erase eol
                      accept  ws-reply at 1830
              end-if
              display space at 1701 with erase eol
              display space at 1801 with erase eol
     end-if
     perform  F500-Process-CSV-Data thru F599-Exit.   *> RT could be 0,4,8 ignore for the moment
     go       to F997-Finished-Flt-Data.
*>
 F100-Process-Layouts.
     if       CSV-Src-Position not numeric
          or  CSV-Target-Fld-No > 16               *>    Adjust for correct
              display  SY021 at 1201 with erase eol
              go to F198-Error.
*>
     add      1 to WS-CSV-Table-Size.
     if       WS-CSV-Table-Size > WS-CSV-Table-Max-Size       *> # of fields in FLT file
              display  SY022 at 1201 with erase eol
              subtract 1 from WS-CSV-Table-Size
              go to F198-Error.
*>
     move     CSV-Src-Position    to WS-CSV-Src-Position    (WS-CSV-Table-Size).
     move     CSV-Target-Fld-No   to WS-CSV-Target-Fld-Pos  (WS-CSV-Table-Size).
 *>    if       CSV-Src-No-Quotes not = space                   *> Not used yet.
 *>             move 1              to WS-CSV-Src-No-Quotes   (WS-CSV-Table-Size).
     move     1 to SW-CSV-Data-Received.                 *> position data read
     if       CSV-Src-Position not = zero                *> count of fltlog records used in rec type 1
              add 1 to Y.                                *>  as we need the minimum
     move     zero to Return-Code.
     go       to F199-exit.
*>
 F198-Error.
     display  FL006 at 1301 with erase eol.
     accept   ws-reply at 1332.
     move     8 to Return-Code.
     move     zero to SW-CSV-Data-Received.
*>
 F199-Exit.   exit.
*>
 F200-Process-Date-Time-Formats.
     if       CSV-Date = spaces
        or    CSV-Time-1 = spaces
        or    CSV-Time-2 = spaces
              go to  F298-Param-Error.
*>
     move     function upper-case (CSV-Date) to CSV-Date     WS-CSV-Held-Date-Format.
     move     function upper-case (CSV-Time-1) to CSV-Time-1 WS-CSV-Held-Time1-Format.
     move     function upper-case (CSV-Time-2) to CSV-Time-2 WS-CSV-Held-Time2-Format.
     evaluate WS-CSV-Held-Date-Format
              when "DD/MM/YYYY" move 11 to WS-CSV-Date-Format
              when "YYYY/MM/DD" move 12 to WS-CSV-Date-Format
              when "MM/DD/YYYY" move 13 to WS-CSV-Date-Format
              when "DDMMYYYY"   move  1 to WS-CSV-Date-Format
              when "YYYYMMDD"   move  2 to WS-CSV-Date-Format  *> tested
              when "MMDDYYYY"   move  3 to WS-CSV-Date-Format
              when "YYYYDDD"    move  4 to WS-CSV-Date-Format
*>                                                             None of these should still be used but !
              when "DD/MM/YY"   move 31 to WS-CSV-Date-Format
              when "YY/MM/DD"   move 32 to WS-CSV-Date-Format
              when "MM/DD/YY"   move 33 to WS-CSV-Date-Format
              when "DDMMYY"     move 21 to WS-CSV-Date-Format
              when "YYMMDD"     move 22 to WS-CSV-Date-Format
              when "MMDDYY"     move 23 to WS-CSV-Date-Format
              when "YYDDD"      move 24 to WS-CSV-Date-Format *> after year 2000 should not be used but!
              when other      go to F298-Param-Error
     end-evaluate.
     evaluate WS-CSV-Held-Time1-Format
              when "MMMM"       move  3 to WS-CSV-Time-1-Format
              when "HHMM"       move  1 to WS-CSV-Time-1-Format
              when "HH.MM"
              when "HH:MM"
                                move  2 to WS-CSV-Time-1-Format
              when other      go to F298-Param-Error
     end-evaluate.
     evaluate WS-CSV-Held-Time2-Format
              when "MMMM"       move  3 to WS-CSV-Time-2-Format
              when "HHMM"       move  1 to WS-CSV-Time-2-Format
              when "HH.MM"
              when "HH:MM"
                                move  2 to WS-CSV-Time-2-Format
              when other      go to F298-Param-Error
     end-evaluate.
*>
*>  So here with No Errors in data.
*>
     move     zero to Return-Code.
     go       to F299-Exit.
*>
 F298-Param-Error.
     display  SY023 at 1201 with erase eol.
     display  FL006 at 1301 with erase eol.
     accept   ws-reply at 1332.
     move     8 to Return-Code.
*>
 F299-Exit.   exit.
*>
 F300-Process-New-Afld-Type.      *> ignoring any errors such as dup key etc.
     if       CSV-Airfield-Code not = spaces
        and   CSV-Airfield-Name not = spaces
              move     function upper-case (CSV-Airfield-Code) to CSV-Airfield-Code ICAO-Code
              read     Airfield-File
              end-read
              if       FS-Reply = "00"               *> if it exists just change the name
                       move     CSV-Airfield-Name to AFLD-Name
                       rewrite  Airfield-Record
              else                                   *> doesn't exist so create it
                       move     CSV-Airfield-Code to ICAO-Code
                       move     CSV-Airfield-Name to AFLD-Name
                       move     zeros             to AFLD-Last-Flt
                       write    Airfield-Record
              end-if
     end-if.
*>
 F399-Exit.   exit.
*>
 F400-Process-New-Acft-Type.      *> ignoring any errors such as dup key etc.
     move     function upper-case (CSV-Acft-Type)  to CSV-Acft-Type Aircraft-Type.
     move     function upper-case (CSV-Acft-Complex) to CSV-Acft-Complex.
     move     function upper-case (CSV-Acft-MS) to CSV-Acft-MS.
     read     Aircraft-File.
     if       FS-Reply not = "00"                 *> Good doesn't exist
              move     CSV-Acft-Type    to Aircraft-Type
              move     CSV-Acft-MS      to Aircraft-MS
              move     CSV-Acft-Complex to Aircraft-Complex
              move     zeros            to Aircraft-Last-Flt
              move     spaces           to Aircraft-Last-Reg
              write    Aircraft-Record
              go       to F499-exit
     end-if
     if       CSV-Acft-MS not = space
        and   Aircraft-MS not = CSV-Acft-MS
              move     CSV-Acft-MS to Aircraft-MS
     end-if
     if       CSV-Acft-Complex not = space
        and   Aircraft-Complex not = CSV-Acft-Complex
              move     CSV-Acft-Complex to Aircraft-Complex
     end-if.
     rewrite  Aircraft-Record.
*>
 F499-Exit.   exit.
*>
 F500-Process-CSV-Data.
*>
*> First check we have valid params
*>
     if       WS-CSV-Held-Date-Format = spaces
          or  WS-CSV-Held-Time1-Format = spaces
          or  WS-CSV-Held-Time2-Format = spaces
          or  WS-CSV-Table-Size < WS-CSV-Data-Def-Min-Cnt
          or  not SW-CSV-Received-Date
          or  not SW-CSV-Received-Data
              display  SY021 at 1201 with erase eol
              display  FL006 at 1301 with erase eol
              accept   ws-reply at 1332
              move     8 to Return-Code
              go to F599-Exit
     end-if
*>
*> Param data looks good so continue
*>
     open     input CSV-Data-File.
     if       FS-Reply not = "00"
              display  FL040 at 1201 with erase eol
              display  FL006 at 1301 with erase eol
              accept   ws-reply at 1332
              move     8 to Return-Code
              go to F599-Exit
     end-if
     move     zero to CSV-Recs-In CSV-Recs-Out CSV-Recs-Exist.
*>
 F510-Read-CSV-File.
*>
*> if Held-Cap not spaces  to only include data if matches, everything else ignored.
*> if Cap-Sub-Name not spaces to replace included record CAPTAIN
*>     (such as 'SELF' converted to upper case)
*> but only when processing fld-pos (6) CAPTAIN
*>
     move     spaces to CSV-Data-Record.
     read     CSV-Data-File at end
              display  "CSV Records in  - "   at line ws-21-lines col 01 with erase eol
              display  CSV-Recs-In            at line ws-21-lines col 19
              display  "CSV Records out - "   at line ws-22-lines col 01 with erase eol
              display  CSV-Recs-Out           at line ws-22-lines col 19
              display  "CSV Records Exist - " at line ws-23-lines col 01 with erase eol
              display  CSV-Recs-Exist         at line ws-23-lines col 20
              display  " or rejected "        at line ws-23-lines col 31
              display  FL017                  at line ws-lines    col 01 with erase eol
              accept   WS-Reply at line ws-lines col 30
              display  space at line ws-21-lines col 01 with erase eos
              go to F599-Exit.
*>
*> Check if conversion needed from EBCDIC to ASCII
*>
 *>    if       WS-Data-Format = "E"
 *> *>             inspect CSV-Data-Record converting Beta  to Alpha
 *>             inspect CSV-Data-Record converting Table-EBCDIC to Table-ASCII
 *>             display "CSV data being converted from EBCDIC to ASCII" at line ws-20-lines col 01
 *>             display CSV-Data-Record (1:80) at line ws-18-lines col 01
 *>             display CSV-Data-Record (81:80) at line ws-19-lines col 01.
*>
     if       CSV-Data-Record (1:10) = spaces        *> JIC that a blank line is present.
              go to F510-Read-CSV-File.
*>
     add      1 to CSV-Recs-In.
     move     zero to  B C Return-Code
                       SAVE-FLT-Mth Save-FLT-HH Save-FLT-MM.
     move     1 to A.
     initialise Flightlog-Record.
     perform  varying  B from 1 by 1 until B > WS-CSV-Table-Size
              if       B > WS-CSV-Table-Size
                  or   A not < WS-CSV-Rec-Size     *> Max length of CSV data record def'd in WS
                       exit perform
              end-if
              move     zero to Return-code
              if       A = 1                    *> only done once
                and    CSV-Data-Record (1:1) = quote or = "'"
                and    WS-Data-Delim (1:1) not = CSV-Data-Record (1:1)
                       move CSV-Data-Record (1:1) to WS-Data-Delim (1:1)
              end-if
              move     spaces to WS-CSV-Workx
              move     zeros  to WS-CSV-Work-Count
                 move CSV-Data-Record (A:1) to WS-Tmp-Delim
              if       CSV-Data-Record (A:1) =   quote or = "'"
                       add 1 to A
                       perform F520-Unstring
              else
                       perform F530-Unstring
              end-if
*> TESTING
              if   SW-Testing
                display  "Fld = " at line ws-19-lines col 01
                move     B to WS-Display4
                display  WS-Display4 at line ws-19-lines col 07
                display  "Ptr="     at line ws-19-lines col 12
                move     A  to WS-display4     *> pointer
                display  ws-display4  at line ws-19-lines col 16
                if       WS-CSV-Work-Count = zero
                         move 1 to ws-csv-work-count
                end-if
                display  WS-CSV-Work (1:WS-CSV-Work-Count) at line ws-19-lines col 21 with erase eol
                display  "Delim="  at line ws-19-lines col 41
                display  WS-Tmp-Delim  at line ws-19-lines col 47
                display  "Delim found=" at line ws-19-lines col 50
                display  WS-CSV-Work-Delim  at line ws-19-lines col 62
                display  "Cnt="  at line ws-19-lines col 66
                move     WS-CSV-Work-Count to WS-Display4
                display  ws-display4 at line ws-19-lines col 70
                display  FL017  at line ws-20-lines col 01
                accept   ws-reply at line ws-20-lines col 32
              end-if
*>
              if       WS-CSV-Rec-Pos4Search not = zero            *> test for P2/p3 pilot record if rec 6 present & set.
                 and   B = WS-CSV-Rec-Pos4Search                   *> have type 6 with src-pos matching current CSV pos
                 and   function upper-case (WS-CSV-Work (1:30))
                                      not = WS-CSV-Held-Cap        *> searching for specific Name for P2/3 pilots in fld nn
                       move 2 to Return-Code
                       exit perform
              end-if
*>
*> So if rec 6 set for finding P2/3 record it will be current as else get next CSV record.
*>
              if       WS-CSV-Target-Fld-Pos (B) = 0             *> NO FLT compatable field
                       exit perform cycle                        *>   So skip it
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 1             *> [ FLT-DATE ]
                       perform  F550-Convert-Date thru F559-Exit  *> puts it back into orig fld
                       move     WS-CSV-Work9  to FLT-DATE
                       move     WSA-MM to SAVE-FLT-Mth
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 2 or = 3           *> [ FLT-START ] in minutes
                       move     zero to Z                             *> not working on Pn,Inst.
                       perform  F560-Convert-ES-Time thru F569-Exit
                       if       Return-Code = 8                       *> we have an error
                                go to F599-Exit
                       end-if
                       if  WS-CSV-Target-Fld-Pos (B) = 2
                           move WS-CSV-Work9  to FLT-START
                           exit perform cycle
                       end-if
                       if  WS-CSV-Target-Fld-Pos (B) = 3              *> [ FLT-END ] in minutes
                           move WS-CSV-Work9  to FLT-END
                           exit perform cycle
                       end-if
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 11 or 12 or 13 or 14 or 15 *> (Day P1,23; Nite P1,23; Inst)
                       subtract  10 from WS-CSV-Target-Fld-Pos (B) giving Z   *> = 1 thru 5
                       perform   F560-Convert-ES-Time thru F569-Exit
                       if        Return-Code = 8
                                 go to F599-Exit
                       end-if
                       evaluate Z
                                 when 1   move WS-CSV-Work9 to FLT-P1 (1)     *> Day P!
                                 when 2   move WS-CSV-Work9 to FLT-P23 (1)    *> Day P32
                                 when 3   move WS-CSV-Work9 to FLT-P1 (2)     *> nite P1
                                 when 4   move WS-CSV-Work9 to FLT-P23 (2)    *> nite P23
                                 when 5   move WS-CSV-Work9 to FLT-INSTRUMENT
                       end-evaluate
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 4             *>  FLT-AC-TYPE
                       move      function upper-case (WS-CSV-Work) to WS-CSV-Work FLT-AC-TYPE
                       if        FLT-AC-Type not = spaces
                                 PERFORM  ZH000-SEARCH-FOR-AIRCRAFT
                                 if       C not = zero                  *> Record found On file
                                          if   FLT-MS = space
                                               move Aircraft-MS  to FLT-MS
                                          end-if
                                          exit perform cycle
                                 end-if
                       else
                                 display  FL044 at 1201 with erase eol
                                 display  FL006 at 1301 with erase eol
                                 accept   ws-reply at 1332
                                 display  space at 1201 with erase eol
                                 move     8 to Return-Code              *> A/c type NOT on file.
                                 go to F599-Exit
                       end-if
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 5             *>  FLT-AC-REG(istration)
                       if       WS-CSV-WORK (1:1) = "N"             *>  Ignore the 'N'
                                move WS-CSV-Work (2:5) to FLT-AC-REG
                       else
                                move WS-CSV-Work to FLT-AC-REG
                       end-if
                       move     function upper-case (FLT-AC-REG) to FLT-AC-REG
                       if       FLT-AC-REG  not = spaces
                          and   FLT-AC-Type not = spaces
                          and   C not = zero
                                move     FLT-AC-Reg to Aircraft-Last-Reg
                                rewrite  Aircraft-Record
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 6             *>  FLT-CAPTAIN
                       move WS-CSV-Work (1:15) to FLT-CAPTAIN
                       move function upper-case (FLT-CAPTAIN) to FLT-CAPTAIN
                                                                 WS-Tmp-Captain
                       if       WS-CSV-Held-Cap not = spaces
                         and    WS-CSV-Rec-Pos4Search = zeros    *> Not looking for P2/3 pilot
                         and    WS-CSV-Held-Cap not = FLT-Captain     *>   WS-CSV-Work (1:30)
                                move 2 to Return-Code
                                exit perform                     *> go to F510-Read-CSV-File
                       end-if
                       if       WS-CSV-Cap-Sub-Name not = spaces
                                move WS-CSV-Cap-Sub-Name to FLT-Captain
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 7             *>  FLT-CAPACITY = P1,P1I,P1T,P1S,P2,P3
                       move WS-CSV-Work (1:3) to FLT-CAPACITY    *>  E1,2,3  R1,2,3
                       move function upper-case (FLT-CAPACITY) to FLT-CAPACITY
                       if       FLT-Capacity = "PUT"             *> airline pilot does not use, but JIC for training Est.
                                move "P3 " to FLT-Capacity
                       end-if
                       if       FLT-Capacity (1:1) not = "P" and not = "E" and not = "N"
                                               and not = "R" and not = "T"
                           and  FLT-Capacity (2:1) not = "1" and not = "2" and not = "3"
                                display  FL048 at 1201 with erase eol
                                display  FLT-Capacity at 1242
                                display  FL006 at 1301 with erase eol
                                accept   ws-reply at 1332
                                display  space at 1201 with erase eol
                                move     8 to Return-Code
                                go to F599-Exit
                       end-if
                       if     WS-Tmp-Captain not = spaces        *> Unlikely but JIC
                         and  FLT-Capacity = "P3 "
                              move WS-Tmp-Captain to FLT-Captain
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 8             *>  FLT-FROM Icao afld
                       move WS-CSV-Work (1:4) to FLT-FROM
                       move function upper-case (FLT-FROM) to FLT-FROM WS-ICAO-CODE
                       PERFORM  ZE000-SEARCH-FOR-ICAO
                       IF       ERROR-CODE = ZERO
                                display  FL023 at 1201 with erase eol
                                display  WS-ICAO-Code at 1242
                                display  FL006 at 1301 with erase eol
                                accept   ws-reply at 1332
                                display  space at 1201 with erase eol
                                move     8 to Return-Code
                                go to F599-Exit
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 9             *>  FLT-TO   Icao afld
                       move WS-CSV-Work (1:4) to FLT-TO
                       move function upper-case (FLT-TO) to FLT-TO WS-ICAO-CODE
                       PERFORM  ZE000-SEARCH-FOR-ICAO
                       IF       ERROR-CODE = ZERO
                                display  FL023 at 1201 with erase eol
                                display  WS-ICAO-Code at 1242
                                display  FL006 at 1301 with erase eol
                                accept   ws-reply at 1332
                                display  space at 1201 with erase eol
                                move     8 to Return-Code
                                go to F599-Exit
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 10            *>  FLT-MS Multi/Single acft will be added if omitted which is very likely
                       move WS-CSV-Work (1:1) to FLT-MS
                       move function upper-case (FLT-MS) to FLT-MS
                       if   FLT-MS not = "S" or "M"
                            move "M" to FLT-MS                 *> assuming Employed, it is always Multi
                       end-if
                       exit perform cycle
              end-if
              if       WS-CSV-Target-Fld-Pos (B) = 16            *>  FLT-Remarks
                       move WS-CSV-Work (1:32) to FLT-Remarks
                       exit perform cycle
              end-if
 *>   Process if P1,23 day nite not supplied so use Capacity and end/start times
              if       FLT-P1 (1) = zero and FLT-P23 (1) = zero
                   and FLT-P1 (2) = zero and FLT-P23 (2) = zero
                       perform F580-Compute-P-Time thru F589-Exit
                       exit perform cycle
              end-if
     end-perform.
     if       Return-Code = 2                *> type 6 rec not satisfied.
              go       to  F510-Read-CSV-File.
*>
*> Update Aircraft type last-flt and same for airfield FROM and TO
*>
     if       C not = zero
              move     FLT-Date to Aircraft-Last-Flt
              rewrite  Aircraft-Record
     end-if
*>
*> Update Airports both From and To
*>
     move     FLT-From to WS-ICAO-Code
     perform  ZE000-SEARCH-FOR-ICAO
     if       Error-Code = 1
              move FLT-Date to AFLD-Last-Flt
              rewrite Airfield-Record
     end-if
     if       FLT-From not = FLT-To
              move     FLT-TO to WS-ICAO-Code
              perform  ZE000-SEARCH-FOR-ICAO
              if       Error-Code = 1
                       move FLT-Date to AFLD-Last-Flt
                       rewrite Airfield-Record
              end-if
     end-if
*>
*>  First check if non P1 being processed by evidence of Rec 6, Fld 6 not spaces
*>
     if       WS-CSV-New-Cap not = spaces
              move WS-CSV-New-Cap to FLT-Capacity.
*>
*> Now add flight record - if exists report it but ignore future one's
*>   as user may have reapplied same data.
*>
     write    Flightlog-Record not invalid key
              add      1 to CSV-Recs-Out
              go       to  F510-Read-CSV-File.
     if       FS-Reply = "00"
              add      1 to CSV-Recs-Out
              go       to  F510-Read-CSV-File.

*>
*>  We have a duplicate record (invalid key)
*>
     if       CSV-Recs-Exist = zero
              display  FL041 at line ws-21-lines col 01 with erase eol
              display  FL042 at line ws-22-lines col 01 with erase eol
              MOVE     FLT-DATE TO WS-Test-Intl
              perform  ZZ060-Convert-Date
              MOVE     WS-Test-Date TO PR1-DATE
              display  WS-Test-Date at line ws-22-lines col 43
              display  " at " at line ws-22-lines col 53
              DIVIDE   FLT-START BY 60 GIVING WSF-HH REMAINDER WSF-MM
              move     "." to wsf-dot
              DISPLAY  WSE-TIME  AT line ws-22-lines col 57
              perform  ZZA-File-Status
              display  space at line ws-21-lines col 01 with erase eos
              add      1 to CSV-Recs-Exist
     else
              display  FL041 at line ws-21-lines col 01 with erase eol
              if       CSV-Recs-Exist < 107          *> Only do for 1st 106 recs
                       display  "." at line ws-22-lines col CSV-Recs-Exist
              end-if
     end-if
*>
     go       to  F510-Read-CSV-File.
*>
 F520-Unstring.
     move     spaces to WS-CSV-WorkX.
     move     zero   to WS-CSV-Work-Count.
     if       B not < WS-CSV-Table-Size       *> test for the last CSV field without a comma
              unstring CSV-Data-Record
                     delimited by quote or "'"
                       into WS-CSV-Work
                       delimiter in WS-CSV-Work-Delim
                       count  WS-CSV-Work-Count
                       pointer A
              end-unstring
     else
              unstring CSV-Data-Record
                     delimited by '",' or "',"
                       into WS-CSV-Work
                       delimiter in WS-CSV-Work-Delim
                       count  WS-CSV-Work-Count
                       pointer A
              end-unstring
     end-if.
*>
 F530-Unstring.
     move     spaces to WS-CSV-WorkX.
     move     zero   to WS-CSV-Work-Count.
     if       B not < WS-CSV-Table-Size       *> test for the last CSV field without a comma
              unstring CSV-Data-Record
                     delimited by "    "
                       into WS-CSV-Work
                       delimiter in WS-CSV-Work-Delim
                       count  WS-CSV-Work-Count
                       pointer A
              end-unstring
     else
              unstring CSV-Data-Record
                     delimited by ","
                       into WS-CSV-Work
                       delimiter in WS-CSV-Work-Delim
                       count  WS-CSV-Work-Count
                       pointer A
              end-unstring
     end-if.
*>
 F550-Convert-Date.
     evaluate WS-CSV-Date-Format
              when 12    *> YYYY/MM/DD
                 move     WS-CSV-Work (1:4) to WSA-YY
                 move     WS-CSV-Work (6:2) to WSA-MM
                 move     WS-CSV-Work (9:2) to WSA-DD
                 move     WSA-Date2   to WS-CSV-Work9
              when 2     *> YYYYMMDD
                 continue
              when 11    *> DD/MM/YYYY
                  move     WS-CSV-Work (1:2) to WSA-DD
                  move     WS-CSV-Work (4:2) to WSA-MM
                  move     WS-CSV-Work (7:4) to WSA-YY
                  move     WSA-Date2 to WS-CSV-Work9
              when  1     *> DDMMYYYY
                  move     WS-CSV-Work9 (1:2) to WSA-DD
                  move     WS-CSV-Work9 (3:2) to WSA-MM
                  move     WS-CSV-Work9 (5:4) to WSA-YY
                  move     WSA-Date2 to WS-CSV-Work9
              when 13     *> MM/DD/YYYY
                  move     WS-CSV-Work (1:2) to WSA-MM
                  move     WS-CSV-Work (4:2) to WSA-DD
                  move     WS-CSV-Work (7:4) to WSA-YY
                  move     WSA-Date2 to WS-CSV-Work9
              when  3     *> MMDDYYYY
                  move     WS-CSV-Work9 (1:2) to WSA-MM
                  move     WS-CSV-Work9 (3:2) to WSA-DD
                  move     WS-CSV-Work9 (5:4) to WSA-YY
                  move     WSA-Date2 to WS-CSV-Work9
              when  4     *> YYYYDDD
                  move     WS-CSV-Work9 (1:7)                       to WS-Tmp-Date7
                  move     function INTEGER-OF-DAY (WS-Tmp-Date7)   to WS-Tmp-Date8 *> days since 1601
                  move     function DATE-OF-INTEGER (WS-Tmp-Date8)  to WS-CSV-Work9 *> days to date
              when 24     *> YYDDD
                  move     function DAY-TO-YYYYDDD (WS-CSV-Work (1:5), 70) to WS-Tmp-Date7
                  move     function INTEGER-OF-DAY (WS-Tmp-Date7)          to WS-Tmp-Date8
                  move     function DATE-OF-INTEGER (WS-Tmp-Date8)         to WS-CSV-Work9
              when 32     *> YY/MM/DD
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WS-CSV-Work9 (1:2) to WSA-YY (3:2)
                  move     WS-CSV-Work9 (4:2) to WSA-MM
                  move     WS-CSV-Work9 (7:2) to WSA-DD
                  move     WSA-Date2 to WS-CSV-Work9
              when 22     *> YYMMDD
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WS-CSV-Work9 (1:6) to WSA-Date2 (3:6)
                  move     WSA-Date2 to WS-CSV-Work9
              when 31     *> DD/MM/YY
                  move     WS-CSV-Work9 (1:2) to WSA-DD
                  move     WS-CSV-Work9 (4:2) to WSA-MM
                  move     WS-CSV-Work9 (7:2) to WSA-YY (3:2)
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WSA-Date2 to WS-CSV-Work9
              when 21     *> DDMMYY
                  move     WS-CSV-Work9 (1:2) to WSA-DD
                  move     WS-CSV-Work9 (3:2) to WSA-MM
                  move     WS-CSV-Work9 (5:2) to WSA-YY (3:2)
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WSA-Date2 to WS-CSV-Work9
              when 33     *> MM/DD/YY
                  move     WS-CSV-Work9 (1:2) to WSA-MM
                  move     WS-CSV-Work9 (4:2) to WSA-DD
                  move     WS-CSV-Work9 (7:2) to WSA-YY (3:2)
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WSA-Date2 to WS-CSV-Work9
              when 23     *> MMDDYY
                  move     WS-CSV-Work9 (1:2) to WSA-MM
                  move     WS-CSV-Work9 (3:2) to WSA-DD
                  move     WS-CSV-Work9 (5:2) to WSA-YY (3:2)
                  move     WS-TODAY (1:2)     to WSA-YY (1:2)
                  move     WSA-Date2 to WS-CSV-Work9
     end-evaluate.
*>
 F559-Exit.   exit.
*>
 F560-Convert-ES-Time.
     if       Z = zero
              move  WS-CSV-Time-1-Format to  WS-CSV-Test-Time-Format
     else
              move  WS-CSV-Time-2-Format to WS-CSV-Test-Time-Format
     end-if
     evaluate WS-CSV-Test-Time-Format
              when  3     *> MMMM
                  if       WS-CSV-Work (1:4) numeric
                           move WS-CSV-Work9 (1:4) to WS-CSV-Tmp-Work9
                           move WS-CSV-Tmp-Work9 to WS-CSV-Work9     *> now right just
                           if       WS-CSV-Target-Fld-Pos (B) = 2
                                    divide WS-CSV-Work9 by 60 giving WSF-HH remainder WSF-MM
                                    move  WSF-HH to Save-FLT-HH
                                    move  WSF-MM to Save-Flt-MM
                           end-if
                  else
                           move 8 to Return-Code
                  end-if
              when  1     *> HHMM
                  if       WS-CSV-Work (1:4) numeric
                           move     WS-CSV-Work9 (1:2) to WSF-HH
                           move     WS-CSV-Work9 (3:2) to WSF-MM
                           if       WS-CSV-Target-Fld-Pos (B) = 2
                                    move  WSF-HH to Save-FLT-HH
                                    move  WSF-MM to Save-Flt-MM
                           end-if
                           perform  F561-Convert-Test-HHMM
                  else
                           move 8 to Return-Code
                  end-if
              when  2     *> HH.MM or HH:MM
                  if       WS-CSV-Work (1:2) numeric
                      and  WS-CSV-Work (4:2) numeric
                           move     WS-CSV-Work9 (1:2) to WSF-HH
                           move     WS-CSV-Work9 (4:2) to WSF-MM
                           if       WS-CSV-Target-Fld-Pos (B) = 2    *> Start time
                                    move  WSF-HH to Save-FLT-HH
                                    move  WSF-MM to Save-Flt-MM
                           end-if
                           perform  F561-Convert-Test-HHMM
                  else
                           move 8 to Return-Code
                  end-if
     end-evaluate.
     go       to F569-Exit.
*>
 F561-Convert-Test-HHMM.
     PERFORM  ZF000-CONVERT-LOGBK-TIME.
     IF       ERROR-CODE NOT = ZERO
              display  FL043 at 1201 with erase eol
              display  WS-CSV-Work (1:4) at 1232
              display  FL006 at 1301 with erase eol
              accept   ws-reply at 1332
              display  space at 1201 with erase eol
              move     8 to Return-Code
     else
              move     WSH-Time to WS-CSV-Work9
     end-if.
*>
 F569-Exit.   exit.
*>
 F580-Compute-P-Time.
*>
*>  Here using End and start times and Capacity work out flight time then see
*>   we can work out day nite times but we know it is not accurate during
*>    overlap periods.  In which case user will have to Amend the record.
*>
*>  The CSV file should contain this information anyway.
*>   First check we have valid Date, Start and End times along with Capacity, if
*>     not quit with RT = 8
*>
     move     zero to Return-Code SW-Its-Night.
     if       zeros = FLT-Date or FLT-Start or Flt-End
         or   FLT-Capacity = spaces
              move 8 to Return-Code
              go to F589-Exit.
     if       FLT-P1 (1) not = zero or FLT-P23 (1) not = zero  *> Pn values present!
         or   FLT-P1 (2) not = zero or FLT-P23 (2) not = zero
              go to F589-Exit.
*>
     move     FLT-End to WSH-Time.
     perform  CA140-Enter-Logbk-Tot-Tim-Calc.   *> WS-Time-Remaining = End - Start
     if       Save-FLT-HH = zero or > 23
         or   Save-FLT-Mth = zero or > 12
              move 8 to Return-Code
              go to F589-Exit.
*>
     if       (NIM (SAVE-FLT-Mth) - 2) < Save-FLT-HH
              move 1 to SW-Its-Night.
*>
     if       (FLT-Capacity (1:2)  = "P1" or "E1" or "R1")
        and   SW-Its-Night = zero
              move     WS-Elapsed-Time to FLT-P1 (1)
     else
      if      (FLT-Capacity (1:2)  = "P1" or "E1" or "R1")
         and  SW-Its-Night = 1
              move     WS-Elapsed-Time to FLT-P1 (2)
      else
       if     (FLT-Capacity (1:2)  = "P2" or "P3" or "E2" or "R2" or "E3" or "R3")
         and  SW-Its-Night = zero
              move     WS-Elapsed-Time to FLT-P23 (1)
       else
        if    (FLT-Capacity (1:2)  = "P2" or "P3" or "E2" or "R2" or "E3" or "R3")
         and  SW-Its-Night = 1
              move     WS-Elapsed-Time to FLT-P23 (2).
*>
 F589-Exit.   exit.
*>
 F599-Exit.   exit.
*>
*>
 F997-Finished-Flt-Data.
     close    CSV-Data-File.
*>
 F998-Finished-Params.
     display  space at 1201 with erase eol.
     display  space at 1301 with erase eol.
     close    CSV-Layout-File.
     exit section.
*>
 ZA000-DATE-CHECK      SECTION.
*>============================
*>
*>**************************************************
*>                                                 *
*>   Date Vet Section                              *
*>   ================                              *
*>                                                 *
*>  Keyed input as WS-Test-Date                    *
*>    Output WSA-Date if Error-code = zero         *
*>           WS-Test-Intl                          *
*>     WSA-Date format is not changed so is in the *
*>     form  yyyymmdd                              *
*>                                                 *
*>    Format of date must be UK,USA or Unix format *
*>                                                 *
*>   Error-Code Zero date good, else 1             *
*>    as o/p from ZZ050                            *
*>**************************************************
*>
     MOVE     ZERO TO Z.
     MOVE     1 TO ERROR-CODE.
     if       WS-Test-Date = spaces
              go to ZA999-Exit.
*>
     perform  ZZ050-Validate-Date.      *> converts to Unix and tests,  U-Bin <> 0 is error O/P test-intl
     if       U-Bin not = zero
              GO TO ZA999-EXIT.
*> these moves needed ??
     MOVE     WS-Test-Intl (1:4) TO WSA-YY.
     MOVE     WS-Test-Intl (5:2) TO WSA-MM.
     MOVE     WS-Test-Intl (7:2) TO WSA-DD.
*>
     MOVE     ZERO TO ERROR-CODE.
*>
 ZA999-EXIT.  exit section.
*>
 ZB000-LOAD-AIRFIELDS  SECTION.
*>============================
*>
*> Now only used for statistic reporting and option K.
*>   but init. with HV in key field in case sort puts junk occurs flds ahead of valids
*>      this way the junk will be down from table size count
*>
*> DONT load last-flt so new anal will be accurate if Amend mode used.
*>
*>  FIRST Test if airfield table loaded - if anal done earlier then don't reload it.
*>
     if       WST-Airfield-Size > zero
              go to ZB999-Exit.
*>
     initialise WST-Airfield-TABLE.
     perform  varying WST-Airfield-Size from 1 by 1 until WST-Airfield-Size > WST-Afld-Max
              move high-values to WST-Airfield (WST-Airfield-Size)
     end-perform
     move     zero to WST-Airfield-Size.
     START    AIRFIELD-FILE FIRST.
     if       FS-Reply not = "00"
              move 8 to Return-Code
              go to ZB999-Exit.
*>
 ZB020-LOAD-AFLD-READ.
     READ     AIRFIELD-FILE NEXT RECORD AT END
              GO TO ZB999-EXIT.
     IF       WST-AIRFIELD-SIZE not < WST-AFLD-MAX
              DISPLAY FL027    AT line ws-22-Lines col 01 with erase eos
              accept  ws-reply at line ws-22-Lines col 60
              move    4 to Return-Code
              GO TO ZB999-EXIT.
*>
     IF       icao-code not alphabetic go to ZB020-Load-Afld-Read.
     ADD      1 TO WST-AIRFIELD-SIZE.
     MOVE     ICAO-CODE     TO WST-AIRFIELD  (WST-AIRFIELD-SIZE).
     MOVE     AFLD-NAME     TO WST-AFLD-NAME (WST-AIRFIELD-SIZE).
 *>     move     AFLD-Last-Flt to WST-AFLD-Last-Flt (WST-AIRFIELD-SIZE).
     GO       TO ZB020-LOAD-AFLD-READ.
*>
 ZB999-EXIT.  exit section.
*>
 ZC000-LOAD-AIRCRAFT   SECTION.
*>============================
*>
*>  Init table but set acft field to HV so that sorting will bit give junk data
*>    as such recs will be further back in table beyond current size
*>
     initialise WST-Aircraft-Table.
     perform  varying WST-AIRCRAFT-SIZE from 1 by 1 until WST-AIRCRAFT-SIZE > WST-AC-Max
              move high-values to WST-Aircraft (WST-AIRCRAFT-SIZE)
     end-perform
     MOVE     ZERO TO WST-AIRCRAFT-SIZE.
     START    AIRCRAFT-FILE FIRST.
     if       FS-Reply not = "00"
              move 8 to Return-Code
              go to ZC999-Exit.
*>
 ZC020-READ.
     READ     AIRCRAFT-FILE NEXT AT END
              GO TO ZC999-EXIT.
*>
     if       fs-reply not = "00"
              perform  zza-file-status
              move 8 to Return-Code
              go to zc999-exit.
*>
     IF       WST-AIRCRAFT-SIZE not < WST-AC-MAX
              DISPLAY FL026    AT line ws-22-Lines col 01 with erase eos
              accept  ws-reply at line ws-22-Lines col 60
              move    4 to Return-Code
              GO TO ZC999-EXIT.
*>
     ADD      1 TO WST-AIRCRAFT-SIZE.
     MOVE     Aircraft-Type     TO WST-AIRCRAFT (WST-AIRCRAFT-SIZE).
     MOVE     AIRCRAFT-MS       TO WST-AC-MS (WST-AIRCRAFT-SIZE).
     move     Aircraft-Complex  to WST-AC-Complex   (WST-AIRCRAFT-SIZE).
     move     AIRCRAFT-Last-Reg to WST-AC-Last-Reg  (WST-AIRCRAFT-SIZE).
     move     Aircraft-Last-Flt to WST-AC-Last-Flt  (WST-AIRCRAFT-SIZE).
     GO       TO ZC020-READ.
*>
 ZC999-EXIT.
     exit     section.
*>
 ZE000-SEARCH-FOR-ICAO SECTION.
*>============================
*>
*> Changed to use file
*>
     move     1 to Error-Code.
     move     WS-ICAO-Code to ICAO-Code.
     read     Airfield-File invalid key
              move zero to Error-Code.
*>
 ZE999-EXIT.  exit section.
*>**********
*>
 ZF000-CONVERT-LOGBK-TIME SECTION.
*>===============================
*>
     MOVE     ZERO TO ERROR-CODE.
     IF       WSF-HH NOT NUMERIC OR  WSF-MM NOT NUMERIC OR
              WSF-HH > 23        OR  WSF-MM > 59
              MOVE 1 TO ERROR-CODE
              GO TO ZF999-EXIT.
*>
     MULTIPLY WSF-HH BY 60 GIVING WSH-TIME.
     ADD      WSF-MM TO WSH-TIME.
*>
 ZF999-EXIT.  exit section.
*>
 ZG000-RESTORE-LOGBK-TIME SECTION.
*>===============================
*>
     MOVE     ZERO TO ERROR-CODE.
     DIVIDE   WS-WORK1 BY 60 GIVING WS-WORK1 REMAINDER WS-WORK2
                       ON SIZE ERROR MOVE 1 TO ERROR-CODE.
     MULTIPLY 100 BY WS-WORK1.
     ADD      WS-WORK2 TO WS-WORK1.
*>
 ZG999-EXIT.  exit section.
*>
 ZH000-SEARCH-FOR-AIRCRAFT  SECTION.
*>=================================
*>
*> Changed to use acft file data
*>
     move     FLT-AC-Type to Aircraft-Type.
     move     1 to C.                         *> Set as found but if invalid set to zero
     read     Aircraft-file invalid key
              move zero to C.
*>
 ZH999-EXIT.  exit section.
*>
 ZJ000-SEARCH-FOR-AIRCRAFT  SECTION.
*>=================================
*> Table
*>
     MOVE     ZERO TO C.
     SET      QQ TO 1.
     SEARCH   WST-ACFT-Groups at end
              move zero to C
              WHEN WST-AIRCRAFT (QQ) = FLT-AC-TYPE
                   SET C TO QQ.
*>
 ZJ999-EXIT.  EXIT.
*>
 ZK000-Calc-Remaining Section.
*>===========================
*>
     move     zero to WS-Time-Remaining WS-Time-Remaining-HHMM WSE-Time.
     if       WS-Calc-Time < WS-Elapsed-Time
              subtract WS-Calc-Time from WS-Elapsed-Time giving WS-Time-Remaining
              if       WS-Time-Remaining > zero
                       divide WS-Time-Remaining by 60 giving WSF-HH remainder WSF-MM
                       move   WSE-Time to WS-Time-Remaining-HHMM
              else
                       move   zero to WS-Time-Remaining-HHMM  WSE-Time
              end-if
     end-if.
*>
 ZK999-Exit.  exit section.
*>
 ZL000-Create-Seq-Files section.
*>=============================
*>
*> Called when all dat files open
*>
     start    Flightlog-File FIRST.
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to ZL999-Exit.
     start    Aircraft-File  FIRST.
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to ZL999-Exit.
     start    Airfield-File FIRST.
     if       FS-Reply not = "00"
              display FL016 at line ws-23-lines col 10 with foreground-color COB-COLOR-RED with erase eol
              accept WS-Reply at line ws-23-lines col 50
              go to ZL999-Exit.
     open     output FlightlogBackup-File AircraftBackup-File AirfieldBackup-File.
*>
 ZL010-Process-Flightlog.
     read     Flightlog-File next at end
              go to ZL020-Process-Aircraft.
     if       FS-Reply not = "00"
              go to ZL020-Process-Aircraft.
     write    FlightlogBackup-Record from Flightlog-Record.
     if       FS-Reply not = "00"
              display FL029 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZL040-Finish.
     go       to ZL010-Process-Flightlog.
*>
 ZL020-Process-Aircraft.
     read     Aircraft-File next at end
              go to ZL030-Process-Airfield.
     if       FS-Reply not = "00"
              go to ZL030-Process-Airfield.
     write    AircraftBackup-Record from Aircraft-Record.
     if       FS-Reply not = "00"
              display FL030 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZL040-Finish.
     go       to ZL020-Process-Aircraft.
*>
 ZL030-Process-Airfield.
     read     Airfield-File next at end
              go to ZL040-Finish.
     if       FS-Reply not = "00"
              go to ZL040-Finish.
     IF       icao-code not alphabetic go to ZL030-Process-Airfield.
     write    AirfieldBackup-Record from Airfield-Record.
     if       FS-Reply not = "00"
              display FL031 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZL040-Finish.
     go       to ZL030-Process-Airfield.
*>
 ZL040-Finish.
     close     FlightlogBackup-File AircraftBackup-File AirfieldBackup-File.
*>
 ZL999-Exit.  exit section.
*>
 ZM000-Recreate-Dat-Files section.
*>===============================
*>
*> Recreate Dat files from Seq files on
*>   change of compiler or platform
*>
     open     input  FlightlogBackup-File AircraftBackup-File AirfieldBackup-File.
     open     output Flightlog-File Aircraft-File Airfield-File.
*>
 ZM010-Process-Flightlog.
     read     FlightlogBackup-File next at end
              go to ZM020-Process-Aircraft.
     write    Flightlog-Record from FlightlogBackup-Record.
     if       FS-Reply not = "00"
              display FL032 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZM040-Finish.
     go       to ZM010-Process-Flightlog.
*>
 ZM020-Process-Aircraft.
     read     AircraftBackup-File next at end
              go to ZM030-Process-Airfield.
     write    Aircraft-Record from AircraftBackup-Record.
     if       FS-Reply not = "00"
              display FL033 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZM040-Finish.
     go       to ZM020-Process-Aircraft.
*>
 ZM030-Process-Airfield.
     read     AirfieldBackup-File next at end
              go to ZM040-Finish.
     IF       icao-code not alphabetic go to ZM030-Process-Airfield.
     write    Airfield-Record from AirfieldBackup-Record.
     if       FS-Reply not = "00"
              display FL034 at 1201 with erase eol
              display FL006 at 1301 with erase eol
              go to ZM040-Finish.
     go       to ZM030-Process-Airfield.
*>
 ZM040-Finish.
     close     FlightlogBackup-File AircraftBackup-File AirfieldBackup-File.
     close     Flightlog-File Aircraft-File Airfield-File.
*>
 ZM999-Exit.  exit section.
*>
 ZN000-SEARCH-FOR-ICAO SECTION.     *> Uses WS-ICAO-CODE
     MOVE     ZERO TO ERROR-CODE.
     SET      QQQ TO 1.
     SEARCH   WST-ICAO at end
              move zero to Error-Code
              WHEN WST-AIRFIELD (QQQ) = WS-ICAO-CODE
                   SET ERROR-CODE TO QQQ.
*>
 ZN999-EXIT.  EXIT.
*>
 ZP000-SAVE-AIRFIELDS  SECTION.
*>============================
*>
*> Used after statistic reporting when afld data is uptodate.
*>
     if       WST-Airfield-Size = zero
              go to ZP999-Exit.
     move     zero to Error-Code.
*>
 ZP020-Save-AFLD.
     add      1 to Error-Code.
     if       Error-Code > WST-Airfield-Size
              go to ZP999-Exit.
*>
     MOVE     WST-AIRFIELD  (Error-Code)  to  ICAO-CODE.
     IF       WST-AIRFIELD  (Error-Code) not alphabetic
              delete Airfield-File
              go to ZP020-Save-Afld.
     if       WST-AIRFIELD  (Error-Code) = high-values             *> If sorted could have junk
              go to ZP020-Save-Afld.                               *> within active table size limit
*>
     read     Airfield-File invalid KEY            *> Deleted in this run
              go to ZP020-Save-AFLD.
     if       WST-AFLD-Last-Flt (Error-Code) > AFLD-Last-Flt or = zero
              move     WST-AFLD-Last-Flt (Error-Code) to AFLD-Last-Flt
              rewrite  Airfield-Record.
*>
     GO       TO ZP020-Save-AFLD.
*>
 ZP999-EXIT.  exit section.
*>
 ZQ000-Convert-Date section.
*>=========================
*>
*>  Converts date from Accept DATE YYYYMMDD to UK/USA/Intl date format
*>   For print heads or data entry
*>
*> Input:   WSE-Date X(8) or WSE-Date9 9(8) but as yyyymmdd within WSE-Date-Block
*> output:  WSF-Date X(10) as UK/US/Intl date format or more as required.
*>
     if       WS-Local-Time-Zone = zero or > 3
              move 3 to WS-Local-Time-Zone.   *> Intl - ccyy/mm/dd - force if not set but it should be.
*>
     if       LTZ-UK
              move "dd/mm/ccyy" to WSF-Date
              move WSE-Year  to WSF-Date (7:4)
              move WSE-Month to WSF-Date (4:2)
              move WSE-Days  to WSF-Date (1:2)
     else
      if      LTZ-USA
              move "mm/dd/ccyy" to WSF-Date
              move WSE-Year  to WSF-Date (7:4)
              move WSE-Month to WSF-Date (1:2)
              move WSE-Days  to WSF-Date (4:2)
      else
       if     LTZ-Unix
              move "ccyy/mm/dd" to WSF-Date
              move WSE-Year  to WSF-Date (1:4)
              move WSE-Month to WSF-Date (6:2)
              move WSE-Days  to WSF-Date (9:2)
       else
              move "ZQ000 Bug" to WSF-Date.
*>
 ZQ999-Exit.  exit section.
*>
 ZZ050-Validate-Date        section.
*>*********************************
*>
*>  Converts UK/USA/Intl to INTL/Unix date format for testing
*>   as per setting for LOCATE.
*>
*> Input:   ws-test-date x(10)
*> output:  WS-Test-Intl as yyyymmdd
*>          u-bin = zero if valid date
*>
     move     ws-test-date to ws-date.
     if       WS-Local-Time-Zone = zero
              move 3 to WS-Local-Time-Zone.            *> Unix / Intl
     if       LTZ-UK
              move  ws-Year  to WS-Test-Intl (1:4)
              move  WS-Month to WS-Test-Intl (5:2)
              move  WS-Days  to WS-Test-Intl (7:2)
              go to zz050-test-date.
     if       LTZ-USA
              move  ws-Year      to WS-Test-Intl (1:4)
              move  WS-USA-Month to WS-Test-Intl (5:2)
              move  WS-USA-Days  to WS-Test-Intl (7:2)
              go to zz050-test-date.
*>
*> So its International date format : LTZ-Unix so just ignore the delimiters
*>
     move     ws-test-date9 (1:4) to ws-Test-Intl (1:4).
     move     ws-test-date9 (6:2) to ws-Test-Intl (5:2).
     move     ws-test-date9 (9:2) to ws-Test-Intl (7:2).
*>
 ZZ050-Test-Date.
     move     function TEST-DATE-YYYYMMDD (WS-Test-Intl) to U-Bin.  *> Non zero = error
*>
 ZZ050-Exit.
     exit     section.
*>
 ZZ060-Convert-Date        section.
*>********************************
*>
*> Converts date in Unix to UK/USA/Intl date format
*>  for display,printing or Data entry
*>*************************************************
*> Input:   WS-Test-Intl  9(8) yyyymmdd
*> output:  ws-date X(10) / WS-Test-Date (x(10) as UK/US/Inlt date format with '/'
*>          spaces if invalid.
*>
     if       WS-Test-Intl = zeroes
              move spaces to ws-Date WS-Test-Date
              go to ZZ060-Exit.
*>
     if       WS-Local-Time-Zone  = zero
              move 3 to WS-Local-Time-Zone.       *> force Unix if unset
     if       LTZ-UK
              move  "dd/mm/yyyy" to WS-Date
              move  WS-Test-Intl (1:4) to WS-Date (7:4)
              move  WS-Test-Intl (5:2) to WS-Date (4:2)
              move  WS-Test-Intl (7:2) to WS-Date (1:2)
              move  WS-Date to WS-Test-Date
              go to ZZ060-Exit.
     if       LTZ-USA
              move  "mm/dd/yyyy" to WS-Date
              move  WS-Test-Intl (1:4) to WS-Date (7:4)
              move  WS-Test-Intl (5:2) to WS-Date (1:2)
              move  WS-Test-Intl (7:2) to WS-Date (4:2)
              move  WS-Date to WS-Test-Date
              go to ZZ060-Exit.
*>
*> So its International date format
*>
     move     "ccyy/mm/dd" to WS-Date.
     move     WS-Test-Intl (1:4) to WS-Date (1:4).
     move     WS-Test-Intl (5:2) to WS-Date (6:2).
     move     WS-Test-Intl (7:2) to WS-Date (9:2).
     move     WS-Date to WS-Test-Date.
*>
 ZZ060-Exit.
     exit     section.
*>
 ZZA-FILE-STATUS      SECTION.
*>===========================
*>
*>  File Status Checking Routines using standard Cobol file status values only.
*>
     move     spaces to sys-message.
     evaluate s1
              when "0" go to ZZA999-exit
              when "1" go to zza999-exit
              when "2" perform zza020-check-inv-key-status
              when "3" perform zza030-check-perm-err-status
              when "4" perform zza040-look-up-error
              when "5" perform zza050-look-up-error
              when "6" perform zza060-look-up-error
              when "9" perform zza090-look-up-error
     end-evaluate.
     go       to zza998-display-message.
*>
 zza020-check-inv-key-status.
     evaluate s2
              when "1" move "Invalid key"           to sys-Message
              when "2" move "Writing dup key"       to sys-message
              when "3" move "No record found"       to sys-message
     end-evaluate.
*>
 zza030-check-perm-err-status.
     evaluate s2
              when "0" move "Permanent I/O error"   to sys-Message
              when "1" move "Inconsistent filename" to sys-Message
              when "4" move "Boundary violation"    to sys-Message
              when "5" move "File not found"        to sys-message
              when "7" move "Permission denied"     to sys-Message
              when "8" move "Closed with lock"      to sys-Message
              when "9" move "Conflicting attribute" to sys-Message
     end-evaluate.
*>
 zza040-look-up-error.
*>
*>    Look Up Error Number - below not needed for GnuCOBOL
*>
*>     move     low-values to s1.
*>     move     spaces to disply-stat.
*>     move     stat-bin to s2-displ.
     evaluate s2
              when "1" move "File already open"     to sys-message
              when "2" move "File not open"         to sys-message
              when "3" move "Read not done"         to sys-message
              when "4" move "Record overflow"       to sys-message
              when "6" move "Read error"            to sys-message
              when "7" move "Open Input Denied"     to sys-message
              when "8" move "Open Output Denied"    to sys-message
              when "9" move "Open I-O Denied"       to sys-message
     end-evaluate.
*>
 zza050-look-up-error.
     evaluate s2
              when "1" move "Record locked"         to sys-message
              when "2" move "End of page"           to sys-message
              when "7" move "Linage spec Invalid"   to sys-message
     end-evaluate.
*>
 zza060-look-up-error.
     evaluate s2
              when "1" move "File sharing failure"  to sys-message
     end-evaluate.
*>
 zza090-look-up-error.
     evaluate s2
              when "1" move "File not available"    to sys-message
     end-evaluate.
*>
 zza998-display-message.
     if       sys-message not = spaces
              display  sys-message at line ws-23-Lines col 41 with foreground-color COB-COLOR-RED
              display FL017 at line ws-Lines col 01
              accept ws-reply at line ws-Lines col 30
              display space at line ws-23-Lines col 01 with erase eos.
*>
 zza999-exit. exit section.
*>
