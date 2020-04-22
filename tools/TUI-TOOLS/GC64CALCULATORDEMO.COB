       >>SOURCE FORMAT IS FREE
       replace ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
program-id. GC64CALCULATORDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC64CALCULATOR - GNUCOBOL POCKET CALCULATOR
*> Tectonics:  cobc -x GC64CALCULATORDEMO.COB (use GnuCOBOL 3.1)
*> Usage:      GC64CALCULATORDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU Lesser General Public License,
*> Version:    1.0 2020.04.21
*> Changelog:  -
*> ***********************************************************************************
ENVIRONMENT DIVISION.
DATA DIVISION.
Working-Storage Section.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.
01 wDummy  pic x(01) VALUE space.

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  SET-AUTO-MOUSE-HANDLING    VALUE 1.
78  SET-LEFT-DOWN              VALUE 2.
78  SET-LEFT-UP                VALUE 4.
78  SET-LEFT-DOUBLE            VALUE 8.
78  SET-MIDDLE-DOWN            VALUE 16.
78  SET-MIDDLE-UP              VALUE 32.
78  SET-MIDDLE-DOUBLE          VALUE 64.
78  SET-RIGHT-DOWN             VALUE 128.
78  SET-RIGHT-UP               VALUE 256.
78  SET-RIGHT-DOUBLE           VALUE 512.
78  SET-MOUSE-MOVE             VALUE 1024.
01  MOUSE-FLAGS      PIC 9(04).

COPY 'GC01BOX.CPY'.
COPY "GC64CALCULATOR.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
  perform InitSettings thru InitSettingsEx

  display wDummy at 0101 with blank screen end-display

  *> *********************************************************************************
  *> DISPLAY A BIG BOX AS BACKGROUND
  *> *********************************************************************************
  move green    to Box-bco   set Box-fco to white
  move '001001' to Box-r1c1  move '025080' to Box-r2c2
  move 'D'      to Box-style move 'N'      to Box-3D
  call GC01BOX using BOX-AREA

   *> Display  " " AT 0101
            *> with background-color green foreground-color red highlight blank screen
   Display  "GnuCOBOL TUI TOOLS DEMO (dilo)          "                      AT 0339
            :BCOL: green :FCOL: white highlight
   Display  "----------------------------------------"                      AT 0439
            :BCOL: green :FCOL: white highlight
   Display  "GnuCOBOL Calculator ...                 "                      AT 0639
            :BCOL: green :FCOL: white highlight


   Display  "Select one or more digits with:        "                      AT 0839
            :BCOL: green :FCOL: white highlight
   Display  "- left mouse button                    "                      AT 0939
            :BCOL: green :FCOL: white highlight
   Display  "Selec one operator with:               "                      AT 1039
            :BCOL: green :FCOL: white highlight
   Display  "- left mouse button                    "                      AT 1139
            :BCOL: green :FCOL: white highlight
   Display  "                                       "                      AT 1239
            :BCOL: green :FCOL: white highlight
   Display  "                                       "                     AT 1339
            :BCOL: green :FCOL: white highlight
   Display  "                                       "                     AT 1439
            :BCOL: green :FCOL: white highlight
   Display  "[ C ] button clear last number.        "                     AT 1539
            :BCOL: green :FCOL: white highlight

   Display  "ESC or RIGHT MOUSE BUTTON to exit. "                         AT 1739
            :BCOL: green :FCOL: white highlight

   move 003 to Ca-r1
   move 004 to Ca-c1
   call GC64CALCULATOR using Calculator-Area.

   Display  "Result =  "                                               AT 1939
            :BCOL: green :FCOL: white highlight
   Display Ca-Result                                                   AT 1950
            :BCOL: green :FCOL: white highlight
   accept omitted

   *> clear screen
    display wDummy at 2579 with blank screen end-display
    display ' TUI TOOL to use a GnuCOBOL CALCULATOR - END OF DEMO. (dilo)'
            at 0301 :BCOL: green foreground-color white

    *> DISPLAY ITALIAN FLAG
     move '009036014049' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
     call  GC01BOX using BOX-AREA
     display '    ' at 010037 :BCOL: Green       end-display
     display '    ' at 011037 :BCOL: Green       end-display
     display '    ' at 012037 :BCOL: Green       end-display
     display '    ' at 013037 :BCOL: Green       end-display
     display '    ' at 010041 :BCOL: white blink end-display
     display '    ' at 011041 :BCOL: white blink end-display
     display '    ' at 012041 :BCOL: white blink end-display
     display '    ' at 013041 :BCOL: white blink end-display
     display '    ' at 010045 :BCOL: red   blink end-display
     display '    ' at 011045 :BCOL: red   blink end-display
     display '    ' at 012045 :BCOL: red   blink end-display
     display '    ' at 013045 :BCOL: red   blink end-display

   ACCEPT OMITTED.

   Goback.

InitSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.
  *> display ' ' at 001001 with erase eos.

  *> set mouse mask  - make mouse active
  COMPUTE MOUSE-FLAGS = SET-AUTO-MOUSE-HANDLING
                      + SET-LEFT-DOWN   + SET-MIDDLE-DOWN   + SET-RIGHT-DOWN
                      + SET-LEFT-UP     + SET-MIDDLE-UP     + SET-RIGHT-UP
                      + SET-LEFT-DOUBLE + SET-MIDDLE-DOUBLE + SET-RIGHT-DOUBLE
                      + SET-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"   to MOUSE-FLAGS
  continue.
InitSettingsEx. exit.
