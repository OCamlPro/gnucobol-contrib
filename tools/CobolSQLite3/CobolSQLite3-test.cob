*> ** >>SOURCE FORMAT IS FREE
*>
*> Test program for CobolSQLite3 [an SQLite3 Interface for GnuCOBOL 2.x].
*>
*>  - Passes string variables to DBxxx functions.
*>  - Creates database test.sdb
*>
*> Written by Robert W.Mills, September 2017.
*>
*> Tectonics:
*>
*>   Install the SQLite3 library (sqlite.org), if required.
*>   prompt$ cobc -x -fdebugging-line CobolSQLite3-test.cob
*>   prompt$ export COB_PRE_LOAD=CobolSQLite3
*>   prompt$ ./CobolSQLite3-test

identification division.

  program-id.                          CobolSQLite3-test.

environment division.

  configuration section.

    repository.
      copy "CobolSQLite3-CSR.cpy".
      function all intrinsic.

data division.

  working-storage section.

    copy "CobolSQLite3-WS.cpy".

    01  foo-column-number.
      05  fcn-line-no                  pic s9(04) comp value 1.
      05  fcn-line-text                pic s9(04) comp value 2.

    01  sql-statements.
      05  drop-table-foo               pic x(080) value
            "drop table if exists foo;".
      05  create-table-foo             pic x(080) value
            "create table foo(line_no int, line_text text);".
      05  insert-into-foo-1            pic x(088) value
            "insert into foo (line_no, line_text) values (1, 'this is line 1');".
      05  insert-into-foo-2            pic x(080) value
            "insert into foo (line_no, line_text) values (2, 'this is line 2');".
      05  insert-into-foo-3            pic x(080) value
            "insert into foo (line_no, line_text) values (3, 'this is line 3');".
      05  select-from-foo              pic x(080) value
            "select * from foo;".

    01  foo-heading-1.
      05                               pic x(001) value spaces.
      05  fh-line-no                   pic x(007) value "Line No".
      05                               pic x(003) value spaces.
      05  fh-line-text                 pic x(060) value "Line Text".
      05                               pic x(001) value spaces.

    01  foo-heading-2.
      05                               pic x(001) value spaces.
      05                               pic x(007) value all "-".
      05                               pic x(003) value spaces.
      05                               pic x(060) value all "-".
      05                               pic x(001) value spaces.

    01  foo-detail.
      05                               pic x(004) value spaces.
      05  fd-line-no                   pic Z(3)9(1).
      05                               pic x(003) value spaces.
      05  fd-line-text                 pic x(060).
      05                               pic x(001) value spaces.

procedure division.

testsqlite3-mainline.

>>D display "- opening database" end-display

  move "test.sdb" to db-name
  move DBOPEN(db-name) to db-object

  if DBSTATUS <> ZERO then
    display "DBOPEN: ", DBERRMSG end-display
    goback
  end-if

>>D display "- dropping table foo if exists" end-display

  if DBSQL(db-object, drop-table-foo) <> ZERO then
    display "DBSQL (drop table): ", DBERRMSG end-display
    goback
  end-if

>>D display "- creating table foo" end-display

  if DBSQL(db-object, create-table-foo) <> ZERO then
    display "DBSQL (create table): ", DBERRMSG end-display
    goback
  end-if

>>D display "- adding record(s) to table foo" end-display

  if DBSQL(db-object, insert-into-foo-1) <> ZERO then
    display "DBSQL (insert 1): ", DBERRMSG end-display
    goback
  end-if

  if DBSQL(db-object, insert-into-foo-2) <> ZERO then
    display "DBSQL (insert 2): ", DBERRMSG end-display
    goback
  end-if

  if DBSQL(db-object, insert-into-foo-3) <> ZERO then
    display "DBSQL (insert 3): ", DBERRMSG end-display
    goback
  end-if

>>D display "- selecting all records from foo" end-display

  move DBCOMPILE(db-object, select-from-foo) to sql-object

  if DBSTATUS <> ZERO then
    display "DBCOMPILE (select foo): ", DBERRMSG end-display
    goback
  end-if

  move DBEXECUTE(sql-object) to db-status

  evaluate true

    when database-row-available

      perform print-column-headings

      perform get-print-data
        until sql-statement-finished

      display space end-display
      display "-- End of Report --" end-display

    when sql-statement-finished
      continue

    when database-lock-failed
      display "DBEXECUTE: ", DBERRMSG end-display
      goback

    when other
      display "DBEXECUTE: ", DBERRMSG end-display
      goback

  end-evaluate

  if DBRELEASE(sql-object) <> ZERO then
    display "DBRELEASE: ", DBERRMSG end-display
  end-if

>>D display "- closing database" end-display

  if DBCLOSE(db-object) <> ZERO then
    display "DBCLOSE: ", DBERRMSG end-display
  end-if

  move zero to return-code
  goback
  .

print-column-headings.

  *> Print the column heading lines.

  display foo-heading-1 end-display
  display foo-heading-2 end-display
  .

get-print-data.

  *> Get the line-no and line-text values.

  move DBGETINT(sql-object, fcn-line-no) to fd-line-no
  move DBGETSTR(sql-object, fcn-line-text) to fd-line-text

  *> Print the detail line.

  display foo-detail end-display

  *> Get the next row.

  move DBEXECUTE(sql-object) to db-status
  .

end program CobolSQLite3-test.
