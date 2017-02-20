01  GC51CALYEAR pic x(20) value 'GC51CALYEAR'.
01  Calendar-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC51CALYEAR.COB - DISPLAY A ONE YEAR CALENDAR
*> Usage:      call GC51CALYEAR using Calendar-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 20.02.2017
*> Changelog:  1.0 first release.
*>             1.1 estended use to 6 languages
*>             1.2 colors moved from program to to copy
*> ***********************************************************************************
*> PARAMETER  DESCRIPTION
*> ---------  ----------------------------------------------------
*> Lan        1=english, 2=Italian, 3=French, 4=Spanish, 5=German, 6=Ducth(Netherland)
*> CaleDate   at the program call contains the date to start the cursor
*>            at the return to the caller contains the selected date
*> CaleDay    at the return to the caller contains the selected day (es. Monday)
*> CaleMonth  at the return to the caller contains the selected month es. February)
*> ***********************************************************************************
   03 Calebco0    pic 9(01) value white. *> bgr.col numbers calend
   03 Calefco0    pic 9(01) value black. *> for.col numbers calend
   03 Calebco1    pic 9(01) value white. *> bgr.col frame e dd
   03 Calefco1    pic 9(01) value blue.  *> for.col frame e dd
   03 Calebco2    pic 9(14) value white. *> bgr.col sunday & saturday
   03 Calefco2    pic 9(01) value red.   *> bgr.col sunday & saturday
   03 Calebco4    pic 9(01) value white. *> bgr.col titolo anno e legenda tasti
   03 Calefco4    pic 9(01) value red.   *> for.col titolo anno e legenda tasti
   03 Calebco5    pic 9(01) value green. *> bgr.col cursor position
   03 Calefco5    pic 9(01) value white. *> for.col cursor position
   03 CaleLan    pic  9(03) value 001.

   03 CaleDate.
      05 CaleDD           pic  9(02) value ZERO.
      05 CaleMM           pic  9(02) value ZERO.
      05 CaleYY           pic  9(04) value ZERO.
   03 CaleDay             pic  x(10) value space.
   03 CaleMonth           pic  x(10) value space.
