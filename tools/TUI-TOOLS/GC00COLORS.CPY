*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    workarea with GnuCOBOL color codes.
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (C) 2021 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2018.06.08
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> WARNING !
*> PUT THIS COPY FILE AS FIRST LINE IN YOUR WORKING-STORAGE SECTION
*> (because these constants are use in other "copy" file).
*> ***********************************************************************************
*> FOREGROUND-COLOR values from 8 to 15,
*>    are the same as values from 0 to 7 and the HIGHLIGHT option.
*> BACKGROUND-COLOR values from 8 to 15,
*>    are the same as values from 0 to 7 and the BLINK option.


  01 Black        constant as 00.
  01 Blue         constant as 01.
  01 Green        constant as 02.
  01 Cyan         constant as 03.
  01 Red          constant as 04.
  01 Magenta      constant as 05.
  01 Brown        constant as 06.
  01 White        constant as 07.

  01 Grey         constant as 15.
  01 LightBlue    constant as 08.
  01 LightGreen   constant as 09.
  01 LightCyan    constant as 10.
  01 LightRed     constant as 11.
  01 LightMagenta constant as 12.
  01 Yellow       constant as 13.
  01 LightWhite   constant as 14.
