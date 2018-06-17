*>******************************************************************************
*>  imgcaptcha-test.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  imgcaptcha-test.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with imgcaptcha-test.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      imgcaptcha-test.cob
*>
*> Purpose:      Test program for imgcaptcha.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-06-17
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-06-17 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. imgcaptcha-test.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 
 01 WS-CAPTCHA-FILE-NAME               PIC X(256).
 01 WS-CAPTCHA-CHAR-TYPE               BINARY-LONG.
    88 V-NUMBERS                       VALUE 0. 
    88 V-UPPERCASE-LETTERS             VALUE 1. 
    88 V-LOWERCASE-LETTERS             VALUE 2. 
    88 V-LETTERS                       VALUE 3. 
    88 V-LETTERS-NUMBERS               VALUE 4. 
    88 V-UPPERCASE-LETTERS-NUMBERS     VALUE 5. 
    88 V-LOWERCASE-LETTERS-NUMBERS     VALUE 6. 
 01 WS-CAPTCHA-TEXT                    PIC X(6). 

 01 WS-RETVAL                          BINARY-LONG. 
 
 01 WS-IND                             PIC 9(2).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-IMGCAPTCHA-TEST SECTION.
*>------------------------------------------------------------------------------

*>  numbers
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-NUMBERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha0" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM

*>  uppercase letters
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-UPPERCASE-LETTERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha1" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM

*>  lowercase letters
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-LOWERCASE-LETTERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha2" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM
    
*>  letters
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-LETTERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha3" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM
    
*>  letters numbers
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-LETTERS-NUMBERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha4" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM

*>  uppercase letters numbers
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-UPPERCASE-LETTERS-NUMBERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha5" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM

*>  lowercase letters numbers
    DISPLAY " " END-DISPLAY
    PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 10
       SET V-LOWERCASE-LETTERS-NUMBERS OF WS-CAPTCHA-CHAR-TYPE TO TRUE
       MOVE SPACES TO WS-CAPTCHA-FILE-NAME
       STRING "captcha6" WS-IND ".png" X"00" DELIMITED BY SIZE
         INTO WS-CAPTCHA-FILE-NAME 
       END-STRING
       MOVE ALL X"00" TO WS-CAPTCHA-TEXT
       
       PERFORM CREATE-IMG-CAPTCHA
     
       DISPLAY "Retval: " WS-RETVAL 
               ", File: " WS-CAPTCHA-FILE-NAME(1:14) 
               ", Text: " WS-CAPTCHA-TEXT 
       END-DISPLAY
    END-PERFORM
    
    STOP RUN
    .

*>------------------------------------------------------------------------------
 CREATE-IMG-CAPTCHA SECTION.
*>------------------------------------------------------------------------------

    CALL "imgcaptcha" USING BY REFERENCE WS-CAPTCHA-FILE-NAME
                          , BY REFERENCE WS-CAPTCHA-CHAR-TYPE  
                          , BY REFERENCE WS-CAPTCHA-TEXT
         RETURNING WS-RETVAL
    END-CALL
    
    EXIT SECTION
    .
    
 END PROGRAM imgcaptcha-test.
