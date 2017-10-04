       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC22MENU is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY MENU ON SCREEN WITH OPTIONS & EFFECTS, LET THE USER CHOOSE AN ITEM
*>             SAME AS GC21MENU.COB + HOT KEYS MANAGEMENT (use call getch instead of accept omitted)
*> Tectonics:  cobc -m GC22MENU.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC22MENU using Menu-Area
*> Parameters: look at GC22MENU.CPY (use with copy Version: 1.0 2017.07.20
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.20
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

DATA DIVISION.
WORKING-STORAGE SECTION.

01  wFields.
    03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  k            pic 9(02) value 1.
    03  j            pic 9(02) value 1.

    03  Item-Num     pic 9(02) value 0.  *> count how many menu items
    03  Item-Len     pic 9(02) value 0.
    03  Item-MaxLen  pic 9(02) value 0.

    03  wcol         PIC 9(03).
    03  wChar        PIC X(01).
    03  wNum         PIC X(01).

    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).

01  wVisibilityNot   BINARY-SHORT  value 0.  *> 0 = hide cursor
01  wVisibilityYes   BINARY-SHORT  value 2.  *> 2 = cursor visible full
01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

01 wInt        BINARY-SHORT SIGNED.
01 wChars.
   03  wChars1 pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
   03  wChars-Ele redefines wChars1 pic x(01) occurs 26 indexed by wChars-Idx.
01 wNums.
   03  wNums1 pic x(26) value '0123456789'.
   03  wNums-Ele redefines wNums1 pic x(01) occurs 10 indexed by wNums-Idx.


01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01 Key-lc-Idx9  PIC 9(4) value zero.

copy 'GC01BOX.CPY'.
COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
COPY 'GC22MENU.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Menu-Area.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  perform CursorHide thru CursorHideEx

  *> i = the number of menu item
  move 1 to i.
*> ***********************************************************************************
*> loop to display MENU ITEMS at right position and display a message at row 25
*> ***********************************************************************************
Main.
   if mn-ele(i) = low-value       *> = at end of menu items
      compute Item-Num = i - 1    *> count how many menu items
      go to Main-ex
   end-if

   if Mn-Act(i) = '1'
      move i        to Mn-Selected
      *> set active item colors
      Move mn-bcoS  to bco
      move mn-fcoS  to fco
      Move mn-fcoSH to fcoH
      perform DisplayItem thru DisplayItemEx
      perform DisplayMessage thru DisplayMessageEx *> for "active item" display the associated message
   else
      *> set non active item colors
      Move mn-bcoN  to bco
      move mn-fcoN  to fco
      Move mn-fcoNH to fcoH
      perform DisplayItem thru DisplayItemEx
   end-if

   *> go to display next menu item
   add  1 to i
   go to Main.

Main-ex.
   *> after displayed all items draw a box around menu items if requested
   if mn-box = 'Y'

     compute box-r1 = mn-r(1) - 1
     compute box-c1 = mn-c(1) - 1
     compute box-r2 = mn-r(Item-Num) + 1
     compute box-c2 = mn-c(1) + Item-MaxLen + 2

     move Mn-Box-Parameters to Box-Parameters

     CALL GC01BOX USING BY CONTENT BOX-AREA
   end-if

   continue.
   *> exit.

*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
Accept-a-Key.

  call static "getch" returning Key-Pressed end-call

  *> <enter> or <escape> return to caller Mn-Selected
  IF Key-Pressed = Key-Enter  move Key-Enter  to Mn-Key go to Exit-Program end-if
  IF Key-Pressed = Key-Escape move Key-Escape to Mn-Key go to Exit-Program end-if

  *> if pressed cursor down or right -> then de-activate current item and activate next menu item
  *> if pressed cursor up   or left  <- then de-activate current item and activate previous menu item
  *> if pressed a hotkey then de-activate current item and activate menu item with that hotkey
  *> move space to mn-Act of curr.item, move '1' to mn-Act of next/previous/hotkey item, other keys have no effect
  EVALUATE TRUE
     when Key-Pressed = Key-CursRight and (Mn-Arrow = 'H' or ' ')    *> Key -> or down
       or Key-Pressed = Key-CursDn    and (Mn-Arrow = 'V' or ' ')
          move Mn-Selected to i
          move space       to Mn-Act(Mn-Selected)
          *> change display active item to display as normal item
          Move Mn-bcoN  to bco
          Move Mn-fcoN  to fco
          Move Mn-fcoNH to fcoH
          perform DisplayItem thru DisplayItemEx

          *> add 1 to i or move 1 if you are on last item of menu
          if   Mn-Selected = Item-Num move 1 to Mn-Selected i else add 1 to Mn-Selected i end-if
          move '1'   to Mn-Act(Mn-Selected)
          *> change display from normal item to display as active item
          Move Mn-bcoS  to bco
          Move Mn-fcoS  to fco
          Move Mn-fcoSH to fcoH
          perform DisplayItem    thru DisplayItemEx
          perform DisplayMessage thru DisplayMessageEx

     when Key-Pressed = Key-CursLeft and (Mn-Arrow = 'H' or ' ')     *> key <- or up
       or Key-Pressed = Key-CursUp   and (Mn-Arrow = 'V' or ' ')
          move Mn-Selected to i
          move space       to Mn-Act(Mn-Selected)
          *> change display from active item to display as normal item
          Move Mn-bcoN  to bco
          Move Mn-fcoN  to fco
          Move Mn-fcoNH to fcoH
          perform DisplayItem thru DisplayItemEx
          *> subtract 1 from i or move item-num if you are on first item of menu
          if   Mn-Selected = 1  move Item-Num to Mn-Selected i else subtract 1 from Mn-Selected i end-if
          move '1'   to Mn-Act(Mn-Selected)
         *> change display from normal item to display as active item
          Move Mn-bcoS  to bco
          Move Mn-fcoS  to fco
          Move Mn-fcoSH to fcoH
          perform DisplayItem    thru DisplayItemEx
          perform DisplayMessage thru DisplayMessageEx

     *> ex. in a drop down menu. Mn-Arrow = V and the user press Key left o Key Right
     *> this program return to caller. Caller program will move to the next drop down menu,
     *> it normally move to the next menu item
     when Mn-Return = 'Y' and (
           (Key-Pressed = Key-CursLeft  and Mn-Arrow = 'V')
        or (Key-Pressed = Key-CursRight and Mn-Arrow = 'V')
        or (Key-Pressed = Key-CursUp    and Mn-Arrow = 'H')
        or (Key-Pressed = Key-CursDn    and Mn-Arrow = 'H')
           )
           move Key-Pressed to Mn-Key go Exit-Program

    *> *****************************************************************************************
    *> IF USER HAS TYPED A LETTER - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when Key-Pressed >= Key-lc-a and <= Key-lc-z

        *> search the index of Key Pressed
        set wChars-Idx Key-lc-Idx to 0
        search Key-lc-Ele varying  Key-lc-Idx
               at end set Key-lc-Idx to 0
               when   Key-lc-Ele (Key-lc-Idx) = Key-Pressed  continue
        end-search

        set wChars-Idx to Key-lc-Idx
        perform varying k from 1 by 1 until k > Item-Num
                if Mn-Hot(k) not = '0' move Mn-Item(k) (Mn-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Mn-Selected to i
                    move space       to Mn-Act(Mn-Selected)
                    Move Mn-bcoN  to bco
                    Move Mn-fcoN  to fco
                    Move Mn-fcoNH to fcoH
                    perform DisplayItem thru DisplayItemEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Mn-Selected i
                    move '1'   to Mn-Act(Mn-Selected)
                    Move Mn-bcoS  to bco
                    Move Mn-fcoS  to fco
                    Move Mn-fcoSH to fcoH
                    perform DisplayItem    thru DisplayItemEx
                    perform DisplayMessage thru DisplayMessageEx
                end-if
        end-perform

    *> *****************************************************************************************
    *> IF USER HAS TYPED A DIGIT - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when Key-Pressed >= Key-0 and <= Key-9
        *> search the index of Key Pressed
        set wChars-Idx Key-num-Idx to 0
        search Key-num-Ele varying  Key-num-Idx
               at end set Key-num-Idx to 0
               when   Key-num-Ele (Key-num-Idx) = Key-Pressed  continue
        end-search

        set wNums-Idx to Key-num-Idx
        perform varying k from 1 by 1 until k > Item-Num
                if Mn-Hot(k) not = '0' move Mn-Item(k) (Mn-Hot(k):1) to wNum end-if
                if wNum = wNums-Ele(wNums-Idx)
                    *> the digit typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Mn-Selected to i
                    move space       to Mn-Act(Mn-Selected)
                    Move Mn-bcoN  to bco
                    Move Mn-fcoN  to fco
                    Move Mn-fcoNH to fcoH
                    perform DisplayItem thru DisplayItemEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Mn-Selected i
                    move '1'   to Mn-Act(Mn-Selected)
                    Move Mn-bcoS  to bco
                    Move Mn-fcoS  to fco
                    Move Mn-fcoSH to fcoH
                    perform DisplayItem thru DisplayItemEx
                end-if
        end-perform

  END-EVALUATE


  go to Accept-a-Key.

Exit-Program.

  *> reset the cursor
  perform CursorReset thru CursorResetEx

  GOBACK.
  *> EXIT PROGRAM.



*> ***********************************************************************************
*> DISPLAY A MENU ITEM  (i = the number of menu item)
*> ***********************************************************************************
DisplayItem.
  *> j= numer of single char , loop to display single chars of a menu item (last char is x'00'.)
   move 0 to j.
DisplayItemLoop.
   add 1 to j
   if Mn-Item(i) (j:1) = low-value go DisplayItemEx end-if

   *> save max length of menu items. useful for drawing a box around the menu
   compute Item-Len = (mn-c(i) + j - 1) - (mn-c(1) + 1)
   if Item-Len > Item-MaxLen move Item-Len to Item-MaxLen end-if

   compute wcol = mn-c(i) + j - 1 end-compute
   if j = Mn-Hot(i)
      display Mn-Item(i) (j:1) at line mn-r(i) col wcol :BCOL:  bco :FCOL: Mn-fcoH highlight end-display
   else
      if fcoH = 'Y' and fco not = black  *> black is not highlighted (it becames grey !)
         display Mn-Item(i) (j:1) at line mn-r(i) col wcol :BCOL: bco :FCOL: fco highlight end-display
      else
         display Mn-Item(i) (j:1) at line mn-r(i) col wcol :BCOL: bco :FCOL: fco end-display
      end-if
   end-if
   go to DisplayItemLoop.
DisplayItemEx. exit.


*> ***********************************************************************************
*> DISPLAY MESSAGE ASSOCIATED TO MENU ITEM
*> ***********************************************************************************
DisplayMessage.
   *> clear row 25 from previous message (next menu item may have "no message" )
   if mn-mess(i) (1:1) = low-value
      display ' ' at line 25 :BCOL: Mn-bcoN :FCOL: Mn-fcoN end-display
      go to DisplayMessageEx
   end-if

   move 1 to w .

DisplayMessageLoop.   *> loop to display single characters of the message
   if mn-mess(i) (w:1) = low-value or w > 80
      go to DisplayMessageEx
   end-if
   if Mn-fcoMH = 'Y'
      display Mn-Mess(i) (w:1) at line Mn-MessRow col w :BCOL: Mn-bcoM :FCOL: Mn-fcoM highlight end-display
   else
      display Mn-Mess(i) (w:1) at line Mn-MessRow col w :BCOL: Mn-bcoM :FCOL: Mn-fcoM           end-display
   end-if
   add 1 to w
   go to DisplayMessageLoop.
DisplayMessageEx. exit.


CursorHide.
    *> save cursor state and hide the cursor
    *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
    move wVisibilityNot to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorHideEx. exit.

CursorReset.
    *> reset (show) the cursor to its saved previous state
    move wVisibilityOld to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorResetEx. exit.

End Program GC22MENU.
