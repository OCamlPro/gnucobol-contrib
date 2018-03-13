*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  checkbox.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  checkbox.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with checkbox.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      checkbox.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free checkbox.cob cobjapi.o \
*>                                          japilib.o \
*>                                          imageio.o \
*>                                          fileselect.o
*>
*> Usage:        ./checkbox.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - checkbox.c converted into checkbox.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. checkbox.
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
    FUNCTION J-CHECKBOX
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-SETSTATE
    FUNCTION J-GETSTATE
    FUNCTION J-SETCOLORBG
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
 01 WS-OBJ                             BINARY-INT.
*> checkbox
 01 WS-BLUE                            BINARY-INT.
 01 WS-RED                             BINARY-INT.
 01 WS-GREEN                           BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-G                               BINARY-INT.
 01 WS-B                               BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-CHECKBOX SECTION.
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
    MOVE J-FRAME("switch the colors On/Off") TO WS-FRAME  
                                       
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    
    MOVE J-CHECKBOX(WS-FRAME, "Red") TO WS-RED
    MOVE 150 TO WS-XPOS
    MOVE  80 TO WS-YPOS
    MOVE J-SETPOS(WS-RED, WS-XPOS, WS-YPOS)   TO WS-RET
    MOVE J-SETSTATE(WS-RED, J-TRUE)           TO WS-RET
    MOVE 255 TO WS-R

    MOVE J-CHECKBOX(WS-FRAME, "Green") TO WS-GREEN
    MOVE 150 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-GREEN, WS-XPOS, WS-YPOS) TO WS-RET
    MOVE J-SETSTATE(WS-GREEN, J-FALSE)        TO WS-RET
    MOVE 0 TO WS-G

    MOVE J-CHECKBOX(WS-FRAME, "Blue") TO WS-BLUE
    MOVE 150 TO WS-XPOS
    MOVE 160 TO WS-YPOS
    MOVE J-SETPOS(WS-BLUE, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE J-SETSTATE(WS-BLUE, J-FALSE)         TO WS-RET
    MOVE 0 TO WS-B
    
    MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-RED
       THEN
          MOVE J-GETSTATE(WS-RED) TO WS-RET
          IF WS-RET = J-TRUE
          THEN
             MOVE 255 TO WS-R
          ELSE
             MOVE   0 TO WS-R
          END-IF
       END-IF

       IF WS-OBJ = WS-GREEN
       THEN
          MOVE J-GETSTATE(WS-GREEN) TO WS-RET
          IF WS-RET = J-TRUE
          THEN
             MOVE 255 TO WS-G
          ELSE
             MOVE   0 TO WS-G
          END-IF
       END-IF

       IF WS-OBJ = WS-BLUE
       THEN
          MOVE J-GETSTATE(WS-BLUE) TO WS-RET
          IF WS-RET = J-TRUE
          THEN
             MOVE 255 TO WS-B
          ELSE
             MOVE   0 TO WS-B
          END-IF
       END-IF
       
       MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-CHECKBOX-EX.
    EXIT.
 END PROGRAM checkbox.
