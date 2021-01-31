       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
program-id. GC13CHECKBOXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC13CHECKBOX TUI TOOL -  DISPLAYS & MANAGE CHECKBOX ON SCREEN
*> Description: Displays a small group of checkbox items, displays other 3 small gropus showing
*>              different options. Then displays a checkbox items list of 29 items grouped in 4 subgroups.
*> Tectonics:  cobc -x GC13CHECKBOXDEMO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC13CHECKBOXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License LGPL 3.0 (or greater)
*> Version:    2.0 2020.12.12
*> Changelog:  1.0 first version.
*>             1.1 Ck-hot from 9(01) to 9(02)
*>             2.0 demo enhanced with mouse management
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
*> source-computer. WINDOWS10 64bit WITH DEBUGGING MODE.
special-names.
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

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

COPY 'GC01BOX.CPY'.
copy 'GC02BOXMEX.CPY'     suppress.
COPY 'GC13CHECKBOX.CPY'.
COPY 'GC97KEYCODEGC.CPY'.

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
    display 'GnuCOBOL GC13CHECKBOX TUI TOOL at work. '
            at 0303 with :FCOL: white :BCOL: blue
    perform DisplayHelp thru DisplayHelpEx

    display ' GnuCOBOL GC13CHECKBOX TUI TOOL at work. '
          at 2103 with :FCOL: white :BCOL: blue
    display ' Cursor keys or left mousekey singleclick on item to change active checkbox'
          at 2203 with :FCOL: white :BCOL: blue
    display ' enter/spacebar/left mousekey doubleclick to mark/unmark. TAB or ESC to exit'
          at 2303 with :FCOL: white :BCOL: blue
    display " Activate an item (give the 'focus to') also with hot keys (yellow chars) "
          at 2403 with :FCOL: white :BCOL: blue
  *> *********************************************************************************
  *> DISPLAY CHECKBOX NUMBER 1
  *> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF SCREEN
set  Box-bco Box-fco to white move '002003020077' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow move 'E' to Box-3D Move 'Y' to Box-tit
move ' Mark or unmark one or more switches per group ' & x'00' to Box-titDes
perform callGC01BOX thru callGC01BOX-ex

*> DISPLAY A BOX AS BACKGROUND OF A CHECKBOX ITEMS GROUP
set  Box-bco   Box-fco to white
move '003005013040' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display 'Group 1 switches. F1 = HELP ' at 003007 with :BCOL: white :FCOL: black end-display

*> DISPLAY CHECKBOX ITEMS N.1
initialize CHECKBOX-area ALL TO VALUE
move low-value                                        to Ck-tab
Move ' 102004011 Stop after first error     ' & x'00' to Ck-Ele(01)
Move ' 102005011 Allow LABEL and GOTO       ' & x'00' to Ck-Ele(02)
Move '  02006011 Enable macros              ' & x'00' to Ck-Ele(03)
Move ' 103007011 Allow inline               ' & x'00' to Ck-Ele(04)
Move ' 102008011 Include assertion code     ' & x'00' to Ck-Ele(05)
Move ' 103009011 Load compatible units      ' & x'00' to Ck-Ele(06)
Move '1 06010011 Allow STATIC in objects    ' & x'00' to Ck-Ele(07)
Move '  02011011 C like operators           ' & x'00' to Ck-Ele(08)
Move ' 104012011 Conditional defines        ' & x'00' to Ck-Ele(09)
perform callGC13CHECKBOX thru callGC13CHECKBOX-ex
perform DisplayMarkTable thru DisplayMarkTableEx.

*> DISPLAY A BOX AS BACKGROUND OF A CHECKBOX ITEMS GROUP
set  Box-bco   Box-fco to white move '003048011075' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display 'Group 2 switches' at 003050 with :BCOL: white :FCOL: black end-display

*> DISPLAY CHECKBOX ITEMS N.2
initialize CHECKBOX-area ALL TO VALUE
move 'x'       to Ck-MarkChar
move '()'      to Ck-BracketChars
move blue to Ck-bcoN Ck-bcoA Ck-bcoH
move cyan to Ck-fcoN
move low-value                                 to Ck-tab
Move ' 102004054 Counts              ' & x'00' to Ck-Ele(01)
Move '1102005054 Percentages         ' & x'00' to Ck-Ele(02)
Move '  02006054 Valid uppercase     ' & x'00' to Ck-Ele(03)
Move ' 102007054 Error Messages      ' & x'00' to Ck-Ele(04)
Move ' 102008054 Reserved words      ' & x'00' to Ck-Ele(05)
Move ' 103009054 Colums stats        ' & x'00' to Ck-Ele(06)
Move '  02010054 Total stats         ' & x'00' to Ck-Ele(07)
perform callGC13CHECKBOX thru callGC13CHECKBOX-ex

perform DisplayMarkTable thru DisplayMarkTableEx.

*> DISPLAY A BOX AS BACKGROUND OF A CHECKBOX ITEMS GROUP
set  Box-bco   Box-fco to white move '014005018040' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow Box-tit move 'R' to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display 'Group 3 switches' at 014007 with :BCOL: white :FCOL: black highlight end-display

*> DISPLAY CHECKBOX ITEMS N.3
initialize CHECKBOX-area ALL TO VALUE
move 'o'  to Ck-MarkChar
move '<>' to Ck-BracketChars
move low-value                                        to Ck-tab
Move ' 102015011 Counts                     ' & x'00' to Ck-Ele(01)
Move '1 02016011 Percentages                ' & x'00' to Ck-Ele(02)
Move '  02017011 Valid uppercase            ' & x'00' to Ck-Ele(03)
perform callGC13CHECKBOX thru callGC13CHECKBOX-ex

perform DisplayMarkTable thru DisplayMarkTableEx.

*> DISPLAY CHECKBOX ITEMS N.4
display 'Group 4 switches' at 012045 with :BCOL: white :FCOL: black highlight end-display
initialize CHECKBOX-area ALL TO VALUE

move 'o'     to Ck-MarkChar
move blue    to Ck-bcoN Ck-bcoA Ck-bcoH
move yellow  to Ck-fcoN
move red     to Ck-fcoH
move 'Y'     to Ck-fcoNH
move low-value                                       to Ck-tab
Move '1 00013048 01-Stop after first error ' & x'00' to Ck-Ele(01)
Move ' 100014048 02-Allow LABEL and GOTO   ' & x'00' to Ck-Ele(02)
Move '  00015048 03-Enable macros          ' & x'00' to Ck-Ele(03)
Move '  00016048 03-Disable warnings       ' & x'00' to Ck-Ele(04)
Move ' 100017048 04-Overnight              ' & x'00' to Ck-Ele(05)
Move ' 100017048 05-Include assertion code ' & x'00' to Ck-Ele(06)
Move ' 100017048 06-Load compatible units  ' & x'00' to Ck-Ele(07)
Move '  00017048 07-Allow STATIC in objects' & x'00' to Ck-Ele(08)
Move '  00017048 08-C like operators       ' & x'00' to Ck-Ele(09)
Move ' 100017048 09-Overlapped items !     ' & x'00' to Ck-Ele(10)
perform callGC13CHECKBOX thru callGC13CHECKBOX-ex

perform DisplayMarkTable thru DisplayMarkTableEx.
accept wDummy at 2479
DISPLAY ' ESC = return to previous screen, Enter to select and Exit '
         AT 001003 with :FCOL: yellow :BCOL: blue highlight

*> *********************************************************************************
*> DISPLAY CHECKBOX - 29 CHECKBOX ITEMS ON A SINGLE NEW SCREEN PAGE
*> *********************************************************************************

*> DISPLAY A BOX AS BACKGROUND OF CHECKBOX ITEMS
set  Box-bco Box-fco to white move '002003020077' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow move 'E' to Box-3D Move 'N' to Box-tit
perform callGC01BOX thru callGC01BOX-ex

set  Box-bco   Box-fco to white move '003005019074' to Box-rc
move 'S' to Box-style move 'N' to Box-3D Box-shadow move 'R' to Box-3D Move 'Y' to Box-tit
move ' Checkboxes. A list of 29 items (switches) in 4 groups ' & x'00' to Box-titDes
perform callGC01BOX thru callGC01BOX-ex

*> DISPLAY CHECKBOX ITEMS N.5
display 'Options'     at 004007 with :BCOL: white :FCOL: black  end-display
display 'Command set' at 015007 with :BCOL: white :FCOL: black  end-display
display 'Auto-Save'   at 013042 with :BCOL: white :FCOL: black  end-display
initialize CHECKBOX-area ALL TO VALUE
move low-value                                        to Ck-tab
Move ' 102005011 Stop after first error     ' & x'00' to Ck-Ele(01)
Move ' 102006011 Allow LABEL and GOTO       ' & x'00' to Ck-Ele(02)
Move '  02007011 Enable macros              ' & x'00' to Ck-Ele(03)
Move ' 103008011 Allow inline               ' & x'00' to Ck-Ele(04)
Move ' 102009011 Include assertion code     ' & x'00' to Ck-Ele(05)
Move ' 102010011 Load compatible units      ' & x'00' to Ck-Ele(06)
Move '  04011011 Allow STATIC in objects    ' & x'00' to Ck-Ele(07)
Move '  02012011 C like operators           ' & x'00' to Ck-Ele(08)
Move ' 104013011 Conditional defines        ' & x'00' to Ck-Ele(09)
Move ' 102016011 Counts                     ' & x'00' to Ck-Ele(10)
Move '  02017011 Percentages                ' & x'00' to Ck-Ele(11)
Move '  02018011 Valid uppercase            ' & x'00' to Ck-Ele(12)

Move ' 100005046 Counts                    ' & x'00' to Ck-Ele(13)
Move '1100006046 Percentages               ' & x'00' to Ck-Ele(14)
Move '  00007046 Valid uppercase           ' & x'00' to Ck-Ele(15)
Move ' 100008046 Error Messages            ' & x'00' to Ck-Ele(16)
Move ' 100009046 Reserved words            ' & x'00' to Ck-Ele(17)
Move ' 100010046 Colums stats              ' & x'00' to Ck-Ele(18)
Move '  00011046 Total stats               ' & x'00' to Ck-Ele(19)
Move '  03014046 01-Stop after first error ' & x'00' to Ck-Ele(20)
Move ' 103015046 02-Allow LABEL and GOTO   ' & x'00' to Ck-Ele(21)
Move '  03016046 03-Enable macros          ' & x'00' to Ck-Ele(22)
Move '  03017046 03-Disable warnings       ' & x'00' to Ck-Ele(23)
*> overlapped items - same row & col
Move ' 103018046 04-Overnight              ' & x'00' to Ck-Ele(24)
Move ' 103018046 05-Include assertion code ' & x'00' to Ck-Ele(25)
Move ' 103018046 06-Load compatible units  ' & x'00' to Ck-Ele(26)
Move '  03018046 07-Allow STATIC in objects' & x'00' to Ck-Ele(27)
Move '  03018046 08-C like operators       ' & x'00' to Ck-Ele(28)
Move ' 103018046 09-Overlapped items !     ' & x'00' to Ck-Ele(29)
perform callGC13CHECKBOX thru callGC13CHECKBOX-ex

perform DisplayMarkTable thru DisplayMarkTableEx.
accept wDummy at 2479

if Ck-Key = K-ESCAPE go to Start-Display end-if

*> ***********************************************************************************************
*> DISPLAY ITALIAN FLAG
*> ***********************************************************************************************
    initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex

    display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC13CHECKBOX at work.'
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
    STRING ' Switches set to: -'
                      Ck-Mark(01) '-' Ck-Mark(02) '-' Ck-Mark(03) '-' Ck-mark(04) '-' Ck-Mark(05) '-'
                      Ck-Mark(06) '-' Ck-Mark(07) '-' Ck-Mark(08) '-' Ck-mark(09) '-' Ck-Mark(10) '-'
                      Ck-Mark(11) '-' Ck-Mark(12) '-' Ck-Mark(13) '-' Ck-mark(14) '-' Ck-Mark(15) '-'
                      Ck-Mark(16) '-' Ck-Mark(17) '-' Ck-Mark(18) '-' Ck-mark(19) '-' Ck-Mark(20) '-'
                      Ck-Mark(21) '-' Ck-Mark(22) '-' Ck-Mark(23) '-' Ck-mark(24) '-' Ck-Mark(25) '-'
                      Ck-Mark(26) '-' Ck-Mark(27) '-' Ck-Mark(28) '-' Ck-mark(29) '-' Ck-Mark(30) '+'
             into wSTRING  *> wString is truncated at 70 char
    DISPLAY wSTRING     AT 025003 with :FCOL: white :BCOL: blue reverse-video
    DISPLAY Ck-Selected AT 021076 with :FCOL: white :BCOL: blue reverse-video
    continue.
DisplayMarkTableEx. Exit.

DisplayHelp.

    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' This demo will show you some  ' to Bxm-mex(y) add 1 to y
    move z' use of the CHECKBOX tool.     ' to Bxm-mex(y) add 1 to y
    move z' Different colors, positions   ' to Bxm-mex(y) add 1 to y
    move z' type of bracket, and type     ' to Bxm-mex(y) add 1 to y
    move z' of marker.                    ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' CHECKBOX tool has its own     ' to Bxm-mex(y) add 1 to y
    move z' help. F1 to show help         ' to Bxm-mex(y) add 1 to y
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
    move x'B4' & ' GnuCOBOL CHECKBOX DEMO '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = 04
   compute Bxm-c1 = 42
   compute Bxm-r2 = Bxm-r1 + 19
   compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using by content BOXMEX-AREA
        on exception display 'CALL GC02BOXMEX error. Module GC02BOXMEX not Found.'
        accept OMITTED
   end-call
   continue.
DisplayHelpEx. exit.

*> ScreenSave.
   *> move Z'GC13CHECKBOXDEMO.SCR' to wScreenName
   *> call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
*> ScreenSaveEx. exit.

*> ScreenRestore.
   *> call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   *> CALL 'CBL_DELETE_FILE' USING wScreenName.
*> ScreenRestoreEx. exit.

callGC01BOX.
    call GC01BOX using by reference BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

callGC13CHECKBOX.
      call GC13CHECKBOX using by reference CHECKBOX-AREA
         on exception     display ' CALL GC13CHECBOX error. Module GC13CHECKBOX not Found !' at 0501
                          display ' type Enter to close ...                                ' at 0601
                          accept OMITTED
                          go END-OF-PROGRAM
         not on exception continue
    end-call
    continue.
callGC13CHECKBOX-ex. exit.


End Program GC13CHECKBOXDEMO.
