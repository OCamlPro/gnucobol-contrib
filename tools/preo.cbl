       IDENTIFICATION DIVISION.
       PROGRAM-ID. prei.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-NO-PARAGRAPH         PIC S9(4).
       01  WS-MYSQL-I              PIC S9(4) COMP.
       01  WS-MYSQL-EDIT           PIC -Z(18)9.9(9).
       01  WS-CONDITION            PIC X(1024).
       01  WS-READ-AREA            PIC X(64).
       01  WS-TABLE-NAME           PIC X(64).
       01  WS-DEMONSTRATE-DEFINE.
      */MYSQL DEFINE\
      *    TABLE=table_two,GHI
           05  GHI-INT                       PIC S9(10) COMP.
      */MYSQL-END\
      */MYSQL VAR\
      *    BASE=presql
      *    TABLE=table_one,ABC
      *    TABLE=table_two,DEF
       COPY MYSQL-VARIABLES.
      *
      *    DEFINITIONS FOR THE table_one TABLE
      *
       01  TP-TABLE-ONE                      USAGE POINTER.
       01  TD-TABLE-ONE.
           05  ABC-FBIGINT                   PIC S9(18) COMP.
           05  ABC-FCHAR                     PIC X(1).
           05  ABC-FDATE                     PIC X(10).
           05  ABC-FDATETIME                 PIC X(19).
           05  ABC-FDEC                      PIC S9(05)V9(02) COMP.
           05  ABC-FDECIMAL                  PIC S9(05)V9(02) COMP.
           05  ABC-FINT                      PIC S9(10) COMP.
           05  ABC-FINTEGER                  PIC S9(10) COMP.
           05  ABC-FMEDIUMINT                PIC S9(07) COMP.
           05  ABC-FNUMERIC                  PIC S9(06)V9(02) COMP.
           05  ABC-FSMALLINT                 PIC S9(05) COMP.
           05  ABC-FTIME                     PIC X(10).
           05  ABC-FTIMESTAMP                PIC X(19).
           05  ABC-FTINYBLOB                 PIC X(255).
           05  ABC-FTINYINT                  PIC S9(03) COMP.
           05  ABC-FTINYTEXT                 PIC X(255).
           05  ABC-FVARCHAR                  PIC X(45).
      *
      *    DEFINITIONS FOR THE table_two TABLE
      *
       01  TP-TABLE-TWO                      USAGE POINTER.
       01  TD-TABLE-TWO.
           05  DEF-INT                       PIC S9(10) COMP.
      */MYSQL-END\
      ****************************************************************
      *                PROCEDURE DIVISION                            *
      ****************************************************************
       PROCEDURE DIVISION.
       0000-MAIN SECTION.
           GO TO 1000-COMMAND-LOOP.
      *
       0100-ERROR.
           DISPLAY "T) ERROR--CONTACT SUPERVISOR".
           DISPLAY "I) AT PARAGRAPH ", WS-NO-PARAGRAPH.
           DISPLAY "I) SQL ERROR NUMBER=", WS-MYSQL-ERROR-NUMBER.
           DISPLAY "I) SQL ERROR MESAGE=", WS-MYSQL-ERROR-MESSAGE.
           STOP RUN.
      *
       1000-COMMAND-LOOP.
           MOVE SPACES TO WS-READ-AREA.
           DISPLAY "A) ENTER THE COMMAND YOU DESIRE ".
           ACCEPT WS-READ-AREA.
           EVALUATE WS-READ-AREA
             WHEN "INIT" GO TO 2000-INIT
             WHEN "INSERT" GO TO 2100-INSERT
             WHEN "SELECT" GO TO 2200-SELECT
             WHEN "FETCH" GO TO 2300-FETCH
             WHEN "FREE" GO TO 2400-FREE
             WHEN "DELETE" GO TO 2700-DELETE
             WHEN "CLOSE" GO TO 2800-CLOSE
             WHEN "UPDATE" GO TO 2900-UPDATE
             WHEN "END" GO TO 9900-EOJ
             WHEN "OTHER"
               DISPLAY "W) INVALID COMMAND"
               GO TO 1000-COMMAND-LOOP
           END-EVALUATE.
      *
       2000-INIT.
           MOVE 2000 TO WS-NO-PARAGRAPH.
      */MYSQL INIT\
      *
      *    OPEN THE DATABASE
      *
      *    BASE=presql
      *    PASSWORD=mysqlpass
           MOVE "presql"  & X"00" TO WS-MYSQL-BASE-NAME.
           MOVE "localhost" & X"00" TO WS-MYSQL-HOST-NAME.
151019     MOVE "dev-prog-001" & X"00" TO WS-MYSQL-IMPLEMENTATION.
           MOVE "mysqlpass" & X"00" TO WS-MYSQL-PASSWORD.
           MOVE "3306" & X"00" TO WS-MYSQL-PORT-NUMBER.
151019     MOVE "/home/mysql/mysql.sock"
             & X"00" TO WS-MYSQL-SOCKET.
           PERFORM MYSQL-1000-OPEN  THRU MYSQL-1090-EXIT.
      */MYSQL-END\
           GO TO 1000-COMMAND-LOOP.
      *
       2100-INSERT.
           MOVE 2100 TO WS-NO-PARAGRAPH.
           MOVE SPACES TO WS-READ-AREA.
           DISPLAY "A) ENTER THE VALUE FOR fbigint ".
           ACCEPT WS-READ-AREA.
      */MYSQL LOCK\
      *
      *    LOCK A TABLE
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "LOCK TABLES "
             "table_one"
             " WRITE ;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           MOVE WS-READ-AREA TO ABC-FBIGINT.
           MOVE "A" TO ABC-FCHAR.
           MOVE "2010-01-01" TO ABC-FDATE.
           MOVE "2010-01-01 01:02:03" TO ABC-FDATETIME.
           MOVE 7.2 TO ABC-FDEC.
           MOVE 7.2 TO ABC-FDECIMAL.
           MOVE 1 TO ABC-FINT.
           MOVE 2 TO ABC-FINTEGER.
           MOVE 3 TO ABC-FMEDIUMINT.
           MOVE 8.2 TO ABC-FNUMERIC.
           MOVE 4 TO ABC-FSMALLINT.
           MOVE "01:02:03" TO ABC-FTIME.
           MOVE "2010-01-01 01:02:03" TO ABC-FTIMESTAMP.
           MOVE "B" TO ABC-FTINYBLOB.
           MOVE 5 TO ABC-FTINYINT.
           MOVE "C" TO ABC-FTINYTEXT.
           MOVE "D" TO ABC-FVARCHAR.
      */MYSQL INSERT\
      *
      *    INSERT A ROW
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           MOVE 1 TO WS-MYSQL-I.
           STRING 'INSERT INTO '
                    'table_one SET '
              INTO WS-MYSQL-COMMAND
              WITH POINTER WS-MYSQL-I.
      *
           STRING 'fbigint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FBIGINT
             TO WS-MYSQL-EDIT.
           IF ABC-FBIGINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(03:18))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fchar="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FCHAR,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdate="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FDATE,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdatetime="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FDATETIME,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdec="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FDEC
             TO WS-MYSQL-EDIT.
           IF ABC-FDEC
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdecimal="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FDECIMAL
             TO WS-MYSQL-EDIT.
           IF ABC-FDECIMAL
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FINT
             TO WS-MYSQL-EDIT.
           IF ABC-FINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(11:10))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'finteger="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FINTEGER
             TO WS-MYSQL-EDIT.
           IF ABC-FINTEGER
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(11:10))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fmediumint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FMEDIUMINT
             TO WS-MYSQL-EDIT.
           IF ABC-FMEDIUMINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(14:07))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fnumeric="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FNUMERIC
             TO WS-MYSQL-EDIT.
           IF ABC-FNUMERIC
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(15:06))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fsmallint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FSMALLINT
             TO WS-MYSQL-EDIT.
           IF ABC-FSMALLINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftime="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTIME,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftimestamp="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTIMESTAMP,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinyblob="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTINYBLOB,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinyint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FTINYINT
             TO WS-MYSQL-EDIT.
           IF ABC-FTINYINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(18:03))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinytext="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTINYTEXT,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fvarchar="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FVARCHAR,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ";" INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING X"00" INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
       PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           IF WS-MYSQL-COUNT-ROWS IS LESS THAN 1
             GO TO 0100-ERROR.
      */MYSQL UNLOCK\
      *
      *    UNLOCK THE DATABASE
      *
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "UNLOCK TABLES;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           GO TO 1000-COMMAND-LOOP.
      *
       2200-SELECT.
           MOVE SPACES TO WS-READ-AREA.
           DISPLAY "A) ENTER THE WHERE FOR THE SELECT"
           ACCEPT WS-READ-AREA.
           MOVE WS-READ-AREA TO WS-CONDITION.
      *MYSQL SELECT\
      *
      *    SELECT ROWS
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "SELECT * FROM "
             "table_one"
             " WHERE "
             WS-CONDITION
            ";"  X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
           PERFORM MYSQL-1220-STORE-RESULT THRU MYSQL-1239-EXIT.
           MOVE WS-MYSQL-RESULT TO TP-TABLE-ONE.
      *MYSQL-END\
           DISPLAY "I) ROWS SELECTED=", WS-MYSQL-COUNT-ROWS.
           GO TO 1000-COMMAND-LOOP.
      *
       2300-FETCH.
      */MYSQL FETCH\
      *
      *    FETCH NEXT RECORD
      *
      *    TABLE=table_one
           MOVE TP-TABLE-ONE TO WS-MYSQL-RESULT.
           CALL "MySQL_fetch_record" USING WS-MYSQL-RESULT
                    ABC-FBIGINT
                    ABC-FCHAR
                    ABC-FDATE
                    ABC-FDATETIME
                    ABC-FDEC
                    ABC-FDECIMAL
                    ABC-FINT
                    ABC-FINTEGER
                    ABC-FMEDIUMINT
                    ABC-FNUMERIC
                    ABC-FSMALLINT
                    ABC-FTIME
                    ABC-FTIMESTAMP
                    ABC-FTINYBLOB
                    ABC-FTINYINT
                    ABC-FTINYTEXT
                    ABC-FVARCHAR
                   .
      */MYSQL-END\
           DISPLAY "I) fbigint=", ABC-FBIGINT.
           GO TO 1000-COMMAND-LOOP.
      *
       2400-FREE.
      */MYSQL FREE\
      *
      *    FREE RESULT ARRAY
      *
      *    TABLE=table_one
           MOVE TP-TABLE-ONE TO WS-MYSQL-RESULT.
           CALL "MySQL_free_result" USING WS-MYSQL-RESULT.
      */MYSQL-END\
           GO TO 1000-COMMAND-LOOP.
      *
       2700-DELETE.
           MOVE SPACES TO WS-READ-AREA.
           DISPLAY "A) ENTER THE WHERE STATEMENT ".
           ACCEPT WS-READ-AREA.
           MOVE WS-READ-AREA TO WS-CONDITION.
      */MYSQL LOCK\
      *
      *    LOCK A TABLE
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "LOCK TABLES "
             "table_one"
             " WRITE ;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
      */MYSQL DELETE\
      *
      *    DELETE A ROW
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "DELETE FROM "
             "table_one"
             " WHERE "
             WS-CONDITION
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           IF WS-MYSQL-COUNT-ROWS IS LESS THAN 1
             GO TO 0100-ERROR.
      */MYSQL UNLOCK\
      *
      *    UNLOCK THE DATABASE
      *
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "UNLOCK TABLES;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           GO TO 1000-COMMAND-LOOP.
      *
       2800-CLOSE.
      */MYSQL CLOSE\
      *
      *    CLOSE THE DATABASE
      *
           PERFORM MYSQL-1980-CLOSE THRU MYSQL-1999-EXIT.
           GO TO 1000-COMMAND-LOOP.
      *
       2900-UPDATE.
           DISPLAY "A) ENTER THE VALUE OF FBIGINT ".
           MOVE SPACES TO WS-READ-AREA.
           ACCEPT WS-READ-AREA.
           MOVE WS-READ-AREA TO ABC-FBIGINT.
           DISPLAY "A) ENTER THE WHERE STATEMENT ".
           MOVE SPACES TO WS-READ-AREA.
           ACCEPT WS-READ-AREA.
           MOVE WS-READ-AREA TO WS-CONDITION.
           DISPLAY "A) ENTER THE NEW VALUE FOR fchar ".
           MOVE SPACES TO WS-READ-AREA.
           ACCEPT WS-READ-AREA.
           MOVE WS-READ-AREA TO ABC-FCHAR.
      */MYSQL LOCK\
      *
      *    LOCK A TABLE
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "LOCK TABLES "
             "table_one"
             " WRITE ;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
      */MYSQL UPDATE\
      *
      *    UPDATE A ROW
      *
      *    TABLE=table_one
           INITIALIZE WS-MYSQL-COMMAND.
           MOVE 1 TO WS-MYSQL-I.
           STRING 'UPDATE '
                    'table_one SET '
              INTO WS-MYSQL-COMMAND
              WITH POINTER WS-MYSQL-I.
      *
           STRING 'fbigint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FBIGINT
             TO WS-MYSQL-EDIT.
           IF ABC-FBIGINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(03:18))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fchar="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FCHAR,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdate="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FDATE,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdatetime="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FDATETIME,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdec="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FDEC
             TO WS-MYSQL-EDIT.
           IF ABC-FDEC
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fdecimal="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FDECIMAL
             TO WS-MYSQL-EDIT.
           IF ABC-FDECIMAL
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FINT
             TO WS-MYSQL-EDIT.
           IF ABC-FINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(11:10))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'finteger="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FINTEGER
             TO WS-MYSQL-EDIT.
           IF ABC-FINTEGER
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(11:10))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fmediumint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FMEDIUMINT
             TO WS-MYSQL-EDIT.
           IF ABC-FMEDIUMINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(14:07))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fnumeric="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FNUMERIC
             TO WS-MYSQL-EDIT.
           IF ABC-FNUMERIC
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(15:06))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING "." INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING WS-MYSQL-EDIT(22:02)
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fsmallint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FSMALLINT
             TO WS-MYSQL-EDIT.
           IF ABC-FSMALLINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(16:05))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftime="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTIME,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftimestamp="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTIMESTAMP,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinyblob="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTINYBLOB,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinyint="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           MOVE ABC-FTINYINT
             TO WS-MYSQL-EDIT.
           IF ABC-FTINYINT
             IS LESS THAN ZERO
               STRING '-' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-MYSQL-EDIT(18:03))
             INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           STRING '"' INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'ftinytext="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FTINYTEXT,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING ', 'INTO WS-MYSQL-COMMAND
           WITH POINTER WS-MYSQL-I.
      *
           STRING 'fvarchar="' INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (ABC-FVARCHAR,TRAILING)
                  '"'
                   INTO WS-MYSQL-COMMAND
                   WITH POINTER WS-MYSQL-I.
           STRING " WHERE "
              INTO WS-MYSQL-COMMAND
              WITH POINTER WS-MYSQL-I.
           STRING FUNCTION TRIM (WS-CONDITION)
              INTO WS-MYSQL-COMMAND
              WITH POINTER WS-MYSQL-I.
           STRING ";" X"00" INTO WS-MYSQL-COMMAND
             WITH POINTER WS-MYSQL-I.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           CALL "MySQL_errno" USING WS-MYSQL-ERROR-NUMBER.
           IF WS-MYSQL-COUNT-ROWS IS LESS THAN 1
             AND WS-MYSQL-ERROR-NUMBER IS NOT EQUAL TO "0   "
               GO TO 0100-ERROR.
      */MYSQL UNLOCK\
      *
      *    UNLOCK THE DATABASE
      *
           INITIALIZE WS-MYSQL-COMMAND.
           STRING "UNLOCK TABLES;"
             X"00" INTO WS-MYSQL-COMMAND.
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT.
      */MYSQL-END\
           GO TO 1000-COMMAND-LOOP.
      *
       9900-EOJ.
           DISPLAY "I) PROGRAM TERMINATING".
           STOP RUN.
      */MYSQL PRO\
       COPY MYSQL-PROCEDURES.
      */MYSQL-END\
