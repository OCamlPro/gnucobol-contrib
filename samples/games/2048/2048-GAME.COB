       IDENTIFICATION DIVISION.
       PROGRAM-ID. 2048-GAME.

      * AUTHOR:    Valdis Grindbergs (vgrin)
      * BASED ON http://gabrielecirulli.github.io/2048/
      * ORIGINAL JAVASCRIPT SOURCE CODE AT:
      * https://github.com/gabrielecirulli/2048
      *
      * GAME PLAY:
      * EACH TURN SLIDE ALL TILES ON GRID IN ONE OF FOUR
      * DIRECTIONS.  IF TWO TILES WITH THE SAME VALUE
      * COLLIDE, THEY ARE REPLACED WITH ONE TILE WITH
      * DOUBLE THE VALUE.  EACH TURN A NEW TILE IS ADDED
      * TO THE GRID.
      * GAME IS WON IF CREATE A TILE WITH THE VALUE 2048
      * (2 TO THE 11TH POWER).  GAME IS LOST IF ALL SPACES
      * IN THE GRID ARE FILLED.
      *
      * PARAGRAPHS SLIDE-RIGHT SLIDE-LEFT SLIDE-UP SLIDE-DOWN
      * ARE SIMILAR AND COULD BE REPLACED BY ONE PARAGRAPH
      * CALLED FOUR DIFFERENT WAYS.  HOWEVER, THEY ARE KEPT
      * SEPARATE BECAUSE IT MIGHT MAKE THE CODE EASIER TO
      * UNDERSTAND AND IT DOES NOT CREATE TOO MUCH DUPLICATION.
      *
      * LICENSE:
      * 2048-GAME is free software: you can redistribute it and/or
      * modify it under the terms of the GNU General Public License as
      * published by the Free Software Foundation, either version 3 of
      * the License, or (at your option) any later version.
      *
      * 2048-GAME is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public
      * License along with 2048-GAME.
      * If not, see <http://www.gnu.org/licenses/>.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.
       01  IS-GAME-OVER                     PIC X VALUE 'N'.
           88  GAME-OVER                    VALUE 'Y'.
       01  EMPTY-COUNT                      PIC 99 USAGE COMP.
       01  RANDOM-NUMBER                    PIC 99 USAGE COMP.
       01  CELL-COUNT                       PIC 99 USAGE COMP.
       01  USER-ENTRY                       PIC X(10).
           88  VALID-USER-ENTRY             VALUE 'Q' 'q' 'R' 'r'
                                                  'L' 'l' 'U' 'u'
                                                  'D' 'd'.
           88  USER-CHOSE-QUIT              VALUE 'Q' 'q'.
           88  USER-CHOSE-UP                VALUE 'U' 'u'.
           88  USER-CHOSE-DOWN              VALUE 'D' 'd'.
           88  USER-CHOSE-LEFT              VALUE 'L' 'l'.
           88  USER-CHOSE-RIGHT             VALUE 'R' 'r'.

       01  GAME-GRID.
           05  GRID-ROW OCCURS 4 TIMES INDEXED BY ROW-INDEX.
               10  GRID-COL OCCURS 4 TIMES INDEXED BY COL-INDEX.
                   15  GRID-CELL            PIC 9999 VALUE ZERO.

       01  UPDATED-GROUP.
           05  UPDATED-SET OCCURS 4 TIMES INDEXED BY UPDATED-INDEX
                                            PIC 9999 VALUE ZERO.
       01  PRIOR-TILE                       PIC 9999 VALUE ZERO.

       SCREEN SECTION.
       01  GAME-GRID-SCREEN.
           05  BLANK SCREEN.
           05  GRID-SCREEN.
               10  LINE 2 COLUMN 10 VALUE '2048'.
               10  GRID-DISPLAY-11 LINE 4 COLUMN 2 PIC ZZZ9
                   FROM GRID-CELL (1, 1) AUTO.
               10  GRID-DISPLAY-12 LINE 4 COLUMN 7 PIC ZZZ9
                   FROM GRID-CELL (1, 2) AUTO.
               10  GRID-DISPLAY-13 LINE 4 COLUMN 12 PIC ZZZ9
                   FROM GRID-CELL (1, 3) AUTO.
               10  GRID-DISPLAY-14 LINE 4 COLUMN 17 PIC ZZZ9
                   FROM GRID-CELL (1, 4).
               10  GRID-DISPLAY-21 LINE 6 COLUMN 2 PIC ZZZ9
                   FROM GRID-CELL (2, 1).
               10  GRID-DISPLAY-22 LINE 6 COLUMN 7 PIC ZZZ9
                   FROM GRID-CELL (2, 2).
               10  GRID-DISPLAY-23 LINE 6 COLUMN 12 PIC ZZZ9
                   FROM GRID-CELL (2, 3).
               10  GRID-DISPLAY-24 LINE 6 COLUMN 17 PIC ZZZ9
                   FROM GRID-CELL (2, 4).
               10  GRID-DISPLAY-31 LINE 8 COLUMN 2 PIC ZZZ9
                   FROM GRID-CELL (3, 1).
               10  GRID-DISPLAY-32 LINE 8 COLUMN 7 PIC ZZZ9
                   FROM GRID-CELL (3, 2).
               10  GRID-DISPLAY-33 LINE 8 COLUMN 12 PIC ZZZ9
                   FROM GRID-CELL (3, 3).
               10  GRID-DISPLAY-34 LINE 8 COLUMN 17 PIC ZZZ9
                   FROM GRID-CELL (3, 4).
               10  GRID-DISPLAY-41 LINE 10 COLUMN 2 PIC ZZZ9
                   FROM GRID-CELL (4, 1).
               10  GRID-DISPLAY-42 LINE 10 COLUMN 7 PIC ZZZ9
                   FROM GRID-CELL (4, 2).
               10  GRID-DISPLAY-43 LINE 10 COLUMN 12 PIC ZZZ9
                   FROM GRID-CELL (4, 3).
               10  GRID-DISPLAY-44 LINE 10 COLUMN 17 PIC ZZZ9
                   FROM GRID-CELL (4, 4).
               10  LINE 12 COLUMN  4 VALUE 'CHOICE:'.
               10  LINE 13 COLUMN 12 VALUE 'U - UP'.
               10  LINE 14 COLUMN 12 VALUE 'D - DOWN'.
               10  LINE 15 COLUMN 12 VALUE 'L - LEFT'.
               10  LINE 16 COLUMN 12 VALUE 'R - RIGHT'.
               10  LINE 17 COLUMN 12 VALUE 'Q - QUIT'.
               10  GRID-MESSAGE LINE 19 COLUMN 4     PIC X(27).
           05  GRID-INPUT.
               10  USER-COMMAND LINE 12 COLUMN 12    PIC X(10)
                   USING USER-ENTRY.

       PROCEDURE DIVISION.
       MAIN.
           MOVE SPACES TO GRID-MESSAGE
           PERFORM PLACE-NEW-TILE
           PERFORM GAME-TURN
               UNTIL GAME-OVER
           ACCEPT USER-COMMAND
           STOP RUN
           .

       GAME-TURN.
           PERFORM PLACE-NEW-TILE
           DISPLAY GAME-GRID-SCREEN
           PERFORM HANDLE-USER-ENTRY
           PERFORM CHECK-IF-WIN
           .

       PLACE-NEW-TILE.
      * CALLED TWICE BEFORE PLAY BEGINS AND ONCE EVERY TURN
           PERFORM COUNT-EMPTY
           IF EMPTY-COUNT = ZERO
               SET GAME-OVER TO TRUE
               MOVE 'NO MOVES LEFT' TO GRID-MESSAGE
               DISPLAY GAME-GRID-SCREEN
           END-IF
           COMPUTE RANDOM-NUMBER = FUNCTION RANDOM * EMPTY-COUNT + 1
           MOVE ZERO TO CELL-COUNT
           PERFORM VARYING ROW-INDEX FROM 1 BY 1
               UNTIL ROW-INDEX > 4 OR CELL-COUNT >= RANDOM-NUMBER
               PERFORM VARYING COL-INDEX FROM 1 BY 1
               UNTIL COL-INDEX > 4 OR CELL-COUNT >= RANDOM-NUMBER
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) = ZERO
                       ADD 1 TO CELL-COUNT
                   END-IF
               END-PERFORM
           END-PERFORM
           SET ROW-INDEX DOWN BY 1
           SET COL-INDEX DOWN BY 1
           COMPUTE RANDOM-NUMBER = FUNCTION RANDOM * 10 + 1
           IF RANDOM-NUMBER > 8
               MOVE 4 TO GRID-CELL (ROW-INDEX, COL-INDEX)
           ELSE
               MOVE 2 TO GRID-CELL (ROW-INDEX, COL-INDEX)
           END-IF
           .

       COUNT-EMPTY.
           MOVE ZERO TO EMPTY-COUNT
           PERFORM VARYING ROW-INDEX FROM 1 BY 1
               UNTIL ROW-INDEX > 4
               PERFORM VARYING COL-INDEX FROM 1 BY 1
               UNTIL COL-INDEX > 4
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) = ZERO
                       ADD 1 TO EMPTY-COUNT
                   END-IF
               END-PERFORM
           END-PERFORM
           .

       HANDLE-USER-ENTRY.
           PERFORM UNTIL VALID-USER-ENTRY
               MOVE SPACES TO USER-ENTRY
               ACCEPT USER-COMMAND
           END-PERFORM
           EVALUATE TRUE
               WHEN USER-CHOSE-QUIT
                   SET GAME-OVER TO TRUE
                   MOVE 'QUITING GAME...' TO GRID-MESSAGE
                   DISPLAY GAME-GRID-SCREEN
               WHEN USER-CHOSE-UP
                   PERFORM SLIDE-UP
               WHEN USER-CHOSE-DOWN
                   PERFORM SLIDE-DOWN
               WHEN USER-CHOSE-LEFT
                   PERFORM SLIDE-LEFT
               WHEN USER-CHOSE-RIGHT
                   PERFORM SLIDE-RIGHT
           END-EVALUATE
           MOVE SPACES TO USER-ENTRY
           .

       SLIDE-UP.
           PERFORM VARYING COL-INDEX FROM 1 BY 1
           UNTIL COL-INDEX > 4
               MOVE ZERO TO PRIOR-TILE

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE ZERO TO UPDATED-SET (UPDATED-INDEX)
               END-PERFORM

               SET UPDATED-INDEX TO 1
               PERFORM VARYING ROW-INDEX FROM 1 BY 1
                   UNTIL ROW-INDEX > 4
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) NOT = 0
                       IF GRID-CELL (ROW-INDEX, COL-INDEX) = PRIOR-TILE
                           COMPUTE UPDATED-SET(UPDATED-INDEX - 1)
                               = UPDATED-SET(UPDATED-INDEX - 1) * 2
                           MOVE ZERO TO PRIOR-TILE
                       ELSE
                           MOVE GRID-CELL (ROW-INDEX, COL-INDEX)
                             TO UPDATED-SET(UPDATED-INDEX)
                                PRIOR-TILE
                           SET UPDATED-INDEX UP BY 1
                       END-IF
                   END-IF
               END-PERFORM

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE UPDATED-SET (UPDATED-INDEX)
                     TO GRID-CELL (UPDATED-INDEX, COL-INDEX)
               END-PERFORM

           END-PERFORM
           .

       SLIDE-DOWN.
           PERFORM VARYING COL-INDEX FROM 1 BY 1
           UNTIL COL-INDEX > 4
               MOVE ZERO TO PRIOR-TILE

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE ZERO TO UPDATED-SET (UPDATED-INDEX)
               END-PERFORM

               SET UPDATED-INDEX TO 4
               PERFORM VARYING ROW-INDEX FROM 4 BY -1
                   UNTIL ROW-INDEX < 1
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) NOT = 0
                       IF GRID-CELL (ROW-INDEX, COL-INDEX) = PRIOR-TILE
                           COMPUTE UPDATED-SET(UPDATED-INDEX + 1)
                               = UPDATED-SET(UPDATED-INDEX + 1) * 2
                           MOVE ZERO TO PRIOR-TILE
                       ELSE
                           MOVE GRID-CELL (ROW-INDEX, COL-INDEX)
                             TO UPDATED-SET(UPDATED-INDEX)
                                PRIOR-TILE
                           SET UPDATED-INDEX DOWN BY 1
                       END-IF
                   END-IF
               END-PERFORM

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE UPDATED-SET (UPDATED-INDEX)
                     TO GRID-CELL (UPDATED-INDEX, COL-INDEX)
               END-PERFORM

           END-PERFORM
           .

       SLIDE-LEFT.
           PERFORM VARYING ROW-INDEX FROM 1 BY 1
           UNTIL ROW-INDEX > 4
               MOVE ZERO TO PRIOR-TILE

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE ZERO TO UPDATED-SET (UPDATED-INDEX)
               END-PERFORM

               SET UPDATED-INDEX TO 1
               PERFORM VARYING COL-INDEX FROM 1 BY 1
                   UNTIL COL-INDEX > 4
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) NOT = 0
                       IF GRID-CELL (ROW-INDEX, COL-INDEX) = PRIOR-TILE
                           COMPUTE UPDATED-SET(UPDATED-INDEX - 1)
                               = UPDATED-SET(UPDATED-INDEX - 1) * 2
                           MOVE ZERO TO PRIOR-TILE
                       ELSE
                           MOVE GRID-CELL (ROW-INDEX, COL-INDEX)
                             TO UPDATED-SET(UPDATED-INDEX)
                                PRIOR-TILE
                           SET UPDATED-INDEX UP BY 1
                       END-IF
                   END-IF
               END-PERFORM

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE UPDATED-SET (UPDATED-INDEX)
                     TO GRID-CELL (ROW-INDEX, UPDATED-INDEX)
               END-PERFORM

           END-PERFORM
           .

       SLIDE-RIGHT.
           PERFORM VARYING ROW-INDEX FROM 1 BY 1
           UNTIL ROW-INDEX > 4
               MOVE ZERO TO PRIOR-TILE

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE ZERO TO UPDATED-SET (UPDATED-INDEX)
               END-PERFORM

               SET UPDATED-INDEX TO 4
               PERFORM VARYING COL-INDEX FROM 4 BY -1
                   UNTIL COL-INDEX < 1
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) NOT = 0
                       IF GRID-CELL (ROW-INDEX, COL-INDEX) = PRIOR-TILE
                           COMPUTE UPDATED-SET(UPDATED-INDEX + 1)
                               = UPDATED-SET(UPDATED-INDEX + 1) * 2
                           MOVE ZERO TO PRIOR-TILE
                       ELSE
                           MOVE GRID-CELL (ROW-INDEX, COL-INDEX)
                             TO UPDATED-SET(UPDATED-INDEX)
                                PRIOR-TILE
                           SET UPDATED-INDEX DOWN BY 1
                       END-IF
                   END-IF
               END-PERFORM

               PERFORM VARYING UPDATED-INDEX FROM 1 BY 1
               UNTIL UPDATED-INDEX > 4
                   MOVE UPDATED-SET (UPDATED-INDEX)
                     TO GRID-CELL (ROW-INDEX, UPDATED-INDEX)
               END-PERFORM

           END-PERFORM
           .

       CHECK-IF-WIN.
           PERFORM VARYING ROW-INDEX FROM 1 BY 1
               UNTIL ROW-INDEX > 4
               PERFORM VARYING COL-INDEX FROM 1 BY 1
               UNTIL COL-INDEX > 4
                   IF GRID-CELL (ROW-INDEX, COL-INDEX) = 2048
                       MOVE 'YOU REACHED 2048 AND WON!!!' 
                         TO GRID-MESSAGE 
                       DISPLAY GAME-GRID-SCREEN
                       SET GAME-OVER TO TRUE
                   END-IF
               END-PERFORM
           END-PERFORM
           .
