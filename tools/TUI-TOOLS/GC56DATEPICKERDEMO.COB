       >> SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC56DATEPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC56DATEPICKER
*> Tectonics:  cobc -x GC56DATEPICDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC56DATEPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2016.10.14
*> Changelog:  1.0 first release.
*>             1.1 small enhancement (legend , toggle legend)
*> ***********************************************************************************
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
01 wDummy            pic x(01) VALUE     ' '.
01  i    pic 999.
01  j    pic 999.
01  wR   pic 999 value zero.
01  wC   pic 999 value zero.
01 wInt        BINARY-SHORT . *> SIGNED.

copy 'GC01BOX.CPY'.
copy 'GC56DATEPICKER.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

initialize Box-area ALL TO VALUE
set  Box-bco  to white
set  Box-fco  to white
move '002006' to Box-r1c1
move '025076' to Box-r2c2
move 'S'      to Box-style
move "R" to Box-3D
move 'Y' to Box-tit
move z' Date Picker DEMO ' to Box-titDES
call GC01BOX using BOX-AREA
display 'Use cursor right/left to next/prev day, down/up to next/prev week ' at 1709 with background-color  Box-Bco foreground-color blue highlight
display 'PgDown, Tab, Space bar = next month; PgUp= previous month         ' at 1809 with background-color  Box-Bco foreground-color blue highlight
display '+ = next year; - = previuos year; Home= jump to current date      ' at 1909 with background-color  Box-Bco foreground-color blue highlight
display 'F1/F2= change fore/backcolor: F3= change borders; F4= toggle title' at 2009 with background-color  Box-Bco foreground-color blue highlight
display 'F5= toggle shadow; F6= toggle language EN/IT F7= change 3D borders' at 2109 with background-color  Box-Bco foreground-color blue highlight
display 'F8= toggle legend, Enter= select date,return to caller; Esc= exit ' at 2209 with background-color  Box-Bco foreground-color blue highlight

*> first calendar. small size, start from currente date
MOVE 'N' to Dtp-shadow
Move 'S' to Dtp-style
move 'S' to Dtp-dim      *> Small Size Calendar
move '004013' to Dtp-r1c1
call GC56DATEPICKER  using DatePicker-Area cancel GC56DATEPICKER

display 'User has selected: '  at 2309 with background-color  Box-Bco foreground-color red highlight
display  Dtp-DateSel           at 2328 with background-color  Box-Bco foreground-color red highlight
display ' - With key: '        at 2337 with background-color  Box-Bco foreground-color red highlight
display   Dtp-Key              at 2350 with background-color  Box-Bco foreground-color red highlight
*> accept omitted
call static "getch" returning Key-Pressed end-call

*> second calendar. big size, set a date from start the calendar (not using current date)
move '20190907' to Dtp-DateSel
MOVE 'N' to Dtp-shadow
Move 'N' to Dtp-style
MOVE 'B' to Dtp-dim      *> Big Size Calendar
move red    to Dtp-bco
move yellow to Dtp-fco
Move 'N' to Dtp-tit
move x'B4' & ' Calendar '  & x'C3' & x'00' to Dtp-titDes
move '004042' to Dtp-r1c1
call GC56DATEPICKER  using DatePicker-Area cancel GC56DATEPICKER

display 'User has selected: '  at 2409 with background-color  Box-Bco foreground-color red highlight
display Dtp-DateSel            at 2428 with background-color  Box-Bco foreground-color red highlight
display ' - With key: '        at 2437 with background-color  Box-Bco foreground-color red highlight
display Dtp-Key                at 2450 with background-color  Box-Bco foreground-color red highlight
*> accept omitted
call static "getch" returning Key-Pressed end-call

goback.

End Program GC56DATEPICKERDEMO.
