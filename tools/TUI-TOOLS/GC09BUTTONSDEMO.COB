       >> SOURCE FORMAT IS FREE
ID DIVISION.
program-id. GC09BUTTONSDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF HOW TO USE GC09BUTTONS -  DISPLAYS BUTTONS ON SCREEN
*> Tectonics:  cobc -x GC09BUTTONSDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC09BUTTONSDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.3 2017.11.04
*> Changelog:  1.1 added demo of click effect
*>             1.2 hot key management.
*>             1.3 Bu-Hot from 9(01) to 9(02)
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


    *> display a big box as background
    move blue     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    call GC01BOX using BOX-AREA
    move 2 to Wr
    display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
          at 2103 with foreground-color white background-color blue
    display ' Cursor/Page/Tab and spacebar keys change active Button.'
          at 2203 with foreground-color white background-color blue
    display " Activate an item (give the 'focus to') also with hot keys (red characters) "
          at 2303 with foreground-color white background-color blue

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 1
*> *********************************************************************************
display ' 4 Vertical buttons ' at 2403 with foreground-color white background-color blue
*> DISPLAY A BOX AS BACKGROUND OF BUTTONS
set  Box-bco   Box-fco to white
move '006005015026' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move "E"            to Box-3D
call GC01BOX using BOX-AREA
*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move '1' to Bu-Arrow
move 'N' to Bu-Click
Move '108007008       Ok       ' & x'00' to Bu-Ele(01)
Move ' 06009008     Cancel     ' & x'00' to Bu-Ele(02)
Move ' 06011008     Ignore     ' & x'00' to Bu-Ele(03)
Move ' 07013008      Exit      ' & x'00' to Bu-Ele(04)
call GC09BUTTONS using BUTTONS-AREA


STRING " Bu-Selected ......: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 002004 with foreground-color white background-color blue.
STRING " Bu-Key code ......: " Bu-Key      into wSTRING.
DISPLAY wSTRING AT 003004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 2
*> *********************************************************************************
    display ' 6 Vertical buttons other colors and active ''button marker'' '
          at 2403 with foreground-color yellow highlight background-color blue
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
Move ' 06006036     Edit    ' & x'00' to Bu-Ele(01)
Move ' 06008036     Help    ' & x'00' to Bu-Ele(02)
Move '105010036    Ignore   ' & x'00' to Bu-Ele(03)
Move ' 05012036    Cancel   ' & x'00' to Bu-Ele(04)
Move ' 07014036     Exit    ' & x'00' to Bu-Ele(05)
Move ' 07016036      1      ' & x'00' to Bu-Ele(06)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected ......: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 002004 with foreground-color white background-color blue.
STRING " Bu-Key code ......: " Bu-Key      into wSTRING.
DISPLAY wSTRING AT 003004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 3
*> *********************************************************************************
    display ' 3 vetical buttons other colors and ''='' as ''button marker'' '
          at 2403 with foreground-color white background-color blue
initialize Box-area ALL TO VALUE
set  Box-bco  Box-fco to white
move '007060016073' to Box-rc
move 'S'            to Box-style
move "R"            to Box-3D
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
Move ' 02009063 Pause ' & x'00' to Bu-Ele(01)
Move '102011063 Abcde ' & x'00' to Bu-Ele(02)
Move ' 02013063 Enter ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected ......: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 002004 with foreground-color white background-color blue.
STRING " Bu-Key code ......: " Bu-Key      into wSTRING.
DISPLAY wSTRING AT 003004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.


*> ******************************************************************************+
*> ERASE THE SCREEN
*> *******************************************************************************
display wDummy at 0101 with blank screen end-display

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 3 bis
*> *********************************************************************************
    display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
          at 2103 with foreground-color white background-color blue
    display ' Cursor/Page/Tab and spacebar keys change active Button.'
          at 2203 with foreground-color white background-color blue
    display " Activate an item (give the 'focus to') also with hot keys (red characters) "
          at 2303 with foreground-color white background-color blue
    display ' 3 horizontal buttons other colors and ''(   )'' as ''button marker'' '
          at 2403 with foreground-color yellow highlight background-color blue
*> DISPLAY A BOX
set  Box-bco  Box-fco to white
move '013017017072' to Box-rc
move 'S'      to Box-style
move 'N'      to Box-3D Box-shadow
move "E" to Box-3D
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

Move '103015020  1 Continue   ' & x'00' to Bu-Ele(01)
Move ' 03015037  2  Cancel    ' & x'00' to Bu-Ele(02)
Move ' 03015054  3 Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected ......: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 002004 with foreground-color white background-color blue.
STRING " Bu-Key code ......: " Bu-Key      into wSTRING.
DISPLAY wSTRING AT 003004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.


*> ******************************************************************************+
*> ERASE THE SCREEN
*> *******************************************************************************
display wDummy at 0101 with blank screen end-display

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 4
*> *********************************************************************************
    display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
          at 2103 with foreground-color white background-color blue
    display ' Cursor/Page/Tab and spacebar keys change active Button.'
          at 2203 with foreground-color white background-color blue
    display " Activate an item (give the 'focus to') also with hot keys (red characters) "
          at 2303 with foreground-color white background-color blue
    display ' 3 horizontal buttons other colors and ''(   )'' as ''button marker'' '
          at 2403 with foreground-color yellow highlight background-color blue
*> DISPLAY A BOX
set  Box-bco  Box-fco to white
move '013017017065' to Box-rc
move 'S'      to Box-style
move 'N'      to Box-3D Box-shadow
move "E" to Box-3D
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

Move '103015020  Continue   ' & x'00' to Bu-Ele(01)
Move ' 05015035   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 03015050  Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected ......: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 002004 with foreground-color white background-color blue.
STRING " Bu-Key code ......: " Bu-Key      into wSTRING.
DISPLAY wSTRING AT 003004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 5
*> *********************************************************************************

display wDummy at 0101 with blank screen end-display
    display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
          at 2103 with foreground-color white background-color blue
    display ' Cursor/Page/Tab and spacebar keys change active Button.'
          at 2203 with foreground-color white background-color blue
    display " Activate an item (give the 'focus to') also with hot keys (red characters) "
          at 2303 with foreground-color white background-color blue
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
Move '104010020   Cancel    ' & x'00' to Bu-Ele(01)
Move ' 05010035    Save     ' & x'00' to Bu-Ele(02)
Move ' 05010050    Goto     ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING " Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 019003 with foreground-color white background-color blue.
STRING " Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 020003 with foreground-color white background-color blue.
*> accept omitted
call static "getch" returning Key-Pressed end-call.


*> DISPLAY BUTTONS WITH CLICK EFFECT

*> display a background
move blue     to Box-bco   set Box-fco to white
move '002002' to Box-r1c1  move '024079' to Box-r2c2
move 'D'      to Box-style move 'N'      to Box-3D
call GC01BOX using BOX-AREA

DISPLAY '   Buttons with ''click effect''     '
        AT line 04 col 06 with foreground-color white background-color blue

display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
        at 2103 with foreground-color white background-color blue
display ' Cursor/Page/Tab and spacebar keys change active Button.'
        at 2203 with foreground-color white background-color blue
display " Activate an item (give the 'focus to') also with hot keys (red characters) "
        at 2303 with foreground-color white background-color blue

*> save the background
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

    display ' GnuCOBOL TUI TOOL to display buttons on screen. GC09BUTTONS at work.'
          at 2103 with foreground-color white background-color blue
    display ' Cursor/Page/Tab and spacebar keys change active Button.'
          at 2203 with foreground-color white background-color blue
    display " Activate an item (give the 'focus to') also with hot keys (red characters) "
          at 2303 with foreground-color white background-color blue

*> DISPLAY BUTTONS
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab
move '1' to Bu-Arrow
move 'Y' to Bu-Click
move 'Y' to Bu-Beep
Move '106009036     Ok      ' & x'00' to Bu-Ele(01)
Move ' 04011036   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 04013036   Ignore    ' & x'00' to Bu-Ele(03)
Move ' 05015036    Exit     ' & x'00' to Bu-Ele(04)
call GC09BUTTONS using BUTTONS-AREA

move space to wString
STRING "Bu-Selected: " Bu-Selected into wSTRING.
DISPLAY wSTRING AT 019004 with foreground-color white background-color blue.
STRING "Bu-Key:      " Bu-Key   into wSTRING.
DISPLAY wSTRING AT 020004 with foreground-color white background-color blue.
call static "getch" returning Key-Pressed end-call.

*> restore the background
call static 'scr_restore' using by reference szScreenName returning iScrOk end-call

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 7
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
Move ' 06008036     Edit    ' & x'00' to Bu-Ele(01)
Move ' 06010036     Help    ' & x'00' to Bu-Ele(02)
Move '105012036    Ignore   ' & x'00' to Bu-Ele(03)
Move ' 05014036    Cancel   ' & x'00' to Bu-Ele(04)
Move ' 07016036     Exit    ' & x'00' to Bu-Ele(05)
Move ' 07018036      1      ' & x'00' to Bu-Ele(06)
call GC09BUTTONS using BUTTONS-AREA

call static 'scr_restore' using by reference szScreenName returning iScrOk end-call
CALL 'CBL_DELETE_FILE' USING szScreenName
*> display "return code " at 0103
*> move return-code to wRetCod
*> display wRetCod at 0116
*> accept omitted.

*> *********************************************************************************
*> DISPLAY BUTTONS NUMBER 8
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

Move '103015020  Continue   ' & x'00' to Bu-Ele(01)
Move ' 05015035   Cancel    ' & x'00' to Bu-Ele(02)
Move ' 03015050  Inspect    ' & x'00' to Bu-Ele(03)
call GC09BUTTONS using BUTTONS-AREA


*> accept omitted
call static "getch" returning Key-Pressed end-call.

*> ***********************************************************************************************
*> DISPLAY ITALAN FLAG
*> ***********************************************************************************************
  initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    call GC01BOX using Box-Area

     move '009036014049' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
     call  GC01BOX using BOX-AREA
     display '    ' at 010037 with foreground-color white background-color Green end-display
     display '    ' at 011037 with foreground-color white background-color Green end-display
     display '    ' at 012037 with foreground-color white background-color Green end-display
     display '    ' at 013037 with foreground-color white background-color Green end-display
     display '    ' at 010041 with blink foreground-color white background-color white end-display
     display '    ' at 011041 with blink foreground-color white background-color white end-display
     display '    ' at 012041 with blink foreground-color white background-color white end-display
     display '    ' at 013041 with blink foreground-color white background-color white end-display
     display '    ' at 010045 with blink foreground-color white background-color red   end-display
     display '    ' at 011045 with blink foreground-color white background-color red   end-display
     display '    ' at 012045 with blink foreground-color white background-color red   end-display
     display '    ' at 013045 with blink foreground-color white background-color red   end-display
   ACCEPT OMITTED.

goback.


End Program GC09BUTTONSDEMO.
