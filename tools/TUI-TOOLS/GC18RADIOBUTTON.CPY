<<<<<<< .mine
01 GC18RADIOBUTTON pic x(15) value 'GC18RADIOBUTTON'.
01 RadioButton-Area.
*> ***********************************************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC18RADIOBUTTON.COB - DISPLAY A GROUP OF RADIOBUTTON ITEMS (OPTIONS)
*> Usage:      call GC18RADIOBUTTON using RadioButton-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.10
*> Changelog:  1.0 first release.
*> ***********************************************************************************************************
*> on screen You can manage a group of max 98 RadioButton items (options) each of 1 row .
*> Each RadioButton has tobe inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but good to have a better user interface
*> step 2. display RadioButton items (options) inside the BOX
*> wait for user input (cursors keys,spacebar to activate one of the options, enter/escape = exit
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Rb-Act    1= this item is displayed as Active (it has the focus)
*>           only one of RadioButton items can have '1'. it will be highlighted (has the focus)
*>           at first display of the RadioButton items. when you exit from the RadioButton function
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
*>
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
*>
*> Rb-Selected  return to caller the number of the Option selected/marked by the user
*>           Caller pgm will know if user selected a RadioButton with enter
*>           or has pressed Escape key to exit whitout selection
*> Rb-Key    key code pressed by user: 0013 = Enter, 0027 = Escape
*>           Caller pgm will know if user has selected radiobutton items and exit with enter
*>           to confirm the selections or has pressed Escape key to exit
*>           it is up to the caller to decide how to use the returned selection of switches
*> ***********************************************************************************************************
     03 Rb-Tab  value low-value.
        04 Rb-Ele occurs 99.
           05 Rb-Act          pic x(01).
           05 Rb-Mark         pic x(01).
           05 Rb-Hot          pic 9(01).
           05 Rb-r            pic 9(03).
           05 Rb-c            pic 9(03).
           05 Rb-Item         pic x(81).
     03 Rb-Parameters.
        05 Rb-MarkChar        pic x(01) value '*'.
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
        *> colors for hot key char of a RadioButton item (not yet available)
        05 Rb-bcoH            pic 9(01) value green.  *> backcolor for "hot key" char
        05 Rb-fcoH            pic 9(01) value yellow. *> forecolor for "hot key" char
        05 Rb-fcoHH           pic X(01) Value 'Y'.    *> foreground hotkey char in Highlight ?
        *> back color of shadow background (it has tobe settled to the same of box background)
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Rb-Selected           pic 9(02).
     03 Rb-Key                pic 9(04).
||||||| .r0
=======
01 GC18RADIOBUTTON pic x(15) value 'GC18RADIOBUTTON'.
01 RadioButton-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC18RADIOBUTTON.COB - DISPLAY RADIOBUTTON ITEMS
*> Usage:      call GC18RADIOBUTTON using RadioButton-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.10
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> on screen You can manage max 98 RadioButton items each of 1 row .
*> Each RadioButton has tobe inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but good to have a better user interface
*> step 2. display RadioButton items inside the BOX
*> wait for user input (cursors keys,spacebar to mark/unmark, enter or escape to exit
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Rb-Act    1= this item is displayed as Active or "with focus" (tobe Marked / unmarked with spacebar)
*>           only one of RadioButton items can have '1' . it will be highlighted (has the focus)
*>           at first display of the RadioButton items. when you exit from the RadioButton function
*>           the active (with focus) RadioButton item will have '1' other items will have blank.
*> Rb-Mark   if = 1 at display this item is displayed as Marked, marked = (*), not marked = ( )
*>           only one RadioButton item can have '1' all others must be = blank
*>           when you exit from RadioButton function the only one marked RadioButton item will have '1'
*>           all other RadioButton items will have blank
*> Rb-Hot    number of char to be used as hot key (the letter key or corresponding Alt-Key) . ex. if item
*>           is "Option 1 " and this Rb-Hot = 2, the typing p or P or ALT-P is like acctivate the item
*>           !!! NOT YET AVAILABLE !!!
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
*>
*> Rb-Key    key code pressed by user: 0013 = Enter, 0027 = Escape
*>           Caller pgm will know if user selected a RadioButton with enter
*>           or has pressed Escape key to exit whitout selection
*> *************************************************************
     03 Rb-Tab  value low-value.
        04 Rb-Ele occurs 99.
           05 Rb-Act          pic x(01).
           05 Rb-Mark         pic x(01).
           05 Rb-Hot          pic 9(01).
           05 Rb-r            pic 9(03).
           05 Rb-c            pic 9(03).
           05 Rb-Item         pic x(81).
     03 Rb-Parameters.
        05 Rb-MarkChar        pic x(01) value '*'.
        05 Rb-BracketChars.
           07 Rb-BracketChar1 pic x(01) value '('.
           07 Rb-BracketChar2 pic x(01) value ')'.
        *> colors for Normal RadioButton item (non active)
        05 Rb-bcoN           pic 9(01) value green.  *> backcolor  for "normal" RadioButton item
        05 Rb-fcoN           pic 9(01) value black.  *> forecolor  for "normal" RadioButton item
        05 Rb-fcoNH          pic X(01) Value 'N'.    *> foreground for "Normal" RadioButton item in Highlight ?
        *> colors for active (to be selected) RadioButton item
        05 Rb-bcoA           pic 9(01) value green.  *> backcolor for "active" RadioButton item
        05 Rb-fcoA           pic 9(01) value white.  *> forecolor for "active" RadioButton item
        05 Rb-fcoAH          pic X(01) Value 'Y'.    *> forecolor of active RadioButton item in Highlight ?
        *> colors for hot key char of a RadioButton item (not yet available)
        05 Rb-bcoH           pic 9(01) value green.  *> backcolor for "hot key" char
        05 Rb-fcoH           pic 9(01) value yellow. *> forecolor for "hot key" char
        05 Rb-fcoHH          pic X(01) Value 'Y'.    *> foreground hotkey char in Highlight ?
        *> back color of shadow background (it has tobe settled to the same of box background)
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Rb-Selected       pic 9(02).
     03 Rb-Key            pic 9(04).
>>>>>>> .r496
