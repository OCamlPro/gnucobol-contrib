       IDENTIFICATION DIVISION.
       PROGRAM-ID.    Presql2Maria.
      *AUTHOR.        J C CURREY.
      *UPDATES.       Vincent B Coen, Applewood Computers.
      *               and many others.
      ***
      * Security.     Copyright (C) 2009-2016, Jim Currey.
      *               Distributed under the GNU General Public License
      *               v2.0. See the file COPYING for details.
      ***
      * Version.       See WS-Prog-Version in Ws.
      * CALLED BY.     None.
      * CALLED AS.
      *                presql  and enter param by hand
      *                          OR
      *                presql inputfile outputfile src-format
      *
      *                Note that in and out files must not have
      *                the same names.
      *                if no files are specified the files will
      *                  be requested.
      *                third param = spaces
      *
      *                              FIXED | fixed
      *                              FREE  | FREE
      *
      *                program will also look for line 1 in
      *                source file to be a compiler directive as
      *     >>SOURCE FREE|FIXED starting in CC8
      *
      * Error messages used.
      *      See Working storage under Error-Messages
      *                            and Warning Messages.
      ************************************************************
      *  ***********  WARNING **** This program only accepts     *
      *                  FIXED format sources   *************    *
      *  Updated in v1.12 to accept both fixed and free          *
      *   but all MYSQL commands must still be in UPPER CASE     *
      *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
      *
      *************************************************************
      *  CHANGE the items at lines 340/346 under
      *                0000-MAIN SECTION
      *       to reflect your MySql site requirements
      *  For presql v2 these are taken from a file found within the
      *   current working directory so this requirement is no longer
      *    needed BUT the version of cobmysqlapi (taken from dbpre)
      *     MUST be used instead of cobmysqlapi.005.c and this is
      *      included in the archive.
      *
      *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
      *                                                                *
      *      SQL PRE PROCESSOR FOR OPEN COBOL 1.1                      *
      *                            GNU Cobol 2.0                       *
      *                                                                *
      *      THIS PROGRAM READS A COBOL SOURCE FILE WITH SQL           *
      *        PRE PROCESSOR STATEMENTS IN IT AND CREATES AN           *
      *        OUTPUT FILE WITH THE PRE PROCESSOR STATEMENTS           *
      *        HAVING BEEN COMMENTED AND REPLACED WITH THE             *
      *        APPROPRIATE CODE.  THE OUTPUT FILE CAN THEN BE          *
      *        COMPILED BY THE OPEN Gnu COBOL COMPILER                 *
      *                                                                *
      *      SINCE THIS PROGRAM WILL PROBABLY BE ADDED TO OVER         *
      *        TIME, THE PROGRAMMER SHOULD RECORD THE VERSION          *
      *        NUMBER OF THE PRE PROCESSOR IN THE COMMENTS AT THE      *
      *        BEGINNING OF THE SOURCE PROGRAM SO THAT THE             *
      *        CORRECT VERSION OF THE PRE PROCESSOR CAN BE RUN         *
      *        AGAINST THE SOURCE FILE                                 *
      *                                                                *
      *      NOTE THAT WHEN PRINTING THIS PROGRAM WITH "PRTCBL"        *
      *        PRTCBL WILL DUTIFULLY INCLUDE THE COPYBOOKS FOR         *
      *        MYSQL-VARIABLES AND MYSQL-PROCEDURES SINCE THIS         *
      *        PROGRAM GENERATES A COPY STATEMENT FOR EACH OF          *
      *        THEM AND PLACES IT IN THE OUTPUT FILE                   *
      *                                                                *
      *  Changes:
      *   VERSION 001--ORIGINAL VERSION                                *
      *                                                                *
      *                 UNSUPPORTED COLUMN TYPES ARE IGNORED           *
      *                 (BLOB, MEDIUMBLOB, MEDIUMTEXT, TEXT)           *
      *                                                                *
      *                 JANUARY, 2010--J C CURREY                      *
      *                                                                *
      *   VERSION 002--ADDS SUPPORT FOR MULTIPLE DATA BASES            *
      *                MARCH 21, 2010--J C CURREY                      *
      *                                                          *******
      *                                                                *
      *   VERSION 003--CHANGES TO REPLACE SPACES IN COLUMN NAMES       *
      *                BEFORE OUTPUT TO THE OUTPUT-FILE FOR COBOL      *
      *                VARIABLE NAMES                                  *
      *                1344794--JIM CURREY                             *
      *                04/15/2010--SANDY DOSS                          *
      *                                                                *
      *   VERSION 004--CHANGED TO SURROUND TABLE AND COLUMN NAMES      *
      *                WITH BACKTICS WHEN OUTPUTTING SQL               *
      *                STATEMENTS, REPLACE SPACES WITH DASHES IN       *
      *                TABLE NAMES WHEN OUTPUTTING TD- AND TP-,        *
      *                PLACE PICS IN COLUMN 50.                        *
      *                1344794--SANDY DOSS                             *
      *                04/20/2010--JOSE ROSADO                         *
      *                                                                *
      *   VERSION 005--REMOVED OUTPUTTING OF STRING STATEMENT          *
      *                THAT PLACES NEGATIVE SIGN IN FRONT OF           *
      *                NEGATIVE VALUES; IN 5200-STRING-COLUMNS.        *
      *                1345281--SANDY DOSS                             *
      *                05/10/2010--JOSE ROSADO                         *
      *                                                                *
      *   VERSION 006--CHANGES MYSQL SOCKET FILE TO mysqld.sock        *
      *                NOTE: THESE COMMENTS, AND COMMENTED CODE        *
      *                FOR THIS CHANGE WERE DELETED 7/28/2010          *
      *                07/10/2010--SANDY DOSS                          *
      *                                                                *
      *   VERSION 006--MODIFIED TO ALERT USER IF 'MYSQL VAR'           *
      *                TABLE DOES NOT EXIST FOR SPECIFIED DB.          *
      *                1346707--JIM CURREY                             *
      *                07/28/2010--JEREMY MONTOYA                      *
      *                                                                *
      *   VERSION 008--CORRECTS VERSIONING - PREVIOUS VERSION IS       *
      *                NOW SAVED AS presql.007.cbl                     *
      *                CHANGES SELECT IN 2132-TABLE-LOOP TO USE        *
      *                FUNCTION TRIM ON TABLE_NAME COLUMN, AND TO      *
      *                INITIALIZE WS-MYSQL-COMMAND BEFORE STRING       *
      *                1353954--JIM CURREY                             *
      *                11/14/2011--SANDY DOSS                          *
      *                                                                *
      * 151016 vbc - 009 Added support for longtext as for medium      *
      *                Added debug displays to help tracing            *
      *                  rem'd out                                     *
      *                Added close files before STOP RUN o/p           *
      *                  might be useful for debugging.                *
      *                Changed comments to lowercase when going        *
      *                through the code for other changes which makes  *
      *                it easier to read & change versioning comments. *
      *                date at the top in form yymmdd with             *
      *                programmer initials                             *
      *                                                                *
      * 151019 vbc - 010 Changed Mysql params for VBC test Env         *
      *                likewise for ACS env.                           *
      *                Added comments about GC v2 and fixed            *
      *                format Cobol sources only                       *
      *                                                                *
      * 160605 vbc - 011 Removed a dup IF statement-No not me!         *
      *                modified for using command to have the          *
      *                parameters when called.                         *
      *                Called by:                                      *
      *                presql inputfile outputfile                     *
      *                                                                *
      *                Note that in and out files must NOT have        *
      *                the same name/extensions.                       *
      *                                                                *
      * 160612 vbc - 1.12 Coding for FREE source input including       *
      *                renumbered to 1.12                              *
      *                                                                *
      *                FIXED format                                    *
      *                third param = spaces | blank                    *
      *                              FIXED | fixed                     *
      *                              FREE  | FREE                      *
      *                Problem will be the floating '*>'               *
      *                so new code for this.                           *
      *                presql will look for compiler directive         *
      *                within first TWO lines containing               *
      *                >>SOURCE FIXED|FREE upper or lower case.        *
      *                Support for warning/error message tables to     *
      *                allow for messages in other languages.          *
      *                Increased these comment lines to cc72.          *
      *                                                                *
      * 160622 vbc - 1.13 Changed ALL created/generated cobol statements *
      *                to have NO periods at end of each procedure     *
      *                statement. This way they can be inbedded within *
      *                a IF or EVALUATE statement.                     *
      *                Programmer MUST remember to terminate with      *
      *                a "." when required.                            *
      *                                                                *
      * 160817 vbc - 1.14 Test for lines 1 or 2 for FULL >>source      *
      *                Rem'd out dup initialise at start               *
      *                variations 'FORMAT FIXED|FREE'                  *
      *                           'FORMAT IS FIXED|FREE'               *
      *                Extra comments below for changes required       *
      *                before compiling presql                         *
      *                                                                *
      *        vbc - 1.15 Cosmetic - Add an 'e' to Curry > Currey.     *
      *                Clean up a debug block that displays the        *
      *                found VAR tables (not spaces) and is rem'd out. *
      *                                                                *
      * 160830 vbc - 2.16 This version will read a file containing the *
      *                six RDB parameters e.g.,                        *
      * DBHOST=localhost                                               *
      * DBUSER=root                                                    *
      * DBPASSWD=PaSsWoRd                                              *
      * DBNAME= any as over ridden                                     *
      * DBPORT=03306                                                   *
      * DBSOCKET=/home/mysql/mysql.sock                                *
      *    in file presql2.param                                       *
      *                                                                *
      *  Then issues a call to the dbpre version (ONLY) of cobmysqlapi *
      *   to read in this file that MUST be in the working directory.  *
      *                                                                *
      *  This way presql can be used for more than one MySQL server on *
      *   more than one system within a LAN.                           *
      *    See the example file called presql2.param                   *
      *                                                                *
      *  TO BE DONE:                                                   *
      *               Support for lower-case /MYSQL commends e.g.,     *
      *                                       /mysql init\             *
      *      For the moment this is somewhat long winding so will put  *
      *      it on the back burner.                                    *
      *                                                                *
      *                                                                *
      * 161108 vbc - 2.17 Now have two versions of presql2 namely :    *
      *            presql2Maria for MariaDB has one more column in     *
      *             information_schema                                 *
      *            presql2Mysql for MySQL.                             *
      *                                                                *
      * 162220 vbc - 2.18 Signed comp values now has a test to check if   *
      *            unsigned is set in ws-ca-column-type (WS-I) & if so *
      *            removes the sign 'S' see low in 2142-FIELD-LOOP.    *
      *            same as prtschema2M & prtschema2o                   *
      *
      * 161112 vbc - 2.19 Modified all reads to have spaces in buffer.
      *             test for fixed free after each.
      *             changed free test at 8000 as needed a rewrite.
      *
      * 170103 vbc - 2.20 Removed start/end displays along with the RDB
      *              params & added name of source prog compiling.
      *
      ******************************************************************
      *
      * COPYRIGHT NOTICE.
      ******************
      *
      * This file/program is part of the Mysql pre-processor presql
      * and is copyright (c) Jim Currey. 2009-2017 and later.
      *
      * This program is free software; you can redistribute it and/or
      * modify it under the terms of the GNU General Public License as
      * published by the Free Software Foundation; version 2 ONLY.
      *
      * The Presql package is distributed in the hope that it will be
      * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
      * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      * See the GNU General Public License for more details.
      * If it breaks, you own both pieces but I will endevor to fix it,
      * providing you tell me about the problem.
      *
      * You should have received a copy of the GNU General Public License
      * along with the package; see the file COPYING.
      * If not, write to the Free Software Foundation, 59 Temple Place,
      *  Suite 330, Boston, MA 02111-1307 USA.
      ********************************************************************
      *
      *
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE  ASSIGN       WS-NAME-INPUT-FILE
                              ORGANIZATION LINE SEQUENTIAL
                              FILE STATUS  WS-INPUT-FILE-STATUS.
      *
           SELECT OUTPUT-FILE ASSIGN       WS-NAME-OUTPUT-FILE
                              ORGANIZATION LINE SEQUENTIAL
                              FILE STATUS  WS-OUTPUT-FILE-STATUS.
       DATA DIVISION.
       FILE SECTION.
      *
       FD  INPUT-FILE.
       01  INPUT-RECORD.
           05  IR-BUFFER                 PIC X(256).

       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD.
           05  OR-BUFFER                 PIC X(256).

       WORKING-STORAGE SECTION.
      ****************************************************
      *   CONSTANTS, COUNTERS AND WORK AREAS             *
      ****************************************************
160612 01  WS-NAME-PROGRAM.
160612     03  WS-Program-Name              pic x(8) value "presql2M".
160830     03  ws-Prog-Version              pic x(6) value " 2.20 ".
      *> needed 4 read-params call.
160830 01  ws-parm-prog-name                pic x(8) value "presql2M".
      *
       01  WS-NO-PARAGRAPH                  PIC S9(4) COMP value zero.
161112 01  WS-LLength                       pic 9(4)  comp value zero.
160612 01  WS-A                             PIC 9(4)  COMP value zero.
160612 01  WS-B                             PIC 9(4)  COMP value zero.
160612 01  WS-C                             PIC 9(4)  COMP value zero.
161112 01  WS-D                             PIC 9(4)  COMP value zero.
160612 01  WS-Line-Length                   pic 9(4)  comp value zero.
       01  WS-I                             PIC S9(4) COMP.
       01  WS-J                             PIC S9(4) COMP.
       01  WS-K                             PIC S9(4) COMP.
041510*01  WS-L                             PIC S9(4) COMP.
       01  WS-NAME-INPUT-FILE               PIC X(64)      VALUE SPACES.
       01  WS-INPUT-FILE-STATUS             PIC XX.
       01  WS-NAME-OUTPUT-FILE              PIC X(64)      VALUE SPACES.
       01  WS-OUTPUT-FILE-STATUS            PIC XX.
160612 01  ws-Source-Format                 pic x(5)      value "FIXED".
           88  Source-Fixed                       value "FIXED" "fixed".
           88  Source-Free                        value "FREE" "free".
160612 01  WS-Comment-Found                 PIC 9          value zero.
           88  Comment-Found                               value 1.
       01  WS-RECORD-NUMBER                 PIC S9(6) COMP VALUE ZERO.
       01  WS-SWITCH-VAR                    PIC X          VALUE "N".
      *01  WS-SWITCH-INIT                   PIC X          VALUE "N".
       01  WS-SWITCH-GOT-BASE               PIC X          VALUE "N".
       01  WS-SWITCH-GOT-TABLE-NAME         PIC X          VALUE "N".
       01  WS-SWITCH-GOT-WHERE              PIC X          VALUE "N".
       01  WS-SWITCH-DID-VARIABLES          PIC X          VALUE "N".
       01  WS-SWITCH-FOUND-BASE             PIC X          VALUE "N".
       01  WS-LAST-MYSQL-COMMAND            PIC X(16).
       01  WS-TABLE-WANTED                  PIC X(64).
042010 01  WS-TEMP-TABLE-NAME               PIC X(64).
       01  WS-COLUMN-WANTED                 PIC X(64).
041510*01  WS-TEMP-COLUMN-NAME              PIC X(32).
042010 01  WS-TEMP-COLUMN-NAME              PIC X(27).
       01  WS-LEFT-POSITION-START           PIC S99.
      *01  WS-COMBINED-NUMERIC-LENGTH       PIC S99.
       01  WS-ED2                           PIC 99.
       01  WS-ED2-SECOND                    PIC 99.
       01  WS-ED6S                          PIC Z(4)9-.
       01  WS-ED8                           PIC Z(7)9.
       01  WS-BASE-WANTED                   PIC X(64).
       01  WS-TABLE-WORK                    PIC X(64).
       01  WS-TABLE-PREFIX-WORK             PIC X(4).
      *
       01  WS-HOST                          PIC X(64)      VALUE SPACE.
       01  WS-IMPLEMENTATION                PIC X(64)      VALUE SPACE.
       01  WS-PASSWORD                      PIC X(64)      VALUE SPACE.
       01  WS-PORT                          PIC X(4)       VALUE SPACE.
       01  WS-SOCKET                        PIC X(64)      VALUE SPACE.
       01  WS-RUNTIME                       PIC X          VALUE "N".
      *
       01  WS-IR-Buffer                     pic x(256).
      *
151019* 01  CC-MYSQL-HOST-NAME               PIC X(64).
151019* 01  CC-MYSQL-IMPLEMENTATION          PIC X(64).
151019* 01  CC-MYSQL-PASSWORD                PIC X(64).
151019* 01  CC-MYSQL-BASE-NAME               PIC X(64).
151019* 01  CC-MYSQL-PORT-NUMBER             PIC X(4).
151019* 01  CC-MYSQL-SOCKET                  PIC X(64).
      *
      *
160612 01  Warning-Messages.
           03  PSW001  pic x(27) value "PSW001 Input file not found".
           03  PSW002  pic x(53) value
               "PSW002 Input & Output file names must not be the same".
           03  PSW003  pic x(17) value " Beginning at -- ".
           03  PSW004  pic x(26) value " Completed normally at -- ".
       01  Error-Messages.
           03  PSE001  pic x(39) value
               "PSE001 Cannot open output file, Status=".
           03  PSE002  pic x(42) value
               "PSE002 Un-Terminated /MYSQL VAR\ Construct".
           03  PSE003  pic x(49) value
               "PSE003 Must have base statement after /MYSQL VAR\".
           03  PSE004  pic x(33)  value
               "PSE004 Invalid command at record=".
           03  PSE005  pic x(39)  value
               "PSE005 Table prefix too long at record=".
           03  PSE006  pic x(36)  value
               "PSE006 Invalid table spec at record=".
           03  PSE007  pic x(26)  value "PSE007 More than 32 Tables".
           03  PSE008A pic x(14)  value "PSE008 Table '".
           03  PSE008B pic x(41)  value
               "' Does not exist in MYSQL VAR Definition ".
           03  PSE009A pic x(39)  value
               "PSE009 Unsupported data type in column ".
           03  PSE009B pic x(10)  value " of Table=".
           03  PSE010A pic x(35)  value
               "PSE010 Cannot handle data type for ".
           03  PSE010B pic x(12)  value " DataType = ".
           03  PSE011  pic x(43)  value
               "PSE011 Input file NOT available at 2090-EOF".
           03  PSE012  pic x(41)  value
               "PSE012 No table for MYSQL DEFINE at line=".
           03  PSE013  pic x(39)  value
               "PSE013 Table prefix too long at record=".
           03  PSE014  pic x(30)  value
               "PSE014 Invalid spec at record=".
           03  PSE015A pic x(23)  value
               "PSE015 Table not found=".
           03  PSE015B pic x(11)  value " at record=".
           03  PSE016  pic x(41)  value
               "PSE016 No table for MYSQL DELETE at line=".
           03  PSE017  pic x(23)  value "PSE017 Table not found=".
           03  PSE018  pic x(42)  value
               "PSE018 Nowhere for MYSQL DELETE at record=".
           03  PSE019  pic x(40)  value
               "PSE019 No table for MYSQL FETCH at line=".
           03  PSE020  pic x(39)  value
               "PSE020 No table for MYSQL FREE at line=".
           03  PSE021  pic x(40)  value
               "PSE021 No base name specified at record=".
           03  PSE022  pic x(41)  value
               "PSE022 No table for MYSQL INSERT at line=".
           03  PSE023  pic x(41)  value
               "PSE023 No table for MYSQL SELECT at line=".
           03  PSE024  pic x(42)  value
               "PSE024 Nowhere for MYSQL SELECT at record=".
           03  PSE025  pic x(41)  value
               "PSE025 No table for MYSQL UPDATE at line=".
           03  PSE026  pic x(42)  value
               "PSE026 Nowhere for MYSQL UPDATE at record=".
           03  PSE027  pic x(60)  value
               "PSE027 Must have BASE statement after /MYSQL VAR\ at " &
               "record=".
           03  PSE028  pic x(27)  value "PSE028 Could not find BASE=".
           03  PSE029  pic x(39)  value
               "PSE029 No table for MYSQL LOCK at line=".
           03  PSE030A pic x(22)  value 'PSE030 Un-terminated "'.
           03  PSE030B pic x(20)  value '" at record number='.
      *
      *    MYSQL Column Buffer
      *
       01  COLUMN-BUFFER.
           05  CB-COLUMN-NAME               PIC X(64).
           05  CB-COLUMN-TYPE               PIC X(4096).  *> New vbc 161110/161113
           05  CB-DATA-TYPE                 PIC X(64).
           05  CB-CHARACTER-MAXIMUM-LENGTH  PIC S9(19).
           05  CB-NUMERIC-PRECISION         PIC S9(19).
           05  CB-NUMERIC-SCALE             PIC S9(19).
      *
      *  These variables will contain the information relating
      *    to the tables and columns being used in the program
      *
       01  WS-TABLES-USED.
           05  WS-TABLE-ARRAY-HIGH-POINT    PIC S9(4) COMP.
           05  WS-BASE-NAME-ARRAY           PIC X(64)      OCCURS 32.
           05  WS-TABLE-ARRAY               PIC X(64)      OCCURS 32.
           05  WS-TABLE-PREFIX              PIC X(6)       OCCURS 32.
           05  WS-TABLE-START               PIC S9(4) COMP OCCURS 32.
       01  WS-COLUMN-ARRAY-BUFFER.
           05  WS-CA-HIGH-POINT             PIC S9(4) COMP.
           05  WS-CA-COLUMN-NAME            PIC X(32)      OCCURS 1024.
           05  WS-CA-COLUMN-TYPE            PIC X(32)       occurs 1024.  *> New vbc 161110
           05  WS-CA-DATA-TYPE              PIC X(12)      OCCURS 1024.
           05  WS-CA-CHARACTER-MAXIMUM-LENGTH PIC S9(19)   OCCURS 1024.
           05  WS-CA-NUMERIC-PRECISION      PIC S9(19)     OCCURS 1024.
           05  WS-CA-NUMERIC-SCALE          PIC S9(19)     OCCURS 1024.
           05  WS-CA-PICTURE                PIC X(32)      OCCURS 1024.
      *
       COPY MYSQL-VARIABLES.
      ****************************************************************
      *                Procedure division                            *
      ****************************************************************
       PROCEDURE DIVISION chaining ws-name-input-file
                                   ws-name-output-file
                                   ws-Source-Format.
       0000-MAIN SECTION.
           PERFORM  1000-INITIALIZATION THRU 1990-EXIT.
           PERFORM  2000-PROCESS THRU 7990-EXIT.
           PERFORM  9000-END-OF-PROGRAM THRU 9990-EXIT.
           STOP     RUN.
      ****************************************************************
      *               Initialization                                 *
      ****************************************************************
       1000-INITIALIZATION.
           MOVE     1000 TO WS-NO-PARAGRAPH.
160612*    if       function upper-case (ws-name-input-file)
170103*                              not = "HELP"
170103*             DISPLAY  "I) " WS-NAME-PROGRAM
170103*                      PSW003 FUNCTION CURRENT-DATE
170103*    end-if
           INITIALIZE
                    WS-TABLES-USED
                    WS-COLUMN-ARRAY-BUFFER.
      *
           if       function upper-case (ws-name-input-file) = "HELP"
                    display WS-NAME-PROGRAM " - - help "
                    display "       P1 = Input File Name  "
                    display "       P2 = Output File Name "
                    display "       P3 = fixed | FIXED | free | FREE "
                    display " "
                    stop run
           end-if
           if       ws-name-input-file not = spaces
                and ws-name-output-file not = spaces
                and ws-name-input-file not = ws-name-output-file
                    open input  Input-File
                    if   ws-Input-File-Status = 35
                         go to 1003-Error-35
                    end-if
                    open output Output-File
                    if   ws-Output-File-Status not = zero
                         go to 1004-Error-Non-Zero
                    end-if
                    go to 1005-Init
           end-if.
       1002-GET-INPUT-FILE.
           DISPLAY  "A) Enter Input File Name " WITH NO ADVANCING.
           ACCEPT   WS-NAME-INPUT-FILE.
           OPEN     INPUT INPUT-FILE.
       1003-Error-35.
           IF       WS-INPUT-FILE-STATUS = 35
160612              DISPLAY PSW001
                    GO TO 1002-GET-INPUT-FILE.
           DISPLAY  "A) Enter Output File name " WITH NO ADVANCING.
           ACCEPT   WS-NAME-OUTPUT-FILE.
           IF       WS-NAME-INPUT-FILE = WS-NAME-OUTPUT-FILE
                    CLOSE INPUT-FILE
160612              DISPLAY PSW002
                    GO TO 1002-GET-INPUT-FILE.
           OPEN OUTPUT OUTPUT-FILE.
       1004-Error-Non-Zero.
           IF       WS-OUTPUT-FILE-STATUS IS NOT EQUAL TO ZERO
160612              DISPLAY PSE001 WS-OUTPUT-FILE-STATUS
                    close Input-File
                    STOP RUN.
      *
160612 1005-Init.
      *     INITIALIZE
160817*              WS-TABLES-USED.       *> Done earlier
170103     display  WS-NAME-PROGRAM " compiling " ws-name-input-file.
           MOVE     1 TO WS-TABLE-ARRAY-HIGH-POINT.
       1990-EXIT.
           EXIT.
      **************************************************************
      *                 Detail section                             *
      **************************************************************
       2000-PROCESS.
           MOVE 2000 TO WS-NO-PARAGRAPH.
      *
      ******************************************************************
      *    Find the /MYSQL VAR\ statements & build the table of tables.
      *
      *    O/P file not produced here - just creates the tables needed
      *     into the WS.
      *  The I/P file will be closed and re-opened later on
      *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      *
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 2130-ENDER.
           ADD      1 TO WS-Record-Number.
      *
      *  But first
      * Check for a '>>SOURCE' compiler directive lines 1 or 2
      *  yes a bit simple but KISS rules :)
      *
           if       WS-Record-Number < 3
            if      function upper-case (IR-Buffer (8:14))
                                        = ">>SOURCE FREE "
160817          or  function upper-case (IR-Buffer (8:21))
160817                                  = ">>SOURCE FORMAT FREE "
                 or function upper-case (IR-Buffer (8:24))
                                        = ">>SOURCE FORMAT IS FREE "
                    move "FREE" to ws-Source-Format
161112              go to 2000-Process
            else if function upper-case (IR-Buffer (8:14))
                                        = ">>SOURCE FIXED"
160817           or function upper-case (IR-Buffer (8:21))
160817                                  = ">>SOURCE FORMAT FIXED"
                 or function upper-case (IR-Buffer (8:24))
                                        = ">>SOURCE FORMAT IS FIXED"
                    move "FIXED" to ws-Source-Format
161112              go to 2000-Process.
      *
      **************************************************************
      * Here we need to add in tests for fixed / free and if free
      *  do separate processing.
      * Likewise for all of the others doing the same test for '*'
      *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      *
160612     if       Source-Fixed
              and   IR-BUFFER (7:1) = "*"
                    GO TO 2000-PROCESS.
160612     if       Source-Free
                    perform 8000-Find-Comment-Lines thru 8010-Exit
                    if      Comment-Found
                            go to 2000-Process.
      *
160612     if       Source-Fixed
                    move 72 to ws-Line-Length.
160612     if       Source-Free
161112              move WS-LLength to ws-Line-Length.
      *
           MOVE ZERO TO WS-I.
160612     INSPECT IR-BUFFER (1:ws-Line-Length)
                   TALLYING WS-I FOR ALL "/MYSQL VAR\".
161113     IF      WS-I not = zero         *> Could have more than one !
                   MOVE "Y" TO WS-SWITCH-VAR
                   GO TO 2100-PROCESS-VAR.
           GO TO 2000-PROCESS.
      *
      *    Build table arrays
      *
       2100-PROCESS-VAR.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
160612              DISPLAY PSE002
151016              close input-file output-file
                    STOP RUN.
           ADD 1 TO WS-RECORD-NUMBER.
160612     IF       Source-Fixed
              and   IR-BUFFER (7:1) = "*"
                    GO TO 2100-PROCESS-VAR.
160612     if       Source-Free
                    perform 8000-Find-Comment-Lines thru 8010-Exit
                    if      Comment-Found
                            go to 2100-Process-Var.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "BASE=".
           IF       WS-I = 1
160612              if       Source-fixed
                             MOVE "      " TO IR-BUFFER (1:6)
                    end-if
                    MOVE FUNCTION SUBSTITUTE (IR-BUFFER," BASE="," ")
                                  TO IR-BUFFER
                    MOVE FUNCTION TRIM (IR-BUFFER)
                      TO WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT)
160612       ELSE   DISPLAY PSE003
151016              close input-file output-file
                    STOP RUN
           END-IF.
       2110-READ-LOOP.
           MOVE     2110 TO WS-NO-PARAGRAPH.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
160612     IF       Source-Fixed
              and   IR-BUFFER (7:1) = "*"
                    GO TO 2110-READ-LOOP.
160612     if       Source-Free
                    perform 8000-Find-Comment-Lines thru 8010-Exit
                    if      Comment-Found
                            go to 2110-Read-Loop.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
              GO TO 2000-PROCESS.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL " TABLE="
           IF       WS-I IS NOT EQUAL TO 1
                    MOVE WS-RECORD-NUMBER TO WS-ED6S
160612              DISPLAY PSE004, WS-ED6S
151016              close input-file output-file
                    STOP RUN.
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER," TABLE="," ")
                    TO IR-BUFFER.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WORK.
      *
      *    Specification Should Be TABLE-NAME,PRE(fix)
      *      Parse across to separate data items and validate
      *      syntax
      *
           MOVE "N" TO WS-SWITCH-GOT-TABLE-NAME.
           MOVE 1 TO WS-J.
       2112-PARSE-LOOP.
           EVALUATE WS-TABLE-WORK (WS-J:1)
             WHEN " "
               GO TO 2114-FINISHED
             WHEN ","
               MOVE "Y" TO WS-SWITCH-GOT-TABLE-NAME
               MOVE WS-TABLE-WORK (WS-J + 1: 64 - WS-J)
                 TO WS-TABLE-WORK
               MOVE ZERO TO WS-J
             WHEN OTHER
               IF   WS-SWITCH-GOT-TABLE-NAME IS EQUAL TO "N"
                    MOVE WS-TABLE-WORK (WS-J:1)
                        TO WS-TABLE-ARRAY (WS-TABLE-ARRAY-HIGH-POINT)
                             (WS-J:1)
                ELSE IF  WS-J IS GREATER THAN 4
                         MOVE WS-RECORD-NUMBER TO WS-ED6S
                         DISPLAY PSE005, WS-ED6S
151016                   close input-file output-file
                         STOP RUN
                      END-IF
                      MOVE WS-TABLE-WORK (WS-J:1)
                        TO WS-TABLE-PREFIX (WS-TABLE-ARRAY-HIGH-POINT)
                             (WS-J:1)
               END-IF
           END-EVALUATE.
       2114-FINISHED.
           ADD 1 TO WS-J.
           IF WS-J IS LESS THAN 65 GO TO 2112-PARSE-LOOP.
           IF WS-TABLE-ARRAY (WS-TABLE-ARRAY-HIGH-POINT)
             IS EQUAL TO SPACES GO TO 2116-ERROR.
           IF WS-TABLE-PREFIX (WS-TABLE-ARRAY-HIGH-POINT)
             IS EQUAL TO SPACES GO TO 2116-ERROR.
           GO TO 2118-CONTINUE.
       2116-ERROR.
           MOVE     WS-RECORD-NUMBER TO WS-ED6S.
160612     DISPLAY  PSE006, WS-ED6S.
151016     close    input-file output-file
           STOP RUN.
       2118-CONTINUE.
           IF WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT)
             IS EQUAL TO SPACES
               MOVE WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT - 1)
                 TO WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT).
           ADD 1 TO WS-TABLE-ARRAY-HIGH-POINT.
           IF       WS-TABLE-ARRAY-HIGH-POINT IS GREATER THAN 32
160612              DISPLAY PSE007
151016              close input-file output-file
                    STOP RUN.
           GO TO 2110-READ-LOOP.
      *
      *    Now we will open the mysql information schema,
      *      get the columns from each table in WS-TABLE-ARRAY,
      *      Determine their characteristics,
      *      and build the list of columns for each table
      *
       2130-ENDER.
           MOVE 1 TO WS-I.
       2131-ENDER.
      * Debug code [ ws-table-array-high-point is 1 higher than content]
      D    DISPLAY "D) WS-BASE-NAME-ARRAY=", WS-BASE-NAME-ARRAY (WS-I).
      D    DISPLAY "D) WS-TABLE-ARRAY=", WS-TABLE-ARRAY (WS-I).
      D    DISPLAY "D) WS-I=", WS-I.
      D    ADD      1 TO WS-I.
      D    IF       WS-I IS LESS THAN 33
      D        and  WS-I < WS-TABLE-ARRAY-HIGH-POINT
      D             GO TO 2131-ENDER.
      * End debug coding
      *
       2131-Get-RDB-Params.                  *> reads file presql2.param
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
      *
170103*    display "Using as RDB calls ".
170103*    display "Host=" WS-MYSQL-Host-Name.
170103*    display "BaseName=" WS-MYSQL-BASE-NAME.
170103*    display "User=" WS-MYSQL-Implementation.
170103*    display "Password=" WS-MYSQL-Password.
170103*    display "Port=" WS-MYSQL-Port-Number.
170103*    display "Socket=" WS-MYSQL-Socket.
170103*    display " ".

           PERFORM  MYSQL-1000-OPEN THRU MYSQL-1090-EXIT.
      *> Now = last table entry.
           SUBTRACT 1 FROM WS-TABLE-ARRAY-HIGH-POINT.
      *
      *    In the loops below:
      *      WS-I = Pointer to the table being processed
      *      WS-J = Pointer to the column being processed
      *
           MOVE 1 TO WS-I.
           MOVE 1 TO WS-J.
       2132-TABLE-LOOP.
           MOVE     2132 TO WS-NO-PARAGRAPH.
           MOVE     WS-J TO WS-TABLE-START (WS-I).
111411     MOVE     SPACE TO WS-MYSQL-COMMAND.
           STRING   "SELECT COLUMN_NAME, DATA_TYPE, ",
                    "CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, ",
                    "NUMERIC_SCALE, COLUMN_TYPE FROM COLUMNS WHERE ",
                    'TABLE_SCHEMA="',
                    FUNCTION TRIM (WS-BASE-NAME-ARRAY (WS-I)),
                    '" AND TABLE_NAME="',
111411              FUNCTION TRIM (WS-TABLE-ARRAY (WS-I)),
111411*               WS-TABLE-ARRAY (WS-I) DELIMITED BY SIZE,
                    '"',
                    X"00"
                               INTO WS-MYSQL-COMMAND
           END-STRING.
      D    display " Looking in for "
      D    display  WS-MYSQL-COMMAND (1:240).
      *
           PERFORM  MYSQL-1200-SELECT THRU MYSQL-1209-EXIT.
           PERFORM  MYSQL-1220-STORE-RESULT THRU MYSQL-1239-EXIT.
072810     IF       WS-MYSQL-COUNT-ROWS IS LESS THAN 1
072810              THEN DISPLAY PSE008A
072810                        FUNCTION TRIM(WS-TABLE-ARRAY ( WS-I ))
072810                     PSE008B
      D                     "=" ws-i
151016              close input-file output-file
072810              STOP RUN
072810	   END-IF.
       2134-COLUMN-LOOP.
           MOVE     2134 TO WS-NO-PARAGRAPH.
           CALL     "MySQL_fetch_row" USING WS-MYSQL-RESULT
                                            CB-COLUMN-NAME,
                                            CB-DATA-TYPE,
                                            CB-CHARACTER-MAXIMUM-LENGTH,
                                            CB-NUMERIC-PRECISION,
                                            CB-NUMERIC-SCALE,
                                            CB-COLUMN-TYPE.
           IF RETURN-CODE IS EQUAL TO -1
             ADD 1 TO WS-I
             IF WS-I IS GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
               THEN GO TO 2140-CONTINUE
               ELSE GO TO 2132-TABLE-LOOP
             END-IF
           END-IF.
      *
      *  (BLOB, MEDIUMBLOB, MEDIUMTEXT, TEXT)
      *
           EVALUATE CB-DATA-TYPE
             WHEN "blob"
	     WHEN "mediumblob"
      *      WHEN "mediumtext"
      *      WHEN "text"
                    DISPLAY PSE009A
                            FUNCTION TRIM (CB-COLUMN-NAME)
                            PSE009B
                            FUNCTION TRIM (WS-TABLE-ARRAY (WS-I))
151016              close input-file output-file
161113              STOP RUN
161113     end-evaluate.
           MOVE CB-COLUMN-NAME TO WS-CA-COLUMN-NAME (WS-J).
           MOVE CB-DATA-TYPE TO WS-CA-DATA-TYPE (WS-J).
           MOVE CB-CHARACTER-MAXIMUM-LENGTH
             TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-J).
           MOVE CB-NUMERIC-PRECISION TO WS-CA-NUMERIC-PRECISION (WS-J).
           MOVE CB-NUMERIC-SCALE TO WS-CA-NUMERIC-SCALE (WS-J).
           move CB-COLUMN-TYPE   to WS-CA-COLUMN-TYPE (WS-J).  *> vbc 161110
           ADD 1 TO WS-J.
           GO TO 2134-COLUMN-LOOP.
      *
      *    Now let's build the cobol data definitions for the
      *      tables and columns
      *
       2140-CONTINUE.
           MOVE WS-J TO WS-TABLE-START (WS-I).
           SUBTRACT 1 FROM WS-J GIVING WS-CA-HIGH-POINT.
           MOVE 1 TO WS-I.
151016D      display "D=  WS-I=", WS-I.
151016D      display "D=  WS-CA-DATA-TYPE=" WS-CA-DATA-TYPE (WS-I).
161113D      display "D=  WS-CA-COLUMN-TYPE=" WS-CA-COLUMN-TYPE (WS-I).
      *
       2142-FIELD-LOOP.
      *
      *   First evaluate for
      *   Date Items that do not show precision in the Schema
      *
           EVALUATE WS-CA-DATA-TYPE (WS-I)
             WHEN "date"
               MOVE 10 TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
             WHEN "datetime"
               MOVE 19 TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
             WHEN "time"
               MOVE 10 TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
             WHEN "timestamp"
               MOVE 19 TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
             WHEN "year"
               MOVE 4 TO WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
             WHEN "bigint"
               MOVE 18 TO WS-CA-NUMERIC-PRECISION (WS-I)
           END-EVALUATE.
      *
      *   Decimal items need to have their lengths fixed
      *
           EVALUATE WS-CA-DATA-TYPE (WS-I)
             WHEN "dec"
             WHEN "decimal"
               SUBTRACT WS-CA-NUMERIC-SCALE (WS-I)
                 FROM WS-CA-NUMERIC-PRECISION (WS-I)
           END-EVALUATE.
           EVALUATE WS-CA-DATA-TYPE (WS-I)
             WHEN "blob"
             WHEN "char"
             WHEN "date"
             WHEN "datetime"
             WHEN "mediumblob"
             WHEN "mediumtext"
             WHEN "text"
             WHEN "time"
             WHEN "timestamp"
             WHEN "tinyblob"
             WHEN "tinytext"
151016       when "longtext"
             WHEN "varchar"
             WHEN "year"
               MOVE WS-CA-CHARACTER-MAXIMUM-LENGTH (WS-I)
                 TO WS-ED8
               STRING
                 "PIC X("
                 FUNCTION TRIM (WS-ED8)
                 ")"
                   INTO WS-CA-PICTURE (WS-I)
             WHEN "bigint"
             WHEN "decimal"
             WHEN "int"
             WHEN "integer"
             WHEN "mediumint"
             WHEN "numeric"
             WHEN "smallint"
             WHEN "tinyint"
               MOVE WS-CA-NUMERIC-PRECISION (WS-I) TO WS-ED2
               MOVE WS-CA-NUMERIC-SCALE (WS-I) TO WS-ED2-SECOND
161110         move zero to ws-A
161110         inspect  ws-ca-column-type (WS-I)
161110                  tallying ws-A for all "unsigned"
161110         if ws-A = zero
161110               move "PIC S9(XX) COMP" to ws-ca-picture (WS-I)
161110         else
161110               move "PIC  9(XX) COMP" to ws-ca-picture (WS-I)
161110         end-if
      D        display ws-ca-column-type (ws-I) " for "
      D                ws-ca-column-name (ws-I)
               MOVE WS-ED2 TO WS-CA-PICTURE (WS-I) (8:2)
               IF WS-CA-NUMERIC-SCALE (WS-I) NOT = ZERO
                 THEN MOVE "V9(XX) COMP" TO WS-CA-PICTURE (WS-I) (11:11)
                      MOVE WS-ED2-SECOND TO WS-CA-PICTURE (WS-I) (14:2)
               END-IF
             WHEN   OTHER
160612              DISPLAY PSE010A,
                            WS-CA-COLUMN-NAME (WS-I)
160612                      PSE010B WS-CA-DATA-TYPE (WS-I)
151016              close input-file output-file
                    STOP RUN
           END-EVALUATE.
           ADD 1 TO WS-I.
           IF       WS-I not > WS-CA-HIGH-POINT
                    GO TO 2142-FIELD-LOOP
           end-if
           CLOSE INPUT-FILE.
           OPEN INPUT INPUT-FILE.
           IF       WS-INPUT-FILE-STATUS = 35
160612              DISPLAY PSE011
151016              close input-file output-file
                    STOP RUN.
           MOVE ZERO TO WS-RECORD-NUMBER.
161113     move     zero to WS-Comment-Found.
      *
      *    Now we can process the statements
      *     starting at beginning of source file.
      *
       2810-READ.
           MOVE     2110 TO WS-NO-PARAGRAPH.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 2980-EOF.
           ADD      1 TO WS-RECORD-NUMBER.
160612     IF       Source-Fixed
              and   IR-BUFFER (7:1) = "*"
                    PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                    GO TO 2810-READ
161113     end-if
160612     if       Source-Free
                    perform 8000-Find-Comment-Lines thru 8010-Exit
                    if      Comment-Found
                            PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                            GO TO 2810-READ
                    end-if
           end-if
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL".
           IF WS-I IS EQUAL TO ZERO
             MOVE IR-BUFFER TO OR-BUFFER
             WRITE OUTPUT-RECORD
             GO TO 2810-READ.
      *
      * Got start of PSQL commands
      *
           MOVE "N" TO WS-SWITCH-GOT-TABLE-NAME.
           MOVE "N" TO WS-SWITCH-GOT-WHERE.
           MOVE ZERO TO WS-I.
160612     if       Source-fixed
                    MOVE "      " TO IR-BUFFER (1:6).
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL CLOSE\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3000-CLOSE.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL DEFINE\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3050-DEFINE.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL DELETE\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3100-DELETE.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL FETCH\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3200-FETCH.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL FREE\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3300-FREE.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL INIT\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3400-INIT.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL INSERT\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3500-INSERT.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL LOCK\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 4000-LOCK.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL PRO\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3600-PRO.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL SELECT\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3700-SELECT.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL SWITCHDB\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3750-SWITCH-DB.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL UNLOCK\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 4100-UNLOCK.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL UPDATE\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3800-UPDATE.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL VAR\".
           IF WS-I IS NOT EQUAL TO ZERO GO TO 3900-VAR.
       2980-EOF.
           GO TO 7990-EXIT.
      **************************************************************
      *    Execute mysql close                                     *
      **************************************************************
       3000-CLOSE.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    CLOSE THE DATABASE" TO OR-BUFFER
220616     else     move "*>    Close the Database" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "           PERFORM MYSQL-1980-CLOSE"
220616       & " THRU MYSQL-1999-EXIT" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL CLOSE\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE     ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS NOT EQUAL TO 1 GO TO 5000-ERROR.
161113     PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    Define the rows in a table                              *
      **************************************************************
       3050-DEFINE.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE "/MYSQL DEFINE\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           ADD 1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
161113     IF       WS-I not = 1
161113              DISPLAY PSE012
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WORK.
      *
      *    Specification should be TABLE-NAME,PRE(fix)
      *      Parse across to separate data items and validate
      *      syntax
      *
           MOVE "N" TO WS-SWITCH-GOT-TABLE-NAME.
           MOVE SPACES TO WS-TABLE-WANTED.
           MOVE 1 TO WS-J.
       3051-PARSE-LOOP.
           EVALUATE WS-TABLE-WORK (WS-J:1)
             WHEN " "
               GO TO 3052-FINISHED
             WHEN ","
               MOVE "Y" TO WS-SWITCH-GOT-TABLE-NAME
               MOVE WS-TABLE-WORK (WS-J + 1: 64 - WS-J)
                 TO WS-TABLE-WORK
               MOVE ZERO TO WS-J
             WHEN OTHER
               IF WS-SWITCH-GOT-TABLE-NAME IS EQUAL TO "N"
                 THEN MOVE WS-TABLE-WORK (WS-J:1)
                        TO WS-TABLE-WANTED (WS-J:1)
               ELSE IF   WS-J IS GREATER THAN 4
                         MOVE WS-RECORD-NUMBER TO WS-ED6S
160612                   DISPLAY PSE013, WS-ED6S
151016                   close input-file output-file
                         STOP RUN
                    END-IF
                    MOVE WS-TABLE-WORK (WS-J:1)
                        TO WS-TABLE-PREFIX-WORK (WS-J:1)
               END-IF
           END-EVALUATE.
       3052-FINISHED.
           ADD 1 TO WS-J.
           IF WS-J IS LESS THAN 65 GO TO 3051-PARSE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO SPACES GO TO 3053-ERROR.
           IF WS-TABLE-PREFIX-WORK IS EQUAL TO SPACES GO TO 3053-ERROR.
           GO TO 3054-CONTINUE.
       3053-ERROR.
           MOVE     WS-RECORD-NUMBER TO WS-ED6S.
160612     DISPLAY  PSE014, WS-ED6S.
151016     close    input-file output-file
           STOP RUN.
       3054-CONTINUE.
           MOVE 1 TO WS-I.
       3056-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3057-DEFINE.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3056-TABLE-LOOP
160612       ELSE   DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3057-DEFINE.
           MOVE WS-TABLE-START (WS-I) TO WS-J.
       3058-COLUMN-LOOP.
041510     MOVE WS-CA-COLUMN-NAME (WS-J) TO WS-TEMP-COLUMN-NAME.
041510     PERFORM 5300-FIX-INTERIM-SPACES THRU 5390-EXIT.
           INITIALIZE OR-BUFFER.
           STRING
             "           05  "
             FUNCTION TRIM (WS-TABLE-PREFIX-WORK)
             "-"
041510*      FUNCTION TRIM (WS-CA-COLUMN-NAME (WS-J))
041510       FUNCTION TRIM (WS-TEMP-COLUMN-NAME)
               INTO OR-BUFFER.
042010*    MOVE 46 TO WS-K.
042010     MOVE 50 TO WS-K.
           STRING
             FUNCTION TRIM (WS-CA-PICTURE (WS-J))
             "."
               INTO OR-BUFFER WITH POINTER WS-K.
           MOVE FUNCTION UPPER-CASE (OR-BUFFER) TO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           ADD 1 TO WS-J.
           IF WS-J IS LESS THAN WS-TABLE-START (WS-I + 1)
             GO TO 3058-COLUMN-LOOP.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE     ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS NOT EQUAL TO 1 GO TO 5000-ERROR.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    Delete a row                                            *
      **************************************************************
       3100-DELETE.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    DELETE A ROW" TO OR-BUFFER
           else     move "*>    Delete a row" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL DELETE\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE     ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
160612              DISPLAY PSE016
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3102-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3104-DELETE.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3102-TABLE-LOOP
160612       ELSE   DISPLAY PSE017, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3104-DELETE.
           INITIALIZE OR-BUFFER.
220616     MOVE '           INITIALIZE WS-MYSQL-COMMAND'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           STRING "DELETE FROM "' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
042010*    STRING '             "'
042010     STRING '             "`'
             FUNCTION TRIM (WS-TABLE-WANTED)
042010*      '"'
042010       '`"'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '             " WHERE "' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
       3106-READ-LOOP.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE     ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "WHERE=".
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           IF WS-I IS EQUAL TO 1
             MOVE "Y" TO WS-SWITCH-GOT-WHERE
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "WHERE="," ")
               TO IR-BUFFER
             STRING "             "
               FUNCTION TRIM (IR-BUFFER)
                INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
220616       MOVE '             X"00" INTO WS-MYSQL-COMMAND'
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
             MOVE '           PERFORM MYSQL-1210-COMMAND'
220616         & ' THRU MYSQL-1219-EXIT'
                 TO OR-BUFFER
             WRITE OUTPUT-RECORD
161112       move     spaces to INPUT-RECORD
             READ     INPUT-FILE NEXT RECORD AT END
                      GO TO 5000-ERROR
             ADD      1 TO WS-RECORD-NUMBER
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN IF WS-SWITCH-GOT-WHERE IS EQUAL TO "N"
160612              DISPLAY PSE018
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN
                  END-IF
                  PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      **************************************************************
      *    Fetch the next record                                   *
      **************************************************************
       3200-FETCH.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE "/MYSQL FETCH\" TO WS-LAST-MYSQL-COMMAND.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    FETCH NEXT RECORD" TO OR-BUFFER
           else     move "*>    Fetch next record" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
160612              DISPLAY PSE019
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3202-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3204-PROCESS-COLUMNS.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3202-TABLE-LOOP
160612      ELSE    DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3204-PROCESS-COLUMNS.
           INITIALIZE OR-BUFFER.
042010     MOVE WS-TABLE-WANTED TO WS-TEMP-TABLE-NAME.
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING ALL " " BY "-".
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING TRAILING "-" BY " ".
           STRING "           MOVE TP-"
042010*      FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TABLE-WANTED))
042010       FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TEMP-TABLE-NAME))
220616       " TO WS-MYSQL-RESULT"
               INTO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           MOVE '           CALL "MySQL_fetch_record" USING'
             & ' WS-MYSQL-RESULT' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE WS-TABLE-START (WS-I) TO WS-J.
       3206-COLUMN-LOOP.
041510     MOVE WS-CA-COLUMN-NAME (WS-J) TO WS-TEMP-COLUMN-NAME.
041510     PERFORM 5300-FIX-INTERIM-SPACES THRU 5390-EXIT.
           INITIALIZE OR-BUFFER.
           STRING
             "                    "
             FUNCTION TRIM (WS-TABLE-PREFIX (WS-I))
             "-"
041510*      FUNCTION TRIM (WS-CA-COLUMN-NAME (WS-J))
041510       FUNCTION TRIM (WS-TEMP-COLUMN-NAME)
               INTO OR-BUFFER.
           MOVE FUNCTION UPPER-CASE (OR-BUFFER) TO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           ADD 1 TO WS-J.
           IF WS-J IS LESS THAN WS-TABLE-START (WS-I + 1)
             GO TO 3206-COLUMN-LOOP.
           INITIALIZE OR-BUFFER.
220616*     MOVE "." TO OR-BUFFER (20:1)
220616     move     " end-call" to OR-BUFFER (20:1)
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      **************************************************************
      *    EXECUTE MYSQL free result                               *
      **************************************************************
       3300-FREE.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE "/MYSQL FREE\" TO WS-LAST-MYSQL-COMMAND.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    FREE RESULT ARRAY" TO OR-BUFFER
           else     move "*>    Free result array" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
160612              DISPLAY PSE020
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3302-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3304-CONTINUE.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3302-TABLE-LOOP
160612      ELSE    DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3304-CONTINUE.
           INITIALIZE OR-BUFFER.
042010     MOVE WS-TABLE-WANTED TO WS-TEMP-TABLE-NAME.
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING ALL " " BY "-".
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING TRAILING "-" BY " ".
           STRING "           MOVE TP-"
042010*      FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TABLE-WANTED))
042010       FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TEMP-TABLE-NAME))
220616       " TO WS-MYSQL-RESULT"
               INTO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           MOVE '           CALL "MySQL_free_result"'
220616      & " USING WS-MYSQL-RESULT end-call" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS NOT EQUAL TO 1 GO TO 5000-ERROR.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    Get the variables to specify the data base              *
      *      and open the data base                                *
      **************************************************************
       3400-INIT.
           MOVE 3400 TO WS-NO-PARAGRAPH.
           MOVE "/MYSQL INIT\" TO WS-LAST-MYSQL-COMMAND.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    OPEN THE DATABASE" TO OR-BUFFER
           else     move "*>    Open the database" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
       3402-INIT-LOOP.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "BASE=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "BASE=", " ")
               TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER)
               TO WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT)
             MOVE "Y" TO WS-SWITCH-GOT-BASE
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "HOST=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "HOST=", " ")
               TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER) TO WS-HOST
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "IMPLEMENTATION=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION
               SUBSTITUTE (IR-BUFFER, "IMPLEMENTATION=", " ")
                 TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER) TO WS-IMPLEMENTATION
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "PASSWORD=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION
               SUBSTITUTE (IR-BUFFER, "PASSWORD=", " ")
                 TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER) TO WS-PASSWORD
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "PORT=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "PORT=", " ")
               TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER) TO WS-PORT
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "SOCKET=".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "SOCKET=", " ")
               TO IR-BUFFER
             MOVE FUNCTION TRIM (IR-BUFFER) TO WS-SOCKET
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "RUNTIME".
           IF WS-I IS EQUAL TO 1
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             MOVE "Y" TO WS-RUNTIME
             GO TO 3402-INIT-LOOP
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN NEXT SENTENCE
             ELSE GO TO 5000-ERROR.
           IF       WS-SWITCH-GOT-BASE IS NOT EQUAL TO "Y"
160612              DISPLAY PSE021, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           IF       WS-HOST IS EQUAL TO SPACES
                    MOVE "localhost" to WS-HOST.
           IF       WS-IMPLEMENTATION IS EQUAL TO SPACES
                    MOVE "mysql" TO WS-IMPLEMENTATION.
           IF       WS-PORT IS EQUAL TO SPACES
160612              MOVE "3306"  to WS-Port.
           IF       WS-SOCKET IS EQUAL TO SPACES
151018              MOVE "/var/run/mysqld/mysqld.sock" to WS-Socket.
           INITIALIZE OR-BUFFER.
           IF WS-RUNTIME IS EQUAL TO "N"
             STRING
               '           MOVE "'
               FUNCTION TRIM
                 (WS-BASE-NAME-ARRAY (WS-TABLE-ARRAY-HIGH-POINT))
220616         '"  & X"00" TO WS-MYSQL-BASE-NAME'
               INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
           END-IF.
           STRING
             '           MOVE "'
             FUNCTION TRIM (WS-HOST)
220616       '" & X"00" TO WS-MYSQL-HOST-NAME'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING
             '           MOVE "'
             FUNCTION TRIM (WS-IMPLEMENTATION)
220616       '" & X"00" TO WS-MYSQL-IMPLEMENTATION'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           IF WS-RUNTIME IS EQUAL TO "N"
             STRING
               '           MOVE "'
               FUNCTION TRIM (WS-PASSWORD)
220616         '" & X"00" TO WS-MYSQL-PASSWORD'
                 INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
           END-IF.
           STRING
             '           MOVE "'
             FUNCTION TRIM (WS-PORT)
220616       '" & X"00" TO WS-MYSQL-PORT-NUMBER'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING
             '           MOVE "'
             FUNCTION TRIM (WS-SOCKET)
             '"'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING
220616       '             & X"00" TO WS-MYSQL-SOCKET'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING
             "           PERFORM MYSQL-1000-OPEN "
220616       " THRU MYSQL-1090-EXIT"
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    Insert a row in a table                                 *
      **************************************************************
       3500-INSERT.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    INSERT A ROW" TO OR-BUFFER
           else     move "*>    Insert a row" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL INSERT\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
                    DISPLAY PSE022
                             WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3502-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3504-PROCESS-COLUMNS.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3502-TABLE-LOOP
160612      ELSE    DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3504-PROCESS-COLUMNS.
      *
      *    INITIALIZE WS-MYSQL-COMMAND.
      *    MOVE 1 TO WS-MYSQL-I.
      *    STRING 'INSERT INTO '
      *      'tbl_time_entries SET '
      *        INTO WS-MYSQL-COMMAND
      *        WITH POINTER WS-MYSQL-I
220616     MOVE "           INITIALIZE WS-MYSQL-COMMAND"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE "           MOVE 1 TO WS-MYSQL-I"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "           STRING 'INSERT INTO '"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
042010*    STRING "                    '"
042010     STRING "                    '`"
             FUNCTION TRIM (WS-TABLE-WANTED)
042010*      " SET '"
042010       "` SET '"
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "              INTO WS-MYSQL-COMMAND"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE "              WITH POINTER WS-MYSQL-I end-string"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           PERFORM 5200-STRING-COLUMNS THRU 5290-EXIT.
           INITIALIZE OR-BUFFER.
           STRING '           STRING ";" INTO WS-MYSQL-COMMAND'
             INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
220616     STRING '             WITH POINTER WS-MYSQL-I end-string'
             INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING '           STRING X"00" INTO WS-MYSQL-COMMAND'
             INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
220616     STRING '             WITH POINTER WS-MYSQL-I end-string'
             INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING "       PERFORM MYSQL-1210-COMMAND"
220616       " THRU MYSQL-1219-EXIT"
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      **************************************************************
      *    Place mysql procedures in program                       *
      **************************************************************
       3600-PRO.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "       COPY MYSQL-PROCEDURES." TO OR-BUFFER
           else      *> source-free
                    MOVE ' COPY "mysql-procedures.cpy".' TO OR-BUFFER
160612     end-if
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL PRO\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS NOT EQUAL TO 1 GO TO 5000-ERROR.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    Select rows                                             *
      **************************************************************
       3700-SELECT.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    SELECT ROWS" TO OR-BUFFER
           else     move "*>    Select rows" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL SELECT\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
                    DISPLAY PSE023
                             WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3702-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3704-SELECT.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3702-TABLE-LOOP
160612     ELSE    DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3704-SELECT.
           INITIALIZE OR-BUFFER.
220616     MOVE '           INITIALIZE WS-MYSQL-COMMAND'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           STRING "SELECT * FROM "' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
042010*    STRING '             "'
042010     STRING '             "`'
             FUNCTION TRIM (WS-TABLE-WANTED)
042010*      '"'
042010       '`"'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           MOVE '             " WHERE "' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
       3706-READ-LOOP.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "WHERE=".
           IF WS-I IS EQUAL TO 1
             MOVE "Y" TO WS-SWITCH-GOT-WHERE
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "WHERE="," ")
               TO IR-BUFFER
             STRING "             "
               FUNCTION TRIM (IR-BUFFER)
                INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
220616       MOVE '            ";"  X"00" INTO WS-MYSQL-COMMAND'
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
             MOVE '           PERFORM MYSQL-1210-COMMAND'
220616         & ' THRU MYSQL-1219-EXIT'
                 TO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
             MOVE "           PERFORM MYSQL-1220-STORE-RESULT "
220616         & "THRU MYSQL-1239-EXIT"
                 TO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
042010       MOVE WS-TABLE-WANTED TO WS-TEMP-TABLE-NAME
042010       INSPECT WS-TEMP-TABLE-NAME REPLACING ALL " " BY "-"
042010       INSPECT WS-TEMP-TABLE-NAME REPLACING TRAILING "-" BY " "
             STRING "           MOVE WS-MYSQL-RESULT TO TP-"
042010*        FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TABLE-WANTED))
042010         FUNCTION UPPER-CASE (FUNCTION TRIM (WS-TEMP-TABLE-NAME))
220616*        "."
                 INTO OR-BUFFER
             INSPECT OR-BUFFER REPLACING ALL "_" BY "-"
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
161112       move     spaces to INPUT-RECORD
             READ     INPUT-FILE NEXT RECORD AT END
                      GO TO 5000-ERROR
             end-read
             ADD      1 TO WS-RECORD-NUMBER
           END-IF.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
160605     IF WS-I IS EQUAL TO 1
             THEN IF WS-SWITCH-GOT-WHERE IS EQUAL TO "N"
160612               DISPLAY PSE024
                             WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN
                  END-IF
                  PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      **************************************************************
      *    EXECUTE MYSQL selectdb                                  *
      **************************************************************
       3750-SWITCH-DB.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE "/MYSQL SWITCHDB\" TO WS-LAST-MYSQL-COMMAND.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    SWITCH DATA BASES" TO OR-BUFFER
           else     move "*>    Switch Data Bases" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           MOVE "           PERFORM MYSQL-1240-SWITCH-DB THRU "
220616       & "MYSQL-1249-EXIT" TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS NOT EQUAL TO 1 GO TO 5000-ERROR.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    UPDATE A ROW IN A TABLE                                 *
      **************************************************************
       3800-UPDATE.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    UPDATE A ROW" TO OR-BUFFER
           else     move "*>    Update a row" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL UPDATE\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
160612              DISPLAY PSE025
                             WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       3802-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 3804-PROCESS-COLUMNS.
           ADD 1 TO WS-I.
           IF       WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3802-TABLE-LOOP
160612      ELSE    DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       3804-PROCESS-COLUMNS.
      *
      *    INITIALIZE WS-MYSQL-COMMAND.
      *    MOVE 1 TO WS-MYSQL-I.
      *    STRING 'UPDATE '
      *      'tbl_time_entries SET '
      *        INTO WS-MYSQL-COMMAND
      *        WITH POINTER WS-MYSQL-I
220616     MOVE "           INITIALIZE WS-MYSQL-COMMAND"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE "           MOVE 1 TO WS-MYSQL-I"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "           STRING 'UPDATE '"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
042010*    STRING "                    '"
042010     STRING "                    '`"
             FUNCTION TRIM (WS-TABLE-WANTED)
042010*      " SET '"
042010       "` SET '"
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE "              INTO WS-MYSQL-COMMAND"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE "              WITH POINTER WS-MYSQL-I end-string"
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           PERFORM 5200-STRING-COLUMNS THRU 5290-EXIT.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "WHERE=".
           IF WS-I IS EQUAL TO 1
             MOVE "Y" TO WS-SWITCH-GOT-WHERE
             MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "WHERE="," ")
               TO IR-BUFFER
             INITIALIZE OR-BUFFER
             STRING '           STRING " WHERE "'
                 INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             MOVE "              INTO WS-MYSQL-COMMAND"
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
220616       MOVE "              WITH POINTER WS-MYSQL-I end-string"
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
             STRING '           STRING FUNCTION TRIM ('
               FUNCTION TRIM (IR-BUFFER)
               ')'
                 INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             MOVE "              INTO WS-MYSQL-COMMAND"
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
220616       MOVE "              WITH POINTER WS-MYSQL-I end-string"
               TO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
             STRING '           STRING ";" X"00" INTO WS-MYSQL-COMMAND'
               INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
220616       STRING '             WITH POINTER WS-MYSQL-I end-string'
               INTO OR-BUFFER
             WRITE OUTPUT-RECORD
             INITIALIZE OR-BUFFER
             STRING '           PERFORM MYSQL-1210-COMMAND '
220616         'THRU MYSQL-1219-EXIT'
                 INTO OR-BUFFER
             WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF       WS-I = 1
             THEN   IF  WS-SWITCH-GOT-WHERE = "N"
160612                  display PSE026 WS-RECORD-NUMBER
151016                  close input-file output-file
                        STOP RUN
                    END-IF
                    PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                    GO TO 2810-READ
           ELSE     GO TO 5000-ERROR.
      **************************************************************
      *    Place mysql variables in program                        *
      *         and build table arrays                             *
      *                                                            *
      *      WS-J will contain the pointer to the start of the     *
      *        tables for this particular data base                *
      **************************************************************
       3900-VAR.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           MOVE "/MYSQL VAR\" TO WS-LAST-MYSQL-COMMAND.
           MOVE "N" TO WS-SWITCH-FOUND-BASE.
       3910-READ-LOOP.
           MOVE 3910 TO WS-NO-PARAGRAPH.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
160612     IF       IR-BUFFER (7:1) = "*"
                    PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                    GO TO 3910-READ-LOOP.
160612     if       Source-Free
                    perform 8000-Find-Comment-Lines thru 8010-Exit
                    if      Comment-Found
                            PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                            GO TO 3910-READ-LOOP.
           IF WS-SWITCH-FOUND-BASE IS EQUAL TO "Y" GO TO 3914-CONTINUE.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "BASE=".
           IF       WS-I = 1
160612              if       Source-fixed
                             MOVE "      " TO IR-BUFFER (1:6)
                    end-if
                    MOVE FUNCTION SUBSTITUTE (IR-BUFFER," BASE="," ")
                                 TO IR-BUFFER
                    MOVE FUNCTION TRIM (IR-BUFFER) TO WS-BASE-WANTED
                    MOVE "Y" TO WS-SWITCH-FOUND-BASE
160612      ELSE    DISPLAY PSE027, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN
           END-IF.
           MOVE 1 TO WS-J.
       3912-FIND-BASE.
           IF WS-BASE-WANTED IS EQUAL TO WS-BASE-NAME-ARRAY (WS-J)
             GO TO 3914-CONTINUE.
           ADD 1 TO WS-J.
           IF       WS-I IS LESS THAN WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 3912-FIND-BASE.
160612     DISPLAY  PSE028,  WS-BASE-WANTED,
160612              PSE015B, WS-RECORD-NUMBER
151016     close input-file output-file
           STOP RUN.
       3914-CONTINUE.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN NEXT SENTENCE
             ELSE PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 3910-READ-LOOP.
      *
      *    NOW WE CAN FINALLY OUTPUT THE GENERATED COBOL CODE
      *
160612     IF       WS-SWITCH-DID-VARIABLES = "N"
                    INITIALIZE OR-BUFFER
                    if  Source-Fixed
                        MOVE "       COPY MYSQL-VARIABLES." TO OR-BUFFER
                    else
                        MOVE ' COPY "mysql-variables.cpy".' TO OR-BUFFER
160612              end-if
                    WRITE OUTPUT-RECORD
                    MOVE "Y" TO WS-SWITCH-DID-VARIABLES.
           MOVE WS-J  TO WS-I.
       3950-TABLE-LOOP.
           IF WS-BASE-WANTED IS NOT EQUAL TO WS-BASE-NAME-ARRAY (WS-I)
             PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
             GO TO 2810-READ.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    STRING
                         "      *    DEFINITIONS FOR THE "
                         FUNCTION TRIM (WS-TABLE-ARRAY (WS-I))
                         " TABLE"
                      INTO OR-BUFFER
           else
                    STRING
                         "*>    Definitions for the "
                         FUNCTION TRIM (WS-TABLE-ARRAY (WS-I))
                         " Table"
                      INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
042010     MOVE WS-TABLE-ARRAY (WS-I) TO WS-TEMP-TABLE-NAME.
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING ALL " " BY "-".
042010     INSPECT WS-TEMP-TABLE-NAME REPLACING TRAILING "-" BY " ".
           STRING
             "       01  TP-"
042010*      FUNCTION TRIM (WS-TABLE-ARRAY (WS-I))
042010       FUNCTION TRIM (WS-TEMP-TABLE-NAME)
               INTO OR-BUFFER.
042010*    MOVE "USAGE POINTER." TO OR-BUFFER (46:14).
042010     MOVE "USAGE POINTER." TO OR-BUFFER (50:14).
           MOVE FUNCTION UPPER-CASE (OR-BUFFER) TO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING
             "       01  TD-"
042010*      FUNCTION TRIM (WS-TABLE-ARRAY (WS-I))
042010       FUNCTION TRIM (WS-TEMP-TABLE-NAME)
             "."
               INTO OR-BUFFER.
           MOVE FUNCTION UPPER-CASE (OR-BUFFER) TO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           MOVE WS-TABLE-START (WS-I) TO WS-J.
       3954-COLUMN-LOOP.
041510     MOVE WS-CA-COLUMN-NAME (WS-J) TO WS-TEMP-COLUMN-NAME.
041510     PERFORM 5300-FIX-INTERIM-SPACES THRU 5390-EXIT.
           INITIALIZE OR-BUFFER.
           STRING
             "           05  "
             FUNCTION TRIM (WS-TABLE-PREFIX (WS-I))
             "-"
041510*      FUNCTION TRIM (WS-CA-COLUMN-NAME (WS-J))
041510       FUNCTION TRIM (WS-TEMP-COLUMN-NAME)
               INTO OR-BUFFER.
042010*    MOVE 46 TO WS-K.
042010     MOVE 50 TO WS-K.
           STRING
             FUNCTION TRIM (WS-CA-PICTURE (WS-J))
             "."
               INTO OR-BUFFER WITH POINTER WS-K.
           MOVE FUNCTION UPPER-CASE (OR-BUFFER) TO OR-BUFFER.
           INSPECT OR-BUFFER REPLACING ALL "_" BY "-".
           WRITE OUTPUT-RECORD.
           ADD 1 TO WS-J.
           IF WS-J IS LESS THAN WS-TABLE-START (WS-I + 1)
             GO TO 3954-COLUMN-LOOP.
           ADD 1 TO WS-I.
           IF WS-I IS NOT GREATER THAN WS-TABLE-ARRAY-HIGH-POINT
             GO TO 3950-TABLE-LOOP.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
           GO TO 2810-READ.
      **************************************************************
      *    LOCK A TABLE                                            *
      **************************************************************
       4000-LOCK.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    LOCK A TABLE" TO OR-BUFFER
           else     move "*>    Lock a table" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL LOCK\" TO WS-LAST-MYSQL-COMMAND.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "TABLE=".
           IF       WS-I not = 1
160612              DISPLAY PSE029
                            WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-fixed
                    MOVE SPACES TO IR-BUFFER (1:7).
           MOVE FUNCTION SUBSTITUTE (IR-BUFFER, "TABLE=", " ")
             TO IR-BUFFER.
           MOVE FUNCTION TRIM (IR-BUFFER) TO WS-TABLE-WANTED.
           MOVE 1 TO WS-I.
       4202-TABLE-LOOP.
           IF WS-TABLE-WANTED IS EQUAL TO WS-TABLE-ARRAY (WS-I)
             THEN GO TO 4204-LOCK.
           ADD 1 TO WS-I.
           IF       WS-I NOT > WS-TABLE-ARRAY-HIGH-POINT
                    GO TO 4202-TABLE-LOOP
160612       ELSE   DISPLAY PSE015A, WS-TABLE-WANTED,
160612                      PSE015B, WS-RECORD-NUMBER
151016              close input-file output-file
                    STOP RUN.
       4204-LOCK.
           INITIALIZE OR-BUFFER.
220616     MOVE '           INITIALIZE WS-MYSQL-COMMAND'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           STRING "LOCK TABLES "' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
042010*    STRING '             "'
042010     STRING '             "`'
             FUNCTION TRIM (WS-TABLE-WANTED)
042010*      '"'
042010       '`"'
               INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '             " WRITE ;"' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE '             X"00" INTO WS-MYSQL-COMMAND '
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           PERFORM MYSQL-1210-COMMAND'
220616         & ' THRU MYSQL-1219-EXIT'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      **************************************************************
      *    Unlock the Data base                                    *
      **************************************************************
       4100-UNLOCK.
           PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *    UNLOCK THE DATABASE" TO OR-BUFFER
           else     move "*>    Unlock the Database" TO OR-Buffer.
           WRITE OUTPUT-RECORD.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
           MOVE "/MYSQL UNLOCK\" TO WS-LAST-MYSQL-COMMAND.
           INITIALIZE OR-BUFFER.
220616     MOVE '           INITIALIZE WS-MYSQL-COMMAND'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           STRING "UNLOCK TABLES;"' TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
220616     MOVE '             X"00" INTO WS-MYSQL-COMMAND end-string'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           MOVE '           PERFORM MYSQL-1210-COMMAND'
220616       & ' THRU MYSQL-1219-EXIT'
             TO OR-BUFFER.
           WRITE OUTPUT-RECORD.
161112     move     spaces to INPUT-RECORD.
           READ     INPUT-FILE NEXT RECORD AT END
                    GO TO 5000-ERROR.
           ADD      1 TO WS-RECORD-NUMBER.
           MOVE ZERO TO WS-I.
           INSPECT IR-BUFFER TALLYING WS-I FOR ALL "/MYSQL-END\".
           IF WS-I IS EQUAL TO 1
             THEN PERFORM 5100-OUTPUT-COMMENT THRU 5109-EXIT
                  GO TO 2810-READ
             ELSE GO TO 5000-ERROR.
      *
      *    Instruction not terminated
      *
       5000-ERROR.
160612     DISPLAY  PSE030A
                    FUNCTION TRIM (WS-LAST-MYSQL-COMMAND)
160612              PSE030B WS-RECORD-NUMBER.
           GO       TO 7990-EXIT.
      *
      *    Output mysql command as a comment
      *
       5100-OUTPUT-COMMENT.
160612     if       Source-Fixed
                    MOVE IR-BUFFER TO OR-BUFFER
                    MOVE   "*" TO OR-BUFFER (7:1)
           else
             if     Comment-Found
                    MOVE IR-BUFFER TO OR-BUFFER
             else
160612              move   spaces to OR-Buffer
                    string "*> "      delimited by size
                           IR-Buffer  *>  (1:ws-Line-Length)
                                   into OR-Buffer
                    end-string
           end-if
           WRITE OUTPUT-RECORD.
       5109-EXIT.
           EXIT.
      *
      *    String column names and their data contents
      *
       5200-STRING-COLUMNS.
           MOVE WS-TABLE-START (WS-I) TO WS-J.
       5202-COLUMN-LOOP.
      *
      *    sql_column_name="data from buffer"
      *
           INITIALIZE OR-BUFFER.
160612     if       Source-Fixed
                    MOVE "      *" TO OR-BUFFER
           else     move "*>" to OR-Buffer.
           WRITE OUTPUT-RECORD.
042010     MOVE WS-CA-COLUMN-NAME (WS-J) TO WS-TEMP-COLUMN-NAME.
042010     PERFORM 5300-FIX-INTERIM-SPACES THRU 5390-EXIT.
           STRING
             FUNCTION TRIM (WS-TABLE-PREFIX (WS-I))
             "-"
042010*      FUNCTION TRIM (WS-CA-COLUMN-NAME (WS-J))
042010       FUNCTION TRIM (WS-TEMP-COLUMN-NAME)
               INTO WS-COLUMN-WANTED.
           MOVE FUNCTION UPPER-CASE (WS-COLUMN-WANTED)
             TO WS-COLUMN-WANTED.
           INSPECT WS-COLUMN-WANTED REPLACING ALL "_" BY "-".
041510*    MOVE WS-COLUMN-WANTED TO WS-TEMP-COLUMN-NAME.
041510*    PERFORM 5300-FIX-INTERIM-SPACES THRU 5390-EXIT.
041510*    MOVE WS-TEMP-COLUMN-NAME TO WS-COLUMN-WANTED.
           INITIALIZE OR-BUFFER.
042010*    STRING "           STRING '"
042010     STRING "           STRING '`"
             FUNCTION TRIM (WS-CA-COLUMN-NAME (WS-J))
042010*      "=""' INTO WS-MYSQL-COMMAND"
042010       "`=""' INTO WS-MYSQL-COMMAND"
             INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           INITIALIZE OR-BUFFER.
           STRING "                   "
220616       "WITH POINTER WS-MYSQL-I end-string"
                INTO OR-BUFFER.
           WRITE OUTPUT-RECORD.
           EVALUATE WS-CA-DATA-TYPE (WS-J)
             WHEN "blob"
             WHEN "char"
             WHEN "date"
             WHEN "datetime"
             WHEN "mediumblob"
             WHEN "mediumtext"
             WHEN "text"
             WHEN "time"
             WHEN "timestamp"
             WHEN "tinyblob"
             WHEN "tinytext"
             WHEN "varchar"
             WHEN "year"
               INITIALIZE OR-BUFFER
               STRING "           STRING FUNCTION TRIM ("
                 FUNCTION TRIM (WS-COLUMN-WANTED)
                 ',TRAILING)'
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
               STRING '                  ''"'' '
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
               STRING "                   "
                 "INTO WS-MYSQL-COMMAND"
                    INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
               STRING "                   "
220616           "WITH POINTER WS-MYSQL-I end-string"
                    INTO OR-BUFFER
               WRITE OUTPUT-RECORD
      *
      *
             WHEN "bigint"
             WHEN "dec"
             WHEN "decimal"
             WHEN "int"
             WHEN "integer"
             WHEN "mediumint"
             WHEN "numeric"
             WHEN "smallint"
             WHEN "tinyint"
               SUBTRACT WS-CA-NUMERIC-PRECISION (WS-J) FROM 21
                 GIVING WS-LEFT-POSITION-START
               MOVE WS-LEFT-POSITION-START TO WS-ED2
               MOVE WS-CA-NUMERIC-PRECISION (WS-J)
                 TO WS-ED2-SECOND
               INITIALIZE OR-BUFFER
               STRING "           MOVE "
                 FUNCTION TRIM (WS-COLUMN-WANTED,TRAILING)
                    INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
220616         STRING "             TO WS-MYSQL-EDIT"
                    INTO OR-BUFFER
               WRITE OUTPUT-RECORD
051010*        INITIALIZE OR-BUFFER
051010*        STRING "           IF "
051010*          FUNCTION TRIM (WS-COLUMN-WANTED,TRAILING)
051010*             INTO OR-BUFFER
051010*        WRITE OUTPUT-RECORD
051010*        INITIALIZE OR-BUFFER
051010*        STRING "             IS LESS THAN ZERO"
051010*          INTO OR-BUFFER
051010*        WRITE OUTPUT-RECORD
051010*        INITIALIZE OR-BUFFER
051010*        STRING "               STRING '-' "
051010*          "INTO WS-MYSQL-COMMAND"
051010*             INTO OR-BUFFER
051010*        WRITE OUTPUT-RECORD
051010*        INITIALIZE OR-BUFFER
051010*        STRING "                   "
220616*          "WITH POINTER WS-MYSQL-I end-string"
051010*             INTO OR-BUFFER
051010*        WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
      *
               STRING "           STRING FUNCTION TRIM (WS-MYSQL-EDIT"
                 "("
                 WS-ED2
                 ":"
                 WS-ED2-SECOND
                 "))"
                   INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
               STRING "             INTO WS-MYSQL-COMMAND"
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
220616         STRING "             WITH POINTER WS-MYSQL-I end-string"
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
      *
               IF WS-CA-NUMERIC-SCALE (WS-J) IS NOT EQUAL TO ZERO
                 THEN MOVE WS-CA-NUMERIC-SCALE (WS-J) TO WS-ED2
                      STRING "           STRING ""."" "
                        "INTO WS-MYSQL-COMMAND"
                           INTO OR-BUFFER
                      WRITE OUTPUT-RECORD
                      INITIALIZE OR-BUFFER
220616                STRING "             WITH POINTER WS-MYSQL-I" &
220616                       " end-string"
                        INTO OR-BUFFER
                      WRITE OUTPUT-RECORD
                      INITIALIZE OR-BUFFER
                      STRING "           STRING WS-MYSQL-EDIT"
                        "("
                        "22"
                        ":"
                        WS-ED2
                        ")"
                          INTO OR-BUFFER
                      WRITE OUTPUT-RECORD
                      INITIALIZE OR-BUFFER
                      STRING "             INTO WS-MYSQL-COMMAND"
                        INTO OR-BUFFER
                      WRITE OUTPUT-RECORD
                      INITIALIZE OR-BUFFER
220616                STRING "             WITH POINTER WS-MYSQL-I" &
220616                       " end-string"
                        INTO OR-BUFFER
                      WRITE OUTPUT-RECORD
                      INITIALIZE OR-BUFFER
                 END-IF
220616         INITIALIZE OR-BUFFER
               STRING '           STRING ''"'' INTO WS-MYSQL-COMMAND'
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
220616         STRING '           WITH POINTER WS-MYSQL-I end-string'
                 INTO OR-BUFFER
               WRITE OUTPUT-RECORD
               INITIALIZE OR-BUFFER
           END-EVALUATE.
           MOVE SPACES TO WS-COLUMN-WANTED.
           ADD 1 TO WS-J.
           INITIALIZE OR-BUFFER
           IF WS-J IS LESS THAN WS-TABLE-START (WS-I + 1)
             THEN STRING '           STRING '', '''
                      'INTO WS-MYSQL-COMMAND'
                    INTO OR-BUFFER
                  WRITE OUTPUT-RECORD
                  INITIALIZE OR-BUFFER
220616            STRING '           WITH POINTER WS-MYSQL-I end-string'
                    INTO OR-BUFFER
                  WRITE OUTPUT-RECORD
                  INITIALIZE OR-BUFFER
                  GO TO 5202-COLUMN-LOOP.
       5290-EXIT.
           EXIT.
041510****************************************************************
041510*    Replaces spaces in column names with "-" for COBOL        *
041510*      Variable names                                          *
041510****************************************************************
041510 5300-FIX-INTERIM-SPACES.
041510     INSPECT WS-TEMP-COLUMN-NAME REPLACING ALL " " BY "-".
041510     INSPECT WS-TEMP-COLUMN-NAME REPLACING TRAILING "-" BY " ".
041510 5390-EXIT.
041510     EXIT.
      *
      *    END OF JOB
      *
       7990-EXIT.
           EXIT.
      *
160612 8000-Find-Comment-lines.
161112*
161112* Complete rewrite of paragraph
161112*
      ******************************************************************
      * Called after a new source line is read in : -
      *  Processing for free format comment lines, trailing comments
      *    and if present is PSQL (presql) uppercase string also
      *     present and where is the comment.
      *   We will ignore comments AFTER PSQL as valid as presql
      *       will work
      ******************************************************************
      *
           move     zero to Ws-Comment-Found.
      *
      * Make sure we have only now process free format source
      *
           if       Source-Fixed
                    go to 8010-Exit.
      *
      * Work out actual length of the source record.
      *
           perform  varying WS-LLength from 256 by -1 until
                    WS-LLength < 2 or
                    IR-Buffer (WS-LLength:1) not = space
           end-perform
      *
      * Treat blank line as comment
      *
           if       WS-LLength < 2
                    move 1 to ws-Comment-Found
                    go to 8010-Exit.
      *
      *  See if we have any PSQL commands [with complete list]
      *   with WS-D holding count of all occurances on a line
      *  Note that none are Cobol reserved words.
      *
           move     zero to WS-D.
           inspect  IR-Buffer tallying WS-D for all "/MYSQL"
                                                all "TABLE="
                                                all "BASE="
                                                all "WHERE="
                                                all "HOST="
                                                all "IMPLEMENTATION="
                                                all "PASSWORD="
                                                all "PORT="
                                                all "SOCKET="
                                                all "RUNTIME".
      *
      * Now have record data length of IR-Buffer in ws-LLength
      *    as a CC with text present so see if we have a
      *     floating comment
      *
           perform  varying WS-B from 1 by 1 until
                    WS-B not < WS-LLength  or
                    IR-Buffer (WS-B:2) = "*>"
           end-perform
      *
      *    If no comment or no PSQL command, done
      *
           if       WS-B not < WS-LLength  *> no float comments, done
                    go to 8010-Exit.
      *
      * Comment found, so far - -
      *
           if       IR-Buffer (WS-B:2) = "*>"     *> this is not needed
                and WS-D = zero
                    move 1 to ws-Comment-Found
                    go to 8010-Exit.
      *
      *   At this point we have -
      *     a floating comment at WS-B:2 AND
      *     a PSQL command.
      *   So lets find out where each is on the basis of only one
      *    of each will be present at most and if the command is
      *    after "*>" make it a comment so no processing is done.
      *
      * Got a comment at pointer WS-B so test for command after
      *   and yes I know that 'WS-C:any' can be longer than the
      *     length of data but buffer is 256 chars long.
      *
           perform  varying WS-C from WS-B  by 1 until
                            WS-C not < WS-LLength or
                            IR-Buffer (WS-C:5)  = "BASE="   or
                                                = "HOST="   or
                                                = "PORT="   or
                            IR-Buffer (WS-C:6)  = "/MYSQL"  or
                                                = "TABLE="  or
                                                = "WHERE="  or
                            IR-Buffer (WS-C:7)  = "SOCKET=" or
                                                = "RUNTIME" or
                            IR-Buffer (WS-C:9)  = "PASSWORD=" or
                            IR-Buffer (WS-C:15) = "IMPLEMENTATION="
           end-perform
      *
      * Next should not happen but for completeness . .
      *
           if       WS-C not < WS-LLength  *> no PSQL, so treat as comment
                    move 1 to ws-Comment-Found
                    go to 8010-Exit.
      *
      *  Found PSQL command but is it before a comment
      *    If after, clear it from buffer so its safe for main
      *      routines to process  as comment.
      * Data WS-B pointer to comment
      *      WS-C pointer to PSQL
      *
           if       IR-Buffer (WS-B:2) = "*>"
                and WS-B < WS-C             *> got comment before PSQL
                    move 1 to WS-Comment-Found
                    go to 8010-Exit.
      *
      * Test for comment after, if so done as presql will handle.
      *
           if       IR-Buffer (WS-B:2) = "*>"
               and  WS-B > WS-C
                    go to 8010-Exit.
      *
           display  "Program Logic Error".
           stop run.
      *
       8010-Exit.
160612    exit.
      *
      ****************************************************************
      *             TERMINATION                                      *
      ****************************************************************
       9000-END-OF-PROGRAM.
           MOVE 9000 TO WS-NO-PARAGRAPH.
           CLOSE INPUT-FILE.
           CLOSE OUTPUT-FILE.
170103*    DISPLAY  "I) " WS-NAME-PROGRAM PSW004
170103*             FUNCTION CURRENT-DATE.
       9990-EXIT.
           EXIT.
      *
       COPY MYSQL-PROCEDURES.
