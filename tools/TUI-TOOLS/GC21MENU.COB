       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC21MENU is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A LIST OF MENU ITEMS ON THE SCREEN
*> Tectonics:  cobc -m GC21MENU.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> CALLS;      GC01BOX.DLL (complie from GC01BOX.COB)
*> Usage:      call GC21MENU using Menu-Area
*> Parameters: look at GC21MENU.CPY
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License
*> Version:    3.1 2020.06.10
*> Changelog:  1.0 first release.
*>             2.0 mouse management added (left click to make menu item "active"
*>                                         double left-click to select a menu item
*>             3.0 hot key management added to make menu item "active"
*>                 Mn-Hot from 9(01) to 9(02)
*>             3.1 tectonics specifies  -lpdcurses
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position

DATA DIVISION.
WORKING-STORAGE SECTION.
copy       'GC01BOX.CPY'  suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

01  .
    03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  j            pic 9(02) value 1.
    03  k            pic 9(02) value 1.
    03  Item-Num     pic 9(02) value 0.  *> count how many menu items
    03  Item-Len     pic 9(02) value 0.
    03  Item-MaxLen  pic 9(02) value 0.
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wcol         PIC 9(03).
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).

    03  wChar        PIC X(01).
    03  wNum         PIC X(01).

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

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  COB-AUTO-MOUSE-HANDLING          VALUE 1.
78  COB-ALLOW-LEFT-DOWN              VALUE 2.
78  COB-ALLOW-LEFT-UP                VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE            VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN            VALUE 16.
78  COB-ALLOW-MIDDLE-UP              VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE          VALUE 64.
78  COB-ALLOW-RIGHT-DOWN             VALUE 128.
78  COB-ALLOW-RIGHT-UP               VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE           VALUE 512.
78  COB-ALLOW-MOUSE-MOVE             VALUE 1024.
01  COB-MOUSE-FLAGS         PIC 9(04).

01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01 wMn-ItemLenTab    Value zero.
  05 wMn-ItemLen     occurs 25 pic 9(03). *> menu item length (char number before X"00")
  05 wMn-ItemCol-End occurs 25 pic 9(03). *> end column of the item

01 wChars.
   03  wChars1 pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
   03  wChars-Ele redefines wChars1 pic x(01) occurs 26 indexed by wChars-Idx.
01 wNums.
   03  wNums1 pic x(26) value '0123456789'.
   03  wNums-Ele  redefines wNums1  pic x(01) occurs 10 indexed by wNums-Idx.

01  Key-lc.
    05                   pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
01  Key-lc-Table redefines Key-lc.
    05 Key-lc-Ele        pic X(1) occurs 26 indexed by Key-lc-Idx.

01 Key-num.
    05                   pic x(10) value '0123456789'.
01 Key-num-Table redefines Key-num.
   05 Key-num-Ele        pic x(1) occurs 10 indexed by Key-num-Idx.

LINKAGE SECTION.
COPY 'GC21MENU.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Menu-Area.

perform InitialSettings thru InitialSettingsEx

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
 go to Main.    *> go to display next menu item

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
 continue.

*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field.
 *> the dummy field is at cursor position of the 1st byte of the fors menu item
 *> it has same back end fore color of 1st menu item so it is invisible
 *> with "Auto" option is useful to detect if cursor up/down/left/right is pressed
 move space to wDummy

 if Mn-Selected = 1
    accept wDummy at line Mn-r(1) col Mn-c(1)
           with auto no-echo size 0 background-color Mn-bcoS :FCOL: Mn-fcoS end-accept
 else
    accept wDummy at line Mn-r(1) col Mn-c(1)
           with auto no-echo size 0 background-color Mn-bcoN :FCOL: Mn-fcoN end-accept
 end-if

  *> <enter> or <escape> return to caller Mn-Selected
  *> if pressed cursor down or right -> activate next menu item
  *> if pressed cursor up   or left  <- activate previous menu item
  *> move space to mn-Act of item
  *> move '1' to mn-Act of next or previous item
  *> other keys have no effect

*> if user has typed a letter or a digit then wCRT-STATUS is = 00000 (K-ENTER) !
If wDummy = space
 IF wCRT-STATUS = K-ENTER  move K-ENTER  to Mn-Key go Exit-Program end-if
 IF wCRT-STATUS = K-ESCAPE move K-ESCAPE to Mn-Key go Exit-Program end-if
end-if

 EVALUATE TRUE

 when wCRT-STATUS = K-RIGHT and (Mn-Arrow = 'H' or ' ')  *> Cursor Key right or down
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

 when wCRT-STATUS = K-LEFT and (Mn-Arrow = 'H' or ' ')   *> cursor key left or up
   or wCRT-STATUS = K-UP   and (Mn-Arrow = 'V' or ' ')
    move Mn-Selected to i
    move space    to Mn-Act(Mn-Selected)
    *> display as normal item
    Move Mn-bcoN  to bco
    Move Mn-fcoN  to fco
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

  when (wCRT-STATUS = K-LEFT-PRESSED or wCRT-STATUS = K-LEFT-DBL-CLICK)
       *> check if mouse position is on a menu item
       perform varying k from 1 by 1 until k > Item-Num
         if wCursorRow  = Mn-r(k)
            if ( wCursorCol >= Mn-c(k) and  wCursorCol <= wMn-ItemCol-End(k) )
              *> the mouse has been clicked on a menu item
              *> change display of active item to display as normal item
              move Mn-Selected to i
              move space       to Mn-Act(Mn-Selected)
              Move Mn-bcoN  to bco
              Move Mn-fcoN  to fco
              Move Mn-fcoNH to fcoH
              perform DisplayItem thru DisplayItemEx
              *> change the clicked item to display from normal item to display as active item
              move k to Mn-Selected i
              move '1'   to Mn-Act(Mn-Selected)
              Move Mn-bcoS  to bco
              Move Mn-fcoS  to fco
              Move Mn-fcoSH to fcoH
              perform DisplayItem    thru DisplayItemEx
              perform DisplayMessage thru DisplayMessageEx

              if wCRT-STATUS = K-LEFT-DBL-CLICK
                *> CALL "C$SLEEP" USING 1 *> small delay to show the click effect
                *> continue after 0.5 seconds
                *> Windows systems will only be able to sleep at a millisecond granularity
                call "CBL_GC_NANOSLEEP" USING 500000000 end-call
                move K-ENTER  to Mn-Key
                go Exit-Program
              end-if

            end-if
         end-if
       end-perform

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

    *> *****************************************************************************************
    *> IF USER HAS TYPED A LETTER - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when wDummy >= "a" and <= "z"
        *> search the index of Key Pressed
        set wChars-Idx Key-lc-Idx to 0
        search Key-lc-Ele varying  Key-lc-Idx
               at end set Key-lc-Idx to 0
               when   Key-lc-Ele (Key-lc-Idx) = wDummy  continue
        end-search

        set wChars-Idx to Key-lc-Idx
        perform varying k from 1 by 1 until k > Item-Num
                if Mn-Hot(k) not = zero move Mn-Item(k) (Mn-Hot(k):1) to wChar end-if
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
     when wDummy >= "0" and <= "9"
        *> search the index of Key Pressed
        set wChars-Idx Key-num-Idx to 0
        search Key-num-Ele varying  Key-num-Idx
               at end set Key-num-Idx to 0
               when   Key-num-Ele (Key-num-Idx) = wDummy  continue
        end-search

        set wNums-Idx to Key-num-Idx
        perform varying k from 1 by 1 until k > Item-Num
                if Mn-Hot(k) not = zero move Mn-Item(k) (Mn-Hot(k):1) to wNum end-if
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
    *> re-show the cursor
    move 2 to wInt
    call static "curs_set" using by value wInt end-call

EXIT PROGRAM.

*> ***********************************************************************************
*> DISPLAY A MENU ITEM
*> ***********************************************************************************
DisplayItem.
 move 0 to j
 *> store the legth of a menu item , useful to detect if user has mouse clicked on it
 move zero to wMn-ItemLen(i)
 inspect Mn-Item(i) tallying wMn-ItemLen(i) FOR CHARACTERS before x"00"
 compute wMn-ItemCol-End(i) =  Mn-c(i) +  wMn-ItemLen(i) - 1
 continue.

*> loop to display single characters of a menu item (last char is x'00'.)
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
*> DISPLAY THE MESSAGE ASSOCIATED TO MENU ITEM
*> ***********************************************************************************
DisplayMessage.
 *> clear row 25 from previous message (next menu item may have "no message" )
 if mn-mess(i) (1:1) = low-value
      display ' ' at line 25 :BCOL: Mn-bcoN :FCOL: Mn-fcoN end-display
    go to DisplayMessageEx end-if

 move 1 to w .
*> loop to display single characters of the message
DisplayMessageLoop.
 if mn-mess(i) (w:1) = low-value or w > 80
    go to DisplayMessageEx
 end-if
 if Mn-fcoMH = 'Y'
    display Mn-Mess(i) (w:1) at line Mn-MessRow col w :BCOL: Mn-bcoM :FCOL: Mn-fcoM highlight end-display
 else
    display Mn-Mess(i) (w:1) at line Mn-MessRow col w :BCOL: Mn-bcoM :FCOL: Mn-fcoM end-display
 end-if
 add 1 to w
 go to DisplayMessageLoop.
DisplayMessageEx. exit.

hide-cursor.
    *> hide the cursor
    move 0 to wInt
    call static "curs_set" using by value wInt end-call.
hide-cursor-ex. exit.

InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING
                      + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
                      + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP
                      + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
                      + COB-ALLOW-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to COB-MOUSE-FLAGS

  perform hide-cursor thru hide-cursor-ex
  continue.
InitialSettingsEx. exit.

End Program GC21MENU.
