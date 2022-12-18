*>******************************************************************************
*>  winbeep.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  winbeep.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with winbeep.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      winbeep.cob
*>
*> Purpose:      COBOL wrapper for win_beep.c
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
 PROGRAM-ID. winbeep.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINBEEP.
   02 LNK-INPUT.
     03 LNK-FREQ                       BINARY-LONG UNSIGNED.
     03 LNK-DURATION                   BINARY-LONG UNSIGNED.
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINBEEP.   
 
*>------------------------------------------------------------------------------
 MAIN-WINBEEP SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINBEEP

*>  call C function win_beep
    CALL "win_beep" 
         USING BY VALUE LNK-FREQ       OF LNK-WINBEEP
               BY VALUE LNK-DURATION   OF LNK-WINBEEP
         RETURNING LNK-RETURN-VALUE    OF LNK-WINBEEP
    END-CALL     

    GOBACK . 
    
 END PROGRAM winbeep.

*>******************************************************************************
*> Program:      winmsgbeep.cob
*>
*> Purpose:      COBOL wrapper for win_beep.c
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
 PROGRAM-ID. winmsgbeep.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-WINMSGBEEP.
   02 LNK-INPUT.
     03 LNK-SOUND-TYPE                 BINARY-SHORT UNSIGNED.
       88 V-SIMPLE-BEEP                VALUE H"FFFFFFFF".
       88 V-MB-ICONASTERISK            VALUE H"00000040".
       88 V-MB-ICONEXCLAMATION         VALUE H"00000030".
       88 V-MB-ICONERROR               VALUE H"00000010".
       88 V-MB-ICONHAND                VALUE H"00000010".
       88 V-MB-ICONINFORMATION         VALUE H"00000040".
       88 V-MB-ICONQUESTION            VALUE H"00000020".
       88 V-MB-ICONSTOP                VALUE H"00000010".
       88 V-MB-ICONWARNING             VALUE H"00000030".
       88 V-MB-OK                      VALUE H"00000000".
   02 LNK-OUTPUT.
     03 LNK-RETURN-VALUE               BINARY-SHORT.
        88 V-NOK                       VALUE 0.
 
 PROCEDURE DIVISION USING LNK-WINMSGBEEP.   
 
*>------------------------------------------------------------------------------
 MAIN-WINMSGBEEP SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT OF LNK-WINMSGBEEP

*>  call C function win_msg_beep
    CALL "win_msg_beep" 
         USING BY VALUE LNK-SOUND-TYPE   OF LNK-WINMSGBEEP
         RETURNING      LNK-RETURN-VALUE OF LNK-WINMSGBEEP
    END-CALL     

    GOBACK . 
    
 END PROGRAM winmsgbeep.
