01 GC54FILEPICKER pic x(20) value 'GC54FILEPICKER'.
01 FilePicker-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC54FILEPICKER.COB (FUNCTION TO BROWSE & PICKUP A FILE)
*> Usage:      call GC54FILEPICKER using FilePicker-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.0 2018.12.12
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
*> Fip-r1/c1            row & col where the header of list items starts on screen
*> Fip-TabNumRows/Cols  Size of the table elements in the list at screen
*> Fip-WinNumRows/Cols  Size of the window at screen in which the list is displayed
*> Fip-RowHeader        header of columns of the list
*> Fip-RowCmd           command diaplayed on the last window ros (the bottom box line)
*>
*> Fip-Dis              1 = this row is displayed but not selectable
*> Fip-Row              list items (move here your list elements (max 999 elemnts in the table)
*> Fip-Selected         Number of element in the table selected by the user
*> Fip-Key              ScanCode returned to caller at exit from the program, 0013= Enter, 0027= ESACPE
*> ***********************************************************************************
  03 Fip-Parameters.
    05 Fip-r1c1.                           *> look at previous schema
        07 Fip-r1     pic 9(03) value 005. *> start row of listview items
        07 Fip-c1     pic 9(03) value 008. *> start col of listview items
    *> table size (must be > = than window size)
    05 Fip-TabNumRows pic 9(03) value 099. *> number of rows
    05 Fip-TabNumCols pic 9(03) value 099. *> number of cols
    *> window size (must be < = than table size)
    05 Fip-WinNumRows pic 9(03) value 010. *> number of rows
    05 Fip-WinNumCols pic 9(03) value 040. *> number of cols

    *> Normal row colors
    05 Fip-bcoN       pic 9(01) value white.  *> backcolor for listview items
    05 Fip-fcoN       pic 9(01) value black.  *> forecolor for listview items
    05 Fip-fcoNH      pic X(01) Value 'N'.    *> foreground in Highlight ?
    *> cursor row colors
    05 Fip-bcoS       pic 9(01) value cyan.   *> backcolor for "cursor" listview item
    05 Fip-fcoS       pic 9(01) value yellow. *> forecolor for "cursor" listview item
    05 Fip-fcoSH      pic X(01) Value 'Y'.    *> forecolor of cursors in Highlight ?
    *> header row colors
    05 Fip-bcoH       pic 9(01) value red.    *> backcolor for "header" listview row
    05 Fip-fcoH       pic 9(01) value yellow. *> forecolor for "header" listview row
    05 Fip-fcoHH      pic X(01) Value 'Y'.    *> forecolor of header in Highlight ?

    05 Fip-Beep           pic x(01) value 'Y'.          *> Y= sound if scroll vert/horiz
    05 Fip-Box            pic x(01) value 'Y'.          *> Y= display a box around list items
    05 Fip-Box-Parameters.                              *> only used when Fip-Box = Y
        07 Fip-Box-bco     pic 9(01) value white.       *> backcolor of the box
        07 Fip-Box-fco     pic 9(01) value red.         *> forecolor of the box  (the frame)
        07 Fip-Box-fcoH    pic X(01) value "Y".         *> Y = Hilight Foreground (the frame of the box)
        07 Fip-Box-style   pic X(01) value "S".         *> S, D, 1, 2, 3, N, C
        07 Fip-Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
        07 Fip-Box-fill    pic X(01) value "N".         *> Y = filled box
        07 Fip-Box-shadow  pic x(01) value 'Y'.         *> Y = box with shadow
        07 Fip-Box-3D      pic x(01) value 'N'.         *> N=no3D, 3Deffect: R=Recessed, E=Embossed/Relief
        07 Fip-Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
        07 Fip-Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
        07 Fip-Box-tit     pic x(01) value 'Y'.         *> Y = display a title at top of the box
        07 Fip-Box-titBco  pic 9(01) value white.       *> back color of titlebox
        07 Fip-Box-titFco  pic 9(01) value red.         *> fore color of titlebox
        07 Fip-Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?
        07 Fip-Box-titDes  pic x(80) value ' FILE PICKER ' & x'00' .  *> string 1 to 80 char, used as a box title

  *> ***********************************************************************************
  *> HEADER AND LIST ROWS CONTENT
  *> ***********************************************************************************
  03 Fip-Parameters2.
    05 Fip-RowHeader pic x(999) value 'DATE        TIME               SIZE NAME'.
                            *>         1234567890123456789012345678901234567890
    05 Fip-RowCmd-SW pic x(001) value 'Y'.          *> Y= display Cmd
    05 Fip-RowCmd    pic x(030) value 'Enter=Select ESC=Exit PF1=Help'.
    05 Fip-Tab2      value space.                   *> table disabled flag
      07 Fip-Ele2    occurs 999 indexed by Fip-Idx2.
          09 Fip-Dis pic x(001).  *> 1= this row is disabled (not selectable)
    05 Fip-Tab       value space.                   *> table with list items
      07 Fip-Ele     occurs 999 indexed by Fip-Idx.
          09 Fip-Row pic x(999).

  *> ***********************************************************************************
  *> FIELDS RETURNED TO CALLER
  *> ***********************************************************************************
  03 Fip-Selected   pic 9(004).  *> number of selected listview item: 01, 02 etc.
  03 Fip-Key        pic 9(003).  *> key code at exit (027 escape, 013 enter)
  03 Fip-FileName   pic X(128).  *> name of selected file
