       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
program-id. GC18RADIOBUTTONDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC18RADIOBUTTONDEMO -  DISPLAYS & MANAGE RADIOBUTTONS ON SCREEN
*> Tectonics:  cobc -x GC18RADIOBUTTONDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC18RADIOBUTTONDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License LGPL 3.0 (or greater)
*> Version:    1.1 2017.11.04
*> Changelog:  1.0 first version.
*>             1.1 Rb-hot from 9(01) to 9(02)
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

01 wBco        PIC 9  value cyan.
01  wDummy            pic x(01) VALUE     ' '.
01  wString           pic x(70) VALUE     ' '.
01  i                  pic 999 value zero.
01  wR                 pic 999 value zero.
01  wRetCod            pic 9999 value zero.

*> SAVE/RESTORE SCREEN VARIABLES
01    szScreenName        PIC X(256).
01    iScrOk              BINARY-LONG.

COPY 'GC01BOX.CPY'.
COPY 'GC18RADIOBUTTON.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    *> display omitted at 0101 with blank screen end-display

Start-Display.
  initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    call GC01BOX using Box-Area
    move 2 to Wr

    display 'GnuCOBOL-GC18RADIOBUTTON TUITOOL at work.Manage RadioButton items on screen.'
          at 2203 with foreground-color white background-color wBco
    display 'Cursor/Page/Tab and spacebar keys change and ''mark'' active RadioButton.'
          at 2303 with foreground-color white background-color wBco
    display "Activate an item also with hot keys (letters in yellow ) "
          at 2403 with foreground-color white background-color wBco end-display
*> *********************************************************************************
*> DISPLAY RADIOBUTTON NUMBER 1
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF SCREEN
set  Box-bco   Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'Y' to Box-tit
move black to Box-titFco
move 'N'   to Box-titFcoH
move ' Select one of the Options for each group ' & x'00' to Box-titDes
call GC01BOX using BOX-AREA

*> DISPLAY A BOX AS BACKGROUND OF A RADIOBUTTON ITEMS GROUP 1
set  Box-bco   Box-fco to white
move '003005013040' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D

call GC01BOX using BOX-AREA
display ' Group 1 Options ' at 003006 with :BCOL: white :FCOL: black end-display
*> DISPLAY RADIOBUTTON ITEMS N.1
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
Move '  02004011 Stop after first error     ' & x'00' to Rb-Ele(01)
Move '1102005011 Allow LABEL and GOTO       ' & x'00' to Rb-Ele(02)
Move '  02006011 Enable macros              ' & x'00' to Rb-Ele(03)
Move '  03007011 Allow inline               ' & x'00' to Rb-Ele(04)
Move '  02008011 Include assertion code     ' & x'00' to Rb-Ele(05)
Move '  02009011 Load compatible units      ' & x'00' to Rb-Ele(06)
Move '  05010011 Allow STATIC in objects    ' & x'00' to Rb-Ele(07)
Move '  02011011 C like operators           ' & x'00' to Rb-Ele(08)
Move '  03012011 Conditional defines        ' & x'00' to Rb-Ele(09)
call GC18RADIOBUTTON using RadioButton-Area
perform DisplaySwitch thru DisplaySwitchEx.


*> DISPLAY A BOX AS BACKGROUND OF A RadioButton ITEMS GROUP
set  Box-bco   Box-fco to white
move '003048011075' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
call GC01BOX using BOX-Area
display ' Group 2 of Options ' at 003049 with :BCOL: white :FCOL: white highlight end-display

*> DISPLAY RADIOBUTTON ITEMS N.2

initialize RadioButton-Area ALL TO VALUE
move low-value to Rb-tab
move 'x'       to Rb-MarkChar
move '[]'      to Rb-BracketChars
move blue to Rb-bcoN Rb-bcoA Rb-bcoH
move cyan to Rb-fcoN
Move '  02004054 Counts              ' & x'00' to Rb-Ele(01)
Move '1102005054 Percentages         ' & x'00' to Rb-Ele(02)
Move '  02006054 Valid uppercase     ' & x'00' to Rb-Ele(03)
Move '  02007054 Error Messages      ' & x'00' to Rb-Ele(04)
Move '  02008054 Reserved words      ' & x'00' to Rb-Ele(05)
Move '  03009054 Colums stats        ' & x'00' to Rb-Ele(06)
Move '  02010054 Total stats         ' & x'00' to Rb-Ele(07)
call GC18RADIOBUTTON using RadioButton-Area
perform DisplaySwitch thru DisplaySwitchEx.

*> DISPLAY A BOX AS BACKGROUND OF A RADIOBUTTON ITEMS GROUP
set  Box-bco   Box-fco to white
move '014005018040' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
call GC01BOX using BOX-Area
display ' Group 3 Options ' at 014006 with :BCOL: white :FCOL: black end-display
*> DISPLAY RADIOBUTTON ITEMS N.3
initialize RadioButton-Area ALL TO VALUE
move low-value                                   to Rb-tab
move 'o'  to Rb-MarkChar
move '<>' to Rb-BracketChars
Move '  02015011 Counts                     ' & x'00' to Rb-Ele(01)
Move '1102016011 Percentages                ' & x'00' to Rb-Ele(02)
Move '  02017011 Valid uppercase            ' & x'00' to Rb-Ele(03)
call GC18RADIOBUTTON using RadioButton-Area
perform DisplaySwitch thru DisplaySwitchEx.


*> DISPLAY RADIOBUTTON ITEMS N.4
display ' Group 4 Options ' at 012045 with :BCOL: white :FCOL: black end-display
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
move 'o'     to Rb-MarkChar
move blue    to Rb-bcoN Rb-bcoA Rb-bcoH
move yellow  to Rb-fcoN
move red     to Rb-fcoH
move 'Y'     to Rb-fcoNH
Move '  00013048 01-Stop after first error ' & x'00' to Rb-Ele(01)
Move '  00014048 02-Allow LABEL and GOTO   ' & x'00' to Rb-Ele(02)
Move '1100015048 03-Enable macros          ' & x'00' to Rb-Ele(03)
Move '  00016048 04-Disable warnings       ' & x'00' to Rb-Ele(04)
Move '  00017048 05-Overnight              ' & x'00' to Rb-Ele(05)
Move '  00017048 06-Include assertion code ' & x'00' to Rb-Ele(06)
Move '  00017048 07-Load compatible units  ' & x'00' to Rb-Ele(07)
Move '  00017048 08-Allow STATIC in objects' & x'00' to Rb-Ele(08)
Move '  00017048 09-C like operators       ' & x'00' to Rb-Ele(09)
Move '  00017048 0A-Overlapped items !     ' & x'00' to Rb-Ele(10)
call GC18RADIOBUTTON using RadioButton-Area
perform DisplaySwitch thru DisplaySwitchEx.

accept omitted.
    DISPLAY 'ESC = return to previous screen, Enter to select and Exit '
         AT 022003 with foreground-color yellow background-color wBco highlight.


*> *********************************************************************************
*> DISPLAY RADIOBUTTON - ALL PAGE
*> *********************************************************************************


*> DISPLAY A BOX AS BACKGROUND OF RADIOBUTTON ITEMS
set  Box-bco Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'N' to Box-tit
call GC01BOX using BOX-Area

set  Box-bco   Box-fco to white
move '003005019074' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'R'            to Box-3D
Move 'Y' to Box-tit
move ' Browse and Select only one of the available Options ' & x'00' to Box-titDes
call GC01BOX using BOX-Area

*> DISPLAY RADIOBUTTON ITEMS N.1
display 'Options'     at 004007 with :BCOL: white :FCOL: black  end-display
display 'Command set' at 015007 with :BCOL: white :FCOL: black  end-display
display 'Auto-Save'   at 013042 with :BCOL: white :FCOL: black  end-display
initialize RadioButton-Area ALL TO VALUE
move low-value                                       to Rb-tab
Move '  02005011 Stop after first error     ' & x'00' to Rb-Ele(01)
Move '  02006011 Allow LABEL and GOTO       ' & x'00' to Rb-Ele(02)
Move '  02007011 Enable macros              ' & x'00' to Rb-Ele(03)
Move '  03008011 Allow inline               ' & x'00' to Rb-Ele(04)
Move '  02009011 Include assertion code     ' & x'00' to Rb-Ele(05)
Move '  02010011 Load compatible units      ' & x'00' to Rb-Ele(06)
Move '  04011011 Allow STATIC in objects    ' & x'00' to Rb-Ele(07)
Move '  02012011 C like operators           ' & x'00' to Rb-Ele(08)
Move '  03013011 Conditional defines        ' & x'00' to Rb-Ele(09)

Move '  02016011 Counts                     ' & x'00' to Rb-Ele(10)
Move '  02017011 Percentages                ' & x'00' to Rb-Ele(11)
Move '  02018011 Valid uppercase            ' & x'00' to Rb-Ele(12)

Move '  00005046 Counts                    ' & x'00' to Rb-Ele(13)
Move '1100006046 Percentages               ' & x'00' to Rb-Ele(14)
Move '  00007046 Valid uppercase           ' & x'00' to Rb-Ele(15)
Move '  00008046 Error Messages            ' & x'00' to Rb-Ele(16)
Move '  00009046 Reserved words            ' & x'00' to Rb-Ele(17)
Move '  00010046 Colums stats              ' & x'00' to Rb-Ele(18)
Move '  00011046 Total stats               ' & x'00' to Rb-Ele(19)

Move '  03014046 01-Stop after first error ' & x'00' to Rb-Ele(20)
Move '  03015046 02-Allow LABEL and GOTO   ' & x'00' to Rb-Ele(21)
Move '  03016046 03-Enable macros          ' & x'00' to Rb-Ele(22)
Move '  03017046 03-Disable warnings       ' & x'00' to Rb-Ele(23)
Move '  03018046 04-Overnight              ' & x'00' to Rb-Ele(24)
Move '  03018046 05-Include assertion code ' & x'00' to Rb-Ele(25)
Move '  03018046 06-Load compatible units  ' & x'00' to Rb-Ele(26)
Move '  03018046 07-Allow STATIC in objects' & x'00' to Rb-Ele(27)
Move '  03018046 08-C like operators       ' & x'00' to Rb-Ele(28)
Move '  03018046 09-Overlapped items !     ' & x'00' to Rb-Ele(29)

call GC18RADIOBUTTON using RadioButton-Area
perform DisplaySwitch thru DisplaySwitchEx.

accept omitted at 2580

if Rb-Key = Key-Escape go to Start-Display end-if

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


DisplaySwitch.
    DISPLAY '                                                                            '
         AT 022003 with foreground-color white background-color wBco.
    STRING 'Options set to: -'
                      Rb-Mark(01) '-' Rb-Mark(02) '-' Rb-Mark(03) '-' Rb-mark(04) '-' Rb-Mark(05) '-'
                      Rb-Mark(06) '-' Rb-Mark(07) '-' Rb-Mark(08) '-' Rb-mark(09) '-' Rb-Mark(10) '-'
                      Rb-Mark(11) '-' Rb-Mark(12) '-' Rb-Mark(13) '-' Rb-mark(14) '-' Rb-Mark(15) '-'
                      Rb-Mark(16) '-' Rb-Mark(17) '-' Rb-Mark(18) '-' Rb-mark(19) '-' Rb-Mark(20) '-'
                      Rb-Mark(21) '-' Rb-Mark(22) '-' Rb-Mark(23) '-' Rb-mark(24) '-' Rb-Mark(25) '-'
                      Rb-Mark(26) '-' Rb-Mark(27) '-' Rb-Mark(28) '-' Rb-mark(29) '-' Rb-Mark(30) '+'
             into wSTRING.
    DISPLAY wSTRING     AT 021003 with foreground-color yellow highlight background-color wBco.
    DISPLAY Rb-Selected AT 021076 with foreground-color yellow highlight background-color wBco.

    continue.
DisplaySwitchEx. Exit.


End Program GC18RADIOBUTTONDEMO.
