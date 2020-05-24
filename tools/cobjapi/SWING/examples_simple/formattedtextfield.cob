*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  formattedtextfield.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  formattedtextfield.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with formattedtextfield.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      formattedtextfield.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.05.10
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free formattedtextfield.cob cobjapi.o \
*>                                                    japilib.o \
*>                                                    imageio.o \
*>                                                    fileselect.o
*>
*> Usage:        ./formattedtextfield.exe
*>
*> The following table shows the characters that you can use in the formatting
*> mask.
*>
*> Char:  Description:
*> #      - Any valid number.
*> '      - (single quote) Escape character, used to escape any of the special 
*>          formatting characters.
*> U      - Any character. All lowercase letters are mapped to uppercase.
*> L      - Any character. All uppercase letters are mapped to lowercase.
*> A      - Any character or number.
*> ?      - Any character.
*> *      - Anything.
*> H      - Any hex character (0-9, a-f or A-F).
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.05.10 Laszlo Erdos: 
*>            - textfield.cob converted into formattedtextfield.cob. 
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. formattedtextfield.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC
    COPY "CobjapiFunctions.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 COPY "CobjapiConstants.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-FTEXTFIELD-1                    BINARY-LONG.
 01 WS-FTEXTFIELD-2                    BINARY-LONG.
 01 WS-FTEXTFIELD-3                    BINARY-LONG.
 01 WS-FTEXTFIELD-4                    BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-COLUMNS                         BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-CONTENT                         PIC X(256).
 01 WS-MASK-STR                        PIC X(30).
 01 WS-PLACE-HOLDER-CHAR               PIC X(1).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FORMATTEDTEXTFIELD SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  Generate GUI Objects    
    MOVE J-FRAME("Formatted text field") TO WS-FRAME  

*>  number mask, with column = 0 will be resized to the length of mask
    MOVE "###.###,##" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 0 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-FRAME, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) 
      TO WS-FTEXTFIELD-1

*>  number mask, with column > the length of mask, it keeps the length 20
    MOVE "###.###,##" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 20 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-FRAME, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) 
      TO WS-FTEXTFIELD-2

*>  Any character, all lowercase letters are mapped to uppercase, without palec holder char
    MOVE "UUUUUUUUUUUUUUUUUUUUUUUUU" TO WS-MASK-STR         
    MOVE " " TO WS-PLACE-HOLDER-CHAR
    MOVE 25 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-FRAME, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) 
      TO WS-FTEXTFIELD-3

*>  Any hex character (0-9, a-f or A-F), with palec holder char
    MOVE "HHHHHHHHHHHHHHHHHHHH" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 0 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-FRAME, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) 
      TO WS-FTEXTFIELD-4

    MOVE 10 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-FTEXTFIELD-1, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE J-LABEL(WS-FRAME, "Mask: ###.###,##  Placeholder char: _  Col: 0") TO WS-LABEL
    MOVE 250 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)         TO WS-RET

    MOVE 10 TO WS-XPOS
    MOVE 80 TO WS-YPOS
    MOVE J-SETPOS(WS-FTEXTFIELD-2, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE J-LABEL(WS-FRAME, "Mask: ###.###,##  Placeholder char: _  Col: 20") TO WS-LABEL
    MOVE 250 TO WS-XPOS
    MOVE 80 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)         TO WS-RET

    MOVE 10 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-FTEXTFIELD-3, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE J-LABEL(WS-FRAME, "Mask: UUUUUUUUUUUUUUUUUUUUUUUUU  Placeholder char:     Col: 25") TO WS-LABEL
    MOVE 250 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)         TO WS-RET

    MOVE 10 TO WS-XPOS
    MOVE 160 TO WS-YPOS
    MOVE J-SETPOS(WS-FTEXTFIELD-4, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE J-LABEL(WS-FRAME, "Mask: HHHHHHHHHHHHHHHHHHHH  Placeholder char: _   Col: 0") TO WS-LABEL
    MOVE 250 TO WS-XPOS
    MOVE 160 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)         TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
*>     press enter after you edited the field
       IF WS-OBJ = WS-FTEXTFIELD-1
       THEN
          MOVE J-GETTEXT(WS-FTEXTFIELD-1, WS-CONTENT) TO WS-RET
          DISPLAY "Text-1: " TRIM(WS-CONTENT) END-DISPLAY
       END-IF

*>     press enter after you edited the field
       IF WS-OBJ = WS-FTEXTFIELD-2
       THEN
          MOVE J-GETTEXT(WS-FTEXTFIELD-2, WS-CONTENT) TO WS-RET
          DISPLAY "Text-2: " TRIM(WS-CONTENT) END-DISPLAY
       END-IF

*>     press enter after you edited the field
       IF WS-OBJ = WS-FTEXTFIELD-3
       THEN
          MOVE J-GETTEXT(WS-FTEXTFIELD-3, WS-CONTENT) TO WS-RET
          DISPLAY "Text-3: " TRIM(WS-CONTENT) END-DISPLAY
       END-IF

*>     press enter after you edited the field
       IF WS-OBJ = WS-FTEXTFIELD-4
       THEN
          MOVE J-GETTEXT(WS-FTEXTFIELD-4, WS-CONTENT) TO WS-RET
          DISPLAY "Text-4: " TRIM(WS-CONTENT) END-DISPLAY
       END-IF

       IF WS-CONTENT = "exit"
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FORMATTEDTEXTFIELD-EX.
    EXIT.
 END PROGRAM formattedtextfield.
