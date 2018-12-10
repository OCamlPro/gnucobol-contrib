       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC54FILEPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC54FILEPICKER -  DISPLAY A LISTVIEW TO SELECT A FILE
*> Tectonics:  cobc -x GC54FILEPICKERDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC54FILEPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.0 2018.12.12
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
 COPY 'GC54FILEPICKER.CPY'.
 COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
  *> sets in order to detect PgUp, PgDn, PrtSc, Esc keys
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
  set environment 'COB_SCREEN_ESC'        TO 'Y'
  display wDummy at 001001 with blank screen end-display
  continue.

Loop1.
  perform DisplayBox thru DisplayBoxEx
  perform DisplayParams thru DisplayParamsEx

  CALL GC54FILEPICKER using Filepicker-Area end-call
  perform DisplayMess thru DisplayMessEx
  ACCEPT OMITTED

  if Fip-Key = Key-Escape
     go End-program
  else
     go to Loop1
  end-if

  continue.
End-Program.
  goback.

*> *************************************************************
*>                P R O G R A M     R O U T I N E S
*> *************************************************************
DisplayMess.
  display " Item selected = "            at 024002 :BCOL: 4 :FCOL: 7 highlight
  display     Fip-Selected               at 024019 :BCOL: 4 :FCOL: 7 highlight
  display " Return key = "               at 024024 :BCOL: 4 :FCOL: 7 highlight
  display     Fip-Key                    at 024038 :BCOL: 4 :FCOL: 7 highlight
  display " File = "                     at 024042 :BCOL: 4 :FCOL: 7 highlight
  *> display Fip-Row(Fip-Selected) (37:25)  at 024055 :BCOL: 4 :FCOL: 7 highlight
  display Fip-FileName(01:30)            at 024050 :BCOL: 4 :FCOL: 7 highlight

      continue.
DisplayMessEx. Exit.

DisplayParams.
  display " Position  = " at 002060 :BCOL: 4 :FCOL: 7 highlight
  display " TabNumRows= " at 003060 :BCOL: 4 :FCOL: 7 highlight
  display " TabNumCols= " at 004060 :BCOL: 4 :FCOL: 7 highlight
  display " WinNumRows= " at 005060 :BCOL: 4 :FCOL: 7 highlight
  display " WinNumCols= " at 006060 :BCOL: 4 :FCOL: 7 highlight
  display Fip-r1c1         at 002073 :BCOL: 4 :FCOL: 7 highlight
  display Fip-TabNumRows   at 003073 :BCOL: 4 :FCOL: 7 highlight
  display Fip-TabNumCols   at 004073 :BCOL: 4 :FCOL: 7 highlight
  display Fip-WinNumRows   at 005073 :BCOL: 4 :FCOL: 7 highlight
  display Fip-WinNumCols   at 006073 :BCOL: 4 :FCOL: 7 highlight
  continue.
DisplayParamsEx. Exit.

DisplayBox.
  *> display a 25x80 box to clear the screen
  move green          to Box-bco
  move white          to Box-fco
  move '001001025080' to Box-rc
  move 'S'            to Box-style
  call GC01BOX using Box-Area
  display " GnuCOBOL - TUI TOOLS - DEMO OF 'GC54FILEPICKER' " at 002002 :BCOL: green :FCOL: white highlight end-display
  continue.
DisplayBoxEx. exit.
