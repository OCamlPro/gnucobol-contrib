*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  mousebuttons.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  mousebuttons.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with mousebuttons.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      mousebuttons.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free mousebuttons.cob cobjapi.o \
*>                                              japilib.o \
*>                                              imageio.o \
*>                                              fileselect.o
*>
*> Usage:        ./mousebuttons.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - mousebuttons.c converted into mousebuttons.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. mousebuttons.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-MOUSELISTENER
    FUNCTION J-GETMOUSEBUTTON
    FUNCTION J-SETTEXT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-DCLICK                          BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-STR                             PIC X(256).
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-MOUSEBUTTONS SECTION.
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
    MOVE J-FRAME("Doubleclick the frame") TO WS-FRAME  
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE J-MOUSELISTENER(WS-FRAME, J-DOUBLECLICK) TO WS-DCLICK
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-DCLICK
       THEN
          IF J-GETMOUSEBUTTON(WS-DCLICK) = J-LEFT
          THEN
             MOVE J-SETTEXT(WS-FRAME, "Left Mousebutton")   TO WS-RET
          END-IF
          
          IF J-GETMOUSEBUTTON(WS-DCLICK) = J-CENTER
          THEN
             MOVE J-SETTEXT(WS-FRAME, "Middle Mousebutton") TO WS-RET
          END-IF
          
          IF J-GETMOUSEBUTTON(WS-DCLICK) = J-RIGHT
          THEN
             MOVE J-SETTEXT(WS-FRAME, "Right Mousebutton")  TO WS-RET
          END-IF
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-MOUSEBUTTONS-EX.
    EXIT.
 END PROGRAM mousebuttons.
