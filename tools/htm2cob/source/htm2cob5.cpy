*> Program HTM2COB-SPEC-CHARS template
 01 C-HTM2COB-SPEC-CHARS-MAX-LINE      CONSTANT AS 235.

 01 WS-HTM2COB-SPEC-CHARS.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SPEC-CHARS.cob is free software: you can redistribute it and/or     ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-SPEC-CHARS.cob is distributed in the hope that it will be useful,   ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-HTML-SPEC-CHARS.cob.                                     ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-SPEC-CHARS.cob                                         ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Replace HTML special chars                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               HTM2COB-SPEC-CHARS USING <field-in> <field-out>                ".
   02 FILLER PIC X(80) VALUE "*>               Fields in HTM2COB-SPEC-CHARS linkage:                          ".
   02 FILLER PIC X(80) VALUE "*>                 <field-in>  - input                                          ".
   02 FILLER PIC X(80) VALUE "*>                 <field-out> - output                                         ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-SPEC-CHARS.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE " 01 WS-CONTROLCHAR-FLAG                PIC X(1).                                ".
   02 FILLER PIC X(80) VALUE "    88 V-YES       VALUE X""00"", X""01"", X""02"", X""03"", X""04"", X""05"",  ".
   02 FILLER PIC X(80) VALUE "                         X""06"", X""07"", X""08"", X""09"", X""0A"", X""0B"",  ".
   02 FILLER PIC X(80) VALUE "                         X""0C"", X""0D"", X""0E"", X""0F"", X""10"", X""11"",  ".
   02 FILLER PIC X(80) VALUE "                         X""12"", X""13"", X""14"", X""15"", X""16"", X""17"",  ".
   02 FILLER PIC X(80) VALUE "                         X""18"", X""19"", X""1A"", X""1B"", X""1C"", X""1D"",  ".
   02 FILLER PIC X(80) VALUE "                         X""1E"", X""1F"", X""7F"".                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 78 HTM2COB-LF                         VALUE X""0A"".                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-ERROR-FLAG                      PIC 9.                                   ".
   02 FILLER PIC X(80) VALUE "    88 V-ERROR-NO                      VALUE 0.                                 ".
   02 FILLER PIC X(80) VALUE "    88 V-ERROR-YES                     VALUE 1.                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-LEN-IN                          PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-LEN-OUT                         PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-1                           PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE " 01 WS-IND-2                           PIC 9(9) COMP.                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DISP                            PIC 9(9).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-SPEC-CHARS-FIELD-IN    PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-SPEC-CHARS-FIELD-OUT   PIC X ANY LENGTH.                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-SPEC-CHARS-FIELD-IN                       ".
   02 FILLER PIC X(80) VALUE "                          LNK-HTM2COB-SPEC-CHARS-FIELD-OUT.                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-SPEC-CHARS-MAIN SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION STORED-CHAR-LENGTH(LNK-HTM2COB-SPEC-CHARS-FIELD-IN)           ".
   02 FILLER PIC X(80) VALUE "      TO WS-LEN-IN                                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION LENGTH(LNK-HTM2COB-SPEC-CHARS-FIELD-OUT) TO WS-LEN-OUT        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SPEC-CHARS-FIELD-OUT                                 ".
   02 FILLER PIC X(80) VALUE "    SET V-ERROR-NO OF WS-ERROR-FLAG TO TRUE                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO WS-IND-2                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM VARYING WS-IND-1 FROM 1 BY 1                                        ".
   02 FILLER PIC X(80) VALUE "      UNTIL WS-IND-1 > WS-LEN-IN                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) TO WS-CONTROLCHAR-FLAG  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       EVALUATE TRUE                                                            ".
   02 FILLER PIC X(80) VALUE "*>         double quote: ""                                                     ".
   02 FILLER PIC X(80) VALUE "           WHEN LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) = X""22""           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 6 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""&"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""q"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""u"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""o"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""t"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE "";"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "*>         ampersand: &                                                         ".
   02 FILLER PIC X(80) VALUE "           WHEN LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) = X""26""           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 5 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""&"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""a"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""m"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""p"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE "";"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "*>         single quote: '                                                      ".
   02 FILLER PIC X(80) VALUE "           WHEN LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) = X""27""           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 6 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""&"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""#"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""0"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""3"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""9"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE "";"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "*>         less than: <                                                         ".
   02 FILLER PIC X(80) VALUE "           WHEN LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) = X""3C""           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 4 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""&"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""l"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""t"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE "";"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "*>         greater than: >                                                      ".
   02 FILLER PIC X(80) VALUE "           WHEN LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1) = X""3E""           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 4 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""&"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""g"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""t"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                 MOVE "";"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "*>         control characters                                                   ".
   02 FILLER PIC X(80) VALUE "           WHEN V-YES OF WS-CONTROLCHAR-FLAG                                    ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 1 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "*>               replace with X                                                 ".
   02 FILLER PIC X(80) VALUE "                 MOVE ""X"" TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)     ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "           WHEN OTHER                                                           ".
   02 FILLER PIC X(80) VALUE "              IF WS-IND-2 + 1 <= WS-LEN-OUT                                     ".
   02 FILLER PIC X(80) VALUE "              THEN                                                              ".
   02 FILLER PIC X(80) VALUE "                 MOVE LNK-HTM2COB-SPEC-CHARS-FIELD-IN(WS-IND-1:1)               ".
   02 FILLER PIC X(80) VALUE "                   TO LNK-HTM2COB-SPEC-CHARS-FIELD-OUT(WS-IND-2:1)              ".
   02 FILLER PIC X(80) VALUE "                 ADD 1 TO WS-IND-2 END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "              ELSE                                                              ".
   02 FILLER PIC X(80) VALUE "                 SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE                       ".
   02 FILLER PIC X(80) VALUE "                 EXIT PERFORM                                                   ".
   02 FILLER PIC X(80) VALUE "              END-IF                                                            ".
   02 FILLER PIC X(80) VALUE "       END-EVALUATE                                                             ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-ERROR-YES OF WS-ERROR-FLAG                                             ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error in HTM2COB-SPEC-CHARS"" END-DISPLAY                   ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-LEN-IN  TO WS-DISP                                            ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""WS-LEN-IN: "" WS-DISP  END-DISPLAY                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-LEN-OUT TO WS-DISP                                            ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""WS-LEN-OUT: "" WS-DISP END-DISPLAY                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-IND-1   TO WS-DISP                                            ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""WS-IND-1: "" WS-DISP   END-DISPLAY                          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-IND-2   TO WS-DISP                                            ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""WS-IND-2: "" WS-DISP   END-DISPLAY                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
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
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-SPEC-CHARS.                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".

 01 WS-HTM2COB-SPEC-CHARS-R REDEFINES WS-HTM2COB-SPEC-CHARS.
   02 WS-HTM2COB-SPEC-CHARS-LINES OCCURS C-HTM2COB-SPEC-CHARS-MAX-LINE TIMES.
     03 WS-HTM2COB-SPEC-CHARS-LINE     PIC X(80).
