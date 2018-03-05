01 GC53CALENDAR pic x(12) value 'GC53CALENDAR'.
01 Calendar-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC53CALENDAR.COB - DISPLAY A CALENDAR
*> Usage:      call GC53CALENDAR using Calendar-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2018.03.10
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Cn-Back           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-Fore           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-ForeMonth      Color of Months and Year rows
*> Cn-ForeWeekDays   Color of Days of week rows
*> Cn-ForeDaysNumber Color of Days Numbers
*> Cn-Shadow         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-TitBack        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-TitFore        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-BoxBack        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> Cn-BoxFore        xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*> ***********************************************************************************
           05  Cn-Back           pic 9(02) value 02.  *> green
           05  Cn-Fore           pic 9(02) value 00.
           05  Cn-ForeMonth      pic 9(02) value 06.  *> yellow
           05  Cn-ForeWeekDays   pic 9(02) value 01.  *> blue
           05  Cn-ForeDaysNumber pic 9(02) value 07.  *> white
           05  Cn-BoxShadow      pic x(01) value 'Y'.
           05  Cn-TitBack        pic 9(02) value 02.  *> green
           05  Cn-TitFore        pic 9(02) value 07.
           05  Cn-BoxBack        pic 9(02) value 02.  *> green
           05  Cn-BoxFore        pic 9(02) value 07.
