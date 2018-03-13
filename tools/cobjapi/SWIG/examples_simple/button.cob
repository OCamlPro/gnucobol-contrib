*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  button.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  button.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with button.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      button.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free button.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./button.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - button.c converted into button.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. button.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-MENUBAR
    FUNCTION J-MENU
    FUNCTION J-MENUITEM    
    FUNCTION J-BUTTON
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-SYNC
    FUNCTION J-SETTEXT
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-BUTTON                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.

*> vars
 01 WS-BIG                             BINARY-INT.
 01 WS-IND                             BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-BUTTON SECTION.
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
    MOVE J-FRAME("Growing Button")      TO WS-FRAME  
                                       
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT

    MOVE J-BUTTON(WS-FRAME, "increase") TO WS-BUTTON
    MOVE 80 TO WS-WIDTH
    MOVE 20 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-BUTTON, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE  88 TO WS-XPOS
    MOVE 138 TO WS-YPOS
    MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS)     TO WS-RET

    MOVE 256 TO WS-WIDTH
    MOVE 256 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-BUTTON
       THEN
          IF WS-BIG NOT = 1
          THEN
             PERFORM VARYING WS-IND FROM 0 BY 1 UNTIL WS-IND > 40
                COMPUTE WS-WIDTH  = 80 + WS-IND * 2 END-COMPUTE
                COMPUTE WS-HEIGHT = 20 + WS-IND * 2 END-COMPUTE
                MOVE J-SETSIZE(WS-BUTTON, WS-WIDTH, WS-HEIGHT) TO WS-RET

                COMPUTE WS-XPOS   =  85 - WS-IND END-COMPUTE
                COMPUTE WS-YPOS   = 138 - WS-IND END-COMPUTE
                MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS)     TO WS-RET

                MOVE J-SYNC() TO WS-RET
             END-PERFORM
                
             MOVE 1 TO WS-BIG
             MOVE J-SETTEXT(WS-BUTTON, "shrink")          TO WS-RET
             MOVE J-SETTEXT(WS-FRAME, "Shrinking Button") TO WS-RET
          ELSE
             PERFORM VARYING WS-IND FROM 40 BY -1 UNTIL WS-IND = 0
                COMPUTE WS-WIDTH  = 80 + WS-IND * 2 END-COMPUTE
                COMPUTE WS-HEIGHT = 20 + WS-IND * 2 END-COMPUTE
                MOVE J-SETSIZE(WS-BUTTON, WS-WIDTH, WS-HEIGHT) TO WS-RET

                COMPUTE WS-XPOS   =  85 - WS-IND END-COMPUTE
                COMPUTE WS-YPOS   = 138 - WS-IND END-COMPUTE
                MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS)     TO WS-RET

                MOVE J-SYNC() TO WS-RET
             END-PERFORM
                
             MOVE 0 TO WS-BIG
             MOVE J-SETTEXT(WS-BUTTON, "increase")      TO WS-RET
             MOVE J-SETTEXT(WS-FRAME, "Growing Button") TO WS-RET
          END-IF
       END-IF

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-BUTTON-EX.
    EXIT.
 END PROGRAM button.
