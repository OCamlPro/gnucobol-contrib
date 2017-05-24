01 GC74HELPVIEW pic x(20) value 'GC74HELPVIEW'.
01 Help-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC74HELPVIEW.COB (UTILITY TO DISPLAY A HELP TEXT WINDOW)
*> Usage:      from your program - call GC74HELPVIEW using Help01-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.01.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*>
*> PARAMETER DESCRIPTION
*> --------- ----------------------------------------------------
*> he-file   file name with help text
*>           this file is loaded by program GC74HELPLOAD.COB that read a TXT source file
*>           and create an indxed file with a key = PNNN-xxx + a counter of 4 digit.
*> he-key    HELP KEY (= help topic) you want to be shiowed on screen
*>
*> he-back   background color of help window
*> he-fore   foreground color of help window
*> *************************************************************
     05  HeFile          pic  x(30) value space.
     05  HeKey           pic  x(08) value space.
     05  HeBack          pic  9(04) value cyan.
     05  HeFore          pic  9(04) value white.

     05  HeBoxShadow     pic  x(01) value 'Y'.
     *> colori del titolo del box
     05  HeTitBack       pic  9(04) value cyan.
     05  HeTitFore       pic  9(04) value white.
     *> colori del box ripetuti in due formati diversi
     05  HeBoxBack       pic  9(04) value cyan.
     05  HeBoxFore       pic  9(04) value white.
