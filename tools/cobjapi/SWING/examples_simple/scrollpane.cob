*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  scrollpane.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  scrollpane.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with scrollpane.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      scrollpane.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free scrollpane.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./scrollpane.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - scrollpane.c converted into scrollpane.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. scrollpane.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-SCROLLPANE
    FUNCTION J-VSCROLLBAR
    FUNCTION J-HSCROLLBAR
    FUNCTION J-CANVAS
    FUNCTION J-SETSIZE
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-DRAWLINE
    FUNCTION J-NEXTACTION
    FUNCTION J-GETVIEWPORTWIDTH
    FUNCTION J-GETVIEWPORTHEIGHT
    FUNCTION J-GETVALUE
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-SCROLLPANE                      BINARY-INT.
 01 WS-VSCROLL                         BINARY-INT.
 01 WS-HSCROLL                         BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> FUNCTION ARGS 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-X-WIDTH                         BINARY-INT.
 01 WS-Y-HEIGHT                        BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-SCROLLPANE SECTION.
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
    MOVE J-FRAME("Scrollpane Demo")  TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE J-SCROLLPANE(WS-FRAME)      TO WS-SCROLLPANE
    MOVE J-VSCROLLBAR(WS-SCROLLPANE) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE) TO WS-HSCROLL
    
    MOVE 400 TO WS-WIDTH    
    MOVE 400 TO WS-HEIGHT
    MOVE J-CANVAS(WS-SCROLLPANE, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS
    
    MOVE 180 TO WS-WIDTH
    MOVE 150 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-SCROLLPANE, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

    PERFORM VARYING WS-X FROM 0 BY 10 UNTIL WS-X > 400
       MOVE 0 TO WS-Y
       MOVE 0 TO WS-WIDTH
       COMPUTE WS-HEIGHT = 400 - WS-X END-COMPUTE
       MOVE J-DRAWLINE(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET

       MOVE 400 TO WS-Y
       MOVE 400 TO WS-WIDTH
       COMPUTE WS-HEIGHT = 400 - WS-X END-COMPUTE
       MOVE J-DRAWLINE(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
    END-PERFORM    
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       IF WS-OBJ = WS-SCROLLPANE
       THEN
          MOVE J-GETVIEWPORTWIDTH(WS-SCROLLPANE)  TO WS-WIDTH
          MOVE J-GETVIEWPORTHEIGHT(WS-SCROLLPANE) TO WS-HEIGHT
       END-IF
       
       IF WS-OBJ = WS-HSCROLL
       THEN
          MOVE J-GETVALUE(WS-HSCROLL) TO WS-X
       END-IF
       
       IF WS-OBJ = WS-VSCROLL
       THEN
          MOVE J-GETVALUE(WS-VSCROLL) TO WS-Y
       END-IF
       
       COMPUTE WS-X-WIDTH  = WS-X + WS-WIDTH  END-COMPUTE
       COMPUTE WS-Y-HEIGHT = WS-Y + WS-HEIGHT END-COMPUTE

       DISPLAY "Viewport X = " WS-X ":" WS-X-WIDTH 
               "(Width  = " WS-WIDTH ")"  END-DISPLAY        
       DISPLAY "         Y = " WS-Y ":" WS-Y-HEIGHT 
               "(Height = " WS-HEIGHT ")" END-DISPLAY        
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-SCROLLPANE-EX.
    EXIT.
 END PROGRAM scrollpane.
