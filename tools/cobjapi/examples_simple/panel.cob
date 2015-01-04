*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  panel.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  panel.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with panel.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      panel.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free panel.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./panel.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - panel.c converted into panel.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. panel.
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
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-PANEL
    FUNCTION J-SHOW
    FUNCTION J-LABEL
    FUNCTION J-SETPOS
    FUNCTION J-NEXTACTION
    FUNCTION J-GETACTION
    FUNCTION J-SETTEXT
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-SYNC
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
 01 WS-PANEL                           BINARY-INT.
 01 WS-LABEL                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-P-WIDTH                         BINARY-INT VALUE 256.
 01 WS-P-HEIGHT                        BINARY-INT VALUE 256.
 01 WS-P-WIDTH-DISP                    PIC 9(4).
 01 WS-P-HEIGHT-DISP                   PIC 9(4).
 01 WS-X                               BINARY-INT VALUE 0.
 01 WS-Y                               BINARY-INT VALUE 0.
 01 WS-DX                              BINARY-INT VALUE 2.
 01 WS-DY                              BINARY-INT VALUE 1.
 01 WS-L-WIDTH                         BINARY-INT VALUE 0.
 01 WS-L-HEIGHT                        BINARY-INT VALUE 0.
 01 WS-RUN                             BINARY-INT VALUE 0.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-STR                             PIC X(256).

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PANEL SECTION.
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
    MOVE J-FRAME("Better moving label") TO WS-FRAME  
                                      
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Start") TO WS-DOIT
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    
    MOVE J-SETBORDERLAYOUT(WS-FRAME)  TO WS-RET
    MOVE J-PANEL(WS-FRAME)            TO WS-PANEL

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
    MOVE J-LABEL(WS-PANEL, "0400:0300") TO WS-LABEL
    MOVE 120 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

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

       IF WS-OBJ = WS-PANEL
       THEN
          MOVE J-GETWIDTH(WS-PANEL)  TO WS-P-WIDTH
          MOVE J-GETHEIGHT(WS-PANEL) TO WS-P-HEIGHT
          MOVE WS-P-WIDTH  TO WS-P-WIDTH-DISP
          MOVE WS-P-HEIGHT TO WS-P-HEIGHT-DISP
          MOVE ALL x"00" TO WS-STR
          STRING WS-P-WIDTH-DISP  DELIMITED BY SIZE
                 ":"
                 WS-P-HEIGHT-DISP
            INTO WS-STR     
          END-STRING
          MOVE J-SETTEXT(WS-LABEL, WS-STR) TO WS-RET

          MOVE J-GETWIDTH(WS-LABEL)  TO WS-L-WIDTH
          MOVE J-GETHEIGHT(WS-LABEL) TO WS-L-HEIGHT
          COMPUTE WS-X = (WS-P-WIDTH  - WS-L-WIDTH)  / 2 END-COMPUTE
          COMPUTE WS-Y = (WS-P-HEIGHT - WS-L-HEIGHT) / 2 END-COMPUTE
          MOVE J-SETPOS(WS-LABEL, WS-X, WS-Y) TO WS-RET
       END-IF
       
       IF WS-RUN = 1
       THEN
          IF WS-X + WS-L-WIDTH  >= WS-P-WIDTH
          OR WS-X < 1
          THEN
             COMPUTE WS-DX = -1 * WS-DX END-COMPUTE
          END-IF

          IF WS-Y + WS-L-HEIGHT >= WS-P-HEIGHT
          OR WS-Y < 1
          THEN
             COMPUTE WS-DY = -1 * WS-DY END-COMPUTE
          END-IF
          
          COMPUTE WS-X = WS-X + WS-DX END-COMPUTE
          COMPUTE WS-Y = WS-Y + WS-DY END-COMPUTE
          MOVE J-SETPOS(WS-LABEL, WS-X, WS-Y) TO WS-RET

          MOVE J-SYNC() TO WS-RET
       END-IF
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-PANEL-EX.
    EXIT.
 END PROGRAM panel.
