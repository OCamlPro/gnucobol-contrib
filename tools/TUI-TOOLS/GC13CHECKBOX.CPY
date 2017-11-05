01 GC13CHECKBOX pic x(12) value 'GC13CHECKBOX'.
01 CHECKBOX-Area.
*> ***********************************************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC13CHECKBOX.COB - DISPLAY A GROUP OF CHECKBOX ITEMS (SWITCHES)
*> Usage:      call GC13CHECKBOX using CHECKBOX-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.1 2017.11.04
*> Changelog:  1.0 first release.
*>             1.1 ck-Hot changed from 9(01) to 9(02)
*> ***********************************************************************************************************
*> on screen You can manage a group of max 98 CHECKBOX items each of 1 row .
*> Each checkbox item has tobe inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but good to have a better user interface
*> step 2. display a group of CHECKBOX items (switches) inside the BOX
*> wait for user input (cursors keys,spacebar to mark/unmark, enter or escape to exit
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Ck-Act    1= this item is displayed as Active , it has the "focus" (tobe Marked / unmarked with spacebar)
*>           only one of checkbox items can have '1' . it will be highlighted (has the focus)
*>           at first display of the checkbox items. when you exit from the checkbox function
*>           the active checkbox item will have '1' other items will have blank.
*> Ck-Mark   if = 1 at display this item is displayed as Marked ( marked = [X], not marked = [ ] )
*>           all items can have '1' or blank
*>           when you exit from checkbox function marked checkbox items will have '1'
*>           other checkbox items will have blank
*> Ck-Hot    number of char of Ck-Item to be used as hot key
*>           is "Option 1 " and this Ck-Hot = 2, the typing p or P is like acctivate the item
*>           Hot key is case insensistive  (if hotkey is "A" you can type also "a" )
*>           use only letters (lower or uppercase) or digits, no other chars (no +, ?, ! etc.)
*> Ck-r      row & col where the description of checkbox item starts on screen
*> Ck-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           CHECKBOX items can be displayed in every position, also sparse.
*>           CHECKBOX items can  be overlapped
*>           note the brackets and mark char are displayed at column = Ck-c - 4
*>           example   "   [x] checkbox item    " . "c" is at Ck-r , Ck-c
*> Ck-Item   charatcters string to be displayed as checkbox text (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Ck-Markchar   single char used to "mark" the single chechbox item. example an "X"
*> Ck-Bracket-Char1/2 - Single chars to make active checkbox more visible example [ ] or ( )
*>
*> Ck-Selected  return to caller the number (in the table) of the checkbox item "active" at exit
*> Ck-Key    key code pressed by user: 0013 = Enter, 0027 = Escape
*>           Caller pgm will know if user selected checkbox items and exit with enter
*>           to confirm the selections or has pressed Escape key to exit
*>           it is up to the caller to decide how to use the returned option selected by the user
*> ***********************************************************************************************************
     03 Ck-Tab  value low-value.
        04 Ck-Ele occurs 99.
           05 Ck-Act          pic x(01).
           05 Ck-Mark         pic x(01).
           05 Ck-Hot          pic 9(02).
           05 Ck-r            pic 9(03).
           05 Ck-c            pic 9(03).
           05 Ck-Item         pic x(81).
     03 Ck-Parameters.
        05 Ck-MarkChar        pic x(01) value 'X'.
        05 Ck-BracketChars.
           07 Ck-BracketChar1 pic x(01) value '['.
           07 Ck-BracketChar2 pic x(01) value ']'.
        *> colors for Normal checkbox item (non active)
        05 Ck-bcoN            pic 9(01) value green.  *> backcolor for "normal" checkbox item
        05 Ck-fcoN            pic 9(01) value black.  *> forecolor for "normal" checkbox item
        05 Ck-fcoNH           pic X(01) Value 'N'.    *> foreground for Normal checkbox item in Highlight ?
        *> colors for active (to be selected) checkbox item
        05 Ck-bcoA            pic 9(01) value green.  *> backcolor for "active" checkbox item
        05 Ck-fcoA            pic 9(01) value white.  *> forecolor for "active" checkbox item
        05 Ck-fcoAH           pic X(01) Value 'Y'.    *> forecolor of active checkbox item in Highlight ?
        *> colors for hot key char of a checkbox item (not yet available)
        05 Ck-bcoH            pic 9(01) value green.  *> backcolor for "hot key" char
        05 Ck-fcoH            pic 9(01) value yellow. *> forecolor for "hot key" char
        05 Ck-fcoHH           pic X(01) Value 'Y'.    *> foreground hotkey char in Highlight ?
        *> back color of shadow background (it has tobe settled to the same of box background)
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Ck-Selected           pic 9(02).
     03 Ck-Key                pic 9(04).
