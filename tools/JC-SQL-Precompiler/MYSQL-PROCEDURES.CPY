       >>source fixed
      ************************************************************
      * VERSION 001 -- ORIGINAL VERSION.                         *
      * VERSION 002 -- UNKNOWN CHANGES.                          *
      * VERSION 003 -- CHANGES OPEN ROUTINE TO NOT HARDCODE      *
      *                CONNECTION PARAMETERS.                    *
      *                1277920--JIM CURREY                       *
      *                05/26/2009--JOSE ROSADO                   *
      ************************************************************
      *    COMMON MYSQL ROUTINES                                 *
      ************************************************************
      *
      *    INITIALIZE, CONNECT, AND SELECT DATA BASE
      *
      *      THE NAME OF YOUR DATA BASE FOLLOWED BY HEX 00
      *        NEEDS TO BE MOVED INTO WS-MYSQL-BASE-NAME
      *        BEFORE EXECUTION.  EXAMPLE:
      *          MOVE "MYNAME" & X"00" TO WS-MY-SQL-BASE-NAME
      *
      *
       MYSQL-1000-OPEN.
           CALL "MySQL_init" USING WS-MYSQL-CID.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
052609*    MOVE "localhost" & X"00" to WS-MYSQL-HOST-NAME.
052609*    MOVE "dev-prog-001" & X"00" TO WS-MYSQL-IMPLEMENTATION.
052609*    MOVE "mysqlpass" & X"00" TO WS-MYSQL-PASSWORD.
052609*    MOVE "3306" TO WS-MYSQL-PORT-NUMBER.
052609*    MOVE "/home/mysql/mysql.sock" & X"00"
052609*      TO WS-MYSQL-SOCKET.
           CALL "MySQL_real_connect" USING
             WS-MYSQL-HOST-NAME, WS-MYSQL-IMPLEMENTATION,
             WS-MYSQL-PASSWORD, WS-MYSQL-BASE-NAME, WS-MYSQL-PORT-NUMBER,
             WS-MYSQL-SOCKET.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
           CALL "MySQL_selectdb" USING WS-MYSQL-BASE-NAME.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
       MYSQL-1090-EXIT.
           EXIT.
      *
      *    COMMON ERROR HANDLING
      *
      *      NOTE THAT WE DO A STOP RUN EVEN THOUGH WE GOT HERE
      *        THROUGH A PERFORM THRU
      *
       MYSQL-1100-DB-ERROR.
           CALL "MySQL_errno" USING WS-MYSQL-ERROR-NUMBER.
           IF WS-MYSQL-ERROR-NUMBER IS EQUAL TO "1062"
             EVALUATE WS-MYSQL-COMMAND (1:6)
               WHEN "INSERT"
               WHEN "insert"
                 GO TO MYSQL-1190-EXIT.
           DISPLAY "W) SQL ERROR NUMBER=", WS-MYSQL-ERROR-NUMBER.
           DISPLAY "W) PARAGRAPH=", WS-NO-PARAGRAPH.
           CALL "MySQL_error" USING WS-MYSQL-ERROR-MESSAGE.
           display  "W) SQL Error Message for #" ws-mysql-error-number
                    "=" ws-mysql-error-message.
      *     DISPLAY "W) SQL ERROR MESSAGE=", WS-MYSQL-ERROR-MESSAGE.
           DISPLAY "T) PROGRAM ABORTED--CONTACT SUPERVISOR".
           STOP RUN.
       MYSQL-1190-EXIT.
           EXIT.
      *
      *    EXECUTE SELECT
      *
      *      REMEMBER TO TERMINATE YOUR WS-MYSQL-COMMAND WITH
      *        HEX "00"
      *
       MYSQL-1200-SELECT.
           CALL "MySQL_query" USING WS-MYSQL-COMMAND.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
       MYSQL-1209-EXIT.
           EXIT.

      *
      *    EXECUTE COMMAND
      *
      *      REMEMBER TO TERMINATE YOUR WS-MYSQL-COMMAND WITH
      *        HEX "00"
      *
       MYSQL-1210-COMMAND.
           CALL "MySQL_query" USING WS-MYSQL-COMMAND.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
           CALL "MySQL_affected_rows" USING WS-MYSQL-COUNT-ROWS.
       MYSQL-1219-EXIT.
           EXIT.

      *
      *      STORE RESULT
      *
       MYSQL-1220-STORE-RESULT.
           CALL "MySQL_store_result" USING WS-MYSQL-RESULT.
           IF WS-MYSQL-RESULT IS EQUAL TO NULL
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
           CALL "MySQL_num_rows" USING WS-MYSQL-RESULT,
	                               WS-MYSQL-COUNT-ROWS.
       MYSQL-1239-EXIT.
           EXIT.
      *
      *      SWITCH DATABASES
      *
       MYSQL-1240-SWITCH-DB.
           CALL "MySQL_selectdb" USING WS-MYSQL-BASE-NAME.
           IF RETURN-CODE IS NOT EQUAL TO ZERO
             PERFORM MYSQL-1100-DB-ERROR THRU MYSQL-1190-EXIT.
       MYSQL-1249-EXIT.
                 EXIT.
      *
      *      CLOSE DATA BASE
      *
       MYSQL-1980-CLOSE.
           CALL "MySQL_close".
       MYSQL-1999-EXIT.
           EXIT.
