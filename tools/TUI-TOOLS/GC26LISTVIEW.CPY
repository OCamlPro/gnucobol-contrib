01 GC26LISTVIEW pic x(20) value 'GC26LISTVIEW'.
01 Listview-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC26LISTVIEW.COB (BROWSE A LIST & PICKUP ELEMENTS)
*> Usage:      call GC26LISTVIEW using Listview-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2021 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    2.0 2021.02.02
*> Changelog:  1.0 first release.
*>             1.1 Lv-Beep added
*>             1.2 Lv-Dis added
*>             1.3 Lv-NoSelTxt added  (message "item non available" now is not fixed)
*>                 Lv-PtrCursorWin added (cursor window row position at first call)
*>             2.0 mouse management, Lv-Key from 9(3) to 9(4) for GnuCOBOL code
*>                 Bco & Fco from 9(01) to 9(02) to support color codes from 08 to 15
*>                 Lv-GoFirst/Last to manage yes/no wrapping at top or bottom List
*>
*> ***********************************************************************************
*> You can manage lists with max 999 rows, each one of max 999 cols.
*> Each row must be inserted in a table of 999 elements,
*> sample Listview schema is as following:
*>
*>        c1
*>         |
*>         V              (box title centered)
*>        +-F1=Help---------| COST CENTERS |------i001c001-+ <- Commands & crsr pos.(elem/col)
*> r1 --> |CODE       DESCRIPTION                          | <- listview header
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- 1st row of window list elements
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>        |1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- last row of window list elements
*>        +------------------------------------------------+ <- box (if requested)
*>
*>         <----------------- Lv-WinNumCols -------------->  <- Listview window size
*>
*> Each listview item has following fields:
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Lv-r1/c1  row & col where the "header" row of listview starts on screen. at least 002002
*> Lv-TabNumRows/Cols  Size of the table with the items list
*>                     the table size must be >= than the window size
*> Lv-WinNumRows/Cols  Size of the window at screen in which the item list is displayed
*>                     the window size must be <= than the table size
*>                     If screen sze is 25x80 the max window list is 22x78
*>                     22 = 25 - 2 rows for the box frame - 1 row for the list header
*>                     78 = 80 - 2 rows for the box frame
*> Lv-PtrCursor        "cursor" position (row) at first display
*> Lv-bco/fco          from 00 to 07... you can also use color codes from 08 to 15
*> Lv-RowHeader        header of columns of the item list
*> Lv-RowCmd           command displayed on the last window row (the bottom box frame line)
*>
*> Lv-Dis      1 = this row is displayed but not selectable by the user (Disabled)
*> Lv-Row      list items (put here your list elements (max 999 elemnts in the table)
*> Lv-Selected Number of the item in the table that has been selected by the user
*> Lv-Key      GnuCOBOL key code returned to caller at exit from the program,
*> ***********************************************************************************
  03 Lv-Parameters.
     05 Lv-r1c1.                                *> look at previous schema
        07 Lv-r1     pic 9(03) value 002.       *> start screen row of listview items
        07 Lv-c1     pic 9(03) value 002.       *> start screen col of listview items
     05 Lv-TabWin-RowCol.
        *> Table size (must be >= than window size)
        07 Lv-TabNumRows pic 9(03) value 099.   *> number of rows
        07 Lv-TabNumCols pic 9(03) value 099.   *> number of cols
        *> Window size (must be <= than table size)
        07 Lv-WinNumRows pic 9(03) value 010.   *> number of rows in the list of items
        07 Lv-WinNumCols pic 9(03) value 040.   *> number of cols in the list
     05 Lv-PtrCursorWin  pic s9999 value 1.     *> "Cursor" position on the window at List display
                                                *> the position of cursor will be at this window line
                                                *> the value must be from 1 to WinNumRows
     05 Lv-PtrCursorTab  pic s9999 value 1.     *> the item of the table to be displayed at first window line
                                                *> must be from 1 to TabNumRows
     05 Lv-GoLast         pic x(01) value 'N'.  *> Y= cursor up at first item, go to last item
     05 Lv-GoFirst        pic x(01) value 'N'.  *> Y= cursor down at last item, go to first item
     05 Lv-Beep           pic x(01) value 'N'.  *> Y= sound if scroll vert/horiz
     *> Normal row colors
     05 Lv-bcoN       pic 9(02) value White.    *> backcolor for listview items
     05 Lv-fcoN       pic 9(02) value Black.    *> forecolor for listview items
     05 Lv-fcoNH      pic X(01) Value 'N'.      *> foreground in Highlight ? (deprecated)
     *> Cursor row colors
     05 Lv-bcoS       pic 9(02) value Cyan.            *> backcolor for "cursor" listview item
     05 Lv-fcoS       pic 9(02) value LightYellow.     *> forecolor for "cursor" listview item
     05 Lv-fcoSH      pic X(01) Value 'Y'.             *> forecolor of cursors in Highlight ? (deprecated)
     *> Header row colors
     05 Lv-bcoH       pic 9(02) value Red.             *> backcolor for "header" listview row
     05 Lv-fcoH       pic 9(02) value LightYellow.     *> forecolor for "header" listview row
     05 Lv-fcoHH      pic X(01) Value 'Y'.             *> forecolor of header in Highlight ? (deprecated)
     05 Lv-Box            pic x(01) value 'Y'.         *> Y= display a box around list items
     05 Lv-Box-Parameters.                             *> only used when Lv-Box = Y
        07 Lv-Box-bco     pic 9(02) value White.       *> backcolor of the box
        07 Lv-Box-fco     pic 9(02) value Black.       *> forecolor of the box  (the frame)
        07 Lv-Box-fcoH    pic X(01) value "Y".         *> Y = Hilight Foreground (the frame (deprecated)
        07 Lv-Box-style   pic X(01) value "S".         *> S, D, 1, 2, 3, N, C
        07 Lv-Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
        07 Lv-Box-fill    pic X(01) value "N".         *> Y = filled box
        07 Lv-Box-shadow  pic x(01) value 'N'.         *> Y = box with shadow
        07 Lv-Box-3D      pic x(01) value 'N'.         *> N=no3D, 3Deffect: R=Recessed, E=Embossed/Relief
        07 Lv-Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
        07 Lv-Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
        07 Lv-Box-tit     pic x(01) value 'N'.         *> Y = display a title at top of the box
        07 Lv-Box-titBco  pic 9(02) value White.       *> back color of titlebox
        07 Lv-Box-titFco  pic 9(02) value Red.         *> fore color of titlebox
        07 Lv-Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?(deprecated)
        07 Lv-Box-titDes  pic x(80) value space.       *> string 1 to 80 char, used as a box title
  *> ***********************************************************************************
  *> HEADER AND LIST ROWS CONTENT
  *> ***********************************************************************************
  03 Lv-Parameters2.
     05 Lv-RowHeader    pic x(999) value 'LIST OF ELEMENTS                      '.
     05 Lv-ItemCount-Sw pic x(001) value 'Y'.          *> Switch. Y= display the item/row count
     05 Lv-RowCmd-Sw    pic x(001) value 'Y'.          *> Switch. Y= display the following Command string
     05 Lv-RowCmd       pic x(007) value 'F1=Help'.    *> the command string to be displayed
     05 Lv-Tab2         value space.                   *> table with disabled items flag
        07 Lv-Ele2      occurs 999 indexed by Lv-Idx2.
           09 Lv-Dis    pic x(001).                    *> 1= this row is disabled (not selectable)
     05 Lv-Tab          value space.                   *> table with items list
        07 Lv-Ele       occurs 999 indexed by Lv-Idx.
           09 Lv-Row    pic x(999).
  03 Lv-NoSelTxt      value
                    '                                    ' &
                    '                                    ' &
                    ' This item cannot be selected !     ' &
                    '                                    ' &
                    '                                    '.
     05 Lv-NoSelTxt-Ele occurs 5 pic x(36).

   *> ***********************************************************************************
   *> RETURNED FIELDS TO CALLER
   *> ***********************************************************************************
   03 Lv-Selected   pic 9(04).  *> number of selected listview item: 0001, 0002 etc.
   03 Lv-Key        pic 9(04).  *> GnuCOBOL key code at exit
