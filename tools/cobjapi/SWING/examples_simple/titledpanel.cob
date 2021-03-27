*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  titledpanel.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  titledpanel.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with titledpanel.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      titledpanel.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free titledpanel.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./titledpanel.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.03.21 Laszlo Erdos: 
*>            - panel.cob converted into titledpanel.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. titledpanel.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC
    COPY "CobjapiFunctions.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 COPY "CobjapiConstants.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-TITLEDCOLORPANEL                BINARY-LONG.
 01 WS-TITLEDNAMEDCOLORPANEL           BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.

*> RGB color
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TITLEDPANEL SECTION.
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
    MOVE J-FRAME("Titled Panel") TO WS-FRAME  
                                      
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    
*>  panel 1
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-LEFT, J-TOP, J-RED) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: left, Position: top, NamedColor: red") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  panel 2
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-CENTER, J-TOP, J-BLUE) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 100 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: center, Position: top, NamedColor: blue") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  panel 3
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-RIGHT, J-TOP, J-GREEN) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 170 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: right, Position: top, NamedColor: green") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  panel 4
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-LEFT, J-BOTTOM, J-ORANGE) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 240 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: left, Position: bottom, NamedColor: orange") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  panel 5
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-CENTER, J-BOTTOM, J-MAGENTA) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 310 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: center, Position: bottom, NamedColor: magenta") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  panel 6
    MOVE J-TITLEDNAMEDCOLORPANEL(WS-FRAME, "Title", J-RIGHT, J-BOTTOM, J-LIGHT-GRAY) TO WS-TITLEDNAMEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 380 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDNAMEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDNAMEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDNAMEDCOLORPANEL, "Justify: right, Position: bottom, NamedColor: light gray") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET


    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  panel 7
*>  you can use RGB colors also
    MOVE 178 TO WS-R  
    MOVE 145 TO WS-G  
    MOVE 109 TO WS-B
    MOVE J-TITLEDCOLORPANEL(WS-FRAME, "Title", J-LEFT, J-TOP, WS-R, WS-G, WS-B) TO WS-TITLEDCOLORPANEL

    MOVE  30 TO WS-XPOS
    MOVE 450 TO WS-YPOS
    MOVE J-SETPOS(WS-TITLEDCOLORPANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-TITLEDCOLORPANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-LABEL(WS-TITLEDCOLORPANEL, "Justify: left, Position: top, RGB-Color: 178, 145, 109") TO WS-LABEL
    MOVE 20 TO WS-XPOS
    MOVE 20 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TITLEDPANEL-EX.
    EXIT.
 END PROGRAM titledpanel.
