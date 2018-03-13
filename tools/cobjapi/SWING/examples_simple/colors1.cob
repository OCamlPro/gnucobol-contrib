*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  colors1.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  colors1.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with colors1.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      colors1.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free colors1.cob cobjapi.o \
*>                                         japilib.o \
*>                                         imageio.o \
*>                                         fileselect.o
*>
*> Usage:        ./colors1.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - colors1.c converted into colors1.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. colors1.
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
    FUNCTION J-SETNAMEDCOLOR
    FUNCTION J-FILLRECT
    FUNCTION J-SETCOLOR
    FUNCTION J-DRAWIMAGESOURCE
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
 01 WS-CLEAR                           BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT VALUE 256.
 01 WS-HEIGHT                          BINARY-INT VALUE 256.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.

*> vars
 01 WS-IND                             BINARY-INT.

*> R-TAB = WIDTH * HEIGHT ==> 65536 = 256 * 256 
 01 WS-R-TAB.
   02 WS-R-TAB-LINES OCCURS 65536 TIMES.
     03 WS-R-TAB-LINE                  BINARY-INT.
 
*> G-TAB = WIDTH * HEIGHT ==> 65536 = 256 * 256 
 01 WS-G-TAB.
   02 WS-G-TAB-LINES OCCURS 65536 TIMES.
     03 WS-G-TAB-LINE                  BINARY-INT.

*> B-TAB = WIDTH * HEIGHT ==> 65536 = 256 * 256 
 01 WS-B-TAB.
   02 WS-B-TAB-LINES OCCURS 65536 TIMES.
     03 WS-B-TAB-LINE                  BINARY-INT.
     
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-COLORS1 SECTION.
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
    MOVE J-FRAME("Colors1")           TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Colors") TO WS-CALC
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    MOVE J-MENUITEM(WS-CALC, "Start") TO WS-START
    MOVE J-MENUITEM(WS-CALC, "Clear") TO WS-CLEAR

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
*>     waits for the next event       
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-CLEAR) 
       THEN
          MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-WHITE) TO WS-RET
          MOVE 0 TO WS-X
          MOVE 0 TO WS-Y
          MOVE J-FILLRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-START 
       THEN
          PERFORM VARYING WS-Y FROM 0 BY 1 UNTIL WS-Y > WS-HEIGHT - 1
             PERFORM VARYING WS-X FROM 0 BY 1 UNTIL WS-X > WS-WIDTH - 1
                COMPUTE WS-IND = WS-Y * WS-WIDTH + WS-X + 1 END-COMPUTE

                MOVE WS-X TO WS-R-TAB-LINE(WS-IND)
                MOVE WS-Y TO WS-G-TAB-LINE(WS-IND)
                COMPUTE WS-B-TAB-LINE(WS-IND) 
                      = FUNCTION MOD(WS-X + WS-Y, 256) END-COMPUTE
             END-PERFORM
          END-PERFORM

          MOVE 0 TO WS-XPOS
          MOVE 0 TO WS-YPOS
          MOVE J-DRAWIMAGESOURCE(WS-CANVAS, WS-XPOS, WS-YPOS, 
                                 WS-WIDTH, WS-HEIGHT,
                                 WS-R-TAB, WS-G-TAB, WS-B-TAB) TO WS-RET
       END-IF   
       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-COLORS1-EX.
    EXIT.
 END PROGRAM colors1.
