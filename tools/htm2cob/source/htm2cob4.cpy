*> Program HTM2COB-DECODE template
 01 C-HTM2COB-DECODE-MAX-LINE              CONSTANT AS 347.

 01 WS-HTM2COB-DECODE.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*>  This file is part of htm2cob.                                               ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-DECODE.cob is free software: you can redistribute it and/or         ".
   02 FILLER PIC X(80) VALUE "*>  modify it under the terms of the GNU Lesser General Public License as       ".
   02 FILLER PIC X(80) VALUE "*>  published by the Free Software Foundation, either version 3 of the License, ".
   02 FILLER PIC X(80) VALUE "*>  or (at your option) any later version.                                      ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  HTM2COB-DECODE.cob is distributed in the hope that it will be useful,       ".
   02 FILLER PIC X(80) VALUE "*>  but WITHOUT ANY WARRANTY; without even the implied warranty of              ".
   02 FILLER PIC X(80) VALUE "*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                        ".
   02 FILLER PIC X(80) VALUE "*>  See the GNU Lesser General Public License for more details.                 ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*>  You should have received a copy of the GNU Lesser General Public License    ".
   02 FILLER PIC X(80) VALUE "*>  along with HTM2COB-DECODE.cob.                                              ".
   02 FILLER PIC X(80) VALUE "*>  If not, see <http://www.gnu.org/licenses/>.                                 ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "*> Program:      HTM2COB-DECODE.cob                                             ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Purpose:      Decode UTF-8 chars                                             ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee                ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Date-Written: 2019.05.01                                                     ".
   02 FILLER PIC X(80) VALUE "*>                                                                              ".
   02 FILLER PIC X(80) VALUE "*> Usage:        To use this module, simply CALL it as follows:                 ".
   02 FILLER PIC X(80) VALUE "*>               HTM2COB-DECODE USING <UTF8-string> <UTF8-value>                ".
   02 FILLER PIC X(80) VALUE "*>               Fields in HTM2COB-DECODE linkage:                              ".
   02 FILLER PIC X(80) VALUE "*>                 <UTF8-string>  - input                                       ".
   02 FILLER PIC X(80) VALUE "*>                 <UTF8-value>   - output                                      ".
   02 FILLER PIC X(80) VALUE "*>******************************************************************************".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " IDENTIFICATION DIVISION.                                                       ".
   02 FILLER PIC X(80) VALUE " PROGRAM-ID. HTM2COB-DECODE.                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " ENVIRONMENT DIVISION.                                                          ".
   02 FILLER PIC X(80) VALUE " DATA DIVISION.                                                                 ".
   02 FILLER PIC X(80) VALUE " WORKING-STORAGE SECTION.                                                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DECODE-TABLE.                                                            ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%00"" & X""00"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%01"" & X""01"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%02"" & X""02"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%03"" & X""03"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%04"" & X""04"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%05"" & X""05"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%06"" & X""06"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%07"" & X""07"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%08"" & X""08"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%09"" & X""09"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0A"" & X""0A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0B"" & X""0B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0C"" & X""0C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0D"" & X""0D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0E"" & X""0E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%0F"" & X""0F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%10"" & X""10"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%11"" & X""11"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%12"" & X""12"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%13"" & X""13"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%14"" & X""14"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%15"" & X""15"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%16"" & X""16"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%17"" & X""17"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%18"" & X""18"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%19"" & X""19"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1A"" & X""1A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1B"" & X""1B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1C"" & X""1C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1D"" & X""1D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1E"" & X""1E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%1F"" & X""1F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%20"" & X""20"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%21"" & X""21"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%22"" & X""22"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%23"" & X""23"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%24"" & X""24"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%25"" & X""25"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%26"" & X""26"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%27"" & X""27"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%28"" & X""28"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%29"" & X""29"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2A"" & X""2A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2B"" & X""2B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2C"" & X""2C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2D"" & X""2D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2E"" & X""2E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%2F"" & X""2F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%30"" & X""30"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%31"" & X""31"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%32"" & X""32"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%33"" & X""33"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%34"" & X""34"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%35"" & X""35"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%36"" & X""36"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%37"" & X""37"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%38"" & X""38"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%39"" & X""39"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3A"" & X""3A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3B"" & X""3B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3C"" & X""3C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3D"" & X""3D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3E"" & X""3E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%3F"" & X""3F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%40"" & X""40"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%41"" & X""41"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%42"" & X""42"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%43"" & X""43"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%44"" & X""44"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%45"" & X""45"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%46"" & X""46"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%47"" & X""47"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%48"" & X""48"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%49"" & X""49"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4A"" & X""4A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4B"" & X""4B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4C"" & X""4C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4D"" & X""4D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4E"" & X""4E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%4F"" & X""4F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%50"" & X""50"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%51"" & X""51"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%52"" & X""52"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%53"" & X""53"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%54"" & X""54"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%55"" & X""55"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%56"" & X""56"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%57"" & X""57"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%58"" & X""58"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%59"" & X""59"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5A"" & X""5A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5B"" & X""5B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5C"" & X""5C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5D"" & X""5D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5E"" & X""5E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%5F"" & X""5F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%60"" & X""60"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%61"" & X""61"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%62"" & X""62"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%63"" & X""63"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%64"" & X""64"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%65"" & X""65"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%66"" & X""66"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%67"" & X""67"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%68"" & X""68"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%69"" & X""69"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6A"" & X""6A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6B"" & X""6B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6C"" & X""6C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6D"" & X""6D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6E"" & X""6E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%6F"" & X""6F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%70"" & X""70"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%71"" & X""71"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%72"" & X""72"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%73"" & X""73"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%74"" & X""74"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%75"" & X""75"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%76"" & X""76"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%77"" & X""77"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%78"" & X""78"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%79"" & X""79"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7A"" & X""7A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7B"" & X""7B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7C"" & X""7C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7D"" & X""7D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7E"" & X""7E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%7F"" & X""7F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%80"" & X""80"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%81"" & X""81"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%82"" & X""82"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%83"" & X""83"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%84"" & X""84"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%85"" & X""85"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%86"" & X""86"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%87"" & X""87"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%88"" & X""88"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%89"" & X""89"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8A"" & X""8A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8B"" & X""8B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8C"" & X""8C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8D"" & X""8D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8E"" & X""8E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%8F"" & X""8F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%90"" & X""90"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%91"" & X""91"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%92"" & X""92"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%93"" & X""93"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%94"" & X""94"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%95"" & X""95"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%96"" & X""96"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%97"" & X""97"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%98"" & X""98"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%99"" & X""99"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9A"" & X""9A"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9B"" & X""9B"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9C"" & X""9C"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9D"" & X""9D"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9E"" & X""9E"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%9F"" & X""9F"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A0"" & X""A0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A1"" & X""A1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A2"" & X""A2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A3"" & X""A3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A4"" & X""A4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A5"" & X""A5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A6"" & X""A6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A7"" & X""A7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A8"" & X""A8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%A9"" & X""A9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AA"" & X""AA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AB"" & X""AB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AC"" & X""AC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AD"" & X""AD"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AE"" & X""AE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%AF"" & X""AF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B0"" & X""B0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B1"" & X""B1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B2"" & X""B2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B3"" & X""B3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B4"" & X""B4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B5"" & X""B5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B6"" & X""B6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B7"" & X""B7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B8"" & X""B8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%B9"" & X""B9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BA"" & X""BA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BB"" & X""BB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BC"" & X""BC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BD"" & X""BD"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BE"" & X""BE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%BF"" & X""BF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C0"" & X""C0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C1"" & X""C1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C2"" & X""C2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C3"" & X""C3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C4"" & X""C4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C5"" & X""C5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C6"" & X""C6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C7"" & X""C7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C8"" & X""C8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%C9"" & X""C9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CA"" & X""CA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CB"" & X""CB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CC"" & X""CC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CD"" & X""CD"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CE"" & X""CE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%CF"" & X""CF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D0"" & X""D0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D1"" & X""D1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D2"" & X""D2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D3"" & X""D3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D4"" & X""D4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D5"" & X""D5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D6"" & X""D6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D7"" & X""D7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D8"" & X""D8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%D9"" & X""D9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DA"" & X""DA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DB"" & X""DB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DC"" & X""DC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DD"" & X""DD"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DE"" & X""DE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%DF"" & X""DF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E0"" & X""E0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E1"" & X""E1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E2"" & X""E2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E3"" & X""E3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E4"" & X""E4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E5"" & X""E5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E6"" & X""E6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E7"" & X""E7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E8"" & X""E8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%E9"" & X""E9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%EA"" & X""EA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%EB"" & X""EB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%EC"" & X""EC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%ED"" & X""ED"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%EE"" & X""EE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%EF"" & X""EF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F0"" & X""F0"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F1"" & X""F1"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F2"" & X""F2"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F3"" & X""F3"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F4"" & X""F4"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F5"" & X""F5"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F6"" & X""F6"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F7"" & X""F7"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F8"" & X""F8"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%F9"" & X""F9"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FA"" & X""FA"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FB"" & X""FB"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FC"" & X""FC"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FD"" & X""FD"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FE"" & X""FE"".        ".
   02 FILLER PIC X(80) VALUE "   02 FILLER                           PIC X(4) VALUE ""%FF"" & X""FF"".        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " 01 WS-DECODE-TAB REDEFINES WS-DECODE-TABLE.                                    ".
   02 FILLER PIC X(80) VALUE "   02 WS-DECODE-TAB-LINE               OCCURS 256 TIMES                         ".
   02 FILLER PIC X(80) VALUE "                                       ASCENDING KEY IS WS-DECODE-TAB-UTF8-STR  ".
   02 FILLER PIC X(80) VALUE "                                       INDEXED BY WS-DECODE-TAB-INDEX.          ".
   02 FILLER PIC X(80) VALUE "     03 WS-DECODE-TAB-UTF8-STR         PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "     03 WS-DECODE-TAB-UTF8-VAL         PIC X(1).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " LINKAGE SECTION.                                                               ".
   02 FILLER PIC X(80) VALUE " 01 LNK-HTM2COB-DECODE.                                                         ".
   02 FILLER PIC X(80) VALUE "   02 LNK-UTF8-STR                     PIC X(3).                                ".
   02 FILLER PIC X(80) VALUE "   02 LNK-UTF8-VAL                     PIC X(1).                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " PROCEDURE DIVISION USING LNK-HTM2COB-DECODE.                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " HTM2COB-DECODE-MAIN SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET WS-DECODE-TAB-INDEX TO 1                                                ".
   02 FILLER PIC X(80) VALUE "    SEARCH ALL WS-DECODE-TAB-LINE                                               ".
   02 FILLER PIC X(80) VALUE "       AT END                                                                   ".
   02 FILLER PIC X(80) VALUE "          *> not found --> gives space back                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE X""20""                                                          ".
   02 FILLER PIC X(80) VALUE "            TO LNK-UTF8-VAL                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       WHEN WS-DECODE-TAB-UTF8-STR(WS-DECODE-TAB-INDEX) = LNK-UTF8-STR          ".
   02 FILLER PIC X(80) VALUE "          MOVE WS-DECODE-TAB-UTF8-VAL(WS-DECODE-TAB-INDEX)                      ".
   02 FILLER PIC X(80) VALUE "            TO LNK-UTF8-VAL                                                     ".
   02 FILLER PIC X(80) VALUE "    END-SEARCH                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    GOBACK .                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE " END PROGRAM HTM2COB-DECODE.                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   
 01 WS-HTM2COB-DECODE-R REDEFINES WS-HTM2COB-DECODE.
   02 WS-HTM2COB-DECODE-LINES OCCURS C-HTM2COB-DECODE-MAX-LINE TIMES.
     03 WS-HTM2COB-DECODE-LINE             PIC X(80).
