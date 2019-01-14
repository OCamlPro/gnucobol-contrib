01 GC55DIREPICKER pic x(20) value 'GC55DIREPICKER'.
01 DirePicker-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC55DIREPICKER.COB (FUNCTION TO BROWSE & PICKUP A DIRECTORY)
*> Usage:      call GC55DIREPICKER using DirePicker-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2018 E.Di Lorenzo - GNU LGPL 3.0 (or greater)
*> Version:    1.0 2018.12.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> You can manage list of directory TREE with max 999 rows, each one of max 999 cols.
*> Each row has to be inserted in a table of 999 elements,
*> sample list view schema is as following:
*>
*>        c1
*>         |
*>         V              (box title centered)
*>        +--------------| DIRECTORY PICKER |--------------+ <- box
*> r1 --> |DATE      |SIZE          NAME                   | <- list header
*>      1 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- 1st row of list elements
*>      2 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      3 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      4 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      5 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      6 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      7 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
*>      8 |1234567890|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx| <- last row of list elements
*>        +-Enter=Select ESC=Exit PF1=Help--------i001c001-+ <- Commands & crsr pos.(elem/col)
*>         <----------------- Lv-WinNumCols -------------->
*>
*> Each listview item has following fields:

*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Dir-r1/c1            row & col where the header of list items starts on screen
*> Dir-TabNumRows/Cols  Size of the table elements in the list at screen
*> Dir-WinNumRows/Cols  Size of the window at screen in which the list is displayed
*> Dir-PtrCursor        "Cursor" position at first call
*> Dir-RowHeader        header of columns of the list
*> Dir-RowCmd           commands displayed on the last window ros (the bottom box line)
*> Dir-PtrCursor        cursor position at first call
*>
*> Dir-Dis              1= this row is displayed but not selectable
*> Dir-Row              list items (move here your list elements (max 999 elemnts in the table)
*> Dir-Path             DirePicker will list TREE from thirs directory (ex C:\AAAAA\BBBBBBBBB)
*>                      DirePicker will list files from C:\ if this field is = space
*> Dir-Selected         Number of element in the table selected by the user
*> Dir-Key              ScanCode returned to caller at program exit, 0013=Enter,0027=ESACPE
*> Dir-DireName         Direcory Name (complete path) selected
*> ***********************************************************************************
  03 Dir-Parameters. *> (SAME FIELDS IN GC26LISTVIEW.CPY)
     05 Dir-r1c1.
        07 Dir-r1     pic 9(03) value 005. *> start row of listview items
        07 Dir-c1     pic 9(03) value 004. *> start col of listview items
    *> table size (must be > = than window size)
     05 Dir-TabNumRows pic 9(03) value 999. *> number of table rows
     05 Dir-TabNumCols pic 9(03) value 256. *> number of table cols
     *> window size (must be < = than table size)
     05 Dir-WinNumRows pic 9(03) value 015. *> number of screen window rows
     05 Dir-WinNumCols pic 9(03) value 040. *> number of screen window cols
     05 Dir-PtrCursor  pic s9999 value 1.   *> "Cursor" row position at first call

     *> Normal row colors
     05 Dir-bcoN       pic 9(01) value white.  *> backcolor for listview items
     05 Dir-fcoN       pic 9(01) value black.  *> forecolor for listview items
     05 Dir-fcoNH      pic X(01) Value 'N'.    *> foreground in Highlight ?
     *> cursor row colors
     05 Dir-bcoS       pic 9(01) value cyan.   *> backcolor for "cursor" listview item
     05 Dir-fcoS       pic 9(01) value yellow. *> forecolor for "cursor" listview item
     05 Dir-fcoSH      pic X(01) Value 'Y'.    *> forecolor of cursors in Highlight ?
     *> header row colors
     05 Dir-bcoH       pic 9(01) value red.    *> backcolor for "header" listview row
     05 Dir-fcoH       pic 9(01) value yellow. *> forecolor for "header" listview row
     05 Dir-fcoHH      pic X(01) Value 'Y'.    *> forecolor of header in Highlight ?

     05 Dir-Beep           pic x(01) value 'Y'.         *> Y= sound if scroll vert/horiz
     05 Dir-Box            pic x(01) value 'Y'.         *> Y= display a box around list items
     05 Dir-Box-Parameters.                             *> only used when Dir-Box = Y
        07 Dir-Box-bco     pic 9(01) value white.       *> backcolor of the box
        07 Dir-Box-fco     pic 9(01) value red.         *> forecolor of the box  (the frame)
        07 Dir-Box-fcoH    pic X(01) value "Y".         *> Y = Hilight Foreground (the frame of the box)
        07 Dir-Box-style   pic X(01) value "S".         *> S, D, 1, 2, 3, N, C
        07 Dir-Box-custom  PIC X(09) VALUE "ABCDEFGHI". *> UL, UC, UR, ML, MC, MR, LL, LC, LR
        07 Dir-Box-fill    pic X(01) value "N".         *> Y = filled box
        07 Dir-Box-shadow  pic x(01) value 'Y'.         *> Y = box with shadow
        07 Dir-Box-3D      pic x(01) value 'N'.         *> N=no3D, 3Deffect: R=Recessed, E=Embossed/Relief
        07 Dir-Box-add1c   pic x(01) value 'N'.         *> enlarge box for a better 3D effect
        07 Dir-Box-beep    pic x(01) value 'N'.         *> Y = ring the bell
        07 Dir-Box-tit     pic x(01) value 'Y'.         *> Y = display a title at top of the box
        07 Dir-Box-titBco  pic 9(01) value white.       *> back color of titlebox
        07 Dir-Box-titFco  pic 9(01) value red.         *> fore color of titlebox
        07 Dir-Box-titFcoH pic X(01) value "Y".         *> hiligth fore color of titlebox ?
        07 Dir-Box-titDes  pic x(80) value ' DIRECTORY PICKER ' & x'00' .  *> string 1 to 80 char, used as a box title

  *> ***********************************************************************************
  *> HEADER AND LIST ROWS CONTENT (SAME FIELDS IN GC26LISTVIEW.CPY)
  *> ***********************************************************************************
  03 Dir-Parameters2.
  *> 05 Dir-RowHeader pic x(999) value 'DATE        TIME               SIZE NAME'.
     05 Dir-RowHeader pic x(999) value 'DIRECTORY TREE (F4=go up; F5/F6=toggle graphic/files'.
                            *>         1234567890123456789012345678901234567890
     05 Dir-RowCmd-SW pic x(001) value 'Y'.          *> Y= display Cmd
     05 Dir-RowCmd    pic x(030) value 'Enter=Select ESC=Exit PF1=Help'.
     05 Dir-Tab2      value space.                   *> table disabled flag
        07 Dir-Ele2    occurs 999 indexed by Dir-Idx2.
           09 Dir-Dis pic x(001).   *> 1= this row is disabled (not selectable)
     05 Dir-Tab       value space.  *> table with list items
        07 Dir-Ele     occurs 999 indexed by Dir-Idx.
           09 Dir-Row pic x(999).

  *> message when a not available/wrong row is selected
  03 Dir-NoSelTxt   value
                    '                                    ' &
                    '                                    ' &
                    ' You can''t select this element !    ' &
                    '                                    ' &
                    '                                    '.
     05 Dir-NoSelTxt-Ele occurs 5 pic x(36).

  *> starting path es C:\AAAAAAA\BBBBBB (& current/returned path on exit smae as DireName)
  03 Dir-Path       pic x(128) value space.

*> ***********************************************************************************
  *> FIELDS RETURNED TO CALLER
  *> ***********************************************************************************
  03 Dir-Selected   pic 9(004).  *> number of selected row on listview item: 01, 02 etc.
  03 Dir-Key        pic 9(003).  *> key code at exit (027 escape, 013 enter)
  03 Dir-DireName   pic X(128).  *> name of selected Directory
