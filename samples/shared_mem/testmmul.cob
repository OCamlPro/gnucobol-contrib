*>******************************************************************************
*>  testmmul.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  testmmul.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with testmmul.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      testmmul.cob
*>
*> Purpose:      Main test program for mmul.cob
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
 PROGRAM-ID. testmmul.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
*> CONSTANT definition
 COPY "copy_files/z-constants.cpy".

*> for CBL_OC_HOSTED
 01 ERRNO                              USAGE POINTER.
 01 ERR                                USAGE BINARY-LONG BASED.

 01 WS-ERROR-FLAG                      PIC 9(1).
    88 V-OK                            VALUE 0.
    88 V-ERROR                         VALUE 1.

*> for mmap / munmap
 01 MMAP-LEN                           BINARY-DOUBLE.
 01 MMAP-PROT                          BINARY-LONG.
 01 MMAP-FLAGS                         BINARY-LONG.
 01 MMAP-FD                            BINARY-LONG.
 01 MMAP-OFFSET                        BINARY-DOUBLE.      
 01 MUNMAP-RET                         BINARY-LONG. 
 01 WS-MMAP-LEN                        BINARY-DOUBLE.
 01 WS-SHARED-MEM-PTR                  USAGE POINTER.

*> based variables and pointers
 01 WS-PRIMES-TAB BASED.                           
   02 WS-PRIMES-TAB-LINE               OCCURS C-MAX-PRIMES TIMES.
     03 WS-PRIMES                      BINARY-DOUBLE.
 01 WS-PRIMES-TAB-PTR                  USAGE POINTER.

 01 WS-A-MOD-NUM-TAB BASED.                           
   02 WS-A-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-A-MOD-NUM                   BINARY-DOUBLE.
 01 WS-A-MOD-NUM-TAB-PTR               USAGE POINTER.
     
 01 WS-B-MOD-NUM-TAB BASED.                           
   02 WS-B-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-B-MOD-NUM                   BINARY-DOUBLE.
 01 WS-B-MOD-NUM-TAB-PTR               USAGE POINTER.
     
 01 WS-C-MOD-NUM-TAB BASED.                           
   02 WS-C-MOD-NUM-TAB-LINE            OCCURS C-MAX-PRIMES TIMES.
     03 WS-C-MOD-NUM                   BINARY-DOUBLE.
 01 WS-C-MOD-NUM-TAB-PTR               USAGE POINTER.

 01 WS-IND-1                           BINARY-DOUBLE. 

*> for function CURRENT-DATE 
 01 CURRENT-DATE-AND-TIME.
   02 CDT-YEAR                         PIC 9(4).
   02 CDT-MONTH                        PIC 9(2). *> 01-12
   02 CDT-DAY                          PIC 9(2). *> 01-31
   02 CDT-HOUR                         PIC 9(2). *> 00-23
   02 CDT-MINUTES                      PIC 9(2). *> 00-59
   02 CDT-SECONDS                      PIC 9(2). *> 00-59
   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99
   02 CDT-GMT-DIFF-HOURS               PIC S9(2) SIGN LEADING SEPARATE.
   02 CDT-GMT-DIFF-MINUTES             PIC 9(2). *> 00 OR 30 
 01 WS-DATE-TIME.
   02 CDT-YEAR                         PIC 9(4).
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-MONTH                        PIC 9(2). *> 01-12
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-DAY                          PIC 9(2). *> 01-31
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-HOUR                         PIC 9(2). *> 00-23
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-MINUTES                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-SECONDS                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE ".".
   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99

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
 
 PROCEDURE DIVISION.   
 
*>------------------------------------------------------------------------------
 MAIN-TESTMMUL SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE WS-ERROR-FLAG

    PERFORM INIT-ERRNO
    PERFORM ALLOC-SHARED-VARS

    PERFORM SET-START-VALUES

*>  current timestamp               
    MOVE FUNCTION CURRENT-DATE      
      TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME 
      TO WS-DATE-TIME
    DISPLAY "Start: " WS-DATE-TIME
    
*>  C(i) = A(i) * B(i)   mod P(i)
    PERFORM MODULAR-MUL

*>  current timestamp               
    MOVE FUNCTION CURRENT-DATE      
      TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME 
      TO WS-DATE-TIME
    DISPLAY "End  : " WS-DATE-TIME

    IF V-OK OF LNK-RESULT-FLAG OF LNK-MMUL
    THEN
       PERFORM CHECK-END-VALUES
    END-IF   
    
    PERFORM FREE-SHARED-VARS
    
    STOP RUN .

*>------------------------------------------------------------------------------
 INIT-ERRNO SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_OC_HOSTED" USING ERRNO 
                             , "errno"
    END-CALL
    
    IF ERRNO NOT = NULL 
    THEN
       SET ADDRESS OF ERR TO ERRNO
    ELSE
       SET V-ERROR OF WS-ERROR-FLAG TO TRUE 
       DISPLAY "Error at CBL_OC_HOSTED!"
       EXIT SECTION
    END-IF

    EXIT SECTION .

*>------------------------------------------------------------------------------
 SET-START-VALUES SECTION.
*>------------------------------------------------------------------------------

    IF V-ERROR OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    PERFORM VARYING WS-IND-1 FROM 1 BY 1 
      UNTIL WS-IND-1 > C-MAX-PRIMES
       MOVE 23 TO WS-PRIMES(WS-IND-1)
       MOVE 13 TO WS-A-MOD-NUM(WS-IND-1)
       MOVE 17 TO WS-B-MOD-NUM(WS-IND-1)
    END-PERFORM 
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 MODULAR-MUL SECTION.
*>------------------------------------------------------------------------------

    IF V-ERROR OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    INITIALIZE LNK-MMUL

    MOVE WS-PRIMES-TAB-PTR    TO LNK-PRIMES-TAB-PTR   
    MOVE WS-A-MOD-NUM-TAB-PTR TO LNK-A-MOD-NUM-TAB-PTR
    MOVE WS-B-MOD-NUM-TAB-PTR TO LNK-B-MOD-NUM-TAB-PTR
    MOVE WS-C-MOD-NUM-TAB-PTR TO LNK-C-MOD-NUM-TAB-PTR

*>  C = A * B   mod P
    CALL "mmul" USING LNK-MMUL END-CALL

    IF V-ERROR OF LNK-RESULT-FLAG OF LNK-MMUL
    THEN
       DISPLAY "Error in mmul!"    
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CHECK-END-VALUES SECTION.
*>------------------------------------------------------------------------------

    IF V-ERROR OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    PERFORM VARYING WS-IND-1 FROM 1 BY 1 
      UNTIL WS-IND-1 > C-MAX-PRIMES
       IF WS-C-MOD-NUM(WS-IND-1) NOT = 14
       THEN
          DISPLAY "PRIMES(" WS-IND-1 "): " WS-PRIMES(WS-IND-1)
          DISPLAY "     A(" WS-IND-1 "): " WS-A-MOD-NUM(WS-IND-1)
          DISPLAY "     B(" WS-IND-1 "): " WS-B-MOD-NUM(WS-IND-1)
          DISPLAY "     C(" WS-IND-1 "): " WS-C-MOD-NUM(WS-IND-1)
       END-IF
    END-PERFORM  

    EXIT SECTION .

*>------------------------------------------------------------------------------
 ALLOC-SHARED-VARS SECTION.
*>------------------------------------------------------------------------------

    IF V-ERROR OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

*>  primes
    MOVE FUNCTION LENGTH(WS-PRIMES-TAB) TO WS-MMAP-LEN
    PERFORM ALLOC-SHARED-MEM
    MOVE WS-SHARED-MEM-PTR TO WS-PRIMES-TAB-PTR
    SET ADDRESS OF WS-PRIMES-TAB TO WS-PRIMES-TAB-PTR

*>  A
    MOVE FUNCTION LENGTH(WS-A-MOD-NUM-TAB) TO WS-MMAP-LEN
    PERFORM ALLOC-SHARED-MEM
    MOVE WS-SHARED-MEM-PTR TO WS-A-MOD-NUM-TAB-PTR
    SET ADDRESS OF WS-A-MOD-NUM-TAB TO WS-A-MOD-NUM-TAB-PTR

*>  B
    MOVE FUNCTION LENGTH(WS-B-MOD-NUM-TAB) TO WS-MMAP-LEN
    PERFORM ALLOC-SHARED-MEM
    MOVE WS-SHARED-MEM-PTR TO WS-B-MOD-NUM-TAB-PTR
    SET ADDRESS OF WS-B-MOD-NUM-TAB TO WS-B-MOD-NUM-TAB-PTR

*>  C
    MOVE FUNCTION LENGTH(WS-C-MOD-NUM-TAB) TO WS-MMAP-LEN
    PERFORM ALLOC-SHARED-MEM
    MOVE WS-SHARED-MEM-PTR TO WS-C-MOD-NUM-TAB-PTR
    SET ADDRESS OF WS-C-MOD-NUM-TAB TO WS-C-MOD-NUM-TAB-PTR

    EXIT SECTION .

*>------------------------------------------------------------------------------
 FREE-SHARED-VARS SECTION.
*>------------------------------------------------------------------------------

*>  primes
    MOVE FUNCTION LENGTH(WS-PRIMES-TAB) TO WS-MMAP-LEN
    MOVE WS-PRIMES-TAB-PTR TO WS-SHARED-MEM-PTR
    PERFORM FREE-SHARED-MEM

*>  A
    MOVE FUNCTION LENGTH(WS-A-MOD-NUM-TAB) TO WS-MMAP-LEN
    MOVE WS-A-MOD-NUM-TAB-PTR TO WS-SHARED-MEM-PTR
    PERFORM FREE-SHARED-MEM

*>  B
    MOVE FUNCTION LENGTH(WS-B-MOD-NUM-TAB) TO WS-MMAP-LEN
    MOVE WS-B-MOD-NUM-TAB-PTR TO WS-SHARED-MEM-PTR
    PERFORM FREE-SHARED-MEM

*>  C
    MOVE FUNCTION LENGTH(WS-C-MOD-NUM-TAB) TO WS-MMAP-LEN
    MOVE WS-C-MOD-NUM-TAB-PTR TO WS-SHARED-MEM-PTR
    PERFORM FREE-SHARED-MEM

    EXIT SECTION .

*>------------------------------------------------------------------------------
 ALLOC-SHARED-MEM SECTION.
*>------------------------------------------------------------------------------

*>  check input
    IF WS-MMAP-LEN <= ZEROES
    THEN
       SET V-ERROR OF WS-ERROR-FLAG TO TRUE 
       DISPLAY "Wrong input length in ALLOC-SHARED-MEM!"
       EXIT SECTION
    END-IF   

*>  void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
*>  prot  = PROT_READ  | PROT_WRITE    = (0x01|0x02) => 3
*>  flags = MAP_SHARED | MAP_ANONYMOUS = (0x01|0x20) => 33
    MOVE WS-MMAP-LEN TO MMAP-LEN
    MOVE 3  TO MMAP-PROT
    MOVE 33 TO MMAP-FLAGS
    MOVE -1 TO MMAP-FD
    MOVE 0  TO MMAP-OFFSET
          
    CALL STATIC "mmap" USING NULL
                           , BY VALUE MMAP-LEN
                           , BY VALUE MMAP-PROT
                           , BY VALUE MMAP-FLAGS
                           , BY VALUE MMAP-FD
                           , BY VALUE MMAP-OFFSET
         RETURNING WS-SHARED-MEM-PTR
    END-CALL    

    IF ERR NOT = ZEROES
    THEN
       SET V-ERROR OF WS-ERROR-FLAG TO TRUE 
       DISPLAY "Error in mmap!"
       DISPLAY "ERRNO            : " ERR    
       DISPLAY "WS-SHARED-MEM-PTR: " WS-SHARED-MEM-PTR
       EXIT SECTION
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 FREE-SHARED-MEM SECTION.
*>------------------------------------------------------------------------------

*>  check input
    IF WS-MMAP-LEN <= ZEROES
    THEN
       SET V-ERROR OF WS-ERROR-FLAG TO TRUE 
       DISPLAY "Wrong input length in FREE-SHARED-MEM!"
       EXIT SECTION
    END-IF   
    
*>  int munmap(void *addr, size_t length);
    CALL STATIC "munmap" USING BY VALUE WS-SHARED-MEM-PTR
                             , BY VALUE WS-MMAP-LEN
         RETURNING MUNMAP-RET
    END-CALL    

    IF MUNMAP-RET NOT = ZEROES
    THEN
       SET V-ERROR OF WS-ERROR-FLAG TO TRUE 
       DISPLAY "Error in munmap!"
       DISPLAY "MUNMAP-RET       : " MUNMAP-RET    
       DISPLAY "ERRNO            : " ERR    
       DISPLAY "WS-SHARED-MEM-PTR: " WS-SHARED-MEM-PTR
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
 END PROGRAM testmmul.
