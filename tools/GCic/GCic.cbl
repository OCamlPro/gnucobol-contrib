      >>SOURCE FORMAT IS FIXED 
      *> CONFIGURATION SETTINGS: Set these switches before compiling:
      *>
      *> LINEDRAW Set to:
      *>    0   To use spaces (no lines)
      *>    1   To use the line-drawing characterset (PC codepage 437)
      *>    2   To use conventional ASCII characters (+, -, |)
      *>
      *>          OSX USERS - To use the linedrawing characterset,
      *>                      set your 'terminal' font to 'Lucida Console'
      *>
      *> OS       Set to one of the following:
      *>          'CYGWIN'   For a Windows/Cygwin version
      *>          'MINGW'    For a Windows/MinGW version
      *>          'OSX'      For a Macintosh OSX version
      *>          'UNIX'     For a Unix/Linux version
      *>          'WINDOWS'  For a Native Windows version
      *>
      *> SELCHAR  Set to the desired single character to be used as the red
      *>          'feature selected' character on the screen.
      *>          SUGGESTIONS: '>', '*', '=', '+'
      *>
      *> LPP      Set to maximum printable lines per page when the listing
      *>          should be generated for LANDSCAPE orientation (can be over-
      *>          ridden at execution time using the GCXREF_LINES environment
      *>          variable.
      *>
      *> LPPP     Set to maximum printable lines per page when the listing
      *>          should be generated for PORTRAIT orientation (can be over-
      *>          ridden at execution time using the GCXREF_LINES_PORT
      *>          environment variable.
      *>
GC0712 >>DEFINE CONSTANT LINEDRAW   AS 1
GC0712 >>DEFINE CONSTANT OS         AS 'MINGW'
GC0712 >>DEFINE CONSTANT SELCHAR    AS '>'
GC1213 >>DEFINE CONSTANT LPP        AS 60   *> LANDSCAPE (GCXREF_LINES)
GC1213 >>DEFINE CONSTANT LPPP       AS 54   *> PORTRAIT  (GCXREF_LINES_PORT)
      *> --------------------------------------------------------------
      *> Now set these switches to establish initial (default) settings
      *> for the various on-screen options.  Set them to a value of
      *> 0 if they are to be 'OFF' and 1 if they are to be 'ON'
GC1213*> (for F5, 1=ON (Landscape), 2=ON (Portrait))
      *>
GC0712 >>DEFINE CONSTANT F1  AS 0 *> Assume WITH DEBUGGING MODE
GC0712 >>DEFINE CONSTANT F2  AS 0 *> Procedure+Statement Trace
GC0712 >>DEFINE CONSTANT F3  AS 0 *> Make A Library (DLL)
GC0712 >>DEFINE CONSTANT F4  AS 0 *> Execute If Compilation OK
GC1213 >>DEFINE CONSTANT F5  AS 0 *> Listings
GC0712 >>DEFINE CONSTANT F6  AS 1 *> "FUNCTION" Is Optional
GC0712 >>DEFINE CONSTANT F7  AS 1 *> Enable All Warnings
GC0712 >>DEFINE CONSTANT F8  AS 0 *> Source Is Free-Format
GC0712 >>DEFINE CONSTANT F9  AS 1 *> No COMP/BINARY Truncation
GC0712 >>DEFINE CONSTANT F12 AS 4 *> Default config file (1-7):
      *>                             1 = BS2000
      *>                             2 = COBOL85
      *>                             3 = COBOL2002
      *>                             4 = DEFAULT
      *>                             5 = IBM
      *>                             6 = MF (i.e. Microfocus)
      *>                             7 = MVS
      *> --------------------------------------------------------------
      *> END CONFIGURATION SETTINGS
      /
       IDENTIFICATION DIVISION.
       PROGRAM-ID. GCic.
      *>***************************************************************
      *>     >NOTE<   >NOTE<   >NOTE<   >NOTE<   >NOTE<   >NOTE<     **
      *>                                                             **
      *> If this program is compiled with '-fdebugging-line', you    **
      *> will need to pipe SYSERR to a text file when executing GCic **
      *> (by adding the text '2> filename' to the end of the GCic    **
      *> command).  You may also need to press the ENTER key when    **
      *> GCic is finished.                                           **
      *>***************************************************************
      *> This program provides a Textual User Interface (TUI) to the **
      *> process of compiling and (optionally) executing a GNU COBOL **
      *> program.                                                    **
      *>                                                             **
      *> This programs execution syntax is as follows:               **
      *>                                                             **
      *> GCic <program-path-and-filename> [ <switch>... ]            **
      *>                                                             **
      *> Once executed, a display screen will be presented showing   **
      *> the compilation options that will be used.  The user will   **
      *> have the opportunity to change options, specify new ones    **
      *> and specify any program execution arguments to be used if   **
      *> you select the 'Execute' option.  When you press the Enter  **
      *> key the program will be compiled.                           **
      *>                                                             **
      *> The SCREEN SECTION contains an image of the screen.         **
      *>                                                             **
      *> The '010-Parse-Args' section in the PROCEDURE DIVISION has  **
      *> documentation on switches and their function.               **
      *>***************************************************************
      *>                                                             **
      *> AUTHOR:       GARY L. CUTLER                                **
      *>               Copyright (C) 2009-2014, Gary L. Cutler, GPL  **
      *>                                                             **
      *> DATE-WRITTEN: June 14, 2009                                 **
      *>                                                             **
      *>***************************************************************
      *>  DATE  CHANGE DESCRIPTION                                   **
      *> ====== ==================================================== **
      *> GC0609 Don't display compiler messages file if compilation  **
      *>        Is successful.  Also don't display messages if the   **
      *>        output file is busy (just put a message on the       **
      *>        screen, leave the OC screen up & let the user fix    **
      *>        the problem & resubmit.                              **
      *> GC0709 When 'EXECUTE' is selected, a 'FILE BUSY' error will **
      *>        still cause the (old) executable to be launched.     **
      *>        Also, the 'EXTRA SWITCHES' field is being ignored.   **
      *>        Changed the title bar to lowlighted reverse video &  **
      *>        the message area to highlighted reverse-video.       **
      *> GC0809 Add a SPACE in front of command-line args when       **
      *>        executing users program.  Add a SPACE after the      **
      *>        -ftraceall switch when building cobc command.        **
      *> GC0909 Convert to work on Cygwin/Linux as well as MinGW     **
      *> GC0310 Virtualized the key codes for S-F1 thru S-F7 as they **
      *>        differ depending upon whether PDCurses or NCurses is **
      *>        being used.                                          **
      *> GC0410 Introduced the cross-reference and source listing    **
      *>        features.  Also fixed a bug in EXTRA switch proces-  **
      *>        sing where garbage will result if more than the      **
      *>        EXTRA switch is specified.                           **
      *> GC1010 Corrected several problems reported by Vince Coen:   **
      *>        1) Listing/Xref wouldn't work if '-I' additional     **
      *>           cobc switch specified.                            **
      *>        2) Programs coded with lowercase reserved words did  **
      *>           not get parsed properly when generating listing   **
      *>           and/or xref reports.                              **
      *>        3) Reliance on a TEMP environment variable caused    **
      *>           non-recoverable errors when generating listing    **
      *>           and/or xref reports in a session that lacks a     **
      *>           TEMP variable.                                    **
      *>        As a result of this change, GCic no longer runs a    **
      *>        second 'cobc' when generating listing and/or xref    **
      *>        reports.  A '-save-temps' (without '=dir') specified **
      *>        in the EXTRA options field will be ignored.  A       **
      *>        '-save-temps=dir' specified in the EXTRA options     **
      *>        field will negate both the XREF and SOURCE opts,     **
      *>        if specified.                                        **
      *> GC0711 Tailored for 29APR2011 version of GNU COBOL 2.0      **
      *> GC0712 Replaced all switches with configuration settings;   **
      *>        Tailored for 11FEB2012 version of GNU COBOL 2.0;     **
      *>        Reformatted screen layout to fit a 24x80 screen      **
      *>        rather than a 25x81 screen and to accommodate shell  **
      *>        environments having only F1-F12 (like 'terminal' in  **
      *>        OSX); Fully tested under OSX (required a few altera- **
      *>        tions); Expanded both extra-options and runtime-     **
      *>        arguments areas to TWO lines (152 chars total) each; **
      *>        Added support for MF/IBM/BS2000 listing-control      **
      *>        directives EJECT,SKIP1,SKIP2,SKIP3 (any of these in  **
      *>        copybooks will be ignored)                           **
      *> GC0313 Expand the source code record from 80 chars to 256   **
      *>        to facilitate looking for "LINKAGE SECTION" in a     **
      *>        free-format file.                                    **
      *> GC1113 Edited to support the change of "OpenCOBOL" to "GNU  **
      *>        COBOL"                                               **
      *> GC1213 Updated for 23NOV2013 version of GNU COBOL 2.1       **
      *> GC0114 Introduce a "Press ENTER to Close" action after run- **
      *>        ning the compiled program in the compiler window (F4)**
      *>***************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
GC1010     SELECT F-Cobc-Output-FILE   ASSIGN TO WS-Listing-Filename-TXT
                                       ORGANIZATION IS LINE SEQUENTIAL.

           SELECT F-Source-Code-FILE   ASSIGN TO WS-File-Name-TXT
                                       ORGANIZATION IS LINE SEQUENTIAL
                                       FILE STATUS IS WS-FSM-Status-CD.
      /
       DATA DIVISION.
       FILE SECTION.
       FD  F-Cobc-Output-FILE.
       01  F-Cobc-Output-REC                     PIC X(256).

       FD  F-Source-Code-FILE.
GC0313 01  F-Source-Code-REC                     PIC X(256).

       WORKING-STORAGE SECTION.
       COPY screenio.

GC0712 01  WS-Compilation-Switches-TXT.
GC0712     05 WS-CS-Args-TXT VALUE SPACES.
GC0712        10 WS-CS-Arg-H1-TXT                PIC X(76).
GC0712        10 WS-CS-Arg-H2-TXT                PIC X(76).
GC0712     05 WS-CS-Filenames-TXT.
GC0712        10 VALUE 'BS2000'                  PIC X(9).
GC0712        10 VALUE 'COBOL85'                 PIC X(9).
GC0712        10 VALUE 'COBOL2002'               PIC X(9).
GC0712        10 VALUE 'DEFAULT'                 PIC X(9).
GC0712        10 VALUE 'IBM'                     PIC X(9).
GC0712        10 VALUE 'MF'                      PIC X(9).
GC0712        10 VALUE 'MVS'                     PIC X(9).
GC0712     05 WS-CS-Filenames-Table-TXT REDEFINES WS-CS-Filenames-TXT.
GC0712        10 WS-CS-Filename-TXT              OCCURS 7 TIMES
GC0712                                           PIC X(9).
GC0712 >>IF F12 < 1
GC0712     05 WS-CS-Config-NUM     VALUE 4       PIC 9(1).
GC0712 >>ELIF F12 > 7
GC0712     05 WS-CS-Config-NUM     VALUE 4       PIC 9(1).
GC0712 >>ELSE
GC0712     05 WS-CS-Config-NUM     VALUE F12     PIC 9(1).
GC0712 >>END-IF
GC0712     05 WS-CS-Extra-TXT VALUE SPACES.
GC0712        10 WS-CS-Extra-H1-TXT              PIC X(76).
GC0712        10 WS-CS-Extra-H2-TXT              PIC X(76).
GC0712     05 WS-CS-Switch-Defaults-TXT.
GC0712        10 VALUE F1                        PIC 9(1). *> WS-CS-DEBUG-CHR
GC0712        10 VALUE F4                        PIC 9(1). *> WS-CS-EXECUTE-CHR
GC0712        10 VALUE F8                        PIC 9(1). *> WS-CS-FREE-CHR
GC0712        10 VALUE F3                        PIC 9(1). *> WS-CS-LIBRARY-CHR
GC0712        10 VALUE F5                        PIC 9(1). *> WS-CS-LISTING-CHR
GC0712        10 VALUE F6                        PIC 9(1). *> WS-CS-NOFUNC-CHR
GC0712        10 VALUE F9                        PIC 9(1). *> WS-CS-NOTRUNC-CHR
GC0712        10 VALUE F2                        PIC 9(1). *> WS-CS-TRACEALL-CHR
GC0712        10 VALUE F7                        PIC 9(1). *> WS-CS-WARNALL-CHR
GC0712     05 WS-CS-All-Switches-TXT REDEFINES
GC0712                               WS-CS-Switch-Defaults-TXT.
GC0712        10 WS-CS-DEBUG-CHR                 PIC X(1).
GC0712        10 WS-CS-EXECUTE-CHR               PIC X(1).
GC0712        10 WS-CS-FREE-CHR                  PIC X(1).
GC0712        10 WS-CS-LIBRARY-CHR               PIC X(1).
GC0712        10 WS-CS-LISTING-CHR               PIC X(1).
GC0712        10 WS-CS-NOFUNC-CHR                PIC X(1).
GC0712        10 WS-CS-NOTRUNC-CHR               PIC X(1).
GC0712        10 WS-CS-TRACEALL-CHR              PIC X(1).
GC0712        10 WS-CS-WARNALL-CHR               PIC X(1).

GC0909 01  WS-Cmd-TXT                            PIC X(512).

GC0712 01  WS-Cmd-Args-TXT                       PIC X(256).

GC0712 01  WS-Cmd-End-Quote-CHR                  PIC X(1).

GC0712 01  WS-Cmd-SUB                            USAGE BINARY-LONG.

       01  WS-Cobc-Cmd-TXT                       PIC X(256).

       01  WS-Config-Fn-TXT                      PIC X(12).

GC1113 01  WS-Delete-Fn-TXT                      PIC X(256).

       01  WS-File-Name-TXT.
           05 WS-FN-CHR                          OCCURS 256 TIMES
                                                 PIC X(1).

       01  WS-File-Status-Message-TXT.
           05 VALUE 'Status Code: '              PIC X(13).
           05 WS-FSM-Status-CD                   PIC 9(2).
           05 VALUE ', Meaning: '                PIC X(11).
           05 WS-FSM-Msg-TXT                     PIC X(25).

GC0909 01  WS-Horizontal-Line-TXT                PIC X(80).
GC0909
       01  WS-I-SUB                              USAGE BINARY-LONG.

       01  WS-J-SUB                              USAGE BINARY-LONG.

GC1213 01  WS-Listing-CD VALUE F5                PIC 9(1).

GC0712 01  WS-Listing-Filename-TXT               PIC X(256).

GC1213 01  WS-Listing-TXT VALUE SPACES           PIC X(27).

       01  WS-OC-Compile-DT                      PIC XXXX/XX/XXBXX/XX.

GC0712 >>IF OS = 'CYGWIN'
GC0712 01  WS-OS-Dir-CHR         VALUE '/'       PIC X(1).
GC0712 78  WS-OS-Exe-Ext-CONST   VALUE '.exe'.
GC0712 78  WS-OS-Lib-Ext-CONST   VALUE '.dll'.
GC0712 78  WS-OS-Lib-Type-CONST  VALUE 'DLL)'.
GC0712 01  WS-OS-Type-CD         VALUE 2         PIC 9(1).
GC0712 >>ELIF OS = 'MINGW'
GC0712 01  WS-OS-Dir-CHR         VALUE '\'       PIC X(1).
GC0712 78  WS-OS-Exe-Ext-CONST   VALUE '.exe'.
GC0712 78  WS-OS-Lib-Ext-CONST   VALUE '.dll'.
GC0712 78  WS-OS-Lib-Type-CONST  VALUE 'DLL)'.
GC0712 01  WS-OS-Type-CD         VALUE 5         PIC 9(1).
GC0712 >>ELIF OS = 'OSX'
GC0712 01  WS-OS-Dir-CHR         VALUE '/'       PIC X(1).
GC0712 78  WS-OS-Exe-Ext-CONST   VALUE ' '.
GC0712 78  WS-OS-Lib-Ext-CONST   VALUE '.dylib'.
GC0712 78  WS-OS-Lib-Type-CONST  VALUE 'DYLIB)'.
GC0712 01  WS-OS-Type-CD         VALUE 4         PIC 9(1).
GC0712 >>ELIF OS = 'UNIX'
GC0712 01  WS-OS-Dir-CHR         VALUE '/'       PIC X(1).
GC0712 78  WS-OS-Exe-Ext-CONST   VALUE ' '.
GC0712 78  WS-OS-Lib-Ext-CONST   VALUE '.so'.
GC0712 78  WS-OS-Lib-Type-CONST  VALUE 'SO)'.
GC0712 01  WS-OS-Type-CD         VALUE 3         PIC 9(1).
GC0712 >>ELIF OS = 'WINDOWS'
GC0712 01  WS-OS-Dir-CHR         VALUE '\'       PIC X(1).
GC0712 78  WS-OS-Exe-Ext-CONST   VALUE '.exe'.
GC0712 78  WS-OS-Lib-Ext-CONST   VALUE '.dll'.
GC0712 78  WS-OS-Lib-Type-CONST  VALUE 'DLL)'.
GC0712 01  WS-OS-Type-CD         VALUE 1         PIC 9(1).
GC0712 >>END-IF
GC0909     88 WS-OS-Windows-BOOL VALUE 1, 5.
GC0909     88 WS-OS-Cygwin-BOOL  VALUE 2.
GC0712     88 WS-OS-UNIX-BOOL    VALUE 3, 4.
GC0712     88 WS-OS-OSX-BOOL     VALUE 4.

       01  WS-OS-Type-FILLER-TXT.
           05 VALUE 'Windows'                    PIC X(14).
           05 VALUE 'Windows/Cygwin'             PIC X(14).
           05 VALUE 'UNIX/Linux'                 PIC X(14).
           05 VALUE 'OSX'                        PIC X(14).
           05 VALUE 'Windows/MinGW'              PIC X(14).
       01  WS-OS-Types-TXT REDEFINES WS-OS-Type-FILLER-TXT.
           05 WS-OS-Type-TXT                     OCCURS 5 TIMES
                                                 PIC X(14).

       01  WS-Output-Msg-TXT                     PIC X(80).

       01  WS-Path-Delimiter-CHR                 PIC X(1).

       01  WS-Prog-Extension-TXT                 PIC X(256).

       01  WS-Prog-Folder-TXT                    PIC X(256).

GC0712 01  WS-Prog-File-Name-TXT.
GC0712     05 WS-PFN-CHR                         OCCURS 256 TIMES
GC0712                                           PIC X(1).

GC0712 01  WS-Pgm-Nm-TXT                         PIC X(31).

       01  WS-Runtime-Switches-TXT.
           05 WS-RS-Compile-OK-CHR               PIC X(1).
              88 WS-RS-Compile-OK-BOOL           VALUE 'Y'.
GC0909        88 WS-RS-Compile-OK-Warn-BOOL      VALUE 'W'.
              88 WS-RS-Compile-Failed-BOOL       VALUE 'N'.
GC0609     05 WS-RS-Complete-CHR                 PIC X(1).
GC0609        88 WS-RS-Complete-BOOL             VALUE 'Y'.
GC0609        88 WS-RS-Not-Complete-BOOL         VALUE 'N'.
GC0712     05 WS-RS-Quote-CHR                    PIC X(1).
GC0712        88 WS-RS-Double-Quote-Used-BOOL    VALUE 'Y' FALSE 'N'.
GC0809     05 WS-RS-IDENT-DIV-CHR                PIC X(1).
GC0809        88 WS-RS-1st-Prog-Complete-BOOL    VALUE 'Y'.
GC0809        88 WS-RS-More-To-1st-Prog-BOOL     VALUE 'N'.
           05 WS-RS-No-Switch-Chgs-CHR           PIC X(1).
              88 WS-RS-No-Switch-Changes-BOOL    VALUE 'Y'.
              88 WS-RS-Switch-Changes-BOOL       VALUE 'N'.
GC0709     05 WS-RS-Output-File-Busy-CHR         PIC X(1).
GC0709        88 WS-RS-Output-File-Busy-BOOL     VALUE 'Y'.
GC0709        88 WS-RS-Output-File-Avail-BOOL    VALUE 'N'.
GC0809     05 WS-RS-Source-Record-Type-CHR       PIC X(1).
GC0809        88 WS-RS-Source-Rec-Linkage-BOOL   VALUE 'L'.
GC0809        88 WS-RS-Source-Rec-Ident-BOOL     VALUE 'I'.
GC0712        88 WS-RS-Source-Rec-Ignored-BOOL   VALUE ' '.
           05 WS-RS-Switch-Error-CHR             PIC X(1).
              88 WS-RS-Switch-Is-Bad-BOOL        VALUE 'Y'.
              88 WS-RS-Switch-Is-Good-BOOL       VALUE 'N'.

       01  WS-Tally-QTY                          USAGE BINARY-LONG.
      /
       SCREEN SECTION.
      *>
      *> Here is the layout of the GCic screen.
      *>
      *> The sample screen below shows how the screen would look if the LINEDRAW
      *> configuration setting is set to a value of 2
      *>
      *> The following sample screen layout shows how the screen looks with line-drawing
      *> characters disabled.
      *>
      *>         1         2         3         4         5         6         7         8
      *>12345678901234567890123456789012345678901234567890123456789012345678901234567890
      *>================================================================================
   01 *> GCic (2011/07/11 08:52) - GNU COBOL V2.1 23NOV2013 Interactive Compilation
   02 *>+------------------------------------------------------------------------------+
   03 *>| Folder:   E:\GNU COBOL\Samples                                               |
   04 *>| Filename: GCic.cbl                                                           |
   05 *>+------------------------------------------------------------------------------+
   06 *> Set/Clr Switches Via F1-F9; Set Config Via F12; ENTER Key Compiles; ESC Quits
   07 *>+-----------------------------------------------------------------+------------+
   08 *>| F1  Assume WITH DEBUGGING MODE  F6  "FUNCTION" Is Optional      | Current    |
   09 *>| F2  Procedure+Statement Trace   F7  Enable All Warnings         | Config:    |
   10 *>| F3  Make A Library (DLL)        F8  Source Is Free-Format       | XXXXXXXXXX |
   11 *>| F4  Execute If Compilation OK   F9  No COMP/BINARY Truncation   |            |
   12 *>| F5 >Produce Listing (Landscape)                                 |            |
   13 *>+-----------------------------------------------------------------+------------+
   14 *> Extra "cobc" Switches, If Any ("-save-temps=xxx" Prevents Listings):
   15 *>+------------------------------------------------------------------------------+
   16 *>| ____________________________________________________________________________ |
   17 *>| ____________________________________________________________________________ |
   18 *>+------------------------------------------------------------------------------+
   19 *> Program Execution Arguments, If Any:
   20 *>+------------------------------------------------------------------------------+
   21 *>| ____________________________________________________________________________ |
   22 *>| ____________________________________________________________________________ |
   23 *>+------------------------------------------------------------------------------+
   24 *> GCic Copyright (C) 2009-2014, Gary L. Cutler, GPL
      *>================================================================================
      *>12345678901234567890123456789012345678901234567890123456789012345678901234567890
      *>         1         2         3         4         5         6         7         8
      *>
      *> If this program is run on Windows, it must run with codepage 437 activated to
      *> display the line-drawing characters.  With a native Windows build or a
      *> Windows/MinGW build, one could use the command 'chcp 437' to set that codepage
      *> for display within a Windows console window (that should be the default though).
      *> With a Windows/Cygwin build, set the environment variable CYGWIN to a value of
      *> 'codepage:oem' (this cannot be done from within the program though - you will
      *> have to use the 'Computer/Advanced System Settings/Environment Variables' (Vista
      *> or Windows 7) function to define the variable.  XP Users: use 'My Computer/
      *> Properties/Advanced/Environment Variables'.
      *>
      *> OSX users may use line drawing characters in this and any GNU COBOL program
      *> simply by setting their 'terminal' application's font to "Lucida Console".
      *>
       >>IF LINEDRAW IS EQUAL TO 0
       78 LD-UL-Corner                 VALUE ' '.
       78 LD-LL-Corner                 VALUE ' '.
       78 LD-UR-Corner                 VALUE ' '.
       78 LD-LR-Corner                 VALUE ' '.
       78 LD-Upper-T                   VALUE ' '.
       78 LD-Lower-T                   VALUE ' '.
       78 LD-Horiz-Line                VALUE ' '.
       78 LD-Vert-Line                 VALUE ' '.
       >>ELIF LINEDRAW IS EQUAL TO 1
       78 LD-UL-Corner                 VALUE X'DA'.
       78 LD-LL-Corner                 VALUE X'C0'.
       78 LD-UR-Corner                 VALUE X'BF'.
       78 LD-LR-Corner                 VALUE X'D9'.
       78 LD-Upper-T                   VALUE X'C2'.
       78 LD-Lower-T                   VALUE X'C1'.
       78 LD-Horiz-Line                VALUE X'C4'.
       78 LD-Vert-Line                 VALUE X'B3'.
       >>ELSE
       78 LD-UL-Corner                 VALUE '+'.
       78 LD-LL-Corner                 VALUE '+'.
       78 LD-UR-Corner                 VALUE '+'.
       78 LD-LR-Corner                 VALUE '+'.
       78 LD-Upper-T                   VALUE '+'.
       78 LD-Lower-T                   VALUE '+'.
       78 LD-Horiz-Line                VALUE '-'.
       78 LD-Vert-Line                 VALUE '|'.
       >>END-IF

       01 S-Blank-SCR LINE 1 COLUMN 1 BLANK SCREEN.
       
       01 S-Switches-SCR BACKGROUND-COLOR COB-COLOR-BLACK
                         FOREGROUND-COLOR COB-COLOR-WHITE AUTO.
      *>
      *> GENERAL SCREEN FRAMEWORK
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-GREEN HIGHLIGHT.
GC0712       05 LINE 02 COL 01           VALUE LD-UL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-UR-Corner.

GC0712       05 LINE 03 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 04 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 05 COL 01           VALUE LD-LL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-LR-Corner.

GC0712       05 LINE 07 COL 01           VALUE LD-UL-Corner.
GC0712       05         COL 02 PIC X(65) FROM  WS-Horizontal-Line-TXT.
GC0712       05         COL 67           VALUE LD-Upper-T.
GC0712       05         COL 68 PIC X(12) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-UR-Corner.

GC0712       05 LINE 08 COL 01           VALUE LD-Vert-Line.
GC0712       05         COL 67           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 09 COL 01           VALUE LD-Vert-Line.
GC0712       05         COL 67           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 10 COL 01           VALUE LD-Vert-Line.
GC0712       05         COL 67           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 11 COL 01           VALUE LD-Vert-Line.
GC0712       05         COL 67           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 12 COL 01           VALUE LD-Vert-Line.
GC0712       05         COL 67           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 13 COL 01           VALUE LD-LL-Corner.
GC0712       05         COL 02 PIC X(65) FROM  WS-Horizontal-Line-TXT.
GC0712       05         COL 67           VALUE LD-Lower-T.
GC0712       05         COL 68 PIC X(12) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-LR-Corner.

GC0712       05 LINE 15 COL 01           VALUE LD-UL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-UR-Corner.

GC0712       05 LINE 16 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 17 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 18 COL 01           VALUE LD-LL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-LR-Corner.

GC0712       05 LINE 20 COL 01           VALUE LD-UL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-UR-Corner.

GC0712       05 LINE 21 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 22 COL 01           VALUE LD-Vert-Line.
             05         COL 80           VALUE LD-Vert-Line.

GC0712       05 LINE 23 COL 01           VALUE LD-LL-Corner.
GC0712       05         COL 02 PIC X(78) FROM  WS-Horizontal-Line-TXT.
             05         COL 80           VALUE LD-LR-Corner.
      *>
      *> TOP AND BOTTOM LINES
      *>
GC0712    03 BACKGROUND-COLOR COB-COLOR-BLUE
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0410       05 LINE 01 COL 01 VALUE ' GCic ('.
GC0410       05         COL 08 PIC X(16) FROM WS-OC-Compile-DT.
GC1213       05         COL 24 VALUE ') GNU COBOL 2.1 23NOV2013 ' &
GC0410                               'Interactive Compilation        '.
GC0712    03 BACKGROUND-COLOR COB-COLOR-RED BLINK
GC0712       FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 24 COL 01 PIC X(80) FROM WS-Output-Msg-TXT.
      *>
      *> LABELS
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-CYAN  HIGHLIGHT.
GC0712       05 LINE 06 COL 02 VALUE 'Set/Clr Switches Via F1-F9; ' &
GC0712                               'Set Config Via F12; Enter Key ' &
GC0712                               'Compiles; Esc Quits'.
GC0712       05 LINE 14 COL 02 VALUE 'Extra "cobc" Switches, If Any ' &
GC0712                               '("-save-temps=xxx" Prevents ' &
GC0712                               'Listings):'.
GC0712       05 LINE 19 COL 02 VALUE 'Program Execution Arguments, ' &
GC0712                               'If Any:'.
GC0712    03 BACKGROUND-COLOR COB-COLOR-BLACK
GC0712       FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 06 COL 23 VALUE 'F1'.
GC0712       05         COL 26 VALUE 'F9'.
GC0712       05         COL 45 VALUE 'F12'.
GC0712       05         COL 50 VALUE 'ENTER'.
GC0712       05         COL 70 VALUE 'ESC'.
      *>
      *> TOP SECTION BACKGROUND
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 03 COL 62 VALUE 'Enter'.
GC0712       05 LINE 04 COL 62 VALUE 'Esc'.

          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-GREEN HIGHLIGHT.
GC0712       05 LINE 04 COL 03 VALUE 'Folder:   '.
GC0712       05 LINE 03 COL 03 VALUE 'Filename: '.

GC0712       05 LINE 03 COL 67 VALUE ': Compile   '.
GC0712       05 LINE 04 COL 65 VALUE ':   Quit      '.
      *>
      *> TOP SECTION PROGRAM INFO
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 03 COL 13 PIC X(66) FROM WS-Prog-File-Name-TXT.
GC0712       05 LINE 04 COL 13 PIC X(66) FROM WS-Prog-Folder-TXT.
      *>
      *> MIDDLE LEFT SECTION F-KEYS
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 08 COL 03 VALUE 'F1'.
GC0712       05 LINE 09 COL 03 VALUE 'F2'.
GC0712       05 LINE 10 COL 03 VALUE 'F3'.
GC0712       05 LINE 11 COL 03 VALUE 'F4'.
GC0712       05 LINE 12 COL 03 VALUE 'F5'.

GC0712       05 LINE 08 COL 35 VALUE 'F6'.
GC0712       05 LINE 09 COL 35 VALUE 'F7'.
GC0712       05 LINE 10 COL 35 VALUE 'F8'.
GC0712       05 LINE 11 COL 35 VALUE 'F9'.
      *>
      *> MIDDLE LEFT SECTION SWITCHES
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-RED   HIGHLIGHT.
GC0712       05 LINE 08 COL 06 PIC X(1) FROM WS-CS-DEBUG-CHR.
GC0712       05 LINE 09 COL 06 PIC X(1) FROM WS-CS-TRACEALL-CHR.
GC0712       05 LINE 10 COL 06 PIC X(1) FROM WS-CS-LIBRARY-CHR.
GC0712       05 LINE 11 COL 06 PIC X(1) FROM WS-CS-EXECUTE-CHR.
GC0712       05 LINE 12 COL 06 PIC X(1) FROM WS-CS-LISTING-CHR.

GC0712       05 LINE 08 COL 38 PIC X(1) FROM WS-CS-NOFUNC-CHR.
GC0712       05 LINE 09 COL 38 PIC X(1) FROM WS-CS-WARNALL-CHR.
GC0712       05 LINE 10 COL 38 PIC X(1) FROM WS-CS-FREE-CHR.
GC0712       05 LINE 11 COL 38 PIC X(1) FROM WS-CS-NOTRUNC-CHR.
      *>
      *> MIDDLE LEFT SECTION BACKGROUND
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-GREEN HIGHLIGHT.
GC0712       05 LINE 08 COL 07 VALUE 'Assume WITH DEBUGGING MODE'.
GC0712       05 LINE 09 COL 07 VALUE 'Procedure+Statement Trace '.
GC0712       05 LINE 10 COL 07 VALUE 'Make a Library ('.
GC0712       05         COL 23 VALUE WS-OS-Lib-Type-CONST.
GC0712       05 LINE 11 COL 07 VALUE 'Execute If Compilation OK '.
GC1213       05 LINE 12 COL 07 FROM  WS-Listing-TXT.

GC0712       05 LINE 08 COL 39 VALUE '"FUNCTION" Is Optional    '.
GC0712       05 LINE 09 COL 39 VALUE 'Enable All Warnings       '.
GC0712       05 LINE 10 COL 39 VALUE 'Source Is Free-Format     '.
GC0712       05 LINE 11 COL 39 VALUE 'No COMP/BINARY Truncation '.
      *>
      *> MIDDLE RIGHT SECTION Text
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-GREEN HIGHLIGHT.
GC0712       05 LINE 08 COL 69 VALUE 'Current'.
GC0712       05 LINE 09 COL 69 VALUE 'Config:'.
      *>
      *> MIDDLE RIGHT SECTION CONFIG FILE
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 10 COL 69 PIC X(10)
GC0712          FROM WS-CS-Filename-TXT (WS-CS-Config-NUM).
      *>
      *> FREE-FORM OPTIONS FIELDS
      *>
          03 BACKGROUND-COLOR COB-COLOR-BLACK
             FOREGROUND-COLOR COB-COLOR-WHITE HIGHLIGHT.
GC0712       05 LINE 16 COL 03 PIC X(76) USING WS-CS-Extra-H1-TXT.
GC0712       05 LINE 17 COL 03 PIC X(76) USING WS-CS-Extra-H2-TXT.
GC0712       05 LINE 21 COL 03 PIC X(76) USING WS-CS-Arg-H1-TXT.
GC0712       05 LINE 22 COL 03 PIC X(76) USING WS-CS-Arg-H2-TXT.
      /
       PROCEDURE DIVISION.
      *>***************************************************************
      *> Legend to procedure names:                                  **
      *>                                                             **
      *> 00x-xxx   All MAIN driver procedures                        **
      *> 0xx-xxx   All GLOBAL UTILITY procedures                     **
      *> 1xx-xxx   All INITIALIZATION procedures                     **
      *> 2xx-xxx   All CORE PROCESSING procedures                    **
      *> 9xx-xxx   All TERMINATION procedures                        **
      *>***************************************************************
       DECLARATIVES.
       000-File-Error SECTION.
           USE AFTER STANDARD ERROR PROCEDURE ON F-Source-Code-FILE.
           COPY FileStat-Msgs
               REPLACING STATUS BY WS-FSM-Status-CD
                         MSG    BY WS-FSM-Msg-TXT.
           MOVE SPACES TO WS-Output-Msg-TXT
           IF WS-FSM-Status-CD = 35
               DISPLAY
                   'File not found: "'
                   TRIM(WS-File-Name-TXT,TRAILING)
                   '"'
           ELSE
               DISPLAY
                   'Error accessing file: "'
                   TRIM(WS-File-Name-TXT,TRAILING)
                   '"'
           END-IF
           GOBACK
           .
       END DECLARATIVES.

       000-Main SECTION.
           PERFORM 100-Initialization
GC0609     SET WS-RS-Not-Complete-BOOL TO TRUE
GC0609     PERFORM UNTIL WS-RS-Complete-BOOL
GC0609         PERFORM 200-Let-User-Set-Switches
GC0609         PERFORM 210-Run-Compiler
GC0410         IF (WS-RS-Compile-OK-BOOL OR WS-RS-Compile-OK-Warn-BOOL)
GC0712         AND (WS-CS-LISTING-CHR > SPACE)
GC0712             DISPLAY S-Blank-SCR
GC0410             PERFORM 220-Make-Listing
GC0410         END-IF
GC0709         IF  (WS-CS-EXECUTE-CHR NOT = SPACES)
GC0709         AND (WS-RS-Output-File-Avail-BOOL)
GC0609             PERFORM 230-Run-Program
GC0609         END-IF
GC0712         PERFORM 250-Autoload-Listing
GC0609     END-PERFORM
           PERFORM 900-Terminate
      * -- Control will NOT return
           .
      /
      *>***************************************************************
      *> Perform all program-wide initialization operations          **
      *>***************************************************************
       100-Initialization SECTION.
      *>***************************************************************
      *> Make sure full screen-handling is in effect                 **
      *>***************************************************************
           SET ENVIRONMENT 'COB_SCREEN_EXCEPTIONS' TO 'Y'
           SET ENVIRONMENT 'COB_SCREEN_ESC'        TO 'Y'
      *>***************************************************************
      *> Get GCic Compilation Date/Time                              **
      *>***************************************************************
           MOVE WHEN-COMPILED (1:12) TO WS-OC-Compile-DT
           INSPECT WS-OC-Compile-DT
               REPLACING ALL '/' BY ':'
               AFTER INITIAL SPACE
      *>***************************************************************
      *> Convert WS-CS-All-Switches-TXT to Needed Alphanumeric Values**
      *>***************************************************************
           INSPECT WS-CS-All-Switches-TXT
               REPLACING ALL '0' BY SPACE
                         ALL '1' BY SELCHAR
GC1213                   ALL '2' BY SELCHAR
      *>***************************************************************
      *> Process filename (the only command-line argument)           **
      *>***************************************************************
GC0712     ACCEPT WS-Cmd-Args-TXT FROM COMMAND-LINE
GC0712     MOVE 1 TO WS-Cmd-SUB
GC0712     IF WS-Cmd-Args-TXT(WS-Cmd-SUB:1) = '"' OR "'"
GC0712         MOVE WS-Cmd-Args-TXT(WS-Cmd-SUB:1)
GC0712           TO WS-Cmd-End-Quote-CHR
GC0712         ADD 1 TO WS-Cmd-SUB
GC0712         UNSTRING WS-Cmd-Args-TXT
GC0712             DELIMITED BY WS-Cmd-End-Quote-CHR
GC0712             INTO WS-File-Name-TXT
GC0712             WITH POINTER WS-Cmd-SUB
GC0712     ELSE
GC0712         UNSTRING WS-Cmd-Args-TXT
GC0712             DELIMITED BY ALL SPACES
GC0712             INTO WS-File-Name-TXT
GC0712             WITH POINTER WS-Cmd-SUB
GC0712     END-IF
           IF WS-File-Name-TXT = SPACES
GC0712         DISPLAY 'No program filename was specified'
               PERFORM 900-Terminate
      * ------ Control will NOT return
           END-IF
      *>***************************************************************
      *> Determine if 'Make A Library' feature should be forced 'ON' **
      *>***************************************************************
           PERFORM 240-Find-LINKAGE-SECTION
      *>***************************************************************
      *> Split 'WS-File-Name-TXT' into 'WS-Prog-Folder-TXT' and      **
      *> 'WS-Prog-File-Name-TXT'                                     **
      *>***************************************************************
GC0909     IF WS-OS-Cygwin-BOOL AND WS-File-Name-TXT (2:1) = ':'
GC0712         MOVE '\' TO WS-OS-Dir-CHR
GC0909     END-IF
GC0712     MOVE LENGTH(WS-File-Name-TXT) TO WS-I-SUB
GC0712     PERFORM UNTIL WS-I-SUB = 0
GC0712     OR WS-FN-CHR (WS-I-SUB) = WS-OS-Dir-CHR
               SUBTRACT 1 FROM WS-I-SUB
           END-PERFORM
           IF WS-I-SUB = 0
               MOVE SPACES    TO WS-Prog-Folder-TXT
               MOVE WS-File-Name-TXT TO WS-Prog-File-Name-TXT
           ELSE
               MOVE '*' TO WS-FN-CHR (WS-I-SUB)
               UNSTRING WS-File-Name-TXT DELIMITED BY '*'
                   INTO WS-Prog-Folder-TXT
                        WS-Prog-File-Name-TXT
GC0712         MOVE WS-OS-Dir-CHR TO WS-FN-CHR (WS-I-SUB)
           END-IF
           IF WS-Prog-Folder-TXT = SPACES
               ACCEPT WS-Prog-Folder-TXT FROM ENVIRONMENT 'CD'
GC0909     ELSE
GC0909         CALL 'CBL_CHANGE_DIR'
GC0909             USING TRIM(WS-Prog-Folder-TXT,TRAILING)
           END-IF
GC0909     IF WS-OS-Cygwin-BOOL AND WS-File-Name-TXT (2:1) = ':'
GC0712         MOVE '/' TO WS-OS-Dir-CHR
GC0909     END-IF
      *>***************************************************************
      *> Split 'WS-Prog-File-Name-TXT' into 'WS-Pgm-Nm-TXT' &        **
      *> 'WS-Prog-Extension-TXT'                                     **
      *>***************************************************************
GC0712     MOVE LENGTH(WS-Prog-File-Name-TXT) TO WS-I-SUB
GC0712     PERFORM UNTIL WS-I-SUB = 0
GC0712     OR WS-PFN-CHR (WS-I-SUB) = '.'
GC0712         SUBTRACT 1 FROM WS-I-SUB
GC0712     END-PERFORM
GC0712     IF WS-I-SUB = 0
GC0712         MOVE WS-Prog-File-Name-TXT TO WS-Pgm-Nm-TXT
GC0712         MOVE SPACES         TO WS-Prog-Extension-TXT
GC0712     ELSE
GC0712         MOVE '*' TO WS-PFN-CHR (WS-I-SUB)
GC0712         UNSTRING WS-Prog-File-Name-TXT DELIMITED BY '*'
GC0712             INTO WS-Pgm-Nm-TXT
GC0712                  WS-Prog-Extension-TXT
GC0712         MOVE '.' TO WS-PFN-CHR (WS-I-SUB)
GC0712     END-IF
      *>***************************************************************
      *> Build initial Line 24 Message                               **
      *>***************************************************************
GC0909     MOVE ALL LD-Horiz-Line TO WS-Horizontal-Line-TXT.
GC0410     MOVE CONCATENATE(' GCic for '
GC0410                      TRIM(WS-OS-Type-TXT(WS-OS-Type-CD),Trailing)
GC1213                      ' Copyright (C) 2009-2014, Gary L. '
GC0410                      'Cutler, GPL')
GC0410       TO WS-Output-Msg-TXT.
GC0909     .
      /
      *>***************************************************************
      *> Show the user the current switch settings and allow them to **
      *> be changed.                                                 **
      *>***************************************************************
       200-Let-User-Set-Switches SECTION.
           SET WS-RS-Switch-Changes-BOOL TO TRUE
           PERFORM UNTIL WS-RS-No-Switch-Changes-BOOL
GC1213         EVALUATE WS-Listing-CD
GC1213         WHEN 0
GC1213             MOVE 'Listing Off'            TO WS-Listing-TXT
GC1213             MOVE SPACE                    TO WS-CS-LISTING-CHR
GC1213         WHEN 1
GC1213             MOVE 'Listing On (Landscape)' TO WS-Listing-TXT
GC1213             MOVE SELCHAR                  TO WS-CS-LISTING-CHR
GC1213         WHEN 2
GC1213             MOVE 'Listing On (Portrait)' TO WS-Listing-TXT
GC1213             MOVE SELCHAR                  TO WS-CS-LISTING-CHR
GC1213         END-EVALUATE
               ACCEPT S-Switches-SCR
               IF COB-CRT-STATUS > 0
                   EVALUATE COB-CRT-STATUS
                       WHEN COB-SCR-F1
                           IF WS-CS-DEBUG-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-DEBUG-CHR
                           ELSE
                               MOVE ' ' TO WS-CS-DEBUG-CHR
                           END-IF
GC0712                 WHEN COB-SCR-F2
GC0712                     IF  WS-CS-TRACEALL-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-TRACEALL-CHR
GC0712                     ELSE
GC0712                         MOVE ' ' TO WS-CS-TRACEALL-CHR
GC0712                     END-IF
                       WHEN COB-SCR-F3
GC0712                     IF WS-CS-LIBRARY-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-LIBRARY-CHR
                           ELSE
GC0712                         MOVE ' ' TO WS-CS-LIBRARY-CHR
                           END-IF
                       WHEN COB-SCR-F4
                           IF  WS-CS-EXECUTE-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-EXECUTE-CHR
                           ELSE
                               MOVE ' ' TO WS-CS-EXECUTE-CHR
                           END-IF
GC0712                 WHEN COB-SCR-F5
GC1213                     ADD 1 TO WS-Listing-CD
GC1213                     IF WS-Listing-CD > 2
GC1213                         MOVE 0 TO WS-Listing-CD
GC1213                     END-IF
GC0712                 WHEN COB-SCR-F6
GC0712                     IF WS-CS-NOFUNC-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-NOFUNC-CHR
GC0712                     ELSE
GC0712                         MOVE ' ' TO WS-CS-NOFUNC-CHR
GC0712                     END-IF
GC0712                 WHEN COB-SCR-F7
GC0712                     IF WS-CS-WARNALL-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-WARNALL-CHR
GC0712                     ELSE
GC0712                         MOVE ' ' TO WS-CS-WARNALL-CHR
GC0712                     END-IF
GC0712                 WHEN COB-SCR-F8
GC0712                     IF WS-CS-FREE-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-FREE-CHR
GC0712                     ELSE
GC0712                         MOVE ' ' TO WS-CS-FREE-CHR
GC0712                     END-IF
GC0712                 WHEN COB-SCR-F9
GC0712                     IF  WS-CS-NOTRUNC-CHR = SPACE
GC0712                         MOVE SELCHAR TO WS-CS-NOTRUNC-CHR
GC0712                     ELSE
GC0712                         MOVE ' ' TO WS-CS-NOTRUNC-CHR
GC0712                     END-IF
                       WHEN COB-SCR-ESC
                           PERFORM 900-Terminate
      * ------------------ Control will NOT return
GC0712                 WHEN COB-SCR-F12
GC0712                     ADD 1 TO WS-CS-Config-NUM
GC0712                     IF WS-CS-Config-NUM > 7
GC0712                         MOVE 1 TO WS-CS-Config-NUM
GC0712                     END-IF
                       WHEN OTHER
                           MOVE 'An unsupported key was pressed'
                             TO WS-Output-Msg-TXT
                   END-EVALUATE
               ELSE
                   SET WS-RS-No-Switch-Changes-BOOL TO TRUE
               END-IF
           END-PERFORM
           .
      /
      *>***************************************************************
      *> Run the compiler using the switch settings we've prepared.  **
      *>***************************************************************
       210-Run-Compiler SECTION.
           MOVE SPACES TO WS-Cmd-TXT
                          WS-Cobc-Cmd-TXT
                          WS-Output-Msg-TXT
           DISPLAY S-Switches-SCR
           MOVE 1 TO WS-I-SUB
GC0712     MOVE LOWER-CASE(WS-CS-Filename-TXT (WS-CS-Config-NUM))
GC0712       TO WS-Config-Fn-TXT
      *>***************************************************************
      *> Build the 'cobc' command                                    **
      *>***************************************************************
GC0909     MOVE SPACES TO WS-Cobc-Cmd-TXT
GC0909     STRING 'cobc -v -std='
GC0909         TRIM(WS-Config-Fn-TXT,TRAILING)
GC0909         ' '
GC0909         INTO WS-Cobc-Cmd-TXT
GC0909         WITH POINTER WS-I-SUB
           IF WS-CS-LIBRARY-CHR NOT = ' '
               STRING '-m '
                   DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
                   WITH POINTER WS-I-SUB
           ELSE
               STRING '-x '
                   DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
                   WITH POINTER WS-I-SUB
           END-IF
           IF WS-CS-DEBUG-CHR NOT = ' '
               STRING '-fdebugging-line '
                   DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
                   WITH POINTER WS-I-SUB
           END-IF
           IF WS-CS-NOTRUNC-CHR NOT = ' '
               STRING '-fnotrunc '
                   DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
                   WITH POINTER WS-I-SUB
           END-IF
           IF WS-CS-TRACEALL-CHR NOT = ' '
GC0809         STRING '-ftraceall '
                   DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
                   WITH POINTER WS-I-SUB
           END-IF
GC0712     IF WS-CS-NOFUNC-CHR NOT = ' '
GC0712         STRING '-fintrinsic=all '
GC0712             DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0712             WITH POINTER WS-I-SUB
GC0712     END-IF
GC0712     IF WS-CS-WARNALL-CHR NOT = ' '
GC0712         STRING '-Wall '
GC0712             DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0712             WITH POINTER WS-I-SUB
GC0712     END-IF
GC0712     IF WS-CS-FREE-CHR NOT = ' '
GC0712         STRING '-free '
GC0712             DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0712             WITH POINTER WS-I-SUB
GC0712     ELSE
GC0712         STRING '-fixed '
GC0712             DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0712             WITH POINTER WS-I-SUB
GC0712     END-IF

GC0712     MOVE 0 TO WS-Tally-QTY
GC0712     INSPECT WS-CS-Extra-TXT
GC0712         TALLYING WS-Tally-QTY FOR ALL '-save-temps'
GC0712     IF WS-CS-LISTING-CHR > SPACE
GC0712     AND WS-Tally-QTY > 0
GC0712         MOVE SPACE TO WS-CS-LISTING-CHR *> Can't generate listing if -save-temps used
GC0712     END-IF
GC0712     IF WS-CS-LISTING-CHR > SPACE
GC1010         STRING '-save-temps '
GC1010             DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC1010             WITH POINTER WS-I-SUB
GC1010     END-IF

GC0709     IF WS-CS-Extra-TXT > SPACES
GC0709         STRING ' '
GC0709                TRIM(WS-CS-Extra-TXT,TRAILING)
GC0709                ' '
GC0709                DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0709                WITH POINTER WS-I-SUB
GC0709     END-IF
GC0909     STRING TRIM(WS-Prog-File-Name-TXT,TRAILING)
GC0909         DELIMITED SIZE INTO WS-Cobc-Cmd-TXT
GC0909         WITH POINTER WS-I-SUB
      *>***************************************************************
      *> Prepare the compilation listing file                        **
      *>***************************************************************
GC1113     MOVE CONCATENATE(TRIM(WS-Pgm-Nm-TXT,Trailing),'.gclst')
GC0712       TO WS-Listing-Filename-TXT
GC0712     CALL 'CBL_DELETE_FILE' USING WS-Listing-Filename-TXT
      *>***************************************************************
      *> Now execute the 'cobc' command                              **
      *>***************************************************************
GC0410     MOVE ' Compiling...' TO WS-Output-Msg-TXT
GC0410     DISPLAY S-Switches-SCR
GC0609     SET WS-RS-Output-File-Avail-BOOL TO TRUE
           MOVE SPACES TO WS-Cmd-TXT
           STRING TRIM(WS-Cobc-Cmd-TXT,TRAILING)
GC0712            ' >' WS-Listing-Filename-TXT
GC0712            ' 2>&1'
                  DELIMITED SIZE
                  INTO WS-Cmd-TXT
DEBUG D    DISPLAY WS-Cmd-TXT UPON SYSERR
           CALL 'SYSTEM' USING TRIM(WS-Cmd-TXT,TRAILING)
GC0712     OPEN EXTEND F-Cobc-Output-FILE
GC0712     WRITE F-Cobc-Output-REC FROM SPACES
GC0712     IF RETURN-CODE = 0
GC0712         SET WS-RS-Compile-OK-BOOL TO TRUE
GC0712         MOVE ' Compilation Was Successful' TO WS-Output-Msg-TXT
GC0712         MOVE CONCATENATE('GNU COBOL',WS-Output-Msg-TXT)
GC0712           TO F-Cobc-Output-REC
GC0712         WRITE F-Cobc-Output-REC
GC0712         SET WS-RS-Complete-BOOL TO TRUE
GC0712     ELSE
GC0712         SET WS-RS-Compile-Failed-BOOL TO TRUE
GC0712         MOVE CONCATENATE(' Compilation Failed - See ',
GC0712                     TRIM(WS-Listing-Filename-TXT,Trailing))
GC0712           TO WS-Output-Msg-TXT
GC0712         MOVE 'GNU COBOL Compilation HAS FAILED - See Above'
GC0712           TO F-Cobc-Output-REC
GC0712         WRITE F-Cobc-Output-REC
GC0712     END-IF
GC0712     CLOSE F-Cobc-Output-FILE
GC0712     DISPLAY S-Switches-SCR
GC0712     CALL 'C$SLEEP' USING 2
GC0712     MOVE SPACES TO WS-Output-Msg-TXT
           IF WS-RS-Compile-Failed-BOOL
GC0712         PERFORM 250-Autoload-Listing
               PERFORM 900-Terminate
      *> ----- Control will not return
           END-IF
           .
      /
      *>***************************************************************
      *> Generate a source + xref listing using 'LISTING' subroutine **
      *>***************************************************************
GC0410 220-Make-Listing SECTION.
GC0410     MOVE ' Generating listing...' TO WS-Output-Msg-TXT
GC0410     DISPLAY S-Switches-SCR
GC0410     MOVE 0 TO RETURN-CODE
      *>***************************************************************
      *> Create the listing                                          **
      *>***************************************************************
GC0410     MOVE SPACES TO WS-Output-Msg-TXT
GC0410     CALL 'LISTING' USING WS-Listing-Filename-TXT
GC0712                          WS-File-Name-TXT
GC0712                          WS-OS-Type-CD
GC1213                          LPP
GC1213                          LPPP
GC1213                          WS-Listing-CD
GC0410     ON EXCEPTION
GC0410         MOVE ' LISTING module is not available'
GC0410           TO WS-Output-Msg-TXT
GC0410         MOVE 1 TO RETURN-CODE
GC0410     END-CALL
GC0410     IF RETURN-CODE = 0
GC0712         MOVE ' Source+Xref listing generated '
GC0712           TO WS-Output-Msg-TXT
GC0410     END-IF
GC0712     DISPLAY S-Switches-SCR
GC0712     CALL 'C$SLEEP' USING 2
GC0712     PERFORM 250-Autoload-Listing
GC0410     .
      /
      *>***************************************************************
      *> Run the compiled program                                    **
      *>***************************************************************
       230-Run-Program SECTION.
GC0114     MOVE ' Preparing to run program ... press ENTER to close '
GC0114       TO WS-Output-Msg-TXT
GC0114     DISPLAY S-Switches-SCR
GC0114     CALL 'C$SLEEP' USING 3
GC0909     MOVE SPACES TO WS-Cmd-TXT
GC0909     MOVE 1 TO WS-I-SUB
      *>***************************************************************
      *> If necessary, start with 'cobcrun' command                  **
      *>***************************************************************
GC0712     IF WS-CS-LIBRARY-CHR NOT = ' '
               STRING 'cobcrun ' DELIMITED SIZE
                      INTO WS-Cmd-TXT
                      WITH POINTER WS-I-SUB
           END-IF
      *>***************************************************************
      *> Add any necessary path prefix                               **
      *>***************************************************************
GC0712     SET WS-RS-Double-Quote-Used-BOOL TO FALSE
           IF WS-Prog-Folder-TXT NOT = SPACES
GC0909         IF WS-OS-Cygwin-BOOL AND WS-Prog-Folder-TXT (2:1) = ':'
GC0909             STRING '/cygdrive/'
GC0909                 INTO WS-Cmd-TXT
GC0909                 WITH POINTER WS-I-SUB
GC0909             STRING LOWER-CASE(WS-Prog-Folder-TXT (1:1))
GC0909                 INTO WS-Cmd-TXT
GC0909                 WITH POINTER WS-I-SUB
GC0909             PERFORM
GC0909                 VARYING WS-J-SUB FROM 3 BY 1
GC0909                 UNTIL WS-J-SUB > LENGTH(TRIM(WS-Prog-Folder-TXT))
GC0909                 IF WS-Prog-Folder-TXT (WS-J-SUB:1) = '\'
GC0909                     STRING '/'
GC0909                         INTO WS-Cmd-TXT
GC0909                         WITH POINTER WS-I-SUB
GC0909                 ELSE
GC0909                     STRING WS-Prog-Folder-TXT (WS-J-SUB:1)
GC0909                         INTO WS-Cmd-TXT
GC0909                         WITH POINTER WS-I-SUB
GC0909                 END-IF
GC0909             END-PERFORM
GC0909         ELSE
GC0410             STRING '"' TRIM(WS-Prog-Folder-TXT,TRAILING)
GC0909                 INTO WS-Cmd-TXT
GC0909                 WITH POINTER WS-I-SUB
GC0712             SET WS-RS-Double-Quote-Used-BOOL TO TRUE
GC0909         END-IF
GC0712         STRING WS-OS-Dir-CHR
GC0909             INTO WS-Cmd-TXT
GC0909             WITH POINTER WS-I-SUB
GC0909     ELSE
GC0909         IF WS-OS-Cygwin-BOOL OR WS-OS-UNIX-BOOL
GC0909             STRING './'
GC0909                 INTO WS-Cmd-TXT
GC0909                 WITH POINTER WS-I-SUB
GC0909         END-IF
           END-IF
      *>***************************************************************
      *> Insert program filename                                     **
      *>***************************************************************
GC0909     STRING TRIM(WS-Pgm-Nm-TXT,TRAILING)
GC0909         INTO WS-Cmd-TXT
GC0909         WITH POINTER WS-I-SUB
      *>***************************************************************
      *> Insert proper extension                                     **
      *>***************************************************************
GC0712     IF WS-CS-LIBRARY-CHR = ' '
GC0712         IF WS-OS-Exe-Ext-CONST > ' '
GC0712             STRING WS-OS-Exe-Ext-CONST DELIMITED SPACE
GC0712                 INTO WS-Cmd-TXT
GC0712                 WITH POINTER WS-I-SUB
GC0712         END-IF
GC0712     ELSE
GC0712         IF WS-OS-Lib-Ext-CONST > ' '
GC0712             STRING WS-OS-Lib-Ext-CONST DELIMITED SPACE
GC0712                 INTO WS-Cmd-TXT
GC0712                 WITH POINTER WS-I-SUB
GC0712         END-IF
GC0712     END-IF
GC0712     IF WS-RS-Double-Quote-Used-BOOL
GC0712         STRING '"' DELIMITED SIZE
GC0712             INTO WS-Cmd-TXT
GC0712             WITH POINTER WS-I-SUB
GC0712     END-IF
           IF WS-CS-Args-TXT NOT = SPACES
GC0809         STRING ' ' TRIM(WS-CS-Args-TXT,TRAILING)
                   INTO WS-Cmd-TXT
                   WITH POINTER WS-I-SUB
           END-IF
      *>***************************************************************
      *> Run the program                                             **
      *>***************************************************************
GC0114     CALL X'E4'
           CALL 'SYSTEM' USING TRIM(WS-Cmd-TXT,TRAILING)
GC0712     MOVE SPACES TO WS-Output-Msg-TXT
GC0114     ACCEPT WS-Output-Msg-TXT(1:1) AT 0101
           PERFORM 900-Terminate
      * -- Control will NOT return
           .
      /
      *>***************************************************************
      *> Determine if the program being compiled is a MAIN program   **
      *>***************************************************************
       240-Find-LINKAGE-SECTION SECTION.
           OPEN INPUT F-Source-Code-FILE
GC0712     MOVE ' ' TO WS-CS-LIBRARY-CHR
           SET WS-RS-More-To-1st-Prog-BOOL   TO TRUE
           PERFORM UNTIL WS-RS-1st-Prog-Complete-BOOL
               READ F-Source-Code-FILE AT END
                   CLOSE F-Source-Code-FILE
                   EXIT SECTION
               END-READ
GC0712         CALL 'CHECKSRC'
GC0712             USING BY CONTENT   F-Source-Code-REC
GC0712                   BY REFERENCE WS-RS-Source-Record-Type-CHR
               IF WS-RS-Source-Rec-Ident-BOOL
                   SET WS-RS-1st-Prog-Complete-BOOL TO TRUE
               END-IF
           END-PERFORM
GC0712     SET WS-RS-Source-Rec-Ignored-BOOL TO TRUE
           PERFORM UNTIL WS-RS-Source-Rec-Linkage-BOOL
                      OR WS-RS-Source-Rec-Ident-BOOL
               READ F-Source-Code-FILE AT END
                   CLOSE F-Source-Code-FILE
                   EXIT SECTION
               END-READ
GC0712         CALL 'CHECKSRC'
GC0712             USING BY CONTENT   F-Source-Code-REC
GC0712                   BY REFERENCE WS-RS-Source-Record-Type-CHR
           END-PERFORM
           CLOSE F-Source-Code-FILE
           IF WS-RS-Source-Rec-Linkage-BOOL
GC0712         MOVE SELCHAR TO WS-CS-LIBRARY-CHR
           END-IF
           .
      /
GC0712*>***************************************************************
GC0712*> Attempt to open the listing file as a command.  This will - **
GC1113*> if the user has associated filetype/extension 'gclst' with  **
GC0712*> an application - invoke the appropriate application to      **
GC0712*> allow the user to view the listing.                         **
GC0712*>***************************************************************'
GC0712 250-Autoload-Listing SECTION.
GC0712     EVALUATE TRUE
GC0712         WHEN WS-OS-Windows-BOOL OR WS-OS-Cygwin-BOOL
GC0712             MOVE SPACES TO WS-Cmd-TXT
GC0712             STRING
GC0712                 'cmd /c '
GC0712                 TRIM(WS-Listing-Filename-TXT,TRAILING)
GC0712                 DELIMITED SIZE INTO WS-Cmd-TXT
GC0712             CALL 'SYSTEM' USING TRIM(WS-Cmd-TXT,TRAILING)
GC0712         WHEN WS-OS-OSX-BOOL
GC0712             MOVE SPACES TO WS-Cmd-TXT
GC0712             STRING
GC0712                 'open -t '
GC0712                 TRIM(WS-Listing-Filename-TXT,TRAILING)
GC0712                 DELIMITED SIZE INTO WS-Cmd-TXT
GC0712             CALL 'SYSTEM' USING TRIM(WS-Cmd-TXT,TRAILING)
GC0712     END-EVALUATE
GC0712*>   ************************************************************
GC0712*>   ** Since we had to do our own '-save-temps' when we       **
GC0712*>   ** compiled (in order to generate the cross-reference     **
GC0712*>   ** listing) we now need to clean up after ourselves.      **
GC0712*>   ************************************************************
GC1112     DISPLAY S-Blank-SCR
GC0712     IF WS-OS-Windows-BOOL
GC0712         MOVE CONCATENATE('del ',TRIM(WS-Pgm-Nm-TXT,TRAILING))
GC0712           TO WS-Cmd-TXT
GC0712     ELSE
GC0712         MOVE CONCATENATE('rm ',TRIM(WS-Pgm-Nm-TXT,TRAILING))
GC0712           TO WS-Cmd-TXT
GC0712     END-IF
GC0712     CALL 'SYSTEM'
GC0712         USING CONCATENATE(TRIM(WS-Cmd-TXT,TRAILING),'.c')
GC0712     CALL 'SYSTEM'
GC0712         USING CONCATENATE(TRIM(WS-Cmd-TXT,TRAILING),'.c.h')
GC0712     CALL 'SYSTEM'
GC0712         USING CONCATENATE(TRIM(WS-Cmd-TXT,TRAILING),'.c.l*.h')
GC0712     CALL 'SYSTEM'
GC0712         USING CONCATENATE(TRIM(WS-Cmd-TXT,TRAILING),'.i')
GC0712     CALL 'SYSTEM'
GC0712         USING CONCATENATE(TRIM(WS-Cmd-TXT,TRAILING),'.o')

GC0712     .
      /
      *>***************************************************************
      *> Display a message and halt the program                      **
      *>***************************************************************
       900-Terminate SECTION.
GC0909     IF WS-Output-Msg-TXT > SPACES
GC0909         DISPLAY S-Switches-SCR
GC0909         CALL 'C$SLEEP' USING 2
GC0909     END-IF
           DISPLAY S-Blank-SCR
           STOP RUN
           .

       END PROGRAM GCic.
      /
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  CHECKSRC.
      *>***************************************************************
      *> This subprogram will scan a line of source code it is given **
      *> looking for 'LINKAGE SECTION' or 'IDENTIFICATION DIVISION'. **
      *>                                                             **
      *>  ****NOTE****   ****NOTE****    ****NOTE****   ****NOTE***  **
      *>                                                             **
      *> These two strings must be found IN THEIR ENTIRETY within    **
      *> the 1st 80 columns of program source records, and cannot    **
      *> follow either a '*>' sequence OR a '*' in col 7.            **
      *>***************************************************************
      *>  DATE  CHANGE DESCRIPTION                                   **
      *> ====== ==================================================== **
      *> GC0809 Initial coding.                                      **
      *>***************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-Compressed-Src-TXT.
           05 WS-CS-CHR                          OCCURS 80 TIMES
                                                 PIC X(1).

       01  WS-Runtime-Switches-TXT.
           05 WS-RS-Found-SPACE-CHR              PIC X(1).
              88 WS-RS-Skipping-SPACE-BOOL     VALUE 'Y'.
              88 WS-RS-Not-Skipping-SPACE-BOOL VALUE 'N'.

       01  WS-I-SUB                              USAGE BINARY-CHAR.

       01  WS-J-SUB                              USAGE BINARY-CHAR.
       LINKAGE SECTION.
       01  L-Argument-1-TXT.
           02 L-A1-CHR                           OCCURS 80 TIMES
                                                 PIC X(1).

       01  L-Argument-2-CHR                      PIC X(1).
           88 L-A2-LINKAGE-SECTION-BOOL VALUE 'L'.
           88 L-A2-IDENT-DIVISION-BOOL  VALUE 'I'.
           88 L-A2-Nothing-Special-BOOL VALUE ' '.
      /
GC0712 PROCEDURE DIVISION USING BY VALUE     L-Argument-1-TXT
GC0712                          BY REFERENCE L-Argument-2-CHR.
       000-Main SECTION.
           SET L-A2-Nothing-Special-BOOL TO TRUE
           IF L-A1-CHR (7) = '*'
               GOBACK
           END-IF
           .
      *>
      *> Compress multiple consecutive spaces
      *>
           SET WS-RS-Not-Skipping-SPACE-BOOL TO TRUE
           MOVE 0 TO WS-J-SUB
           MOVE SPACES TO WS-Compressed-Src-TXT
           PERFORM VARYING WS-I-SUB FROM 1 BY 1
                     UNTIL WS-I-SUB > 80
               IF L-A1-CHR (WS-I-SUB) = SPACE
                   IF WS-RS-Not-Skipping-SPACE-BOOL
                       ADD 1 TO WS-J-SUB
                       MOVE UPPER-CASE(L-A1-CHR (WS-I-SUB))
                         TO WS-CS-CHR (WS-J-SUB)
                       SET WS-RS-Skipping-SPACE-BOOL TO TRUE
                   END-IF
               ELSE
                   SET WS-RS-Not-Skipping-SPACE-BOOL TO TRUE
                   ADD 1 TO WS-J-SUB
                   MOVE L-A1-CHR (WS-I-SUB) TO WS-CS-CHR (WS-J-SUB)
               END-IF
           END-PERFORM
      *>
      *> Scan the compressed source line
      *>
           PERFORM VARYING WS-I-SUB FROM 1 BY 1
                     UNTIL WS-I-SUB > 66
               EVALUATE TRUE
                   WHEN WS-CS-CHR (WS-I-SUB) = '*'
                       IF WS-Compressed-Src-TXT (WS-I-SUB : 2) = '*>'
                           GOBACK
                       END-IF
                   WHEN (WS-CS-CHR (WS-I-SUB) = 'L') AND (WS-I-SUB < 66)
                       IF WS-Compressed-Src-TXT (WS-I-SUB : 15)
                          = 'LINKAGE SECTION'
                           SET L-A2-LINKAGE-SECTION-BOOL TO TRUE
                           GOBACK
                       END-IF
                   WHEN (WS-CS-CHR (WS-I-SUB) = 'I') AND (WS-I-SUB < 58)
                       IF WS-Compressed-Src-TXT (WS-I-SUB : 23)
                          = 'IDENTIFICATION DIVISION'
                           SET L-A2-IDENT-DIVISION-BOOL TO TRUE
                           GOBACK
                       END-IF
               END-EVALUATE
           END-PERFORM
      *>
      *> If we get to here, we never found anything!
      *>
+           GOBACK
           .
       END PROGRAM CHECKSRC.

       IDENTIFICATION DIVISION.
       PROGRAM-ID.  LISTING.
      *>***************************************************************
      *> This subprogram generates a cross-reference listing of an   **
      *> GNU COBOL program.                                          **
      *>***************************************************************
      *>                                                             **
      *> AUTHOR:       GARY L. CUTLER                                **
      *>               Copyright (C) 2010, Gary L. Cutler, GPL       **
      *>                                                             **
      *> DATE-WRITTEN: April 1, 2010                                 **
      *>                                                             **
      *>***************************************************************
      *>  DATE  CHANGE DESCRIPTION                                   **
      *> ====== ==================================================== **
      *> GC0410 Initial coding                                       **
      *> GC0711 Updates to accommodate the 12MAR2010 version of OC   **
      *> GC0710 Handle duplicate data names (i.e. 'CORRESPONDING' or **
      *>        qualified items) better; ignore 'END PROGRAM' recs   **
      *>        so program name doesn't appear in listing.           **
      *> GC0313 Fix problem where the first procedure name defined   **
      *>        in the PROCEDURE DIVISION lacks a "Defined" line     **
      *>        number.                                              **
      *> GC1213 Updated for 23NOV2013 version of GNU COBOL 2.1; Stop **
      *>        showing functions as if they were identifiers in the **
      *>        xref listing; Flag all CALL argument references with **
      *>        a "C" rather than "*" because they aren't necessari- **
      *>        ly altered; Fixed assorted formatting bugs; DOWN-    **
      *>        WARD COMPATIBLE WITH GNU COBOL 2.0 SYNTAX            **
      *> GC0314 Fix problem where 1st char of 1st token on a line is **
      *>        lost if >>SOURCE MODE IS FREE is in effect and the   **
      *>        1st character is non-blank.                          **
      *>***************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-Expanded-Src-FILE  ASSIGN TO WS-Expanded-Src-Fn-TXT
                                       ORGANIZATION IS LINE SEQUENTIAL.
GC0712     SELECT F-Listing-FILE       ASSIGN TO L-Listing-Fn-TXT
                                       ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F-Original-Src-FILE  ASSIGN TO L-Src-Fn-TXT
                                       ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F-Sort-Work-FILE     ASSIGN TO DISK.
       DATA DIVISION.
       FILE SECTION.
       FD  F-Expanded-Src-FILE.
       01  F-Expanded-Src-REC.
           05 F-ES-1-CHR                         PIC X.
           05 F-ES-2-256-TXT-256                 PIC X(256).
GC0712 01  F-Expanded-Src2-REC.
GC0712     05 F-ES-1-7-TXT                       PIC X(7).
GC0712     05 F-ES-8-256-TXT                     PIC X(249).

GC0712 FD  F-Listing-FILE.
GC1213 01  F-Listing-96-REC                      PIC X(96).
GC1213 01  F-Listing-135-REC                     PIC X(135).
       01  F-Listing-REC                         PIC X(135).

       FD  F-Original-Src-FILE.
       01  F-Original-Src-REC.
GC0410     05 F-OS-1-128-TXT.
GC0410        10 FILLER                          PIC X(6).
GC0410        10 F-OS-7-CHR                      PIC X(1).
GC0712        10 F-OS-8-72-TXT                   PIC X(65).
GC0712        10 FILLER                          PIC X(56).
           05 F-OS-129-256-TXT                   PIC X(128).

       SD  F-Sort-Work-FILE.
       01  F-Sort-Work-REC.
           05 F-SW-Prog-ID-TXT                   PIC X(15).
           05 F-SW-Token-Uc-TXT                  PIC X(32).
           05 F-SW-Token-TXT                     PIC X(32).
           05 F-SW-Section-TXT                   PIC X(15).
           05 F-SW-Def-Line-NUM                  PIC 9(6).
           05 F-SW-Reference-TXT.
              10 F-SW-Ref-Line-NUM               PIC 9(6).
              10 F-SW-Ref-Flag-CHR               PIC X(1).

       WORKING-STORAGE SECTION.
GC1213 01  WS-Copyright-TXT                      PIC X(86).

       01  WS-Curr-CHR                           PIC X(1).
           88 WS-Curr-Char-Is-Punct-BOOL         VALUE '=', '(', ')',
                                                       '*', '/', '&',
                                                       ';', ',', '<',
                                                       '>', ':'.
           88 WS-Curr-Char-Is-Quote-BOOL         VALUE "'", '"'.
           88 WS-Curr-Char-Is-X-BOOL             VALUE 'x', 'X'.
           88 WS-Curr-Char-Is-Z-BOOL             VALUE 'z', 'Z'.

       01  WS-Curr-Division-TXT                  PIC X(1).
GC1010     88 WS-CD-In-IDENT-DIV-BOOL            VALUE 'i', 'I', '?'.
GC1010     88 WS-CD-In-ENV-DIV-BOOL              VALUE 'e', 'E'.
GC1010     88 WS-CD-In-DATA-DIV-BOOL             VALUE 'd', 'D'.
GC1010     88 WS-CD-In-PROC-DIV-BOOL             VALUE 'p', 'P'.

       01  WS-Curr-Line-NUM                      PIC 9(6).

       01  WS-Curr-Prog-ID-TXT.
           05 FILLER                             PIC X(12).
           05 WS-CPI-13-15-TXT                   PIC X(3).
GC0712     05 WS-CPI-16-CHR                      PIC X(1).

       01  WS-Curr-Section-TXT.
           05 WS-CS-1-CHR                        PIC X(1).
           05 WS-CS-2-14-TXT.
              10 FILLER                          PIC X(10).
              10 WS-CS-11-14-TXT                 PIC X(3).
           05 WS-CS-15-CHR                       PIC X(1).

       01  WS-Curr-Verb-TXT                      PIC X(12).

       01  WS-Delim-TXT                          PIC X(2).

       01  WS-Dummy-TXT                          PIC X(1).

       01  WS-Expanded-Src-Fn-TXT                PIC X(256).

       01  WS-Filename-TXT                       PIC X(256).

GC1213 01  WS-Flags-TXT.
GC1213     05 WS-Suppress-FF-CHR                 PIC X(1).

GC1213 01  WS-Formatted-DT                       PIC 9999/99/99.

       01  WS-Group-Indicators-TXT.
           05 WS-GI-Prog-ID-TXT                  PIC X(15).
           05 WS-GI-Token-TXT                    PIC X(32).

       01  WS-Held-Reference-TXT                 PIC X(100).

       01  WS-I-SUB                              USAGE BINARY-LONG.

       01  WS-J-SUB                              USAGE BINARY-LONG.

       01  WS-Lines-Left-NUM                     USAGE BINARY-LONG.

       01  WS-Lines-Per-Page-NUM                 USAGE BINARY-LONG.

       01  WS-Lines-Per-Page-Env-TXT             PIC X(256).

GC1010 01  WS-Main-Module-Name-TXT               PIC X(256).

       01  WS-Next-CHR                           PIC X(1).
           88 WS-Next-Char-Is-Quote-BOOL         VALUE '"', "'".

       01  WS-OS-Type-FILLER-TXT.
           05 VALUE 'Windows'                    PIC X(14).
           05 VALUE 'Windows/Cygwin'             PIC X(14).
           05 VALUE 'UNIX/Linux'                 PIC X(14).
           05 VALUE 'OSX'                        PIC X(14).
           05 VALUE 'Windows/MinGW'              PIC X(14).
       01  WS-OS-Types-TXT REDEFINES WS-OS-Type-FILLER-TXT.
           05 WS-OS-Type-TXT                     PIC X(14)
                                          OCCURS 5 TIMES .

GC0712 01  WS-Page-NUM                           USAGE BINARY-LONG.

GC0712 01  WS-Page-No-TXT.
GC0712     05 WS-PN-Literal-TXT                  PIC X(6).
GC0712     05 WS-PN-Page-NUM                     PIC Z(3)9.

GC1213 01  WS-Program-Path-TXT                   PIC X(135).

       01  WS-Reserved-Words-TXT.
           05 VALUE '                                 ' PIC X(33).
GC1213     05 VALUE 'FABS                             ' PIC X(33).
           05 VALUE 'VACCEPT                          ' PIC X(33).
           05 VALUE ' ACCESS                          ' PIC X(33).
GC1213     05 VALUE 'FACOS                            ' PIC X(33).
           05 VALUE ' ACTIVE-CLASS                    ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VADD                             ' PIC X(33).
           05 VALUE ' ADDRESS                         ' PIC X(33).
           05 VALUE ' ADVANCING                       ' PIC X(33).
           05 VALUE 'KAFTER                           ' PIC X(33).
           05 VALUE ' ALIGNED                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' ALL                             ' PIC X(33).
           05 VALUE 'VALLOCATE                        ' PIC X(33).
           05 VALUE ' ALPHABET                        ' PIC X(33).
           05 VALUE ' ALPHABETIC                      ' PIC X(33).
           05 VALUE ' ALPHABETIC-LOWER                ' PIC X(33).
           05 VALUE ' ALPHABETIC-UPPER                ' PIC X(33).
           05 VALUE ' ALPHANUMERIC                    ' PIC X(33).
           05 VALUE ' ALPHANUMERIC-EDITED             ' PIC X(33).
           05 VALUE ' ALSO                            ' PIC X(33).
           05 VALUE 'VALTER                           ' PIC X(33).
           05 VALUE ' ALTERNATE                       ' PIC X(33).
           05 VALUE ' AND                             ' PIC X(33).
GC1213     05 VALUE 'FANNUITY                         ' PIC X(33).
           05 VALUE ' ANY                             ' PIC X(33).
           05 VALUE ' ANYCASE                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' ARE                             ' PIC X(33).
           05 VALUE ' AREA                            ' PIC X(33).
           05 VALUE ' AREAS                           ' PIC X(33).
           05 VALUE ' ARGUMENT-NUMBER                 ' PIC X(33).
           05 VALUE ' ARGUMENT-VALUE                  ' PIC X(33).
           05 VALUE ' ARITHMETIC                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' AS                              ' PIC X(33).
           05 VALUE ' ASCENDING                       ' PIC X(33).
           05 VALUE ' ASCII                           ' PIC X(33).
GC1213     05 VALUE 'FASIN                            ' PIC X(33).
           05 VALUE ' ASSIGN                          ' PIC X(33).
           05 VALUE ' AT                              ' PIC X(33).
GC1213     05 VALUE 'FATAN                            ' PIC X(33).
GC0711     05 VALUE ' ATTRIBUTE                       ' PIC X(33).
           05 VALUE ' AUTHOR                          ' PIC X(33).      OBSOLETE
           05 VALUE ' AUTO                            ' PIC X(33).
           05 VALUE ' AUTO-SKIP                       ' PIC X(33).
           05 VALUE ' AUTOMATIC                       ' PIC X(33).
           05 VALUE ' AUTOTERMINATE                   ' PIC X(33).
           05 VALUE ' AWAY-FROM-ZERO                  ' PIC X(33).
           05 VALUE ' B-AND                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' B-NOT                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' B-OR                            ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' B-XOR                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' BACKGROUND-COLOR                ' PIC X(33).
           05 VALUE ' BACKGROUND-COLOUR               ' PIC X(33).
           05 VALUE ' BASED                           ' PIC X(33).
           05 VALUE ' BEEP                            ' PIC X(33).
           05 VALUE ' BEFORE                          ' PIC X(33).
           05 VALUE ' BELL                            ' PIC X(33).
           05 VALUE ' BINARY                          ' PIC X(33).
           05 VALUE ' BINARY-C-LONG                   ' PIC X(33).
           05 VALUE ' BINARY-CHAR                     ' PIC X(33).
           05 VALUE ' BINARY-DOUBLE                   ' PIC X(33).
           05 VALUE ' BINARY-INT                      ' PIC X(33).
           05 VALUE ' BINARY-LONG                     ' PIC X(33).
           05 VALUE ' BINARY-LONG-LONG                ' PIC X(33).
           05 VALUE ' BINARY-SHORT                    ' PIC X(33).
           05 VALUE ' BIT                             ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' BLANK                           ' PIC X(33).
           05 VALUE ' BLINK                           ' PIC X(33).
           05 VALUE ' BLOCK                           ' PIC X(33).
           05 VALUE ' BOOLEAN                         ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FBOOLEAN-OF-INTEGER              ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' BOTTOM                          ' PIC X(33).
           05 VALUE 'YBY                              ' PIC X(33).
GC1213     05 VALUE 'FBYTE-LENGTH                     ' PIC X(33).
           05 VALUE 'MC01                             ' PIC X(33).
           05 VALUE 'MC02                             ' PIC X(33).
           05 VALUE 'MC03                             ' PIC X(33).
           05 VALUE 'MC04                             ' PIC X(33).
           05 VALUE 'MC05                             ' PIC X(33).
           05 VALUE 'MC06                             ' PIC X(33).
           05 VALUE 'MC07                             ' PIC X(33).
           05 VALUE 'MC08                             ' PIC X(33).
           05 VALUE 'MC09                             ' PIC X(33).
           05 VALUE 'MC10                             ' PIC X(33).
           05 VALUE 'MC11                             ' PIC X(33).
           05 VALUE 'MC12                             ' PIC X(33).
           05 VALUE 'VCALL                            ' PIC X(33).
           05 VALUE 'MCALL-CONVENTION                 ' PIC X(33).
           05 VALUE 'VCANCEL                          ' PIC X(33).
           05 VALUE ' CAPACITY                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' CD                              ' PIC X(33).      OBSOLETE
           05 VALUE ' CENTER                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' CF                              ' PIC X(33).
           05 VALUE ' CH                              ' PIC X(33).
           05 VALUE ' CHAIN                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' CHAINING                        ' PIC X(33).
GC1213     05 VALUE 'FCHAR                            ' PIC X(33).
GC1213     05 VALUE 'FCHAR-NATIONAL                   ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' CHARACTER                       ' PIC X(33).
           05 VALUE ' CHARACTERS                      ' PIC X(33).
           05 VALUE ' CLASS                           ' PIC X(33).
           05 VALUE ' CLASS-ID                        ' PIC X(33).      UNIMPLEMENTED
GC0711     05 VALUE ' CLASSIFICATION                  ' PIC X(33).
           05 VALUE 'VCLOSE                           ' PIC X(33).
GC1213     05 VALUE 'FCOB-CRT-STATUS                  ' PIC X(33).
           05 VALUE ' CODE                            ' PIC X(33).
           05 VALUE ' CODE-SET                        ' PIC X(33).
           05 VALUE ' COL                             ' PIC X(33).
           05 VALUE ' COLLATING                       ' PIC X(33).
           05 VALUE ' COLS                            ' PIC X(33).
           05 VALUE ' COLUMN                          ' PIC X(33).
           05 VALUE ' COLUMNS                         ' PIC X(33).
GC1213     05 VALUE 'FCOMBINED-DATETIME               ' PIC X(33).
           05 VALUE ' COMMA                           ' PIC X(33).
           05 VALUE ' COMMAND-LINE                    ' PIC X(33).
           05 VALUE 'VCOMMIT                          ' PIC X(33).
           05 VALUE ' COMMON                          ' PIC X(33).
           05 VALUE ' COMMUNICATION                   ' PIC X(33).      OBSOLETE
           05 VALUE ' COMP                            ' PIC X(33).
           05 VALUE ' COMP-1                          ' PIC X(33).
           05 VALUE ' COMP-2                          ' PIC X(33).
           05 VALUE ' COMP-3                          ' PIC X(33).
           05 VALUE ' COMP-4                          ' PIC X(33).
           05 VALUE ' COMP-5                          ' PIC X(33).
           05 VALUE ' COMP-6                          ' PIC X(33).
           05 VALUE ' COMP-X                          ' PIC X(33).
           05 VALUE ' COMPUTATIONAL                   ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-1                 ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-2                 ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-3                 ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-4                 ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-5                 ' PIC X(33).
           05 VALUE ' COMPUTATIONAL-X                 ' PIC X(33).
           05 VALUE 'VCOMPUTE                         ' PIC X(33).
GC1213     05 VALUE 'FCONCATENATE                     ' PIC X(33).
GC0712     05 VALUE ' CONDITION                       ' PIC X(33).
           05 VALUE 'KCONFIGURATION                   ' PIC X(33).
           05 VALUE 'MCONSOLE                         ' PIC X(33).
           05 VALUE ' CONSTANT                        ' PIC X(33).
           05 VALUE ' CONTAINS                        ' PIC X(33).
GC0712     05 VALUE 'ACONTENT                         ' PIC X(33).
           05 VALUE 'VCONTINUE                        ' PIC X(33).
           05 VALUE ' CONTROL                         ' PIC X(33).
           05 VALUE ' CONTROLS                        ' PIC X(33).
GC0711     05 VALUE ' CONVERSION                      ' PIC X(33).
           05 VALUE 'KCONVERTING                      ' PIC X(33).
           05 VALUE ' COPY                            ' PIC X(33).
           05 VALUE ' CORR                            ' PIC X(33).
           05 VALUE ' CORRESPONDING                   ' PIC X(33).
GC1213     05 VALUE 'FCOS                             ' PIC X(33).
           05 VALUE 'KCOUNT                           ' PIC X(33).
           05 VALUE ' CRT                             ' PIC X(33).
           05 VALUE ' CRT-UNDER                       ' PIC X(33).
           05 VALUE 'MCSP                             ' PIC X(33).
           05 VALUE ' CURRENCY                        ' PIC X(33).
GC1213     05 VALUE 'FCURRENCY-SYMBOL                 ' PIC X(33).
GC1213     05 VALUE 'FCURRENT-DATE                    ' PIC X(33).
           05 VALUE ' CURSOR                          ' PIC X(33).
           05 VALUE ' CYCLE                           ' PIC X(33).
           05 VALUE 'KDATA                            ' PIC X(33).
           05 VALUE ' DATA-POINTER                    ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' DATE                            ' PIC X(33).
           05 VALUE ' DATE-COMPILED                   ' PIC X(33).      OBSOLETE
           05 VALUE ' DATE-MODIFIED                   ' PIC X(33).      OBSOLETE
GC1213     05 VALUE 'FDATE-OF-INTEGER                 ' PIC X(33).
GC1213     05 VALUE 'FDATE-TO-YYYYMMDD                ' PIC X(33).
           05 VALUE ' DATE-WRITTEN                    ' PIC X(33).      OBSOLETE
           05 VALUE ' DAY                             ' PIC X(33).
GC1213     05 VALUE 'FDAY-OF-INTEGER                  ' PIC X(33).
           05 VALUE ' DAY-OF-WEEK                     ' PIC X(33).
GC1213     05 VALUE 'IDAY-TO-YYYYDDD                  ' PIC X(33).
           05 VALUE ' DE                              ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-CONTENTS                  ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-ITEM                      ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-LINE                      ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-NAME                      ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-SUB-1                     ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-SUB-2                     ' PIC X(33).
GC0712     05 VALUE 'IDEBUG-SUB-3                     ' PIC X(33).
           05 VALUE ' DEBUGGING                       ' PIC X(33).
           05 VALUE ' DECIMAL-POINT                   ' PIC X(33).
           05 VALUE ' DECLARATIVES                    ' PIC X(33).
           05 VALUE ' DEFAULT                         ' PIC X(33).
           05 VALUE 'VDELETE                          ' PIC X(33).
           05 VALUE ' DELIMITED                       ' PIC X(33).
           05 VALUE 'KDELIMITER                       ' PIC X(33).
           05 VALUE ' DEPENDING                       ' PIC X(33).
           05 VALUE ' DESCENDING                      ' PIC X(33).
           05 VALUE ' DESTINATION                     ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' DETAIL                          ' PIC X(33).
GC0711     05 VALUE ' DISC                            ' PIC X(33).
           05 VALUE ' DISK                            ' PIC X(33).
           05 VALUE 'VDISPLAY                         ' PIC X(33).
GC1213     05 VALUE 'FDISPLAY-OF                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VDIVIDE                          ' PIC X(33).
           05 VALUE 'KDIVISION                        ' PIC X(33).
           05 VALUE 'KDOWN                            ' PIC X(33).
           05 VALUE ' DUPLICATES                      ' PIC X(33).
           05 VALUE ' DYNAMIC                         ' PIC X(33).
GC1213     05 VALUE 'FE                               ' PIC X(33).
           05 VALUE ' EBCDIC                          ' PIC X(33).
GC0712     05 VALUE ' EC                              ' PIC X(33).
           05 VALUE ' EGI                             ' PIC X(33).      OBSOLETE
           05 VALUE 'VELSE                            ' PIC X(33).
           05 VALUE ' EMI                             ' PIC X(33).      OBSOLETE
           05 VALUE ' EMPTY-CHECK                     ' PIC X(33).
           05 VALUE 'VENABLE                          ' PIC X(33).      OBSOLETE
GC0710     05 VALUE 'KEND                             ' PIC X(33).
           05 VALUE ' END-ACCEPT                      ' PIC X(33).
           05 VALUE ' END-ADD                         ' PIC X(33).
           05 VALUE ' END-CALL                        ' PIC X(33).
           05 VALUE ' END-CHAIN                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' END-COMPUTE                     ' PIC X(33).
           05 VALUE ' END-DELETE                      ' PIC X(33).
           05 VALUE ' END-DISPLAY                     ' PIC X(33).
           05 VALUE ' END-DIVIDE                      ' PIC X(33).
           05 VALUE ' END-EVALUATE                    ' PIC X(33).
           05 VALUE ' END-IF                          ' PIC X(33).
           05 VALUE ' END-MULTIPLY                    ' PIC X(33).
           05 VALUE ' END-OF-PAGE                     ' PIC X(33).
           05 VALUE ' END-PERFORM                     ' PIC X(33).
           05 VALUE ' END-READ                        ' PIC X(33).
           05 VALUE ' END-RECEIVE                     ' PIC X(33).      OBSOLETE
           05 VALUE ' END-RETURN                      ' PIC X(33).
           05 VALUE ' END-REWRITE                     ' PIC X(33).
           05 VALUE ' END-SEARCH                      ' PIC X(33).
           05 VALUE ' END-START                       ' PIC X(33).
           05 VALUE ' END-STRING                      ' PIC X(33).
           05 VALUE ' END-SUBTRACT                    ' PIC X(33).
           05 VALUE ' END-UNSTRING                    ' PIC X(33).
           05 VALUE ' END-WRITE                       ' PIC X(33).
           05 VALUE 'VENTRY                           ' PIC X(33).
           05 VALUE ' ENTRY-CONVENTION                ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'KENVIRONMENT                     ' PIC X(33).
           05 VALUE ' ENVIRONMENT-NAME                ' PIC X(33).
           05 VALUE ' ENVIRONMENT-VALUE               ' PIC X(33).
           05 VALUE ' EO                              ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' EOL                             ' PIC X(33).
           05 VALUE ' EOP                             ' PIC X(33).
           05 VALUE ' EOS                             ' PIC X(33).
           05 VALUE ' EQUAL                           ' PIC X(33).
           05 VALUE 'KEQUALS                          ' PIC X(33).
           05 VALUE ' ERASE                           ' PIC X(33).
           05 VALUE ' ERROR                           ' PIC X(33).
           05 VALUE ' ESCAPE                          ' PIC X(33).
           05 VALUE ' ESI                             ' PIC X(33).      OBSOLETE
           05 VALUE 'VEVALUATE                        ' PIC X(33).
           05 VALUE ' EXCEPTION                       ' PIC X(33).
GC1213     05 VALUE 'FEXCEPTION-FILE                  ' PIC X(33).
GC1213     05 VALUE 'FEXCEPTION-FILE-N                ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FEXCEPTION-LOCATION              ' PIC X(33).
GC1213     05 VALUE 'FEXCEPTION-LOCATION-N            ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' EXCEPTION-OBJECT                ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FEXCEPTION-STATEMENT             ' PIC X(33).
GC1213     05 VALUE 'FEXCEPTION-STATUS                ' PIC X(33).
           05 VALUE ' EXCLUSIVE                       ' PIC X(33).
           05 VALUE 'VEXIT                            ' PIC X(33).
GC1213     05 VALUE 'FEXP                             ' PIC X(33).
GC1213     05 VALUE 'FEXP10                           ' PIC X(33).
           05 VALUE ' EXPANDS                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' EXTEND                          ' PIC X(33).
           05 VALUE ' EXTERNAL                        ' PIC X(33).
GC1213     05 VALUE 'FFACTORIAL                       ' PIC X(33).
           05 VALUE ' FACTORY                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' FALSE                           ' PIC X(33).
           05 VALUE 'KFD                              ' PIC X(33).
           05 VALUE 'KFILE                            ' PIC X(33).
           05 VALUE ' FILE-CONTROL                    ' PIC X(33).
           05 VALUE ' FILE-ID                         ' PIC X(33).
GC1113     05 VALUE ' FILLER                          ' PIC X(33).
           05 VALUE ' FINAL                           ' PIC X(33).
           05 VALUE ' FIRST                           ' PIC X(33).
GC0712     05 VALUE ' FLOAT-BINARY-128                ' PIC X(33).      UNIMPLEMENTED
GC0712     05 VALUE ' FLOAT-BINARY-32                 ' PIC X(33).      UNIMPLEMENTED
GC0712     05 VALUE ' FLOAT-BINARY-64                 ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' FLOAT-DECIMAL-16                ' PIC X(33).
           05 VALUE ' FLOAT-DECIMAL-34                ' PIC X(33).
           05 VALUE ' FLOAT-EXTENDED                  ' PIC X(33).      UNIMPLEMENTED
GC0712     05 VALUE ' FLOAT-INFINITY                  ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' FLOAT-LONG                      ' PIC X(33).
GC0712     05 VALUE ' FLOAT-NOT-A-NUMBER              ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' FLOAT-SHORT                     ' PIC X(33).
           05 VALUE ' FOOTING                         ' PIC X(33).
           05 VALUE ' FOR                             ' PIC X(33).
           05 VALUE ' FOREGROUND-COLOR                ' PIC X(33).
           05 VALUE ' FOREGROUND-COLOUR               ' PIC X(33).
GC0711     05 VALUE ' FOREVER                         ' PIC X(33).
           05 VALUE ' FORMAT                          ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FFORMATTED-CURRENT-DATE          ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FFORMATTED-DATE                  ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FFORMATTED-DATETIME              ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FFORMATTED-TIME                  ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'MFORMFEED                        ' PIC X(33).
GC1213     05 VALUE 'FFRACTION-PART                   ' PIC X(33).
           05 VALUE 'VFREE                            ' PIC X(33).
           05 VALUE ' FROM                            ' PIC X(33).
           05 VALUE ' FULL                            ' PIC X(33).
           05 VALUE ' FUNCTION                        ' PIC X(33).
GC0712     05 VALUE 'KFUNCTION-ID                     ' PIC X(33).
           05 VALUE ' FUNCTION-POINTER                ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VGENERATE                        ' PIC X(33).
           05 VALUE ' GET                             ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'KGIVING                          ' PIC X(33).
           05 VALUE ' GLOBAL                          ' PIC X(33).
           05 VALUE 'VGO                              ' PIC X(33).
           05 VALUE 'VGOBACK                          ' PIC X(33).
           05 VALUE ' GREATER                         ' PIC X(33).
           05 VALUE ' GROUP                           ' PIC X(33).
           05 VALUE ' GROUP-USAGE                     ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' HEADING                         ' PIC X(33).
           05 VALUE ' HIGH-VALUE                      ' PIC X(33).
           05 VALUE ' HIGH-VALUES                     ' PIC X(33).
GC1213     05 VALUE 'FHIGHEST-ALGEBRAIC               ' PIC X(33).
           05 VALUE ' HIGHLIGHT                       ' PIC X(33).
           05 VALUE ' I-O                             ' PIC X(33).
           05 VALUE ' I-O-CONTROL                     ' PIC X(33).
           05 VALUE 'KID                              ' PIC X(33).
           05 VALUE 'KIDENTIFICATION                  ' PIC X(33).
           05 VALUE 'VIF                              ' PIC X(33).
           05 VALUE ' IGNORE                          ' PIC X(33).
           05 VALUE ' IGNORING                        ' PIC X(33).
           05 VALUE ' IMPLEMENTS                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' IN                              ' PIC X(33).
           05 VALUE ' INDEX                           ' PIC X(33).
           05 VALUE 'KINDEXED                         ' PIC X(33).
           05 VALUE ' INDICATE                        ' PIC X(33).
           05 VALUE ' INDIRECT                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' INHERITS                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' INITIAL                         ' PIC X(33).
           05 VALUE 'VINITIALISE                      ' PIC X(33).
           05 VALUE ' INITIALISED                     ' PIC X(33).
           05 VALUE 'VINITIALIZE                      ' PIC X(33).
           05 VALUE ' INITIALIZED                     ' PIC X(33).
           05 VALUE 'VINITIATE                        ' PIC X(33).
           05 VALUE ' INPUT                           ' PIC X(33).
           05 VALUE 'KINPUT-OUTPUT                    ' PIC X(33).
           05 VALUE 'VINSPECT                         ' PIC X(33).
           05 VALUE ' INSTALLATION                    ' PIC X(33).      OBSOLETE
GC1213     05 VALUE 'FINTEGER                         ' PIC X(33).
GC1213     05 VALUE 'FINTEGER-OF-BOOLEAN              ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FINTEGER-OF-DATE                 ' PIC X(33).
GC1213     05 VALUE 'FINTEGER-OF-DAY                  ' PIC X(33).
GC1213     05 VALUE 'FINTEGER-OF-FORMATTED-DATE       ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FINTEGER-PART                    ' PIC X(33).
           05 VALUE ' INTERFACE                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' INTERFACE-ID                    ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' INTERMEDIATE                    ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'KINTO                            ' PIC X(33).
           05 VALUE ' INTRINSIC                       ' PIC X(33).
           05 VALUE ' INVALID                         ' PIC X(33).
           05 VALUE ' INVOKE                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' IS                              ' PIC X(33).
           05 VALUE ' JUST                            ' PIC X(33).
           05 VALUE ' JUSTIFIED                       ' PIC X(33).
           05 VALUE ' KEPT                            ' PIC X(33).
           05 VALUE ' KEY                             ' PIC X(33).
           05 VALUE ' KEYBOARD                        ' PIC X(33).
           05 VALUE ' LABEL                           ' PIC X(33).
           05 VALUE ' LAST                            ' PIC X(33).
           05 VALUE ' LC_ALL                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_COLLATE                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_CTYPE                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_MESSAGES                     ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_MONETARY                     ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_NUMERIC                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LC_TIME                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LEADING                         ' PIC X(33).
           05 VALUE ' LEFT                            ' PIC X(33).
           05 VALUE ' LEFT-JUSTIFY                    ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' LEFTLINE                        ' PIC X(33).
GC1213     05 VALUE 'FLENGTH                          ' PIC X(33).
GC1213     05 VALUE 'FLENGTH-AN                       ' PIC X(33).
           05 VALUE ' LENGTH-CHECK                    ' PIC X(33).
           05 VALUE ' LESS                            ' PIC X(33).
           05 VALUE ' LIMIT                           ' PIC X(33).
           05 VALUE ' LIMITS                          ' PIC X(33).
           05 VALUE ' LINAGE                          ' PIC X(33).
           05 VALUE 'ILINAGE-COUNTER                  ' PIC X(33).
           05 VALUE ' LINE                            ' PIC X(33).
GC1213     05 VALUE 'ILINE-COUNTER                    ' PIC X(33).
           05 VALUE ' LINES                           ' PIC X(33).
           05 VALUE 'KLINKAGE                         ' PIC X(33).
           05 VALUE 'KLOCAL-STORAGE                   ' PIC X(33).
           05 VALUE ' LOCALE                          ' PIC X(33).
GC1213     05 VALUE 'FLOCALE-COMPARE                  ' PIC X(33).
GC1213     05 VALUE 'FLOCALE-DATE                     ' PIC X(33).
GC1213     05 VALUE 'FLOCALE-TIME                     ' PIC X(33).
GC1213     05 VALUE 'FLOCALE-TIME-FROM-SECONDS        ' PIC X(33).
           05 VALUE ' LOCK                            ' PIC X(33).
GC1213     05 VALUE 'FLOG                             ' PIC X(33).
GC1213     05 VALUE 'FLOG10                           ' PIC X(33).
           05 VALUE ' LOW-VALUE                       ' PIC X(33).
           05 VALUE ' LOW-VALUES                      ' PIC X(33).
           05 VALUE ' LOWER                           ' PIC X(33).
GC1213     05 VALUE 'FLOWER-CASE                      ' PIC X(33).
GC1213     05 VALUE 'FLOWEST-ALGEBRAIC                ' PIC X(33).
           05 VALUE ' LOWLIGHT                        ' PIC X(33).
           05 VALUE ' MANUAL                          ' PIC X(33).
GC1213     05 VALUE 'FMAX                             ' PIC X(33).
GC1213     05 VALUE 'FMEAN                            ' PIC X(33).
GC1213     05 VALUE 'FMEDIAN                          ' PIC X(33).
           05 VALUE ' MEMORY                          ' PIC X(33).
           05 VALUE 'VMERGE                           ' PIC X(33).
           05 VALUE ' MESSAGE                         ' PIC X(33).      OBSOLETE
           05 VALUE ' METHOD                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' METHOD-ID                       ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FMIDRANGE                        ' PIC X(33).
GC1213     05 VALUE 'FMIN                             ' PIC X(33).
           05 VALUE ' MINUS                           ' PIC X(33).
GC1213     05 VALUE 'FMOD                             ' PIC X(33).
           05 VALUE ' MODE                            ' PIC X(33).
GC1213     05 VALUE 'FMODULE-CALLER-ID                ' PIC X(33).
GC1213     05 VALUE 'FMODULE-DATE                     ' PIC X(33).
GC1213     05 VALUE 'FMODULE-FORMATTED-DATE           ' PIC X(33).
GC1213     05 VALUE 'FMODULE-ID                       ' PIC X(33).
GC1213     05 VALUE 'FMODULE-PATH                     ' PIC X(33).
GC1213     05 VALUE 'FMODULE-SOURCE                   ' PIC X(33).
GC1213     05 VALUE 'FMODULE-TIME                     ' PIC X(33).
GC1213     05 VALUE 'FMONETARY-DECIMAL-POINT          ' PIC X(33).
GC1213     05 VALUE 'FMONETARY-THOUSANDS-SEPARATOR    ' PIC X(33).
           05 VALUE 'VMOVE                            ' PIC X(33).
           05 VALUE ' MULTIPLE                        ' PIC X(33).
           05 VALUE 'VMULTIPLY                        ' PIC X(33).
GC0711     05 VALUE ' NAME                            ' PIC X(33).
           05 VALUE ' NATIONAL                        ' PIC X(33).
           05 VALUE ' NATIONAL-EDITED                 ' PIC X(33).
GC1213     05 VALUE 'FNATIONAL-OF                     ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' NATIVE                          ' PIC X(33).
           05 VALUE ' NEAREST-AWAY-FROM-ZERO          ' PIC X(33).
           05 VALUE ' NEAREST-EVEN                    ' PIC X(33).
           05 VALUE ' NEAREST-TOWARD-ZERO             ' PIC X(33).
           05 VALUE ' NEGATIVE                        ' PIC X(33).
           05 VALUE ' NESTED                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VNEXT                            ' PIC X(33).
           05 VALUE ' NO                              ' PIC X(33).
           05 VALUE ' NO-ECHO                         ' PIC X(33).
           05 VALUE ' NONE                            ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' NORMAL                          ' PIC X(33).
           05 VALUE ' NOT                             ' PIC X(33).
           05 VALUE ' NULL                            ' PIC X(33).
           05 VALUE ' NULLS                           ' PIC X(33).
           05 VALUE ' NUMBER                          ' PIC X(33).
           05 VALUE 'INUMBER-OF-CALL-PARAMETERS       ' PIC X(33).
           05 VALUE ' NUMBERS                         ' PIC X(33).
           05 VALUE ' NUMERIC                         ' PIC X(33).
GC1213     05 VALUE 'FNUMERIC-DECIMAL-POINT           ' PIC X(33).
           05 VALUE ' NUMERIC-EDITED                  ' PIC X(33).
GC1213     05 VALUE 'FNUMERIC-THOUSANDS-SEPARATOR     ' PIC X(33).
GC1213     05 VALUE 'FNUMVAL                          ' PIC X(33).
GC1213     05 VALUE 'FNUMVAL-C                        ' PIC X(33).
GC1213     05 VALUE 'FNUMVAL-F                        ' PIC X(33).
           05 VALUE ' OBJECT                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' OBJECT-COMPUTER                 ' PIC X(33).
           05 VALUE ' OBJECT-REFERENCE                ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' OCCURS                          ' PIC X(33).
           05 VALUE ' OF                              ' PIC X(33).
           05 VALUE ' OFF                             ' PIC X(33).
           05 VALUE ' OMITTED                         ' PIC X(33).
           05 VALUE ' ON                              ' PIC X(33).
           05 VALUE ' ONLY                            ' PIC X(33).
           05 VALUE 'VOPEN                            ' PIC X(33).
           05 VALUE ' OPTIONAL                        ' PIC X(33).
           05 VALUE ' OPTIONS                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' OR                              ' PIC X(33).
GC1213     05 VALUE 'FORD                             ' PIC X(33).
GC1213     05 VALUE 'FORD-MAX                         ' PIC X(33).
GC1213     05 VALUE 'FORD-MIN                         ' PIC X(33).
           05 VALUE ' ORDER                           ' PIC X(33).
           05 VALUE ' ORGANISATION                    ' PIC X(33).
           05 VALUE ' ORGANIZATION                    ' PIC X(33).
           05 VALUE ' OTHER                           ' PIC X(33).
           05 VALUE ' OUTPUT                          ' PIC X(33).
           05 VALUE ' OVERFLOW                        ' PIC X(33).
           05 VALUE ' OVERLINE                        ' PIC X(33).
           05 VALUE ' OVERRIDE                        ' PIC X(33).
           05 VALUE ' PACKED-DECIMAL                  ' PIC X(33).
           05 VALUE ' PADDING                         ' PIC X(33).
           05 VALUE ' PAGE                            ' PIC X(33).
GC1213     05 VALUE 'IPAGE-COUNTER                    ' PIC X(33).
           05 VALUE ' PARAGRAPH                       ' PIC X(33).
           05 VALUE 'VPERFORM                         ' PIC X(33).
           05 VALUE ' PF                              ' PIC X(33).
           05 VALUE ' PH                              ' PIC X(33).
GC1213     05 VALUE 'FPI                              ' PIC X(33).
           05 VALUE 'KPIC                             ' PIC X(33).
           05 VALUE 'KPICTURE                         ' PIC X(33).
           05 VALUE ' PLUS                            ' PIC X(33).
           05 VALUE 'KPOINTER                         ' PIC X(33).
           05 VALUE ' POSITION                        ' PIC X(33).
           05 VALUE ' POSITIVE                        ' PIC X(33).
           05 VALUE ' PREFIXED                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' PRESENT                         ' PIC X(33).
GC1213     05 VALUE 'FPRESENT-VALUE                   ' PIC X(33).
           05 VALUE ' PREVIOUS                        ' PIC X(33).
           05 VALUE 'MPRINTER                         ' PIC X(33).
           05 VALUE ' PRINTING                        ' PIC X(33).
           05 VALUE 'KPROCEDURE                       ' PIC X(33).
           05 VALUE ' PROCEDURE-POINTER               ' PIC X(33).
           05 VALUE ' PROCEDURES                      ' PIC X(33).
           05 VALUE ' PROCEED                         ' PIC X(33).
           05 VALUE ' PROGRAM                         ' PIC X(33).
           05 VALUE 'KPROGRAM-ID                      ' PIC X(33).
           05 VALUE ' PROGRAM-POINTER                 ' PIC X(33).
           05 VALUE ' PROHIBITED                      ' PIC X(33).
           05 VALUE ' PROMPT                          ' PIC X(33).
           05 VALUE ' PROPERTY                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' PROTOTYPE                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' PURGE                           ' PIC X(33).      OBSOLETE
           05 VALUE ' QUEUE                           ' PIC X(33).      OBSOLETE
           05 VALUE ' QUOTE                           ' PIC X(33).
           05 VALUE ' QUOTES                          ' PIC X(33).
           05 VALUE ' RAISE                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' RAISING                         ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FRANDOM                          ' PIC X(33).
GC1213     05 VALUE 'FRANGE                           ' PIC X(33).
GC1213     05 VALUE 'KRD                              ' PIC X(33).
           05 VALUE 'VREAD                            ' PIC X(33).
           05 VALUE 'VREADY                           ' PIC X(33).
           05 VALUE 'VRECEIVE                         ' PIC X(33).      OBSOLETE
           05 VALUE ' RECORD                          ' PIC X(33).
           05 VALUE ' RECORDING                       ' PIC X(33).
           05 VALUE ' RECORDS                         ' PIC X(33).
           05 VALUE ' RECURSIVE                       ' PIC X(33).
           05 VALUE 'KREDEFINES                       ' PIC X(33).
           05 VALUE ' REEL                            ' PIC X(33).
GC0712     05 VALUE 'AREFERENCE                       ' PIC X(33).
           05 VALUE ' REFERENCES                      ' PIC X(33).
           05 VALUE ' RELATION                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' RELATIVE                        ' PIC X(33).
           05 VALUE 'VRELEASE                         ' PIC X(33).
GC1213     05 VALUE 'FREM                             ' PIC X(33).
           05 VALUE ' REMAINDER                       ' PIC X(33).
           05 VALUE ' REMARKS                         ' PIC X(33).      OBSOLETE
           05 VALUE ' REMOVAL                         ' PIC X(33).
           05 VALUE 'KRENAMES                         ' PIC X(33).
           05 VALUE ' REPLACE                         ' PIC X(33).
           05 VALUE 'KREPLACING                       ' PIC X(33).
           05 VALUE 'KREPORT                          ' PIC X(33).
           05 VALUE ' REPORTING                       ' PIC X(33).
           05 VALUE ' REPORTS                         ' PIC X(33).
           05 VALUE ' REPOSITORY                      ' PIC X(33).
           05 VALUE ' REQUIRED                        ' PIC X(33).
           05 VALUE ' RESERVE                         ' PIC X(33).
           05 VALUE 'VRESET                           ' PIC X(33).
           05 VALUE ' RESUME                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' RETRY                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VRETURN                          ' PIC X(33).
           05 VALUE 'IRETURN-CODE                     ' PIC X(33).
           05 VALUE 'KRETURNING                       ' PIC X(33).
GC1213     05 VALUE 'FREVERSE                         ' PIC X(33).
           05 VALUE ' REVERSE-VIDEO                   ' PIC X(33).
           05 VALUE ' REVERSED                        ' PIC X(33).
           05 VALUE ' REWIND                          ' PIC X(33).
           05 VALUE 'VREWRITE                         ' PIC X(33).
           05 VALUE ' RF                              ' PIC X(33).
           05 VALUE ' RH                              ' PIC X(33).
           05 VALUE ' RIGHT                           ' PIC X(33).
           05 VALUE ' RIGHT-JUSTIFY                   ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VROLLBACK                        ' PIC X(33).
           05 VALUE ' ROUNDED                         ' PIC X(33).
           05 VALUE ' ROUNDING                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' RUN                             ' PIC X(33).
           05 VALUE ' SAME                            ' PIC X(33).
           05 VALUE 'KSCREEN                          ' PIC X(33).
           05 VALUE ' SCROLL                          ' PIC X(33).
           05 VALUE 'KSD                              ' PIC X(33).
           05 VALUE 'VSEARCH                          ' PIC X(33).
           05 VALUE ' SECONDS                         ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FSECONDS-FROM-FORMATTED-TIME     ' PIC X(33).
GC1213     05 VALUE 'FSECONDS-PAST-MIDNIGHT           ' PIC X(33).
           05 VALUE 'KSECTION                         ' PIC X(33).
           05 VALUE ' SECURE                          ' PIC X(33).
           05 VALUE ' SECURITY                        ' PIC X(33).      OBSOLETE
           05 VALUE ' SEGMENT                         ' PIC X(33).      OBSOLETE
           05 VALUE ' SEGMENT-LIMIT                   ' PIC X(33).
           05 VALUE ' SELECT                          ' PIC X(33).
           05 VALUE ' SELF                            ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VSEND                            ' PIC X(33).      OBSOLETE
           05 VALUE ' SENTENCE                        ' PIC X(33).
           05 VALUE ' SEPARATE                        ' PIC X(33).
           05 VALUE ' SEQUENCE                        ' PIC X(33).
           05 VALUE ' SEQUENTIAL                      ' PIC X(33).
           05 VALUE 'VSET                             ' PIC X(33).
           05 VALUE ' SHARING                         ' PIC X(33).
GC1213     05 VALUE 'FSIGN                            ' PIC X(33).
           05 VALUE ' SIGNED                          ' PIC X(33).
           05 VALUE ' SIGNED-INT                      ' PIC X(33).
           05 VALUE ' SIGNED-LONG                     ' PIC X(33).
           05 VALUE ' SIGNED-SHORT                    ' PIC X(33).
GC1213     05 VALUE 'FSIN                             ' PIC X(33).
           05 VALUE ' SIZE                            ' PIC X(33).
           05 VALUE 'VSORT                            ' PIC X(33).
           05 VALUE ' SORT-MERGE                      ' PIC X(33).
           05 VALUE 'ISORT-RETURN                     ' PIC X(33).
           05 VALUE ' SOURCE                          ' PIC X(33).
           05 VALUE ' SOURCE-COMPUTER                 ' PIC X(33).
           05 VALUE ' SOURCES                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' SPACE                           ' PIC X(33).
           05 VALUE ' SPACE-FILL                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' SPACES                          ' PIC X(33).
           05 VALUE ' SPECIAL-NAMES                   ' PIC X(33).
GC1213     05 VALUE 'FSQRT                            ' PIC X(33).
           05 VALUE ' STANDARD                        ' PIC X(33).
           05 VALUE ' STANDARD-1                      ' PIC X(33).
           05 VALUE ' STANDARD-2                      ' PIC X(33).
           05 VALUE ' STANDARD-BINARY                 ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FSTANDARD-COMPARE                ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' STANDARD-DECIMAL                ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FSTANDARD-DEVIATION              ' PIC X(33).
           05 VALUE 'VSTART                           ' PIC X(33).
           05 VALUE ' STATEMENT                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' STATIC                          ' PIC X(33).
           05 VALUE ' STATUS                          ' PIC X(33).
           05 VALUE ' STDCALL                         ' PIC X(33).
           05 VALUE 'MSTDERR                          ' PIC X(33).
           05 VALUE 'MSTDIN                           ' PIC X(33).
           05 VALUE 'MSTDOUT                          ' PIC X(33).
           05 VALUE ' STEP                            ' PIC X(33).
           05 VALUE 'VSTOP                            ' PIC X(33).
GC1213     05 VALUE 'FSTORED-CHAR-LENGTH              ' PIC X(33).
           05 VALUE 'VSTRING                          ' PIC X(33).
           05 VALUE ' STRONG                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' SUB-QUEUE-1                     ' PIC X(33).      OBSOLETE
           05 VALUE ' SUB-QUEUE-2                     ' PIC X(33).      OBSOLETE
           05 VALUE ' SUB-QUEUE-3                     ' PIC X(33).      OBSOLETE
GC1213     05 VALUE 'FSUBSTITUTE                      ' PIC X(33).
GC1213     05 VALUE 'FSUBSTITUTE-CASE                 ' PIC X(33).
           05 VALUE 'VSUBTRACT                        ' PIC X(33).
GC1213     05 VALUE 'FSUM                             ' PIC X(33).
           05 VALUE ' SUPER                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VSUPPRESS                        ' PIC X(33).
           05 VALUE 'MSW0                             ' PIC X(33).
           05 VALUE 'MSW1                             ' PIC X(33).
           05 VALUE 'MSW10                            ' PIC X(33).
           05 VALUE 'MSW11                            ' PIC X(33).
           05 VALUE 'MSW12                            ' PIC X(33).
           05 VALUE 'MSW13                            ' PIC X(33).
           05 VALUE 'MSW14                            ' PIC X(33).
           05 VALUE 'MSW15                            ' PIC X(33).
           05 VALUE 'MSW2                             ' PIC X(33).
           05 VALUE 'MSW3                             ' PIC X(33).
           05 VALUE 'MSW4                             ' PIC X(33).
           05 VALUE 'MSW5                             ' PIC X(33).
           05 VALUE 'MSW6                             ' PIC X(33).
           05 VALUE 'MSW7                             ' PIC X(33).
           05 VALUE 'MSW8                             ' PIC X(33).
           05 VALUE 'MSW9                             ' PIC X(33).
           05 VALUE 'MSWITCH-0                        ' PIC X(33).
           05 VALUE 'MSWITCH-1                        ' PIC X(33).
           05 VALUE 'MSWITCH-10                       ' PIC X(33).
           05 VALUE 'MSWITCH-11                       ' PIC X(33).
           05 VALUE 'MSWITCH-12                       ' PIC X(33).
           05 VALUE 'MSWITCH-13                       ' PIC X(33).
           05 VALUE 'MSWITCH-14                       ' PIC X(33).
           05 VALUE 'MSWITCH-15                       ' PIC X(33).
           05 VALUE 'MSWITCH-2                        ' PIC X(33).
           05 VALUE 'MSWITCH-3                        ' PIC X(33).
           05 VALUE 'MSWITCH-4                        ' PIC X(33).
           05 VALUE 'MSWITCH-5                        ' PIC X(33).
           05 VALUE 'MSWITCH-6                        ' PIC X(33).
           05 VALUE 'MSWITCH-7                        ' PIC X(33).
           05 VALUE 'MSWITCH-8                        ' PIC X(33).
           05 VALUE 'MSWITCH-9                        ' PIC X(33).
           05 VALUE ' SYMBOL                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' SYMBOLIC                        ' PIC X(33).
           05 VALUE ' SYNC                            ' PIC X(33).
           05 VALUE ' SYNCHRONISED                    ' PIC X(33).
           05 VALUE ' SYNCHRONIZED                    ' PIC X(33).
           05 VALUE 'MSYSERR                          ' PIC X(33).
           05 VALUE 'MSYSIN                           ' PIC X(33).
           05 VALUE 'MSYSIPT                          ' PIC X(33).
           05 VALUE 'MSYSLIST                         ' PIC X(33).
           05 VALUE 'MSYSLST                          ' PIC X(33).
           05 VALUE 'MSYSOUT                          ' PIC X(33).
           05 VALUE ' SYSTEM-DEFAULT                  ' PIC X(33).
           05 VALUE ' TABLE                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'KTALLYING                        ' PIC X(33).
GC1213     05 VALUE 'FTAN                             ' PIC X(33).
           05 VALUE ' TAPE                            ' PIC X(33).
           05 VALUE ' TERMINAL                        ' PIC X(33).      OBSOLETE
           05 VALUE 'VTERMINATE                       ' PIC X(33).
           05 VALUE ' TEST                            ' PIC X(33).
GC1213     05 VALUE 'FTEST-DATE-YYYYMMDD              ' PIC X(33).
GC1213     05 VALUE 'FTEST-DAY-YYYYDDD                ' PIC X(33).
GC1213     05 VALUE 'FTEST-FORMATTED-DATETIME         ' PIC X(33).      UNIMPLEMENTED
GC1213     05 VALUE 'FTEST-NUMVAL                     ' PIC X(33).
GC1213     05 VALUE 'FTEST-NUMVAL-C                   ' PIC X(33).
GC1213     05 VALUE 'FTEST-NUMVAL-F                   ' PIC X(33).
           05 VALUE ' TEXT                            ' PIC X(33).      OBSOLETE
           05 VALUE ' THAN                            ' PIC X(33).
           05 VALUE ' THEN                            ' PIC X(33).
           05 VALUE ' THROUGH                         ' PIC X(33).
           05 VALUE ' THRU                            ' PIC X(33).
           05 VALUE ' TIME                            ' PIC X(33).
GC0711     05 VALUE ' TIME-OUT                        ' PIC X(33).
GC0711     05 VALUE ' TIMEOUT                         ' PIC X(33).
           05 VALUE ' TIMES                           ' PIC X(33).
           05 VALUE 'KTO                              ' PIC X(33).
           05 VALUE ' TOP                             ' PIC X(33).
           05 VALUE ' TOWARD-GREATER                  ' PIC X(33).
           05 VALUE ' TOWARD-LESSER                   ' PIC X(33).
           05 VALUE ' TRAILING                        ' PIC X(33).
           05 VALUE ' TRAILING-SIGN                   ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VTRANSFORM                       ' PIC X(33).
GC1213     05 VALUE 'FTRIM                            ' PIC X(33).
           05 VALUE ' TRUE                            ' PIC X(33).
           05 VALUE ' TRUNCATION                      ' PIC X(33).
           05 VALUE ' TYPE                            ' PIC X(33).
           05 VALUE ' TYPEDEF                         ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' UCS-4                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' UNDERLINE                       ' PIC X(33).
           05 VALUE ' UNIT                            ' PIC X(33).
           05 VALUE ' UNIVERSAL                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE 'VUNLOCK                          ' PIC X(33).
           05 VALUE ' UNSIGNED                        ' PIC X(33).
           05 VALUE ' UNSIGNED-INT                    ' PIC X(33).
           05 VALUE ' UNSIGNED-LONG                   ' PIC X(33).
           05 VALUE ' UNSIGNED-SHORT                  ' PIC X(33).
           05 VALUE 'VUNSTRING                        ' PIC X(33).
           05 VALUE ' UNTIL                           ' PIC X(33).
           05 VALUE 'KUP                              ' PIC X(33).
           05 VALUE ' UPDATE                          ' PIC X(33).
           05 VALUE ' UPON                            ' PIC X(33).
           05 VALUE ' UPPER                           ' PIC X(33).
GC1213     05 VALUE 'FUPPER-CASE                      ' PIC X(33).
           05 VALUE ' USAGE                           ' PIC X(33).
           05 VALUE 'VUSE                             ' PIC X(33).
GC0711     05 VALUE ' USER                            ' PIC X(33).
           05 VALUE ' USER-DEFAULT                    ' PIC X(33).
           05 VALUE 'KUSING                           ' PIC X(33).
           05 VALUE ' UTF-16                          ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' UTF-8                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' VAL-STATUS                      ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' VALID                           ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' VALIDATE                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' VALIDATE-STATUS                 ' PIC X(33).      UNIMPLEMENTED
GC0712     05 VALUE 'AVALUE                           ' PIC X(33).
           05 VALUE ' VALUES                          ' PIC X(33).
GC1213     05 VALUE 'FVARIANCE                        ' PIC X(33).
           05 VALUE 'KVARYING                         ' PIC X(33).
           05 VALUE ' VDISABLE                        ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' WAIT                            ' PIC X(33).
           05 VALUE 'VWHEN                            ' PIC X(33).
GC1213     05 VALUE 'FWHEN-COMPILED                   ' PIC X(33).
           05 VALUE ' WITH                            ' PIC X(33).
           05 VALUE ' WORDS                           ' PIC X(33).
           05 VALUE 'KWORKING-STORAGE                 ' PIC X(33).
           05 VALUE 'VWRITE                           ' PIC X(33).
GC1213     05 VALUE 'FYEAR-TO-YYYY                    ' PIC X(33).
           05 VALUE ' YYYYDDD                         ' PIC X(33).
           05 VALUE ' YYYYMMDD                        ' PIC X(33).
           05 VALUE ' ZERO                            ' PIC X(33).
           05 VALUE ' ZERO-FILL                       ' PIC X(33).      UNIMPLEMENTED
           05 VALUE ' ZEROES                          ' PIC X(33).
           05 VALUE ' ZEROS                           ' PIC X(33).
       01  WS-Reserved-Word-Table-TXT REDEFINES WS-Reserved-Words-TXT.
GC1113     05 WS-Reserved-Word-TXT        OCCURS 754 TIMES
                                                 ASCENDING KEY
                                                     WS-RW-Word-TXT
                                                 INDEXED WS-RW-IDX.
              10 WS-RW-Type-CD                   PIC X(1).
              10 WS-RW-Word-TXT                  PIC X(32).

       01  WS-Runtime-Switches.
GC0710     05 WS-RS-Duplicate-CHR                PIC X(1).
           05 WS-RS-In-Which-Pgm-CHR             PIC X(1).
              88 WS-RS-In-Main-Module-BOOL       VALUE 'M'.
              88 WS-RS-In-Copybook-BOOL          VALUE 'C'.
           05 WS-RS-Last-Token-Ended-Sent-CHR    PIC X(1).
           05 WS-RS-Processing-PICTURE-CHR       PIC X(1).
           05 WS-RS-Token-Ended-Sentence-CHR     PIC X(1).
GC0710     05 WS-RS-Verb-Has-Been-Found-CHR      PIC X(1).

       01  WS-Saved-Section-TXT                  PIC X(15).

GC1213 01  WS-Src-Dashes-TXT.
GC0712     05 VALUE '======'                     PIC X(7).
GC0712     05 VALUE ALL '='                      PIC X(128).

       01  WS-Src-Detail-Line-TXT.
           05 WS-SDL-Line-NUM                    PIC ZZZZZ9.
           05 FILLER                             PIC X(1).
           05 WS-SDL-Statement-TXT               PIC X(256).

GC1213 01  WS-Src-Hold-TXT                       PIC X(256).

       01  WS-Src-Line-NUM                       PIC 9(6).

GC1213 01  WS-Src-Lines-NUM                      USAGE BINARY-LONG.

       01  WS-Src-SUB                            USAGE BINARY-LONG.

       01  WS-Tally-QTY                          USAGE BINARY-LONG.

       01  WS-Temp-10-Chars-TXT                  PIC X(10).

       01  WS-Temp-32-Chars-1-TXT                PIC X(32).

GC0711 01  WS-Temp-32-Chars-2-TXT                PIC X(32).

GC0711 01  WS-Temp-32-Chars-3-TXT                PIC X(32).

GC0712 01  WS-Temp-65-Chars-TXT                  PIC X(65).

       01  WS-Temp-256-Chars-TXT                 PIC X(256).

       01  WS-Today-DT                           PIC 9(8).

       01  WS-Token-Curr-TXT                     PIC X(32).

       01  WS-Token-Curr-Uc-TXT                  PIC X(32).

       01  WS-Token-Prev-TXT                     PIC X(32).

       01  WS-Token-Search-TXT                   PIC X(32).

       01  WS-Token-Type-CD                      PIC X(1).
GC0712     88 WS-TT-Token-Is-Argtype-BOOL        VALUE 'A'.
           88 WS-TT-Token-Is-EOF-BOOL            VALUE HIGH-VALUES.
GC1213     88 WS-TT-Token-Is-Function-BOOL       VALUE 'F'.
           88 WS-TT-Token-Is-Identifier-BOOL     VALUE 'I'.
GC0712     88 WS-TT-Token-Is-Keyword-BOOL        VALUE 'K', 'V', 'A'.
           88 WS-TT-Token-Is-Lit-Alpha-BOOL      VALUE 'L'.
           88 WS-TT-Token-Is-Lit-Number-BOOL     VALUE 'N'.
           88 WS-TT-Token-Is-Verb-BOOL           VALUE 'V'.
GC1213     88 WS-TT-Token-Is-Reserved-Wd-BOOL    VALUE ' ', 'F'.

       01  WS-Usernames-QTY                      USAGE BINARY-LONG.

       01  WS-Version-TXT                        PIC X(23).

       01  WS-Xref-Detail-Line-TXT.
           05 WS-XDL-Prog-ID-TXT                 PIC X(15).
           05 FILLER                             PIC X(1).
           05 WS-XDL-Token-TXT                   PIC X(32).
           05 FILLER                             PIC X(1).
           05 WS-XDL-Def-Line-NUM                PIC ZZZZZ9.
           05 FILLER                             PIC X(1).
           05 WS-XDL-Section-TXT                 PIC X(15).
           05 FILLER                             PIC X(1).
           05 WS-XDL-Reference-TXT               OCCURS 8 TIMES.
              10 WS-XDL-Ref-Line-NUM             PIC ZZZZZ9.
              10 WS-XDL-Ref-Flag-CHR             PIC X(1).
              10 FILLER                          PIC X(1).

GC1213 01  WS-Xref-Lines-Per-Rec-NUM             PIC 9(1).

       LINKAGE SECTION.
GC0712 01  L-Listing-Fn-TXT                      PIC X(256).

       01  L-Src-Fn-TXT                          PIC X(256).

GC0712 01  L-OS-Type-CD                          PIC 9(1).

GC1213 01  L-LPP-NUM                             USAGE BINARY-LONG.

GC1213 01  L-LPP-Port-NUM                        USAGE BINARY-LONG.

GC1213 01  L-Listing-CD                          PIC 9(1).
      /
GC0712 PROCEDURE DIVISION USING L-Listing-Fn-TXT
GC0712                          L-Src-Fn-TXT
GC0712                          L-OS-Type-CD
GC1213                          L-LPP-NUM
GC1213                          L-LPP-Port-NUM
GC1213                          L-Listing-CD.
       000-Main SECTION.
           PERFORM 100-Initialization
GC0712     OPEN OUTPUT F-Listing-FILE
GC0712     PERFORM 500-Produce-Source-Listing
GC0712     SORT F-Sort-Work-FILE
GC0712         ASCENDING KEY    F-SW-Prog-ID-TXT
GC0712                          F-SW-Token-Uc-TXT
GC0712                          F-SW-Ref-Line-NUM
GC0712         INPUT PROCEDURE  300-Tokenize-Source
GC0712         OUTPUT PROCEDURE 400-Produce-Xref-Listing
GC0712     CLOSE F-Listing-FILE
           GOBACK
           .
      /
      *>***************************************************************
      *> Perform all program-wide initialization operations          **
      *>***************************************************************
       100-Initialization SECTION.
GC1213     MOVE 0 TO WS-Page-NUM
GC1213     MOVE 'N' TO WS-Suppress-FF-CHR
GC1213     MOVE SPACES TO WS-Copyright-TXT
GC1213     STRING 'GCic for '                  DELIMITED SIZE
GC1213            WS-OS-Type-TXT(L-OS-Type-CD) DELIMITED SPACE
GC1213            ' Copyright (C) 2009-2014, Gary L. Cutler, GPL'
GC1213                                         DELIMITED SIZE
GC1213            INTO WS-Copyright-TXT
GC1213     MOVE 'GNU COBOL 2.1 23NOV2013' TO WS-Version-TXT
           MOVE TRIM(L-Src-Fn-TXT,Leading) TO L-Src-Fn-TXT
GC1010     PERFORM VARYING WS-I-SUB FROM LENGTH(L-Src-Fn-TXT) BY -1 *> Locate last directory delimiter character so that the filename can be extracted
GC1010               UNTIL L-Src-Fn-TXT(WS-I-SUB:1) = '/' OR '\'
GC1010                     OR WS-I-SUB = 0
GC1010     END-PERFORM
GC1010     IF WS-I-SUB = 0
GC1010         MOVE UPPER-CASE(L-Src-Fn-TXT) TO WS-Main-Module-Name-TXT *> No directory delimiter, whole thing is filename
GC1010     ELSE
GC1010         ADD 1 TO WS-I-SUB
GC1010         MOVE UPPER-CASE(L-Src-Fn-TXT(WS-I-SUB:))
GC1010           TO WS-Main-Module-Name-TXT *> Extract filename
GC1010     END-IF
GC1213     IF L-Listing-CD = 1 *> LANDSCAPE
GC1213         MOVE 8 TO WS-Xref-Lines-Per-Rec-NUM
GC1213         ACCEPT WS-Lines-Per-Page-Env-TXT
GC1213             FROM ENVIRONMENT 'GCXREF_LINES'
GC1213     ELSE *> PORTRAIT
GC1213         MOVE 3 TO WS-Xref-Lines-Per-Rec-NUM
GC1213         ACCEPT WS-Lines-Per-Page-Env-TXT
GC1213             FROM ENVIRONMENT 'GCXREF_LINES_PORT'
GC1213     END-IF
           INSPECT L-Src-Fn-TXT REPLACING ALL '\' BY '/'
           MOVE L-Src-Fn-TXT TO WS-Program-Path-TXT
           CALL 'C$JUSTIFY' USING WS-Program-Path-TXT, 'Right'
           MOVE LENGTH(TRIM(L-Src-Fn-TXT,Trailing)) TO WS-I-SUB
           MOVE 0 TO WS-J-SUB
           PERFORM UNTIL L-Src-Fn-TXT(WS-I-SUB:1) = '/'
                      OR WS-I-SUB = 0
               SUBTRACT 1 FROM WS-I-SUB
               ADD      1 TO   WS-J-SUB
           END-PERFORM
           UNSTRING L-Src-Fn-TXT((WS-I-SUB + 1):WS-J-SUB)
               DELIMITED BY '.'
               INTO WS-Filename-TXT
                    WS-Dummy-TXT
GC1010     STRING
GC1010            TRIM(WS-Filename-TXT,Trailing)
GC1010            '.i'
GC1010            DELIMITED SIZE
GC1010            INTO WS-Expanded-Src-Fn-TXT
GC1010     CALL 'CBL_CHECK_FILE_EXIST' USING WS-Expanded-Src-Fn-TXT
GC1010                                       WS-Temp-256-Chars-TXT
GC1010     IF RETURN-CODE NOT = 0
GC1010         GOBACK
GC1010     END-IF
           IF WS-Lines-Per-Page-Env-TXT NOT = SPACES
               MOVE NUMVAL(WS-Lines-Per-Page-Env-TXT)
                 TO WS-Lines-Per-Page-NUM
           ELSE
GC1213         IF L-LISTING-CD = 1 *> LANDSCAPE
GC1213             MOVE L-LPP-NUM TO WS-Lines-Per-Page-NUM
GC1213         ELSE                *> PORTRAIT
GC1213             MOVE L-LPP-Port-NUM TO WS-Lines-Per-Page-NUM
GC1213         END-IF
           END-IF
GC1213     SUBTRACT 3 FROM WS-Lines-Per-Page-NUM *> FOR PAGE FOOTER
           ACCEPT WS-Today-DT FROM DATE YYYYMMDD
GC1213     MOVE WS-Today-DT TO WS-Formatted-DT
           MOVE '????????????...' TO WS-Curr-Prog-ID-TXT
           MOVE SPACES            TO WS-Curr-Verb-TXT
                                     WS-Held-Reference-TXT
           .
      /
       300-Tokenize-Source SECTION.
           OPEN INPUT F-Expanded-Src-FILE
           MOVE SPACES TO F-Expanded-Src-REC
           MOVE 256 TO WS-Src-SUB
           MOVE 0 TO WS-Usernames-QTY
                     WS-Curr-Line-NUM
           MOVE '?' TO WS-Curr-Division-TXT
GC0710     MOVE 'N' TO WS-RS-Verb-Has-Been-Found-CHR
           PERFORM FOREVER
               PERFORM 310-Get-Token
               IF WS-TT-Token-Is-EOF-BOOL
                   EXIT PERFORM
               END-IF
               MOVE UPPER-CASE(WS-Token-Curr-TXT)
                 TO WS-Token-Curr-Uc-TXT
GC1010         IF WS-TT-Token-Is-Keyword-BOOL
GC1010         OR WS-TT-Token-Is-Reserved-Wd-BOOL
GC1010             MOVE WS-Token-Curr-Uc-TXT TO WS-Token-Curr-TXT
GC1010         END-IF
               IF WS-TT-Token-Is-Verb-BOOL
                   MOVE WS-Token-Curr-Uc-TXT TO WS-Curr-Verb-TXT
                                                WS-Token-Prev-TXT
                   IF WS-Held-Reference-TXT NOT = SPACES
                       MOVE WS-Held-Reference-TXT TO F-Sort-Work-REC
                       MOVE SPACES         TO WS-Held-Reference-TXT
                       RELEASE F-Sort-Work-REC
                   END-IF
               END-IF
               EVALUATE TRUE
               WHEN WS-CD-In-IDENT-DIV-BOOL
                   PERFORM 320-IDENTIFICATION-DIVISION
               WHEN WS-CD-In-ENV-DIV-BOOL
                   PERFORM 330-ENVIRONMENT-DIVISION
               WHEN WS-CD-In-DATA-DIV-BOOL
                   PERFORM 340-DATA-DIVISION
               WHEN WS-CD-In-PROC-DIV-BOOL
                   PERFORM 350-PROCEDURE-DIVISION
               END-EVALUATE
               IF WS-TT-Token-Is-Keyword-BOOL
                   MOVE WS-Token-Curr-Uc-TXT TO WS-Token-Prev-TXT
               END-IF
               IF WS-RS-Token-Ended-Sentence-CHR = 'Y'
               AND WS-Curr-Division-TXT NOT = 'I'
                   MOVE SPACES TO WS-Token-Prev-TXT
                                  WS-Curr-Verb-TXT
               END-IF

           END-PERFORM
           CLOSE F-Expanded-Src-FILE
           .
      /
       310-Get-Token SECTION.
      *>-- Position to 1st non-blank character
           MOVE WS-RS-Token-Ended-Sentence-CHR
             TO WS-RS-Last-Token-Ended-Sent-CHR
           MOVE 'N' TO WS-RS-Token-Ended-Sentence-CHR
           PERFORM UNTIL F-Expanded-Src-REC(WS-Src-SUB : 1) NOT = SPACE
               IF WS-Src-SUB > 255
                   READ F-Expanded-Src-FILE AT END
                       IF WS-Held-Reference-TXT NOT = SPACES
                           MOVE WS-Held-Reference-TXT TO F-Sort-Work-REC
                           MOVE SPACES         TO WS-Held-Reference-TXT
                           RELEASE F-Sort-Work-REC
                       END-IF
                       SET WS-TT-Token-Is-EOF-BOOL TO TRUE
                       MOVE 0 TO WS-Curr-Line-NUM
                       EXIT SECTION
                   END-READ
GC0712             IF F-ES-1-7-TXT NOT = '#DEFLIT'
GC0712                 IF F-ES-1-CHR = '#'
GC0712                     PERFORM 311-Control-Record
GC0712                 ELSE
GC0712                     PERFORM 312-Expanded-Src-Record
GC0712                 END-IF
GC0712             END-IF
               ELSE
                   ADD 1 TO WS-Src-SUB
               END-IF
           END-PERFORM
      *>-- Extract token string
           MOVE F-Expanded-Src-REC(WS-Src-SUB : 1)
             TO WS-Curr-CHR
           MOVE F-Expanded-Src-REC(WS-Src-SUB + 1: 1)
             TO WS-Next-CHR
           IF WS-Curr-CHR = '.'
               ADD 1 TO WS-Src-SUB
               MOVE WS-Curr-CHR TO WS-Token-Curr-TXT
               MOVE SPACE TO WS-Token-Type-CD
               MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
               EXIT SECTION
           END-IF
           IF WS-Curr-Char-Is-Punct-BOOL
           AND WS-Curr-CHR = '='
           AND WS-Curr-Division-TXT = 'P'
               ADD 1 TO WS-Src-SUB
               MOVE 'EQUALS' TO WS-Token-Curr-TXT
               MOVE 'K'      TO WS-Token-Type-CD
               EXIT SECTION
           END-IF
           IF WS-Curr-Char-Is-Punct-BOOL *> So subscripts don't get flagged w/ '*'
           AND WS-Curr-CHR = '('
           AND WS-Curr-Division-TXT = 'P'
               MOVE SPACES TO WS-Token-Prev-TXT
           END-IF
           IF WS-Curr-Char-Is-Punct-BOOL
               ADD 1 TO WS-Src-SUB
               MOVE WS-Curr-CHR TO WS-Token-Curr-TXT
               MOVE SPACE TO WS-Token-Type-CD
               EXIT SECTION
           END-IF
           IF WS-Curr-Char-Is-Quote-BOOL
               ADD 1 TO WS-Src-SUB
               UNSTRING F-Expanded-Src-REC
                   DELIMITED BY WS-Curr-CHR
                   INTO WS-Token-Curr-TXT
                   WITH POINTER WS-Src-SUB
               IF F-Expanded-Src-REC(WS-Src-SUB : 1) = '.'
                   MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
                   ADD 1 TO WS-Src-SUB
               END-IF
               SET WS-TT-Token-Is-Lit-Alpha-BOOL TO TRUE
               EXIT SECTION
           END-IF
           IF WS-Curr-Char-Is-X-BOOL AND WS-Next-Char-Is-Quote-BOOL
               ADD 2 TO WS-Src-SUB
               UNSTRING F-Expanded-Src-REC
                   DELIMITED BY WS-Next-CHR
                   INTO WS-Token-Curr-TXT
                   WITH POINTER WS-Src-SUB
               IF F-Expanded-Src-REC(WS-Src-SUB : 1) = '.'
                   MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
                   ADD 1 TO WS-Src-SUB
               END-IF
               SET WS-TT-Token-Is-Lit-Number-BOOL TO TRUE
               EXIT SECTION
           END-IF
           IF WS-Curr-Char-Is-Z-BOOL AND WS-Next-Char-Is-Quote-BOOL
               ADD 2 TO WS-Src-SUB
               UNSTRING F-Expanded-Src-REC
                   DELIMITED BY WS-Next-CHR
                   INTO WS-Token-Curr-TXT
                   WITH POINTER WS-Src-SUB
               IF F-Expanded-Src-REC(WS-Src-SUB : 1) = '.'
                   MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
                   ADD 1 TO WS-Src-SUB
               END-IF
               SET WS-TT-Token-Is-Lit-Alpha-BOOL TO TRUE
               EXIT SECTION
           END-IF
           IF WS-RS-Processing-PICTURE-CHR = 'Y'
               UNSTRING F-Expanded-Src-REC
                   DELIMITED BY '. ' OR ' '
                   INTO WS-Token-Curr-TXT
                   DELIMITER IN WS-Delim-TXT
                   WITH POINTER WS-Src-SUB
               IF WS-Delim-TXT = '. '
                   MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
                   ADD 1 TO WS-Src-SUB
               END-IF
               IF UPPER-CASE(WS-Token-Curr-TXT) = 'IS'
                   MOVE SPACE TO WS-Token-Type-CD
                   EXIT SECTION
               ELSE
                   MOVE 'N' TO WS-RS-Processing-PICTURE-CHR
                   MOVE SPACE TO WS-Token-Type-CD
                   EXIT SECTION
               END-IF
           END-IF
           UNSTRING F-Expanded-Src-REC
               DELIMITED BY '. ' OR ' ' OR '=' OR '(' OR ')' OR '*'
                                 OR '/' OR '&' OR ';' OR ',' OR '<'
                                 OR '>' OR ':'
               INTO WS-Token-Curr-TXT
               DELIMITER IN WS-Delim-TXT
               WITH POINTER WS-Src-SUB
           IF WS-Delim-TXT = '. '
               MOVE 'Y' TO WS-RS-Token-Ended-Sentence-CHR
           END-IF
           IF WS-Delim-TXT NOT = '. ' AND ' '
               SUBTRACT 1 FROM WS-Src-SUB
           END-IF
      *>-- Classify Token
           MOVE UPPER-CASE(WS-Token-Curr-TXT) TO WS-Token-Search-TXT
           IF WS-Token-Search-TXT = 'EQUAL' OR 'EQUALS'
               MOVE 'EQUALS' TO WS-Token-Curr-TXT
               MOVE 'K'      TO WS-Token-Type-CD
               EXIT SECTION
           END-IF
           SEARCH ALL WS-Reserved-Word-TXT
               WHEN WS-RW-Word-TXT (WS-RW-IDX) = WS-Token-Search-TXT
                   MOVE WS-RW-Type-CD (WS-RW-IDX) TO WS-Token-Type-CD
GC0710             IF WS-TT-Token-Is-Verb-BOOL
GC0710                 MOVE 'Y' TO WS-RS-Verb-Has-Been-Found-CHR
GC0710             END-IF
                   EXIT SECTION
           END-SEARCH
      *>-- Not a reserved word, must be a user name
           SET WS-TT-Token-Is-Identifier-BOOL TO TRUE
           PERFORM 313-Check-For-Numeric-Token
           IF WS-TT-Token-Is-Lit-Number-BOOL
               IF  (WS-RS-Last-Token-Ended-Sent-CHR = 'Y')
               AND (WS-Curr-Division-TXT = 'D')
                   MOVE 'LEVEL #' TO WS-Token-Curr-TXT
                   MOVE 'K'       TO WS-Token-Type-CD
                   EXIT SECTION
               ELSE
                   EXIT SECTION
               END-IF
           END-IF
           .
      /
       311-Control-Record SECTION.
           UNSTRING F-ES-2-256-TXT-256
               DELIMITED BY '"'
               INTO WS-Temp-10-Chars-TXT
                    WS-Temp-256-Chars-TXT
                    WS-Dummy-TXT
           INSPECT WS-Temp-10-Chars-TXT REPLACING ALL '"' BY SPACE
GC0712     IF WS-Temp-10-Chars-TXT(1:4) = 'line'
GC0712         MOVE SPACES TO WS-Temp-10-Chars-TXT(1:4)
GC0712     END-IF
           COMPUTE WS-I-SUB = NUMVAL(WS-Temp-10-Chars-TXT) - 1
GC1010     IF UPPER-CASE(TRIM(WS-Temp-256-Chars-TXT,Trailing)) =
GC1010        TRIM(WS-Main-Module-Name-TXT)
               MOVE WS-I-SUB TO WS-Curr-Line-NUM
               SET WS-RS-In-Main-Module-BOOL TO TRUE
               IF WS-Saved-Section-TXT NOT = SPACES
                   MOVE WS-Saved-Section-TXT TO WS-Curr-Section-TXT
               END-IF
           ELSE
               SET WS-RS-In-Copybook-BOOL TO TRUE
               IF WS-Saved-Section-TXT = SPACES
                   MOVE WS-Curr-Section-TXT TO WS-Saved-Section-TXT
               END-IF
               MOVE LENGTH(TRIM(WS-Temp-256-Chars-TXT,Trailing))
                 TO WS-I-SUB
               MOVE 0 TO WS-J-SUB
               PERFORM UNTIL WS-Temp-256-Chars-TXT(WS-I-SUB:1) = '/'
                          OR WS-I-SUB = 0
                   SUBTRACT 1 FROM WS-I-SUB
                   ADD      1 TO   WS-J-SUB
               END-PERFORM
               UNSTRING WS-Temp-256-Chars-TXT((WS-I-SUB + 1):WS-J-SUB)
                   DELIMITED BY '.'
                   INTO WS-Filename-TXT
                        WS-Dummy-TXT
               MOVE '['      TO WS-CS-1-CHR
               MOVE WS-Filename-TXT TO WS-CS-2-14-TXT
               IF WS-CS-11-14-TXT NOT = SPACES
                   MOVE '...' TO WS-CS-11-14-TXT
               END-IF
               MOVE ']'      TO WS-CS-15-CHR
           END-IF
           MOVE SPACES TO F-Expanded-Src-REC *> Force another READ
           MOVE 256    TO WS-Src-SUB
           .
      /
       312-Expanded-Src-Record SECTION.
GC0314     IF F-Expanded-Src-REC(1:1) = SPACE
GC0314         MOVE 2 TO WS-Src-SUB
GC0314     ELSE
GC0314         MOVE 1 TO WS-Src-SUB
GC0314     END-IF
           IF WS-RS-In-Main-Module-BOOL
               ADD 1 To WS-Curr-Line-NUM
           END-IF
           .
      /
       313-Check-For-Numeric-Token SECTION.
           MOVE WS-Token-Curr-TXT TO WS-Temp-32-Chars-1-TXT
           INSPECT WS-Temp-32-Chars-1-TXT
GC0711         CONVERTING '0123456789' TO SPACES
GC0711     IF WS-Temp-32-Chars-1-TXT = SPACES                      *> Simple Unsigned Integer
               SET WS-TT-Token-Is-Lit-Number-BOOL TO TRUE
               EXIT SECTION
           END-IF
GC0711     MOVE SPACES TO WS-Temp-32-Chars-2-TXT
GC0711                    WS-Temp-32-Chars-3-TXT
GC0711                    WS-Dummy-TXT
GC0711     UNSTRING WS-Temp-32-Chars-1-TXT
GC0711         DELIMITED BY 'e' OR 'E'
GC0711         INTO WS-Temp-32-Chars-2-TXT
GC0711              WS-Temp-32-Chars-3-TXT
GC0711              WS-Dummy-TXT
GC0711     IF WS-Dummy-TXT NOT = SPACES                    *> More than one 'E' - Not Numeric
GC0711         EXIT SECTION
GC0711     END-IF
GC0711     IF WS-Temp-32-Chars-2-TXT(1:1) = '+' OR '-'
GC0711         MOVE SPACE TO WS-Temp-32-Chars-2-TXT(1:1)
GC0711     END-IF
GC0711     IF WS-Temp-32-Chars-3-TXT(1:1) = '+' OR '-'
GC0711         MOVE SPACE TO WS-Temp-32-Chars-3-TXT(1:1)
GC0711     END-IF
           MOVE 0 TO WS-Tally-QTY
GC0711     INSPECT WS-Temp-32-Chars-2-TXT
               TALLYING WS-Tally-QTY FOR ALL '.'
           IF WS-Tally-QTY = 1
GC0711         INSPECT WS-Temp-32-Chars-2-TXT REPLACING ALL '.' BY SPACE
           END-IF
GC0711     INSPECT WS-Temp-32-Chars-3-TXT
GC0711         TALLYING WS-Tally-QTY FOR ALL '.'
GC0711     IF WS-Tally-QTY = 1
GC0711         INSPECT WS-Temp-32-Chars-3-TXT REPLACING ALL '.' BY SPACE
GC0711     END-IF
GC0711     IF WS-Temp-32-Chars-2-TXT = SPACES AND WS-Temp-32-Chars-3-TXT = SPACES
               SET WS-TT-Token-Is-Lit-Number-BOOL TO TRUE
               EXIT SECTION
           END-IF
           .
      /
       320-IDENTIFICATION-DIVISION SECTION.
GC0712     IF WS-TT-Token-Is-Argtype-BOOL
GC0712         SET WS-TT-Token-Is-Reserved-Wd-BOOL TO TRUE
GC0712     END-IF
GC0710     MOVE 'N' TO WS-RS-Verb-Has-Been-Found-CHR
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'DIVISION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Division-TXT
               EXIT SECTION
           END-IF
GC0712     IF WS-Token-Prev-TXT = 'PROGRAM-ID' OR 'FUNCTION-ID'
               MOVE SPACES TO WS-Token-Prev-TXT
               MOVE WS-Token-Curr-TXT TO WS-Curr-Prog-ID-TXT
GC0712         IF WS-CPI-16-CHR NOT = SPACES
                   MOVE '...' TO WS-CPI-13-15-TXT
               END-IF
               EXIT SECTION
           END-IF
           .
      /
       330-ENVIRONMENT-DIVISION SECTION.
GC0712     IF WS-TT-Token-Is-Argtype-BOOL
GC0712         SET WS-TT-Token-Is-Reserved-Wd-BOOL TO TRUE
GC0712     END-IF
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'DIVISION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Division-TXT
               EXIT SECTION
           END-IF
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'SECTION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Section-TXT
               EXIT SECTION
           END-IF
           IF WS-TT-Token-Is-Identifier-BOOL
GC0712         IF WS-Token-Prev-TXT = 'FUNCTION'
GC0712             PERFORM 360-Release-Def
GC0712         ELSE
GC0712             PERFORM 361-Release-Ref
GC0712         END-IF
           END-IF
GC1213     IF WS-TT-Token-Is-Function-BOOL
GC1213         PERFORM 361-Release-Ref
GC1213     END-IF
           .
      /
       340-DATA-DIVISION SECTION.
GC0712     IF WS-TT-Token-Is-Argtype-BOOL
GC0712         SET WS-TT-Token-Is-Reserved-Wd-BOOL TO TRUE
GC0712     END-IF
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'DIVISION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Division-TXT
               EXIT SECTION
           END-IF
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'SECTION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Section-TXT
               EXIT SECTION
           END-IF
           IF  (WS-Token-Curr-TXT = 'PIC' OR 'PICTURE')
           AND (WS-TT-Token-Is-Keyword-BOOL)
               MOVE 'Y' TO WS-RS-Processing-PICTURE-CHR
               EXIT SECTION
           END-IF
GC0710     IF WS-TT-Token-Is-Reserved-Wd-BOOL
GC0710     AND WS-Token-Prev-TXT = 'LEVEL #'
GC0710         MOVE SPACES TO WS-Token-Prev-TXT
GC0710         EXIT SECTION
GC0710     END-IF
           IF WS-TT-Token-Is-Identifier-BOOL
               EVALUATE WS-Token-Prev-TXT
               WHEN 'FD'
                   PERFORM 360-Release-Def
                   MOVE SPACES TO WS-Token-Prev-TXT
GC1213         WHEN 'RD'
GC1213             PERFORM 360-Release-Def
GC1213             MOVE SPACES TO WS-Token-Prev-TXT
               WHEN 'SD'
                   PERFORM 360-Release-Def
                   MOVE SPACES TO WS-Token-Prev-TXT
               WHEN 'LEVEL #'
                   PERFORM 360-Release-Def
                   MOVE SPACES TO WS-Token-Prev-TXT
               WHEN 'INDEXED'
                   PERFORM 360-Release-Def
                   MOVE SPACES TO WS-Token-Prev-TXT
               WHEN 'USING'
                   PERFORM 362-Release-Upd
                   MOVE SPACES TO WS-Token-Prev-TXT
               WHEN 'INTO'
                   PERFORM 362-Release-Upd
                   MOVE SPACES TO WS-Token-Prev-TXT
               WHEN OTHER
GC1213             IF WS-Token-Curr-TXT NOT = 'SUM'
GC1213                 PERFORM 361-Release-Ref
GC1213             END-IF
               END-EVALUATE
               EXIT SECTION
           END-IF
           .
      /
       350-PROCEDURE-DIVISION SECTION.
           IF WS-Curr-Section-TXT NOT = 'PROCEDURE'
               MOVE 'PROCEDURE' TO WS-Curr-Section-TXT
           END-IF
GC0710     IF WS-Token-Curr-Uc-TXT = 'PROGRAM'
GC0710     AND WS-Token-Prev-TXT = 'END'
GC0710         MOVE '?' TO WS-Curr-Division-TXT
GC0710         EXIT SECTION
GC0710     END-IF
           IF WS-TT-Token-Is-Keyword-BOOL
           AND WS-Token-Curr-TXT = 'DIVISION'
               MOVE WS-Token-Prev-TXT TO WS-Curr-Division-TXT
               EXIT SECTION
           END-IF
GC0313     IF WS-TT-Token-Is-Identifier-BOOL
GC0313     AND WS-Token-Prev-TXT = SPACES
GC0313     AND WS-Curr-Verb-TXT = SPACES
GC0313*> ----- Definition of a Paragraph or Section
GC0313         PERFORM 360-Release-Def
GC0313         MOVE SPACES TO WS-Token-Prev-TXT
GC0313         EXIT SECTION
GC0313     END-IF
           IF NOT WS-TT-Token-Is-Identifier-BOOL
               EXIT SECTION
           END-IF
           EVALUATE WS-Curr-Verb-TXT
           WHEN 'ACCEPT'
               PERFORM 351-ACCEPT
           WHEN 'ADD'
               PERFORM 351-ADD
           WHEN 'ALLOCATE'
               PERFORM 351-ALLOCATE
           WHEN 'CALL'
               PERFORM 351-CALL
           WHEN 'COMPUTE'
               PERFORM 351-COMPUTE
           WHEN 'DIVIDE'
               PERFORM 351-DIVIDE
           WHEN 'FREE'
               PERFORM 351-FREE
GC1213     WHEN 'GENERATE'
GC1213         PERFORM 351-GENERATE
           WHEN 'INITIALIZE'
               PERFORM 351-INITIALIZE
GC1213     WHEN 'INITIATE'
GC1213         PERFORM 351-GENERATE
           WHEN 'INSPECT'
               PERFORM 351-INSPECT
           WHEN 'MOVE'
               PERFORM 351-MOVE
           WHEN 'MULTIPLY'
               PERFORM 351-MULTIPLY
           WHEN 'PERFORM'
               PERFORM 351-PERFORM
           WHEN 'SET'
               PERFORM 351-SET
           WHEN 'STRING'
               PERFORM 351-STRING
           WHEN 'SUBTRACT'
               PERFORM 351-SUBTRACT
GC1213     WHEN 'TERMINATE'
GC1213         PERFORM 351-GENERATE
           WHEN 'TRANSFORM'
               PERFORM 351-TRANSFORM
           WHEN 'UNSTRING'
               PERFORM 351-UNSTRING
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .
      /
       351-ACCEPT SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'ACCEPT'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-ADD SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'GIVING'
               PERFORM 362-Release-Upd
           WHEN 'TO'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-ALLOCATE SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'ALLOCATE'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN 'RETURNING'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-CALL SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'RETURNING'
               PERFORM 362-Release-Upd
           WHEN 'GIVING'
               PERFORM 362-Release-Upd
           WHEN OTHER
GC1213        PERFORM 365-Release-Arg
           END-EVALUATE
           .

       351-COMPUTE SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'COMPUTE'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-DIVIDE SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'INTO'
               PERFORM 363-Set-Upd
               MOVE F-Sort-Work-REC TO WS-Held-Reference-TXT
           WHEN 'GIVING'
               IF WS-Held-Reference-TXT NOT = SPACES
                   MOVE WS-Held-Reference-TXT To F-Sort-Work-REC
                   MOVE SPACES         To WS-Held-Reference-TXT
                                          F-SW-Ref-Flag-CHR
                   RELEASE F-Sort-Work-REC
               END-IF
               PERFORM 362-Release-Upd
           WHEN 'REMAINDER'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-FREE SECTION.
           PERFORM 362-Release-Upd
           .

GC1213 351-GENERATE SECTION.
GC1213     PERFORM 362-Release-Upd
GC1213     .

       351-INITIALIZE SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'INITIALIZE'
               PERFORM 362-Release-Upd
           WHEN 'REPLACING'
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

GC1213 351-INITIATE SECTION.
GC1213     PERFORM 362-Release-Upd
GC1213     .

       351-INSPECT SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'INSPECT'
               PERFORM 364-Set-Ref
               MOVE SPACES TO WS-Held-Reference-TXT
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN 'TALLYING'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN 'REPLACING'
               IF WS-Held-Reference-TXT NOT = SPACES
                   MOVE WS-Held-Reference-TXT TO F-Sort-Work-REC
                   MOVE SPACES         TO WS-Held-Reference-TXT
                   MOVE '*'            TO F-SW-Ref-Flag-CHR
                   RELEASE F-Sort-Work-REC
               END-IF
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN 'CONVERTING'
               IF WS-Held-Reference-TXT NOT = SPACES
                   MOVE WS-Held-Reference-TXT TO F-Sort-Work-REC
                   MOVE SPACES         TO WS-Held-Reference-TXT
                   MOVE '*'            TO F-SW-Ref-Flag-CHR
                   RELEASE F-Sort-Work-REC
               END-IF
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
          .

       351-MOVE SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'TO'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-MULTIPLY SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'BY'
               PERFORM 363-Set-Upd
               MOVE F-Sort-Work-REC TO WS-Held-Reference-TXT
           WHEN 'GIVING'
               MOVE WS-Held-Reference-TXT TO F-Sort-Work-REC
               MOVE SPACES         TO WS-Held-Reference-TXT
                                      F-SW-Ref-Flag-CHR
               RELEASE F-Sort-Work-REC
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-PERFORM SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'VARYING'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN 'AFTER'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-SET SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'SET'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-STRING SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'INTO'
               PERFORM 362-Release-Upd
           WHEN 'POINTER'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-SUBTRACT SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'GIVING'
               PERFORM 362-Release-Upd
           WHEN 'FROM'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

GC1213 351-TERMINATE SECTION.
GC1213     PERFORM 362-Release-Upd
GC1213     .

       351-TRANSFORM SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'TRANSFORM'
               PERFORM 362-Release-Upd
               MOVE SPACES TO WS-Token-Prev-TXT
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       351-UNSTRING SECTION.
           EVALUATE WS-Token-Prev-TXT
           WHEN 'INTO'
               PERFORM 362-Release-Upd
           WHEN 'DELIMITER'
               PERFORM 362-Release-Upd
           WHEN 'COUNT'
               PERFORM 362-Release-Upd
           WHEN 'POINTER'
               PERFORM 362-Release-Upd
           WHEN 'TALLYING'
               PERFORM 362-Release-Upd
           WHEN OTHER
               PERFORM 361-Release-Ref
           END-EVALUATE
           .

       360-Release-Def SECTION.
           MOVE SPACES                 TO F-Sort-Work-REC
           MOVE WS-Curr-Prog-ID-TXT    TO F-SW-Prog-ID-TXT
           MOVE WS-Token-Curr-Uc-TXT   TO F-SW-Token-Uc-TXT
           MOVE WS-Token-Curr-TXT      TO F-SW-Token-TXT
           MOVE WS-Curr-Section-TXT    TO F-SW-Section-TXT
           MOVE WS-Curr-Line-NUM       TO F-SW-Def-Line-NUM
           MOVE 0                      TO F-SW-Ref-Line-NUM
           RELEASE F-Sort-Work-REC
           .

       361-Release-Ref SECTION.
           PERFORM 364-Set-Ref
           RELEASE F-Sort-Work-REC
           .

       362-Release-Upd SECTION.
           PERFORM 363-Set-Upd
           RELEASE F-Sort-Work-REC
           .

       363-Set-Upd SECTION.
           MOVE SPACES                 TO F-Sort-Work-REC
           MOVE WS-Curr-Prog-ID-TXT    TO F-SW-Prog-ID-TXT
           MOVE WS-Token-Curr-Uc-TXT   TO F-SW-Token-Uc-TXT
           MOVE WS-Token-Curr-TXT      TO F-SW-Token-TXT
           MOVE WS-Curr-Section-TXT    TO F-SW-Section-TXT
           MOVE WS-Curr-Line-NUM       TO F-SW-Ref-Line-NUM
           MOVE '*'                    TO F-SW-Ref-Flag-CHR
           .

       364-Set-Ref SECTION.
           MOVE SPACES                 TO F-Sort-Work-REC
           MOVE WS-Curr-Prog-ID-TXT    TO F-SW-Prog-ID-TXT
           MOVE WS-Token-Curr-Uc-TXT   TO F-SW-Token-Uc-TXT
           MOVE WS-Token-Curr-TXT      TO F-SW-Token-TXT
           MOVE WS-Curr-Section-TXT    TO F-SW-Section-TXT
           MOVE WS-Curr-Line-NUM       TO F-SW-Ref-Line-NUM
           .

GC1213 365-Release-Arg SECTION.
GC1213     PERFORM 366-Set-Arg
GC1213     RELEASE F-Sort-Work-REC
GC1213     .

GC1213 366-Set-Arg SECTION.
GC1213     MOVE SPACES                 TO F-Sort-Work-REC
GC1213     MOVE WS-Curr-Prog-ID-TXT    TO F-SW-Prog-ID-TXT
GC1213     MOVE WS-Token-Curr-Uc-TXT   TO F-SW-Token-Uc-TXT
GC1213     MOVE WS-Token-Curr-TXT      TO F-SW-Token-TXT
GC1213     MOVE WS-Curr-Section-TXT    TO F-SW-Section-TXT
GC1213     MOVE WS-Curr-Line-NUM       TO F-SW-Ref-Line-NUM
GC1213     MOVE 'C'                    TO F-SW-Ref-Flag-CHR
GC1213     .

      /
       400-Produce-Xref-Listing SECTION.
           MOVE SPACES       TO WS-Xref-Detail-Line-TXT
                                WS-Group-Indicators-TXT
           MOVE 0            TO WS-I-SUB
                                WS-Lines-Left-NUM
GC0710     MOVE 'N'          TO WS-RS-Duplicate-CHR
           PERFORM FOREVER
               RETURN F-Sort-Work-FILE AT END
GC1213             IF WS-Xref-Detail-Line-TXT NOT = SPACES
GC1213                 PERFORM 410-Generate-Report-Line
GC1213             END-IF
GC1213             MOVE SPACES TO WS-Xref-Detail-Line-TXT
GC1213             PERFORM 410-Generate-Report-Line
GC1213                 UNTIL WS-Lines-Left-NUM = 0
GC1213             MOVE 'Y' TO WS-Suppress-FF-CHR
GC1213             PERFORM 420-Generate-Xref-Footer
                   EXIT PERFORM
               END-RETURN
               IF F-SW-Prog-ID-TXT  NOT = WS-GI-Prog-ID-TXT
               OR F-SW-Token-Uc-TXT NOT = WS-GI-Token-TXT
GC0710             MOVE 'N' TO WS-RS-Duplicate-CHR
                   IF WS-Xref-Detail-Line-TXT NOT = SPACES
                       PERFORM 410-Generate-Report-Line
                   END-IF
                   IF F-SW-Prog-ID-TXT NOT = WS-GI-Prog-ID-TXT
GC1213                 MOVE SPACES TO WS-Xref-Detail-Line-TXT
GC1213                 PERFORM 410-Generate-Report-Line
GC1213                     UNTIL WS-Lines-Left-NUM = 0
                   END-IF
                   MOVE F-SW-Prog-ID-TXT  TO WS-GI-Prog-ID-TXT
                   MOVE F-SW-Token-Uc-TXT TO WS-GI-Token-TXT
               END-IF
GC0710         IF F-SW-Token-Uc-TXT = WS-GI-Token-TXT
GC0710         AND F-SW-Def-Line-NUM NOT = SPACES
GC0710         AND WS-Xref-Detail-Line-TXT NOT = SPACES
GC0710             MOVE 'Y' TO WS-RS-Duplicate-CHR
GC0710             PERFORM 410-Generate-Report-Line
GC0710             MOVE 0 TO WS-I-SUB
GC0710             MOVE F-SW-Prog-ID-TXT TO WS-XDL-Prog-ID-TXT
GC0710             MOVE '  (Duplicate Definition)' TO WS-XDL-Token-TXT
GC0710             MOVE F-SW-Section-TXT TO WS-XDL-Section-TXT
GC0710             MOVE F-SW-Def-Line-NUM TO WS-XDL-Def-Line-NUM
GC0710             EXIT PERFORM CYCLE
GC0710         END-IF
GC0710         IF F-SW-Token-Uc-TXT = WS-GI-Token-TXT
GC0710         AND F-SW-Def-Line-NUM = SPACES
GC0710         AND WS-RS-Duplicate-CHR = 'Y'
GC0710             MOVE 'N' TO WS-RS-Duplicate-CHR
GC0710             PERFORM 410-Generate-Report-Line
GC0710             MOVE 0 TO WS-I-SUB
GC0710             MOVE F-SW-Prog-ID-TXT TO WS-XDL-Prog-ID-TXT
GC0710             MOVE '  (Duplicate References)' TO WS-XDL-Token-TXT
GC0710         END-IF
               IF WS-Xref-Detail-Line-TXT = SPACES
                   MOVE F-SW-Prog-ID-TXT TO WS-XDL-Prog-ID-TXT
                   MOVE F-SW-Token-TXT TO WS-XDL-Token-TXT
                   MOVE F-SW-Section-TXT TO WS-XDL-Section-TXT
                   IF F-SW-Def-Line-NUM NOT = SPACES
                       MOVE F-SW-Def-Line-NUM TO WS-XDL-Def-Line-NUM
                   END-IF
               END-IF
               IF F-SW-Reference-TXT > '000000'
                   ADD 1 TO WS-I-SUB
                   IF WS-I-SUB > WS-Xref-Lines-Per-Rec-NUM
                       PERFORM 410-Generate-Report-Line
                       MOVE 1 TO WS-I-SUB
                   END-IF
                   MOVE F-SW-Ref-Line-NUM
                     TO WS-XDL-Ref-Line-NUM (WS-I-SUB)
                   MOVE F-SW-Ref-Flag-CHR
                     TO WS-XDL-Ref-Flag-CHR (WS-I-SUB)
               END-IF
           END-PERFORM
           IF WS-Xref-Detail-Line-TXT NOT = SPACES
               PERFORM 410-Generate-Report-Line
           END-IF
           .
      /
       410-Generate-Report-Line SECTION.
           IF WS-Lines-Left-NUM < 1
GC1213         PERFORM 420-Generate-Xref-Footer
GC1213         ADD  1           TO WS-Page-NUM
GC1213         MOVE 'Page:'     TO WS-PN-Literal-TXT
GC1213         MOVE WS-Page-NUM TO WS-PN-Page-NUM
GC1213         CALL 'C$JUSTIFY' USING WS-PN-Page-NUM, 'Left'
GC1213         CALL 'C$JUSTIFY' USING WS-Page-No-TXT, 'Right'
GC1213         IF L-Listing-CD = 1 *> LANDSCAPE
GC1213             MOVE WS-Version-TXT
GC1213               TO F-Listing-135-REC
GC1213             MOVE 'Cross-Reference Listing'
GC1213               TO F-Listing-135-REC(25:23)
GC1213             MOVE WS-Formatted-DT
GC1213               TO F-Listing-135-REC(126:10)
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #1
GC1213             MOVE WS-Program-Path-TXT
GC1213               TO F-Listing-135-REC
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #2
GC1213             MOVE 'PROGRAM-ID      Identifier/Register/Function' &
GC1213                  '     Defn   Where Defined   References'
GC1213               TO F-Listing-135-REC
GC1213             MOVE WS-Page-No-TXT
GC1213               TO F-Listing-135-REC(126:10)
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #3
GC1213             MOVE ALL '=' TO F-Listing-135-REC
GC1213             MOVE SPACE TO F-Listing-135-REC(16:1)
GC1213                           F-Listing-135-REC(49:1)
GC1213                           F-Listing-135-REC(56:1)
GC1213                           F-Listing-135-REC(72:1)
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #4
GC1213         ELSE                *> PORTRAIT
GC1213             MOVE WS-Version-TXT
GC1213               TO F-Listing-96-REC
GC1213             MOVE 'Cross-Reference Listing'
GC1213               TO F-Listing-96-REC(25:23)
GC1213             MOVE WS-Formatted-DT
GC1213               TO F-Listing-96-REC(87:10)
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #1
GC1213             MOVE WS-Program-Path-TXT(40:96)
GC1213               TO F-Listing-96-REC
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #2
GC1213             MOVE 'PROGRAM-ID      Identifier/Register/Function' &
GC1213                  '     Defn   Where Defined   References'
GC1213               TO F-Listing-96-REC
GC1213             MOVE WS-Page-No-TXT
GC1213               TO F-Listing-96-REC(87:10)
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #3
GC1213             MOVE ALL '=' TO F-Listing-96-REC
GC1213             MOVE SPACE TO F-Listing-96-REC(16:1)
GC1213                           F-Listing-96-REC(49:1)
GC1213                           F-Listing-96-REC(56:1)
GC1213                           F-Listing-96-REC(72:1)
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #4
GC1213         END-IF
GC1213         COMPUTE WS-Lines-Left-NUM = WS-Lines-Per-Page-NUM - 4
           END-IF
GC1213     IF L-Listing-CD = 1 *> LANDSCAPE
GC1213         WRITE F-Listing-135-REC FROM WS-Xref-Detail-Line-TXT
GC1213             BEFORE 1
GC1213     ELSE                *> PORTRAIT
GC1213         WRITE F-Listing-96-REC FROM WS-Xref-Detail-Line-TXT
GC1213             BEFORE 1
GC1213     END-IF
           MOVE SPACES TO WS-Xref-Detail-Line-TXT
           MOVE 0 TO WS-I-SUB
           SUBTRACT 1 FROM WS-Lines-Left-NUM
           .
GC1213 420-Generate-Xref-Footer SECTION.
GC1213     IF L-Listing-CD = 1 *> LANDSCAPE
GC1213         WRITE F-Listing-135-REC FROM SPACES BEFORE 1 *> Footer Line #1
GC1213         MOVE ALL '='
GC1213           TO F-Listing-135-REC
GC1213         WRITE F-Listing-135-REC BEFORE 1 *> Footer Line #2
GC1213         MOVE WS-Copyright-TXT
GC1213           TO F-Listing-135-REC
GC1213         MOVE WS-Page-No-TXT
GC1213           TO F-Listing-135-REC(126:10)
GC1213         IF WS-Suppress-FF-CHR = 'Y'
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Footer Line #3
GC1213         ELSE
GC1213             WRITE F-Listing-135-REC BEFORE PAGE *> Footer Line #3
GC1213             WRITE F-Listing-135-REC FROM SPACES BEFORE 1 *> Spaces After FF Character
GC1213         END-IF
GC1213     ELSE                *> PORTRAIT
GC1213         WRITE F-Listing-96-REC FROM SPACES BEFORE 1 *> Footer Line #1
GC1213         MOVE ALL '='
GC1213           TO F-Listing-96-REC
GC1213         WRITE F-Listing-96-REC BEFORE 1 *> Footer Line #2
GC1213         MOVE WS-Copyright-TXT
GC1213           TO F-Listing-96-REC
GC1213         MOVE WS-Page-No-TXT
GC1213           TO F-Listing-96-REC(87:10)
GC1213         IF WS-Suppress-FF-CHR = 'Y'
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Footer Line #3
GC1213         ELSE
GC1213             WRITE F-Listing-96-REC BEFORE PAGE *> Footer Line #3
GC1213             WRITE F-Listing-96-REC FROM SPACES BEFORE 1 *> Spaces After FF Character
GC1213         END-IF
GC1213     END-IF
GC1213     .
      /
       500-Produce-Source-Listing SECTION.
           OPEN INPUT F-Original-Src-FILE
                      F-Expanded-Src-FILE
           MOVE 0 TO WS-Src-Line-NUM
           PERFORM FOREVER
               READ F-Expanded-Src-FILE AT END
GC1213             MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             PERFORM 530-Generate-Source-Line
GC1213                 UNTIL WS-Lines-Left-NUM = 0
                   EXIT PERFORM
               END-READ
GC0712         IF F-ES-1-7-TXT NOT = '#DEFLIT'
GC0712             IF F-ES-1-CHR = '#'
GC0712                 PERFORM 510-Control-Record
GC0712             ELSE
GC0712                 PERFORM 520-Expanded-Src-Record
GC0712             END-IF
GC0712         END-IF
           END-PERFORM
           CLOSE F-Original-Src-FILE
                 F-Expanded-Src-FILE
           .
      /
       510-Control-Record SECTION.
           UNSTRING F-ES-2-256-TXT-256
               DELIMITED BY '"'
               INTO WS-Temp-10-Chars-TXT
                    WS-Temp-256-Chars-TXT
                    WS-Dummy-TXT
GC1010     IF UPPER-CASE(TRIM(WS-Temp-256-Chars-TXT,Trailing)) =
GC1010        TRIM(WS-Main-Module-Name-TXT) *> Main Pgm
               SET WS-RS-In-Main-Module-BOOL TO TRUE
               IF WS-Src-Line-NUM > 0
                   READ F-Expanded-Src-FILE END-READ
               END-IF
           ELSE *> COPY
               SET WS-RS-In-Copybook-BOOL TO TRUE
           END-IF
           .
      /
       520-Expanded-Src-Record SECTION.
           IF WS-RS-In-Main-Module-BOOL
               ADD 1 To WS-Curr-Line-NUM
GC0712         READ F-Original-Src-FILE AT END CONTINUE END-READ
               ADD 1 TO WS-Src-Line-NUM
               MOVE SPACES TO WS-Src-Detail-Line-TXT
               MOVE WS-Src-Line-NUM TO WS-SDL-Line-NUM
GC1213         MOVE F-Original-Src-REC TO WS-SDL-Statement-TXT
GC0712         MOVE LOWER-CASE(TRIM(F-OS-8-72-TXT,LEADING))
GC0712           TO WS-Temp-65-Chars-TXT
GC0712         INSPECT WS-Temp-65-Chars-TXT REPLACING ALL '.' BY SPACE
GC0712         EVALUATE TRUE
GC0712             WHEN F-OS-7-CHR = '/'
GC1213                 MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213                 PERFORM 530-Generate-Source-Line
GC1213                     UNTIL WS-Lines-Left-NUM = 0
GC0712             WHEN WS-Temp-65-Chars-TXT = "eject"
GC1213                 MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213                 PERFORM 530-Generate-Source-Line
GC1213                     UNTIL WS-Lines-Left-NUM = 0
GC0712                 EXIT SECTION
GC0712             WHEN WS-Temp-65-Chars-TXT = "skip1"
GC0712                 MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                 PERFORM 530-Generate-Source-Line
GC0712                 EXIT SECTION
GC0712             WHEN WS-Temp-65-Chars-TXT = "skip2"
GC0712                 MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                 PERFORM 530-Generate-Source-Line 2 TIMES
GC0712                 EXIT SECTION
GC0712             WHEN WS-Temp-65-Chars-TXT = "skip3"
GC0712                 MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                 PERFORM 530-Generate-Source-Line 3 TIMES
GC0712                 EXIT SECTION
GC0712         END-EVALUATE
               PERFORM 530-Generate-Source-Line
           ELSE
               IF F-Expanded-Src-REC NOT = SPACES
                   MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             MOVE F-Expanded-Src-REC
                     TO WS-SDL-Statement-TXT
GC0712             MOVE LOWER-CASE(TRIM(F-OS-8-72-TXT,LEADING))
GC0712               TO WS-Temp-65-Chars-TXT
GC0712             INSPECT WS-Temp-65-Chars-TXT
GC0712                 REPLACING ALL '.' BY SPACE
GC0712             EVALUATE TRUE
GC0712                 WHEN WS-Temp-65-Chars-TXT = "eject"
GC0712                     MOVE 0 TO WS-Lines-Left-NUM
GC0712                     EXIT SECTION
GC0712                 WHEN WS-Temp-65-Chars-TXT = "skip1"
GC0712                     MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                     PERFORM 530-Generate-Source-Line
GC0712                     EXIT SECTION
GC0712                 WHEN WS-Temp-65-Chars-TXT = "skip2"
GC0712                     MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                     PERFORM 530-Generate-Source-Line 2 TIMES
GC0712                     EXIT SECTION
GC0712                 WHEN WS-Temp-65-Chars-TXT = "skip3"
GC0712                     MOVE SPACES TO WS-Src-Detail-Line-TXT
GC0712                     PERFORM 530-Generate-Source-Line 3 TIMES
GC0712                     EXIT SECTION
GC0712             END-EVALUATE
                   PERFORM 530-Generate-Source-Line
               END-IF
           END-IF
           .
      /
       530-Generate-Source-Line SECTION.
GC1213     MOVE 1 TO WS-Src-Lines-NUM
GC1213     IF L-Listing-CD = 1 *> LANDSCAPE
GC1213         IF WS-SDL-Statement-TXT(129:128) > SPACES
GC1213             ADD 1 TO WS-Src-Lines-NUM
GC1213         END-IF
GC1213     ELSE                *> PORTRAIT
GC1213         IF WS-SDL-Statement-TXT(90:167) > SPACES
GC1213             ADD 1 TO WS-Src-Lines-NUM
GC1213             IF WS-SDL-Statement-TXT(179:78) > SPACES
GC1213                 ADD 1 TO WS-Src-Lines-NUM
GC1213             END-IF
GC1213         END-IF
GC1213     END-IF
GC1213     IF WS-Lines-Left-NUM < WS-Src-Lines-NUM
GC1213         IF WS-Page-Num > 0 *> Don't print footer before page 1
GC1213             IF L-Listing-CD = 1 *> LANDSCAPE
GC1213                 IF WS-Src-Lines-NUM = 2
GC1213                     WRITE F-Listing-135-REC FROM SPACES BEFORE 1 *> Blank Line
GC1213                 END-IF
GC1213                 WRITE F-Listing-135-REC FROM SPACES BEFORE 1 *> Footer Line #1
GC1213                 MOVE ALL '='
GC1213                   TO F-Listing-135-REC
GC1213                 WRITE F-Listing-135-REC BEFORE 1 *> Footer Line #2
GC1213                 MOVE WS-Copyright-TXT
GC1213                   TO F-Listing-135-REC
GC1213                 MOVE WS-Page-No-TXT
GC1213                   TO F-Listing-135-REC(126:10)
GC1213                 WRITE F-Listing-135-REC BEFORE PAGE *> Footer Line #3
GC1213                 WRITE F-Listing-135-REC FROM SPACES BEFORE 1 *> Spaces After FF Character
GC1213             ELSE                *> PORTRAIT
GC1213                 EVALUATE WS-Src-Lines-NUM
GC1213                 WHEN 1 *> Need no extra blank lines
GC1213                     CONTINUE
GC1213                 WHEN 2 *> Need 1 extra blank line
GC1213                     WRITE F-Listing-96-REC FROM SPACES BEFORE 1
GC1213                 WHEN 3 *> Need 2 extra blank lines
GC1213                     WRITE F-Listing-96-REC FROM SPACES BEFORE 1
GC1213                     WRITE F-Listing-96-REC FROM SPACES BEFORE 1
GC1213                 END-EVALUATE
GC1213                 WRITE F-Listing-96-REC FROM SPACES BEFORE 1 *> Footer Line #1
GC1213                 MOVE ALL '='
GC1213                   TO F-Listing-96-REC
GC1213                 WRITE F-Listing-96-REC BEFORE 1 *> Footer Line #2
GC1213                 MOVE WS-Copyright-TXT
GC1213                   TO F-Listing-96-REC
GC1213                 MOVE WS-Page-No-TXT
GC1213                   TO F-Listing-96-REC(87:10)
GC1213                 WRITE F-Listing-96-REC BEFORE PAGE *> Footer Line #3
GC1213                 WRITE F-Listing-96-REC FROM SPACES BEFORE 1 *> Spaces After FF Character
GC1213             END-IF
GC1213         END-IF
GC1213         ADD  1           TO WS-Page-NUM
GC1213         MOVE 'Page:'     TO WS-PN-Literal-TXT
GC1213         MOVE WS-Page-NUM TO WS-PN-Page-NUM
GC1213         CALL 'C$JUSTIFY' USING WS-PN-Page-NUM, 'Left'
GC1213         CALL 'C$JUSTIFY' USING WS-Page-No-TXT, 'Right'
GC1213         IF L-Listing-CD = 1 *> LANDSCAPE
GC1213             MOVE WS-Version-TXT
GC1213               TO F-Listing-135-REC
GC1213             MOVE 'Source Listing'
GC1213               TO F-Listing-135-REC(25:14)
GC1213             MOVE WS-Formatted-DT
GC1213               TO F-Listing-135-REC(126:10)
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #1
GC1213             MOVE WS-Program-Path-TXT
GC1213               TO F-Listing-135-REC
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #2
GC1213             MOVE 'Line   Statement'
GC1213               TO F-Listing-135-REC
GC1213             MOVE WS-Page-No-TXT
GC1213               TO F-Listing-135-REC(126:10)
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #3
GC1213             MOVE WS-Src-Dashes-TXT
GC1213               TO F-Listing-135-REC
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Page Header Line #4
GC1213         ELSE                *> PORTRAIT
GC1213             MOVE WS-Version-TXT
GC1213               TO F-Listing-96-REC
GC1213             MOVE 'Source Listing'
GC1213               TO F-Listing-96-REC(25:14)
GC1213             MOVE WS-Formatted-DT
GC1213               TO F-Listing-96-REC(87:10)
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #1
GC1213             MOVE WS-Program-Path-TXT(40:96)
GC1213               TO F-Listing-96-REC
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #2
GC1213             MOVE 'Line   Statement'
GC1213               TO F-Listing-96-REC
GC1213             MOVE WS-Page-No-TXT
GC1213               TO F-Listing-96-REC(87:10)
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #3
GC1213             MOVE WS-Src-Dashes-TXT
GC1213               TO F-Listing-96-REC
GC1213             WRITE F-Listing-96-REC BEFORE 1 *> Page Header Line #4
GC1213         END-IF
GC1213         COMPUTE WS-Lines-Left-NUM = WS-Lines-Per-Page-NUM - 4
GC1213     END-IF
GC1213     IF L-Listing-CD = 1 *> LANDSCAPE
GC1213         EVALUATE WS-Src-Lines-NUM
GC1213         WHEN 1
GC1213             MOVE WS-Src-Detail-Line-TXT TO F-Listing-135-REC
GC1213             WRITE F-Listing-96-REC BEFORE 1
GC1213             SUBTRACT 1 FROM WS-Lines-Left-NUM
GC1213         WHEN 2
GC1213             MOVE WS-SDL-Statement-TXT TO WS-Src-Hold-TXT
GC1213             MOVE WS-Src-Detail-Line-TXT TO F-Listing-135-REC
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Prints chars 1-128 of stmnt
GC1213             MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             MOVE WS-Src-Hold-TXT(129:128) TO WS-SDL-Statement-TXT
GC1213             MOVE WS-Src-Detail-Line-TXT TO F-Listing-135-REC
GC1213             WRITE F-Listing-135-REC BEFORE 1 *> Prints chars 129-256 of stmnt
GC1213             SUBTRACT 2 FROM WS-Lines-Left-NUM
GC1213         END-EVALUATE
GC1213     ELSE                *> PORTRAIT
GC1213         EVALUATE WS-Src-Lines-NUM
GC1213         WHEN 1 *> Print only chars 1-89 of stmnt
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             SUBTRACT 1 FROM WS-Lines-Left-NUM
GC1213         WHEN 2 *> Print only chars 1-89 and 90-178 of text
GC1213             MOVE WS-SDL-Statement-TXT TO WS-Src-Hold-TXT
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             MOVE WS-Src-Hold-TXT(90:89) TO WS-SDL-Statement-TXT
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             SUBTRACT 2 FROM WS-Lines-Left-NUM
GC1213         WHEN 3 *> Print chars 1-89, 90-178 and 179-256 of stmnt
GC1213             MOVE WS-SDL-Statement-TXT TO WS-Src-Hold-TXT
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             MOVE WS-Src-Hold-TXT(90:89) TO WS-SDL-Statement-TXT
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             MOVE SPACES TO WS-Src-Detail-Line-TXT
GC1213             MOVE WS-Src-Hold-TXT(179:78) TO WS-SDL-Statement-TXT
GC1213             WRITE F-Listing-96-REC FROM WS-Src-Detail-Line-TXT
GC1213                 BEFORE 1
GC1213             SUBTRACT 3 FROM WS-Lines-Left-NUM
GC1213         END-EVALUATE
GC1213     END-IF
           MOVE SPACES TO WS-Src-Detail-Line-TXT
           .

       END PROGRAM LISTING.
