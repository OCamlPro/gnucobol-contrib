*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  video.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  video.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with video.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      video.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free video.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./video.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - video.c converted into video.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. video.
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
 01 WS-QUIT                            BINARY-INT.
 01 WS-PLAY                            BINARY-INT.
 01 WS-START                           BINARY-INT.
 01 WS-STOP                            BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-SOUND                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

 01 WS-IMAGE-TAB.
   02 WS-IMAGE-TAB-LINES OCCURS 18 TIMES.
     03 WS-IMAGE-TAB-LINE              BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-MSEC                            BINARY-INT.
 01 WS-FILENAME                        PIC X(256).

*> vars
 01 WS-IND                             BINARY-INT.
 01 WS-DO-WORK                         BINARY-INT VALUE 0.
 01 WS-FILENAME-IND                    PIC 9(2).
 
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-VIDEO SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  Load images    
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 18
       MOVE WS-IND TO WS-FILENAME-IND
       MOVE SPACES TO WS-FILENAME
       STRING "images/ms"     DELIMITED BY SIZE
              WS-FILENAME-IND DELIMITED BY SIZE
              ".gif"          DELIMITED BY SIZE
         INTO WS-FILENAME
       END-STRING         
       
       DISPLAY "Loading " TRIM(WS-FILENAME)
       MOVE J-LOADIMAGE(WS-FILENAME) TO WS-IMAGE-TAB-LINE(WS-IND)      
    END-PERFORM    

    MOVE J-GETWIDTH(WS-IMAGE-TAB-LINE(1))  TO WS-WIDTH
    MOVE J-GETHEIGHT(WS-IMAGE-TAB-LINE(1)) TO WS-HEIGHT

*>  Generate GUI Objects    
    MOVE J-FRAME("Video") TO WS-FRAME  
    
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT

    MOVE J-MENU(WS-MENUBAR, "Play")   TO WS-PLAY
    MOVE J-MENUITEM(WS-PLAY, "Start") TO WS-START
    MOVE J-MENUITEM(WS-PLAY, "Stop")  TO WS-STOP

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  play one time    
    MOVE J-PLAYSOUNDFILE("sounds/ping.au") TO WS-RET
*>  play later with the function J-PLAY()    
    MOVE J-SOUND("sounds/ping.au") TO WS-SOUND

    MOVE  1 TO WS-IND
    MOVE -1 TO WS-OBJ
    
*>  Waiting for actions
    PERFORM FOREVER
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-DO-WORK = 1
       THEN
*>        returns the next event, or 0 if no event available       
          MOVE J-GETACTION()  TO WS-OBJ
       ELSE
*>        waits for the next event       
          MOVE J-NEXTACTION() TO WS-OBJ
       END-IF   
       
       IF (WS-OBJ = WS-START) 
       THEN
          MOVE 1 TO WS-DO-WORK
       END-IF

       IF (WS-OBJ = WS-STOP) 
       THEN
          MOVE 0 TO WS-DO-WORK
       END-IF
       
       IF WS-DO-WORK = 1
       THEN
          IF WS-IND = 17 OR WS-IND = 8
          THEN
             MOVE J-PLAY(WS-SOUND) TO WS-RET
          END-IF

          MOVE 0 TO WS-XPOS
          MOVE 0 TO WS-YPOS
          MOVE J-DRAWIMAGE(WS-CANVAS, WS-IMAGE-TAB-LINE(WS-IND), 
                           WS-XPOS, WS-YPOS) TO WS-RET
       
          MOVE J-SYNC() TO WS-RET
          MOVE 50 TO WS-MSEC
          MOVE J-SLEEP(WS-MSEC) TO WS-RET

          COMPUTE WS-IND = WS-IND + 1 END-COMPUTE
          IF WS-IND > 18
          THEN
             MOVE 1 TO WS-IND
          END-IF
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-VIDEO-EX.
    EXIT.
 END PROGRAM video.
