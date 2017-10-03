01 GC09BUTTONS pic x(11) value 'GC09BUTTONS'.
01 Buttons-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC09BUTTONS.COB - DISPLAY BUTTONS
*> Usage:      call GC09BUTTONS using Buttons-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.2 2017.10.0402.28
*> Changelog:  1.0 first release.
*>             1.1 added beep parameter
*>             1.2 added hot key management
*> ***********************************************************************************
*> on screen You can manage max 24 buttons of 1 row .
*> Each button has tobe inserted in a table with 25 elements
*> there has to be a last item filled with low-value
*>
*> Example of use.
*>
*> step 1. display a box (not mandatory ) but good to have a better user interface
*>     move 08    to box-r1
*>     move 47    to box-c1
*>     move 18    to box-r2
*>     move 68    to box-c2
*>     CALL GC01BOX USING BOX-AREA
*>
*> step 2. display Buttons inside the BOX
*>   (remember to set the button's shadow background to the same color of the box background)
*>   Move ' 3010051  Confirm    ' & x'00' to Bu-Ele(01)
*>   Move ' 4012051    Exit     ' & x'00' to Bu-Ele(02)
*>   Move '13014051   Ignore    ' & x'00' to Bu-Ele(03)
*>   Move ' 5016051     OK      ' & x'00' to Bu-Ele(04)
*>   CALL GC09BUTTONS using Buttons-Area.
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Bu-Act    1= this item is displayed as the one Active (tobe Selected)
*>           only one of items can have '1' . it will be highlighted
*>           at first display of the buttons. when you exit from the buttons function
*>           the active button (item) will have '1' other items will have blank.
*> Bu-r      row & col where the button starts on screen
*> Bu-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           buttons can be displayed in every position, also sparse.
*>           buttons cannot be overlapped ! (the fuction does not havecontrols !)
*> Bu-Item   charatcters string to be displayed on Button (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Bu-Hot    number of char to be used as hot key .
*>           ex. if Bu-Item = "Exit" and Bu-Hot = 2, typing X or x activate the button
*> Bu-Shadow Y= draw a shadow around buttons  Default = Y
*> Bu-Arrow  If the selected button displayed in "selected" color,
*>           has also "arrows" before and after the button description
*>           1= ex.[> EXIT <] at border of button ;
*>           2= ex. [ > EXIT < ] at 2nd and penultimate position
*>           0 = (or other character) = no arrows;
*> Bu-Arrow-Char1/2 Single chars to make active button more visible
*> Bu-click  Y= when hit enter on a button you will have a "click effect"
*>           move button 1 char to right, black/white color , no shadow
*> Bu-beep   Y= when hit enter on button sound a beep
*> Bu bco-shadow set it to the same back color of the underlying background
*>
*> Bu-selected Returns to caller the number of selected button by the user 01, 02, 03, ..
*> Bu-Key    key code pressed by user: 0013 = Enter, 0027 = Escape
*>           Caller pgm will know if user selected a button
*>         with enter or has pressed Escape key to exit
*> *************************************************************
     03 Bu-Tab  value low-value.
        04 Bu-Ele occurs 25.
           05 Bu-Act          pic x(01).
           05 Bu-Hot          pic 9(01).
           05 Bu-r            pic 9(03).
           05 Bu-c            pic 9(03).
           05 Bu-Item         pic x(81).
     03 Bu-Parameters.
        05 Bu-Shadow             pic x(01) value 'Y'.
        05 Bu-Arrow              pic x(01) value '2'.
        05 Bu-Arrow-Chars.
           07 Bu-Arrow-Char1     pic x(01) value '>'.
           07 Bu-Arrow-Char2     pic x(01) value '<'.
        05 Bu-Click              pic x(01) value 'N'.
        05 Bu-Beep               pic x(01) value 'N'.
        *> colors for Normal button (non active)
        05 Bu-bcoN           pic 9(01) value green.  *> default backcolor for "normal" button
        05 Bu-fcoN           pic 9(01) value black.  *> default forecolor for "normal" button
        05 Bu-fcoNH          pic X(01) Value 'N'.    *> default foreground Normal in Highlight ?
        *> colors for active (to be selected) button
        05 Bu-bcoS           pic 9(01) value green.  *> default backcolor for "active" button
        05 Bu-fcoS           pic 9(01) value white.  *> default forecolor for "active" button
        05 Bu-fcoSH          pic X(01) Value 'Y'.    *> default forecolor of active in Highlight ?
        *> colors for hot key char of a button
        05 Bu-bcoH           pic 9(01) value white.  *> default backcolor for "hot key" char
        05 Bu-fcoH           pic 9(01) value red.    *> defalut forecolor for "hot key" char
        05 Bu-fcoHH          pic X(01) Value 'Y'.    *> default foreground hotkey in Highlight ?
        *> back color of shadow background (it has tobe settled to the same of box background)
        05 Bu-bcoShadow      pic 9(01) value white.  *> default backcolor for "shadow" of buttons
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Bu-Selected       pic 9(02).
     03 Bu-Key            pic 9(04).
