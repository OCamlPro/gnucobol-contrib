       >> SOURCE FORMAT IS FREE
ID DIVISION.
program-id. GC13CHECKBOXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC13CHECKBOXDEMO -  DISPLAYS CHECKBOX ON SCREEN
*> Tectonics:  cobc -x GC13CHECKBOXDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC13CHECKBOXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2017.07.10
*> Changelog:  1.0 first version.
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
01  wString           pic x(70) VALUE     ' '.
01  i                  pic 999 value zero.
01  wR                 pic 999 value zero.
01  wRetCod            pic 9999 value zero.

*> SAVE/RESTORE SCREEN VARIABLES
01    szScreenName        PIC X(256).
01    iScrOk              BINARY-LONG.

COPY 'GC01BOX.CPY'.
COPY 'GC13CHECKBOX.CPY'.
COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    *> display omitted at 0101 with blank screen end-display

    *> display a big box as background
    move blue     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    call GC01BOX using BOX-AREA
    move 2 to Wr

    display ' GnuCOBOL - GC13CHECKBOX TUI TOOL at work. manage checkbox items on screen.'
          at 2303 with foreground-color white background-color blue
    display ' Cursor/Page/Tab keys change active checkbox, spacebar mark/unmark checkbox'
          at 2403 with foreground-color white background-color blue

*> *********************************************************************************
*> DISPLAY CHECKBOX NUMBER 1
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF CHECKBOX ITEMS
set  Box-bco   Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'Y' to Box-tit
move ' Set switches ' & x'00' to Box-titDes
call GC01BOX using BOX-AREA

set  Box-bco   Box-fco to white
move '003005013040' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow Box-tit
move 'R'            to Box-3D
call GC01BOX using BOX-AREA

*> DISPLAY CHECKBOX ITEMS N.1
initialize CHECKBOX-area ALL TO VALUE
move low-value                                       to Ck-tab
Move '112004011 Stop after first error     ' & x'00' to Ck-Ele(01)
Move ' 12005011 Allow LABEL and GOTO       ' & x'00' to Ck-Ele(02)
Move '  2006011 Enable macros              ' & x'00' to Ck-Ele(03)
Move ' 13007011 Allow inline               ' & x'00' to Ck-Ele(04)
Move ' 12008011 Include assertion code     ' & x'00' to Ck-Ele(05)
Move ' 12009011 Load compatible units      ' & x'00' to Ck-Ele(06)
Move '  5010011 Allow STATIC in objects    ' & x'00' to Ck-Ele(07)
Move '  2011011 C like operators           ' & x'00' to Ck-Ele(08)
Move ' 13012011 Conditional defines        ' & x'00' to Ck-Ele(09)
call GC13CHECKBOX using CHECKBOX-AREA
perform DisplaySwitch thru DisplaySwitchEx.



*> DISPLAY CHECKBOX ITEMS N.2
initialize CHECKBOX-area ALL TO VALUE
move low-value to Ck-tab
move 'x'       to Ck-MarkChar
move '()'      to Ck-BracketChars
Move ' 12004054 Counts              ' & x'00' to Ck-Ele(01)
Move '112005054 Percentages         ' & x'00' to Ck-Ele(02)
Move '  2006054 Valid uppercase     ' & x'00' to Ck-Ele(03)
Move ' 12007054 Error Messages      ' & x'00' to Ck-Ele(04)
Move ' 12008054 Reserved words      ' & x'00' to Ck-Ele(05)
Move ' 13009054 Colums stats        ' & x'00' to Ck-Ele(06)
Move '  2010054 Total stats         ' & x'00' to Ck-Ele(07)
call GC13CHECKBOX using CHECKBOX-AREA
perform DisplaySwitch thru DisplaySwitchEx.


*> DISPLAY CHECKBOX ITEMS N.3
initialize CHECKBOX-area ALL TO VALUE
move low-value                                   to Ck-tab
move 'o'  to Ck-MarkChar
move '<>' to Ck-BracketChars
Move ' 12015011 Counts              ' & x'00' to Ck-Ele(01)
Move '1 2016011 Percentages         ' & x'00' to Ck-Ele(02)
Move '  2017011 Valid uppercase     ' & x'00' to Ck-Ele(03)
call GC13CHECKBOX using CHECKBOX-AREA
perform DisplaySwitch thru DisplaySwitchEx.


*> DISPLAY CHECKBOX ITEMS N.4
initialize CHECKBOX-area ALL TO VALUE
move low-value                                       to Ck-tab
move 'o'  to Ck-MarkChar
Move '1 3013048 01-Stop after first error ' & x'00' to Ck-Ele(01)
Move ' 13014048 02-Allow LABEL and GOTO   ' & x'00' to Ck-Ele(02)
Move '  3015048 03-Enable macros          ' & x'00' to Ck-Ele(03)
Move '  3016048 03-Disable warnings       ' & x'00' to Ck-Ele(04)
Move ' 13017048 04-Overnight              ' & x'00' to Ck-Ele(05)
Move ' 13017048 05-Include assertion code ' & x'00' to Ck-Ele(06)
Move ' 13017048 06-Load compatible units  ' & x'00' to Ck-Ele(07)
Move '  3017048 07-Allow STATIC in objects' & x'00' to Ck-Ele(08)
Move '  3017048 08-C like operators       ' & x'00' to Ck-Ele(09)
Move ' 13017048 09-Overlapped items !     ' & x'00' to Ck-Ele(10)
call GC13CHECKBOX using CHECKBOX-AREA
perform DisplaySwitch thru DisplaySwitchEx.

accept omitted.


*> *********************************************************************************
*> DISPLAY CHECKBOX - ALL PAGE
*> *********************************************************************************
*> DISPLAY A BOX AS BACKGROUND OF CHECKBOX ITEMS
set  Box-bco   Box-fco to white
move '002003020077' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'E'            to Box-3D
Move 'N' to Box-tit
call GC01BOX using BOX-AREA

set  Box-bco   Box-fco to white
move '003005018074' to Box-rc
move 'S'            to Box-style
move 'N'            to Box-3D Box-shadow
move 'R'            to Box-3D
Move 'Y' to Box-tit
move ' Set switches ' & x'00' to Box-titDes
call GC01BOX using BOX-AREA

*> DISPLAY CHECKBOX ITEMS N.1
initialize CHECKBOX-area ALL TO VALUE
move low-value                                       to Ck-tab
Move ' 13005011 Stop after first error     ' & x'00' to Ck-Ele(01)
Move ' 15006011 Allow LABEL and GOTO       ' & x'00' to Ck-Ele(02)
Move '  4007011 Enable macros              ' & x'00' to Ck-Ele(03)
Move ' 16008011 Allow inline               ' & x'00' to Ck-Ele(04)
Move ' 16009011 Include assertion code     ' & x'00' to Ck-Ele(05)
Move ' 16010011 Load compatible units      ' & x'00' to Ck-Ele(06)
Move '  6011011 Allow STATIC in objects    ' & x'00' to Ck-Ele(07)
Move '  6012011 C like operators           ' & x'00' to Ck-Ele(08)
Move ' 16013011 Conditional defines        ' & x'00' to Ck-Ele(09)

Move ' 13015011 Counts                     ' & x'00' to Ck-Ele(10)
Move '  5016011 Percentages                ' & x'00' to Ck-Ele(11)
Move '  4017011 Valid uppercase            ' & x'00' to Ck-Ele(12)

Move ' 13005046 Counts                    ' & x'00' to Ck-Ele(13)
Move '115006046 Percentages               ' & x'00' to Ck-Ele(14)
Move '  4007046 Valid uppercase           ' & x'00' to Ck-Ele(15)
Move ' 16008046 Error Messages            ' & x'00' to Ck-Ele(16)
Move ' 16009046 Reserved words            ' & x'00' to Ck-Ele(17)
Move ' 16010046 Colums stats              ' & x'00' to Ck-Ele(18)
Move '  6011046 Total stats               ' & x'00' to Ck-Ele(19)

Move '  3013046 01-Stop after first error ' & x'00' to Ck-Ele(20)
Move ' 15014046 02-Allow LABEL and GOTO   ' & x'00' to Ck-Ele(21)
Move '  4015046 03-Enable macros          ' & x'00' to Ck-Ele(22)
Move '  4016046 03-Disable warnings       ' & x'00' to Ck-Ele(23)
Move ' 16017046 04-Overnight              ' & x'00' to Ck-Ele(24)
Move ' 16017046 05-Include assertion code ' & x'00' to Ck-Ele(25)
Move ' 16017046 06-Load compatible units  ' & x'00' to Ck-Ele(26)
Move '  6017046 07-Allow STATIC in objects' & x'00' to Ck-Ele(27)
Move '  6017046 08-C like operators       ' & x'00' to Ck-Ele(28)
Move ' 16017046 09-Overlapped items !     ' & x'00' to Ck-Ele(29)

call GC13CHECKBOX using CHECKBOX-AREA
perform DisplaySwitch thru DisplaySwitchEx.

accept omitted at 2580

goback.


DisplaySwitch.
    DISPLAY '                                                                     '
         AT 022003 with foreground-color white background-color blue.
    STRING ' Switches set to: '
                      Ck-Mark(01) '-' Ck-Mark(02) '-' Ck-Mark(03) '-' Ck-mark(04) '-' Ck-Mark(05) '-'
                      Ck-Mark(06) '-' Ck-Mark(07) '-' Ck-Mark(08) '-' Ck-mark(09) '-' Ck-Mark(10) '-'
                      Ck-Mark(11) '-' Ck-Mark(12) '-' Ck-Mark(13) '-' Ck-mark(14) '-' Ck-Mark(15) '-'
                      Ck-Mark(16) '-' Ck-Mark(17) '-' Ck-Mark(18) '-' Ck-mark(19) '-' Ck-Mark(20) '-'
                      Ck-Mark(21) '-' Ck-Mark(22) '-' Ck-Mark(23) '-' Ck-mark(24) '-' Ck-Mark(25) '-'
                      Ck-Mark(26) '-' Ck-Mark(27) '-' Ck-Mark(28) '-' Ck-mark(29) '-' Ck-Mark(30) '+'
             into wSTRING.
    DISPLAY wSTRING AT 022003 with foreground-color white background-color blue.
    continue.
DisplaySwitchEx. Exit.


End Program GC13CHECKBOXDEMO.
