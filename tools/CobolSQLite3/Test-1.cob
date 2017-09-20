*> ** >>SOURCE FORMAT IS FREE
*>
*> Author    : Robert W.Mills <CobolMac@btinternet.com>
*> Dedicated to the public domain.
*>
*> Purpose   : CobolSQLite3 example and test program.
*>
*> Tests     : See Test-1 entry in the 'Example/Test Programs' section of the
*>             CobolSQLite3 User Guide.
*>
*> Written   : September 2017
*> Modified  : Not yet.
*>
*> Tectonics : Install the SQLite3 library (sqlite.org), if required.
*>             prompt$ cobc -x -fdebugging-line Test-1.cob
*>          or prompt$ cobc -x Test-1.cob
*>             prompt$ export COB_PRE_LOAD=CobolSQLite3
*>             prompt$ ./Test-1

identification division.

  program-id.                          Test-1.

environment division.

  configuration section.

    repository.
      copy "CobolSQLite3-CSR.cpy".
      function all intrinsic.

data division.

  working-storage section.

    copy "CobolSQLite3-WS.cpy".

    01  database-name                  pic x(080) value "./test.sdb".

    01  sql-statements.
      05  create-table-foo             pic x(128) value
            "create table foo (foo_integer int, foo_real real, foo_text text);".
      05  insert-into-foo-1            pic x(128) value
            "insert into foo (foo_integer, foo_real, foo_text) " &
            "values (-12345, -12.345, '1st line, numbers should be -12345 and -12.345');".
      05  insert-into-foo-2            pic x(128) value
            "insert into foo (foo_integer, foo_real, foo_text) " &
            "values (2, 2.99, '2nd line, numbers should be 2 and 2.99');".
      05  insert-into-foo-3            pic x(128) value
            "insert into foo (foo_integer, foo_real, foo_text) " &
            "values (-3, -3.99, '3rd line, numbers should be -3 and -3.99');".
      05  insert-into-foo-4            pic x(128) value
            "insert into foo (foo_integer, foo_real, foo_text) " &
            "values (4, 4.99, '4th line, numbers should be 4 and 4.99');".
      05  select-from-foo              pic x(128) value
            "select * from foo;".

    01  row-buffer                     pic x(128).

    01  foo-heading-1.
      05                               pic x(001) value spaces.
      05                               pic x(007) value "integer".
      05                               pic x(003) value spaces.
      05                               pic x(007) value "real".
      05                               pic x(003) value spaces.
      05                               pic x(059) value "Text".

    01  foo-heading-2.
      05                               pic x(001) value spaces.
      05                               pic x(007) value all "-".
      05                               pic x(003) value spaces.
      05                               pic x(007) value all "-".
      05                               pic x(003) value spaces.
      05                               pic x(059) value all "-".

    01  foo-detail.
      05                               pic x(002) value spaces.
      05  fd-integer                   pic -(5)9(1).
      05                               pic x(003) value spaces.
      05  fd-real                      pic -(3).9(3).
      05                               pic x(003) value spaces.
      05  fd-text                      pic x(059).

procedure division.

Test-1-mainline.

>>D display "- opening database ", trim(database-name) end-display

  call "C$DELETE" using trim(database-name),
                        0 *> required but unused
  end-call

  move DBOPEN(database-name) to db-object

  if DBSTATUS <> ZERO then
    display "DBOPEN: ", DBERRMSG end-display
    goback
  end-if

>>D display "- creating table foo" end-display

  if DBSQL(db-object, create-table-foo) <> ZERO then
    display "DBSQL (create table foo): ", DBERRMSG end-display
    goback
  end-if

>>D display "- adding record(s) to table foo" end-display

  if DBSQL(db-object, insert-into-foo-1) <> ZERO then
    display "DBSQL (insert foo 1): ", DBERRMSG end-display
    goback
  end-if

  if DBSQL(db-object, insert-into-foo-2) <> ZERO then
    display "DBSQL (insert foo 2): ", DBERRMSG end-display
    goback
  end-if

  if DBSQL(db-object, insert-into-foo-3) <> ZERO then
    display "DBSQL (insert foo 3): ", DBERRMSG end-display
    goback
  end-if

  if DBSQL(db-object, insert-into-foo-4) <> ZERO then
    display "DBSQL (insert foo 4): ", DBERRMSG end-display
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

>>D display "- closing database ", trim(database-name) end-display

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

  *> Get the current result row and extract the values.

  if DBGET(sql-object, row-delims, row-buffer) <> ZERO then
    display "DBGET (foo): ", DBERRMSG end-display
  end-if

  unstring row-buffer
    delimited by field-delimiter or row-delimiter
    into
      fd-integer
      fd-real
      fd-text
  end-unstring

  *> Print the detail line.

  display foo-detail end-display

  *> Get the next row.

  move DBEXECUTE(sql-object) to db-status
  .

end program Test-1.
