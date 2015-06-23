            >> source format is free
identification division.
program-id. ask.

*> ask * Accept Special Keys. 
*> 
*> This program shows how the extended ACCEPT special keys are used. 
*> 
*> The program starts with a help screen.
*> Simply run the program and follow the directions. 
*> An ncurses package is required to be in the runtime. 
*>
*> To compile and run under Linux, 
*> 
*> cobc -x ask.cob 
*> ./ask 
*>
*> Enter "debug" in the first demo to enter debug mode.  For experts. 
*> 
*> Published under GNU General Public License. 

data division. 
working-storage section. 

*> GNU Cobol function keys. 
    copy screenio.

*> Accept field. 
    01  af-auto-skip                   pic x(01). 
        88 af-auto-skip-no  value low-value. 
        88 af-auto-skip-yes value high-value. 
    01  af-column                      pic 9(04) binary. 
    01  af-crt-status                  pic 9(04). 
    01  af-field                       pic x(40). 
    01  af-line                        pic 9(04) binary. 
    01  af-on-exception                pic x(01). 
        88 af-on-exception-no  value low-value. 
        88 af-on-exception-yes value high-value. 
    01  af-size                        pic 9(04) binary. 

*> Program control. 
    01  flag-debug                     pic x(01) value low-value. 
        88 flag-debug-no  value low-value. 
        88 flag-debug-yes value high-value. 
    01  flag-done                      pic x(01). 
        88 flag-done-no  value low-value. 
        88 flag-done-yes value high-value. 

*> Demonstration descriptions. 
    01  tabl-demos. 
        02 tabl-demo                      pic x(40)
            occurs 23 times. 
    01  max-demo                       pic 9(04) binary value 23. 
    01  sub-demo                       pic 9(04) binary. 

*> Other. 
    01  ws-accept-enter                pic x(01). 
    01  ws-field-number                pic 9(02) binary value 1. 
    01  ws-x-30                        pic x(30). 
    01  ws-number                      pic 9(05) binary. 

procedure division.

*> 
*> Program root. 
*> 

    Perform 0-prepare thru 0-exit. 
    Perform 1-main    thru 1-exit. 
    Perform 9-finish  thru 9-exit. 

*> 
*> Program main. 
*> 

1-main. 

*> Insert key. 
    Set flag-done-no to true. 
    Perform 10-insert-key thru 10-exit
        until flag-done-yes. 

*> Home and End keys. 
    Set flag-done-no to true. 
    Perform 11-home-end-key thru 11-exit 
        until flag-done-yes. 

*> Backspace and Delete keys. 
    Set flag-done-no to true. 
    Perform 12-backspace-delete-key thru 12-exit 
        until flag-done-yes. 

*> Tab and Back Tab keys. 
    Set flag-done-no to true. 
    Perform 13-tab-back-tab-key thru 13-exit 
        until flag-done-yes. 

*> Auto-skip, left arrow, and right arrow. 
    Move 1 to ws-field-number. 
    Set flag-done-no to true. 
    Perform 14-auto-skip thru 14-exit 
        until flag-done-yes. 
1-exit. 
    Exit. 

*>
*> Insert key. 
*> 
10-insert-key.
 
*> Describe demo. 
    Move "        ** INSERT key **                " to tabl-demo (1). 
    Move "                                        " to tabl-demo (2). 
    Move "The default for the INSERT key is set   " to tabl-demo (3). 
    Move "by the COB_INSERT_MODE environment      " to tabl-demo (4). 
    Move "variable.                               " to tabl-demo (5). 
    Move "If COB_INSERT_MODE is YES or Y (either  " to tabl-demo (6). 
    Move "case) then the program starts with      " to tabl-demo (7). 
    Move "insert mode on.  If it is set to NO, N, " to tabl-demo (8). 
    Move "or is not set at all, then the program  " to tabl-demo (9). 
    Move "starts with insert mode off.            " to tabl-demo (10). 
    Move "Type some characters to see if the      " to tabl-demo (11). 
    Move "insert mode is on or off.               " to tabl-demo (12).
    Move "                                        " to tabl-demo (13). 
    Move "Press the Insert key once and type more." to tabl-demo (14).  
    Move "                                        " to tabl-demo (15). 
    Move "The last press of the Insert key is used" to tabl-demo (16). 
    Move "in all following ACCEPT statements while" to tabl-demo (17). 
    Move "the program is running.                 " to tabl-demo (18).   
    Move "                                        " to tabl-demo (19). 
    Move "Press function keys and the escape key  " to tabl-demo (20). 
    Move "to see those results.  Press F1 last    " to tabl-demo (21).
    Move "since it exits.                         " to tabl-demo (22).  
*> Display demo on the screen. 
    Perform swd-show-which-demo thru swd-exit. 

*> Accept field. 
    Move "ABCD" to af-field. 
    Move 2      to af-line.
    Move 42     to af-column. 
    Move 15     to af-size. 
    Set af-auto-skip-no to true. 
    Perform af-accept-field thru af-exit. 

*> F1 finish demo. 
    If af-crt-status is equal to cob-scr-f1
        Set flag-done-yes to true 
        Perform er-erase-results thru er-exit 
    end-if. 
*> Turn on debug mode. 
    If af-field is equal to "debug" 
        Set flag-debug-yes to true 
    end-if. 
10-exit. 
    Exit. 

*> 
*> Home and End keys. 
*> 
11-home-end-key.

*> Describe demo. 
    Move "      ** HOME and END keys **           " to tabl-demo (1). 
    Move "                                        " to tabl-demo (2). 
    Move "The HOME key goes to the beginning of   " to tabl-demo (3). 
    Move "the text.  Press HOME.                  " to tabl-demo (4).
    Move "                                        " to tabl-demo (5). 
    Move "The Alt-HOME key goes to the beginning  " to tabl-demo (6). 
    Move "of the field.  Press Alt-HOME.          " to tabl-demo (7). 
    Move "                                        " to tabl-demo (8). 
    Move "The END key goes to the end of the text." to tabl-demo (9). 
    Move "Press END.                              " to tabl-demo (10). 
    Move "                                        " to tabl-demo (11). 
    Move "The Alt-END key goes to the end of the  " to tabl-demo (12). 
    Move "field.  Press Alt-END.                  " to tabl-demo (13). 
    Move "                                        " to tabl-demo (14). 
    Move "Press these keys in any sequence, and   " to tabl-demo (15). 
    Move "enter some characters, to get a feel for" to tabl-demo (16). 
    Move "how to use them.                        " to tabl-demo (17). 
*> Display demo on the screen.  
    Perform swd-show-which-demo thru swd-exit. 

*> Accept field. 
    Move "      ABCD" to af-field. 
    Move 2      to af-line.
    Move 42     to af-column. 
    Move 15     to af-size. 
    Set af-auto-skip-no to true. 
    Perform af-accept-field thru af-exit. 

*> F1 finish demo. 
    If af-crt-status is equal to cob-scr-f1
        Set flag-done-yes to true 
        Perform er-erase-results thru er-exit 
    end-if. 
11-exit. 
    Exit. 

*>
*> Backspace and Delete keys. 
*> 
12-backspace-delete-key.

*> Describe demo. 
    Move "    ** BACKSPACE and DELETE keys **     " to tabl-demo (1). 
    Move "                                        " to tabl-demo (2). 
    Move "The BACKSPACE key backspaces the data   " to tabl-demo (3). 
    Move "from the cursor.                        " to tabl-demo (4).
    Move "Move the cursor to the letter 'C' and   " to tabl-demo (5). 
    Move "press BACKSPACE.                        " to tabl-demo (6). 
    Move "                                        " to tabl-demo (7). 
    Move "The DELETE key deletes the character    " to tabl-demo (8). 
    Move "and moves the remainder left.           " to tabl-demo (9). 
    Move "Move the cursor to the letter 'E' and   " to tabl-demo (10). 
    Move "press DELETE.                           " to tabl-demo (11). 
    Move "                                        " to tabl-demo (12). 
    Move "The Alt-DELETE key deletes all          " to tabl-demo (13). 
    Move "characters from the cursor to the end of" to tabl-demo (14). 
    Move "the field.                              " to tabl-demo (15).  
    Move "Move the cursor to the letter 'D' and   " to tabl-demo (16).
    Move "press Alt-DELETE.                       " to tabl-demo (17).
*> Display demo on the screen. 
    Perform swd-show-which-demo thru swd-exit. 

*> Accept field. 
    Move "ABCDEFGHI" to af-field. 
    Move 2           to af-line.
    Move 42          to af-column. 
    Move 15          to af-size. 
    Set af-auto-skip-no to true. 
    Perform af-accept-field thru af-exit. 

*> F1 finish demo. 
    If af-crt-status is equal to cob-scr-f1
        Set flag-done-yes to true 
        Perform er-erase-results thru er-exit 
    end-if. 
12-exit.
    Exit. 

*> 
*> Tab and Back Tab keys. 
*> 
13-tab-back-tab-key.

*> Describe demo. 
    Move "     ** TAB and BACK TAB keys **        " to tabl-demo (1). 
    Move "                                        " to tabl-demo (2). 
    Move "The TAB key returns a status code that  " to tabl-demo (3). 
    Move "is typically used to jump to the next   " to tabl-demo (4).
    Move "field.                                  " to tabl-demo (5). 
    Move "In the first field, press TAB.          " to tabl-demo (6). 
    Move "                                        " to tabl-demo (7). 
    Move "The BACK TAB (Shift-TAB) key is         " to tabl-demo (8). 
    Move "typically used to jump to the previous  " to tabl-demo (9). 
    Move "field.                                  " to tabl-demo (10). 
    Move "In the second field, press Shift-TAB.   " to tabl-demo (11). 
    Move "                                        " to tabl-demo (12). 
    Move "The Up-Arrow and Down-Arrow keys may be " to tabl-demo (13). 
    Move "used for the same purpose.  Try them.   " to tabl-demo (14). 
*> Display demo on the screen. 
    Perform swd-show-which-demo thru swd-exit. 

*> Accept fields. 
    Set af-auto-skip-no to true. 
    Move cob-scr-max-field to af-crt-status.     *> Prevent infinite loop.
    If ws-field-number is equal to 1             *> Switch left and right fields.
        Perform 131-accept-field-1 thru 131-exit 
            until flag-done-yes 
               or af-crt-status is equal to cob-scr-ok           *> Enter. 
               or af-crt-status is equal to cob-scr-tab          *> TAB.
               or af-crt-status is equal to cob-scr-key-down     *> Down-Arrow.
        Move 2 to ws-field-number 
      else 
        Perform 132-accept-field-2 thru 132-exit 
            until flag-done-yes 
               or af-crt-status is equal to cob-scr-back-tab     *> Shift-TAB.
               or af-crt-status is equal to cob-scr-key-up       *> Up-Arrow.
        Move 1 to ws-field-number 
    end-if. 
13-exit.
    Exit. 

*> Accept field 1. 
131-accept-field-1.

*> Accept field. 
    Move "ABC" to af-field. 
    Move 2     to af-line.
    Move 42    to af-column. 
    Move 5     to af-size. 
    Perform af-accept-field thru af-exit. 

*> F1 finish demo. 
    If af-crt-status is equal to cob-scr-f1
        Set flag-done-yes to true 
        Perform er-erase-results thru er-exit 
    end-if. 
131-exit. 
    Exit. 

*> Accept field 2. 
132-accept-field-2.

*> Accept field. 
    Move "DEF" to af-field. 
    Move 2     to af-line.
    Move 48    to af-column. 
    Move 5     to af-size. 
    Perform af-accept-field thru af-exit. 

*> F1 finish demo. 
    If af-crt-status is equal to cob-scr-f1
        Set flag-done-yes to true 
        Perform er-erase-results thru er-exit 
    end-if. 
132-exit. 
    Exit. 

*> Auto-skip, left arrow, and right arrow. 
14-auto-skip.

*> Describe demo. 
    Move "    ** Arrow keys with AUTO-SKIP **     " to tabl-demo (1).
    Move "                                        " to tabl-demo (2).  
    Move "These ACCEPT statements use the auto    " to tabl-demo (3). 
    Move "skip feature.  When a character is      " to tabl-demo (4).
    Move "entered in the last position, it is as  " to tabl-demo (5). 
    Move "if the ENTER key is pressed.            " to tabl-demo (6). 
    Move "Type 5 characters in the first field.   " to tabl-demo (7). 
    Move "                                        " to tabl-demo (8). 
    Move "The left arrow auto-skips at the        " to tabl-demo (9). 
    Move "beginning.  Press the left arrow at the " to tabl-demo (10). 
    Move "beginning of the second field.          " to tabl-demo (11). 
    Move "                                        " to tabl-demo (12). 
    Move "The right arrow auto-skips at the end.  " to tabl-demo (13). 
    Move "Press the right arrow past then end of  " to tabl-demo (14). 
    Move "the first field.                        " to tabl-demo (15).  
    Move "                                        " to tabl-demo (16). 
    Move "The Alt-left-arrow and Alt-right-arrow  " to tabl-demo (17).
    Move "keys do not auto skip.  Try them.       " to tabl-demo (18). 
*> Display demo on the screen. 
    Perform swd-show-which-demo thru swd-exit. 

*> Accept fields. 
    Set af-auto-skip-yes to true. 
    Move cob-scr-max-field to af-crt-status.     *> Prevent infinite loop.
    If ws-field-number is equal to 1             *> Switch left and right fields.
        Perform 131-accept-field-1 thru 131-exit 
            until flag-done-yes 
               or af-crt-status is equal to cob-scr-ok          *> Enter.
               or af-crt-status is equal to cob-scr-key-right   *> Right-Arrow.
               or af-crt-status is equal to cob-scr-tab         *> TAB.
               or af-crt-status is equal to cob-scr-key-down    *> Down-Arrow.
        Move 2 to ws-field-number 
      else 
        Perform 132-accept-field-2 thru 132-exit 
            until flag-done-yes 
               or af-crt-status is equal to cob-scr-key-left    *> Left-Arrow.
               or af-crt-status is equal to cob-scr-back-tab    *> Shift-TAB. 
               or af-crt-status is equal to cob-scr-key-up      *> Up-Arrow. 
        Move 1 to ws-field-number 
    end-if. 
14-exit. 
    Exit. 

*>
*> Program common. 
*> 

*> 
*>  Accept field. 
*> 
*> To use: 
*> 
*>    Move "my text (or spaces)" to af-field.    *> Field to accept. 
*>    Move 10                    to af-line.     *> Line.
*>    Move 20                    to af-column.   *> Column. 
*>    Move 15                    to af-size.     *> Field size. 
*>    Set af-auto-skip-no to true.               *> Auto skip yes or no. 
*>    Perform af-accept-field thru af-exit. 
*>    Move af-field to my-text-field. 
*> 
af-accept-field. 

*> Debug: Put all X to show where the field ends. 
    If flag-debug-yes 
        Move all "X" to ws-x-30
        Display ws-x-30 
            line   af-line 
            column af-column 
        end-display
    end-if. 

*> Accept the field. 
    If af-auto-skip-yes 
        Accept af-field                *> Auto skip on. 
            line   af-line 
            column af-column 
            with update 
                 size af-size 
                 auto-skip
            on exception 
                Set af-on-exception-yes to true 
            not on exception 
                Set af-on-exception-no  to true 
        end-accept 
      else 
        Accept af-field                *> Auto skip off. 
            line   af-line 
            column af-column 
            with update 
                 size af-size 
            on exception 
                Set af-on-exception-yes to true 
            not on exception 
                Set af-on-exception-no  to true 
        end-accept
    end-if. 
    Move cob-crt-status to af-crt-status. 

*> Display the results. 
    Perform dr-display-results thru dr-exit. 
af-exit. 
    Exit. 

*> 
*> Display the results of the accept. 
*> 
dr-display-results. 

*> The accepted field. 
    Display af-field 
        line   21 
        column 42 
    end-display. 

*> The cob-crt-status. 
    Move space to ws-x-30. 
    String 
        "COB-CRT-STATUS: " 
            delimited by size 
        af-crt-status
            delimited by size 
        into ws-x-30 
    end-string.
    Display ws-x-30 
        line   22 
        column 42
    end-display. 

*> The interpretation of the status. 
    Evaluate af-crt-status 
        when cob-scr-ok        Move space         to ws-x-30 
        when cob-scr-f1        Move "F1 "         to ws-x-30 
        when cob-scr-f2        Move "F2 "         to ws-x-30 
        when cob-scr-f3        Move "F3 "         to ws-x-30 
        when cob-scr-f4        Move "F4 "         to ws-x-30 
        when cob-scr-f5        Move "F5 "         to ws-x-30 
        when cob-scr-f6        Move "F6 "         to ws-x-30 
        when cob-scr-f7        Move "F7 "         to ws-x-30 
        when cob-scr-f8        Move "F8 "         to ws-x-30 
        when cob-scr-f9        Move "F9 "         to ws-x-30 
        when cob-scr-f10       Move "F10"         to ws-x-30 
        when cob-scr-f11       Move "F11"         to ws-x-30 
        when cob-scr-f12       Move "F12"         to ws-x-30 
        when cob-scr-f13       Move "F13"         to ws-x-30 
        when cob-scr-f14       Move "F14"         to ws-x-30 
        when cob-scr-f15       Move "F15"         to ws-x-30 
        when cob-scr-f16       Move "F16"         to ws-x-30 
        when cob-scr-f17       Move "F17"         to ws-x-30 
        when cob-scr-f18       Move "F18"         to ws-x-30 
        when cob-scr-f19       Move "F19"         to ws-x-30 
        when cob-scr-f20       Move "F20"         to ws-x-30 
        when cob-scr-f21       Move "F21"         to ws-x-30 
        when cob-scr-f22       Move "F22"         to ws-x-30 
        when cob-scr-f23       Move "F23"         to ws-x-30 
        when cob-scr-f24       Move "F24"         to ws-x-30 
        when cob-scr-f25       Move "F25"         to ws-x-30 
        when cob-scr-f26       Move "F26"         to ws-x-30 
        when cob-scr-f27       Move "F27"         to ws-x-30 
        when cob-scr-f28       Move "F28"         to ws-x-30 
        when cob-scr-f29       Move "F29"         to ws-x-30 
        when cob-scr-f30       Move "F30"         to ws-x-30 
        when cob-scr-f31       Move "F31"         to ws-x-30 
        when cob-scr-f32       Move "F32"         to ws-x-30 
        when cob-scr-f33       Move "F33"         to ws-x-30 
        when cob-scr-f34       Move "F34"         to ws-x-30 
        when cob-scr-f35       Move "F35"         to ws-x-30 
        when cob-scr-f36       Move "F36"         to ws-x-30 
        when cob-scr-f37       Move "F37"         to ws-x-30 
        when cob-scr-f38       Move "F38"         to ws-x-30 
        when cob-scr-f39       Move "F39"         to ws-x-30 
        when cob-scr-f40       Move "F40"         to ws-x-30 
        when cob-scr-f41       Move "F41"         to ws-x-30 
        when cob-scr-f42       Move "F42"         to ws-x-30 
        when cob-scr-f43       Move "F43"         to ws-x-30 
        when cob-scr-f44       Move "F44"         to ws-x-30 
        when cob-scr-f45       Move "F45"         to ws-x-30 
        when cob-scr-f46       Move "F46"         to ws-x-30 
        when cob-scr-f47       Move "F47"         to ws-x-30 
        when cob-scr-f48       Move "F48"         to ws-x-30 
        when cob-scr-f49       Move "F49"         to ws-x-30 
        when cob-scr-f50       Move "F50"         to ws-x-30 
        when cob-scr-f51       Move "F51"         to ws-x-30 
        when cob-scr-f52       Move "F52"         to ws-x-30 
        when cob-scr-f53       Move "F53"         to ws-x-30 
        when cob-scr-f54       Move "F54"         to ws-x-30 
        when cob-scr-f55       Move "F55"         to ws-x-30 
        when cob-scr-f56       Move "F56"         to ws-x-30 
        when cob-scr-f57       Move "F57"         to ws-x-30 
        when cob-scr-f58       Move "F58"         to ws-x-30 
        when cob-scr-f59       Move "F59"         to ws-x-30 
        when cob-scr-f60       Move "F60"         to ws-x-30 
        when cob-scr-f61       Move "F61"         to ws-x-30 
        when cob-scr-f62       Move "F62"         to ws-x-30 
        when cob-scr-f63       Move "F63"         to ws-x-30 
        when cob-scr-f64       Move "F64"         to ws-x-30 
        when cob-scr-page_up   Move "Page Up"     to ws-x-30 
        when cob-scr-page_down Move "Page Down"   to ws-x-30 
        when cob-scr-key-up    Move "Up Arrow"    to ws-x-30 
        when cob-scr-key-down  Move "Down Arrow"  to ws-x-30 
        when cob-scr-esc       Move "Escape"      to ws-x-30 
        when cob-scr-print     Move "Print"       to ws-x-30 
        when cob-scr-tab       Move "Tab"         to ws-x-30 
        when cob-scr-back-tab  Move "Shift-Tab"   to ws-x-30 
        when cob-scr-key-left  Move "Left Arrow"  to ws-x-30 
        when cob-scr-key-right Move "Right Arrow" to ws-x-30 
        when cob-scr-no-field  Move "No Field"    to ws-x-30 
        when cob-scr-time-out  Move "Time Out"    to ws-x-30 
        when cob-scr-fatal     Move "Fatal"       to ws-x-30 
        when cob-scr-max-field Move "Max Field"   to ws-x-30 
        when other             Move "(unknown)"   to ws-x-30 
    end-evaluate. 
    Display ws-x-30 
        line   23 
        column 42 
    end-display.  

*> On exception. 
    If af-on-exception-yes 
        Display "on exception" 
            line   24 
            column 42 
        end-display 
      else 
        Display space 
            line   24 
            column 42 
            with size 12
        end-display 
    end-if. 
dr-exit. 
    Exit. 

*> Blank the accept line for the next demo. 
er-erase-results. 

*> The accept line. 
    Display space 
        line af-line 
        column 42 
        with size 30 
    end-display. 

*> The result lines. 
    Display space 
        line   21 
        column 42 
        with size 30 
    end-display. 
    Display space 
        line   22 
        column 42 
        with size 30 
    end-display. 
    Display space 
        line   23 
        column 42 
        with size 30 
    end-display. 
    Display space 
        line   24 
        column 42 
        with size 30 
    end-display. 
er-exit. 
    Exit. 

*> 
*> Display demo on the screen. 
*>
swd-show-which-demo. 

*> Display demo on the left side. 
    Perform 
        varying sub-demo 
           from 1 
             by 1 
        until sub-demo is greater than max-demo 
            Display tabl-demo (sub-demo) 
                line   sub-demo 
                column 1 
            end-display 
    end-perform. 

*> Erase for next demo. 
    Initialize tabl-demos. 
swd-exit. 
    Exit. 

*>
*> Program prepare. 
*> 

0-prepare. 

*> Turn on function keys. 
    Set environment "COB_SCREEN_EXCEPTIONS" to "Y". 
*> Turn on the escape key. 
    Set environment "COB_SCREEN_ESC"        to "Y". 
*> No delay for the escape key. 
    Set environment "ESCDELAY"              to "25". 

*> Exit if screen size is too small. 
    Accept ws-x-30 
        from lines 
    end-accept. 
    Move function numval (ws-x-30) to ws-number. 
    If ws-number is less than 24 
        Move "Screen size less than 24 lines." to ws-x-30 
        Perform 01-error-exit thru 01-exit 
    end-if. 
    Accept ws-x-30 
        from columns 
    end-accept. 
    Move function numval (ws-x-30) to ws-number. 
    If ws-number is less than 80
        Move "Screen size less than 80 columns." to ws-x-30 
        Perform 01-error-exit thru 01-exit 
    end-if.     

*> Clear the screen. 
    Display space 
        line 1 column 1 
        with blank screen
    end-display. 

*> Display instructions.  
    Initialize tabl-demos. 
    Move "   ask * Accept Special Keys            " to tabl-demo (1). 
    Move "                                        " to tabl-demo (2). 
    Move "This shows how special keys are used    " to tabl-demo (3).
    Move "with the extended ACCEPT statement.     " to tabl-demo (4).
    Move "                                        " to tabl-demo (5). 
    Move "The description appears on the left.    " to tabl-demo (6).
    Move "The ACCEPT is on the upper right.  And  " to tabl-demo (7). 
    Move "the results are on the bottom right.    " to tabl-demo (8). 
    Move "                                        " to tabl-demo (9). 
    Move "Press the F1 key on any field to exit   " to tabl-demo (10).  
    Move "the demo and go to the next.            " to tabl-demo (11). 
*> Display demo on the screen. 
    Perform swd-show-which-demo thru swd-exit. 
*> Wait for the user to press enter. 
    Accept ws-accept-enter 
        line 24 column 1
    end-accept. 
0-exit. 
    Exit. 

01-error-exit. 

*> Display error. 
    Display ws-x-30 
    end-display. 
    Display "Press enter." 
    end-display. 

*> Wait for enter to be pressed. 
    Accept ws-accept-enter
    end-accept. 

*> Stop. 
    Stop run. 
01-exit. 
    Exit. 

*>
*> Program finish. 
*> 

9-finish. 

*> Stop. 
    Stop run. 
9-exit. 
    Exit. 
