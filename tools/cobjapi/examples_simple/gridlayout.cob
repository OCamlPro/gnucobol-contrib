*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  gridlayout.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  gridlayout.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with gridlayout.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      gridlayout.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free gridlayout.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./gridlayout.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - gridlayout.c converted into gridlayout.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. gridlayout.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETGRIDLAYOUT
    FUNCTION J-GETLAYOUTID
    FUNCTION J-BUTTON
    FUNCTION J-SETHGAP
    FUNCTION J-SETVGAP    
    FUNCTION J-SETSIZE
    FUNCTION J-PACK
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-SETROWS
    FUNCTION J-GETROWS
    FUNCTION J-SETCOLUMNS
    FUNCTION J-GETCOLUMNS
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-GRID                            BINARY-INT.
 01 WS-BUTTON-1                        BINARY-INT.
 01 WS-BUTTON-2                        BINARY-INT.
 01 WS-BUTTON-3                        BINARY-INT.
 01 WS-BUTTON-4                        BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 01 WS-VGAP                            BINARY-INT.

*> vars
 01 WS-ROW-DISP                        PIC 9(4).
 01 WS-COL-DISP                        PIC 9(4).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-GRIDLAYOUT SECTION.
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
    MOVE J-FRAME("Grid Layout Demo") TO WS-FRAME  
    
    MOVE 2 TO WS-ROW
    MOVE 2 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET
    MOVE J-GETLAYOUTID(WS-FRAME)                   TO WS-GRID
                               
    MOVE J-BUTTON(WS-FRAME, "button1") TO WS-BUTTON-1
    MOVE J-BUTTON(WS-FRAME, "button2") TO WS-BUTTON-2
    MOVE J-BUTTON(WS-FRAME, "button3") TO WS-BUTTON-3
    MOVE J-BUTTON(WS-FRAME, "button4") TO WS-BUTTON-4

    MOVE 20 TO WS-HGAP
    MOVE J-SETHGAP(WS-FRAME, WS-HGAP)  TO WS-RET
    MOVE  5 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP)  TO WS-RET
    
    MOVE 200 TO WS-WIDTH
    MOVE 100 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-BUTTON-1, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-BUTTON-1
       THEN
          MOVE 4 TO WS-ROW
          MOVE J-SETROWS(WS-GRID, WS-ROW)    TO WS-RET
          MOVE 1 TO WS-COL
          MOVE J-SETCOLUMNS(WS-GRID, WS-COL) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-BUTTON-2
       THEN
          MOVE 1 TO WS-ROW
          MOVE J-SETROWS(WS-GRID, WS-ROW)    TO WS-RET
          MOVE 4 TO WS-COL
          MOVE J-SETCOLUMNS(WS-GRID, WS-COL) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-BUTTON-3
       THEN
          MOVE 3 TO WS-ROW
          MOVE J-SETROWS(WS-GRID, WS-ROW)    TO WS-RET
          MOVE 1 TO WS-COL
          MOVE J-SETCOLUMNS(WS-GRID, WS-COL) TO WS-RET
       END-IF

       IF WS-OBJ = WS-BUTTON-4
       THEN
          MOVE 2 TO WS-ROW
          MOVE J-SETROWS(WS-GRID, WS-ROW)    TO WS-RET
          MOVE 2 TO WS-COL
          MOVE J-SETCOLUMNS(WS-GRID, WS-COL) TO WS-RET
       END-IF
       
       MOVE J-PACK(WS-FRAME) TO WS-RET
       MOVE J-GETROWS(WS-GRID, WS-ROW)    TO WS-ROW-DISP
       MOVE J-GETCOLUMNS(WS-GRID, WS-COL) TO WS-COL-DISP
       DISPLAY "row: " WS-ROW-DISP " col: " WS-COL-DISP
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-GRIDLAYOUT-EX.
    EXIT.
 END PROGRAM gridlayout.
