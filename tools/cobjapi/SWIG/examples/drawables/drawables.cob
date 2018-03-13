*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  drawables.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  drawables.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with drawables.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      drawables.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.06.07
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free drawables.cob cobjapi.o \
*>                                           japilib.o \
*>                                           imageio.o \
*>                                           fileselect.o
*>
*> Usage:        ./drawables.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.06.07 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - drawables.c converted into drawables.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. drawables.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*>  drawgraphics function
    FUNCTION FN-DRAWGRAPHICS
*>  Functions for the cobjapi wrapper 
    COPY "cobjapifn.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-PRINT                           BINARY-INT.
 01 WS-SAVE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-PRINTER                         BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-IMAGE                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-X-MIN                           BINARY-INT.
 01 WS-Y-MIN                           BINARY-INT.
 01 WS-X-MAX                           BINARY-INT.
 01 WS-Y-MAX                           BINARY-INT.
 01 WS-MSEC                            BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-DRAWABLES SECTION.
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
    MOVE J-FRAME("Drawables demo, please resize the window") TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME)  TO WS-RET
    
    MOVE J-MENUBAR(WS-FRAME)             TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")      TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Print")    TO WS-PRINT
    MOVE J-MENUITEM(WS-FILE, "Save BMP") TO WS-SAVE
    MOVE J-MENUITEM(WS-FILE, "Quit")     TO WS-QUIT
    
    MOVE 400 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS

    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
    MOVE 0 TO WS-X-MIN
    MOVE 0 TO WS-Y-MIN
    MOVE J-GETWIDTH(WS-CANVAS)  TO WS-X-MAX
    MOVE J-GETHEIGHT(WS-CANVAS) TO WS-Y-MAX
    MOVE FN-DRAWGRAPHICS(WS-CANVAS, WS-X-MIN, WS-Y-MIN, 
                                    WS-X-MAX, WS-Y-MAX) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-CANVAS) 
       THEN
          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
          MOVE 10 TO WS-X-MIN
          MOVE 10 TO WS-Y-MIN
          COMPUTE WS-X-MAX = J-GETWIDTH(WS-CANVAS)  - 10 END-COMPUTE
          COMPUTE WS-Y-MAX = J-GETHEIGHT(WS-CANVAS) - 10 END-COMPUTE 
          MOVE FN-DRAWGRAPHICS(WS-CANVAS, WS-X-MIN, WS-Y-MIN, 
                                          WS-X-MAX, WS-Y-MAX) TO WS-RET
*>        after hide and show will be the canvas by op. system redraw
          MOVE J-HIDE(WS-CANVAS) TO WS-RET
          MOVE J-SYNC() TO WS-RET
          MOVE 2 TO WS-MSEC
          MOVE J-SLEEP(WS-MSEC)  TO WS-RET
          MOVE J-SHOW(WS-CANVAS) TO WS-RET
       END-IF

       IF (WS-OBJ = WS-PRINT) 
       THEN
          MOVE J-PRINTER(WS-FRAME) TO WS-PRINTER
          IF WS-PRINTER > 0
          THEN
             MOVE 40 TO WS-X-MIN
             MOVE 40 TO WS-Y-MIN
             COMPUTE WS-X-MAX = J-GETWIDTH(WS-PRINTER)  - 80 END-COMPUTE
             COMPUTE WS-Y-MAX = J-GETHEIGHT(WS-PRINTER) - 80 END-COMPUTE 
             MOVE FN-DRAWGRAPHICS(WS-PRINTER, WS-X-MIN, WS-Y-MIN, 
                                              WS-X-MAX, WS-Y-MAX) TO WS-RET
 
             MOVE J-PRINT(WS-PRINTER)   TO WS-RET
             MOVE J-DISPOSE(WS-PRINTER) TO WS-RET          
          END-IF
       END-IF
       
       IF (WS-OBJ = WS-SAVE) 
       THEN
          MOVE 600 TO WS-X-MAX
          MOVE 800 TO WS-Y-MAX
          MOVE J-IMAGE(WS-X-MAX, WS-Y-MAX) TO WS-IMAGE
          
          MOVE   0 TO WS-X-MIN
          MOVE   0 TO WS-Y-MIN
          MOVE 600 TO WS-X-MAX
          MOVE 800 TO WS-Y-MAX
          MOVE FN-DRAWGRAPHICS(WS-IMAGE, WS-X-MIN, WS-Y-MIN, 
                                         WS-X-MAX, WS-Y-MAX) TO WS-RET
*>        save image in a BMP file
          MOVE J-SAVEIMAGE(WS-IMAGE, "test.bmp", J-BMP) TO WS-RET
          IF WS-RET = 0
          THEN
             MOVE J-ALERTBOX(WS-FRAME, "Problems", "Can't save image", "OK")
               TO WS-RET
          END-IF
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-DRAWABLES-EX.
    EXIT.
 END PROGRAM drawables.

*>------------------------------------------------------------------------------
 IDENTIFICATION DIVISION.
 FUNCTION-ID. FN-DRAWGRAPHICS.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*>  Functions for the cobjapi wrapper 
    COPY "cobjapifn.cpy".
 
 DATA DIVISION.
 
 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> function args 
 01 WS-IMAGE                           BINARY-INT.
 01 WS-FONT-SIZE                       BINARY-INT VALUE 10.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-X-MIN                           BINARY-INT.
 01 WS-Y-MIN                           BINARY-INT.
 01 WS-X-MAX                           BINARY-INT.
 01 WS-Y-MAX                           BINARY-INT.
 01 WS-RX                              BINARY-INT.
 01 WS-RY                              BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-TARGET-X                        BINARY-INT.
 01 WS-TARGET-Y                        BINARY-INT.
 01 WS-TARGET-WIDTH                    BINARY-INT.
 01 WS-TARGET-HEIGHT                   BINARY-INT.
 
 01 WS-TMP-STRING                      PIC X(256). 
 01 WS-STRING                          PIC X(14) VALUE "JAPI Test Text".
 
 01 WS-IND                             BINARY-INT.
 01 WS-NUM-DISP                        PIC Z(9)9.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 LINKAGE SECTION.
 01 LNK-DRAWABLE                       BINARY-INT.
 01 LNK-X-MIN                          BINARY-INT.
 01 LNK-Y-MIN                          BINARY-INT.
 01 LNK-X-MAX                          BINARY-INT.
 01 LNK-Y-MAX                          BINARY-INT.
 01 LNK-RET                            BINARY-INT.
 
 PROCEDURE DIVISION USING BY VALUE     LNK-DRAWABLE
                          BY VALUE     LNK-X-MIN
                          BY VALUE     LNK-Y-MIN
                          BY VALUE     LNK-X-MAX
                          BY VALUE     LNK-Y-MAX
                    RETURNING          LNK-RET.

 MAIN-FN-DRAWGRAPHICS SECTION.

    MOVE J-SETFONTSIZE(LNK-DRAWABLE, WS-FONT-SIZE) TO WS-RET
    MOVE J-SETNAMEDCOLOR(LNK-DRAWABLE, J-RED)      TO WS-RET
    
*>  drawline, drawrect
    MOVE LNK-X-MIN TO WS-X-MIN
    MOVE LNK-Y-MIN TO WS-Y-MIN
    COMPUTE WS-X-MAX = LNK-X-MAX - 1 END-COMPUTE
    COMPUTE WS-Y-MAX = LNK-Y-MAX - 1 END-COMPUTE
    MOVE J-DRAWLINE(LNK-DRAWABLE, WS-X-MIN, WS-Y-MIN, 
                                  WS-X-MAX, WS-Y-MAX) TO WS-RET
    MOVE LNK-X-MIN TO WS-X-MIN
    COMPUTE WS-Y-MIN = LNK-Y-MAX - 1 END-COMPUTE 
    COMPUTE WS-X-MAX = LNK-X-MAX - 1 END-COMPUTE
    MOVE LNK-Y-MIN TO WS-Y-MAX
    MOVE J-DRAWLINE(LNK-DRAWABLE, WS-X-MIN, WS-Y-MIN, 
                                  WS-X-MAX, WS-Y-MAX) TO WS-RET
    MOVE LNK-X-MIN TO WS-X-MIN
    MOVE LNK-Y-MIN TO WS-Y-MIN
    COMPUTE WS-X-MAX = LNK-X-MAX - LNK-X-MIN - 1 END-COMPUTE
    COMPUTE WS-Y-MAX = LNK-Y-MAX - LNK-X-MIN - 1 END-COMPUTE
    MOVE J-DRAWRECT(LNK-DRAWABLE, WS-X-MIN, WS-Y-MIN, 
                                  WS-X-MAX, WS-Y-MAX) TO WS-RET

*>  drawline, drawstring                                  
    MOVE J-SETNAMEDCOLOR(LNK-DRAWABLE, J-BLACK) TO WS-RET
    MOVE LNK-X-MIN TO WS-X-MIN
    COMPUTE WS-Y-MIN = LNK-Y-MAX - 30 END-COMPUTE 
    COMPUTE WS-X-MAX = LNK-X-MAX -  1 END-COMPUTE
    COMPUTE WS-Y-MAX = LNK-Y-MAX - 30 END-COMPUTE
    MOVE J-DRAWLINE(LNK-DRAWABLE, WS-X-MIN, WS-Y-MIN, 
                                  WS-X-MAX, WS-Y-MAX) TO WS-RET
    MOVE LNK-X-MAX TO WS-NUM-DISP                                  
    MOVE SPACES TO WS-TMP-STRING
    STRING "XMax = "   DELIMITED BY SIZE
           WS-NUM-DISP DELIMITED BY SIZE
      INTO WS-TMP-STRING
    END-STRING
    COMPUTE WS-X = LNK-X-MAX / 2 
                 - STORED-CHAR-LENGTH(WS-TMP-STRING) / 2
    END-COMPUTE
    COMPUTE WS-Y = LNK-Y-MAX - 40 END-COMPUTE
    MOVE J-DRAWSTRING(LNK-DRAWABLE, WS-X, WS-Y, WS-TMP-STRING) TO WS-RET
    
*>  drawline, drawstring                                  
    COMPUTE WS-X-MIN = LNK-X-MIN + 30 END-COMPUTE
    MOVE LNK-Y-MIN TO WS-Y-MIN
    COMPUTE WS-X-MAX = LNK-X-MIN + 30 END-COMPUTE
    COMPUTE WS-Y-MAX = LNK-Y-MAX -  1 END-COMPUTE
    MOVE J-DRAWLINE(LNK-DRAWABLE, WS-X-MIN, WS-Y-MIN, 
                                  WS-X-MAX, WS-Y-MAX) TO WS-RET
    MOVE LNK-Y-MAX TO WS-NUM-DISP                                  
    MOVE SPACES TO WS-TMP-STRING
    STRING "YMax = "   DELIMITED BY SIZE
           WS-NUM-DISP DELIMITED BY SIZE
      INTO WS-TMP-STRING
    END-STRING
    COMPUTE WS-X = LNK-X-MIN + 50 END-COMPUTE 
    MOVE 40 TO WS-Y
    MOVE J-DRAWSTRING(LNK-DRAWABLE, WS-X, WS-Y, WS-TMP-STRING) TO WS-RET

*>  drawoval    
    MOVE J-SETNAMEDCOLOR(LNK-DRAWABLE, J-MAGENTA) TO WS-RET
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       COMPUTE WS-X = LNK-X-MIN + (LNK-X-MAX - LNK-X-MIN) / 2 END-COMPUTE
       COMPUTE WS-Y = LNK-Y-MIN + (LNK-Y-MAX - LNK-Y-MIN) / 2 END-COMPUTE
       COMPUTE WS-RX = (LNK-X-MAX - LNK-X-MIN) / 20 * WS-IND END-COMPUTE
       COMPUTE WS-RY = (LNK-Y-MAX - LNK-Y-MIN) / 20 * WS-IND END-COMPUTE
       MOVE J-DRAWOVAL(LNK-DRAWABLE, WS-X, WS-Y, WS-RX, WS-RY) TO WS-RET
    END-PERFORM
    
*>  drawstring    
    MOVE J-SETNAMEDCOLOR(LNK-DRAWABLE, J-BLUE) TO WS-RET
    MOVE LNK-Y-MIN TO WS-Y
    PERFORM VARYING WS-IND FROM 5 BY 1 UNTIL WS-IND > 22
       MOVE J-SETFONTSIZE(LNK-DRAWABLE, WS-IND) TO WS-RET
       COMPUTE WS-X = LNK-X-MAX 
                    - J-GETSTRINGWIDTH(LNK-DRAWABLE, WS-STRING) 
       END-COMPUTE
       COMPUTE WS-Y = WS-Y + J-GETFONTHEIGHT(LNK-DRAWABLE) END-COMPUTE
       MOVE J-DRAWSTRING(LNK-DRAWABLE, WS-X, WS-Y, WS-STRING) TO WS-RET
    END-PERFORM

*>  drawimage, drawscaledimage
    MOVE J-LOADIMAGE("images/twux.png") TO WS-IMAGE
    IF WS-IMAGE > 0
    THEN
       MOVE 100 TO WS-X
       MOVE 200 TO WS-Y
       MOVE J-DRAWIMAGE(LNK-DRAWABLE, WS-IMAGE, WS-X, WS-Y) TO WS-RET
*>     source image   
       MOVE  10 TO WS-X
       MOVE   0 TO WS-Y
       MOVE  35 TO WS-WIDTH 
       MOVE  30 TO WS-HEIGHT 
*>     target canvas
       MOVE 100 TO WS-TARGET-X
       MOVE 300 TO WS-TARGET-Y
       MOVE 110 TO WS-TARGET-WIDTH 
       MOVE 138 TO WS-TARGET-HEIGHT 
       MOVE J-DRAWSCALEDIMAGE(LNK-DRAWABLE, WS-IMAGE,
                              WS-X, WS-Y,
                              WS-WIDTH, WS-HEIGHT,
                              WS-TARGET-X, WS-TARGET-Y,
                              WS-TARGET-WIDTH, WS-TARGET-HEIGHT) TO WS-RET
    END-IF
    
    MOVE ZEROES TO LNK-RET
    
    GOBACK

    .
 MAIN-FN-DRAWGRAPHICS-EX.
    EXIT.
 END FUNCTION FN-DRAWGRAPHICS.
