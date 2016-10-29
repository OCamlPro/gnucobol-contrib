01  GC51CALYEAR pic x(20) value 'GC51CALYEAR'.
01  Calendar-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC51CALYEAR.COB - DISPLAY A ONE YEAR CALENDAR
*> Usage:      call GC51CALYEAR using Calendar-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> PARAMETER  DESCRIPTION
*> ---------  ----------------------------------------------------
*> CaleDate   at the program call contains the date on which start the cursor
*>            at the return to the caller contains the selected date
*> CaleDay    at the return to the caller contains the description
*>            of the day selected (es. Monday)
*> CaleMonth  at the return to the caller contains the description
*>            of the month selected es. February)
*> ***********************************************************************************
   03 CaleLan             pic x(02)  value "EN".
   03 CaleDate.
      05 CaleDD           pic  9(02) value ZERO.
      05 CaleMM           pic  9(02) value ZERO.
      05 CaleYY           pic  9(04) value ZERO.
   03 CaleDay             pic  x(09) value space.
   03 CaleMonth           pic  x(09) value space.
