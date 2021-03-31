*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  frame2.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  frame2.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with frame2.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      frame2.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free frame2.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./frame2.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.03.31 Laszlo Erdos: 
*>            - frame.cob converted into frame2.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. frame2.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC
    COPY "CobjapiFunctions.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 COPY "CobjapiConstants.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-ICON                            BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-SCR-WIDTH                       BINARY-LONG.
 01 WS-SCR-HEIGHT                      BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-FONT                            BINARY-LONG.
 01 WS-FONTSTYLE                       BINARY-LONG.
 01 WS-FONTSIZE                        BINARY-LONG.
*> colors
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.

 01 WS-TEXT                            PIC X(30).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FRAME2 SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  Generate GUI Objects    
    MOVE J-FRAME("Frame2 Demo") TO WS-FRAME  

*>  set frame background color
    MOVE 064 TO WS-R
    MOVE 000 TO WS-G
    MOVE 064 TO WS-B
    MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET

*>  get screen data
    MOVE J-GETSCREENWIDTH()  TO WS-SCR-WIDTH
    MOVE J-GETSCREENHEIGHT() TO WS-SCR-HEIGHT

*>  set frame size    
    MOVE 640 TO WS-WIDTH 
    MOVE 400 TO WS-HEIGHT 
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET

*>  the frame position is in the middle of the screen
    COMPUTE WS-XPOS = (WS-SCR-WIDTH - WS-WIDTH) / 2
    COMPUTE WS-YPOS = (WS-SCR-HEIGHT - WS-HEIGHT) / 2
    MOVE J-SETPOS(WS-FRAME, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE "GnuCOBOL" TO WS-TEXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "50"       TO WS-FONTSIZE
    MOVE J-LABEL(WS-FRAME, WS-TEXT)                              TO WS-LABEL
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE 180 TO WS-XPOS
    MOVE 100 TO WS-YPOS
    MOVE J-SETPOS (WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE 255 TO WS-R
    MOVE 255 TO WS-G
    MOVE 255 TO WS-B
    MOVE J-SETCOLOR(WS-LABEL, WS-R, WS-G, WS-B) TO WS-RET

    MOVE J-LOADIMAGE("images/new.gif") TO WS-ICON  
    MOVE J-SETICON(WS-FRAME, WS-ICON)  TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-RET
       IF WS-RET = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FRAME2-EX.
    EXIT.
 END PROGRAM frame2.
