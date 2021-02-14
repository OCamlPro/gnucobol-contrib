01  GC03YESNO pic x(09) value 'GC03YESNO'.
01  Yesno-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC03YESNO.COB - DISPLAY YES & NO BUTTONS IN A BOX
*> Usage:      call GC03YESNO using YesNo-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (C) 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 2021.02.02
*> Changelog:  2.0 color fields from 9(01) to 9(02).
*>                 management of colors fron 08 to 15 is added
*>                 now message from 1 row to 3 rows available,
*> ***********************************************************************************
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row and col of the upper left corner
*>           DEFAULT: 07,20  = box at center of screen
*> Box-Style draw a box around the tool
*>           S=Single line, D=Double line, 1,2=character box, 3=a solid frame, N=noline
*> Shadow    Y= draw a shadow right and below the tool
*> Bco/Fco   color codes for selected (active) button, non selected button, hotKey
*> 3D        N= no 3D; E= 3D box EMBOSSED/RELIEF; R= 3D box RECESSED
*>           if 3D box requested, fore color is forced to black&white to have the 3D effect.
*> Mess      Messagge to the user (3 rows)
*> YES/NO    labels of YES and NO buttons
*>
*> Yesno    - set this value to 'Y' or 'N' to select the active button at first display
*>          - return the user choice to the caller ( 'Y' or 'N')
*> Key     returns GnuCOBOL key code to caller. es.: 0000 = enter, 2005 = escape
*>         2043 = mouse left double click, 2047 = mouse right click
*> *************************************************************
     03 Yn-Parameters.
        05 Yn-Parameters1.
           07 Yn-rc.
              09 Yn-r1        pic  9(03) value 007.
              09 Yn-c1        pic  9(03) value 020.
           07 Yn-Box-Style    pic  x(01) value 'S'.
           07 Yn-Shadow       pic  x(01) value 'Y'.
           07 Yn-BcoNonSel    pic  9(02) value white.
           07 Yn-FcoNonSel    pic  9(02) value red.
           07 Yn-BcoSel       pic  9(02) value red.
           07 Yn-FcoSel       pic  9(02) value white.
           07 Yn-Box-3D       pic  x(01) value 'N'.
           07 Yn-Button-3D    pic  x(01) value 'N'.

        05 Yn-ButtonYES-label pic  x(10) value '   YES    '.
        05 Yn-ButtonNO-label  pic  x(10) value '    NO    '.
        05 Yn-Mess1           pic  x(34) value '              -------             '.
        05 Yn-Mess2           pic  x(34) value '          DO YOU CONFIRM ?        '.
        05 Yn-Mess3           pic  x(34) value '           - o - O - o -          '.


     *> *************************************************************
     *> working fields
     *> *************************************************************
     03 Yn-Working.
        05 wYn-Parameters1    PIC x(16) value space.
        05 wYn-Mess           pic x(34) value space.
        05 wYn-Button         pic x(10) value space.
        05 wYn-BcoNonSel      pic 9(02) value zero.
        05 wYn-FcoNonSel      pic 9(02) value zero.
        05 wYn-Lin-mess       PIC 9(03) value zero.
        05 wYn-Col-mess       PIC 9(03) value zero.
     *> *************************************************************
     *> RETURN TO CALLER
     *> *************************************************************
     03 Yn-Yesno            pic  x(01) value 'Y'.
     03 Yn-Key              pic  X(04) value zero.
