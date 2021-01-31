01 GC15OFFON pic x(12) value 'GC15OFFON'.
01 OFFON-Area.
*> ***********************************************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    WORK-AREA FOR GC15OFFON.COB - MANAGE A GROUP OF OFFON ITEMS (SWITCHES)
*> Usage:      call GC15OFFON using OFFON-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.1 2021.01.15
*> Changelog:  1.0 first release.
*>             1.1 OFF and ON now are variable. Example you can set to NO and YES from caller program
*>                 new fields Oo-OFF-Descr and Oo-ON-Descr
*> ***********************************************************************************************************
*> on screen You can manage a group of max 98 OFFON items each of 1 row (also overlapped).
*> Each OFFON item has to be inserted in a table with 99 elements
*> there has to be a last item in the table, filled with low-value
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Oo-Act    1= this item is displayed as Active,it has the "focus" (tobe OFF/ON chnged)
*>           only one of OFFON items can have '1' . it will be highlighted (has the focus)
*>           at first display of the OFFON items. when you exit from the OFFON function
*>           the active OFFON item will have '1' other items will have blank.
*> Oo-Mark   if= 1 at display,this item is displayed as ON example:  OFF [  X] ON
*>           all items can have '1' or blank
*>           when you exit from OFFON function, OFFON items will have '1' if they are "ON"
*>           other OFFON items will have blank
*> Oo-Hot    number of charachter of Oo-Item string to be used as hotkey, ex.if Oo-Item is " Option 1 "
*>           and Oo-Hot = 3, then the typing p or P is like activate the item with cursor keys
*>           Hot keys are case insensistive  (if a hotkey is "p" you can also type a "P" )
*>           You can use only letters or digits, no other chars allowed (no +, ?, ! etc.)
*> Oo-r      row & col where the description of first OFFON item starts on screen
*> Oo-c      first row & col of the screen are 01, 01, last are 25,80 (row 25 col 80)
*>           OFFON items can be displayed in every position, also sparse or overlapped
*>           note the brackets and mark char are displayed at column = Oo-c + 12
*>           example   "Description........ OFF [X  ] ON" . the "D" is at Oo-r , Oo-c position
*> Oo-c-OFFON column where the OFF / ON part (= the "O" of OFF starts  (the 1st char of Oo-OFF-Descr
*> Oo-Item   charatcters string to be displayed as OFFON text (max 80 - 12 = 68 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Oo-Markchar   single char used to "mark" the single OFFON item. example an "X" or an "O"
*> Oo-Bracket-Char1/2 - 2 Single chars , example [ ] or ( ) or < >
*> Oo-wait   Y= display OFFON items and wait for a user action (normal use)
*>           N= display OFFON items  and returns to caller without waiting for a keypress by the user
*>           useful to just display the OFFON list at first ful screen display
*> Oo-OFF-Descr Description used on screen for OFF switch. Default = OFF
*> Oo-ON-Descr the Description used on screen for ON switch. Default = ON
*> Oo-Selected  return to caller the number (in the table) of the OFFON item "active" at exit
*> Oo-Key    key code pressed by user: 0000 = Enter, 2005 = Escape (see GnuCOBOL codes)
*>           Caller pgm will know if user selected some OFFON items and exit with TAB, ESC ...
*>           to confirm the selections or has pressed Escape key to exit
*>           It is up to the caller to decide how to use switches selected by the user & returned key
*> Oo-Number  Count how many items are in the OFFON panel (= before the low value item)
*>
*> sample schema of OFFON items list
*>
*>            Oo-c(n)                    Oo-c-OFFON(n)
*>            |                          |
*>            V                          V
*>    Oo-r(1)  Stop after first error... OFF [X  ] ON       (item description max 68 chars + x'00'
*>    Oo-r(2)  Allow LABEL and GOTO..... OFF [X  ] ON
*>    Oo-r(3)  Enable macros............ OFF [  X] ON
*>    Oo-r(4)  Allow inline............. OFF [X  ] ON
*>    Oo-r(5)  Include assertion code... OFF [  X] ON
*>    Oo-r(6)  Load compatible units.... OFF [  X] ON
*>    Oo-r(7)  Allow STATIC in objects.. OFF [  X] ON
*>    Oo-r(8)  C like operators......... OFF [X  ] ON
*>    Oo-r(9)  Conditional defines...... OFF [  X] ON
*>
*>            |<---- 68 chars max ----->|123456789012
*>
*>       max 99 items,  max 76 chars each one.
*>       Strings have to be in ASCIIZ format = last byte is x'00'(low-value).
*> ***********************************************************************************************************
     03 Oo-Tab  value low-value.
        04 Oo-Ele occurs 99.
           05 Oo-Act          pic x(01).
           05 Oo-Mark         pic x(01).
           05 Oo-Hot          pic 9(02).
           05 Oo-r            pic 9(03).
           05 Oo-c            pic 9(03).
           05 Oo-c-OFFON      pic 9(03).
           05 Oo-Item         pic x(81).
     03 Oo-Parameters.
        05 Oo-MarkChar        pic x(01) value 'X'.
        05 Oo-BracketChars.
           07 Oo-BracketChar1 pic x(01) value '['.
           07 Oo-BracketChar2 pic x(01) value ']'.
        *> colors for non active (Normal) OFFON item
        05 Oo-BcoN            pic 9(01) value green.  *> backcolor for "normal" OFFON item
        05 Oo-FcoN            pic 9(01) value black.  *> forecolor for "normal" OFFON item
        05 Oo-FcoNH           pic X(01) Value 'N'.    *> foreground for Normal OFFON item in Highlight ?
        *> colors for active (selected) OFFON item
        05 Oo-BcoA            pic 9(01) value green.  *> backcolor for "active" OFFON item
        05 Oo-FcoA            pic 9(01) value white.  *> forecolor for "active" OFFON item
        05 Oo-FcoAH           pic X(01) Value 'Y'.    *> forecolor of active OFFON item in Highlight ?
        *> colors for hot-key char of a OFFON item
        05 Oo-BcoH            pic 9(01) value green.  *> backcolor for "hot key" char
        05 Oo-FcoH            pic 9(01) value yellow. *> forecolor for "hot key" char
        05 Oo-FcoHH           pic X(01) Value 'Y'.    *> foreground hotkey char in Highlight ?
     *> wait: 'Y' normal OFFON wait, N = just display list of OFFON items and return to caller
     03 Oo-wait               pic x(01) value 'Y'.
     03 Oo-OFF-Descr          pic x(04) value 'OFF '.
     03 Oo-ON-Descr           pic x(04) value ' ON '.
     *> *************************************************************
     *> RETURNS TO CALLER
     *> *************************************************************
     03 Oo-Selected           pic 9(02) value 0.
     03 Oo-Key                pic 9(04) value 0.
     03 Oo-Number             pic 9(02) value 0.
