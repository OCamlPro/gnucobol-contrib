*>******************************************************************************
*>  prothsearch.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  prothsearch.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with prothsearch.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      prothsearch.cob
*>
*> Purpose:      This is a primality test for Proth numbers
*>               http://en.wikipedia.org/wiki/Proth%27s_theorem
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.05.14
*>
*> Tectonics:    cobc -x -free prothsearch.cob -o prothsearch.exe prothtest.o
*>
*> Usage:        This main program processes the command line parameters and
*>               calls the prothtest.cob module. The prothtest.cob module 
*>               implements the Proth primality test. For parameterization and
*>               usage please see the readme.txt file.
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
 PROGRAM-ID. prothsearch.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.

 WORKING-STORAGE SECTION.

*> for command line processing 
 01 CMD-LINE-PARAMETERS.
   02 CMD-LINE-PAR                     PIC X(100).
      88 V-CMD-LINE-PAR-K              VALUE "-k".
      88 V-CMD-LINE-PAR-N              VALUE "-n".
      88 V-CMD-LINE-PAR-KMIN           VALUE "-kmin".
      88 V-CMD-LINE-PAR-KMAX           VALUE "-kmax".
      88 V-CMD-LINE-PAR-NMIN           VALUE "-nmin".
      88 V-CMD-LINE-PAR-NMAX           VALUE "-nmax".
      88 V-CMD-LINE-PAR-VERBOSE        VALUE "-v", "-verbose".
      88 V-CMD-LINE-PAR-WRITE-FILE     VALUE "-wf", "-write-file".
      88 V-CMD-LINE-PAR-PRECHECK       VALUE "-pre", "-precheck".
*> command line flags      
   02 CMD-LINE-PAR-K-FLAG              PIC 9(1).
      88 V-CMD-LINE-PAR-K-NO           VALUE 0.
      88 V-CMD-LINE-PAR-K-YES          VALUE 1.
   02 CMD-LINE-PAR-N-FLAG              PIC 9(1).
      88 V-CMD-LINE-PAR-N-NO           VALUE 0.
      88 V-CMD-LINE-PAR-N-YES          VALUE 1.
   02 CMD-LINE-PAR-KMIN-FLAG           PIC 9(1).
      88 V-CMD-LINE-PAR-KMIN-NO        VALUE 0.
      88 V-CMD-LINE-PAR-KMIN-YES       VALUE 1.
   02 CMD-LINE-PAR-KMAX-FLAG           PIC 9(1).
      88 V-CMD-LINE-PAR-KMAX-NO        VALUE 0.
      88 V-CMD-LINE-PAR-KMAX-YES       VALUE 1.
   02 CMD-LINE-PAR-NMIN-FLAG           PIC 9(1).
      88 V-CMD-LINE-PAR-NMIN-NO        VALUE 0.
      88 V-CMD-LINE-PAR-NMIN-YES       VALUE 1.
   02 CMD-LINE-PAR-NMAX-FLAG           PIC 9(1).
      88 V-CMD-LINE-PAR-NMAX-NO        VALUE 0.
      88 V-CMD-LINE-PAR-NMAX-YES       VALUE 1.
   02 CMD-LINE-PAR-VERBOSE-FLAG        PIC 9(1).
      88 V-CMD-LINE-PAR-VERBOSE-NO     VALUE 0.
      88 V-CMD-LINE-PAR-VERBOSE-YES    VALUE 1.
   02 CMD-LINE-PAR-WRITE-FILE-FLAG     PIC 9(1).
      88 V-CMD-LINE-PAR-WRITE-FILE-NO  VALUE 0.
      88 V-CMD-LINE-PAR-WRITE-FILE-YES VALUE 1.
   02 CMD-LINE-PAR-PRECHECK-FLAG       PIC 9(1).
      88 V-CMD-LINE-PAR-PRECHECK-NO    VALUE 0.
      88 V-CMD-LINE-PAR-PRECHECK-YES   VALUE 1.

 01 CMD-LINE-VALUES.
   02 CMD-LINE-K                       BINARY-LONG UNSIGNED.
   02 CMD-LINE-N                       BINARY-LONG UNSIGNED.
   02 CMD-LINE-KMIN                    BINARY-LONG UNSIGNED.
   02 CMD-LINE-KMAX                    BINARY-LONG UNSIGNED.
   02 CMD-LINE-NMIN                    BINARY-LONG UNSIGNED.
   02 CMD-LINE-NMAX                    BINARY-LONG UNSIGNED.

 01 CMD-LINE-END-FLAG                  PIC 9(1).
    88 V-CMD-LINE-END-NO               VALUE 0.
    88 V-CMD-LINE-END-YES              VALUE 1.
   
 01 ERROR-FLAG                         PIC 9(1).
    88 V-ERROR-NO                      VALUE 0.
    88 V-ERROR-YES                     VALUE 1.
   
 01 WS-K-IND                           BINARY-LONG UNSIGNED.
 01 WS-N-IND                           BINARY-LONG UNSIGNED.

 01 WS-PRIME-COUNTER                   BINARY-LONG UNSIGNED VALUE ZEROES.
 01 WS-RESULT-TEXT                     PIC X(14).

*> for the CURRENT-DATE function
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
*> time fields
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
 01 WS-START-TIME                      PIC X(22). 
 01 WS-END-TIME                        PIC X(22). 
 
*> if the parameter "write-file" is set, then a new run-dir will be created
 01 WS-RUN-DIR.
   02 FILLER                           PIC X(4) VALUE "RUN_".
   02 CDT-YEAR                         PIC 9(4).
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-MONTH                        PIC 9(2). *> 01-12
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-DAY                          PIC 9(2). *> 01-31
   02 FILLER                           PIC X(1) VALUE "_".
   02 CDT-HOUR                         PIC 9(2). *> 00-23
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-MINUTES                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-SECONDS                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE "_".
   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99
 
*> linkage for the prothtest module 
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
      
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PROTHSEARCH SECTION.
*>------------------------------------------------------------------------------

*>  program start time    
    MOVE FUNCTION CURRENT-DATE         TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME    TO WS-DATE-TIME
    DISPLAY " "
    DISPLAY "Program start: " WS-DATE-TIME
    DISPLAY " "

*>  init fields    
    INITIALIZE CMD-LINE-PARAMETERS
    INITIALIZE CMD-LINE-VALUES
    INITIALIZE CMD-LINE-END-FLAG
    INITIALIZE ERROR-FLAG

*>  read parameter from command line    
    PERFORM READ-CMD-LINE

*>  if the Proth numbers will be written in files,
*>  then create and change dir
    IF  V-ERROR-NO
    AND V-CMD-LINE-PAR-WRITE-FILE-YES
    AND V-CMD-LINE-PAR-PRECHECK-NO
    THEN
       PERFORM CREATE-RUN-DIR
    END-IF
    
    IF V-ERROR-NO
    THEN
       IF  V-CMD-LINE-PAR-K-YES 
       AND V-CMD-LINE-PAR-N-YES
       THEN
*>        one Proth number will be tested
          INITIALIZE LNK-PROTHTEST
          MOVE CMD-LINE-K TO LNK-K
          MOVE CMD-LINE-N TO LNK-N
          PERFORM CALL-PROTHTEST
       ELSE
*>        an intervall will be tested
          PERFORM VARYING WS-K-IND FROM CMD-LINE-KMIN BY 1
            UNTIL WS-K-IND > CMD-LINE-KMAX
             PERFORM VARYING WS-N-IND FROM CMD-LINE-NMIN BY 1
               UNTIL WS-N-IND > CMD-LINE-NMAX
                INITIALIZE LNK-PROTHTEST
                MOVE WS-K-IND TO LNK-K OF LNK-PROTHTEST
                MOVE WS-N-IND TO LNK-N OF LNK-PROTHTEST
                PERFORM CALL-PROTHTEST
             END-PERFORM
          END-PERFORM
       END-IF
    END-IF

*>  display result
    IF V-CMD-LINE-PAR-PRECHECK-NO
    THEN
       DISPLAY " "
       DISPLAY "Number of primes: " WS-PRIME-COUNTER    
    END-IF
    
*>  program end time    
    MOVE FUNCTION CURRENT-DATE         TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME    TO WS-DATE-TIME
    DISPLAY " "
    DISPLAY "Program end:   " WS-DATE-TIME
    
    STOP RUN
    
    .
 MAIN-PROTHSEARCH-EX.
    EXIT.

*>------------------------------------------------------------------------------
 READ-CMD-LINE SECTION.
*>------------------------------------------------------------------------------

    PERFORM UNTIL V-CMD-LINE-END-YES
       MOVE SPACES TO CMD-LINE-PAR
       ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
       
       IF CMD-LINE-PAR NOT = SPACES
       THEN
*>        convert in lower case       
          MOVE FUNCTION LOWER-CASE(CMD-LINE-PAR) TO CMD-LINE-PAR
          PERFORM PROCESS-CMD-LINE       
       ELSE
          SET V-CMD-LINE-END-YES TO TRUE
       END-IF
    END-PERFORM

    IF V-ERROR-NO
    THEN
       PERFORM CHECK-PARAMETERS
    END-IF
    
    .
 READ-CMD-LINE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 PROCESS-CMD-LINE SECTION.
*>------------------------------------------------------------------------------

    EVALUATE TRUE
        WHEN V-CMD-LINE-PAR-K               
             SET V-CMD-LINE-PAR-K-YES          TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-K
             IF CMD-LINE-K = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: k not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
             
        WHEN V-CMD-LINE-PAR-N               
             SET V-CMD-LINE-PAR-N-YES          TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-N
             IF CMD-LINE-N = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: n not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
             
        WHEN V-CMD-LINE-PAR-KMIN            
             SET V-CMD-LINE-PAR-KMIN-YES       TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-KMIN
             IF CMD-LINE-KMIN = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: kmin not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
             
        WHEN V-CMD-LINE-PAR-KMAX            
             SET V-CMD-LINE-PAR-KMAX-YES       TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-KMAX
             IF CMD-LINE-KMAX = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: kmax not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
             
        WHEN V-CMD-LINE-PAR-NMIN            
             SET V-CMD-LINE-PAR-NMIN-YES       TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-NMIN
             IF CMD-LINE-NMIN = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: nmin not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
             
        WHEN V-CMD-LINE-PAR-NMAX        
             SET V-CMD-LINE-PAR-NMAX-YES        TO TRUE
             MOVE SPACES TO CMD-LINE-PAR
             ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
             MOVE FUNCTION NUMVAL(CMD-LINE-PAR) TO CMD-LINE-NMAX
             IF CMD-LINE-NMAX = ZEROES
             THEN
                SET V-ERROR-YES TO TRUE
                DISPLAY "prothsearch: Error: nmax not numeric!"
                PERFORM DISPLAY-USAGE
             END-IF
        
        WHEN V-CMD-LINE-PAR-VERBOSE         
             SET V-CMD-LINE-PAR-VERBOSE-YES     TO TRUE

        WHEN V-CMD-LINE-PAR-WRITE-FILE      
             SET V-CMD-LINE-PAR-WRITE-FILE-YES  TO TRUE

        WHEN V-CMD-LINE-PAR-PRECHECK      
             SET V-CMD-LINE-PAR-PRECHECK-YES    TO TRUE

        WHEN OTHER
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: Invalid parameter!"
             PERFORM DISPLAY-USAGE 
    END-EVALUATE

    .
 PROCESS-CMD-LINE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CHECK-PARAMETERS SECTION.
*>------------------------------------------------------------------------------

    EVALUATE TRUE
        WHEN V-CMD-LINE-PAR-K-NO    AND V-CMD-LINE-PAR-N-NO    AND
             V-CMD-LINE-PAR-KMIN-NO AND V-CMD-LINE-PAR-KMAX-NO AND
             V-CMD-LINE-PAR-NMIN-NO AND V-CMD-LINE-PAR-NMAX-NO
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: no k or n parameter!"
             PERFORM DISPLAY-USAGE
             
        WHEN V-CMD-LINE-PAR-K-YES AND 
             (V-CMD-LINE-PAR-KMIN-YES OR V-CMD-LINE-PAR-KMAX-YES OR
              V-CMD-LINE-PAR-NMIN-YES OR V-CMD-LINE-PAR-NMAX-YES)
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: Invalid parameter kombination!"
             PERFORM DISPLAY-USAGE

        WHEN V-CMD-LINE-PAR-N-YES AND 
             (V-CMD-LINE-PAR-KMIN-YES OR V-CMD-LINE-PAR-KMAX-YES OR
              V-CMD-LINE-PAR-NMIN-YES OR V-CMD-LINE-PAR-NMAX-YES)
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: Invalid parameter kombination!"
             PERFORM DISPLAY-USAGE
             
        WHEN CMD-LINE-KMIN > CMD-LINE-KMAX
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: kmin > kmax!"
             PERFORM DISPLAY-USAGE
             
        WHEN CMD-LINE-NMIN > CMD-LINE-NMAX
             SET V-ERROR-YES TO TRUE
             DISPLAY "prothsearch: Error: nmin > nmax!"
             PERFORM DISPLAY-USAGE
    END-EVALUATE

    .
 CHECK-PARAMETERS-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 DISPLAY-USAGE SECTION.
*>------------------------------------------------------------------------------

    DISPLAY " "
    DISPLAY "Usage:"
    DISPLAY " "
    DISPLAY "prothsearch { -k <num> -n <num> [-v] [-wf] [-pre] }"
    DISPLAY "            { -kmin <num> -kmax <num> "
                          "-nmin <num> -nmax <num> [-v] [-wf] [-pre] }"
    DISPLAY " "
    DISPLAY "protsearch is a primality test for Proth numbers"
    DISPLAY " "
    DISPLAY "Options:"
    DISPLAY " "
    DISPLAY "-k <num> -n <num>       Test one number in the form k*2^n + 1"
    DISPLAY "-kmin <num> -kmax <num> -nmin <num> -nmax <num>"
    DISPLAY "                        Test an intervall"
    DISPLAY "-v,   -verbose          Verbose mode"
    DISPLAY "-wf,  -write-file       Write Proth numbers in files"
    DISPLAY "-pre, -precheck         Only precheck, no powm test"
    DISPLAY " "

    .
 DISPLAY-USAGE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CREATE-RUN-DIR SECTION.
*>------------------------------------------------------------------------------

*>  create run-dir name with current date-time
    MOVE CORR CURRENT-DATE-AND-TIME TO WS-RUN-DIR
    
    CALL "CBL_CREATE_DIR" USING WS-RUN-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-ERROR-YES TO TRUE
       DISPLAY "prothsearch: Error: can not create run dir!"
    END-IF

*>  change dir in new run-dir    
    CALL "CBL_CHANGE_DIR" USING WS-RUN-DIR END-CALL
    
    IF RETURN-CODE NOT = ZEROES
    THEN
       SET V-ERROR-YES TO TRUE
       DISPLAY "prothsearch: Error: can not change dir!"
    END-IF
    
    .
 CREATE-RUN-DIR-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 CALL-PROTHTEST SECTION.
*>------------------------------------------------------------------------------

    MOVE CMD-LINE-PAR-WRITE-FILE-FLAG  TO LNK-WRITE-FILE-FLAG
    MOVE CMD-LINE-PAR-PRECHECK-FLAG    TO LNK-PRECHECK-ONLY-FLAG

*>  start time    
    MOVE FUNCTION CURRENT-DATE         TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME    TO WS-DATE-TIME
    MOVE WS-DATE-TIME                  TO WS-START-TIME
    
    CALL "prothtest" USING LNK-PROTHTEST END-CALL

*>  end time    
    MOVE FUNCTION CURRENT-DATE         TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME    TO WS-DATE-TIME
    MOVE WS-DATE-TIME                  TO WS-END-TIME
    
    EVALUATE TRUE
        WHEN V-NO-RESULT               OF LNK-RESULT-FLAG  
             MOVE "maybe prime"        TO WS-RESULT-TEXT
        WHEN V-PRIME-NO                OF LNK-RESULT-FLAG  
             MOVE "no prime"           TO WS-RESULT-TEXT
        WHEN V-PRIME-YES               OF LNK-RESULT-FLAG
             ADD 1 TO WS-PRIME-COUNTER
             MOVE "prime found!!!"     TO WS-RESULT-TEXT
        WHEN V-NO-JACOBI-FOUND         OF LNK-RESULT-FLAG 
             MOVE "no Jacobi"          TO WS-RESULT-TEXT
        WHEN V-K-GE-2-POWER-N          OF LNK-RESULT-FLAG 
             MOVE "K >= 2^N"           TO WS-RESULT-TEXT
        WHEN V-K-NOT-ODD               OF LNK-RESULT-FLAG
             MOVE "K not odd"          TO WS-RESULT-TEXT
        WHEN V-WRITE-FILE-ERROR        OF LNK-RESULT-FLAG
             MOVE "write error"        TO WS-RESULT-TEXT
        WHEN V-CLOSE-FILE-ERROR        OF LNK-RESULT-FLAG
             MOVE "close error"        TO WS-RESULT-TEXT
        WHEN OTHER  
             MOVE "maybe prime"        TO WS-RESULT-TEXT
    END-EVALUATE

    IF V-CMD-LINE-PAR-VERBOSE-NO
    THEN
       IF  V-PRIME-YES OF LNK-RESULT-FLAG
       OR (    V-NO-RESULT         OF LNK-RESULT-FLAG 
           AND V-PRECHECK-ONLY-YES OF LNK-PRECHECK-ONLY-FLAG)
       THEN
          DISPLAY "K: "           LNK-K 
                  "; N: "         LNK-N 
                  "; Digits: "    LNK-PROTHTEST-DIGITS OF LNK-PROTHTEST
                  "; "            WS-RESULT-TEXT
                  "; Start: "     WS-START-TIME
                  "; End: "       WS-END-TIME
          END-DISPLAY
       END-IF
    ELSE
       DISPLAY "K: "              LNK-K 
               "; N: "            LNK-N 
               "; Digits: "       LNK-PROTHTEST-DIGITS OF LNK-PROTHTEST
               "; "               WS-RESULT-TEXT
               "; Jacobi a-num: " LNK-JACOBI-A-NUM
               "; Divisor: "      LNK-DIVISOR
               "; Start: "        WS-START-TIME
               "; End: "          WS-END-TIME
       END-DISPLAY
    END-IF
    
    .
 CALL-PROTHTEST-EX.
    EXIT.
    
 END PROGRAM prothsearch.
