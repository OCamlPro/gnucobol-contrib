       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR== .
IDENTIFICATION DIVISION.
program-id. GC26LISTVIEW is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    list ELEMENTS OF A TABLE on screen and let the user pick-up one
*> Tectonics:  cobc -x GC26LISTVIEW.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC26LISTVIEW using Listview-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.1 2018.03.12
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
Configuration Section.
REPOSITORY.
    FUNCTION ALL INTRINSIC.
INPUT-OUTPUT  SECTION.
FILE-CONTROL.
*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.
FILE SECTION.
WORKING-STORAGE SECTION.
01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wString      pic  x(08).

01  wLin         pic  9(03) value   0.
01  wCol         pic  9(03) value   0.
01  wCols        pic  9(03) value   0.
01  wColIni      pic  9(03) value   1.
01  wInd         pic  9(03) value   1.

01  wCount       pic  s9(04) value   0.
01  wBase        pic  s9(04) value   0.

01  wPtrCursor   pic s9999 value 1.
01  wPtrTableIni pic s9999 value 1.
01  wPtrTableEnd pic s9999 value 1.

*> SAVE/RESTORE SCREEN VARIABLES
01  wScreenName        PIC X(256).
01  wiScrOk            BINARY-LONG.
01  wInt         BINARY-SHORT SIGNED.

01 wWinNumRows pic 9(03).
01 wWinNumCols pic 9(03).

 COPY 'GC01BOX.CPY'.
 COPY 'GC02BOXMEX.CPY'.
 COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
COPY 'GC26LISTVIEW.CPY'.

*> **************************************************************
*>
*>           P R O C E D U R E     D I V I S I O N
*>
*> **************************************************************
PROCEDURE DIVISION using ListView-Area.
   *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
   set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
   set environment 'COB_SCREEN_ESC'        TO 'Y'

   if Lv-Box = 'Y'
           perform DisplayBox  thru DisplayBoxEx end-if
   perform DisplayRowHeader    thru DisplayRowHeaderEx
   perform DisplayRowCmd       thru DisplayRowCmdEx
   perform DisplayList         thru DisplayListEx
   perform CursorHide          thru CursorHideEx
   string 'e' wInd 'c' wColIni delimited by size into wString end-string
   perform DisplayPos          thru DisplayPosEx
   continue.

Loop-Wait-for-a-Key.
  *> *************************************************************
  *> WAIT FOR USER INPUT
     call static "getch" returning Key-Pressed end-call
  *> *************************************************************

  *> Evaluate wich key was pressed
  EVALUATE TRUE

     *> *************************************************************
     *> CURSOR DOWN: shows next row at bottom of list (scroll up rows)
     *> *************************************************************
     when Key-Pressed = Key-CursDn
          if wPtrCursor < Lv-WinNumRows
              *> (RE)DISPLAY ACTUAL CURSOR LINE IN NORMAL COLORS
              compute wLin = (Lv-r1 + wPtrCursor)
              compute wInd = wBase + wPtrCursor
              display Lv-Row(wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoN :FCOL: Lv-fcoN
              *> (RE)DISPLAY NEW CURSOR LINE IN DIFFERENT COLORS
              compute wPtrCursor = wPtrCursor + 1
              compute wLin = (Lv-r1 + wPtrCursor)
              compute wInd = wBase + wPtrCursor
              if Lv-fcoSH = 'Y'
                 display Lv-Row(wInd)(wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS highlight
              else
                 display Lv-Row(wInd)(wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS
              end-if
          else
             *> cursor is on last window line -> scroll up previous lines
             compute wBase = wBase + 1
             if wBase <= ( Lv-TabNumRows - Lv-WinNumRows )
                perform DisplayList thru DisplayListEx
             else
                compute wBase = Lv-TabNumRows - Lv-WinNumRows
                perform Beep1 thru Beep1Ex
             end-if
          end-if
     *> *************************************************************
     *> CURSOR UP: shows previous row at first line (sroll down rows)
     *> *************************************************************
     when Key-Pressed = Key-CursUp
          if wPtrCursor > 1
              *> (RE)DISPLAY ACTUAL CURSOR LINE IN NORMAL COLORS
              compute wLin = (Lv-r1 + wPtrCursor)
              compute wInd = wBase + wPtrCursor
              display Lv-Row(wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoN :FCOL: Lv-fcoN
              *> (RE)DISPLAY NEW CURSOR LINE IN DIFFERENT COLORS
              compute wPtrCursor = wPtrCursor - 1
              compute wLin = (Lv-r1 + wPtrCursor)
              compute wInd = wBase + wPtrCursor
              if Lv-fcoSH = 'Y'
                 display Lv-Row (wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS highlight
              else
                 display Lv-Row (wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS
              end-if
          else
             *> cursor is on first window line -> scroll down following lines
             compute wBase = wBase - 1
             if wBase >= 0
                perform DisplayList thru DisplayListEx
             else
                compute wBase = 0
                perform Beep1 thru Beep1Ex
             end-if
          end-if
     *> *************************************************************
     *> PAGE UP (not yet available)
     *> *************************************************************
     when Key-Pressed = Key-PgUp
        continue
     *> *************************************************************
     *> PAGE DOWN (not yet available)
     *> *************************************************************
     when Key-Pressed = Key-PgDn
        continue
     *> *************************************************************
     *> TAB OR CURSOR RIGHT   ->
     *> *************************************************************
     when Key-Pressed = Key-CursRight or Key-Pressed = Key-Tab
        compute wColIni = wColIni + 1
        if wColIni <= Lv-TabNumCols - Lv-WinNumCols + 1
            perform DisplayRowHeader thru DisplayRowHeaderEx
            perform DisplayList      thru DisplayListEx
        else
            compute wColIni = Lv-TabNumCols - Lv-WinNumCols
            perform Beep1 thru Beep1Ex
        end-if
     *> *************************************************************
     *> CURSOR LEFT  <-
     *> *************************************************************
     when Key-Pressed = Key-CursLeft
        compute wColIni = wColIni - 1
        if wColIni >= 1
            perform DisplayRowHeader thru DisplayRowHeaderEx
            perform DisplayList      thru DisplayListEx
        else
            compute wColIni = 1
            perform Beep1 thru Beep1Ex
        end-if
     *> *************************************************************
     *> ENTER
     *> *************************************************************
     when Key-Pressed = Key-Enter
          move Key-Pressed    to Lv-Key
          compute Lv-Selected = wBase + wPtrCursor
          go End-Program
     *> *************************************************************
     *> ESCAPE= EXIT
     *> *************************************************************
     when Key-Pressed = Key-Escape
          move Key-Pressed    to Lv-Key
          compute Lv-Selected = wBase + wPtrCursor
          go End-program
     *> *************************************************************
     *> F1 = HELP
     *> *************************************************************
      when Key-Pressed = Key-F1
          perform DisplayHelp thru DisplayHelpEx
          perform CursorHide  thru CursorHideEx
   END-EVALUATE

   string 'e' wInd 'c' wColIni delimited by size into wString end-string
   perform DisplayPos thru DisplayPosEx


   go Loop-Wait-for-a-Key
   continue.
End-Program.
   perform CursorShow thru CursorShowEx
   GOBACK.

*> *************************************************************
*>
*>                P R O G R A M     R O U T I N E S
*>
*> *************************************************************
DisplayList.
  compute wLin = Lv-r1
  *> DISPLAY LIST LINES
  compute wPtrTableEnd = wPtrTableIni + Lv-WinNumRows - 1
  perform varying wCount from wPtrTableIni by 1 until wCount > wPtrTableEnd
      add 1 to wLin
      compute wInd = wBase + wCount
      display Lv-Row(wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoN :FCOL: Lv-fcoN
  end-perform
  *> (RE)DISPLAY CURSOR LINE IN DIFFERENT COLORS
  compute wLin = (Lv-r1 + wPtrCursor)
  compute wInd = wBase + wPtrCursor
  if Lv-fcoSH = 'Y'
      display Lv-Row (wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS highlight
  else
      display Lv-Row (wInd) (wColIni:Lv-WinNumCols) at line wLin col Lv-c1 :BCOL: Lv-bcoS :FCOL: Lv-fcoS
  end-if
  continue.
DisplayListEx. exit.

DisplayRowHeader.
  *> Header of List (column list description)
  if Lv-fcoHH = 'Y'
      display Lv-RowHeader(wColIni:Lv-WinNumCols) at Line Lv-r1 col Lv-c1 :BCOL: Lv-bcoH :FCOL: Lv-fcoH highlight
  else
      display Lv-RowHeader(wColIni:Lv-WinNumCols) at Line Lv-r1 col Lv-c1 :BCOL: Lv-bcoH :FCOL: Lv-fcoH
  end-if
  continue.
DisplayRowHeaderEx. exit.

DisplayRowCmd.
  *> Commands
  if Lv-RowCmd-SW = 'Y'
      compute wLin = (Lv-r1 + Lv-WinNumRows + 1)
      if Lv-WinNumCols <= 30
         compute wCols = Lv-WinNumCols
      else
         compute wCols = 30
      end-if
      if Lv-fcoHH = 'Y'
          display Lv-RowCmd(01:wCols) at Line wLin col Lv-c1 :BCOL: Lv-Box-bco :FCOL: Lv-Box-fco highlight
      else
          display Lv-RowCmd(01:wCols) at Line wLin col Lv-c1 :BCOL: Lv-Box-bco :FCOL: Lv-Box-fco
      end-if
  end-if
  continue.
DisplayRowCmdEx. exit.

DisplayPos.
  *> Display Position at command row
  if Lv-RowCmd-SW = 'Y'
      compute wLin = (Lv-r1 + Lv-WinNumRows + 1)
      *> if < 38 there is no space for display postion "e001c001"
      if Lv-WinNumCols >= 38
         compute wCol = Lv-c1 + Lv-WinNumCols - 8
         display wString at Line wLin col wCol :BCOL: Lv-Box-bco :FCOL: Lv-Box-fco highlight
      end-if
  end-if
  continue.
DisplayPosEx. exit.

DisplayBox.
    initialize Box-area ALL TO VALUE
    compute Box-r1 = Lv-r1 - 1
    compute Box-c1 = Lv-c1 - 1
    compute Box-r2 = Lv-r1 + Lv-WinNumRows + 1
    compute Box-c2 = Lv-c1 + Lv-WinNumCols
    move Lv-Box-Bco      to Box-Bco
    move Lv-Box-Fco      to Box-Fco
    move Lv-Box-FcoH     to Box-FcoH
    move Lv-Box-style    to Box-style
    move Lv-Box-custom   to Box-custom
    move Lv-Box-fill     to Box-fill
    move Lv-Box-Shadow   to Box-shadow
    move Lv-Box-3D       to Box-3D
    move Lv-Box-add1c    to Box-add1c
    move Lv-Box-beep     to Box-beep
    move Lv-Box-tit      to Box-tit
    move Lv-Box-titBco   to Box-titBco
    move Lv-Box-titFco   to Box-titFco
    move Lv-Box-titFcoH  to Box-titFcoH
    move Lv-Box-titDes   to Box-titDes
    call GC01BOX using BOX-AREA
    continue.
DisplayBoxEx. exit.

DisplayHelp.
    perform ScreenSave thru ScreenSaveEx
    move low-value to bxm-tabmex
    compute Bxm-r1 =  Lv-r1 + 2
    compute Bxm-c1  = Lv-c1 + 1
    move blue  to Bxm-bco Bxm-bcoM Bxm-titBco
    move white to Bxm-fcoM
    move  4 to wWinNumRows
    move 36 to wWinNumCols
    compute Bxm-r2 = Bxm-r1 + wWinNumRows + 1
    compute Bxm-c2 = Bxm-c1 + wWinNumCols + 1
    move 'N' to Bxm-OkButton Bxm-fcoMH Bxm-3D
    move 'Y' to Bxm-tit
    move ' HELP ' & x'00' to Bxm-titDes
    *> 4 rows of 36 cols
    move 'Cursor UP/DOWN   : Scroll vertical  ' & x'00' to bxm-mex(01)
    move 'Cursor RIGHT/LEFT: Scroll horizontal' & x'00' to bxm-mex(02)
    move 'Enter            : Select the item  ' & x'00' to bxm-mex(03)
    move 'Escape           : Exit             ' & x'00' to bxm-mex(04)
    CALL GC02BOXMEX USING BY REFERENCE BOXMEX-AREA
    perform ScreenRestore thru ScreenRestoreEx
    continue.
DisplayHelpEx. exit.

Beep1.
  CALL X'E5'
  perform CursorHide thru CursorHideEx.
Beep1Ex. exit.

CursorHide.
  move 0 to wInt
  call static "curs_set" using by value wInt end-call.
  continue.
CursorHideEx. EXIT.

CursorShow.
  move 2 to wInt
  call static "curs_set" using by value wInt end-call.
  continue.
CursorShowEx. EXIT.

ScreenSave.
    move Z'BOXMEX.SCR' to wScreenName
    call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
  call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
  CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.
