       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.

*> ID DIVISION.
program-id. GC18RADIOBUTTONDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC18RADIOBUTTON TUI TOOL - DISPLAYS & MANAGE RADIOBUTTONS ON SCREEN
*> Tectonics:  cobc -x GC18RADIOBUTTONDEMO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC18RADIOBUTTONDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License LGPL 3.0 (or greater)
*> Version:    2.0 2021.01.01
*> Changelog:  1.0 first version.
*>             1.1 Rb-hot from 9(01) to 9(02)
*>             2.0 demo enhanced with mouse management
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
*> source-computer. WINDOWS10 64bit WITH DEBUGGING MODE.
special-names.
   Currency Sign is '€'.
   Decimal-Point is Comma.
   CRT STATUS    is wCRT-STATUS.   *> Return Code (es. PF, Arrows, TAB, Mouse Keys)
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

01  wBco        PIC 9  value cyan.
01  wDummy      pic x(01) VALUE     ' '.
01  wString     pic x(70) VALUE     ' '.
01  i           pic 999 value zero.
01  wR          pic 999 value zero.
01  wRetCod     pic 9999 value zero.

01  wCRT-STATUS         PIC 9(04) VALUE 9999.  *> CRT-STATUS codes
01  wCursorRowCol       PIC 9(6) value 0.      *> from CURSOR IS ...
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(3).
    05 wCursorCol       Pic 9(3).

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

COPY 'GC01BOX.CPY'         suppress.
copy 'GC02BOXMEX.CPY'      suppress.
COPY 'GC18RADIOBUTTON.CPY' suppress.
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
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex
    move 2 to Wr

    display 'GnuCOBOL GC18RADIOBUTTON TUI TOOL at work. F1= HELP, ENTER= Continue.'
            at 0303 with :FCOL: white :BCOL: wBco
    accept wDummy at 2479 with  auto no-echo size 0  :FCOL: white :BCOL: cyan end-accept
    if wCRT-STATUS = K-F1   perform DisplayHelp thru DisplayHelpEx   end-if

    display ' GnuCOBOL GC18RADIOBUTTON TUI TOOL at work. '
          at 2103 with foreground-color white background-color wBco
    display ' CursorKey or left single/double click on a radiobutton to select.'
          at 2203 with :FCOL: white :BCOL: wBco
    display ' Enter, TAB, ESC or right mouse key click to exit.'
          at 2303 with :FCOL: white :BCOL: wBco
    display " Select a radiobutton also with hot keys (yellow chars). "
          at 2403 with :FCOL: white :BCOL: wBco
*> *********************************************************************************
*> DISPLAY RADIOBUTTON NUMBER 1
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF SCREEN
set  Box-bco   Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'Y' to Box-tit
move black to Box-titFco
move 'N'   to Box-titFcoH
move ' Select one of the Options for each group ' & x'00' to Box-titDes
perform callGC01BOX thru callGC01BOX-ex

*> DISPLAY A BOX AS BACKGROUND OF A RADIOBUTTON ITEMS GROUP 1
set  Box-bco   Box-fco to white
move '003005013040' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
perform callGC01BOX thru callGC01BOX-ex

display ' Group 1 Options ' at 003006 with :BCOL: white :FCOL: black end-display

*> DISPLAY RADIOBUTTON ITEMS N.1
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
Move '  02004011 Stop after first error     ' & x'00' to Rb-Ele(01)
Move '1102005011 Allow LABEL and GOTO       ' & x'00' to Rb-Ele(02)
Move '  02006011 Enable macros              ' & x'00' to Rb-Ele(03)
Move '  03007011 Allow inline               ' & x'00' to Rb-Ele(04)
Move '  02008011 Include assertion code     ' & x'00' to Rb-Ele(05)
Move '  03009011 Load compatible units      ' & x'00' to Rb-Ele(06)
Move '  06010011 Allow STATIC in objects    ' & x'00' to Rb-Ele(07)
Move '  02011011 C-like operators           ' & x'00' to Rb-Ele(08)
Move '  04012011 Conditional defines        ' & x'00' to Rb-Ele(09)
perform callGC18RADIOBUTTON thru callGC18RADIOBUTTON-ex

perform DisplayOptionResult thru DisplayOptionResultEx.

*> DISPLAY A BOX AS BACKGROUND OF A RadioButton ITEMS GROUP
set  Box-bco   Box-fco to white
move '003048011075' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display ' Group 2 of Options ' at 003049 with :BCOL: white :FCOL: white highlight end-display

*> DISPLAY RADIOBUTTON ITEMS N.2

initialize RadioButton-Area ALL TO VALUE
move low-value to Rb-tab
move 'x'       to Rb-MarkChar
move '[]'      to Rb-BracketChars
move blue to Rb-bcoN Rb-bcoA Rb-bcoH
move cyan to Rb-fcoN
Move '  02004054 Counts              ' & x'00' to Rb-Ele(01)
Move '1102005054 Percentages         ' & x'00' to Rb-Ele(02)
Move '  02006054 Valid uppercase     ' & x'00' to Rb-Ele(03)
Move '  02007054 Error Messages      ' & x'00' to Rb-Ele(04)
Move '  02008054 Reserved words      ' & x'00' to Rb-Ele(05)
Move '  03009054 Colums stats        ' & x'00' to Rb-Ele(06)
Move '  02010054 Total stats         ' & x'00' to Rb-Ele(07)
perform callGC18RADIOBUTTON thru callGC18RADIOBUTTON-ex
perform DisplayOptionResult thru DisplayOptionResultEx.

*> DISPLAY A BOX AS BACKGROUND OF A RADIOBUTTON ITEMS GROUP
set  Box-bco   Box-fco to white
move '014005018040' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
perform callGC01BOX thru callGC01BOX-ex
display ' Group 3 Options ' at 014006 with :BCOL: white :FCOL: black end-display
*> DISPLAY RADIOBUTTON ITEMS N.3
initialize RadioButton-Area ALL TO VALUE
move low-value                                   to Rb-tab
move 'o'  to Rb-MarkChar
move '<>' to Rb-BracketChars
Move '  02015011 Counts                     ' & x'00' to Rb-Ele(01)
Move '1102016011 Percentages                ' & x'00' to Rb-Ele(02)
Move '  02017011 Valid uppercase            ' & x'00' to Rb-Ele(03)
perform callGC18RADIOBUTTON thru callGC18RADIOBUTTON-ex
perform DisplayOptionResult thru DisplayOptionResultEx.


*> DISPLAY RADIOBUTTON ITEMS N.4
display ' Group 4 Options ' at 012045 with :BCOL: white :FCOL: black end-display
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
move 'o'     to Rb-MarkChar
move blue    to Rb-bcoN Rb-bcoA Rb-bcoH
move yellow  to Rb-fcoN
move red     to Rb-fcoH
move 'Y'     to Rb-fcoNH
Move '  00013048 01-Stop after first error ' & x'00' to Rb-Ele(01)
Move '  00014048 02-Allow LABEL and GOTO   ' & x'00' to Rb-Ele(02)
Move '1100015048 03-Enable macros          ' & x'00' to Rb-Ele(03)
Move '  00016048 04-Disable warnings       ' & x'00' to Rb-Ele(04)
Move '  00017048 05-Overnight              ' & x'00' to Rb-Ele(05)
Move '  00017048 06-Include assertion code ' & x'00' to Rb-Ele(06)
Move '  00017048 07-Load compatible units  ' & x'00' to Rb-Ele(07)
Move '  00017048 08-Allow STATIC in objects' & x'00' to Rb-Ele(08)
Move '  00017048 09-C like operators       ' & x'00' to Rb-Ele(09)
Move '  00017048 0A-Overlapped items !     ' & x'00' to Rb-Ele(10)
perform callGC18RADIOBUTTON thru callGC18RADIOBUTTON-ex
perform DisplayOptionResult thru DisplayOptionResultEx.

accept wDummy at 2479 with      :FCOL: white :BCOL: cyan
    DISPLAY ' ESC = return to previous screen, Enter to Exit                  '
         AT 025003 with foreground-color yellow background-color wBco highlight


*> *********************************************************************************
*> DISPLAY RADIOBUTTON - 29 RADIOBUTTONS ON A SINGLE NEW SCREEN PAGE
*> *********************************************************************************


*> DISPLAY A BOX AS BACKGROUND OF RADIOBUTTON ITEMS
set  Box-bco Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'N' to Box-tit
perform callGC01BOX thru callGC01BOX-ex

set  Box-bco   Box-fco to white
move '003005019074' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'R'            to Box-3D
Move 'Y' to Box-tit
move ' Radiobuttons. A list of 29 items (options) in 4 groups ' & x'00' to Box-titDes
perform callGC01BOX thru callGC01BOX-ex

*> DISPLAY RADIOBUTTON ITEMS N.1
display 'Options'     at 004007 with :BCOL: white :FCOL: black  end-display
display 'Command set' at 015007 with :BCOL: white :FCOL: black  end-display
display 'Auto-Save'   at 013042 with :BCOL: white :FCOL: black  end-display
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
Move '  02005011 Stop after first error     ' & x'00' to Rb-Ele(01)
Move '  02006011 Allow LABEL and GOTO       ' & x'00' to Rb-Ele(02)
Move '  02007011 Enable macros              ' & x'00' to Rb-Ele(03)
Move '  03008011 Allow inline               ' & x'00' to Rb-Ele(04)
Move '  02009011 Include assertion code     ' & x'00' to Rb-Ele(05)
Move '  02010011 Load compatible units      ' & x'00' to Rb-Ele(06)
Move '  04011011 Allow STATIC in objects    ' & x'00' to Rb-Ele(07)
Move '  02012011 C like operators           ' & x'00' to Rb-Ele(08)
Move '  03013011 Conditional defines        ' & x'00' to Rb-Ele(09)

Move '  02016011 Counts                     ' & x'00' to Rb-Ele(10)
Move '  02017011 Percentages                ' & x'00' to Rb-Ele(11)
Move '  02018011 Valid uppercase            ' & x'00' to Rb-Ele(12)

Move '  00005046 Counts                    ' & x'00' to Rb-Ele(13)
Move '1100006046 Percentages               ' & x'00' to Rb-Ele(14)
Move '  00007046 Valid uppercase           ' & x'00' to Rb-Ele(15)
Move '  00008046 Error Messages            ' & x'00' to Rb-Ele(16)
Move '  00009046 Reserved words            ' & x'00' to Rb-Ele(17)
Move '  00010046 Colums stats              ' & x'00' to Rb-Ele(18)
Move '  00011046 Total stats               ' & x'00' to Rb-Ele(19)

Move '  03014046 01-Stop after first error ' & x'00' to Rb-Ele(20)
Move '  03015046 02-Allow LABEL and GOTO   ' & x'00' to Rb-Ele(21)
Move '  03016046 03-Enable macros          ' & x'00' to Rb-Ele(22)
Move '  03017046 03-Disable warnings       ' & x'00' to Rb-Ele(23)
Move '  03018046 04-Overnight              ' & x'00' to Rb-Ele(24)
Move '  03018046 05-Include assertion code ' & x'00' to Rb-Ele(25)
Move '  03018046 06-Load compatible units  ' & x'00' to Rb-Ele(26)
Move '  03018046 07-Allow STATIC in objects' & x'00' to Rb-Ele(27)
Move '  03018046 08-C like operators       ' & x'00' to Rb-Ele(28)
Move '  03018046 09-Overlapped items !     ' & x'00' to Rb-Ele(29)

perform callGC18RADIOBUTTON thru callGC18RADIOBUTTON-ex
perform DisplayOptionResult thru DisplayOptionResultEx.

accept wDummy at 2479 with  :FCOL: white :BCOL: cyan

if Rb-Key = K-ESCAPE go to Start-Display end-if

*> ***********************************************************************************************
*> DISPLAY ITALIAN FLAG
*> ***********************************************************************************************
  initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex

    display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC18RADIOBUTTON at work.'
             at 003003 with      :FCOL: white :BCOL: cyan
    display ' < End of Demo > ... Enter to exit ...'
             at 023003 with      :FCOL: white :BCOL: cyan

     move '009035014048' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
     perform callGC01BOX thru callGC01BOX-ex
     display '    ' at 010036 with foreground-color white background-color Green end-display
     display '    ' at 011036 with foreground-color white background-color Green end-display
     display '    ' at 012036 with foreground-color white background-color Green end-display
     display '    ' at 013036 with foreground-color white background-color Green end-display
     display '    ' at 010040 with blink foreground-color white background-color white end-display
     display '    ' at 011040 with blink foreground-color white background-color white end-display
     display '    ' at 012040 with blink foreground-color white background-color white end-display
     display '    ' at 013040 with blink foreground-color white background-color white end-display
     display '    ' at 010044 with blink foreground-color white background-color red   end-display
     display '    ' at 011044 with blink foreground-color white background-color red   end-display
     display '    ' at 012044 with blink foreground-color white background-color red   end-display
     display '    ' at 013044 with blink foreground-color white background-color red   end-display
     accept wDummy at 2479

    continue.
END-OF-PROGRAM.
     goback.

*> *********************************************************************************
*>
*> *********************************************************************************
DisplayOptionResult.
    DISPLAY '                                                                            '
         AT 025003 with foreground-color white background-color wBco.
    STRING ' Options set to: -'
                      Rb-Mark(01) '-' Rb-Mark(02) '-' Rb-Mark(03) '-' Rb-mark(04) '-' Rb-Mark(05) '-'
                      Rb-Mark(06) '-' Rb-Mark(07) '-' Rb-Mark(08) '-' Rb-mark(09) '-' Rb-Mark(10) '-'
                      Rb-Mark(11) '-' Rb-Mark(12) '-' Rb-Mark(13) '-' Rb-mark(14) '-' Rb-Mark(15) '-'
                      Rb-Mark(16) '-' Rb-Mark(17) '-' Rb-Mark(18) '-' Rb-mark(19) '-' Rb-Mark(20) '-'
                      Rb-Mark(21) '-' Rb-Mark(22) '-' Rb-Mark(23) '-' Rb-mark(24) '-' Rb-Mark(25) '-'
                      Rb-Mark(26) '-' Rb-Mark(27) '-' Rb-Mark(28) '-' Rb-mark(29) '-' Rb-Mark(30) '+'
             into wSTRING.
    DISPLAY wSTRING     AT 025003 with foreground-color yellow highlight background-color wBco.
    DISPLAY Rb-Selected AT 021076 with foreground-color yellow highlight background-color wBco.

    continue.
DisplayOptionResultEx. Exit.

DisplayHelp.
    perform ScreenSave thru ScreenSaveEx
    *> DISPLAY THE FRAME AND THE HELP TEXT
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    *> Description: Displays a small group of checkbox items, diaplays other 3 small gropus showing
    *> different options. Then displays a checkbox items list of 29 items grouped in 4 subgroups.
    move z'                               ' to Bxm-mex(01)
    move z' Use left mouse button on item ' to Bxm-mex(02)
    move z' to activate the radiobutton   ' to Bxm-mex(03)
    move z' (click or doubleclick)        ' to Bxm-mex(04)
    move z' Use cursor keys or hotkeys    ' to Bxm-mex(05)
    move z' to activate a radiobutton     ' to Bxm-mex(06)
    move z'                               ' to Bxm-mex(07)
    move z'                               ' to Bxm-mex(08)
    move z'                               ' to Bxm-mex(09)
    move z'                               ' to Bxm-mex(10)
    move z' Enter, TAB, ESC or            ' to Bxm-mex(11)
    move z' right mouseclick              ' to Bxm-mex(12)
    move z' to exit from radiobutton mgmt ' to Bxm-mex(13)
    move z'                               ' to Bxm-mex(14)
    move z'                               ' to Bxm-mex(15)
    move z' eugenio.dilo@gmail.com   2020 ' to Bxm-mex(16)
    move z'                               ' to Bxm-mex(17)
    move z' hit <enter> to continue ...   ' to Bxm-mex(18)

    move cyan     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' GnuCOBOL Radiobutton - HELP '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = 05
   compute Bxm-c1 = 10
   compute Bxm-r2 = Bxm-r1 + 19
   compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using by content BOXMEX-AREA
        on exception display 'CALL BOXMEX error. Module BOXMEX not Found.'
        accept OMITTED
   end-call
   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

ScreenSave.
   move Z'GC18RADIOBUTTONDEMO.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

callGC01BOX.
    call GC01BOX using by content BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

callGC18RADIOBUTTON.
      call GC18RADIOBUTTON using by content RADIOBUTTON-AREA
         on exception     display ' CALL GC18RADIOBUTTON error. Module GC18RADIOBUTTON not Found !' at 0501
                          display ' type Enter to close ...                                       ' at 0601
                          accept OMITTED
                          go END-OF-PROGRAM
         not on exception continue
    end-call
    continue.
callGC18RADIOBUTTON-ex. exit.

End Program GC18RADIOBUTTONDEMO.
