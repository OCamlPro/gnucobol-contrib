      *>***********************************************************
      *> version 001 -- original version.                         *
      *> version 002 -- unknown changes.                          *
      *> version 003 -- changes open routine to not hardcode      *
      *>                connection parameters.                    *
      *>                1277920--jim currey                       *
      *>                05/26/2009--jose rosado                   *
      *> version 004 -- Changed to free format & clean up code    *
      *>                layout.                                   *
      *>                12 Jun 2016 -- Vince Coen                 *
      *> 1000-open Has been changed for ACAS only, as some of     *
      *>   these params come from the system file so we will need *
      *>   2 versions of this procedure.                          *
      *>   Cobol file  OR NOT !!! - The moves are rem'd out here  *
      *>    as these are coded from within presql or used from    *
      *>     the filename.scb source file as required.            *
      *> = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
      *>   Change Mysql-1100-Db-Error to suit YOUR application    *
      *>       requirements                                       *
      *>***********************************************************
      *>    Common Mysql Routines                                 *
      *>***********************************************************
      *>
052609*>    Initialize, connect, and select data base
052609*>
052609*>      The name of your data base followed by hex 00
052609*>        needs to be moved into ws-mysql-base-name
052609*>        before execution.  example:
052609*>          move "MYNAME" & x"00" to ws-my-sql-base-name
      *>
      *>
       mysql-1000-open.
           call     "MySQL_init" using ws-mysql-cid.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
      *>     move     "localhost" & x"00"    to ws-mysql-host-name.
      *>     move     "dev-prog-001" & x"00" to ws-mysql-implementation.
      *>     move     "mysqlpass" & x"00"    to ws-mysql-password.
      *>     move     "3306"                 to ws-mysql-port-number.
      *>     move     "/home/mysql/mysql.sock" & x"00"
      *>                                     to ws-mysql-socket.
      *>
           call     "MySQL_real_connect" using ws-mysql-host-name
                                               ws-mysql-implementation
                                               ws-mysql-password
                                               ws-mysql-base-name
                                               ws-mysql-port-number
                                               ws-mysql-socket.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
           call     "MySQL_selectdb" using ws-mysql-base-name.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
      *>
       mysql-1090-exit.
           exit.
      *>
      *>    Common Error Handling UNCHANGED but Needs to be <<<<<< ??
      *>
      *>  Note that we do a stop run even though we got here
      *>              through a perform thru
      *>
       Mysql-1100-Db-Error.
           call     "MySQL_errno" using ws-mysql-error-number.
           if       ws-mysql-error-number = "1062"
                    evaluate ws-mysql-command (1:6)
                          when "INSERT"
                          when "insert"
                               go to mysql-1190-exit.
           display  "W) SQL Error Number=", ws-mysql-error-number.
           display  "W) PARAGRAPH=", ws-no-paragraph.
           display  "W) SQL Command=", ws-mysql-command.
           call     "MySQL_error" using ws-mysql-error-message.
           display  "W) SQL Error Message for #" ws-mysql-error-number
                        "=" ws-mysql-error-message.
           display  "T) Program Aborted--Contact IT Support".
           stop     run.
      *>
       mysql-1190-exit.
           exit.
      *>
      *>    Execute Select
      *>
      *>    Remember to terminate your ws-mysql-command with hex "00"
      *>
       mysql-1200-select.
           call     "MySQL_query" using ws-mysql-command.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
      *>
       mysql-1209-exit.
           exit.
      *>
      *>   Execute Command
      *>
      *>   Remember to terminate your ws-mysql-command with hex "00"
      *>
	      mysql-1210-command.
           call     "MySQL_query" using ws-mysql-command.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
           call     "MySQL_affected_rows" using ws-mysql-count-rows.
      *>
       mysql-1219-exit.
           exit.
      *>
      *>      Store Result
      *>
       mysql-1220-store-result.
           call     "MySQL_store_result" using ws-mysql-result.
           if       ws-mysql-result = null
                    perform mysql-1100-db-error thru mysql-1190-exit.
           call     "MySQL_num_rows" using ws-mysql-result,
                                           ws-mysql-count-rows.
      *>
       mysql-1239-exit.
           exit.
      *>
      *>      Switch Databases
      *>
       mysql-1240-switch-db.
           call     "MySQL_selectdb" using ws-mysql-base-name.
           if       return-code not = zero
                    perform mysql-1100-db-error thru mysql-1190-exit.
      *>
       mysql-1249-exit.
           exit.
      *>
      *>      Close Data Base
      *>
       mysql-1980-close.
           call     "MySQL_close".
      *>
       mysql-1999-exit.
           exit.
