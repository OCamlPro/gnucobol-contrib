*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  mandelbrot3.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  mandelbrot3.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with mandelbrot3.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      mandelbrot3.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.03.22
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free mandelbrot3.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./mandelbrot3.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.03.22 Laszlo Erdos: 
*>            mandel2.c converted into mandelbrot3.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. mandelbrot3.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-MENUBAR
    FUNCTION J-MENU
    FUNCTION J-MENUITEM    
    FUNCTION J-CANVAS
    FUNCTION J-MOUSELISTENER
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-GETACTION
    FUNCTION J-NEXTACTION
    FUNCTION J-SETNAMEDCOLOR
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-PRINT
    FUNCTION J-SETCOLOR
    FUNCTION J-DRAWPIXEL
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-DRAWIMAGESOURCE
    FUNCTION J-SETXOR
    FUNCTION J-DRAWRECT
    FUNCTION J-GETMOUSEPOS
    FUNCTION J-SYNC
    FUNCTION J-QUIT
*>  mandelbrot function
    FUNCTION MANDEL
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
 01 WS-RESET                           BINARY-INT.
 01 WS-PRINT                           BINARY-INT.
 01 WS-PRESSED                         BINARY-INT.
 01 WS-DRAGGED                         BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT VALUE 1024.
 01 WS-HEIGHT                          BINARY-INT VALUE  780.
 01 WS-IMG-WIDTH                       BINARY-INT.
 01 WS-IMG-HEIGHT                      BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-MAXITER                         BINARY-INT.
 01 WS-MX-START                        BINARY-INT VALUE 0.
 01 WS-MX-END                          BINARY-INT VALUE 0.
 01 WS-MY-START                        BINARY-INT VALUE 0.
 01 WS-MY-END                          BINARY-INT VALUE 0.
 01 WS-DX                              BINARY-INT.
 01 WS-DY                              BINARY-INT.
 01 WS-R-TAB.
   02 WS-R-TAB-LINES OCCURS 5000 TIMES.
     03 WS-R                           BINARY-INT.
 01 WS-G-TAB.
   02 WS-G-TAB-LINES OCCURS 5000 TIMES.
     03 WS-G                           BINARY-INT.
 01 WS-B-TAB.
   02 WS-B-TAB-LINES OCCURS 5000 TIMES.
     03 WS-B                           BINARY-INT.

*> vars
 01 WS-DO-WORK                         BINARY-INT VALUE 0.
 01 WS-ITER                            BINARY-INT.
 01 WS-Z-REAL                          COMPUTATIONAL-2.
 01 WS-Z-IMAG                          COMPUTATIONAL-2.
 01 WS-X-START                         COMPUTATIONAL-2 VALUE 0.
 01 WS-X-END                           COMPUTATIONAL-2 VALUE 0.
 01 WS-Y-START                         COMPUTATIONAL-2 VALUE 0.
 01 WS-Y-END                           COMPUTATIONAL-2 VALUE 0.
 01 WS-LX-START                        COMPUTATIONAL-2.
 01 WS-LX-END                          COMPUTATIONAL-2.
 01 WS-LY-START                        COMPUTATIONAL-2.
 01 WS-LY-END                          COMPUTATIONAL-2.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-MANDELBROT3 SECTION.
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
    MOVE J-FRAME("mandelbrot3 (zoomable)") TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME)  TO WS-RET
    
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Calc")   TO WS-CALC
    MOVE J-MENUITEM(WS-FILE, "Print") TO WS-PRINT
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    MOVE J-MENUITEM(WS-CALC, "Start") TO WS-START
    MOVE J-MENUITEM(WS-CALC, "Stop")  TO WS-STOP
    MOVE J-MENUITEM(WS-CALC, "Reset") TO WS-RESET

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  

    MOVE J-MOUSELISTENER(WS-CANVAS, J-PRESSED) TO WS-PRESSED
    MOVE J-MOUSELISTENER(WS-CANVAS, J-DRAGGED) TO WS-DRAGGED
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  mandelbrot area    
    MOVE -1.8 TO WS-LX-START 
    MOVE  0.8 TO WS-LX-END   
    MOVE -1.0 TO WS-LY-START 
    MOVE  1.0 TO WS-LY-END   
    
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

       IF (WS-OBJ = WS-STOP) 
       THEN
          MOVE 0 TO WS-DO-WORK
       END-IF

       IF (WS-OBJ = WS-PRINT) 
       THEN
          MOVE J-PRINT(WS-CANVAS) TO WS-RET
       END-IF

       IF (WS-OBJ = WS-RESET) 
       THEN
          MOVE -1.8 TO WS-LX-START WS-X-START 
          MOVE  0.8 TO WS-LX-END   WS-X-END   
          MOVE -1.0 TO WS-LY-START WS-Y-START 
          MOVE  1.0 TO WS-LY-END   WS-Y-END   
          
          MOVE -1 TO WS-X
          MOVE -1 TO WS-Y

          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
          MOVE 0 TO WS-DO-WORK
       END-IF
       
       IF (WS-OBJ = WS-START) 
       THEN
          MOVE WS-LX-START TO WS-X-START 
          MOVE WS-LX-END   TO WS-X-END   
          MOVE WS-LY-START TO WS-Y-START 
          MOVE WS-LY-END   TO WS-Y-END   

          MOVE -1 TO WS-X
          MOVE -1 TO WS-Y
          MOVE  1 TO WS-DO-WORK

          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
       END-IF
       
       IF WS-DO-WORK = 1
       THEN
          ADD 1 TO WS-Y
          IF WS-Y >= WS-HEIGHT
          THEN
             MOVE 0 TO WS-Y  
             MOVE 0 TO WS-DO-WORK
          ELSE
             PERFORM VARYING WS-X FROM 1 BY 1 UNTIL WS-X >= WS-WIDTH
                COMPUTE WS-Z-REAL = WS-X-START 
                      + WS-X * (WS-X-END - WS-X-START) / WS-WIDTH
                END-COMPUTE
                COMPUTE WS-Z-IMAG = WS-Y-START 
                      + WS-Y * (WS-Y-END - WS-Y-START) / WS-HEIGHT
                END-COMPUTE
          
                MOVE 512 TO WS-MAXITER           
*>              iteration function
                MOVE FUNCTION MANDEL(WS-Z-REAL, WS-Z-IMAG, WS-MAXITER) 
                  TO WS-ITER
          
                COMPUTE WS-R(WS-X) = 
                        FUNCTION MOD(WS-ITER * 11, 256) 
                END-COMPUTE
                COMPUTE WS-G(WS-X) = 
                        FUNCTION MOD(WS-ITER * 13, 256) 
                END-COMPUTE
                COMPUTE WS-B(WS-X) = 
                        FUNCTION MOD(WS-ITER * 17, 256) 
                END-COMPUTE
             END-PERFORM          

             MOVE 0        TO WS-XPOS
             MOVE WS-Y     TO WS-YPOS
             MOVE WS-WIDTH TO WS-IMG-WIDTH
             MOVE 1        TO WS-IMG-HEIGHT

             MOVE J-DRAWIMAGESOURCE(WS-CANVAS, WS-XPOS, WS-YPOS, 
                                    WS-IMG-WIDTH, WS-IMG-HEIGHT,
                                    WS-R-TAB, WS-G-TAB, WS-B-TAB) TO WS-RET
             MOVE J-SYNC() TO WS-RET
          END-IF          
       END-IF   
       
       IF (WS-OBJ = WS-CANVAS) 
       THEN
          MOVE J-GETWIDTH(WS-CANVAS)  TO WS-WIDTH
          MOVE J-GETHEIGHT(WS-CANVAS) TO WS-HEIGHT
          MOVE -1 TO WS-X
          MOVE -1 TO WS-Y
          INITIALIZE WS-R-TAB
          INITIALIZE WS-G-TAB
          INITIALIZE WS-B-TAB
          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
       END-IF
       
       IF (WS-OBJ = WS-PRESSED) 
       THEN
          MOVE J-SETXOR(WS-CANVAS, J-TRUE) TO WS-RET
          COMPUTE WS-DX = WS-MX-END - WS-MX-START END-COMPUTE
          COMPUTE WS-DY = WS-MY-END - WS-MY-START END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, WS-MX-START, WS-MY-START, 
                          WS-DX , WS-DY) TO WS-RET
          MOVE J-DRAWPIXEL(WS-CANVAS,                           
                           WS-MX-START, WS-MY-START) TO WS-RET
          MOVE J-GETMOUSEPOS(WS-PRESSED, WS-MX-END, WS-MY-END) TO WS-RET 
          MOVE WS-MX-END TO WS-MX-START
          MOVE WS-MY-END TO WS-MY-START
          MOVE J-SETXOR(WS-CANVAS, J-FALSE) TO WS-RET
       END-IF
       
       IF (WS-OBJ = WS-DRAGGED) 
       THEN
          MOVE J-SETXOR(WS-CANVAS, J-TRUE) TO WS-RET
          COMPUTE WS-DX = WS-MX-END - WS-MX-START END-COMPUTE
          COMPUTE WS-DY = WS-MY-END - WS-MY-START END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, WS-MX-START, WS-MY-START, 
                          WS-DX , WS-DY) TO WS-RET
          MOVE J-GETMOUSEPOS(WS-DRAGGED, WS-MX-END, WS-MY-END) TO WS-RET 

          COMPUTE WS-DX = WS-MX-END - WS-MX-START END-COMPUTE
          COMPUTE WS-DY = WS-MY-END - WS-MY-START END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, WS-MX-START, WS-MY-START, 
                          WS-DX , WS-DY) TO WS-RET
          MOVE J-SETXOR(WS-CANVAS, J-FALSE) TO WS-RET

          COMPUTE WS-LX-START = WS-X-START +
                  ((WS-X-END - WS-X-START) * WS-MX-START) / WS-WIDTH
          END-COMPUTE                  
          COMPUTE WS-LX-END   = WS-X-START +
                  ((WS-X-END - WS-X-START) * WS-MX-END)   / WS-WIDTH
          END-COMPUTE                  
          COMPUTE WS-LY-START = WS-Y-START +
                  ((WS-Y-END - WS-Y-START) * WS-MY-START) / WS-HEIGHT
          END-COMPUTE                  
          COMPUTE WS-LY-END   = WS-Y-START +
                  ((WS-Y-END - WS-Y-START) * WS-MY-END)   / WS-HEIGHT
          END-COMPUTE                  
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-MANDELBROT3-EX.
    EXIT.
 END PROGRAM mandelbrot3.

*>------------------------------------------------------------------------------
 IDENTIFICATION DIVISION.
 FUNCTION-ID. MANDEL.
 AUTHOR.      Laszlo Erdos.
 
 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 WS-X                               COMPUTATIONAL-2.
 01 WS-Y                               COMPUTATIONAL-2.
 01 WS-TMP                             COMPUTATIONAL-2.
 01 WS-SUM                             COMPUTATIONAL-2.
 01 WS-ITER                            BINARY-INT.
 
 LINKAGE SECTION.
 01 LNK-Z-REAL                         COMPUTATIONAL-2.
 01 LNK-Z-IMAG                         COMPUTATIONAL-2.
 01 LNK-MAXITER                        BINARY-INT.
 01 LNK-RET                            BINARY-INT.
 
 PROCEDURE DIVISION USING BY VALUE     LNK-Z-REAL
                          BY VALUE     LNK-Z-IMAG
                          BY VALUE     LNK-MAXITER
                    RETURNING          LNK-RET.

 MAIN-MANDEL SECTION.

    MOVE 0.0 TO WS-X
    MOVE 0.0 TO WS-Y
    MOVE 0.0 TO WS-SUM

    PERFORM VARYING WS-ITER FROM 1 BY 1 UNTIL WS-ITER > LNK-MAXITER
       COMPUTE WS-TMP = WS-X * WS-X - WS-Y * WS-Y + LNK-Z-REAL END-COMPUTE   
       COMPUTE WS-Y   = 2 * WS-X * WS-Y + LNK-Z-IMAG END-COMPUTE    
       MOVE WS-TMP TO WS-X

       COMPUTE WS-SUM = WS-X * WS-X + WS-Y * WS-Y END-COMPUTE

       IF WS-SUM > 4.0
       THEN
          MOVE WS-ITER TO LNK-RET
          GOBACK
       END-IF       
    END-PERFORM

    MOVE LNK-MAXITER TO LNK-RET
    
    GOBACK

    .
 MAIN-MANDEL-EX.
    EXIT.
 END FUNCTION MANDEL.
