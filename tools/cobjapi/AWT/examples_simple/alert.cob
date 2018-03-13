*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  alert.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  alert.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with alert.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      alert.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free alert.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./alert.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - alert.c converted into alert.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. alert.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SHOW
    FUNCTION J-MESSAGEBOX
    FUNCTION J-SLEEP
    FUNCTION J-DISPOSE
    FUNCTION J-ALERTBOX
    FUNCTION J-CHOICEBOX2
    FUNCTION J-CHOICEBOX3
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-ALERT                           BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-MSEC                            BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-ALERT SECTION.
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
    MOVE J-FRAME("Alert Dialog Demo") TO WS-FRAME  
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE J-MESSAGEBOX(WS-FRAME, 
         "www.iarchitect.com",
         "All examples are real Microsoft error warnings" & X"0A" 
         & "found at: www.iarchitect.com"
         ) 
      TO WS-ALERT  
    DISPLAY "Alert = " WS-ALERT

    MOVE 5000 TO WS-MSEC
    MOVE J-SLEEP(WS-MSEC) TO WS-RET

    MOVE J-DISPOSE(WS-ALERT) TO WS-RET

    MOVE J-ALERTBOX(WS-FRAME, 
         "Error Deleting File",
         "Cannot delete 016: There is not enough free disk space" & X"0A"
         & "Delete one ore more files to free disk space, and then try again.",
         "OK"
         )
      TO WS-RET                    
    DISPLAY "Alert = " WS-ALERT

    MOVE J-CHOICEBOX2(WS-FRAME, 
         "Performance Warning",
         "A new MS-DOS resident program named 'WIN' may decrease your system's performance." & X"0A" 
         & "Would you like to see more information about this problem?",
         " Yes ",
         "  No "
         )
      TO WS-RET                    
    DISPLAY "Alert = " WS-ALERT
    
    MOVE J-CHOICEBOX3(WS-FRAME, 
         "SQL Windows",
         "This item doesn't belong here",
         "   Yes   ",
         "    No   ",
         "  Cancel "
         )
      TO WS-RET                    
    DISPLAY "Alert = " WS-ALERT

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-RET
       IF WS-RET = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-ALERT-EX.
    EXIT.
 END PROGRAM alert.
