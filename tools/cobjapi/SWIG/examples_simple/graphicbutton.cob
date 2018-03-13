*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  graphicbutton.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  graphicbutton.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with graphicbutton.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      graphicbutton.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free graphicbutton.cob cobjapi.o \
*>                                               japilib.o \
*>                                               imageio.o \
*>                                               fileselect.o
*>
*> Usage:        ./graphicbutton.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - graphicbutton.c converted into graphicbutton.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. graphicbutton.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETFLOWLAYOUT
    FUNCTION J-SETINSETS
    FUNCTION J-SETHGAP
    FUNCTION J-SETVGAP
    FUNCTION J-GRAPHICBUTTON
    FUNCTION J-SETIMAGE
    FUNCTION J-LOADIMAGE
    FUNCTION J-DISABLE
    FUNCTION J-ENABLE
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-FIRST                           BINARY-INT.
 01 WS-GBUTTON                         BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 01 WS-VGAP                            BINARY-INT.
 01 WS-TOP                             BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-GRAPHICBUTTON SECTION.
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
    MOVE J-FRAME("Graphic Buttons") TO WS-FRAME  
                                       
    MOVE J-SETFLOWLAYOUT(WS-FRAME, J-HORIZONTAL) TO WS-RET
    MOVE 30 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
    MOVE 10 TO WS-HGAP
    MOVE J-SETHGAP(WS-FRAME, WS-HGAP) TO WS-RET    
    MOVE 10 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP) TO WS-RET    
    
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/open.gif") TO WS-FIRST
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/new.gif")  TO WS-GBUTTON
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/save.gif") TO WS-GBUTTON
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/cut.gif")  TO WS-GBUTTON
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/copy.gif") TO WS-GBUTTON
    MOVE J-GRAPHICBUTTON(WS-FRAME, "images/open.gif") TO WS-GBUTTON

*>  overwrite last button, and disable    
    MOVE J-SETIMAGE(WS-GBUTTON, J-LOADIMAGE("images/paste.gif")) TO WS-RET
    MOVE J-DISABLE(WS-GBUTTON) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-FIRST
       THEN
*>        enable last button       
          MOVE J-ENABLE(WS-GBUTTON) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-GRAPHICBUTTON-EX.
    EXIT.
 END PROGRAM graphicbutton.
