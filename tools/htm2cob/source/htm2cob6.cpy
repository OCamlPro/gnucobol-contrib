*> Program HTM2COB-SESSION-ID template
 01 C-HTM2COB-SESSION-ID-MAX-LINE      CONSTANT AS 1208.

 01 WS-HTM2COB-SESSION-ID.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SESSION-ID.cob is free software: you can redistribute it and/or     ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SESSION-ID.cob is distributed in the hope that it will be useful,   ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-SESSION-ID.cob.                                          ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-SESSION-ID.cob                                         ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      This module computes a session ID with SHA3-512.               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Tectonics:    cobc -m -free HTM2COB-SESSION-ID.cob HTM2COB-SHA3-512.o \      ".
   02 FILLER PIC X(80) VALUE "*>                                                    HTM2COB-KECCAK.o          ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        Call this module in your web application. It creates a session ".
   02 FILLER PIC X(80) VALUE "*>               ID from the IP address of the visitor. This is the REMOTE_ADDR ".
   02 FILLER PIC X(80) VALUE "*>               CGI Environment Variable. To the IP address will be append a   ".
   02 FILLER PIC X(80) VALUE "*>               timestamp and a random number. After it will be SHA3-512       ".
   02 FILLER PIC X(80) VALUE "*>               called to create a hash. The output hash is available in binary".
   02 FILLER PIC X(80) VALUE "*>               and in hexadecimal format.                                     ".
   02 FILLER PIC X(80) VALUE "*>               It creates also a USER-AGENT-HASH from the HTTP-USER-AGENT CGI ".
   02 FILLER PIC X(80) VALUE "*>               Environment Variable. You can use it to track the client       ".
   02 FILLER PIC X(80) VALUE "*>               browser.                                                       ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-SESSION-ID.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-SHA3-512-INPUT                  PIC X(8000).                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-SHA3-512-INPUT-BYTE-LEN         BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-SHA3-512-OUTPUT                 PIC X(64).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-CURRENT-DATE-AND-TIME           PIC X(21).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-CDT REDEFINES WS-CURRENT-DATE-AND-TIME.                                  ".
   02 FILLER PIC X(80) VALUE "   02 WS-CDT-DATE-AND-TIME             PIC 9(16).                               ".
   02 FILLER PIC X(80) VALUE "   02 WS-CDT-GMT-DIFF                  PIC S9(4).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-RANDOM-NR                       PIC 9V9(37).                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-RND-NR-RE REDEFINES WS-RANDOM-NR.                                        ".
   02 FILLER PIC X(80) VALUE "   02 WS-RND-DOT                       PIC X(1).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-RND-NR                        PIC X(37).                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> for clock_gettime                                                            ".
   02 FILLER PIC X(80) VALUE " 01 CLOCK-MONOTONIC                    BINARY-LONG VALUE 1.                     ".
   02 FILLER PIC X(80) VALUE " 01 TIME-SPEC.                                                                  ".
   02 FILLER PIC X(80) VALUE "   02 TV-SEC                           BINARY-DOUBLE SIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 TV-NSEC                          BINARY-DOUBLE SIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-TV-SEC                          PIC S9(21).                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-TV-NSEC                         PIC S9(21).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> for converting num to hex                                                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM2HEX-IN                      PIC 9(2) COMP-5.                         ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM2HEX-OUT                     PIC X(2).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM2HEX-QUOTIENT                PIC 9(2) COMP-5.                         ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM2HEX-REMAINDER               PIC 9(2) COMP-5.                         ".
   02 FILLER PIC X(80) VALUE " 01 WS-HEX-CHAR                        PIC X(16) VALUE ""0123456789ABCDEF"".    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-2                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-STR-POINTER                     PIC 9(4).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM-DATA                        PIC X(64).                               ".
   02 FILLER PIC X(80) VALUE " 01 WS-NUM-TABLE REDEFINES WS-NUM-DATA.                                         ".
   02 FILLER PIC X(80) VALUE "   02 WS-NUM                           PIC 9(2) COMP-5 OCCURS 64.               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-HEX-DATA                        PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-HEX-TABLE REDEFINES WS-HEX-DATA.                                         ".
   02 FILLER PIC X(80) VALUE "   02 WS-HEX                           PIC X(2) OCCURS 64.                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-SESSION-ID.                                                     ".
   02 FILLER PIC X(80) VALUE "   02 LNK-INPUT.                                                                ".
   02 FILLER PIC X(80) VALUE "     03 LNK-REMOTE-ADDR                PIC X(100).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-REMOTE-ADDR-FLAG           PIC 9.                                   ".
   02 FILLER PIC X(80) VALUE "       88 V-NO                         VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES                        VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "     03 LNK-HTTP-USER-AGENT            PIC X(8000).                             ".
   02 FILLER PIC X(80) VALUE "     03 LNK-HTTP-USER-AGENT-FLAG       PIC 9.                                   ".
   02 FILLER PIC X(80) VALUE "       88 V-NO                         VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "       88 V-YES                        VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OUTPUT.                                                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-ID-BIN             PIC X(64).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-SESSION-ID-HEX             PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "     03 LNK-USER-AGENT-HASH-BIN        PIC X(64).                               ".
   02 FILLER PIC X(80) VALUE "     03 LNK-USER-AGENT-HASH-HEX        PIC X(128).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-SESSION-ID.                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESSION-ID-MAIN SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  compute session-id from remote-addr                                         ".
   02 FILLER PIC X(80) VALUE "    IF V-YES OF LNK-REMOTE-ADDR-FLAG                                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM COMPUTE-SESSION-ID                                               ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  compute user-agent hash                                                     ".
   02 FILLER PIC X(80) VALUE "    IF V-YES OF LNK-HTTP-USER-AGENT-FLAG                                        ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM COMPUTE-USER-AGENT-HASH                                          ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " COMPUTE-SESSION-ID SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  init fields                                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-SHA3-512-INPUT                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-SHA3-512-OUTPUT                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-CURRENT-DATE-AND-TIME                                         ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-RANDOM-NR                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  current-date is not enough, we need nano sec also                           ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-AND-TIME                      ".
   02 FILLER PIC X(80) VALUE "*>  get sec and nano sec                                                        ".
   02 FILLER PIC X(80) VALUE "    PERFORM GETTIME                                                             ".
   02 FILLER PIC X(80) VALUE "*>  get random number with a seed of nano sec                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION RANDOM(WS-TV-NSEC) TO WS-RANDOM-NR                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  init string pointer                                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-STR-POINTER                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  string all together 1. part                                                 ".
   02 FILLER PIC X(80) VALUE "    STRING LNK-REMOTE-ADDR OF LNK-HTM2COB-SESSION-ID DELIMITED BY SPACE         ".
   02 FILLER PIC X(80) VALUE "           WS-CDT-DATE-AND-TIME                      DELIMITED BY SIZE          ".
   02 FILLER PIC X(80) VALUE "           WS-RND-NR                                 DELIMITED BY SPACE         ".
   02 FILLER PIC X(80) VALUE "           WS-TV-SEC                                 DELIMITED BY SIZE          ".
   02 FILLER PIC X(80) VALUE "           WS-TV-NSEC                                DELIMITED BY SIZE          ".
   02 FILLER PIC X(80) VALUE "      INTO WS-SHA3-512-INPUT                                                    ".
   02 FILLER PIC X(80) VALUE "      WITH POINTER WS-STR-POINTER                                               ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  get sec and nano sec                                                        ".
   02 FILLER PIC X(80) VALUE "    PERFORM GETTIME                                                             ".
   02 FILLER PIC X(80) VALUE "*>  get random number with a seed of nano sec                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION RANDOM(WS-TV-NSEC) TO WS-RANDOM-NR                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  string all together 2. part                                                 ".
   02 FILLER PIC X(80) VALUE "    STRING WS-RND-NR                         DELIMITED BY SPACE                 ".
   02 FILLER PIC X(80) VALUE "           WS-TV-SEC                         DELIMITED BY SIZE                  ".
   02 FILLER PIC X(80) VALUE "           WS-TV-NSEC                        DELIMITED BY SIZE                  ".
   02 FILLER PIC X(80) VALUE "      INTO WS-SHA3-512-INPUT                                                    ".
   02 FILLER PIC X(80) VALUE "      WITH POINTER WS-STR-POINTER                                               ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION STORED-CHAR-LENGTH(WS-SHA3-512-INPUT)                         ".
   02 FILLER PIC X(80) VALUE "      TO WS-SHA3-512-INPUT-BYTE-LEN                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  compute the hash                                                            ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SHA3-512"" USING WS-SHA3-512-INPUT                           ".
   02 FILLER PIC X(80) VALUE "                                    WS-SHA3-512-INPUT-BYTE-LEN                  ".
   02 FILLER PIC X(80) VALUE "                                    WS-SHA3-512-OUTPUT                          ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-SHA3-512-OUTPUT TO LNK-SESSION-ID-BIN OF LNK-HTM2COB-SESSION-ID     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert in hexa                                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-SHA3-512-OUTPUT TO WS-NUM-DATA                                      ".
   02 FILLER PIC X(80) VALUE "    PERFORM DATA-BUFF-IN-HEXA                                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-HEX-DATA        TO LNK-SESSION-ID-HEX OF LNK-HTM2COB-SESSION-ID     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " COMPUTE-USER-AGENT-HASH SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  init fields                                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-SHA3-512-INPUT                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-SHA3-512-OUTPUT                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-HTTP-USER-AGENT OF LNK-HTM2COB-SESSION-ID                          ".
   02 FILLER PIC X(80) VALUE "      TO WS-SHA3-512-INPUT                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION STORED-CHAR-LENGTH(WS-SHA3-512-INPUT)                         ".
   02 FILLER PIC X(80) VALUE "      TO WS-SHA3-512-INPUT-BYTE-LEN                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  compute the hash                                                            ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SHA3-512"" USING WS-SHA3-512-INPUT                           ".
   02 FILLER PIC X(80) VALUE "                                    WS-SHA3-512-INPUT-BYTE-LEN                  ".
   02 FILLER PIC X(80) VALUE "                                    WS-SHA3-512-OUTPUT                          ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-SHA3-512-OUTPUT TO LNK-USER-AGENT-HASH-BIN OF LNK-HTM2COB-SESSION-ID".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  convert in hexa                                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-SHA3-512-OUTPUT TO WS-NUM-DATA                                      ".
   02 FILLER PIC X(80) VALUE "    PERFORM DATA-BUFF-IN-HEXA                                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-HEX-DATA        TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION-ID".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE " GETTIME SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL STATIC ""clock_gettime""                                               ".
   02 FILLER PIC X(80) VALUE "          USING BY VALUE     CLOCK-MONOTONIC                                    ".
   02 FILLER PIC X(80) VALUE "                BY REFERENCE TIME-SPEC                                          ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE TV-SEC  OF TIME-SPEC TO WS-TV-SEC                                      ".
   02 FILLER PIC X(80) VALUE "    MOVE TV-NSEC OF TIME-SPEC TO WS-TV-NSEC                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE " DATA-BUFF-IN-HEXA SECTION.                                                     ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-HEX-DATA                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND-1 FROM 1 BY 1                                        ".
   02 FILLER PIC X(80) VALUE "            UNTIL   WS-IND-1 > 64                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-NUM(WS-IND-1) TO WS-NUM2HEX-IN                                   ".
   02 FILLER PIC X(80) VALUE "       PERFORM NUM2HEX                                                          ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-NUM2HEX-OUT   TO WS-HEX(WS-IND-1)                                ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE " NUM2HEX SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE "*>----------------------------------------------------------------------        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-NUM2HEX-OUT                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND-2 FROM 2 BY -1                                       ".
   02 FILLER PIC X(80) VALUE "            UNTIL   WS-IND-2 < 1                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       DIVIDE WS-NUM2HEX-IN BY 16                                               ".
   02 FILLER PIC X(80) VALUE "          GIVING    WS-NUM2HEX-QUOTIENT                                         ".
   02 FILLER PIC X(80) VALUE "          REMAINDER WS-NUM2HEX-REMAINDER                                        ".
   02 FILLER PIC X(80) VALUE "       END-DIVIDE                                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO WS-NUM2HEX-REMAINDER END-ADD                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-HEX-CHAR(WS-NUM2HEX-REMAINDER:1)                                 ".
   02 FILLER PIC X(80) VALUE "         TO WS-NUM2HEX-OUT(WS-IND-2:1)                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-NUM2HEX-QUOTIENT                                                 ".
   02 FILLER PIC X(80) VALUE "         TO WS-NUM2HEX-IN                                                       ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SHA3-512.cob is free software: you can redistribute it and/or       ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SHA3-512.cob is distributed in the hope that it will be useful,     ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-SHA3-512.cob.                                            ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-SHA3-512.cob                                           ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      This module computes SHA3-512 on the input message.            ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Tectonics:    cobc -m -free HTM2COB-SHA3-512.cob HTM2COB-KECCAK.o            ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        Call this module in your application.                          ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module to compute SHA3-512 on the input message.                             ".
   02 FILLER PIC X(80) VALUE "*> The output length is fixed to 64 bytes.                                      ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-SHA3-512.                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-RATE                    BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-CAPACITY                BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-DELIMITED-SUFFIX        PIC X.                                   ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-OUTPUT-BYTE-LEN         BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-SHA3-512-INPUT                 PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-SHA3-512-INPUT-BYTE-LEN        BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 LNK-SHA3-512-OUTPUT                PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-SHA3-512-INPUT                                    ".
   02 FILLER PIC X(80) VALUE "                          LNK-SHA3-512-INPUT-BYTE-LEN                           ".
   02 FILLER PIC X(80) VALUE "                          LNK-SHA3-512-OUTPUT.                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " SHA3-512-MAIN SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE 576    TO LNK-KECCAK-RATE                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE 1024   TO LNK-KECCAK-CAPACITY                                          ".
   02 FILLER PIC X(80) VALUE "    MOVE X""06""  TO LNK-KECCAK-DELIMITED-SUFFIX                                ".
   02 FILLER PIC X(80) VALUE "    MOVE 64     TO LNK-KECCAK-OUTPUT-BYTE-LEN                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-KECCAK"" USING LNK-KECCAK-RATE                               ".
   02 FILLER PIC X(80) VALUE "                                  LNK-KECCAK-CAPACITY                           ".
   02 FILLER PIC X(80) VALUE "                                  LNK-SHA3-512-INPUT                            ".
   02 FILLER PIC X(80) VALUE "                                  LNK-SHA3-512-INPUT-BYTE-LEN                   ".
   02 FILLER PIC X(80) VALUE "                                  LNK-KECCAK-DELIMITED-SUFFIX                   ".
   02 FILLER PIC X(80) VALUE "                                  LNK-SHA3-512-OUTPUT                           ".
   02 FILLER PIC X(80) VALUE "                                  LNK-KECCAK-OUTPUT-BYTE-LEN                    ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-KECCAK.cob is free software: you can redistribute it and/or         ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-KECCAK.cob is distributed in the hope that it will be useful,       ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-KECCAK.cob.                                              ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-KECCAK.cob                                             ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      This module computes the Keccak[r,c] sponge function           ".
   02 FILLER PIC X(80) VALUE "*>               over a given input.                                            ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Tectonics:    cobc -c -free HTM2COB-KECCAK.cob                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        This module will be called in SHA3 and SHAKE modules.          ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>               Fields in LINKAGE SECTION:                                     ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-RATE: The value of the rate r. The rate must be   ".
   02 FILLER PIC X(80) VALUE "*>                 a multiple of 8 bits in this implementation.                 ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-CAPACITY: The value of the capacity c.            ".
   02 FILLER PIC X(80) VALUE "*>                 The rate and capacity must have r+c=1600.                    ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-INPUT: The input message.                         ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-INPUT-BYTE-LEN: The number of input bytes provided".
   02 FILLER PIC X(80) VALUE "*>                 in the input message.                                        ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-DELIMITED-SUFFIX: Bits that will be automatically ".
   02 FILLER PIC X(80) VALUE "*>                 appended to the end of the input message, as in domain       ".
   02 FILLER PIC X(80) VALUE "*>                 separation.                                                  ".
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-OUTPUT: The buffer where to store the output.     ".     
   02 FILLER PIC X(80) VALUE "*>               - LNK-KECCAK-OUTPUT-BYTE-LEN: The number of output bytes       ".
   02 FILLER PIC X(80) VALUE "*>                 desired.                                                     ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> The KECCAK module, that uses the Keccak-f[1600] permutation.                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-KECCAK.                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-STATE                           PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-RATE-IN-BYTES                   BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-BLOCK-SIZE                      BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-INPUT-BYTE-LEN                  BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-INPUT-IND                       BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-OUTPUT-BYTE-LEN                 BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-OUTPUT-IND                      BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-CHECK-PADDING-BIT               PIC X.                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the STATE-PERMUTE module                                         ".
   02 FILLER PIC X(80) VALUE " 01 LNK-STATE-PERMUTE.                                                          ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-RATE                    BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-CAPACITY                BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-INPUT                   PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-INPUT-BYTE-LEN          BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-DELIMITED-SUFFIX        PIC X.                                   ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-OUTPUT                  PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-KECCAK-OUTPUT-BYTE-LEN         BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-KECCAK-RATE                                       ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-CAPACITY                                   ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-INPUT                                      ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-INPUT-BYTE-LEN                             ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-DELIMITED-SUFFIX                           ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-OUTPUT                                     ".
   02 FILLER PIC X(80) VALUE "                          LNK-KECCAK-OUTPUT-BYTE-LEN.                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-KECCAK-MAIN SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Check rate and capacity, they must have r+c=1600                            ".
   02 FILLER PIC X(80) VALUE "    IF (LNK-KECCAK-RATE + LNK-KECCAK-CAPACITY) NOT = 1600                       ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       GOBACK                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Check rate, it must be a multiple of 8 bits in this implementation          ".
   02 FILLER PIC X(80) VALUE "    IF FUNCTION MOD(LNK-KECCAK-RATE, 8) NOT = ZEROES                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       GOBACK                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Initialize fields                                                           ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-RATE-IN-BYTES = LNK-KECCAK-RATE / 8 END-COMPUTE                  ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-KECCAK-INPUT-BYTE-LEN  TO WS-INPUT-BYTE-LEN                        ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES                     TO WS-INPUT-IND                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-KECCAK-OUTPUT-BYTE-LEN TO WS-OUTPUT-BYTE-LEN                       ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES                     TO WS-OUTPUT-IND                            ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES                     TO WS-BLOCK-SIZE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Initialize the state                                                        ".
   02 FILLER PIC X(80) VALUE "    MOVE ALL X""00"" TO WS-STATE                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Absorb all the input blocks                                                 ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL WS-INPUT-BYTE-LEN <= 0                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE FUNCTION MIN(WS-INPUT-BYTE-LEN, WS-RATE-IN-BYTES) TO WS-BLOCK-SIZE  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       PERFORM VARYING WS-IND-1 FROM 1 BY 1 UNTIL WS-IND-1 > WS-BLOCK-SIZE      ".
   02 FILLER PIC X(80) VALUE "          COMPUTE WS-INPUT-IND = WS-INPUT-IND + 1 END-COMPUTE                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          CALL ""CBL_XOR"" USING LNK-KECCAK-INPUT(WS-INPUT-IND:1)               ".
   02 FILLER PIC X(80) VALUE "                               WS-STATE(WS-IND-1:1)                             ".
   02 FILLER PIC X(80) VALUE "                         BY VALUE 1                                             ".
   02 FILLER PIC X(80) VALUE "          END-CALL                                                              ".
   02 FILLER PIC X(80) VALUE "       END-PERFORM                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-INPUT-BYTE-LEN = WS-INPUT-BYTE-LEN - WS-BLOCK-SIZE            ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF WS-BLOCK-SIZE = WS-RATE-IN-BYTES                                      ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-STATE TO LNK-STATE OF LNK-STATE-PERMUTE                       ".
   02 FILLER PIC X(80) VALUE "          CALL ""STATE-PERMUTE"" USING LNK-STATE-PERMUTE END-CALL               ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE TO WS-STATE                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE ZEROES TO WS-BLOCK-SIZE                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Do the padding and switch to the squeezing phase.                           ".
   02 FILLER PIC X(80) VALUE "*>  Absorb the last few bits and add the first bit of padding (which coincides  ".
   02 FILLER PIC X(80) VALUE "*>  with the delimiter in delimitedSuffix)                                      ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING LNK-KECCAK-DELIMITED-SUFFIX                          ".
   02 FILLER PIC X(80) VALUE "                         WS-STATE(WS-BLOCK-SIZE + 1:1)                          ".
   02 FILLER PIC X(80) VALUE "                   BY VALUE 1                                                   ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  If the first bit of padding is at position rate - 1, we need a whole        ".
   02 FILLER PIC X(80) VALUE "*>  new block for the second bit of padding                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-KECCAK-DELIMITED-SUFFIX TO WS-CHECK-PADDING-BIT                    ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING X""80""                                              ".
   02 FILLER PIC X(80) VALUE "                         WS-CHECK-PADDING-BIT                                   ".
   02 FILLER PIC X(80) VALUE "                   BY VALUE 1                                                   ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  WS-CHECK-PADDING-BIT NOT = X""00""                                      ".
   02 FILLER PIC X(80) VALUE "    AND WS-BLOCK-SIZE = WS-RATE-IN-BYTES - 1                                    ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-STATE TO LNK-STATE OF LNK-STATE-PERMUTE                          ".
   02 FILLER PIC X(80) VALUE "       CALL ""STATE-PERMUTE"" USING LNK-STATE-PERMUTE END-CALL                  ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-STATE OF LNK-STATE-PERMUTE TO WS-STATE                          ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Add the second bit of padding                                               ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING X""80""                                              ".
   02 FILLER PIC X(80) VALUE "                         WS-STATE(WS-RATE-IN-BYTES:1)                           ".
   02 FILLER PIC X(80) VALUE "                   BY VALUE 1                                                   ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Switch to the squeezing phase                                               ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-STATE TO LNK-STATE OF LNK-STATE-PERMUTE                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""STATE-PERMUTE"" USING LNK-STATE-PERMUTE END-CALL                     ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE TO WS-STATE                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Squeeze out all the output blocks                                           ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-OUTPUT-IND                                                     ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL WS-OUTPUT-BYTE-LEN <= 0                                       ".
   02 FILLER PIC X(80) VALUE "       MOVE FUNCTION MIN(WS-OUTPUT-BYTE-LEN, WS-RATE-IN-BYTES) TO WS-BLOCK-SIZE ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-STATE(1:WS-BLOCK-SIZE)                                           ".
   02 FILLER PIC X(80) VALUE "         TO LNK-KECCAK-OUTPUT(WS-OUTPUT-IND:WS-BLOCK-SIZE)                      ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-OUTPUT-IND = WS-OUTPUT-IND + WS-BLOCK-SIZE END-COMPUTE        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-OUTPUT-BYTE-LEN = WS-OUTPUT-BYTE-LEN - WS-BLOCK-SIZE          ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF WS-OUTPUT-BYTE-LEN > 0                                                ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-STATE TO LNK-STATE OF LNK-STATE-PERMUTE                       ".
   02 FILLER PIC X(80) VALUE "          CALL ""STATE-PERMUTE"" USING LNK-STATE-PERMUTE END-CALL               ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE TO WS-STATE                       ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module that computes the Keccak-f[1600] permutation on the given state.      ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. STATE-PERMUTE.                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-ROUND                           BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-X                               BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-Y                               BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-Y-TMP                           BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-J                               BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-T                               BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-R                               BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-BIT-POSITION                    BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 LFSR-STATE                         PIC X.                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-C-TAB.                                                                   ".
   02 FILLER PIC X(80) VALUE "   02 WS-C                             PIC X(8) OCCURS 5.                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-D                               PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-CURRENT                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-TEMP                            PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-TMP-TAB.                                                                 ".
   02 FILLER PIC X(80) VALUE "   02 WS-TMP                           PIC X(8) OCCURS 5.                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-0                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-1                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-2                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-3                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-4                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-X                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-NUM REDEFINES WS-LANE-X BINARY-DOUBLE UNSIGNED.                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-2                           BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the READ-LANE module                                             ".
   02 FILLER PIC X(80) VALUE " 01 LNK-READ-LANE.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the WRITE-LANE module                                            ".
   02 FILLER PIC X(80) VALUE " 01 LNK-WRITE-LANE.                                                             ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the XOR-LANE module                                              ".
   02 FILLER PIC X(80) VALUE " 01 LNK-XOR-LANE.                                                               ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the ROL-LANE module                                              ".
   02 FILLER PIC X(80) VALUE " 01 LNK-ROL-LANE.                                                               ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OFFSET                       BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> linkage for the LFSR86540 module                                             ".
   02 FILLER PIC X(80) VALUE " 01 LNK-LFSR86540.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LFSR                         PIC X.                                   ".
   02 FILLER PIC X(80) VALUE "   02 LNK-RESULT                       BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-STATE-PERMUTE.                                                          ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-STATE-PERMUTE.                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-STATE-PERMUTE SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE X""01"" TO LFSR-STATE                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-ROUND FROM 0 BY 1 UNTIL WS-ROUND > 23                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Theta step (see [Keccak Reference, Section 2.3.2])                       ".
   02 FILLER PIC X(80) VALUE "       PERFORM STEP-THETA                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Rho and pi steps (see [Keccak Reference, Sections 2.3.3 and 2.3.4])      ".
   02 FILLER PIC X(80) VALUE "       PERFORM STEP-RHO-AND-PI                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Chi step (see [Keccak Reference, Section 2.3.1])                         ".
   02 FILLER PIC X(80) VALUE "       PERFORM STEP-CHI                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Iota step (see [Keccak Reference, Section 2.3.5])                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM STEP-IOTA                                                        ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-STATE-PERMUTE-EX.                                                         ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " STEP-THETA SECTION.                                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-C-TAB                                                         ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-D                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Compute the parity of the columns                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-X FROM 0 BY 1 UNTIL WS-X > 4                             ".
   02 FILLER PIC X(80) VALUE "       PERFORM READ-LANES                                                       ".
   02 FILLER PIC X(80) VALUE "       PERFORM XOR-LANES                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-LANE-4 TO WS-C(WS-X + 1)                                         ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-X FROM 0 BY 1 UNTIL WS-X > 4                             ".
   02 FILLER PIC X(80) VALUE "*>     Compute the theta effect for a given column                              ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-IND-1 = 1 + FUNCTION MOD(WS-X + 4, 5) END-COMPUTE             ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-C(WS-IND-1) TO WS-LANE-0                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-IND-1 = 1 + FUNCTION MOD(WS-X + 1, 5) END-COMPUTE             ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-C(WS-IND-1) TO LNK-LANE   OF LNK-ROL-LANE                        ".
   02 FILLER PIC X(80) VALUE "       MOVE 1              TO LNK-OFFSET OF LNK-ROL-LANE                        ".
   02 FILLER PIC X(80) VALUE "       CALL ""ROL-LANE"" USING LNK-ROL-LANE END-CALL                            ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-LANE OF LNK-ROL-LANE TO WS-LANE-1                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       CALL ""CBL_XOR"" USING WS-LANE-0 WS-LANE-1                               ".
   02 FILLER PIC X(80) VALUE "                        BY VALUE 8                                              ".
   02 FILLER PIC X(80) VALUE "       END-CALL                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-LANE-1 TO WS-D                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Add the theta effect to the whole column                                 ".
   02 FILLER PIC X(80) VALUE "       PERFORM VARYING WS-Y FROM 0 BY 1 UNTIL WS-Y > 4                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-X                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-X     OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-Y                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-Y     OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-D                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-LANE  OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          CALL ""XOR-LANE"" USING LNK-XOR-LANE END-CALL                         ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "       END-PERFORM                                                              ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " STEP-THETA-EX.                                                                 ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " READ-LANES SECTION.                                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE 0                                                                      ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-LANE-0                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE 1                                                                      ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-LANE-1                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE 2                                                                      ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-LANE-2                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE 3                                                                      ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-LANE-3                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE 4                                                                      ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-LANE-4                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " READ-LANES-EX.                                                                 ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " XOR-LANES SECTION.                                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-0 WS-LANE-1                                  ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-1 WS-LANE-2                                  ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-2 WS-LANE-3                                  ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-3 WS-LANE-4                                  ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " XOR-LANES-EX.                                                                  ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " STEP-RHO-AND-PI SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-CURRENT                                                       ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-TEMP                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Start at coordinates (1 0)                                                  ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-X                                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE 0 TO WS-Y                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-X                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-X     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-Y                                                                   ".
   02 FILLER PIC X(80) VALUE "      TO LNK-Y     OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE OF LNK-STATE-PERMUTE                                         ".
   02 FILLER PIC X(80) VALUE "      TO LNK-STATE OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "    CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                             ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE  OF LNK-READ-LANE                                             ".
   02 FILLER PIC X(80) VALUE "      TO WS-CURRENT                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Iterate over ((0 1)(2 3))^t * (1 0) for 0 = t = 23                          ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-T FROM 0 BY 1 UNTIL WS-T > 23                            ".
   02 FILLER PIC X(80) VALUE "*>     Compute the rotation constant r = (t+1)(t+2)/2                           ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-R = FUNCTION MOD(((WS-T + 1) * (WS-T + 2) / 2), 64)           ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Compute ((0 1)(2 3)) * (x y)                                             ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-Y-TMP = FUNCTION MOD((2 * WS-X + 3 * WS-Y), 5)                ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-Y     TO WS-X                                                    ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-Y-TMP TO WS-Y                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Swap current and state(x,y), and rotate                                  ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-X                                                                ".
   02 FILLER PIC X(80) VALUE "         TO LNK-X     OF LNK-READ-LANE                                          ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-Y                                                                ".
   02 FILLER PIC X(80) VALUE "         TO LNK-Y     OF LNK-READ-LANE                                          ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-STATE OF LNK-STATE-PERMUTE                                      ".
   02 FILLER PIC X(80) VALUE "         TO LNK-STATE OF LNK-READ-LANE                                          ".
   02 FILLER PIC X(80) VALUE "       CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                          ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-LANE  OF LNK-READ-LANE                                          ".
   02 FILLER PIC X(80) VALUE "         TO WS-TEMP                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-CURRENT TO LNK-LANE   OF LNK-ROL-LANE                            ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-R       TO LNK-OFFSET OF LNK-ROL-LANE                            ".
   02 FILLER PIC X(80) VALUE "       CALL ""ROL-LANE"" USING LNK-ROL-LANE END-CALL                            ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-LANE OF LNK-ROL-LANE TO WS-LANE-0                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-X                                                                ".
   02 FILLER PIC X(80) VALUE "         TO LNK-X     OF LNK-WRITE-LANE                                         ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-Y                                                                ".
   02 FILLER PIC X(80) VALUE "         TO LNK-Y     OF LNK-WRITE-LANE                                         ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-STATE OF LNK-STATE-PERMUTE                                      ".
   02 FILLER PIC X(80) VALUE "         TO LNK-STATE OF LNK-WRITE-LANE                                         ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-LANE-0                                                           ".
   02 FILLER PIC X(80) VALUE "         TO LNK-LANE  OF LNK-WRITE-LANE                                         ".
   02 FILLER PIC X(80) VALUE "       CALL ""WRITE-LANE"" USING LNK-WRITE-LANE END-CALL                        ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-STATE OF LNK-WRITE-LANE                                         ".
   02 FILLER PIC X(80) VALUE "         TO LNK-STATE OF LNK-STATE-PERMUTE                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE WS-TEMP TO WS-CURRENT                                               ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " STEP-RHO-AND-PI-EX.                                                            ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " STEP-CHI SECTION.                                                              ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE WS-TMP-TAB                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-Y FROM 0 BY 1 UNTIL WS-Y > 4                             ".
   02 FILLER PIC X(80) VALUE "*>     Take a copy of the plane                                                 ".
   02 FILLER PIC X(80) VALUE "       PERFORM VARYING WS-X FROM 0 BY 1 UNTIL WS-X > 4                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-X                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-X     OF LNK-READ-LANE                                       ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-Y                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-Y     OF LNK-READ-LANE                                       ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-READ-LANE                                       ".
   02 FILLER PIC X(80) VALUE "          CALL ""READ-LANE"" USING LNK-READ-LANE END-CALL                       ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-LANE  OF LNK-READ-LANE                                       ".
   02 FILLER PIC X(80) VALUE "            TO WS-TMP(WS-X + 1)                                                 ".
   02 FILLER PIC X(80) VALUE "       END-PERFORM                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>     Compute chi on the plane                                                 ".
   02 FILLER PIC X(80) VALUE "       PERFORM VARYING WS-X FROM 0 BY 1 UNTIL WS-X > 4                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-TMP(WS-X + 1) TO WS-LANE-0                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          COMPUTE WS-IND-1 = 1 + FUNCTION MOD(WS-X + 1, 5) END-COMPUTE          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-TMP(WS-IND-1) TO WS-LANE-1                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          CALL ""CBL_NOT"" USING WS-LANE-1                                      ".
   02 FILLER PIC X(80) VALUE "                         BY VALUE 8                                             ".
   02 FILLER PIC X(80) VALUE "          END-CALL                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          COMPUTE WS-IND-1 = 1 + FUNCTION MOD(WS-X + 2, 5) END-COMPUTE          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-TMP(WS-IND-1) TO WS-LANE-2                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          CALL ""CBL_AND"" USING WS-LANE-1 WS-LANE-2                            ".
   02 FILLER PIC X(80) VALUE "                           BY VALUE 8                                           ".
   02 FILLER PIC X(80) VALUE "          END-CALL                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          CALL ""CBL_XOR"" USING WS-LANE-0 WS-LANE-2                            ".
   02 FILLER PIC X(80) VALUE "                           BY VALUE 8                                           ".
   02 FILLER PIC X(80) VALUE "          END-CALL                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-X                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-X     OF LNK-WRITE-LANE                                      ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-Y                                                             ".
   02 FILLER PIC X(80) VALUE "            TO LNK-Y     OF LNK-WRITE-LANE                                      ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-WRITE-LANE                                      ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-LANE-2                                                        ".
   02 FILLER PIC X(80) VALUE "            TO LNK-LANE  OF LNK-WRITE-LANE                                      ".
   02 FILLER PIC X(80) VALUE "          CALL ""WRITE-LANE"" USING LNK-WRITE-LANE END-CALL                     ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-WRITE-LANE                                      ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "       END-PERFORM                                                              ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " STEP-CHI-EX.                                                                   ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " STEP-IOTA SECTION.                                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-J FROM 0 BY 1 UNTIL WS-J > 6                             ".
   02 FILLER PIC X(80) VALUE "*>     2^j-1                                                                    ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-BIT-POSITION = (2 ** WS-J) - 1 END-COMPUTE                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       INITIALIZE LNK-LFSR86540                                                 ".
   02 FILLER PIC X(80) VALUE "       MOVE LFSR-STATE                                                          ".
   02 FILLER PIC X(80) VALUE "         TO LNK-LFSR  OF LNK-LFSR86540                                          ".
   02 FILLER PIC X(80) VALUE "       CALL ""LFSR86540"" USING LNK-LFSR86540 END-CALL                          ".
   02 FILLER PIC X(80) VALUE "*>     save new LFSR-STATE                                                      ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-LFSR OF LNK-LFSR86540                                           ".
   02 FILLER PIC X(80) VALUE "         TO LFSR-STATE                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF LNK-RESULT OF LNK-LFSR86540 NOT = ZEROES                              ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          COMPUTE WS-LANE-NUM = 2 ** WS-BIT-POSITION END-COMPUTE                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE 0                                                                ".
   02 FILLER PIC X(80) VALUE "            TO LNK-X     OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE 0                                                                ".
   02 FILLER PIC X(80) VALUE "            TO LNK-Y     OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-LANE-X                                                        ".
   02 FILLER PIC X(80) VALUE "            TO LNK-LANE  OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "          CALL ""XOR-LANE"" USING LNK-XOR-LANE END-CALL                         ".
   02 FILLER PIC X(80) VALUE "          MOVE LNK-STATE OF LNK-XOR-LANE                                        ".
   02 FILLER PIC X(80) VALUE "            TO LNK-STATE OF LNK-STATE-PERMUTE                                   ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " STEP-IOTA-EX.                                                                  ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module to load a 64-bit value from STATE.                                    ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. READ-LANE.                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND                             BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE                            PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-R REDEFINES WS-LANE.                                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-LANE-1                        PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "   02 WS-LANE-2                        PIC X(192).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-READ-LANE.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-READ-LANE.                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-READ-LANE SECTION.                                                        ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-IND = (LNK-X + 5 * LNK-Y) * 8 + 1 END-COMPUTE                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE(WS-IND:8) TO WS-LANE                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-LANE(1:8)        TO LNK-LANE                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-READ-LANE-EX.                                                             ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE " END PROGRAM READ-LANE.                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module to write a 64-bit value in STATE.                                     ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. WRITE-LANE.                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND                             BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-WRITE-LANE.                                                             ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-WRITE-LANE.                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-WRITE-LANE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-IND = (LNK-X + 5 * LNK-Y) * 8 + 1 END-COMPUTE                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE TO LNK-STATE(WS-IND:8)                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-WRITE-LANE-EX.                                                            ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE " END PROGRAM WRITE-LANE.                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module to xor and write a 64-bit value in STATE.                             ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. XOR-LANE.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND                             BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-1                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-2                          PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-XOR-LANE.                                                               ".
   02 FILLER PIC X(80) VALUE "   02 LNK-X                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-Y                            BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "   02 LNK-STATE                        PIC X(200).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-XOR-LANE.                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-XOR-LANE SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE TO WS-LANE-1                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE WS-IND = (LNK-X + 5 * LNK-Y) * 8 + 1 END-COMPUTE                    ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-STATE(WS-IND:8) TO WS-LANE-2                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-1 WS-LANE-2                                  ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-LANE-2 TO LNK-STATE(WS-IND:8)                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-XOR-LANE-EX.                                                              ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE " END PROGRAM XOR-LANE.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module to rotate a 64-bit value.                                             ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. ROL-LANE.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND                             BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-X-1                        PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-9-1 REDEFINES WS-LANE-X-1  BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-X-2                        PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LANE-9-2 REDEFINES WS-LANE-X-2  BINARY-DOUBLE UNSIGNED.                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-ROL-LANE.                                                               ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LANE                         PIC X(8).                                ".
   02 FILLER PIC X(80) VALUE "   02 LNK-OFFSET                       BINARY-LONG UNSIGNED.                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-ROL-LANE.                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-ROL-LANE SECTION.                                                         ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF LNK-OFFSET = ZEROES                                                      ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "*>     nothing to do                                                            ".
   02 FILLER PIC X(80) VALUE "       GOBACK                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE TO WS-LANE-X-1                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LANE TO WS-LANE-X-2                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > LNK-OFFSET                ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-LANE-9-1 = WS-LANE-9-1 * 2 END-COMPUTE                        ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > (64 - LNK-OFFSET)         ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-LANE-9-2 = WS-LANE-9-2 / 2 END-COMPUTE                        ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_XOR"" USING WS-LANE-X-1 WS-LANE-X-2                              ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 8                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ". 
   02 FILLER PIC X(80) VALUE "    MOVE WS-LANE-X-2 TO LNK-LANE                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-ROL-LANE-EX.                                                              ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE " END PROGRAM ROL-LANE.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Module that computes the linear feedback shift register (LFSR) used to       ".
   02 FILLER PIC X(80) VALUE "*> define the round constants (see [Keccak Reference, Section 1.2]).            ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. LFSR86540.                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-LFSR-CHECK                      PIC X.                                   ".
   02 FILLER PIC X(80) VALUE " 01 WS-LFSR-WORK                       PIC X.                                   ".
   02 FILLER PIC X(80) VALUE " 01 WS-LFSR-WORK-BIN REDEFINES WS-LFSR-WORK BINARY-CHAR UNSIGNED.               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-LFSR86540.                                                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-LFSR                         PIC X.                                   ".
   02 FILLER PIC X(80) VALUE "   02 LNK-RESULT                       BINARY-LONG.                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-LFSR86540.                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " MAIN-LFSR86540 SECTION.                                                        ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LFSR TO WS-LFSR-CHECK                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LFSR TO WS-LFSR-WORK                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_AND"" USING X""01"" WS-LFSR-CHECK                                ".
   02 FILLER PIC X(80) VALUE "                     BY VALUE 1                                                 ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF WS-LFSR-CHECK NOT = X""00""                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE 1 TO LNK-RESULT                                                     ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE 0 TO LNK-RESULT                                                     ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-LFSR TO WS-LFSR-CHECK                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_AND"" USING X""80"" WS-LFSR-CHECK                                ".
   02 FILLER PIC X(80) VALUE "                   BY VALUE 1                                                   ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF WS-LFSR-CHECK NOT = X""00""                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "*>     Primitive polynomial over GF(2): x^8+x^6+x^5+x^4+1                       ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-LFSR-WORK-BIN = WS-LFSR-WORK-BIN * 2 END-COMPUTE              ".
   02 FILLER PIC X(80) VALUE "       CALL ""CBL_XOR"" USING X""71"" WS-LFSR-WORK-BIN                          ".
   02 FILLER PIC X(80) VALUE "                        BY VALUE 1                                              ".
   02 FILLER PIC X(80) VALUE "       END-CALL                                                                 ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE WS-LFSR-WORK-BIN = WS-LFSR-WORK-BIN * 2 END-COMPUTE              ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE WS-LFSR-WORK TO LNK-LFSR                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK                                                                      ".
   02 FILLER PIC X(80) VALUE "    .                                                                           ".
   02 FILLER PIC X(80) VALUE " MAIN-LFSR86540-EX.                                                             ".
   02 FILLER PIC X(80) VALUE "    EXIT.                                                                       ".
   02 FILLER PIC X(80) VALUE " END PROGRAM LFSR86540.                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM STATE-PERMUTE.                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-KECCAK.                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-SHA3-512.                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-SESSION-ID.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
                                                                                                              
   01 WS-HTM2COB-SESSION-ID-R REDEFINES WS-HTM2COB-SESSION-ID.                                                        
   02 WS-HTM2COB-SESSION-ID-LINES OCCURS C-HTM2COB-SESSION-ID-MAX-LINE TIMES.                                       
     03 WS-HTM2COB-SESSION-ID-LINE     PIC X(80).                                                             
