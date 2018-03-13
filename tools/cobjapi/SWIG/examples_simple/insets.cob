*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  insets.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  insets.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with insets.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      insets.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free insets.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./insets.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - insets.c converted into insets.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. insets.
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
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-CANVAS
    FUNCTION J-SETNAMEDCOLOR
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-PACK
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-DRAWRECT
    FUNCTION J-DRAWLINE
    FUNCTION J-SETINSETS
    FUNCTION J-GETINSETS
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
 01 WS-INSETS                          BINARY-INT.
 01 WS-PLUS                            BINARY-INT.
 01 WS-MINUS                           BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-TOP                             BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
     
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-INSETS SECTION.
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
    MOVE J-FRAME("Insets Demo")               TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME)          TO WS-RET
                                       
    MOVE J-MENUBAR(WS-FRAME)                  TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")           TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")          TO WS-QUIT
    MOVE J-MENU(WS-MENUBAR, "Insets")         TO WS-INSETS
    MOVE J-MENUITEM(WS-INSETS, "Insets + 10") TO WS-PLUS
    MOVE J-MENUITEM(WS-INSETS, "Insets - 10") TO WS-MINUS

    MOVE 320 TO WS-WIDTH
    MOVE 240 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS
    MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-RED)       TO WS-RET

    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-CANVAS
       THEN
          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
          COMPUTE WS-WIDTH  = J-GETWIDTH(WS-CANVAS)  - 1
          COMPUTE WS-HEIGHT = J-GETHEIGHT(WS-CANVAS) - 1
          MOVE 0 TO WS-X
          MOVE 0 TO WS-Y
          MOVE J-DRAWRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
          MOVE J-DRAWLINE(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
          MOVE J-DRAWLINE(WS-CANVAS, WS-X, WS-HEIGHT, WS-WIDTH, WS-Y) TO WS-RET
       END-IF

       IF WS-OBJ = WS-PLUS
       THEN
          COMPUTE WS-TOP    = J-GETINSETS(WS-FRAME, J-TOP)    + 10 END-COMPUTE
          COMPUTE WS-BOTTOM = J-GETINSETS(WS-FRAME, J-BOTTOM) + 10 END-COMPUTE 
          COMPUTE WS-LEFT   = J-GETINSETS(WS-FRAME, J-LEFT)   + 10 END-COMPUTE
          COMPUTE WS-RIGHT  = J-GETINSETS(WS-FRAME, J-RIGHT)  + 10 END-COMPUTE
          MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET            
       END-IF

       IF WS-OBJ = WS-MINUS
       THEN
          COMPUTE WS-TOP    = J-GETINSETS(WS-FRAME, J-TOP)    - 10 END-COMPUTE
          COMPUTE WS-BOTTOM = J-GETINSETS(WS-FRAME, J-BOTTOM) - 10 END-COMPUTE 
          COMPUTE WS-LEFT   = J-GETINSETS(WS-FRAME, J-LEFT)   - 10 END-COMPUTE
          COMPUTE WS-RIGHT  = J-GETINSETS(WS-FRAME, J-RIGHT)  - 10 END-COMPUTE
          MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET            
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-INSETS-EX.
    EXIT.
 END PROGRAM insets.
