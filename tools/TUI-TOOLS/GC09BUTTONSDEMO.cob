ID DIVISION.
program-id. GC09BUTTONSDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC09BUTTONSDEMO -  DISPLAYS BUTTONS ON SCREEN
*> Tectonics:  cobc -x GC09BUTTONSDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC09BUTTONSDEMO
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
01  wString           pic x(40) VALUE     ' '.

COPY 'GC09BUTTONS.CPY'.
COPY 'GC01BOX.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
set environment "cob_screen_exceptions" to "y".

display wDummy at 0101 with blank screen end-display


move blue     to Box-bco   set Box-fco to white
move '002002' to Box-r1c1  move '024079' to Box-r2c2
move 'D'      to Box-style move 'N'      to Box-3D
call GC01BOX using BOX-AREA

*> **********************************************************  BUTTONS NUMBER 1
*> DISPLAY A BOX
set  Box-bco  to white
set  Box-fco  to white
move '005008' to Box-r1c1
move '016026' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
move "E" to Box-3D Move "N" to Box-shadow
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move '1' to Bu-Arrow
Move '13007011     OK      ' & x'00' to Bu-Ele(01)
Move ' 5009011   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 4011011   Ignore    ' & x'00' to Bu-Ele(03)
Move ' 6013011    Exit     ' & x'00' to Bu-Ele(04)
call GC09BUTTONS using BUTTONS-AREA


STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 022004 with foreground-color white background-color green.
accept omitted

*> **********************************************************  BUTTONS NUMBER 2
set  Box-bco  to white
set  Box-fco  to white
move '004031' to Box-r1c1
move '019053' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
*> move "R" to Box-3D
Move "N" to Box-shadow
Move 'Y' to Box-tit
Move ' Select a Button ' & x'00' to Box-titDes
call GC01BOX using BOX-AREA

initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move yellow to Bu-fcoS
move red    to Bu-bcoS
move '2' to Bu-Arrow
Move ' 3006036     Edit    ' & x'00' to Bu-Ele(01)
Move ' 5008036     Help    ' & x'00' to Bu-Ele(02)
Move '14010036    Ignore   ' & x'00' to Bu-Ele(03)
Move ' 6012036    Cancel   ' & x'00' to Bu-Ele(04)
Move ' 6014036     Exit    ' & x'00' to Bu-Ele(05)
Move ' 6016036      ?      ' & x'00' to Bu-Ele(06)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green highlight.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 022004 with foreground-color white background-color green highlight.

*> **********************************************************  BUTTONS NUMBER 3
initialize Box-area ALL TO VALUE
set  Box-bco  to white
set  Box-fco  to white
move '007058' to Box-r1c1
move '016076' to Box-r2c2
move 'S'      to Box-style
move "R" to Box-3D
call GC01BOX using BOX-AREA

initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move white   to Bu-fcoN
move magenta to Bu-bcoN
move blue    to Bu-fcoS
move cyan    to Bu-bcoS
move '1' to Bu-Arrow
move "==" to Bu-Arrow-Chars
Move ' 5009061    Pause    ' & x'00' to Bu-Ele(01)
Move '14011061   Ignore    ' & x'00' to Bu-Ele(02)
Move ' 6013061    Enter    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 022004 with foreground-color white background-color green highlight.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 023004 with foreground-color white background-color green highlight.


*> ******************************************************************************+
*> ERASE SCREEN
*> *******************************************************************************
display wDummy at 0101 with blank screen end-display

*> **********************************************************  BUTTONS NUMBER 4
*> DISPLAY A BOX
set  Box-bco  to white
set  Box-fco  to white
move '013017017065' to Box-rc
move 'S'      to Box-style
move 'N'      to Box-3D
move "E" to Box-3D
Move "N" to Box-shadow
Move 'Y' to Box-tit
Move ' Buttons ' & x'00' to Box-titDes
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move green  to Bu-bcoN
move white  to Bu-fcoN
move blue to Bu-bcoS
move yellow  to Bu-fcoS
move '2' to Bu-Arrow
move "(" to Bu-Arrow-Char1
move ")" to Bu-Arrow-Char2

Move '16015020  Continue   ' & x'00' to Bu-Ele(01)
Move ' 5015035   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 6015050  Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 020004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
accept omitted

*> **********************************************************  BUTTONS NUMBER 5
*> DISPLAY THE BOX
initialize Box-area ALL TO VALUE
set  Box-bco  to red
set  Box-fco  to white
move '013017017065' to Box-rc
move 'S'      to Box-style
move 'N'      to Box-3D
move "E" to Box-3D Move "N" to Box-shadow
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move green  to Bu-bcoN
move white  to Bu-fcoN
move blue   to Bu-bcoS
move yellow  to Bu-fcoS
move Box-bco to Bu-bcoShadow
move '2' to Bu-Arrow
move "()" to Bu-Arrow-Chars

Move '16015020   Cancel    ' & x'00' to Bu-Ele(01)
Move ' 5015035    Save     ' & x'00' to Bu-Ele(02)
Move ' 6015050    Goto     ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 020004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
accept omitted
goback.


End Program GC09BUTTONSDEMO.
