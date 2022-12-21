*>******************************************************************************
*>  tstwsound.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tstwsound.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tstwsound.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tstwsound.cob
*>
*> Purpose:      Test program for the PlaySound Windows function
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022.12.21
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2022.12.21 Laszlo Erdos: 
*>            First version created.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. tstwsound.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 01 WS-WAV-FILE                        PIC X(256).
 01 WS-RETURN-VALUE                    BINARY-SHORT.
   88 V-NOK                            VALUE 0.

*> flags, please check MS documentation for other flags and parameters
 01 WS-SND-FLAG                        BINARY-LONG UNSIGNED.
 01 WS-SND-ASYNC                       BINARY-LONG UNSIGNED VALUE H"0001".
 01 WS-SND-LOOP                        BINARY-LONG UNSIGNED VALUE H"0008".
 01 WS-SND-FILENAME                    BINARY-LONG UNSIGNED VALUE H"00020000".
      
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TSTWSOUND SECTION.
*>------------------------------------------------------------------------------

*>  WAV file
    MOVE "Linus-linux.wav" TO WS-WAV-FILE
 
*>  test winsound
    PERFORM CALL-WINSOUND

    DISPLAY "The sound is played synchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  test winsound-async
    PERFORM CALL-WINSOUND-ASYNC

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  test the STOP 
*>  first start with winsound-async
    PERFORM CALL-WINSOUND-ASYNC

    DISPLAY "The sound is played asynchronously..."
    CALL "C$SLEEP" USING 2 END-CALL

*>  STOP with winsound-stop
    PERFORM CALL-WINSOUND-STOP

    DISPLAY "The sound is stopped"
    CALL "C$SLEEP" USING 2 END-CALL

*>  test winsound-loop 
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

    CALL STATIC "PlaySound" 
         USING BY CONTENT CONCATENATE(TRIM(WS-WAV-FILE), X"00")
               BY VALUE   0
               BY VALUE   WS-SND-FILENAME
         RETURNING WS-RETURN-VALUE 
    END-CALL     
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with PlaySound in CALL-WINSOUND"
    END-IF   

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-ASYNC SECTION.
*>------------------------------------------------------------------------------

    COMPUTE WS-SND-FLAG = WS-SND-FILENAME + WS-SND-ASYNC 
    END-COMPUTE

    CALL STATIC "PlaySound" 
         USING BY CONTENT CONCATENATE(TRIM(WS-WAV-FILE), X"00")
               BY VALUE   0
               BY VALUE   WS-SND-FLAG
         RETURNING WS-RETURN-VALUE 
    END-CALL     
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with PlaySound in CALL-WINSOUND-ASYNC"
    END-IF   
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-LOOP SECTION.
*>------------------------------------------------------------------------------

    COMPUTE WS-SND-FLAG = WS-SND-FILENAME + WS-SND-ASYNC + WS-SND-LOOP 
    END-COMPUTE

    CALL STATIC "PlaySound" 
         USING BY CONTENT CONCATENATE(TRIM(WS-WAV-FILE), X"00")
               BY VALUE   0
               BY VALUE   WS-SND-FLAG
         RETURNING WS-RETURN-VALUE 
    END-CALL     
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with PlaySound in CALL-WINSOUND-LOOP"
    END-IF   
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINSOUND-STOP SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "PlaySound" 
         USING BY VALUE   0
               BY VALUE   0
               BY VALUE   0
         RETURNING WS-RETURN-VALUE 
    END-CALL     
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with PlaySound in CALL-WINSOUND-STOP"
    END-IF   
    
    .
    EXIT SECTION .
    
 END PROGRAM tstwsound.
