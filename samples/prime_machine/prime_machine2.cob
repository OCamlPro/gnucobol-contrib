*>******************************************************************************
*> Program:      prime_machine2.cob
*>               (if compiled with GnuCOBOL/OpenCOBOL a version 2 or later is needed)
*>
*> Purpose:      This example implements Conway's prime algorithm
*>               as a state machine: http://en.wikipedia.org/wiki/FRACTRAN
*>               This algorithm is very slow, but it uses only ADD and SUBTRACT.
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.09.14, 2014.09.26
*>
*> Tectonics:    cobc -x -free -O2 prime_machine.cob
*>
*> Optional Defines:
*>   Register PICTURE USAGE:
*>          -DUSAGE="BINARY" :
*>               USAGE BINARY / COMPUTATIONAL-5
*>          -DUSAGE="BINARY-SHORT" :
*>               USAGE BINARY-SHORT UNSIGNED
*>          -DUSAGE="BINARY-LONG" :
*>               USAGE BINARY-LONG UNSIGNED
*>          -DUSAGE="BINARY-DOUBLE" :
*>               USAGE BINARY-DOUBLE UNSIGNED
*>          None of the above :
*>               USAGE DISPLAY
*>   Register PICTURE SIZE (for USAGE BINARY/DISPLAY only)
*>          -DPICSIZE=02:
*>               PIC 9(02)
*>          -DPICSIZE=03..17:
*>               PIC 9(03..17)
*>          -DPICSIZE=18:
*>               PIC 9(18)
*>          -DPICSIZE=19..37 (for USAGE DISPLAY only):
*>               PIC 9(19..37)
*>          -DPICSIZE=38 (for USAGE DISPLAY only):
*>               PIC 9(38)
*>          None of the above :
*>               PIC 9(36) for USAGE DISPLAY, PIC 9(18) for USAGE BINARY
*>   Screen I/O:
*>          -DHIDE-REGISTERS :
*>               display of primes only          (using SCREEN SECTION)
*>          -DUSE-SYSERR :
*>               display of primes only          (output to SYSERR only)
*>          None of the above :
*>               full display with all registers (using SCREEN SECTION)
*>   Sample: cobc -x -free -O2 -DUSAGE="BINARY" -DPICSIZE=08 -DUSE-SYSERR prime_machine2.cob
*>
*> If compiled with debugging mode (add -fdebugging-line to cobc command line)
*> prime_machine2 will wait for ENTER before calculating the next state.
*>
*> Usage:        ./prime_machine2
*>
*>******************************************************************************
*> Date       Change description
*> ========== ==================================================================
*> 2014.09.14 laszloerdos - First version.
*> 2014.26.14 sf-mensch
*>   * use FILLER instead of multiple SCREEN-REG0
*>   * using lvl78 for identical lenghts to simplify changes
*>   * use screenio.cpy instead of self-defined colors
*>   * reduce REG-SIZE to 36 for enabling use of OpenCOBOL/GnuCOBOL 1.1
*>   * grouped ADD and SUBTRACT and added terminators (compiles with -W)
*> 2014.26.14 sf-mensch
*>   * set USAGE and PICTURE size [for USAGE DISPLAY/BINARY] at compile time
*>     via DEFINEs (heavy use of >> IF and use of REPLACE) - could be much
*>     less code if CONSTANT and complex conditions for >> IF would be fully
*>     supported
*>   * used less and relative LINE clauses in SCREEN SECTION
*>   * add compile time options via DEFINES to remove DISPLAY of registers
*>     and to only DISPLAY UPON SYSERR all found primes
*>   * add compile time option via debugging line to investigate the state
*>     before recalculation
*>
*>******************************************************************************

*>******************************************************************************
*>  prime_machine2 is free software: you can redistribute it and/or modify it
*>  under the terms of the GNU General Public License as published by the Free
*>  Software Foundation, either version 3 of the License, or (at your option)
*>  any later version.
*>
*>  prime_machine2 is distributed in the hope that it will be useful, but
*>  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*>  or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU General Public License for more details.
*>
*>  You should have received a copy of the GNU General Public License along
*>  with prime_machine2.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. prime_machine2.
*>   AUTHOR. Laszlo Erdos, Simon Sobisch.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
*> REPOSITORY.

 DATA DIVISION.

 WORKING-STORAGE SECTION.

*> Check defines

>> IF USAGE DEFINED
*> USAGE should be a valid entry
 >> IF USAGE IS NOT = "BINARY"
  >> IF USAGE IS NOT = "DISPLAY"
   >> IF USAGE IS NOT = "BINARY-SHORT"
    >> IF USAGE IS NOT = "BINARY-LONG"
     >> IF USAGE IS NOT = "BINARY-DOUBLE"
      >> DISPLAY Error: Defined USAGE is INVALID
     >> END-IF
    >> END-IF
   >> END-IF
  >> END-IF
 >> END-IF

*> If PICSIZE was defined only USAGE "BINARY" or "DISPLAY" are valid
*> as others don't allow PICTURE
 >> IF PICSIZE DEFINED
  >> IF USAGE IS NOT = "BINARY"
   >> IF USAGE IS NOT = "DISPLAY"
    >> DISPLAY Error: Defined PICSIZE and USAGE are incompatible
   >> END-IF
  >> END-IF
 >> END-IF
>> END-IF

*> The following could be reduced but the support is currently missing in cobc
*>> IF PICSIZE GREATER OR EQUAL TO 02
*>> 01 REG-SIZE    CONSTANT FROM PICSIZE.
*>> 01 REG-SIZE-M1 CONSTANT AS   REGSIZE - 1.
*>> ELSE
>> IF   PICSIZE EQUAL TO 02
 78 REG-SIZE                           VALUE 02.
 78 REG-SIZE-M1                        VALUE 01.
>> ELIF PICSIZE EQUAL TO 03
 78 REG-SIZE                           VALUE 03.
 78 REG-SIZE-M1                        VALUE 02.
>> ELIF PICSIZE EQUAL TO 04
 78 REG-SIZE                           VALUE 04.
 78 REG-SIZE-M1                        VALUE 03.
>> ELIF PICSIZE EQUAL TO 05
 78 REG-SIZE                           VALUE 05.
 78 REG-SIZE-M1                        VALUE 04.
>> ELIF PICSIZE EQUAL TO 06
 78 REG-SIZE                           VALUE 06.
 78 REG-SIZE-M1                        VALUE 05.
>> ELIF PICSIZE EQUAL TO 07
 78 REG-SIZE                           VALUE 07.
 78 REG-SIZE-M1                        VALUE 06.
>> ELIF PICSIZE EQUAL TO 08
 78 REG-SIZE                           VALUE 08.
 78 REG-SIZE-M1                        VALUE 07.
>> ELIF PICSIZE EQUAL TO 09
 78 REG-SIZE                           VALUE 09.
 78 REG-SIZE-M1                        VALUE 08.
>> ELIF PICSIZE EQUAL TO 10
 78 REG-SIZE                           VALUE 10.
 78 REG-SIZE-M1                        VALUE 09.
>> ELIF PICSIZE EQUAL TO 11
 78 REG-SIZE                           VALUE 11.
 78 REG-SIZE-M1                        VALUE 10.
>> ELIF PICSIZE EQUAL TO 12
 78 REG-SIZE                           VALUE 12.
 78 REG-SIZE-M1                        VALUE 11.
>> ELIF PICSIZE EQUAL TO 13
 78 REG-SIZE                           VALUE 13.
 78 REG-SIZE-M1                        VALUE 12.
>> ELIF PICSIZE EQUAL TO 14
 78 REG-SIZE                           VALUE 14.
 78 REG-SIZE-M1                        VALUE 13.
>> ELIF PICSIZE EQUAL TO 15
 78 REG-SIZE                           VALUE 15.
 78 REG-SIZE-M1                        VALUE 14.
>> ELIF PICSIZE EQUAL TO 16
 78 REG-SIZE                           VALUE 16.
 78 REG-SIZE-M1                        VALUE 15.
>> ELIF PICSIZE EQUAL TO 17
 78 REG-SIZE                           VALUE 17.
 78 REG-SIZE-M1                        VALUE 16.
>> ELIF PICSIZE EQUAL TO 18
 78 REG-SIZE                           VALUE 18.
 78 REG-SIZE-M1                        VALUE 17.
>> ELIF PICSIZE EQUAL TO 19
 78 REG-SIZE                           VALUE 19.
 78 REG-SIZE-M1                        VALUE 18.
>> ELIF PICSIZE EQUAL TO 20
 78 REG-SIZE                           VALUE 20.
 78 REG-SIZE-M1                        VALUE 19.
>> ELIF PICSIZE EQUAL TO 21
 78 REG-SIZE                           VALUE 21.
 78 REG-SIZE-M1                        VALUE 20.
>> ELIF PICSIZE EQUAL TO 22
 78 REG-SIZE                           VALUE 22.
 78 REG-SIZE-M1                        VALUE 21.
>> ELIF PICSIZE EQUAL TO 23
 78 REG-SIZE                           VALUE 23.
 78 REG-SIZE-M1                        VALUE 22.
>> ELIF PICSIZE EQUAL TO 24
 78 REG-SIZE                           VALUE 24.
 78 REG-SIZE-M1                        VALUE 23.
>> ELIF PICSIZE EQUAL TO 25
 78 REG-SIZE                           VALUE 25.
 78 REG-SIZE-M1                        VALUE 24.
>> ELIF PICSIZE EQUAL TO 26
 78 REG-SIZE                           VALUE 26.
 78 REG-SIZE-M1                        VALUE 25.
>> ELIF PICSIZE EQUAL TO 27
 78 REG-SIZE                           VALUE 27.
 78 REG-SIZE-M1                        VALUE 26.
>> ELIF PICSIZE EQUAL TO 28
 78 REG-SIZE                           VALUE 28.
 78 REG-SIZE-M1                        VALUE 27.
>> ELIF PICSIZE EQUAL TO 29
 78 REG-SIZE                           VALUE 29.
 78 REG-SIZE-M1                        VALUE 28.
>> ELIF PICSIZE EQUAL TO 30
 78 REG-SIZE                           VALUE 30.
 78 REG-SIZE-M1                        VALUE 29.
>> ELIF PICSIZE EQUAL TO 31
 78 REG-SIZE                           VALUE 31.
 78 REG-SIZE-M1                        VALUE 30.
>> ELIF PICSIZE EQUAL TO 32
 78 REG-SIZE                           VALUE 32.
 78 REG-SIZE-M1                        VALUE 31.
>> ELIF PICSIZE EQUAL TO 33
 78 REG-SIZE                           VALUE 33.
 78 REG-SIZE-M1                        VALUE 32.
>> ELIF PICSIZE EQUAL TO 34
 78 REG-SIZE                           VALUE 34.
 78 REG-SIZE-M1                        VALUE 33.
>> ELIF PICSIZE EQUAL TO 35
 78 REG-SIZE                           VALUE 35.
 78 REG-SIZE-M1                        VALUE 34.
>> ELIF PICSIZE EQUAL TO 36
 78 REG-SIZE                           VALUE 36.
 78 REG-SIZE-M1                        VALUE 35.
>> ELIF PICSIZE EQUAL TO 37
 78 REG-SIZE                           VALUE 37.
 78 REG-SIZE-M1                        VALUE 36.
>> ELIF PICSIZE EQUAL TO 38
 78 REG-SIZE                           VALUE 38.
 78 REG-SIZE-M1                        VALUE 37.
>> ELIF PICSIZE DEFINED
   *> PICSIZE is defined but wrong
 >> DISPLAY Error: PICSIZE is defined but wrong
 *> Define the following for keeping the rest of the source valid
 78 REG-SIZE                           VALUE 1.
 >> IF USE-SYSERR NOT DEFINED
 78 REG-SIZE-M1                        VALUE 1.
 >> END-IF
>> ELSE
 >> IF   USAGE EQUAL TO "BINARY-SHORT"
 78 REG-SIZE-M1                        VALUE 4.
 >> ELIF USAGE EQUAL TO "BINARY-LONG"
 78 REG-SIZE-M1                        VALUE 9.
 >> ELIF USAGE EQUAL TO "BINARY-DOUBLE"
 78 REG-SIZE-M1                        VALUE 19.
 >> ELIF USAGE EQUAL TO "BINARY"
 78 REG-SIZE                           VALUE 18.
 78 REG-SIZE-M1                        VALUE 17.
 >> ELSE *> USAGE not defined or "DISPLAY"
 78 REG-SIZE                           VALUE 36.
 78 REG-SIZE-M1                        VALUE 35.
 >> END-IF
>> END-IF

*> registers

>> IF   USAGE EQUAL TO "BINARY-SHORT"
 REPLACE ==REG-PICTURE== BY ====
         ==REG-USAGE==   BY ==BINARY-SHORT==.
>> ELIF USAGE EQUAL TO "BINARY-LONG"
 REPLACE ==REG-PICTURE== BY ====
         ==REG-USAGE==   BY ==BINARY-LONG==.
>> ELIF USAGE EQUAL TO "BINARY-DOUBLE"
 REPLACE ==REG-PICTURE== BY ====
         ==REG-USAGE==   BY ==BINARY-DOUBLE==.
>> ELIF USAGE EQUAL TO "BINARY"
 REPLACE ==REG-PICTURE== BY ==PIC 9(REG-SIZE)==
         ==REG-USAGE==   BY ==BINARY==.
>> ELSE *> USAGE not defined or "DISPLAY"
 REPLACE ==REG-PICTURE== BY ==PIC 9(REG-SIZE)==
         ==REG-USAGE==   BY ==DISPLAY==.
>> END-IF

 01 REG0                               REG-PICTURE USAGE REG-USAGE.
 01 REG1                               REG-PICTURE USAGE REG-USAGE.
 01 REG2                               REG-PICTURE USAGE REG-USAGE.
 01 REG3                               REG-PICTURE USAGE REG-USAGE.
 01 REG4                               REG-PICTURE USAGE REG-USAGE.
 01 REG5                               REG-PICTURE USAGE REG-USAGE.
 01 REG6                               REG-PICTURE USAGE REG-USAGE.
 01 REG7                               REG-PICTURE USAGE REG-USAGE.
 01 REG8                               REG-PICTURE USAGE REG-USAGE.
 01 REG9                               REG-PICTURE USAGE REG-USAGE.

 REPLACE OFF.

>> IF USE-SYSERR NOT DEFINED
*> colors
 copy screenio.

*> screen attributes
 78 START-COL-TITLE                    VALUE 13.
 78 START-COL-DATA                     VALUE 20.

 SCREEN SECTION.
 01 HEADER-SCREEN.
    05 FILLER LINE 3 COLUMN START-COL-TITLE
       VALUE "Conway's prime algorithm as a state machine"
       FOREGROUND-COLOR COB-COLOR-GREEN.

>> IF HIDE-REGISTERS DEFINED
    05 FILLER LINE 6 COLUMN START-COL-TITLE
       VALUE "HIDING the DISPLAY of temporary registers."
       FOREGROUND-COLOR COB-COLOR-BLUE.
>> END-IF   *> HIDE-REGISTERS DEFINED


>> IF HIDE-REGISTERS NOT DEFINED
 01 REG-SCREEN.
    05 FILLER LINE 6.
       10 COLUMN START-COL-TITLE    VALUE "REG0:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG0
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE    VALUE "REG1:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG1
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE    VALUE "REG2:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG2
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE    VALUE "REG3:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG3
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE   VALUE "REG4:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG4
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE   VALUE "REG5:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG5
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE   VALUE "REG6:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG6
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE   VALUE "REG7:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG7
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE  VALUE "REG8:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG8
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.

    05 FILLER LINE PLUS 1.
       10 COLUMN START-COL-TITLE  VALUE "REG9:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG9
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.
>> END-IF   *> HIDE-REGISTERS NOT DEFINED

 01 PRIME-SCREEN.
    05 FILLER LINE 18.
       10 COLUMN START-COL-TITLE  VALUE "REG0:"
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER PIC Z(REG-SIZE-M1)9 USING REG0
          COLUMN START-COL-DATA
          FOREGROUND-COLOR COB-COLOR-GREEN.
       10 FILLER COLUMN PLUS 2           VALUE "(this is a prime)"
          FOREGROUND-COLOR COB-COLOR-GREEN.
>> IF HIDE-REGISTERS NOT DEFINED
    05 FILLER LINE 21.
       10 COLUMN START-COL-TITLE
          VALUE "If the registers REG1 - REG9 are zeros, then REG0 is a prime."
          FOREGROUND-COLOR COB-COLOR-GREEN.
>> END-IF   *> HIDE-REGISTERS NOT DEFINED

>> END-IF   *> USE-SYSERR NOT DEFINED

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PRIME SECTION.
*>------------------------------------------------------------------------------

>> IF USE-SYSERR NOT DEFINED
    DISPLAY HEADER-SCREEN END-DISPLAY
>> END-IF
*>  start value
    MOVE 1 TO REG0

    PERFORM FOREVER
       EVALUATE TRUE
*>        state 01
          WHEN (REG3 > ZEROES) AND (REG5 > ZEROES)
             ADD      1 TO   REG6             END-ADD
             SUBTRACT 1 FROM REG3, REG5       END-SUBTRACT

*>        state 02
          WHEN (REG2 > ZEROES) AND (REG6 > ZEROES)
             ADD      1 TO   REG0, REG1, REG5 END-ADD
             SUBTRACT 1 FROM REG2, REG6       END-SUBTRACT

*>        state 03
          WHEN (REG1 > ZEROES) AND (REG6 > ZEROES)
             ADD      1 TO   REG7             END-ADD
             SUBTRACT 1 FROM REG1, REG6       END-SUBTRACT

*>        state 04
          WHEN (REG0 > ZEROES) AND (REG7 > ZEROES)
             ADD      1 TO   REG8             END-ADD
             SUBTRACT 1 FROM REG0, REG7       END-SUBTRACT

*>        state 05
          WHEN (REG1 > ZEROES) AND (REG4 > ZEROES)
             ADD      1 TO   REG9             END-ADD
             SUBTRACT 1 FROM REG1, REG4       END-SUBTRACT

*>        state 06
          WHEN (REG9 > ZEROES)
             ADD      1 TO   REG3, REG4       END-ADD
             SUBTRACT 1 FROM REG9             END-SUBTRACT

*>        state 07
          WHEN (REG8 > ZEROES)
             ADD      1 TO   REG2, REG7       END-ADD
             SUBTRACT 1 FROM REG8             END-SUBTRACT

*>        state 08
          WHEN (REG7 > ZEROES)
             ADD      1 TO   REG3, REG4       END-ADD
             SUBTRACT 1 FROM REG7             END-SUBTRACT

*>        state 09
          WHEN (REG6 > ZEROES)
             SUBTRACT 1 FROM REG6             END-SUBTRACT

*>        state 10
          WHEN (REG5 > ZEROES)
             ADD      1 TO   REG4             END-ADD
             SUBTRACT 1 FROM REG5             END-SUBTRACT

*>        state 11
          WHEN (REG4 > ZEROES)
             ADD      1 TO   REG5             END-ADD
             SUBTRACT 1 FROM REG4             END-SUBTRACT

*>        state 12
          WHEN (REG0 > ZEROES) AND (REG3 > ZEROES)
             ADD      1 TO   REG1, REG2       END-ADD
             SUBTRACT 1 FROM REG0, REG3       END-SUBTRACT

*>        state 13
          WHEN (REG0 > ZEROES)
             ADD      1 TO   REG1, REG2       END-ADD
             SUBTRACT 1 FROM REG0             END-SUBTRACT

*>        state 14
          WHEN OTHER
             ADD      1 TO   REG2, REG4       END-ADD
       END-EVALUATE

>> IF USE-SYSERR NOT DEFINED
  >> IF HIDE-REGISTERS NOT DEFINED
       DISPLAY REG-SCREEN END-DISPLAY
  *> In debugging mode: wait for a keypress
  >>D  ACCEPT OMITTED END-ACCEPT
  >> END-IF
>> END-IF

*>     If the registers REG1 - REG9 are zeroes, then REG0 is a prime
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
>> IF USE-SYSERR NOT DEFINED
          DISPLAY PRIME-SCREEN END-DISPLAY
>> ELSE
          DISPLAY REG0 UPON SYSERR END-DISPLAY
>> END-IF
       END-IF
    END-PERFORM

    STOP RUN

    .
 MAIN-PRIME-EX.
    EXIT.
 END PROGRAM prime_machine2.
