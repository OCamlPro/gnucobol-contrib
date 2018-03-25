       >>SOURCE FREE
*>***********************************************************
*> NOTE:  This COPY code block [ Mysql-Procedures ] must be *
*>        included in all modules that call SQL procedures  *
*>        using the Currey SQL pre compiler along with the  *
*>        Mysql-Variables COPY block.                       *
*>                                                          *
*> version 001 -- original version.                         *
*> version 002 -- unknown changes.                          *
*> version 003 -- changes open routine to not hardcode      *
*>                connection parameters.                    *
*>                1277920--jim currey                       *
*>                05/26/2009--jose rosado                   *
*>                                                          *
*> version 004 -- Changed to free format & clean up code    *
*>                layout.                                   *
*>                12 Jun 2016 -- Vince Coen                 *
*>                                                          *
*> version 005 -- Changes to DB-error to display only       *
*>                1000-open changed for ACAS only as some   *
*>                as these params come from the system file *
*>                as a Cobol file -> RDB !                  *
*>                The moves are rem'd out here !            *
*>                8 July 2016 -- Vince Coen (080716)        *
*>                                                          *
*> version 006 -- Changes to support locked table and wait  *
*>                time for delays. New fields added to      *
*>                Mysql-procedures.cpy                      *
*>                Locked tables should not happen as RDB    *
*>                internally deals for update & delete but  *
*>                here as a JIC. Belts & Braces.            *
*>                                                          *
*>                NOTE that Ws-No-Paragraph numbers start   *
*>                with 101 here, and 001 should be used in  *
*>                the application code.                     *
*>                20/09/2016 -- Vince Coen                  *
*>                                                          *
*> version 007 -- Added extra check and exit for open.      *
*>                05/10/2016 -- Vince Coen.                 *
*>                                                          *
*> version 008 -- Moved 'move 101,102,103..' to just before *
*>                'perform DB-Error..' in mysql-1000-open.  *
*>                as it hides caller para lits if no errors *
*>                18/12/2016 -- Vince Coen                  *
*>                                                          *
*> version 009 -- Added support for SQL-State.              *
*>                25/12/2016 -- Vince Coen                  *
*>***********************************************************
*>               Common MYSQL Routines                      *
*>***********************************************************
*>
*>    Initialize, Connect, and Select Data Base
*>
*>      The name of your data base followed by hex 00
*>        needs to be moved into ws-mysql-base-name
*>        before execution.  example:
*>          move "MYNAME" & x"00" to ws-mysql-base-name
*>
 Mysql-1000-Open.
     move     zero to WS-Mysql-Time-Step
                      WS-SQL-Retry.
     call     "MySQL_init" using Ws-Mysql-Cid.
     if       Return-Code not = zero
              move     101  to Ws-No-Paragraph
              perform Mysql-1100-Db-Error thru Mysql-1190-Exit
              go to Mysql-1090-Exit.
*>
     call     "MySQL_real_connect" using Ws-Mysql-Host-Name
                                         Ws-Mysql-Implementation
                                         Ws-Mysql-Password
                                         Ws-Mysql-Base-Name
                                         Ws-Mysql-Port-Number
                                         Ws-Mysql-Socket.
     if       Return-Code not = zero
              move     102 to Ws-No-Paragraph
              perform Mysql-1100-Db-Error thru Mysql-1190-Exit
              go to Mysql-1090-Exit.
     call     "MySQL_selectdb" using Ws-Mysql-Base-Name.
     if       Return-Code not = zero
              move     103 to Ws-No-Paragraph
              perform Mysql-1100-Db-Error thru Mysql-1190-Exit.
*>
 Mysql-1090-Exit.
     exit.
*>
*>**************************************************************
*>
*>    Common error handling
*>
*>  This is changed for use with ACAS as it was bit too basic
*>
 Mysql-1100-Db-Error.
     call     "MySQL_errno" using Ws-Mysql-Error-Number.
 Mysql-1100-Db-Error-2.
     if       Ws-Mysql-Error-Number = "1062" or = "1022"   *> Duplicate entry/Write dup key
              evaluate Ws-Mysql-Command (1:6)
                    when "INSERT"
                    when "insert"
                    move 22 to fs-Reply
                    go to Mysql-1190-Exit
     end-if

     call     "MySQL_error" using Ws-Mysql-Error-Message.
*>
*> Next blk new, 30/12/16 and is under test- just have to work out any IF tests.
*> poss. tests ?
*>
*>   0200n  no data found one way or another [Get random = 23 else = 10].
*>   00 & 01 is good.
*>   23000  Dup primary key on insert same as fs-reply = 22.
*>   '99NKS'   internal error = invalid key # used.
*>   '99NKU'   internal error = No valid key used.
*>   '99NKD'   internal error - no valid key used for delete
*>   '99RNP'   internal error = read next with no position (no start 1st)
*>   '99GNS'   internal error = Could not generate a start.
*>
*>
     call     "MySQL_sqlstate" using WS-MYSQL-SqlState.
     move     WS-MYSQL-SqlState      to SQL-State.
 *>     if       SQL-State = "02000"                          *> No data
 *>
*>
     move     99 to fs-Reply.
     move     911 to We-Error.
*>
 Mysql-1110-Report-Problem.
*>  Calling program needs screen sections set up - see stockMT.scb as example
*>    along with message ST001/ST901
*>
     display  Display-Message-2 with erase eos.
     display  ST901 at line ws-lines col 1.
     accept   ws-reply at line ws-lines col 33.
     move     space to ws-reply.
*>
 Mysql-1190-Exit.
     exit.
*>
*>**************************************************************
*>    Execute select
*>
*>    Remember to terminate your ws-mysql-command with hex "00"
*>
 Mysql-1200-Select.
     call     "MySQL_query" using Ws-Mysql-Command.
     if       Return-Code not = zero
              perform Mysql-1100-Db-Error Thru Mysql-1190-Exit.
*>
 Mysql-1209-Exit.
     exit.
*>
*>**************************************************************
*>
*>   Execute command
*>
*>   Remember to terminate your ws-mysql-command with hex "00"
*>
*>   Now contains tests for locking errors but only in 1210 as not
*>    called elsewere.
*>
 Mysql-1210-Command.
     call     "MySQL_query" using WS-Mysql-Command.
     if       Return-Code not = zero
 *>             perform Mysql-1300-DB-Error thru Mysql-1390-Exit
 *>             if      WE-Error = 910
 *>                     go to Mysql-1219-Exit
 *>             end-if
 *>             if      WS-SQL-Retry = 1
 *>                     move zero to WS-SQL-Retry
 *>                     go to Mysql-1210-Command
 *>             end-if
 *>              perform Mysql-1100-Db-Error-2 Thru Mysql-1190-Exit
              perform Mysql-1100-Db-Error Thru Mysql-1190-Exit
     end-if
     call     "MySQL_affected_rows" using WS-Mysql-Count-Rows.
*>
 Mysql-1219-Exit.     *> on return test for WE-Error = 910
     exit.
*>
*>**************************************************************
*>
*>      Store result
*>
 Mysql-1220-Store-Result.
     call     "MySQL_store_result" using ws-mysql-result.
     if       Ws-Mysql-Result = null
              perform Mysql-1100-Db-Error thru Mysql-1190-Exit.
     call     "MySQL_num_rows" using Ws-Mysql-Result
                                     Ws-Mysql-Count-Rows.
*>
 Mysql-1239-Exit.
     exit.
*>
*>**************************************************************
*>
*>      Switch databases
*>
 Mysql-1240-Switch-Db.
     call     "MySQL_selectdb" using Ws-Mysql-Base-Name.
     if       Return-Code not = zero
              perform Mysql-1100-Db-Error thru Mysql-1190-Exit.
*>
 Mysql-1249-Exit.
     exit.
*>
 Mysql-1300-DB-Error.
*>
*>  This replaces for 1210, operation tests first
*>
*>  Clear switch for retry.
*>
     move     zero to WS-SQL-Retry.
*>
     call     "MySQL_errno" using Ws-Mysql-Error-Number.
     if       WS-Mysql-Error-Number not = "1027"  *> HY000  - Locked against change
                                and not = "1036"  *> HY000  - Table Read Only
                                and not = "1099"  *> HY000  - Locked with Read lock
              go to Mysql-1390-Exit.      *> Not interested as it's not a LOCK problem.
*>
     if       WS-Mysql-Time-Step = zero
              move 1 to WS-Mysql-Time-Step
              call "CBL_OC_NANOSLEEP" using 250000000    *> 1/4 sec
     else
      if      WS-Mysql-Time-Step = 1
              move 2 to WS-Mysql-Time-Step
              display "Waiting < sec " at line ws-lines col 1 blink
              call "CBL_OC_NANOSLEEP" using 500000000    *> 1/2 sec
              display " "              at line ws-lines col 1 with erase eol
      else
       if     WS-Mysql-Time-Step = 2
              move 4 to WS-Mysql-Time-Step
              display "Waiting 1 sec " at line ws-lines col 1 blink
              call "C$SLEEP" using 1    *> 1 sec
              display " "              at line ws-lines col 1 with erase eol
       else
        if    WS-Mysql-Time-Step = 4
              move 8 to WS-Mysql-Time-Step
              display "Waiting 5 secs" at line ws-lines col 1 blink
              call "C$SLEEP" using 5    *> 5 sec
              display " "              at line ws-lines col 1 with erase eol
        else                             *> well after 5 secs it should be released so error.
              move 910 to WE-Error
              move 99  to FS-Reply
              call "MySQL_error" using Ws-Mysql-Error-Message
              go to Mysql-1390-Exit.     *>  Test for, after exit
*>
*>**************************************************************
*>
*> Retry last SQL process.
*>
     move     1 to WS-SQL-Retry.
     go       to Mysql-1390-Exit.
*>
 Mysql-1390-Exit.
     exit.
*>
*>***************************************************************
*>
*>      Close data base
*>
 Mysql-1980-Close.
     call "MySQL_close".
*>
 Mysql-1999-Exit.
     exit.
