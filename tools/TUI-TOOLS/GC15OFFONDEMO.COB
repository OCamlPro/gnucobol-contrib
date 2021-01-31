       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
program-id. GC15OFFONDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC15OFFON TUI TOOL -  DISPLAYS & MANAGE OFFON ITEMS ON SCREEN
*> Description: Displays a small group of OFFON items, displays other 3 small groups showing
*>              different options of the tool.
*> Tectonics:  cobc -x GC15OFFONDEMO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC15OFFONDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License LGPL 3.0 (or greater)
*> Version:    1.1 2021.01.15
*> Changelog:  1.0 first version.
*>             1.1 small fixes
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
*> source-computer. WINDOWS10 64bit WITH DEBUGGING MODE.
special-names.
   Currency Sign is '€'.
   Decimal-Point is Comma.
   CRT STATUS    is wCRT-STATUS.      *> Return Code (es. PF, Arrows, TAB, Mouse Keys)
   CURSOR        is wCursorRowCol. *> Cursor Position

DATA DIVISION.
WORKING-STORAGE SECTION.
01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wDummy            pic x(01) VALUE     ' '.
01  wString           pic x(70) VALUE     ' '.
01  i                 pic 999 value zero.
01  y                 pic  99 value 1.
01  wR                pic 999 value zero.

01  wCRT-STATUS         PIC 9(4) value 0.  *> CRT-STATUS codes
01  wCursorRowCol       PIC 9(6) value 0.  *> from CURSOR IS ...
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(3).
    05 wCursorCol       Pic 9(3).

COPY 'GC01BOX.CPY'         suppress.
copy 'GC02BOXMEX.CPY'      suppress.
COPY 'GC15OFFON.CPY'       suppress.
COPY 'GC97KEYCODEGC.CPY'   suppress.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

Start-Display.
  initialize Box-area ALL TO VALUE
    *> display a big box as background
    move blue     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex
    move 2 to Wr
    display 'GnuCOBOL GC15OFFON TUI TOOL. '
            at 0303 with :FCOL: white :BCOL: blue

    perform DisplayHelp thru DisplayHelpEx

    display ' GnuCOBOL GC15OFFON TUI TOOL at work. '
          at 2103 with :FCOL: white :BCOL: blue
    display ' Cursor keys or left mousekey singleclick on item to change active OFFON'
          at 2203 with :FCOL: white :BCOL: blue
    display ' enter/spacebar/left mousekey doubleclick: change OFF/ON. TAB or ESC to exit'
          at 2303 with :FCOL: white :BCOL: blue
    display " Activate an item (give the 'focus to') also with hot keys. F1 = tool HELP  "
          at 2403 with :FCOL: white :BCOL: blue

*> DISPLAY A BOX AS BACKGROUND OF THE SCREEN
set  Box-bco Box-fco to white move '002003020077' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow move 'E' to Box-3D Move 'Y' to Box-tit
move ' Set OFF or ON one or more switches per group ' & x'00' to Box-titDes
perform callGC01BOX thru callGC01BOX-ex

*> *********************************************************************************
*> DISPLAY OFFON NUMBER 1
*> *********************************************************************************
set  Box-bco   Box-fco to white  *> DISPLAY A BOX AS BACKGROUND OF A OFFON ITEMS GROUP
move '003004013046' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display ' Your choice (F1=HELP)' at 003007 with :BCOL: white :FCOL: black end-display

initialize OFFON-area ALL TO VALUE
move low-value  to Oo-tab
*>                 123456789012345678901234567890
Move ' 102004005033 Stop after first error.... ' & x'00' to Oo-Ele(01)
Move ' 102005005033 Allow LABEL and GOTO...... ' & x'00' to Oo-Ele(02)
Move '1 02006005033 Enable macros............. ' & x'00' to Oo-Ele(03)
Move ' 106007005033 Allow inline.............. ' & x'00' to Oo-Ele(04)
Move ' 102008005033 Include assertion code.... ' & x'00' to Oo-Ele(05)
Move ' 102009005033 Load compatible units..... ' & x'00' to Oo-Ele(06)
Move '  08010005033 Allow STATIC in objects... ' & x'00' to Oo-Ele(07)
Move '  02011005033 C like operators.......... ' & x'00' to Oo-Ele(08)
Move ' 103012005033 Conditional defines....... ' & x'00' to Oo-Ele(09)
perform callGC15OFFON thru callGC15OFFON-ex
perform DisplayMarkTable thru DisplayMarkTableEx.

*> *********************************************************************************
*> DISPLAY OFFON ITEMS N.2
*> *********************************************************************************
set  Box-bco   Box-fco to white *> DISPLAY A BOX AS BACKGROUND OF A OFFON ITEMS GROUP
move '003047011076' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display ' Parameters F1=Help ' at 003050 with :BCOL: white :FCOL: black end-display

initialize OFFON-area ALL TO VALUE
move 'x'       to Oo-MarkChar
move '()'      to Oo-BracketChars
move blue to Oo-bcoN Oo-bcoA Oo-bcoH
move cyan to Oo-fcoN
move ' OFF' to Oo-OFF-Descr   *> between OFF and 1st bracket there is no "blank char"
move 'ON  ' to Oo-ON-Descr    *> between 2nd bracket and ON there is no "blank char"
move low-value                             to Oo-tab
*>              12345678901234567890
Move ' 102004048063 Counts        ' & x'00' to Oo-Ele(01)
Move '1102005048063 Percentages   ' & x'00' to Oo-Ele(02)
Move '  02006048063 Valid upperc  ' & x'00' to Oo-Ele(03)
Move ' 102007048063 Error Mess    ' & x'00' to Oo-Ele(04)
Move ' 102008048063 Reserved      ' & x'00' to Oo-Ele(05)
Move ' 103009048063 Colums stats  ' & x'00' to Oo-Ele(06)
Move '  02010048063 Total stats   ' & x'00' to Oo-Ele(07)
perform callGC15OFFON thru callGC15OFFON-ex

perform DisplayMarkTable thru DisplayMarkTableEx.

*> *********************************************************************************
*> DISPLAY OFFON ITEMS N.3
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF A OFFON ITEMS GROUP
set  Box-bco   Box-fco to white move '014004018046' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display ' Options ' at 014007 with :BCOL: white :FCOL: black highlight end-display

initialize OFFON-area ALL TO VALUE
move 'o'  to Oo-MarkChar
move '<>' to Oo-BracketChars
move low-value                                        to Oo-tab
*>              123456789012345678901234567890
Move ' 102015005033 Counts                     ' & x'00' to Oo-Ele(01)
Move '1 02016005033 Percentages                ' & x'00' to Oo-Ele(02)
Move '  02017005033 Valid uppercase            ' & x'00' to Oo-Ele(03)
perform callGC15OFFON thru callGC15OFFON-ex

perform DisplayMarkTable thru DisplayMarkTableEx.

*> DISPLAY OFFON ITEMS N.4
display 'Debugger Preferences ' at 012049 with :BCOL: white :FCOL: black highlight end-display
initialize OFFON-area ALL TO VALUE

move 'o'     to Oo-MarkChar
move blue    to Oo-bcoN Oo-bcoA Oo-bcoH
move yellow  to Oo-fcoN
move red     to Oo-fcoH
move 'Y'     to Oo-fcoNH
move '  NO' to Oo-OFF-Descr
move 'YES ' to Oo-ON-Descr
move low-value                           to Oo-tab
Move '1 00013048063 01-Stop after....' & x'00' to Oo-Ele(01)
Move ' 100014048063 02-Allow LABEL...' & x'00' to Oo-Ele(02)
Move '  00015048063 03-Enable macro..' & x'00' to Oo-Ele(03)
Move '  00016048063 03-Disable.......' & x'00' to Oo-Ele(04)
Move ' 100017048063 04-Overnight.....' & x'00' to Oo-Ele(05)
Move ' 100017048063 05-Include.......' & x'00' to Oo-Ele(06)
Move ' 100017048063 06-Load units....' & x'00' to Oo-Ele(07)
Move '  00017048063 07-Allow STAT....' & x'00' to Oo-Ele(08)
Move '  00017048063 08-C like........' & x'00' to Oo-Ele(09)
Move ' 100017048063 09-Overlapped....' & x'00' to Oo-Ele(10)
perform callGC15OFFON thru callGC15OFFON-ex

perform DisplayMarkTable thru DisplayMarkTableEx.
accept wDummy at 2479
DISPLAY ' ESC = return to previous screen, Enter to select and Exit '
         AT 001003 with :FCOL: yellow :BCOL: blue highlight

if Oo-Key = K-ESCAPE go to Start-Display end-if

*> ***********************************************************************************************
*> DISPLAY ITALIAN FLAG
*> ***********************************************************************************************
    initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex

    display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC15OFFON at work.'
             at 003003 with      :FCOL: white :BCOL: cyan
    display ' < End of Demo > ... Enter to exit ...'
             at 023003 with      :FCOL: white :BCOL: cyan
    move '009035014048' to Box-rc
    move black to Box-bco
    move 'S' to Box-style
    perform callGC01BOX thru callGC01BOX-ex

   display '    ' at 010036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 011036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 012036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 013036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 010040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 011040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 012040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 013040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 010044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 011044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 012044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 013044 with blink :FCOL: white :BCOL: red   end-display
   accept wDummy at 2479

   continue.
END-OF-PROGRAM.
   goback.

*> *********************************************************************************
*>
*> *********************************************************************************
DisplayMarkTable.
    DISPLAY '                                                                           '
         AT 025003 with :FCOL: white :BCOL: blue reverse-video
    STRING ' OFFON are set to: -'
                      Oo-Mark(01) '-' Oo-Mark(02) '-' Oo-Mark(03) '-' Oo-mark(04) '-' Oo-Mark(05) '-'
                      Oo-Mark(06) '-' Oo-Mark(07) '-' Oo-Mark(08) '-' Oo-mark(09) '-' Oo-Mark(10) '-'
                      Oo-Mark(11) '-' Oo-Mark(12) '-' Oo-Mark(13) '-' Oo-mark(14) '-' Oo-Mark(15) '-'
                      Oo-Mark(16) '-' Oo-Mark(17) '-' Oo-Mark(18) '-' Oo-mark(19) '-' Oo-Mark(20) '-'
                      Oo-Mark(21) '-' Oo-Mark(22) '-' Oo-Mark(23) '-' Oo-mark(24) '-' Oo-Mark(25) '-'
                      Oo-Mark(26) '-' Oo-Mark(27) '-' Oo-Mark(28) '-' Oo-mark(29) '-' Oo-Mark(30) '+'
             into wSTRING
    DISPLAY wSTRING     AT 025003 with :FCOL: white :BCOL: blue reverse-video
    DISPLAY Oo-Selected AT 021076 with :FCOL: white :BCOL: blue reverse-video
    continue.
DisplayMarkTableEx. Exit.

DisplayHelp.

    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' This demo will show you four  ' to Bxm-mex(y) add 1 to y
    move z' use of the OFFON tool.        ' to Bxm-mex(y) add 1 to y
    move z' Different colors, positions   ' to Bxm-mex(y) add 1 to y
    move z' type of bracket, and type     ' to Bxm-mex(y) add 1 to y
    move z' of marker.                    ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' OFFON tool has its F1 = help. ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' OFF and ON strings are also   ' to Bxm-mex(y) add 1 to y
    move z' changed to NO and YES.        ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' eugenio.dilo@gmail.com (2021) ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' hit <enter> or click mouse    ' to Bxm-mex(y) add 1 to y
    move z' left button to continue ...   ' to Bxm-mex(y) add 1 to y

    move cyan     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' GnuCOBOL OFFON DEMO '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = 03
   compute Bxm-c1 = 42
   compute Bxm-r2 = Bxm-r1 + 19
   compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using by content BOXMEX-AREA
        on exception display 'CALL GC02BOXMEX error. Module GC02BOXMEX not Found.'
        accept OMITTED
   end-call
   continue.
DisplayHelpEx. exit.

callGC01BOX.
    call GC01BOX using by reference BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

callGC15OFFON.
      call GC15OFFON using by reference OFFON-AREA
         on exception     display ' CALL GC15OFFON error. Module GC15OFFON not Found !' at 0501
                          display ' type Enter to close ...                                ' at 0601
                          accept OMITTED
                          go END-OF-PROGRAM
         not on exception continue
    end-call
    continue.
callGC15OFFON-ex. exit.


End Program GC15OFFONDEMO.
