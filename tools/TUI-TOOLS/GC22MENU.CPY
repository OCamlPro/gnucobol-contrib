01 GC22MENU pic x(20) value 'GC22MENU'.
01 Menu-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC22MENU.COB FUNCTION TO MANAGE A MENU ON SCREEN
*> Usage:      call GC22MENU using Menu-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.20
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> You can manage menus with max 24 items.
*> Each item has to be inserted in a table of 25 elements, last char has tobe = low-value
*> there has to be a last menu item filled with low-values
*>
*> Each menu item has following fields:
*> PARAMETER DESCRIPTION
*> --------- ----------------------------------------------------
*> Mn-Act    1= this item is displayed as Active/tobe Selected
*>           only one of items can have Mn-Act = 1. it will be displayed as active
*>           at first display of the menu. when you exit from the menu
*>           the active item will have '1' other items will have blank.
*> Mn-Hot    char number in a menu item string of char to be used as "hot key" .
*>           ex. if menu item is " Exit " and Mn-Hot = 2, typing E or e make item "active"
*>           Hot key is case insensistive  (if hotkey is "A" you can type "a" )
*>           only letters (lower or uppercase) or digits, no other chars (no +, ?, ! etc.)
*> Mn-r      row & col where the menu item starts on screen
*> Mn-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           menu items can be displayed in every position, horizontal (bar menu), vertical, sparse.
*>           menu items can be also all overlapped (you will have like a list-box)
*> Mn-Item   charatcters string to be displayed as menu item (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*>           Setting 24 items of 80 chars, fills the screen.
*> Mn-Mess   character string max 80 chars) thats system displays at row 25 on screen.
*>           it is a message associated at each menu item
*>           It has to be in ASCIIZ (must have x'00'(low-value) as last byte
*>           It is not mandatory but if present it has tobe max 80 chars
*>
*> PARAMETER DESCRIPTION
*> --------- ----------------------------------------------------

*> Mn-MessRow number of Row where display the message associated to each menu item. Default= 25
*> Mn-Arrow  H= you can select items only with cursor left -> and cursor right <- (horizontal)
*>           V= you can select items only with cursor up and down (vertical)
*>           useful to manage drop-down menus
*>           Other values (ex a space) means you can select/scroll menu items with all cursor keys:
*>            -> or cursor down = next item; <- or cursor up = previous item
*> Mn-Return Y= means if pressed an invalid arrow, the "menu" function returns to caller
*>           ex. Mn-Arrow = V and the user press cursor left or right
*>           It is useful when caller have to take an action (key code pressed is on Mn-Key field)
*>           Ex.in a drop down menu you press -> or <- then you have to move the drop down menu
*>           Other values in this field means a cursor is simply ignored
*> Mn-BcoN/FcoN   back and fore color for non active items
*> Mn-BcoS/FcoS   back and fore color for the active item
*> Mn-BcoH/FcoH   back and fore color for Hot Key character
*> Mn-Box    Y= draw a box around the list of items. DEFAULT: no box. box parameters follows
*>
*> PARAMETER DESCRIPTION
*> --------- ----------------------------------------------------
*> Mn-Selected  The number of selected item. returned to caller: 01, 02, 03, ..
*> Mn-Key       ScanCode returned to caller at exit from the program, 0013= Enter, 0027= ESACPE
*> ***********************************************************************************
     03 Mn-Tab  value low-value.
        05 Mn-Ele occurs 25.             *> last item has tobe low-value (x'00)')
           07 Mn-Act      pic x(01).     *> 1 = item is "active"
           07 Mn-Hot      pic 9(01).     *> num of character used as hotkey
           07 Mn-r        pic 9(03).     *> row of menu item
           07 Mn-c        pic 9(03).     *> col of menu item
           07 Mn-Item     pic x(81).     *> menu item text, last char hast tobe = x'00'
           07 Mn-Mess     pic x(81).     *> message associated to each menu item

     03 Mn-Parameters.
        05 Mn-MessRow        pic 9(03) value 025.
        05 Mn-Arrow          pic x(01) value space.
        05 Mn-Return         pic x(01) value space.
        *> Normal menu item colors
        05 Mn-bcoN           pic 9(01) value white.  *> backcolor for "non active" menu item
        05 Mn-fcoN           pic 9(01) value black.  *> forecolor for "non active" menu item
        05 Mn-fcoNH          pic X(01) Value 'N'.    *> foreground Normal in Highlight ?
        *> selected menu item colors
        05 Mn-bcoS           pic 9(01) value green.  *> backcolor for "active" menu item
        05 Mn-fcoS           pic 9(01) value white.  *> forecolor for "active" menu item
        05 Mn-fcoSH          pic X(01) Value 'Y'.    *> forecolor of selected in Highlight ?
        *> colors for hot key char for a menu item
        05 Mn-bcoH           pic 9(01) value white.  *> backcolor for "hot key" char
        05 Mn-fcoH           pic 9(01) value red.    *> forecolor for "hot key" char
        05 Mn-fcoHH          pic X(01) Value 'Y'.    *> foreground hotkey in Highlight ?
        *> message row colors
        05 Mn-bcoM           pic 9(01) value white.  *> backcolor for message row
        05 Mn-fcoM           pic 9(01) value black.  *> forecolor for message row
        05 Mn-fcoMH          pic X(01) Value 'N'.    *> forecolor of messsage in Highlight ?

        05 Mn-Box            pic x(01) value 'N'.

        05 Mn-Box-Parameters.                             *> only used when Mn-Box = Y
           07 Mn-Box-bco     pic 9(01) value white.       *> back color of the box
           07 Mn-Box-fco     pic 9(01) value red.         *> fore color of the box  (the frame)
           07 Mn-Box-fcoH    pic X(01) value "Y".         *> Y = Hilight Foreground (the frame of the box)
           07 Mn-Box-style   pic X(01) value "D".         *> S, D, 1, 2, 3, N, C
           07 Mn-Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
           07 Mn-Box-fill    pic X(01) value "N".         *> Y = filled box
           07 Mn-Box-shadow  pic x(01) value 'N'.         *> Y = box with shadow
           07 Mn-Box-3D      pic x(01) value 'N'.         *> N=no3D, 3Deffect: R=Recessed, E=Embossed/Relief
           07 Mn-Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
           07 Mn-Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
           07 Mn-Box-tit     pic x(01) value 'N'.         *> Y = display a title at top of the box
           07 Mn-Box-titBco  pic 9(01) value 7.           *> back color of titlebox
           07 Mn-Box-titFco  pic 9(01) value 7.           *> fore color of titlebox
           07 Mn-Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?
           07 Mn-Box-titDes  pic x(80) value space.       *> string 1 to 80 char, used as a box title

     *> ***********************************************************************************
     *> FIELDS RETURNED TO CALLER
     *> ***********************************************************************************
     03 Mn-Selected       pic 9(02).  *> number of selected menu item: 01, 02 etc.
     03 Mn-Key            pic 9(04).  *> 0013 = Enter, 0027 = ESCAPE ....
