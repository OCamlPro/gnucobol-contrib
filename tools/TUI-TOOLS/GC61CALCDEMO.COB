       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC61CALCDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC61CALC - GNUCOBOL POCKET CALCULATOR
*> Tectonics:  cobc -x GC61CALCDEMO.COB (use GnuCOBOL 2.2 or greater)
*> Usage:      GC61CALCDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2018.01.31
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
01  wDummy     pic x(01) VALUE space.

COPY 'GC01BOX.CPY'.
COPY "GC61CALC.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

MAIN1.

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
   Display  "GnuCOBOL TUI TOOL DEMO           "                           AT 0538
            with background-color green foreground-color white highlight
   Display  "Enter to display Pocket Calculator ..."                      AT 0638
            with background-color green foreground-color white highlight

   ACCEPT OMITTED

   Display  "Select a number with: "                                      AT 0838
            with background-color green foreground-color white highlight
   Display  "- cursor or tab keys to browse buttons "                     AT 0938
            with background-color green foreground-color white highlight
   Display  "- type a number to 'activate' a button"                      AT 1038
            with background-color green foreground-color white highlight
   Display  "and press enter.  "                                          AT 1138
            with background-color green foreground-color white highlight
   Display  "After press a +, -, x, :  button. "                          AT 1238
            with background-color green foreground-color white highlight
   Display  "and a second number. "                                       AT 1338
            with background-color green foreground-color white highlight
   Display  "After press the  =  button. "                                AT 1438
            with background-color green foreground-color white highlight
   Display  "[ C ] button clear last number. "                            AT 1538
            with background-color green foreground-color white highlight

   Display  "ESC to exit. "                                                AT 1738
            with background-color green foreground-color white highlight

   call GC61CALC using Calc-Area.

   Display  "Result =  "                                               AT 1938
            with background-color green foreground-color white highlight
   Display Cc-Result                                                   AT 1950
            with background-color green foreground-color white highlight
   accept omitted

   *> clear screen
    display wDummy at 2579 with blank screen end-display
    display ' GnuCOBOL TUI TOOL to manage a POCKET CALCULATOR - END OF DEMO.'
            at 0301 with foreground-color white background-color green

    *> DISPLAY ITALIAN FLAG
     move '009036014049' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
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

   ACCEPT OMITTED.

   Goback.
