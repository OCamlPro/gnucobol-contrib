*>******************************************************************************
*>  This file is part of htm2cob.
*>
*>  htm2cob.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  htm2cob.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with htm2cob.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      htm2cob.cob
*>
*> Purpose:      HTML preprocessor
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2019-05-01
*>
*> Tectonics:    cobc -x -free htm2cob.cob
*>
*> Usage:        To use this program, simply start it as follows:
*>               htm2cob <input HTML file> [-m] [-v]
*>                 Options:                                               
*>                   <input HTML file>  This is a HTML file with embedded COBOL 
*>                   -m,   -module      It converts only the lines in <BODY>
*>                   -v,   -verbose     Verbose mode
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2019-02-03 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. htm2cob.

 ENVIRONMENT DIVISION.
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
    SELECT HTM-FILE ASSIGN             TO WS-HTM-FILE-NAME
           FILE STATUS                 IS WS-HTM-FILE-STATUS
           ORGANIZATION                IS LINE SEQUENTIAL.
                                       
    SELECT COB-FILE ASSIGN             TO WS-COB-FILE-NAME
           FILE STATUS                 IS WS-COB-FILE-STATUS
           ORGANIZATION                IS LINE SEQUENTIAL.
           
 DATA DIVISION.
 FILE SECTION.
 FD HTM-FILE.
 01 HTM-LINE                           PIC X(4096).

 FD COB-FILE.
 01 COB-LINE                           PIC X(4096).
    
 WORKING-STORAGE SECTION.
*> flags
 01 WS-FLAGS.
   02 WS-ERROR-FLAG                    PIC 9(01).
      88 V-ERROR-NO                    VALUE 0.
      88 V-ERROR-YES                   VALUE 1.
   02 WS-HTM-FILE-FLAG                 PIC 9(01).
      88 V-HTM-FILE-OPEN-NO            VALUE 0.
      88 V-HTM-FILE-OPEN-YES           VALUE 1.
   02 WS-COB-FILE-FLAG                 PIC 9(01).
      88 V-COB-FILE-OPEN-NO            VALUE 0.
      88 V-COB-FILE-OPEN-YES           VALUE 1.
   02 WS-WITH-DISPLAY-FLAG             PIC 9(01).
      88 V-WITH-DISPLAY-NO             VALUE 0.
      88 V-WITH-DISPLAY-YES            VALUE 1.
   02 WS-IN-HTML-FLAG                  PIC 9(01).
      88 V-IN-HTML-NO                  VALUE 0.
      88 V-IN-HTML-YES                 VALUE 1.
   02 WS-IN-BODY-FLAG                  PIC 9(01).
      88 V-IN-BODY-NO                  VALUE 0.
      88 V-IN-BODY-YES                 VALUE 1.
   02 WS-WRITE-COB-FLAG                PIC 9(01).
      88 V-WRITE-COB-NO                VALUE 0.
      88 V-WRITE-COB-YES               VALUE 1.

*> for command line processing 
 01 CMD-LINE-PARAMETERS.
   02 CMD-LINE-PAR                     PIC X(256).
      88 V-CMD-LINE-PAR-MODULE         VALUE "-m", "-module".
      88 V-CMD-LINE-PAR-VERBOSE        VALUE "-v", "-verbose".
*> command line flags      
   02 CMD-LINE-PAR-MODULE-FLAG         PIC 9(1).
      88 V-CMD-LINE-PAR-MODULE-NO      VALUE 0.
      88 V-CMD-LINE-PAR-MODULE-YES     VALUE 1.
   02 CMD-LINE-PAR-VERBOSE-FLAG        PIC 9(1).
      88 V-CMD-LINE-PAR-VERBOSE-NO     VALUE 0.
      88 V-CMD-LINE-PAR-VERBOSE-YES    VALUE 1.
 01 CMD-LINE-VALUES.
   02 CMD-HTM-FILE-NAME                PIC X(256) VALUE SPACES.
 01 CMD-LINE-END-FLAG                  PIC 9(1).
    88 V-CMD-LINE-END-NO               VALUE 0.
    88 V-CMD-LINE-END-YES              VALUE 1.
 01 CMD-NUMBER-OF-ARG                  PIC 9(04)  VALUE ZEROES.

*> for CBL_CHECK_FILE_EXIST 
 01 ARGUMENT-1                         PIC X(256).
 01 ARGUMENT-2.
   02 FILE-SIZE-IN-BYTES               PIC 9(18) COMP.
   02 MOD-DD                           PIC 9(2) COMP. *> Modification Time
   02 MOD-MO                           PIC 9(2) COMP.
   02 MOD-YYYY                         PIC 9(4) COMP. *> Modification Date
   02 MOD-HH                           PIC 9(2) COMP.
   02 MOD-MM                           PIC 9(2) COMP.
   02 MOD-SS                           PIC 9(2) COMP.
   02 FILLER                           PIC 9(2) COMP. *> This will always be 00
 
*> file names
 01 WS-HTM-FILE-NAME                   PIC X(256) VALUE SPACES.
 01 WS-COB-FILE-NAME                   PIC X(256) VALUE SPACES.
 01 WS-PROG-ID                         PIC X(256) VALUE SPACES.
 01 WS-PARAM-FILE-NAME                 PIC X(256) VALUE SPACES.
 01 WS-INSP-COUNT                      PIC 9(04)  VALUE ZEROES.
 01 WS-INSP-COUNT-1                    PIC 9(04)  VALUE ZEROES.
 01 WS-INSP-COUNT-2                    PIC 9(04)  VALUE ZEROES.
 
*> file-status
 01 WS-FILE-STATUS.
   02 WS-HTM-FILE-STATUS               PIC 9(02).
*>    88 V-HTM-FILE-OK                 VALUE 00.
      88 V-HTM-FILE-OK                 VALUE 00, 02, 04, 05, 07.
      88 V-HTM-FILE-EOF                VALUE 10.
   02 WS-COB-FILE-STATUS               PIC 9(02).
*>    88 V-COB-FILE-OK                 VALUE 00.
      88 V-COB-FILE-OK                 VALUE 00, 02, 04, 05, 07.
      88 V-COB-FILE-EOF                VALUE 10.

*> file-status message
 01 WS-FS-MESSAGE.
   02 FILLER                           PIC X(13) VALUE "Status Code: ".
   02 WS-FS-CODE                       PIC 9(2).
   02 FILLER                           PIC X(11) VALUE ", Meaning: ".
   02 WS-FS-MSG-TXT                    PIC X(25).  
       
 01 WS-HTM-LINE-LEN                    PIC S9(09).

*> counter
 01 WS-IND-1                           PIC S9(09).
 01 WS-IND-2                           PIC S9(09).
 01 WS-LINE-COUNT-1                    PIC S9(09).
 01 WS-TEST-IND-1                      PIC S9(09).
 01 WS-TEST-IND-2                      PIC S9(09).

 01 WS-FROM-LINE                       PIC S9(09).
 01 WS-FROM-COL                        PIC S9(09).
 01 WS-TO-LINE                         PIC S9(09).
 01 WS-TO-COL                          PIC S9(09).

*> constant defines
 01 C-SUBS-FROM                        CONSTANT AS "_cob.html". 
 01 C-SUBS-TO                          CONSTANT AS ".cob". 
 01 C-SUBS-PARAM                       CONSTANT AS "_param.cpy". 
 01 C-SUBS-FROM-QM                     CONSTANT AS """". 
 01 C-SUBS-TO-QM                       CONSTANT AS """""". 
 01 C-MAX-LEN                          CONSTANT AS 4096.
*> HTML tags 
 01 C-TAG-HTML                         CONSTANT AS "<HTML>".
 01 C-TAG-HTML-LEN                     CONSTANT AS 6.
 01 C-TAG-HTML-END                     CONSTANT AS "</HTML>".
 01 C-TAG-HTML-END-LEN                 CONSTANT AS 7.
 01 C-TAG-BODY                         CONSTANT AS "<BODY>".
 01 C-TAG-BODY-LEN                     CONSTANT AS 6.
 01 C-TAG-BODY-END                     CONSTANT AS "</BODY>".
 01 C-TAG-BODY-END-LEN                 CONSTANT AS 7.
*> COBOL tags
 01 C-TAG-COB-WS                       CONSTANT AS "<?COB-WS".
 01 C-TAG-COB-WS-LEN                   CONSTANT AS 8.
 01 C-TAG-COB                          CONSTANT AS "<?COB".
 01 C-TAG-COB-LEN                      CONSTANT AS 5.
 01 C-TAG-COB-END                      CONSTANT AS "?>".
 01 C-TAG-COB-END-LEN                  CONSTANT AS 2.
 
*> end of line char
 01 ENDL                               CONSTANT AS X"0A".

*> parse table
 01 C-PARSE-TAB-MAX-LINE               CONSTANT AS 10000.
 01 WS-PARSE-TAB-IND                   PIC S9(09).
 01 WS-PARSE-TAB-MAX-IND               PIC S9(09).
 01 WS-PARSE-TAB.
   02 WS-PARSE-TAB-LINES OCCURS C-PARSE-TAB-MAX-LINE TIMES.
     03 WS-PARSE-TAB-LINE              PIC S9(9).
     03 WS-PARSE-TAB-COL               PIC S9(9).
     03 WS-PARSE-TAB-TAG               PIC X(20).
 
*> diplay table fields
 01 WS-DISP-COUNT                      PIC Z(10).
 01 WS-DISP-LINE                       PIC Z(10).
 01 WS-DISP-COL                        PIC Z(10).

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
 
*>------------------------------------------------------------------------------
*> Main program template
 COPY "htm2cob0.cpy".

*>------------------------------------------------------------------------------
*> HTM2COB sections template
 COPY "htm2cob1.cpy".
     
*>------------------------------------------------------------------------------
*> Program HTM2COB-POST template
 COPY "htm2cob2.cpy".

*>------------------------------------------------------------------------------
*> Program HTM2COB-ENV template
 COPY "htm2cob3.cpy".

*>------------------------------------------------------------------------------
*> Program HTM2COB-DECODE template
 COPY "htm2cob4.cpy".

*>------------------------------------------------------------------------------
*> Program HTM2COB-SPEC-CHARS template
 COPY "htm2cob5.cpy".
 
*>------------------------------------------------------------------------------
*> Program HTM2COB-SESSION-ID template
 COPY "htm2cob6.cpy".

*>------------------------------------------------------------------------------
*> Program HTM2COB-SESSION template
 COPY "htm2cob7.cpy".
 
*>------------------------------------------------------------------------------
*> Program HTM2COB-COOKIE template
 COPY "htm2cob8.cpy".
 
 PROCEDURE DIVISION.

 DECLARATIVES.

*>------------------------------------------------------------------------------
 HTM-FILE-ERROR SECTION.
*>------------------------------------------------------------------------------

    USE AFTER STANDARD ERROR PROCEDURE ON HTM-FILE.

    IF NOT V-HTM-FILE-EOF OF WS-HTM-FILE-STATUS
    THEN
       MOVE WS-HTM-FILE-STATUS 
         TO WS-FS-CODE                 OF WS-FS-MESSAGE
       PERFORM EVAL-FILE-STATUS  
       DISPLAY WS-FS-MESSAGE END-DISPLAY
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 COB-FILE-ERROR SECTION.
*>------------------------------------------------------------------------------

    USE AFTER STANDARD ERROR PROCEDURE ON COB-FILE.

    IF NOT V-COB-FILE-EOF OF WS-COB-FILE-STATUS
    THEN
       MOVE WS-COB-FILE-STATUS 
         TO WS-FS-CODE                 OF WS-FS-MESSAGE
       PERFORM EVAL-FILE-STATUS  
       DISPLAY WS-FS-MESSAGE END-DISPLAY
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 EVAL-FILE-STATUS SECTION.
*>------------------------------------------------------------------------------
    
    EVALUATE WS-FS-CODE OF WS-FS-MESSAGE
       WHEN 00 MOVE "SUCCESS "                 TO WS-FS-MSG-TXT
       WHEN 02 MOVE "SUCCESS DUPLICATE "       TO WS-FS-MSG-TXT
       WHEN 04 MOVE "SUCCESS INCOMPLETE "      TO WS-FS-MSG-TXT
       WHEN 05 MOVE "SUCCESS OPTIONAL "        TO WS-FS-MSG-TXT
       WHEN 07 MOVE "SUCCESS NO UNIT "         TO WS-FS-MSG-TXT
       WHEN 10 MOVE "END OF FILE "             TO WS-FS-MSG-TXT
       WHEN 14 MOVE "OUT OF KEY RANGE "        TO WS-FS-MSG-TXT
       WHEN 21 MOVE "KEY INVALID "             TO WS-FS-MSG-TXT
       WHEN 22 MOVE "KEY EXISTS "              TO WS-FS-MSG-TXT
       WHEN 23 MOVE "KEY NOT EXISTS "          TO WS-FS-MSG-TXT
       WHEN 30 MOVE "PERMANENT ERROR "         TO WS-FS-MSG-TXT
       WHEN 31 MOVE "INCONSISTENT FILENAME "   TO WS-FS-MSG-TXT
       WHEN 34 MOVE "BOUNDARY VIOLATION "      TO WS-FS-MSG-TXT
       WHEN 35 MOVE "FILE NOT FOUND "          TO WS-FS-MSG-TXT
       WHEN 37 MOVE "PERMISSION DENIED "       TO WS-FS-MSG-TXT
       WHEN 38 MOVE "CLOSED WITH LOCK "        TO WS-FS-MSG-TXT
       WHEN 39 MOVE "CONFLICT ATTRIBUTE "      TO WS-FS-MSG-TXT
       WHEN 41 MOVE "ALREADY OPEN "            TO WS-FS-MSG-TXT
       WHEN 42 MOVE "NOT OPEN "                TO WS-FS-MSG-TXT
       WHEN 43 MOVE "READ NOT DONE "           TO WS-FS-MSG-TXT
       WHEN 44 MOVE "RECORD OVERFLOW "         TO WS-FS-MSG-TXT
       WHEN 46 MOVE "READ ERROR "              TO WS-FS-MSG-TXT
       WHEN 47 MOVE "INPUT DENIED "            TO WS-FS-MSG-TXT
       WHEN 48 MOVE "OUTPUT DENIED "           TO WS-FS-MSG-TXT
       WHEN 49 MOVE "I/O DENIED "              TO WS-FS-MSG-TXT
       WHEN 51 MOVE "RECORD LOCKED "           TO WS-FS-MSG-TXT
       WHEN 52 MOVE "END-OF-PAGE "             TO WS-FS-MSG-TXT
       WHEN 57 MOVE "I/O LINAGE "              TO WS-FS-MSG-TXT
       WHEN 61 MOVE "FILE SHARING FAILURE "    TO WS-FS-MSG-TXT
       WHEN 91 MOVE "FILE NOT AVAILABLE "      TO WS-FS-MSG-TXT
    END-EVALUATE
    
    EXIT SECTION .
    
 END DECLARATIVES.
 
*>------------------------------------------------------------------------------
 MAIN-HTM2COB SECTION.
*>------------------------------------------------------------------------------

*>  program start time    
    MOVE FUNCTION CURRENT-DATE      TO CURRENT-DATE-AND-TIME
    MOVE CORR CURRENT-DATE-AND-TIME TO WS-DATE-TIME
    IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       DISPLAY " "                            END-DISPLAY 
       DISPLAY "Program start: " WS-DATE-TIME END-DISPLAY
       DISPLAY " "                            END-DISPLAY 
    END-IF

    INITIALIZE WS-FLAGS
    INITIALIZE WS-FILE-STATUS

*>  get input parameters
    PERFORM READ-CMD-LINE
    
*>  create output file name
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM CREATE-FILE-NAME    
    END-IF

*>  open output file
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM OPEN-COB-FILE    
    END-IF
 
*>  convert the HTML file in a COBOL CGI program
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM PROCESS-HTM-FILE
    END-IF

*>  write sections
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-SECTIONS
    END-IF
    
*>  write modules
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-MODULES
    END-IF
 
*>  close output file, if open
    PERFORM CLOSE-COB-FILE    

*>  close input file, if open
    PERFORM CLOSE-HTM-FILE    
    
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
*>     set status for make
       STOP RUN WITH ERROR STATUS
    ELSE
       STOP RUN WITH NORMAL STATUS
    END-IF
    .
    
*>------------------------------------------------------------------------------
 READ-CMD-LINE SECTION.
*>------------------------------------------------------------------------------

    SET V-CMD-LINE-PAR-MODULE-NO  OF CMD-LINE-PAR-MODULE-FLAG  TO TRUE
    SET V-CMD-LINE-PAR-VERBOSE-NO OF CMD-LINE-PAR-VERBOSE-FLAG TO TRUE

    ACCEPT CMD-NUMBER-OF-ARG FROM ARGUMENT-NUMBER END-ACCEPT
    
    IF CMD-NUMBER-OF-ARG < 1 OR CMD-NUMBER-OF-ARG > 3
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Number of argument is: " 
               CMD-NUMBER-OF-ARG END-DISPLAY    
       PERFORM DISPLAY-USAGE
       EXIT SECTION
    END-IF
    
    PERFORM UNTIL V-CMD-LINE-END-YES
       MOVE SPACES TO CMD-LINE-PAR
       ACCEPT CMD-LINE-PAR FROM ARGUMENT-VALUE
*> todo, it does not work on cygwin       
*>        ON EXCEPTION 
*>           SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
*>           DISPLAY "*** Error: Exception at accept argument." END-DISPLAY  
*>           PERFORM DISPLAY-USAGE
*>           EXIT SECTION
       END-ACCEPT
       
       IF CMD-LINE-PAR NOT = SPACES
       THEN
*>        convert in lower case       
          MOVE FUNCTION LOWER-CASE(CMD-LINE-PAR) TO CMD-LINE-PAR
          PERFORM PROCESS-CMD-LINE       
       ELSE
          SET V-CMD-LINE-END-YES TO TRUE
       END-IF
    END-PERFORM

    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM CHECK-PARAMETERS
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 PROCESS-CMD-LINE SECTION.
*>------------------------------------------------------------------------------

    EVALUATE TRUE
        WHEN V-CMD-LINE-PAR-MODULE         
             SET V-CMD-LINE-PAR-MODULE-YES  TO TRUE

        WHEN V-CMD-LINE-PAR-VERBOSE         
             SET V-CMD-LINE-PAR-VERBOSE-YES TO TRUE

        WHEN OTHER
             MOVE CMD-LINE-PAR TO CMD-HTM-FILE-NAME
    END-EVALUATE
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CHECK-PARAMETERS SECTION.
*>------------------------------------------------------------------------------

    IF CMD-NUMBER-OF-ARG = 2 
    AND V-CMD-LINE-PAR-MODULE-NO  OF CMD-LINE-PAR-MODULE-FLAG
    AND V-CMD-LINE-PAR-VERBOSE-NO OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Input parameter error" END-DISPLAY 
       PERFORM DISPLAY-USAGE
       EXIT SECTION
    END-IF

    IF CMD-NUMBER-OF-ARG = 3 
    AND NOT (    V-CMD-LINE-PAR-MODULE-YES  OF CMD-LINE-PAR-MODULE-FLAG
             AND V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG)
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Input parameter error" END-DISPLAY 
       PERFORM DISPLAY-USAGE
       EXIT SECTION
    END-IF
    
    MOVE CMD-HTM-FILE-NAME TO ARGUMENT-1
    CALL "CBL_CHECK_FILE_EXIST" USING ARGUMENT-1
                                      ARGUMENT-2
    END-CALL    

    IF RETURN-CODE = ZEROES
       MOVE CMD-HTM-FILE-NAME TO WS-HTM-FILE-NAME
       IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
       THEN
          DISPLAY "Input  file: " FUNCTION TRIM(WS-HTM-FILE-NAME) END-DISPLAY
       END-IF
    ELSE
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Input file does not exist: " 
               CMD-HTM-FILE-NAME END-DISPLAY    
       PERFORM DISPLAY-USAGE
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 DISPLAY-USAGE SECTION.
*>------------------------------------------------------------------------------

    DISPLAY " "                                                      END-DISPLAY
    DISPLAY "Usage:"                                                 END-DISPLAY 
    DISPLAY " "                                                      END-DISPLAY
    DISPLAY "htm2cob <input HTML file> [-m] [-v]"                    END-DISPLAY
    DISPLAY " "                                                      END-DISPLAY 
    DISPLAY "htm2cob converts a HTML file in a CGI COBOL program"    END-DISPLAY
    DISPLAY " "                                                      END-DISPLAY
    DISPLAY "Options:"                                               END-DISPLAY 
    DISPLAY " "                                                      END-DISPLAY
    DISPLAY "<input HTML file>  This is a HTML file with embedded COBOL" END-DISPLAY
    DISPLAY "-m,   -module      It converts only the lines in <BODY>" END-DISPLAY
    DISPLAY "-v,   -verbose     Verbose mode"                        END-DISPLAY
    DISPLAY " "                                                      END-DISPLAY
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 CREATE-FILE-NAME SECTION.
*>------------------------------------------------------------------------------
    
    MOVE FUNCTION TRIM(WS-HTM-FILE-NAME)             
      TO WS-COB-FILE-NAME 

    MOVE ZEROES TO WS-INSP-COUNT  
    INSPECT WS-COB-FILE-NAME 
       TALLYING WS-INSP-COUNT
       FOR ALL C-SUBS-FROM    

    IF WS-INSP-COUNT NOT = 1
    THEN
       DISPLAY "*** Error: String " C-SUBS-FROM 
               "not found in input file name." 
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF   

*>  convert the file name from "*_cob.html" to "*.cob"
    MOVE FUNCTION SUBSTITUTE(WS-COB-FILE-NAME, C-SUBS-FROM, C-SUBS-TO)
      TO WS-COB-FILE-NAME
    
    IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       DISPLAY "Output file: " FUNCTION TRIM(WS-COB-FILE-NAME) END-DISPLAY   
    END-IF   
    
*>  search for file path chars    
    MOVE ZEROES TO WS-INSP-COUNT    
    INSPECT WS-COB-FILE-NAME 
       TALLYING WS-INSP-COUNT
       FOR ALL "\" "/"
 
    IF WS-INSP-COUNT > ZEROES
    THEN
       MOVE ZEROES TO WS-INSP-COUNT    
       MOVE ZEROES TO WS-INSP-COUNT-1    
       MOVE ZEROES TO WS-INSP-COUNT-2    

       INSPECT FUNCTION REVERSE(WS-COB-FILE-NAME) 
          TALLYING WS-INSP-COUNT-1
          FOR CHARACTERS BEFORE INITIAL "\"

       INSPECT FUNCTION REVERSE(WS-COB-FILE-NAME) 
          TALLYING WS-INSP-COUNT-2
          FOR CHARACTERS BEFORE INITIAL "/"
          
       MOVE FUNCTION MIN(WS-INSP-COUNT-1, WS-INSP-COUNT-2)               
         TO WS-INSP-COUNT
          
       MOVE WS-COB-FILE-NAME(FUNCTION LENGTH(WS-COB-FILE-NAME) - WS-INSP-COUNT + 1:)
         TO WS-PROG-ID       
    ELSE     
       MOVE WS-COB-FILE-NAME
         TO WS-PROG-ID       
    END-IF   

*>  create and replace program-id    
    MOVE SPACES TO WS-PRG OF WS-CGI-PROG
    STRING " PROGRAM-ID. " DELIMITED BY SIZE
       FUNCTION SUBSTITUTE(WS-PROG-ID, C-SUBS-TO, " ") DELIMITED BY SPACE
       "." DELIMITED BY SIZE
      INTO WS-PRG OF WS-CGI-PROG
    END-STRING
    
    IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       DISPLAY WS-PRG OF WS-CGI-PROG END-DISPLAY
    END-IF
    
*>  replace date-time   
    MOVE SPACES TO WS-DT OF WS-CGI-PROG
    STRING "*>  Date-Time: " DELIMITED BY SIZE
           WS-DATE-TIME      DELIMITED BY SIZE
      INTO WS-DT OF WS-CGI-PROG
    END-STRING

*>  replace param file name    
    MOVE WS-PROG-ID TO WS-PARAM-FILE-NAME
    MOVE FUNCTION SUBSTITUTE(WS-PARAM-FILE-NAME, C-SUBS-TO, C-SUBS-PARAM)
      TO WS-PARAM-FILE-NAME
      
    MOVE SPACES TO WS-PAR OF WS-CGI-PROG
    STRING " COPY """         DELIMITED BY SIZE
           WS-PARAM-FILE-NAME DELIMITED BY SPACE
           """."              DELIMITED BY SIZE
      INTO WS-PAR OF WS-CGI-PROG
    END-STRING
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 OPEN-HTM-FILE SECTION.
*>------------------------------------------------------------------------------
     
    OPEN INPUT HTM-FILE 

    IF V-HTM-FILE-OK OF WS-HTM-FILE-STATUS
    THEN
       SET V-HTM-FILE-OPEN-YES OF WS-HTM-FILE-FLAG TO TRUE
    ELSE
       SET V-HTM-FILE-OPEN-NO  OF WS-HTM-FILE-FLAG TO TRUE
       DISPLAY "*** Error at OPEN input file." END-DISPLAY    
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 OPEN-COB-FILE SECTION.
*>------------------------------------------------------------------------------
     
    OPEN OUTPUT COB-FILE 

    IF V-COB-FILE-OK OF WS-COB-FILE-STATUS
    THEN
       SET V-COB-FILE-OPEN-YES OF WS-COB-FILE-FLAG TO TRUE
    ELSE
       SET V-COB-FILE-OPEN-NO  OF WS-COB-FILE-FLAG TO TRUE
       DISPLAY "*** Error at OPEN output file." END-DISPLAY    
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 CLOSE-HTM-FILE SECTION.
*>------------------------------------------------------------------------------
     
    IF V-HTM-FILE-OPEN-YES OF WS-HTM-FILE-FLAG
    THEN
       CLOSE HTM-FILE 
       
       IF V-HTM-FILE-OK OF WS-HTM-FILE-STATUS
       THEN
          SET V-HTM-FILE-OPEN-NO OF WS-HTM-FILE-FLAG TO TRUE
       ELSE
          DISPLAY "*** Error at CLOSE input file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF    
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 CLOSE-COB-FILE SECTION.
*>------------------------------------------------------------------------------
     
    IF V-COB-FILE-OPEN-YES OF WS-COB-FILE-FLAG
    THEN
       CLOSE COB-FILE 
       
       IF V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          SET V-COB-FILE-OPEN-NO OF WS-COB-FILE-FLAG TO TRUE
       ELSE
          DISPLAY "*** Error at CLOSE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF    
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 PROCESS-HTM-FILE SECTION.
*>------------------------------------------------------------------------------

*>  write program header
    PERFORM WRITE-PROG-HEADER
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
    
*>  process HTML tags
    PERFORM PROCESS-HTM-TAGS
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

*>  display internal table
    IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       PERFORM DISP-PARSE-TAB
    END-IF

*>  check tags in the internal table
    PERFORM CHECK-PARSE-TAB
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

*>  write working-storage section
    PERFORM WRITE-WS-SECTION
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
    
*>  write main section
    PERFORM WRITE-MAIN-SECTION
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-PROG-HEADER SECTION.
*>------------------------------------------------------------------------------

    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE
    
    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-CGI-PROG-MAIN-LINE

       MOVE WS-CGI-PROG-LINE(WS-IND-2) 
         TO COB-LINE
       
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 PROCESS-HTM-TAGS SECTION.
*>------------------------------------------------------------------------------

    PERFORM OPEN-HTM-FILE
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    MOVE ZEROES TO WS-LINE-COUNT-1
    MOVE ZEROES TO WS-PARSE-TAB-IND
    MOVE ZEROES TO WS-PARSE-TAB-MAX-IND
    
*>  search HTML tags, and save them in the internal table
    PERFORM SEARCH-HTM-TAGS
      UNTIL V-HTM-FILE-EOF OF WS-HTM-FILE-STATUS
      OR    V-ERROR-YES    OF WS-ERROR-FLAG

    PERFORM CLOSE-HTM-FILE
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 SEARCH-HTM-TAGS SECTION.
*>------------------------------------------------------------------------------

*>  read input HTML file            
    MOVE SPACES TO HTM-LINE
    MOVE ZEROES TO WS-HTM-LINE-LEN

    READ HTM-FILE END-READ
    IF V-HTM-FILE-OK OF WS-HTM-FILE-STATUS
    THEN
       ADD 1 TO WS-LINE-COUNT-1 END-ADD
    ELSE
       IF V-HTM-FILE-EOF OF WS-HTM-FILE-STATUS
       THEN
          EXIT SECTION
       ELSE
          DISPLAY "*** Error at READ input file. Line: " 
                  WS-LINE-COUNT-1 
          END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF
    
*>  compute input line length
    INSPECT FUNCTION REVERSE(HTM-LINE)
       TALLYING WS-HTM-LINE-LEN FOR LEADING " "
    COMPUTE WS-HTM-LINE-LEN = FUNCTION LENGTH(HTM-LINE) 
                            - WS-HTM-LINE-LEN 
    END-COMPUTE

*>  looking for tags
    MOVE 1 TO WS-IND-1
    PERFORM UNTIL WS-IND-1 > WS-HTM-LINE-LEN

*>     <HTML>    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-HTML-LEN)) 
          = C-TAG-HTML
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-HTML      TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-HTML-LEN TO WS-IND-1 END-ADD      
          EXIT PERFORM CYCLE
       END-IF       
      
*>     </HTML>    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-HTML-END-LEN)) 
          = C-TAG-HTML-END
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-HTML-END  TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-HTML-END-LEN TO WS-IND-1 END-ADD        
          EXIT PERFORM CYCLE
       END-IF       

*>     <BODY>    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-BODY-LEN)) 
          = C-TAG-BODY
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-BODY      TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-BODY-LEN TO WS-IND-1 END-ADD      
          EXIT PERFORM CYCLE
       END-IF       
      
*>     </BODY>    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-BODY-END-LEN)) 
          = C-TAG-BODY-END
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-BODY-END  TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-BODY-END-LEN TO WS-IND-1 END-ADD      
          EXIT PERFORM CYCLE
       END-IF       
       
*>     <?COB-WS    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-COB-WS-LEN)) 
          = C-TAG-COB-WS
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-COB-WS    TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-COB-WS-LEN TO WS-IND-1 END-ADD      
          EXIT PERFORM CYCLE
       END-IF       
       
*>     <?COB    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-COB-LEN)) 
          = C-TAG-COB
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-COB       TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-COB-LEN TO WS-IND-1 END-ADD      
          EXIT PERFORM CYCLE
       END-IF       
       
*>     ?>    
       IF FUNCTION UPPER-CASE(HTM-LINE(WS-IND-1:C-TAG-COB-END-LEN)) 
          = C-TAG-COB-END
       THEN
          ADD 1 TO WS-PARSE-TAB-IND END-ADD
          MOVE WS-LINE-COUNT-1 TO WS-PARSE-TAB-LINE(WS-PARSE-TAB-IND)
          MOVE WS-IND-1        TO WS-PARSE-TAB-COL (WS-PARSE-TAB-IND)
          MOVE C-TAG-COB-END   TO WS-PARSE-TAB-TAG (WS-PARSE-TAB-IND)

          ADD C-TAG-COB-END-LEN TO WS-IND-1 END-ADD       
          EXIT PERFORM CYCLE
       END-IF       
       
*>     no tags found            
       ADD 1 TO WS-IND-1 END-ADD
       
    END-PERFORM

    MOVE WS-PARSE-TAB-IND TO WS-PARSE-TAB-MAX-IND
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 DISP-PARSE-TAB SECTION.
*>------------------------------------------------------------------------------

    DISPLAY " "                                                             END-DISPLAY
    DISPLAY " Count     | Line       | Col        | Tag                  |" END-DISPLAY
    DISPLAY "-----------+------------+------------+----------------------+" END-DISPLAY

    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      MOVE WS-IND-1                    TO WS-DISP-COUNT
      MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-DISP-LINE 
      MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-DISP-COL 
      
       DISPLAY WS-DISP-COUNT          " | "      
          WS-DISP-LINE                " | "
          WS-DISP-COL                 " | "
          WS-PARSE-TAB-TAG (WS-IND-1) " | "
       END-DISPLAY   
       
    END-PERFORM

    DISPLAY " " END-DISPLAY
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 
 CHECK-PARSE-TAB SECTION.
*>------------------------------------------------------------------------------

    IF V-CMD-LINE-PAR-VERBOSE-YES OF CMD-LINE-PAR-VERBOSE-FLAG
    THEN
       DISPLAY "Check tags..." END-DISPLAY
       DISPLAY " " END-DISPLAY
    END-IF

    PERFORM CHECK-TAG-HTML
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    PERFORM CHECK-TAG-BODY
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    PERFORM CHECK-TAG-COB-WS
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CHECK-TAG-HTML SECTION.
*>------------------------------------------------------------------------------

*>  check if exist <HTML> and </HTML>
    MOVE ZEROES TO WS-TEST-IND-1
    MOVE ZEROES TO WS-TEST-IND-2
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-HTML
      THEN
         ADD 1 TO WS-TEST-IND-1 END-ADD
      END-IF

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-HTML-END
      THEN
         ADD 1 TO WS-TEST-IND-2 END-ADD
      END-IF
    END-PERFORM

    IF WS-TEST-IND-1 = ZEROES
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Not found: " C-TAG-HTML END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    IF WS-TEST-IND-2 = ZEROES
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Not found: " C-TAG-HTML-END END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF

    IF WS-TEST-IND-1 > 1
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: More than one found: " C-TAG-HTML END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    IF WS-TEST-IND-2 > 1
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: More than one found: " C-TAG-HTML-END END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF

*>  check <HTML> and </HTML> sequence
    MOVE ZEROES TO WS-TEST-IND-1
    MOVE ZEROES TO WS-TEST-IND-2
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-HTML
      THEN
         MOVE WS-IND-1 TO WS-TEST-IND-1
      END-IF

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-HTML-END
      THEN
         MOVE WS-IND-1 TO WS-TEST-IND-2
      END-IF
    END-PERFORM

    IF WS-TEST-IND-1 > WS-TEST-IND-2
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Sequence is incorrect with: " 
               C-TAG-HTML " and " C-TAG-HTML-END
       END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 CHECK-TAG-BODY SECTION.
*>------------------------------------------------------------------------------

*>  check if exist <BODY> and </BODY>
    MOVE ZEROES TO WS-TEST-IND-1
    MOVE ZEROES TO WS-TEST-IND-2
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-BODY
      THEN
         ADD 1 TO WS-TEST-IND-1 END-ADD
      END-IF

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-BODY-END
      THEN
         ADD 1 TO WS-TEST-IND-2 END-ADD
      END-IF
    END-PERFORM

    IF WS-TEST-IND-1 = ZEROES
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Not found: " C-TAG-BODY END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    IF WS-TEST-IND-2 = ZEROES
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Not found: " C-TAG-BODY-END END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF

    IF WS-TEST-IND-1 > 1
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: More than one found: " C-TAG-BODY END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    IF WS-TEST-IND-2 > 1
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: More than one found: " C-TAG-BODY-END END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF

*>  check <BODY> and </BODY> sequence
    MOVE ZEROES TO WS-TEST-IND-1
    MOVE ZEROES TO WS-TEST-IND-2
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-BODY
      THEN
         MOVE WS-IND-1 TO WS-TEST-IND-1
      END-IF

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-BODY-END
      THEN
         MOVE WS-IND-1 TO WS-TEST-IND-2
      END-IF
    END-PERFORM

    IF WS-TEST-IND-1 > WS-TEST-IND-2
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Sequence is incorrect with: " 
               C-TAG-BODY " and " C-TAG-BODY-END
       END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CHECK-TAG-COB-WS SECTION.
*>------------------------------------------------------------------------------

*>  check <?COB-WS, <?COB and ?> sequence
    MOVE ZEROES TO WS-TEST-IND-1
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB-WS
      OR WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB
      THEN
         IF WS-IND-1 > 1
         AND (   WS-PARSE-TAB-TAG (WS-IND-1 - 1) = C-TAG-COB-WS
              OR WS-PARSE-TAB-TAG (WS-IND-1 - 1) = C-TAG-COB)
         THEN
            SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
            DISPLAY "*** Error: Sequence is incorrect(1) with: " 
                    C-TAG-COB-WS " , " C-TAG-COB " and " C-TAG-COB-END
            END-DISPLAY   
            MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-DISP-LINE 
            MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-DISP-COL 
            DISPLAY "Check " C-TAG-COB-WS " , " C-TAG-COB 
                    " and " C-TAG-COB-END
                    " at line: " WS-DISP-LINE " and col: " WS-DISP-COL
            END-DISPLAY   
            DISPLAY " " END-DISPLAY   
            EXIT SECTION
         END-IF   
      END-IF

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB-END
      THEN
         IF WS-IND-1 = 1
         OR ((WS-IND-1 > 1) 
             AND NOT (   WS-PARSE-TAB-TAG (WS-IND-1 - 1) = C-TAG-COB-WS
                      OR WS-PARSE-TAB-TAG (WS-IND-1 - 1) = C-TAG-COB))
         THEN
            SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
            DISPLAY "*** Error: Sequence is incorrect(2) with: " 
                    C-TAG-COB-WS " , " C-TAG-COB " and " C-TAG-COB-END
            END-DISPLAY   
            MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-DISP-LINE 
            MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-DISP-COL 
            DISPLAY "Check " C-TAG-COB-WS " , " C-TAG-COB 
                    " and " C-TAG-COB-END
                    " at line: " WS-DISP-LINE " and col: " WS-DISP-COL
            END-DISPLAY   
            DISPLAY " " END-DISPLAY   
            EXIT SECTION
         END-IF
      END-IF
    END-PERFORM
    
    MOVE ZEROES TO WS-TEST-IND-1
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB-WS
      OR WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB
      THEN
         ADD 1 TO WS-TEST-IND-1 END-ADD
      END-IF
      
      IF WS-PARSE-TAB-TAG (WS-IND-1) = C-TAG-COB-END
      THEN
         SUBTRACT 1 FROM WS-TEST-IND-1 END-SUBTRACT
      END-IF
    END-PERFORM

    IF WS-TEST-IND-1 NOT = ZEROES
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "*** Error: Sequence is incorrect(3) with: " 
               C-TAG-COB-WS " , " C-TAG-COB " and " C-TAG-COB-END
       END-DISPLAY   
       DISPLAY "Check " C-TAG-COB-WS " , " C-TAG-COB 
               " and " C-TAG-COB-END
       END-DISPLAY   
       DISPLAY " " END-DISPLAY   
       EXIT SECTION
    END-IF
    
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-WS-SECTION SECTION.
*>------------------------------------------------------------------------------

    SET V-IN-HTML-NO OF WS-IN-HTML-FLAG TO TRUE
    SET V-IN-BODY-NO OF WS-IN-BODY-FLAG TO TRUE
    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE

    PERFORM VARYING WS-IND-1 FROM 1 BY 1
      UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND

       IF WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-COB-WS
       THEN
          MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-FROM-LINE
          COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL(WS-IND-1) 
                              + C-TAG-COB-WS-LEN
          END-COMPUTE                    
          
          MOVE WS-PARSE-TAB-LINE(WS-IND-1 + 1) TO WS-TO-LINE
          COMPUTE WS-TO-COL = WS-PARSE-TAB-COL(WS-IND-1 + 1) 
          END-COMPUTE                    

          PERFORM WRITE-FROM-TO
       END-IF
          
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-MAIN-SECTION SECTION.
*>------------------------------------------------------------------------------

*>  write main start
    PERFORM WRITE-MAIN-START
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    IF V-CMD-LINE-PAR-MODULE-YES OF CMD-LINE-PAR-MODULE-FLAG
    THEN
       SET V-WRITE-COB-NO OF WS-WRITE-COB-FLAG TO TRUE
    END-IF
    
    MOVE 1 TO WS-IND-1
    MOVE 1 TO WS-FROM-LINE
    MOVE 1 TO WS-FROM-COL
    SET V-IN-HTML-NO OF WS-IN-HTML-FLAG TO TRUE
    SET V-IN-BODY-NO OF WS-IN-BODY-FLAG TO TRUE
    
    PERFORM UNTIL WS-IND-1 > WS-PARSE-TAB-MAX-IND
       
       IF WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-HTML
       THEN
          SET V-IN-HTML-YES OF WS-IN-HTML-FLAG TO TRUE
       END-IF       

       IF  WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-HTML-END
       THEN
          SET V-IN-HTML-NO OF WS-IN-HTML-FLAG TO TRUE
          IF V-CMD-LINE-PAR-MODULE-YES OF CMD-LINE-PAR-MODULE-FLAG
          THEN
             SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE
             MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-FROM-LINE
             COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL (WS-IND-1) 
                                 + C-TAG-HTML-END-LEN
             END-COMPUTE                    
          END-IF
       END-IF       

       IF WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-BODY
       THEN
          SET V-IN-BODY-YES OF WS-IN-BODY-FLAG TO TRUE
          IF V-CMD-LINE-PAR-MODULE-YES OF CMD-LINE-PAR-MODULE-FLAG
          THEN
             SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE
             MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-FROM-LINE
             COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL (WS-IND-1) 
                                 + C-TAG-BODY-LEN
             END-COMPUTE                    
          END-IF
       END-IF       

       IF  WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-BODY-END
       THEN
          SET V-IN-BODY-NO OF WS-IN-BODY-FLAG TO TRUE
          IF V-CMD-LINE-PAR-MODULE-YES OF CMD-LINE-PAR-MODULE-FLAG
          THEN
             SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE
             MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-TO-LINE
             MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-TO-COL 
             
             SET V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG TO TRUE      
             PERFORM WRITE-FROM-TO
             
             SET V-WRITE-COB-NO OF WS-WRITE-COB-FLAG TO TRUE
          END-IF
       END-IF       
       
       IF WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-COB-WS
       THEN
          IF  WS-FROM-LINE = 1
          AND WS-FROM-COL  = 1
          AND WS-PARSE-TAB-LINE(WS-IND-1) = 1
          AND WS-PARSE-TAB-COL (WS-IND-1) = 1
          THEN
             CONTINUE          
          ELSE
             MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-TO-LINE
             MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-TO-COL
             SET V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG TO TRUE      
             PERFORM WRITE-FROM-TO
          END-IF   

          MOVE WS-PARSE-TAB-LINE(WS-IND-1 + 1) TO WS-FROM-LINE
          COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL (WS-IND-1 + 1) 
                              + C-TAG-COB-END-LEN
          END-COMPUTE
          
          ADD 2 TO WS-IND-1 END-ADD
          EXIT PERFORM CYCLE
       END-IF

       IF WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-COB
       THEN
          IF  WS-FROM-LINE = 1
          AND WS-FROM-COL  = 1
          AND WS-PARSE-TAB-LINE(WS-IND-1) = 1
          AND WS-PARSE-TAB-COL (WS-IND-1) = 1
          THEN
             CONTINUE          
          ELSE
             IF V-IN-BODY-YES OF WS-IN-BODY-FLAG
             THEN
                MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-TO-LINE
                MOVE WS-PARSE-TAB-COL (WS-IND-1) TO WS-TO-COL
                SET V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG TO TRUE      
                PERFORM WRITE-FROM-TO
             END-IF   
          END-IF   

          MOVE WS-PARSE-TAB-LINE(WS-IND-1)     TO WS-FROM-LINE
          COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL (WS-IND-1) 
                              + C-TAG-COB-LEN
          END-COMPUTE                    
          
          MOVE WS-PARSE-TAB-LINE(WS-IND-1 + 1) TO WS-TO-LINE
          MOVE WS-PARSE-TAB-COL (WS-IND-1 + 1) TO WS-TO-COL
          SET V-WITH-DISPLAY-NO OF WS-WITH-DISPLAY-FLAG TO TRUE      

*>        empty line
          MOVE SPACES TO COB-LINE
          PERFORM WRITE-COB-LINE       

          PERFORM WRITE-FROM-TO

*>        empty line
          MOVE SPACES TO COB-LINE
          PERFORM WRITE-COB-LINE       
          
          MOVE WS-PARSE-TAB-LINE(WS-IND-1 + 1) TO WS-FROM-LINE
          COMPUTE WS-FROM-COL = WS-PARSE-TAB-COL (WS-IND-1 + 1) 
                              + C-TAG-COB-END-LEN
          END-COMPUTE
          
          ADD 2 TO WS-IND-1 END-ADD
          EXIT PERFORM CYCLE
       END-IF

       IF  WS-PARSE-TAB-TAG(WS-IND-1) = C-TAG-HTML-END
       THEN
          MOVE WS-PARSE-TAB-LINE(WS-IND-1) TO WS-TO-LINE
          COMPUTE WS-TO-COL = WS-PARSE-TAB-COL (WS-IND-1)
                            + C-TAG-HTML-END-LEN         
          END-COMPUTE                           
          
          SET V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG TO TRUE      
          PERFORM WRITE-FROM-TO

*>        write main end
          PERFORM WRITE-MAIN-END
          IF V-ERROR-YES OF WS-ERROR-FLAG
          THEN
             EXIT SECTION
          END-IF
          
          MOVE WS-TO-LINE TO WS-FROM-LINE
          COMPUTE WS-FROM-COL = WS-TO-COL + 1 
          END-COMPUTE
          
          ADD 1 TO WS-IND-1 END-ADD
          EXIT PERFORM CYCLE
       END-IF
       
       ADD 1 TO WS-IND-1 END-ADD
       
    END-PERFORM

    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-MAIN-START SECTION.
*>------------------------------------------------------------------------------

    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE

*>  write main start
    PERFORM VARYING WS-IND-2 FROM C-CGI-PROG-MAIN-LINE BY 1
      UNTIL WS-IND-2 > C-CGI-PROG-MAIN-END-LINE

       MOVE WS-CGI-PROG-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-MAIN-END SECTION.
*>------------------------------------------------------------------------------

    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE

*>  write main end
    PERFORM VARYING WS-IND-2 FROM C-CGI-PROG-MAIN-END-LINE BY 1
      UNTIL WS-IND-2 > C-CGI-PROG-MAX-LINE

       MOVE WS-CGI-PROG-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
        
*>------------------------------------------------------------------------------
 WRITE-FROM-TO SECTION.
*>------------------------------------------------------------------------------

    PERFORM OPEN-HTM-FILE
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF

    MOVE ZEROES TO WS-LINE-COUNT-1
    
    PERFORM WRITE-LINES
      UNTIL V-HTM-FILE-EOF OF WS-HTM-FILE-STATUS
      OR    V-ERROR-YES    OF WS-ERROR-FLAG
      OR    WS-LINE-COUNT-1 > WS-TO-LINE

    PERFORM CLOSE-HTM-FILE
    IF V-ERROR-YES OF WS-ERROR-FLAG
    THEN
       EXIT SECTION
    END-IF
      
    EXIT SECTION .
        
*>------------------------------------------------------------------------------
 WRITE-LINES SECTION.
*>------------------------------------------------------------------------------

*>  read input HTML file            
    MOVE SPACES TO HTM-LINE
    MOVE ZEROES TO WS-HTM-LINE-LEN

    READ HTM-FILE END-READ
    IF V-HTM-FILE-OK OF WS-HTM-FILE-STATUS
    THEN
       ADD 1 TO WS-LINE-COUNT-1 END-ADD
    ELSE
       IF V-HTM-FILE-EOF OF WS-HTM-FILE-STATUS
       THEN
          EXIT SECTION
       ELSE
          DISPLAY "*** Error at READ input file. Line: " 
                  WS-LINE-COUNT-1 
          END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF

*>  line not in interval
    IF WS-LINE-COUNT-1 < WS-FROM-LINE
    OR WS-LINE-COUNT-1 > WS-TO-LINE    
    THEN
       EXIT SECTION
    END-IF

*>  compute input line length
    INSPECT FUNCTION REVERSE(HTM-LINE)
       TALLYING WS-HTM-LINE-LEN FOR LEADING " "
    COMPUTE WS-HTM-LINE-LEN = FUNCTION LENGTH(HTM-LINE) 
                            - WS-HTM-LINE-LEN 
    END-COMPUTE

*>  begin and end in the same line
    IF WS-FROM-LINE = WS-TO-LINE
    THEN
       IF  V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG
       THEN
          IF (WS-TO-COL - WS-FROM-COL) > ZEROES
          THEN
             MOVE SPACES TO COB-LINE
             
             STRING "    DISPLAY """   DELIMITED BY SIZE
*>                  convert quotation mark before write
                    FUNCTION SUBSTITUTE(
                       HTM-LINE(WS-FROM-COL:(WS-TO-COL - WS-FROM-COL))
                     , C-SUBS-FROM-QM, C-SUBS-TO-QM)
                                     DELIMITED BY SIZE
                    """ END-DISPLAY" DELIMITED BY SIZE              
               INTO COB-LINE            
             END-STRING       
             PERFORM WRITE-COB-LINE       
          END-IF
       ELSE       
          IF V-IN-HTML-NO OF WS-IN-HTML-FLAG
          THEN
             MOVE HTM-LINE(WS-FROM-COL:(WS-TO-COL - WS-FROM-COL))
               TO COB-LINE
          ELSE
*>           Comment line          
             IF HTM-LINE(WS-FROM-COL:1) = "*"
             THEN
                MOVE HTM-LINE(WS-FROM-COL:(WS-TO-COL - WS-FROM-COL))
                  TO COB-LINE
             ELSE
                MOVE SPACES TO COB-LINE
                STRING "    "          DELIMITED BY SIZE
                       HTM-LINE(WS-FROM-COL:(WS-TO-COL - WS-FROM-COL)) 
                                       DELIMITED BY SIZE
                  INTO COB-LINE            
                END-STRING       
             END-IF   
          END-IF
          PERFORM WRITE-COB-LINE       
       END-IF   
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       EXIT SECTION       
    END-IF

*>  line in interval, write all chars
    IF  WS-FROM-LINE < WS-TO-LINE
    AND WS-FROM-LINE < WS-LINE-COUNT-1
    AND WS-LINE-COUNT-1 < WS-TO-LINE   
    THEN
       IF  V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG
       THEN
          IF WS-HTM-LINE-LEN > ZEROES
          THEN
             MOVE SPACES TO COB-LINE
             
             STRING "    DISPLAY """   DELIMITED BY SIZE
*>                  convert quotation mark before write
                    FUNCTION SUBSTITUTE(
                       HTM-LINE(1:WS-HTM-LINE-LEN)
                     , C-SUBS-FROM-QM, C-SUBS-TO-QM)
                                       DELIMITED BY SIZE
                    """ END-DISPLAY"   DELIMITED BY SIZE              
               INTO COB-LINE            
             END-STRING       
             PERFORM WRITE-COB-LINE       
          END-IF   
       ELSE       
          IF V-IN-HTML-NO OF WS-IN-HTML-FLAG
          THEN
             MOVE HTM-LINE(1:WS-HTM-LINE-LEN)
               TO COB-LINE
          ELSE
*>           Comment line          
             IF HTM-LINE(1:1) = "*"
             THEN
                MOVE HTM-LINE(1:WS-HTM-LINE-LEN)
                  TO COB-LINE
             ELSE
                MOVE SPACES TO COB-LINE
                STRING "    "          DELIMITED BY SIZE
                       HTM-LINE(1:WS-HTM-LINE-LEN) 
                                       DELIMITED BY SIZE
                  INTO COB-LINE            
                END-STRING     
             END-IF             
          END-IF   
          PERFORM WRITE-COB-LINE       
       END-IF   
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       EXIT SECTION       
    END-IF

*>  begin in the from-line
    IF  WS-FROM-LINE < WS-TO-LINE
    AND WS-FROM-LINE = WS-LINE-COUNT-1
    AND WS-LINE-COUNT-1 < WS-TO-LINE   
    THEN
       IF V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG
       THEN
          IF (WS-HTM-LINE-LEN - WS-FROM-COL + 1) > ZEROES
          THEN
             MOVE SPACES TO COB-LINE
             
             STRING "    DISPLAY """   DELIMITED BY SIZE
*>                  convert quotation mark before write
                    FUNCTION SUBSTITUTE(
                       HTM-LINE(WS-FROM-COL:(WS-HTM-LINE-LEN - WS-FROM-COL + 1))
                     , C-SUBS-FROM-QM, C-SUBS-TO-QM)
                                       DELIMITED BY SIZE
                    """ END-DISPLAY"   DELIMITED BY SIZE              
               INTO COB-LINE            
             END-STRING       
             PERFORM WRITE-COB-LINE       
          END-IF   
       ELSE       
          IF V-IN-HTML-NO OF WS-IN-HTML-FLAG
          THEN
             MOVE HTM-LINE(WS-FROM-COL:(WS-HTM-LINE-LEN - WS-FROM-COL + 1))
               TO COB-LINE
          ELSE
*>           Comment line          
             IF HTM-LINE(WS-FROM-COL:1) = "*"
             THEN
                MOVE HTM-LINE(WS-FROM-COL:(WS-HTM-LINE-LEN - WS-FROM-COL + 1))
                  TO COB-LINE
             ELSE
                MOVE SPACES TO COB-LINE
                STRING "    "          DELIMITED BY SIZE
                       HTM-LINE(WS-FROM-COL:(WS-HTM-LINE-LEN - WS-FROM-COL + 1)) 
                                       DELIMITED BY SIZE
                  INTO COB-LINE            
                END-STRING       
             END-IF
          END-IF   
          PERFORM WRITE-COB-LINE       
       END-IF   
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       EXIT SECTION       
    END-IF

*>  begin in the to-line
    IF  WS-FROM-LINE < WS-TO-LINE
    AND WS-FROM-LINE < WS-LINE-COUNT-1
    AND WS-LINE-COUNT-1 = WS-TO-LINE   
    THEN
       IF  V-WITH-DISPLAY-YES OF WS-WITH-DISPLAY-FLAG
       THEN
          IF (WS-TO-COL - 1) > ZEROES
          THEN
             MOVE SPACES TO COB-LINE
             
             STRING "    DISPLAY """   DELIMITED BY SIZE
*>                  convert quotation mark before write
                    FUNCTION SUBSTITUTE(
                       HTM-LINE(1:WS-TO-COL - 1)
                     , C-SUBS-FROM-QM, C-SUBS-TO-QM)
                                     DELIMITED BY SIZE
                    """ END-DISPLAY" DELIMITED BY SIZE              
               INTO COB-LINE            
             END-STRING       
             PERFORM WRITE-COB-LINE       
          END-IF   
       ELSE       
          IF V-IN-HTML-NO OF WS-IN-HTML-FLAG
          THEN
             MOVE HTM-LINE(1:WS-TO-COL - 1)
               TO COB-LINE
          ELSE
*>           Comment line          
             IF HTM-LINE(1:1) = "*"
             THEN
                MOVE HTM-LINE(1:WS-TO-COL - 1)
                  TO COB-LINE
             ELSE
                MOVE SPACES TO COB-LINE
                STRING "    "          DELIMITED BY SIZE
                       HTM-LINE(1:WS-TO-COL - 1) 
                                       DELIMITED BY SIZE
                  INTO COB-LINE            
                END-STRING      
             END-IF             
          END-IF   
          PERFORM WRITE-COB-LINE       
       END-IF   
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       EXIT SECTION       
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-COB-LINE SECTION.
*>------------------------------------------------------------------------------

    IF V-CMD-LINE-PAR-MODULE-NO OF CMD-LINE-PAR-MODULE-FLAG
    OR (    V-CMD-LINE-PAR-MODULE-YES OF CMD-LINE-PAR-MODULE-FLAG
        AND V-WRITE-COB-YES OF WS-WRITE-COB-FLAG)
    THEN    
       WRITE COB-LINE END-WRITE
    END-IF   

    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-SECTIONS SECTION.
*>------------------------------------------------------------------------------

    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-SECTIONS-MAX-LINE

       MOVE WS-HTM2COB-SECTIONS-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-MODULES SECTION.
*>------------------------------------------------------------------------------

    SET V-WRITE-COB-YES OF WS-WRITE-COB-FLAG TO TRUE

*>  write function HTM2COB-POST
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-POST
    END-IF
    
*>  write function HTM2COB-ENV
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-ENV
    END-IF
      
*>  write function HTM2COB-DECODE
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-DECODE
    END-IF

*>  write function HTM2COB-SPEC-CHARS
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-SPEC-CHARS
    END-IF

*>  write function HTM2COB-SESSION-ID
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-SESSION-ID
    END-IF

*>  write function HTM2COB-SESSION
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-SESSION
    END-IF

*>  write function HTM2COB-COOKIE
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM WRITE-HTM2COB-COOKIE
    END-IF
    
*>  write end program
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       MOVE SPACES 
         TO COB-LINE
       STRING " END PROGRAM " DELIMITED BY SIZE
              FUNCTION SUBSTITUTE(WS-PROG-ID, C-SUBS-TO, " ")
                              DELIMITED BY SPACE
              "."             DELIMITED BY SIZE
         INTO COB-LINE     
       END-STRING
         
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-HTM2COB-POST SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-POST-MAX-LINE

       MOVE WS-HTM2COB-POST-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-HTM2COB-ENV SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-ENV-MAX-LINE

       MOVE WS-HTM2COB-ENV-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-HTM2COB-DECODE SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-DECODE-MAX-LINE

       MOVE WS-HTM2COB-DECODE-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-HTM2COB-SPEC-CHARS SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-SPEC-CHARS-MAX-LINE

       MOVE WS-HTM2COB-SPEC-CHARS-LINE(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 WRITE-HTM2COB-SESSION-ID SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-SESSION-ID-MAX-LINE

       MOVE WS-HTM2COB-SESSION-ID-LINES(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-HTM2COB-SESSION SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-SESSION-MAX-LINE

       MOVE WS-HTM2COB-SESSION-LINES(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .

*>------------------------------------------------------------------------------
 WRITE-HTM2COB-COOKIE SECTION.
*>------------------------------------------------------------------------------

    PERFORM VARYING WS-IND-2 FROM 1 BY 1
      UNTIL WS-IND-2 >= C-HTM2COB-COOKIE-MAX-LINE

       MOVE WS-HTM2COB-COOKIE-LINES(WS-IND-2) 
         TO COB-LINE
        
       PERFORM WRITE-COB-LINE       
       IF NOT V-COB-FILE-OK OF WS-COB-FILE-STATUS
       THEN
          DISPLAY "*** Error at WRITE output file." END-DISPLAY    
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM
      
    EXIT SECTION .
    
 END PROGRAM htm2cob.
