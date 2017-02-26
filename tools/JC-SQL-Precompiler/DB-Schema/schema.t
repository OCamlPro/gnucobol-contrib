prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:35      PAGE   1



ANALYSIS-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:32
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

PA-CODE                                           NO   char         3            char(3)                PRI PIC X(3)
                                   CHARACTER-SET-NAME      utf8

PA-GL                                             NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

PA-DESC                                           NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

PA-PRINT                                          NO   char         3            char(3)                    PIC X(3)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:36      PAGE   2


DELIVERY-RECORD
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-09 17:57:47
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

DELIV-KEY                                         NO   char         8            char(8)                PRI PIC X(8)
                                   CHARACTER-SET-NAME      utf8

DELIV-NAME                                        NO   char        30            char(30)                   PIC X(30)
                                   CHARACTER-SET-NAME      utf8

DELIV-ADDRESS                                     NO   char        96            char(96)                   PIC X(96)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:36      PAGE   3


GLBATCH-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:33
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

BATCH-KEY                                         NO   mediumint         7       mediumint(6) unsigned  PRI PIC  9(07) COMP

ITEMS                                             NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

BATCH-STATUS                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

CLEARED-STATUS                                    NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

BCYCLE                                            NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

ENTERED                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

PROOFED                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

POSTED                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

STORED                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

INPUT-GROSS                                       NO   decimal          12    2  decimal(14,2) unsigned     PIC  9(12)V9(02) COMP

INPUT-VAT                                         NO   decimal          12    2  decimal(14,2) unsigned     PIC  9(12)V9(02) COMP

ACTUAL-GROSS                                      NO   decimal          12    2  decimal(14,2) unsigned     PIC  9(12)V9(02) COMP

ACTUAL-VAT                                        NO   decimal          12    2  decimal(14,2) unsigned     PIC  9(12)V9(02) COMP

DESCRIPTION                                       NO   char        24            char(24)                   PIC X(24)
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:36      PAGE   4

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

                                   CHARACTER-SET-NAME      utf8

BDEFAULT                                          NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

CONVENTION                                        NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

BATCH-DEF-AC                                      NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

BATCH-DEF-PC                                      NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

BATCH-DEF-CODE                                    NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

BATCH-DEF-VAT                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

BATCH-START                                       NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:36      PAGE   5


GLLEDGER-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-07 18:14:50
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

LEDGER-KEY                                        NO   int              10       int(8) unsigned        PRI PIC  9(10) COMP

LEDGER-TYPE                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEDGER-PLACE                                      NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

LEDGER-LEVEL                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEDGER-NAME                                       NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

LEDGER-BALANCE                                    NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

LEDGER-LAST                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

LEDGER-Q1                                         NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

LEDGER-Q2                                         NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

LEDGER-Q3                                         NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

LEDGER-Q4                                         NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:37      PAGE   6


GLPOSTING-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-23 21:19:45
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

POST-RRN                                          NO   mediumint         7       mediumint(5) unsigned  PRI PIC  9(07) COMP
                                       COLUMN-COMMENT      Rel. replacement

POST-KEY                                          NO   bigint           20       bigint(10) unsigned        PIC  9(18) COMP

POST-CODE                                         NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

POST-DAT                                          NO   char         8            char(8)                    PIC X(8)
                                   CHARACTER-SET-NAME      utf8

POST-DR                                           NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

DR-PC                                             NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST-CR                                           NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

CR-PC                                             NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST-AMOUNT                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

POST-LEGEND                                       NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

VAT-AC                                            NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

VAT-PC                                            NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:37      PAGE   7

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


POST-VAT-SIDE                                     NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

VAT-AMOUNT                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:37      PAGE   8


IRSDFLT-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        1
           AVG-ROW-LENGTH                   16,384
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-07 18:07:01
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT  Defaults table for IRS
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

DEF-REC-KEY                                       NO   tinyint           3       tinyint(2) unsigned    PRI PIC  9(03) COMP

DEF-ACS                                           NO   decimal           5       decimal(5,0) unsigned      PIC  9(05) COMP

DEF-CODES                                         NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

DEF-VAT                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:37      PAGE   9


IRSFINAL-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-17 20:45:05
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

IRS-FINAL-ACC-REC-KEY                             NO   tinyint           3       tinyint(2) unsigned    PRI PIC  9(03) COMP

IRS-AR1                                           NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

IRS-AR2                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:37      PAGE  10


IRSNL-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-14 18:22:47
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

KEY-1                                             NO   bigint           20       bigint(10) unsigned    PRI PIC  9(18) COMP

TIPE                                              NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

NL-NAME                                           NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

DR                                                NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

CR                                                NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

DR-LAST-01                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

CR-LAST-01                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

DR-LAST-02                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

CR-LAST-02                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

DR-LAST-03                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

CR-LAST-03                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

DR-LAST-04                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

CR-LAST-04                                        NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:38      PAGE  11

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


AC                                                NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

REC-POINTER                                       NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:38      PAGE  12


IRSPOSTING-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-12-31 19:15:14
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

KEY-4                                             NO   mediumint         7       mediumint(5) unsigned  PRI PIC  9(07) COMP

POST4-CODE                                        NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

POST4-DAT                                         NO   char         8            char(8)                    PIC X(8)
                                   CHARACTER-SET-NAME      utf8

POST4-DAY                                         NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST4-MONTH                                       NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST4-YEAR                                        NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST4-DR                                          NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

POST4-CR                                          NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

POST4-AMOUNT                                      NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

POST4-LEGEND                                      NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

VAT-AC-DEF4                                       NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

POST4-VAT-SIDE                                    NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:38      PAGE  13

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


VAT-AMOUNT4                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:38      PAGE  14


PLPAY-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-13 17:32:11
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

PAY-KEY                                           NO   char         9            char(9)                PRI PIC X(9)
                                   CHARACTER-SET-NAME      utf8

PAY-CONT                                          NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

PAY-DAT                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

PAY-CHEQUE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

PAY-SORTCODE                                      NO   int              10       int(6) unsigned            PIC  9(10) COMP

PAY-ACCOUNT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

PAY-GROSS                                         NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:38      PAGE  15


PLPAY-RECrg01
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                   16,384
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-13 17:30:49
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

PAY-FOLIO                                         NO   int              10       int(8) unsigned            PIC  9(10) COMP

PAY-PERIOD                                        NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

PAY-VALUE                                         NO   decimal          10    4  decimal(14,4)              PIC S9(10)V9(04) COMP

PAY-DEDUCT                                        NO   decimal          10    4  decimal(14,4)              PIC S9(10)V9(04) COMP

PAY-INVOICE                                       NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

LEVEL-J                                           NO   tinyint           3       tinyint(1) unsigned    PRI PIC  9(03) COMP

PAY-KEY                                           NO   char         9            char(9)                PRI PIC X(9)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:39      PAGE  16


PSIRSPOST-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-14 18:22:47
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

IRS-POST-KEY                                      NO   bigint           19       bigint(11)             PRI PIC S9(18) COMP

IRS-POST-CODE                                     NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

IRS-POST-DAT                                      NO   char         8            char(8)                    PIC X(8)
                                   CHARACTER-SET-NAME      utf8

IRS-POST-DR                                       NO   int              10       int(5) unsigned            PIC  9(10) COMP

IRS-POST-CR                                       NO   int              10       int(5) unsigned            PIC  9(10) COMP

IRS-POST-AMOUNT                                   NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IRS-POST-LEGEND                                   NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

IRS-VAT-AC-DEF                                    NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

IRS-POST-VAT-SIDE                                 NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

IRS-VAT-AMOUNT                                    NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:39      PAGE  17


PUDELINV-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-06 18:23:27
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

DEL-INV-NOS                                       NO   int              10       int(8) unsigned        PRI PIC  9(10) COMP

DEL-INV-DAT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

DEL-INV-CUS                                       NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:39      PAGE  18


PUINVOICE-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-14 18:22:48
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

INVOICE-KEY                                       NO   bigint           20       bigint(11) unsigned    PRI PIC  9(18) COMP

INVOICE-SUPPLIER                                  NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

INVOICE-DAT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

INV-ORDER                                         NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

INVOICE-TYPE                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IH-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-TEST                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-SUPPLIER                                       NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

IH-DAT                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-ORDER                                          NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IH-TYPE                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IH-REF                                            NO   char        10            char(10)                   PIC X(10)
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:39      PAGE  19

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

                                   CHARACTER-SET-NAME      utf8

IH-P-C                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-EXTRA                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-CARRIAGE                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-DISCOUNT                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-E-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-C-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-STATUS                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-LINES                                          NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-DEDUCT-DAYS                                    NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-DEDUCT-AMT                                     NO   decimal           2    3  decimal(5,3) unsigned      PIC  9(02)V9(03) COMP

IH-DEDUCT-VAT                                     NO   decimal           2    3  decimal(5,3) unsigned      PIC  9(02)V9(03) COMP

IH-DAYS                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-CR                                             NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-DAY-BOOK-FLAG                                  NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IL-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IL-LINE                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IL-PRODUCT                                        NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

IL-PA                                             NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

IL-QTY                                            NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:40      PAGE  20

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


IL-TYPE                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IL-DESCRIPTION                                    NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

IL-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-UNIT                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-DISCOUNT                                       NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

IL-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-VAT-CODE                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IL-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:40      PAGE  21


PULEDGER-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:38
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

PURCH-KEY                                         NO   char         7            char(7)                PRI PIC X(7)
                                   CHARACTER-SET-NAME      utf8

PURCH-STATUS                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PURCH-NOTES-TAG                                   NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PURCH-NAME                                        NO   char        30            char(30)                   PIC X(30)
                                   CHARACTER-SET-NAME      utf8

PURCH-ADDRESS                                     NO   char        96            char(96)                   PIC X(96)
                                   CHARACTER-SET-NAME      utf8

PURCH-PHONE                                       NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

PURCH-EXT                                         NO   char         4            char(4)                    PIC X(4)
                                   CHARACTER-SET-NAME      utf8

PURCH-FAX                                         NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

PURCH-EMAIL                                       NO   char        30            char(30)                   PIC X(30)
                                   CHARACTER-SET-NAME      utf8

PURCH-DISCOUNT                                    NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:41      PAGE  22

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

PURCH-CREDIT                                      NO   mediumint         7       mediumint(2) unsigned      PIC  9(07) COMP

PURCH-SORTCODE                                    NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

PURCH-ACCOUNTNO                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-LIMIT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-ACTIVETY                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-LAST-INV                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-LAST-PAY                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-AVERAGE                                     NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-CREATE-DAT                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-PAY-ACTIVETY                                NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-PAY-AVERAGE                                 NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-PAY-WORST                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

PURCH-CURRENT                                     NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PURCH-LAST                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q1                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q2                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q3                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q4                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PURCH-UNAPPLIED                                   NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:41      PAGE  23


PUOIFILE5-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:39
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

INVOICE-NOS                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

ITEM-NOS                                          NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

OI5-INVOICE-KEY                                   NO   char        10            char(10)               PRI PIC X(10)
                                   CHARACTER-SET-NAME      utf8

INVOICE-SUPPLIER                                  NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

INVOICE-DAT                                       NO   int              10       int(11)                    PIC S9(10) COMP

INV-ORDER                                         NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

INVOICE-TYPE                                      NO   int              10       int(11)                    PIC S9(10) COMP

IH-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-TEST                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-SUPPLIER                                       NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

IH-DAT                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-ORDER                                          NO   char        10            char(10)                   PIC X(10)
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:42      PAGE  24

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

                                   CHARACTER-SET-NAME      utf8

IH-TYPE                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IH-REF                                            NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IH-P-C                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-EXTRA                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-CARRIAGE                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-DISCOUNT                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-E-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-C-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-STATUS                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-LINES                                          NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-DEDUCT-DAYS                                    NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-DEDUCT-AMT                                     NO   decimal           3    2  decimal(5,2) unsigned      PIC  9(03)V9(02) COMP

IH-DEDUCT-VAT                                     NO   decimal           3    2  decimal(5,2) unsigned      PIC  9(03)V9(02) COMP

IH-DAYS                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-CR                                             NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-DAY-BOOK-FLAG                                  NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IL-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IL-LINE                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IL-PRODUCT                                        NO   char        12            char(12)                   PIC X(12)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:42      PAGE  25

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


IL-PA                                             NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

IL-QTY                                            NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IL-TYPE                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IL-DESCRIPTION                                    NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

IL-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-UNIT                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-DISCOUNT                                       NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

IL-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-VAT-CODE                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IL-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:43      PAGE  26


SADELINV-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:39
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

DEL-INV-NOS                                       NO   int              10       int(8) unsigned        PRI PIC  9(10) COMP

DEL-INV-DAT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

DEL-INV-CUS                                       NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:43      PAGE  27


SAINV-LINES-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-22 15:03:06
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

IL-LINE-KEY                                       NO   char        10            char(10)               PRI PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IL-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IL-LINE                                           NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

IL-PRODUCT                                        NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

IL-PA                                             NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

IL-QTY                                            NO   smallint          5       smallint(6) unsigned       PIC  9(05) COMP

IL-TYPE                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IL-DESCRIPTION                                    NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

IL-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-UNIT                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-DISCOUNT                                       NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:43      PAGE  28

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

IL-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IL-VAT-CODE                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IL-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:43      PAGE  29


SAINVOICE-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                   16,384
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-01-31 20:05:16
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

SINVOICE-KEY                                      NO   char        10            char(10)               PRI PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IH-INVOICE                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-TEST                                           NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

IH-CUSTOMER                                       NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

IH-DAT                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-ORDER                                          NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IH-TYPE                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

IH-REF                                            NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

IH-DESCRIPTION                                    NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

IH-P-C                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-NET                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:44      PAGE  30

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

IH-EXTRA                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-CARRIAGE                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-VAT                                            NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-DISCOUNT                                       NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-E-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-C-VAT                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

IH-STATUS                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-STATUS-P                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-STATUS-L                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-STATUS-C                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-STATUS-A                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-STATUS-I                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-DEDUCT-DAYS                                    NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-DEDUCT-AMT                                     NO   decimal           3    2  decimal(5,2) unsigned      PIC  9(03)V9(02) COMP

IH-DEDUCT-VAT                                     NO   decimal           3    2  decimal(5,2) unsigned      PIC  9(03)V9(02) COMP

IH-DAYS                                           NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

IH-CR                                             NO   int              10       int(8) unsigned            PIC  9(10) COMP

IH-LINES                                          NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

IH-DAY-BOOK-FLAG                                  NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IH-UPDATE                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OIT3-KEY                                          NO   char        15            char(15)               UNI PIC X(15)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:44      PAGE  31

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


OIT3-APPLIED                                      NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OIT3-BATCH                                        NO   char         8            char(8)                    PIC X(8)
                                   CHARACTER-SET-NAME      utf8

OIT3-DATE-CLEARED                                 NO   int              10       int(8) unsigned            PIC  9(10) COMP

OIT3-HOLD-FLAG                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OIT3-PAID                                         NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OIT3-UNAPL                                        NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:44      PAGE  32


SAITM3-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2017-02-08 17:43:28
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

OI3-KEY                                           NO   char        15            char(15)               PRI PIC X(15)
                                   CHARACTER-SET-NAME      utf8

OI3-CUSTOMER                                      NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

OI3-INVOICE                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

OI3-DAT                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

OI3-BATCH                                         NO   char         8            char(8)                    PIC X(8)
                                   CHARACTER-SET-NAME      utf8

OI3-BATCH-NOS                                     NO   char         5            char(5)                    PIC X(5)
                                   CHARACTER-SET-NAME      utf8
                                       COLUMN-COMMENT      Batch content

OI3-BATCH-ITEM                                    NO   char         3            char(3)                    PIC X(3)
                                   CHARACTER-SET-NAME      utf8
                                       COLUMN-COMMENT      Batch content

OI3-TYPE                                          NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI3-DESCRIPTION                                   NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:45      PAGE  33

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

OI3-HOLD-FLAG                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI3-UNAPL                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI3-P-C                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-NET                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP
                                       COLUMN-COMMENT      Also called Approp

OI3-EXTRA                                         NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-CARRIAGE                                      NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-VAT                                           NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-DISCOUNT                                      NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-E-VAT                                         NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-C-VAT                                         NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-PAID                                          NO   decimal           7    2  decimal(9,2)               PIC S9(07)V9(02) COMP

OI3-STATUS                                        NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI3-DEDUCT-DAYS                                   NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

OI3-DEDUCT-AMT                                    NO   decimal           3    2  decimal(5,2)               PIC S9(03)V9(02) COMP

OI3-DEDUCT-VAT                                    NO   decimal           3    2  decimal(5,2)               PIC S9(03)V9(02) COMP

OI3-DAYS                                          NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

OI3-CR                                            NO   int              10       int(8)                     PIC S9(10) COMP

OI3-APPLIED                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI3-DATE-CLEARED                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:45      PAGE  34


SALEDGER-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:40
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

SALES-KEY                                         NO   char         7            char(7)                PRI PIC X(7)
                                   CHARACTER-SET-NAME      utf8

SALES-NAME                                        NO   char        30            char(30)                   PIC X(30)
                                   CHARACTER-SET-NAME      utf8

SALES-ADDRESS                                     NO   char        96            char(96)                   PIC X(96)
                                   CHARACTER-SET-NAME      utf8

SALES-PHONE                                       NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

SALES-EXT                                         NO   char         4            char(4)                    PIC X(4)
                                   CHARACTER-SET-NAME      utf8

SALES-EMAIL                                       NO   char        30            char(30)                   PIC X(30)
                                   CHARACTER-SET-NAME      utf8

SALES-FAX                                         NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

SALES-STATUS                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SALES-LATE                                        NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SALES-DUNNING                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:46      PAGE  35

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

EMAIL-INVOICE                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

EMAIL-STATEMENT                                   NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

EMAIL-LETTERS                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

DELIVERY-TAG                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

NOTES-TAG                                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SALES-CREDIT                                      NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

SALES-DISCOUNT                                    NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

SALES-LATE-MIN                                    NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

SALES-LATE-MAX                                    NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

SALES-LIMIT                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-ACTIVETY                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-LAST-INV                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-LAST-PAY                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-AVERAGE                                     NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-PAY-ACTIVETY                                NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-PAY-AVERAGE                                 NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-PAY-WORST                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-CREATE-DAT                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

SALES-CURRENT                                     NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SALES-LAST                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q1                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q2                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q3                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

TURNOVER-Q4                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SALES-UNAPPLIED                                   NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:46      PAGE  36


STOCK-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        8
           AVG-ROW-LENGTH                    2,048
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                   32,768
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:41
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

STOCK-KEY                                         NO   char        13            char(13)               PRI PIC X(13)
                                   CHARACTER-SET-NAME      utf8

STOCK-ABREV-KEY                                   NO   char         7            char(7)                MUL PIC X(7)
                                   CHARACTER-SET-NAME      utf8

STOCK-SUPPLIER-P1                                 NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

STOCK-SUPPLIER-P2                                 NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

STOCK-SUPPLIER-P3                                 NO   char         7            char(7)                    PIC X(7)
                                   CHARACTER-SET-NAME      utf8

STOCK-DESC                                        NO   char        32            char(32)               MUL PIC X(32)
                                   CHARACTER-SET-NAME      utf8

STOCK-CONSTRUCT-ITEM                              NO   char        13            char(13)                   PIC X(13)
                                   CHARACTER-SET-NAME      utf8

STOCK-LOCATION                                    NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

STOCK-PA-CODE                                     NO   char         3            char(3)                    PIC X(3)
                                   CHARACTER-SET-NAME      utf8

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:47      PAGE  37

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

STOCK-SA-CODE                                     NO   char         3            char(3)                    PIC X(3)
                                   CHARACTER-SET-NAME      utf8

STOCK-SERVICES-FLAG                               NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

STOCK-LAST-ACTUAL-COST                            NO   decimal           7    2  decimal(9,2) unsigned      PIC  9(07)V9(02) COMP

STOCK-CONSTRUCT-BUNDLE                            NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-UNDER-CONSTRUCTION                          NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-WORK-IN-PROGRESS                            NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-REORDER-PNT                                 NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-STD-REORDER                                 NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-BACK-ORDERED                                NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-ON-ORDER                                    NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-HELD                                        NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-PRE-SALES                                   NO   int              10       int(6)                     PIC S9(10) COMP

STOCK-RETAIL                                      NO   decimal           7    2  decimal(9,2) unsigned      PIC  9(07)V9(02) COMP

STOCK-COST                                        NO   decimal           7    4  decimal(11,4) unsigned     PIC  9(07)V9(04) COMP

STOCK-VALUE                                       NO   decimal           9    2  decimal(11,2) unsigned     PIC  9(09)V9(02) COMP

STOCK-ORDER-DUE                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-ORDER-DAT                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-ADDS                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-DEDUCTS                                     NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-WIP-ADDS                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-WIP-DEDS                                    NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-01                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-02                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-03                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:47      PAGE  38

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

STOCK-TD-ADDS-04                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-05                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-06                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-07                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-08                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-09                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-10                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-11                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-ADDS-12                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-01                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-02                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-03                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-04                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-05                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-06                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-07                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-08                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-09                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-10                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-11                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-DEDS-12                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-01                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-02                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-03                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-04                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:48      PAGE  39

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

STOCK-TD-WIP-ADDS-05                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-06                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-07                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-08                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-09                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-10                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-11                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-ADDS-12                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-01                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-02                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-03                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-04                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-05                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-06                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-07                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-08                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-09                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-10                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-11                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

STOCK-TD-WIP-DEDS-12                              NO   int              10       int(8) unsigned            PIC  9(10) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:49      PAGE  40


STOCKAUDIT-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        1
              CREATE-TIME      2016-09-20 11:12:42
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

AUDIT-ID                                          NO   int              10       int(6) unsigned        PRI PIC  9(10) COMP
                                                EXTRA      auto_increment

AUDIT-KEY                                         NO   char        14            char(14)                   PIC X(14)
                                   CHARACTER-SET-NAME      utf8

AUDIT-INVOICE-PO                                  NO   int              10       int(8) unsigned            PIC  9(10) COMP

AUDIT-CR-FOR-INVOICE                              NO   int              10       int(8) unsigned            PIC  9(10) COMP

AUDIT-DESC                                        NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

AUDIT-PROCESS-DAT                                 NO   char        10            char(10)                   PIC X(10)
                                   CHARACTER-SET-NAME      utf8

AUDIT-REVERSE-TRANSACTION                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

AUDIT-TRANSACTION-QTY                             NO   mediumint         7       mediumint(6)               PIC S9(07) COMP

AUDIT-UNIT-COST                                   NO   decimal           6    4  decimal(10,4)              PIC S9(06)V9(04) COMP

AUDIT-STOCK-VALUE-CHANGE                          NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

AUDIT-NO                                          NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:49      PAGE  41


SYSDEFLT-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-07 18:06:36
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

DEF-REC-KEY                                       NO   tinyint           3       tinyint(2) unsigned    PRI PIC  9(03) COMP

DEF-ACS                                           NO   decimal           4    2  decimal(6,2) unsigned      PIC  9(04)V9(02) COMP

DEF-CODES                                         NO   char         2            char(2)                    PIC X(2)
                                   CHARACTER-SET-NAME      utf8

DEF-VAT                                           NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:49      PAGE  42


SYSFINAL-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:43
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

FINAL-ACC-REC-KEY                                 NO   tinyint           3       tinyint(2) unsigned    PRI PIC  9(03) COMP

AR1                                               NO   char        16            char(16)                   PIC X(16)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:49      PAGE  43


SYSTEM-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        1
           AVG-ROW-LENGTH                   16,384
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-11-30 19:18:51
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

SYSTEM-REC-KEY                                    NO   tinyint           3       tinyint(1) unsigned    PRI PIC  9(03) COMP

SYSTEM-RECORD-VERSION-PRIME                       NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

SYSTEM-RECORD-VERSION-SECONDAR                    NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

VAT-RATE-1                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT-RATE-2                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT-RATE-3                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT-RATE-4                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT-RATE-5                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

CYCLEA                                            NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

PERIOD                                            NO   tinyint           3       tinyint(2) unsigned        PIC  9(03) COMP

PAGE-LINES                                        NO   tinyint           3       tinyint(3) unsigned        PIC  9(03) COMP

NEXT-INVOICE                                      NO   int              10       int(8) unsigned            PIC  9(10) COMP

RUN-DAT                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

START-DAT                                         NO   int              10       int(8) unsigned            PIC  9(10) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:50      PAGE  44

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


END-DAT                                           NO   int              10       int(8) unsigned            PIC  9(10) COMP

SUSER                                             NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

USER-CODE                                         NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

ADDRESS-1                                         NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

ADDRESS-2                                         NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

ADDRESS-3                                         NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

ADDRESS-4                                         NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

POST-CODE                                         NO   char        12            char(12)                   PIC X(12)
                                   CHARACTER-SET-NAME      utf8

COUNTRY                                           NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

PRINT-SPOOL-NAME                                  NO   char        48            char(48)                   PIC X(48)
                                   CHARACTER-SET-NAME      utf8

FILE-STATUSES                                     NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

PASS-VALUE                                        NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-1                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-2                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-3                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-4                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-5                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

LEVEL-6                                           NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PASS-WORD                                         NO   char         4            char(4)                    PIC X(4)
                                   CHARACTER-SET-NAME      utf8

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:50      PAGE  45

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

HOST                                              NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

OP-SYSTEM                                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

CURRENT-QUARTER                                   NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

FILE-SYSTEM-USED                                  NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

FILE-DUPLICATES-IN-USE                            NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

MAPS-SER                                          NO   char         6            char(6)                    PIC X(6)
                                   CHARACTER-SET-NAME      utf8

DATE-FORM                                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

DATA-CAPTURE-USED                                 NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

RDBMS-DB-NAME                                     NO   char        12            char(12)                   PIC X(12)
                                   CHARACTER-SET-NAME      utf8

RDBMS-USER                                        NO   char        12            char(12)                   PIC X(12)
                                   CHARACTER-SET-NAME      utf8

RDBMS-PASSWD                                      NO   char        12            char(12)                   PIC X(12)
                                   CHARACTER-SET-NAME      utf8

RDBMS-PORT                                        NO   char         5            char(5)                    PIC X(5)
                                   CHARACTER-SET-NAME      utf8

RDBMS-HOST                                        NO   char        32            char(32)                   PIC X(32)
                                   CHARACTER-SET-NAME      utf8

RDBMS-SOCKET                                      NO   char        64            char(64)                   PIC X(64)
                                   CHARACTER-SET-NAME      utf8

VAT-REG-NUMBER                                    NO   char        11            char(11)                   PIC X(11)
                                   CHARACTER-SET-NAME      utf8

PARAM-RESTRICT                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

P-C                                               NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

P-C-GROUPED                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

P-C-LEVEL                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:51      PAGE  46

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

COMPS                                             NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

COMPS-ACTIVE                                      NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

M-V                                               NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

ARCH                                              NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

TRANS-PRINT                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

TRANS-PRINTED                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

HEADER-LEVEL                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SALES-RANGE                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PURCHASE-RANGE                                    NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

VAT                                               NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

BATCH-ID                                          NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

LEDGER-2ND-INDEX                                  NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

IRS-INSTEAD                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

LEDGER-SEC                                        NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

UPDATES                                           NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

POSTINGS                                          NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

NEXT-BATCH                                        NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

EXTRA-CHARGE-AC                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

VAT-AC                                            NO   int              10       int(8) unsigned            PIC  9(10) COMP

PRINT-SPOOL-NAME2                                 NO   char        48            char(48)                   PIC X(48)
                                   CHARACTER-SET-NAME      utf8
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:52      PAGE  47

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


NEXT-FOLIO                                        NO   int              10       int(8) unsigned            PIC  9(10) COMP

BL-PAY-AC                                         NO   int              10       int(8) unsigned            PIC  9(10) COMP

P-CREDITORS                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

BL-PURCH-AC                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

BL-END-CYCLE-DAT                                  NO   int              10       int(1) unsigned            PIC  9(10) COMP

BL-NEXT-BATCH                                     NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

AGE-TO-PAY                                        NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

PURCHASE-LEDGER                                   NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

PL-DELIM                                          NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

ENTRY-LEVEL                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

P-FLAG-A                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

P-FLAG-I                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

P-FLAG-P                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PL-STOCK-LINK                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

PRINT-SPOOL-NAME3                                 NO   char        48            char(48)                   PIC X(48)
                                   CHARACTER-SET-NAME      utf8

SALES-LEDGER                                      NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-DELIM                                          NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI-3-FLAG                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

CUST-FLAG                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

OI-5-FLAG                                         NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:52      PAGE  48

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

S-FLAG-OI-3                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

FULL-INVOICING                                    NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

S-FLAG-A                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

S-FLAG-I                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

S-FLAG-P                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SL-DUNNING                                        NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SL-CHARGES                                        NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SL-OWN-NOS                                        NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-STATS-RUN                                      NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SL-DAY-BOOK                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

INVOICER                                          NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

EXTRA-DESC                                        NO   char        14            char(14)                   PIC X(14)
                                   CHARACTER-SET-NAME      utf8

EXTRA-TYPE                                        NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

EXTRA-PRINT                                       NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-STOCK-LINK                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-STOCK-AUDIT                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-LATE-PER                                       NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

SL-DISC                                           NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

EXTRA-RATE                                        NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

SL-DAYS-1                                         NO   smallint          5       smallint(3) unsigned       PIC  9(05) COMP

SL-DAYS-2                                         NO   smallint          5       smallint(3) unsigned       PIC  9(05) COMP

SL-DAYS-3                                         NO   smallint          5       smallint(3) unsigned       PIC  9(05) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:53      PAGE  49

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


SL-CREDIT                                         NO   smallint          5       smallint(3) unsigned       PIC  9(05) COMP

SL-MIN                                            NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

SL-MAX                                            NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

PF-RETENTION                                      NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

FIRST-SL-BATCH                                    NO   smallint          5       smallint(4) unsigned       PIC  9(05) COMP

FIRST-SL-INV                                      NO   int              10       int(8) unsigned            PIC  9(10) COMP

SL-LIMIT                                          NO   int              10       int(8) unsigned            PIC  9(10) COMP

SL-PAY-AC                                         NO   int              10       int(8) unsigned            PIC  9(10) COMP

S-DEBTORS                                         NO   int              10       int(8) unsigned            PIC  9(10) COMP

SL-SALES-AC                                       NO   int              10       int(8) unsigned            PIC  9(10) COMP

S-END-CYCLE-DAT                                   NO   int              10       int(8) unsigned            PIC  9(10) COMP

SL-COMP-HEAD-PICK                                 NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-COMP-HEAD-INV                                  NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-COMP-HEAD-STAT                                 NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-COMP-HEAD-LETS                                 NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

SL-VAT-PRINTED                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

STK-ABREV-REF                                     NO   char         6            char(6)                    PIC X(6)
                                   CHARACTER-SET-NAME      utf8

STK-DEBUG                                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-MANU-USED                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-OE-USED                                       NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-AUDIT-USED                                    NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-MOV-AUDIT                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:54      PAGE  50

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


STK-PERIOD-CUR                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

STK-PERIOD-DAT                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

STOCK-CONTROL                                     NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

STK-AVERAGING                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-ACTIVITY-REP-RUN                              NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

STK-PAGE-LINES                                    NO   tinyint           3       tinyint(4) unsigned        PIC  9(03) COMP

STK-AUDIT-NO                                      NO   tinyint           3       tinyint(4) unsigned        PIC  9(03) COMP

CLIENT                                            NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

NEXT-POST                                         NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

VAT1                                              NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT2                                              NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

VAT3                                              NO   decimal           2    2  decimal(4,2) unsigned      PIC  9(02)V9(02) COMP

IRS-PASS-VALUE                                    NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SAVE-SEQU                                         NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

SYSTEM-WORK-GROUP                                 NO   char        18            char(18)                   PIC X(18)
                                   CHARACTER-SET-NAME      utf8

PL-APP-CREATED                                    NO   char         1            char(1)                    PIC X(1)
                                   CHARACTER-SET-NAME      utf8

PL-APPROP-AC                                      NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

1ST-TIME-FLAG                                     NO   tinyint           3       tinyint(1) unsigned        PIC  9(03) COMP

PL-APPROP-AC6                                     NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:54      PAGE  51


SYSTOT-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        1
           AVG-ROW-LENGTH                   16,384
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-29 13:58:54
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

LEDGER-TOTALS-REC-KEY                             NO   tinyint           3       tinyint(1) unsigned    PRI PIC  9(03) COMP

SL-OS-BAL-LAST-MONTH                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-OS-BAL-THIS-MONTH                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-INVOICES-THIS-MONTH                            NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-CREDIT-NOTES-THIS-MONTH                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-VARIANCE                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-CREDIT-DEDUCTIONS                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-CN-UNAPPL-THIS-MONTH                           NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL-PAYMENTS                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL4-SPARE1                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL4-SPARE2                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-OS-BAL-LAST-MONTH                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-OS-BAL-THIS-MONTH                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-INVOICES-THIS-MONTH                            NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:55      PAGE  52

                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY


PL-CREDIT-NOTES-THIS-MONTH                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-VARIANCE                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-CREDIT-DEDUCTIONS                              NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-CN-UNAPPL-THIS-MONTH                           NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

PL-PAYMENTS                                       NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL4-SPARE3                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP

SL4-SPARE4                                        NO   decimal           8    2  decimal(10,2)              PIC S9(08)V9(02) COMP
prtschema2M 2.12-- ACASDB                                                                        22/02/2017  12:56:55      PAGE  53


VALUEANAL-REC
               TABLE-TYPE  BASE TABLE
                   ENGINE  InnoDB
                  VERSION                       10
               ROW-FORMAT  Compact
               TABLE-ROWS                        0
           AVG-ROW-LENGTH                        0
              DATA-LENGTH                   16,384
          MAX-DATA-LENGTH                        0
             INDEX-LENGTH                        0
              DATA-FREE                          0
           AUTO-INCREMENT                        0
              CREATE-TIME      2016-09-20 11:12:45
              UPDATE-TIME                        0
               CHECK-TIME                        0
          TABLE-COLLATION  utf8_general_ci
                 CHECKSUM                        0
           CREATE-OPTIONS
 DEFAULT CHARACTER SET NM  latin1
       DEFAULT PRIVILEGES  select,insert,update,references
            TABLE-COMMENT
****************************************************************************************************************************************
                                                  NULL TYPE       SIZE LEFT   RT TYPE                   KEY

VA-CODE                                           NO   char         3            char(3)                PRI PIC X(3)
                                   CHARACTER-SET-NAME      utf8

VA-GL                                             NO   mediumint         7       mediumint(6) unsigned      PIC  9(07) COMP

VA-DESC                                           NO   char        24            char(24)                   PIC X(24)
                                   CHARACTER-SET-NAME      utf8

VA-PRINT                                          NO   char         3            char(3)                    PIC X(3)
                                   CHARACTER-SET-NAME      utf8

VA-T-THIS                                         NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

VA-T-LAST                                         NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

VA-T-YEAR                                         NO   mediumint         7       mediumint(5) unsigned      PIC  9(07) COMP

VA-V-THIS                                         NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

VA-V-LAST                                         NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP

VA-V-YEAR                                         NO   decimal           8    2  decimal(10,2) unsigned     PIC  9(08)V9(02) COMP
