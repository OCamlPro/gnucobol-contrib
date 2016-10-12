*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    workarea with KEY SCAN CODES FOR NON ASCII charatcters.
*> Usage:      in your program type CALL STATIC "GETCH" RETURNING Key-Pressed END-CALL
*>             your program will wait for a user input, field - KeyPressed -
*>             will contain the corresponding Code of the key pressed by the user
*> Author:     Eugenio Di Lorenzo (DILO) - Italia
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
01 Key-Pressed            pic 9(3) value zero.
01 Key-Code.
*> ***********************************************************************************
*> NON ASCII CHARACTERS
*> ***********************************************************************************
     05  Key-Backspace   pic 9(3) value 008.
     05  Key-Tab         pic 9(3) value 009.
     05  Key-Enter       pic 9(3) value 013.
     05  Key-Escape      pic 9(3) value 027.
     05  Key-Home        pic 9(3) value 071.
     05  Key-CursUp      pic 9(3) value 072.
     05  Key-PgUp        pic 9(3) value 073.
     05  Key-CursLeft    pic 9(3) value 075.
     05  Key-CursRight   pic 9(3) value 077.
     05  Key-End         pic 9(3) value 079.
     05  Key-CursDn      pic 9(3) value 080.
     05  Key-PgDn        pic 9(3) value 081.
     05  Key-Insert      pic 9(3) value 082.
     05  Key-Canc        pic 9(3) value 083.

     05  Key-Alt-CursUp       pic 9(3) value 152.
     05  Key-Alt-CursLeft     pic 9(3) value 155.
     05  Key-Alt-CursRight    pic 9(3) value 157.
     05  Key-Alt-CursDn       pic 9(3) value 160.

     05  Key-Ctrl-CursUp      pic 9(3) value 141.
     05  Key-Ctrl-CursLeft    pic 9(3) value 115.
     05  Key-Ctrl-CursRight   pic 9(3) value 116.
     05  Key-Ctrl-CursDn      pic 9(3) value 145.

     05  Key-F1          pic 9(3) value 059.
     05  Key-F2          pic 9(3) value 060.
     05  Key-F3          pic 9(3) value 061.
     05  Key-F4          pic 9(3) value 062.
     05  Key-F5          pic 9(3) value 063.
     05  Key-F6          pic 9(3) value 064.
     05  Key-F7          pic 9(3) value 065.
     05  Key-F8          pic 9(3) value 066.
     05  Key-F9          pic 9(3) value 067.
     05  Key-F10         pic 9(3) value 068.
     05  Key-F11         pic 9(3) value 133.
     05  Key-F12         pic 9(3) value 134.

     05  Key-Alt-a       pic 9(3) value 030.
     05  Key-Alt-b       pic 9(3) value 048.
     05  Key-Alt-c       pic 9(3) value 046.
     05  Key-Alt-d       pic 9(3) value 032.
     05  Key-Alt-e       pic 9(3) value 063.
     05  Key-Alt-f       pic 9(3) value 033.
     05  Key-Alt-g       pic 9(3) value 034.
     05  Key-Alt-h       pic 9(3) value 035.
     05  Key-Alt-i       pic 9(3) value 023.
     05  Key-Alt-j       pic 9(3) value 036.
     05  Key-Alt-k       pic 9(3) value 037.
     05  Key-Alt-l       pic 9(3) value 038.
     05  Key-Alt-m       pic 9(3) value 050.
     05  Key-Alt-n       pic 9(3) value 049.
     05  Key-Alt-o       pic 9(3) value 024.
     05  Key-Alt-p       pic 9(3) value 025.
     05  Key-Alt-q       pic 9(3) value 016.
     05  Key-Alt-r       pic 9(3) value 019.
     05  Key-Alt-s       pic 9(3) value 031.
     05  Key-Alt-t       pic 9(3) value 020.
     05  Key-Alt-u       pic 9(3) value 022.
     05  Key-Alt-v       pic 9(3) value 047.
     05  Key-Alt-w       pic 9(3) value 017.
     05  Key-Alt-x       pic 9(3) value 045.
     05  Key-Alt-y       pic 9(3) value 021.
     05  Key-Alt-z       pic 9(3) value 044.

     05  Key-Ctrl-a      pic 9(3) value 001.
     05  Key-Ctrl-b      pic 9(3) value 002.
     05  Key-Ctrl-c      pic 9(3) value 003.
     05  Key-Ctrl-d      pic 9(3) value 004.
     05  Key-Ctrl-e      pic 9(3) value 005.
     05  Key-Ctrl-f      pic 9(3) value 006.
     05  Key-Ctrl-g      pic 9(3) value 007.
     05  Key-Ctrl-h      pic 9(3) value 008.
     05  Key-Ctrl-i      pic 9(3) value 009.
     05  Key-Ctrl-j      pic 9(3) value 010.
     05  Key-Ctrl-k      pic 9(3) value 011.
     05  Key-Ctrl-l      pic 9(3) value 012.
     05  Key-Ctrl-m      pic 9(3) value 013.  *> the same ENTER key code
     05  Key-Ctrl-n      pic 9(3) value 014.
     05  Key-Ctrl-o      pic 9(3) value 015.
     05  Key-Ctrl-p      pic 9(3) value 016.
     05  Key-Ctrl-q      pic 9(3) value 017.
     05  Key-Ctrl-r      pic 9(3) value 018.
     05  Key-Ctrl-s      pic 9(3) value 019.
     05  Key-Ctrl-t      pic 9(3) value 020.
     05  Key-Ctrl-u      pic 9(3) value 021.
     05  Key-Ctrl-v      pic 9(3) value 022.
     05  Key-Ctrl-w      pic 9(3) value 023.
     05  Key-Ctrl-x      pic 9(3) value 024.
     05  Key-Ctrl-y      pic 9(3) value 025.
     05  Key-Ctrl-z      pic 9(3) value 026.

*> ***********************************************************************************
*> ASCII CHARACTERS
*> ***********************************************************************************
     *> lowercase (a-z) from 97 to 122
     05  Key-a            pic 9(3) value 097.
     05  Key-b            pic 9(3) value 098.
     05  Key-c            pic 9(3) value 099.
     05  Key-d            pic 9(3) value 100.
     *> ......................................
     05  Key-z            pic 9(3) value 122.
     *> uppercase (A-Z)  from 65 to 90
     05  Key-A            pic 9(3) value 065.
     05  Key-B            pic 9(3) value 066.
     05  Key-C            pic 9(3) value 067.
     05  Key-D            pic 9(3) value 068.
     *> ......................................
     05  Key-Z            pic 9(3) value 090.

     05  Key-0            pic 9(3) value 048.
     05  Key-1            pic 9(3) value 049.
     05  Key-2            pic 9(3) value 050.
     05  Key-3            pic 9(3) value 051.
     05  Key-4            pic 9(3) value 052.
     05  Key-5            pic 9(3) value 053.
     05  Key-6            pic 9(3) value 054.
     05  Key-7            pic 9(3) value 055.
     05  Key-8            pic 9(3) value 056.
     05  Key-9            pic 9(3) value 057.
     05  Key-Numpad0      pic 9(3) value 082.

     05  Key-space        pic 9(3) value 032.  *>  space
     05  Key-esclamation  pic 9(3) value 033.  *>  !
     05  Key-quotes       pic 9(3) value 034.  *>  "
     05  Key-hash         pic 9(3) value 035.  *>  #
     05  Key-dollar       pic 9(3) value 036.  *>  $
     05  Key-percent      pic 9(3) value 037.  *>  %
     05  Key-ampersand    pic 9(3) value 038.  *>  &
     05  Key-apost        pic 9(3) value 039.  *>  '
     05  Key-open         pic 9(3) value 040.  *>  (
     05  Key-close        pic 9(3) value 041.  *>  )
     05  Key-star         pic 9(3) value 042.  *>  *
     05  Key-plus         pic 9(3) value 043.  *>  +
     05  Key-comma        pic 9(3) value 044.  *>  ,
     05  Key-minus        pic 9(3) value 045.  *>  -
     05  Key-dot          pic 9(3) value 046.  *>  .
     05  Key-slash        pic 9(3) value 047.  *>  /
     05  Key-colon        pic 9(3) value 058.  *>  :
     05  Key-semicolon    pic 9(3) value 059.  *>  ;
     05  Key-less         pic 9(3) value 060.  *>  <
     05  Key-equal        pic 9(3) value 061.  *>  =
     05  Key-greater      pic 9(3) value 062.  *>  >
     05  Key-question     pic 9(3) value 063.  *>  ?
     05  Key-atsign       pic 9(3) value 064.  *>  @
     05  Key-braceleft    pic 9(3) value 123.  *> {
     05  Key-pipe         pic 9(3) value 124.  *> |
     05  Key-braceright   pic 9(3) value 125.  *> }
     05  Key-tilde        pic 9(3) value 125.  *> ~
     05  Key-bracketleft  pic 9(3) value 091.  *>  [
     05  Key-backSlash    pic 9(3) value 092.  *>  \
     05  Key-bracketright pic 9(3) value 093.  *>  ]
     05  Key-circumflex   pic 9(3) value 094.  *>  ^
     05  Key-underscore   pic 9(3) value 095.  *>  _
     05  Key-apostrophe   pic 9(3) value 096.  *>  `