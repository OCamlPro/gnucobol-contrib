01 GC13CHECKBOX pic x(12) value 'GC13CHECKBOX'.
01 CHECKBOX-Area.
*> ***********************************************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC13CHECKBOX.COB - MANAGE A GROUP OF CHECKBOX ITEMS (SWITCHES)
*> Usage:      call GC13CHECKBOX using CHECKBOX-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    2.0 2020.12.12
*> Changelog:  1.0 first release.
*>             1.1 ck-Hot changed from 9(01) to 9(02)
*>             1.2 Ck-wait added
*>             1.3 Ck-Number added
*>             2.0 Mouse management added
*> ***********************************************************************************************************
*> on screen You can manage a group of max 98 CHECKBOX items each of 1 row (also overlapped).
*> Each checkbox item has to be inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Ck-Act    1= this item is displayed as Active,it has the "focus" (tobe marked/unmarked with spacebar)
*>           only one of checkbox items can have '1' . it will be highlighted (has the focus)
*>           at first display of the checkbox items. when you exit from the checkbox function
*>           the active checkbox item will have '1' other items will have blank.
*> Ck-Mark   if= 1 at display,this item is displayed as Checked (Checked= [X], not Checked= [ ] )
*>           all items can have '1' or blank
*>           when you exit from checkbox function, Checked checkbox items will have '1'
*>           other checkbox items will have blank
*> Ck-Hot    number of charachter of Ck-Item to be used as hot key, ex. if Ck-Item is " Option 1 "
 *>          and this Ck-Hot = 3, then the typing p or P is like activate the item with cursor keys
*>           Hot key is case insensistive  (if hotkey is "p" you can also type a "P" )
*>           use only letters or digits, no other chars allowed (no +, ?, ! etc.)
*> Ck-r      row & col where the description of checkbox item starts on screen
*> Ck-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           CHECKBOX items can be displayed in every position, also sparse or overlapped
*>           note the brackets and mark char are displayed at column = Ck-c - 4
*>           example   " [x] Description   " . the "D" is at Ck-r , Ck-c position
*> Ck-Item   charatcters string to be displayed as checkbox text (max 76 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Ck-Markchar   single char used to "mark" the single chechbox item. example an "X" or an "o"
*> Ck-Bracket-Char1/2 - Single chars to make active checkbox more visible example [ ] or ( ) or < >
*> Ck-wait   Y= display checkbox items and wait for a user action (normal use)
*>           N= display checkbox items  and returns to caller without waiting for a keypress by the user
*>           useful to just display the checkbox list at first ful screen display
*> Ck-Selected  return to caller the number (in the table) of the checkbox item "active" at exit
*> Ck-Key    key code pressed by user: 0000 = Enter, 2005 = Escape (see GnuCOBOL codes)
*>           Caller pgm will know if user selected some checkbox items and exit with TAB, ESC ...
*>           to confirm the selections or has pressed Escape key to exit
*>           It is up to the caller to decide how to use switches selected by the user & returned key
*> Ck-Number  Count how many items are in the Checkbox panel (= before the low value item)
*>
*> sample schema of checkbox items list
*>                  Ck-c(n)
*>                  |
*>                  V
*>       Ck-r(1) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  (item description max 76 chars + x'00'
*>       Ck-r(2) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*>       Ch-r(3) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*>       Ck-r(4) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*>       Ck-r(5) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*>       Ck-r(6) [X] xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*>               1234 <-- Ck-c(n) has to be >= 4
*>
*>       max 99 items,  max 76 chars each one.
*>       Strings have to be in ASCIIZ format = last byte is x'00'(low-value).
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
        *> wait: 'Y' normal checkbox wait, N = just display list of checkbox items and exit
        05 Ck-wait            pic x(01) value 'Y'.
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Ck-Selected           pic 9(02) value 0.
     03 Ck-Key                pic 9(04) value 0.
     03 Ck-Number             pic 9(02) value 0.
