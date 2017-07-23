       >> SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. GC21MENU is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY MENU ON SCREEN WITH OPTIONS & EFFECTS, LET CHOOSE AN ITEM
*> Tectonics:  cobc -m GC21MENU.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC21MENU using Menu-Area
*> Parameters: look at GC21MENU.CPY (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.

DATA DIVISION.
WORKING-STORAGE SECTION.
copy 'GC01BOX.CPY'.

01  .
    03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  j            pic 9(02) value 1.
    03  Item-Num     pic 9(02) value 0.  *> count how many menu items
    03  Item-Len     pic 9(02) value 0.
    03  Item-MaxLen  pic 9(02) value 0.
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wCRT-STATUS  PIC 9(04) VALUE 9999.
    03  wcol         PIC 9(03).
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).

01 wInt        BINARY-SHORT SIGNED.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.

78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-ESCAPE      VALUE 2005.

LINKAGE SECTION.
COPY 'GC21MENU.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Menu-Area.

*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

move 1 to i.
*> ***********************************************************************************
*> loop to display MENU ITEMS at right position and display a message at row 25
*> ***********************************************************************************
Main.
 if mn-ele(i) = low-value
    compute Item-Num = i - 1    *> count how many menu items
    go to Main-ex               *> end of items
 end-if

 if Mn-Act(i) = '1'             *> for "active item" display the associated message
    perform DisplayMessage thru DisplayMessageEx
    move i       to Mn-Selected
    Move mn-bcoS to bco         *> active item colors
    move mn-fcoS to fco
    Move mn-fcoSH to fcoH
 else
    Move mn-bcoN to bco
    move mn-fcoN to fco         *> non active item colors
    Move mn-fcoNH to fcoH
 end-if

 perform DisplayItem thru DisplayItemEx

 add  1 to i
 go to Main.                                            *> go to display next menu item

Main-ex.
 *> after displayed all items draw a box around menu items if requested
 if mn-box = 'Y'
   move Mn-Shadow to box-Shadow
   move mn-Style  to box-Style
   move 'N'       to box-fill
   compute box-r1 = mn-r(1) - 1
   compute box-c1 = mn-c(1) - 1
   compute box-r2 = mn-r(Item-Num) + 1
   compute box-c2 = mn-c(1) + Item-MaxLen + 2
   CALL GC01BOX USING BY CONTENT BOX-AREA
 end-if

 perform hide-cursor thru hide-cursor-ex

 exit.

*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field.
 *> With "Auto" will detect if cursor up/down/left/right pressed
 accept wDummy at 2580 with auto size 0 background-color red foreground-color white end-accept

  *> <enter> or <escape> return to caller Mn-Selected
  *> if pressed cursor down or right -> activate next menu item
  *> if pressed cursor up   or left  <- activate previous menu item
  *> move space to mn-Act of item
  *> move '1' to mn-Act of next or previous item
  *> other keys have no effect

 IF wCRT-STATUS = K-ENTER  move K-ENTER  to Mn-Key go Exit-Program end-if
 IF wCRT-STATUS = K-ESCAPE move K-ESCAPE to Mn-Key go Exit-Program end-if

 EVALUATE TRUE

 when wCRT-STATUS = K-RIGHT and (Mn-Arrow = 'H' or ' ')    *> Key dx or down
   or wCRT-STATUS = K-DOWN  and (Mn-Arrow = 'V' or ' ')
    move Mn-Selected to i
    move space       to Mn-Act(Mn-Selected)
    *> display as normal item
    Move Mn-bcoN  to bco
    Move Mn-fcoN  to fco
    Move Mn-fcoNH to fcoH
    perform DisplayItem thru DisplayItemEx

    if   Mn-Selected = Item-Num *> if you were on last item of menu
         move 1 to Mn-Selected i
    else
         add  1 to Mn-Selected i
    end-if
    move '1'   to Mn-Act(Mn-Selected)

    *> display as Active item
    Move Mn-bcoS  to bco
    Move Mn-fcoS  to fco
    Move Mn-fcoSH to fcoH
    perform DisplayItem    thru DisplayItemEx
    perform DisplayMessage thru DisplayMessageEx

 when wCRT-STATUS = K-LEFT and (Mn-Arrow = 'H' or ' ')     *> key sx or up
   or wCRT-STATUS = K-UP   and (Mn-Arrow = 'V' or ' ')
    move Mn-Selected to i
    move space       to Mn-Act(Mn-Selected)
    *> display as normal item
    Move Mn-bcoN to bco
    Move Mn-fcoN to fco
    Move Mn-fcoNH to fcoH

    perform DisplayItem thru DisplayItemEx

    if   Mn-Selected = 1     *> if you were on first item of menu
         move Item-Num to Mn-Selected i
    else
         subtract 1  from Mn-Selected i
    end-if
    move '1'   to Mn-Act(Mn-Selected)

    *> display as Active item
    Move Mn-bcoS  to bco
    Move Mn-fcoS  to fco
    Move Mn-fcoSH to fcoH
    perform DisplayItem    thru DisplayItemEx
    perform DisplayMessage thru DisplayMessageEx

 *> ex. in a drop down menu. Mn-Arrow = V and the user press Key left o Key Right
 *> this program return to caller. Caller program will move to the next drop down menu,
 *> it normally move to the next menu item
 when Mn-Return = 'Y' and (
       (wCRT-STATUS = K-LEFT  and Mn-Arrow = 'V')
    or (wCRT-STATUS = K-RIGHT and Mn-Arrow = 'V')
    or (wCRT-STATUS = K-UP    and Mn-Arrow = 'H')
    or (wCRT-STATUS = K-DOWN  and Mn-Arrow = 'H')
       )
    move wCRT-STATUS to Mn-Key go Exit-Program

 END-EVALUATE

 perform hide-cursor thru hide-cursor-ex

 go to Accept-a-Key.

Exit-Program.
    *> re-show the cursor
    move 2 to wInt
    call static "curs_set" using by value wInt end-call

EXIT PROGRAM.

*> ***********************************************************************************
*> DISPLAY A MENU ITEM
*> ***********************************************************************************
DisplayItem.
 move 0 to j.
DisplayItemLoop.   *> loop to display single characters of a menu item (last char is x'00'.)
 add 1 to j
 if Mn-Item(i) (j:1) = low-value go DisplayItemEx end-if

 *> save max length of menu items. useful for drawing a box around the menu
 compute Item-Len = (mn-c(i) + j - 1) - (mn-c(1) + 1)
 if Item-Len > Item-MaxLen move Item-Len to Item-MaxLen end-if

 compute wcol = mn-c(i) + j - 1 end-compute
 if j = Mn-Hot(i)
    display Mn-Item(i) (j:1) at line mn-r(i) col wcol
            with background-color  bco foreground-color Mn-fcoH highlight end-display
 else
    if fcoH = 'Y' and fco not = black  *> black is not highlighted (it becames grey !)
       display Mn-Item(i) (j:1) at line mn-r(i) col wcol
               with background-color bco foreground-color fco highlight end-display
    else
       display Mn-Item(i) (j:1) at line mn-r(i) col wcol
              with background-color bco foreground-color fco end-display
    end-if
 end-if
 go to DisplayItemLoop.
DisplayItemEx. exit.

*> ***********************************************************************************
*> DISPLAY THE MESSAGE ASSOCIATED TO MENU ITEM
*> ***********************************************************************************
DisplayMessage.
 *> clear row 25 from previous message (next menu item may have "no message" )
 if mn-mess(i) (1:1) = low-value
      display ' ' at line 25 with background-color Mn-bcoN foreground-color Mn-fcoN end-display
    go to DisplayMessageEx end-if

 move 1 to w .
*> loop to display single characters of the message
DisplayMessageLoop.
 if mn-mess(i) (w:1) = low-value or w > 80
    go to DisplayMessageEx
 end-if
 if Mn-fcoMH = 'Y'
    display Mn-Mess(i) (w:1) at line Mn-MessRow col w
            with background-color Mn-bcoM foreground-color Mn-fcoM highlight end-display
 else
    display Mn-Mess(i) (w:1) at line Mn-MessRow col w
            with background-color Mn-bcoM foreground-color Mn-fcoM end-display
 end-if
 add 1 to w
 go to DisplayMessageLoop.
DisplayMessageEx. exit.

hide-cursor.
    *> hide the cursor
    move 0 to wInt
    call static "curs_set" using by value wInt end-call.
hide-cursor-ex. exit.

End Program GC21MENU.
