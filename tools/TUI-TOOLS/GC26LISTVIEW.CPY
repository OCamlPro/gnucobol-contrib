01 GC26LISTVIEW pic x(20) value 'GC26LISTVIEW'.
01 Listview-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC26LISTVIEW.COB (FUNCTION TO BROWSE & PICKUP ELEMENTS)
*> Usage:      call GC26LISTVIEW using Listview-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.0 2018.03.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> You can manage lists with max 999 rows, each one of max 999 cols.
*> Each row has to be inserted in a table of 999 elements,
*> sample list view schema is as following:
*>
*>        c1
*>         |
*>         V              (box title centered)
*>        +-----------------| COST CENTERS |---------------+ <- box
*> r1 --> |CODE      |DESCRIPTION                          | <- list header
*>      1 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- 1st row of list elements
*>      2 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      3 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      4 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      5 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      6 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      7 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      8 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- last row of list elements
*>        +-Enter=Select ESC=Exit PF1=Help--------e001c001-+ <- Commands & crsr pos.(elem/col)
*>         <----------------- Lv-WinNumCols -------------->
*>
*> Each listview item has following fields:
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Lv-r1/c1  row & col where the header of listview items starts on screen
*> Lv-TabNumRows/Cols  Size of the table elements in the list at screen
*> Lv-WinNumRows/Cols  Size of the window at screen in which the list is displayed
*> Lv-RowHeader        header of columns of the list
*> Lv-RowCmd           command diaplayed on the last window ros (the bottom box line)
*>
*> Lv-Row    list items (move here yout list elements (max 999 elemnts in the table)
*> Lv-Selected Number of elemnts in the table selected by the user
*> Lv-Key    ScanCode returned to caller at exit from the program, 0013= Enter, 0027= ESACPE
*> ***********************************************************************************
  03 Lv-Parameters.
    05 Lv-r1c1.                           *> look at previous schema
        07 Lv-r1     pic 9(03) value 005. *> start row of listview items
        07 Lv-c1     pic 9(03) value 008. *> start col of listview items
    *> table size (must be > = than window size)
    05 Lv-TabNumRows pic 9(03) value 099. *> number of rows
    05 Lv-TabNumCols pic 9(03) value 099. *> number of cols
    *> window size (must be < = than table size)
    05 Lv-WinNumRows pic 9(03) value 010. *> number of rows
    05 Lv-WinNumCols pic 9(03) value 040. *> number of cols

    *> Normal row colors
    05 Lv-bcoN       pic 9(01) value white.  *> backcolor for listview items
    05 Lv-fcoN       pic 9(01) value black.  *> forecolor for listview items
    05 Lv-fcoNH      pic X(01) Value 'N'.    *> foreground in Highlight ?
    *> cursor row colors
    05 Lv-bcoS       pic 9(01) value cyan.   *> backcolor for "cursor" listview item
    05 Lv-fcoS       pic 9(01) value yellow. *> forecolor for "cursor" listview item
    05 Lv-fcoSH      pic X(01) Value 'Y'.    *> forecolor of cursors in Highlight ?
    *> header row colors
    05 Lv-bcoH       pic 9(01) value red.    *> backcolor for "header" listview row
    05 Lv-fcoH       pic 9(01) value yellow. *> forecolor for "header" listview row
    05 Lv-fcoHH      pic X(01) Value 'Y'.    *> forecolor of header in Highlight ?

    05 Lv-Box            pic x(01) value 'Y'.          *> Y= display a box around list items
    05 Lv-Box-Parameters.                              *> only used when Lv-Box = Y
        07 Lv-Box-bco     pic 9(01) value white.       *> backcolor of the box
        07 Lv-Box-fco     pic 9(01) value red.         *> forecolor of the box  (the frame)
        07 Lv-Box-fcoH    pic X(01) value "Y".         *> Y = Hilight Foreground (the frame of the box)
        07 Lv-Box-style   pic X(01) value "S".         *> S, D, 1, 2, 3, N, C
        07 Lv-Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
        07 Lv-Box-fill    pic X(01) value "N".         *> Y = filled box
        07 Lv-Box-shadow  pic x(01) value 'N'.         *> Y = box with shadow
        07 Lv-Box-3D      pic x(01) value 'N'.         *> N=no3D, 3Deffect: R=Recessed, E=Embossed/Relief
        07 Lv-Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
        07 Lv-Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
        07 Lv-Box-tit     pic x(01) value 'N'.         *> Y = display a title at top of the box
        07 Lv-Box-titBco  pic 9(01) value white.       *> back color of titlebox
        07 Lv-Box-titFco  pic 9(01) value red.         *> fore color of titlebox
        07 Lv-Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?
        07 Lv-Box-titDes  pic x(80) value space.       *> string 1 to 80 char, used as a box title

  *> ***********************************************************************************
  *> HEADER AND LIST ROWS CONTENT
  *> ***********************************************************************************
  03 Lv-RowHeader pic x(999) value ' LIST OF ELEMENTS                      '.
  03 Lv-RowCmd-SW pic x(001) value 'Y'.          *> Y= display Cmd
  03 Lv-RowCmd    pic x(030) value 'Enter=Select ESC=Exit PF1=Help'.
  03 Lv-Tab       value space.                   *> table with list items
    05 Lv-Ele     occurs 999 indexed by Lv-Idx.
        07 Lv-Row pic x(999).

  *> ***********************************************************************************
  *> FIELDS RETURNED TO CALLER
  *> ***********************************************************************************
  03 Lv-Selected   pic 9(04).  *> number of selected listview item: 01, 02 etc.
  03 Lv-Key        pic 9(03).  *> key code at exit (027 escape, 013 enter)
