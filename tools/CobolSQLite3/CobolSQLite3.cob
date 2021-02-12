*> **  >>SOURCE FORMAT IS FREE

identification division.

replace

    *> Set the Library Version (see the 'Developer Notes' below).
    =="Version.Update.Fix"== by =="A.01.00"==

    *> Set the name for the EXTERNAL Database Status variable.
    ==:EXTERNAL-DBSTATUS:== by
    ==
    CobolSQLite3-Database-Status
    ==

    *> Define the EXTERNAL Database Status variable.
    *> Note: The variable name here and above MUST match.
    ==:EXTERNAL-DBSTATUS-DEF:== by
    ==
    01  CobolSQLite3-Database-Status   pic s9(04) comp external.
    ==
    .
>>page "User Guide Header"

*><* ========================================
*>   User Guide Title & Version (see the 'Developer Notes' below).
*><* CobolSQLite3 User Guide for Version A.01
*><* ========================================
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
*><* :Rights:   Copyright © 2017-2021, Robert W.Mills.
*><* :Email:    rwm.cobol@gmail.com
*><* :Purpose:  An SQLite3 Interface Library for GnuCOBOL
*><*

>>page "License"

*><* ----------
*><* 1. License
*><* ----------
*><*
*><* 1.1. CobolSQLite3 Library
*><* ~~~~~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   This program is free software: you can redistribute it and/or modify it
*><+   under the terms of the GNU General Public License as published by the Free
*><+   Software Foundation, either version 3 of the License, or (at your option)
*><+   any later version.
*><*
*><*   This program is distributed in the hope that it will be useful, but WITHOUT
*><+   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*><+   FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
*><+   more details.
*><*
*><*   You should have received a copy of the GNU General Public License, in the
*><+   file COPYING, along with this program. If not, see
*><+   <http://www.gnu.org/licenses/gpl.txt>.
*><*
*><* 1.2. CobolSQLite3 User Guide
*><* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   Permission is granted to copy, distribute and/or modify this document
*><+   under the terms of the GNU Free Documentation License, Version 1.3
*><+   or any later version published by the Free Software Foundation;
*><+   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*><*
*><*   A copy of this license, in the file COPYING, should be included with this
*><+   software. If not, see <http://www.gnu.org/licenses/fdl.txt>.
*><*
*><* 1.3. SQLite3
*><* ~~~~~~~~~~~~
*><*
*><*   *SQLite is in the Public Domain*
*><*
*><*   All of the code and documentation in SQLite has been dedicated to the public
*><+   domain by the authors. All code authors, and representatives of the companies
*><+   they work for, have signed affidavits dedicating their contributions to the
*><+   public domain and originals of those signed affidavits are stored in a firesafe
*><+   at the main offices of Hwaci <https://www.hwaci.com/>. Anyone is free to copy,
*><+   modify, publish, use, compile, sell, or distribute the original SQLite code,
*><+   either in source code form or as a compiled binary, for any purpose, commercial
*><+   or non-commercial, and by any means.
*><*
*><*   All of the deliverable code in SQLite has been written from scratch. No code
*><+   has been taken from other projects or from the open internet. Every line of
*><+   code can be traced back to its original author, and all of those authors have
*><+   public domain dedications on file. So the SQLite code base is clean and is
*><+   uncontaminated with licensed code from other projects.
*><*

>>page "Description"

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
*><*   - Bind values to parameters in a compiled SQL Statement.
*><*   - Execute a compiled SQL Statement.
*><*   - Release (delete) a compiled SQL Statement.
*><*   - Reset (re-initialise) a compiled SQL Statement.
*><*   - Compile, execute and release an SQL Statement.
*><*   - Retrieve all columns from a SELECTed row.
*><*   - Request information about the Database (currently a limited function).
*><*   - Translate a Status Code into human-readable text.
*><*
*><* 2.1. Quote from SQLite author
*><* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   D Richard Hipp, architect and primary author of *SQLite* as well as the
*><+   Fossil SCM, said:
*><*
*><*   "*SQLite* is a C library that implements an embeddable SQL database engine.
*><+   Programs that link with the *SQLite library* can have SQL database access
*><+   without running a separate RDBMS process. The distribution comes with a
*><+   standalone command-line access program (*SQLite*) that can be used to
*><+   administer a *SQLite database* and which serves as an example of how to use
*><+   the *SQLite library*.
*><*
*><*   *SQLite* is not a client library used to connect to a big database server.
*><+   *SQLite* is the server. The *SQLite library* reads and writes directly to and
*><+   from the database files on disk."
*><*

>>page "Reusing Compiled Statements"

*><* ------------------------------
*><* 3. Reusing Compiled Statements
*><* ------------------------------
*><*
*><*   It is not useful to evaluate the exact same SQL Statement more than once.
*><+   More often, you want to execute similar statements. For example, you might
*><+   want to execute an INSERT statement multiple times with different values. Or
*><+   you might want to execute the same query multiple times using a different key
*><+   in the WHERE clause.
*><*
*><*   To accommodate this, *CobolSQLite3* allows SQL Statements to contain parameters
*><+   which are **bound** to values prior to being executed. These values can later
*><+   be changed and the same compiled SQL Statement can be executed a second time
*><+   using the new values.
*><*
*><*   A question-mark (?) is used as a place-holder for the parameter within the SQL
*><+   Statement. *CobolSQLite3* allows a parameter wherever a string literal,
*><+   numeric constant, or NULL is allowed. It may not be used for column or table
*><+   names. A call to DBINFO Mode 200 will return the expanded SQL Statement.
*><*
*><*   A parameter initially has a value of NULL. Prior to calling DBEXECUTE the first
*><+   time or immediately after a DBRESET, the program can call DBBIND to attach
*><+   values to the parameters. Each use of DBBIND overrides prior bindings on the
*><+   same parameter. Note that existing bindings are not cleared by DBRESET.
*><*
*><*   There is no arbitrary limit to the number of SQL Statements that can be
*><+   compiled. A program can call DBCOMPILE multiple times at start-up, to create
*><+   all of the compiled SQL Statements it will ever need, and then execute them
*><+   as needed.
*><*

>>page "Developer Notes"

*> Developer Notes (not included in the User Guide).
*> -------------------------------------------------
*>
*> Prior to release of a new version:
*>
*>   - Add an entry to the Modification History (ChangeLog file).
*>
*>   - Update these Developer Notes, if required.
*>
*>   - Update the Library Version.Update.Fix level.
*>     (edit the REPLACE statement at the beginning of the source file)
*>
*>       *Version* = A letter indicating the VERSION.
*>                   Increment when a MAJOR (?non-compatible?) change has been made.
*>       *Update*  = A 2-digit number indicating an UPDATE to the current VERSION.
*>                   Set to 00 when the VERSION changes.
*>       *Fix*     = A 2-digit number indicating a FIX to the current UPDATE.
*>                   Set to 00 when the UPDATE changes.
*>
*>   - Update the documentation, if required.
*>
*>   - Ammend the User Guide Version (line 27) if the Library Version.Update level changed.
*>
*> Database Status Code:
*>
*>   An external variable is used within this library to hold the Database Status
*>   Code as returned by each function. This variable needs to be initialise to ZERO
*>   at the start of the function. If an error occurs then set it to the required
*>   value prior to exiting the function.
*>
*>   Each function within the Library must have the string :EXTERNAL-DBSTATUS-DEF:
*>   placed at the start of the Working-Storage Section. This string is replaced at
*>   compile time with the definition of the External Database Status.
*>
*>   Wherever the functions need to set/read the External Database Status then use
*>   :EXTERNAL-DBSTATUS: inplace of the variables name.

>>page "Program: CobolSQLite3"

  program-id.                          CobolSQLite3.

environment division.

  configuration section.

    source-computer.                   Linux Mint.
    object-computer.                   Linux Mint.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    01  runtime-options                pic x(016).
      88  help-message                   values "-h", "--help".
      88  library-version                values "-v", "--version".
      88  repository-module              values "-r", "--repository".
      88  copylibrary                    values "-c", "--copylib".

    01  sqlite3-library-version        pic x(010).
    01  redefines sqlite3-library-version.
      05  slv-major                    pic 9(001).
      05                               pic x(001).
      05  slv-minor                    pic 9(002).
      05                               pic x(006).

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(128) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

procedure division.

  CobolSQLite3-mainline.

    move low-values to runtime-options
    accept runtime-options from argument-value end-accept

    if runtime-options > low-values then *> Found argument.

      move lower-case(runtime-options) to runtime-options

      evaluate true

        when help-message *> -h or --help
          perform display-help-message

        when library-version *> -v or --version
          perform display-library-version

        when repository-module *> -r or --repository
          perform generate-repository-module

        when copylibrary *> -c or --copylib
          perform generate-copylibrary-module

        when other
          display "Unknown option or multiple options entered." end-display

      end-evaluate

    else
      perform display-help-message
    end-if

    goback
    .

  display-help-message.

    display space end-display
    display "cobcrun [path/]CobolSQLite3 [option] [>filename]" end-display
    display space end-display
    display "option:" end-display
    display "  -h, --help          Display this help text." end-display
    display "  -v, --version       Display the Library and SQLite3 Versions." end-display
    display "  -r, --repository    Generate the Repository Copylibrary module." end-display
    display "  -c, --copylib       Generate the Working-Storage Copylibrary module." end-display
    display space end-display
    display "Output from the --repository and --copylib options is written to" end-display
    display "Standard Out. Use >filename to redirect it to a disc file instead." end-display
    display space end-display
    .

  display-library-version.

    *> const char *sqlite3_libversion(void);

    call static "sqlite3_libversion" *> using nothing
                                 returning sqlite3-temporary-pointer
    end-call

    set address of sqlite3-data to sqlite3-temporary-pointer

    string
      sqlite3-data delimited by low-value
      into sqlite3-library-version
    end-string

    set address of sqlite3-data to NULL

    display space end-display
    display "CobolSQLite3/", "Version.Update.Fix" end-display
    display "SQLite3 Interface Functions for GnuCOBOL" end-display
    display "Copyright (c) Robert W.Mills <rwm.cobol@gmail.com>, 2017-2021" end-display
    display "SQLite3 Library Version ", trim(sqlite3-library-version) end-display
    if slv-minor < 14 then
       display space end-display
       display " ** Please update SQLite3 Library to at least Version 3.14 **" end-display
    end-if
    display space end-display
    display "This is free software; see the source for copying conditions. There is NO" end-display
    display "WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE." end-display
    display space end-display
    .

  generate-repository-module.

    display " *> CobolSQLite3 Function Definitions.                        " end-display
    display " *>                                                           " end-display
    display " *> DO NOT EDIT THIS MODULE. See User Guide Section 6.2.      " end-display
    display "                                                              " end-display
    display "      Function DBSTATUS                                       " end-display
    display "      Function DBOPEN                                         " end-display
    display "      Function DBCLOSE                                        " end-display
    display "      Function DBCOMPILE                                      " end-display
    display "      Function DBBIND                                         " end-display
    display "      Function DBEXECUTE                                      " end-display
    display "      Function DBRELEASE                                      " end-display
    display "      Function DBRESET                                        " end-display
    display "      Function DBSQL                                          " end-display
    display "      Function DBGET                                          " end-display
    display "      Function DBINFO                                         " end-display
    display "      Function DBERRMSG                                       " end-display
    .

  generate-copylibrary-module.

    display " *> CobolSQLite3 Working Storage Definitions.                 " end-display
    display " *>                                                           " end-display
    display " *> DO NOT EDIT THIS MODULE. See User Guide Section 6.2.      " end-display
    display "                                                              " end-display
    display "    01  db-object                      pic x(008).            " end-display
    display "      88  database-is-closed             value NULL.          " end-display
    display "                                                              " end-display
    display "    01  db-status                      pic s9(04) comp.       " end-display
    display "      88  call-successful                value ZERO.          " end-display
    display "      *> -- CobolSQLite3 Function codes ----------------------" end-display
    display "      88  database-already-open          value -1.            " end-display
    display "      88  database-open-failed           value -2.            " end-display
    display "      88  database-not-open              value -3.            " end-display
    display "      88  unreleased-sql-objects-exist   value -4.            " end-display
    display "      88  sql-compile-failed             value -5.            " end-display
    display "      88  database-lock-failed           value -6.            " end-display
    display "      88  sql-object-not-released        value -7.            " end-display
    display "      88  sql-object-not-reset           value -8.            " end-display
    display "      88  invalid-bind-index             value -9.            " end-display
    display "      88  bind-value-to-big              value -10.           " end-display
    display "      88  datatype-unknown-unsupported   value -11.           " end-display
    display "      88  datatype-undefined             value -12.           " end-display
    display "      88  invalid-dbinfo-mode            value -13.           " end-display
    display "      88  not-an-sqlite-database         value -14.           " end-display
    display "      88  no-data-returned               value -15.           " end-display
    display "      88  row-buffer-overflow            value -16.           " end-display
    display "      88  dbinfo-buffer-overflow         value -17.           " end-display
    display "      *> -- SQLite3 Library codes ----------------------------" end-display
    display "      88  database-row-available         value 100.           " end-display
    display "      88  sql-statement-finished         value 101.           " end-display
    display "                                                              " end-display
    display "    01  sql-object                     pic x(008).            " end-display
    display "      88  object-released                value NULL.          " end-display
    display "                                                              " end-display
    display "    01  row-delims.                                           " end-display
    display "      05  field-delimiter              pic x(001) value x'1D'." end-display
    display "      05  row-delimiter                pic x(001) value x'1E'." end-display
    display "                                                              " end-display
    display "    01  dbinfo-mode                    pic 9(004) value zeros." end-display
    display "      88  dbinfo-changed-rows            value 100.           " end-display
    display "      88  dbinfo-expand-sql              value 200.           " end-display
    display "                                                              " end-display
    display "    01  dbinfo-buffer                  pic x(2048).           " end-display
    display "        *> 2K should be big enough.                           " end-display
    display "                                                              " end-display
    display "    01  redefines dbinfo-buffer.                              " end-display
    display "      05  dbinfo-rows-changed          pic s9(09) comp.       " end-display
    display "                                                              " end-display
    display "    01  error-message                  pic x(128).            " end-display
    .

end program CobolSQLite3.

>>page "Library Functions"

*><* --------------------
*><* 4. Library Functions
*><* --------------------
*><*
*><* 4.0. Restrictions
*><* ~~~~~~~~~~~~~~~~~
*><*
*><*   *DBCOMPILE* and *DBSQL* will only use the 1st statement passed in the
*><+    *sql-statement* parameter, any additional statements will be dropped.
*><*
*><*   This helps prevent **SQL Injection Attacks** against the Database.
*><*

>>page "Function: DBSTATUS"

identification division.

  function-id.                         DBSTATUS.

*><* 4.1. DBSTATUS
*><* ~~~~~~~~~~~~~
*><*
*><*   Returns the *Status Code* of the last executed CobolSQLite3 function.
*><*
*><* Syntax
*><* ######
*><*
*><*   move DBSTATUS to *status-code*
*><*
*><*   if DBSTATUS <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *status-code* is a size 4 signed binary integer.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

  linkage section.

    01  db-status                      pic s9(04) comp.

procedure division returning db-status.

  dbstatus-mainline.

    move :EXTERNAL-DBSTATUS: to db-status

    goback
    .

end function DBSTATUS.

>>page "Function: DBOPEN"

identification division.

  function-id.                         DBOPEN.

*><* 4.2. DBOPEN
*><* ~~~~~~~~~~~
*><*
*><*   Opens the specified database and creates a Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   move DBOPEN(*db-name*) to *db-object*
*><*
*><* Parameters
*><* ##########
*><*
*><*   *db-name* is either an alphanumeric variable or quoted string.
*><+   It holds the name of the Database to be opened.
*><+   The path to the Database must be specified if it's not in the working directory.
*><*
*><*   *db-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the Database Object.
*><*
*><* Notes
*><* #####
*><*
*><*   If the database does not exist then it will be automatically created.
*><*
*><*   If *db-name* specifies a file that is not an SQLite3 Database then *DBOPEN*
*><+   will return an error (use DBSTATUS to return the Status Code).
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

    01  pic x(001). *> is the file an sqlite3 database?
      88  is-an-sqlite3-database         value "I".
      88  not-an-sqlite3-database        value "N".

    *> CBL_*_FILE parameters

    01  file-handle                    pic x(004) usage comp-x.
    01  offset                         pic x(008) usage comp-x.
    01  nbytes                         pic x(004) usage comp-x.
    01  read-buffer                    pic x(015).

  linkage section.

    01  db-name                        pic x any length.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

procedure division using db-name
               returning db-object.

  dbopen-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status

    if not database-is-closed then
      move -1 to :EXTERNAL-DBSTATUS:
      goback
    end-if

    perform check-if-sqlite-database

    if not-an-sqlite3-database then
      move -14 to :EXTERNAL-DBSTATUS:
      goback
    end-if

    *> int sqlite3_open(const char *filename, sqlite3 **ppDb);

    call static "sqlite3_open" using concatenate(trim(db-name), x"00"),
                                     by reference db-object-ptr
                           returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> database open failed (-2)
      move sqlite3-status to :EXTERNAL-DBSTATUS:
      goback
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
        move 15 to nbytes

        call "CBL_READ_FILE" using file-handle,
                                   offset,
                                   nbytes, *> number of bytes to be read
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

>>page "Function: DBCLOSE"

identification division.

  function-id.                         DBCLOSE.

*><* 4.3. DBCLOSE
*><* ~~~~~~~~~~~~
*><*
*><*   Closes the specified database and destroys its Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBCLOSE(*db-object*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *db-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the Database Object.
*><*
*><* Notes
*><* #####
*><*
*><*   If *DBCLOSE* returns a non-zero value then use *DBSTATUS* to obtain the Status Code.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  db-status                      pic s9(04) comp.
      88  db-call-ok                      value zero.
      88  db-call-error                   value 1.

procedure division using db-object
               returning db-status.

  dbclose-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status
    set db-call-ok to TRUE

    if database-is-closed then
      move -3 to :EXTERNAL-DBSTATUS:
      set db-call-error to TRUE
      goback
    end-if

    *> int sqlite3_close(sqlite3*);

    call static "sqlite3_close" using by value db-object-ptr
                            returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> database closed
        set database-is-closed to TRUE

      when 5 *> not all sql objects have been released
        move -4 to :EXTERNAL-DBSTATUS:
        set db-call-error to TRUE

      when other *> sqlite3 specific error
        move sqlite3-status to :EXTERNAL-DBSTATUS:
        set db-call-error to TRUE

    end-evaluate

    goback
    .

end function DBCLOSE.

>>page "Function: DBCOMPILE"

identification division.

  function-id.                         DBCOMPILE.

*><* 4.4. DBCOMPILE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Compiles an SQL Statement, into byte-code, and creates an SQL Object for it.
*><*
*><* Syntax
*><* ######
*><*
*><*   move DBCOMPILE(*db-object*, *sql-statement*) to *sql-object*
*><*
*><* Parameters
*><* ##########
*><*
*><*   *db-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the Database Object.
*><*
*><*   *sql-statement* is either an alphanumeric variable or quoted string.
*><+   It holds the SQL Statement to be compiled.
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*
*><* Notes
*><* #####
*><*
*><*   Use *DBSTATUS* to obtain the Status Code and check for a non-zero return.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

    01  sql-statement-wrk              pic x(4096). *> 4K should be big enough

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  sql-statement                  pic x any length.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

procedure division using db-object, sql-statement
               returning sql-object.

  dbcompile-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status

    if database-is-closed then
      move -3 to :EXTERNAL-DBSTATUS:
      goback
    end-if

    move trim(sql-statement) to sql-statement-wrk
    move length(trim(sql-statement-wrk, trailing)) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    *> int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail);

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(trim(sql-statement-wrk), x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object-ptr,
                                           NULL
                                 returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> compile failed
      *> move -5 to :EXTERNAL-DBSTATUS:
      move sqlite3-status to :EXTERNAL-DBSTATUS:
    end-if

    goback
    .

end function DBCOMPILE.

>>page "Function: DBBIND"

identification division.

  function-id.                         DBBIND.

*><* 4.5. DBBIND
*><* ~~~~~~~~~~~~
*><*
*><*   Binds a value to a compiled SQL statement parameter.
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBBIND(*sql-object*, *param-idx*, *param-value*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*
*><*   *param-idx* is either an alphanumeric variable or an unquoted string.
*><+   It indicates which parameter, in the compiled SQL statement, is to be *bound*.
*><*
*><*   *param-value* is either an alphanumeric variable, or a quoted string.
*><+   It holds the value to be *bound* to the parameter pointed to by *param-idx*.
*><*
*><* Notes
*><* #####
*><*
*><*   The leftmost SQL Statement parameter has an index of 1.
*><*
*><*   See Section *3. Reusing Compiled Statements* for more details.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

    01  param-idx-wrk                  pic 9(002). *> s9(04) comp.

    01  param-value-wrk                pic x(4096). *> 4K should be big enough

    01  sql-num-bytes                  pic 9(004). *> s9(04) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  param-idx                      pic x any length.

    01  param-value                    pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object, param-idx, param-value
               returning db-status.

  dbbind-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    compute param-idx-wrk = numval(trim(param-idx)) end-compute
    move trim(param-value) to param-value-wrk
    move length(trim(param-value-wrk, trailing)) to sql-num-bytes

    *> int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int, void(*)(void*));

    call static "sqlite3_bind_text" using by value sql-object-ptr,
                                          by value param-idx-wrk,
                                          by reference concatenate(trim(param-value-wrk), x"00"),
                                          by value sql-num-bytes,
                                          by value 0 *> SQLITE_STATIC
                                returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when 18 *> parameter value to big
        move -10 to :EXTERNAL-DBSTATUS:, db-status

      when 25 *> parameter index is out of range
        move -9 to :EXTERNAL-DBSTATUS:, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status

    end-evaluate

    goback
    .

end function DBBIND.

>>page "Function: DBEXECUTE"

identification division.

  function-id.                         DBEXECUTE.

*><* 4.6. DBEXECUTE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Executes an SQL Object (a compiled SQL Statement).
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBEXECUTE(*sql-object*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbexecute-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    *> int sqlite3_step(sqlite3_stmt*);

    call static "sqlite3_step" using by value sql-object-ptr
                           returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when 5 *> unable to obtain database locks
        move -6 to :EXTERNAL-DBSTATUS:, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status

    end-evaluate

    goback
    .

end function DBEXECUTE.

>>page "Function: DBRELEASE"

identification division.

  function-id.                         DBRELEASE.

*><* 4.7. DBRELEASE
*><* ~~~~~~~~~~~~~~
*><*
*><*   Releases (deletes) an SQL Object (a compiled SQL Statement).
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBRELEASE(*sql-object*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*
*><* Notes
*><* #####
*><*
*><*   This function MUST be executed against all SQL Objects before the database
*><+   is closed as failure to do so result's in *memory leaks*.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbrelease-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    *> int sqlite3_finalize(sqlite3_stmt *pStmt);

    call static "sqlite3_finalize" using by value sql-object-ptr
                               returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> object released
        set object-released to TRUE

      when other *> sqlite3 object not released
        *> move -7 to :EXTERNAL-DBSTATUS:, db-status
        move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status

    end-evaluate

    goback
    .

end function DBRELEASE.

>>page "Function: DBRESET"

identification division.

  function-id.                         DBRESET.

*><* 4.8. DBRESET
*><* ~~~~~~~~~~~~
*><*
*><*   Resets the SQL Object back to initial state so it can be re-executed.
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBRESET(*sql-object*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*
*><* Notes
*><* #####
*><*
*><*   If the SQL Object contains any *bound* parameter values, they will **not**
*><+   be cleared.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object
               returning db-status.

  dbreset-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    *> int sqlite3_reset(sqlite3_stmt *pStmt);

    call static "sqlite3_reset" using by value sql-object-ptr
                            returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> object not reset
      *> move -8 to :EXTERNAL-DBSTATUS:, db-status
      move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status
    end-if

    goback
    .

end function DBRESET.

>>page "Function: DBSQL"

identification division.

  function-id.                         DBSQL.

*><* 4.9. DBSQL
*><* ~~~~~~~~~~
*><*
*><*   Executes an SQL Statement against the Database Object.
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBSQL(*db-object*, *sql-statement*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *db-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the Database Object.
*><*
*><*   *sql-statement* is either an alphanumeric variable or quoted string.
*><+   It holds the SQL Statement to be executed.
*><*
*><* Notes
*><* #####
*><*
*><*   This function combines the *DBCOMPILE*, *DBEXECUTE* and *DBRELEASE*
*><+   functionality.
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  sql-statement-wrk              pic x(4096). *> 4K should be big enough

    01  sql-num-bytes                  pic s9(04) comp.

  linkage section.

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

    01  sql-statement                  pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using db-object, sql-statement
               returning db-status.

  dbsql-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    if database-is-closed then
      move -3 to :EXTERNAL-DBSTATUS:, db-status
      goback
    end-if

    move trim(sql-statement) to sql-statement-wrk
    move length(trim(sql-statement-wrk, trailing)) to sql-num-bytes

    add 1 to sql-num-bytes end-add

    *> int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail);

    call static "sqlite3_prepare_v2" using by value db-object-ptr,
                                           by content concatenate(sql-statement-wrk, x"00"),
                                           by value sql-num-bytes,
                                           by reference sql-object-ptr,
                                           NULL
                                 returning sqlite3-status
    end-call

    if sqlite3-status <> ZERO then *> compile failed
      *> move -5 to :EXTERNAL-DBSTATUS:, db-status
      move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status
      goback
    end-if

    *> int sqlite3_step(sqlite3_stmt*);

    call static "sqlite3_step" using by value sql-object-ptr
                           returning sqlite3-status
    end-call

    evaluate true

      when sqlite3-status = 5 *> unable to obtain database locks
        move -6 to :EXTERNAL-DBSTATUS:, db-status
        goback

      when sqlite3-status = 100 *> statement returned data, will be ignored
        move ZERO to :EXTERNAL-DBSTATUS:, db-status

      when sqlite3-status = 101 *> statement has run to completion
        move ZERO to :EXTERNAL-DBSTATUS:, db-status

      when other *> sqlite3 specific error
        move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status
        goback

    end-evaluate

    *> int sqlite3_finalize(sqlite3_stmt *pStmt);

    call static "sqlite3_finalize" using by value sql-object-ptr
                               returning sqlite3-status
    end-call

    evaluate sqlite3-status

      when ZERO *> object released
        set object-released to TRUE

      when other *> sqlite3 object not released
        *> move -7 to :EXTERNAL-DBSTATUS:, db-status
        move sqlite3-status to :EXTERNAL-DBSTATUS:, db-status

    end-evaluate

    goback
    .

end function DBSQL.

>>page "Function: DBGET"

identification division.

  function-id.                         DBGET.

*><* 4.10. DBGET
*><* ~~~~~~~~~~~
*><*
*><*   Returns the current result row of an SQL Query (Select).
*><*
*><* Syntax
*><* ######
*><*
*><*   if DBGET(*sql-object*, *row-delims*, *row-buffer*) <> ZERO then ... end-if
*><*
*><* Parameters
*><* ##########
*><*
*><*   *sql-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the SQL Object created for a
*><+   compiled SQL Statement.
*><*
*><*   *row-delims* is a size 2 alphanumeric variable.
*><+   It containing the delimiters to use when loading the *row-buffer*.
*><*
*><*   - The 1st character is placed between each column (see Notes below).
*><*   - The 2nd character is placed after the last column to indicate the end of
*><+     data in *row-buffer* (see Notes below)
*><*
*><*   *row-buffer* is an alphanumeric variable that contains the complete row in
*><+   delimited format. All numeric column data is converted to display format.
*><*
*><* Notes
*><* #####
*><*
*><*   The *row-delims* entry in the Working-Storage Copybook sets default values of
*><+   HEX 1D (Group Separator) and HEX 1E (Record Separator) for the 1st and 2nd
*><+   delimiter. These values are the developers choice and you can keep them as-is,
*><+   modify the *row-delims* entry in the Copybook, or override the values within
*><+   your program by using one-or-more MOVE commands.
*><*
*><*   A modified version of the following **unstring** statement should be used to
*><+   extract the data for each column from **row-buffer**. You, as the developer
*><+   using this Library, are in complete control of the picture format/size of the
*><+   Working-storage field that will be the recipient of the column data. It is
*><+   suggested that you use the SQLite Command-Line Shell (see Section 5.1) to look
*><+   at the current data formats/sizes used and code accordingly.
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

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-status                 pic s9(04) comp.

    01  sqlite3-datatype               pic s9(04) comp.

    01  sqlite3-column-count           pic s9(04) comp.

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

    01  column-number                  usage binary-short unsigned.

    01  row-buffer-idx                 pic 9(018).

  linkage section.

    01  sql-object.
      05  sql-object-ptr               usage pointer.
        88  object-released              value NULL.

    01  delims.
      05  field-delimiter              pic x(001).
      05  row-delimiter                pic x(001).

    01  row-buffer                     pic x any length.

    01  db-status                      pic s9(04) comp.

procedure division using sql-object, delims, row-buffer
               returning db-status.

  dbget-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:, sqlite3-status, db-status

    perform get-column-count

    if sqlite3-column-count = ZERO then *> no data returned
      move -15 to :EXTERNAL-DBSTATUS:, db-status
      goback
    end-if

    move SPACES to row-buffer
    move 1 to row-buffer-idx

    perform get-column-data
      varying column-number from ZERO by 1
      until column-number = sqlite3-column-count

    perform replace-last-field-delimiter

    goback
    .

  get-column-count.

    *> int sqlite3_column_count(sqlite3_stmt *pStmt);

    call static "sqlite3_column_count" using by value sql-object-ptr
                                   returning sqlite3-column-count
    end-call
    .

  get-column-data.

    *> int sqlite3_column_type(sqlite3_stmt*, int);

    call static "sqlite3_column_type" using by value sql-object-ptr,
                                            by value column-number
                                  returning sqlite3-datatype
    end-call

    evaluate sqlite3-datatype

      when ZERO *> undefined as a type conversion occurred
        move -12 to :EXTERNAL-DBSTATUS:

      when 1 *> 64-bit signed integer (automatic convertion to text)
      when 2 *> 64-bit ieee floating point number (automatic convertion to text)
      when 3 *> string

        *> const unsigned char *sqlite3_column_text(sqlite3_stmt*, int);

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
            move -16 to :EXTERNAL-DBSTATUS:
            goback
        end-string

        set address of sqlite3-data to NULL

      when 4 *> blob

        *> const void *sqlite3_column_blob(sqlite3_stmt*, int);

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
            move -16 to :EXTERNAL-DBSTATUS:
            goback
        end-string

        set address of sqlite3-data to NULL

      when 5 *> null

        string
          field-delimiter delimited by size
          into row-buffer with pointer row-buffer-idx
          on overflow
            move -16 to :EXTERNAL-DBSTATUS:
            goback
        end-string

      when other *> datatype unknown/unsupported
        move -11 to :EXTERNAL-DBSTATUS:

    end-evaluate
    .

  replace-last-field-delimiter.

    move row-delimiter to row-buffer(row-buffer-idx - 1:1)
    .

end function DBGET.

>>page "Function: DBINFO"

identification division.

  function-id.                         DBINFO.

*><* 4.11. DBINFO
*><* ~~~~~~~~~~~~
*><*
*><*   Returns information about the Database being accessed.
*><*
*><* Syntax
*><* ######
*><*
*><*   move DBINFO(*dbinfo-mode*, *db-object*) to *dbinfo-buffer*
*><*
*><* Parameters
*><* ##########
*><*
*><*   *dbinfo-mode* is a size 4 unsigned numeric variable.
*><+   It indicates what information to return (see DBINFO Modes table below).
*><*
*><*   *db-object* is a size 8 alphanumeric variable.
*><+   It is used to hold the internal handle to the Database/SQL Object.
*><*
*><*   *dbinfo-buffer* is an alphanumeric variable for returning the requested
*><+   information. Refer to the mapping for *dbinfo-buffer* in the Working-Storage
*><+   Copybook (CobolSQLite3-WS.cpy) for further details.
*><*
*><* DBINFO Modes
*><* ############
*><*
*><*   +----+----------------------------------------------------------------------+
*><*   |Mode|Description                                                           |
*><*   +====+======================================================================+
*><*   |100 |The number of rows modified, inserted or deleted by the most recently |
*><*   |    |completed INSERT, UPDATE or DELETE statement against the database.    |
*><*   |    |Changes caused by triggers, foreign key actions or REPLACE constraint |
*><*   |    |resolution are not counted.                                           |
*><*   +----+----------------------------------------------------------------------+
*><*   |200 |Return a compiled SQL Statement with bind parameters expanded.        |
*><*   +----+----------------------------------------------------------------------+
*><*

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

    :EXTERNAL-DBSTATUS-DEF:

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

  linkage section.

    01  dbinfo-mode                    pic 9(004).
      88  dbinfo-changed-rows            value 100.
      88  dbinfo-expand-sql              value 200.

    01  db-object.
      05  db-object-ptr                usage pointer.

    01  dbinfo-buffer                  pic x(2048).

    01  redefines dbinfo-buffer.
      05  dbinfo-rows-changed          pic s9(09) comp.

procedure division using dbinfo-mode, db-object
               returning dbinfo-buffer.

  dbinfo-mainline.

    move ZERO to :EXTERNAL-DBSTATUS:

    evaluate true

      when dbinfo-changed-rows

        move ZERO to dbinfo-rows-changed

        *> int sqlite3_changes(sqlite3*);

        call static "sqlite3_changes" using by value db-object-ptr
                                  returning dbinfo-rows-changed
        end-call

      when dbinfo-expand-sql
         
        *> char *sqlite3_expanded_sql(sqlite3_stmt *pStmt);

        call static "sqlite3_expanded_sql" using by value db-object-ptr
                                   returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        move spaces to dbinfo-buffer
        string
          sqlite3-data delimited by low-value
          into dbinfo-buffer
          on overflow
            move -17 to :EXTERNAL-DBSTATUS:
            goback
        end-string

        set address of sqlite3-data to NULL

      when other *> invalid dbinfo mode
        move -13 to :EXTERNAL-DBSTATUS:

    end-evaluate

    goback
    .

end function DBINFO.

>>page "Function: DBERRMSG"

identification division.

  function-id.                         DBERRMSG.

*><* 4.12. DBERRMSG
*><* ~~~~~~~~~~~~~~
*><*
*><*   Returns the error message associated with the last *Status Code* setting.
*><*
*><* Syntax
*><* ######
*><*
*><*   move DBERRMSG to *error-message*
*><*
*><*   display DBERRMSG
*><*
*><* Parameters
*><* ##########
*><*
*><*   *error-message* is a size 256 alphanumeric variable.
*><+   It will hold the error message text for the last *Status Code*.
*><*
*><* Notes
*><* #####
*><*
*><*   The returned *error-message* will have one of following prefixes:
*><*
*><*     **DBINF** is not an actual error but for information. *DBINFO 0: Successful
*><+     completion.* is the only entry with this prefix.
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

    :EXTERNAL-DBSTATUS-DEF:

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
      88  invalid-bind-index             value -9.
      88  bind-value-to-big              value -10.
      88  datatype-unknown-unsupported   value -11.
      88  datatype-undefined             value -12.
      88  invalid-dbinfo-mode            value -13.
      88  not-an-sqlite-database         value -14.
      88  no-data-returned               value -15.
      88  row-buffer-overflow            value -16.
      88  dbinfo-buffer-overflow         value -17.

    01  display-sqlite3-status         pic Z(5)9(1).

    01  sqlite3-error-message          pic x(256).

    01  sqlite3-temporary-pointer      usage pointer.

    01  sqlite3-data                   pic x(1024) based.
          *> DO NOT WRITE TO THIS VARIABLE. *** THERE BE DRAGONS ***

  linkage section.

    01  error-message                  pic x(256).

procedure division returning error-message.

  dberrmsg-mainline.

    move :EXTERNAL-DBSTATUS: to db-status

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

      when invalid-bind-index

        move "DBERR -9: Bind parameter index out of range." to error-message

      when bind-value-to-big

        move "DBERR -10: Bind parameter value is to big." to error-message

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

        move "DBERR -16: Buffer passed to DBGET not large enough." to error-message

      when dbinfo-buffer-overflow

        move "DBERR -17: DBINFO buffer overflow (>2K characters)." to error-message

*>      when ?
*>
*>        move "DBERR -?: ?" to error-message

      when other *> sqlite3 library error

        *> const char *sqlite3_errstr(int);

        call static "sqlite3_errstr" using by value db-status
                                 returning sqlite3-temporary-pointer
        end-call

        set address of sqlite3-data to sqlite3-temporary-pointer

        move db-status to display-sqlite3-status

        move spaces to error-message
        string
          "SQLite3ERR " delimited by size
          trim(display-sqlite3-status) delimited by size
          ": " delimited by size
          sqlite3-data delimited by low-value
          into error-message
        end-string

        set address of sqlite3-data to NULL

    end-evaluate

    goback
    .

end function DBERRMSG.

>>page "Compilation Instructions"

*><* ---------------------------
*><* 5. Compilation Instructions
*><* ---------------------------
*><*
*><* 5.1. Linux/UNIX
*><* ~~~~~~~~~~~~~~~
*><*
*><*   Compile the *CobolSQLite3* source (CobolSQLite3.cob) by entering the following
*><+   command within any terminal program:
*><*
*><*   ::
*><*
*><*     cobc -o CobolSQLite3.so -debug CobolSQLite3.cob -lsqlite3
*><*
*><* 5.2. Apple Mac OS X
*><* ~~~~~~~~~~~~~~~~~~~
*><*
*><*   Compile the source file as for Linux/Unix.
*><*
*><* 5.3. Windows
*><* ~~~~~~~~~~~~
*><*
*><*   I do not have access to Windows, Windows/Cygwin or Windows/MinGW but I
*><+   understand that the following commands should work [YMMV].
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
*><* 5.4. Hard-copy Listings
*><* ~~~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   If you want a Hard-copy Listing then:
*><*
*><*   ::
*><*
*><*     cobc -F -Xref -T CobolSQLite3.lst CobolSQLite3.cob
*><*
*><*   The source listing, including cross-reference, will be written to the file
*><+   *CobolSQLite3.lst*.
*><*

>>page "Installation"

*><* ---------------
*><* 6. Installation
*><* ---------------
*><*
*><* 6.1. Requirements
*><* ~~~~~~~~~~~~~~~~~
*><*
*><*   **GnuCOBOL:** Version 2.2 (or greater) installed and tested fully working.
*><*
*><*     See the documentation supplied with *GnuCOBOL*. You **must** have run both
*><+     the sanity checks created by the test procedures included within the
*><+     Cobol85 suite as well as the *make check* procedure.
*><*
*><*   **SQLite3:** Version 3.14 (or greater).
*><*
*><*     As a minimum you need to install the Shared Library (*Libsqlite3-0*) and
*><+     Development Files (*Libsqlite3-dev*). Available from most Linux Distros,
*><+     but for Windows you will have to download them from **sqlite.org**.
*><*
*><*     **Note:** If updating from a previous version you may need to execute the
*><+     'ldconfig' command.
*><*
*><*     Although you do not need it you will find it an advantage to also install
*><+     the following:
*><*
*><*     - Command-Line Shell (*sqlite3*) is a utility that allows the manual
*><+       entry and execution of SQL statements against an SQLite database.
*><+       Documentation is at <https://www.sqlite.org/cli.html>.
*><*
*><*     - SQLite Database Analyzer (*sqlite3_analyzer*) reads an SQLite database
*><+       and outputs a file showing the space used by each table and index and
*><+       other statistics.
*><+       Documentation is at <https://www.sqlite.org/sqlanalyze.html>.
*><*
*><*     - SQLite Database Diff (*sqldiff*) compares two SQLite database files and
*><+       outputs the SQL needed to convert one into the other.
*><+       Documentation is at <https://www.sqlite.org/sqldiff.html>.
*><*
*><*     The **SQLite** Download page <https://www.sqlite.org/download.html> contains Source
*><+     Code files and precompiled binaries for multiple platforms. As of writing,
*><+     February 2021, version 3.34.1 is available from here.
*><*
*><*     See <https://www.sqlite.org/about.html> for information on SQLite.
*><*
*><* 6.2. Before First Use
*><* ~~~~~~~~~~~~~~~~~~~~~
*><*
*><*   Before you use the *CobolSQLite3* Library for the first time (and also after
*><+   a **new** release) you **must** generate the Copybook modules required by
*><+   the programs using the Library.
*><*
*><*   Enter the following commands:
*><*
*><*   ::
*><*
*><*     cobcrun ./CobolSQLite3 --repository > CobolSQLite3-CSR.cpy
*><*
*><*     cobcrun ./CobolSQLite3 --copylib > CobolSQLite3-WS.cpy
*><*
*><*   The first command generates a copylibrary containing a list of the functions
*><+   that are available in the CobolSQLite3 Library. This module needs to be
*><+   included in the REPOSITORY statement within the programs CONFIGURATION SECTION.
*><*
*><*   For example,
*><*
*><*   .. code:: cobolfree
*><*
*><*     configuration section.
*><*
*><*       repository.
*><*         copy "CobolSQLite3-CSR.cpy".
*><*         function all intrinsic.
*><*
*><*   The second command generates a copylibrary containing the Library data
*><+   definitions. This module needs to be included in the programs WORKING-STORAGE
*><+   SECTION.
*><*
*><*   For example,
*><*
*><*   .. code:: cobolfree
*><*
*><*     working-storage section.
*><*
*><*       copy "CobolSQLite3-WS.cpy".
*><*
*><*       *> additional data definitions
*><*
*><*   There are two additional commands that you can run:
*><*
*><*   ::
*><*
*><*     cobcrun ./CobolSQLite3 --version
*><*
*><*     cobcrun ./CobolSQLite3 --help
*><*
*><*   The first command displays the CobolSQLite3 Library and SQLite3 versions.
*><*
*><*   For example,
*><*
*><*   ::
*><*
*><*     CobolSQLite3/A.01.00
*><*     SQLite3 Interface Functions for GnuCOBOL
*><*     Copyright (c) Robert W.Mills <rwm.cobol@gmail.com>, 2017-2021
*><*     SQLite3 Library Version 3.13
*><*
*><*      ** Please update SQLite3 Library to at least Version 3.14 **
*><*
*><*     This is free software; see the source for copying conditions. There is NO
*><*     WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*><*
*><*   The second command displays some help text.
*><*
*><*   For example,
*><*
*><*   ::
*><*
*><*     cobcrun [path/]CobolSQLite3 [option] [>filename]
*><*
*><*     option:
*><*       -h, --help          Display this help text.
*><*       -v, --version       Display the Library and SQLite3 Versions.
*><*       -r, --repository    Generate the Repository Copylibrary module.
*><*       -c, --copylib       Generate the Working-storage Copylibrary module.
*><*
*><*     Output from the --repository and --copylib options is written to
*><*     Standard Out. Use >filename to redirect it to a disc file instead.
*><*
*><* 6.3. Copybook Listings
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

>>page "Accessing the Library"

*><* ------------------------
*><* 7. Accessing the Library
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

>>page "Example/Test Programs"

*><* ------------------------
*><* 8. Example/Test Programs
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
*><+    to the functions instead of quoted strings.
*><*
*><*   .. include:: Test-2.cob
*><*      :code: cobolfree
*><*
*><*   **Test-3.cob** is a copy of **Test-1.cob** that demonstrates Reusing Compiled
*><+    Statements. It calls the DBCOMPILE, DBBIND, DBEXECUTE and DBRELEASE functions,
*><+    instead of DBSQL, to load the 4 entries into the Table.
*><*
*><*   .. include:: Test-3.cob
*><*      :code: cobolfree
*><*

>>page "Modification History"

*><* -----------------------
*><* 9. Modification History
*><* -----------------------
*><*
*><*   .. include:: ChangeLog
*><*

>>page "Planned Enhancements"

*><* ------------------------
*><* 10. Planned Enhancements
*><* ------------------------
*><*
*><*   .. include:: ToDo
*><*

>>page "End of User Guide and Source Code"

*><*
*><* .. footer:: End of CobolSQLite3 User Guide
*><*
*> End of source code.
*> *****************************************************************************
