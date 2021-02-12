*> ** >>SOURCE FORMAT IS FREE
*>
*> Author    : Robert W.Mills <CobolMac@btinternet.com>
*> Dedicated to the public domain.
*>
*> Purpose   : CobolSQLite3 example and test program.
*>
*> Tests     : See Test-3 entry in the 'Example/Test Programs' section of the
*>             CobolSQLite3 User Guide.
*>
*> Written   : October 2017
*> Modified  : Feburary 2021
*>
*> Tectonics : Install the SQLite3 library (sqlite.org), if required.
*>             prompt$ cobc -x -fdebugging-line Test-3.cob
*>          or prompt$ cobc -x Test-3.cob
*>             prompt$ export COB_PRE_LOAD=CobolSQLite3
*>             prompt$ ./Test-3

identification division.

  program-id.                          Test-3.

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
      05  insert-into-foo              pic x(128) value
            "insert into foo (foo_integer, foo_real, foo_text) values (?, ?, ?);".
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

Test-3-mainline.

  set dbinfo-expand-sql to true

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

  perform add-records-to-table

  if DBRELEASE(sql-object) <> ZERO then
    display "DBRELEASE: ", DBERRMSG end-display
  end-if

>>D display "- selecting all records from foo" end-display

  move DBCOMPILE(db-object, select-from-foo) to sql-object

  if DBSTATUS <> ZERO then
    display "DBCOMPILE (select foo): ", DBERRMSG end-display
    goback
  end-if
>>D display "-- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display

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

add-records-to-table.

  move DBCOMPILE(db-object, insert-into-foo) to sql-object

  if DBSTATUS <> ZERO then
    display "DBCOMPILE: ", DBERRMSG end-display
    goback
  end-if
>>D display "-- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display

>>D display "-- Add record 1 to table." end-display

  if DBBIND(sql-object, 1, '12345') <> ZERO then
    display "DBBIND (1-1): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 2, '23.456') <> ZERO then
    display "DBBIND (1-2): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 3, '1st line, numbers should be 12345 and 23.456') <> ZERO then
    display "DBBIND (1-3): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display
>>D display "--- Insert the record." end-display

  move DBEXECUTE(sql-object) to db-status

  if not call-successful and not sql-statement-finished then
    display "DBEXECUTE (1): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- Reset the sql object." end-display

  if DBRESET(sql-object) <> ZERO then
    display "DBRESET (1): ", DBERRMSG end-display
    goback
  end-if

>>D display "-- Add record 2 to table." end-display

  if DBBIND(sql-object, 1, '2') <> ZERO then
    display "DBBIND (2-1): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 2, '2.990') <> ZERO then
    display "DBBIND (2-2): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 3, "2nd line, numbers should be 2 and 2.990") <> ZERO then
    display "DBBIND (2-3): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display
>>D display "--- Insert the record." end-display

  move DBEXECUTE(sql-object) to db-status

  if not call-successful and not sql-statement-finished then
    display "DBEXECUTE (2): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- Reset the sql object." end-display

  if DBRESET(sql-object) <> ZERO then
    display "DBRESET (2): ", DBERRMSG end-display
    goback
  end-if

>>D display "-- Add record 3 to table." end-display

  if DBBIND(sql-object, 1, '-3') <> ZERO then
    display "DBBIND (3-1): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 2, '-3.990') <> ZERO then
    display "DBBIND (3-2): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 3, "3rd line, numbers should be -3 and -3.990") <> ZERO then
    display "DBBIND (3-3): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display
>>D display "--- Insert the record." end-display

  move DBEXECUTE(sql-object) to db-status

  if not call-successful and not sql-statement-finished then
    display "DBEXECUTE (3): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- Reset the sql object." end-display

  if DBRESET(sql-object) <> ZERO then
    display "DBRESET (3): ", DBERRMSG end-display
    goback
  end-if

>>D display "-- Add record 4 to table." end-display

  if DBBIND(sql-object, 1, '4') <> ZERO then
    display "DBBIND (4-1): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 2, '4.99') <> ZERO then
    display "DBBIND (4-2): ", DBERRMSG end-display
    goback
  end-if

  if DBBIND(sql-object, 3, "4th line, numbers should be 4 and 4.990") <> ZERO then
    display "DBBIND (4-3): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- ", trim(DBINFO(dbinfo-mode,sql-object)) end-display
>>D display "--- Insert the record." end-display

  move DBEXECUTE(sql-object) to db-status

  if not call-successful and not sql-statement-finished then
    display "DBEXECUTE (4): ", DBERRMSG end-display
    goback
  end-if

>>D display "--- Reset the sql object." end-display

  if DBRESET(sql-object) <> ZERO then
    display "DBRESET (4): ", DBERRMSG end-display
    goback
  end-if
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

end program Test-3.
