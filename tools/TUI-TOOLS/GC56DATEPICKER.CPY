01 GC56DATEPICKER pic x(14) value 'GC56DATEPICKER'.
01 DatePicker-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC56DATEPICKER.COB - DISPLAY A ONE MONTH CALENDAR
*> Usage:      call GC56DATEPICKER using DatePicker-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2015 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2016.10.14
*> Changelog:  1.0 first release.
*>             1.1 modified Example below of the calendar, added Dtp-legend
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row & column of upper left corner   - DEFAULT: 07,25  (at center of screen)
*> bco,fco   box background & foreground (the frame) color
*> hilight   Y= the foreground (the frame of the box) is highlighted
*> style     S= Single line, D= Double line, 1,2=character box, 3=a solid frame (does'nt work!)
*>           N= noline (to colour a zone), C= custom
*> custom    if style=C, here are 9 chars to draw the box: UpLeft, UpCenter, UpRight, MiddleLeft, MC, MR, LowLeft, LC, LR
*> fill      Y= filled box, N= transparent box, draw only the frame
*> shadow    Y= draw a shadow low & right of the box. DEFAULT: no shadow
*> 3D        N= no 3D; E= 3D box EMBOSSED/RELIEF; R= 3D box RECESSED
*>           if 3D box requested, fore color is forced to black&white to have the 3D effect.
*> add1c     Y= box width expanded 1 col at left and 1 col at right.
*>           improve appaerance of 3D box. (not yet implemented)
*> beep      Y= bell
*> tit       Y= display a title
*> titDes    string to be displayed as title
*> dim       Select N= Normal Size Calendar(12x30) or S= Small Size Calendar(12x23)
*> legend    Y = display a small legend
*>                                        c1
*>           Example               r1 ->  +------ Calendar -----+
*>           style = 1         displays:  |JUNE             2016|
*>           Dim   = S small              |---------------------|
*>                                        | Su Mo Tu We Th Fr Sa|
*>                                        |---------------------|
*>                                        |          01 02 03 04|
*>                                        | 05 06 07 08 09 10 11|
*>                                        | 12 13 14 15 16 17 18|
*>                                        | 19 29 21 22 23 24 25|
*>                                        | 26 27 28 29 30      |
*>                   legend -->           |       CurUpDn PgUpDn|
*>                                        +---------------------+

*>                                        12345678901234567890123
*>
*>                                       c1
*>           Example               r1 ->  +--------- Calendar ---------+
*>           style = 1         displays:  |JUNE                    2016|
*>           Dim   = B Big                |----------------------------|
*>                                        |Sun Mon Tue Wed Thu Fri Sat |
*>                                        |----------------------------|
*>                                        |             01  02  03  04 |
*>                                        | 05  06  07  08  09  10  11 |
*>                                        | 12  13  14  15  16  17  18 |
*>                                        | 19  29  21  22  23  24  25 |
*>                                        | 26  27  28  29  30         |
*>                --> legend              |         Cursor,PgUP/Dn,+/- |
*>                                        +----------------------------+
*>                                        123456789012345678901234567890


*>
*> Datesel   the date selected by the User is returned to caller YYYYMMDD.
*>           if the caller set this Date, Datrepicker starts from this date
*> Key       the key selectd by the user on exit (enter or escape)
*> ***********************************************************************************
   03 Dtp-rc.
      05 Dtp-r1c1.
         07 Dtp-r1   pic 9(03) value 007.
         07 Dtp-c1   pic 9(03) value 025.

   03 Dtp-Parameters.
      05 Dtp-bco     pic 9(01) value cyan.          *> back color of the calendar
      05 Dtp-fco     pic 9(01) value white.         *> fore color of the calendar
      05 Dtp-fcoH    pic X(01) value "Y".           *> Hilight Foreground ?
      05 Dtp-style   pic X(01) value "S".           *> S, D, 1, 2, 3, N, C
      05 Dtp-custom  PIC X(09) VALUE "ABCDEFGHI".   *> UL, UC, UR, ML, MC, MR, LL, LC, LR
      05 Dtp-fill    pic X(01) value "Y".           *> filled box
      05 Dtp-shadow  pic x(01) value 'N'.           *> box with shadow
      05 Dtp-3D      pic x(01) value 'N'.           *> N=no3D, 3D effect: R= Recessed, E= Embossed/Relief
      05 Dtp-add1c   pic x(01) value 'N'.           *> enlarge box for a better 3D effect
      05 Dtp-beep    pic x(01) value 'N'.           *> Y = ring the bell
      05 Dtp-tit     pic x(01) value 'Y'.           *> Y = display a title at top of the box
      05 Dtp-titBco  pic 9(01) value cyan.          *> back color of titleBox
      05 Dtp-titFco  pic 9(01) value white.         *> fore color of titleBox
      05 Dtp-titFcoH pic X(01) value "Y".           *> hiligth fore color of titleBox ?
      05 Dtp-titDes  pic x(80) value z' Calendar '. *> string from 1 to 80 char, to be used as a box title
      05 Dtp-dim     pic x(01) value 'B'.           *> B= big size, S= Small size
      05 Dtp-legend  pic x(01) value 'Y'.           *> Y= display legend on last calendar row
*> ***********************************************************************************
*> RETUNRS TO CALLER
*> ***********************************************************************************
   05 Dtp-DateSel pic  x(08) value space.   *> User has selected this Date YYYYMMDD
   05 Dtp-Key     pic  9(08) value zero.    *> which Key to exit (enter or escape)
