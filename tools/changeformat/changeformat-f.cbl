       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. changeformat.
      *
      * Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
      * Copyright (C) 2014 Vincent Coen
      * Copyright (C) 2019 Simon Sobisch
      *
      * This program is free software; you can redistribute it and/or
      * modify it under the terms of the GNU General Public License
      * as published by the Free Software Foundation; either
      * version 2, or (at your option) any later version.
      *
      * This program is distributed in the hope that it will be
      * useful, but WITHOUT ANY WARRANTY; without even the implied
      * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
      * PURPOSE.  See the GNU General Public License for more
      * details.
      *
      * You should have received a copy of the GNU General Public
      * License along with this software; see the file COPYING.
      * If not, write to the Free Software Foundation, Inc.,
      * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

      *=======================================================
      * change a cobol program format tofixed/tofree
      *
      * tofixed includes change to upper case
      * tofree includes change to lower case
      *
      * cobc -x changeformat.cbl
      * chmod +x changeformat
      *
      *  Standard mode :
      * ./changeformat <inprogram> <outprogram> tofixed/tofree \
      *     ws-after pd-after nocc1
      *
      *  tofixed option ws-after places comments after
      *  the working-storage section line
      *
      *  tofree option pd-after places comments after
      *  the procedure division line
      *
      *  tofree option nocc1 moves uncommented lines starting in
      *  cc2
      *
      * Extended mode: to output input file (with case changed to
      *                                                          reflect
      *   fixed (uppercase) or free (lowercase) to  output path/
      *
      * ./changeformat <inprogram> <outputprogram path/> tofixed/tofree
      *                                                                \
      *     ws-after pd-after nocc1
      *
      * Example for Extended under linux:
      *
      *  ./changeformat st010.cbl ~/cobolsrc/ACAS/stock-fixed/ tofixed
      *
      * Note that for windows the slash is a \
      *
      * to do a batch run of similar files within a directory with the
      *                                                     output files
      *  in a different directory using the default Linux bash shell
      *  use supplied chgfmt-all.sh but change for your own usage:
      *
      * --------
      * #!/bin/bash
      * for i in `ls st0*.cbl`; do changeformat $i
      *                       ~/cobolsrc/ACAS/stock-fixed/ tofixed; done
      * exit 0
      * --------
      *
      *=======================================================

      *=======================================================
      * advice:
      * if you want to debug, put the following
      * at strategic locations in the code:
      *     if line-number = nnnnnn
      *         call 'dumpscancontrol'
      *             using input-record scan-control
      *         end-call
      *     end-if
      *=======================================================

      *=======================================================
      * 2014-10-20 1) tested with Vincent Voen's ACAS st010
      *            2) added area-a-indent
      *            3) add tab to scanner
      *            4) rewrite free comment processing
      * 2014-10-26 1) area-a-indent lost after comment
      *            2) find-comment-break-point not recognizing
      *               short remaining text
      *            4) default format-type FREE not set
      *            5) unclosed continuation losing closing
      *               quote
      *            6) rewrite free literal processing
      *            7) tested with gary cutler's OCic.cbl
      *            8) added ( ) and , to scanner
      *
      * n.b. except for testing changeformat.cbl itself,
      * testing a program means getting a clean compile of
      * the converted code  -- no actual execution of
      * converted code
      *
      * 2014-10-29 v1.0.2
      *            1) added ws-after pd-after and nocc1
      *               command line optionss
      *
      * 2014-11-06 - .03 - Vincent Coen
      *          * 1) Extra function to support path as 2nd arg to
      *               allow for block format change/migrations.
      *               using O/P arg to be path/ | path\
      *               See sample bash script that would be needed.
      *
      * 2014-11-13 1) changed compute fixed-start = 65 - t + 1
      *                    to compute fixed-start = 72 - t + 1
      *            2) removed subtract 2 from break the
      *               line before wordx
      *
      * 2019-04-30 - .04 - Simon Sobisch
      *            1) don't change casing in comment lines
      *            2) disabled 2014-10-20 2) as the indent must
      *               stay in existing lines with area A
      *               not un-indent lines without it
      *
      * 2022-01-01 - .04 - Chuck Haatvedt
      *            1) change the CONVERT-TO-FIXED paragraph
      *               to move the check for a blank line to the
      *               beginning of the paragraph and if it is a
      *               blank line, then process it and
      *               EXIT PARAGRAPH.
      *
      *               This avoids falling in a zero subscript
      *               problem in the next if statement.
      *=======================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT INPUT-FILE
               ASSIGN TO INPUT-FILE-NAME
               FILE STATUS IS INPUT-FILE-STATUS
               ORGANIZATION IS LINE SEQUENTIAL.

            SELECT OUTPUT-FILE
               ASSIGN TO OUTPUT-FILE-NAME
               FILE STATUS IS OUTPUT-FILE-STATUS
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD PIC X(256).

       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD        PIC X(256).
       01  OUTPUT-RECORD-FIXED  PIC X(80).

       WORKING-STORAGE SECTION.
       01  PROGRAM-VERSION     PIC X(15)     VALUE "chgfmt v1.00.04".
       01  OUTPUT-FILE-NAME    PIC X(512)    VALUE SPACES.
       01  OUTPUT-FILE-STATUS  PIC XX.
      *
       01  OS-SLASH-CHAR       PIC X         VALUE SPACE.
       01  XA                  PIC 9999 COMP VALUE ZERO.
      *
      * // 01  area-a-indent pic 9.
       01  FIXED-START PIC 999.
       01  FIXED-LENGTH PIC 999.
       01  FIXED-END PIC 999.
       01  S PIC 999.
       01  T PIC 999.

       01  INPUT-FILE-NAME PIC X(128).
       01  INPUT-FILE-STATUS PIC XX.
       01  CHANGE PIC X(16) VALUE SPACES.
       01  OPTION1 PIC X(8) VALUE SPACES.
       01  OPTION2 PIC X(8) VALUE SPACES.
       01  OPTION3 PIC X(8) VALUE SPACES.
       01  OPTION4 PIC X(8) VALUE SPACES.
       01  OPTION5 PIC X(8) VALUE SPACES.

       01  WS-AFTER PIC X VALUE 'n'.
       01  PD-AFTER PIC X VALUE 'n'.
       01  CC1 PIC X VALUE 'y'.

       01  SCAN-VALUES.
           03 SCAN-TYPE PIC 99.
           03 SCAN-START PIC 999.
           03 SCAN-LENGTH PIC 999.
           03 SCAN-END PIC 999.

       01  SCAN-CONTROL.
           03  COBOL-CURRENT PIC XX.
           03  LINE-NUMBER PIC 9(6).
           03  RECORD-TYPE PIC X(8).
           03  RECX-MAX PIC 999.
           03  RECX-BEGIN PIC 999.
           03  RECX-END PIC 999.
           03  RECX-START PIC 999.
           03  SCAN-STATE PIC 99.
           03  WORDX PIC 99.
           03  WORDX-MAX PIC 99.
           03  WORDX-LIM PIC 99 VALUE 64.
           03  WORD-VALUES OCCURS 64.
               05  WORD-TYPE PIC 99.
               05  WORD-START PIC 999.
               05  WORD-LENGTH PIC 999.
               05  WORD-END PIC 999.

       01  WORK-CONTROL.
           03  WOUTX PIC 999.
           03  WOUTX-MAX PIC 999.
           03  WOUTX-LIM PIC 999 VALUE 20.
           03  WORK-OUTPUT-AREA OCCURS 20.
               05  WORK-OUTPUT-LEN PIC 999.
               05  WORK-OUTPUT PIC X(256).

       01  COMMENT-CONTROL.
           03  COUTX PIC 999.
           03  COUTX-MAX PIC 999.
           03  COUTX-LIM PIC 999 VALUE 20.
           03  COMMENT-OUTPUT-AREA OCCURS 20.
               05  COMMENT-OUTPUT-LEN PIC 999.
               05  COMMENT-OUTPUT PIC X(256).

       01  PROCESS-STATE.
           03  FORMAT-TYPE PIC X(5).

       01  RUN-LINE PIC X(72).
       01  WORK-RECORD PIC X(256).
       01  WORK-WORD PIC X(16).
       01  DONT-CONVERT PIC X VALUE SPACE.

       01  BREAK-POINT PIC 999.
       01  QUOTE-STATE PIC 9.
       01  LAST-SPACE PIC 999.
       01  TEST-RECORD PIC X(256).

       01  PATTERN-INFO.
           03  PATTERN-RESULT PIC X.
           03  PATTERN-CODE PIC X(8).
           03  PATTERN-VALUE PIC X(30).
           03  PATTERN-WORD PIC X(30).

      *  pattern tables
       01  COBOL-TABLE.
           03  PIC X(28) VALUE '1216        IDENTIFICATION'.
           03  PIC X(28) VALUE 'SF16ID      DIVISION'.
           03  PIC X(28) VALUE 'S116PID     PROGRAM-ID'.
           03  PIC X(28) VALUE '1216        ENVIRONMENT'.
           03  PIC X(28) VALUE 'SF16ED      DIVISION'.
           03  PIC X(28) VALUE '1216        DATA'.
           03  PIC X(28) VALUE 'SF16DD      DIVISION'.
           03  PIC X(28) VALUE '1216        WORKING-STORAGE'.
           03  PIC X(28) VALUE 'SF16WS      SECTION'.
           03  PIC X(28) VALUE '1216        LOCAL-STORAGE'.
           03  PIC X(28) VALUE 'SF16XS      SECTION'.
           03  PIC X(28) VALUE '1216        SCREEN'.
           03  PIC X(28) VALUE 'SF16WS      SECTION'.
           03  PIC X(28) VALUE '1216        LINKAGE'.
           03  PIC X(28) VALUE 'SF16LS      SECTION'.
           03  PIC X(28) VALUE '1216        REPORT'.
           03  PIC X(28) VALUE 'SF16RS      SECTION'.
           03  PIC X(28) VALUE '1216        PROCEDURE'.
           03  PIC X(28) VALUE 'SF16PD      DIVISION'.
           03  PIC X(28) VALUE '1F16        END'.
           03  PIC X(28) VALUE 'SF16END     PROGRAM'.

       PROCEDURE DIVISION CHAINING INPUT-FILE-NAME OUTPUT-FILE-NAME
           CHANGE OPTION1 OPTION2 OPTION3 OPTION4 OPTION5.
       START-CHANGEFORMAT.

           IF INPUT-FILE-NAME = OUTPUT-FILE-NAME
               MOVE 'ERROR: input and output files are identical' TO
                                                           RUN-LINE
               PERFORM ABORT-RUN
           END-IF

           EVALUATE TRUE
           WHEN 'TOFIXED' = UPPER-CASE(CHANGE)
               MOVE 'TOFIXED' TO CHANGE
           WHEN 'TOFREE' = UPPER-CASE(CHANGE)
               MOVE 'TOFREE' TO CHANGE
           WHEN OTHER
               MOVE 'valid change values are:' TO RUN-LINE
               DISPLAY RUN-LINE END-DISPLAY
               MOVE '    TOFREE, TOFIXED' TO RUN-LINE
               DISPLAY RUN-LINE END-DISPLAY
               MOVE 'ERROR: no valid change function specified' TO
                                                           RUN-LINE
               PERFORM ABORT-RUN
           END-EVALUATE
      *  default format-type
           MOVE 'FIXED' TO FORMAT-TYPE

           IF 'WS-AFTER' = UPPER-CASE(OPTION1) OR UPPER-CASE(OPTION2)
                                             OR UPPER-CASE(OPTION3)
           OR UPPER-CASE(OPTION4) OR UPPER-CASE(OPTION5)
               MOVE 'y' TO WS-AFTER
           END-IF
           IF 'PD-AFTER' = UPPER-CASE(OPTION1) OR UPPER-CASE(OPTION2)
                                             OR UPPER-CASE(OPTION3)
           OR UPPER-CASE(OPTION4) OR UPPER-CASE(OPTION5)
               MOVE 'y' TO PD-AFTER
           END-IF
           IF 'NOCC1' = UPPER-CASE(OPTION1) OR UPPER-CASE(OPTION2) OR
                                                UPPER-CASE(OPTION3)
           OR UPPER-CASE(OPTION4) OR UPPER-CASE(OPTION5)
               MOVE 'n' TO CC1
           END-IF
      *
      * Code supporting .03 for O/P being a path/ used for bulk
      *                                                      conversions
      *   so 1st, see if it is by seeing what the trailing char is =
      *   / | \ | or A/N
      *
           PERFORM  VARYING XA FROM 512 BY -1
                     UNTIL OUTPUT-FILE-NAME (XA:1) NOT = SPACE
                       OR  XA < 2
              CONTINUE
           END-PERFORM
           IF       XA < 2
                    MOVE "ERROR: O/P path too short" TO RUN-LINE
                    PERFORM ABORT-RUN
           END-IF
           MOVE     OUTPUT-FILE-NAME (XA:1) TO OS-SLASH-CHAR.
           IF       OS-SLASH-CHAR NOT = "/" AND NOT = "\"
                    GO TO START-NORMAL-PROCESSES
           END-IF
      *
      *                                              if tilde bad path
           IF       OUTPUT-FILE-NAME (1:1) = "~"
                    MOVE "ERROR: Path starts with an Invalid char '~'"
                                                        TO RUN-LINE
                    PERFORM ABORT-RUN
           END-IF
           ADD      1 TO XA.
      *
      * Now we change the file name case depending on type of process
      *   eg, TOFIXED = upper or TOFREE = lower
      *
           IF       CHANGE = "TOFIXED"
                    STRING   UPPER-CASE (INPUT-FILE-NAME) DELIMITED BY
                                                               SIZE
                               INTO OUTPUT-FILE-NAME POINTER XA
                      ON OVERFLOW
                                MOVE "ERROR: Path/name too long (512)"
                                                        TO RUN-LINE
                                PERFORM ABORT-RUN
                    END-STRING
           ELSE
                    STRING   LOWER-CASE (INPUT-FILE-NAME) DELIMITED BY
                                                               SIZE
                               INTO OUTPUT-FILE-NAME POINTER XA
                      ON OVERFLOW
                                MOVE "ERROR: Path/name too long (512)"
                                                        TO RUN-LINE
                                PERFORM ABORT-RUN
                    END-STRING
           END-IF.
      *
      *  We are done, so can continue with normal processing.
      *
       START-NORMAL-PROCESSES.
          OPEN OUTPUT OUTPUT-FILE
          PERFORM CHECK-OUTPUT-FILE
          EVALUATE TRUE
          WHEN CHANGE = 'TOFREE'
              WRITE OUTPUT-RECORD
                  FROM '       >>SOURCE FORMAT IS FREE'
              END-WRITE
          WHEN CHANGE = 'TOFIXED'
              WRITE OUTPUT-RECORD-FIXED
                  FROM '       >>SOURCE FORMAT IS FIXED'
              END-WRITE
          END-EVALUATE

          MOVE 0 TO LINE-NUMBER
      * // move 0 to area-a-indent

          OPEN INPUT INPUT-FILE
          PERFORM CHECK-INPUT-FILE
          READ INPUT-FILE END-READ
          PERFORM CHECK-INPUT-FILE
          PERFORM UNTIL INPUT-FILE-STATUS = '10'
              ADD 1 TO LINE-NUMBER END-ADD
              CALL 'classifyrecord' USING INPUT-RECORD SCAN-CONTROL
                  PROCESS-STATE END-CALL

              IF RECORD-TYPE <> 'FORMAT'
                  PERFORM PROCESS-RECORD
              END-IF

              READ INPUT-FILE END-READ
              PERFORM CHECK-INPUT-FILE
          END-PERFORM

          CLOSE INPUT-FILE
          CLOSE OUTPUT-FILE
          DISPLAY PROGRAM-VERSION " Completed successfully".
          STOP RUN.
      *
       CHECK-OUTPUT-FILE.
           IF OUTPUT-FILE-STATUS <> '00'
               DISPLAY OUTPUT-FILE-STATUS
                   SPACE 'open failure'
                   SPACE OUTPUT-FILE-NAME
               END-DISPLAY
               STOP RUN
           END-IF
           .
       CHECK-INPUT-FILE.
           IF INPUT-FILE-STATUS <> '00' AND '10'
               DISPLAY INPUT-FILE-STATUS
                   SPACE 'open failure'
                   SPACE INPUT-FILE-NAME
               END-DISPLAY
               STOP RUN
           END-IF
           .
       PROCESS-RECORD.
      *  find out where we are in the program
           CALL 'parsepattern' USING COBOL-TABLE PATTERN-INFO
               INPUT-RECORD SCAN-CONTROL END-CALL
           IF PATTERN-CODE <> SPACE
               MOVE PATTERN-CODE TO COBOL-CURRENT
           END-IF

           MOVE 0 TO WOUTX-MAX
           MOVE 0 TO COUTX-MAX

      *  apply the change

           IF RECORD-TYPE <> 'COMMENT'
               PERFORM CHANGE-CASE
           END-IF
           EVALUATE CHANGE ALSO FORMAT-TYPE
           WHEN 'TOFIXED' ALSO 'FIXED'
           WHEN 'TOFREE' ALSO 'FREE'
               PERFORM INCREMENT-WOUTX-MAX
               MOVE INPUT-RECORD TO WORK-OUTPUT(WOUTX-MAX)
           WHEN 'TOFIXED' ALSO 'FREE'
               PERFORM CONVERT-TO-FIXED
           WHEN 'TOFREE' ALSO 'FIXED'
               PERFORM CONVERT-TO-FREE
           END-EVALUATE

      *  write the output record(s)
           EVALUATE TRUE
           WHEN COBOL-CURRENT = 'WS' AND WS-AFTER = 'y'
           WHEN COBOL-CURRENT = 'PD' AND PD-AFTER = 'y'
               PERFORM OUTPUT-WORK
               PERFORM OUTPUT-COMMENT
           WHEN COBOL-CURRENT = 'WS' AND WS-AFTER = 'n'
           WHEN COBOL-CURRENT = 'PD' AND PD-AFTER = 'n'
               PERFORM OUTPUT-COMMENT
               PERFORM OUTPUT-WORK
           WHEN OTHER
               PERFORM OUTPUT-COMMENT
               PERFORM OUTPUT-WORK
           END-EVALUATE
           .
       OUTPUT-WORK.
           PERFORM VARYING WOUTX FROM 1 BY 1
           UNTIL WOUTX > WOUTX-MAX
               EVALUATE TRUE
               WHEN CHANGE = 'TOFIXED'
                   WRITE OUTPUT-RECORD-FIXED
                       FROM WORK-OUTPUT(WOUTX)(1:80) END-WRITE
               WHEN CHANGE = 'TOFREE'
                   WRITE OUTPUT-RECORD
                       FROM WORK-OUTPUT(WOUTX) END-WRITE
               END-EVALUATE
               PERFORM CHECK-OUTPUT-FILE
           END-PERFORM
           .
       OUTPUT-COMMENT.
           PERFORM VARYING COUTX FROM 1 BY 1
           UNTIL COUTX > COUTX-MAX
               EVALUATE TRUE
               WHEN CHANGE = 'TOFIXED'
                   WRITE OUTPUT-RECORD-FIXED
                       FROM COMMENT-OUTPUT(COUTX)(1:80) END-WRITE
               WHEN CHANGE = 'TOFREE'
                   WRITE OUTPUT-RECORD
                       FROM COMMENT-OUTPUT(COUTX) END-WRITE
               END-EVALUATE
               PERFORM CHECK-OUTPUT-FILE
           END-PERFORM
           .
       CHANGE-CASE.
           MOVE INPUT-RECORD TO WORK-RECORD
           PERFORM VARYING WORDX FROM 1 BY 1
           UNTIL WORDX > WORDX-MAX
               MOVE WORD-VALUES(WORDX) TO SCAN-VALUES
               MOVE UPPER-CASE(INPUT-RECORD(SCAN-START:SCAN-LENGTH)) TO
                                                          WORK-WORD
               EVALUATE TRUE
               WHEN DONT-CONVERT = '2'
      *          don't convert this word
                   MOVE SPACE TO DONT-CONVERT
               WHEN WORK-WORD = 'PROGRAM-ID'
               WHEN WORK-WORD = 'END'
      *          don't convert the second word after this one
                   MOVE '1' TO DONT-CONVERT
                   PERFORM CHANGE-WORD
               WHEN WORK-WORD = 'PROGRAM'
                   IF DONT-CONVERT = 1
      *              don't convert the next word
                       MOVE '2' TO DONT-CONVERT
                   END-IF
                   PERFORM CHANGE-WORD
               WHEN WORK-WORD = 'COPY'
               WHEN WORK-WORD = 'INCLUDE'
      *          don't convert the next word
                   MOVE '2' TO DONT-CONVERT
                   PERFORM CHANGE-WORD
      *                            leading alpha
               WHEN SCAN-TYPE = 3
      *                            leading non-alpha
               WHEN SCAN-TYPE = 6
                   PERFORM CHANGE-WORD
                   MOVE SPACE TO DONT-CONVERT
               WHEN DONT-CONVERT = '1'
                   MOVE '2' TO DONT-CONVERT
               END-EVALUATE
           END-PERFORM
           MOVE WORK-RECORD TO INPUT-RECORD
           .
       CHANGE-WORD.
           EVALUATE TRUE
           WHEN CHANGE = 'TOFIXED'
               MOVE UPPER-CASE(INPUT-RECORD(SCAN-START:SCAN-LENGTH))
               TO WORK-RECORD(SCAN-START:SCAN-LENGTH)
           WHEN CHANGE = 'TOFREE'
               MOVE LOWER-CASE(INPUT-RECORD(SCAN-START:SCAN-LENGTH))
               TO WORK-RECORD(SCAN-START:SCAN-LENGTH)
           END-EVALUATE
           .
       CONVERT-TO-FIXED.
           CALL 'scancobol' USING INPUT-RECORD SCAN-CONTROL END-CALL

      * start embedded test if running changeformat on itself
      *    move
      * ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      *                '''''''''''''''''''''''''''''''''' to test-record
      *    move
      * """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      *                """""""""""""""""""""""""""""""""" to test-record
      * end embedded test

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *                                                               *
      *    IF THE INPUT RECORD IS A BLANK RECORD THEN PROCESS IT      *
      *    AND EXIT THE PARAGRAPH.                                    *
      *                                                               *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

      *  output a blank record
           IF RECORD-TYPE = 'BLANK'
               PERFORM INCREMENT-WOUTX-MAX
               EXIT PARAGRAPH
           END-IF.

      *  convert and remove any comment from input-record
      *                                 free comment
           IF WORD-TYPE(WORDX-MAX) = 9
               MOVE WORD-VALUES(WORDX-MAX) TO SCAN-VALUES
               EVALUATE TRUE
               WHEN INPUT-RECORD(SCAN-START + 2:) = SPACES
      *          empty comment
                   PERFORM INCREMENT-COUTX-MAX
                   MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
               WHEN SCAN-END <= 67
      *          comment fits
                   PERFORM INCREMENT-COUTX-MAX
                   MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
                   MOVE INPUT-RECORD(SCAN-START + 2:SCAN-LENGTH - 2)
                       TO COMMENT-OUTPUT(COUTX-MAX)(7 +
                                        SCAN-START:SCAN-LENGTH - 2)
               WHEN OTHER
      *          comment text is beyond the fixed limit
                   PERFORM CONVERT-COMMENT
               END-EVALUATE
      *      remove the comment
               MOVE SPACES TO INPUT-RECORD(SCAN-START:)
               COMPUTE WORDX-MAX = WORDX-MAX - 1 END-COMPUTE
           END-IF

      *  remove a debug marker from the line
           IF RECORD-TYPE = 'DEBUG'
               MOVE WORD-VALUES(1) TO SCAN-VALUES
               MOVE SPACES TO INPUT-RECORD(SCAN-START:SCAN-LENGTH)
               IF INPUT-RECORD = SPACES
                   PERFORM INCREMENT-WOUTX-MAX
                   MOVE 'd' TO WORK-OUTPUT(WOUTX-MAX)(7:1)
               END-IF
           END-IF

      *  output a blank record
           IF RECORD-TYPE = 'BLANK'
               PERFORM INCREMENT-WOUTX-MAX
           END-IF

      * at this point we have removed comments, removed debug markers
      * and put an empty input-record

      * // *>==============================================
      * // *>  area-a-indent is the indent found before an
      * // *>  area A word.  It may be 0. It is subtracted
      * // *>  from fixed-start for all free words in all free
      * // *>  records subordinate to the area A word
      * // *>
      * // *>  we assume the free text uses input-record(1:4)
      * // *>  as area A.  if not, then not
      * // *>===================================================
      * // *> check area A for an indent
      * //     if wordx-max > 0
      * //     and word-start(1) <= 4
      * //         compute area-a-indent = word-start(1) - 1 end-compute
      * //     end-if

      * we now move free words until input-record is empty
           PERFORM UNTIL INPUT-RECORD = SPACES
               CALL 'scancobol' USING INPUT-RECORD SCAN-CONTROL
                                                           END-CALL

      *      check to see of we need to break the line
               PERFORM VARYING WORDX FROM 1 BY 1
               UNTIL WORDX > WORDX-MAX
      * //      compute fixed-end = 7 - area-a-indent + word-end(wordx)
      *                                                      end-compute
                  COMPUTE FIXED-END = 7 + WORD-END(WORDX) END-COMPUTE
                  IF FIXED-END > 71
                       EXIT PERFORM
                  END-IF
               END-PERFORM

               EVALUATE TRUE
               WHEN WORDX > WORDX-MAX
      *          the entire line fits
                   PERFORM INCREMENT-WOUTX-MAX
                   IF RECORD-TYPE = 'DEBUG'
                       MOVE 'd' TO WORK-OUTPUT(WOUTX-MAX)(7:1)
                   END-IF
                   MOVE WORD-START(1) TO SCAN-START
      * //       compute fixed-start = 7 - area-a-indent + scan-start
      *                                                      end-compute
                   COMPUTE FIXED-START = 7 + SCAN-START END-COMPUTE
                   COMPUTE FIXED-LENGTH = RECX-MAX - SCAN-START + 1
                                                        END-COMPUTE
                   MOVE INPUT-RECORD(SCAN-START:FIXED-LENGTH)
                       TO WORK-OUTPUT(WOUTX-MAX)(
                                          FIXED-START:FIXED-LENGTH)
                   MOVE SPACES TO INPUT-RECORD(SCAN-START:FIXED-LENGTH)
              WHEN WORDX = 1
      *          the first word ends beyond column 71. assumed to be a
      *                                                          literal

      *          break the word into two parts with the length of the
      *                                                       first part
      *          less than or equal to 60 and insert close-quote &
      *                                                       open-quote
      *          between the parts

                   MOVE WORD-VALUES(1) TO SCAN-VALUES
                   MOVE 0 TO QUOTE-STATE
                   MOVE 0 TO LAST-SPACE
                   PERFORM VARYING S FROM 1 BY 1
                   UNTIL S > 60 - SCAN-START + 1
      *              check for an embedded quote
                       EVALUATE INPUT-RECORD(SCAN-START + S:1) ALSO
                                                        QUOTE-STATE
                       WHEN INPUT-RECORD(SCAN-START:1) ALSO 0
      *                  a first embedded quote
                           MOVE 1 TO QUOTE-STATE
                       WHEN INPUT-RECORD(SCAN-START:1) ALSO 1
      *                  a second embedded quote
                           MOVE 0 TO QUOTE-STATE
                           MOVE S TO BREAK-POINT
                       WHEN SPACE ALSO ANY
                           MOVE S TO LAST-SPACE
                           MOVE S TO BREAK-POINT
                       WHEN OTHER
                           MOVE S TO BREAK-POINT
                       END-EVALUATE
                   END-PERFORM
      *          break at a space, if possible
                   IF LAST-SPACE > BREAK-POINT - 10
                       MOVE LAST-SPACE TO BREAK-POINT
                   END-IF

                   MOVE SPACES TO WORK-RECORD
                   EVALUATE TRUE
      *                                single-quoted literal
                   WHEN SCAN-TYPE = 1
                       STRING INPUT-RECORD(1:SCAN-START + BREAK-POINT)
                           "' & '" DELIMITED BY SIZE
                           INPUT-RECORD(SCAN-START + BREAK-POINT + 1:)
                           DELIMITED BY SIZE INTO WORK-RECORD
                       END-STRING
      *                                double-quoted literal
                   WHEN SCAN-TYPE = 2
                       STRING INPUT-RECORD(1:SCAN-START + BREAK-POINT)
                           '" & "'
                           INPUT-RECORD(SCAN-START + BREAK-POINT + 1:)
                           DELIMITED BY SIZE INTO WORK-RECORD
                       END-STRING
                   END-EVALUATE
                   MOVE WORK-RECORD TO INPUT-RECORD
               WHEN OTHER

      *          break the line before wordx
                   SUBTRACT 1 FROM WORDX
                   MOVE WORD-START(1) TO SCAN-START
      * //       compute fixed-start = 7 - area-a-indent + scan-start
      *                                                      end-compute
                   COMPUTE FIXED-START = 7 + SCAN-START END-COMPUTE
                   COMPUTE FIXED-LENGTH = WORD-END(WORDX) - SCAN-START
                                                                + 1
                   PERFORM INCREMENT-WOUTX-MAX
                   IF RECORD-TYPE = 'DEBUG'
                       MOVE 'd' TO WORK-OUTPUT(WOUTX-MAX)(7:1)
                   END-IF
                   MOVE INPUT-RECORD(SCAN-START:FIXED-LENGTH)
                       TO WORK-OUTPUT(WOUTX-MAX)(
                                          FIXED-START:FIXED-LENGTH)
                   MOVE SPACES TO INPUT-RECORD(SCAN-START:FIXED-LENGTH)

      *          rejustify the remainder
                   COMPUTE SCAN-START = WORD-END(WORDX) + 1
                   COMPUTE SCAN-LENGTH = RECX-MAX - WORD-END(WORDX)
                   MOVE INPUT-RECORD(SCAN-START:) TO WORK-RECORD
                   IF SCAN-LENGTH > 60
      *              punt
                       MOVE WORK-RECORD TO INPUT-RECORD(1:)
                   ELSE
                       MOVE WORK-RECORD TO INPUT-RECORD(61 -
                                                      SCAN-LENGTH:)
                   END-IF
               END-EVALUATE
           END-PERFORM
           .
       CONVERT-COMMENT.
      *  comment text ends beyond the fixed limit

      *  find the start of the comment text
           COMPUTE S = SCAN-START + 2 END-COMPUTE
           PERFORM VARYING S
           FROM S BY 1
           UNTIL S > RECX-MAX
           OR INPUT-RECORD(S:1) <> SPACE
               CONTINUE
           END-PERFORM

      *  find the length of the comment text
           COMPUTE T = RECX-MAX - S + 1

           EVALUATE TRUE
           WHEN T <= 65
           AND WORDX-MAX > 1
      *      the comment text will fit right justified in the fixed area
               COMPUTE FIXED-START = 72 - T + 1 END-COMPUTE
               COMPUTE FIXED-LENGTH = T
               PERFORM INCREMENT-COUTX-MAX
               MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
               MOVE INPUT-RECORD(S:T) TO COMMENT-OUTPUT(COUTX-MAX)(
                                                     FIXED-START:T)
           WHEN WORDX-MAX > 1
      *      the comment is not the entire line
               PERFORM FIND-COMMENT-BREAK-POINT
               IF BREAK-POINT = 0
                   COMPUTE T = 65 - S + 1 END-COMPUTE
               ELSE
                   MOVE BREAK-POINT TO T
               END-IF
               COMPUTE FIXED-START = 7 + S END-COMPUTE
               PERFORM INCREMENT-COUTX-MAX
               MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
               MOVE INPUT-RECORD(S:T) TO COMMENT-OUTPUT(COUTX-MAX)(
                                                     FIXED-START:T)
               COMPUTE S = S + T END-COMPUTE
      *      continuations start in column 8
               PERFORM UNTIL S > RECX-MAX
                   PERFORM FIND-COMMENT-BREAK-POINT
                   IF BREAK-POINT = 0
                       MOVE 65 TO T
                   ELSE
                       MOVE BREAK-POINT TO T
                   END-IF
                   PERFORM INCREMENT-COUTX-MAX
                   MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
                   MOVE INPUT-RECORD(S:T) TO COMMENT-OUTPUT(COUTX-MAX)(
                                                               8:T)
                   COMPUTE S = S + T END-COMPUTE
               END-PERFORM
           WHEN OTHER
      *      the entire line is a comment
               COMPUTE S = SCAN-START + 2 END-COMPUTE
               PERFORM FIND-COMMENT-BREAK-POINT
               IF BREAK-POINT = 0
                   MOVE 65 TO T
               ELSE
                   MOVE BREAK-POINT TO T
               END-IF
               COMPUTE FIXED-START = 5 + S END-COMPUTE
               PERFORM INCREMENT-COUTX-MAX
               MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
               MOVE INPUT-RECORD(S:T) TO COMMENT-OUTPUT(COUTX-MAX)(
                                                     FIXED-START:T)
               COMPUTE S = S + T END-COMPUTE
      *      continuations are right justified
               PERFORM UNTIL S > RECX-MAX
                   PERFORM FIND-COMMENT-BREAK-POINT
                   IF BREAK-POINT = 0
                       MOVE 65 TO T
                   ELSE
                       MOVE BREAK-POINT TO T
                   END-IF
                   COMPUTE FIXED-START = 72 - T + 1
                   PERFORM INCREMENT-COUTX-MAX
                   MOVE '*' TO COMMENT-OUTPUT(COUTX-MAX)(7:1)
                   MOVE INPUT-RECORD(S:T) TO COMMENT-OUTPUT(COUTX-MAX)(
                                                     FIXED-START:T)
                   COMPUTE S = S + T END-COMPUTE
               END-PERFORM
           END-EVALUATE
           .
       FIND-COMMENT-BREAK-POINT.
           IF RECX-MAX - S + 1 <= 65
               COMPUTE BREAK-POINT = RECX-MAX - S + 1 END-COMPUTE
           ELSE
               MOVE 0 TO BREAK-POINT
               PERFORM VARYING T FROM 1 BY 1
               UNTIL S + T > RECX-MAX
               OR T > 65
      *          take the last space in the comment
                   IF INPUT-RECORD(S + T:1) = SPACE
                       MOVE T TO BREAK-POINT
                   END-IF
               END-PERFORM
               IF BREAK-POINT = 0
               AND S + T > RECX-MAX
                   COMPUTE BREAK-POINT = RECX-MAX - S + 1 END-COMPUTE
               END-IF
           END-IF
           .
       CONVERT-TO-FREE.
           IF WORDX-MAX > 0
      *      check for unclosed quotes at end of line
               EVALUATE TRUE
               WHEN WORD-TYPE(WORDX-MAX) = 10
      *          unclosed single quote
                   MOVE "'" TO INPUT-RECORD(73:1)
               WHEN WORD-TYPE(WORDX-MAX) = 11
      *          unclosed double quote
                   MOVE '"' TO INPUT-RECORD(73:1)
               END-EVALUATE
           END-IF

           EVALUATE TRUE
           WHEN RECORD-TYPE = 'BLANK'
               PERFORM INCREMENT-WOUTX-MAX
           WHEN RECORD-TYPE = 'COMMENT'
               PERFORM INCREMENT-WOUTX-MAX
               IF INPUT-RECORD(7:2) = '*>'
                   STRING INPUT-RECORD(7:) DELIMITED BY SIZE
                       INTO WORK-OUTPUT(WOUTX-MAX) END-STRING
               ELSE
                   STRING '*>' INPUT-RECORD(8:) DELIMITED BY SIZE
                       INTO WORK-OUTPUT(WOUTX-MAX) END-STRING
               END-IF
           WHEN RECORD-TYPE = 'DEBUG'
               PERFORM INCREMENT-WOUTX-MAX
               STRING '>>D' INPUT-RECORD(8:) DELIMITED BY SIZE
                   INTO WORK-OUTPUT(WOUTX-MAX) END-STRING
           WHEN RECORD-TYPE = 'CONTINUE'
               MOVE WORD-VALUES(1) TO SCAN-VALUES
               PERFORM INCREMENT-WOUTX-MAX
               STRING '& ' INPUT-RECORD(8:)
                   DELIMITED BY SIZE INTO WORK-OUTPUT(WOUTX-MAX)
               END-STRING
           WHEN CC1 = 'n'
               PERFORM INCREMENT-WOUTX-MAX
               MOVE INPUT-RECORD(8:) TO WORK-OUTPUT(WOUTX-MAX)(2:)
           WHEN OTHER
               PERFORM INCREMENT-WOUTX-MAX
               MOVE INPUT-RECORD(8:) TO WORK-OUTPUT(WOUTX-MAX)
           END-EVALUATE
           .
       INCREMENT-WOUTX-MAX.
           IF WOUTX-MAX >= WOUTX-LIM
               STRING 'ERROR: generated record count exceeds '
                                                          WOUTX-LIM
                   DELIMITED BY SIZE INTO RUN-LINE
               END-STRING
               PERFORM ABORT-RUN
           END-IF
           ADD 1 TO WOUTX-MAX END-ADD
           MOVE SPACES TO WORK-OUTPUT(WOUTX-MAX)
           .
       INCREMENT-COUTX-MAX.
           IF COUTX-MAX >= COUTX-LIM
               STRING 'ERROR: generated comment count exceeds '
                                                          COUTX-LIM
                   DELIMITED BY SIZE INTO RUN-LINE
               END-STRING
               PERFORM ABORT-RUN
           END-IF
           ADD 1 TO COUTX-MAX END-ADD
           MOVE SPACES TO COMMENT-OUTPUT(COUTX-MAX)
           .
       ABORT-RUN.
           DISPLAY PROGRAM-VERSION END-DISPLAY
           DISPLAY RUN-LINE END-DISPLAY
           CALL 'dumpscancontrol' USING INPUT-RECORD SCAN-CONTROL
                                                           END-CALL
           STOP RUN
           .
       END PROGRAM changeformat
       .
       IDENTIFICATION DIVISION.
       PROGRAM-ID. classifyrecord.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  PATTERN-INFO.
           03  PATTERN-RESULT PIC X.
           03  PATTERN-CODE PIC X(8).
           03  PATTERN-VALUE PIC X(30).
           03  PATTERN-WORD PIC X(30).

      *  pattern tables
       01  FORMAT-TABLE.
           03  PIC X(28) VALUE '3116        >>SOURCE'.
           03  PIC X(28) VALUE '1F16        >>'.
           03  PIC X(28) VALUE '1F16        SOURCE'.
           03  PIC X(28) VALUE '1116        FORMAT'.
           03  PIC X(28) VALUE '1116        IS'.
           03  PIC X(28) VALUE 'S116FORMAT  FREE'.
           03  PIC X(28) VALUE 'SF16FORMAT  FIXED'.

       01  FREE-TABLE.
           03  PIC X(28) VALUE 'S102COMMENT *>'.
           03  PIC X(28) VALUE 'S103DEBUG   >>D'.
           03  PIC X(28) VALUE 'SS01TEXT     '.

       01  RUN-LINE PIC X(72).

       01  SCAN-VALUES.
           03 SCAN-TYPE PIC 99.
           03 SCAN-START PIC 999.
           03 SCAN-LENGTH PIC 999.
           03 SCAN-END PIC 999.

       LINKAGE SECTION.
       01  INPUT-RECORD PIC X(256).

       01  SCAN-CONTROL.
           03  COBOL-CURRENT PIC XX.
           03  LINE-NUMBER PIC 9(6).
           03  RECORD-TYPE PIC X(8).
           03  RECX-MAX PIC 999.
           03  RECX-BEGIN PIC 999.
           03  RECX-END PIC 999.
           03  RECX-START PIC 999.
           03  SCAN-STATE PIC 99.
           03  WORDX PIC 99.
           03  WORDX-MAX PIC 99.
           03  WORDX-LIM PIC 99 VALUE 64.
           03  WORD-VALUES OCCURS 64.
               05  WORD-TYPE PIC 99.
               05  WORD-START PIC 999.
               05  WORD-LENGTH PIC 999.
               05  WORD-END PIC 999.

       01  PROCESS-STATE.
           03  FORMAT-TYPE PIC X(5).

       PROCEDURE DIVISION USING INPUT-RECORD SCAN-CONTROL
           PROCESS-STATE.
       START-CLASSIFYRECORD.
      *  scan as a fixed format-type
           MOVE 7 TO RECX-BEGIN
           MOVE 72 TO RECX-END
           CALL 'scancobol' USING INPUT-RECORD SCAN-CONTROL END-CALL

      *  check for >>SOURCE [FORMAT] [IS] (FREE/FIXED)
           CALL 'parsepattern' USING FORMAT-TABLE PATTERN-INFO
               INPUT-RECORD SCAN-CONTROL END-CALL
           IF PATTERN-RESULT = 'S'
      *      this is a >>SOURCE FORMAT line
               MOVE TRIM(PATTERN-VALUE) TO FORMAT-TYPE
               MOVE 'FORMAT' TO RECORD-TYPE
               GOBACK
           END-IF
           EVALUATE TRUE
           WHEN INPUT-RECORD = SPACES
               MOVE 'BLANK' TO RECORD-TYPE
           WHEN FORMAT-TYPE = 'FIXED'
               EVALUATE INPUT-RECORD(7:1)
               WHEN '*'
               WHEN '/'
                   MOVE 'COMMENT' TO RECORD-TYPE
               WHEN 'D'
               WHEN 'd'
                   MOVE 'DEBUG' TO RECORD-TYPE
               WHEN '-'
                   MOVE 'CONTINUE' TO RECORD-TYPE
               WHEN SPACE
                   MOVE 'TEXT' TO RECORD-TYPE
               WHEN OTHER
                   STRING
                     'ERROR: invalid fixed record type in column 7'
                       SPACE INPUT-RECORD(7:1)
                       SPACE INPUT-RECORD
                       DELIMITED BY SIZE INTO RUN-LINE
                   END-STRING
      *          perform abort-run
               END-EVALUATE
           WHEN FORMAT-TYPE = 'FREE'
      *      rescan the record as FREE
               MOVE 1 TO RECX-BEGIN
               MOVE LENGTH OF INPUT-RECORD TO RECX-END
               CALL 'scancobol' USING INPUT-RECORD SCAN-CONTROL
                                                           END-CALL
               CALL 'parsepattern' USING FREE-TABLE PATTERN-INFO
                   INPUT-RECORD SCAN-CONTROL END-CALL
               MOVE PATTERN-CODE TO RECORD-TYPE
           WHEN OTHER
               MOVE 'ERROR: source format is neither FIXED nor FREE'
                   TO RUN-LINE
               PERFORM ABORT-RUN
           END-EVALUATE

           GOBACK
           .
       ABORT-RUN.
           DISPLAY RUN-LINE END-DISPLAY
           CALL 'dumpscancontrol' USING INPUT-RECORD SCAN-CONTROL
                                                           END-CALL
           STOP RUN
           .
       END PROGRAM classifyrecord
       .
       IDENTIFICATION DIVISION.
       PROGRAM-ID. parsepattern.

      *=====================================================
      * We're not parsing COBOL here, but just look at
      * input records and categorizing them with a simple
      * pattern recognizer.
      *=====================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY. FUNCTION ALL INTRINSIC.
       SPECIAL-NAMES. C01 IS ONE-PAGE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  MATCH-IDX PIC 99.
       01  W PIC 999.
       01  L PIC 999.

       01  TEST-WORD PIC X(16).
       01  TEST-LENGTH PIC 99.

       LINKAGE SECTION.
       01  PATTERN-TABLE.
           03  COMMAND OCCURS 64.
               05  MATCH-SUCCESS.
                   07  MATCH-SUCCESS-N PIC 9.
               05  MATCH-FAILURE.
                   07  MATCH-FAILURE-N PIC 9.
               05  MATCH-LENGTH PIC 99.
               05  MATCH-CODE PIC X(8).
               05  MATCH-VALUE PIC X(16).

       01  PATTERN-INFO.
           03  PATTERN-RESULT.
               05  PATTERN-RESULT-N PIC 9.
           03  PATTERN-CODE PIC X(8).
           03  PATTERN-VALUE PIC X(30).
           03  PATTERN-WORD PIC X(30).

       01  RECORD-TEXT PIC X(256).

       01  SCAN-CONTROL.
           03  COBOL-CURRENT PIC XX.
           03  LINE-NUMBER PIC 9(6).
           03  RECORD-TYPE PIC X(8).
           03  RECX-MAX PIC 999.
           03  RECX-BEGIN PIC 999.
           03  RECX-END PIC 999.
           03  RECX-START PIC 999.
           03  SCAN-STATE PIC 99.
           03  WORDX PIC 99.
           03  WORDX-MAX PIC 99.
           03  WORDX-LIM PIC 99 VALUE 64.
           03  WORD-VALUES OCCURS 64.
               05  WORD-TYPE PIC 99.
               05  WORD-START PIC 999.
               05  WORD-LENGTH PIC 999.
               05  WORD-END PIC 999.

       PROCEDURE DIVISION USING PATTERN-TABLE PATTERN-INFO
           RECORD-TEXT SCAN-CONTROL.
       START-PARSEPATTERN.
           MOVE SPACES TO PATTERN-INFO
           IF WORDX-MAX = 0
      *      blank line
               MOVE 'F' TO PATTERN-RESULT
               GOBACK
           END-IF
           MOVE 1 TO MATCH-IDX WORDX
           MOVE 0 TO PATTERN-RESULT-N
           PERFORM UNTIL PATTERN-RESULT = 'S' OR 'F'
           OR WORDX > WORDX-MAX
               ADD PATTERN-RESULT-N TO MATCH-IDX END-ADD
               MOVE WORD-START(WORDX) TO W
               MOVE WORD-LENGTH(WORDX) TO L
               UNSTRING RECORD-TEXT(W:L) INTO PATTERN-WORD END-UNSTRING
               MOVE UPPER-CASE(PATTERN-WORD) TO PATTERN-VALUE
               MOVE MATCH-LENGTH(MATCH-IDX) TO TEST-LENGTH
               IF PATTERN-VALUE(1:TEST-LENGTH) = MATCH-VALUE(MATCH-IDX)
                   MOVE MATCH-SUCCESS(MATCH-IDX) TO PATTERN-RESULT
                   ADD 1 TO WORDX END-ADD
               ELSE
                   MOVE MATCH-FAILURE(MATCH-IDX) TO PATTERN-RESULT
               END-IF
               MOVE MATCH-CODE(MATCH-IDX) TO PATTERN-CODE
           END-PERFORM
           IF PATTERN-RESULT <> 'S' AND 'F'
      *      success with missing optionals/alternatives
               MOVE 'S' TO PATTERN-RESULT
           END-IF
           GOBACK
           .
       END PROGRAM parsepattern.

       IDENTIFICATION DIVISION.
       PROGRAM-ID.  scancobol.
       DATA DIVISION.
       LINKAGE SECTION.
       01  INPUT-RECORD PIC X(256).
       01  SCAN-CONTROL.
           03  COBOL-CURRENT PIC XX.
           03  LINE-NUMBER PIC 9(6).
           03  RECORD-TYPE PIC X(8).
           03  RECX-MAX PIC 999.
           03  RECX-BEGIN PIC 999.
           03  RECX-END PIC 999.
           03  RECX-START PIC 999.
           03  SCAN-STATE PIC 99.
               88  NOTHING-FOUND VALUE 0.
               88  START-SINGLE-QUOTE VALUE 1.
               88  START-DOUBLE-QUOTE VALUE 2.
               88  START-LEADING-ALPHA VALUE 3.
               88  SINGLE-QUOTE-IN-SINGLE-QUOTE VALUE 4.
               88  DOUBLE-QUOTE-IN-DOUBLE-QUOTE VALUE 5.
               88  START-LEADING-NONALPHA VALUE 6.
               88  ISOLATED-PERIOD VALUE 7.
               88  START-FREE-COMMENT VALUE 8.
               88  FREE-COMMENT VALUE 9.
               88  UNCLOSED-SINGLE-QUOTE VALUE 10.
               88  UNCLOSED-DOUBLE-QUOTE VALUE 11.
           03  WORDX PIC 99.
           03  WORDX-MAX PIC 99.
           03  WORDX-LIM PIC 99 VALUE 64.
           03  WORD-VALUES OCCURS 64.
               05  WORD-TYPE PIC 99.
               05  WORD-START PIC 999.
               05  WORD-LENGTH PIC 999.
               05  WORD-END PIC 999.

       PROCEDURE DIVISION USING INPUT-RECORD SCAN-CONTROL.
       START-SCANCOBOL.
           MOVE 0 TO WORDX-MAX
           MOVE 0 TO SCAN-STATE
           PERFORM VARYING RECX-MAX FROM RECX-BEGIN BY 1
           UNTIL RECX-MAX > RECX-END
           OR INPUT-RECORD(RECX-MAX:) = SPACES
               EVALUATE SCAN-STATE ALSO INPUT-RECORD(RECX-MAX:1)
      *                           nothing found
               WHEN 0 ALSO SPACE
      *                         not interesting
               WHEN 0 ALSO ';'
      *                           not interesting
               WHEN 0 ALSO X'09'
                   CONTINUE
               WHEN 0 ALSO '('
               WHEN 0 ALSO ')'
      *                         isolated (leading) comma
               WHEN 0 ALSO ','
      *                         isolated (leading) period
               WHEN 0 ALSO '.'
      *                         isolated (leading) ampersand
               WHEN 0 ALSO '&'
                   MOVE 7 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
                   PERFORM STOP-WORD
      *                         maybe a comment
               WHEN 0 ALSO '*'
                   MOVE 8 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
      *                         start a single quote literal
               WHEN 0 ALSO "'"
                   MOVE 1 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
      *                         start a double quote literal
               WHEN 0 ALSO '"'
                   MOVE 2 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
      *                                start leading alphabetic
               WHEN 0 ALSO ALPHABETIC
                   MOVE 3 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
      *                         start leading non-alphabetic
               WHEN 0 ALSO ANY
                   MOVE 6 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START

      *                         single quote in single quote
               WHEN 1 ALSO "'"
                   MOVE 4 TO SCAN-STATE
      *                         continuing the single quote
               WHEN 1 ALSO ANY
                   CONTINUE
      *                         double quote in double quote
               WHEN 2 ALSO '"'
                   MOVE 5 TO SCAN-STATE
      *                         continuing the double quote
               WHEN 2 ALSO ANY
                   CONTINUE

      *                         consecutive single quote
               WHEN 4 ALSO "'"
                   MOVE 1 TO SCAN-STATE
               WHEN 4 ALSO '('
               WHEN 4 ALSO ')'
      *                         end of single quote by comma
               WHEN 4 ALSO ','
      *                         end of single quote by period
               WHEN 4 ALSO '.'
                   MOVE 1 TO SCAN-STATE
                   PERFORM STOP-WORD
                   MOVE 7 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
                   PERFORM STOP-WORD
      *                         continue of single quote
               WHEN 4 ALSO ANY
                   MOVE 1 TO SCAN-STATE
                   PERFORM STOP-WORD

      *                         consecutive double quote
               WHEN 5 ALSO '"'
                   MOVE 2 TO SCAN-STATE
               WHEN 5 ALSO '('
               WHEN 5 ALSO ')'
      *                         end of double quote by comma
               WHEN 5 ALSO ','
      *                         end of double quote by period
               WHEN 5 ALSO '.'
                   MOVE 2 TO SCAN-STATE
                   PERFORM STOP-WORD
                   MOVE 7 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
                   PERFORM STOP-WORD
      *                         end of double quote
               WHEN 5 ALSO ANY
                   MOVE 2 TO SCAN-STATE
                   PERFORM STOP-WORD

      *                         definitely a comment
               WHEN 8 ALSO '>'
                   MOVE 9 TO SCAN-STATE
      *                           definitely not a comment
               WHEN 8 ALSO SPACE
                   MOVE 6 TO SCAN-STATE
                   PERFORM STOP-WORD
      *                         definitely not a comment
               WHEN 8 ALSO ANY
                   MOVE 6 TO SCAN-STATE

      *                         comment to end of line
               WHEN 9 ALSO ANY
                   CONTINUE

               WHEN ANY ALSO SPACE
               WHEN ANY ALSO ';'
               WHEN ANY ALSO X'09'
                   PERFORM STOP-WORD
               WHEN ANY ALSO '('
               WHEN ANY ALSO ')'
      *                           ending comma
               WHEN ANY ALSO ','
      *                           ending period
               WHEN ANY ALSO '.'
                   PERFORM STOP-WORD
                   MOVE 7 TO SCAN-STATE
                   MOVE RECX-MAX TO RECX-START
                   PERFORM STOP-WORD
               END-EVALUATE
           END-PERFORM
      *  at the end of the line
           EVALUATE TRUE
           WHEN SCAN-STATE = 0
               CONTINUE
      *                         close quote at end of line
           WHEN SCAN-STATE = 4
               MOVE 1 TO SCAN-STATE
               PERFORM STOP-WORD
      *                         close quote at end of line
           WHEN SCAN-STATE = 5
               MOVE 2 TO SCAN-STATE
               PERFORM STOP-WORD
      *                         unclosed single quote
           WHEN SCAN-STATE = 1
               MOVE 10 TO SCAN-STATE
               PERFORM STOP-WORD
      *                         unclosed double quote
           WHEN SCAN-STATE = 2
               MOVE 11 TO SCAN-STATE
               PERFORM STOP-WORD
           WHEN OTHER
               PERFORM STOP-WORD
           END-EVALUATE
           SUBTRACT 1 FROM RECX-MAX END-SUBTRACT

           GOBACK
           .
       STOP-WORD.
           IF WORDX-MAX >= WORDX-LIM
               DISPLAY 'wordx-max exceeds ' WORDX-LIM END-DISPLAY
               CALL 'dumpscancontrol' USING INPUT-RECORD SCAN-CONTROL
               STOP RUN
           END-IF
           ADD 1 TO WORDX-MAX END-ADD
           MOVE RECX-START TO WORD-START(WORDX-MAX)
           IF RECX-MAX = RECX-START
               MOVE 1 TO WORD-LENGTH(WORDX-MAX)
               MOVE RECX-MAX TO WORD-END(WORDX-MAX)
           ELSE
               COMPUTE WORD-LENGTH(WORDX-MAX) =
                   RECX-MAX - RECX-START END-COMPUTE
               COMPUTE WORD-END(WORDX-MAX) =
                   RECX-MAX - 1 END-COMPUTE
           END-IF

           MOVE SCAN-STATE TO WORD-TYPE(WORDX-MAX)
           MOVE 0 TO SCAN-STATE
           .
       END PROGRAM scancobol.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. dumpscancontrol.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  W PIC 999.
       LINKAGE SECTION.
       01  INPUT-RECORD PIC X(256).
       01  SCAN-CONTROL.
           03  COBOL-CURRENT PIC XX.
           03  LINE-NUMBER PIC 9(6).
           03  RECORD-TYPE PIC X(8).
           03  RECX-MAX PIC 999.
           03  RECX-BEGIN PIC 999.
           03  RECX-END PIC 999.
           03  RECX-START PIC 999.
           03  SCAN-STATE PIC 99.
           03  WORDX PIC 99.
           03  WORDX-MAX PIC 99.
           03  WORDX-LIM PIC 99 VALUE 64.
           03  WORD-VALUES OCCURS 64.
               05  WORD-TYPE PIC 99.
               05  WORD-START PIC 999.
               05  WORD-LENGTH PIC 999.
               05  WORD-END PIC 999.

       PROCEDURE DIVISION USING INPUT-RECORD SCAN-CONTROL.
       START-DUMPSCANCONTROL.
           DISPLAY SPACE END-DISPLAY
           DISPLAY INPUT-RECORD(1:RECX-MAX) END-DISPLAY
           DISPLAY COBOL-CURRENT
               SPACE LINE-NUMBER
               SPACE RECORD-TYPE
               SPACE RECX-MAX '=max'
               SPACE RECX-BEGIN '=begin'
               SPACE RECX-END '=end'
               SPACE WORDX-MAX '=words'
           END-DISPLAY
           PERFORM VARYING W FROM 1 BY 1
           UNTIL W > WORDX-MAX
               DISPLAY W
                   SPACE WORD-TYPE(W)

                   SPACE WORD-START(W)
                   SPACE WORD-LENGTH(W)
                   SPACE WORD-END(W)
                   '/'
                   WITH NO ADVANCING
               END-DISPLAY
           END-PERFORM
           DISPLAY SPACE END-DISPLAY
           GOBACK
           .
       END PROGRAM dumpscancontrol.

