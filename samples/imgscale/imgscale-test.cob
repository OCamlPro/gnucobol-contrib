*>******************************************************************************
*>  imgscale-test.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  imgscale-test.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with imgscale-test.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      imgscale-test.cob
*>
*> Purpose:      Test program for imgscale.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-02-22
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-02-22 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. imgscale-test.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 
 01 WS-IMG-IN                          PIC X(256). 
 01 WS-IMG-IN-TYPE                     BINARY-LONG. 
    88 V-BMP                           VALUE 0. 
    88 V-GIF                           VALUE 1. 
    88 V-JPG                           VALUE 2. 
    88 V-PNG                           VALUE 3. 
    88 V-TIF                           VALUE 4. 

 01 WS-IMG-OUT                         PIC X(256). 
 01 WS-IMG-OUT-TYPE                    BINARY-LONG. 
    88 V-BMP                           VALUE 0. 
    88 V-GIF                           VALUE 1. 
    88 V-JPG                           VALUE 2. 
    88 V-PNG                           VALUE 3. 
    88 V-TIF                           VALUE 4. 
 01 WS-WIDTH-OUT                       BINARY-LONG. 

 01 WS-RETVAL                          BINARY-LONG. 
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-IMGSCALE-TEST SECTION.
*>------------------------------------------------------------------------------

    MOVE SPACES TO WS-IMG-IN
    STRING "rainbow.jpg" X"00" DELIMITED BY SIZE
      INTO WS-IMG-IN 
    END-STRING
    SET V-JPG OF WS-IMG-IN-TYPE TO TRUE

*>  scale width    
    MOVE 400 TO WS-WIDTH-OUT

*>  convert in BMP    
    MOVE SPACES TO WS-IMG-OUT
    STRING "rainbow_400.bmp" X"00" DELIMITED BY SIZE
      INTO WS-IMG-OUT 
    END-STRING
    SET V-BMP OF WS-IMG-OUT-TYPE TO TRUE

    PERFORM CONVERT-AND-SCALE-IMG

    DISPLAY "WS-RETVAL: " WS-RETVAL END-DISPLAY

*>  convert in GIF    
    MOVE SPACES TO WS-IMG-OUT
    STRING "rainbow_400.gif" X"00" DELIMITED BY SIZE
      INTO WS-IMG-OUT 
    END-STRING
    SET V-GIF OF WS-IMG-OUT-TYPE TO TRUE

    PERFORM CONVERT-AND-SCALE-IMG

    DISPLAY "WS-RETVAL: " WS-RETVAL END-DISPLAY

*>  convert in JPG    
    MOVE SPACES TO WS-IMG-OUT
    STRING "rainbow_400.jpg" X"00" DELIMITED BY SIZE
      INTO WS-IMG-OUT 
    END-STRING
    SET V-JPG OF WS-IMG-OUT-TYPE TO TRUE

    PERFORM CONVERT-AND-SCALE-IMG

    DISPLAY "WS-RETVAL: " WS-RETVAL END-DISPLAY

*>  convert in PNG    
    MOVE SPACES TO WS-IMG-OUT
    STRING "rainbow_400.png" X"00" DELIMITED BY SIZE
      INTO WS-IMG-OUT 
    END-STRING
    SET V-PNG OF WS-IMG-OUT-TYPE TO TRUE

    PERFORM CONVERT-AND-SCALE-IMG

    DISPLAY "WS-RETVAL: " WS-RETVAL END-DISPLAY

*>  convert in TIFF    
    MOVE SPACES TO WS-IMG-OUT
    STRING "rainbow_400.tiff" X"00" DELIMITED BY SIZE
      INTO WS-IMG-OUT 
    END-STRING
    SET V-TIF OF WS-IMG-OUT-TYPE TO TRUE

    PERFORM CONVERT-AND-SCALE-IMG

    DISPLAY "WS-RETVAL: " WS-RETVAL END-DISPLAY
    
    STOP RUN
    .

*>------------------------------------------------------------------------------
 CONVERT-AND-SCALE-IMG SECTION.
*>------------------------------------------------------------------------------

    CALL "imgscale" USING BY REFERENCE WS-IMG-IN
                        , BY REFERENCE WS-IMG-IN-TYPE
                        , BY REFERENCE WS-IMG-OUT
                        , BY REFERENCE WS-IMG-OUT-TYPE
                        , BY REFERENCE WS-WIDTH-OUT
         RETURNING WS-RETVAL
    END-CALL
    
    EXIT SECTION
    .
    
 END PROGRAM imgscale-test.
