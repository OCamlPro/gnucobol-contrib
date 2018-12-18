*>******************************************************************************
*>  COOKIE.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COOKIE.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with COOKIE.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      COOKIE.cob
*>
*> Purpose:      This module creates a cookie string
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-12-18
*>
*> Tectonics:    see the makefile
*>
*> Usage:        To use this module, simply CALL it as follows: 
*>               CALL "COOKIE" USING LNK-COOKIE END-CALL. 
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-12-18 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. COOKIE.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

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

*> Syntax: <day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT   
*> Example: Tue, 12 Nov 2018 22:03:14 GMT  
 01 WS-EXPIRES-DATE-TIME.
   02 WS-DAY-NAME                      PIC X(3).
   02 FILLER                           PIC X(2) VALUE ", ".
   02 WS-DAY                           PIC 9(2).
   02 FILLER                           PIC X(1) VALUE " ".
   02 WS-MONTH                         PIC X(3). 
   02 FILLER                           PIC X(1) VALUE " ".
   02 WS-YEAR                          PIC 9(4).
   02 FILLER                           PIC X(1) VALUE " ".
   02 WS-HOUR                          PIC 9(2). 
   02 FILLER                           PIC X(1) VALUE ":".
   02 WS-MINUTE                        PIC 9(2). 
   02 FILLER                           PIC X(1) VALUE ":".
   02 WS-SECOND                        PIC 9(2). 
   02 FILLER                           PIC X(4) VALUE " GMT".
 
 01 WS-DAY-OF-WEEK                     PIC 9(1).
 01 C-MAX-DAY-IND                      CONSTANT AS 7.
 01 WS-DAY-TAB-R.
   02 FILLER                           PIC X(3) VALUE "Sun".
   02 FILLER                           PIC X(3) VALUE "Mon".
   02 FILLER                           PIC X(3) VALUE "Tue".
   02 FILLER                           PIC X(3) VALUE "Wed".
   02 FILLER                           PIC X(3) VALUE "Thu".
   02 FILLER                           PIC X(3) VALUE "Fri".
   02 FILLER                           PIC X(3) VALUE "Sat".
 01 WS-DAY-TAB REDEFINES WS-DAY-TAB-R.
   02 WS-DAY-TAB-LINES OCCURS C-MAX-DAY-IND TIMES.
     03 WS-DAY                         PIC X(3).
   
 01 C-MAX-MONTH-IND                    CONSTANT AS 12.
 01 WS-MONTH-TAB-R.
   02 FILLER                           PIC X(3) VALUE "Jan".
   02 FILLER                           PIC X(3) VALUE "Feb".
   02 FILLER                           PIC X(3) VALUE "Mar".
   02 FILLER                           PIC X(3) VALUE "Apr".
   02 FILLER                           PIC X(3) VALUE "May".
   02 FILLER                           PIC X(3) VALUE "Jun".
   02 FILLER                           PIC X(3) VALUE "Jul".
   02 FILLER                           PIC X(3) VALUE "Aug".
   02 FILLER                           PIC X(3) VALUE "Sep".
   02 FILLER                           PIC X(3) VALUE "Oct".
   02 FILLER                           PIC X(3) VALUE "Nov".
   02 FILLER                           PIC X(3) VALUE "Dec".
 01 WS-MONTH-TAB REDEFINES WS-MONTH-TAB-R.
   02 WS-MONTH-TAB-LINES OCCURS C-MAX-MONTH-IND TIMES.
     03 WS-MONTH                       PIC X(3).
 
 01 WS-DATE-NUM-R.
   02 WS-YEAR                          PIC 9(4).
   02 WS-MONTH                         PIC 9(2).
   02 WS-DAY                           PIC 9(2).
 01 WS-DATE-NUM REDEFINES WS-DATE-NUM-R PIC 9(8).   

 01 WS-NUMBER-OF-DAYS                  PIC 9(18).  
 01 WS-NUMBER-OF-SECS                  PIC 9(18).  
 01 WS-REST-SECS-1                     PIC 9(18).  
 01 WS-REST-SECS-2                     PIC 9(18).  
 01 WS-GMT-DIFF-HOURS                  PIC 9(2).

 01 C-SEC-IN-DAY                       CONSTANT AS 86400.  
 01 C-SEC-IN-HOUR                      CONSTANT AS 3600.  
 01 C-SEC-IN-MINUTE                    CONSTANT AS 60.
 
 01 WS-STR-POINTER                     PIC 9(4).
 01 WS-MAX-AGE-SEC                     PIC X(10).
 01 WS-TALLY                           PIC 9(2). 

 LINKAGE SECTION. 
 01 LNK-COOKIE.
   02 LNK-INPUT.
     03 LNK-COOKIE-FUNC                PIC X(3).
       88 V-SET                        VALUE "SET".
       88 V-DEL                        VALUE "DEL".
     03 LNK-COOKIE-NAME                PIC X(100).
     03 LNK-COOKIE-VALUE               PIC X(256).
     03 LNK-MAX-AGE-SEC                PIC 9(10).
     03 LNK-DOMAIN-VALUE               PIC X(256).
     03 LNK-PATH-VALUE                 PIC X(256).
     03 LNK-SECURE-FLAG                PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
     03 LNK-HTTPONLY-FLAG              PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
     03 LNK-SAMESITE-FLAG              PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES-LAX                    VALUE 1.
       88 V-YES-STRICT                 VALUE 2.
   02 LNK-OUTPUT.
     03 LNK-COOKIE-STR                 PIC X(1024).

 PROCEDURE DIVISION USING LNK-COOKIE.
 
*>------------------------------------------------------------------------------
 COOKIE-MAIN SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT

    EVALUATE TRUE
        WHEN V-SET OF LNK-COOKIE-FUNC
           PERFORM SET-COOKIE    
        WHEN V-DEL OF LNK-COOKIE-FUNC
           PERFORM DEL-COOKIE    
    END-EVALUATE
    
    GOBACK
    .
    
*>------------------------------------------------------------------------------
 SET-COOKIE SECTION.
*>------------------------------------------------------------------------------

*>  init string pointer
    MOVE 1 TO WS-STR-POINTER

*>  Name and Value    
    STRING "Set-Cookie: "   DELIMITED BY SIZE
           LNK-COOKIE-NAME  DELIMITED BY SPACE
           "="              DELIMITED BY SIZE
           LNK-COOKIE-VALUE DELIMITED BY SPACE
      INTO LNK-COOKIE-STR
      WITH POINTER WS-STR-POINTER
    END-STRING      

*>  Expires and Max-Age    
    IF LNK-MAX-AGE-SEC > ZEROES
    THEN
       MOVE ZEROES TO WS-TALLY
       INSPECT LNK-MAX-AGE-SEC TALLYING WS-TALLY FOR LEADING ZEROS 
       ADD 1 TO WS-TALLY END-ADD
       MOVE LNK-MAX-AGE-SEC(WS-TALLY:) TO WS-MAX-AGE-SEC

       PERFORM COMPUTE-EXPIRES
       
       STRING "; Expires="         DELIMITED BY SIZE
              WS-EXPIRES-DATE-TIME DELIMITED BY SIZE
              "; Max-Age="         DELIMITED BY SIZE
              WS-MAX-AGE-SEC       DELIMITED BY SPACE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF

*>  Domain
    IF LNK-DOMAIN-VALUE NOT = SPACES
    THEN
       STRING "; Domain="          DELIMITED BY SIZE
              LNK-DOMAIN-VALUE     DELIMITED BY SPACE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF
    
*>  Path
    IF LNK-PATH-VALUE NOT = SPACES
    THEN
       STRING "; Path="            DELIMITED BY SIZE
              LNK-PATH-VALUE       DELIMITED BY SPACE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF

*>  Secure    
    IF V-YES OF LNK-SECURE-FLAG
    THEN
       STRING "; Secure"           DELIMITED BY SIZE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF    

*>  HttpOnly    
    IF V-YES OF LNK-HTTPONLY-FLAG
    THEN
       STRING "; HttpOnly"         DELIMITED BY SIZE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF    
    
*>  SameSite    
    IF V-YES-LAX    OF LNK-SAMESITE-FLAG 
    OR V-YES-STRICT OF LNK-SAMESITE-FLAG
    THEN
       IF V-YES-LAX    OF LNK-SAMESITE-FLAG 
          STRING "; SameSite=Lax"    DELIMITED BY SIZE
            INTO LNK-COOKIE-STR
            WITH POINTER WS-STR-POINTER
          END-STRING      
       ELSE   
          STRING "; SameSite=Strict" DELIMITED BY SIZE
            INTO LNK-COOKIE-STR
            WITH POINTER WS-STR-POINTER
          END-STRING      
       END-IF
    END-IF    
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 DEL-COOKIE SECTION.
*>------------------------------------------------------------------------------

*>  init string pointer
    MOVE 1 TO WS-STR-POINTER

*>  Name and empty Value with an old Expires
    STRING "Set-Cookie: "   DELIMITED BY SIZE
           LNK-COOKIE-NAME  DELIMITED BY SPACE
           "=; "            DELIMITED BY SIZE
           "Expires=Thu, 01 Jan 1970 00:00:01 GMT" DELIMITED BY SIZE
      INTO LNK-COOKIE-STR
      WITH POINTER WS-STR-POINTER
    END-STRING      

*>  Domain
    IF LNK-DOMAIN-VALUE NOT = SPACES
    THEN
       STRING "; Domain="          DELIMITED BY SIZE
              LNK-DOMAIN-VALUE     DELIMITED BY SPACE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF
    
*>  Path
    IF LNK-PATH-VALUE NOT = SPACES
    THEN
       STRING "; Path="            DELIMITED BY SIZE
              LNK-PATH-VALUE       DELIMITED BY SPACE
         INTO LNK-COOKIE-STR
         WITH POINTER WS-STR-POINTER
       END-STRING      
    END-IF
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 COMPUTE-EXPIRES SECTION.
*>------------------------------------------------------------------------------

*>  get current date and time
    MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME
    
    MOVE CDT-YEAR  OF CURRENT-DATE-AND-TIME TO WS-YEAR  OF WS-DATE-NUM-R
    MOVE CDT-MONTH OF CURRENT-DATE-AND-TIME TO WS-MONTH OF WS-DATE-NUM-R
    MOVE CDT-DAY   OF CURRENT-DATE-AND-TIME TO WS-DAY   OF WS-DATE-NUM-R

*>  convert current date in number of days
    MOVE FUNCTION INTEGER-OF-DATE(WS-DATE-NUM) TO WS-NUMBER-OF-DAYS
    
*>  current number of seconds 
    COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-DAYS * C-SEC-IN-DAY
                              + CDT-HOUR          * C-SEC-IN-HOUR
                              + CDT-MINUTES       * C-SEC-IN-MINUTE
                              + CDT-SECONDS
    END-COMPUTE                          

*>  current number of seconds in GMT (cookies use GMT)
    MOVE CDT-GMT-DIFF-HOURS TO WS-GMT-DIFF-HOURS
    
    IF CDT-GMT-DIFF-HOURS > ZEROES
    THEN
       COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-SECS 
               - (  WS-GMT-DIFF-HOURS    * C-SEC-IN-HOUR 
                  + CDT-GMT-DIFF-MINUTES * C-SEC-IN-MINUTE)
       END-COMPUTE
    ELSE
       COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-SECS 
               + (  WS-GMT-DIFF-HOURS    * C-SEC-IN-HOUR 
                  + CDT-GMT-DIFF-MINUTES * C-SEC-IN-MINUTE)
       END-COMPUTE
    END-IF

*>  add input max-age seconds
    ADD LNK-MAX-AGE-SEC OF LNK-COOKIE TO WS-NUMBER-OF-SECS END-ADD
    
*>  convert back in number of days    
    DIVIDE C-SEC-IN-DAY INTO WS-NUMBER-OF-SECS
       GIVING    WS-NUMBER-OF-DAYS
       REMAINDER WS-REST-SECS-1
    END-DIVIDE   

*>  convert back in datum    
    MOVE FUNCTION DATE-OF-INTEGER(WS-NUMBER-OF-DAYS) TO WS-DATE-NUM

*>  day of week    
    COMPUTE WS-DAY-OF-WEEK = FUNCTION MOD(WS-NUMBER-OF-DAYS, 7) + 1 END-COMPUTE
    MOVE WS-DAY OF WS-DAY-TAB(WS-DAY-OF-WEEK) 
      TO WS-DAY-NAME OF WS-EXPIRES-DATE-TIME

    MOVE WS-DAY   OF WS-DATE-NUM-R TO WS-DAY OF WS-EXPIRES-DATE-TIME

*>  name of month
    MOVE WS-MONTH OF WS-MONTH-TAB(WS-MONTH OF WS-DATE-NUM-R) 
      TO WS-MONTH OF WS-EXPIRES-DATE-TIME

    MOVE WS-YEAR  OF WS-DATE-NUM-R TO WS-YEAR OF WS-EXPIRES-DATE-TIME
    
*>  hour    
    DIVIDE C-SEC-IN-HOUR INTO WS-REST-SECS-1
       GIVING    WS-HOUR   OF WS-EXPIRES-DATE-TIME
       REMAINDER WS-REST-SECS-2
    END-DIVIDE   

*>  minute and second    
    DIVIDE C-SEC-IN-MINUTE INTO WS-REST-SECS-2
       GIVING    WS-MINUTE OF WS-EXPIRES-DATE-TIME
       REMAINDER WS-SECOND OF WS-EXPIRES-DATE-TIME
    END-DIVIDE   
 
    .
    EXIT SECTION .
    
 END PROGRAM COOKIE.
