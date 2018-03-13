*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  canvas.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  canvas.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with canvas.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      canvas.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free canvas.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./canvas.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - canvas.c converted into canvas.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. canvas.
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
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-SETCOLOR
    FUNCTION J-DRAWPIXEL
    FUNCTION J-RANDOM
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-GETACTION
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
 01 WS-CANVAS                          BINARY-INT.
 01 WS-CALC                            BINARY-INT.
 01 WS-START                           BINARY-INT.
 01 WS-STOP                            BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-G                               BINARY-INT.
 01 WS-B                               BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.

*> vars
 01 WS-DO-WORK                         BINARY-INT VALUE 0.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-CANVAS SECTION.
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
    MOVE J-FRAME(" ")                 TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Calc")   TO WS-CALC
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    MOVE J-MENUITEM(WS-CALC, "Start") TO WS-START
    MOVE J-MENUITEM(WS-CALC, "Stop")  TO WS-STOP

    MOVE 256 TO WS-WIDTH
    MOVE 256 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-YELLOW)  TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

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
          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-YELLOW) TO WS-RET
       END-IF

       IF (WS-OBJ = WS-STOP) 
       THEN
          MOVE 0 TO WS-DO-WORK
       END-IF
       
       IF WS-DO-WORK = 1
       THEN
*>        random color       
          MOVE J-RANDOM() TO WS-R
          COMPUTE WS-R = FUNCTION MOD(WS-R, 256) END-COMPUTE
          MOVE J-RANDOM() TO WS-G
          COMPUTE WS-G = FUNCTION MOD(WS-G, 256) END-COMPUTE
          MOVE J-RANDOM() TO WS-B
          COMPUTE WS-B = FUNCTION MOD(WS-B, 256) END-COMPUTE

          MOVE J-SETCOLOR(WS-CANVAS, WS-R, WS-G, WS-B) TO WS-RET       

*>        random position          
          MOVE J-RANDOM() TO WS-X
          COMPUTE WS-X = FUNCTION MOD(WS-X, 256) END-COMPUTE
          MOVE J-RANDOM() TO WS-Y
          COMPUTE WS-Y = FUNCTION MOD(WS-Y, 256) END-COMPUTE

          MOVE J-DRAWPIXEL(WS-CANVAS, WS-X, WS-Y) TO WS-RET       
       END-IF   
       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-CANVAS-EX.
    EXIT.
 END PROGRAM canvas.
