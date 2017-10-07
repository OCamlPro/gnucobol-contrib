       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC22MENUDEMO1.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC22MENU -  MENU MANAGEMENT WITH HOT KEY OF MENU ITEMS DEMO
*> Tectonics:  cobc -x GC03YESNODEMO1.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC22MENUDEMO1
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.20
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

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

COPY 'GC01BOX.CPY'.
COPY 'GC22MENU.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

display wDummy at 025080 with blank screen end-display.

display " Activate a menu item with cursor keys or with hot keys (letters in red ) "
        at 021002 :BCOL: 4 :FCOL: 7 highlight end-display

move low-value                              to mn-tab
move z'12007010 Option number one         ' to mn-ele(1)
move z' 4008010 Second choice             ' to mn-ele(2)
move z' 2009010 Third option              ' to mn-ele(3)
move z' 4010010 Forth option              ' to mn-ele(4)
move z' 6011010 Fifth option              ' to mn-ele(5)
move z' 4012010 Sixth option              ' to mn-ele(6)
move z' 2013010 Seventh option            ' to mn-ele(7)
move z' 3014010 Last option               ' to mn-ele(8)
move  ' This is the message associated to the option number one                   ' to mn-mess(1)
move  ' Choose second menu item !                                                 ' to mn-mess(2)
move  ' The 3rd option you can select ..... try it !                              ' to mn-mess(3)
move  ' 444444444444444444444444444444444444444444444444                          ' to mn-mess(4)
move  ' 5 5 5 5 5 5 5 5 5 5                                                       ' to mn-mess(5)
move  ' 666666666666666 666666666666666 6666666666666666666                       ' to mn-mess(6)
move  ' 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77   ' to mn-mess(7)
move  ' 888 888 888 888 888 88888 888888 888888 88888                             ' to mn-mess(8)

move 'Y'   to Mn-Box
*> move black to Mn-Box-fco
*> move 'N'   to Mn-Box-fcoH
move 'S'   to Mn-Box-style
CALL  'GC22MENU' USING BY REFERENCE MENU-AREA

perform DisplayMess thru DisplayMessEx


ACCEPT OMITTED


display wDummy at 2579 with blank screen end-display.
display wTitle at 001001 :BCOL: 4 :FCOL: 7 highlight end-display

display " Activate a menu item with cursor keys or with hot keys (letters in red ) "
        at 021002 :BCOL: 4 :FCOL: 7 highlight end-display

move low-value to mn-tab
move z'12002001 Box       '       to mn-ele(1)
move z' 3002011 Button    '       to mn-ele(2)
move z' 2002022 Menu      '       to mn-ele(3)
move z' 2002033 Calendar  '       to mn-ele(4)
move z' 2002044 Fade Screen '     to mn-ele(5)
move z' 4002057 Screen Saver '    to mn-ele(6)
move z' 3002071 Other    '        to mn-ele(7)
move  ' Demo of Boxes                  ' to mn-mess(1)
move  ' Demo of Buttons                ' to mn-mess(2)
move  ' Demo of Menus                  ' to mn-mess(3)
move  ' Choose a date on calendar      ' to mn-mess(4)
move  ' Some options on fade screens   ' to mn-mess(5)
move  ' Screen Savers                  ' to mn-mess(6)
move  ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
move 'N' to Mn-Box
call  GC22MENU using MENU-AREA.


perform DisplayMess thru DisplayMessEx

*> *************************************************************************************
move cyan     to Box-bco.
move black    to Box-fco.
move '006009' to Box-r1c1.
move '014024' to Box-r2c2.
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA.

move low-value to mn-tab
set Mn-bcoN to Cyan   *> back color for "normal" item
set Mn-fcoN to Black  *> fore color for "normal" item
set Mn-bcoS to black  *> back color for "active" item
set Mn-fcoS to cyan   *> fore color for "active" item
move z'12007010 Box          '    to mn-ele(1)
move z' 2008010 Button       '    to mn-ele(2)
move z' 2009010 Menu         '    to mn-ele(3)
move z' 3010010 Calendar     '    to mn-ele(4)
move z' 2011010 Fade Screen  '    to mn-ele(5)
move z' 3012010 Screen Saver '    to mn-ele(6)
move z' 3013010 Other        '    to mn-ele(7)
move  ' Demo of Boxes                  ' to mn-mess(1)
move  ' Demo of Buttons                ' to mn-mess(2)
move  ' Demo of Menus                  ' to mn-mess(3)
move  ' Choose a date on calendar      ' to mn-mess(4)
move  ' Some options on fade screens   ' to mn-mess(5)
move  ' Screen Savers                  ' to mn-mess(6)
move  ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call  GC22MENU using MENU-AREA.

perform DisplayMess thru DisplayMessEx
*> *************************************************************************************
move white    to Box-bco.
move black    to Box-fco.
move '006029' to Box-r1c1.
move '014044' to Box-r2c2.
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA.

move low-value to mn-tab
set Mn-bcoN to white   *> back color for "normal" item
set Mn-fcoN to Black  *> fore color for "normal" item
set Mn-bcoS to green  *> back color for "active" item
set Mn-fcoS to black  *> fore color for "active" item
move '12007030 Box          '  & x'00'  to mn-ele(1)
move ' 2008030 Button       '  & x'00'  to mn-ele(2)
move ' 2009030 Menu        >'  & x'00'  to mn-ele(3)
move ' 3010030 Calendar    >'  & x'00'  to mn-ele(4)
move ' 2011030 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 3012030 Screen Saver '  & x'00'  to mn-ele(6)
move ' 3013030 Other        '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC22MENU using MENU-AREA.

perform DisplayMess thru DisplayMessEx
*> *************************************************************************************
move red      to Box-bco.
move yellow   to Box-fco.
move '006049' to Box-r1c1.
move '014064' to Box-r2c2.
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA.

move low-value to mn-tab
set Mn-bcoN to red    *> back color for "normal" item
set Mn-fcoN to yellow *> fore color for "normal" item
set Mn-bcoS to yellow *> back color for "active" item
set Mn-fcoS to red    *> fore color for "active" item
move 'Y' to Mn-fcoNH
move '12007050 Box          '  & x'00'  to mn-ele(1)
move ' 2008050 Button       '  & x'00'  to mn-ele(2)
move ' 2009050 Menu         '  & x'00'  to mn-ele(3)
move ' 3010050 Calendar     '  & x'00'  to mn-ele(4)
move ' 2011050 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 3012050 Screen Saver '  & x'00'  to mn-ele(6)
move ' 3013050 Other        '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC22MENU using MENU-AREA.

perform DisplayMess thru DisplayMessEx

*> *************************************************************************************
move magenta  to Box-bco.
move white    to Box-fco.
move '017029' to Box-r1c1.
move '019044' to Box-r2c2.
move 'S'      to Box-style
move 'N'      to Box-3D
move 'N'      to Box-shadow
call GC01BOX using BOX-AREA.

move low-value to mn-tab
set Mn-bcoN to white   *> back color for "normal" item
set Mn-fcoN to magenta *> fore color for "normal" item
set Mn-bcoS to magenta *> back color for "active" item
set Mn-fcoS to white    *> fore color for "active" item
move '12018030 Box          '  & x'00'  to mn-ele(1)
move ' 2018030 Button       '  & x'00'  to mn-ele(2)
move ' 2018030 Menu         '  & x'00'  to mn-ele(3)
move ' 3018030 Calendar     '  & x'00'  to mn-ele(4)
move ' 2018030 Fade Screen  '  & x'00'  to mn-ele(5)
move ' 3018030 Screen Saver '  & x'00'  to mn-ele(6)
move ' 3018030 Other        '  & x'00'  to mn-ele(7)
move ' Demo of Boxes                  ' to mn-mess(1)
move ' Demo of Buttons                ' to mn-mess(2)
move ' Demo of Menus                  ' to mn-mess(3)
move ' Choosee a dat on calendar      ' to mn-mess(4)
move ' Some options on fade screens   ' to mn-mess(5)
move ' Screen Savers                  ' to mn-mess(6)
move ' Exit from GnuCOBOL Demo        ' to mn-mess(7)
call GC22MENU using MENU-AREA.

perform DisplayMess thru DisplayMessEx

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

DisplayMess.
    display " Item selected    = " at 023002 :BCOL: 4 :FCOL: 7 highlight end-display
    display      Mn-Selected       at 023022 :BCOL: 4 :FCOL: 7 highlight end-display
    display " Return key       = " at 023030 :BCOL: 4 :FCOL: 7 highlight end-display
    display      Mn-Key            at 023050 :BCOL: 4 :FCOL: 7 highlight end-display.
DisplayMessEx. Exit.

End Program GC22MENUDEMO1.
