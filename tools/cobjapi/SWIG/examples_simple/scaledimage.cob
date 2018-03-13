*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  scaledimage.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  scaledimage.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with scaledimage.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      scaledimage.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free scaledimage.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./scaledimage.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - scaledimage.c converted into scaledimage.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. scaledimage.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-CANVAS
    FUNCTION J-SETPOS
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-FILLCIRCLE
    FUNCTION J-GETSCALEDIMAGE
    FUNCTION J-DRAWSCALEDIMAGE
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-IMAGE                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-TARGET-WIDTH                    BINARY-INT.
 01 WS-TARGET-HEIGHT                   BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-TARGET-X                        BINARY-INT.
 01 WS-TARGET-Y                        BINARY-INT.
 01 WS-R                               BINARY-INT.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-SCALEDIMAGE SECTION.
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
    MOVE J-FRAME("Scaled Image") TO WS-FRAME  
                                
    MOVE 300 TO WS-WIDTH                                
    MOVE 300 TO WS-HEIGHT                                
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS
    MOVE 10 TO WS-X
    MOVE 30 TO WS-Y
    MOVE J-SETPOS(WS-CANVAS, WS-X, WS-Y) TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET
    
    MOVE 150 TO WS-X
    MOVE 150 TO WS-Y
    MOVE 100 TO WS-R
    MOVE J-FILLCIRCLE(WS-CANVAS, WS-X, WS-Y, WS-R) TO WS-RET

*>  source canvas   
    MOVE  50 TO WS-X
    MOVE  50 TO WS-Y
    MOVE 250 TO WS-WIDTH 
    MOVE 250 TO WS-HEIGHT 
*>  target image
    MOVE  50 TO WS-TARGET-WIDTH 
    MOVE  50 TO WS-TARGET-HEIGHT 
    MOVE J-GETSCALEDIMAGE(WS-CANVAS, 
                          WS-X, WS-Y,
                          WS-WIDTH, WS-HEIGHT,
                          WS-TARGET-WIDTH, WS-TARGET-HEIGHT) TO WS-IMAGE

*>  source image   
    MOVE   0 TO WS-X
    MOVE   0 TO WS-Y
    MOVE  25 TO WS-WIDTH 
    MOVE  25 TO WS-HEIGHT 
*>  target canvas
    MOVE 210 TO WS-TARGET-X
    MOVE 210 TO WS-TARGET-Y
    MOVE  75 TO WS-TARGET-WIDTH 
    MOVE  75 TO WS-TARGET-HEIGHT 
    MOVE J-DRAWSCALEDIMAGE(WS-CANVAS, WS-IMAGE,
                           WS-X, WS-Y,
                           WS-WIDTH, WS-HEIGHT,
                           WS-TARGET-X, WS-TARGET-Y,
                           WS-TARGET-WIDTH, WS-TARGET-HEIGHT) TO WS-RET
    
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
 MAIN-SCALEDIMAGE-EX.
    EXIT.
 END PROGRAM scaledimage.
