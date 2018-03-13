*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  image.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  image.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with image.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      image.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free image.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./image.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - image.c converted into image.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. image.
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
    FUNCTION J-NEXTACTION
    FUNCTION J-DRAWIMAGESOURCE
    FUNCTION J-GETSCREENWIDTH
    FUNCTION J-GETSCREENHEIGHT
    FUNCTION J-LOADIMAGE
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-DRAWIMAGE
    FUNCTION J-GETIMAGESOURCE
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
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-INVERT                          BINARY-INT.
 01 WS-IMAGE                           BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.

*> vars
 01 WS-IND                             BINARY-INT.
 01 WS-WIDTH-DISP                      PIC 9(5).
 01 WS-HEIGHT-DISP                     PIC 9(5).

*> R-TAB = WIDTH * HEIGHT ==> 1048576 = 1024 * 1024 
 01 WS-R-TAB.
   02 WS-R-TAB-LINES OCCURS 1048576 TIMES.
     03 WS-R-TAB-LINE                  BINARY-INT.
 
*> G-TAB = WIDTH * HEIGHT ==> 1048576 = 1024 * 1024 
 01 WS-G-TAB.
   02 WS-G-TAB-LINES OCCURS 1048576 TIMES.
     03 WS-G-TAB-LINE                  BINARY-INT.

*> B-TAB = WIDTH * HEIGHT ==> 1048576 = 1024 * 1024 
 01 WS-B-TAB.
   02 WS-B-TAB-LINES OCCURS 1048576 TIMES.
     03 WS-B-TAB-LINE                  BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-IMAGE SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET

    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

    MOVE J-GETSCREENWIDTH()  TO WS-WIDTH-DISP
    MOVE J-GETSCREENHEIGHT() TO WS-HEIGHT-DISP
    DISPLAY "screen width : "   WS-WIDTH-DISP
            ", screen height: " WS-HEIGHT-DISP
    END-DISPLAY

    MOVE J-LOADIMAGE("images/mandel.gif") TO WS-IMAGE
    MOVE J-GETWIDTH(WS-IMAGE)  TO WS-WIDTH
    MOVE J-GETHEIGHT(WS-IMAGE) TO WS-HEIGHT
    MOVE WS-WIDTH  TO WS-WIDTH-DISP
    MOVE WS-HEIGHT TO WS-HEIGHT-DISP
    DISPLAY "image width  : "   WS-WIDTH-DISP
            ", image height : " WS-HEIGHT-DISP
    END-DISPLAY

*>  Generate GUI Objects    
    MOVE J-FRAME("Image invert")       TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)           TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")    TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Invert") TO WS-INVERT

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT)      TO WS-CANVAS  
    MOVE 0 TO WS-X
    MOVE 0 TO WS-Y
    MOVE J-DRAWIMAGE(WS-CANVAS, WS-IMAGE, WS-X, WS-Y) TO WS-RET
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)        TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
*>     waits for the next event       
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-INVERT) 
       THEN
          MOVE 0 TO WS-X
          MOVE 0 TO WS-Y
          MOVE J-GETIMAGESOURCE(WS-CANVAS, WS-X, WS-Y, 
                                WS-WIDTH, WS-HEIGHT,
                                WS-R-TAB, WS-G-TAB, WS-B-TAB) TO WS-RET
*>        Image invert
          PERFORM VARYING WS-IND FROM 1 BY 1 
            UNTIL WS-IND > WS-WIDTH * WS-HEIGHT 
             COMPUTE WS-R-TAB-LINE(WS-IND) = 
                     255 - WS-R-TAB-LINE(WS-IND) 
             END-COMPUTE
             COMPUTE WS-G-TAB-LINE(WS-IND) = 
                     255 - WS-G-TAB-LINE(WS-IND) 
             END-COMPUTE
             COMPUTE WS-B-TAB-LINE(WS-IND) = 
                     255 - WS-B-TAB-LINE(WS-IND) 
             END-COMPUTE
          END-PERFORM

          MOVE 0 TO WS-X
          MOVE 0 TO WS-Y
          MOVE J-DRAWIMAGESOURCE(WS-CANVAS, WS-X, WS-Y, 
                                 WS-WIDTH, WS-HEIGHT,
                                 WS-R-TAB, WS-G-TAB, WS-B-TAB) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-IMAGE-EX.
    EXIT.
 END PROGRAM image.
