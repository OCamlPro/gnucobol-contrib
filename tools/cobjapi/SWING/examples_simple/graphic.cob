*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  graphic.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  graphic.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with graphic.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      graphic.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free graphic.cob cobjapi.o \
*>                                         japilib.o \
*>                                         imageio.o \
*>                                         fileselect.o
*>
*> Usage:        ./graphic.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - graphic.c converted into graphic.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. graphic.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-CANVAS
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-SETNAMEDCOLOR
    FUNCTION J-CLIPRECT
    FUNCTION J-TRANSLATE
    FUNCTION J-DRAWSTRING
    FUNCTION J-DRAWLINE
    FUNCTION J-DRAWPOLYGON
    FUNCTION J-DRAWRECT
    FUNCTION J-DRAWROUNDRECT
    FUNCTION J-DRAWCIRCLE
    FUNCTION J-DRAWOVAL
    FUNCTION J-DRAWARC
    FUNCTION J-DRAWPOLYLINE
    FUNCTION J-FILLPOLYGON
    FUNCTION J-FILLRECT
    FUNCTION J-FILLROUNDRECT
    FUNCTION J-FILLCIRCLE
    FUNCTION J-FILLOVAL
    FUNCTION J-FILLARC
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-RX                              BINARY-INT.
 01 WS-RY                              BINARY-INT.
 01 WS-ARC1                            BINARY-INT.
 01 WS-ARC2                            BINARY-INT.
 01 WS-X1                              BINARY-INT.
 01 WS-Y1                              BINARY-INT.
 01 WS-X2                              BINARY-INT.
 01 WS-Y2                              BINARY-INT.
 01 WS-ARCX                            BINARY-INT.
 01 WS-ARCY                            BINARY-INT.
*> Polygon 
 01 WS-POLYGON-LEN                     BINARY-INT VALUE 10.
 01 WS-POLYGON-X-VALUES.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  20.
   02 FILLER                           BINARY-INT VALUE  30.
   02 FILLER                           BINARY-INT VALUE  40.
   02 FILLER                           BINARY-INT VALUE  50.
   02 FILLER                           BINARY-INT VALUE  60.
   02 FILLER                           BINARY-INT VALUE  70.
   02 FILLER                           BINARY-INT VALUE  80.
   02 FILLER                           BINARY-INT VALUE  90.
   02 FILLER                           BINARY-INT VALUE 100.
 01 WS-POLYGON-X REDEFINES WS-POLYGON-X-VALUES.
   02 WS-POLYGON-X-LINES OCCURS 10 TIMES.
     03 WS-POLYGON-X-LINE              BINARY-INT.
 01 WS-POLYGON-Y-VALUES.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  90.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  90.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  90.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  90.
   02 FILLER                           BINARY-INT VALUE  10.
   02 FILLER                           BINARY-INT VALUE  90.
 01 WS-POLYGON-Y REDEFINES WS-POLYGON-Y-VALUES.
   02 WS-POLYGON-Y-LINES OCCURS 10 TIMES.
     03 WS-POLYGON-Y-LINE              BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-GRAPHIC SECTION.
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
    MOVE J-FRAME("Graphic primitives") TO WS-FRAME  
    MOVE 730 TO WS-WIDTH
    MOVE 260 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE 710 TO WS-WIDTH
    MOVE 230 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-CANVAS  
    
    MOVE 10 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)    TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET
    
    MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-BLUE) TO WS-RET

*>  This is only for test!    
*>  MOVE  30 TO WS-X
*>  MOVE  30 TO WS-Y
*>  MOVE 170 TO WS-WIDTH
*>  MOVE 170 TO WS-HEIGHT
*>  MOVE J-CLIPRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
*>  Normal graphic primitives

*>  Line
    MOVE  10 TO WS-X
    MOVE  10 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  10 TO WS-X1
    MOVE  10 TO WS-Y1
    MOVE  90 TO WS-X2
    MOVE  90 TO WS-Y2
    MOVE J-DRAWLINE(WS-CANVAS, WS-X1, WS-Y1, WS-X2, WS-Y2) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Line") TO WS-RET
    
*>  Polygon
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE J-DRAWPOLYGON(WS-CANVAS, WS-POLYGON-LEN, 
                                  WS-POLYGON-X, WS-POLYGON-Y) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Polygon") TO WS-RET
    
*>  Rectangle
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  10 TO WS-X
    MOVE  10 TO WS-Y
    MOVE  80 TO WS-WIDTH
    MOVE  80 TO WS-HEIGHT
    MOVE J-DRAWRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Rectangle") TO WS-RET

*>  RoundRect
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  10 TO WS-X
    MOVE  10 TO WS-Y
    MOVE  80 TO WS-WIDTH
    MOVE  80 TO WS-HEIGHT
    MOVE  20 TO WS-ARCX
    MOVE  20 TO WS-ARCY
    MOVE J-DRAWROUNDRECT(WS-CANVAS, WS-X, WS-Y, 
                                    WS-WIDTH, WS-HEIGHT, 
                                    WS-ARCX, WS-ARCY) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "RoundRect") TO WS-RET

*>  Circle
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-R
    MOVE J-DRAWCIRCLE(WS-CANVAS, WS-X, WS-Y, WS-R) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Circle") TO WS-RET

*>  Oval
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-RX
    MOVE  20 TO WS-RY
    MOVE J-DRAWOVAL(WS-CANVAS, WS-X, WS-Y, WS-RX, WS-RY) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Oval") TO WS-RET

*>  Arc
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-RX
    MOVE  30 TO WS-RY
    MOVE 113 TO WS-ARC1
    MOVE 370 TO WS-ARC2
    MOVE J-DRAWARC(WS-CANVAS, WS-X, WS-Y, 
                              WS-RX, WS-RY, 
                              WS-ARC1, WS-ARC2) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Arc") TO WS-RET
    
*>  Filled graphic primitives

*>  Polyline
    MOVE -600 TO WS-X
    MOVE  100 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE J-DRAWPOLYLINE(WS-CANVAS, WS-POLYGON-LEN, 
                                   WS-POLYGON-X, WS-POLYGON-Y) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "Polyline") TO WS-RET
    
*>  FillPolygon
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE J-FILLPOLYGON(WS-CANVAS, WS-POLYGON-LEN, 
                                  WS-POLYGON-X, WS-POLYGON-Y) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillPolygon") TO WS-RET

*>  FillRectangle
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  10 TO WS-X
    MOVE  10 TO WS-Y
    MOVE  80 TO WS-WIDTH
    MOVE  80 TO WS-HEIGHT
    MOVE J-FILLRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillRectangle") TO WS-RET

*>  FillRoundRect
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  10 TO WS-X
    MOVE  10 TO WS-Y
    MOVE  80 TO WS-WIDTH
    MOVE  80 TO WS-HEIGHT
    MOVE  20 TO WS-ARCX
    MOVE  20 TO WS-ARCY
    MOVE J-FILLROUNDRECT(WS-CANVAS, WS-X, WS-Y, 
                                    WS-WIDTH, WS-HEIGHT, 
                                    WS-ARCX, WS-ARCY) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillRoundRect") TO WS-RET

*>  FillCircle
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-R
    MOVE J-FILLCIRCLE(WS-CANVAS, WS-X, WS-Y, WS-R) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillCircle") TO WS-RET

*>  FillOval
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-RX
    MOVE  20 TO WS-RY
    MOVE J-FILLOVAL(WS-CANVAS, WS-X, WS-Y, WS-RX, WS-RY) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillOval") TO WS-RET

*>  FillArc
    MOVE 100 TO WS-X
    MOVE   0 TO WS-Y
    MOVE J-TRANSLATE(WS-CANVAS, WS-X, WS-Y) TO WS-RET
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE  40 TO WS-RX
    MOVE  30 TO WS-RY
    MOVE 113 TO WS-ARC1
    MOVE 370 TO WS-ARC2
    MOVE J-FILLARC(WS-CANVAS, WS-X, WS-Y, 
                              WS-RX, WS-RY, 
                              WS-ARC1, WS-ARC2) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 105 TO WS-Y
    MOVE J-DRAWSTRING(WS-CANVAS, WS-X, WS-Y, "FillArc") TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-GRAPHIC-EX.
    EXIT.
 END PROGRAM graphic.
