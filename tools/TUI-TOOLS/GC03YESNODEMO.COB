ID DIVISION.
PROGRAM-ID. GC03YESNODEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC03YESNO -  DISPLAYS A YES & NO BOX
*> Tectonics:  cobc -x GC03YESNODEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC03YESNODEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
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

COPY 'GC01BOX.CPY'.
COPY 'GC03YESNO.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

*> clear the screen
display wDummy at 2579 with blank screen end-display

move red     to Box-bco
set  Box-fco to white
*>    r1 c1 r2 c2
move '001001025080' to Box-rc
move 'S'            to Box-style
move 'N'            to Yn-Shadow
call GC01BOX using BOX-AREA.
Display " use cursor right/left & up/down, tab/backtab, pgup/pgdn o space bar"
        at 018006 with background-color red foreground-color yellow highlight end-display

set Yn-BcoNonSel to white.
set Yn-FcoNonSel to red.

set Yn-BcoSel    to green.
set Yn-FcoSel    to white.

call GC03YESNO using YESNO-AREA

display "return value = "  at 022015  Yn-YESNO  at 022030
         with background-color 01 foreground-color 07 end-display
display "return Key   = "  at 023015  Yn-Key    at 023030
        with background-color 01 foreground-color 07 end-display

*> accept omitted
call static "getch" returning Key-Pressed end-call.

goback.

End Program GC03YESNODEMO.
