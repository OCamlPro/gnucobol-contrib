01 GC52COLORPICKER pic x(15) value 'GC52COLORPICKER'.
01 ColorPicker-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC52COLORPICKER.COB - DISPLAY A 8 x 8 COLORMAP
*> Usage:      call GC52COLORPICKER using ColorPicker-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2017.12.01
*> Changelog:  1.0 first release.
*>             2.0 Mouse management added
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row & column of upper left corner   - DEFAULT: 05,15  (at center of the screen)
*> bco,fco   box background & foreground color (the frame)
*> fcoH      Y= the foreground (the frame of the box) is highlighted
*> style     S= Single line border, D= Double line, 1,2=characters box, 3=solid frame (doesn't work!)
*>           N= noline (just colour the backgound), C= custom
*> custom    if style=C, here are 9 chars to draw the box:
*>           UpLeft, UpCenter, UpRight, MiddleLeft, MiddleCenter, MR, LowLeft, LowCenter, LowRight
*> fill      Y= filled box, N= transparent box (draw only the frame)
*> shadow    Y= draw a shadow low & right of the box. DEFAULT: no shadow
*> 3D        N= no 3D borders; E= 3D box EMBOSSED/RELIEF; R= 3D box RECESSED
*>           if 3D box requested, fore color is forced to black&white to have the 3D effect.
*> add1c     Y= box width expanded 1 col at left and 1 col at right.
*>           improve appaerance of 3D box. (not yet implemented)
*> beep      Y= sound a bell at first display
*> tit       Y= display a title
*> titDes    string to be displayed as title
*>
*> BackCol   Background color selected by the user (from 0 to 7)
*> ForeCol   Foreground color selected by the user (from 0 to 7)
*> CoorPair  The corresponding Color Pair Code. FROM 00 TO 63.
*>           in the table there are some exceptions (all when BackGround is black):
*>           white on black is = 00, green on black is = 01, black on black is = 63
*>           see more description into the program GC52COLORPICKER
*> Key       the GnuCOBOL code of key used by the user (enter, escape or a mouse key)
*> ***********************************************************************************
   03 Cop-rc.
      05 Cop-r1c1.
         07 Cop-r1   pic 9(03) value 005.
         07 Cop-c1   pic 9(03) value 015.

   03 Cop-Parameters.                               *> see also GC01BOX.CPY for same descriptions
      05 Cop-bco     pic 9(01) value black.         *> back color of the colorpicker
      05 Cop-fco     pic 9(01) value white.         *> fore color of the colorpicker
      05 Cop-fcoH    pic X(01) value "Y".           *> Hilight Foreground ?
      05 Cop-style   pic X(01) value "S".           *> S, D, 1, 2, 3, N, C
      05 Cop-custom  PIC X(09) VALUE "ABCDEFGHI".   *> UL, UC, UR, ML, MC, MR, LL, LC, LR
      05 Cop-fill    pic X(01) value "Y".           *> filled box
      05 Cop-shadow  pic x(01) value 'N'.           *> box with shadow
      05 Cop-3D      pic x(01) value 'N'.           *> N=no3D, 3D effect: R= Recessed, E= Embossed/Relief
      05 Cop-add1c   pic x(01) value 'N'.           *> enlarge box for a better 3D effect
      05 Cop-beep    pic x(01) value 'N'.           *> Y = ring the bell
      05 Cop-tit     pic x(01) value 'Y'.           *> Y = display a title at top of the box
      05 Cop-titBco  pic 9(01) value cyan.          *> back color of titleBox
      05 Cop-titFco  pic 9(01) value white.         *> fore color of titleBox
      05 Cop-titFcoH pic X(01) value "Y".           *> hiligth fore color of titleBox ?
      05 Cop-titDes  pic x(80) value x'B4' & ' Color Pair Picker (F1=Help) '  & x'C3' & x'00' .
*> *************************************************************
*> FIELDS RETURNED TO THE CALLER
*> *************************************************************
   03 Cop-BackCol   pic  9(02) value zero. *> User has selected this color
   03 Cop-ForeCol   pic  9(02) value zero. *> User has selected this color
   03 Cop-ColorPair pic  9(02) value zero. *> User has selected this color pair code
   03 Cop-Key       pic  9(04) value zero. *> which Key to exit (enter, escape or mouse key code)
