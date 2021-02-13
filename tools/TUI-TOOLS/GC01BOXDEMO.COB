              >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY      ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
program-id. GC01BOXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC01BOX - DRAWS BOXES ON SCREEN - LAST SCREEN IS TO RESIZE A BOX
*> Tectonics:  cobc -x GC01BOXDEMO.COB (use GnuCOBOL 3.1 or greater)
*> Usage:      GC01BOXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (c)2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    3.0 2021.02.02
*> Changelog:  1.0 first release.
*>             2.0 introduced use of GC98KEYCODES.CPY and
*>                 use of CALL GETCH instead of ACCEPT OMITTED and other minor changes
*>             3.0 back to ACCEPT a "dummy" field.
*>                 Colors from 9(01) to 9(02) to use also color code from 08 to 15.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position
DATA DIVISION.
WORKING-STORAGE SECTION.
COPY 'GC00COLORS.CPY'.

01 wInt         BINARY-SHORT . *> SIGNED.
01 wDummy       pic x(01) VALUE     ' '.

01  w3D       pic x(03)  value 'NRE'.
01  w3        pic 9(01)  value 0.
01  wBorder   pic x(07)  value 'SD123NC'.
01  wB        pic 9(01) value 0.
01  wFlipFlop pic 9(01) value 0.

01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01 wVisibilityNew  BINARY-SHORT .
01 wVisibilityOld  BINARY-SHORT .

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  COB-AUTO-MOUSE-HANDLING          VALUE 1.
78  COB-ALLOW-LEFT-DOWN              VALUE 2.
78  COB-ALLOW-LEFT-UP                VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE            VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN            VALUE 16.
78  COB-ALLOW-MIDDLE-UP              VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE          VALUE 64.
78  COB-ALLOW-RIGHT-DOWN             VALUE 128.
78  COB-ALLOW-RIGHT-UP               VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE           VALUE 512.
78  COB-ALLOW-MOUSE-MOVE             VALUE 1024.
01  COB-MOUSE-FLAGS         PIC 9(04).

01  wColorCode    pic 9(02).
01  wColorDes     pic x(12).
01  wBcoDes       pic x(12).
01  wFcoDes       pic x(12).

COPY 'GC01BOX.CPY'.
COPY 'GC97KEYCODEGC.CPY'.
COPY 'GC98KEYCODE.CPY'.
*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
    perform InitialSettings thru InitialSettingsEx

    display wDummy at 001001 with blank screen end-display
    *> use always a "display at ..." or an "accept at lincol ..." before to have a call to "initscr"
    perform HideCursor thru HideCursorEx
*> ***********************************************************************************
*> BOX N.1
*> ***********************************************************************************
initialize Box-area ALL TO VALUE
*>    r1 c1 r2 c2
move '001001024080' to Box-rc
move 'Y'                     to Box-tit
move ' 1.DEMO OF GC01BOX TUI TOOL (LightWhite on Grey) ' & x'00' to Box-titDes
move Grey           to Box-bco Box-titBco
move LightWhite     to Box-fco Box-titFco
call  GC01BOX using BOX-AREA
display "....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8" at 2501 with  Background-Color 00 :FCOL: 06 Highlight end-display
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

*> ***********************************************************************************
*> BOX N.1A  - SOLID FRAME BOX
*> ***********************************************************************************
initialize Box-area ALL TO VALUE
move "3"            to Box-style
move blue           to Box-bco Box-titBco
move yellow         to Box-fco Box-titFco
move '003006022074' to Box-rc
move 'Y'                 to Box-tit
move Z' 2.yellow on blue ' to Box-titDes
call GC01BOX using BOX-AREA
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

initialize Box-area ALL TO VALUE
move '005009012023' to Box-rc
move cyan     to Box-bco Box-titBco
move white    to Box-fco Box-titFco
move 'S'      to Box-style
move 'R'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

initialize Box-area ALL TO VALUE
move '015009020025' to Box-rc.
move white   to Box-bco Box-titBco
move yellow  to Box-fco Box-titFco
move 'D' to Box-style
move 'E' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA.
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

initialize Box-area ALL TO VALUE
move '005028019047' to Box-rc.
move LightRed    to Box-bco Box-titBco
move LightGreen  to Box-fco Box-titFco
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
move 'Y'                   to Box-tit
move Z' 5.LGreen on LRed ' to Box-titDes
call GC01BOX using BOX-AREA.
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

initialize Box-area ALL TO VALUE
move '007051' to Box-r1c1.
move '022077' to Box-r2c2.
move LightMagenta to Box-bco Box-titBco
move white        to Box-fco Box-titFco
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
move 'Y' to Box-tit
move Z' 6.White on LMagenta ' to Box-titDes
call GC01BOX using BOX-AREA.
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

initialize Box-area ALL TO VALUE
move LightBlue  to Box-bco Box-titBco
move LightCyan  to Box-fco Box-titFco
move '010053' to Box-r1c1.
move '018075' to Box-r2c2.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
move 'Y'                 to Box-tit
move Z' 7.LCyan on LBlue ' to Box-titDes
call GC01BOX using BOX-AREA.
call GC01BOX using BOX-AREA.
accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

*> **************************************************************
*> SCREEN WITH SOME BOXES (LIKE BUTTONS)
*> **************************************************************
initialize Box-area ALL TO VALUE
set Box-bco to white.
set Box-fco to black.
move '001001' to Box-r1c1
move '024080' to Box-r2c2
move 'S' to Box-style
move 'N' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA

move '003005' to Box-r1c1
move '006020' to Box-r2c2
move 'R' to Box-3D
call GC01BOX using BOX-AREA
display " Frame1 " at 003006 :BCOL: 07 :FCOL: 00 end-display

move '009005' to Box-r1c1
move '016020' to Box-r2c2
call GC01BOX using BOX-AREA.

move '003030' to Box-r1c1
move '016070' to Box-r2c2
call GC01BOX using BOX-AREA
display " Frame2 " at 003032 :BCOL: 07 :FCOL: 00 end-display

move '005033009048' to Box-rc
call GC01BOX using BOX-AREA

move '005050009067' to Box-rc
call GC01BOX using BOX-AREA

move '018033020048' to Box-rc
move 'E' to Box-3D
call GC01BOX using BOX-AREA
display "Button1" at 019037 :BCOL: 07 :FCOL: 00 end-display

move '018050020067' to Box-rc
call GC01BOX using BOX-AREA
display "Button2" at 019056 :BCOL: 07 :FCOL: 00 end-display

accept wDummy at 025001 :BCOL: 00 :FCOL: 00 auto-skip

*> ***************************************************************************+
*> SCREEN WITH BOX TOBE RESIZED AND MOVED ON SCREEN
*> ***************************************************************************+
    initialize Box-area ALL TO VALUE
    move "S"    to Box-style
    move LightRed    to Box-Bco Box-titBco
    move LightCyan   to Box-Fco Box-titFco
    move '005030015075' to Box-rc
    move "Y" to Box-tit
    move x'B4' & ' Box Title ' & x'C3' & x'00' to Box-TitDes
    continue.

Changing-BoxRefresh.

    call x'E4' *> "E4" CLEAR THE SCREEN (using the color of previous last display

    display 'RESIZE, CHANGE COLORS AND MOVE THE BOX                             ' at 0205 :BCOL: Blue :FCOL: White highlight
    display 'cursor      left/right/up/down = enlarge the box                   ' at 1805 :BCOL: Blue :FCOL: White highlight
    display 'Alt-Cursor  left/right/up/down = shrink the box                    ' at 1905 :BCOL: Blue :FCOL: White highlight
    display 'Ctrl-Cursor left/right/up/down = move the box                      ' at 2005 :BCOL: Blue :FCOL: White highlight
    display 'F1/F2= change fore/backcolor: F3= change borders; F4= toggle title ' at 2105 :BCOL: Blue :FCOL: White highlight
    display 'F5= toggle shadow; F6= change 3D borders                           ' at 2205 :BCOL: Blue :FCOL: White highlight
    display 'Enter= exit; Escape= exit                                          ' at 2305 :BCOL: Blue :FCOL: White highlight

    move  Box-Fco to wColorCode
    perform DecodeColor thru DecodeColorEx
    move wColorDes to wFcoDes
    display "Fco"    at 006002 display Box-Fco    at 006009 display wFcoDes at 006012
    display "titFco" at 008002 display Box-titFco at 008009

    move  Box-Bco to wColorCode
    perform DecodeColor thru DecodeColorEx
    move wColorDes to wBcoDes
    display "Bco"    at 005002 display Box-Bco    at 005009 display wBcoDes at 005012
    display "titBco" at 007002 display Box-titBco at 007009

    display "key pressed: "  at 2356 :BCOL: 01 :FCOL: 07 end-display
    display     Key-Pressed  at 2369 :BCOL: 01 :FCOL: 07 end-display

    call GC01BOX using Box-Area

    *> use call getch to detect ALT-CURSOR and CTRL-CURSOR (not available at GnuCOBOL CRT-STATUS codes.
    call static "getch" returning Key-Pressed end-call

    EVALUATE Key-Pressed
         when Key-CursRight
              compute Box-c2 = Box-c2 + 1
         when Key-CursLeft
              compute Box-c1 = Box-c1 - 1
         when Key-CursDn
              compute Box-r2 = Box-r2 + 1
         when Key-CursUp
              compute Box-r1 = Box-r1 - 1
         when Key-Alt-CursRight
              compute Box-c1 = Box-c1 + 1
         when Key-Alt-CursLeft
              compute Box-c2 = Box-c2 - 1
         when Key-Alt-CursDn
              compute Box-r1 = Box-r1 + 1
         when Key-Alt-CursUp
              compute Box-r2 = Box-r2 - 1
         when Key-Ctrl-CursLeft
              compute Box-c1 = Box-c1 - 1
              compute Box-c2 = Box-c2 - 1
         when Key-Ctrl-CursRight
              compute Box-c1 = Box-c1 + 1
              compute Box-c2 = Box-c2 + 1
         when Key-Ctrl-CursUp
              compute Box-r1 = Box-r1 - 1
              compute Box-r2 = Box-r2 - 1
         when Key-Ctrl-CursDn
              compute Box-r1 = Box-r1 + 1
              compute Box-r2 = Box-r2 + 1

         when Key-F1  *> F1 change Fore Color (the box frame)
             add 1 to Box-Fco add 1 to Box-titFco
             If Box-Fco > 15 move 0 to Box-Fco move 0 to Box-titFco end-if
         when Key-F2   *> F2 change Back Color (the Box color)
             add 1 to Box-Bco add 1 to Box-titBco
             If Box-Bco > 15 move 0 to Box-Bco move 0 to Box-titBco end-if
         when Key-F3    *> F3 change borders type (single, double ...)
             add 1 to wB  if wB > 6 move 1 to wB end-if
             move wBorder (wB:1) to Box-Style
         when Key-F4     *> F4 toggle title
             if wFlipFlop = 0
                move 1 to wFlipFlop
                move "N" to Box-tit
             else
                move 0 to wFlipFlop
                move "Y" to Box-tit
                *> move Box-Bco to Box-titBco
                *> move Box-Fco to Box-titFco
                move x'B4' & ' Title Box ' & x'C3' & x'00' to Box-TitDes
             end-if
         when Key-F5   *> F5 toggle shadow to eliminate shadow we restore backgroud
             if wFlipFlop = 0
                move 1 to wFlipFlop
                move "N" to Box-shadow
             else
                move 0 to wFlipFlop
                move "Y" to Box-shadow
             end-if
         when Key-F6                                         *> F6 toggle 3D
             add 1 to w3  if w3 > 3 move 1 to w3 end-if
             move w3D(w3:1) to Box-3D
         when Key-Escape
             go to Exit-Program
         when Key-Enter
              go to Exit-Program
    END-EVALUATE

    go to Changing-BoxRefresh .

Exit-Program.


*> ***********************************************************************************************
*> DISPLAY END OF PROGRAM SCREEN
*> ***********************************************************************************************
    initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex

    display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC01BOX at work.'
             at 003003 with      :FCOL: white :BCOL: cyan
    display ' < End of Demo > ... Enter to exit ...'
             at 023003 with      :FCOL: white :BCOL: cyan
    move '009035014048' to Box-rc
    move black to Box-bco
    move 'S' to Box-style
    perform callGC01BOX thru callGC01BOX-ex

   *> DISPLAY ITALIAN FLAG
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

   perform ShowCursor thru ShowCursorEx
   goback.

*> ***********************************************************************************
*>
*> ***********************************************************************************
InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING
                      + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
                      + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP
                      + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
                      + COB-ALLOW-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to COB-MOUSE-FLAGS
  continue.
InitialSettingsEx. exit.

HideCursor.
  *> hide the cursor and save its previous state
  *> (use always a display or an accept at .... before to have a call to "initscr"
  move 0 to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
  continue.
HideCursorEx. exit.

ShowCursor.
  *> reset (re-show) the cursor to its previous state
  move wVisibilityOld to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
  continue.
ShowCursorEx. exit.


callGC01BOX.
    call GC01BOX using by reference BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

DecodeColor.
   evaluate true
        when wColorCode = Black        move "Black       "      to wColorDes
        when wColorCode = Blue         move "Blue        "      to wColorDes
        when wColorCode = Green        move "Green       "      to wColorDes
        when wColorCode = Cyan         move "Cyan        "      to wColorDes
        when wColorCode = Red          move "Red         "      to wColorDes
        when wColorCode = Magenta      move "Magenta     "      to wColorDes
        when wColorCode = Brown        move "Brown       "      to wColorDes
        when wColorCode = White        move "White       "      to wColorDes
        when wColorCode = Grey         move "Grey        "      to wColorDes
        when wColorCode = LightBlue    move "LightBlue   "      to wColorDes
        when wColorCode = LightGreen   move "LightGreen  "      to wColorDes
        when wColorCode = LightCyan    move "LightCyan   "      to wColorDes
        when wColorCode = LightRed     move "LightRed    "      to wColorDes
        when wColorCode = LightMagenta move "LightMagenta"      to wColorDes
        when wColorCode = Yellow       move "Yellow      "      to wColorDes
        when wColorCode = LightWhite   move "LightWhite  "      to wColorDes
   end-evaluate
   continue.
DecodeColorEx. exit.

End Program GC01BOXDEMO.
