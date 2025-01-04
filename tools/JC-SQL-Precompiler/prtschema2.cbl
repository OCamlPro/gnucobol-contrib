       >>SOURCE FREE
*> Next statement a REPLACE fixes a error when using MySQL which inserts
*>  very large values in 3 fields in TD-COLLUMN block when compiling with GC
*>  the generated prtschema2.cbl from prtschema2.scb.
*>
       REPLACE ==94967295==  BY ==1048576==.
 identification division.
 program-id.    Prtschema2.
*>Author.       J. C. Currey.
*>Updates.      V. B. Coen, Applewood Computers.
*>**
*> Security.    Copyright (C) 2009-2021, Jim Currey.
*>              Distributed under the GNU General Public License
*>              v2.0. See the file COPYING for details.
*>**********************************************************************
*> PURPOSE:                                                            *
*>      MySQL schema print for GnuCOBOL 1.1, v2 & v3.                  *
*>       and MySQL and Mariadb.                                        *
*>                                                                     *
*>    This program prints a Full schema from a mysql                   *
*>           data base placing the result into file                    *
*>           schema.t which is then printed.                           *
*>           You will need to CHANGE the CUPS spool name               *
*>           to match your installation - see                          *
*>            01  print-report.                                        *
*>                                                                     *
*>    Depending on the size of your database tables this               *
*>     could be a long print out so you might want to leave            *
*>     the current cups spool name as is to stop a report !            *
*>    Report is landscape as it takes up to 132 columns.               *
*>     and is generally used for reference only.                       *
*>                                                                     *
*>**                                                                   *
*>  COMPILE: Using prtschema2.sh                                       *
*>**                                                                   *
*>  USAGE:                                                             *
*>       prtschema2 DatabaseName PrintSpoolName                        *
*>   OR                                                                *
*>      prtschema2                                                     *
*>           and parameters will be requested.                         *
*>**                                                                   *
*> Change Record.                                                      *
*>   version 001--Original version                                     *
*>                                                                     *
*>                 February, 2010--J C Currey                          *
*>                                                                     *
*>           002--Only prints character-set-name,                      *
*>                  collation-name, and privileges                     *
*>                  if they are non-standard                           *
*>                 March 11, 2010--J C Currey                          *
*>                                                                     *
*>   version 003--Fixed the bug that allowed a line to be              *
*>                skipped at the beginning of a new page               *
*>                1353122--Randy Coman                                 *
*>                08/30/2011--Efrain Aguilera                          *
*>                                                                     *
*>           03b--Rem'd out the laser printer formatting               *
*>                as only applies to jc site but set up                *
*>                for landscape + char size etc, now done              *
*>                using the lpr command, see rev 004 notes.            *
*>                Changed mysql params at location of                  *
*>                /MYSQL INIT\ so do same for your site.               *
*>                 See 1050-Init-RDB                                   *
*>                                                                     *
*>                Note tested against mariadb ONLY which is            *
*>                a drop in replacement for Mysql.                     *
*>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                *
*>                20151015 -- Vince Coen                               *
*>                                                                     *
*>   version 004--Added support for longtext as for medium.            *
*>                extra display info for unhandled                     *
*>                datatypes and close files.                           *
*>                changed 9000 for more detailed lpr prt               *
*>                 command.                                            *
*>                Changed to free format source code.                  *
*>                20151016 -- Vince Coen                               *
*>                                                                     *
*>           005--Check update-time and check-time for null            *
*>                e.g., not starting with "2"                          *
*>                NOTE prt name limited to 32 chars.                   *
*>                Amended to print 0 if empty (151019)                 *
*>                Replaced silly NEXT SENTENCE clauses                 *
*>                20151018 -- Vince Coen                               *
*>                                                                     *
*>   Version renamed 1.05 20160628 -- Vince Coen                       *
*>          1.06 - Added extra notes/comments here and proc.           *
*>                 Coding clean up.                                    *
*>                 Removed print command display at EOJ.               *
*>                 Added chaining so params added at                   *
*>                 program load time in the form :                     *
*>                  prtschema DataBaseName CupsSpoolName               *
*>                                                                     *
*>                 If not present will ask for these.                  *
*>                  If spoolname not found will just report an error   *
*>                   and the o/p file is schema.t .                    *
*>                                                                     *
*>          1.07 - Change tests on ws-Mysql-Count-Rows from            *
*>                 'not > zero' to '= zero'                            *
*>                 Add blank line before new page.                     *
*>                 Moved date & time over 4 char to allign.            *
*>                 20160821 -- Vince Coen.                             *
*>                                                                     *
*>          1.08 - Moved over KEY 2 chars to stop trunc'n.             *
*>                 Support for unsigned fields in PIC                  *
*>          1.09 - Added Intl dating formatting for O/P.               *
*>                 for LC_TIME accepts :                               *
*>                    en_GB   for the UK                               *
*>                    en_US   for the USA                              *
*>                    other   for Unix format (CCYY/MM/DD)             *
*>                 NON UK/USA users can change line with if needed :   *
*>                 01  WS-Local-Time-Zone         pic 9    value 3.    *
*>                  to 2 for USA or 1 for UK, 3 = unix format which is *
*>                     ccyy/mm/dd                                      *
*>                 This is only for date format in headings.           *
*>                 More tidying up for heads line 1                    *
*>                 Display a '.' for each table processed              *
*>                  subject to buffering                               *
*>                  can be a bit slow accessing MySQL/Maria            *
*>                 20160821 -- Vince Coen.                             *
*>                                                                     *
*>          1.10 - Cosmetic added 'e' to Curry > Currey.               *
*>          2.11 - For prtschema2 the Mysql connection set up that     *
*>                 needs to reflect your MySql site requirements are   *
*>                 taken from a file found within the current working  *
*>                 directory BUT the version of cobmysqlapi38 (taken   *
*>                 from dbpre and updated) MUST be used                *
*>                 and this is included in the archive.                *
*>                 Unused Format file processing that was commented    *
*>                 out has now been removed.                           *
*>                                                                     *
*>                 This version will read a file containing the        *
*>                 six RDB parameters e.g.,                            *
*>                 DBHOST=localhost                                    *
*>                 DBUSER=root                                         *
*>                 DBPASSWD=PaSsWoRd                                   *
*>                 DBNAME= any as over ridden                          *
*>                 DBPORT=03306                                        *
*>                 DBSOCKET=/home/mysql/mysql.sock                     *
*>                 in file presql2.param                               *
*>                                                                     *
*>       Then issues a call to the cobmysqlapi38 * version             *
*>        to read in this file that MUST be in the working directory.  *
*>                                                                     *
*>       This way prtschema2 can be used for more than one MySQL       *
*>       server on more than one system within a LAN.                  *
*>        See the example file called prtschema2.param                 *
*>                     30 August 2016 (160830)                         *
*>                                                                     *
*>          2.12 - Updated copyright notices & change 2.11 comments.   *
*>                     7 April 2018.                                   *
*>                                                                     *
*>          2.13 - Created a UDR REPLACE to change the large values    *
*>                 created against the RDBMS for BLOBS/GLOBS that are  *
*>                 too large for the cobol compiler. See 1st few lines *
*>                                                                     *
*>                 Extra notes for the REPLACE line.                   *
*>                                                                     *
*>**********************************************************************
*>
*> COPYRIGHT NOTICE.
*>*****************
*>
*> This file/program is part of the Mysql pre-processor presql
*> and is copyright (c) Jim Currey. 2009-2021 and later.
*>
*> This program is free software; you can redistribute it and/or
*> modify it under the terms of the GNU General Public License as
*> published by the Free Software Foundation; version 2 ONLY.
*>
*> The Presql package is distributed in the hope that it will be
*> useful, but WITHOUT ANY WARRANTY; without even the implied warranty
*> of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*> See the GNU General Public License for more details.
*> If it breaks, you own both pieces but I will endevor to fix it,
*> providing you tell me about the problem.
*>
*> You should have received a copy of the GNU General Public License
*> along with the package; see the file COPYING.
*> If not, write to the Free Software Foundation, 59 Temple Place,
*>  Suite 330, Boston, MA 02111-1307 USA.
*>*******************************************************************
*>
 environment division.
 input-output section.
 file-control.
     select Print-File       assign ws-Name-Print-File
                             organization line sequential
                             file status ws-Print-File-Status.
*>
 data division.
 file section.
*>
 fd  Print-File.
 01  Print-Record.
     05  pr-buffer                       pic x(136).
*>
 working-storage section.
*>***************************************************
*>   Constants, Counters And Work Areas             *
*>***************************************************
 01  ws-Name-Program                     pic x(15) value "prtschema2 2.13".
   *> needed 4 read-params call.
 01  ws-parm-prog-name                   pic x(10) value "prtschema2".
*>
 01  ws-No-Paragraph                     pic s9(4) comp.
 01  ws-A                                pic s9(4) comp.
 01  ws-I                                pic s9(4) comp.
 01  ws-J                                pic s9(4) comp.
 01  ws-K                                pic s9(4) comp.
 01  ws-Name-Print-File                  pic x(64)     value spaces.
 01  ws-Line-Printer-Name                pic x(64).
 01  ws-Print-File-Status                pic xx.
 01  ws-Print-Command                    pic x(192).
 01  ws-Read-Area                        pic x(80).
 01  ws-Date                             pic 9(8).
 01  ws-Time                             pic 9(8).
 01  ws-Ed-Time                          pic 99b99b99b99.
 01  ws-Ed2                              pic 99.
 01  ws-Ed2-Second                       pic 99.
 01  ws-Ed3s                             pic zzz-.
 01  ws-Ed6s                             pic zzzzz9-.
 01  ws-Ed8                              pic z(7)9.
 01  ws-Ed18s                            pic zzz,zzz,zzz,zzz,zzz,zz9-.
 01  ws-Name-Data-Base                   pic x(30).
 01  ws-Where                            pic x(512).
 01  ws-Line-Counter                     pic s9(4).
 01  ws-Page-Number                      pic s9(4)     value zero.
 01  ws-Heading-Buffer                   pic x(132).
 01  ws-Switch-Table                     pic x         value "N".
 01  ws-Character-Set-Name               pic x(64).
 01  ws-Collation-Name                   pic x(64).
 01  ws-Privileges                       pic x(80).
 01  ws-Print-Record-Hold                pic x(132).
*>
 01  WS-Locale                           pic x(16)     value spaces.
 01  WS-Local-Time-Zone                  pic 9         value 3.
*>
*> Sets WS-Local-Time-Zone ^~^ to one of these 88 value's according to your local requirements
*> NOTE Environment var. LC_TIME is checked for "en_GB" for UK (1) and "en_US" for USA (2)
*>   at start of program. For any other, you can add yours if different but let the author know,
*>     so it can be added to the master sources
*>
*>    Note that 'implies' does NOT mean the program does anything e.g., changes page sizing in the report.
*>
     88  LTZ-Unix                                      value 3.
     88  LTZ-USA                                       value 2.
     88  LTZ-UK                                        value 1.
*>
*>***************************************************************
*> This block replaces the use of a printer format file         *
*>***************************************************************
*>
 01  Print-Report.
     03  filler          pic x(117)     value
     "lpr -o 'orientation-requested=4 page-left=18 " &
     "page-top=48 " &     *> '-r ' is before '-o' but want to keep o/p file
     "page-right=10 sides=two-sided-long-edge cpi=12 lpi=8' -P ".
*>
*> This is the Cups print spool, it is updated by param 2.
*>
     03  psn             pic x(32)      value "HPLJ4TCP ".
*>
*> Don't change this line
     03  filler          pic x(15)      value " schema.t".
*>
*>***************************************************************
*>  These variables will contain the information used           *
*>    to build the cobol data definition                        *
*>***************************************************************
*>
 01  ws-Column-Array-Buffer.
     05  ws-ca-Column-Name               pic x(32).
     05  ws-ca-Data-Type                 pic x(12).
     05  ws-ca-Column-Type               pic x(32).
     05  ws-ca-Character-Maximum-Length  pic s9(19).
     05  ws-ca-Numeric-Precision         pic s9(19).
     05  ws-ca-Numeric-Scale             pic s9(19).
     05  ws-ca-Picture                   pic x(32).
*>  /MYSQL VAR\
*>        information_schema
*>        TABLE=TABLES,TB
*>        TABLE=COLUMNS,CB
 COPY "mysql-variables.cpy".
*>
*>    Definitions for the TABLES Table
*>
       01  TP-TABLES                             USAGE POINTER.
       01  TD-TABLES.
           05  TB-TABLE-CATALOG                  PIC X(512).
           05  TB-TABLE-SCHEMA                   PIC X(64).
           05  TB-TABLE-NAME                     PIC X(64).
           05  TB-TABLE-TYPE                     PIC X(64).
           05  TB-ENGINE                         PIC X(64).
           05  TB-VERSION                        PIC  9(18) COMP.
           05  TB-ROW-FORMAT                     PIC X(10).
           05  TB-TABLE-ROWS                     PIC  9(18) COMP.
           05  TB-AVG-ROW-LENGTH                 PIC  9(18) COMP.
           05  TB-DATA-LENGTH                    PIC  9(18) COMP.
           05  TB-MAX-DATA-LENGTH                PIC  9(18) COMP.
           05  TB-INDEX-LENGTH                   PIC  9(18) COMP.
           05  TB-DATA-FREE                      PIC  9(18) COMP.
           05  TB-AUTO-INCREMENT                 PIC  9(18) COMP.
           05  TB-CREATE-TIME                    PIC X(19).
           05  TB-UPDATE-TIME                    PIC X(19).
           05  TB-CHECK-TIME                     PIC X(19).
           05  TB-TABLE-COLLATION                PIC X(32).
           05  TB-CHECKSUM                       PIC  9(18) COMP.
           05  TB-CREATE-OPTIONS                 PIC X(2048).
           05  TB-TABLE-COMMENT                  PIC X(2048).
           05  TB-MAX-INDEX-LENGTH               PIC  9(18) COMP.
           05  TB-TEMPORARY                      PIC X(1).
*>
*>    Definitions for the COLUMNS Table
*>
       01  TP-COLUMNS                            USAGE POINTER.
       01  TD-COLUMNS.
           05  CB-TABLE-CATALOG                  PIC X(512).
           05  CB-TABLE-SCHEMA                   PIC X(64).
           05  CB-TABLE-NAME                     PIC X(64).
           05  CB-COLUMN-NAME                    PIC X(64).
           05  CB-ORDINAL-POSITION               PIC  9(18) COMP.
           05  CB-COLUMN-DEFAULT                 PIC X(94967295).
           05  CB-IS-NULLABLE                    PIC X(3).
           05  CB-DATA-TYPE                      PIC X(64).
           05  CB-CHARACTER-MAXIMUM-LENGTH       PIC  9(18) COMP.
           05  CB-CHARACTER-OCTET-LENGTH         PIC  9(18) COMP.
           05  CB-NUMERIC-PRECISION              PIC  9(18) COMP.
           05  CB-NUMERIC-SCALE                  PIC  9(18) COMP.
           05  CB-DATETIME-PRECISION             PIC  9(18) COMP.
           05  CB-CHARACTER-SET-NAME             PIC X(32).
           05  CB-COLLATION-NAME                 PIC X(32).
           05  CB-COLUMN-TYPE                    PIC X(94967295).
           05  CB-COLUMN-KEY                     PIC X(3).
           05  CB-EXTRA                          PIC X(80).
           05  CB-PRIVILEGES                     PIC X(80).
           05  CB-COLUMN-COMMENT                 PIC X(1024).
           05  CB-IS-GENERATED                   PIC X(6).
           05  CB-GENERATION-EXPRESSION          PIC X(94967295).
*>  /MYSQL-END\
*>***************************************************************
*>                Procedure Division                            *
*>***************************************************************
 procedure division chaining ws-Name-Data-Base
                             ws-Line-Printer-Name.
*>
 0000-main section.
     perform  1000-initialization thru 1990-exit.
     perform  2000-process        thru 7990-exit.
     perform  9000-end-of-program thru 9990-exit.
     stop run.
*>***************************************************************
*>               Initialization                                 *
*>***************************************************************
 1000-initialization.
     move     1000 to ws-no-paragraph.
     if       function upper-case (ws-Name-Data-Base) not = "HELP"
              display  "I) ", ws-name-program, " BEGINNING AT--"
                       function current-date.
     initialize ws-column-array-buffer.
     if       function upper-case (ws-Name-Data-Base) = "HELP"
              display WS-NAME-PROGRAM " - - help "
              display "       P1 = Data Base Name  "
              display "       P2 = Printer Spool Name "
              display " "
              stop run
     end-if
     if       ws-Name-Data-Base not = spaces
          and ws-Line-Printer-Name not = spaces
              move ws-Line-Printer-Name to psn
              move "schema.t" to ws-Name-Print-File
              open output Print-File
              if   ws-Print-File-Status not = zero
                   display "T) Cannot Open Print File, Status=",
                   ws-Print-File-Status
                   stop run
              end-if
              go to 1050-Init-RDB
     end-if.

 1002-get-base-name-file.
     display  "A) Enter Data Base Name " with no advancing.
     accept   ws-name-data-base.
     move     "schema.t" to ws-name-print-file.
     display  "A) Enter Printer Spool Name " with no advancing.
     accept   ws-line-printer-name.
     move     ws-line-printer-name to psn.
     open     output print-file.
     if       ws-print-file-status not = zero
              display "T) Cannot Open Print File, Status=" ws-print-file-status
              stop run.
*>
 1050-Init-RDB.        *> reads file prtschema2.param
     move     spaces to               WS-MYSQL-Host-Name
                                      WS-MYSQL-Implementation
                                      WS-MYSQL-Password
                                      WS-MYSQL-Base-Name
                                      WS-MYSQL-Port-Number
                                      WS-MYSQL-Socket.
     Call     "read_params"     USING ws-parm-prog-name
                                      WS-MYSQL-Host-Name
                                      WS-MYSQL-Implementation
                                      WS-MYSQL-Password
                                      WS-MYSQL-Base-Name
                                      WS-MYSQL-Port-Number
                                      WS-MYSQL-Socket
     End-call
*>
*>     display  "Using as RDB calls ".
*>     display  "Host=" WS-MYSQL-Host-Name.
*>     display  "BaseName=" WS-MYSQL-BASE-NAME.
*>     display  "User=" WS-MYSQL-Implementation.
*>     display  "Password=" WS-MYSQL-Password.
*>     display  "Port=" WS-MYSQL-Port-Number.
*>     display  "Socket=" WS-MYSQL-Socket.
*>     display  " ".

*> /MYSQL INIT\
*>     BASE=information_schema
*>     HOST=localhost
*>     IMPLEMENTATION=dev-prog-001
*>     PASSWORD=mysqlpass
*>     SOCKET=/home/mysql/mysql.sock
*> /MYSQL-END\
     PERFORM  MYSQL-1000-OPEN THRU MYSQL-1090-EXIT.

     move     "select,insert,update,references" to ws-privileges.
     move     "latin1" to ws-character-set-name.
*>
     accept   WS-Locale     from Environment "LC_TIME".     *> works with Linux, unix not sure about others ?
     if       WS-Locale (1:5) = "en_GB"
              set LTZ-UK  to true
     else if  WS-Locale (1:5) = "en_US"
              set LTZ-USA to true
     end-if.
*>
 1990-exit.
     exit.
*>*************************************************************
*>                 Detail Section                             *
*>*************************************************************
 2000-process.
     move     2000 to ws-no-paragraph.
     initialize ws-where.
     string   'TABLE_SCHEMA="'
              function trim (ws-name-data-base)
              '"'
                  into ws-where.
*>  /MYSQL SELECT\
*>
*>    Select rows
*>
*>      TABLE=TABLES
           INITIALIZE WS-MYSQL-COMMAND
           STRING "SELECT * FROM "
             "`TABLES`"
             " WHERE "
             WS-WHERE
            ";"  X"00" INTO WS-MYSQL-COMMAND
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT
           PERFORM MYSQL-1220-STORE-RESULT THRU MYSQL-1239-EXIT
           MOVE WS-MYSQL-RESULT TO TP-TABLES
*>  /MYSQL-END\
     if       ws-Mysql-Count-Rows = zero     *>   not > zero
              display "T) NO TABLES DEFINED IN "
                      function trim (ws-name-data-base)
              stop run.
 2010-fetch-tables-loop.
*>  /MYSQL FETCH\
*>
*>    Fetch next record
*>
*>      TABLE=TABLES
           MOVE TP-TABLES TO WS-MYSQL-RESULT
           CALL "MySQL_fetch_record" USING WS-MYSQL-RESULT
                    TB-TABLE-CATALOG
                    TB-TABLE-SCHEMA
                    TB-TABLE-NAME
                    TB-TABLE-TYPE
                    TB-ENGINE
                    TB-VERSION
                    TB-ROW-FORMAT
                    TB-TABLE-ROWS
                    TB-AVG-ROW-LENGTH
                    TB-DATA-LENGTH
                    TB-MAX-DATA-LENGTH
                    TB-INDEX-LENGTH
                    TB-DATA-FREE
                    TB-AUTO-INCREMENT
                    TB-CREATE-TIME
                    TB-UPDATE-TIME
                    TB-CHECK-TIME
                    TB-TABLE-COLLATION
                    TB-CHECKSUM
                    TB-CREATE-OPTIONS
                    TB-TABLE-COMMENT
                    TB-MAX-INDEX-LENGTH
                    TB-TEMPORARY

*>  /MYSQL-END\
     if       return-code = -1
              go to 9000-end-of-program.
     move     "Y" to ws-switch-table.
     perform  3100-headings thru 3190-exit.
     perform  3000-print-line thru 3090-exit.
     move     tb-table-name to pr-buffer.
     perform  3000-print-line thru 3090-exit.
     move     "TABLE-TYPE" to pr-buffer (16:10).
     move     tb-table-type to pr-buffer (28:64).
     perform  3000-print-line thru 3090-exit.
     move     "ENGINE" to pr-buffer (20:6).
     move     tb-engine to pr-buffer (28:64).
     perform  3000-print-line thru 3090-exit.
     move     "VERSION" to pr-buffer (19:7).
     move     tb-version to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "ROW-FORMAT" to pr-buffer (16:10).
     move     tb-row-format to pr-buffer (28:10).
     perform  3000-print-line thru 3090-exit.
     move     "TABLE-ROWS" to pr-buffer (16:10)
     move     tb-table-rows to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "AVG-ROW-LENGTH" to pr-buffer (12:14)
     move     tb-avg-row-length to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "DATA-LENGTH" to pr-buffer (15:11)
     move     tb-data-length to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "MAX-DATA-LENGTH" to pr-buffer (11:15)
     move     tb-max-data-length to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "INDEX-LENGTH" to pr-buffer (14:12)
     move     tb-index-length to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "DATA-FREE" to pr-buffer (15:9)
     move     tb-data-free to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "AUTO-INCREMENT" to pr-buffer (12:14)
     move     tb-auto-increment to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "CREATE-TIME" to pr-buffer (15:11).
     move     tb-create-time to pr-buffer (32:19).
     perform  3000-print-line thru 3090-exit.
*>
*> Don't print junk if field NULL
*>
     move     "UPDATE-TIME" to pr-buffer (15:11).
     if       tb-update-time (1:1) = "2"               *> starts with "20"  e.g., 21st century onwards
              move tb-update-time to pr-buffer (32:19)
     else
              move "0" to pr-buffer (50:1).
     perform  3000-print-line thru 3090-exit.
     move     "CHECK-TIME" to pr-buffer (16:10).
     if       tb-check-time (1:1) = "2"
              move tb-check-time to pr-buffer (32:19)
     else
              move "0" to pr-buffer (50:1).
     perform  3000-print-line thru 3090-exit.
*>
     move     "TABLE-COLLATION" to pr-buffer (11:15).
     move     tb-table-collation to pr-buffer (28:64).
     move     tb-table-collation to ws-collation-name.
     perform  3000-print-line thru 3090-exit.
     move     "CHECKSUM" to pr-buffer (18:8).
     move     tb-checksum to ws-ed18s.
     move     ws-ed18s to pr-buffer (28:24).
     perform  3000-print-line thru 3090-exit.
     move     "CREATE-OPTIONS" to pr-buffer (12:14).
     move     tb-create-options to pr-buffer (28:100).
     perform  3000-print-line thru 3090-exit.
     move     "DEFAULT CHARACTER SET NM" to pr-buffer (2:24).
     move     ws-character-set-name to pr-buffer (28:64).
     perform  3000-print-line thru 3090-exit.
     move     "DEFAULT PRIVILEGES" to pr-buffer (8:18).
     move     ws-privileges to pr-buffer (28:80).
     perform  3000-print-line thru 3090-exit.
     move     "TABLE-COMMENT" to pr-buffer (13:13).
     move     tb-table-comment to pr-buffer (28:80).
     perform  3000-print-line thru 3090-exit.
     inspect  pr-buffer replacing all " " by "*".
     perform  3000-print-line thru 3090-exit.
     move     "N" to ws-switch-table.
*>
     display "." no advancing.
*>
     initialize ws-where.
     string   'TABLE_SCHEMA="'
              function trim (ws-name-data-base)
              '" and TABLE_name="'
              function trim (tb-table-name)
              '"'
                   into ws-where.
*>  /MYSQL SELECT\
*>
*>    Select rows
*>
*>      TABLE=COLUMNS
           INITIALIZE WS-MYSQL-COMMAND
           STRING "SELECT * FROM "
             "`COLUMNS`"
             " WHERE "
             WS-WHERE
            ";"  X"00" INTO WS-MYSQL-COMMAND
           PERFORM MYSQL-1210-COMMAND THRU MYSQL-1219-EXIT
           PERFORM MYSQL-1220-STORE-RESULT THRU MYSQL-1239-EXIT
           MOVE WS-MYSQL-RESULT TO TP-COLUMNS
*>  /MYSQL-END\
     if       ws-mysql-count-rows = zero     *>   not > zero
              go to 2010-fetch-tables-loop.
     initialize pr-buffer.
     move     "NULL" to pr-buffer (51:4).
     move     "TYPE" to pr-buffer (56:4).
     move     "SIZE" to pr-buffer (67:4).
     move     "LEFT" to pr-buffer (72:4).
     move     "  RT" to pr-buffer (77:4).
     move     "TYPE" to pr-buffer (82:4).
     move     "KEY" to pr-buffer (105:3).
     perform  3000-print-line thru 3090-exit.
 2110-fetch-columns-loop.
*>  /MYSQL FETCH\
*>
*>    Fetch next record
*>
*>      TABLE=COLUMNS
           MOVE TP-COLUMNS TO WS-MYSQL-RESULT
           CALL "MySQL_fetch_record" USING WS-MYSQL-RESULT
                    CB-TABLE-CATALOG
                    CB-TABLE-SCHEMA
                    CB-TABLE-NAME
                    CB-COLUMN-NAME
                    CB-ORDINAL-POSITION
                    CB-COLUMN-DEFAULT
                    CB-IS-NULLABLE
                    CB-DATA-TYPE
                    CB-CHARACTER-MAXIMUM-LENGTH
                    CB-CHARACTER-OCTET-LENGTH
                    CB-NUMERIC-PRECISION
                    CB-NUMERIC-SCALE
                    CB-DATETIME-PRECISION
                    CB-CHARACTER-SET-NAME
                    CB-COLLATION-NAME
                    CB-COLUMN-TYPE
                    CB-COLUMN-KEY
                    CB-EXTRA
                    CB-PRIVILEGES
                    CB-COLUMN-COMMENT
                    CB-IS-GENERATED
                    CB-GENERATION-EXPRESSION

*>  /MYSQL-END\
     if       return-code = -1
              go to 2010-fetch-tables-loop.
     initialize pr-buffer.
     perform  3000-print-line thru 3090-exit.
     move     cb-column-name to pr-buffer.
     move     cb-is-nullable to pr-buffer (51:4).
     move     cb-data-type to pr-buffer (56:10).
     move     cb-character-maximum-length to ws-ed3s.
     move     ws-ed3s to pr-buffer (67:4).
     subtract cb-numeric-scale from cb-numeric-precision giving ws-j.
     move     ws-j to ws-ed3s.
     move     ws-ed3s to pr-buffer (72:4).
     move     cb-numeric-scale to ws-ed3s.
     move     ws-ed3s to pr-buffer (77:4).
     move     cb-column-type to pr-buffer (82:22).  *> size+2
     move     cb-column-key to pr-buffer (105:3).
*>
     move     cb-column-name to ws-ca-column-name.
     move     cb-data-type to ws-ca-data-type.
     move     cb-character-maximum-length  to ws-ca-character-maximum-length.
     move     cb-numeric-precision to ws-ca-numeric-precision.
     move     cb-numeric-scale to ws-ca-numeric-scale.
     move     spaces to ws-ca-picture.
     move     cb-Column-Type to ws-ca-Column-Type.
*>
*>    Now build the cobol data definitions for the tables and columns
*>
*>    Date items do not show precision in the schema
*>
     evaluate ws-ca-data-type
       when "date"
              move 10 to ws-ca-character-maximum-length
       when "datetime"
              move 19 to ws-ca-character-maximum-length
       when "time"
              move 10 to ws-ca-character-maximum-length
       when "timestamp"
              move 19 to ws-ca-character-maximum-length
       when "year"
              move 4 to ws-ca-character-maximum-length
       when "bigint"
              move 18 to ws-ca-numeric-precision
     end-evaluate.
*>
*>         Decimal items need to have their lengths fixed
*>
     evaluate ws-ca-data-type
       when "dec"
       when "decimal"
              subtract ws-ca-numeric-scale from ws-ca-numeric-precision
     end-evaluate.
     evaluate ws-ca-data-type
       when "blob"
       when "char"
       when "date"
       when "datetime"
       when "mediumblob"
       when "mediumtext"
         when "longtext"
       when "text"
       when "time"
       when "timestamp"
       when "tinyblob"
       when "tinytext"
       when "varchar"
       when "year"
              move ws-ca-character-maximum-length to ws-ed8
              string "PIC X("
                     function trim (ws-ed8)
                     ")"
                         into ws-ca-picture
       when "bigint"
       when "decimal"
       when "int"
       when "integer"
       when "mediumint"
       when "numeric"
       when "smallint"
       when "tinyint"
              move ws-ca-numeric-precision to ws-ed2
              move ws-ca-numeric-scale to ws-ed2-second
              move zero to ws-A
              inspect  ws-ca-column-type tallying ws-A for all "unsigned"
              if ws-A = zero
                    move "PIC S9(XX) COMP" to ws-ca-picture
              else  move "PIC  9(XX) COMP" to ws-ca-picture
              end-if
  *>*>            move "PIC S9(XX) COMP" to ws-ca-picture
              move ws-ed2 to ws-ca-picture (8:2)
              if   ws-ca-numeric-scale not = zero
                   move "V9(XX) COMP" to ws-ca-picture (11:11)
                   move ws-ed2-second to ws-ca-picture (14:2)
              end-if
       when other
              display " "
              display "T) CANNOT HANDLE DATA TYPE FOR "
                      ws-ca-column-name
                      " DataType = "
                      ws-ca-data-type
              close print-file
              stop run
     end-evaluate.
     move     ws-ca-picture to pr-buffer (109:25).
     perform  3000-print-line thru 3090-exit.
     if       cb-column-default not = spaces
        and   cb-column-default (1:1) is not less than space
              move "COLUMN-DEFAULT" to pr-buffer (40:14)
              move cb-column-default to pr-buffer (60:70)
              perform 3000-print-line thru 3090-exit.
     if       cb-character-set-name is not equal to spaces
       and    cb-character-set-name (1:1) is not less than space
       and    cb-character-set-name not = ws-character-set-name
              move "CHARACTER-SET-NAME" to pr-buffer (36:18)
              move cb-character-set-name to pr-buffer (60:70)
              perform 3000-print-line thru 3090-exit.
     if       cb-collation-name is not equal to spaces
       and    cb-collation-name (1:1) is not less than space
       and    cb-collation-name is not equal to ws-collation-name
              move "COLLATION-NAME" to pr-buffer (40:14)
              move cb-collation-name to pr-buffer (60:70)
              perform 3000-print-line thru 3090-exit.
     if       cb-extra is not equal to spaces
              move "EXTRA" to pr-buffer (49:5)
              move cb-extra to pr-buffer (60:20)
              perform 3000-print-line thru 3090-exit.
     if       cb-privileges is not equal to spaces
       and    cb-privileges is not equal to ws-privileges
         then move "PRIVILEGES" to pr-buffer (44:10)
              move cb-privileges to pr-buffer (60:70)
              perform 3000-print-line thru 3090-exit.
     if       cb-column-comment is not equal to spaces
              move "COLUMN-COMMENT" to pr-buffer (40:14)
              move cb-column-comment to pr-buffer (60:70)
              perform 3000-print-line thru 3090-exit.
     go to    2110-fetch-columns-loop.
*>
*>    Print a single line
*>
 3000-print-line.
     if       ws-line-counter is greater than 110
              move pr-buffer to ws-print-record-hold
              perform 3100-headings thru 3190-exit
              move ws-print-record-hold to pr-buffer.
     write    print-record after advancing 1 line.
     add      1 to ws-line-counter.
     initialize pr-buffer.
 3090-exit.
     exit.
*>
*>    page headings
*>
 3100-headings.
     initialize ws-heading-buffer.
     add      1 to ws-page-number.
     if       ws-Page-Number not = 1         *>  Gives cleaner schema.t for reading
              move spaces to Print-Record
              write Print-Record after 1.
     move     ws-name-program to ws-heading-buffer.
     move     "--" to ws-heading-buffer (17:2).
     move     ws-name-data-base to ws-heading-buffer (20:32).
     move     "PAGE " to ws-heading-buffer (124:5).
     move     ws-page-number to ws-ed3s.
     move     ws-ed3s to ws-heading-buffer (129:4).
     accept   ws-date from date YYYYMMDD.
     accept   ws-time from time.
*>
     if       LTZ-USA
              string   ws-date (5:2)   *> MM
                       "/"
                       ws-date (7:2)   *> DD
                       "/"
                       ws-date (1:4)   *> CCYY
                              into ws-heading-buffer (98:10)
     else
      if      LTZ-UK
              string   ws-date (7:2)   *> DD
                       "/"
                       ws-date (5:2)   *> MM
                       "/"
                       ws-date (1:4)   *> CCYY
                              into ws-heading-buffer (98:10)
     else
              string   ws-date (1:4)   *> CCYY
                       "/"
                       ws-date (5:2)   *> MM
                       "/"
                       ws-date (7:2)   *> DD
                              into ws-heading-buffer (98:10).
*>
     move     ws-time to ws-ed-time.
     move     ws-ed-time (1:8) to ws-heading-buffer (110:8).
     inspect  ws-heading-buffer (110:8) replacing
                 all " " by ":".
     if       ws-page-number is equal to 1
              write print-record from ws-heading-buffer
       else
              write print-record from ws-heading-buffer after advancing page.
     move     spaces to ws-heading-buffer.
     write    print-record from ws-heading-buffer after advancing 2 lines.
     move     5 to ws-line-counter.
     if       ws-switch-table is equal to "N"
              move "NULL" to pr-buffer (51:4)
              move "TYPE" to pr-buffer (56:4)
              move "SIZE" to pr-buffer (67:4)
              move "LEFT" to pr-buffer (72:4)
              move "  RT" to pr-buffer (77:4)
              move "TYPE" to pr-buffer (82:4)
              move "KEY" to pr-buffer (105:3)
              perform 3000-print-line thru 3090-exit
              perform 3000-print-line thru 3090-exit.
 3190-exit.
     exit.
*>
*>    End Of Job
*>
 7990-exit.
     exit.
*>***************************************************************
*>             termination                                      *
*>***************************************************************
 9000-end-of-program.
     move     9000 to ws-no-paragraph.
     close    print-file.
     call     "SYSTEM" using print-report.
*>
*>  /MYSQL CLOSE\
*>
*>    Close the Database
*>
           PERFORM MYSQL-1980-CLOSE THRU MYSQL-1999-EXIT
*>  /MYSQL-END\
     display  " ".
     display  "I) " ws-name-program " COMPLETED NORMALLY AT--"
              function current-date.
     stop run.
 9990-exit.
     exit.
*>
*>  /MYSQL PRO\
 COPY "mysql-procedures.cpy".
*>  /MYSQL-END\
