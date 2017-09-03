           ____      _           _  ____   ___  _     _ _        _____
          / ___|___ | |__   ___ | |/ ___| / _ \| |   (_) |_ ___ |___ /
         | |   / _ \| '_ \ / _ \| |\___ \| | | | |   | | __/ _ \  |_ \
         | |__| (_) | |_) | (_) | | ___) | |_| | |___| | ||  __/ ___) |
          \____\___/|_.__/ \___/|_||____/ \__\_\_____|_|\__\___||____/

                    An SQLite3 Interface for GnuCOBOL 2.x

                           Copyright (c) 2017-2017
                   Robert W.Mills <cobolmac@btinternet.com>
--------------------------------------------------------------------------------
       Please Note: The current verion, X.01.00, is BETA. Buyer beware!!
--------------------------------------------------------------------------------

CobolSQLite3 implements an interface to the SQLite3 Database Engine.

See <https://www.sqlite.org/about.html> for information on SQLite.

The interface consists of a Dynamic Library (.so file in Linux), containing User
Defined Functions, that performs the following actions:

    - Open/Create an SQLite Database
    - Close an SQLite Database
    - Compile an SQL Statement into byte-code
    - Execute a compiled SQL Statement
    - Release (delete) a compiled SQL Statement
    - Reset (re-initialise) a compiled SQL Statement
    - Compile, execute and release a single SQL Statement
    - Retrieve selected columns from a SELECTed row
    - Request information about the Database (currently a limited function)
    - Translates a UDF Status Code into human-readable text

    NOTE: The interface only supports TEXT and INTEGER data types.
          Data types FLOAT and BLOB will be added later (if needed).

--------------------------------------------------------------------------------

Instructions on how to compile the library, and how the library can be used to
generate the required Repository and Working-storage Copylibrary modules, can be
found in the comment block at the start of the source file (CobolSQLite3.cob)
under the 'Tectonics:' heading.

A test program, named CobolSQLite3-test.cob, has been included. Compilation and
run-time instructions are included under the 'Tectonics:' heading.

Note: You must compile the library and generate the copy libraries before you
      compiling the test program.

--------------------------------------------------------------------------------
Last updated 3rd September, 2017 (c) Robert W.Mills
