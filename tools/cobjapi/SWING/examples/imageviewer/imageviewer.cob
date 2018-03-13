*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  imageviewer.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  imageviewer.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with imageviewer.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      imageviewer.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.01.08
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free imageviewer.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./imageviewer.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.01.08 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - imageviewer.c converted into imageviewer.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. imageviewer.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*> Functions for the cobjapi wrapper 
 COPY "cobjapifn.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-OPEN                            BINARY-INT.
 01 WS-BMP                             BINARY-INT.
 01 WS-PPM                             BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 01 WS-IMAGE                           BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-MSEC                            BINARY-INT.
 01 WS-FILENAME                        PIC X(256).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-IMAGEVIEWER SECTION.
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
    MOVE J-FRAME("Image Viewer")         TO WS-FRAME  
    
    MOVE J-MENUBAR(WS-FRAME)             TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")      TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Open")     TO WS-OPEN
    MOVE J-MENUITEM(WS-FILE, "Save BMP") TO WS-BMP
    MOVE J-MENUITEM(WS-FILE, "Save PPM") TO WS-PPM
    MOVE J-SEPERATOR(WS-FILE)            TO WS-RET
    MOVE J-MENUITEM(WS-FILE, "Quit")     TO WS-QUIT

    MOVE 320 TO WS-WIDTH
    MOVE 240 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS

	MOVE 1 TO WS-ROW
    MOVE 1 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET
    MOVE J-SETRESIZABLE(WS-FRAME, J-FALSE)         TO WS-RET
    MOVE J-DISABLE(WS-BMP)                         TO WS-RET
    MOVE J-DISABLE(WS-PPM)                         TO WS-RET
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE "images" TO WS-FILENAME
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-OPEN) 
       THEN
          MOVE J-FILESELECT(WS-FRAME, "Open File", "*", WS-FILENAME) TO WS-RET

          IF WS-FILENAME NOT = SPACES
          THEN
             MOVE J-LOADIMAGE(WS-FILENAME) TO WS-IMAGE
             DISPLAY TRIM(WS-FILENAME) END-DISPLAY
             
             IF WS-IMAGE = -1 
             THEN
                MOVE J-ALERTBOX(WS-FRAME, 
                     "Warning", 
                     "Not a valid image file", 
                     "OK") TO WS-RET
                     
                MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
                MOVE J-DISABLE(WS-BMP)                     TO WS-RET
                MOVE J-DISABLE(WS-PPM)                     TO WS-RET
                MOVE 320 TO WS-WIDTH
                MOVE 240 TO WS-HEIGHT
                MOVE J-SETSIZE(WS-CANVAS, WS-WIDTH, WS-HEIGHT) TO WS-RET
                MOVE J-PACK(WS-FRAME) TO WS-RET
             ELSE
                MOVE J-GETWIDTH(WS-IMAGE)  TO WS-WIDTH
                MOVE J-GETHEIGHT(WS-IMAGE) TO WS-HEIGHT
                MOVE J-SETSIZE(WS-CANVAS, WS-WIDTH, WS-HEIGHT) TO WS-RET

                DISPLAY "Image width: " WS-WIDTH
                        " height: "     WS-HEIGHT
                END-DISPLAY

                MOVE J-SETNAMEDCOLORBG(WS-CANVAS, J-WHITE) TO WS-RET
                MOVE J-PACK(WS-FRAME) TO WS-RET

                MOVE 500 TO WS-MSEC
                MOVE J-SLEEP(WS-MSEC) TO WS-RET

                MOVE 0 TO WS-X
                MOVE 0 TO WS-Y
                MOVE J-DRAWIMAGE(WS-CANVAS, WS-IMAGE, WS-X, WS-Y) TO WS-RET
                MOVE J-ENABLE(WS-BMP) TO WS-RET
                MOVE J-ENABLE(WS-PPM) TO WS-RET
             END-IF
          END-IF       
       END-IF

       IF (WS-OBJ = WS-BMP) 
       THEN
          MOVE J-FILESELECT(WS-FRAME, "Save as BMP", "*.bmp", WS-FILENAME) TO WS-RET

          IF  WS-FILENAME NOT = SPACES
          THEN
             MOVE J-SAVEIMAGE(WS-IMAGE, WS-FILENAME, J-BMP) TO WS-RET
          END-IF       
       END-IF
       
       IF (WS-OBJ = WS-PPM) 
       THEN
          MOVE J-FILESELECT(WS-FRAME, "Save as PPM", "*.ppm", WS-FILENAME) TO WS-RET

          IF  WS-FILENAME NOT = SPACES
          THEN
             MOVE J-SAVEIMAGE(WS-IMAGE, WS-FILENAME, J-PPM) TO WS-RET
          END-IF       
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-IMAGEVIEWER-EX.
    EXIT.
 END PROGRAM imageviewer.
