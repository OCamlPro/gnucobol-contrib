       >> SOURCE FORMAT IS FREE
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
*> Version:    1.1 2017.02.28
*> Changelog:  1.1 added demo of click effetc.
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
01  i                  pic 999 value zero.
01  wR                 pic 999 value zero.
01  wRetCod            pic 9999 value zero.

    *> SAVE/RESTORE SCREEN VARIABLES
    01    szScreenName        PIC X(256).
    01    iScrOk              BINARY-LONG.


COPY 'GC09BUTTONS.CPY'.
COPY 'GC01BOX.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

display wDummy at 0101 with blank screen end-display


*> display a background
move blue     to Box-bco   set Box-fco to white
move '002002' to Box-r1c1  move '024079' to Box-r2c2
move 'D'      to Box-style move 'N'      to Box-3D
call GC01BOX using BOX-AREA
move 2 to Wr
*> perform varying i from 1 by 1 until i = 22
  *> add 1 to Wr
*> DISPLAY 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        *> AT line wr col 03 with foreground-color white background-color blue
*> end-perform

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 1
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF BUTTONS
set  Box-bco  to white
set  Box-fco  to white
move '006008' to Box-r1c1
move '015026' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
move "E" to Box-3D Move "N" to Box-shadow
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move '1' to Bu-Arrow
move 'N' to Bu-Click
Move '13007011     OK      ' & x'00' to Bu-Ele(01)
Move ' 5009011   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 4011011   Ignore    ' & x'00' to Bu-Ele(03)
Move ' 6013011    Exit     ' & x'00' to Bu-Ele(04)
call GC09BUTTONS using BUTTONS-AREA


STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 022004 with foreground-color white background-color green.
*> accept omitted
call static "getch" returning Key-Pressed end-call.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 2
*> *********************************************************************************
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
move 'N' to Bu-Click
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

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 3
*> *********************************************************************************
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
move 'N' to Bu-Click
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
*> ERASE THE SCREEN
*> *******************************************************************************
display wDummy at 0101 with blank screen end-display

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 4
*> *********************************************************************************
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
move 'N' to Bu-Click

Move '16015020  Continue   ' & x'00' to Bu-Ele(01)
Move ' 5015035   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 6015050  Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 020004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
*> accept omitted
call static "getch" returning Key-Pressed end-call.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 5
*> *********************************************************************************

display wDummy at 0101 with blank screen end-display
*> DISPLAY THE BOX
initialize Box-area ALL TO VALUE
set  Box-bco  to red
set  Box-fco  to white
move '008017012065' to Box-rc
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
move 'N' to Bu-Click
Move '16010020   Cancel    ' & x'00' to Bu-Ele(01)
Move ' 5010035    Save     ' & x'00' to Bu-Ele(02)
Move ' 6010050    Goto     ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 020004 with foreground-color white background-color green.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 021004 with foreground-color white background-color green.
*> accept omitted
call static "getch" returning Key-Pressed end-call.


*> DISPLAY BUTTONS WITH CLICK EFFECT

*> display a background
move blue     to Box-bco   set Box-fco to white
move '002002' to Box-r1c1  move '024079' to Box-r2c2
move 'D'      to Box-style move 'N'      to Box-3D
call GC01BOX using BOX-AREA
*> move 2 to Wr
*> perform varying i from 1 by 1 until i = 22
  *> add 1 to Wr
*> DISPLAY 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        *> AT line wr col 03 with foreground-color white background-color blue
*> end-perform

DISPLAY '   Buttons with ''click effect''     '
        AT line 04 col 06 with foreground-color white background-color blue

move Z'SAVESCREEN.SCR' to szScreenName
call static 'scr_dump' using by reference szScreenName returning iScrOk end-call


*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 6
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF BUTTONS
set  Box-bco  to white
set  Box-fco  to white
move '008031' to Box-r1c1
move '017053' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
move "E" to Box-3D Move "N" to Box-shadow
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move '1' to Bu-Arrow
move 'Y' to Bu-Click
move 'Y' to Bu-Beep
Move '13009036     OK      ' & x'00' to Bu-Ele(01)
Move ' 5011036   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 4013036   Ignore    ' & x'00' to Bu-Ele(03)
Move ' 6015036    Exit     ' & x'00' to Bu-Ele(04)
call GC09BUTTONS using BUTTONS-AREA


call static 'scr_restore' using by reference szScreenName returning iScrOk end-call

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 2
*> *********************************************************************************
set  Box-bco  to white
set  Box-fco  to white
move '006031' to Box-r1c1
move '021053' to Box-r2c2
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
move 'Y' to Bu-Click
Move ' 3008036     Edit    ' & x'00' to Bu-Ele(01)
Move ' 5010036     Help    ' & x'00' to Bu-Ele(02)
Move '14012036    Ignore   ' & x'00' to Bu-Ele(03)
Move ' 6014036    Cancel   ' & x'00' to Bu-Ele(04)
Move ' 6016036     Exit    ' & x'00' to Bu-Ele(05)
Move ' 6018036      ?      ' & x'00' to Bu-Ele(06)
call GC09BUTTONS using BUTTONS-AREA

call static 'scr_restore' using by reference szScreenName returning iScrOk end-call
CALL 'CBL_DELETE_FILE' USING szScreenName
*> display "return code " at 0103
*> move return-code to wRetCod
*> display wRetCod at 0116
*> accept omitted.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 4
*> *********************************************************************************
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
move 'Y' to Bu-Click

Move '16015020  Continue   ' & x'00' to Bu-Ele(01)
Move ' 5015035   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 6015050  Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA


*> accept omitted
call static "getch" returning Key-Pressed end-call.


goback.


End Program GC09BUTTONSDEMO.
