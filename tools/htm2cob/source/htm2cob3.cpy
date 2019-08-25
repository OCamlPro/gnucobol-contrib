*> Program HTM2COB-ENV template
 01 C-HTM2COB-ENV-MAX-LINE                 CONSTANT AS 67.

 01 WS-HTM2COB-ENV.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-ENV.cob is free software: you can redistribute it and/or            ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-ENV.cob is distributed in the hope that it will be useful,          ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-ENV.cob.                                                 ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-ENV.cob                                                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Get cgi environment variables                                  ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               HTM2COB-ENV USING <env-name> <env-value>                       ".
   02 FILLER PIC X(80) VALUE "*>               Fields in HTM2COB-ENV linkage:                                 ".
   02 FILLER PIC X(80) VALUE "*>                 <env-name>  - input                                          ".
   02 FILLER PIC X(80) VALUE "*>                 <env-value> - output                                         ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-ENV.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-ENV-NAME                        PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE " 01 WS-ENV-VALUE                       PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-ENV.                                                            ".
   02 FILLER PIC X(80) VALUE "   02 LNK-ENV-NAME                     PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "   02 LNK-ENV-VALUE                    PIC X(256).                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-ENV.                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-ENV-MAIN SECTION.                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-ENV-VALUE                                                    ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION TRIM(LNK-ENV-NAME) TO WS-ENV-NAME                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    ACCEPT WS-ENV-VALUE FROM ENVIRONMENT                                        ".
   02 FILLER PIC X(80) VALUE "           WS-ENV-NAME                                                          ".
   02 FILLER PIC X(80) VALUE "    END-ACCEPT                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION TRIM(WS-ENV-VALUE) TO LNK-ENV-VALUE                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-ENV.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
     
 01 WS-HTM2COB-ENV-R REDEFINES WS-HTM2COB-ENV.
   02 WS-HTM2COB-ENV-LINES OCCURS C-HTM2COB-ENV-MAX-LINE TIMES.
     03 WS-HTM2COB-ENV-LINE                PIC X(80).
