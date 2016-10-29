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
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
DATA DIVISION.
Working-Storage Section.

COPY "GC51CALYEAR.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

MAIN1.
   call GC51CALYEAR using Calendar-Area.

   Display  "DATE SELECTED:" AT 0101 WITH ERASE EOS.
   Display  CaleDate         AT 0201 .
   Display  CaleDay          AT 0301 .
   Display  CaleMonth        AT 0401 .
   ACCEPT OMITTED.

   Goback.
