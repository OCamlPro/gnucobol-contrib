*> **  >>SOURCE FORMAT IS FREE

identification division.

*> -----------------------------------------------------------------------------
*>  CobolSQLite3: an SQLite3 Interface for GnuCOBOL 2.x
*>  Copyright (c) 2017-2017 by Robert W.Mills <cobolmac@btinternet.com>
*> -----------------------------------------------------------------------------
*>
*>  This program is free software: you can redistribute it and/or modify it
*>  under the terms of the GNU General Public License as published by the Free
*>  Software Foundation, either version 3 of the License, or (at your option)
*>  any later version.
*>
*>  This program is distributed in the hope that it will be useful, but WITHOUT
*>  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*>  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
*>  more details.
*>
*>  You should have received a copy of the GNU General Public License along with
*>  this program. If not, see <http://www.gnu.org/licenses/>.
*>
*> -----------------------------------------------------------------------------
*>
*>  NOTES:
*>
*>    Requires that the SQLite3 Library (www.sqlite.org) has been installed. The
*>    download page contains precompiled binaries for Linux, Mac OS X (x86) and
*>    Windows (32-bit and 64-bit).
*>
*>    An EXTERNAL variable, named 'CobolSQLite3-Database-Status-Code', is used
*>    within this library to hold the Status Code as returned by each function.
*>    It MUST be defined, as follows, in the working storage of each module:
*>
*>      01  CobolSQLite3-Database-Status-Code   pic s9(04) comp external.
*>
*> -----------------------------------------------------------------------------
*>
*> Tectonics:
*>
*>   prompt$ cobc -o CobolSQLite3.so -debug CobolSQLite3.cob -lsqlite3
*>
*>     Compiles the CobolSQLite3 source code into a object (.so) file.
*>
*>   prompt$ cobcrun ./CobolSQLite3
*>
*>     - Displays the version id, copyright message and SQLite3 Library version.
*>     - Creates the copylibrary modules need by programs using the functions.
*> -----------------------------------------------------------------------------

*> Set the libraries Version.Update.Fix level here.
REPLACE =="V.UU.FF"== BY =="X.01.00"==.

  program-id.                          CobolSQLite3.

environment division.

  configuration section.

    source-computer.                   Linux Mint Sonya; Cinnamon Edition.
    object-computer.                   Linux Mint Sonya; Cinnamon Edition.

    repository.
      function all intrinsic.

  input-output section.

    file-control.

      select copylib                   assign to copylib-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is copylib-status
                                       .
data division.

  file section.

    fd  copylib.

    01  copylib-record                 pic x(080).

  working-storage section.

    01  copylib-filename               pic x(256).

    01  copylib-status                 pic x(002).

    01  answer                         pic x(001).

    01  sqlite3-library-version        pic x(010).

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(128) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

procedure division.

  CobolSQLite3-mainline.

    call static "sqlite3_libversion" returning sqlite3-temporary-pointer end-call

    set address of sqlite3-data to sqlite3-temporary-pointer

    string
      sqlite3-data delimited by low-value
      into sqlite3-library-version
    end-string

    set address of sqlite3-data to NULL

    display space end-display
    display "CobolSQLite3/", "V.UU.FF" end-display
    display "SQLite3 Interface Functions for GnuCOBOL 2.x" end-display
    display "Copyright (c) Robert W.Mills <cobolmac@btinternet.com>, 2017" end-display
    display "SQLite3 Library Version ", trim(sqlite3-library-version) end-display
    display space end-display
    display "This is free software; see the source for copying conditions. There is NO" end-display
    display "WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE." end-display
    display space end-display

    display "Generate Repository CopyLibrary [N/y]? " no advancing end-display
    accept answer end-accept

    if upper-case(answer) = "Y" then

      move "CobolSQLite3-CSR.cpy" to copylib-filename
      open output copylib

      move "      Function DBOPEN" to copylib-record
      write copylib-record end-write

      move "      Function DBCLOSE" to copylib-record
      write copylib-record end-write

      move "      Function DBCOMPILE" to copylib-record
      write copylib-record end-write

      move "      Function DBEXECUTE" to copylib-record
      write copylib-record end-write

      move "      Function DBRELEASE" to copylib-record
      write copylib-record end-write

      move "      Function DBRESET" to copylib-record
      write copylib-record end-write

      move "      Function DBSQL" to copylib-record
      write copylib-record end-write

      move "      Function DBGETSTR" to copylib-record
      write copylib-record end-write

      move "      Function DBGETINT" to copylib-record
      write copylib-record end-write

      move "      Function DBSTATUS" to copylib-record
      write copylib-record end-write

      move "      Function DBINFO" to copylib-record
      write copylib-record end-write

      move "      Function DBERRMSG" to copylib-record
      write copylib-record end-write

      close copylib

      display "-- CopyLibrary written to ", trim(copylib-filename) end-display
      display space end-display
      display "  Example usage:" end-display
      display space end-display
      display "    repository." end-display
      display '      copy "', trim(copylib-filename), '".' end-display
      display "      function all intrinsic." end-display
      display space end-display

    end-if

    display "Generate Working-storage CopyLibrary [N/y]? " no advancing end-display
    accept answer end-accept

    if upper-case(answer) = "Y" then

      move "CobolSQLite3-WS.cpy" to copylib-filename
      open output copylib

      *> -------------------------------------

      move "    01  db-name                        pic x(256)." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  db-object." to copylib-record
      write copylib-record end-write

      move "      05  db-object-ptr                usage pointer." to copylib-record
      write copylib-record end-write

      move "        88  database-is-closed           value NULL." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  db-status                      pic s9(04) comp." to copylib-record
      write copylib-record end-write

      move "      88  call-successful                value ZERO." to copylib-record
      write copylib-record end-write

      move "      *> -- CobolSQLite3 Function codes --------------" to copylib-record
      write copylib-record end-write

      move "      88  database-already-open          value -1." to copylib-record
      write copylib-record end-write

      move "      88  database-open-failed           value -2." to copylib-record
      write copylib-record end-write

      move "      88  database-not-open              value -3." to copylib-record
      write copylib-record end-write

      move "      88  unreleased-sql-objects-exist   value -4." to copylib-record
      write copylib-record end-write

      move "      88  sql-compile-failed             value -5." to copylib-record
      write copylib-record end-write

      move "      88  database-lock-failed           value -6." to copylib-record
      write copylib-record end-write

      move "      88  sql-object-not-released        value -7." to copylib-record
      write copylib-record end-write

      move "      88  sql-object-not-reset           value -8." to copylib-record
      write copylib-record end-write

      move "      88  datatype-not-text              value -9." to copylib-record
      write copylib-record end-write

      move "      88  datatype-not-integer           value -10." to copylib-record
      write copylib-record end-write

      move "      88  datatype-unknown-unsupported   value -11." to copylib-record
      write copylib-record end-write

      move "      88  datatype-undefined             value -12." to copylib-record
      write copylib-record end-write

      move "      *> -- SQLite3 Library codes --------------------" to copylib-record
      write copylib-record end-write

      move "      88  database-row-available         value 100." to copylib-record
      write copylib-record end-write

      move "      88  sql-statement-finished         value 101." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  sql-statement                  pic x(2048)." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  sql-object." to copylib-record
      write copylib-record end-write

      move "      05  sql-object-ptr               usage pointer." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  dbinfo-buffer                  pic x(080)." to copylib-record
      write copylib-record end-write

      move "    01  redefines dbinfo-buffer." to copylib-record
      write copylib-record end-write

      move "      05  dbinfo-rows-changed          pic s9(09) comp." to copylib-record
      write copylib-record end-write

      move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  error-message                  pic x(256)." to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      close copylib

      display "-- CopyLibrary written to ", trim(copylib-filename) end-display
      display space end-display
      display "  Example usage:" end-display
      display space end-display
      display "  working-storage section." end-display
      display '    copy "', trim(copylib-filename), '".' end-display
      display "    *> additional definitions" end-display
      display space end-display

    end-if

    goback
    .

end program CobolSQLite3.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBOPEN(db-name)
*> -----------------------------------------------------------------------------
*>
*> Opens the specified Database and creates a Database Object.
*>
*> Notes:
*>
*>   If the database does not exist then a Temporary Database is created.
*>
*>   Use the DBSTATUS Function to obtain the Status Code.
*>
*> Parameters:
*>
*>   db-name
*>     - String containing the name of the Database to be opened.
*>       (see db-name in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   Pointer holding the handle to the Database Object.
*>   (see db-object in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBOPEN.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  db-name                        pic x any length.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

procedure division using db-name
               returning db-object.

  dbopen-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    if not database-is-closed then
      move -1 to CobolSQLite3-Database-Status-Code
      goback
    end-if

    call static "sqlite3_open" using concatenate(trim(db-name), x"00"),
                                     by reference db-object-ptr
                           returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -2 to CobolSQLite3-Database-Status-Code
    end-if

    goback
    .

end function DBOPEN.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBCLOSE(db-object)
*> -----------------------------------------------------------------------------
*>
*> Closes the specified Database and destroys the Database Object.
*>
*> Notes:
*>
*>   If a Temporary Database was created then it is automatically deleted.
*>
*> Parameters:
*>
*>   db-object
*>     - Pointer holding the handle to the Database Object.
*>       (see db-object in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBCLOSE.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using db-object
               returning db-status.

  dbclose-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    if db-object-ptr = NULL then
      move -3 to CobolSQLite3-Database-Status-Code, db-status
      goback
    end-if

    call static "sqlite3_close" using by value db-object-ptr
                            returning CobolSQLite3-Database-Status-Code
    end-call

    evaluate CobolSQLite3-Database-Status-Code

      when ZERO

        set database-is-closed to TRUE
        move ZERO to db-status

      when 5

        move -4 to CobolSQLite3-Database-Status-Code, db-status

      when other

        move CobolSQLite3-Database-Status-Code to db-status

    end-evaluate

    goback
    .

end function DBCLOSE.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBCOMPILE(db-object, sql-statement)
*> -----------------------------------------------------------------------------
*>
*> Compiles an SQL Statement into byte-code and creates an SQL Object.
*>
*> Notes:
*>
*>   Use the DBSTATUS Function to obtain the Status Code.
*>
*> Parameters:
*>
*>   db-object
*>     - Pointer holding the handle to the Database Object.
*>       (see db-object in CobolSQLite3-WS.cpy)
*>
*>   sql-statement
*>     - String containing the SQL Statement to be compiled into byte-code.
*>       (see sql-statement in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   Pointer holding the handle to the SQL Object.
*>   (see sql-object in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBCOMPILE.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  sql-statement                  pic x any length.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

procedure division using db-object, sql-statement
               returning sql-object.

  dbcompile-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    if database-is-closed then
      move -3 to CobolSQLite3-Database-Status-Code
      goback
    end-if

    move length(trim(sql-statement)) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(trim(sql-statement), x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object-ptr,
                                           NULL
                                 returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -5 to CobolSQLite3-Database-Status-Code
    end-if

    goback
    .

end function DBCOMPILE.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBEXECUTE(sql-object)
*> -----------------------------------------------------------------------------
*>
*> Executes an SQL Object (compiled SQL Statement).
*>
*> Notes:
*>
*>   The handle to the Database Object is stored within the SQL Object.
*>
*> Parameters:
*>
*>   sql-object
*>     - Pointer holding the handle to the SQL Object.
*>       (see sql-object in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBEXECUTE.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbexecute-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    call static "sqlite3_step" using by value sql-object-ptr
                           returning CobolSQLite3-Database-Status-Code
    end-call

    evaluate CobolSQLite3-Database-Status-Code

      when 5

        move -6 to CobolSQLite3-Database-Status-Code, db-status

      when other

        move CobolSQLite3-Database-Status-Code to db-status

    end-evaluate

    goback
    .

end function DBEXECUTE.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBRELEASE(sql-object)
*> -----------------------------------------------------------------------------
*>
*> Releases (deletes) an SQL Object (compiled SQL Statement).
*>
*> Notes:
*>
*>   This MUST be done for all SQL Objects before the Database is closed.
*>   Failure to do so will result in "memory leaks".
*>
*> Parameters:
*>
*>   sql-object
*>     - Pointer holding the handle to the SQL Object.
*>       (see sql-object in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBRELEASE.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbrelease-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    call static "sqlite3_finalize" using by value sql-object-ptr
                               returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -7 to CobolSQLite3-Database-Status-Code, db-status
    else
      move CobolSQLite3-Database-Status-Code to db-status
    end-if

    goback
    .

end function DBRELEASE.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBRESET(sql-object)
*> -----------------------------------------------------------------------------
*>
*> Resets an SQL Object back to its initial state so it can be re-executed.
*>
*> Parameters:
*>
*>   sql-object
*>     - Pointer holding the handle to the SQL Object.
*>       (see sql-object in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBRESET.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbreset-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    call static "sqlite3_reset" using by value sql-object-ptr
                            returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -8 to CobolSQLite3-Database-Status-Code, db-status
    else
      move CobolSQLite3-Database-Status-Code to db-status
    end-if

    goback
    .

end function DBRESET.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBSQL(db-object, sql-statement)
*> -----------------------------------------------------------------------------
*>
*> Executes a single SQL Statement against a Database Object.
*>
*> Combines the functionality of DBCOMPILE, DBEXECUTE and DBRELEASE.
*>
*> Notes:
*>
*>   Any output generated by an SQL SELECT Statement will be lost.
*>
*> Parameters:
*>
*>   db-object
*>     - Pointer holding the handle to the Database Object.
*>       (see db-object in CobolSQLite3-WS.cpy)
*>
*>   sql-statement
*>     - String containing the SQL Statement to be executed.
*>       (see sql-statement in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBSQL.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

    01  sql-object                     usage pointer.

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.

    01  sql-statement                  pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using db-object, sql-statement
               returning db-status.

  dbsql-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    if db-object-ptr = NULL then
      move -3 to CobolSQLite3-Database-Status-Code, db-status
      goback
    end-if

    move trim(sql-statement) to sql-statement
    move length(sql-statement) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(sql-statement, x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object,
                                           NULL
                                 returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -5 to CobolSQLite3-Database-Status-Code, db-status
      goback
    end-if

    call static "sqlite3_step" using by value sql-object
                           returning CobolSQLite3-Database-Status-Code
    end-call

    evaluate true

      when CobolSQLite3-Database-Status-Code = 5

        move -6 to CobolSQLite3-Database-Status-Code, db-status
        goback

      when CobolSQLite3-Database-Status-Code = 100 *> SQLITE_ROW

        *> The SQL Statement has returned data which will be ignored.
        move ZERO to CobolSQLite3-Database-Status-Code, db-status

      when CobolSQLite3-Database-Status-Code = 101 *> SQLITE_DONE

        *> The SQL Statement has run to completion.
        move ZERO to CobolSQLite3-Database-Status-Code, db-status

      when other *> Return with SQLite3 status.

        move CobolSQLite3-Database-Status-Code to db-status
        goback

    end-evaluate

    call static "sqlite3_finalize" using by value sql-object
                               returning CobolSQLite3-Database-Status-Code
    end-call

    if CobolSQLite3-Database-Status-Code <> ZERO then
      move -7 to CobolSQLite3-Database-Status-Code, db-status
    else
      move CobolSQLite3-Database-Status-Code to db-status
    end-if

    goback
    .

end function DBSQL.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBGETSTR(sql-object, column-number)
*> -----------------------------------------------------------------------------
*>
*> Returns the string value of the specified column in the current row.
*>
*> Notes:
*>
*>   Use the DBSTATUS Function to obtain the Status Code.
*>
*> Parameters:
*>
*>   sql-object
*>     - Pointer holding the handle to the SQL Object.
*>       (see sql-object in CobolSQLite3-WS.cpy)
*>
*>   column-number
*>     - 16-bit Unsigned Integer indicating which column is to be returned.
*>
*> Returns:
*>
*>   String variable holding the data for the specified column.
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBGETSTR.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

    01  sqlite3-datatype               pic s9(04) comp.

    01  sqlite3-num-bytes              pic s9(04) comp.

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

    01  temp-column-number             pic 9(004) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  column-number                  pic 9(004) comp.

    01  column-value                   pic x(1024).

procedure division using sql-object, column-number
               returning column-value.

  dbgetstr-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    subtract 1 from column-number giving temp-column-number end-subtract

    call static "sqlite3_column_type" using by value sql-object-ptr,
                                            by value temp-column-number
                                  returning sqlite3-datatype
    end-call

    evaluate sqlite3-datatype

      when ZERO *> Undefined as a type conversion occurred.

        move -12 to CobolSQLite3-Database-Status-Code

      when 3 *> String

        call static "sqlite3_column_bytes" using by value sql-object-ptr,
                                                 by value temp-column-number
                                       returning sqlite3-num-bytes
        end-call

        call static "sqlite3_column_text" using by value sql-object-ptr,
                                                by value temp-column-number
                                      returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        string
          sqlite3-data delimited by low-value
          into column-value
        end-string

        set address of sqlite3-data to NULL

      when other

        move -9 to CobolSQLite3-Database-Status-Code

    end-evaluate

    goback
    .

end function DBGETSTR.

*> -----------------------------------------------------------------------------

identification division.

*> -----------------------------------------------------------------------------
*> DBGETINT(sql-object, column-number)
*> -----------------------------------------------------------------------------
*>
*> Returns the integer value of the specified column in the current row.
*>
*> Notes:
*>
*>   Use the DBSTATUS Function to obtain the Status Code.
*>
*> Parameters:
*>
*>   sql-object
*>     - Pointer holding the handle to the SQL Object.
*>       (see sql-object in CobolSQLite3-WS.cpy)
*>
*>   column-number
*>     - Unsigned Integer indicating which column is to be returned.
*>
*> Returns:
*>
*>   64-bit Signed Integer variable holding the data for the specified column.
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBGETINT.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

    01  sqlite3-datatype               pic s9(04) comp.

    01  temp-column-number             pic 9(004) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  column-number                  pic 9(004) comp.

    01  column-value                   usage binary-double signed.

procedure division using sql-object, column-number
               returning column-value.

  dbgetint-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    subtract 1 from column-number giving temp-column-number end-subtract

    call static "sqlite3_column_type" using by value sql-object-ptr,
                                            by value temp-column-number
                                  returning sqlite3-datatype
    end-call

    evaluate sqlite3-datatype

      when ZERO *> Undefined as a type conversion occurred.

        move -12 to CobolSQLite3-Database-Status-Code

      when 1 *> 64-bit Signed Integer

        call static "sqlite3_column_int" using by value sql-object-ptr,
                                               by value temp-column-number
                                     returning column-value
        end-call

      when other

        move -10 to CobolSQLite3-Database-Status-Code

    end-evaluate

    goback
    .

end function DBGETINT.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBSTATUS
*> -----------------------------------------------------------------------------
*>
*> Returns the Status Code of the last executed CobolSQLite3 DBxxx Function.
*>
*> Parameters:
*>
*>   none
*>
*> Returns:
*>
*>   16-bit Signed Integer holding the functions Status Code.
*>   (see db-status in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBSTATUS.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  db-status                      pic s9(04) comp.

procedure division returning db-status.

  dbstatus-mainline.

    move CobolSQLite3-Database-Status-Code to db-status

    goback
    .

end function DBSTATUS.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBINFO(dbinfo-mode, db-object, sql-object, colnum, colname)
*> -----------------------------------------------------------------------------
*>
*> Provides information about the Database being accessed.
*>
*> Notes:
*>
*>   Use the DBSTATUS Function to obtain the Status Code.
*>
*> Parameters:
*>
*>   dbinfo-mode
*>     - 3-digit Numeric indicating information to be returned:
*>       100 = Number of rows modified, inserted or deleted by the most recently
*>             completed INSERT, UPDATE or DELETE statement on the specified
*>             Database. Changes caused by triggers, foreign key actions or
*>             REPLACE constraint resolution are not counted.
*>
*>   db-object
*>     - Pointer holding the handle to the Database Object.
*>       (see db-object in CobolSQLite3-WS.cpy)
*>
*> Returns:
*>
*>   See definition of dbinfo-buffer in CobolSQLite3-WS.cpy
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBINFO.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.

  linkage section.

    01  dbinfo-mode                    pic 9(003).
      88  dbinfo-mode-rows-changed       value 100.

    01  db-object                      usage pointer.

    01  dbinfo-buffer                  pic x(080).

    01  redefines dbinfo-buffer.
      05  dbinfo-rows-changed          pic s9(09) comp.

procedure division using dbinfo-mode, db-object
               returning dbinfo-buffer.

  dbinfo-mainline.

    move ZERO to CobolSQLite3-Database-Status-Code

    evaluate true

      when dbinfo-mode-rows-changed

        move ZERO to dbinfo-rows-changed

        call static "sqlite3_changes" using by value db-object
                                  returning dbinfo-rows-changed
        end-call

      when other
        move -13 to CobolSQLite3-Database-Status-Code

    end-evaluate

    goback
    .

end function DBINFO.

*> *****************************************************************************

identification division.

*> -----------------------------------------------------------------------------
*> DBERRMSG
*> -----------------------------------------------------------------------------
*>
*> Returns the Database Status Code as a human-readable error message.
*>
*> Parameters:
*>
*>   none
*>
*> Returns:
*>
*>   String variable holding the human-readable error message.
*>   (see error-message in CobolSQLite3-WS.cpy)
*>
*> -----------------------------------------------------------------------------

  function-id.                         DBERRMSG.

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status-Code
                                       pic s9(04) comp external.
      88  call-successful                value ZERO.
      88  database-already-open          value -1.
      88  database-open-failed           value -2.
      88  database-not-open              value -3.
      88  unreleased-sql-objects-exist   value -4.
      88  sql-compile-failed             value -5.
      88  database-lock-failed           value -6.
      88  sql-object-not-released        value -7.
      88  sql-object-not-reset           value -8.
      88  datatype-not-text              value -9.
      88  datatype-not-integer           value -10.
      88  datatype-unknown-unsupported   value -11.
      88  datatype-undefined             value -12.
      88  invalid-dbinfo-mode            value -13.

    01 sqlite3-status                  pic Z(5)9(1).

  linkage section.

    01  error-message                  pic x(256).

procedure division returning error-message.

  dberrmsg-mainline.

    evaluate true

      when call-successful

        move "DBINF 0: Successful completion." to error-message

      when database-already-open

        move "DBERR -1: The specified database is already open." to error-message

      when database-open-failed

        move "DBERR -2: Unable to open the specified database." to error-message

      when database-not-open

        move "DBERR -3: The specified database is not open." to error-message

      when unreleased-sql-objects-exist

        move "DBERR -4: Unable to close database. Unreleased SQL Objects exist." to error-message

      when sql-compile-failed

        move "DBERR -5: Compile of SQL Statement failed." to error-message

      when database-lock-failed

        move "DBERR -6: Database locks could not be applied." to error-message

      when sql-object-not-released

        move "DBERR -7: Unable to release (delete) the SQL Object." to error-message

      when sql-object-not-reset

        move "DBERR -8: Unable to reset the SQL Object." to error-message

      when datatype-not-text

        move "DBERR -9: The datatype of the selected column is not TEXT." to error-message

      when datatype-not-integer

        move "DBERR -10: The datatype of the selected column is not a SIGNED INTEGER." to error-message

      when datatype-unknown-unsupported

        move "DBERR -11: Datatype is unknown or unsupported." to error-message

      when datatype-undefined

        move "DBERR -12: The datatype of the selected column is undefined." to error-message
        *> This error is returned if a type conversion occurred.

      when invalid-dbinfo-mode

        move "DBERR -13: The specified DBINFO Mode is not recognised." to error-message

*>      when ?
*>
*>        move "?" to error-message

      when other

        move CobolSQLite3-Database-Status-Code to sqlite3-status

        move spaces to error-message
        string
          "A Status Code of ["
          trim(sqlite3-status)
          "] has been returned by the SQLite3 Library."
          delimited by size
          into error-message
        end-string

    end-evaluate

    goback
    .

end function DBERRMSG.

*> End of source code.
*> *****************************************************************************
