01 GC64CALCULATOR pic x(14) value 'GC64CALCULATOR'.
01 Calculator-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC64CALCULATOR.COB - POCKET CALCULATOR
*> Usage:      call GC64CALCULATOR using Calculatora-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2020.04.10
*> Changelog:
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> r1,c1     row and col of the upper left corner of the calculator box
*> Box       Y= draw a box around the calculator
*> Title     Title of calculator
*>
*> Result    number calculated returned to CALLER
*> *************************************************************************************
     03 Ca-Parameters.
        05 Ca-rc.
           07 Ca-r1            pic  9(03) value 002.
           07 Ca-c1            pic  9(03) value 010.
        05 Ca-Box              pic  x(01) value 'Y'.

        *> Calculator Box parameters
        05 Ca-Box-bco     pic 9(01) value 7.   *> back color of the box
        05 Ca-Box-fco     pic 9(01) value 4.   *> fore color of the box  (the box frame)
        05 Ca-Box-fcoH    pic X(01) value 'Y'. *> Y = Hilight Foreground (the box frame)
        05 Ca-Box-style   pic X(01) value 'S'. *> S, D, 1, 2, 3, N, C
        05 Ca-Box-custom  PIC X(09) VALUE 'ABCDEFGHI'. *> UL, UC, UR, ML, MC, MR, LL, LC, LR
        05 Ca-Box-fill    pic X(01) value 'Y'. *> Y = filled box, else an empty box
        05 Ca-Box-shadow  pic x(01) value 'N'. *> Y = box with shadow
        05 Ca-Box-3D      pic x(01) value 'N'. *> N=no3D, 3D effect: R= Recessed, E= Embossed/Relief
        05 Ca-Box-add1c   pic x(01) value 'N'. *> enlarge box for a better 3D effect
        05 Ca-Box-beep    pic x(01) value 'N'. *> Y = ring the bell
        05 Ca-Box-tit     pic x(01) value 'Y'. *> Y = display a title at top of the box
        05 Ca-Box-titBco  pic 9(01) value 7.   *> back color of title
        05 Ca-Box-titFco  pic 9(01) value 7.   *> fore color of title
        05 Ca-Box-titFcoH pic X(01) value 'Y'. *> hilight fore color of title ?
        05 Ca-Box-titDes  pic x(80) value ' GnuCOBOL Calculator ' & x'00'.

     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Ca-Result         PIC S9(16)V999 value 0.
