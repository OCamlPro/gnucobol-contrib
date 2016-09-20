ID DIVISION.
program-id. GC01BOXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC01BOX - DRAWS BOXES ON SCREEN
*> Tectonics:  cobc -x GC01BOXDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC01BOXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
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

01  result     usage binary-long.
01  wresult    pic S9(8).

COPY 'GC01BOX.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

display wDummy at 2579 with blank screen end-display
*> hide the cursor (use always a display or an accept at .... before to have a call to "initscr"
move 0 to wInt
call static 'curs_set' using by value wInt end-call


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
accept omitted

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
accept omitted

initialize Box-area ALL TO VALUE
move '005009012023' to Box-rc
move cyan     to Box-bco
move white    to Box-fco
move 'S'      to Box-style
move 'R'      to Box-3D
move 'N'      to Box-shadow
*> move 'Y' to Box-beep

call GC01BOX using BOX-AREA
accept omitted

initialize Box-area ALL TO VALUE
move '015009020025' to Box-rc.
move white   to Box-bco.
move yellow  to Box-fco.
move 'D' to Box-style
move 'E' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA.
accept omitted

initialize Box-area ALL TO VALUE
move '005030019046' to Box-rc.
move red     to Box-bco.
move yellow  to Box-fco.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
accept omitted

initialize Box-area ALL TO VALUE
move '007051' to Box-r1c1.
move '022077' to Box-r2c2.
move green   to Box-bco.
move white    to Box-fco.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
accept omitted

initialize Box-area ALL TO VALUE
move green   to Box-bco.
move white    to Box-fco.
move '010053' to Box-r1c1.
move '018075' to Box-r2c2.
move 'S' to Box-style
move 'N' to Box-3D
move 'Y' to Box-shadow
call GC01BOX using BOX-AREA.
accept omitted.

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

accept omitted.


Changing-Box.
*> move '002002024078' to Box-rc
*> move 'Y'                     to Box-tit
*> move ' DEMO OF GC01BOX TUI TOOL ' & x'00' to Box-titDes
*> call  GC01BOX using BOX-AREA.

initialize Box-area ALL TO VALUE
move "S"    to Box-style
move blue   to Box-Bco
move yellow to Box-Fco
move '005015015060' to Box-rc.

Changing-BoxRefresh.
*> display ' ' AT 0101 WITH ERASE EOS
call x'E4'
move yellow to wFco
move black to wBco
display
 'cursor      left/right/up/down = enlarge the box              ' at 1809 with background-color  wBco foreground-color wFco highlight
 'ALT-cursor  left/right/up/down = shrink the box               ' at 1909 with background-color  wBco foreground-color wFco highlight
 'CTRL-cursor left/right/up/down = move the box                 ' at 2009 with background-color  wBco foreground-color wFco highlight
 'F1/F2= change fore/backcolor: F3= change borders; F4= toggle title ' at 2109 with background-color  wBco foreground-color wFco highlight
 'F5= toggle shadow; F6= change 3D borders                           ' at 2209 with background-color  wBco foreground-color wFco highlight
 'Enter= exit; Escape= exit                                          ' at 2309 with background-color  wBco foreground-color wFco highlight
end-display
call GC01BOX using box-area.

display "key pressed: "  at 2356 with background-color 01 foreground-color 07 end-display
display     wresult      at 2369 with background-color 01 foreground-color 07 end-display

call static "getch" returning result end-call
move result to wresult.

    EVALUATE TRUE
     when wresult = 77     *> 77=Cursor right -->
          compute Box-c2 = Box-c2 + 1
     when wresult = 75     *> 77=Cursor left  <--
          compute Box-c1 = Box-c1 - 1
     when wresult = 80     *> 80= Cursor down
          compute Box-r2 = Box-r2 + 1
     when wresult = 72     *> 72= Cursor up
          compute Box-r1 = Box-r1 - 1
     when wresult = 157    *> 104= ALT-cursor right -->
          compute Box-c1 = Box-c1 + 1
     when wresult = 155     *> 104= ALT-cursor left <--
          compute Box-c2 = Box-c2 - 1
     when wresult = 160     *> 160= ALT-cursor down
          compute Box-r1 = Box-r1 + 1
     when wresult = 152     *> 152= ALT-cursor up
          compute Box-r2 = Box-r2 - 1
     when wresult = 115     *> CTRL-cursor <--
          compute Box-c1 = Box-c1 - 1
          compute Box-c2 = Box-c2 - 1
     when wresult = 116     *> CTRL-cursor -->
          compute Box-c1 = Box-c1 + 1
          compute Box-c2 = Box-c2 + 1
     when wresult = 141     *> CTRL-cursor up
          compute Box-r1 = Box-r1 - 1
          compute Box-r2 = Box-r2 - 1
     when wresult = 145     *> CTRL-cursor down
          compute Box-r1 = Box-r1 + 1
          compute Box-r2 = Box-r2 + 1

     *> 84= F1 change Fore Color
     when wresult = 84
         add 1 to Box-Fco Box-titFco
         If Box-Fco > 7 move 0 to Box-Fco Box-titFco end-if
     *> 85= F2 change Back Color
     when wresult = 85
         add 1 to Box-Bco Box-titBco
         If Box-Bco > 7 move 0 to Box-Bco Box-titBco end-if
     *> 86= F3 change borders
     when wresult = 86
         add 1 to wB  if wB > 6 move 1 to wB end-if
         move wBorder (wB:1) to Box-Style
     *> 87= F4 toggle title
     when wresult = 87
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
     *> 88= F5 toggle shadow
     *> (warning to eliminate shadow you have to restore backgroud after saved !)
     when wresult = 88
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Box-shadow
         else
            move 0 to wFlipFlop
            move "Y" to Box-shadow
         end-if
     *> 89= F6 toggle 3D
     when wresult = 89
         add 1 to w3  if w3 > 3 move 1 to w3 end-if
         move w3D(w3:1) to Box-3D
     *> 27= Escape
     when wresult = 27
         go to Exit-Program
     *> 13= Enter
     when wresult = 13
          go to Exit-Program

     END-EVALUATE.

     go to Changing-BoxRefresh
.
Exit-Program.
goback.

End Program GC01BOXDEMO.
