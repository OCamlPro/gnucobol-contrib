*>******************************************************************************
*>  winsound.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  winsound.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with winsound.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      winsound.cob
*>
*> Purpose:      COBOL wrapper for win_sound.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022-12-18
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
 PROGRAM-ID. winsound.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINSOUND.
   02 LNK-INPUT.
     03 LNK-WAV-FILE                   PIC X(256).
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINSOUND.   
 
*>------------------------------------------------------------------------------
 MAIN-WINSOUND SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINSOUND

*>  call C function
    CALL "win_play_sound_sync" 
         USING BY CONTENT CONCATENATE(TRIM(LNK-WAV-FILE OF LNK-WINSOUND), X"00")
         RETURNING LNK-RETURN-VALUE    OF LNK-WINSOUND
    END-CALL     

    GOBACK . 
    
 END PROGRAM winsound.

*>******************************************************************************
*> Program:      winsound-async.cob
*>
*> Purpose:      COBOL wrapper for win_sound.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022-12-18
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
 PROGRAM-ID. winsound-async.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINSOUND.
   02 LNK-INPUT.
     03 LNK-WAV-FILE                   PIC X(256).
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINSOUND.   
 
*>------------------------------------------------------------------------------
 MAIN-WINSOUND-ASYNC SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINSOUND

*>  call C function
    CALL "win_play_sound_async" 
         USING BY CONTENT CONCATENATE(TRIM(LNK-WAV-FILE OF LNK-WINSOUND), X"00")
         RETURNING LNK-RETURN-VALUE    OF LNK-WINSOUND
    END-CALL     

    GOBACK . 
    
 END PROGRAM winsound-async.

*>******************************************************************************
*> Program:      winsound-loop.cob
*>
*> Purpose:      COBOL wrapper for win_sound.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022-12-18
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
 PROGRAM-ID. winsound-loop.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINSOUND.
   02 LNK-INPUT.
     03 LNK-WAV-FILE                   PIC X(256).
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINSOUND.   
 
*>------------------------------------------------------------------------------
 MAIN-WINSOUND-LOOP SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINSOUND

*>  call C function
    CALL "win_play_sound_loop" 
         USING BY CONTENT CONCATENATE(TRIM(LNK-WAV-FILE OF LNK-WINSOUND), X"00")
         RETURNING LNK-RETURN-VALUE    OF LNK-WINSOUND
    END-CALL     

    GOBACK . 
    
 END PROGRAM winsound-loop.

*>******************************************************************************
*> Program:      winsound-stop.cob
*>
*> Purpose:      COBOL wrapper for win_sound.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022-12-18
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
 PROGRAM-ID. winsound-stop.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINSOUND.
   02 LNK-INPUT.
     03 LNK-WAV-FILE                   PIC X(256).
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINSOUND.   
 
*>------------------------------------------------------------------------------
 MAIN-WINSOUND-STOP SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINSOUND

*>  call C function
    CALL "win_play_sound_stop" 
         USING OMITTED
         RETURNING LNK-RETURN-VALUE    OF LNK-WINSOUND
    END-CALL     

    GOBACK . 
    
 END PROGRAM winsound-stop.
