*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  colors.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  colors.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with colors.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      colors.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free colors.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./colors.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - colors.c converted into colors.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. colors.
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
    FUNCTION J-CANVAS
    FUNCTION J-SETPOS
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-GETACTION
    FUNCTION J-NEXTACTION
    FUNCTION J-SETCOLOR
    FUNCTION J-DRAWPIXEL
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
 01 WS-CANVAS                          BINARY-INT.
 01 WS-CALC                            BINARY-INT.
 01 WS-START                           BINARY-INT.
 01 WS-STOP                            BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT VALUE 255.
 01 WS-HEIGHT                          BINARY-INT VALUE 255.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-SUM-X-Y                         BINARY-INT.

*> vars
 01 WS-DO-WORK                         BINARY-INT VALUE 0.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-COLORS SECTION.
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
    MOVE J-FRAME("Colors")            TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Colors") TO WS-CALC
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    MOVE J-MENUITEM(WS-CALC, "Start") TO WS-START
    MOVE J-MENUITEM(WS-CALC, "Stop")  TO WS-STOP

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

    MOVE -1 TO WS-X
    MOVE -1 TO WS-Y
    
*>  Waiting for actions
    PERFORM FOREVER
       IF WS-DO-WORK = 1
       THEN
*>        returns the next event, or 0 if no event available       
          MOVE J-GETACTION()  TO WS-OBJ
       ELSE
*>        waits for the next event       
          MOVE J-NEXTACTION() TO WS-OBJ
       END-IF   

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-START) 
       THEN
          MOVE 1 TO WS-DO-WORK
       END-IF

       IF (WS-OBJ = WS-STOP) 
       THEN
          MOVE 0 TO WS-DO-WORK
       END-IF
       
       IF WS-DO-WORK = 1
       THEN
          COMPUTE WS-X = FUNCTION MOD(WS-X + 1, WS-WIDTH) END-COMPUTE
          
          IF WS-X = 0
          THEN 
             COMPUTE WS-Y = FUNCTION MOD(WS-Y + 1, WS-HEIGHT) END-COMPUTE
          END-IF

          IF (WS-X = WS-WIDTH - 1) AND (WS-Y = WS-HEIGHT - 1)          
          THEN
             MOVE 0 TO WS-DO-WORK
          ELSE
             COMPUTE WS-SUM-X-Y = WS-X + WS-Y END-COMPUTE
             MOVE J-SETCOLOR(WS-CANVAS, WS-X, WS-Y, WS-SUM-X-Y) TO WS-RET       
             MOVE J-DRAWPIXEL(WS-CANVAS, WS-X, WS-Y) TO WS-RET       
          END-IF
       END-IF   
       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-COLORS-EX.
    EXIT.
 END PROGRAM colors.
