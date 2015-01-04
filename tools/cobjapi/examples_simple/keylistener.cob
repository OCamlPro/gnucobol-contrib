*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  keylistener.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  keylistener.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with keylistener.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      keylistener.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free keylistener.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./keylistener.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - keylistener.c converted into keylistener.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. keylistener.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-KEYLISTENER
    FUNCTION J-GETKEYCODE
    FUNCTION J-GETKEYCHAR
    FUNCTION J-SETTEXT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-KEYLST                          BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-STR                             PIC X(256).
 
*> vars
 01 WS-KEYCODE-DISP                    PIC 9(4). 
 01 WS-KEYCHAR                         BINARY-INT. 
 01 WS-KEYCHAR-DISP                    PIC 9(4). 
 01 WS-CHAR                            PIC X. 
     
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-KEYLISTENER SECTION.
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
    MOVE J-FRAME("Press a Key in the Window") TO WS-FRAME  
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE J-KEYLISTENER(WS-FRAME) TO WS-KEYLST
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-KEYLST
       THEN
          MOVE J-GETKEYCODE(WS-KEYLST) TO WS-KEYCODE-DISP
          MOVE J-GETKEYCHAR(WS-KEYLST) TO WS-KEYCHAR
          MOVE WS-KEYCHAR TO WS-KEYCHAR-DISP
          MOVE FUNCTION CHAR(WS-KEYCHAR + 1) TO WS-CHAR
       
          MOVE ALL x"00" TO WS-STR
          STRING
              "Keycode: " DELIMITED BY SIZE
              WS-KEYCODE-DISP
              " Ascii: "
              WS-KEYCHAR-DISP
              " Char: "
              WS-CHAR
            INTO WS-STR
          END-STRING

          MOVE J-SETTEXT(WS-FRAME, WS-STR) TO WS-RET         
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-KEYLISTENER-EX.
    EXIT.
 END PROGRAM keylistener.
