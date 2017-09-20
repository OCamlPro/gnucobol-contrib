*> **  >>SOURCE FORMAT IS FREE

identification division.

*> Set the libraries Version.Update.Fix level here.
REPLACE =="V.UU.FF"== BY =="A.00.00"==.

*><* ========================================
*><* CobolSQLite3 User Guide for Version A.00
*><* ========================================
*>
*>   When the "V.UU" changes modify the above line.
*>
*><*
*><* .. sidebar:: Table of Contents
*><*
*><*     .. contents:: :local:
*><*
*><* ::
*><*
*><*    ____      _           _  ____   ___  _     _ _        _____
*><*   / ___|___ | |__   ___ | |/ ___| / _ \| |   (_) |_ ___ |___ /
*><*  | |   / _ \| '_ \ / _ \| |\___ \| | | | |   | | __/ _ \  |_ \
*><*  | |__| (_) | |_) | (_) | | ___) | |_| | |___| | ||  __/ ___) |
*><*   \____\___/|_.__/ \___/|_||____/ \__\_\_____|_|\__\___||____/
*><*
*><* :Author:   Robert W.Mills
*><* :Date:     September 2017
*><* :Rights:   Copyright © 2017-2017, Robert W.Mills.
*><* :Email:    CobolMac@btinternet.com
*><* :Purpose:  An SQLite3 Interface Library for GnuCOBOL 2.2+
*><*
*><* ----------
*><* 1. License
*><* ----------
*><*
*><*   This program is free software: you can redistribute it and/or modify it
*><+    under the terms of the GNU General Public License as published by the Free
*><+    Software Foundation, either version 3 of the License, or (at your option)
*><+    any later version.
*><*
*><*   This program is distributed in the hope that it will be useful, but WITHOUT
*><+    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*><+    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
*><+    more details.
*><*
*><*   You should have received a copy of the GNU General Public License along with
*><+    this program. If not, see <http://www.gnu.org/licenses/#GPL>.
*><*
*><* --------------
*><* 2. Description
*><* --------------
*><*
*><*   The *CobolSQLite3* Library is an interface to the SQLite3 Database Engine.
*><*
*><*   The interface consists of a Dynamic Library (.so file in Linux & .dll in
*><+   Windows). It containing User Defined Functions that perform the following
*><+   actions:
*><*
*><*   - Open/Create an SQLite Database.
*><*   - Close an SQLite Database.
*><*   - Compile an SQL Statement into byte-code.
*><*   - Execute a compiled SQL Statement.
*><*   - Release (delete) a compiled SQL Statement.
*><*   - Reset (re-initialise) a compiled SQL Statement.
*><*   - Compile, execute and release an SQL Statement.
*><*   - Retrieve all columns from a SELECTed row.
*><*   - Request information about the Database (currently a limited function).
*><*   - Translate a Status Code into human-readable text.
*><*

*> *****************************************************************************

*> Developer Notes (not included in the User Guide).
*> -------------------------------------------------
*>
*> Prior to release of a new version:
*>
*>   - Add an entry to the Modification History (ChangeLog file).
*>
*>   - Update the Developer Notes, if required.
*>
*>   - Update the Libraries Version.Update.Fix (v.uu.ff) level (edit the REPLACE
*>     statement at the beginning of the source file).
*>
*>       *v*  = A letter indicating the VERSION.
*>              Increment when a MAJOR (?non-compatible?) change has been made.
*>       *uu* = A 2-digit number indicating an UPDATE to the current VERSION.
*>              Set to 00 when the VERSION changes.
*>       *ff* = A 2-digit number indicating a FIX to the current UPDATE.
*>              Set to 00 when the UPDATE changes.
*>
*>   - Update the documentation, if required.
*>
*>   - Ammend the User Guide version if the Library Version.Update level changed.
*>
*> Library Status Code:
*>
*>   An EXTERNAL variable is used within this library to hold the Status Code as
*>   returned by each function. Add a definition for it in the working-storage of
*>   each new module. Initialise to ZERO at the start of the module. If an error
*>   occurs then set it to the required value prior to exiting the module.
*>
*>     01  CobolSQLite3-Database-Status pic s9(04) comp external.

*> *****************************************************************************

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

    call static "sqlite3_libversion" returning sqlite3-temporary-pointer
    end-call

    set address of sqlite3-data to sqlite3-temporary-pointer

    string
      sqlite3-data delimited by low-value
      into sqlite3-library-version
    end-string

    set address of sqlite3-data to NULL

    display space end-display
    display "CobolSQLite3/", "V.UU.FF" end-display
    display "SQLite3 Interface Functions for GnuCOBOL 2.2+" end-display
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

      move "      Function DBSTATUS" to copylib-record
      write copylib-record end-write

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

      move "      Function DBGET" to copylib-record
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

      move "    01  db-object                      pic x(008)." to copylib-record
      write copylib-record end-write

      move "      88  database-is-closed             value NULL." to copylib-record
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

      move "      88  datatype-unknown-unsupported   value -11." to copylib-record
      write copylib-record end-write

      move "      88  datatype-undefined             value -12." to copylib-record
      write copylib-record end-write

      move "      88  invalid-dbinfo-mode            value -13." to copylib-record
      write copylib-record end-write

      move "      88  not-an-sqlite-database         value -14." to copylib-record
      write copylib-record end-write

      move "      88  no-data-returned               value -15." to copylib-record
      write copylib-record end-write

      move "      88  row-buffer-overflow            value -16." to copylib-record
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

      move "    01  sql-object                     pic x(008)." to copylib-record
      write copylib-record end-write

      move "      88  object-released                value NULL." to copylib-record
      write copylib-record end-write

     move spaces to copylib-record
      write copylib-record end-write

      *> -------------------------------------

      move "    01  row-delims." to copylib-record
      write copylib-record end-write

      move "      05  field-delimiter              pic x(001) value x'1D'." to copylib-record
      write copylib-record end-write

      move "      05  row-delimiter                pic x(001) value x'1E'." to copylib-record
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

      move "    01  error-message                  pic x(128)." to copylib-record
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

*><* --------------------
*><* 3. Library Functions
*><* --------------------
*><*
*><* 3.0. Restrictions
*><* ~~~~~~~~~~~~~~~~~
*><*
*><*   *DBCOMPILE* and *DBSQL* will only use the 1st statement passed in the
*><+    *sql-statement* parameter, any additional statements will be dropped.
*><*
*><*   This helps prevent **SQL Injection Attacks** against the Database.
*><*

*> *****************************************************************************

identification division.

  function-id.                         DBSTATUS.

*><* 3.1. DBSTATUS
*><* ~~~~~~~~~~~~~
*><*
*><*   Returns the *Status Code* of the last executed CobolSQLite3 function.
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBSTATUS
*><*
*><* Parameters
*><* ##########
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

  linkage section.

    01  db-status                      pic s9(04) comp.

procedure division returning db-status.

  dbstatus-mainline.

    move CobolSQLite3-Database-Status to db-status

    goback
    .

end function DBSTATUS.

*> *****************************************************************************

identification division.

  function-id.                         DBOPEN.

*><* 3.2. DBOPEN
*><* ~~~~~~~~~~~
*><*
*><*   Opens the specified database and creates a Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   *db-object* = DBOPEN(*db-name*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *db-name* is the name of the Database to be opened, and can be either an
*><+  alphanumeric variable or quoted string. If the Database is not in the current
*><+  working directory then you must pre-pend the path to the name.
*><*
*><*     *db-object* is a variable that is used to hold the internal handle to the
*><+  Database Object, it must be alphanumeric with at least a size of 8.
*><*
*><* Notes
*><* #####
*><*
*><*   If the database does not exist then it will be automatically created.
*><*
*><*   If *db-name* specifies a file that is not an SQLite3 Database then *DBOPEN*
*><+    will return an error (use DBSTATUS to return the Status Code).
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

    01  pic x(001). *> is the file an sqlite3 database?
      88  is-an-sqlite3-database         value "I".
      88  not-an-sqlite3-database        value "N".

    *> CBL_*_FILE parameters

    01  file-handle                    usage pointer.
    01  offset                         pic x(8) usage comp-x.
    01  read-buffer                    pic x(015).

  linkage section.

    01  db-name                        pic x any length.

    01  db-object                      pic x(008).

    01  redefines db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

procedure division using db-name
               returning db-object.

  dbopen-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status

    if not database-is-closed then
      move -1 to CobolSQLite3-Database-Status
      goback
    end-if

    perform check-if-sqlite-database

    if not-an-sqlite3-database then
      move -14 to CobolSQLite3-Database-Status
      goback
    end-if

    call static "sqlite3_open" using concatenate(trim(db-name), x"00"),
                                     by reference db-object-ptr
                           returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> database open failed
      *> move -2 to CobolSQLite3-Database-Status
      move sqlite3-status to CobolSQLite3-Database-Status
    end-if

    goback
    .

  check-if-sqlite-database.

    set not-an-sqlite3-database to TRUE

    call "CBL_OPEN_FILE" using concatenate(trim(db-name), x"00"),
                               1, *> access mode = read only
                               3, *> file lock = allow shared read/write
                               0, *> device (must be ZERO)
                               file-handle
    end-call

    evaluate return-code

      when ZERO *> file exists

        move "00000000" to offset

        call "CBL_READ_FILE" using file-handle,
                                   offset,
                                   15, *> mumber of bytes to be read
                                   0, *> standard read
                                   read-buffer
        end-call

        if return-code = ZERO then *> read sucessful

          if trim(read-buffer) = "SQLite format 3" then
            set is-an-sqlite3-database to TRUE
          end-if

        end-if

      when 35 *> file does not exist
        set is-an-sqlite3-database to TRUE

    end-evaluate

    call "CBL_CLOSE_FILE" using file-handle
    end-call
    .

end function DBOPEN.

*> *****************************************************************************

identification division.

  function-id.                         DBCLOSE.

*><* 3.3. DBCLOSE
*><* ~~~~~~~~~~~~
*><*
*><*   Closes the specified database and destroys its Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBCLOSE(*db-object*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *db-object* is a variable that is used to hold the internal handle to the
*><+  Database Object, it must be alphanumeric with at least a size of 8.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  db-object                      pic x(008).

    01  redefines db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using db-object
               returning db-status.

  dbclose-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    if database-is-closed then
      move -3 to CobolSQLite3-Database-Status, db-status
      goback
    end-if

    call static "sqlite3_close" using by value db-object-ptr
                            returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> database closed
        set database-is-closed to TRUE

      when 5 *> not all sql objects have been released
        move -4 to CobolSQLite3-Database-Status, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to CobolSQLite3-Database-Status, db-status

    end-evaluate

    goback
    .

end function DBCLOSE.

*> *****************************************************************************

identification division.

  function-id.                         DBCOMPILE.

*><* 3.4. DBCOMPILE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Compiles an SQL Statement, into byte-code, and creates an SQL Object for it.
*><*
*><* Syntax
*><* ######
*><*
*><*   *sql-object* = DBCOMPILE(*db-object*, *sql-statement*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *db-object* is a variable that is used to hold the internal handle to the
*><+  Database Object, it must be alphanumeric with at least a size of 8.
*><*
*><*     *sql-statement* is the SQL Statement to be compiled, and can be either an
*><+  alphanumeric variable or quoted string.
*><*
*><*     *sql-object* is a variable that is used to hold the internal handle to the
*><+  SQL Object created for a compiled SQL Statement, it must be alphanumeric with
*><+  at least a size of 8.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

    01  sql-statement-wrk              pic x(4096). *> 4K should be big enough

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object                      pic x(008).

    01  redefines db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  sql-statement                  pic x any length.

    01  sql-object                     pic x(008).

    01  redefines sql-object.
      05  sql-object-ptr               usage pointer.

procedure division using db-object, sql-statement
               returning sql-object.

  dbcompile-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status

    if database-is-closed then
      move -3 to CobolSQLite3-Database-Status
      goback
    end-if

    move trim(sql-statement) to sql-statement-wrk
    move length(trim(sql-statement-wrk, trailing)) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(trim(sql-statement-wrk), x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object-ptr,
                                           NULL
                                 returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> compile failed
      *> move -5 to CobolSQLite3-Database-Status
      move sqlite3-status to CobolSQLite3-Database-Status
    end-if

    goback
    .

end function DBCOMPILE.

*> *****************************************************************************

identification division.

  function-id.                         DBEXECUTE.

*><* 3.5. DBEXECUTE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Executes an SQL Object (a compiled SQL Statement).
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBEXECUTE(*sql-object*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *sql-object* is a variable that is used to hold the internal handle to the
*><+  SQL Object created for a compiled SQL Statement, it must be alphanumeric with
*><+  at least a size of 8.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object                     pic x(008).

    01  redefines sql-object.
      05  sql-object-ptr               usage pointer.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbexecute-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    call static "sqlite3_step" using by value sql-object-ptr
                           returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when 5 *> unable to obtain database locks
        move -6 to CobolSQLite3-Database-Status, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to CobolSQLite3-Database-Status, db-status

    end-evaluate

    goback
    .

end function DBEXECUTE.

*> *****************************************************************************

identification division.

  function-id.                         DBRELEASE.

*><* 3.6. DBRELEASE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Releases (deletes) an SQL Object (a compiled SQL Statement).
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBRELEASE(*sql-object*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *sql-object* is a variable that is used to hold the internal handle to the
*><+  SQL Object created for a compiled SQL Statement, it must be alphanumeric with
*><+  at least a size of 8.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*
*><* Notes
*><* #####
*><*
*><*   This function MUST be executed against all SQL Objects before the database
*><+    is closed as failure to do so result's in *memory leaks*.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object                     pic x(008).

    01  redefines sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbrelease-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    call static "sqlite3_finalize" using by value sql-object-ptr
                               returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> object released
        set object-released to TRUE

      when other *> sqlite3 object not released
        *> move -7 to CobolSQLite3-Database-Status, db-status
        move sqlite3-status to CobolSQLite3-Database-Status, db-status

    end-evaluate

    goback
    .

end function DBRELEASE.

*> *****************************************************************************

identification division.

  function-id.                         DBRESET.

*><* 3.7. DBRESET
*><* ~~~~~~~~~~~~
*><*
*><*   Resets the SQL Object back to initial state so it can be re-executed.
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBRESET(*sql-object*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *sql-object* is a variable that is used to hold the internal handle to the
*><+  SQL Object created for a compiled SQL Statement, it must be alphanumeric with
*><+  at least a size of 8.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object                     pic x(008).

    01  redefines sql-object.
      05  sql-object-ptr               usage pointer.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbreset-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    call static "sqlite3_reset" using by value sql-object-ptr
                            returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> object not reset
      *> move -8 to CobolSQLite3-Database-Status, db-status
      move sqlite3-status to CobolSQLite3-Database-Status, db-status
    end-if

    goback
    .

end function DBRESET.

*> *****************************************************************************

identification division.

  function-id.                         DBSQL.

*><* 3.8. DBSQL
*><* ~~~~~~~~~~
*><*
*><*   Executes an SQL Statement against the Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBSQL(*db-object*, *sql-statement*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *db-object* is a variable that is used to hold the internal handle to the
*><+  Database Object, it must be alphanumeric with at least a size of 8.
*><*
*><*     *sql-statement* is the SQL Statement to be executed. It can be either an
*><+  alphanumeric variable or a quoted string.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*
*><* Notes
*><* #####
*><*
*><*   This function combines the DBCOMPILE, DBEXECUTE and DBRELEASE functionality.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

    01  sql-object-ptr                 usage pointer.
      88  object-released                value NULL.

    01  sql-statement-wrk              pic x(4096). *> 4K should be big enough

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object                      pic x(008).

    01  redefines db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  sql-statement                  pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using db-object, sql-statement
               returning db-status.

  dbsql-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    if database-is-closed then
      move -3 to CobolSQLite3-Database-Status, db-status
      goback
    end-if

    move trim(sql-statement) to sql-statement-wrk
    move length(trim(sql-statement-wrk, trailing)) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(sql-statement-wrk, x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object-ptr,
                                           NULL
                                 returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> compile failed
      *> move -5 to CobolSQLite3-Database-Status, db-status
      move sqlite3-status to CobolSQLite3-Database-Status, db-status
      goback
    end-if

    call static "sqlite3_step" using by value sql-object-ptr
                           returning sqlite3-status
    end-call

    evaluate true

      when sqlite3-status = 5 *> unable to obtain database locks
        move -6 to CobolSQLite3-Database-Status, db-status
        goback

      when sqlite3-status = 100 *> statement returned data, will be ignored
        move ZERO to CobolSQLite3-Database-Status, db-status

      when sqlite3-status = 101 *> statement has run to completion
        move ZERO to CobolSQLite3-Database-Status, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to CobolSQLite3-Database-Status, db-status
        goback

    end-evaluate

    call static "sqlite3_finalize" using by value sql-object-ptr
                               returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> object released
        set object-released to TRUE

      when other *> sqlite3 object not released
        *> move -7 to CobolSQLite3-Database-Status, db-status
        move sqlite3-status to CobolSQLite3-Database-Status, db-status

    end-evaluate

    goback
    .

end function DBSQL.

*> *****************************************************************************

identification division.

  function-id.                         DBGET.

*><* 3.9. DBGET
*><* ~~~~~~~~~~
*><*
*><*   Returns the current result row of an SQL Query (Select).
*><*
*><* Syntax
*><* ######
*><*
*><*   *status-code* = DBGET(*sql-object*, *row-delims*, *row-buffer*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *sql-object* is a variable that is used to hold the internal handle to the
*><+  SQL Object created for a compiled SQL Statement, it must be alphanumeric with
*><+  at least a size of 8.
*><*
*><*     *row-delims* is an alphanumeric variable containing the delimiters to use
*><+  when loading the *row-buffer*.
*><*
*><*     - The 1st character is placed between each column (see Notes below).
*><*     - The 2nd character is placed after the last column to indicate the end of
*><+  data in *row-buffer* (see Notes below)
*><*
*><*     *row-buffer* is an alphanumeric variable that contains the complete row in
*><+  delimited format. All numeric column data is converted to display format.
*><*
*><*     *status-code* is a signed binary integer, with at least a size of 4. It
*><+  will hold the same value that would be returned by the DBSTATUS function.
*><*
*><* Notes
*><* #####
*><*
*><*   The *row-delims* entry in the Working-Storage Copybook sets default values of
*><+    HEX 1D (Group Separator) and HEX 1E (Record Separator) for the 1st and 2nd
*><+    delimiter. These values are the developers choice and you can keep them as-is,
*><+    modify the *row-delims* entry in the Copybook, or override the values within
*><+    your program by using one-or-more MOVE commands.
*><*
*><*   A modified version of the following **unstring** statement should be used to
*><+    extract the data for each column from **row-buffer**. You, as the developer
*><+    using this Library, are in complete control of the picture format/size of the
*><+    Working-storage field that will be the recipient of the column data. It is
*><+    suggested that you use the SQLite Command-Line Shell (see Section 5.1) to look
*><+    at the current data formats/sizes used and code accordingly.
*><*
*><*   .. code:: cobolfree
*><*
*><*     unstring row-buffer
*><*       delimited by field-delimiter or row-delimiter
*><*       into
*><*         ws-column-1
*><*         ws-column-2
*><*         ws-column-n
*><*     end-unstring
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  sqlite3-status                 pic s9(04) comp.

    01  sqlite3-datatype               pic s9(04) comp.

    01  sqlite3-column-count           pic s9(04) comp.

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

    01  column-number                  usage binary-short unsigned.

    01  row-buffer-idx                 pic 9(018).

  linkage section.

    01  sql-object                     pic x(008).

    01  redefines sql-object.
      05  sql-object-ptr               usage pointer.

    01  delims.
      05  field-delimiter              pic x(001).
      05  row-delimiter                pic x(001).

    01  row-buffer                     pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object, delims, row-buffer
               returning db-status.

  dbget-mainline.

    move ZERO to CobolSQLite3-Database-Status, sqlite3-status, db-status

    perform get-column-count

    move SPACES to row-buffer
    move 1 to row-buffer-idx

    perform get-column-data
      varying column-number from ZERO by 1
      until column-number = sqlite3-column-count

    perform replace-last-field-delimiter

    goback
    .

  get-column-count.

    call static "sqlite3_column_count" using by value sql-object-ptr
                                   returning sqlite3-column-count
    end-call

    if sqlite3-column-count = ZERO then *> no data returned
      move -15 to CobolSQLite3-Database-Status, db-status
      goback
    end-if
    .

  get-column-data.

    call static "sqlite3_column_type" using by value sql-object-ptr,
                                            by value column-number
                                  returning sqlite3-datatype
    end-call

    evaluate sqlite3-datatype

      when ZERO *> undefined as a type conversion occurred
        move -12 to CobolSQLite3-Database-Status

      when 1 *> 64-bit signed integer (automatic convertion to text)
      when 2 *> 64-bit ieee floating point number (automatic convertion to text)
      when 3 *> string

        call static "sqlite3_column_text" using by value sql-object-ptr,
                                                by value column-number
                                      returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        string
          sqlite3-data delimited by low-value
          field-delimiter delimited by size
          into row-buffer with pointer row-buffer-idx
          on overflow
            move -16 to CobolSQLite3-Database-Status
            goback
        end-string

        set address of sqlite3-data to NULL

      when 4 *> blob

        call static "sqlite3_column_blob" using by value sql-object-ptr,
                                                by value column-number
                                      returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        string
          sqlite3-data delimited by low-value
          field-delimiter delimited by size
          into row-buffer with pointer row-buffer-idx
          on overflow
            move -16 to CobolSQLite3-Database-Status
            goback
        end-string

        set address of sqlite3-data to NULL

      when 5 *> null

        string
          field-delimiter delimited by size
          into row-buffer with pointer row-buffer-idx
          on overflow
            move -16 to CobolSQLite3-Database-Status
            goback
        end-string

      when other *> datatype unknown/unsupported
        move -11 to CobolSQLite3-Database-Status

    end-evaluate
    .

  replace-last-field-delimiter.

    move row-delimiter to row-buffer(row-buffer-idx - 1:1)
    .

end function DBGET.

*> *****************************************************************************

identification division.

  function-id.                         DBINFO.

*><* 3.10. DBINFO
*><* ~~~~~~~~~~~~
*><*
*><*   Returns information about the Database being accessed.
*><*
*><* Syntax
*><* ######
*><*
*><*   *dbinfo-buffer* = DBINFO(*dbinfo-mode*, *db-object*)
*><*
*><* Parameters
*><* ##########
*><*
*><*     *dbinfo-mode* is a three digit numeric indicating the information to return
*><+  (see DBINFO Modes table below).
*><*
*><*     *db-object* is a variable that is used to hold the internal handle to the
*><+  Database Object, it must be alphanumeric with at least a size of 8.
*><*
*><*     *dbinfo-buffer* is an alphanumeric variable for returning the requested
*><+  information. Refer to the mapping for *dbinfo-buffer* in the Working-Storage
*><+  Copybook (CobolSQLite3-WS.cpy) for further details.
*><*
*><* DBINFO Modes
*><* ############
*><*
*><*   +----+----------------------------------------------------------------------+
*><*   |Mode|Description                                                           |
*><*   +====+======================================================================+
*><*   |100 |The number of rows modified, inserted or deleted by the most recently |
*><*   |    |completed INSERT, UPDATE or DELETE statement against the database.    |
*><*   |    |                                                                      |
*><*   |    |Changes caused by triggers, foreign key actions or REPLACE constraint |
*><*   |    |resolution are not counted.                                           |
*><*   +----+----------------------------------------------------------------------+
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

  linkage section.

    01  dbinfo-mode                    pic 9(003).
      88  dbinfo-mode-rows-changed       value 100.

    01  db-object                      pic x(008).

    01  redefines db-object.
      05  db-object-ptr                usage pointer.

    01  dbinfo-buffer                  pic x(080).

    01  redefines dbinfo-buffer.
      05  dbinfo-rows-changed          pic s9(09) comp.

procedure division using dbinfo-mode, db-object
               returning dbinfo-buffer.

  dbinfo-mainline.

    move ZERO to CobolSQLite3-Database-Status

    evaluate true

      when dbinfo-mode-rows-changed

        move ZERO to dbinfo-rows-changed

        call static "sqlite3_changes" using by value db-object-ptr
                                  returning dbinfo-rows-changed
        end-call

      when other *> invalid dbinfo mode
        move -13 to CobolSQLite3-Database-Status

    end-evaluate

    goback
    .

end function DBINFO.

*> *****************************************************************************

identification division.

  function-id.                         DBERRMSG.

*><* 3.11. DBERRMSG
*><* ~~~~~~~~~~~~~~
*><*
*><*   Returns the error message associated with the last *Status Code* setting.
*><*
*><* Syntax
*><* ######
*><*
*><*   *error-message* = DBERRMSG
*><*
*><* Parameters
*><* ##########
*><*
*><*    *error-message* is an alphanumeric variable, with at least a size of 128.
*><*
*><* Notes
*><* #####
*><*
*><*   The returned *error-message* will have one of following prefixes:
*><*
*><*     **DBINF** is not an actual error but for information. *DBINFO 0: Successful
*><+  completion.* is the only entry with this prefix.
*><*
*><*     **DBERR** errors are generated by the *CobolSQLite3* Library.
*><*
*><*     **SQLite3ERR** errors are generated by the SQLite3 Library.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  CobolSQLite3-Database-Status   pic s9(04) comp external.

    01  db-status                      pic s9(04) comp.
      88  call-successful                value ZERO.
      88  database-already-open          value -1.
      88  database-open-failed           value -2.
      88  database-not-open              value -3.
      88  unreleased-sql-objects-exist   value -4.
      88  sql-compile-failed             value -5.
      88  database-lock-failed           value -6.
      88  sql-object-not-released        value -7.
      88  sql-object-not-reset           value -8.
      88  datatype-unknown-unsupported   value -11.
      88  datatype-undefined             value -12.
      88  invalid-dbinfo-mode            value -13.
      88  not-an-sqlite-database         value -14.
      88  no-data-returned               value -15.
      88  row-buffer-overflow            value -16.

    01  display-sqlite3-status         pic Z(5)9(1).

    01  sqlite3-error-message          pic x(256).

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

  linkage section.

    01  error-message                  pic x(256).

procedure division returning error-message.

  dberrmsg-mainline.

    move CobolSQLite3-Database-Status to db-status

    evaluate true

      when call-successful

        move "DBINF 0: Successful completion." to error-message

      when database-already-open

        move "DBERR -1: Specified database already open." to error-message

      when database-open-failed

        move "DBERR -2: Unable to open specified database." to error-message

      when database-not-open

        move "DBERR -3: Specified database not open." to error-message

      when unreleased-sql-objects-exist

        move "DBERR -4: Unable to close database. Unreleased SQL Objects exist." to error-message

      when sql-compile-failed

        move "DBERR -5: Compile of SQL Statement failed." to error-message

      when database-lock-failed

        move "DBERR -6: Database locks could not be applied." to error-message

      when sql-object-not-released

        move "DBERR -7: Unable to release (delete) SQL Object." to error-message

      when sql-object-not-reset

        move "DBERR -8: Unable to reset SQL Object." to error-message

*>    when *not used*
*>
*>      move "DBERR -9: xxx." to error-message

*>    when *not used*
*>
*>      move "DBERR -10: xxx." to error-message

      when datatype-unknown-unsupported

        move "DBERR -11: Datatype unknown or unsupported." to error-message

      when datatype-undefined

        move "DBERR -12: Datatype of selected column undefined." to error-message
        *> This error is returned if a type conversion occurred.

      when invalid-dbinfo-mode

        move "DBERR -13: Specified DBINFO Mode not recognised." to error-message

      when not-an-sqlite-database

        move "DBERR -14: Specified file NOT an SQLite3 Database." to error-message

      when no-data-returned

        move "DBERR -15: No data has been returned." to error-message

      when row-buffer-overflow

        move "DBERR -16: Buffer passed to DBGETALL not large enough." to error-message

*>      when ?
*>
*>        move "DBERR -?: ?" to error-message

      when other *> sqlite3 library error

        call static "sqlite3_errstr" using by value db-status
                                 returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        move db-status to display-sqlite3-status

        move spaces to error-message
        string
          "SQLite3ERR " delimited by size
          trim(display-sqlite3-status) delimited by size
          "]: " delimited by size
          sqlite3-data delimited by low-value
          into error-message
        end-string

        set address of sqlite3-data to NULL

    end-evaluate

    goback
    .

end function DBERRMSG.

*> *****************************************************************************

*><* ---------------------------
*><* 4. Compilation Instructions
*><* ---------------------------
*><*
*><* 4.1. Linux/UNIX
*><* ~~~~~~~~~~~~~~~
*><*
*><*   Compile the *CobolSQLite3* source (CobolSQLite3.cob) by entering the following
*><+  command within any terminal program.
*><*
*><*     cobc -o CobolSQLite3.so -debug CobolSQLite3.cob -lsqlite3
*><*
*><* 4.2. Apple Mac OS X
*><* ~~~~~~~~~~~~~~~~~~~
*><*
*><*   Compile the source file as for Linux/Unix.
*><*
*><* 4.3. Windows
*><* ~~~~~~~~~~~~
*><*
*><*   I do not have access to Windows, Windows/Cygwin or Windows/MinGW but I
*><+  understand that the following commands should work [YMMV].
*><*
*><*   Windows/MinGW and Windows/Cygwin (inside the terminal program):
*><*
*><*   ::
*><*
*><*     Compile the source file as for Linux/Unix.
*><*
*><*   Windows/MinGW and Windows/Cygwin (outside the terminal program):
*><*
*><*   ::
*><*
*><*     cobc -debug -lsqlite3 [drive:][path/to/]CobolSQLite3.cob
*><*
*><*   Native Windows:
*><*
*><*   ::
*><*
*><*     cobc -debug -lsqlite3 [drive:][path\\to\\]CobolSQLite3.cob
*><*
*><* ---------------
*><* 5. Installation
*><* ---------------
*><*
*><* 5.1. Requirements
*><* ~~~~~~~~~~~~~~~~~
*><*
*><*   **GnuCOBOL:** Version 2.2 (or greater) installed and tested fully working.
*><*
*><*     See the documentation supplied with *GnuCOBOL*. You **must** have run both
*><+     the sanity checks created by the test procedures included within the
*><+     Cobol85 suite as well as the *make check* procedure.
*><*
*><*   **SQLite 3:** Version 3.11.0 (or greater).
*><*
*><*     As a minimum you need to install the Shared Library (*Libsqlite3-0*) and
*><+     Development Files (*Libsqlite3-dev*). Available from most Linux Distros.
*><*
*><*     Although you do not need it you will find it an advantage to also install
*><+     the following:
*><*
*><*     - Command-Line Shell (*sqlite3*) is a utility that allows the manual
*><+        entry and execution of SQL statements against an SQLite database.
*><+        Documentation is at <https://www.sqlite.org/cli.html>.
*><*
*><*     - SQLite Database Analyzer (*sqlite3_analyzer*) reads an SQLite database
*><+        and outputs a file showing the space used by each table and index and
*><+        other statistics.
*><+        Documentation is at <https://www.sqlite.org/sqlanalyze.html>.
*><*
*><*     - SQLite Database Diff (*sqldiff*) compares two SQLite database files and
*><+        outputs the SQL needed to convert one into the other.
*><+        Documentation is at <https://www.sqlite.org/sqldiff.html>.
*><*
*><*     The **SQLite** Download page (sqlite.org/download.html) contains Source
*><+     Code files and precompiled binaries for multiple platforms. As of writing,
*><+     September 2017, version 3.20.1 is available from here.
*><*
*><*     See <https://www.sqlite.org/about.html> for information on SQLite.
*><*
*><* 5.2. Before first use
*><* ~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   Before you use the *CobolSQLite3* Library for the first time (also after a
*><+   **new** release) you **must** generate the Copybook modules required by programs
*><+    using the Library.
*><*
*><*   Enter the following **cobcrun** command and respond **Y** (or **y**) to the
*><+    two questions you will be asked:
*><*
*><*   ::
*><*
*><*     cobcrun ./CobolSQLite3
*><*
*><*     CobolSQLite3/A.00.00
*><*     SQLite3 Interface Functions for GnuCOBOL 2.2+
*><*     Copyright (c) Robert W.Mills <cobolmac@btinternet.com>, 2017
*><*     SQLite3 Library Version 3.11.0
*><*
*><*     This is free software; see the source for copying conditions. There is NO
*><*     WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*><*
*><*     Generate Repository CopyLibrary [N/y]? y
*><*     -- CopyLibrary written to CobolSQLite3-CSR.cpy
*><*
*><*       Example usage:
*><*
*><*         repository.
*><*           copy "CobolSQLite3-CSR.cpy".
*><*           function all intrinsic.
*><*
*><*     Generate Working-storage CopyLibrary [N/y]? y
*><*     -- CopyLibrary written to CobolSQLite3-WS.cpy
*><*
*><*       Example usage:
*><*
*><*         working-storage section.
*><*           copy "CobolSQLite3-WS.cpy".
*><*           *> additional definitions
*><*
*><* 5.3. Copybook Listings
*><* ~~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   Below are examples of the two Copybook's that are generated by *CobolSQLite3*.
*><*
*><*   *CobolSQLite3-CSR.cpy* contains the Library function definitions. It needs to
*><+    be COPYed into the Repository paragraph within the Configuration Section.
*><*
*><*   .. include:: CobolSQLite3-CSR.cpy
*><*      :code: cobolfree
*><*
*><*   *CobolSQLite3-WS.cpy* contains the Library data definitions. It needs to
*><+    be COPYed into the Working-Storage Section. It is recommended that copy
*><+    statement is placed at the start of the section.
*><*
*><*   .. include:: CobolSQLite3-WS.cpy
*><*      :code: cobolfree
*><*
*><* ------------------------
*><* 6. Accessing the Library
*><* ------------------------
*><*
*><*   Prior to executing a program that uses the *CobolSQLite3* Library you need
*><+   to set the **COB_PRE_LOAD** environment variable. This tells the *GnuCOBOL*
*><+   runtime link resolver what dynamic link modules are included in a run.
*><*
*><*   ::
*><*
*><*     export COB_PRE_LOAD=CobolSQLite3
*><*
*><*   If the Library is not in the current working directory along with the
*><+   executable, the **COB_LIBRARY_PATH** environment variable can be set
*><+   to find them.
*><*
*><*   ::
*><*
*><*     export COB_LIBRARY_PATH=/path/to/library
*><*
*><* ------------------------
*><* 7. Example/Test Programs
*><* ------------------------
*><*
*><*   **Test-1.cob** Open a new SQLite3 Database; create a Table with an *Integer*,
*><+    *Real (IEEE Floating Point)* and *Text* column; load 4 entries into the Table;
*><+    display all entries from the Table; and close the Database.
*><*
*><*   .. include:: Test-1.cob
*><*      :code: cobolfree
*><*
*><*   **Test-2.cob** is a copy of **Test-1.cob** that passes alphanumeric variables
*><*    to the functions instead of quoted strings.
*><*
*><*   .. include:: Test-2.cob
*><*      :code: cobolfree
*><*
*><* -----------------------
*><* 8. Modification History
*><* -----------------------
*><*
*><*   .. include:: ChangeLog
*><*
*><* -----------------------
*><* 9. Planned Enhancements
*><* -----------------------
*><*
*><*   .. include:: ToDo
*><*
*><*
*><* .. footer:: End of CobolSQLite3 User Guide
*><*
*> End of source code.
*> *****************************************************************************
