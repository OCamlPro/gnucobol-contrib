esqlOC
======

An ESQL preprocessor by Sergey Kashyrin.

esqlOC relies on ODBC for access to a variety of SQL engines including

- PostgreSQL
- MariaDB (MySQL)
- SQLite
- DB2
- Firebird

Installation
------------

For Windows, a very complete setup article can be found at

[ati setup guide](https://open-cobol.sourceforge.io/faq/index.html#getting-started-with-esqloc)

### Pre-requisites
esqlOC requires a C++ compiler.

For GNU/Linux apt that is as simple as

    prompt$ sudo apt install g++

### Get
Either copy the files from here, or pull a copy from Sergey's upstream site

    prompt$ wget http://www.kiska.net/opencobol/esql/gnu-cobol-sql-2.0.tar.gz

### Extract

    prompt$ tar xvf gnu-cobol-sql-2.0.tar.gz

### Build

    prompt$ cd gnu-cobol-sql-2.0
    prompt$ ./configure
    prompt$ make
    prompt$ sudo make install
    prompt$ sudo ldconfig

### Setup ODBC

You will need a functioning ODBC engine and driver for your particular
database.

    prompt$ sudo apt install unixODBC

### Try

The Windows article by *ati* linked above includes a handy first sample.  Get a
copy from the listing in the article and customize the connection settings:

      *-----------------------------------------------------------------*
      * CONNECT TO THE DATABASE
      * also possible with DSN: 'youruser/yourpasswd@yourODBC_DSN'
      *-----------------------------------------------------------------*
         STRING 'DRIVER={MySQL ODBC 5.2w Driver};'
                'SERVER=localhost;'
                'PORT=3306;'
                'DATABASE=test;'
                'USER=youruser;'
                'PASSWORD=yourpasswd;'
      * example for DB specific ODBC parameter:
      *   no compressed MySQL connection (would be the DEFAULT anyway)
                'COMRESSED_PROTO=0;'
           INTO BUFFER.
         EXEC SQL
           CONNECT TO :BUFFER
         END-EXEC.
         PERFORM SQLSTATE-CHECK.

A MySQL setup.  For SQLite this can be simplified to

       STRING 'nouser/@unicon' INTO BUFFER

       EXEC SQL
           CONNECT TO :BUFFER
       END-EXEC.
       PERFORM SQLSTATE-CHECK

### Prepare a test

NOTE: esqlOC is case sensitive and input sources need to use UPPER CASE
reserved words.

This example is configured for SQLite and required a change from the *ati*
example.  The example uses an extension to the SQL syntax:

INSERT INTO SET is non standard syntax

    EXEC SQL
     INSERT INTO TESTPERSON SET
      ID=:hVarN,
      NAME=:hVarC
    END-EXEC

That needs to change to SQL standard for compliant databases.

    EXEC SQL
     INSERT INTO TESTPERSON (ID, NAME) VALUES (:hVarN, :hVarC)
    END-EXEC

### Pre-process and compile
The code needs to be pre-processed, and then compiled.

The esqlOC command accepts input and output filenames, but defaults to
converting .cbl files to .cob.


    prompt$ esqlOC esqltest.cbl
    prompt$ cobc -x esqltest.cob -locsql
    prompt$ ./esqltest

    1487824575 OCSQL: DB connect to DSN 'unicon' user = 'nouser'
    1487824575 OCSQL: DB Connected, Schema is
    '/home/btiffin/lang/unicon/databases/unicon.db'
    1487824575 OCSQL: EXECUTE IMMEDIATE CREATE TABLE TESTPERSON(ID DECIMAL(12,0),
    NAME CHAR(50) NOT NULL, PRIMARY KEY (ID))
    
     created Table TESTPERSON
    1487824575 OCSQL: PREPARE I/O INSERT INTO TESTPERSON (ID,NAME) VALUES (?,?)
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPERSON (ID,NAME) VALUES (?,?)
    INSERTED 
      Person 000000000001 NAME Testpers 000000000001                             
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPERSON (ID,NAME) VALUES (?,?)
    INSERTED 
      Person 000000000002 NAME Testpers 000000000002                             
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPERSON (ID,NAME) VALUES (?,?)
    INSERTED 
      Person 000000000003 NAME Testpers 000000000003                             
    1487824575 OCSQL: EXECUTE IMMEDIATE CREATE TABLE TESTGAME(ID DECIMAL(12,0),
    NAME CHAR(50) NOT NULL, PRIMARY KEY (ID))
    
     created Table TESTGAME
    1487824575 OCSQL: PREPARE I/O INSERT INTO TESTGAME (ID,NAME) VALUES (?,?)
    1487824575 OCSQL: EXECUTE INSERT INTO TESTGAME (ID,NAME) VALUES (?,?)
    INSERTED
      Game 000000000001 NAME Testgame 000000000001
    1487824575 OCSQL: EXECUTE INSERT INTO TESTGAME (ID,NAME) VALUES (?,?)
    INSERTED
      Game 000000000002 NAME Testgame 000000000002
    1487824575 OCSQL: EXECUTE INSERT INTO TESTGAME (ID,NAME) VALUES (?,?)
    INSERTED
      Game 000000000003 NAME Testgame 000000000003
    1487824575 OCSQL: EXECUTE INSERT INTO TESTGAME (ID,NAME) VALUES (?,?)
    INSERTED
      Game 000000000004 NAME Testgame 000000000004
    1487824575 OCSQL: EXECUTE IMMEDIATE CREATE TABLE TESTPOINTS(PERSONID
    DECIMAL(12,0), GAMEID DECIMAL(12,0), POINTS DECIMAL(6,2), CONSTRAINT
    POINTS_CONSTRAINT1 FOREIGN KEY (PERSONID) REFERENCES TESTPERSON(ID), CONSTRAINT
    POINTS_CONSTRAINT2 FOREIGN KEY (GAMEID) REFERENCES TESTGAME(ID),PRIMARY KEY
    (PERSONID, GAMEID))
    
     created Table TESTPOINTS
    1487824575 OCSQL: PREPARE I/O INSERT INTO TESTPOINTS (PERSONID,GAMEID,POINTS)
    VALUES (?,?,?)
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPOINTS (PERSONID,GAMEID,POINTS)
    VALUES (?,?,?)
    INSERTED
      POINTS for person/game 000000000001 : +00001.75
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPOINTS (PERSONID,GAMEID,POINTS)
    VALUES (?,?,?)
    INSERTED
      POINTS for person/game 000000000002 : +00002.75
    1487824575 OCSQL: EXECUTE INSERT INTO TESTPOINTS (PERSONID,GAMEID,POINTS)
    VALUES (?,?,?)
    INSERTED
      POINTS for person/game 000000000003 : +00003.75
    1487824575 OCSQL: PREPARE I/O SELECT SUM(POINTS) FROM TESTPERSON,TESTPOINTS
    WHERE PERSONID>1 AND PERSONID=ID
    1487824575 OCSQL: EXECUTE SELECT SUM(POINTS) FROM TESTPERSON,TESTPOINTS WHERE
    PERSONID>1 AND PERSONID=ID
    SELECTED
      SUM of POINTS for persons >1 +00006.50
    1487824575 OCSQL: PREPARE I/O SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
    1487824575 OCSQL: OPEN CURSOR SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
    1487824575 OCSQL: FETCH SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
    FETCHED
      person Testpers 000000000001                              points: +00001.75
    1487824575 OCSQL: FETCH SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
    FETCHED
      person Testpers 000000000002                              points: +00002.75
    1487824575 OCSQL: FETCH SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
    FETCHED
      person Testpers 000000000003                              points: +00003.75
    1487824575 OCSQL: FETCH SELECT TESTPERSON.NAME,POINTS FROM
    TESTPERSON,TESTPOINTS WHERE PERSONID=ID
     No points found
    1487824575 OCSQL: COMMIT
    1487824575 OCSQL: DB Closed
