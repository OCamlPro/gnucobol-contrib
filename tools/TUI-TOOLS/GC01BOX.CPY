01 GC01BOX pic x(07) value 'GC01BOX'.
01 Box-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC01BOX.COB - DISPLAY A BOX
*> Usage:      call GC01BOX using BOX-AREA
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row & column of upper left corner   - DEFAULT: 01,01
*> r2,c2     row & column of lower right corner  - DEFAULT: 25, 80
*> bco,fco   box background & foreground (the frame) color
*> hilight   Y= the foreground (the frame of the box) is highlighted
*> style     S= Single line, D= Double line, 1,2=character box, 3=a solid frame (does'nt work!)
*>           N= noline (to colour a zone), C= custom
*> custom    if style=C, here are 9 chars to draw the box: UpLeft, UpCenter, UpRight, MiddleLeft, MC, MR, LowLeft, LC, LR
*> fill      Y= filled box, N= transparent box, draw only the frame
*> shadow    Y= draw a shadow low & right of the box. DEFAULT: no shadow
*> 3D        N= no 3D; E= 3D box EMBOSSED/RELIEF; R= 3D box RECESSED
*>           if 3D box requested, fore color is forced to black&white to have the 3D effect.
*> add1c     Y= box width expanded 1 col at left and 1 col at right.
*>           improve appaerance of 3D box. (not yet implemented)
*> beep      Y= bell
*> tit       Y= display a title
*> titDes    string to be displayed as title
*>                                       c1
*>           Example               r1 ->  ABBBBBBBBBBBB TTTTTTTTT BBBBBBBBBBBBC
*>           style = ABCDEFGHZ displays:  DEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEF
*>                                        DEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEF
*>                                        DEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEF
*>                                        GHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHI <- r2
*>                                                                     c2
*>           where ' TTTTTTTTT ' is the title of the box if requested (optional)
*> ***********************************************************************************
   03 Box-rc.
      05 Box-r1c1.
         07 Box-r1   pic 9(03) value 001.
         07 Box-c1   pic 9(03) value 001.
      05 Box-r2c2.
         07 Box-r2   pic 9(03) value 025.
         07 Box-c2   pic 9(03) value 080.
   03 Box-Parameters.
      05 Box-bco     pic 9(01) value 7.       *> back color of the box
      05 Box-fco     pic 9(01) value 7.       *> fore color of the box (the frame)
      05 Box-fcoH    pic X(01) value "Y".         *> Hilight Foreground ?
      05 Box-style   pic X(01) value "D".         *> S, D, 1, 2, 3, N, C
      05 Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
      05 Box-fill    pic X(01) value "Y".         *> filled box
      05 Box-shadow  pic x(01) value 'N'.         *> box with shadow
      05 Box-3D      pic x(01) value 'N'.         *> N=no3D, 3D effect: R= Recessed, E= Embossed/Relief
      05 Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
      05 Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
      05 Box-tit     pic x(01) value 'N'.         *> Y = display a title at top of the box
      05 Box-titBco  pic 9(01) value 7.           *> back color of titlebox
      05 Box-titFco  pic 9(01) value 7.           *> fore color of titlebox
      05 Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?
      05 Box-titDes  pic x(80) value space.       *> string from 1 to 80 char, to be used as a box title
