01 GC02BOXMEX pic X(10) value 'GC02BOXMEX'.
01 Boxmex-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC02BOXMEX.COB - DISPLAY MESSAGE IN A BOX
*> Usage:      call GC02BOXMEX using Boxmex-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> wait      Y= display the message and wait for a user keypress
*>           N= diisplay the message and returns to caller
*> savescr   Y= program saves the screen before displaying the message
*>              and restore it after displayed the message
*>           N= program dispalys the message and return to caller
*>              screen remains modified from message in the box
*>           Note: setting wait=N & savescr=N you will have a permanent message on screen
*> tabmex    table of 1 to 20 strings to be displayed in the box
*>           firts element will be displayed 1 row under the box frame
*>           and 1 column right of the box frame. see following sample:
*>
*>           c1
*>        r1 +-----------------------------------+
*>         1 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|  <- first row of the message text
*>         2 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|  <- 2nd row of the message text
*>         3 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>         4 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>         5 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>         6 |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>         7 |                                   |  <- last row of the message text (es. = blank)
*>           |            <   OK   >             |  <- 'ok button' is always at row=r2 -2 of the box
*>           |                                   |
*>           +-----------------------------------+ r2
*>                                               c2
*>       r2 has to be at least = r1 + 'n.of non blank rows of messages' + 3
*>       max 20 rows,  max 78 chars each one. Strings have to be
*>       in ASCIIZ format = last byte is x'00'(low-value).
*> ***********************************************************************************
   03 Bxm-rc.
      05 Bxm-r1c1.
         07 Bxm-r1   pic 9(03) value 001.
         07 Bxm-c1   pic 9(03) value 001.
      05 Bxm-r2c2.
         07 Bxm-r2   pic 9(03) value 025.
         07 Bxm-c2   pic 9(03) value 080.
   03 Bxm-Parameters.
      05 Bxm-bco     pic 9(01) value white.       *> back color of box
      05 Bxm-fco     pic 9(01) value white.       *> fore color of box
      05 Bxm-fcoH    pic X(01) value 'Y'.         *> Hilight Foreground ? (frame of the box)
      05 Bxm-style   pic X(01) value 'S'.         *> single line frame
      05 Bxm-custom  PIC X(09) VALUE 'ABCDEFGHI'. *> UL, UC, UR, ML, MC, MR, LL, LC, LR
      05 Bxm-fill    pic X(01) value 'Y'.         *> filled Box
      05 Bxm-shadow  pic x(01) value 'N'.         *> box with shadow
      05 Bxm-3D      pic x(01) value 'E'.         *> N=no3D, 3D effect: R= Recessed, E= Embossed/Relief
      05 Bxm-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
      05 Bxm-beep    pic x(01) value 'N'.         *> Y = bell
      *> colors for the message
      05 Bxm-bcoM       pic 9(01) value white.    *> back color of message text (use same of box )
      05 Bxm-fcoM       pic 9(01) value black.    *> fore color of message text
      05 Bxm-fcoMH      pic X(01) value 'Y'.      *> Hilight Foreground  (message text)
      05 Bxm-wait       pic x(01) value 'Y'.
      05 Bxm-savescr    pic x(01) value 'Y'.
      05 Bxm-tit     pic x(01) value 'N'.         *> Y = display a title at top of the box
      05 Bxm-titBco  pic 9(01) value white.       *> back color of titlebox
      05 Bxm-titFco  pic 9(01) value white.       *> fore color of titlebox
      05 Bxm-titFcoH pic X(01) value 'Y'.         *> hiligth fore color of titlebox ?
      05 Bxm-titDes  pic x(80) value space.       *> string from 1 to 80 char, to be used as a box title
   *> 80 columns - 2 cols for box frame + 1 column for x'00' to have an ASCIIZ string = 79
     03 Bxm-tabmex.
      05 Bxm-mex     pic x(79) occurs 20 value low-value.
