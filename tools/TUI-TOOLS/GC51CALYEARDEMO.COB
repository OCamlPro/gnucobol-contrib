       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC51CALYEARDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC51CALYEAR - DISPLAY A ONE YEAR CALENDAR
*> Tectonics:  cobc -x GC51CALYEARDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC51CALYEARDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2017.02.19
*> Changelog:  1.1 set the language (new feature of GC51CALYEAR)
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


COPY "GC51CALYEAR.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

MAIN1.

   Display  " " AT 0101
            with background-color green foreground-color red highlight blink blank screen
   Display  "GnuCOBOL TUI TOOL DEMO           " AT 0505
            with background-color green foreground-color red highlight blink
   Display  "                                 " AT 0605
            with background-color green foreground-color red highlight blink
   Display  "Enter to display the Calendar ..." AT 0705
            with background-color green foreground-color red highlight blink
   ACCEPT OMITTED.


   *> 5 = German
   move 5 to CaleLan
   call GC51CALYEAR using Calendar-Area.


   Display  "DATE SELECTED:" AT 0704 WITH BLANK SCREEN.
   Display  CaleDate         AT 0804 .
   Display  CaleDay          AT 0904 .
   Display  CaleMonth        AT 1004 .
   Display  CaleLan          AT 1104 .
   ACCEPT OMITTED.

   Goback.
