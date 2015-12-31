*> *****************************************************************************
*>  SQL3I4GC [SQLite3 Interface for GnuCOBOL] -- Macro Version: A.00.01 [ALPHA]
*>  Single Database Object Version (c) Copyright Robert W.Mills, 2015-2015.
*> -----------------------------------------------------------------------------
*>  Note: Requires that the SQLite3 Library (www.sqlite.org) has been installed.
*>  The download page contains precompiled binaries for Linux, Mac OS X (x86)
*>  and Windows (32-bit and 64-bit).
*> *****************************************************************************

*> -----------------------------------------------------------------------------
*>  Macro Parameters.
*>
*>  The following variables describe the parameters used by the macros.
*>
*>  The names are not fixed and you can change them to whatever you want (within
*>  reason). It is suggested that you keep them as-is and make a copy of those
*>  you need new names for and pass those names to the macros instead of these.
*>  It is advised that you stay away from using the prefix of sqlite3- for your
*>  variables as they could clash with internal variables used in the macros.

    01  database-name                  pic x(256).
          *> Load name of database to be opened. Ensure that picture is large
          *> enough to hold the path/name of your database else it will be
          *> truncated and the %DBOPEN call will fail.
          *> Note: The condition SQLITE3-CLOSED can be used to check if the
          *>       database is open (FALSE) or closed (TRUE).

    01  sql-statement                  pic x(1024).
          *> Load SQL statement to be compiled into an SQL Object. Ensure that
          *> picture is large enough to hold your longest statement else it will
          *> be truncated and %DBCOMPILE call will fail.

    01  sql-object                     usage pointer.
          *> Initialised by %DBCOMPILE and released by %DBDELETE. Needs to be
          *> passed to %DBEXECUTE, %DBRESET, %DBGETCOLCOUNT, %DBGETCOLNAME,
          *> %DBGETCOLTYPE and %DBGETCOLVALUE.

    01  row-num-changes                pic s9(09) comp.
          *> Initialised by %DBSQL and indicates how many rows were modified,
          *> inserted or deleted by the last %DBSQL call.

    01  column-count                   pic s9(04) comp.
          *> Initialised by %GETCOLCOUNT and indicates how many columns are in
          *> the current row returned by an SQL SELECT statement.

    01  column-number                  pic s9(04) comp.
          *> Set to the number of the column, in the current row, that you want
          *> to access. Column numbers start at zero. Needs to be passed to
          *> %DBGETCOLNAME, %DBGETCOLTYPE and %DBGETCOLVALUE.

    01  column-name                    pic x(256).
          *> The name of the column pointed to by column-number. Initialised by
          *> %DBGETCOLNAME. Ensure that the picture is large enough to hold the
          *> longest column name else it will be truncated.

    01  column-value.
          *> A general purpose buffer to accept data returned by %DBGETCOLVALUE.
      05  column-buffer                pic x(1024).
      05  redefines column-buffer.
        10  column-integer             pic 9(009).
      05  redefines column-buffer.
        10  column-text                pic x(1024).
      05  redefines column-buffer.
        10  column-null                pic 9(001).

*> The name of the following variable must not be changed but you can change the
*> names of the status codes as long as the values remain the same.

    01  database-status                pic s9(04) comp.
          *> The following Status Codes are the only ones you need to check.
          *> The comment following each code describes its purpose.
      88  database-ok                  value zero.
            *> Operation successful and there were no errors.
      88  database-busy                value 5.
            *> Database could not be read/written because of concurrent activity.
            *> This tends to be generated when database locks can not be set.
      88  database-row                 value 100.
            *> Indicates that another row of output is available for processing.
            *> Continue to call %DBEXECUTE, and proccess the returned row, until
            *> database-done is returned.
      88  database-done                value 101.
            *> Indicates that an SQL Object, a compiled SQL statement, has run
            *> to completion.

*> -----------------------------------------------------------------------------

*> -----------------------------------------------------------------------------
*>  Internal variables used by the SQLite3 macros. ** DO NOT MODIFY CONTENTS **

    01  sqlite3-object                 usage pointer value NULL.
          *> Initialised by %DBOPEN and released by %DBCLOSE.
      88  sqlite3-closed               value NULL.
            *> Easy way to check if database is open (FALSE) or closed (TRUE).

    01  sqlite3-status                 pic s9(04) comp.
          *> The following SQLite3 Status Codes are the only ones you need to
          *> check. The comment following each code describes its purpose.
          *> Note: The value of sqlite3-status is copied to database-status at
          *>       the end of each macro.
      88  sqlite3-ok                   value zero.
            *> Operation successful and there were no errors.
      88  sqlite3-busy                 value 5.
            *> Database could not be read/written because of concurrent activity.
            *> This tends to be generated when database locks can not be set.
      88  sqlite3-row                  value 100.
            *> Indicates that another row of output is available for processing.
            *> Continue to call %DBEXECUTE, and proccess the returned row, until
            *> sqlite3-done is returned.
      88  sqlite3-done                 value 101.
            *> Indicates that an SQL Object, a compiled SQL statement, has run
            *> to completion.

    01  sqlite3-message.
          *> Used by %DBERROR to display message generated by the other macros.
      05  sqlite3-message-type         pic x(003).
        88  sqlite3-error              value "*E*".
        88  sqlite3-warning            value "*W*".
        88  sqlite3-info               value "*I*".
        88  sqlite3-no-message         value spaces.
      05  sqlite3-message-body         pic x(253).

    01  sqlite3-message-2              pic x(256).
          *> Used by %DBERROR to display output from sqlite3_errmsg.

    01  sqlite3-num-bytes              pic s9(04) comp.
          *> Used by %DBCOMPILE and %DBGETCOLVALUE.

    01  sqlite3-datatype               pic s9(04) comp.
          *> Initialised by %DBGETCOLTYPE and used by %DBGETCOLVALUE.
      88  sqlite3-datatype-undefined   value zero.
      88  sqlite3-datatype-integer     value 1. *> 64-bit signed integer.
      88  sqlite3-datatype-float       value 2. *> 64-bit IEEE floating point.
      88  sqlite3-datatype-text        value 3. *> string.
      88  sqlite3-datatype-blob        value 4. *> BLOB
      88  sqlite3-datatype-null        value 5. *> NULL

    01  sqlite3-temporary-pointer      usage pointer.
          *> Initialised by sqlite3 routines that return an address to a block
          *> of memory holding text. %DBERROR, %DBGETCOLNAME and %DBGETCOLVALUE
          *> use it to retrieve this text.

    01  sqlite3-data                   pic x(1024) based.
          *> Used by %DBERROR, %DBGETCOLNAME and %DBGETCOLVALUE to retrieve text
          *> loaded into a block of memory by sqlite reoutines (see above).
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

    01  sqlite3-dbsql-object           usage pointer.
          *> Used by %DBSQL to pass an SQL Object between the macros it calls.

*> -----------------------------------------------------------------------------

*> -----------------------------------------------------------------------------
*> %DBERROR
*> -----------------------------------------------------------------------------
*> Displays, on stderr, text that describes the last error/warning/info message
*> generated for the specified database by the interface. After a warning/info
*> message is displayed the program will continue, but after an error message
*> has been displayed the program will terminate.
*>
*> The displayed message is made up as follows:
*>   1st line: Message generated by the macro.
*>   2nd line: If present, is an English-language text that's generated by the
*>             SQLite3 Library. It describes the error code returned by SQLite3.
*>   3rd line: The status code generated by the SQLite3 Library.
*>
*> Note: If you leave too long an interval between an interface macro and this
*>       macro, the Library error message may be overwritten or deallocated by
*>       subsequent Library functions.
*>
*> input values:
*> - none
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBERROR=
move spaces to sqlite3-message-2

if not sqlite3-no-message then

  display function trim(sqlite3-message) upon stderr end-display

  if sqlite3-error then

    call "sqlite3_errmsg" using by value sqlite3-object
                      returning sqlite3-temporary-pointer
    end-call

    set address of sqlite3-data to sqlite3-temporary-pointer
    string
      sqlite3-data delimited by low-value
      into sqlite3-message-2
    end-string
    set address of sqlite3-data to NULL

    display function trim(sqlite3-message-2) upon stderr end-display
    display "*E* SQLite3 Status Code: ", sqlite3-status upon stderr end-display

  end-if

end-if#

*> -----------------------------------------------------------------------------
*> %DBOPEN(database-name#)
*> -----------------------------------------------------------------------------
*> Opens the specified database and creates an SQLite3 Database Object.
*> Note: Only one database can be open at a time.
*>
*> input values:
*> - database-name is a string containing the name of the database to be opened.
*>   If the database does not exist then a skeleton database is be created.
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBOPEN=
move spaces to sqlite3-message

call "sqlite3_open" using function concatenate(function trim(!1), x"00"),
                          by reference sqlite3-object
                returning sqlite3-status
end-call

if not sqlite3-ok then
  string
    "*E* Unable to open database ", function trim(!1) delimited by size
    into sqlite3-message
  end-string
end-if

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBCLOSE
*> -----------------------------------------------------------------------------
*> Closes the current database and destroys the SQLite3 Database Object.
*>
*> input values:
*> - none
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBCLOSE=
move spaces to sqlite3-message

call "sqlite3_close" using by value sqlite3-object
                 returning sqlite3-status
end-call

evaluate true

  when sqlite3-ok
    move NULL to sqlite3-object

  when sqlite3-busy
    move "*W* The database is still open. SQL Object(s) still exists." to sqlite3-message

  when other
    move "*E* Problem detected when closing the database." to sqlite3-message

end-evaluate

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBCOMPILE(sql-statement#, sql-object#)
*> -----------------------------------------------------------------------------
*> Compiles an SQL statement into byte-code and creates an SQLite3 SQL Object.
*>
*> input values:
*> - sql-statement is a string containing the SQL statement that is to be
*>   compiled.
*>
*> output values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*> -----------------------------------------------------------------------------

$define %DBCOMPILE=
move spaces to sqlite3-message

move function length(function trim(!1)) to sqlite3-num-bytes
add 1 to sqlite3-num-bytes end-add

call "sqlite3_prepare_v2" using by value sqlite3-object,
                                by content function concatenate(function trim(!1), x"00"),
                                by value sqlite3-num-bytes,
                                by reference !2,
                                NULL
                      returning sqlite3-status
end-call

if not sqlite3-ok then
  move "*E* Compile of SQL statement failed." to sqlite3-message
end-if

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBEXECUTE(sql-object#)
*> -----------------------------------------------------------------------------
*> Executes an SQLite3 SQL Object. The SQLite3 Database Object it will be run
*> against is stored within the SQL Object.
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBEXECUTE=
move spaces to sqlite3-message

call "sqlite3_step" using by value !1
                returning sqlite3-status
end-call

evaluate true

  when sqlite3-row
    continue

  when sqlite3-done
    continue

  when sqlite3-busy
    move "*E* Database locks could not be applied." to sqlite3-message

  when other
    move "*E* The SQL statement failed." to sqlite3-message

end-evaluate

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBDELETE(sql-object#)
*> -----------------------------------------------------------------------------
*> Deletes an SQLite3 SQL Object. This must be done for all SQL Objects before
*> the database is closed. Failure to do so will result in "memory leaks".
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBDELETE=
move spaces to sqlite3-message

call "sqlite3_finalize" using by value !1
                    returning sqlite3-status
end-call

if not sqlite3-ok then
  move "*W* An SQL Object could not be deleted." to sqlite3-message
end-if

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBRESET(sql-object#)
*> -----------------------------------------------------------------------------
*> Resets an SQLite3 SQL Object back to its initial state. The Object can then
*> be re-executed.
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBRESET=
move spaces to sqlite3-message

call "sqlite3_reset" using by value !1
                 returning sqlite3-status
end-call

if not sqlite3-ok then
  move "*E* An SQL Object could not be reset." to sqlite3-message
end-if

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
*> %DBGETCOLCOUNT(sql-object#, column-count#)
*> -----------------------------------------------------------------------------
*> Gets the number of columns in the current row.
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*>
*> output values:
*> - column-count is a numeric variable that will indicate the number of columns
*>   in the current row. A value of zero indicates that no data was returned
*>   (for example, an SQL UPDATE or DELETE).
*> -----------------------------------------------------------------------------

$define %DBGETCOLCOUNT=
call "sqlite3_column_count" using by value !1
                        returning !2
end-call#

*> -----------------------------------------------------------------------------
*> %DBGETCOLNAME(sql-object#, column-number#, column-name#)
*> -----------------------------------------------------------------------------
*> Gets the name of the specified column in the current row.
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*> - column-number is a numeric variable that indicates which column to return
*>   the name for. Column numbers start, on the left, at zero.
*>
*> output values:
*> - column-name is a string variable that will contain the column name.
*> -----------------------------------------------------------------------------

$define %DBGETCOLNAME=
call "sqlite3_column_name" using by value !1,
                                 by value !2
                       returning sqlite3-temporary-pointer
end-call

set address of sqlite3-data to sqlite3-temporary-pointer
string
  sqlite3-data delimited by low-value
  into !3
end-string
set address of sqlite3-data to NULL#

*> -----------------------------------------------------------------------------
*> %DBGETCOLVALUE(sql-object#, column-number#, column-value#)
*> -----------------------------------------------------------------------------
*> Gets the value of the specified column in the current row.
*>
*> input values:
*> - sql-object is a usage pointer variable that points to the SQLite3 SQL
*>   Object.
*> - column-number is a numeric variable that indicates which column to return
*>   the datatype for. Column numbers start, on the left, at zero.
*>
*> output values:
*> - column-value is a variable suitable to hold the returned value.
*> -----------------------------------------------------------------------------

$define %DBGETCOLVALUE=
move spaces to sqlite3-message

call "sqlite3_column_type" using by value !1,
                                 by value !2
                       returning sqlite3-datatype
end-call

*> Note: sqlite3-datatype is only meaningful if no type conversion occurred.
*>       After a type conversion, the value returned is undefined.

evaluate sqlite3-datatype

  when 1 *> 64-bit signed integer.

    call "sqlite3_column_int" using by value !1,
                                    by value !2
                          returning column-integer
    end-call

  when 3 *> Text string.

    call "sqlite3_column_bytes" using by value !1,
                                      by value !2
                            returning sqlite3-num-bytes
    end-call

    call "sqlite3_column_text" using by value !1,
                                     by value !2
                           returning sqlite3-temporary-pointer
    end-call

    set address of sqlite3-data to sqlite3-temporary-pointer
    string
      sqlite3-data delimited by low-value
      into column-text
    end-string
    set address of sqlite3-data to NULL

  when 5 *> Column contains NULL.
    move x"00" to column-buffer

  when 2 *> 64-bit IEEE floating point number.
    move "*W* The FLOAT datatype is not yet supported." to sqlite3-message

  when 4 *> BLOB
    move "*W* The BLOB datatype is not yet supported." to sqlite3-message

  when other
    move "*W* Datatype is unknown or undefined." to sqlite3-message

end-evaluate#

*> -----------------------------------------------------------------------------
*> %DBSQL(sql-statement#)
*> -----------------------------------------------------------------------------
*> Executes a single SQL statement against an SQLite3 Database Object.
*> Combines the functionality of the %DBCOMPILE, %DBEXECUTE and %DBDELETE macros.
*>
*> Note: A call to %DBERROR will display a warning message if any SQL statement,
*>       eg SELECT, has resulted in the return of data. This data, if any, will
*>       have been lost and can not be accessed in any way.
*>
*> input values:
*> - sql-statement is a string containing the SQL statement that is to be
*>   compiled.
*>
*> output values:
*> - none
*> -----------------------------------------------------------------------------

$define %DBSQL=
move spaces to sqlite3-message

move function length(function trim(!1)) to sqlite3-num-bytes
add 1 to sqlite3-num-bytes end-add

*> Compile SQL statement into an Object.

call "sqlite3_prepare_v2" using by value sqlite3-object,
                                by content function concatenate(function trim(!1), x"00"),
                                by value sqlite3-num-bytes,
                                by reference sqlite3-dbsql-object,
                                NULL
                      returning sqlite3-status
end-call

if sqlite3-ok then

  *> Execute the SQL Object.

  call "sqlite3_step" using by value sqlite3-dbsql-object
                  returning sqlite3-status
  end-call

  evaluate true

    when sqlite3-row
      move "*W* SQL statement returned data which is ignored." to sqlite3-message
      set sqlite3-ok to true

    when sqlite3-done
      *> The SQL statement completed successfully.
      set sqlite3-ok to true

    when sqlite3-busy
      move "*E* Database locks could not be applied." to sqlite3-message

    when other
      move "*E* The SQL statement failed." to sqlite3-message

  end-evaluate

  *> Get mumber of rows modified, inserted or deleted.

  call "sqlite3_changes" using by value sqlite3-object
                     returning row-num-changes
  end-call

  *> Delete the SQL Object.

  call "sqlite3_finalize" using by value sqlite3-dbsql-object,
                      returning sqlite3-status
  end-call

  if not sqlite3-ok then
    move "*W* An SQL Object could not be deleted." to sqlite3-message
  end-if

else
  move "*E* Compile of SQL statement failed." to sqlite3-message
end-if

move sqlite3-status to database-status#

*> -----------------------------------------------------------------------------
