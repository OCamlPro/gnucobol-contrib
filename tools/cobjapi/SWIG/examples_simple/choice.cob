*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  choice.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  choice.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with choice.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      choice.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free choice.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./choice.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - choice.c converted into choice.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. choice.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-CHOICE
    FUNCTION J-ADDITEM
    FUNCTION J-SETPOS
    FUNCTION J-SELECT
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-GETSELECT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CHOICE                          BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-ITEM                            BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-CHOICE SECTION.
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
    MOVE J-FRAME("select a color") TO WS-FRAME  
                                       
    MOVE J-CHOICE(WS-FRAME) TO WS-CHOICE

    MOVE J-ADDITEM(WS-CHOICE, "Red")     TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Green")   TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Blue")    TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Yellow")  TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "White")   TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Black")   TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Magenta") TO WS-RET
    MOVE J-ADDITEM(WS-CHOICE, "Orange")  TO WS-RET
    
    MOVE 150 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-CHOICE, WS-XPOS, WS-YPOS) TO WS-RET

*>  Makes the given item the selected one for the choice.    
    MOVE 3 TO WS-ITEM
    MOVE J-SELECT(WS-CHOICE, WS-ITEM) TO WS-RET
    
    MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-YELLOW) TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-CHOICE, J-WHITE) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-CHOICE
       THEN
          MOVE J-GETSELECT(WS-CHOICE) TO WS-ITEM

          EVALUATE WS-ITEM
             WHEN 0 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-RED)     TO WS-RET
             WHEN 1 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-GREEN)   TO WS-RET
             WHEN 2 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-BLUE)    TO WS-RET
             WHEN 3 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-YELLOW)  TO WS-RET
             WHEN 4 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-WHITE)   TO WS-RET
             WHEN 5 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-BLACK)   TO WS-RET
             WHEN 6 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-MAGENTA) TO WS-RET
             WHEN 7 MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-ORANGE)  TO WS-RET
          END-EVALUATE      
          
          MOVE J-SETNAMEDCOLORBG(WS-CHOICE, J-WHITE) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-CHOICE-EX.
    EXIT.
 END PROGRAM choice.
