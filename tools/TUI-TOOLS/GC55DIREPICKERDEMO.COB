       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC55DIREPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC55DIREPICKER -  DISPLAY A LISTVIEW TO SELECT A DIRECTORY
*> Tectonics:  cobc -x GC55DIREPICKERDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC55DIREPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.0 2018.12.31
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

01  wDummy            pic x(01) VALUE     ' '.
01 wDir-DireName pic x(128).

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

 COPY 'GC01BOX.CPY'.
 COPY 'GC54FILEPICKER.CPY'.
 COPY 'GC55DIREPICKER.CPY'.
 COPY 'GC98KEYCODE.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
  *> sets in order to detect PgUp, PgDn, PrtSc, Esc keys
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
  set environment 'COB_SCREEN_ESC'        TO 'Y'
  display wDummy at 001001 with blank screen end-display

  *> set a Directory or display files form curret Directory
  *> move "C:\GC-AWORK"  to Dir-Path

  move ' Please select a subdirectory        '             to Dir-NoSelTxt-Ele(03)
  move " < DIREPICKERDEMO - SELECT A DIRECTORY > " & X"00" to Dir-Box-titDes
  continue.

Loop1.
  perform DisplayBox    thru DisplayBoxEx
  perform DisplayParams thru DisplayParamsEx
  perform ScreenSave    thru ScreenSaveEx

  move  4 to Dir-PtrCursor
  move 60 to Dir-WinNumCols
  CALL GC55DIREPICKER using DirePicker-Area end-call

  *> ACCEPT OMITTED

  evaluate true
     when Dir-Key = key-enter
          *> ******************************************************************
          *> DISPLAY DIRECTORY SELECTED
          *> ******************************************************************
            perform DisplayMess thru  DisplayMessEx
            accept omitted
            go to Loop1

     when Dir-Key = Key-Escape
          go to End-Program
     when other
          go to Loop1
  end-evaluate

  continue.
End-Program.
  goback.

*> *************************************************************
*>                P R O G R A M     R O U T I N E S
*> *************************************************************
DisplayMess.
  display " Item= "           at 024002 :BCOL: 4 :FCOL: 7 highlight
  display Dir-Selected        at 024009 :BCOL: 4 :FCOL: 7 highlight
  display " RetKey= "         at 024014 :BCOL: 4 :FCOL: 7 highlight
  display Dir-Key             at 024023 :BCOL: 4 :FCOL: 7 highlight
  display " Dire= "           at 024027 :BCOL: 4 :FCOL: 7 highlight
  *> string Dir-Path     delimited by size
         *> Dir-DireName delimited by size
         *> into wDir-Direname
  *> end-string
  display Dir-Path           at 024034 :BCOL: 4 :FCOL: 7 highlight
  display Dir-DireName       at 025034 :BCOL: 4 :FCOL: 7 highlight
  continue.
DisplayMessEx. Exit.

DisplayParams.
  display "Pos    = "      at 002066 :BCOL: 4 :FCOL: 7 highlight
  display "TabNumRows="    at 003066 :BCOL: 4 :FCOL: 7 highlight
  display "TabNumCols="    at 004066 :BCOL: 4 :FCOL: 7 highlight
  display "WinNumRows="    at 005066 :BCOL: 4 :FCOL: 7 highlight
  display "WinNumCols="    at 006066 :BCOL: 4 :FCOL: 7 highlight
  display Dir-r1c1         at 002074 :BCOL: 4 :FCOL: 7 highlight
  display Dir-TabNumRows   at 003077 :BCOL: 4 :FCOL: 7 highlight
  display Dir-TabNumCols   at 004077 :BCOL: 4 :FCOL: 7 highlight
  display Dir-WinNumRows   at 005077 :BCOL: 4 :FCOL: 7 highlight
  display Dir-WinNumCols   at 006077 :BCOL: 4 :FCOL: 7 highlight
  continue.
DisplayParamsEx. Exit.

DisplayBox.
  *> display a 25x80 box to clear the screen
  move green          to Box-bco
  move white          to Box-fco
  move '001001025080' to Box-rc
  move 'S'            to Box-style
  call GC01BOX using Box-Area
  display " GnuCOBOL - TUI TOOLS - DEMO OF 'GC55DIREPICKER' " at 002002 :BCOL: green :FCOL: white highlight end-display
  continue.
DisplayBoxEx. exit.

ScreenSave.
   move Z'GC55DIREPICKERDEMO.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.
