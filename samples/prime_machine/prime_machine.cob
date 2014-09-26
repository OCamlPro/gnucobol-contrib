*>******************************************************************************
*> Program:      prime_machine.cob
*>
*> Purpose:      This example implements Conway's prime algorithm
*>               as a state machine: http://en.wikipedia.org/wiki/FRACTRAN
*>               This algorithm is very slow, but it uses only ADD and SUBTRACT.
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.09.14
*>
*> Tectonics:    cobc -x -free prime_machine.cob
*>
*> Usage:        ./prime_machine.exe
*>
*>******************************************************************************
*> Date       Change description 
*> ========== ==================================================================
*> 2014.09.14 First version.
*>
*>******************************************************************************

*>******************************************************************************
*>  prime_machine compiler is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU General Public License as published
*>  by the Free Software Foundation, either version 3 of the License, or (at
*>  your option) any later version.
*>
*>  prime_machine is distributed in the hope that it will be useful, but
*>  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*>  or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU General Public License for more details.
*>
*>  You should have received a copy of the GNU General Public License along
*>  with prime_machine.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. prime_machine.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> registers 
 01 REG0                               PIC 9(38).
 01 REG1                               PIC 9(38).
 01 REG2                               PIC 9(38).
 01 REG3                               PIC 9(38).
 01 REG4                               PIC 9(38).
 01 REG5                               PIC 9(38).
 01 REG6                               PIC 9(38).
 01 REG7                               PIC 9(38).
 01 REG8                               PIC 9(38).
 01 REG9                               PIC 9(38).

*> colors 
 01 BLACK                              PIC 9(1) VALUE 0.
 01 BLUE                               PIC 9(1) VALUE 1.
 01 GREEN                              PIC 9(1) VALUE 2.
 01 CYAN                               PIC 9(1) VALUE 3.
 01 RED                                PIC 9(1) VALUE 4.
 01 MAGENTA                            PIC 9(1) VALUE 5.
 01 YELLOW                             PIC 9(1) VALUE 6.
 01 WHITE                              PIC 9(1) VALUE 7.
 
 SCREEN SECTION.
 01 HEADER-SCREEN.
    05 FILLER LINE 3 COLUMN 15
       VALUE "Conway's prime algorithm as a state machine"
       FOREGROUND-COLOR GREEN.

 01 REG-SCREEN.
    05 FILLER LINE 6 COLUMN 15
       VALUE "REG0:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG0
       LINE 6 COLUMN 22 FOREGROUND-COLOR GREEN.
    
    05 FILLER LINE 7 COLUMN 15
       VALUE "REG1:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG1
       LINE 7 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 8 COLUMN 15
       VALUE "REG2:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG2
       LINE 8 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 9 COLUMN 15
       VALUE "REG3:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG3
       LINE 9 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 10 COLUMN 15
       VALUE "REG4:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG4
       LINE 10 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 11 COLUMN 15
       VALUE "REG5:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG5
       LINE 11 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 12 COLUMN 15
       VALUE "REG6:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG6
       LINE 12 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 13 COLUMN 15
       VALUE "REG7:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG7
       LINE 13 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 14 COLUMN 15
       VALUE "REG8:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG8
       LINE 14 COLUMN 22 FOREGROUND-COLOR GREEN.

    05 FILLER LINE 15 COLUMN 15
       VALUE "REG9:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG9
       LINE 15 COLUMN 22 FOREGROUND-COLOR GREEN.

 01 PRIME-SCREEN.
    05 FILLER LINE 18 COLUMN 15
       VALUE "REG0:" FOREGROUND-COLOR GREEN.
    05 SCREEN-REG0 PIC Z(37)9 USING REG0
       LINE 18 COLUMN 22 FOREGROUND-COLOR GREEN.
    05 FILLER LINE 18 COLUMN 62
       VALUE "(this is a prime)" FOREGROUND-COLOR GREEN.
    05 FILLER LINE 21 COLUMN 15
       VALUE "If the registers REG1 - REG9 are zeros, then REG0 is a prime." 
       FOREGROUND-COLOR GREEN.
       
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PRIME SECTION.
*>------------------------------------------------------------------------------

    DISPLAY HEADER-SCREEN          

*>  start value 
    MOVE 1 TO REG0
 
    PERFORM FOREVER
       EVALUATE TRUE
*>        state 01
          WHEN (REG3 > ZEROES) AND (REG5 > ZEROES)
             ADD 1 TO REG6        
             SUBTRACT 1 FROM REG3 
             SUBTRACT 1 FROM REG5 
          
*>        state 02
          WHEN (REG2 > ZEROES) AND (REG6 > ZEROES)
             ADD 1 TO REG0
             ADD 1 TO REG1
             ADD 1 TO REG5
             SUBTRACT 1 FROM REG2
             SUBTRACT 1 FROM REG6
          
*>        state 03
          WHEN (REG1 > ZEROES) AND (REG6 > ZEROES)
             ADD 1 TO REG7
             SUBTRACT 1 FROM REG1
             SUBTRACT 1 FROM REG6
          
*>        state 04
          WHEN (REG0 > ZEROES) AND (REG7 > ZEROES)
             ADD 1 TO REG8
             SUBTRACT 1 FROM REG0
             SUBTRACT 1 FROM REG7
          
*>        state 05
          WHEN (REG1 > ZEROES) AND (REG4 > ZEROES)
             ADD 1 TO REG9
             SUBTRACT 1 FROM REG1
             SUBTRACT 1 FROM REG4
          
*>        state 06
          WHEN (REG9 > ZEROES)
             ADD 1 TO REG3
             ADD 1 TO REG4
             SUBTRACT 1 FROM REG9
          
*>        state 07
          WHEN (REG8 > ZEROES)
             ADD 1 TO REG2
             ADD 1 TO REG7
             SUBTRACT 1 FROM REG8
          
*>        state 08
          WHEN (REG7 > ZEROES)
             ADD 1 TO REG3
             ADD 1 TO REG4
             SUBTRACT 1 FROM REG7
          
*>        state 09
          WHEN (REG6 > ZEROES)
             SUBTRACT 1 FROM REG6
          
*>        state 10
          WHEN (REG5 > ZEROES)
             ADD 1 TO REG4
             SUBTRACT 1 FROM REG5
             
*>        state 11
          WHEN (REG4 > ZEROES)
             ADD 1 TO REG5
             SUBTRACT 1 FROM REG4
             
*>        state 12
          WHEN (REG0 > ZEROES) AND (REG3 > ZEROES)
             ADD 1 TO REG1
             ADD 1 TO REG2
             SUBTRACT 1 FROM REG0
             SUBTRACT 1 FROM REG3
             
*>        state 13
          WHEN (REG0 > ZEROES)
             ADD 1 TO REG1
             ADD 1 TO REG2
             SUBTRACT 1 FROM REG0
             
*>        state 14
          WHEN OTHER
             ADD 1 TO REG2
             ADD 1 TO REG4
       END-EVALUATE 

       DISPLAY REG-SCREEN          
       
*>     If the registers REG1 - REG9 are zeros, then REG0 is a prime
       IF  REG1 = ZEROES 
       AND REG2 = ZEROES
       AND REG3 = ZEROES
       AND REG4 = ZEROES
       AND REG5 = ZEROES
       AND REG6 = ZEROES
       AND REG7 = ZEROES
       AND REG8 = ZEROES
       AND REG9 = ZEROES
       THEN
          DISPLAY PRIME-SCREEN          
       END-IF
    END-PERFORM

    STOP RUN
    
    .
 MAIN-PRIME-EX.
    EXIT.
 END PROGRAM prime_machine.
