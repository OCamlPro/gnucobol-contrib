ID DIVISION.
program-id. GC01BOXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC01BOX - DRAWS BOXES ON SCREEN
*> Tectonics:  cobc -x -free GC01BOXDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC01BOXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*>             2.0 use GC98KEYCODES.CPY ,
*>                 use CALL GETCH instead of ACCEPT OMITTED and other minor changes
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 black   constant as 00.
01 blue    constant as 01.
01 green   constant as 02.
01 cyan    constant as 03.
01 red     constant as 04.
01 magenta constant as 05.
01 yellow  constant as 06.  *> or Brown
01 white   constant as 07.

01 wCRT-STATUS  PIC 9(04) VALUE 9999.
01 wInt         BINARY-SHORT . *> SIGNED.
01 wDummy       pic x(01) VALUE     ' '.
01 wFco         pic 9(01) value zero.
01 wBco         pic 9(01) value zero.

01  w3D       pic x(03)  value 'NRE'.
01  w3        pic 9(01)  value 0.
01  wBorder   pic x(07)  value 'SD123NC'.
01  wB        pic 9(01) value 0.
01  wFlipFlop pic 9(01) value 0.

01 wVisibilityNew  BINARY-SHORT .
01 wVisibilityOld  BINARY-SHORT .

COPY 'GC01BOX.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

display wDummy at 2579 with blank screen end-display
*> hide the cursor
*> use always a "display at ..." or an "accept at lincol ..." before to have a call to "initscr"
move 0 to wVisibilityNew
call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

*> ***********************************************************************************
*> BOX N.1 (use default colors & settings)
*> ***********************************************************************************
initialize Box-area ALL TO VALUE
*>    r1 c1 r2 c2
move '001001024080' to Box-rc
move 'Y'                     to Box-tit
move ' DEMO OF GC01BOX TUI TOOL ' & x'00' to Box-titDes
call  GC01BOX using BOX-AREA

display "....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8" at 2501 with  Background-Color 00 Foreground-Color 06 Highlight end-display
*> accept omitted
call static "getch" returning Key-Pressed end-call

*> ***********************************************************************************
*> BOX N.1A  - SOLID FRAME BOX
*> ***********************************************************************************
initialize Box-area ALL TO VALUE
move "3" to Box-style
move blue to Box-Bco
move yellow to Box-Fco
move '003006022074' to Box-rc
*> TITLE BOX
move 'Y'                     to Box-tit
move Z' box - title '  to Box-titDes
call GC01BOX using BOX-AREA
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
move '005009012023' to Box-rc
move cyan     to Box-bco
move white    to Box-fco
move 'S'      to Box-style
move 'R'      to Box-3D
move 'N'      to Box-shadow
*> move 'Y' to Box-beep

call GC01BOX using BOX-AREA
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
move '015009020025' to Box-rc.
move white   to Box-bco.
move yellow  to Box-fco.
move 'D' to Box-style
move 'E' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA.
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
move '005030019046' to Box-rc.
move red     to Box-bco.
move yellow  to Box-fco.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
move '007051' to Box-r1c1.
move '022077' to Box-r2c2.
move green   to Box-bco.
move white    to Box-fco.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
move green   to Box-bco.
move white    to Box-fco.
move '010053' to Box-r1c1.
move '018075' to Box-r2c2.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
*> accept omitted
call static "getch" returning Key-Pressed end-call

initialize Box-area ALL TO VALUE
set Box-bco to white.
set Box-fco to black.
move '001001' to Box-r1c1.
move '024079' to Box-r2c2.
move 'S' to Box-style
move 'N' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA.

move '003005' to Box-r1c1.
move '006020' to Box-r2c2.
move 'R' to Box-3D
call GC01BOX using BOX-AREA.
display " Frame1 " at 003006 with  Background-Color 07 Foreground-Color 00 end-display

move '009005' to Box-r1c1.
move '016020' to Box-r2c2.
call GC01BOX using BOX-AREA.

move '003030' to Box-r1c1.
move '016070' to Box-r2c2.
call GC01BOX using BOX-AREA.
display " Frame2 " at 003032 with  Background-Color 07 Foreground-Color 00 end-display

move '005033009048' to Box-rc.
call GC01BOX using BOX-AREA.

move '005050009067' to Box-rc.
call GC01BOX using BOX-AREA.

move '018033020048' to Box-rc.
move 'E' to Box-3D
call GC01BOX using BOX-AREA.
display "Button1" at 019037 with  Background-Color 07 Foreground-Color 00 end-display

move '018050020067' to Box-rc.
call GC01BOX using BOX-AREA.
display "Button2" at 019056 with  Background-Color 07 Foreground-Color 00 end-display

*> accept omitted
call static "getch" returning Key-Pressed end-call.


Changing-Box.
initialize Box-area ALL TO VALUE
move "S"    to Box-style
move blue   to Box-Bco
move yellow to Box-Fco
move '005015015060' to Box-rc.

Changing-BoxRefresh.
call x'E4'
move blue   to wBco
move yellow to wFco

display 'cursor      left/right/up/down = enlarge the box                   ' at 1809 with background-color  wBco foreground-color wFco highlight
display 'Alt-Cursor  left/right/up/down = shrink the box                    ' at 1909 with background-color  wBco foreground-color wFco highlight
display 'Ctrl-Cursor left/right/up/down = move the box                      ' at 2009 with background-color  wBco foreground-color wFco highlight
display 'F1/F2= change fore/backcolor: F3= change borders; F4= toggle title ' at 2109 with background-color  wBco foreground-color wFco highlight
display 'F5= toggle shadow; F6= change 3D borders                           ' at 2209 with background-color  wBco foreground-color wFco highlight
display 'Enter= exit; Escape= exit                                          ' at 2309 with background-color  wBco foreground-color wFco highlight

call GC01BOX using box-area.

display "key pressed: "  at 2356 with background-color 01 foreground-color 07 end-display
display     Key-Pressed  at 2369 with background-color 01 foreground-color 07 end-display

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
     when Key-F1                                        *> F1 change Fore Color
         add 1 to Box-Fco Box-titFco
         If Box-Fco > 7 move 0 to Box-Fco Box-titFco end-if
     when Key-F2                                        *> F2 change Back Color
         add 1 to Box-Bco Box-titBco
         If Box-Bco > 7 move 0 to Box-Bco Box-titBco end-if
     when Key-F3                                        *> F3 change borders
         add 1 to wB  if wB > 6 move 1 to wB end-if
         move wBorder (wB:1) to Box-Style
     when Key-F4                                        *> F4 toggle title
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Box-tit
         else
            move 0 to wFlipFlop
            move "Y" to Box-tit
            move Box-Bco to Box-titBco
            move Box-Fco to Box-titFco
            move x'B4' & ' Title Box ' & x'C3' & x'00' to Box-TitDes
         end-if
     when Key-F5   *> F5 toggle shadow (warning to eliminate shadow you have to restore backgroud after saved !)
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
   *> re-show the cursor
   move 2 to wVisibilityNew
   call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
   goback.

End Program GC01BOXDEMO.
