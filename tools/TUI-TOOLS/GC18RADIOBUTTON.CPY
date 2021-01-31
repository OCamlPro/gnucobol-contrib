01 GC18RADIOBUTTON pic x(15) value 'GC18RADIOBUTTON'.
01 RadioButton-Area.
*> ***********************************************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC18RADIOBUTTON.COB - DISPLAY A GROUP OF RADIOBUTTON ITEMS (OPTIONS)
*> Usage:      call GC18RADIOBUTTON using RadioButton-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    2.0. 2021.01.01
*> Changelog:  1.0 first release.
*>             1.1 Rb-Hot from 9(01) to 9(02)
*>             1.2 Rb-wait added
*>             1.3 Rb-Number added
*>             2.0 Mouse management added
*> ***********************************************************************************************************
*> on screen You can manage a group of max 98 RadioButton items (options) each of 1 row .
*> Each RadioButton has tobe inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 0: display box and radiobuttons (none active) just to display initial screen
*>         (fields, radiobuttons, checkboxes...) without wait for user input
*> step 1. re-display a box (not mandatory ) but good to have a better user interface
*> step 2. dre-isplay RadioButton items (options) inside the BOX, one of them is active (hs the focus)
*> wait for user input (cursors keys,spacebar to activate one of the options, enter/escape = exit
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Rb-Act    1= this item is displayed as Active (it has the focus). only one of RadioButton
*>           items can have '1'. it will be highlighted (has the focus) at first display
*>           of RadioButton items. when you exit from the RadioButton function
*>           the active (with focus) RadioButton item will have '1' other items will have blank.
*> Rb-Mark   if = 1 at display this item is displayed as Marked, marked = (*), not marked = ( )
*>           only one RadioButton item can have '1' all others must be = blank
*>           when you exit from RadioButton function the only one marked RadioButton item will have '1'
*>           all other RadioButton items will have blank
*>
*>           warning: For the nature of the radiobuttons if an item is active (focus) it must be also marked.
*>           Then if a certain radiobutton item have Rb-Act = 1, it must have also Rb-Mark = 1.
*>           Although it can be done differently (having an active item and a different item marked),
*>           this is not a good practice and it is not recommended.
*> Rb-Hot    number of char of Rb-Item to be used as hot key
*>           is "Option 1 " and this Rb-Hot = 2, the typing p or P is like acctivate the item
*>           Hot key is case insensistive  (if hotkey is "A" you can type also "a" )
*>           use only letters (lower or uppercase) or digits, no other chars (no +, ?, ! etc.)
*> Rb-r      row & col where the description of RadioButton item starts on screen
*> Rb-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           RadioButton items can be displayed in every position, also sparse.
*>           RadioButton items can  be overlapped
*>           note the brackets and mark char are displayed at column = Rb-c - 4
*>           example   "   (*) RadioButton item    " . "*" is at Rb-r , Rb-c
*> Rb-Item   charatcters string to be displayed as RadioButton text (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Rb-Markchar   single char used to "mark" the single chechbox item. example an "*"  asterisk
*> Rb-Bracket-Char1/2 - Single chars to make active RadioButton more visible example ( ) or [ ]
*> Rb-wait   Y= display radiobutton items and wait for a user action (standard use)
*>           N= display radiobutton items  and returns to caller without wait for a keypress by the user
*>           useful just to display radiobuttos at first full screen display
*>           in that case none of radiobutton is "active"  (has the focus) none has Rn-Act = 1.
*> Rb-Selected  return to caller the number of the Option selected/marked by the user
*>           Caller pgm will know if user selected a RadioButton with enter or mouse or ...
*>           or has pressed Escape key or tAb or ... to exit
*> Rb-Key    key code pressed by user: 0000 = Enter, 2005 = Escape (see GnuCOBOL codes)
*>           Caller pgm will know if user has selected a radiobutton and exit with Cursor or mouse
*>           to confirm the selections or has pressed Enter, TAB, Escape key ... to exit
*>           It is up to the caller to decide how to use radiobuttn selected by the user & returned key
*> Rb-Number  Count how many items are in the Radiobutton panel (= before the low value item)
*>
*> sample schema of radiobuttn items list
*>                  Rb-c(n)
*>                  |
*>                  V
*>       Rb-r(1) ( ) aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  (item description max 76 chars + x'00'
*>       Rb-r(2) ( ) bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
*>       Rb-r(3) ( ) cccccccccccccccccccccccccccccccc
*>       Rb-r(4) (o) dddddddddddddddddddddddddddddddd
*>       Rb-r(5) ( ) eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
*>       Rb-r(6) ( ) ffffffffffffffffffffffffffffffff
*>               1234 <-- Rb-c(n) has to be >= 4
*>
*>       max 99 items,  max 76 chars each one.
*>       Strings have to be in ASCIIZ format = last byte is x'00'(low-value).
*> ***********************************************************************************************************
     03 Rb-Tab  value low-value.
        04 Rb-Ele occurs 99.
           05 Rb-Act          pic x(01).
           05 Rb-Mark         pic x(01).
           05 Rb-Hot          pic 9(02).
           05 Rb-r            pic 9(03).
           05 Rb-c            pic 9(03).
           05 Rb-Item         pic x(81).
     03 Rb-Parameters.
        05 Rb-MarkChar        pic x(01) value 'o'.
        05 Rb-BracketChars.
           07 Rb-BracketChar1 pic x(01) value '('.
           07 Rb-BracketChar2 pic x(01) value ')'.
        *> colors for Normal RadioButton item (non active)
        05 Rb-bcoN            pic 9(01) value green.  *> backcolor  for "normal" RadioButton item
        05 Rb-fcoN            pic 9(01) value black.  *> forecolor  for "normal" RadioButton item
        05 Rb-fcoNH           pic X(01) Value 'N'.    *> foreground for "Normal" RadioButton item in Highlight ?
        *> colors for active (to be selected) RadioButton item
        05 Rb-bcoA            pic 9(01) value green.  *> backcolor for "active" RadioButton item
        05 Rb-fcoA            pic 9(01) value white.  *> forecolor for "active" RadioButton item
        05 Rb-fcoAH           pic X(01) Value 'Y'.    *> forecolor of active RadioButton item in Highlight ?
        *> colors for hot key char of a RadioButton item
        05 Rb-bcoH            pic 9(01) value green.  *> backcolor for "hot key" char
        05 Rb-fcoH            pic 9(01) value yellow. *> forecolor for "hot key" char
        05 Rb-fcoHH           pic X(01) Value 'Y'.    *> foreground hotkey char in Highlight ?
     *> wait= Y normal Radiobutton; wait= N display list of Radiobuttons items and return to caller
     03 Rb-wait               pic x(01) value 'Y'.
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Rb-Selected           pic 9(02) value 0.
     03 Rb-Key                pic 9(04) value 0.
     03 Rb-Number             pic 9(02) value 0.
