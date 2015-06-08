            >> source format is free
identification division.
program-id. dasize.

*> dasize * Display Accept Size. 
*> 
*> This program shows how the WITH SIZE option works 
*> on the extended ACCEPT and DISPLAY statements. 
*> 
*> The program starts with a help screen.
*> Simply run the program and follow the directions. 
*> An ncurses package is required to be in the runtime. 
*>
*> To compile and run under Linux, 
*> 
*> cobc -x dasize.cob 
*> ./dasize 
*>
*> Published under GNU General Public License. 

data division. 
working-storage section. 

01  tabl-demos. 
    02 tabl-demo                      pic x(40)
        occurs 10 times. 
01  max-demo                       pic 9(04) binary value 10. 
01  sub-demo                       pic 9(04) binary. 

01  ws-accept-enter                pic x(01). 
01  ws-all-x                       pic x(25) value all "X". 
01  ws-expected                    pic x(25). 
01  ws-size                        pic 9(04) binary. 

01  x-20.
    02 x-5                            pic x(05). 
    02 num-5 redefines x-5            pic 9(05). 
    02                                pic x(15). 

procedure division.

*> Program root. 

Perform 0-prepare thru 0-exit. 
Perform 1-main    thru 1-exit. 
Perform 9-finish  thru 9-exit. 

*> Program main. 

1-main. 

*> The DISPLAY WITH SIZE. 
Perform 10-display-with-size-is thru 10-exit. 

*> The DISPLAY without size. 
Perform 11-display-without-size thru 11-exit.

*> The ACCEPT WITH SIZE. 
Perform 12-accept-with-size-is  thru 12-exit. 

*> The ACCEPT without size. 
Perform 13-accept-without-size  thru 13-exit. 

1-exit. 
    Exit. 

*> 
*> Show various uses of the DISPLAY WITH SIZE. 
*> 
10-display-with-size-is. 

*> "abcd" size 10. 
Move "Display 'abcd' "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "abcd      XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display "abcd"
    line 14 column 5 
    with size 10 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> "abcd" size 2. 
Move "Display 'abcd' "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 2 "           to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "abXXXXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display "abcd"
    line 14 column 5 
    with size 2 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> "   " with size 10. 
Move "Display '     ' "           to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "          XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display "     " 
    line 14 column 5 
    with size 10 
end-display.  
Perform dad-display-after-demo thru dad-exit. 

*> Space size 10. 
Move "Display spaces "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "          XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display spaces 
    line 14 column 5 
    with size 10 
end-display.  
Perform dad-display-after-demo thru dad-exit. 

*> low-value size 10. 
Move "Display low-value "         to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "Display 'after low-value' " to tabl-demo (5). 
Move "end-display. "              to tabl-demo (6). 
Move "after low-valueXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display low-value
    line 14 column 5 
    with size 10 
end-display.  
Display "after low-value" 
end-display.
Perform dad-display-after-demo thru dad-exit. 

*> quote size 10. 
Move "Display quotes "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move all quote                    to ws-expected.
Move "XXXXXXXXXXXXXXX"            to ws-expected (11:). 
Perform dbd-display-before-demo thru dbd-exit. 
Display quotes
    line 14 column 5 
    with size 10 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> zero size 10. 
Move "Display zeros "             to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size 10 "          to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "0000000000XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display zeros
    line 14 column 5 
    with size 10 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> With size is literal. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Display x-20   "            to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "    with size is 5 "        to tabl-demo (4).
Move "end-display. "              to tabl-demo (5). 
Move "iiiiiXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display x-20 
    line 14 column 5 
    with size is 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> With size literal. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Display x-20   "            to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "    with size 5 "           to tabl-demo (4).
Move "end-display. "              to tabl-demo (5). 
Move "iiiiiXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display x-20 
    line 14 column 5 
    with size 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> With size is variable. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Move 5       to ws-size. "  to tabl-demo (2).
Move "Display x-20   "            to tabl-demo (3).
Move "    line 14 column 5 "      to tabl-demo (4).
Move "    with size is ws-size "  to tabl-demo (5).
Move "end-display. "              to tabl-demo (6). 
Move "iiiiiXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Move 5 to ws-size. 
Display x-20 
    line 14 column 5 
    with size is ws-size 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> With size variable. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Move 5       to ws-size. "  to tabl-demo (2).
Move "Display x-20   "            to tabl-demo (3).
Move "    line 14 column 5 "      to tabl-demo (4).
Move "    with size ws-size "     to tabl-demo (5).
Move "end-display. "              to tabl-demo (6). 
Move "iiiiiXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Move 5 to ws-size. 
Display x-20 
    line 14 column 5 
    with size ws-size 
end-display.  
Perform dad-display-after-demo thru dad-exit. 

*> x-20 (1:5) with size ws-size. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Move 10      to ws-size. "  to tabl-demo (2).
Move "Display x-20 (1:5) "        to tabl-demo (3).
Move "    line 14 column 5 "      to tabl-demo (4).
Move "    with size ws-size "     to tabl-demo (5).
Move "end-display. "              to tabl-demo (6). 
Move "iiiii     XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Move 10 to ws-size. 
Display x-20 (1:5) 
    line 14 column 5 
    with size ws-size 
end-display.  
Perform dad-display-after-demo thru dad-exit. 

*> x-20 (1:5) with size 10. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Display x-20 (1:5) "        to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "    with size is 10 "       to tabl-demo (4).
Move "end-display. "              to tabl-demo (5). 
Move "iiiii     XXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display x-20 (1:5) 
    line 14 column 5 
    with size 10
end-display.  
Perform dad-display-after-demo thru dad-exit. 

10-exit. 
    Exit. 

*>
*> The DISPLAY without size. 
*> 
11-display-without-size.

*> "abcd" size zero. 
Move "Display 'abcd' "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "    with size zero "        to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "abcdXXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display "abcd"
    line 14 column 5 
    with size zero
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> "abcd". 
Move "Display 'abcd' "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "end-display. "              to tabl-demo (3). 
Move "abcdXXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display "abcd"
    line 14 column 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> x-20. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Display x-20 "              to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "    with size zero "        to tabl-demo (4).
Move "end-display. "              to tabl-demo (5). 
Move "iiiiiiiiiiiiiiiiiiiiXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display x-20
    line 14 column 5 
    with size zero 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> x-20. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Display x-20 "              to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "end-display. "              to tabl-demo (4). 
Move "iiiiiiiiiiiiiiiiiiiiXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display x-20
    line 14 column 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> Space with no size. 
Move "Display spaces "            to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "end-display. "              to tabl-demo (3). 
Move "                    XXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display spaces  
    line 14 column 5 
end-display.  
Perform dad-display-after-demo thru dad-exit. 

*> low-value. 
Move "Display low-value "         to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "end-display. "              to tabl-demo (3). 
Move "Display 'after low-value' " to tabl-demo (4). 
Move "end-display. "              to tabl-demo (5). 
Move "after low-valueXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display low-value
    line 14 column 5 
end-display.  
Display "after low value" 
end-display.
Perform dad-display-after-demo thru dad-exit. 

*> quote. 
Move "Display quote "             to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "end-display. "              to tabl-demo (3). 
Move """XXXXXXXXXXXXXXXXXXXXXXXX" to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display quote
    line 14 column 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

*> zero. 
Move "Display zero "              to tabl-demo (1).
Move "    line 14 column 5 "      to tabl-demo (2).
Move "end-display. "              to tabl-demo (3). 
Move "0XXXXXXXXXXXXXXXXXXXXXXXX"  to ws-expected. 
Perform dbd-display-before-demo thru dbd-exit. 
Display zero
    line 14 column 5 
end-display. 
Perform dad-display-after-demo thru dad-exit. 

11-exit.
    Exit. 

*> 
*> The ACCEPT WITH SIZE demos. 
*> 
12-accept-with-size-is.

*> With protected size is literal. 
Move "Accept x-20 "                   to tabl-demo (1).
Move "    line 14 column 5 "          to tabl-demo (2).
Move "    with protected size is 10 " to tabl-demo (3).
Move "end-accept. "                   to tabl-demo (4). 
Move "          XXXXXXXXXXXXXXX"      to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Accept x-20 
    line 14 column 5 
    with protected size is 10
end-accept. 
Perform aad-accept-after-demo thru aad-exit. 

*> With update size is literal. 
Move "Move all 'i' to x-20. "     to tabl-demo (1).
Move "Accept x-20 "               to tabl-demo (2).
Move "    line 14 column 5 "      to tabl-demo (3).
Move "    with update "           to tabl-demo (4).
Move "         size 10 "          to tabl-demo (5).
Move "end-accept. "               to tabl-demo (6). 
Move "iiiiiiiiiiXXXXXXXXXXXXXXX"  to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Accept x-20 
    line 14 column 5 
    with update 
         size 10
end-accept. 
Perform aad-accept-after-demo thru aad-exit. 

*> Numeric With update size is literal. 
Move "01  x-20.                              " to tabl-demo (1). 
Move "    02 x-5                  pic x(05). " to tabl-demo (2). 
Move "    02 num-5 redefines x-5  pic 9(05). " to tabl-demo (3). 
Move "    02                      pic x(15). " to tabl-demo (4). 
Move "Move 123 to num-5. "                     to tabl-demo (5).
Move "Accept num-5 "                           to tabl-demo (6).
Move "    line 14 column 5 "                   to tabl-demo (7).
Move "    with update "                        to tabl-demo (8).
Move "         size 4 "                        to tabl-demo (9).
Move "end-accept. "                            to tabl-demo (10). 
Move "0012XXXXXXXXXXXXXXXXXXXXX"               to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Move 123 to num-5. 
Accept num-5  
    line 14 column 5 
    with update 
         size 4
end-accept. 
Perform aad-accept-after-demo thru aad-exit. 

*> With size greater than field size. 
Move "01  x-20. "                 to tabl-demo (1). 
Move "    02 x-5     pic x(05). " to tabl-demo (2). 
Move "    02         pic x(15). " to tabl-demo (3). 
Move "Move all 'i' to x-20. "     to tabl-demo (4).
Move "Accept x-5 "                to tabl-demo (5).
Move "    line 14 column 5 "      to tabl-demo (6).
Move "    with size 10 "          to tabl-demo (7).
Move "end-accept. "               to tabl-demo (8). 
Move "          XXXXXXXXXXXXXXX"  to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Accept x-5
    line 14 column 5 
    with size 10
end-accept. 
Perform aad-accept-after-demo thru aad-exit.
 
12-exit.
    Exit. 

*> 
*> The ACCEPT without size demos. 
*> 
13-accept-without-size.

*> Size zero. 
Move "01  x-20. "                 to tabl-demo (1). 
Move "    02 x-5     pic x(05). " to tabl-demo (2). 
Move "    02         pic x(15). " to tabl-demo (3). 
Move "Move all 'i' to x-20. "     to tabl-demo (4).
Move "Accept x-5 "                to tabl-demo (5).
Move "    line 14 column 5 "      to tabl-demo (6).
Move "    with size zero "        to tabl-demo (7). 
Move "end-accept. "               to tabl-demo (8). 
Move "     XXXXXXXXXXXXXXXXXXXX"  to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Accept x-5
    line 14 column 5 
    with size zero 
end-accept. 
Perform aad-accept-after-demo thru aad-exit.

*> Without size. 
Move "01  x-20. "                 to tabl-demo (1). 
Move "    02 x-5     pic x(05). " to tabl-demo (2). 
Move "    02         pic x(15). " to tabl-demo (3). 
Move "Move all 'i' to x-20. "     to tabl-demo (4).
Move "Accept x-5 "                to tabl-demo (5).
Move "    line 14 column 5 "      to tabl-demo (6).
Move "end-accept. "               to tabl-demo (7). 
Move "     XXXXXXXXXXXXXXXXXXXX"  to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Accept x-5
    line 14 column 5 
end-accept. 
Perform aad-accept-after-demo thru aad-exit.

13-exit. 
    Exit. 

*> Program common. 

*> 
*> Set up for next demo. 
*> 
dbd-display-before-demo. 

*> Display which demo on the screen. 
Perform swd-show-which-demo thru swd-exit. 

*> Ruler. 
Display "1234567890123456789012345" 
    line 12 column 5 
end-display. 

*> Demo heading:. 
Display "Output:" 
    line 13 column 5 
end-display. 

*> All x to see how many bytes displayed. 
Display ws-all-x 
    line 14 column 5 
end-display. 

*> Expected result. 
Display "Expected result: "
    line 15 column 5 
end-display.
Display ws-expected 
    line 16 column 5 
end-display. 

*> Erase previous accepted field. 
Display space 
    line 17 column 5 
    with size 40 
end-display. 
Display space 
    line 18 column 5 
    with size 40 
end-display. 

*> Prepare the display field. 
Move all "i" to x-20. 

dbd-exit. 
    Exit. 

swd-show-which-demo. 

*> Display which demo on the screen. 
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
*> Review results of demo.  
*> 
dad-display-after-demo. 

*> Review and press enter.
Display "Review result and press enter. "
    line 20 column 1
end-display. 
Accept ws-accept-enter 
    line 20 column 32
end-accept. 

dad-exit. 
    Exit. 

*> 
*> Review results of demo.  
*> 
aad-accept-after-demo. 

*> Accepted field. 
Display "The x-20 field after the accept: " 
    line 17 column 5 
end-display. 
*> Display accepted field. 
Display x-20 
    line 18 column 5 
end-display. 

*> Review results of demo.  
Perform dad-display-after-demo thru dad-exit. 

aad-exit. 
    Exit. 

*> Program prepare. 

0-prepare. 

*> Clear the screen. 
Display space 
    line 1 column 1 
    with blank screen
end-display. 

*> Display instructions.  
Move "This shows the WITH SIZE option on the  " to tabl-demo (1).
Move "extended ACCEPT and DISPLAY statements. " to tabl-demo (2).
Move "The demo appears in the upper left      " to tabl-demo (3).
Move "corner.  The middle shows a ruler, the  " to tabl-demo (4). 
Move "output, and the expected result.  The   " to tabl-demo (5). 
Move "output field is prepared with all 'X' to" to tabl-demo (6). 
Move "show where the size of the field ends.  " to tabl-demo (7). 
Move "Accept demos also show the field after  " to tabl-demo (8). 
Move "it is accepted.                         " to tabl-demo (9). 
Move space                                      to ws-expected.  
Perform dbd-display-before-demo thru dbd-exit. 
Perform dad-display-after-demo  thru dad-exit. 

0-exit. 
    Exit. 

*> Program finish. 

9-finish. 

stop run. 

9-exit. 
    Exit. 
