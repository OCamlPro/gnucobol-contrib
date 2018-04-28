       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC26LISTVIEWDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC26LISTVIEW -  DISPLAY A LISTVIEW TO SELECT AN ITEM
*> Tectonics:  cobc -x GC26LISTVIEWDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC26LISTVIEWDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.1 2018.03.31
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

*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESCAPE      VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-NO-DATA     VALUE 8000.
78  K-TIMEOUT     VALUE 8001.
78  K-F1          VALUE 1001.
78  K-SHIFT-F1    VALUE 1013.
78  K-F2          VALUE 1002.
78  K-SHIFT-F2    VALUE 1014.

 COPY 'GC01BOX.CPY'.
 COPY 'GC26LISTVIEW.CPY'.
 COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
  *> sets in order to detect PgUp, PgDn, PrtSc, Esc keys
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
  set environment 'COB_SCREEN_ESC'        TO 'Y'
  *> clear screen
  display wDummy at 001001 with blank screen end-display
  continue.

Displaylist.
  perform DisplayBox thru DisplayBoxEx
  move space to Lv-Tab
  move 'Y' to Lv-Box-tit Lv-Box-shadow
  move ' 1 COST CENTERS ' & x'00'  to Lv-Box-titDes
  move 'N. CODE    DESCRIPTION ' to Lv-RowHeader
  move '01 1111111 111111111111111111111111111111111111111111111abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (001)
  move '02 2222222 222222222222222222222222222222222222222222222abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (002)
  move '03 3333333 333333333333333333333333333333333333333333333abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (003)
  move '04 4444444 444444444444444444444444412345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (004)
  move '05 5555555 5555555555555555555555555123456789012345678901234567890123456789011111' & x'00' to Lv-Row (005)
  move '1...+....10...+....20...+....30...+....40...+....50...+....60...+....70...+....80' & x'00' to Lv-Row (006)
  move '07 7777777 777777777777777777777777777777777777777777777abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (007)
  move '08 8888888 88888888888888888888888881234567890123456789012345678901234567890xxxxx' & x'00' to Lv-Row (008)
  move '09 9999999 99999999999999999999999999999999999999999999912345678901234567890lllll' & x'00' to Lv-Row (009)
  move '10 0000000 000000000000000000000000000000000000000000000abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (010)
  move '11 1111111 aaaaaaaaaaaaaaaaaaaaaaaaa12345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (011)
  move '12 2222222 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb12345678901234567890cacac' & x'00' to Lv-Row (012)
  move '13 3333333 ccccccccccccccccccccccccc12345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (013)
  move '1...+....10...+....20...+....30...+....40...+....50...+....60...+....70...+....80' & x'00' to Lv-Row (014)
  move '15 5555555 eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (015)
  move '16 6666666 fffffffffffffffffffffffff1234567890123456789012345678901234567890frdwr' & x'00' to Lv-Row (016)
  move '17 7777777 ggggggggggggggggggggggggg12345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (017)
  move '18 8888888 hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (018)
  move '19 9999999 iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (019)
  move '20 0000000 jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (020)
  move '21 1111111 AAAAAAAAAAAAAAAAAAAAAAAAA1234567890123456789012345678901234567890ooooo' & x'00' to Lv-Row (021)
  move '22 2222222 BBBBBBBBBBBBBBBBBBBBBBBBB12345678901234567890ooooooooooooooooooooooooo' & x'00' to Lv-Row (022)
  move '23 3333333 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (023)
  move '24 4444444 DDDDDDDDDDDDDDDDDDDDDDDDD12345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (024)
  move '25 5555555 EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEooooooooooooooooooooooooo' & x'00' to Lv-Row (025)
  move '26 6666666 FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (026)
  move '27 7777777 GGGGGGGGGGGGGGGGGGGGGGGGG12345678901234567890hhhhhhhhhhhhhhhhhhhhhhhhh' & x'00' to Lv-Row (027)
  move '28 8888888 HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (028)
  move '29 9999999 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIabcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (029)
  move '30 0000000 JJJJJJJJJJJJJJJJJJJJJJJJJ12345678901234567890abcdefghijklmnopqrstuwxyz' & x'00' to Lv-Row (030)
 *>     123456789012345678901234567890123456789012345678901234567890123456789012345678901

  move 'Y' to Lv-Box-tit Lv-Box-shadow Lv-Box Lv-RowCmd-SW
  move '003004' to Lv-r1c1
  move 30 to Lv-TabNumRows
  move 81 to Lv-TabNumCols
  move 12 to Lv-WinNumRows
  move 50 to Lv-WinNumCols
  perform DisplayParams thru DisplayParamsEx
  CALL GC26LISTVIEW using ListView-Area end-call
  perform DisplayMess thru DisplayMessEx
  ACCEPT OMITTED
  if Lv-Key = Key-Escape go End-program else continue end-if

  perform DisplayBox thru DisplayBoxEx
  move ' 2 COST CENTERS ' & x'00'  to Lv-Box-titDes
  move 'N' to Lv-Box-tit Lv-Box-shadow
  move blue  to Lv-Box-fco
  move green to Lv-bcoH
  move white to Lv-fcoH
  move '010013' to Lv-r1c1
  move 28 to Lv-TabNumRows
  move 81 to Lv-TabNumCols
  move 08 to Lv-WinNumRows
  move 50 to Lv-WinNumCols
  perform DisplayParams thru DisplayParamsEx
  CALL GC26LISTVIEW using ListView-Area end-call
  perform DisplayMess thru DisplayMessEx
  ACCEPT OMITTED
  if Lv-Key = Key-Escape go End-program else continue end-if

  perform DisplayBox thru DisplayBoxEx
  move ' 3 COST CENTERS ' & x'00'  to Lv-Box-titDes
  move 'Y' to Lv-Box-tit Lv-Box-shadow
  move magenta  to Lv-Box-fco
  move blue to Lv-bcoH
  move yellow to Lv-fcoH
  move '005026' to Lv-r1c1
  move 19 to Lv-TabNumRows
  move 70 to Lv-TabNumCols
  move 16 to Lv-WinNumRows
  move 15 to Lv-WinNumCols
  perform DisplayParams thru DisplayParamsEx
  CALL GC26LISTVIEW using ListView-Area end-call
  perform DisplayMess thru DisplayMessEx
  ACCEPT OMITTED
  if Lv-Key = Key-Escape go End-program else continue end-if

  perform DisplayBox thru DisplayBoxEx
  move 'N' to Lv-Box-tit Lv-Box-shadow Lv-Box Lv-RowCmd-SW
  move 'NOBOX' to Lv-RowHeader
  move blue  to Lv-Box-fco
  move green to Lv-bcoH
  move white to Lv-fcoH
  move '010013' to Lv-r1c1
  move 28 to Lv-TabNumRows
  move 81 to Lv-TabNumCols
  move 08 to Lv-WinNumRows
  move 50 to Lv-WinNumCols
  perform DisplayParams thru DisplayParamsEx
  CALL GC26LISTVIEW using ListView-Area end-call
  perform DisplayMess thru DisplayMessEx
  ACCEPT OMITTED
  if Lv-Key = Key-Escape go End-program else go to DisplayList end-if

  continue.
End-program.
  goback.



*> *************************************************************
*>                P R O G R A M     R O U T I N E S
*> *************************************************************
DisplayMess.
  display " Item selected = " at 024002 :BCOL: 4 :FCOL: 7 highlight
  display      Lv-Selected    at 024019 :BCOL: 4 :FCOL: 7 highlight
  display " Return key    = " at 024030 :BCOL: 4 :FCOL: 7 highlight
  display     Lv-Key          at 024047 :BCOL: 4 :FCOL: 7 highlight
  continue.
DisplayMessEx. Exit.

DisplayParams.
  display " Position  = " at 002060 :BCOL: 4 :FCOL: 7 highlight
  display " TabNumRows= " at 003060 :BCOL: 4 :FCOL: 7 highlight
  display " TabNumCols= " at 004060 :BCOL: 4 :FCOL: 7 highlight
  display " WinNumRows= " at 005060 :BCOL: 4 :FCOL: 7 highlight
  display " WinNumCols= " at 006060 :BCOL: 4 :FCOL: 7 highlight
  display Lv-r1c1         at 002073 :BCOL: 4 :FCOL: 7 highlight
  display Lv-TabNumRows   at 003073 :BCOL: 4 :FCOL: 7 highlight
  display Lv-TabNumCols   at 004073 :BCOL: 4 :FCOL: 7 highlight
  display Lv-WinNumRows   at 005073 :BCOL: 4 :FCOL: 7 highlight
  display Lv-WinNumCols   at 006073 :BCOL: 4 :FCOL: 7 highlight
  continue.
DisplayParamsEx. Exit.

DisplayBox.
  *> display a 25x80 box to clear the screen
  move green          to Box-bco
  move white          to Box-fco
  move '001001025080' to Box-rc
  move 'S'            to Box-style
  call GC01BOX using Box-Area
  display " GnuCOBOL - TUI TOOLS - DEMO OF 'LIST VIEW' " at 002002 :BCOL: green :FCOL: white highlight end-display
  continue.
DisplayBoxEx. exit.
