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
*>            - First version created.
*>------------------------------------------------------------------------------
*> yyyy.mm.dd
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. prothtest.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> gmp variables have a type of mpz_t struct
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
   
 01 WS-GMP-INIT-FLAG                   PIC 9(1).
    88 V-GMP-INIT-NO                   VALUE 0.
    88 V-GMP-INIT-YES                  VALUE 1.
   
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
   02 WS-A-TAB-LINE                    OCCURS 1 TO C-A-TAB-MAX-LINE TIMES.
     03 WS-A                           BINARY-LONG UNSIGNED.

*> small primes for the division precheck   
 COPY "smallprimes.cpy".     
     
 01 WS-IND                             BINARY-LONG.
   
*> function return value 
 01 WS-RET-1                           BINARY-INT.
 01 WS-RET-2                           BINARY-LONG UNSIGNED.

*> for div test 
 01 WS-DIVIDEND                        BINARY-LONG UNSIGNED.
 01 WS-DIVISOR                         BINARY-LONG UNSIGNED.
 01 WS-QUOTIENT                        BINARY-LONG UNSIGNED.
 01 WS-REMAINDER                       BINARY-LONG UNSIGNED.
 
*> save Proth number in a file
 01 WS-FILE-POINTER                    USAGE POINTER.
 01 WS-FILE-NAME                       PIC X(28).   
 01 WS-FILE-NAME-STRUCT.
   02 WS-FILE-NAME-K                   PIC X(01) VALUE "K".
   02 WS-FILE-NAME-K-NUM               PIC 9(10).
   02 WS-FILE-NAME-SPLIT               PIC X(01) VALUE "-".
   02 WS-FILE-NAME-N                   PIC X(01) VALUE "N".
   02 WS-FILE-NAME-N-NUM               PIC 9(10).
   02 WS-FILE-NAME-TYP                 PIC X(04) VALUE ".txt".
*> end of string
   02 WS-WS-FILE-NAME-EOS              PIC X(01) VALUE X"00".
 
 LINKAGE SECTION.
*> for the prothtest module 
 01 LNK-PROTHTEST.
*> input; k in: k*2^n + 1
   02 LNK-K                            BINARY-LONG UNSIGNED.
*> input; n exponent in: k*2^n + 1
   02 LNK-N                            BINARY-LONG UNSIGNED.
*> input; write Proth numbers in files 
   02 LNK-WRITE-FILE-FLAG              PIC 9(1).
      88 V-WRITE-FILE-NO               VALUE 0.
      88 V-WRITE-FILE-YES              VALUE 1.
*> input; precheck only 
   02 LNK-PRECHECK-ONLY-FLAG           PIC 9(1).
      88 V-PRECHECK-ONLY-NO            VALUE 0.
      88 V-PRECHECK-ONLY-YES           VALUE 1.
*> output; flag
   02 LNK-RESULT-FLAG                  PIC 9(1).
      88 V-NO-RESULT                   VALUE 0.
      88 V-PRIME-NO                    VALUE 1.
      88 V-PRIME-YES                   VALUE 2.
      88 V-NO-JACOBI-FOUND             VALUE 3.
      88 V-K-GE-2-POWER-N              VALUE 4.
      88 V-K-NOT-ODD                   VALUE 5.
      88 V-WRITE-FILE-ERROR            VALUE 6.
      88 V-CLOSE-FILE-ERROR            VALUE 7.
*> output; number of digits
   02 LNK-PROTHTEST-DIGITS             BINARY-LONG UNSIGNED.
*> output; "a" in Jacobi symbol (a/p)
   02 LNK-JACOBI-A-NUM                 BINARY-LONG UNSIGNED.
*> output; the divisor, if not prime
   02 LNK-DIVISOR                      BINARY-LONG UNSIGNED.
 
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
 MAIN-PROTHTEST-EX.
    EXIT.

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
 CHECK-K-ODD-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 INIT-GMP-FIELDS SECTION.
*>------------------------------------------------------------------------------

*>  If an application can estimate the final size, then the second parameter
*>  can be set to allocate the necessary space (for n-bit numbers) from the 
*>  beginning. It doesn’t matter if a size set with mpz_init2 is too small, 
*>  since all functions in GMP will do a further reallocation if necessary. But 
*>  repeatedly realloced memory could be quite slow or could fragment memory.
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
    
    .
 INIT-GMP-FIELDS-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COMP-PROTH-NUMBER SECTION.
*>------------------------------------------------------------------------------

*>  compute the PROTH number: k*2^n + 1
    CALL STATIC "mpz_ui_pow_ui" 
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
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
         USING BY REFERENCE WS-GMP-PROTH-NUMBER
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
               BY REFERENCE WS-GMP-PROTH-NUMBER
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
    
    .
 COMP-PROTH-NUMBER-EX.
    EXIT.

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
 COMP-JACOBI-SYMBOL-EX.
    EXIT.

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
    PERFORM VARYING WS-IND FROM 1 BY 1
      UNTIL WS-IND > C-TAB-SMALL-PRIMES-MAX-LINE

*>     prepare compare, move small prime to help-var
       CALL STATIC "mpz_set_ui" 
            USING BY REFERENCE WS-GMP-HELP-VAR
                  BY VALUE     WS-SMALL-PRIMES(WS-IND)
            RETURNING OMITTED
       END-CALL     
     
*>     compare: small prime >= square root of Proth number + 1
       CALL STATIC "mpz_cmp" 
            USING BY REFERENCE WS-GMP-PROTH-NUMBER-SQRT
                  BY REFERENCE WS-GMP-HELP-VAR
            RETURNING WS-RET-1
       END-CALL     
     
*>     check compare result 
*>     exit if small prime >= square root of Proth number + 1     
       IF WS-RET-1 = ZEROES
       OR WS-RET-1 < ZEROES
       THEN
          EXIT SECTION
       END-IF

*>     return non-zero if the proth number is exactly divisible     
       CALL STATIC "mpz_divisible_ui_p" 
            USING BY REFERENCE WS-GMP-PROTH-NUMBER
                  BY VALUE     WS-SMALL-PRIMES(WS-IND)
            RETURNING WS-RET-1
       END-CALL     
      
       IF WS-RET-1 NOT = ZEROES
       THEN
          SET V-PRIME-NO OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
          MOVE WS-SMALL-PRIMES(WS-IND) TO LNK-DIVISOR OF LNK-PROTHTEST
          EXIT SECTION       
       END-IF
    END-PERFORM
    
    .
 SMALL-PRIMES-DIVISION-TEST-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 PROTH-PRIMALITY-TEST SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "mpz_set_ui" 
         USING BY REFERENCE WS-GMP-POWM-BASE
               BY VALUE     WS-POWM-BASE
         RETURNING OMITTED
    END-CALL     

    CALL STATIC "mpz_powm" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-POWM-BASE
               BY REFERENCE WS-GMP-PROTH-NUMBER-2
               BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING OMITTED
    END-CALL     

*>  the function mpz_powm() can not give back -1, 
*>  therefore we have to add 1, and compare the result with the Proth number    
    CALL STATIC "mpz_add_ui" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-POWM-RESULT
               BY VALUE     1
         RETURNING OMITTED
    END-CALL     

*>  compare    
    CALL STATIC "mpz_cmp" 
         USING BY REFERENCE WS-GMP-POWM-RESULT
               BY REFERENCE WS-GMP-PROTH-NUMBER
         RETURNING WS-RET-1
    END-CALL     

    IF WS-RET-1 = ZEROES
    THEN
*>     Proth prime found!    
       SET V-PRIME-YES OF LNK-RESULT-FLAG OF LNK-PROTHTEST TO TRUE
       
*>     write Proth number in a file
       IF V-WRITE-FILE-YES OF LNK-WRITE-FILE-FLAG OF LNK-PROTHTEST
       THEN
          PERFORM WRITE-FILE
       END-IF
    END-IF
    
    .
 PROTH-PRIMALITY-TEST-EX.
    EXIT.

*>------------------------------------------------------------------------------
 WRITE-FILE SECTION.
*>------------------------------------------------------------------------------

*>  create file name
    MOVE LNK-K OF LNK-PROTHTEST TO WS-FILE-NAME-K-NUM
    MOVE LNK-N OF LNK-PROTHTEST TO WS-FILE-NAME-N-NUM
    MOVE WS-FILE-NAME-STRUCT    TO WS-FILE-NAME

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
       DISPLAY "prothtest: Error: can not write in the file " WS-FILE-NAME
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
       DISPLAY "prothtest: Error: can not close the file " WS-FILE-NAME
    END-IF
    
    .
 WRITE-FILE-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 CLEAR-GMP-FIELDS SECTION.
*>------------------------------------------------------------------------------

*>  free memory
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
    
    .
 CLEAR-GMP-FIELDS-EX.
    EXIT.
    
 END PROGRAM prothtest.
