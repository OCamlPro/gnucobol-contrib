*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    workarea with KEY SCANCODES FOR ASCI & NON ASCII charatcters.
*> Usage:      use CALL STATIC "GETCH" RETURNING Key-Pressed END-CALL
*>             your program will wait for a user input. Field - KeyPressed -
*>             will contain the corresponding scancode of the key pressed by the user
*> Author:     Eugenio Di Lorenzo (DILO) - Italia
*> License:    Copyright 2016 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.3 2018.05.01
*> Changelog:  1.0 first release.
*>             1.1 keys CTRL-F1/3 added
*>             1.2 keys alt-lc added, table fields added
*>             1.3 alt/ctrl-home /end added
*> ***********************************************************************************
01 Key-Pressed            pic 9(3) value zero.
01 Key-Code.
*> ***********************************************************************************
*> NON ASCII CHARACTERS
*> ***********************************************************************************
   03 Key-Non-Ascii.
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

      05  Key-Alt-Home         pic 9(3) value 151.
      05  Key-Alt-End          pic 9(3) value 159.
      05  Key-Alt-CursUp       pic 9(3) value 152.
      05  Key-Alt-CursLeft     pic 9(3) value 155.
      05  Key-Alt-CursRight    pic 9(3) value 157.
      05  Key-Alt-CursDn       pic 9(3) value 160.

      05  Key-Ctrl-Home        pic 9(3) value 119.
      05  Key-Ctrl-End         pic 9(3) value 117.
      05  Key-Ctrl-CursUp      pic 9(3) value 141.
      05  Key-Ctrl-CursLeft    pic 9(3) value 115.
      05  Key-Ctrl-CursRight   pic 9(3) value 116.
      05  Key-Ctrl-CursDn      pic 9(3) value 145.

   03 Key-FX.
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

   03 Key-Ctrl-FX.
      05  Key-Ctrl-F1     pic 9(3) value 094.
      05  Key-Ctrl-F2     pic 9(3) value 095.
      05  Key-Ctrl-F3     pic 9(3) value 096.

   03 Key-Alt.
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
   03  Key-Alt-Table redefines Key-Alt.
      05 Key-Alt-Ele      pic 9(3) occurs 26 indexed by Key-Alt-Idx.

   03 Key-Ctrl.
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
   03  Key-Ctrl-Table redefines Key-Ctrl.
      05 Key-Ctrl-Ele     pic 9(3) occurs 26 indexed by Key-Ctrl-Idx.

   03 Key-lc.
      *>  lowercase (a-z) from 97 to 122
      05  Key-lc-a         pic 9(3) value 097.
      05  Key-lc-b         pic 9(3) value 098.
      05  Key-lc-c         pic 9(3) value 099.
      05  Key-lc-d         pic 9(3) value 100.
      05  Key-lc-e         pic 9(3) value 101.
      05  Key-lc-f         pic 9(3) value 102.
      05  Key-lc-g         pic 9(3) value 103.
      05  Key-lc-h         pic 9(3) value 104.
      05  Key-lc-i         pic 9(3) value 105.
      05  Key-lc-j         pic 9(3) value 106.
      05  Key-lc-k         pic 9(3) value 107.
      05  Key-lc-l         pic 9(3) value 108.
      05  Key-lc-m         pic 9(3) value 109.
      05  Key-lc-n         pic 9(3) value 110.
      05  Key-lc-o         pic 9(3) value 111.
      05  Key-lc-p         pic 9(3) value 112.
      05  Key-lc-q         pic 9(3) value 113.
      05  Key-lc-r         pic 9(3) value 114.
      05  Key-lc-s         pic 9(3) value 115.
      05  Key-lc-t         pic 9(3) value 116.
      05  Key-lc-u         pic 9(3) value 117.
      05  Key-lc-v         pic 9(3) value 118.
      05  Key-lc-w         pic 9(3) value 119.
      05  Key-lc-x         pic 9(3) value 120.
      05  Key-lc-y         pic 9(3) value 121.
      05  Key-lc-z         pic 9(3) value 122.
   03  Key-lc-Table redefines Key-lc.
      05 Key-lc-Ele        pic 9(3) occurs 26 indexed by Key-lc-Idx.

   03 Key-uc.
     *>  uppercase (A-Z) from 65 to 90
      05  Key-uc-A         pic 9(3) value 065.
      05  Key-uc-B         pic 9(3) value 066.
      05  Key-uc-C         pic 9(3) value 067.
      05  Key-uc-D         pic 9(3) value 068.
      *> ......................................
      05  Key-uc-Z         pic 9(3) value 090.

   03 Key-num.
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
    03  Key-num-Table redefines Key-num.
      05 Key-num-Ele        pic 9(3) occurs 10 indexed by Key-num-Idx.

   03 Key-others.
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
