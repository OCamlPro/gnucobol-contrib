*> Program HTM2COB-COOKIE template
 01 C-HTM2COB-COOKIE-MAX-LINE          CONSTANT AS 530.

 01 WS-HTM2COB-COOKIE.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SET-COOKIE.cob is free software: you can redistribute it and/or     ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SET-COOKIE.cob is distributed in the hope that it will be useful,   ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-SET-COOKIE.cob.                                          ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-SET-COOKIE.cob                                         ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      This module creates a cookie string                            ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019-05-01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               CALL ""HTM2COB-SET-COOKIE"" USING LNK-HTM2COB-SET-COOKIE       ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-SET-COOKIE.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> for the CURRENT-DATE function                                                ".
   02 FILLER PIC X(80) VALUE " 01 CURRENT-DATE-AND-TIME.                                                      ".
   02 FILLER PIC X(80) VALUE "   02 CDT-YEAR                         PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "   02 CDT-MONTH                        PIC 9(2). *> 01-12                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-DAY                          PIC 9(2). *> 01-31                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-HOUR                         PIC 9(2). *> 00-23                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-MINUTES                      PIC 9(2). *> 00-59                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-SECONDS                      PIC 9(2). *> 00-59                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99                       ".
   02 FILLER PIC X(80) VALUE "   02 CDT-GMT-DIFF-HOURS               PIC S9(2) SIGN LEADING SEPARATE.         ".
   02 FILLER PIC X(80) VALUE "   02 CDT-GMT-DIFF-MINUTES             PIC 9(2). *> 00 OR 30                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> Syntax: <day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT        ".
   02 FILLER PIC X(80) VALUE "*> Example: Tue, 12 Nov 2018 22:03:14 GMT                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-EXPIRES-DATE-TIME.                                                       ".
   02 FILLER PIC X(80) VALUE "   02 WS-DAY-NAME                      PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(2) VALUE "", "".                   ".
   02 FILLER PIC X(80) VALUE "   02 WS-DAY                           PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "" "".                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-MONTH                         PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "" "".                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-YEAR                          PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "" "".                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-HOUR                          PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "":"".                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-MINUTE                        PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "":"".                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-SECOND                        PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE "" GMT"".                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DAY-OF-WEEK                     PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE " 01 C-MAX-DAY-IND                      CONSTANT AS 7.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-DAY-TAB-R.                                                               ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Sun"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Mon"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Tue"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Wed"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Thu"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Fri"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Sat"".                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-DAY-TAB REDEFINES WS-DAY-TAB-R.                                          ".
   02 FILLER PIC X(80) VALUE "   02 WS-DAY-TAB-LINES OCCURS C-MAX-DAY-IND TIMES.                              ".
   02 FILLER PIC X(80) VALUE "     03 WS-DAY                         PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 C-MAX-MONTH-IND                    CONSTANT AS 12.                          ".
   02 FILLER PIC X(80) VALUE " 01 WS-MONTH-TAB-R.                                                             ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Jan"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Feb"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Mar"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Apr"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""May"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Jun"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Jul"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Aug"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Sep"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Oct"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Nov"".                  ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(3) VALUE ""Dec"".                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-MONTH-TAB REDEFINES WS-MONTH-TAB-R.                                      ".
   02 FILLER PIC X(80) VALUE "   02 WS-MONTH-TAB-LINES OCCURS C-MAX-MONTH-IND TIMES.                          ".
   02 FILLER PIC X(80) VALUE "     03 WS-MONTH                       PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DATE-NUM-R.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 WS-YEAR                          PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-MONTH                         PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-DAY                           PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DATE-NUM REDEFINES WS-DATE-NUM-R PIC 9(8).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUMBER-OF-DAYS                  PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUMBER-OF-SECS                  PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-REST-SECS-1                     PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-REST-SECS-2                     PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-GMT-DIFF-HOURS                  PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-DAY                       CONSTANT AS 86400.                       ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-HOUR                      CONSTANT AS 3600.                        ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-MINUTE                    CONSTANT AS 60.                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-STR-POINTER                     PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-MAX-AGE-SEC                     PIC X(10).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-TALLY                           PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-SET-COOKIE.                                                     ".
   02 FILLER PIC X(80) VALUE "   02 LNK-INPUT.                                                                ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-FUNC                PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "       88 V-SET                        VALUE ""SET"".                           ".
   02 FILLER PIC X(80) VALUE "       88 V-DEL                        VALUE ""DEL"".                           ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-NAME                PIC X(100).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-VALUE               PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-MAX-AGE-SEC                PIC 9(10).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-DOMAIN-VALUE               PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-PATH-VALUE                 PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SECURE-FLAG                PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "       88 V-NO                         VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES                        VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "     03 LNK-HTTPONLY-FLAG              PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "       88 V-NO                         VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES                        VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SAMESITE-FLAG              PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "       88 V-NO                         VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES-LAX                    VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES-STRICT                 VALUE 2.                                 ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OUTPUT.                                                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-STR                 PIC X(1024).                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-SET-COOKIE.                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SET-COOKIE-MAIN SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-OUTPUT                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "        WHEN V-SET OF LNK-COOKIE-FUNC                                           ".
   02 FILLER PIC X(80) VALUE "           PERFORM SET-COOKIE                                                   ".
   02 FILLER PIC X(80) VALUE "        WHEN V-DEL OF LNK-COOKIE-FUNC                                           ".
   02 FILLER PIC X(80) VALUE "           PERFORM DEL-COOKIE                                                   ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SET-COOKIE SECTION.                                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  init string pointer                                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-STR-POINTER                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Name and Value                                                              ".
   02 FILLER PIC X(80) VALUE "    STRING ""Set-Cookie: "" DELIMITED BY SIZE                                   ".
   02 FILLER PIC X(80) VALUE "           LNK-COOKIE-NAME  DELIMITED BY SPACE                                  ".
   02 FILLER PIC X(80) VALUE "           ""=""            DELIMITED BY SIZE                                   ".
   02 FILLER PIC X(80) VALUE "           LNK-COOKIE-VALUE DELIMITED BY SPACE                                  ".
   02 FILLER PIC X(80) VALUE "      INTO LNK-COOKIE-STR                                                       ".
   02 FILLER PIC X(80) VALUE "      WITH POINTER WS-STR-POINTER                                               ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Expires and Max-Age                                                         ".
   02 FILLER PIC X(80) VALUE "    IF LNK-MAX-AGE-SEC > ZEROES                                                 ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE ZEROES TO WS-TALLY                                                  ".
   02 FILLER PIC X(80) VALUE "       INSPECT LNK-MAX-AGE-SEC TALLYING WS-TALLY FOR LEADING ZEROS              ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO WS-TALLY END-ADD                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-MAX-AGE-SEC(WS-TALLY:) TO WS-MAX-AGE-SEC                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       PERFORM COMPUTE-EXPIRES                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Expires=""       DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              WS-EXPIRES-DATE-TIME DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              ""; Max-Age=""       DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              WS-MAX-AGE-SEC       DELIMITED BY SPACE                           ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Domain                                                                      ".
   02 FILLER PIC X(80) VALUE "    IF LNK-DOMAIN-VALUE NOT = SPACES                                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Domain=""        DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              LNK-DOMAIN-VALUE     DELIMITED BY SPACE                           ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Path                                                                        ".
   02 FILLER PIC X(80) VALUE "    IF LNK-PATH-VALUE NOT = SPACES                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Path=""          DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              LNK-PATH-VALUE       DELIMITED BY SPACE                           ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Secure                                                                      ".
   02 FILLER PIC X(80) VALUE "    IF V-YES OF LNK-SECURE-FLAG                                                 ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Secure""         DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  HttpOnly                                                                    ".
   02 FILLER PIC X(80) VALUE "    IF V-YES OF LNK-HTTPONLY-FLAG                                               ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; HttpOnly""       DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  SameSite                                                                    ".
   02 FILLER PIC X(80) VALUE "    IF V-YES-LAX    OF LNK-SAMESITE-FLAG                                        ".
   02 FILLER PIC X(80) VALUE "    OR V-YES-STRICT OF LNK-SAMESITE-FLAG                                        ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-YES-LAX    OF LNK-SAMESITE-FLAG                                     ".
   02 FILLER PIC X(80) VALUE "          STRING ""; SameSite=Lax"" DELIMITED BY SIZE                           ".
   02 FILLER PIC X(80) VALUE "            INTO LNK-COOKIE-STR                                                 ".
   02 FILLER PIC X(80) VALUE "            WITH POINTER WS-STR-POINTER                                         ".
   02 FILLER PIC X(80) VALUE "          END-STRING                                                            ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          STRING ""; SameSite=Strict"" DELIMITED BY SIZE                        ".
   02 FILLER PIC X(80) VALUE "            INTO LNK-COOKIE-STR                                                 ".
   02 FILLER PIC X(80) VALUE "            WITH POINTER WS-STR-POINTER                                         ".
   02 FILLER PIC X(80) VALUE "          END-STRING                                                            ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DEL-COOKIE SECTION.                                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  init string pointer                                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-STR-POINTER                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Name and empty Value with an old Expires                                    ".
   02 FILLER PIC X(80) VALUE "    STRING ""Set-Cookie: "" DELIMITED BY SIZE                                   ".
   02 FILLER PIC X(80) VALUE "           LNK-COOKIE-NAME  DELIMITED BY SPACE                                  ".
   02 FILLER PIC X(80) VALUE "           ""=; ""          DELIMITED BY SIZE                                   ".
   02 FILLER PIC X(80) VALUE "           ""Expires=Thu, 01 Jan 1970 00:00:01 GMT"" DELIMITED BY SIZE          ".
   02 FILLER PIC X(80) VALUE "      INTO LNK-COOKIE-STR                                                       ".
   02 FILLER PIC X(80) VALUE "      WITH POINTER WS-STR-POINTER                                               ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Domain                                                                      ".
   02 FILLER PIC X(80) VALUE "    IF LNK-DOMAIN-VALUE NOT = SPACES                                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Domain=""        DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              LNK-DOMAIN-VALUE     DELIMITED BY SPACE                           ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Path                                                                        ".
   02 FILLER PIC X(80) VALUE "    IF LNK-PATH-VALUE NOT = SPACES                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       STRING ""; Path=""          DELIMITED BY SIZE                            ".
   02 FILLER PIC X(80) VALUE "              LNK-PATH-VALUE       DELIMITED BY SPACE                           ".
   02 FILLER PIC X(80) VALUE "         INTO LNK-COOKIE-STR                                                    ".
   02 FILLER PIC X(80) VALUE "         WITH POINTER WS-STR-POINTER                                            ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " COMPUTE-EXPIRES SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  get current date and time                                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-YEAR  OF CURRENT-DATE-AND-TIME TO WS-YEAR  OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-MONTH OF CURRENT-DATE-AND-TIME TO WS-MONTH OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-DAY   OF CURRENT-DATE-AND-TIME TO WS-DAY   OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert current date in number of days                                      ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION INTEGER-OF-DATE(WS-DATE-NUM) TO WS-NUMBER-OF-DAYS             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current number of seconds                                                   ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-DAYS * C-SEC-IN-DAY                ".
   02 FILLER PIC X(80) VALUE "                              + CDT-HOUR          * C-SEC-IN-HOUR               ".
   02 FILLER PIC X(80) VALUE "                              + CDT-MINUTES       * C-SEC-IN-MINUTE             ".
   02 FILLER PIC X(80) VALUE "                              + CDT-SECONDS                                     ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current number of seconds in GMT (cookies use GMT)                          ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-GMT-DIFF-HOURS TO WS-GMT-DIFF-HOURS                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF CDT-GMT-DIFF-HOURS > ZEROES                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-SECS                            ".
   02 FILLER PIC X(80) VALUE "               - (  WS-GMT-DIFF-HOURS    * C-SEC-IN-HOUR                        ".
   02 FILLER PIC X(80) VALUE "                  + CDT-GMT-DIFF-MINUTES * C-SEC-IN-MINUTE)                     ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-NUMBER-OF-SECS = WS-NUMBER-OF-SECS                            ".
   02 FILLER PIC X(80) VALUE "               + (  WS-GMT-DIFF-HOURS    * C-SEC-IN-HOUR                        ".
   02 FILLER PIC X(80) VALUE "                  + CDT-GMT-DIFF-MINUTES * C-SEC-IN-MINUTE)                     ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  add input max-age seconds                                                   ".
   02 FILLER PIC X(80) VALUE "    ADD LNK-MAX-AGE-SEC OF LNK-HTM2COB-SET-COOKIE TO WS-NUMBER-OF-SECS END-ADD  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert back in number of days                                              ".
   02 FILLER PIC X(80) VALUE "    DIVIDE C-SEC-IN-DAY INTO WS-NUMBER-OF-SECS                                  ".
   02 FILLER PIC X(80) VALUE "       GIVING    WS-NUMBER-OF-DAYS                                              ".
   02 FILLER PIC X(80) VALUE "       REMAINDER WS-REST-SECS-1                                                 ".
   02 FILLER PIC X(80) VALUE "    END-DIVIDE                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert back in datum                                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION DATE-OF-INTEGER(WS-NUMBER-OF-DAYS) TO WS-DATE-NUM             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  day of week                                                                 ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-DAY-OF-WEEK = FUNCTION MOD(WS-NUMBER-OF-DAYS, 7) + 1 END-COMPUTE ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-DAY OF WS-DAY-TAB(WS-DAY-OF-WEEK)                                   ".
   02 FILLER PIC X(80) VALUE "      TO WS-DAY-NAME OF WS-EXPIRES-DATE-TIME                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-DAY   OF WS-DATE-NUM-R TO WS-DAY OF WS-EXPIRES-DATE-TIME            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  name of month                                                               ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-MONTH OF WS-MONTH-TAB(WS-MONTH OF WS-DATE-NUM-R)                    ".
   02 FILLER PIC X(80) VALUE "      TO WS-MONTH OF WS-EXPIRES-DATE-TIME                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-YEAR  OF WS-DATE-NUM-R TO WS-YEAR OF WS-EXPIRES-DATE-TIME           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  hour                                                                        ".
   02 FILLER PIC X(80) VALUE "    DIVIDE C-SEC-IN-HOUR INTO WS-REST-SECS-1                                    ".
   02 FILLER PIC X(80) VALUE "       GIVING    WS-HOUR   OF WS-EXPIRES-DATE-TIME                              ".
   02 FILLER PIC X(80) VALUE "       REMAINDER WS-REST-SECS-2                                                 ".
   02 FILLER PIC X(80) VALUE "    END-DIVIDE                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  minute and second                                                           ".
   02 FILLER PIC X(80) VALUE "    DIVIDE C-SEC-IN-MINUTE INTO WS-REST-SECS-2                                  ".
   02 FILLER PIC X(80) VALUE "       GIVING    WS-MINUTE OF WS-EXPIRES-DATE-TIME                              ".
   02 FILLER PIC X(80) VALUE "       REMAINDER WS-SECOND OF WS-EXPIRES-DATE-TIME                              ".
   02 FILLER PIC X(80) VALUE "    END-DIVIDE                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-SET-COOKIE.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-GET-COOKIE.cob is free software: you can redistribute it and/or     ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-GET-COOKIE.cob is distributed in the hope that it will be useful,   ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-GET-COOKIE.cob.                                          ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-GET-COOKIE.cob                                         ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Get saved cookie value from HTM2COB-HTTP-COOKIE field          ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               CALL ""HTM2COB-GET-COOKIE"" USING LNK-HTM2COB-GET-COOKIE       ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-GET-COOKIE.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           PIC 9(9).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-COOKIE-NAME                     PIC X(101).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-GET-COOKIE.                                                     ".
   02 FILLER PIC X(80) VALUE "   02 LNK-INPUT.                                                                ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-NAME                PIC X(100).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OUTPUT.                                                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-COOKIE-VALUE               PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-GET-COOKIE.                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-GET-COOKIE SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-COOKIE-VALUE                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  append =                                                                    ".
   02 FILLER PIC X(80) VALUE "    MOVE SPACES TO WS-COOKIE-NAME                                               ".
   02 FILLER PIC X(80) VALUE "    STRING FUNCTION TRIM(LNK-COOKIE-NAME) DELIMITED BY SIZE                     ".
   02 FILLER PIC X(80) VALUE "           ""="" DELIMITED BY SIZE                                              ".
   02 FILLER PIC X(80) VALUE "      INTO WS-COOKIE-NAME                                                       ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO WS-IND-1                                                     ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-HTTP-COOKIE TALLYING WS-IND-1                               ".
   02 FILLER PIC X(80) VALUE "            FOR CHARACTERS BEFORE FUNCTION TRIM(WS-COOKIE-NAME)                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF WS-IND-1 < FUNCTION LENGTH(HTM2COB-HTTP-COOKIE)                          ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "*>     cookie-name found                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-IND-1 = WS-IND-1                                              ".
   02 FILLER PIC X(80) VALUE "             + FUNCTION STORED-CHAR-LENGTH(WS-COOKIE-NAME) + 1                  ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     unstring cookie-value                                                    ".
   02 FILLER PIC X(80) VALUE "       UNSTRING HTM2COB-HTTP-COOKIE                                             ".
   02 FILLER PIC X(80) VALUE "                DELIMITED BY ALL "";""                                          ".
   02 FILLER PIC X(80) VALUE "                INTO LNK-COOKIE-VALUE                                           ".
   02 FILLER PIC X(80) VALUE "                WITH POINTER WS-IND-1                                           ".
   02 FILLER PIC X(80) VALUE "       END-UNSTRING                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-GET-COOKIE.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-UPD-SESS-STR.cob is free software: you can redistribute it and/or   ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-UPD-SESS-STR.cob is distributed in the hope that it will be useful, ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-UPD-SESS-STR.cob.                                        ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-UPD-SESS-STR.cob                                       ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Update SESSIONID in HTM2COB-HTTP-COOKIE field                  ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               CALL ""HTM2COB-UPD-SESS-STR"" USING LNK-HTM2COB-UPD-SESS-STR   ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-UPD-SESS-STR.                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           PIC 9(9).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-UPD-SESS-STR.                                                   ".
   02 FILLER PIC X(80) VALUE "   02 LNK-INPUT.                                                                ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-ID-HEX             PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OUTPUT.                                                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-RESULT                     PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "        88 V-OK                        VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-NOT-OK                    VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-UPD-SESS-STR.                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-UPD-SESS-STR SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-OUTPUT                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO WS-IND-1                                                     ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-HTTP-COOKIE TALLYING WS-IND-1                               ".
   02 FILLER PIC X(80) VALUE "            FOR CHARACTERS BEFORE ""SESSIONID=""                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF WS-IND-1 < FUNCTION LENGTH(HTM2COB-HTTP-COOKIE)                          ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "*>     SESSIONID found                                                          ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-IND-1 = WS-IND-1 + 11 END-COMPUTE                             ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-SESSION-ID-HEX OF LNK-INPUT                                     ".
   02 FILLER PIC X(80) VALUE "         TO HTM2COB-HTTP-COOKIE(WS-IND-1:128)                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-UPD-SESS-STR.                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   
 01 WS-HTM2COB-COOKIE-R REDEFINES WS-HTM2COB-COOKIE.
   02 WS-HTM2COB-COOKIE-LINES OCCURS C-HTM2COB-COOKIE-MAX-LINE TIMES.
     03 WS-HTM2COB-COOKIE-LINE                PIC X(80).
