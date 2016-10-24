01 GC58SAVERCLOCK pic x(14) value 'GC58SAVERCLOCK'.
01 Saver-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC58SAVERCLOCK.COB - SCREEN SAVER WHIT A BIG CLOCK
*> Usage:      call GC58SAVERCLOCK using Saver-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ------------------------------------------------------------------------------------
*> This program have to be called when the user does not press any key
*> It is the caller that have to decide when activate the Screen Saver
*> The program ends when the user press a key.
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> SSrows     25, 43, 50 wRowhe da gestire come screen saver
*> SSbeep     se = 'Y' allora quando parte lo screen saver fa beep
*> SSbackcol  background color of the clock
*> SSforecol  foreground color of the clock
*> SSMove     seconds before moving the clock on screen
*> SStitle1   'Y'= display  the scrolling string
*> SStitle2   text of ScrollingString
*> SSbackcolt background color of the scrolling string
*> SSforecolt foreground color of the scrolling string
*> ***********************************************************************************
   05 SSrows        pic 9(04) value  25.
   05 SSbeep        pic x(01) value 'N'.
   05 SSbackcol     pic 9(01) value green.           *> back color of the clock
   05 SSforecol     pic 9(01) value white.           *> fore color of the clock
   05 SSMove      pic s9(02) value +02.
   05 SStitle1      pic  x(01) value 'Y'.
   05 SStitle2      pic  x(80) value
      '> > > > > > > > > Screen Saver Active (press a key to exit  ... ) > > > > > > >'.
   *>  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   05 SSbackcolt     pic 9(01) value green.           *> back color of the title
   05 SSforecolt     pic 9(01) value white.           *> fore color of the title
