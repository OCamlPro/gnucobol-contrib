*>******************************************************************************
*>  tstwinsound.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tstwinsound.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tstwinsound.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tstwinsound.cob
*>
*> Purpose:      Test program for winsound.cob
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022.12.18
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2022.12.18 Laszlo Erdos: 
*>            First version created.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. tstwinsound.

 ENVIRONMENT DIVISION.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 01 LNK-WINSOUND.
   02 LNK-INPUT.
     03 LNK-WAV-FILE                   PIC X(256).
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
      
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TSTWINSOUND SECTION.
*>------------------------------------------------------------------------------
 
*>  test winsound
    MOVE "Linus-linux.wav" TO LNK-WAV-FILE OF LNK-WINSOUND
    PERFORM CALL-WINSOUND

    DISPLAY "The sound is played synchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  test winsound-async
    MOVE "Linus-linux.wav" TO LNK-WAV-FILE OF LNK-WINSOUND
    PERFORM CALL-WINSOUND-ASYNC

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  test the STOP 
*>  first start with winsound-async
    MOVE "Linus-linux.wav" TO LNK-WAV-FILE OF LNK-WINSOUND
    PERFORM CALL-WINSOUND-ASYNC

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  STOP with winsound-stop
    PERFORM CALL-WINSOUND-STOP

    DISPLAY "The sound is stopped"
    CALL "C$SLEEP" USING 2 END-CALL

*>  test winsound-loop 
    MOVE "Linus-linux.wav" TO LNK-WAV-FILE OF LNK-WINSOUND
    PERFORM CALL-WINSOUND-LOOP

    DISPLAY "The sound is played asynchronously in a loop ..."
    CALL "C$SLEEP" USING 4 END-CALL

    DISPLAY "The sound is played asynchronously in a loop ..."
    CALL "C$SLEEP" USING 4 END-CALL

    DISPLAY "The sound is played asynchronously in a loop ..."
    CALL "C$SLEEP" USING 4 END-CALL

*>  STOP with winsound-stop
    PERFORM CALL-WINSOUND-STOP

    DISPLAY "The sound is stopped"
    CALL "C$SLEEP" USING 2 END-CALL

    STOP RUN
    .

*>------------------------------------------------------------------------------
 CALL-WINSOUND SECTION.
*>------------------------------------------------------------------------------

    CALL "winsound" USING LNK-WINSOUND END-CALL
    
    IF V-NOK OF LNK-RETURN-VALUE OF LNK-WINSOUND
    THEN
       DISPLAY "Problem with WINSOUND"
    END-IF   

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-ASYNC SECTION.
*>------------------------------------------------------------------------------

    CALL "winsound-async" USING LNK-WINSOUND END-CALL
    
    IF V-NOK OF LNK-RETURN-VALUE OF LNK-WINSOUND
    THEN
       DISPLAY "Problem with WINSOUND-ASYNC"
    END-IF   
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-LOOP SECTION.
*>------------------------------------------------------------------------------

    CALL "winsound-loop" USING LNK-WINSOUND END-CALL
    
    IF V-NOK OF LNK-RETURN-VALUE OF LNK-WINSOUND
    THEN
       DISPLAY "Problem with WINSOUND-LOOP"
    END-IF   
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-STOP SECTION.
*>------------------------------------------------------------------------------

    CALL "winsound-stop" USING LNK-WINSOUND END-CALL
    
    IF V-NOK OF LNK-RETURN-VALUE OF LNK-WINSOUND
    THEN
       DISPLAY "Problem with WINSOUND-STOP"
    END-IF   
    
    .
    EXIT SECTION .
    
 END PROGRAM tstwinsound.
