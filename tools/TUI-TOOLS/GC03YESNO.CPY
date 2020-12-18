01  GC03YESNO pic x(09) value 'GC03YESNO'.
01  Yesno-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC03YESNO.COB - DISPLAY YES & NO BUTTONS IN A BOX
*> Usage:      call GC03YESNO using YesNo-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************

*> Displays a Box with a YES and NO options and returns the choice to caller
*> the BOX has a fixed size of 10 rows and 40 cols (included cols for shadow)
*>
*>            12345678901234567890123456789012345678
*>
*>        1   +------------------------------------+
*>        2   |                                    |北
*>        3   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |北
*>        4   |                                    |北
*>        5   |    +----------+   +----------+     |北
*>        6   |    |   YES    |   |    NO    |     |北
*>        7   |    +----------+   +----------+     |北
*>        8   |                                    |北
*>        9   +------------------------------------+北
*>              北北北北北北北北北北北北北北北北北北北
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row and col of the upper left corner
*>           DEFAULT: 07,20  = box at center of screen
*> Box       Y= draw a box around the tool
*> Shadow    Y= draw a shadow right and below the tool
*> Bco/Fco   colors for selected and non selected button
*> Mess      Messagge to the user
*>
*> Yesno   - return the user choice to the caller ( 'Y' or 'N')
*>         - set this value to 'Y' or 'N' to select what option to show at first display
*>
*> Key     returns the key code to caller 13 = enter, 27 = escape
*> *************************************************************
     03 Yn-Parameters.
        05 Yn-rc.
           07 Yn-r1            pic  9(03) value 007.
           07 Yn-c1            pic  9(03) value 020.
        05 Yn-Box              pic  x(01) value 'Y'.
        05 Yn-Shadow           pic  x(01) value 'Y'.
        05 Yn-BcoNonSel        pic  9(01) value white.
        05 Yn-FcoNonSel        pic  9(01) value red.
        05 Yn-BcoSel           pic  9(01) value red.
        05 Yn-FcoSel           pic  9(01) value white.
        05 Yn-Mess             pic  x(34) value '          YOU CONFIRM ?           '.
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Yn-Yesno            pic  x(01) value 'Y'.
     03 Yn-Key              pic  9(08) value zero.
