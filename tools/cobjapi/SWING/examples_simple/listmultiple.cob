*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  listmultiple.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  listmultiple.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with listmultiple.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      listmultiple.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free listmultiple.cob cobjapi.o \
*>                                              japilib.o \
*>                                              imageio.o \
*>                                              fileselect.o
*>
*> Usage:        ./listmultiple.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - listmultiple.c converted into listmultiple.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. listmultiple.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-LIST
    FUNCTION J-ADDITEM
    FUNCTION J-SETPOS
    FUNCTION J-SELECT
    FUNCTION J-MULTIPLEMODE
    FUNCTION J-SETCOLORBG
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-SETCOLOR
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-ISSELECT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-LIST                            BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-ROWS                            BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-ITEM                            BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-G                               BINARY-INT.
 01 WS-B                               BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-LISTMULTIPLE SECTION.
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
    MOVE J-FRAME("select one or more colors") TO WS-FRAME  
                                       
    MOVE 3 TO WS-ROWS                                   
    MOVE J-LIST(WS-FRAME, WS-ROWS) TO WS-LIST

    MOVE J-ADDITEM(WS-LIST, "Red")     TO WS-RET
    MOVE J-ADDITEM(WS-LIST, "Green")   TO WS-RET
    MOVE J-ADDITEM(WS-LIST, "Blue")    TO WS-RET
    
    MOVE 130 TO WS-XPOS
    MOVE 100 TO WS-YPOS
    MOVE J-SETPOS(WS-LIST, WS-XPOS, WS-YPOS) TO WS-RET

*>  Makes the given items pre-selected for the LIST.    
    MOVE J-MULTIPLEMODE(WS-LIST, J-TRUE) TO WS-RET
    MOVE 0 TO WS-ITEM
    MOVE J-SELECT(WS-LIST, WS-ITEM) TO WS-RET
    MOVE 1 TO WS-ITEM
    MOVE J-SELECT(WS-LIST, WS-ITEM) TO WS-RET

    MOVE 255 TO WS-R    
    MOVE 255 TO WS-G    
    MOVE   0 TO WS-B    
    MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-LIST, J-WHITE)      TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-LIST
       THEN
          MOVE 0 TO WS-ITEM
          IF J-ISSELECT(WS-LIST, WS-ITEM) = J-TRUE
          THEN
             MOVE 255 TO WS-R
          ELSE
             MOVE   0 TO WS-R
          END-IF
          
          MOVE 1 TO WS-ITEM
          IF J-ISSELECT(WS-LIST, WS-ITEM) = J-TRUE
          THEN
             MOVE 255 TO WS-G
          ELSE
             MOVE   0 TO WS-G
          END-IF

          MOVE 2 TO WS-ITEM
          IF J-ISSELECT(WS-LIST, WS-ITEM) = J-TRUE
          THEN
             MOVE 255 TO WS-B
          ELSE
             MOVE   0 TO WS-B
          END-IF

          MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
       END-IF

       IF WS-R = 0 AND WS-G = 0
       THEN
          MOVE 255 TO WS-R    
          MOVE 255 TO WS-G    
          MOVE 255 TO WS-B    
          MOVE J-SETCOLOR(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
       ELSE
          MOVE   0 TO WS-R    
          MOVE   0 TO WS-G    
          MOVE   0 TO WS-B    
          MOVE J-SETCOLOR(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
       END-IF

       MOVE J-SETNAMEDCOLORBG(WS-LIST, J-WHITE) TO WS-RET
       
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-LISTMULTIPLE-EX.
    EXIT.
 END PROGRAM listmultiple.
