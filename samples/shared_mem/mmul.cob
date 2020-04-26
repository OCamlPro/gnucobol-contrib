*>******************************************************************************
*>  mmul.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  mmul.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with mmul.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      mmul.cob
*>
*> Purpose:      Modular multiplication module
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020-04-26
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2020-04-26 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. mmul.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
*> CONSTANT definition
 COPY "copy_files/z-constants.cpy".

*> based variables
 01 WS-PRIMES-TAB BASED.                           
   02 WS-PRIMES-TAB-LINE               OCCURS C-MAX-PRIMES TIMES.
     03 WS-PRIMES                      BINARY-DOUBLE.

 01 WS-A-MOD-NUM-TAB BASED.                           
   02 WS-A-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-A-MOD-NUM                   BINARY-DOUBLE.
     
 01 WS-B-MOD-NUM-TAB BASED.                           
   02 WS-B-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-B-MOD-NUM                   BINARY-DOUBLE.
     
 01 WS-C-MOD-NUM-TAB BASED.                           
   02 WS-C-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-C-MOD-NUM                   BINARY-DOUBLE.

 01 WS-IND-1                           BINARY-DOUBLE. 
 01 WS-IND-2                           BINARY-DOUBLE. 
 01 WS-IND-3                           BINARY-DOUBLE. 

 01 WS-START-IND                       BINARY-DOUBLE. 
 01 WS-END-IND                         BINARY-DOUBLE. 
 01 WS-INTERVAL                        BINARY-DOUBLE. 
 01 WS-DIVISOR                         BINARY-DOUBLE.

*> process IDs
 01 WS-CHILD-PID-TAB.                           
   02 WS-CHILD-PID-TAB-LINE            OCCURS C-MAX-NUM-CHILD-PID TIMES.
     03 WS-CHILD-PID                   PIC S9(9) BINARY.
*> wait process status
 01 WS-WAIT-STS                        PIC S9(9) BINARY.

 LINKAGE SECTION.
 01 LNK-MMUL.
   02 LNK-INPUT.
     03 LNK-PRIMES-TAB-PTR             USAGE POINTER.
     03 LNK-A-MOD-NUM-TAB-PTR          USAGE POINTER. 
     03 LNK-B-MOD-NUM-TAB-PTR          USAGE POINTER.
     03 LNK-C-MOD-NUM-TAB-PTR          USAGE POINTER.
   02 LNK-OUTPUT.
     03 LNK-RESULT-FLAG                PIC 9(1).
        88 V-OK                        VALUE 0.
        88 V-ERROR                     VALUE 1.
 
 PROCEDURE DIVISION USING LNK-MMUL.   
 
*>------------------------------------------------------------------------------
 MAIN-MMUL SECTION.
*>------------------------------------------------------------------------------

*>  set based variables to pointers
    SET ADDRESS OF WS-PRIMES-TAB    TO LNK-PRIMES-TAB-PTR    
    SET ADDRESS OF WS-A-MOD-NUM-TAB TO LNK-A-MOD-NUM-TAB-PTR 
    SET ADDRESS OF WS-B-MOD-NUM-TAB TO LNK-B-MOD-NUM-TAB-PTR 
    SET ADDRESS OF WS-C-MOD-NUM-TAB TO LNK-C-MOD-NUM-TAB-PTR 

*>  compute interval for start / end index
    COMPUTE WS-DIVISOR = C-MAX-NUM-CHILD-PID - 1 END-COMPUTE
    IF WS-DIVISOR > ZEROES
    THEN
       DIVIDE WS-DIVISOR INTO C-MAX-PRIMES
          GIVING WS-INTERVAL
       END-DIVIDE   
    ELSE   
       MOVE C-MAX-PRIMES TO WS-INTERVAL
    END-IF   
    
    PERFORM FORK-PROGRAM 

    GOBACK . 

*>------------------------------------------------------------------------------
 FORK-PROGRAM SECTION.
*>------------------------------------------------------------------------------

*>  set first start / end interval
    MOVE 1           TO WS-START-IND
    MOVE WS-INTERVAL TO WS-END-IND  

    PERFORM VARYING WS-IND-1 FROM 1 BY 1 
      UNTIL WS-IND-1 > C-MAX-NUM-CHILD-PID
       CALL "CBL_GC_FORK" RETURNING WS-CHILD-PID(WS-IND-1) END-CALL
       EVALUATE TRUE
          WHEN WS-CHILD-PID(WS-IND-1) = ZEROES
             PERFORM CHILD-CODE
          WHEN WS-CHILD-PID(WS-IND-1) > ZEROES
*>           parent code after PERFORM VARYING
             CONTINUE
          WHEN WS-CHILD-PID(WS-IND-1) = -1
             DISPLAY 'CBL_GC_FORK is not available '
                     'on the current system!'
             END-DISPLAY
             SET V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL TO TRUE
             EXIT SECTION
          WHEN OTHER
             MULTIPLY -1 BY WS-CHILD-PID(WS-IND-1) END-MULTIPLY
             DISPLAY 'CBL_GC_FORK returned system error: '
                     WS-CHILD-PID(WS-IND-1)
             END-DISPLAY
             SET V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL TO TRUE
             EXIT SECTION
       END-EVALUATE
*>     update start / end interval
       ADD WS-INTERVAL TO WS-START-IND WS-END-IND END-ADD
    END-PERFORM

    PERFORM PARENT-CODE

    EXIT SECTION .

*>------------------------------------------------------------------------------
 PARENT-CODE SECTION.
*>------------------------------------------------------------------------------
    
    PERFORM VARYING WS-IND-2 FROM 1 BY 1 
      UNTIL WS-IND-2 > C-MAX-NUM-CHILD-PID
*>     wait until child process terminate
       CALL "CBL_GC_WAITPID" USING WS-CHILD-PID(WS-IND-2) 
                             RETURNING WS-WAIT-STS 
       END-CALL
       MOVE ZEROES TO RETURN-CODE
       EVALUATE TRUE
          WHEN WS-WAIT-STS >= ZEROES
*>           Size error in RETURN-CODE         
             IF WS-WAIT-STS = 3
             THEN
                DISPLAY 'Child ended with status: '
                        WS-WAIT-STS ", WS-IND-2: " WS-IND-2
                END-DISPLAY
                SET V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL TO TRUE
                EXIT SECTION
             END-IF
          WHEN WS-WAIT-STS = -1
             DISPLAY 'CBL_GC_WAITPID is not available '
                     'on the current system!'
             END-DISPLAY
             SET V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL TO TRUE
             EXIT SECTION
          WHEN WS-WAIT-STS < -1
             MULTIPLY -1 BY WS-WAIT-STS END-MULTIPLY
             DISPLAY 'CBL_GC_WAITPID returned system error: ' WS-WAIT-STS
             END-DISPLAY
             SET V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL TO TRUE
             EXIT SECTION
       END-EVALUATE
    END-PERFORM
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CHILD-CODE SECTION.
*>------------------------------------------------------------------------------

*>  we get back the RETURN-CODE at CALL "CBL_GC_WAITPID" in WS-WAIT-STS 
*>  2 - OK
*>  3 - Size error
    MOVE 2 TO RETURN-CODE

    DISPLAY "Start child: " WS-IND-1
    DISPLAY "WS-START-IND: " WS-START-IND ", WS-END-IND: " WS-END-IND

    PERFORM MUL-A-BY-B-MOD-P 

    DISPLAY "End child: " WS-IND-1

*>  always stop child at the end
    STOP RUN

    EXIT SECTION .

*>------------------------------------------------------------------------------
 MUL-A-BY-B-MOD-P SECTION.
*>------------------------------------------------------------------------------

*>  multiply only in an interval from WS-START-IND to WS-END-IND    
    PERFORM VARYING WS-IND-3 FROM WS-START-IND BY 1 
      UNTIL WS-IND-3 > WS-END-IND
         OR WS-IND-3 > C-MAX-PRIMES
       MULTIPLY WS-A-MOD-NUM(WS-IND-3) BY WS-B-MOD-NUM(WS-IND-3) 
           GIVING WS-C-MOD-NUM(WS-IND-3)
           ON SIZE ERROR DISPLAY "Size error in MUL-A-BY-B-GIVING SECTION!"
*>                       we get back the RETURN-CODE at CALL "CBL_GC_WAITPID" in WS-WAIT-STS 
                         MOVE 3 TO RETURN-CODE
                         EXIT SECTION
       END-MULTIPLY
*>     normalization
       IF WS-C-MOD-NUM(WS-IND-3) >= WS-PRIMES(WS-IND-3)
       THEN
          COMPUTE WS-C-MOD-NUM(WS-IND-3) = 
                  FUNCTION MOD(WS-C-MOD-NUM(WS-IND-3), WS-PRIMES(WS-IND-3))
          END-COMPUTE                                
       END-IF
    END-PERFORM
    
    EXIT SECTION .
    
 END PROGRAM mmul.
