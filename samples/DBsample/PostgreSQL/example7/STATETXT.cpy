      *>************************************************************************
      *>  This file is part of DBsample.
      *>
      *>  STATETXT.cpy is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  STATETXT.cpy is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with STATETXT.cpy.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************

      *>************************************************************************
      *> Program:      STATETXT.cpy
      *>
      *> Purpose:      SQLCODE and SQLSTATE error messages
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        Use this copy file in GnuCOBOL PostgreSQL programs.
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************

      *> PostgreSQL v10 SQLCODE Error Codes
       01 C-SQL-CODETXT-MAX-LINE       CONSTANT AS 38.
      
       01 WS-SQL-CODETXT.
         02 FILLER PIC X(60) VALUE 
         "+000ECPG_NO_ERROR                                           ".
         02 FILLER PIC X(60) VALUE 
         "+100ECPG_NOT_FOUND                                          ".
         02 FILLER PIC X(60) VALUE 
         "-012ECPG_OUT_OF_MEMORY                                      ".
         02 FILLER PIC X(60) VALUE 
         "-200ECPG_UNSUPPORTED                                        ".
         02 FILLER PIC X(60) VALUE 
         "-201ECPG_TOO_MANY_ARGUMENTS                                 ".
         02 FILLER PIC X(60) VALUE 
         "-202ECPG_TOO_FEW_ARGUMENTS                                  ".
         02 FILLER PIC X(60) VALUE 
         "-203ECPG_TOO_MANY_MATCHES                                   ".
         02 FILLER PIC X(60) VALUE 
         "-204ECPG_INT_FORMAT                                         ".
         02 FILLER PIC X(60) VALUE 
         "-205ECPG_UINT_FORMAT                                        ".
         02 FILLER PIC X(60) VALUE 
         "-206ECPG_FLOAT_FORMAT                                       ".
         02 FILLER PIC X(60) VALUE 
         "-207ECPG_NUMERIC_FORMAT                                     ".
         02 FILLER PIC X(60) VALUE 
         "-208ECPG_INTERVAL_FORMAT                                    ".
         02 FILLER PIC X(60) VALUE 
         "-209ECPG_DATE_FORMAT                                        ".
         02 FILLER PIC X(60) VALUE 
         "-210ECPG_TIMESTAMP_FORMAT                                   ".
         02 FILLER PIC X(60) VALUE 
         "-211ECPG_CONVERT_BOOL                                       ".
         02 FILLER PIC X(60) VALUE 
         "-212ECPG_EMPTY                                              ".
         02 FILLER PIC X(60) VALUE 
         "-213ECPG_MISSING_INDICATOR                                  ".
         02 FILLER PIC X(60) VALUE 
         "-214ECPG_NO_ARRAY                                           ".
         02 FILLER PIC X(60) VALUE 
         "-215ECPG_DATA_NOT_ARRAY                                     ".
         02 FILLER PIC X(60) VALUE 
         "-220ECPG_NO_CONN                                            ".
         02 FILLER PIC X(60) VALUE 
         "-221ECPG_NOT_CONN                                           ".
         02 FILLER PIC X(60) VALUE 
         "-230ECPG_INVALID_STMT                                       ".
         02 FILLER PIC X(60) VALUE 
         "-239ECPG_INFORMIX_DUPLICATE_KEY                             ".
         02 FILLER PIC X(60) VALUE 
         "-240ECPG_UNKNOWN_DESCRIPTOR                                 ".
         02 FILLER PIC X(60) VALUE 
         "-241ECPG_INVALID_DESCRIPTOR_INDEX                           ".
         02 FILLER PIC X(60) VALUE 
         "-242ECPG_UNKNOWN_DESCRIPTOR_ITEM                            ".
         02 FILLER PIC X(60) VALUE 
         "-243ECPG_VAR_NOT_NUMERIC                                    ".
         02 FILLER PIC X(60) VALUE 
         "-244ECPG_VAR_NOT_CHAR                                       ".
         02 FILLER PIC X(60) VALUE 
         "-284ECPG_INFORMIX_SUBSELECT_NOT_ONE                         ".
         02 FILLER PIC X(60) VALUE 
         "-400ECPG_PGSQL                                              ".
         02 FILLER PIC X(60) VALUE 
         "-401ECPG_TRANS                                              ".
         02 FILLER PIC X(60) VALUE 
         "-402ECPG_CONNECT                                            ".
         02 FILLER PIC X(60) VALUE 
         "-403ECPG_DUPLICATE_KEY                                      ".
         02 FILLER PIC X(60) VALUE 
         "-404ECPG_SUBSELECT_NOT_ONE                                  ".
         02 FILLER PIC X(60) VALUE 
         "-602ECPG_WARNING_UNKNOWN_PORTAL                             ".
         02 FILLER PIC X(60) VALUE 
         "-603ECPG_WARNING_IN_TRANSACTION                             ".
         02 FILLER PIC X(60) VALUE 
         "-604ECPG_WARNING_NO_TRANSACTION                             ".
         02 FILLER PIC X(60) VALUE 
         "-605ECPG_WARNING_PORTAL_EXISTS                              ".

       01 WS-SQL-CODETXT-TAB REDEFINES WS-SQL-CODETXT.
         02 WS-SQL-CODETXT-LINES OCCURS C-SQL-CODETXT-MAX-LINE TIMES 
                                         INDEXED BY WS-CODETXT-IDX.
           03 WS-SQL-CODETXT-LINE.
             04 WS-SQL-CODETXT-NUM     PIC S9(3) SIGN LEADING SEPARATE.
             04 WS-SQL-CODETXT-TEXT    PIC X(56).
      
      *>--------------------------------------------------------------- 
      *> PostgreSQL v10 SQLSTATE Error Codes
       01 C-SQL-STATETXT-MAX-LINE      CONSTANT AS 240.
      
       01 WS-SQL-STATETXT.
      *> Class 00 - Successful Completion
         02 FILLER PIC X(60) VALUE 
         "00000successful completion                                  ". 
      *> Class 01 - Warning
         02 FILLER PIC X(60) VALUE 
         "01000warning                                                ".
         02 FILLER PIC X(60) VALUE 
         "0100Cdynamic result sets returned                           ".
         02 FILLER PIC X(60) VALUE 
         "01008implicit zero bit padding                              ".
         02 FILLER PIC X(60) VALUE 
         "01003null value eliminated in set function                  ".
         02 FILLER PIC X(60) VALUE 
         "01007privilege not granted                                  ".
         02 FILLER PIC X(60) VALUE 
         "01006privilege not revoked                                  ".
         02 FILLER PIC X(60) VALUE 
         "01004string data right truncation                           ".
         02 FILLER PIC X(60) VALUE 
         "01P01deprecated feature                                     ".
      *> Class 02 - No Data (this is also a warning class per the SQL standard)
         02 FILLER PIC X(60) VALUE 
         "02000no data                                                ".
         02 FILLER PIC X(60) VALUE 
         "02001no additional dynamic result sets returned             ".
      *> Class 03 - SQL Statement Not Yet Complete
         02 FILLER PIC X(60) VALUE 
         "03000sql statement not yet complete                         ".
      *> Class 08 - Connection Exception
         02 FILLER PIC X(60) VALUE 
         "08000connection exception                                   ".
         02 FILLER PIC X(60) VALUE 
         "08003connection does not exist                              ".
         02 FILLER PIC X(60) VALUE 
         "08006connection failure                                     ".
         02 FILLER PIC X(60) VALUE 
         "08001sqlclient unable to establish sqlconnection            ".
         02 FILLER PIC X(60) VALUE 
         "08004sqlserver rejected establishment of sqlconnection      ".
         02 FILLER PIC X(60) VALUE 
         "08007transaction resolution unknown                         ".
         02 FILLER PIC X(60) VALUE 
         "08P01protocol violation                                     ".
      *> Class 09 - Triggered Action Exception
         02 FILLER PIC X(60) VALUE 
         "09000triggered action exception                             ".
      *> Class 0A - Feature Not Supported
         02 FILLER PIC X(60) VALUE 
         "0A000feature not supported                                  ".
      *> Class 0B - Invalid Transaction Initiation
         02 FILLER PIC X(60) VALUE 
         "0B000invalid transaction initiation                         ".
      *> Class 0F - Locator Exception
         02 FILLER PIC X(60) VALUE 
         "0F000locator exception                                      ".
         02 FILLER PIC X(60) VALUE 
         "0F001invalid locator specification                          ".
      *> Class 0L - Invalid Grantor
         02 FILLER PIC X(60) VALUE 
         "0L000invalid grantor                                        ".
         02 FILLER PIC X(60) VALUE 
         "0LP01invalid grant operation                                ".
      *> Class 0P - Invalid Role Specification
         02 FILLER PIC X(60) VALUE 
         "0P000invalid role specification                             ".
      *> Class 0Z - Diagnostics Exception
         02 FILLER PIC X(60) VALUE 
         "0Z000diagnostics exception                                  ".
         02 FILLER PIC X(60) VALUE 
         "0Z002stacked diagnostics accessed without active handler    ".
      *> Class 20 - Case Not Found
         02 FILLER PIC X(60) VALUE 
         "20000case not found                                         ".
      *> Class 21 - Cardinality Violation
         02 FILLER PIC X(60) VALUE 
         "21000cardinality violation                                  ".
      *> Class 22 - Data Exception
         02 FILLER PIC X(60) VALUE 
         "22000data exception                                         ".
         02 FILLER PIC X(60) VALUE 
         "2202Earray subscript error                                  ".
         02 FILLER PIC X(60) VALUE 
         "22021character not in repertoire                            ".
         02 FILLER PIC X(60) VALUE 
         "22008datetime field overflow                                ".
         02 FILLER PIC X(60) VALUE 
         "22012division by zero                                       ".
         02 FILLER PIC X(60) VALUE 
         "22005error in assignment                                    ".
         02 FILLER PIC X(60) VALUE 
         "2200Bescape character conflict                              ".
         02 FILLER PIC X(60) VALUE 
         "22022indicator overflow                                     ".
         02 FILLER PIC X(60) VALUE 
         "22015interval field overflow                                ".
         02 FILLER PIC X(60) VALUE 
         "2201Einvalid argument for logarithm                         ".
         02 FILLER PIC X(60) VALUE 
         "22014invalid argument for ntile function                    ".
         02 FILLER PIC X(60) VALUE 
         "22016invalid argument for nth value function                ".
         02 FILLER PIC X(60) VALUE 
         "2201Finvalid argument for power function                    ".
         02 FILLER PIC X(60) VALUE 
         "2201Ginvalid argument for width bucket function             ".
         02 FILLER PIC X(60) VALUE 
         "22018invalid character value for cast                       ".
         02 FILLER PIC X(60) VALUE 
         "22007invalid datetime format                                ".
         02 FILLER PIC X(60) VALUE 
         "22019invalid escape character                               ".
         02 FILLER PIC X(60) VALUE 
         "2200Dinvalid escape octet                                   ".
         02 FILLER PIC X(60) VALUE 
         "22025invalid escape sequence                                ".
         02 FILLER PIC X(60) VALUE 
         "22P06nonstandard use of escape character                    ".
         02 FILLER PIC X(60) VALUE 
         "22010invalid indicator parameter value                      ".
         02 FILLER PIC X(60) VALUE 
         "22023invalid parameter value                                ".
         02 FILLER PIC X(60) VALUE 
         "2201Binvalid regular expression                             ".
         02 FILLER PIC X(60) VALUE 
         "2201Winvalid row count in limit clause                      ".
         02 FILLER PIC X(60) VALUE 
         "2201Xinvalid row count in result offset clause              ".
         02 FILLER PIC X(60) VALUE 
         "2202Hinvalid tablesample argument                           ".
         02 FILLER PIC X(60) VALUE 
         "2202Ginvalid tablesample repeat                             ".
         02 FILLER PIC X(60) VALUE 
         "22009invalid time zone displacement value                   ".
         02 FILLER PIC X(60) VALUE 
         "2200Cinvalid use of escape character                        ".
         02 FILLER PIC X(60) VALUE 
         "2200Gmost specific type mismatch                            ".
         02 FILLER PIC X(60) VALUE 
         "22004null value not allowed                                 ".
         02 FILLER PIC X(60) VALUE 
         "22002null value no indicator parameter                      ".
         02 FILLER PIC X(60) VALUE 
         "22003numeric value out of range                             ".
         02 FILLER PIC X(60) VALUE 
         "2200Hsequence generator limit exceeded                      ".
         02 FILLER PIC X(60) VALUE 
         "22026string data length mismatch                            ".
         02 FILLER PIC X(60) VALUE 
         "22001string data right truncation                           ".
         02 FILLER PIC X(60) VALUE 
         "22011substring error                                        ".
         02 FILLER PIC X(60) VALUE 
         "22027trim error                                             ".
         02 FILLER PIC X(60) VALUE 
         "22024unterminated c string                                  ".
         02 FILLER PIC X(60) VALUE 
         "2200Fzero length character string                           ".
         02 FILLER PIC X(60) VALUE 
         "22P01floating point exception                               ".
         02 FILLER PIC X(60) VALUE 
         "22P02invalid text representation                            ".
         02 FILLER PIC X(60) VALUE 
         "22P03invalid binary representation                          ".
         02 FILLER PIC X(60) VALUE 
         "22P04bad copy file format                                   ".
         02 FILLER PIC X(60) VALUE 
         "22P05untranslatable character                               ".
         02 FILLER PIC X(60) VALUE 
         "2200Lnot an xml document                                    ".
         02 FILLER PIC X(60) VALUE 
         "2200Minvalid xml document                                   ".
         02 FILLER PIC X(60) VALUE 
         "2200Ninvalid xml content                                    ".
         02 FILLER PIC X(60) VALUE 
         "2200Sinvalid xml comment                                    ".
         02 FILLER PIC X(60) VALUE 
         "2200Tinvalid xml processing instruction                     ".
      *> Class 23 - Integrity Constraint Violation
         02 FILLER PIC X(60) VALUE 
         "23000integrity constraint violation                         ".
         02 FILLER PIC X(60) VALUE 
         "23001restrict violation                                     ".
         02 FILLER PIC X(60) VALUE 
         "23502not null violation                                     ".
         02 FILLER PIC X(60) VALUE 
         "23503foreign key violation                                  ".
         02 FILLER PIC X(60) VALUE 
         "23505unique violation                                       ".
         02 FILLER PIC X(60) VALUE 
         "23514check violation                                        ".
         02 FILLER PIC X(60) VALUE 
         "23P01exclusion violation                                    ".
      *> Class 24 - Invalid Cursor State
         02 FILLER PIC X(60) VALUE 
         "24000invalid cursor state                                   ".
      *> Class 25 - Invalid Transaction State
         02 FILLER PIC X(60) VALUE 
         "25000invalid transaction state                              ". 
         02 FILLER PIC X(60) VALUE 
         "25001active sql transaction                                 ".
         02 FILLER PIC X(60) VALUE 
         "25002branch transaction already active                      ".
         02 FILLER PIC X(60) VALUE 
         "25008held cursor requires same isolation level              ".
         02 FILLER PIC X(60) VALUE 
         "25003inappropriate access mode for branch transaction       ".
         02 FILLER PIC X(60) VALUE 
         "25004inappropriate isolation level for branch transaction   ".
         02 FILLER PIC X(60) VALUE 
         "25005no active sql transaction for branch transaction       ".
         02 FILLER PIC X(60) VALUE 
         "25006read only sql transaction                              ".
         02 FILLER PIC X(60) VALUE 
         "25007schema and data statement mixing not supported         ".
         02 FILLER PIC X(60) VALUE 
         "25P01no active sql transaction                              ".
         02 FILLER PIC X(60) VALUE 
         "25P02in failed sql transaction                              ".
         02 FILLER PIC X(60) VALUE 
         "25P03idle in transaction session timeout                    ".
      *> Class 26 - Invalid SQL Statement Name
         02 FILLER PIC X(60) VALUE 
         "26000invalid sql statement name                             ".
      *> Class 27 - Triggered Data Change Violation
         02 FILLER PIC X(60) VALUE 
         "27000triggered data change violation                        ".
      *> Class 28 - Invalid Authorization Specification
         02 FILLER PIC X(60) VALUE 
         "28000invalid authorization specification                    ".
         02 FILLER PIC X(60) VALUE 
         "28P01invalid password                                       ".
      *> Class 2B - Dependent Privilege Descriptors Still Exist
         02 FILLER PIC X(60) VALUE 
         "2B000dependent privilege descriptors still exist            ".
         02 FILLER PIC X(60) VALUE 
         "2BP01dependent objects still exist                          ".
      *> Class 2D - Invalid Transaction Termination
         02 FILLER PIC X(60) VALUE 
         "2D000invalid transaction termination                        ".
      *> Class 2F - SQL Routine Exception
         02 FILLER PIC X(60) VALUE 
         "2F000sql routine exception                                  ".
         02 FILLER PIC X(60) VALUE 
         "2F005function executed no return statement                  ".
         02 FILLER PIC X(60) VALUE 
         "2F002modifying sql data not permitted                       ".
         02 FILLER PIC X(60) VALUE 
         "2F003prohibited sql statement attempted                     ".
         02 FILLER PIC X(60) VALUE 
         "2F004reading sql data not permitted                         ".
      *> Class 34 - Invalid Cursor Name
         02 FILLER PIC X(60) VALUE 
         "34000invalid cursor name                                    ".
      *> Class 38 - External Routine Exception
         02 FILLER PIC X(60) VALUE 
         "38000external routine exception                             ".
         02 FILLER PIC X(60) VALUE 
         "38001containing sql not permitted                           ".
         02 FILLER PIC X(60) VALUE 
         "38002modifying sql data not permitted                       ".
         02 FILLER PIC X(60) VALUE 
         "38003prohibited sql statement attempted                     ".
         02 FILLER PIC X(60) VALUE 
         "38004reading sql data not permitted                         ".
      *> Class 39 - External Routine Invocation Exception
         02 FILLER PIC X(60) VALUE 
         "39000external routine invocation exception                  ". 
         02 FILLER PIC X(60) VALUE 
         "39001invalid sqlstate returned                              ".
         02 FILLER PIC X(60) VALUE 
         "39004null value not allowed                                 ".
         02 FILLER PIC X(60) VALUE 
         "39P01trigger protocol violated                              ".
         02 FILLER PIC X(60) VALUE 
         "39P02srf protocol violated                                  ".
         02 FILLER PIC X(60) VALUE 
         "39P03event trigger protocol violated                        ".
      *> Class 3B - Savepoint Exception
         02 FILLER PIC X(60) VALUE 
         "3B000savepoint exception                                    ".
         02 FILLER PIC X(60) VALUE 
         "3B001invalid savepoint specification                        ".
      *> Class 3D - Invalid Catalog Name
         02 FILLER PIC X(60) VALUE 
         "3D000invalid catalog name                                   ".
      *> Class 3F - Invalid Schema Name
         02 FILLER PIC X(60) VALUE 
         "3F000invalid schema name                                    ".
      *> Class 40 - Transaction Rollback
         02 FILLER PIC X(60) VALUE 
         "40000transaction rollback                                   ".
         02 FILLER PIC X(60) VALUE 
         "40002transaction integrity constraint violation             ".
         02 FILLER PIC X(60) VALUE 
         "40001serialization failure                                  ".
         02 FILLER PIC X(60) VALUE 
         "40003statement completion unknown                           ".
         02 FILLER PIC X(60) VALUE 
         "40P01deadlock detected                                      ".
      *> Class 42 - Syntax Error or Access Rule Violation
         02 FILLER PIC X(60) VALUE 
         "42000syntax error or access rule violation                  ".
         02 FILLER PIC X(60) VALUE 
         "42601syntax error                                           ".
         02 FILLER PIC X(60) VALUE 
         "42501insufficient privilege                                 ".
         02 FILLER PIC X(60) VALUE 
         "42846cannot coerce                                          ".
         02 FILLER PIC X(60) VALUE 
         "42803grouping error                                         ".
         02 FILLER PIC X(60) VALUE 
         "42P20windowing error                                        ".
         02 FILLER PIC X(60) VALUE 
         "42P19invalid recursion                                      ".
         02 FILLER PIC X(60) VALUE 
         "42830invalid foreign key                                    ".
         02 FILLER PIC X(60) VALUE 
         "42602invalid name                                           ".
         02 FILLER PIC X(60) VALUE 
         "42622name too long                                          ".
         02 FILLER PIC X(60) VALUE 
         "42939reserved name                                          ".
         02 FILLER PIC X(60) VALUE 
         "42804datatype mismatch                                      ".
         02 FILLER PIC X(60) VALUE 
         "42P18indeterminate datatype                                 ".
         02 FILLER PIC X(60) VALUE 
         "42P21collation mismatch                                     ".
         02 FILLER PIC X(60) VALUE 
         "42P22indeterminate collation                                ".
         02 FILLER PIC X(60) VALUE 
         "42809wrong object type                                      ".
         02 FILLER PIC X(60) VALUE 
         "428C9generated always                                       ".
         02 FILLER PIC X(60) VALUE 
         "42703undefined column                                       ".
         02 FILLER PIC X(60) VALUE 
         "42883undefined function                                     ".
         02 FILLER PIC X(60) VALUE 
         "42P01undefined table                                        ".
         02 FILLER PIC X(60) VALUE 
         "42P02undefined parameter                                    ".
         02 FILLER PIC X(60) VALUE 
         "42704undefined object                                       ".
         02 FILLER PIC X(60) VALUE 
         "42701duplicate column                                       ".
         02 FILLER PIC X(60) VALUE 
         "42P03duplicate cursor                                       ".
         02 FILLER PIC X(60) VALUE 
         "42P04duplicate database                                     ".
         02 FILLER PIC X(60) VALUE 
         "42723duplicate function                                     ".
         02 FILLER PIC X(60) VALUE 
         "42P05duplicate prepared statement                           ".
         02 FILLER PIC X(60) VALUE 
         "42P06duplicate schema                                       ".
         02 FILLER PIC X(60) VALUE 
         "42P07duplicate table                                        ".
         02 FILLER PIC X(60) VALUE 
         "42712duplicate alias                                        ".
         02 FILLER PIC X(60) VALUE 
         "42710duplicate object                                       ".
         02 FILLER PIC X(60) VALUE 
         "42702ambiguous column                                       ".
         02 FILLER PIC X(60) VALUE 
         "42725ambiguous function                                     ".
         02 FILLER PIC X(60) VALUE 
         "42P08ambiguous parameter                                    ".
         02 FILLER PIC X(60) VALUE 
         "42P09ambiguous alias                                        ".
         02 FILLER PIC X(60) VALUE 
         "42P10invalid column reference                               ".
         02 FILLER PIC X(60) VALUE 
         "42611invalid column definition                              ".
         02 FILLER PIC X(60) VALUE 
         "42P11invalid cursor definition                              ".
         02 FILLER PIC X(60) VALUE 
         "42P12invalid database definition                            ".
         02 FILLER PIC X(60) VALUE 
         "42P13invalid function definition                            ".
         02 FILLER PIC X(60) VALUE 
         "42P14invalid prepared statement definition                  ".
         02 FILLER PIC X(60) VALUE 
         "42P15invalid schema definition                              ".
         02 FILLER PIC X(60) VALUE 
         "42P16invalid table definition                               ".
         02 FILLER PIC X(60) VALUE 
         "42P17invalid object definition                              ".
      *> Class 44 - WITH CHECK OPTION Violation
         02 FILLER PIC X(60) VALUE 
         "44000with check option violation                            ".
      *> Class 53 - Insufficient Resources
         02 FILLER PIC X(60) VALUE 
         "53000insufficient resources                                 ".
         02 FILLER PIC X(60) VALUE 
         "53100disk full                                              ".
         02 FILLER PIC X(60) VALUE 
         "53200out of memory                                          ".
         02 FILLER PIC X(60) VALUE 
         "53300too many connections                                   ".
         02 FILLER PIC X(60) VALUE 
         "53400configuration limit exceeded                           ".
      *> Class 54 - Program Limit Exceeded
         02 FILLER PIC X(60) VALUE 
         "54000program limit exceeded                                 ". 
         02 FILLER PIC X(60) VALUE 
         "54001statement too complex                                  ".
         02 FILLER PIC X(60) VALUE 
         "54011too many columns                                       ".
         02 FILLER PIC X(60) VALUE 
         "54023too many arguments                                     ".
      *> Class 55 - Object Not In Prerequisite State
         02 FILLER PIC X(60) VALUE 
         "55000object not in prerequisite state                       ".
         02 FILLER PIC X(60) VALUE 
         "55006object in use                                          ".
         02 FILLER PIC X(60) VALUE 
         "55P02cant change runtime param                              ".
         02 FILLER PIC X(60) VALUE 
         "55P03lock not available                                     ".
      *> Class 57 - Operator Intervention
         02 FILLER PIC X(60) VALUE 
         "57000operator intervention                                  ". 
         02 FILLER PIC X(60) VALUE 
         "57014query canceled                                         ".
         02 FILLER PIC X(60) VALUE 
         "57P01admin shutdown                                         ".
         02 FILLER PIC X(60) VALUE 
         "57P02crash shutdown                                         ".
         02 FILLER PIC X(60) VALUE 
         "57P03cannot connect now                                     ".
         02 FILLER PIC X(60) VALUE 
         "57P04database dropped                                       ".
      *> Class 58 - System Error (errors external to PostgreSQL itself)
         02 FILLER PIC X(60) VALUE 
         "58000system error                                           ". 
         02 FILLER PIC X(60) VALUE 
         "58030io error                                               ".
         02 FILLER PIC X(60) VALUE 
         "58P01undefined file                                         ".
         02 FILLER PIC X(60) VALUE 
         "58P02duplicate file                                         ".
      *> Class 72 - Snapshot Failure
         02 FILLER PIC X(60) VALUE 
         "72000snapshot too old                                       ".
      *> Class F0 - Configuration File Error
         02 FILLER PIC X(60) VALUE 
         "F0000config file error                                      ". 
         02 FILLER PIC X(60) VALUE 
         "F0001lock file exists                                       ".
      *> Class HV - Foreign Data Wrapper Error (SQL/MED)
         02 FILLER PIC X(60) VALUE 
         "HV000fdw error                                              ".
         02 FILLER PIC X(60) VALUE 
         "HV005fdw column name not found                              ".
         02 FILLER PIC X(60) VALUE 
         "HV002fdw dynamic parameter value needed                     ".
         02 FILLER PIC X(60) VALUE 
         "HV010fdw function sequence error                            ".
         02 FILLER PIC X(60) VALUE 
         "HV021fdw inconsistent descriptor information                ".
         02 FILLER PIC X(60) VALUE 
         "HV024fdw invalid attribute value                            ".
         02 FILLER PIC X(60) VALUE 
         "HV007fdw invalid column name                                ".
         02 FILLER PIC X(60) VALUE 
         "HV008fdw invalid column number                              ".
         02 FILLER PIC X(60) VALUE 
         "HV004fdw invalid data type                                  ".
         02 FILLER PIC X(60) VALUE 
         "HV006fdw invalid data type descriptors                      ".
         02 FILLER PIC X(60) VALUE 
         "HV091fdw invalid descriptor field identifier                ".
         02 FILLER PIC X(60) VALUE 
         "HV00Bfdw invalid handle                                     ".
         02 FILLER PIC X(60) VALUE 
         "HV00Cfdw invalid option index                               ".
         02 FILLER PIC X(60) VALUE 
         "HV00Dfdw invalid option name                                ".
         02 FILLER PIC X(60) VALUE 
         "HV090fdw invalid string length or buffer length             ".
         02 FILLER PIC X(60) VALUE 
         "HV00Afdw invalid string format                              ".
         02 FILLER PIC X(60) VALUE 
         "HV009fdw invalid use of null pointer                        ".
         02 FILLER PIC X(60) VALUE 
         "HV014fdw too many handles                                   ".
         02 FILLER PIC X(60) VALUE 
         "HV001fdw out of memory                                      ".
         02 FILLER PIC X(60) VALUE 
         "HV00Pfdw no schemas                                         ".
         02 FILLER PIC X(60) VALUE 
         "HV00Jfdw option name not found                              ".
         02 FILLER PIC X(60) VALUE 
         "HV00Kfdw reply handle                                       ".
         02 FILLER PIC X(60) VALUE 
         "HV00Qfdw schema not found                                   ".
         02 FILLER PIC X(60) VALUE 
         "HV00Rfdw table not found                                    ".
         02 FILLER PIC X(60) VALUE 
         "HV00Lfdw unable to create execution                         ".
         02 FILLER PIC X(60) VALUE 
         "HV00Mfdw unable to create reply                             ".
         02 FILLER PIC X(60) VALUE 
         "HV00Nfdw unable to establish connection                     ".
      *> Class P0 - PL/pgSQL Error
         02 FILLER PIC X(60) VALUE 
         "P0000plpgsql error                                          ".
         02 FILLER PIC X(60) VALUE 
         "P0001raise exception                                        ".
         02 FILLER PIC X(60) VALUE 
         "P0002no data found                                          ".
         02 FILLER PIC X(60) VALUE 
         "P0003too many rows                                          ".
         02 FILLER PIC X(60) VALUE 
         "P0004assert failure                                         ".
      *> Class XX - Internal Error
         02 FILLER PIC X(60) VALUE 
         "XX000internal error                                         ".
         02 FILLER PIC X(60) VALUE 
         "XX001data corrupted                                         ".
         02 FILLER PIC X(60) VALUE 
         "XX002index corrupted                                        ".
      
       01 WS-SQL-STATETXT-TAB REDEFINES WS-SQL-STATETXT.
         02 WS-SQL-STATETXT-LINES OCCURS C-SQL-STATETXT-MAX-LINE TIMES 
                                         INDEXED BY WS-STATETXT-IDX.
           03 WS-SQL-STATETXT-LINE.
             04 WS-SQL-STATETXT-NUM    PIC X(5).
             04 WS-SQL-STATETXT-TEXT   PIC X(55).
