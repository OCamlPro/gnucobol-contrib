01 GC58SAVERCLOCK pic x(14) value 'GC58SAVERCLOCK'.
01 Saver-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC58SAVERCLOCK.COB - SCREEN SAVER WHIT A BIG CLOCK
*> Usage:      call GC58SAVERCLOCK using Saver-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU GPL, 3.0 (or greater)
*> Version:    1.2 2018.06.29
*> Changelog:  1.0 first release.
*>             1.1 cosmetic changes
*>             1.2 SSChangeCol & SSChangeColT added
*> ------------------------------------------------------------------------------------
*> This program have to be called when the user does not press any key
*> It is the caller that have to decide when activate the Screen Saver
*> This program ends when the user press a key.
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> SSrows     25, 43, 50 how many rows on the screen
*> SSbeep     Y = sound a beep at start of screen saver
*> SSbackcol  background color of the clock
*> SSforecol  foreground color of the clock
*> SSMove     after how many seconds move the clock on screen
*> SStitle1   Y= display  a scrolling string
*> SStitle2   text of Scrolling String
*> SSbackcolt background color of the scrolling string
*> SSforecolt foreground color of the scrolling string
*> SSChangeCol  Y= starting from SSbackcol SSforecol, change clock colors
*> SSChangeColT Y= starting from SSbackcolT SSforecolT, change scrolling string colors
*> ***********************************************************************************
   05 SSrows        pic 9(04) value  25.
   05 SSbeep        pic x(01) value 'N'.
   05 SSbackcol     pic 9(01) value green.      *> back color of the clock
   05 SSforecol     pic 9(01) value white.      *> fore color of the clock
   05 SSMove        pic 9(02) value  10.
   05 SStitle1      pic x(01) value 'Y'.
   05 SStitle2      pic x(80) value
      '> > > > > > > > > Screen Saver Active (press a key to return ... ) > > > > > > >'.
   *>  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   05 SSbackcolt     pic 9(01) value green.      *> back color of the title
   05 SSforecolt     pic 9(01) value white.      *> fore color of the title
   05 SSChangeCol    pic x(01) value 'Y'.
   05 SSChangeColT   pic x(01) value 'Y'.
