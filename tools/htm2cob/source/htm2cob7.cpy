*> Program HTM2COB-SESSION template
 01 C-HTM2COB-SESSION-MAX-LINE         CONSTANT AS 930.

 01 WS-HTM2COB-SESSION.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SESSION.cob is free software: you can redistribute it and/or        ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SESSION.cob is distributed in the hope that it will be useful,      ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-SESSION.cob.                                             ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-SESSION.cob                                            ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      This module writes or deletes the session data in a file.      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Tectonics:    cobc -m -free HTM2COB-SESSION.cob                              ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        Call this module in your web application. It writes or deletes ".
   02 FILLER PIC X(80) VALUE "*>               the session data in a file.                                    ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-SESSION.                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " INPUT-OUTPUT SECTION.                                                          ".
   02 FILLER PIC X(80) VALUE " FILE-CONTROL.                                                                  ".
   02 FILLER PIC X(80) VALUE "    SELECT OPTIONAL SESSION-FILE ASSIGN TO WS-SESSION-FILE                      ".
   02 FILLER PIC X(80) VALUE "        SHARING WITH ALL OTHER                                                  ".
   02 FILLER PIC X(80) VALUE "        LOCK MODE            IS MANUAL                                          ".
   02 FILLER PIC X(80) VALUE "        ORGANIZATION         IS INDEXED                                         ".
   02 FILLER PIC X(80) VALUE "        ACCESS MODE          IS DYNAMIC                                         ".
   02 FILLER PIC X(80) VALUE "        RECORD KEY           IS SESSION-KEY                                     ".
   02 FILLER PIC X(80) VALUE "        ALTERNATE RECORD KEY IS FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD       ".
   02 FILLER PIC X(80) VALUE "                                                           WITH DUPLICATES      ".
   02 FILLER PIC X(80) VALUE "        ALTERNATE RECORD KEY IS LAST-REQ-TIMESTAMP-SEC  OF SESSION-RECORD       ".
   02 FILLER PIC X(80) VALUE "                                                           WITH DUPLICATES      ".
   02 FILLER PIC X(80) VALUE "        FILE STATUS          IS WS-SESSION-FILE-STATUS.                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SELECT OPTIONAL SESSION-VAR-FILE ASSIGN TO WS-SESSION-VAR-FILE              ".
   02 FILLER PIC X(80) VALUE "        SHARING WITH ALL OTHER                                                  ".
   02 FILLER PIC X(80) VALUE "        LOCK MODE            IS MANUAL                                          ".
   02 FILLER PIC X(80) VALUE "        ORGANIZATION         IS INDEXED                                         ".
   02 FILLER PIC X(80) VALUE "        ACCESS MODE          IS DYNAMIC                                         ".
   02 FILLER PIC X(80) VALUE "        RECORD KEY           IS SESSION-VAR-KEY OF SESSION-VAR-RECORD           ".
   02 FILLER PIC X(80) VALUE "        ALTERNATE RECORD KEY IS FIRST-REQ-TIMESTAMP-SEC OF SESSION-VAR-RECORD   ".
   02 FILLER PIC X(80) VALUE "                                                           WITH DUPLICATES      ".
   02 FILLER PIC X(80) VALUE "        FILE STATUS          IS WS-SESSION-VAR-FILE-STATUS.                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SELECT OPTIONAL SESSION-VAR-FILE-2 ASSIGN TO WS-SESSION-VAR-FILE-2          ".
   02 FILLER PIC X(80) VALUE "        SHARING WITH ALL OTHER                                                  ".
   02 FILLER PIC X(80) VALUE "        LOCK MODE            IS MANUAL                                          ".
   02 FILLER PIC X(80) VALUE "        ORGANIZATION         IS INDEXED                                         ".
   02 FILLER PIC X(80) VALUE "        ACCESS MODE          IS DYNAMIC                                         ".
   02 FILLER PIC X(80) VALUE "        RECORD KEY           IS SESSION-VAR-KEY OF SESSION-VAR-RECORD-2         ".
   02 FILLER PIC X(80) VALUE "        ALTERNATE RECORD KEY IS FIRST-REQ-TIMESTAMP-SEC OF SESSION-VAR-RECORD-2 ".
   02 FILLER PIC X(80) VALUE "                                                           WITH DUPLICATES      ".
   02 FILLER PIC X(80) VALUE "        FILE STATUS          IS WS-SESSION-VAR-FILE-2-STATUS.                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " FILE SECTION.                                                                  ".
   02 FILLER PIC X(80) VALUE " FD SESSION-FILE.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 SESSION-RECORD.                                                             ".
   02 FILLER PIC X(80) VALUE "   02 SESSION-KEY.                                                              ".
   02 FILLER PIC X(80) VALUE "     03 SESSION-ID-HEX                 PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "   02 USER-AGENT-HASH-HEX              PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "   02 REMOTE-ADDR                      PIC X(100).                              ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP              PIC X(19).                               ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP-SEC          PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "   02 LAST-REQ-TIMESTAMP               PIC X(19).                               ".
   02 FILLER PIC X(80) VALUE "   02 LAST-REQ-TIMESTAMP-SEC           PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " FD SESSION-VAR-FILE.                                                           ".
   02 FILLER PIC X(80) VALUE " 01 SESSION-VAR-RECORD.                                                         ".
   02 FILLER PIC X(80) VALUE "   02 SESSION-VAR-KEY.                                                          ".
   02 FILLER PIC X(80) VALUE "     03 SESSION-ID-HEX                 PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 SESSION-VAR-NAME               PIC X(40).                               ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP              PIC X(19).                               ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP-SEC          PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "   02 SESSION-VAR-VALUE                PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " FD SESSION-VAR-FILE-2.                                                         ".
   02 FILLER PIC X(80) VALUE " 01 SESSION-VAR-RECORD-2.                                                       ".
   02 FILLER PIC X(80) VALUE "   02 SESSION-VAR-KEY.                                                          ".
   02 FILLER PIC X(80) VALUE "     03 SESSION-ID-HEX                 PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 SESSION-VAR-NAME               PIC X(40).                               ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP              PIC X(19).                               ".
   02 FILLER PIC X(80) VALUE "   02 FIRST-REQ-TIMESTAMP-SEC          PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "   02 SESSION-VAR-VALUE                PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*> file-status                                                                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-FILE-STATUS.                                                             ".
   02 FILLER PIC X(80) VALUE "   02 WS-SESSION-FILE-STATUS           PIC 9(02).                               ".
   02 FILLER PIC X(80) VALUE "*>    88 V-SUCCESS                     VALUE 00.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-SUCCESS                     VALUE 00, 02, 04, 05, 07.                ".
   02 FILLER PIC X(80) VALUE "      88 V-END-OF-FILE                 VALUE 10.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-KEY-NOT-EXISTS              VALUE 23.                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-SESSION-VAR-FILE-STATUS       PIC 9(02).                               ".
   02 FILLER PIC X(80) VALUE "*>    88 V-SUCCESS                     VALUE 00.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-SUCCESS                     VALUE 00, 02, 04, 05, 07.                ".
   02 FILLER PIC X(80) VALUE "      88 V-END-OF-FILE                 VALUE 10.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-KEY-NOT-EXISTS              VALUE 23.                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-SESSION-VAR-FILE-2-STATUS     PIC 9(02).                               ".
   02 FILLER PIC X(80) VALUE "*>    88 V-SUCCESS                     VALUE 00.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-SUCCESS                     VALUE 00, 02, 04, 05, 07.                ".
   02 FILLER PIC X(80) VALUE "      88 V-END-OF-FILE                 VALUE 10.                                ".
   02 FILLER PIC X(80) VALUE "      88 V-KEY-NOT-EXISTS              VALUE 23.                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> file-status message                                                          ".
   02 FILLER PIC X(80) VALUE " 01 WS-FS-MESSAGE.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(13) VALUE ""Status Code: "".       ".
   02 FILLER PIC X(80) VALUE "   02 WS-FS-CODE                       PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(11) VALUE "", Meaning: "".         ".
   02 FILLER PIC X(80) VALUE "   02 WS-FS-MSG-TXT                    PIC X(25).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> File path for the session file.                                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-SESSION-FILE                    PIC X(1024).                             ".
   02 FILLER PIC X(80) VALUE "*> File path for the session variable file.                                     ".
   02 FILLER PIC X(80) VALUE " 01 WS-SESSION-VAR-FILE                PIC X(1024).                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-SESSION-VAR-FILE-2              PIC X(1024).                             ".
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
   02 FILLER PIC X(80) VALUE "*> time fields                                                                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-CURR-DATE-TIME.                                                          ".
   02 FILLER PIC X(80) VALUE "   02 CDT-YEAR                         PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE ""-"".                    ".
   02 FILLER PIC X(80) VALUE "   02 CDT-MONTH                        PIC 9(2). *> 01-12                       ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE ""-"".                    ".
   02 FILLER PIC X(80) VALUE "   02 CDT-DAY                          PIC 9(2). *> 01-31                       ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "":"".                    ".
   02 FILLER PIC X(80) VALUE "   02 CDT-HOUR                         PIC 9(2). *> 00-23                       ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "":"".                    ".
   02 FILLER PIC X(80) VALUE "   02 CDT-MINUTES                      PIC 9(2). *> 00-59                       ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(1) VALUE "":"".                    ".
   02 FILLER PIC X(80) VALUE "   02 CDT-SECONDS                      PIC 9(2). *> 00-59                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DATE-NUM-R.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 WS-YEAR                          PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-MONTH                         PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-DAY                           PIC 9(2).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DATE-NUM REDEFINES WS-DATE-NUM-R PIC 9(8).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-CURR-NUMBER-OF-DAYS             PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-CURR-NUMBER-OF-SECS             PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-FIRST-REQ-TIMESTAMP-SEC         PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-LAST-REQ-TIMESTAMP-SEC          PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-DAY                       CONSTANT AS 86400.                       ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-HOUR                      CONSTANT AS 3600.                        ".
   02 FILLER PIC X(80) VALUE " 01 C-SEC-IN-MINUTE                    CONSTANT AS 60.                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 78 HTM2COB-LF                         VALUE X""0A"".                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-2                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-SESSION.                                                        ".
   02 FILLER PIC X(80) VALUE "   02 LNK-INPUT.                                                                ".
   02 FILLER PIC X(80) VALUE "     03 LNK-FUNCTION                   PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "        88 V-START-SESSION             VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-DEL-OLD-SESSION           VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-DESTROY-SESSION           VALUE 2.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-REGENERATE-SESSION        VALUE 3.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-SET-SESSION-VAR           VALUE 4.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-GET-SESSION-VAR           VALUE 5.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-DEL-SESSION-VAR           VALUE 6.                                 ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-ID-HEX             PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-ID-HEX-OLD         PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-USER-AGENT-HASH-HEX        PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-REMOTE-ADDR                PIC X(100).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-FIRST-REQ-DIFF-SEC         PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-LAST-REQ-DIFF-SEC          PIC 9(18).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-VAR-NAME           PIC X(40).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-VAR-INP-VALUE      PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OUTPUT.                                                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-RESULT                     PIC 9(1).                                ".
   02 FILLER PIC X(80) VALUE "        88 V-OK                        VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "        88 V-NOT-OK                    VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-VAR-OUT-VALUE      PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-SESSION.                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DECLARATIVES.                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SESSION-FILE-ERROR SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    USE AFTER STANDARD ERROR PROCEDURE ON SESSION-FILE.                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  NOT V-END-OF-FILE    OF WS-SESSION-FILE-STATUS                          ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-KEY-NOT-EXISTS OF WS-SESSION-FILE-STATUS                          ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-SESSION-FILE-STATUS                                              ".
   02 FILLER PIC X(80) VALUE "         TO WS-FS-CODE OF WS-FS-MESSAGE                                         ".
   02 FILLER PIC X(80) VALUE "       PERFORM EVAL-FILE-STATUS                                                 ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>"" ""SESSION-FILE-ERROR: "" WS-FS-MESSAGE ""<BR>""      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SESSION-VAR-FILE-ERROR SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    USE AFTER STANDARD ERROR PROCEDURE ON SESSION-VAR-FILE.                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  NOT V-END-OF-FILE    OF WS-SESSION-VAR-FILE-STATUS                      ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-KEY-NOT-EXISTS OF WS-SESSION-VAR-FILE-STATUS                      ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-SESSION-VAR-FILE-STATUS                                          ".
   02 FILLER PIC X(80) VALUE "         TO WS-FS-CODE OF WS-FS-MESSAGE                                         ".
   02 FILLER PIC X(80) VALUE "       PERFORM EVAL-FILE-STATUS                                                 ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>"" ""SESSION-VAR-FILE-ERROR: "" WS-FS-MESSAGE ""<BR>""  ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SESSION-VAR-FILE-2-ERROR SECTION.                                              ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    USE AFTER STANDARD ERROR PROCEDURE ON SESSION-VAR-FILE-2.                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  NOT V-END-OF-FILE    OF WS-SESSION-VAR-FILE-2-STATUS                    ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-KEY-NOT-EXISTS OF WS-SESSION-VAR-FILE-2-STATUS                    ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-SESSION-VAR-FILE-2-STATUS                                        ".
   02 FILLER PIC X(80) VALUE "         TO WS-FS-CODE OF WS-FS-MESSAGE                                         ".
   02 FILLER PIC X(80) VALUE "       PERFORM EVAL-FILE-STATUS                                                 ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>"" ""SESSION-VAR-FILE-2-ERROR: "" WS-FS-MESSAGE ""<BR>""".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " EVAL-FILE-STATUS SECTION.                                                      ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE WS-FS-CODE OF WS-FS-MESSAGE                                        ".
   02 FILLER PIC X(80) VALUE "       WHEN 00 MOVE ""SUCCESS ""               TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 02 MOVE ""SUCCESS DUPLICATE ""     TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 04 MOVE ""SUCCESS INCOMPLETE ""    TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 05 MOVE ""SUCCESS OPTIONAL ""      TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 07 MOVE ""SUCCESS NO UNIT ""       TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 10 MOVE ""END OF FILE ""           TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 14 MOVE ""OUT OF KEY RANGE ""      TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 21 MOVE ""KEY INVALID ""           TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 22 MOVE ""KEY EXISTS ""            TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 23 MOVE ""KEY NOT EXISTS ""        TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 30 MOVE ""PERMANENT ERROR ""       TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 31 MOVE ""INCONSISTENT FILENAME "" TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 34 MOVE ""BOUNDARY VIOLATION ""    TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 35 MOVE ""FILE NOT FOUND ""        TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 37 MOVE ""PERMISSION DENIED ""     TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 38 MOVE ""CLOSED WITH LOCK ""      TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 39 MOVE ""CONFLICT ATTRIBUTE ""    TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 41 MOVE ""ALREADY OPEN ""          TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 42 MOVE ""NOT OPEN ""              TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 43 MOVE ""READ NOT DONE ""         TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 44 MOVE ""RECORD OVERFLOW ""       TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 46 MOVE ""READ ERROR ""            TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 47 MOVE ""INPUT DENIED ""          TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 48 MOVE ""OUTPUT DENIED ""         TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 49 MOVE ""I/O DENIED ""            TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 51 MOVE ""RECORD LOCKED ""         TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 52 MOVE ""END-OF-PAGE ""           TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 57 MOVE ""I/O LINAGE ""            TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 61 MOVE ""FILE SHARING FAILURE ""  TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "       WHEN 91 MOVE ""FILE NOT AVAILABLE ""    TO WS-FS-MSG-TXT                 ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-DISP-CONTENT-TYPE SECTION.                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-DISP-CONT-TYPE-NO OF HTM2COB-DISP-CONT-TYPE-FLAG               ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       DISPLAY ""Content-Type: text/html; charset=utf-8""                       ".
   02 FILLER PIC X(80) VALUE "               WITH NO ADVANCING HTM2COB-LF                                     ".
   02 FILLER PIC X(80) VALUE "       END-DISPLAY                                                              ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-DISP-CONT-TYPE-YES OF HTM2COB-DISP-CONT-TYPE-FLAG TO TRUE  ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END DECLARATIVES.                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESSION-MAIN SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-OUTPUT OF LNK-HTM2COB-SESSION                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-FILE-STATUS                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESSION-FILE     TO WS-SESSION-FILE                            ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESSION-VAR-FILE TO WS-SESSION-VAR-FILE                        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESSION-VAR-FILE TO WS-SESSION-VAR-FILE-2                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  functions                                                                   ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "    WHEN V-START-SESSION      OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM START-SESSION                                                    ".
   02 FILLER PIC X(80) VALUE "    WHEN V-DEL-OLD-SESSION    OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM DEL-OLD-SESSION                                                  ".
   02 FILLER PIC X(80) VALUE "    WHEN V-DESTROY-SESSION    OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM DESTROY-SESSION                                                  ".
   02 FILLER PIC X(80) VALUE "    WHEN V-REGENERATE-SESSION OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM REGENERATE-SESSION                                               ".
   02 FILLER PIC X(80) VALUE "    WHEN V-SET-SESSION-VAR    OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM SET-SESSION-VAR                                                  ".
   02 FILLER PIC X(80) VALUE "    WHEN V-GET-SESSION-VAR    OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM GET-SESSION-VAR                                                  ".
   02 FILLER PIC X(80) VALUE "    WHEN V-DEL-SESSION-VAR    OF LNK-FUNCTION OF LNK-INPUT                      ".
   02 FILLER PIC X(80) VALUE "       PERFORM DEL-SESSION-VAR                                                  ".
   02 FILLER PIC X(80) VALUE "    WHEN OTHER                                                                  ".
   02 FILLER PIC X(80) VALUE "*>     invalid function                                                         ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT OF LNK-OUTPUT TO TRUE                         ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " START-SESSION SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current time in number of seconds                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM GET-CURR-TIME                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX TO SESSION-ID-HEX OF SESSION-RECORD                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-FILE WITH WAIT END-READ                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "        WHEN V-SUCCESS        OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "*>         check USER-AGENT-HASH and REMOTE-ADDR                                ".
   02 FILLER PIC X(80) VALUE "           IF  LNK-USER-AGENT-HASH-HEX = USER-AGENT-HASH-HEX OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           AND LNK-REMOTE-ADDR         = REMOTE-ADDR         OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           THEN                                                                 ".
   02 FILLER PIC X(80) VALUE "*>            rewrite last request timestamp                                    ".
   02 FILLER PIC X(80) VALUE "              MOVE WS-CURR-DATE-TIME                                            ".
   02 FILLER PIC X(80) VALUE "                TO LAST-REQ-TIMESTAMP     OF SESSION-RECORD                     ".
   02 FILLER PIC X(80) VALUE "              MOVE WS-CURR-NUMBER-OF-SECS                                       ".
   02 FILLER PIC X(80) VALUE "                TO LAST-REQ-TIMESTAMP-SEC OF SESSION-RECORD                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "              REWRITE SESSION-RECORD END-REWRITE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "              IF V-SUCCESS OF WS-SESSION-FILE-STATUS                            ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-OK     OF LNK-RESULT TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-NOT-OK OF LNK-RESULT TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "           ELSE                                                                 ".
   02 FILLER PIC X(80) VALUE "              SET V-NOT-OK OF LNK-RESULT TO TRUE                                ".
   02 FILLER PIC X(80) VALUE "           END-IF                                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN V-KEY-NOT-EXISTS OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "*>         write, if not found                                                  ".
   02 FILLER PIC X(80) VALUE "           MOVE LNK-USER-AGENT-HASH-HEX                                         ".
   02 FILLER PIC X(80) VALUE "             TO USER-AGENT-HASH-HEX     OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "           MOVE LNK-REMOTE-ADDR                                                 ".
   02 FILLER PIC X(80) VALUE "             TO REMOTE-ADDR             OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "           MOVE WS-CURR-DATE-TIME                                               ".
   02 FILLER PIC X(80) VALUE "             TO FIRST-REQ-TIMESTAMP     OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "           MOVE WS-CURR-NUMBER-OF-SECS                                          ".
   02 FILLER PIC X(80) VALUE "             TO FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "           MOVE WS-CURR-DATE-TIME                                               ".
   02 FILLER PIC X(80) VALUE "             TO LAST-REQ-TIMESTAMP      OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "           MOVE WS-CURR-NUMBER-OF-SECS                                          ".
   02 FILLER PIC X(80) VALUE "             TO LAST-REQ-TIMESTAMP-SEC  OF SESSION-RECORD                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "           WRITE SESSION-RECORD END-WRITE                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "           IF V-SUCCESS OF WS-SESSION-FILE-STATUS                               ".
   02 FILLER PIC X(80) VALUE "           THEN                                                                 ".
   02 FILLER PIC X(80) VALUE "              SET V-OK     OF LNK-RESULT TO TRUE                                ".
   02 FILLER PIC X(80) VALUE "           ELSE                                                                 ".
   02 FILLER PIC X(80) VALUE "              SET V-NOT-OK OF LNK-RESULT TO TRUE                                ".
   02 FILLER PIC X(80) VALUE "           END-IF                                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN OTHER                                                              ".
   02 FILLER PIC X(80) VALUE "           SET V-NOT-OK OF LNK-RESULT TO TRUE                                   ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DEL-OLD-SESSION SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current time in number of seconds                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM GET-CURR-TIME                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete according to last request timestamp                                  ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-LAST-REQ-TIMESTAMP-SEC =                                         ".
   02 FILLER PIC X(80) VALUE "            WS-CURR-NUMBER-OF-SECS - LNK-LAST-REQ-DIFF-SEC                      ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-LAST-REQ-TIMESTAMP-SEC TO LAST-REQ-TIMESTAMP-SEC OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "    START SESSION-FILE KEY IS <= LAST-REQ-TIMESTAMP-SEC OF SESSION-RECORD       ".
   02 FILLER PIC X(80) VALUE "    END-START                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL NOT V-SUCCESS OF WS-SESSION-FILE-STATUS                       ".
   02 FILLER PIC X(80) VALUE "       READ SESSION-FILE PREVIOUS WITH WAIT END-READ                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-FILE-STATUS                                   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF LAST-REQ-TIMESTAMP-SEC OF SESSION-RECORD >                         ".
   02 FILLER PIC X(80) VALUE "                                               WS-LAST-REQ-TIMESTAMP-SEC        ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             CONTINUE                                                           ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "*>           first delete all session vars for this session-key                 ".
   02 FILLER PIC X(80) VALUE "             PERFORM DEL-SESSION-VAR-ALL                                        ".
   02 FILLER PIC X(80) VALUE "*>           delete session                                                     ".
   02 FILLER PIC X(80) VALUE "             DELETE SESSION-FILE END-DELETE                                     ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete according to first request timestamp                                 ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-FIRST-REQ-TIMESTAMP-SEC =                                        ".
   02 FILLER PIC X(80) VALUE "            WS-CURR-NUMBER-OF-SECS - LNK-FIRST-REQ-DIFF-SEC                     ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-FIRST-REQ-TIMESTAMP-SEC TO FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD".
   02 FILLER PIC X(80) VALUE "    START SESSION-FILE KEY IS <= FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD      ".
   02 FILLER PIC X(80) VALUE "    END-START                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL NOT V-SUCCESS OF WS-SESSION-FILE-STATUS                       ".
   02 FILLER PIC X(80) VALUE "       READ SESSION-FILE PREVIOUS WITH WAIT END-READ                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-FILE-STATUS                                   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD >                        ".
   02 FILLER PIC X(80) VALUE "                                                WS-FIRST-REQ-TIMESTAMP-SEC      ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             CONTINUE                                                           ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "*>           first delete all session vars for this session-key                 ".
   02 FILLER PIC X(80) VALUE "             PERFORM DEL-SESSION-VAR-ALL                                        ".
   02 FILLER PIC X(80) VALUE "*>           delete session                                                     ".
   02 FILLER PIC X(80) VALUE "             DELETE SESSION-FILE END-DELETE                                     ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete orphan session vars with FIRST-REQ-TIMESTAMP-SEC                     ".
   02 FILLER PIC X(80) VALUE "    PERFORM DEL-SESSION-VAR-ORPHAN                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DEL-SESSION-VAR-ALL SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE SESSION-ID-HEX OF SESSION-RECORD                                       ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-ID-HEX OF SESSION-VAR-RECORD                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    START SESSION-VAR-FILE KEY IS >= SESSION-VAR-KEY OF SESSION-VAR-RECORD      ".
   02 FILLER PIC X(80) VALUE "    END-START                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete all session vars for a session-key                                   ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL NOT V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                   ".
   02 FILLER PIC X(80) VALUE "       READ SESSION-VAR-FILE NEXT WITH WAIT END-READ                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF SESSION-ID-HEX OF SESSION-RECORD NOT = SESSION-ID-HEX              ".
   02 FILLER PIC X(80) VALUE "                                                    OF SESSION-VAR-RECORD       ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             EXIT PERFORM                                                       ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "             DELETE SESSION-VAR-FILE END-DELETE                                 ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DEL-SESSION-VAR-ORPHAN SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete orphan session vars with FIRST-REQ-TIMESTAMP-SEC                     ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-FIRST-REQ-TIMESTAMP-SEC =                                        ".
   02 FILLER PIC X(80) VALUE "            WS-CURR-NUMBER-OF-SECS - LNK-FIRST-REQ-DIFF-SEC                     ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-FIRST-REQ-TIMESTAMP-SEC TO FIRST-REQ-TIMESTAMP-SEC                  ".
   02 FILLER PIC X(80) VALUE "                                                        OF SESSION-VAR-RECORD   ".
   02 FILLER PIC X(80) VALUE "    START SESSION-VAR-FILE KEY IS <= FIRST-REQ-TIMESTAMP-SEC                    ".
   02 FILLER PIC X(80) VALUE "                                                        OF SESSION-VAR-RECORD   ".
   02 FILLER PIC X(80) VALUE "    END-START                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  delete orphan session vars                                                  ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL NOT V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                   ".
   02 FILLER PIC X(80) VALUE "       READ SESSION-VAR-FILE PREVIOUS WITH WAIT END-READ                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF FIRST-REQ-TIMESTAMP-SEC OF SESSION-VAR-RECORD >                    ".
   02 FILLER PIC X(80) VALUE "                                                WS-FIRST-REQ-TIMESTAMP-SEC      ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             CONTINUE                                                           ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "             DELETE SESSION-VAR-FILE END-DELETE                                 ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DESTROY-SESSION SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX TO SESSION-ID-HEX OF SESSION-RECORD                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-FILE WITH WAIT END-READ                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "        WHEN V-SUCCESS        OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "*>         check USER-AGENT-HASH and REMOTE-ADDR                                ".
   02 FILLER PIC X(80) VALUE "           IF  LNK-USER-AGENT-HASH-HEX = USER-AGENT-HASH-HEX OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           AND LNK-REMOTE-ADDR         = REMOTE-ADDR         OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           THEN                                                                 ".
   02 FILLER PIC X(80) VALUE "*>            first delete all session vars for this session-key                ".
   02 FILLER PIC X(80) VALUE "              PERFORM DEL-SESSION-VAR-ALL                                       ".
   02 FILLER PIC X(80) VALUE "*>            delete session                                                    ".
   02 FILLER PIC X(80) VALUE "              DELETE SESSION-FILE END-DELETE                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "              IF V-SUCCESS OF WS-SESSION-FILE-STATUS                            ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-OK     OF LNK-RESULT TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-NOT-OK OF LNK-RESULT TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "           ELSE                                                                 ".
   02 FILLER PIC X(80) VALUE "              SET V-NOT-OK OF LNK-RESULT TO TRUE                                ".
   02 FILLER PIC X(80) VALUE "           END-IF                                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN V-KEY-NOT-EXISTS OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "           SET V-NOT-OK OF LNK-RESULT TO TRUE                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN OTHER                                                              ".
   02 FILLER PIC X(80) VALUE "           SET V-NOT-OK OF LNK-RESULT TO TRUE                                   ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " REGENERATE-SESSION SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current time in number of seconds                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM GET-CURR-TIME                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  read old session                                                            ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX-OLD TO SESSION-ID-HEX OF SESSION-RECORD             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-FILE WITH WAIT END-READ                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "        WHEN V-SUCCESS        OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "*>         check USER-AGENT-HASH and REMOTE-ADDR                                ".
   02 FILLER PIC X(80) VALUE "           IF  LNK-USER-AGENT-HASH-HEX = USER-AGENT-HASH-HEX OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           AND LNK-REMOTE-ADDR         = REMOTE-ADDR         OF SESSION-RECORD  ".
   02 FILLER PIC X(80) VALUE "           THEN                                                                 ".
   02 FILLER PIC X(80) VALUE "*>            first copy and delete all session vars for this session           ".
   02 FILLER PIC X(80) VALUE "              PERFORM REGENERATE-SESSION-VAR                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>            write last request timestamp                                      ".
   02 FILLER PIC X(80) VALUE "              MOVE WS-CURR-DATE-TIME                                            ".
   02 FILLER PIC X(80) VALUE "                TO LAST-REQ-TIMESTAMP     OF SESSION-RECORD                     ".
   02 FILLER PIC X(80) VALUE "              MOVE WS-CURR-NUMBER-OF-SECS                                       ".
   02 FILLER PIC X(80) VALUE "                TO LAST-REQ-TIMESTAMP-SEC OF SESSION-RECORD                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>            write with new session                                            ".
   02 FILLER PIC X(80) VALUE "              MOVE LNK-SESSION-ID-HEX TO SESSION-ID-HEX OF SESSION-RECORD       ".
   02 FILLER PIC X(80) VALUE "              WRITE SESSION-RECORD END-WRITE                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "              IF V-SUCCESS OF WS-SESSION-FILE-STATUS                            ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "*>               delete old session                                             ".
   02 FILLER PIC X(80) VALUE "                 MOVE LNK-SESSION-ID-HEX-OLD TO SESSION-ID-HEX OF SESSION-RECORD".
   02 FILLER PIC X(80) VALUE "                 DELETE SESSION-FILE END-DELETE                                 ".
   02 FILLER PIC X(80) VALUE "                 IF V-SUCCESS OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "                 THEN                                                           ".
   02 FILLER PIC X(80) VALUE "                    SET V-OK     OF LNK-RESULT TO TRUE                          ".
   02 FILLER PIC X(80) VALUE "                 ELSE                                                           ".
   02 FILLER PIC X(80) VALUE "                    SET V-NOT-OK OF LNK-RESULT TO TRUE                          ".
   02 FILLER PIC X(80) VALUE "                 END-IF                                                         ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-NOT-OK OF LNK-RESULT TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "           ELSE                                                                 ".
   02 FILLER PIC X(80) VALUE "              SET V-NOT-OK OF LNK-RESULT TO TRUE                                ".
   02 FILLER PIC X(80) VALUE "           END-IF                                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN V-KEY-NOT-EXISTS OF WS-SESSION-FILE-STATUS                         ".
   02 FILLER PIC X(80) VALUE "           SET V-NOT-OK OF LNK-RESULT TO TRUE                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "        WHEN OTHER                                                              ".
   02 FILLER PIC X(80) VALUE "           SET V-NOT-OK OF LNK-RESULT TO TRUE                                   ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " REGENERATE-SESSION-VAR SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE-2                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD-2                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX-OLD TO SESSION-ID-HEX OF SESSION-VAR-RECORD         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    START SESSION-VAR-FILE KEY IS >= SESSION-VAR-KEY OF SESSION-VAR-RECORD      ".
   02 FILLER PIC X(80) VALUE "    END-START                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  copy and delete all session vars for a session-key                          ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL NOT V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                   ".
   02 FILLER PIC X(80) VALUE "       READ SESSION-VAR-FILE NEXT WITH WAIT END-READ                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF LNK-SESSION-ID-HEX-OLD NOT = SESSION-ID-HEX OF SESSION-VAR-RECORD  ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             EXIT PERFORM                                                       ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "*>           write with new session                                             ".
   02 FILLER PIC X(80) VALUE "             MOVE SESSION-VAR-RECORD TO SESSION-VAR-RECORD-2                    ".
   02 FILLER PIC X(80) VALUE "             MOVE LNK-SESSION-ID-HEX TO SESSION-ID-HEX OF SESSION-VAR-RECORD-2  ".
   02 FILLER PIC X(80) VALUE "             WRITE SESSION-VAR-RECORD-2 END-WRITE                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             IF V-SUCCESS OF WS-SESSION-VAR-FILE-2-STATUS                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                DELETE SESSION-VAR-FILE END-DELETE                              ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE-2                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SET-SESSION-VAR SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  exists session in session file?                                             ".
   02 FILLER PIC X(80) VALUE "    PERFORM CHECK-SESSION                                                       ".
   02 FILLER PIC X(80) VALUE "    IF V-NOT-OK OF LNK-RESULT                                                   ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX                                                     ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-ID-HEX          OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-VAR-NAME                                                   ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-VAR-NAME        OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-VAR-FILE WITH WAIT END-READ                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  timestamps                                                                  ".
   02 FILLER PIC X(80) VALUE "    MOVE FIRST-REQ-TIMESTAMP     OF SESSION-RECORD                              ".
   02 FILLER PIC X(80) VALUE "      TO FIRST-REQ-TIMESTAMP     OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "    MOVE FIRST-REQ-TIMESTAMP-SEC OF SESSION-RECORD                              ".
   02 FILLER PIC X(80) VALUE "      TO FIRST-REQ-TIMESTAMP-SEC OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "*>  value                                                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-VAR-INP-VALUE OF LNK-INPUT                                 ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-VAR-VALUE         OF SESSION-VAR-RECORD                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "*>     var exists yet                                                           ".
   02 FILLER PIC X(80) VALUE "       REWRITE SESSION-VAR-RECORD END-REWRITE                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       WRITE SESSION-VAR-RECORD END-WRITE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-OK     OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " GET-SESSION-VAR SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  exists session in session file?                                             ".
   02 FILLER PIC X(80) VALUE "    PERFORM CHECK-SESSION                                                       ".
   02 FILLER PIC X(80) VALUE "    IF V-NOT-OK OF LNK-RESULT                                                   ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX                                                     ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-ID-HEX          OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-VAR-NAME                                                   ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-VAR-NAME        OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-VAR-FILE WITH WAIT END-READ                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-OK OF LNK-RESULT TO TRUE                                           ".
   02 FILLER PIC X(80) VALUE "*>     value                                                                    ".
   02 FILLER PIC X(80) VALUE "       MOVE SESSION-VAR-VALUE         OF SESSION-VAR-RECORD                     ".
   02 FILLER PIC X(80) VALUE "         TO LNK-SESSION-VAR-OUT-VALUE OF LNK-OUTPUT                             ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " DEL-SESSION-VAR SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  exists session in session file?                                             ".
   02 FILLER PIC X(80) VALUE "    PERFORM CHECK-SESSION                                                       ".
   02 FILLER PIC X(80) VALUE "    IF V-NOT-OK OF LNK-RESULT                                                   ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-VAR-FILE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-VAR-RECORD                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX                                                     ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-ID-HEX          OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-VAR-NAME                                                   ".
   02 FILLER PIC X(80) VALUE "      TO SESSION-VAR-NAME        OF SESSION-VAR-RECORD                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-VAR-FILE WITH WAIT END-READ                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       DELETE SESSION-VAR-FILE END-DELETE                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-SUCCESS OF WS-SESSION-VAR-FILE-STATUS                               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-OK OF LNK-RESULT TO TRUE                                        ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-NOT-OK OF LNK-RESULT TO TRUE                                    ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-VAR-FILE                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " CHECK-SESSION SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    OPEN I-O SHARING WITH ALL OTHER SESSION-FILE                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE SESSION-RECORD                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX TO SESSION-ID-HEX OF SESSION-RECORD                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    READ SESSION-FILE WITH WAIT END-READ                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-SUCCESS OF WS-SESSION-FILE-STATUS                                      ".
   02 FILLER PIC X(80) VALUE "*>     check USER-AGENT-HASH and REMOTE-ADDR                                    ".
   02 FILLER PIC X(80) VALUE "       IF LNK-USER-AGENT-HASH-HEX NOT = USER-AGENT-HASH-HEX OF SESSION-RECORD   ".
   02 FILLER PIC X(80) VALUE "       OR LNK-REMOTE-ADDR         NOT = REMOTE-ADDR         OF SESSION-RECORD   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-NOT-OK OF LNK-RESULT TO TRUE                                    ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NOT-OK OF LNK-RESULT TO TRUE                                       ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CLOSE SESSION-FILE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " GET-CURR-TIME SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION CURRENT-DATE      TO CURRENT-DATE-AND-TIME                    ".
   02 FILLER PIC X(80) VALUE "    MOVE CORR CURRENT-DATE-AND-TIME TO WS-CURR-DATE-TIME                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-YEAR  OF CURRENT-DATE-AND-TIME TO WS-YEAR  OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-MONTH OF CURRENT-DATE-AND-TIME TO WS-MONTH OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "    MOVE CDT-DAY   OF CURRENT-DATE-AND-TIME TO WS-DAY   OF WS-DATE-NUM-R        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert current date in number of days                                      ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION INTEGER-OF-DATE(WS-DATE-NUM) TO WS-CURR-NUMBER-OF-DAYS        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current number of seconds                                                   ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-CURR-NUMBER-OF-SECS = WS-CURR-NUMBER-OF-DAYS * C-SEC-IN-DAY      ".
   02 FILLER PIC X(80) VALUE "           + CDT-HOUR    OF CURRENT-DATE-AND-TIME * C-SEC-IN-HOUR               ".
   02 FILLER PIC X(80) VALUE "           + CDT-MINUTES OF CURRENT-DATE-AND-TIME * C-SEC-IN-MINUTE             ".
   02 FILLER PIC X(80) VALUE "           + CDT-SECONDS OF CURRENT-DATE-AND-TIME                               ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-SESSION.                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   
 01 WS-HTM2COB-SESSION-R REDEFINES WS-HTM2COB-SESSION.
   02 WS-HTM2COB-SESSION-LINES OCCURS C-HTM2COB-SESSION-MAX-LINE TIMES.
     03 WS-HTM2COB-SESSION-LINE                PIC X(80).
