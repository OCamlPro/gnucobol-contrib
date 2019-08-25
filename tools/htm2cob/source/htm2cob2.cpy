*> Program HTM2COB-POST template
 01 C-HTM2COB-POST-MAX-LINE                CONSTANT AS 183.

 01 WS-HTM2COB-POST.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-POST.cob is free software: you can redistribute it and/or           ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-POST.cob is distributed in the hope that it will be useful,         ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-POST.cob.                                                ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-POST.cob                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Get saved cgi values                                           ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               HTM2COB-POST USING <field-name> <field-value>                  ".
   02 FILLER PIC X(80) VALUE "*>               Fields in HTM2COB-POST linkage:                                ".
   02 FILLER PIC X(80) VALUE "*>                 <field-name>  - input                                        ".
   02 FILLER PIC X(80) VALUE "*>                 <field-value> - output                                       ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-POST.                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-POST-NAME              PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-POST-VALUE             PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-POST-NAME                                 ".
   02 FILLER PIC X(80) VALUE "                          LNK-HTM2COB-POST-VALUE.                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-POST-MAIN SECTION.                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND-1 FROM 1 BY 1                                        ".
   02 FILLER PIC X(80) VALUE "      UNTIL WS-IND-1 > HTM2COB-TAB-NR                                           ".
   02 FILLER PIC X(80) VALUE "      OR    WS-IND-1 > HTM2COB-TAB-MAX-LINE                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-TAB-FIELD(WS-IND-1) = LNK-HTM2COB-POST-NAME                   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-TAB-FILE-YES OF HTM2COB-TAB-FILE-FLAG(WS-IND-1)          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-TAB-FILE-NAME(WS-IND-1)                               ".
   02 FILLER PIC X(80) VALUE "                                       (1:HTM2COB-TAB-FILE-NAME-LEN(WS-IND-1))  ".
   02 FILLER PIC X(80) VALUE "               TO LNK-HTM2COB-POST-VALUE                                        ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-TAB-VALUE-LEN(WS-IND-1) = ZEROES                        ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE SPACES                                                     ".
   02 FILLER PIC X(80) VALUE "                  TO LNK-HTM2COB-POST-VALUE                                     ".
   02 FILLER PIC X(80) VALUE "             ELSE                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-DATA-VALUE                                         ".
   02 FILLER PIC X(80) VALUE "                     (HTM2COB-TAB-VALUE-PTR(WS-IND-1):                          ".
   02 FILLER PIC X(80) VALUE "                      HTM2COB-TAB-VALUE-LEN(WS-IND-1))                          ".
   02 FILLER PIC X(80) VALUE "                  TO LNK-HTM2COB-POST-VALUE                                     ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          EXIT PERFORM                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF WS-IND-1 > HTM2COB-TAB-NR                                                ".
   02 FILLER PIC X(80) VALUE "    OR WS-IND-1 > HTM2COB-TAB-MAX-LINE                                          ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE SPACES                                                              ".
   02 FILLER PIC X(80) VALUE "         TO LNK-HTM2COB-POST-VALUE                                              ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-POST.                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-POST-MULTI.cob is free software: you can redistribute it and/or     ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-POST-MULTI.cob is distributed in the hope that it will be useful,   ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-POST-MULTI.cob.                                          ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-POST-MULTI.cob                                         ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Get saved cgi values                                           ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               HTM2COB-POST USING <field-name> <field-value>                  ".
   02 FILLER PIC X(80) VALUE "*>               Fields in HTM2COB-POST-MULTI linkage:                          ".
   02 FILLER PIC X(80) VALUE "*>                 <field-name>      - input                                    ".
   02 FILLER PIC X(80) VALUE "*>                 <field-separator> - input                                    ".
   02 FILLER PIC X(80) VALUE "*>                 <field-value>     - output                                   ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-POST-MULTI.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-STR-POINTER                     PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-REST-LEN                        PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-POST-NAME              PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-POST-SEPARATOR         PIC X(1).                                ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-POST-VALUE             PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-POST-NAME                                 ".
   02 FILLER PIC X(80) VALUE "                          LNK-HTM2COB-POST-SEPARATOR                            ".
   02 FILLER PIC X(80) VALUE "                          LNK-HTM2COB-POST-VALUE.                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-POST-MULTI-MAIN SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE SPACES TO LNK-HTM2COB-POST-VALUE                                       ".
   02 FILLER PIC X(80) VALUE "*>  init string pointer                                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-STR-POINTER                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND-1 FROM 1 BY 1                                        ".
   02 FILLER PIC X(80) VALUE "      UNTIL WS-IND-1 > HTM2COB-TAB-NR                                           ".
   02 FILLER PIC X(80) VALUE "      OR    WS-IND-1 > HTM2COB-TAB-MAX-LINE                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-TAB-FIELD(WS-IND-1) = LNK-HTM2COB-POST-NAME                   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF HTM2COB-TAB-VALUE-LEN(WS-IND-1) NOT = ZEROES                       ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             COMPUTE WS-REST-LEN = FUNCTION LENGTH(LNK-HTM2COB-POST-VALUE)      ".
   02 FILLER PIC X(80) VALUE "                                 - WS-STR-POINTER                               ".
   02 FILLER PIC X(80) VALUE "             END-COMPUTE                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             IF WS-REST-LEN > HTM2COB-TAB-VALUE-LEN(WS-IND-1)                   ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                STRING HTM2COB-DATA-VALUE                                       ".
   02 FILLER PIC X(80) VALUE "                       (HTM2COB-TAB-VALUE-PTR(WS-IND-1):                        ".
   02 FILLER PIC X(80) VALUE "                        HTM2COB-TAB-VALUE-LEN(WS-IND-1)) DELIMITED BY SIZE      ".
   02 FILLER PIC X(80) VALUE "                       LNK-HTM2COB-POST-SEPARATOR        DELIMITED BY SIZE      ".
   02 FILLER PIC X(80) VALUE "                  INTO LNK-HTM2COB-POST-VALUE                                   ".
   02 FILLER PIC X(80) VALUE "                  WITH POINTER WS-STR-POINTER                                   ".
   02 FILLER PIC X(80) VALUE "                END-STRING                                                      ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-POST-MULTI.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".

 01 WS-HTM2COB-POST-R REDEFINES WS-HTM2COB-POST.
   02 WS-HTM2COB-POST-LINES OCCURS C-HTM2COB-POST-MAX-LINE TIMES.
     03 WS-HTM2COB-POST-LINE                PIC X(80).
