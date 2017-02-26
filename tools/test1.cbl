      **************************************
      *  Change lines 151019 to reflect    *
      *   your RDB set up.                 *
      *                                    *
      *  It will assist you in confirming  *
      *  that your RDB sinstall is working.*
      **************************************
       identification  division.
       program-id.     test1.
       data            division.
       working-storage section.
        01  cid               usage pointer.
        01  result            usage pointer.
        01  a                 pic x(20).
        01  b                 pic x(20).
        01  c                 pic x(16).
        01  i                 pic s9(9) comp-5.
        01  s4                pic z(3)9-.
        01  s9                pic z(8)9-.
        01  s18               pic z(17)9-.
        01  s9p8              pic z(8)9.9(8)-.
        01  len               pic s9(9) comp.
        01  buffer            pic x(4096).
        01  buffer-pointer    pic s9(4) comp.
        01  errno             pic x(10).
        01  err-msg           pic x(80).
        01  eod               pic x.
        01  WS-NO-PARAGRAPH   pic s9(4) comp.
        01  test-type-buffer.
            05  tt-char       pic x(255).
            05  tt-tint       pic s9(4) comp.
            05  tt-sint       pic s9(9) comp.
            05  tt-mint       pic s9(9) comp.
            05  tt-int        pic s9(18) comp.
            05  tt-bint       pic s9(18) comp.
            05  tt-dec        pic s9(9)v9(8) comp.
            05  tt-dec2       pic s9(9)v9(8) comp.
            05  tt-date       pic x(10).
            05  tt-time       pic x(8).
            05  tt-ts         pic x(20).
            05  tt-dt         pic x(20).
            05  tt-year       pic x(4).
            05  tt-vchar      pic x(255).
            05  tt-tblob      pic x(255).
            05  tt-ttext      pic x(255).
            05  tt-blob       pic x(1024).
            05  tt-text       pic x(1024).
            05  tt-mblob      pic x(512).
            05  tt-mtext      pic x(512).
            05  tt-null       pic x.
            05  tt-int2       pic s9(18) comp.
            05  tt-dec3       pic s9(9)v9(8) comp.
        01  edit-tint         pic z(3)9-.
        01  edit-sint         pic z(8)9-.
        01  edit-mint         pic z(8)9-.
        01  edit-int          pic z(17)9-.
        01  edit-bint         pic z(17)9-.
        01  edit-dec          pic z(8)9.9(8)-.
        01  edit-dec2         pic z(8)9.9(8)-.
        01  edit-int2         pic z(17)9-.
        01  edit-dec3         pic z(8)9.9(8)-.
      *
       01  MYSQL-SCH-BUFFER.
           05  SCH-CATALOG-NAME                PIC X(512).
           05  SCH-SCHEMA-NAME                 PIC X(64).
           05  SCH-DEFAULT-CHARACTER-SET-NAME  PIC X(32).
           05  SCH-DEFAULT-COLLATION-NAME      PIC X(32).
           05  SCH-SQL-PATH                    PIC X(512).
      *
       procedure       division.

            display "at init".
            call "MySQL_init"  using cid.
            if return-code not = 0 then
               perform db-error
            end-if.
            display "after init".

            call "MySQL_real_connect"
151019                  using "localhost" "dev-prog-001"  "mysqlpass"
                              "information_schema" "3306"
151019                        "/home/mysql/mysql.sock".
            if return-code not = 0 then
               perform db-error
            end-if.
            display "after real connect".

            call "MySQL_selectdb"  using "information_schema".
            if return-code not = 0 then
               perform db-error
            end-if.
            display "after select db".

            call "MySQL_get_character_set_info" using buffer.
            display "after charset: " function trim (buffer).

            move spaces to buffer.
            string
              "select * from SCHEMATA;"
               X"00"
                 into buffer.
            call "MySQL_query" using buffer.
            if return-code not = 0 then
               perform db-error
            end-if.
            display "after query".

            call "MySQL_store_result" using result.
            if result = NULL then
               perform db-error
            end-if.
            display "after store result".

            call "MySQL_num_rows" using result i.
            if result = NULL then
               perform db-error
            end-if.
            move i to s9.
            display "after num rows (comp-5) " s9.

            perform until eod not = eod
               call "MySQL_fetch_record" using
                 result
                 SCH-CATALOG-NAME
                 SCH-SCHEMA-NAME
                 SCH-DEFAULT-CHARACTER-SET-NAME
                 SCH-DEFAULT-COLLATION-NAME
                 SCH-SQL-PATH
               end-call
               if return-code = -1 then
                  display "no more results"
                  exit perform
               end-if
               if return-code = -9 then
                  display "wrong number of parms on fetch record"
                  exit perform
               end-if
               move spaces to buffer
               string
                 "[" function trim (SCH-CATALOG-NAME) "] "
                 "[" function trim (SCH-SCHEMA-NAME) "] "
                 "[" function trim (SCH-DEFAULT-CHARACTER-SET-NAME) "] "
                 "[" function trim (SCH-DEFAULT-COLLATION-NAME) "] "
                 "[" function trim (SCH-SQL-PATH) "] "
                 into buffer
               end-string
               display function trim (buffer)
            end-perform

            move spaces to buffer.
            string
              "select bad_field from bad_table;"
              X"00"
              into buffer.
            call "MySQL_query" using buffer.
            if return-code not = 0
               call "MySQL_errno" using i
               move i to s9
               call "MySQL_error" using buffer
               display "** " function trim (s9) ":"
                 function trim (buffer) " **"
            end-if

            call "MySQL_close".
            display "after close".

            stop run.

      * error
       db-error.
           call "MySQL_errno" using errno.
           call "MySQL_error" using err-msg.
           display function trim (errno) ":" function trim (err-msg).
           stop run.
      *
