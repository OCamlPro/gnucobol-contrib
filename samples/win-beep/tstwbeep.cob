*>******************************************************************************
*>  tstwinbeep.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tstwinbeep.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tstwinbeep.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tstwinbeep.cob
*>
*> Purpose:      Test program for the Beep and MessageBeep Windows functions
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
 PROGRAM-ID. tstwbeep.

 ENVIRONMENT DIVISION.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 01 WS-FREQ                            BINARY-LONG UNSIGNED.
 01 WS-DURATION                        BINARY-LONG UNSIGNED.
 01 WS-RETURN-VALUE                    BINARY-SHORT.
   88 V-NOK                            VALUE 0.

 01 WS-SOUND-TYPE                      BINARY-SHORT UNSIGNED.
   88 V-SIMPLE-BEEP                    VALUE H"FFFFFFFF".
   88 V-MB-ICONASTERISK                VALUE H"00000040".
   88 V-MB-ICONEXCLAMATION             VALUE H"00000030".
   88 V-MB-ICONERROR                   VALUE H"00000010".
   88 V-MB-ICONHAND                    VALUE H"00000010".
   88 V-MB-ICONINFORMATION             VALUE H"00000040".
   88 V-MB-ICONQUESTION                VALUE H"00000020".
   88 V-MB-ICONSTOP                    VALUE H"00000010".
   88 V-MB-ICONWARNING                 VALUE H"00000030".
   88 V-MB-OK                          VALUE H"00000000".
      
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TSTWBEEP SECTION.
*>------------------------------------------------------------------------------
 
*>  test the Beep(freq, duration) function 
    PERFORM TEST-WINBEEP

*>  test MessageBeep(sound_type) function
    PERFORM TEST-WINMSGBEEP
    
    STOP RUN
    .

*>------------------------------------------------------------------------------
 TEST-WINBEEP SECTION.
*>------------------------------------------------------------------------------

*>  The Beep function generates simple tones on the speaker. The function is synchronous; it performs 
*>  an alertable wait and does not return control to its caller until the sound finishes.
*>  
*>  Parameters:
*>  - freq:     The frequency of the sound, in hertz. This parameter must be in the range 
*>              37 through 32,767 (0x25 through 0x7FFF).
*>  - duration: The duration of the sound, in milliseconds.
*>
*>  Return value:
*>  - If the function succeeds, the return value is nonzero.
*>  - If the function fails, the return value is zero. 

*>  C4 = 261,63
    MOVE  261 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  D4 = 293,67
    MOVE  293 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  E4 = 329,63
    MOVE  329 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  F4 = 349,23
    MOVE  349 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  G4 = 392,00
    MOVE  392 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  A4 = 440,00
    MOVE  440 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

*>  H4 = 493,88
    MOVE  493 TO WS-FREQ
    MOVE 1000 TO WS-DURATION
    PERFORM CALL-WINBEEP

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 TEST-WINMSGBEEP SECTION.
*>------------------------------------------------------------------------------

*>  The MessageBeep function plays a waveform sound. The waveform sound for each sound type is identified 
*>  by an entry in the registry. After queuing the sound, the MessageBeep function 
*>  returns control to the calling function and plays the sound asynchronously.
*>  
*>  The parameter can be one of the following values:
*>  Value                           Meaning
*>  
*>                     0xFFFFFFFF   A simple beep. If the sound card is not available, the sound is generated using the speaker.
*>  
*>  MB_ICONASTERISK    0x00000040L  See MB_ICONINFORMATION.
*>  
*>  MB_ICONEXCLAMATION 0x00000030L  See MB_ICONWARNING.
*>  
*>  MB_ICONERROR       0x00000010L  The sound specified as the Windows Critical Stop sound.
*>  
*>  MB_ICONHAND        0x00000010L  See MB_ICONERROR.
*>  
*>  MB_ICONINFORMATION 0x00000040L  The sound specified as the Windows Asterisk sound.
*>  
*>  MB_ICONQUESTION    0x00000020L  The sound specified as the Windows Question sound.
*>  
*>  MB_ICONSTOP        0x00000010L  See MB_ICONERROR.
*>  
*>  MB_ICONWARNING     0x00000030L  The sound specified as the Windows Exclamation sound.
*>  
*>  MB_OK              0x00000000L  The sound specified as the Windows Default Beep sound.
*>  
*>  Return value:
*>  - If the function succeeds, the return value is nonzero.
*>  - If the function fails, the return value is zero.

    SET V-SIMPLE-BEEP        OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONASTERISK    OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONEXCLAMATION OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONERROR       OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONHAND        OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONINFORMATION OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONQUESTION    OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONSTOP        OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-ICONWARNING     OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    SET V-MB-OK              OF WS-SOUND-TYPE TO TRUE
    PERFORM CALL-WINMSGBEEP

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINBEEP SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "Beep" 
         USING BY VALUE WS-FREQ
               BY VALUE WS-DURATION
         RETURNING WS-RETURN-VALUE 
    END-CALL
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with Beep"
    END-IF   
    
    CALL "C$SLEEP" USING 2 END-CALL
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-WINMSGBEEP SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "MessageBeep" 
         USING BY VALUE WS-SOUND-TYPE
         RETURNING WS-RETURN-VALUE 
    END-CALL
    
    IF V-NOK OF WS-RETURN-VALUE
    THEN
       DISPLAY "Problem with MessageBeep"
    END-IF   
    
    CALL "C$SLEEP" USING 2 END-CALL
    
    .
    EXIT SECTION .
    
 END PROGRAM tstwbeep.
