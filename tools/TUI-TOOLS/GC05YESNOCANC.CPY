01  GC05YESNOCANC pic x(13) value 'GC05YESNOCANC'.
01  Yesnocanc-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC05YESNOCANC.COB - DISPLAY YES, NO & CANCEL BUTTONS IN A BOX
*> Usage:      call GC05YESNOCANC using YesNo-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (C) 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2021.02.02
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row and col of the upper left corner
*>           DEFAULT: 07,20  = box at center of screen
*> Box-Style to draw a box around the tool
*>           S=Single line, D=Double line, 1,2=character box, 3=a solid frame, N=noline
*> Shadow    Y= draw a shadow right and below the tool
*> Bco/Fco   color codes for selected (active) button, non selected button
*> 3D        N= no 3D; E= 3D box EMBOSSED/RELIEF; R= 3D box RECESSED
*>           if 3D box requested, fore color is forced to black&white to have the 3D effect.
*> Mess      Messagge to the user (3 rows)
*> YES/NO    labels of YES and NO and CANCEL buttons
*>
*> YesNoCanc - set this value to 'Y' or 'N' or 'C' to select the active button at first display
*>           - return the user choice to the caller ( 'Y' or 'N' or 'C')
*> Key      returns GnuCOBOL key code to caller. es.: 0000 = enter, 2005 = escape
*>          2043 = mouse left double click, 2047 = mouse right click
*> *************************************************************
     03 Ync-Parameters.
        05 Ync-Parameters1.
           07 Ync-rc.
              09 Ync-r1        pic  9(03) value 007.
              09 Ync-c1        pic  9(03) value 020.
           07 Ync-Box-Style    pic  x(01) value 'S'.
           07 Ync-Shadow       pic  x(01) value 'Y'.
           07 Ync-BcoNonSel    pic  9(02) value white.
           07 Ync-FcoNonSel    pic  9(02) value red.
           07 Ync-BcoSel       pic  9(02) value red.
           07 Ync-FcoSel       pic  9(02) value white.
           07 Ync-Box-3D       pic  x(01) value 'N'.
           07 Ync-Button-3D    pic  x(01) value 'N'.

        05 Ync-ButtonYES-label  pic  x(10) value '   YES    '.
        05 Ync-ButtonNO-label   pic  x(10) value '    NO    '.
        05 Ync-ButtonCANC-label pic  x(10) value '  CANCEL  '.
        05 Ync-Mess1           pic  x(40) value '                                        '.
        05 Ync-Mess2           pic  x(40) value '            DO YOU CONFIRM ?            '.
        05 Ync-Mess3           pic  x(40) value '                                        '.


     *> *************************************************************
     *> working fields
     *> *************************************************************
     03 Ync-Working.
        05 wYnc-Parameters1    PIC x(16) value space.
        05 wYnc-Mess           pic x(40) value space.
        05 wYnc-Button         pic x(10) value space.
        05 wYnc-BcoNonSel      pic 9(02) value zero.
        05 wYnc-FcoNonSel      pic 9(02) value zero.
        05 wYnc-Lin-mess       PIC 9(03) value zero.
        05 wYnc-Col-mess       PIC 9(03) value zero.
     *> *************************************************************
     *> RETURN TO CALLER
     *> *************************************************************
     03 Ync-YesNoCanc        pic  x(01) value 'Y'.
     03 Ync-Key              pic  X(04) value zero.
