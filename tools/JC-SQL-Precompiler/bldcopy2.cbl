       >>SOURCE FREE
 identification division.
 program-id.    bldcopy2.
*>Author.       J. C. Currey.
*>Updates.      V. B. Coen, Applewood Computers.
*>**
*> Security.    Copyright (C) 2009-2018, Jim Currey.
*>              Distributed under the GNU General Public License
*>              v2.0. See the file COPYING for details.
*>**
*> Copy books used.
*>              mysql-variables.
*>              mysql-procedures
*>
*>**********************************************************************
*>      Builds copy books from mysql for GnuCobol or                   *
*>                                       Open Cobol                    *
*>                                                                     *
*>   Copy books created for fixed with no comments so can              *
*>    be used in free format programs.                                 *
*>                                                                     *
*> Change code at 1010-Process-Chained-Data to match your              *
*> MySQL | Mariadb installation.                                       *
*>                                                                     *
*>   version 001--original version                                     *
*>                 4/04/2009--j c currey                               *
*>   version 002--data type bigint cannot be defined as an             *
*>                s9(19).  changed program to define bigint            *
*>                as s9(18).                                           *
*>                1324086--jim currey                                  *
*>                11/16/2009--pete mcthompson                          *
*>                                                                     *
*>   version 002b-added local changes to access mysql                  *
*>                See Process-Changed-Data                             *
*>                 CHANGE  to your installation.                       *
*>                18/10/2015--Vincent Coen                             *
*>                                                                     *
*>   version 002c-changes for db acasdb                                *
*>                20/05/2016--Vince Coen                               *
*>                                                                     *
*>   version 002d-Changed source for free format.                      *
*>                O/P left as fixed as works with free srcs            *
*>                                                                     *
*>   version 002e-Changed to accept data when program                  *
*>                called in the form of : -                            *
*>                bldcopy o/p file name                                *
*>                        database name                                *
*>                        table name                                   *
*>                        field prefix                                 *
*>                E.g., bldcopy test-1 ACASDB STOCK-REC stk            *
*>                Also bldcopy help = list of params                   *
*>                07/06/2016 -- Vince Coen.                            *
*>                                                                     *
*>     reversioned as 1.03                                             *
*>                Changed field array from 256 to 512                  *
*>                16/08/2016 Vince Coen.                               *
*>                                                                     *
*>           1.04-Support for unsigned fields in PIC                   *
*>                to match up with prtschema.                          *
*>                Uniform the help message to match others.            *
*>                21/08/2016 Vince Coen.                               *
*>                                                                     *
*>           1.05-Do not over-ride numeric-precision unless            *
*>                it is zero but use one in row table/def              *
*>                Does depend on MySQL server defaults thougth.        *
*>                So may well not do anything.                         *
*>                25/08/2016 Vince Coen.                               *
*>                                                                     *
*>           1.06-Cosmetic added 'e' to Curry > Currey.                *
*>                                                                     *
*>          2.06 - For bldcopy2 the Mysql connection set up that       *
*>                 needs to reflect your MySql site requirements are   *
*>                 taken from a file found within the CURRENT working  *
*>                 directory BUT the version of cobmysqlapi (taken     *
*>                 from dbpre) MUST be used instead of                 *
*>                 cobmysqlapi.005.c and this is included in the       *
*>                 archive.                                            *
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
*>       Then issues a call to the dbpre version (ONLY) of cobmysqlapi *
*>        to read in this file that MUST be in the working directory.  *
*>                                                                     *
*>       This way bcdcopy2 can be used for more than one MySQL server  *
*>       on more than one system within a LAN.                         *
*>        See the example file called bcdcopy2.param                   *
*>                     31 August 2016 (160830)                         *
*>                                                                     *
*>          2.07 - Added updated copyright dating and copybook info at *
*>                 beginning comment area. Updated presql manual.      *
*>                     27 February 2018.                               *
*>**********************************************************************
*>
*> COPYRIGHT NOTICE.
*> *****************
*>
*> This file/program is part of the Mysql pre-processor presql
*>  and is copyright (c) Jim Currey. 2009-2018 and later.
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
*>
 environment division.
 input-output section.
 file-control.
     select   Output-File assign       Ws-output-file-name
                          organization line sequential
                          file status  ws-output-file-status.
 data division.
 file section.
 fd  output-file.
 01  output-record                       pic x(80).
*>
 working-storage section.
*>***************************************************
*>   Constants, Counters And Work Areas             *
*>***************************************************
 01  ws-name-program                     pic x(13) value "bldcopy2 2.06".
   *> needed 4 read-params call.
 01  ws-parm-prog-name                   pic x(8)  value "bldcopy2".
 01  ws-output-file-name                 pic x(64) value spaces.
 01  ws-schema-name                      pic x(64) value spaces.
 01  ws-table-name                       pic x(64) value spaces.
 01  ws-field-prefix                     pic x(16) value spaces.
*>
 01  ws-output-file-status               pic xx.
 01  ws-no-paragraph                     pic s9(4) comp.
 01  ws-build-field-name                 pic x(30).
 01  ws-a                                pic s9(4) comp  value zero.
 01  ws-i                                pic s9(4) comp  value zero.
 01  ws-j                                pic s9(4) comp  value zero.
 01  ws-k                                pic s9(4) comp  value zero.
 01  ws-ed2                              pic 99.
 01  ws-ed3                              pic 999.
 01  ws-ed5                              pic 99999.
 copy mysql-variables.
*>
*>   Mysql Table Buffer
*>
 01  table-buffer.
     05  tb-column-name                  pic x(64).
     05 tb-column-type                  pic x(64).
     05  tb-data-type                    pic x(64).
     05  tb-maximum-length               pic x(19).
     05  tb-numeric-precision            pic x(19).
     05  tb-numeric-scale                pic x(19).
*>
*>   Mysql Field Arrays
*>
 01  ws-field-array-buffer.
     05  ws-array-high-point             pic s9(4) comp.
     05  ws-ab-column-name               pic x(64)     occurs 512 times.
     05 ws-ab-column-type                  pic x(64)    occurs 512.      *> added for current vers of MariaDB
     05  ws-ab-data-type                 pic x(64)     occurs 512 times.
     05  ws-ab-maximum-length            pic s9(19)    occurs 512 times.
     05  ws-ab-numeric-precision         pic s9(19)    occurs 512 times.
     05  ws-ab-numeric-scale             pic s9(19)    occurs 512 times.

*>***************************************************************
*>                Procedure Division                            *
*>***************************************************************
*>
 procedure division chaining ws-output-file-name
                             ws-schema-name
                             ws-table-name
                             ws-field-prefix.
*>
 0000-main section.
     perform  1000-initialization thru 1990-exit.
     perform  2000-process thru 2990-exit.
     perform  9000-end-of-program thru 9990-exit.
     stop run.
*>***************************************************************
*>               Initialization                                 *
*>***************************************************************
 1000-initialization.
     move     1000 to ws-no-paragraph.
     if       function upper-case (ws-output-file-name) not = "HELP"
              display  "I) ", ws-name-program, " BEGINNING AT--"
                       function current-date.
*>
     if       spaces not = ws-output-file-name
                 and not = ws-schema-name
                 and not = ws-table-name
                 and not = ws-field-prefix
                 go to 1010-Process-Chained-Data.
*>
     if       ws-output-file-name = "HELP" or "help"
              display WS-NAME-PROGRAM " - - help "
              display "       P1 - O/P File Name "
              display "       P2 - DataBase Name "
              display "       P3 - Table Name "
              display "       P4 - Field Name Prefix "
              stop run.
*>
     display  "A) 1 - Enter The Output File Name " with no advancing.
     accept   ws-output-file-name.
     if       ws-output-file-name (1:3) is equal to "END"
              stop run.
     move     2000 to ws-no-paragraph.
     display  "A) 2 - Enter Your Database Name " with no advancing.
     accept   ws-schema-name.
     display  "A) 3 - Enter Your Table Name " with no advancing.
     accept   ws-table-name.
     display  "A) 4 - Enter The Field Prefix Wanted " with no advancing.
     accept   ws-field-prefix.
*>
 1010-Process-Chained-Data.
     open     output Output-file.
 1050-Init-RDB.        *> reads file bldcopy2.param
     move     spaces to               WS-MYSQL-Host-Name
                                      WS-MYSQL-Implementation
                                      WS-MYSQL-Password
                                      WS-MYSQL-Base-Name
                                      WS-MYSQL-Port-Number
                                      WS-MYSQL-Socket.
*>
     Call     "read_params"     USING ws-parm-prog-name
                                      WS-MYSQL-Host-Name
                                      WS-MYSQL-Implementation
                                      WS-MYSQL-Password
                                      WS-MYSQL-Base-Name
                                      WS-MYSQL-Port-Number
                                      WS-MYSQL-Socket
     End-call
     perform  mysql-1000-open thru mysql-1090-exit.
 1990-exit.
     exit.
*>*************************************************************
*>                 Detail Section                             *
*>*************************************************************
 2000-process.
     string "select COLUMN_NAME, DATA_TYPE, COLUMN_TYPE "         *> column_type added vbc 21/08/16
         delimited by size,
       " from COLUMNS where " delimited by size,
       'TABLE_SCHEMA="' delimited by size,
       ws-schema-name delimited by space,
       '" and TABLE_NAME="' delimited by size,
       ws-table-name delimited by space,
       '"' delimited by size,
       x"00" delimited by size
           into ws-mysql-command.
     perform mysql-1200-select thru mysql-1209-exit.
     perform mysql-1220-store-result thru mysql-1239-exit.
     move 1 to ws-i.
 2010-fetch-loop.
     call     "MySQL_fetch_row" using ws-mysql-result
                                      tb-column-name
                                      tb-data-type
                                      tb-Column-Type.         *> added vbc 21/08/16
     if       return-code = -1
              go to 2090-ender.
     move     tb-column-name to ws-ab-column-name (ws-i).
     move     tb-data-type to ws-ab-data-type (ws-i).
     move     tb-Column-Type to ws-ab-Column-Type (ws-i).     *> added vbc 21/08/16
     move     zero to ws-ab-maximum-length (ws-i).
     move     zero to ws-ab-numeric-precision (ws-i).
     move     zero to ws-ab-numeric-scale (ws-i).
     add      1 to ws-i.
     if       ws-i > 512
              display "T) TOO MANY COLUMNS (> 512)"
              close  Output-file
              stop run.
     go to    2010-fetch-loop.
*>
*>    Now we need to go get the field lengths
*>
  2090-ender.
     subtract 1 from ws-i giving ws-array-high-point.
     move     1 to ws-i.
  2100-get-lengths-loop.
     initialize ws-mysql-command.
     evaluate ws-ab-data-type (ws-i)
       when "char"
       when "varchar"
       when "tinyblob"
       when "tinytext"
       when "blob"
       when "text"
       when "mediumblob"
       when "mediumtext"
              string "select CHARACTER_MAXIMUM_LENGTH "
                 delimited by size,
                "from COLUMNS where " delimited by size,
                'TABLE_SCHEMA="'      delimited by size,
                ws-schema-name        delimited by space,
                '" and TABLE_NAME="'  delimited by size,
                ws-table-name         delimited by space,
                '" and COLUMN_NAME="' delimited by size,
                ws-ab-column-name (ws-i) delimited by space,
                '"'                   delimited by size,
                x"00"                 delimited by size
                           into ws-mysql-command
              end-string
              perform mysql-1200-select thru mysql-1209-exit
              perform mysql-1220-store-result thru mysql-1239-exit
              call "MySQL_fetch_row" using ws-mysql-result
                                           tb-maximum-length
*>              if return-code is not equal to zero
*>              go to 1100-db-error
              move tb-maximum-length to ws-ab-maximum-length (ws-i)
       when "tinyint"
       when "smallint"
       when "int"
       when "integer"
       when "bigint"
       when "mediumint"
       when "decimal"
       when "dec"
              string "select NUMERIC_PRECISION, NUMERIC_SCALE "
                                             delimited by size,
                       "from COLUMNS where " delimited by size,
                       'TABLE_SCHEMA="'      delimited by size,
                       ws-schema-name        delimited by space,
                       '" and TABLE_NAME="'  delimited by size,
                       ws-table-name         delimited by space,
                       '" and COLUMN_NAME="' delimited by size,
                       ws-ab-column-name (ws-i) delimited by space,
                       '"'                   delimited by size,
                       x"00"                 delimited by size
                                 into ws-mysql-command
              end-string
              perform mysql-1200-select thru mysql-1209-exit
              perform mysql-1220-store-result thru mysql-1239-exit
              call "MySQL_fetch_row" using ws-mysql-result
                                           tb-numeric-precision
                                           tb-numeric-scale
*>              if return-code is not equal to zero
*>                 go to 1100-db-error
         move tb-numeric-precision to ws-ab-numeric-precision (ws-i)
         move tb-numeric-scale     to ws-ab-numeric-scale (ws-i)
*>
*>  Now update if precision is zero because DBA didnt include it
*>
       when "year"
         move    4 to ws-ab-numeric-precision (ws-i)
       when "tinyint"
         if      tb-numeric-precision = zero
                 move 3 to ws-ab-numeric-precision (ws-i)
         end-if
       when "smallint"
         if      tb-numeric-precision = zero
                 move 5 to ws-ab-numeric-precision (ws-i)
         end-if
       when "mediumint"
         if      tb-numeric-precision = zero
                 move 7 to ws-ab-numeric-precision (ws-i)
         end-if
       when "int"
         if      tb-numeric-precision = zero
                 move 10 to ws-ab-numeric-precision (ws-i)
         end-if
       when "bigint"
         if      tb-numeric-precision = zero
                 move 18 to ws-ab-numeric-precision (ws-i)
         end-if
       when "date"
         move    10 to ws-ab-maximum-length (ws-i)
       when "datetime"
       when "timestamp"
         move    19 to ws-ab-maximum-length (ws-i)
       when "time"
         move    11 to ws-ab-maximum-length (ws-i)
     end-evaluate.
     add 1 to ws-i.
     if       ws-i not > ws-array-high-point
              go to 2100-get-lengths-loop.
     initialize output-record.
     move     "01" to output-record (8:2).
     string   "MYSQL-"
              ws-field-prefix delimited by space
              "-BUFFER."
                     into ws-build-field-name.
     move     function upper-case (ws-build-field-name) to output-record (12:32).
     write    output-record.
     move     1 to ws-i.
 2200-display-loop.
     initialize output-record.
     move     "05" to output-record (12:2).
     string   ws-field-prefix delimited by space
              "-"
              ws-ab-column-name (ws-i)
                    into ws-build-field-name.
     move     function upper-case (ws-build-field-name) to output-record (16:32).
     move     "PIC" to output-record (48:3).
     evaluate ws-ab-data-type (ws-i)
       when "decimal"
       when "dec"
         subtract ws-ab-numeric-scale (ws-i) from ws-ab-numeric-precision (ws-i)
     end-evaluate.
     evaluate ws-ab-data-type (ws-i)
       when "decimal"
       when "dec"
       when "tinyint"
       when "smallint"
       when "int"
       when "bigint"
       when "mediumint"
       when "year"
              move zero to ws-A                                                    *> vbc 21/08/16
              inspect  ws-ab-column-type (ws-i) tallying ws-A for all "unsigned"   *>  & 4 lines
              if ws-A = zero
                    move "S9(" to output-record (52:3)
              else
                    move " 9(" to output-record (52:3)
              end-if
*>        move "S9(" to output-record (52:3)                                      *> vbc 21/08/16
         move ws-ab-numeric-precision (ws-i) to ws-ed2
         move ws-ed2 to output-record (55:2)
         if ws-ab-numeric-scale (ws-i) is equal to zero
           then move ") COMP." to output-record (57:7)
           else move ws-ab-numeric-scale (ws-i)
                  to ws-ed2
                move ")V9(" to output-record (57:4)
                move ws-ed2 to output-record (61:2)
                move ") COMP." to output-record (63:7)
         end-if
       when "mediumblob"
       when "mediumtext"
       when "char"
       when "text"
       when "blob"
         move "X(" to output-record (52:2)
         move ws-ab-maximum-length (ws-i) to ws-ed5
         move ws-ed5 to output-record (54:5)
         move ")." to output-record (59:2)
         move "X(" to output-record (52:2)
         move ws-ab-maximum-length (ws-i) to ws-ed5
         move ws-ed5 to output-record (54:5)
         move ")." to output-record (59:2)
       when "date"
         move "X(10)." to output-record (52:6)
       when "datetime"
       when "timestamp"
         move "X(19)." to output-record (52:6)
       when "time"
         move "X(11)." to output-record (52:6)
       when other
*>        add 1 to ws-ab-numeric-precision (ws-i)
         move "X(" to output-record (52:2)
         move ws-ab-numeric-precision (ws-i) to ws-ed3
         move ws-ed3 to output-record (54:3)
         move ")." to output-record (57:2)
     end-evaluate.
     write output-record.
     add 1 to ws-i.
     if ws-i is greater than ws-array-high-point
       then next sentence
       else go to 2200-display-loop.
*>
*>    End Of Job
*>
 2990-exit.
     exit.
*>***************************************************************
*>             Termination                                      *
*>***************************************************************
 9000-end-of-program.
     move     9000 to ws-no-paragraph.
     perform  mysql-1980-close thru mysql-1999-exit.
     close    output-file.
     display  "I) " ws-name-program " COMPLETED NORMALLY AT--"
              function current-date.
*>
 9990-exit.
     exit.
*>
 copy mysql-procedures.
