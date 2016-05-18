*>******************************************************************************
*>  This file is part of cobsha3.
*>
*>  SHAKE256.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  SHAKE256.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with SHAKE256.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      SHAKE256.cob
*>
*> Purpose:      This module computes SHAKE256 on the input message. 
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2016.05.17
*>
*> Tectonics:    cobc -m -free SHAKE256.cob KECCAK.o
*>
*> Usage:        Call this module in your application.
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2016.05.17 Laszlo Erdos: 
*>            - First version created.
*>------------------------------------------------------------------------------
*> yyyy.mm.dd
*>
*>******************************************************************************


*>******************************************************************************
*> Module to compute SHAKE256 on the input message with any output length.
*>******************************************************************************
 IDENTIFICATION DIVISION.
 PROGRAM-ID. SHAKE256.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 LNK-KECCAK-RATE                    BINARY-LONG UNSIGNED.
 01 LNK-KECCAK-CAPACITY                BINARY-LONG UNSIGNED.
 01 LNK-KECCAK-DELIMITED-SUFFIX        PIC X.
 
 LINKAGE SECTION.
 01 LNK-SHAKE256-INPUT                 PIC X ANY LENGTH.
 01 LNK-SHAKE256-INPUT-BYTE-LEN        BINARY-DOUBLE UNSIGNED.
 01 LNK-SHAKE256-OUTPUT                PIC X ANY LENGTH.
 01 LNK-SHAKE256-OUTPUT-BYTE-LEN       BINARY-DOUBLE UNSIGNED.
 
 PROCEDURE DIVISION USING LNK-SHAKE256-INPUT          
                          LNK-SHAKE256-INPUT-BYTE-LEN 
                          LNK-SHAKE256-OUTPUT         
                          LNK-SHAKE256-OUTPUT-BYTE-LEN.
 
*>------------------------------------------------------------------------------
 MAIN-SHAKE256 SECTION.
*>------------------------------------------------------------------------------

    MOVE 1088  TO LNK-KECCAK-RATE
    MOVE 512   TO LNK-KECCAK-CAPACITY
    MOVE X"1F" TO LNK-KECCAK-DELIMITED-SUFFIX

    CALL "KECCAK" USING LNK-KECCAK-RATE            
                        LNK-KECCAK-CAPACITY        
                        LNK-SHAKE256-INPUT           
                        LNK-SHAKE256-INPUT-BYTE-LEN  
                        LNK-KECCAK-DELIMITED-SUFFIX
                        LNK-SHAKE256-OUTPUT          
                        LNK-SHAKE256-OUTPUT-BYTE-LEN 
    END-CALL
    
    GOBACK
    
    .
 MAIN-SHAKE256-EX.
    EXIT.
 END PROGRAM SHAKE256.
