*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  label.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  label.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with label.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      label.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free label.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./label.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - label.c converted into label.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. label.
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
    FUNCTION J-LABEL
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-GETACTION
    FUNCTION J-SETTEXT
    FUNCTION J-GETXPOS
    FUNCTION J-GETYPOS
    FUNCTION J-SYNC
    FUNCTION J-SLEEP
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
 01 WS-DOIT                            BINARY-INT.
 01 WS-LABEL                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-DX                              BINARY-INT.
 01 WS-DY                              BINARY-INT.
 01 WS-RUN                             BINARY-INT VALUE 0.
 01 WS-MSEC                            BINARY-INT.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-LABEL SECTION.
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
    MOVE J-FRAME("Moving Label")      TO WS-FRAME  
                                      
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Start") TO WS-DOIT
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT

    MOVE J-LABEL(WS-FRAME, "Hello World")         TO WS-LABEL
    MOVE  10 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 256 TO WS-WIDTH
    MOVE 256 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-LABEL, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE J-GETWIDTH(WS-LABEL)  TO WS-WIDTH
    MOVE J-GETHEIGHT(WS-LABEL) TO WS-HEIGHT

    MOVE 2 TO WS-DX
    MOVE 1 TO WS-DY
    
*>  Waiting for actions
    PERFORM FOREVER
       IF WS-RUN = 1
       THEN
          MOVE J-GETACTION()  TO WS-OBJ
       ELSE
          MOVE J-NEXTACTION() TO WS-OBJ
       END-IF

       IF WS-OBJ = WS-DOIT
       THEN
          IF WS-RUN NOT = 1
          THEN
             MOVE 1 TO WS-RUN
             MOVE J-SETTEXT(WS-DOIT, "Stop")  TO WS-RET
          ELSE
             MOVE 0 TO WS-RUN
             MOVE J-SETTEXT(WS-DOIT, "Start") TO WS-RET
          END-IF
       END-IF

       IF WS-RUN = 1
       THEN
          MOVE J-GETXPOS(WS-LABEL) TO WS-X
          MOVE J-GETYPOS(WS-LABEL) TO WS-Y

          IF WS-X + WS-WIDTH  >= J-GETWIDTH(WS-FRAME)
          OR WS-X < 1
          THEN
             COMPUTE WS-DX = -1 * WS-DX END-COMPUTE
          END-IF

          IF WS-Y + WS-HEIGHT >= J-GETHEIGHT(WS-FRAME)
          OR WS-Y < 1
          THEN
             COMPUTE WS-DY = -1 * WS-DY END-COMPUTE
          END-IF
          
          COMPUTE WS-XPOS = WS-X + WS-DX END-COMPUTE
          COMPUTE WS-YPOS = WS-Y + WS-DY END-COMPUTE
          MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

          MOVE J-SYNC() TO WS-RET
          MOVE 10 TO WS-MSEC
          MOVE J-SLEEP(WS-MSEC) TO WS-RET
       END-IF
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-LABEL-EX.
    EXIT.
 END PROGRAM label.
