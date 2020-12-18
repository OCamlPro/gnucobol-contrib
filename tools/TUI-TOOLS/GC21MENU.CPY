01 GC21MENU pic x(20) value 'GC21MENU'.
01 Menu-Area.
  *> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC21MENU.COB FUNCTION TO MANAGE A MENU ON SCREEN
*> Usage:      call GC21MENU using Menu-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.1 2020.04.18
*> Changelog:  1.0 first release.
*>             1.1 Mn-Hot from 9(01) to 9(02)
*> ***********************************************************************************
*> You can manage menus with max 24 items.
*> Each item has tobe inserted in a table with 25 elements, last char has tobe = low-value
*> there has to be a last menu item filled with low-values
*>
*> Each item has following fields:
*> FIELD     DESCRIPTION
*> --------- ----------------------------------------------------
*> Mn-Act    1= this item is displayed as Active/tobe Selected
*>           only one of items can have '1' . it will be displayed as active
*>           at first display of the menu. when you exit from the menu
*>           the active item will have '1' other items will have blank.
*> Mn-Hot    char number in a menu item string of char to be used as "hot key" .
*>           ex. if menu item is " Exit " and Mn-Hot= 02, typing e or E make item "active"
*>           Hot key is case insensistive (if hotkey is "A" you can type "a" )
*>           only letters (lower or uppercase) or digits, no other chars(no +, ?, ! etc.)
*> Mn-r      row & col where the item starts on screen
*> Mn-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           menu items can be displayed in every position, horizontal (bar menu), vertical, sparse.
*>           menu items can be also all overlapped (you will have like a list-box)
*> Mn-Item   charatcters string to be displayed as a menu item(max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*>           Setting 24 items of 80 chars, fills the screen.
*> Mn-Mess   character string max 80 chars) thats system displays at row 25 on screen.
*>           it is a message associated at each menu item
*>           It has to be in ASCIIZ (must have x'00'(low-value) as last byte
*>           It is not mandatory but if present it has tobe max 80 chars
*> Mn-Box    Y= draw a box around the list of items. DEFAULT: no box
*> Mn-Style  char string to be used as frame of the box.
*> Mn-Shadow Y = draw a shadow low & right of the box. DEFAULT: no shadow
*> Mn-MessRow number of Row where display the message associated to each menu item. Default= 25
*> Mn-Arrow  H= you can select items only with cursor left -> and cursor right <- (horizontal)
*>           V= you can select items only with cursor up and down (vertical)
*>           useful to manage drop-down menus
*>           Other values means you can select menu items with both:
*>            -> or cursor down = next item; <- or cursor up = previous item
*> Mn-Return Y= means if pressed an invalid arrow, the "menu" function returns to caller
*>           ex. Mn-Arrow = V and the user press cursor left or right
*>           It is useful when caller have to take an action (key code pressed is on Mn-Key field)
*>           Ex.in a drop down menu you press -> or <- then you have to move the drop down menu
*>           Other values in this field means a cursor is simply ignored
*> Mn-BcoN/FcoN   back and fore color for non active items
*> Mn-BcoS/FcoS   back and fore color for the active item
*> Mn-BcoH/FcoH   back and fore color for Hot Key character (displayed but not yet implemented)
*> Mn-Selected    The number of selected item. returned to caller: 01, 02, 03, ..
*> Mn-Key    Key code at exit from the menu program. returned to caller.
*>           0000 = Enter, 2005 = ESACPE
*>           Retunrn codes are GnuCOBOL FUNCTION KEYS, KEY CODES, MOUSE KEYS CODES
*> *************************************************************
     03 Mn-Tab  value low-value.
        04 Mn-Ele occurs 25.             *> last item has tobe low-value (x'00)')
           05 Mn-Act      pic x(01).     *> 1 = item is "active"
           05 Mn-Hot      pic 9(02).     *> num of character used as hotkey
           05 Mn-r        pic 9(03).     *> row
           05 Mn-c        pic 9(03).     *> col
           05 Mn-Item     pic x(81).     *> menu item text, last char hast tobe = x'00'
        04 Mn-Mess occurs 25  pic x(81). *> message associated to menu item

     03 Mn-Parameters.
        05 Mn-Box            pic x(01) value 'N'.
        05 Mn-Style          pic x(09) value 'S'. *> Single, Double, 1, 2, 3, No border
        05 Mn-Shadow         pic x(01) value 'N'. *> Y = a shadow around the box
        05 Mn-MessRow        pic 9(03) value 025.
        05 Mn-Arrow          pic x(01) value space.
        05 Mn-Return         pic x(01) value space.
        *> Normal menu item colors
        05 Mn-bcoN           pic 9(01) value white.  *> default backcolor for "non active" menu item
        05 Mn-fcoN           pic 9(01) value black.  *> default forecolor for "non active" menu item
        05 Mn-fcoNH          pic X(01) Value 'N'.    *> default foreground Normal in Highlight ?
        *> selected menu item colors
        05 Mn-bcoS           pic 9(01) value green.  *> default backcolor for "active" menu item
        05 Mn-fcoS           pic 9(01) value white.  *> default forecolor for "active" menu item
        05 Mn-fcoSH          pic X(01) Value 'Y'.    *> default forecolor of selected in Highlight ?
        *> colors for hot key char for a menu item
        05 Mn-bcoH           pic 9(01) value white.  *> default backcolor for "hot key" char
        05 Mn-fcoH           pic 9(01) value red.    *> defalut forecolor for "hot key" char
        05 Mn-fcoHH          pic X(01) Value 'Y'.    *> default foreground hotkey in Highlight ?
        *> message row colors
        05 Mn-bcoM           pic 9(01) value white.  *> default backcolor for message row
        05 Mn-fcoM           pic 9(01) value black.  *> defalut forecolor for message row
        05 Mn-fcoMH          pic X(01) Value 'N'.    *> default forecolor of messsage in Highlight ?
     *> return to caller
     03 Mn-Selected       pic 9(02).  *> number of selected menu item: 01, 02 etc.
     03 Mn-Key            pic 9(04).  *> 0000 = Enter, 2005 = ESCAPE
