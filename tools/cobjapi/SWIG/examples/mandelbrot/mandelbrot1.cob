*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  mandelbrot1.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  mandelbrot1.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with mandelbrot1.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      mandelbrot1.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.03.22
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free mandelbrot1.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./mandelbrot1.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.03.22 Laszlo Erdos: 
*>            mandel.c converted into mandelbrot1.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. mandelbrot1.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*>  mandelbrot function
    FUNCTION MANDEL
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
 01 WS-QUIT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-CALC                            BINARY-INT.
 01 WS-START                           BINARY-INT.
 01 WS-STOP                            BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT VALUE 320.
 01 WS-HEIGHT                          BINARY-INT VALUE 240.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-G                               BINARY-INT.
 01 WS-B                               BINARY-INT.
 01 WS-MAXITER                         BINARY-INT.

*> vars
 01 WS-DO-WORK                         BINARY-INT VALUE 0.
 01 WS-ITER                            BINARY-INT.
 01 WS-Z-REAL                          COMPUTATIONAL-2.
 01 WS-Z-IMAG                          COMPUTATIONAL-2.
 01 WS-X-START                         COMPUTATIONAL-2.
 01 WS-X-END                           COMPUTATIONAL-2.
 01 WS-Y-START                         COMPUTATIONAL-2.
 01 WS-Y-END                           COMPUTATIONAL-2.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-MANDELBROT1 SECTION.
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
    MOVE J-FRAME("Mandelbrot1")       TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Calc")   TO WS-CALC
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    MOVE J-MENUITEM(WS-CALC, "Start") TO WS-START
    MOVE J-MENUITEM(WS-CALC, "Stop")  TO WS-STOP

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SETRESIZABLE(WS-FRAME, J-FALSE) TO WS-RET

    MOVE -1.8 TO WS-X-START 
    MOVE  0.8 TO WS-X-END   
    MOVE -1.0 TO WS-Y-START 
    MOVE  1.0 TO WS-Y-END   
    
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
       
       IF (WS-OBJ = WS-START) 
       THEN
          MOVE -1 TO WS-X
          MOVE -1 TO WS-Y
          MOVE  1 TO WS-DO-WORK

          MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET

          MOVE 0 TO WS-XPOS
          MOVE 0 TO WS-YPOS
          MOVE J-FILLRECT(WS-CANVAS, WS-XPOS, WS-YPOS, WS-WIDTH, WS-HEIGHT) 
            TO WS-RET
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
             COMPUTE WS-Z-REAL = WS-X-START 
                   + WS-X * (WS-X-END - WS-X-START) / WS-WIDTH
             END-COMPUTE
             COMPUTE WS-Z-IMAG = WS-Y-START 
                   + WS-Y * (WS-Y-END - WS-Y-START) / WS-HEIGHT
             END-COMPUTE
             
             MOVE 512 TO WS-MAXITER           
*>           iteration function
             MOVE FUNCTION MANDEL(WS-Z-REAL, WS-Z-IMAG, WS-MAXITER) 
               TO WS-ITER
             
             COMPUTE WS-R = FUNCTION MOD(WS-ITER * 11, 256) END-COMPUTE
             COMPUTE WS-G = FUNCTION MOD(WS-ITER * 13, 256) END-COMPUTE
             COMPUTE WS-B = FUNCTION MOD(WS-ITER * 17, 256) END-COMPUTE
          
             MOVE J-SETCOLOR(WS-CANVAS, WS-R, WS-G, WS-B) TO WS-RET       
             MOVE J-DRAWPIXEL(WS-CANVAS, WS-X, WS-Y) TO WS-RET       
          END-IF
       END-IF   
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-MANDELBROT1-EX.
    EXIT.
 END PROGRAM mandelbrot1.

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
