       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
Program-Id. GC99MOUSEDEMO.
*> *************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    COBOL DEMO ON PROGRAMMING AND USE MOUSE (TUI MODE)
*> Tectonics:  cobc -x -lpdcurses GC99MOUSEDEMO.COB (windows compile with GnuCOBOL 3.1 or greater)
*> Tectonics:  cobc -x -lncurses  GC99MOUSEDEMO.COB (unix compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC99MOUSEDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2019 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2020.06.13
*> Changelog:  1.0 first release.
*> *************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS wRetCode.  *> Return Code from Accept (ex.PF Keys, Mouse Keys)
   CURSOR     IS wRowCol.   *> Cursor Position

DATA DIVISION.
FILE SECTION.
WORKING-STORAGE SECTION.
*>   mouse mask, apply to COB-MOUSE-FLAGS
78  COB-AUTO-MOUSE-HANDLING          VALUE 1.
78  COB-ALLOW-LEFT-DOWN              VALUE 2.
78  COB-ALLOW-LEFT-UP                VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE            VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN            VALUE 16.
78  COB-ALLOW-MIDDLE-UP              VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE          VALUE 64.
78  COB-ALLOW-RIGHT-DOWN             VALUE 128.
78  COB-ALLOW-RIGHT-UP               VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE           VALUE 512.
78  COB-ALLOW-MOUSE-MOVE             VALUE 1024.
78  COB-ALLOW-ALL-SCREEN-ACTIONS     VALUE 16384. *> reserved

*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
*>  Function keys - Values 1xxx
78  COB-SCR-F3                       VALUE  1003.

*>  Exception keys for mouse handling
78  COB-SCR-MOUSE-MOVE               VALUE  2040.
78  COB-SCR-LEFT-PRESSED             VALUE  2041.
78  COB-SCR-LEFT-RELEASED            VALUE  2042.
78  COB-SCR-LEFT-DBL-CLICK           VALUE  2043.
78  COB-SCR-MID-PRESSED              VALUE  2044.
78  COB-SCR-MID-RELEASED             VALUE  2045.
78  COB-SCR-MID-DBL-CLICK            VALUE  2046.
78  COB-SCR-RIGHT-PRESSED            VALUE  2047.
78  COB-SCR-RIGHT-RELEASED           VALUE  2048.
78  COB-SCR-RIGHT-DBL-CLICK          VALUE  2049.
01  COB-MOUSE-FLAGS   PIC 9(4).

01  wDummy        PIC X.
01  wRetCode      PIC 9(4) value 0000.
01  wRetCodeDescr pic x(23).
01  wRowCol       PIC 9(6) value 0000.
01  redefines wRowCol .
    05 wRowR      Pic 9(3).
    05 wColR      Pic 9(3).

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01   wInt         BINARY-SHORT SIGNED.
01   wDashes1 pic x(80) value "1...+....10...+....20...+....30...+....40...+....50...+....60...+....70...+....0".
01   wTitle      pic x(80) value '                          - GnuCOBOL MOUSE DEMO -  '.
01   wRow        pic 9(02) value  0.
01   wRow2       pic 9(02) value  0.
01   wCol        pic 9(02) value  0.
01   wCol2       pic 9(02) value  0.
01   wClicked    pic 9(02) value  0.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
MAIN1.
  perform InitialSettings thru InitialSettingsEx

  *> this is an infinite LOOP. the program detect if a mouse button is clicked
  perform forever
      accept wDummy at 001001 :BCOL: Red   :FCOL: white

      compute wRow = wRowR
      compute wCol = wColR + 1  *> (wColR is from 000 to 079 !)

      *> display 'Return Code...:' at 004037 :BCOL: green :FCOL: white end-display
      display wRetCode          at 004053 :BCOL: green :FCOL: white end-display

      evaluate wRetCode
          when COB-SCR-MOUSE-MOVE      move 'Mouse moved'         to wRetCodeDescr
          when COB-SCR-LEFT-PRESSED    move 'Left pressed'        to wRetCodeDescr
          when COB-SCR-LEFT-RELEASED   move 'Left released'       to wRetCodeDescr
          when COB-SCR-LEFT-DBL-CLICK  move 'Left doubleclick'    to wRetCodeDescr
          when COB-SCR-MID-PRESSED     move 'Mid pressed'         to wRetCodeDescr
          when COB-SCR-MID-RELEASED    move 'Mid released'        to wRetCodeDescr
          when COB-SCR-MID-DBL-CLICK   move 'Mid doubleclick'     to wRetCodeDescr
          when COB-SCR-RIGHT-PRESSED   move 'Right pressed'       to wRetCodeDescr
          when COB-SCR-RIGHT-RELEASED  move 'Right released'      to wRetCodeDescr
          when COB-SCR-RIGHT-DBL-CLICK move 'Right doubleclick'   to wRetCodeDescr
          when other                   move 'Unknown Ret.code '   to wRetCodeDescr
      end-evaluate

      display wRetCodeDescr     at 004058 :BCOL: green :FCOL: white end-display
      *> display 'Row & Col.....:' at 005037 :BCOL: green :FCOL: white end-display
      display wRowR             at 005053 :BCOL: green :FCOL: white end-display
      display wColR             at 005058 :BCOL: green :FCOL: white end-display

      *> display a simbol (paint) the screen on mouse move
      if wRetCode = COB-SCR-MOUSE-MOVE
         display '*' at line wRowR col wColR :BCOL: red :FCOL: white end-display
      end-if

      if wRetCode =  COB-SCR-F3 accept omitted go to ENDPROG end-if

      *> test if a mouse key is pressed and the mouse was on the OK button
      if  (wRow >= 21 and wRow <= 23) and (wCol >= 60 and wCol <= 70)
          display '+---------+' at 021060 :BCOL: red :FCOL: white end-display
          display '|  EXIT   |' at 022060 :BCOL: red :FCOL: white end-display
          display '+---------+' at 023060 :BCOL: red :FCOL: white end-display
          go to ENDPROG
      end-if
  end-perform
  continue.

ENDPROG.
  goback.

*>* *************************************************************
*>*
*>*
*>* *************************************************************
InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.
  display ' ' at 0101 with blank screen end-display. *> initialize pdcurses

  *> make mouse active
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING
                          + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
                          + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP
                          + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
                          + COB-ALLOW-MOUSE-MOVE
  SET environment   "COB_MOUSE_FLAGS"  to COB-MOUSE-FLAGS.

  perform HideCursor thru HideCursorEx
  DISPLAY (1, 1)  ' ' ERASE
  display wTitle    at 001001 :BCOL: Red   :FCOL: white
  display wDashes1  at 002001 :BCOL: Green :FCOL: White
  display 'Click or doubleclick mouse buttons or click & move mouse to test'
                    at 008010 :BCOL: Red   :FCOL: White  blink highlight
  move    '10'      to wDashes1 (1:2)
  display wDashes1  at 010001 :BCOL: Green :FCOL: White
  move    '15'      to wDashes1 (1:2)
  display wDashes1  at 015001 :BCOL: Green :FCOL: White
  move    '20'      to wDashes1 (1:2)
  display wDashes1  at 020001 :BCOL: Green :FCOL: White

  display 'Return Code...:' at 004037 :BCOL: green :FCOL: white end-display
  display 'Row & Col.....:' at 005037 :BCOL: green :FCOL: white end-display
  display 'Press F3 or click on the EXIT button to exit'
                        at 025001 :BCOL: Red   :FCOL: White blink highlight end-display
  *> button area to click for EXIT
  display '+---------+' at 021060 :BCOL: green :FCOL: white end-display
  display '|  EXIT   |' at 022060 :BCOL: green :FCOL: white end-display
  display '+---------+' at 023060 :BCOL: green :FCOL: white end-display

  continue.
InitialSettingsEx. exit.

HideCursor.
    *> hide the cursor
    move 0 to wInt
    call static "curs_set" using by value wInt end-call
    continue.
HideCursorEx. exit.

END PROGRAM GC99MOUSEDEMO.
