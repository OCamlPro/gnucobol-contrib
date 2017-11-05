*>******************************************************************************
*>  prothtest.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  prothtest.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with prothtest.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      prothtest.cob
*>
*> Purpose:      This is a primality test for Proth numbers
*>               http://en.wikipedia.org/wiki/Proth%27s_theorem
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.05.14
*>
*> Tectonics:    cobc -c -free prothtest.cob -o prothtest.o
*>
*> Usage:        This module implements the Proth primality test. For the used
*>               algorithm please see the readme.txt file.
*>               To use this module, simply CALL it as follows: 
*>               CALL "prothtest" USING LNK-PROTHTEST. 
*>               For more information please see the comments in the linkage
*>               section.
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2015.05.14 Laszlo Erdos: 
*>            First version created.
*> 2017.03.25 Laszlo Erdos / Error corrections: 
*>            TO phrase without DEPENDING phrase in table definition.
*> 2017.10.19 Laszlo Erdos: 
*>            - GMP mpz_powm() function replaced with other algorithm.
*>            - small-prime test with parameter.
*>            - Save / Load state.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. prothtest.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
    SELECT OPTIONAL                    LOG-PTEST-FILE 
           ASSIGN                      TO WS-LOG-FILE-NAME
           STATUS                      IS WS-LOG-FILE-STATUS
           ORGANIZATION                IS LINE SEQUENTIAL.

 DATA DIVISION.
 FILE SECTION.
 FD LOG-PTEST-FILE.
 01 LOG-PTEST-FILE-LINE.
   02 LOG-PTEST-TEXT                   PIC X(45).
   02 LOG-PTEST-SPACE                  PIC X(01).
   02 LOG-PTEST-DATE-TIME              PIC X(22).

 WORKING-STORAGE SECTION.
*> gmp variables have a type of mpz_t struct
*> 2^n
 01 WS-GMP-POW-2.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> the Proth number: k*2^n + 1
 01 WS-GMP-PROTH-NUMBER.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> equal with (ws-gmp-proth-nummer - 1) / 2   
 01 WS-GMP-PROTH-NUMBER-2.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> for mpz_powm()   
 01 WS-GMP-POWM-BASE.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
 01 WS-GMP-POWM-RESULT.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
 01 WS-GMP-POWM-RESULT-LOAD.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> for the Jacobi check
 01 WS-GMP-JACOBI-A.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> square root of Proth number   
 01 WS-GMP-PROTH-NUMBER-SQRT.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> for compare   
 01 WS-GMP-HELP-VAR.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
*> for mod Proth number
 01 WS-GMP-A.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
 01 WS-GMP-B.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
 01 WS-GMP-Q.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
 01 WS-GMP-R.
   02 MP-ALLOC                         BINARY-INT SYNC.
   02 MP-SIZE                          BINARY-INT SYNC.
   02 MP-D                             USAGE POINTER SYNC.
   
 01 WS-GMP-INIT-FLAG                   PIC 9(1).
    88 V-GMP-INIT-NO                   VALUE 0.
    88 V-GMP-INIT-YES                  VALUE 1.
 01 WS-LOAD-SUCCESS-FLAG               PIC 9(1).
    88 V-LOAD-SUCCESS-NO               VALUE 0.
    88 V-LOAD-SUCCESS-YES              VALUE 1.
   
 01 WS-POWM-BASE                       BINARY-LONG UNSIGNED.
   
*> small primes for the Jacobi symbol (a/p)
 01 C-A-TAB-MAX-LINE                   CONSTANT AS 25.
 01 WS-A-TAB.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE  2.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE  3.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE  5.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE  7.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 11.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 13.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 17.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 19.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 23.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 29.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 31.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 37.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 41.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 43.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 47.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 53.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 59.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 61.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 67.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 71.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 73.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 79.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 83.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 89.
   02 FILLER                           BINARY-LONG UNSIGNED VALUE 97.
 01 WS-A-TAB-R REDEFINES WS-A-TAB.                           
   02 WS-A-TAB-LINE                    OCCURS C-A-TAB-MAX-LINE TIMES.
     03 WS-A                           BINARY-LONG UNSIGNED.

*> small prime for the division precheck   
*> WS-SMALL-PRIME = 6 * WS-MAX-SMALL-PRIME + 1;
*> WS-MAX-SMALL-PRIME = (WS-SMALL-PRIME - 1) / 6;
*> and a BINARY-LONG UNSIGNED can be max.: 4,294,967,295;
*> WS-MAX-SMALL-PRIME = (4,294,967,295 - 1) / 6 ==> 715,827,882
 01 C-DEFAULT-MAX-SMALL-PRIME          CONSTANT AS 20000.
 01 WS-MAX-SMALL-PRIME                 BINARY-LONG UNSIGNED.
 01 WS-SMALL-PRIME                     BINARY-LONG UNSIGNED.
 01 WS-DIVTEST-END-FLAG                PIC 9(1).
    88 V-DIVTEST-END-NO                VALUE 0.
    88 V-DIVTEST-END-YES               VALUE 1.
     
 01 WS-IND                             BINARY-LONG UNSIGNED.
 01 WS-COUNTDOWN-IND                   BINARY-LONG UNSIGNED.

*> number of bits in WS-GMP-PROTH-NUMBER-2 
 01 WS-BIT-LEN-2                       BINARY-LONG UNSIGNED.
 01 WS-COUNTDOWN-START                 BINARY-LONG UNSIGNED.
 01 WS-COUNTDOWN-START-LOAD            BINARY-LONG UNSIGNED.
 01 WS-COUNTDOWN-START-DISP            PIC 9(10).
 
*> function return value 
 01 WS-RET-1                           BINARY-INT.
 01 WS-RET-2                           BINARY-LONG UNSIGNED.
 01 WS-CMP-RET-1                       BINARY-INT.
 01 WS-CMP-RET-2                       BINARY-INT.
 
*> for div test 
 01 WS-DIVIDEND                        BINARY-LONG UNSIGNED.
 01 WS-DIVISOR                         BINARY-LONG UNSIGNED.
 01 WS-QUOTIENT                        BINARY-LONG UNSIGNED.
 01 WS-REMAINDER                       BINARY-LONG UNSIGNED.

*> if the parameter "write-file" is set, then a Proth_Primes dir will be created
 01 WS-PROTH-PRIME-DIR                 PIC X(12) VALUE "Proth_Primes".
 
*> save Proth number in a file
 01 WS-FILE-POINTER                    USAGE POINTER.
 01 WS-FILE-NAME                       PIC X(28).   
 01 WS-FILE-NAME-R REDEFINES WS-FILE-NAME.
   02 WS-FILE-NAME-K                   PIC X(01).
   02 WS-FILE-NAME-K-NUM               PIC 9(10).
   02 WS-FILE-NAME-SPLIT               PIC X(01).
   02 WS-FILE-NAME-N                   PIC X(01).
   02 WS-FILE-NAME-N-NUM               PIC 9(10).
   02 WS-FILE-NAME-TYP                 PIC X(04).
*> end of string
   02 WS-FILE-NAME-EOS                 PIC X(01).

*> for save, restore data
 01 WS-SAVE-STATE-DIR                  PIC X(34).
 01 WS-SAVE-STATE-DIR-R REDEFINES WS-SAVE-STATE-DIR.
   02 WS-SAVE-DIR-NAME-K               PIC X(12).
   02 WS-SAVE-DIR-NAME-K-NUM           PIC 9(10).
   02 WS-SAVE-DIR-NAME-SPLIT           PIC X(01).
   02 WS-SAVE-DIR-NAME-N               PIC X(01).
   02 WS-SAVE-DIR-NAME-N-NUM           PIC 9(10).
   
 01 WS-SAVE-FILE-POINTER               USAGE POINTER.
 01 WS-SAVE-FILE-NAME                  PIC X(45).   
 01 WS-SAVE-FILE-NAME-R REDEFINES WS-SAVE-FILE-NAME.
   02 WS-SAVE-FILE-NAME-K              PIC X(06).
   02 WS-SAVE-FILE-NAME-K-NUM          PIC 9(10).
   02 WS-SAVE-FILE-NAME-SPLIT-1        PIC X(01).
   02 WS-SAVE-FILE-NAME-N              PIC X(01).
   02 WS-SAVE-FILE-NAME-N-NUM          PIC 9(10).
   02 WS-SAVE-FILE-NAME-SPLIT-2        PIC X(01).
   02 WS-SAVE-FILE-NAME-C              PIC X(01).
   02 WS-SAVE-FILE-NAME-C-NUM          PIC 9(10).
   02 WS-SAVE-FILE-NAME-TYP            PIC X(04).
*> end of string
   02 WS-SAVE-FILE-NAME-EOS            PIC X(01).

 01 WS-LAST-SAVED-FILE-NAME-1          PIC X(45).   
 01 WS-LAST-SAVED-FILE-NAME-2          PIC X(45).   
   
*> file name
 01 WS-LOG-FILE-NAME                   PIC X(32).
 01 WS-LOG-FILE-NAME-R REDEFINES WS-LOG-FILE-NAME.
   02 WS-LOG-FILE-NAME-K               PIC X(05) VALUE "LOG-K".
   02 WS-LOG-FILE-NAME-K-NUM           PIC 9(10).
   02 WS-LOG-FILE-NAME-SPLIT           PIC X(01) VALUE "-".
   02 WS-LOG-FILE-NAME-N               PIC X(01) VALUE "N".
   02 WS-LOG-FILE-NAME-N-NUM           PIC 9(10).
   02 WS-LOG-FILE-NAME-TYP             PIC X(04) VALUE ".txt".
*> end of string                       
   02 WS-LOG-FILE-NAME-EOS             PIC X(01) VALUE X"00".
 
*> file-status
 01 WS-LOG-FILE-STATUS                 PIC 9(02).
    88 V-LOG-FILE-OK                   VALUE 00.
    88 V-LOG-FILE-OPTIONAL             VALUE 05.
    88 V-LOG-FILE-EOF                  VALUE 10.

 01 WS-LOG-PTEST-TEXT                  PIC X(45).

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
 
 LINKAGE SECTION.
*> for the prothtest module 
 01 LNK-PROTHTEST.
   02 LNK-INPUT.
*>   k in: k*2^n + 1
     03 LNK-K                          BINARY-LONG UNSIGNED.
*>   n exponent in: k*2^n + 1          
     03 LNK-N                          BINARY-LONG UNSIGNED.
*>   diplay more information           
     03 LNK-VERBOSE-FLAG               PIC 9(1).
        88 V-VERBOSE-NO                VALUE 0.
        88 V-VERBOSE-YES               VALUE 1.
*>   write Proth numbers in files      
     03 LNK-WRITE-FILE-FLAG            PIC 9(1).
        88 V-WRITE-FILE-NO             VALUE 0.
        88 V-WRITE-FILE-YES            VALUE 1.
*>   precheck only                     
     03 LNK-PRECHECK-ONLY-FLAG         PIC 9(1).
        88 V-PRECHECK-ONLY-NO          VALUE 0.
        88 V-PRECHECK-ONLY-YES         VALUE 1.
*>   for small primes division test 20,000 <= LNK-MAX-SMALL-PRIME <= 715,827,882
     03 LNK-MAX-SMALL-PRIME            BINARY-LONG UNSIGNED.
*>   save state after num counter step 
     03 LNK-SAVE-FLAG                  PIC 9(1).
        88 V-SAVE-NO                   VALUE 0.
        88 V-SAVE-YES                  VALUE 1.
*>   save num counter                  
     03 LNK-SAVE-NUM                   BINARY-LONG UNSIGNED.
*>   load last saved state             
     03 LNK-LOAD-FLAG                  PIC 9(1).
        88 V-LOAD-NO                   VALUE 0.
        88 V-LOAD-YES                  VALUE 1.
   02 LNK-OUTPUT.                      
*>   flag                              
     03 LNK-RESULT-FLAG                PIC 9(2).
        88 V-NO-RESULT                 VALUE  0.
        88 V-PRIME-NO                  VALUE  1.
        88 V-PRIME-YES                 VALUE  2.
        88 V-NO-JACOBI-FOUND           VALUE  3.
        88 V-K-GE-2-POWER-N            VALUE  4.
        88 V-K-NOT-ODD                 VALUE  5.
        88 V-NOT-IN-SIX-PLUS-MINUS-1   VALUE  6.
        88 V-WRITE-FILE-ERROR          VALUE  7.
        88 V-READ-FILE-ERROR           VALUE  8.
        88 V-CLOSE-FILE-ERROR          VALUE  9.
        88 V-DELETE-FILE-ERROR         VALUE 10.
        88 V-CHANGE-DIR-ERROR          VALUE 11.
*>   number of digits                  
     03 LNK-PROTHTEST-DIGITS           BINARY-LONG UNSIGNED.
*>   "a" in Jacobi symbol (a/p)        
     03 LNK-JACOBI-A-NUM               BINARY-LONG UNSIGNED.
*>   the divisor, if not prime         
     03 LNK-DIVISOR                    BINARY-LONG UNSIGNED.
 
 PROCEDURE DIVISION USING LNK-PROTHTEST.

*>------------------------------------------------------------------------------
 MAIN-PROTHTEST SECTION.
*>------------------------------------------------------------------------------

*>  init flags
    SET V-GMP-INIT-NO OF WS-GMP-INIT-FLAG TO TRUE
    SET V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE

*>  K must be odd
    PERFORM CHECK-K-ODD    

*>  allocate memory     
    IF V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    THEN
       SET V-GMP-INIT-YES OF WS-GMP-INIT-FLAG TO TRUE
       PERFORM INIT-GMP-FIELDS
    END-IF
    
*>  compute the Proth number
    IF V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    THEN
       PERFORM COMP-PROTH-NUMBER
    END-IF

*>  compute the Jacobi symbol (a/p)
    IF V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    THEN
       PERFORM COMP-JACOBI-SYMBOL
    END-IF

*>  6*j-1 and 6*j+1 test
    IF V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    THEN
       PERFORM SIX-PLUS-MINUS-1-TEST
    END-IF

*>  divide the Proth number with small primes
    IF V-NO-RESULT OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    THEN
       PERFORM SMALL-PRIMES-DIVISION-TEST
    END-IF
    
*>  start the Proth primality test    
    IF  V-NO-RESULT        OF LNK-RESULT-FLAG        OF LNK-PROTHTEST
    AND V-PRECHECK-ONLY-NO OF LNK-PRECHECK-ONLY-FLAG OF LNK-PROTHTEST
    THEN
       PERFORM PROTH-PRIMALITY-TEST
    END-IF

*>  free memory
    IF V-GMP-INIT-YES OF WS-GMP-INIT-FLAG
    THEN
       PERFORM CLEAR-GMP-FIELDS
    END-IF
    
    GOBACK
    .
    
*>------------------------------------------------------------------------------
 CHECK-K-ODD SECTION.
*>------------------------------------------------------------------------------

    MOVE LNK-K OF LNK-PROTHTEST TO WS-DIVIDEND
    MOVE 2                      TO WS-DIVISOR
    
    DIVIDE WS-DIVISOR INTO WS-DIVIDEND
       GIVING    WS-QUOTIENT
       REMAINDER WS-REMAINDER
    END-DIVIDE   

    IF WS-REMAINDER = ZEROES
    THEN
       SET V-K-NOT-ODD OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
    END-IF
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 INIT-GMP-FIELDS SECTION.
*>------------------------------------------------------------------------------

*>  If an application can estimate the final size, then the second parameter
*>  can be set to allocate the necessary space (for n-bit numbers) from the 
*>  beginning. It doesn’t matter if a size set with mpz_init2 is too small, 
*>  since all functions in GMP will do a further reallocation if necessary. But 
*>  repeatedly realloced memory could be quite slow or could fragment memory.
    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-POW-2
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-POWM-BASE
               BY VALUE     80
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-POWM-RESULT-LOAD
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-JACOBI-A
               BY VALUE     80
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     80
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-A
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-B
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-Q
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_init2" 
         USING BY REFERENCE WS-GMP-R
               BY VALUE     400000000
         RETURNING OMITTED
    END-CALL     
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 COMP-PROTH-NUMBER SECTION.
*>------------------------------------------------------------------------------

*>  compute the PROTH number: k*2^n + 1
    CALL STATIC "mpz_ui_pow_ui" 
         USING BY REFERENCE WS-GMP-POW-2
               BY VALUE     2
               BY VALUE     LNK-N OF LNK-PROTHTEST
         RETURNING OMITTED
    END-CALL     

*>  prepare compare, move K to help-var    
    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     LNK-K OF LNK-PROTHTEST
         RETURNING OMITTED
    END-CALL     

*>  compare: k < 2^n
    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-POW-2
               BY REFERENCE WS-GMP-HELP-VAR
         RETURNING WS-RET-1
    END-CALL     

*>  compare result    
    IF WS-RET-1 = ZEROES
    OR WS-RET-1 < ZEROES
    THEN
       SET V-K-GE-2-POWER-N OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
    END-IF
    
    CALL STATIC "mpz_mul_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY REFERENCE WS-GMP-POW-2
               BY VALUE     LNK-K OF LNK-PROTHTEST
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_add_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*> compute (proth-nummer - 1) / 2   
    CALL STATIC "mpz_sub_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_tdiv_q_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY VALUE     2
         RETURNING WS-RET-2
    END-CALL     
    
    CALL STATIC "mpz_sizeinbase" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     10
         RETURNING WS-RET-2
    END-CALL     

    MOVE WS-RET-2 TO LNK-PROTHTEST-DIGITS
    
    CALL STATIC "mpz_sizeinbase" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY VALUE     2
         RETURNING WS-RET-2
    END-CALL     

*>  Number of bits in Proth num-2       
    MOVE WS-RET-2 TO WS-BIT-LEN-2
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 COMP-JACOBI-SYMBOL SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND FROM 1 BY 1
      UNTIL WS-IND > C-A-TAB-MAX-LINE

*>     prepare Jacobi check, move WS-A(WS-IND) to WS-GMP-JACOBI-A   
       CALL STATIC "mpz_set_ui" 
            USING BY REFERENCE WS-GMP-JACOBI-A
                  BY VALUE     WS-A(WS-IND)
            RETURNING OMITTED
       END-CALL     
      
*>     Compute the Jacobi symbol (a/p). The p is the Proth number.
*>     The Jacobi symbol is defined only for p odd.
       CALL STATIC "mpz_jacobi" 
            USING BY REFERENCE WS-GMP-JACOBI-A
                  BY REFERENCE WS-GMP-PROTH-NUMBER
            RETURNING WS-RET-1
       END-CALL     
       
       IF WS-RET-1 = -1
       THEN
*>        Jacobi "a" number found
          MOVE WS-A(WS-IND) TO WS-POWM-BASE
          MOVE WS-A(WS-IND) TO LNK-JACOBI-A-NUM
          EXIT SECTION       
       END-IF
    END-PERFORM
    
    SET V-NO-JACOBI-FOUND OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 SIX-PLUS-MINUS-1-TEST SECTION.
*>------------------------------------------------------------------------------

*>  compare: Proth number >= 5 ?
    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     5
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY REFERENCE WS-GMP-HELP-VAR
         RETURNING WS-RET-1
    END-CALL     
    
*>  check compare result, exit if < 5 
    IF WS-RET-1 < ZEROES
    THEN
       EXIT SECTION
    END-IF

*>  the sequence 6*j-1 and 6*j+1 includes all primes   
    CALL STATIC "mpz_sub_ui" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*>  return non-zero if the number is exactly divisible     
    CALL STATIC "mpz_divisible_ui_p" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     6
         RETURNING WS-CMP-RET-1
    END-CALL     

    CALL STATIC "mpz_add_ui" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*>  return non-zero if the number is exactly divisible     
    CALL STATIC "mpz_divisible_ui_p" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     6
         RETURNING WS-CMP-RET-2
    END-CALL     
    
    IF  WS-CMP-RET-1 = ZEROES
    AND WS-CMP-RET-2 = ZEROES
    THEN
       SET V-NOT-IN-SIX-PLUS-MINUS-1 OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       EXIT SECTION       
    END-IF
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 SMALL-PRIMES-DIVISION-TEST SECTION.
*>------------------------------------------------------------------------------

*>  square root of Proth number
    CALL STATIC "mpz_sqrt" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
               BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING OMITTED
    END-CALL     

*>  add 1 to square root of Proth number    
    CALL STATIC "mpz_add_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
               BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*>  divide the Proth number with small primes
    MOVE 2 TO WS-SMALL-PRIME
    SET V-DIVTEST-END-NO OF WS-DIVTEST-END-FLAG TO TRUE
    PERFORM DIVISION-TEST
    IF V-DIVTEST-END-YES OF WS-DIVTEST-END-FLAG
    OR V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST
       EXIT SECTION
    END-IF
    
    MOVE 3 TO WS-SMALL-PRIME
    SET V-DIVTEST-END-NO OF WS-DIVTEST-END-FLAG TO TRUE
    PERFORM DIVISION-TEST
    IF V-DIVTEST-END-YES OF WS-DIVTEST-END-FLAG
    OR V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST
       EXIT SECTION
    END-IF

*>  20,000 <= WS-MAX-SMALL-PRIME <= 715,827,882    
    IF LNK-MAX-SMALL-PRIME = ZEROES
    THEN
       MOVE C-DEFAULT-MAX-SMALL-PRIME TO WS-MAX-SMALL-PRIME
    ELSE
       MOVE LNK-MAX-SMALL-PRIME       TO WS-MAX-SMALL-PRIME
    END-IF    
    
*>  the sequence 6*j-1 and 6*j+1 includes all primes   
    PERFORM VARYING WS-IND FROM 1 BY 1
      UNTIL WS-IND > WS-MAX-SMALL-PRIME

       COMPUTE WS-SMALL-PRIME = 6 * WS-IND - 1 END-COMPUTE
       SET V-DIVTEST-END-NO OF WS-DIVTEST-END-FLAG TO TRUE
       PERFORM DIVISION-TEST
       IF V-DIVTEST-END-YES OF WS-DIVTEST-END-FLAG
       OR V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST
          EXIT SECTION
       END-IF
       
       COMPUTE WS-SMALL-PRIME = 6 * WS-IND + 1 END-COMPUTE
       SET V-DIVTEST-END-NO OF WS-DIVTEST-END-FLAG TO TRUE
       PERFORM DIVISION-TEST
       IF V-DIVTEST-END-YES OF WS-DIVTEST-END-FLAG
       OR V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST
          EXIT SECTION
       END-IF

       IF  V-VERBOSE-YES OF LNK-VERBOSE-FLAG
       AND LNK-MAX-SMALL-PRIME NOT = ZEROES
       THEN
          MOVE 1000   TO WS-DIVISOR
          MOVE WS-IND TO WS-DIVIDEND
          
          DIVIDE WS-DIVISOR INTO WS-DIVIDEND
             GIVING    WS-QUOTIENT
             REMAINDER WS-REMAINDER
          END-DIVIDE   
         
          IF WS-REMAINDER = ZEROES
          THEN
             DISPLAY "Small primes division test: " 
                     WS-IND " / " WS-MAX-SMALL-PRIME
          END-IF   
       END-IF
       
    END-PERFORM
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 DIVISION-TEST SECTION.
*>------------------------------------------------------------------------------

*>  prepare compare, move small prime to help-var
    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY VALUE     WS-SMALL-PRIME
         RETURNING OMITTED
    END-CALL     
    
*>  compare: small prime >= square root of Proth number + 1
    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
               BY REFERENCE WS-GMP-HELP-VAR
         RETURNING WS-RET-1
    END-CALL     
    
*>  check compare result 
*>  exit if small prime >= square root of Proth number + 1     
    IF WS-RET-1 = ZEROES
    OR WS-RET-1 < ZEROES
    THEN
       SET V-DIVTEST-END-YES OF WS-DIVTEST-END-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  return non-zero if the proth number is exactly divisible     
    CALL STATIC "mpz_divisible_ui_p" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
               BY VALUE     WS-SMALL-PRIME
         RETURNING WS-RET-1
    END-CALL     
    
    IF WS-RET-1 NOT = ZEROES
    THEN
       SET V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       MOVE WS-SMALL-PRIME TO LNK-DIVISOR OF LNK-PROTHTEST
       EXIT SECTION       
    END-IF
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 PROTH-PRIMALITY-TEST SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-POWM-BASE
               BY VALUE     WS-POWM-BASE
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     WS-POWM-BASE
         RETURNING OMITTED
    END-CALL     

    IF V-VERBOSE-YES OF LNK-VERBOSE-FLAG
    THEN
       DISPLAY " "
       DISPLAY "Start Proth primality test with K: " LNK-K OF LNK-PROTHTEST 
                                             ", N: " LNK-N OF LNK-PROTHTEST
    END-IF
    
*>  write log file       
    IF V-SAVE-YES OF LNK-SAVE-FLAG
    THEN
       INITIALIZE WS-LAST-SAVED-FILE-NAME-1
       INITIALIZE WS-LAST-SAVED-FILE-NAME-2
       MOVE "Start; Proth primality test." TO WS-LOG-PTEST-TEXT
       PERFORM WRITE-LOG-FILE
       IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
       OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
       THEN
          EXIT SECTION             
       END-IF
    END-IF        

    IF V-LOAD-YES OF LNK-LOAD-FLAG
    THEN
*>     load saved-file and countdown counter
       PERFORM LOAD-STATE
       IF V-LOAD-SUCCESS-YES OF WS-LOAD-SUCCESS-FLAG
       THEN
          MOVE WS-COUNTDOWN-START-LOAD TO WS-COUNTDOWN-START
          CALL STATIC "mpz_set" 
               USING BY REFERENCE WS-GMP-POWM-RESULT
                     BY REFERENCE WS-GMP-POWM-RESULT-LOAD
               RETURNING OMITTED
          END-CALL     

          MOVE WS-COUNTDOWN-START TO WS-COUNTDOWN-START-DISP
          INITIALIZE WS-LOG-PTEST-TEXT         
          STRING "Load; Countdown: " WS-COUNTDOWN-START-DISP DELIMITED BY SIZE
            INTO WS-LOG-PTEST-TEXT
          END-STRING  
          PERFORM WRITE-LOG-FILE
          IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
          OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
          THEN
             EXIT SECTION             
          END-IF
       ELSE
          COMPUTE WS-COUNTDOWN-START = WS-BIT-LEN-2 - 2 END-COMPUTE
       END-IF
    ELSE    
       COMPUTE WS-COUNTDOWN-START = WS-BIT-LEN-2 - 2 END-COMPUTE
    END-IF   

    PERFORM TEST AFTER VARYING WS-COUNTDOWN-IND FROM WS-COUNTDOWN-START BY -1
      UNTIL WS-COUNTDOWN-IND = ZEROES 

       IF V-SAVE-YES OF LNK-SAVE-FLAG
       THEN
          MOVE LNK-SAVE-NUM OF LNK-PROTHTEST TO WS-DIVISOR
          MOVE WS-COUNTDOWN-IND              TO WS-DIVIDEND
          
          DIVIDE WS-DIVISOR INTO WS-DIVIDEND
             GIVING    WS-QUOTIENT
             REMAINDER WS-REMAINDER
          END-DIVIDE   
         
          IF WS-REMAINDER = ZEROES
          THEN
             PERFORM SAVE-STATE
             IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
             OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
             OR V-CLOSE-FILE-ERROR OF LNK-RESULT-FLAG
             THEN
                EXIT SECTION             
             END-IF
           
*>           file name without EOS          
             MOVE WS-SAVE-FILE-NAME(1:44) TO WS-LOG-PTEST-TEXT
             PERFORM WRITE-LOG-FILE
             IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
             OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
             THEN
                EXIT SECTION             
             END-IF
             
*>           delete last saved file
             IF WS-LAST-SAVED-FILE-NAME-2 NOT = SPACES
             THEN
                PERFORM DELETE-STATE
                IF V-CHANGE-DIR-ERROR  OF LNK-RESULT-FLAG
                OR V-DELETE-FILE-ERROR OF LNK-RESULT-FLAG
                THEN
                   EXIT SECTION             
                END-IF
             END-IF             
          END-IF
       END-IF
       
       CALL STATIC "mpz_tstbit" 
            USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
                  BY VALUE     WS-COUNTDOWN-IND
            RETURNING WS-RET-1
       END-CALL     
      
       CALL STATIC "mpz_mul" 
            USING BY REFERENCE WS-GMP-POWM-RESULT
                  BY REFERENCE WS-GMP-POWM-RESULT
                  BY REFERENCE WS-GMP-POWM-RESULT
            RETURNING OMITTED
       END-CALL     

*>     compare    
       PERFORM CMP-PROTH-NUMBER

       IF WS-CMP-RET-1 >= ZEROES
       THEN 
          PERFORM COMPUTE-MOD-PROTH-NUMBER
       END-IF
       
       IF WS-RET-1 = 1
       THEN
          CALL STATIC "mpz_mul" 
               USING BY REFERENCE WS-GMP-POWM-RESULT
                     BY REFERENCE WS-GMP-POWM-RESULT
                     BY REFERENCE WS-GMP-POWM-BASE
               RETURNING OMITTED
          END-CALL     

*>        compare    
          PERFORM CMP-PROTH-NUMBER
      
          IF WS-CMP-RET-1 >= ZEROES
          THEN 
             CALL STATIC "mpz_mod" 
                  USING BY REFERENCE WS-GMP-POWM-RESULT
                        BY REFERENCE WS-GMP-POWM-RESULT
                        BY REFERENCE WS-GMP-PROTH-NUMBER
                  RETURNING OMITTED
             END-CALL     
          END-IF
       END-IF

       IF V-VERBOSE-YES OF LNK-VERBOSE-FLAG
       THEN
          DISPLAY "Proth test Countdown: " WS-COUNTDOWN-IND
       END-IF
    END-PERFORM  

*>  the function mpz_powm() can not give back -1, 
*>  therefore we have to add 1, and compare the result with the Proth number    
    CALL STATIC "mpz_add_ui" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*>  compare    
    PERFORM CMP-PROTH-NUMBER

    IF WS-CMP-RET-1 = ZEROES
    THEN 
*>     Proth prime found!    
       SET V-PRIME-YES OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       
*>     write Proth number in file
       IF V-WRITE-FILE-YES OF LNK-WRITE-FILE-FLAG OF LNK-PROTHTEST
       THEN
          PERFORM WRITE-PROTH-NR-IN-FILE
          IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
          OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
          OR V-CLOSE-FILE-ERROR OF LNK-RESULT-FLAG
          THEN
             EXIT SECTION             
          END-IF
       END-IF

       MOVE "End; Proth prime found!!!" TO WS-LOG-PTEST-TEXT
    ELSE   
       MOVE "End; no prime."            TO WS-LOG-PTEST-TEXT
    END-IF
    
*>  write log file       
    IF V-SAVE-YES OF LNK-SAVE-FLAG
    THEN
       PERFORM WRITE-LOG-FILE
       IF V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG
       OR V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG
       THEN
          EXIT SECTION             
       END-IF
    END-IF        
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CMP-PROTH-NUMBER SECTION.
*>------------------------------------------------------------------------------

*>  compare    
    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING WS-CMP-RET-1
    END-CALL     
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 COMPUTE-MOD-PROTH-NUMBER SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "mpz_tdiv_q_2exp" 
         USING BY REFERENCE WS-GMP-A
               BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     LNK-N OF LNK-PROTHTEST
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_tdiv_r_2exp" 
         USING BY REFERENCE WS-GMP-B
               BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     LNK-N OF LNK-PROTHTEST
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_tdiv_qr_ui" 
         USING BY REFERENCE WS-GMP-Q
               BY REFERENCE WS-GMP-R
               BY REFERENCE WS-GMP-A
               BY VALUE     LNK-K OF LNK-PROTHTEST
         RETURNING WS-RET-2
    END-CALL     
    
    CALL STATIC "mpz_mul" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-R
               BY REFERENCE WS-GMP-POW-2
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_add" 
         USING BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-B
         RETURNING OMITTED
    END-CALL     

*>  compare    
    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-Q
               BY REFERENCE WS-GMP-HELP-VAR
         RETURNING WS-CMP-RET-2
    END-CALL     
    
    IF WS-CMP-RET-2 >= ZEROES
    THEN 
       CALL STATIC "mpz_add" 
            USING BY REFERENCE WS-GMP-HELP-VAR
                  BY REFERENCE WS-GMP-HELP-VAR
                  BY REFERENCE WS-GMP-PROTH-NUMBER
            RETURNING OMITTED
       END-CALL     
    END-IF

    CALL STATIC "mpz_sub" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-HELP-VAR
               BY REFERENCE WS-GMP-Q
         RETURNING OMITTED
    END-CALL     
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-PROTH-NR-IN-FILE SECTION.
*>------------------------------------------------------------------------------

*>  create dir
    CALL "CBL_CREATE_DIR" USING WS-PROTH-PRIME-DIR END-CALL
    
*>  change dir in Proth_Primes    
    CALL "CBL_CHANGE_DIR" USING WS-PROTH-PRIME-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section WRITE-PROTH-NR-IN-FILE)"
       EXIT SECTION
    END-IF

*>  set file name
    MOVE "K"                    TO WS-FILE-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-FILE-NAME-K-NUM
    MOVE "-"                    TO WS-FILE-NAME-SPLIT
    MOVE "N"                    TO WS-FILE-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-FILE-NAME-N-NUM
    MOVE ".txt"                 TO WS-FILE-NAME-TYP
    MOVE X"00"                  TO WS-FILE-NAME-EOS

*>  get a file stream pointer    
    CALL STATIC "fopen" 
         USING BY CONTENT   WS-FILE-NAME
               BY CONTENT   z"w" 
         RETURNING          WS-FILE-POINTER
    END-CALL     

*>  write Proth number in a file    
    CALL STATIC "gmp_fprintf" 
         USING BY VALUE     WS-FILE-POINTER
                  CONTENT   z"%Zd" 
               BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING WS-RET-1
    END-CALL     
    
    IF WS-RET-1 = -1
    THEN
       SET V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not write in the file: " WS-FILE-NAME
               " (Section WRITE-PROTH-NR-IN-FILE)"
       EXIT SECTION
    END-IF

*>  close file stream    
    CALL STATIC "fclose" 
         USING BY VALUE     WS-FILE-POINTER
         RETURNING WS-RET-1
    END-CALL     

    IF WS-RET-1 NOT = ZEROES
    THEN
       SET V-CLOSE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not close the file: " WS-FILE-NAME
               " (Section WRITE-PROTH-NR-IN-FILE)"
       EXIT SECTION
    END-IF

*>  change dir back   
    CALL "CBL_CHANGE_DIR" USING ".." END-CALL

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section WRITE-PROTH-NR-IN-FILE)"
       EXIT SECTION
    END-IF
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 SAVE-STATE SECTION.
*>------------------------------------------------------------------------------

*>  set dir name
    MOVE "Save_State_K"         TO WS-SAVE-DIR-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-K-NUM
    MOVE "-"                    TO WS-SAVE-DIR-NAME-SPLIT
    MOVE "N"                    TO WS-SAVE-DIR-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-N-NUM

*>  create dir
    CALL "CBL_CREATE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
*>  change dir in Save_State    
    CALL "CBL_CHANGE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section SAVE-STATE)"
       EXIT SECTION
    END-IF
    
*>  set file name
    MOVE "SAVE-K"               TO WS-SAVE-FILE-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-SAVE-FILE-NAME-K-NUM
    MOVE "-"                    TO WS-SAVE-FILE-NAME-SPLIT-1
    MOVE "N"                    TO WS-SAVE-FILE-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-SAVE-FILE-NAME-N-NUM
    MOVE "-"                    TO WS-SAVE-FILE-NAME-SPLIT-2
    MOVE "C"                    TO WS-SAVE-FILE-NAME-C
    MOVE WS-COUNTDOWN-IND       TO WS-SAVE-FILE-NAME-C-NUM
    MOVE ".txt"                 TO WS-SAVE-FILE-NAME-TYP
    MOVE X"00"                  TO WS-SAVE-FILE-NAME-EOS

    IF V-VERBOSE-YES OF LNK-VERBOSE-FLAG
    THEN
       DISPLAY " "
       DISPLAY "Save state in file: " WS-SAVE-FILE-NAME
       DISPLAY " "
    END-IF
    
*>  get a file stream pointer    
    CALL STATIC "fopen" 
         USING BY CONTENT   WS-SAVE-FILE-NAME
               BY CONTENT   z"w" 
         RETURNING          WS-SAVE-FILE-POINTER
    END-CALL     

*>  write save number in a file    
    CALL STATIC "gmp_fprintf" 
         USING BY VALUE     WS-SAVE-FILE-POINTER
                  CONTENT   z"%Zd" 
               BY REFERENCE WS-GMP-POWM-RESULT
         RETURNING WS-RET-1
    END-CALL     
    
    IF WS-RET-1 = -1
    THEN
       SET V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not write in the file: " WS-SAVE-FILE-NAME
               " (Section SAVE-STATE)"
       EXIT SECTION
    END-IF

*>  close file stream    
    CALL STATIC "fclose" 
         USING BY VALUE     WS-SAVE-FILE-POINTER
         RETURNING WS-RET-1
    END-CALL     

    IF WS-RET-1 NOT = ZEROES
    THEN
       SET V-CLOSE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not close the file: " WS-SAVE-FILE-NAME
               " (Section SAVE-STATE)"
       EXIT SECTION
    END-IF

*>  set last saved file name    
    MOVE WS-LAST-SAVED-FILE-NAME-1 TO WS-LAST-SAVED-FILE-NAME-2
    MOVE WS-SAVE-FILE-NAME         TO WS-LAST-SAVED-FILE-NAME-1
    
*>  change dir back   
    CALL "CBL_CHANGE_DIR" USING ".." END-CALL

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir back! (Section SAVE-STATE)"
       EXIT SECTION
    END-IF
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 DELETE-STATE SECTION.
*>------------------------------------------------------------------------------

*>  set dir name
    MOVE "Save_State_K"         TO WS-SAVE-DIR-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-K-NUM
    MOVE "-"                    TO WS-SAVE-DIR-NAME-SPLIT
    MOVE "N"                    TO WS-SAVE-DIR-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-N-NUM

*>  change dir in Save_State    
    CALL "CBL_CHANGE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section DELETE-STATE)"
       EXIT SECTION
    END-IF
    
    CALL "CBL_DELETE_FILE" USING WS-LAST-SAVED-FILE-NAME-2

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-DELETE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not delete saved state: " WS-LAST-SAVED-FILE-NAME-2
               " (Section DELETE-STATE)"
       EXIT SECTION
    END-IF
    
*>  change dir back   
    CALL "CBL_CHANGE_DIR" USING ".." END-CALL

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir back! (Section DELETE-STATE)"
       EXIT SECTION
    END-IF
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 LOAD-STATE SECTION.
*>------------------------------------------------------------------------------

    SET V-LOAD-SUCCESS-NO OF WS-LOAD-SUCCESS-FLAG TO TRUE

*>  set dir name
    MOVE "Save_State_K"         TO WS-SAVE-DIR-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-K-NUM
    MOVE "-"                    TO WS-SAVE-DIR-NAME-SPLIT
    MOVE "N"                    TO WS-SAVE-DIR-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-N-NUM

*>  change dir in Save_State    
    CALL "CBL_CHANGE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section LOAD-STATE)"
       EXIT SECTION
    END-IF

    PERFORM READ-LOG-FILE

    IF V-READ-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST
    OR WS-LOG-PTEST-TEXT(1:6) NOT = "SAVE-K"
    THEN
*>     change dir back   
       CALL "CBL_CHANGE_DIR" USING ".." END-CALL
       EXIT SECTION       
    END-IF

*>  set file name
    MOVE WS-LOG-PTEST-TEXT(1:44) TO WS-SAVE-FILE-NAME(1:44)
    MOVE X"00"                   TO WS-SAVE-FILE-NAME-EOS
    MOVE WS-SAVE-FILE-NAME-C-NUM TO WS-COUNTDOWN-START-LOAD
    
    IF V-VERBOSE-YES OF LNK-VERBOSE-FLAG
    THEN
       DISPLAY " "
       DISPLAY "Load state from file: " WS-SAVE-FILE-NAME
       DISPLAY " "
    END-IF
    
*>  get a file stream pointer    
    CALL STATIC "fopen" 
         USING BY CONTENT   WS-SAVE-FILE-NAME
               BY CONTENT   z"r" 
         RETURNING          WS-SAVE-FILE-POINTER
    END-CALL     
    
*>  read saved number from a file    
    CALL STATIC "gmp_fscanf" 
         USING BY VALUE     WS-SAVE-FILE-POINTER
                  CONTENT   z"%Zd" 
               BY REFERENCE WS-GMP-POWM-RESULT-LOAD
         RETURNING WS-RET-1
    END-CALL     
    
    IF WS-RET-1 = -1
    THEN
       SET V-READ-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not read from the file: " WS-SAVE-FILE-NAME
               " (Section LOAD-STATE)"
    END-IF

*>  close file stream    
    CALL STATIC "fclose" 
         USING BY VALUE     WS-SAVE-FILE-POINTER
         RETURNING WS-RET-1
    END-CALL     

    IF WS-RET-1 NOT = ZEROES
    THEN
       SET V-CLOSE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not close the file: " WS-SAVE-FILE-NAME
               " (Section LOAD-STATE)"
    END-IF
    
*>  change dir back   
    CALL "CBL_CHANGE_DIR" USING ".." END-CALL

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir back! (Section LOAD-STATE)"
       EXIT SECTION
    END-IF
    
    SET V-LOAD-SUCCESS-YES OF WS-LOAD-SUCCESS-FLAG TO TRUE
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-LOG-FILE SECTION.
*>------------------------------------------------------------------------------

*>  set dir name
    MOVE "Save_State_K"         TO WS-SAVE-DIR-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-K-NUM
    MOVE "-"                    TO WS-SAVE-DIR-NAME-SPLIT
    MOVE "N"                    TO WS-SAVE-DIR-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-SAVE-DIR-NAME-N-NUM

*>  create dir
    CALL "CBL_CREATE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
*>  change dir in Save_State    
    CALL "CBL_CHANGE_DIR" USING WS-SAVE-STATE-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir! (Section WRITE-LOG-FILE)"
       EXIT SECTION
    END-IF

*>  set file name
    MOVE "LOG-K"                TO WS-LOG-FILE-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-LOG-FILE-NAME-K-NUM
    MOVE "-"                    TO WS-LOG-FILE-NAME-SPLIT
    MOVE "N"                    TO WS-LOG-FILE-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-LOG-FILE-NAME-N-NUM
    MOVE ".txt"                 TO WS-LOG-FILE-NAME-TYP
    MOVE X"00"                  TO WS-LOG-FILE-NAME-EOS

*>  write log file    
    OPEN EXTEND LOG-PTEST-FILE
    IF  NOT V-LOG-FILE-OK       OF WS-LOG-FILE-STATUS
    AND NOT V-LOG-FILE-OPTIONAL OF WS-LOG-FILE-STATUS
    THEN
       SET V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not open the file: " WS-LOG-FILE-NAME
               " (Section WRITE-LOG-FILE)"
       EXIT SECTION
    END-IF   

    INITIALIZE LOG-PTEST-FILE-LINE
    MOVE WS-LOG-PTEST-TEXT          
      TO LOG-PTEST-TEXT                OF LOG-PTEST-FILE-LINE
*>  current timestamp               
    MOVE FUNCTION CURRENT-DATE      
      TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME 
      TO WS-DATE-TIME
    MOVE WS-DATE-TIME               
      TO LOG-PTEST-DATE-TIME           OF LOG-PTEST-FILE-LINE
    
    WRITE LOG-PTEST-FILE-LINE
    IF NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
    THEN
       SET V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not write in the file: " WS-LOG-FILE-NAME
               " (Section WRITE-LOG-FILE)"
    END-IF   

    CLOSE LOG-PTEST-FILE
    IF NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
    THEN
       SET V-WRITE-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not close the file: " WS-LOG-FILE-NAME
               " (Section WRITE-LOG-FILE)"
       EXIT SECTION
    END-IF   
    
*>  change dir back   
    CALL "CBL_CHANGE_DIR" USING ".." END-CALL

    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-CHANGE-DIR-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not change dir back! (Section WRITE-LOG-FILE)"
       EXIT SECTION
    END-IF
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 READ-LOG-FILE SECTION.
*>------------------------------------------------------------------------------

*>  set file name
    MOVE "LOG-K"                TO WS-LOG-FILE-NAME-K
    MOVE LNK-K OF LNK-PROTHTEST TO WS-LOG-FILE-NAME-K-NUM
    MOVE "-"                    TO WS-LOG-FILE-NAME-SPLIT
    MOVE "N"                    TO WS-LOG-FILE-NAME-N
    MOVE LNK-N OF LNK-PROTHTEST TO WS-LOG-FILE-NAME-N-NUM
    MOVE ".txt"                 TO WS-LOG-FILE-NAME-TYP
    MOVE X"00"                  TO WS-LOG-FILE-NAME-EOS

*>  read log file    
    OPEN INPUT LOG-PTEST-FILE
    IF NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
    THEN
       SET V-READ-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not open the file: " WS-LOG-FILE-NAME
               " (Section READ-LOG-FILE)"
       EXIT SECTION
    END-IF   

    INITIALIZE WS-LOG-PTEST-TEXT
    SET V-LOG-FILE-OK OF WS-LOG-FILE-STATUS TO TRUE    
    
    PERFORM UNTIL NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
       INITIALIZE LOG-PTEST-FILE-LINE
       READ LOG-PTEST-FILE
       
       IF V-LOG-FILE-EOF OF WS-LOG-FILE-STATUS
       THEN
          EXIT PERFORM
       END-IF
       
       IF NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
       THEN
          SET V-READ-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
          DISPLAY "Error: can not read the file: " WS-LOG-FILE-NAME
                  " (Section READ-LOG-FILE)"
          EXIT PERFORM
       END-IF   

*>     search for the last saved file name       
       IF LOG-PTEST-TEXT OF LOG-PTEST-FILE-LINE(1:6) = "SAVE-K"
       THEN
          MOVE LOG-PTEST-TEXT OF LOG-PTEST-FILE-LINE TO WS-LOG-PTEST-TEXT
       END-IF
    END-PERFORM

    CLOSE LOG-PTEST-FILE
    IF NOT V-LOG-FILE-OK OF WS-LOG-FILE-STATUS
    THEN
       SET V-READ-FILE-ERROR OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       DISPLAY "Error: can not close the file: " WS-LOG-FILE-NAME
               " (Section READ-LOG-FILE)"
       EXIT SECTION
    END-IF   
    .
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 CLEAR-GMP-FIELDS SECTION.
*>------------------------------------------------------------------------------

*>  free memory
    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-POW-2
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-2
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-POWM-BASE
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-POWM-RESULT-LOAD
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-JACOBI-A
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-HELP-VAR
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-A
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-B
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-Q
         RETURNING OMITTED
    END-CALL     
    
    CALL STATIC "mpz_clear" 
         USING BY REFERENCE WS-GMP-R
         RETURNING OMITTED
    END-CALL     
    .
    EXIT SECTION .
    
 END PROGRAM prothtest.
