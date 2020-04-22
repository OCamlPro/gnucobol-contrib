ID DIVISION.
PROGRAM-ID. GC21MENUDEMO1.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC21MENU -  MENU MANAGER WITH MOUSE ADDED
*> Tectonics:  cobc -x GC21MENUDEMO1.COB (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC21MENUDEMO1
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0
*> Version:    3.0 2020.04.15
*> Changelog:  1.0 first release.
*>             2.0 mouse management added (left click to mae menu item "active"
*>                                         double left-click to select a menu item
*>             3.0 hot key management added to make menu item "active"
*>                 Mn-Hot from 9(01) to 9(02)
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS ws-KEY.         *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position
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

01  ws-KEY            PIC 9(04) VALUE 9999.
01  ws-Item-Selected  PIC 9(04) VALUE 9999.
01  wTitle            pic x(80) VALUE ALL '_'.
01  wDummy            pic x(01) VALUE     ' '.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

COPY  'GC01BOX.CPY'.
COPY 'GC21MENU.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

display wDummy at 0101 with blank screen end-display.
DISPLAY "GnuCOBOL 3.1 TEXT USER INTERFACE TOOLS COLLECTION - MENU MANAGEMENT." AT 002003
        with foreground-color white background-color red
DISPLAY "NEW RELEASE - WITH MOUSE MANAGEMENT - from DILO (Itay).             " AT 003003
        with foreground-color white background-color red
display "Cursorkeys/mouse leftclick= activate menu item. Enter/lett doubleclick= select. " at 024001
        with background-color 4 foreground-color 7 highlight end-display

move '005008013038' to Box-rc
move black          to Box-bco
move 'S'            to Box-style
call  GC01BOX using BOX-AREA

move low-value                              to mn-tab
move z'102007010 Option number one         ' to mn-ele(1)
move z' 02009010 This is the second option ' to mn-ele(2)
move z' 02011010 Exit                      ' to mn-ele(3)
move  ' This is the message associated to the option number one                   ' to mn-mess(1)
move  ' Choose second menu item !                                                 ' to mn-mess(2)
move  ' Exit from this GnuCOBOL demo.                                             ' to mn-mess(3)
CALL  GC21MENU USING BY REFERENCE MENU-AREA

if Mn-Selected = 03 go to End-of-Program end-if

display wDummy at 0101 with blank screen end-display.
display wTitle at 001001 with background-color 4 foreground-color 7 highlight end-display
display "Cursorkeys/mouse leftclick= activate menu item. Enter/lett doubleclick= select. " at 024001
        with background-color 4 foreground-color 7 highlight end-display

move low-value                           to mn-tab
move z'102002001 Box      '               to mn-ele(1)
move z' 03002011 Button    '              to mn-ele(2)
move z' 02002022 Menu      '              to mn-ele(3)
move z' 02002033 Calendar1 '              to mn-ele(4)
move z' 02002044 Fade Screen '            to mn-ele(5)
move z' 02002057 Screen Saver '           to mn-ele(6)
move z' 03002071 EXIT     '               to mn-ele(7)
move  ' Demo of Boxes                  ' to mn-mess(1)
move  ' Demo of Buttons                ' to mn-mess(2)
move  ' Demo of Menus                  ' to mn-mess(3)
move  ' Choose a date on calendar      ' to mn-mess(4)
move  ' Some options on fade screens   ' to mn-mess(5)
move  ' Screen Savers                  ' to mn-mess(6)
move  ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call  GC21MENU using MENU-AREA

if Mn-Selected = 07 go to End-of-Program end-if

display " Item selected = " at 023001
        Mn-Selected         at 023019
with background-color 4 foreground-color 7 highlight end-display


move cyan     to Box-bco
move black    to Box-fco
move '006009' to Box-r1c1
move '014024' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA

move low-value to mn-tab
set Mn-bcoN to Cyan   *> back color for "normal" item
set Mn-fcoN to Black  *> fore color for "normal" item
set Mn-bcoS to black  *> back color for "selected" item
set Mn-fcoS to cyan   *> fore color for "selected" item
move z'102007010 Box          '    to mn-ele(1)
move z' 03008010 Button       '    to mn-ele(2)
move z' 02009010 Menu         '    to mn-ele(3)
move z' 02010010 Calendar     '    to mn-ele(4)
move z' 02011010 Fade Screen  '    to mn-ele(5)
move z' 02012010 Screen Saver '    to mn-ele(6)
move z' 03013010 EXIT         '    to mn-ele(7)
move  ' Demo of Boxes                  ' to mn-mess(1)
move  ' Demo of Buttons                ' to mn-mess(2)
move  ' Demo of Menus                  ' to mn-mess(3)
move  ' Choose a date on calendar      ' to mn-mess(4)
move  ' Some options on fade screens   ' to mn-mess(5)
move  ' Screen Savers                  ' to mn-mess(6)
move  ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call  GC21MENU using MENU-AREA.

if Mn-Selected = 07 go to End-of-Program end-if

display " Item selected = " at 023001
        Mn-Selected    at 023019
        with background-color 4 foreground-color 7 highlight end-display


*> *************************************************************************************
move white   to Box-bco
move black   to Box-fco
move '006029' to Box-r1c1
move '014044' to Box-r2c2
move 'S' to Box-style
move 'N' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA

move low-value to mn-tab
set Mn-bcoN to white   *> back color for "normal" item
set Mn-fcoN to Black  *> fore color for "normal" item
set Mn-bcoS to green  *> back color for "selected" item
set Mn-fcoS to black  *> fore color for "selected" item
move '102007030 Box          '  & x'00'  to mn-ele(1)
move ' 03008030 Button       '  & x'00'  to mn-ele(2)
move ' 02009030 Menu        >'  & x'00'  to mn-ele(3)
move ' 02010030 Calendar    >'  & x'00'  to mn-ele(4)
move ' 02011030 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 02012030 Screen Saver '  & x'00'  to mn-ele(6)
move ' 03013030 Exit         '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC21MENU using MENU-AREA

if Mn-Selected = 07 go to End-of-Program end-if

display " Item selected = " at 023001
        Mn-Selected         at 023019
        with background-color 4 foreground-color 7 highlight end-display


*> *************************************************************************************
move red     to Box-bco
move yellow  to Box-fco
move '006049' to Box-r1c1
move '014064' to Box-r2c2
move 'S' to Box-style
move 'N' to Box-3D
move 'N' to Box-shadow
call GC01BOX using BOX-AREA

move low-value to mn-tab
set Mn-bcoN to red    *> back color for "normal" item
set Mn-fcoN to yellow *> fore color for "normal" item
set Mn-bcoS to yellow *> back color for "selected" item
set Mn-fcoS to red    *> fore color for "selected" item
move 'Y' to Mn-fcoNH
move '102007050 Box          '  & x'00'  to mn-ele(1)
move ' 03008050 Button       '  & x'00'  to mn-ele(2)
move ' 02009050 Menu         '  & x'00'  to mn-ele(3)
move ' 02010050 Calendar     '  & x'00'  to mn-ele(4)
move ' 02011050 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 02012050 Screen Saver '  & x'00'  to mn-ele(6)
move ' 03013050 Exit         '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC21MENU using MENU-AREA.

if Mn-Selected = 07 go to End-of-Program end-if

display " Item selected = " at 023001
        Mn-Selected         at 023019
        with background-color 4 foreground-color 7 highlight end-display

*> *************************************************************************************
move magenta  to Box-bco
move white    to Box-fco
move '017029' to Box-r1c1
move '019044' to Box-r2c2
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA

move low-value to mn-tab
set Mn-bcoN to white    *> back color for "normal" item
set Mn-fcoN to magenta  *> fore color for "normal" item
set Mn-bcoS to magenta  *> back color for "selected" item
set Mn-fcoS to white    *> fore color for "selected" item
move '102018030 Box          '  & x'00'  to mn-ele(1)
move ' 03018030 Button       '  & x'00'  to mn-ele(2)
move ' 02018030 Menu         '  & x'00'  to mn-ele(3)
move ' 02018030 Calendar     '  & x'00'  to mn-ele(4)
move ' 02018030 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 02018030 Screen Saver '  & x'00'  to mn-ele(6)
move ' 03018030 Exit         '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC21MENU using MENU-AREA.

if Mn-Selected = 07 go to End-of-Program end-if

display " Item selected = " at 023001
        Mn-Selected         at 023019
        with background-color 4 foreground-color 7 highlight end-display.

End-of-Program.

    *> clear screen
    display wDummy at 2579 with blank screen end-display
    display ' GnuCOBOL TUI TOOL - MENU MANAGEMENT (with MOUSE !) - END OF DEMO.'
          at 0301 with foreground-color white background-color green
    *> DISPLAY ITALIAN FLAG
    move '009036014049' to Box-rc
    move black          to Box-bco
    move 'S'            to Box-style
    call  GC01BOX using BOX-AREA
    display '    ' at 010037 with       background-color Green end-display
    display '    ' at 011037 with       background-color Green end-display
    display '    ' at 012037 with       background-color Green end-display
    display '    ' at 013037 with       background-color Green end-display
    display '    ' at 010041 with blink background-color white end-display
    display '    ' at 011041 with blink background-color white end-display
    display '    ' at 012041 with blink background-color white end-display
    display '    ' at 013041 with blink background-color white end-display
    display '    ' at 010045 with blink background-color red   end-display
    display '    ' at 011045 with blink background-color red   end-display
    display '    ' at 012045 with blink background-color red   end-display
    display '    ' at 013045 with blink background-color red   end-display
    display " " at 016001 with background-color black foreground-color black end-display


    goback.

End Program GC21MENUDEMO1.
