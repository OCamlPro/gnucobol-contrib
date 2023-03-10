01 GC09BUTTONS pic x(11) value 'GC09BUTTONS'.
01 Buttons-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC09BUTTONS.COB - DISPLAY BUTTONS AND MANAGE BUTTONS ON SCREEN
*> Usage:      call GC09BUTTONS using Buttons-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.4 2020.12.12
*> Changelog:  1.0 first release.
*>             1.1 added beep parameter
*>             1.2 added hot key management
*>             1.3 Bu-Hot changed from 9(01) to 9(02)
*>             2.0 Little changes fro mouse management
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
*> Bu-Act    1= this Button is displayed as Active (tobe Selected)(it has the focus)
*>           only one of items can have Bu-Act = 1. it will be highlighted
*>           at first display of the buttons. when you exit from the buttons function
*>           the active button (item) will have '1' other items will have blank.
*> Bu-r      row & col where the button starts on screen
*> Bu-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           buttons can be displayed in every position, vertical, horizontal or sparse.
*>           buttons cannot be overlapped ! (the fuction does not have controls !)
*> Bu-Item   charatcters string to be displayed inside the Button (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Bu-Hot    position of the char of Bu-Item that have to be used as hot key .
*>           if Bu-Item= "Exit" and Bu-Hot= 2 (x is the hotkey), typing X or x activate the button
*>           Hot key is case insensistive  (if hotkey is "A" you can type "A" or also "a" )
*>           only letters (lower or uppercase) or digits, no other chars (no +, ?, ! etc.)
*> Bu-Shadow Y= draw a shadow around buttons  Default = Y
*> Bu-Arrow  If the selected button displayed in "selected" color,
*>           has also "arrows" before and after the button description*>
*>           0 = (or other character) = no arrows;
*>           1= ex. [>   EXIT   <] at border of button ;
*>           2= ex. [ >  EXIT  < ] at 2nd and penultimate position
*> Bu-Arrow-Char1/2 Single chars to make active button more visible (ex: > and <  or: ( and )  or: = ...)
*> Bu-click  Y= when hit enter or mouse doubleclick on a button you will have a "click effect"
*>           = move button 1 char to right, change colors to black/white and have no shadow
*> Bu-beep   Y= when hit enter or mouse doubleclcik on a button sound a beep
*> Bu- bcoshadow set it to the same back color of the underlying background
*>
*> Bu-selected Returns to caller the number of selected button by the user 01, 02, 03, ..
*> Bu-Key    key pressed by user: 0000 = Enter, 2005 = Escape, 2043 = mouse left doubleclick
*>           Caller pgm will know if user selected a button
*>           with enter or Mouse left doubleclick or has pressed Escape key to exit
*>           Retunrn codes are GnuCOBOL FUNCTION KEYS, KEY CODES, MOUSE KEYS CODES
*> ***********************************************************************************
     03 Bu-Tab  value low-value.
        04 Bu-Ele occurs 25.
           05 Bu-Act          pic x(01).
           05 Bu-HotX.
              07 Bu-Hot       pic 9(02).
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
     *> RETURNS TO CALLER
     *> *************************************************************
     03 Bu-Selected       pic 9(02).
     03 Bu-Key            pic 9(04).
