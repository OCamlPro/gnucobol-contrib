*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  dialogmodal.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  dialogmodal.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with dialogmodal.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      dialogmodal.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free dialogmodal.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./dialogmodal.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - dialogmodal.c converted into dialogmodal.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. dialogmodal.
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
    FUNCTION J-DIALOG
    FUNCTION J-SETFLOWLAYOUT
    FUNCTION J-LABEL
    FUNCTION J-BUTTON
    FUNCTION J-PACK
    FUNCTION J-SHOW
    FUNCTION J-HIDE
    FUNCTION J-NEXTACTION
    FUNCTION J-DISABLE
    FUNCTION J-ENABLE
    FUNCTION J-GETXPOS
    FUNCTION J-GETYPOS
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-SETPOS
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
 01 WS-OBJ                             BINARY-INT.
 01 WS-DOIT                            BINARY-INT.
 01 WS-OPEN                            BINARY-INT.
 01 WS-DIALOG                          BINARY-INT.
 01 WS-LABEL                           BINARY-INT.
 01 WS-CLOSE                           BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-DIALOGMODAL SECTION.
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
    MOVE J-FRAME("Modal Dialog Demo")            TO WS-FRAME  
                                                 
    MOVE J-MENUBAR(WS-FRAME)                     TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")              TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")             TO WS-QUIT
    MOVE J-MENU(WS-MENUBAR, "Do It")             TO WS-DOIT
    MOVE J-MENUITEM(WS-DOIT, "Open Dialog")      TO WS-OPEN

    MOVE J-DIALOG(WS-FRAME, "Modal Dialog Demo") TO WS-DIALOG
    MOVE J-SETFLOWLAYOUT(WS-DIALOG, J-VERTICAL)  TO WS-RET
    MOVE J-LABEL(WS-DIALOG, "Hello World")       TO WS-LABEL
    MOVE J-BUTTON(WS-DIALOG, "Close")            TO WS-CLOSE
    MOVE J-PACK(WS-DIALOG) TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-OPEN
       THEN
*>        Modal Dialog --> disable frame       
          MOVE J-DISABLE(WS-FRAME) TO WS-RET
       
*>        place in the middle       
          COMPUTE WS-XPOS = J-GETXPOS(WS-FRAME)
                          + J-GETWIDTH(WS-FRAME)  / 2 
                          - J-GETWIDTH(WS-DIALOG) / 2
          END-COMPUTE

          COMPUTE WS-YPOS = J-GETYPOS(WS-FRAME)
                          + J-GETHEIGHT(WS-FRAME)  / 2 
                          - J-GETHEIGHT(WS-DIALOG) / 2
          END-COMPUTE
          
          MOVE J-SETPOS(WS-DIALOG, WS-XPOS, WS-YPOS) TO WS-RET
          MOVE J-SHOW(WS-DIALOG) TO WS-RET
       END-IF

       IF (WS-OBJ = WS-CLOSE) OR (WS-OBJ = WS-DIALOG)
       THEN
          MOVE J-HIDE(WS-DIALOG) TO WS-RET
*>        Modal Dialog --> enable frame       
          MOVE J-ENABLE(WS-FRAME) TO WS-RET
       END-IF
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-DIALOGMODAL-EX.
    EXIT.
 END PROGRAM dialogmodal.
