*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    workarea with GnuCOBOL FUNCTION KEYS AND KEY RETURN CODES
*> VALUEs returned in CRT STATUS field (or COB-CRT-STATUS)
*> Author:     Eugenio Di Lorenzo (DILO) - Italia
*> License:    Copyright 2020 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    2.0 2020.04.04
*> Changelog:  1.0 first release.
*>             2.0 mouse keys added
*> ***********************************************************************************
77  K-ENTER       PIC 9(04) VALUE 0000.
77  K-F1          PIC 9(04) VALUE 1001.
77  K-F2          PIC 9(04) VALUE 1002.
77  K-F3          PIC 9(04) VALUE 1003.
77  K-F4          PIC 9(04) VALUE 1004.
77  K-F5          PIC 9(04) VALUE 1005.
77  K-F6          PIC 9(04) VALUE 1006.
77  K-F7          PIC 9(04) VALUE 1007.
77  K-F8          PIC 9(04) VALUE 1008.
77  K-F9          PIC 9(04) VALUE 1009.
77  K-F10         PIC 9(04) VALUE 1010.
77  K-F11         PIC 9(04) VALUE 1011.
77  K-F12         PIC 9(04) VALUE 1012.
77  K-SHIFT-F1    PIC 9(04) VALUE 1013.  *> F13
77  K-SHIFT-F2    PIC 9(04) VALUE 1014.  *> F14
77  K-SHIFT-F3    PIC 9(04) VALUE 1015.  *> F15
77  K-SHIFT-F12   PIC 9(04) VALUE 1024.  *> F24

77  K-ALT-F1      PIC 9(04) VALUE 1025.  *> F25
77  K-ALT-F12     PIC 9(04) VALUE 1048.  *> F48

77  K-CTRL-F1     PIC 9(04) VALUE 1049.  *> F49
77  K-CTRL-F12    PIC 9(04) VALUE 1064.  *> F64

*>  Exception keys - PIC 9(04) VALUEs 2xxx
77  K-PAGEUP      PIC 9(04) VALUE 2001.
77  K-PAGEDOWN    PIC 9(04) VALUE 2002.
77  K-UP          PIC 9(04) VALUE 2003.
77  K-DOWN        PIC 9(04) VALUE 2004.
77  K-ESCAPE      PIC 9(04) VALUE 2005.
77  K-PRINT       PIC 9(04) VALUE 2006.
77  K-TAB         PIC 9(04) VALUE 2007.
77  K-BACKTAB     PIC 9(04) VALUE 2008.
77  K-LEFT        PIC 9(04) VALUE 2009.
77  K-RIGHT       PIC 9(04) VALUE 2010.

*>  Exception keys for mouse handling
77  K-MOUSE-MOVE          PIC 9(04) VALUE 2040.
77  K-LEFT-PRESSED        PIC 9(04) VALUE 2041.
77  K-LEFT-RELEASED       PIC 9(04) VALUE 2042.
77  K-LEFT-DBL-CLICK      PIC 9(04) VALUE 2043.
77  K-MID-PRESSED         PIC 9(04) VALUE 2044.
77  K-MID-RELEASED        PIC 9(04) VALUE 2045.
77  K-MID-DBL-CLICK       PIC 9(04) VALUE 2046.
77  K-RIGHT-PRESSED       PIC 9(04) VALUE 2047.
77  K-RIGHT-RELEASED      PIC 9(04) VALUE 2048.
77  K-RIGHT-DBL-CLICK     PIC 9(04) VALUE 2049.

*>  The following keys are *only* returned on ACCEPT OMITTED
77  K-INSERT      PIC 9(04) VALUE 2011.
77  K-DELETE      PIC 9(04) VALUE 2012.
77  K-BACKSPACE   PIC 9(04) VALUE 2013.
77  K-HOME        PIC 9(04) VALUE 2014.
77  K-END         PIC 9(04) VALUE 2015.

*>  Input validation - PIC 9(04) VALUEs 8xxx
77  K-NO-DATA     PIC 9(04) VALUE 8000. *> NO DATA FROM ACCEPT ex.a timeout is passed (also 8001)
77  K-TIMEOUT     PIC 9(04) VALUE 8001.
*>  Other errors - PIC 9(04) VALUEs 9xxx
77  K-FATAL       PIC 9(04) VALUE 9000.
77  K-MAXFIELD    PIC 9(04) VALUE 9001.
