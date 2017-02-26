*>
*>***********************************************************
*> NOTE:  This COPY code block [ Mysql-Variables ] must be  *
*>        included in all modules that call SQL procedures  *
*>        using the Currey SQL pre compiler along with the  *
*>        Mysql-Procedures COPY block.                      *
*>                                                          *
*>   Variables used to work with mysql api                  *
*>                                                          *
*>   version 001--original version                          *
*>                                                          *
*>   version 002--increased size of mysql command to        *
*>                4096 from 1024.                           *
*>                1331214--jim currey                       *
*>                12/17/2009--jose rosado                   *
*>                                                          *
*>   version 003--changed count rows variable to            *
*>                to comp-5 to correct problem on sys0u.    *
*>                1343983--jim currey                       *
*>                03/09/2010--jose rosado                   *
*>                                                          *
*>   version 004--Changed to free format                    *
*>                01/07/2016-- Vincent Coen                 *
*>                                                          *
*>   version 005--Changed count rows var to unsigned        *
*>                as not handling > 127 column tables       *
*>                No I don't understand it as well !        *
*>                15/09/2016--Vincent Coen                  *
*>                                                          *
*>   version 006--Added vars for locked table error         *
*>                Processing, see blocks Mysql-1210         *
*>                and Mysql-1300 in mysql-procedure.        *
*>                2016--Vincent Coen                        *
*>                                                          *
*>   version 007--Changes for Count-Rows / -neg             *
*>                Increased size for error-message.         *
*>                Added SQLSTATE, includes new code in      *
*>                cobmysqlapi38.c                           *
*>                This captures error codes on Dup keys     *
*>                on insert, which errno does not.          *
*>                Extra Result pointers when using more     *
*>                than one table FETCH - save -Result to    *
*>                Result-2 or 3 before restoring on Fetch   *
*>                for original table operations using       *
*>                Save-Result -rg1/2 etc                    *
*>                The above 'ASSUMES' using same DB.        *
*>                27/12/2016--Vincent Coen                  *
*> Comments updated:                                        *
*>                10/01/2017--Vincent Coen                  *
*>                                                          *
*>***********************************************************
*>                                                          *
*> NOTE! ws-mysql-count-rows must be a comp-5 on ia64       *
*> machines (little endian) and comp on other machines      *
*> (big-endian)!                                            *
*>                                                          *
*>  According to Mysql C specs should be ulonglong,         *
*>   equivalent - changed. vbc --27/12/16.                  *
*>                                                          *
*>***********************************************************
*>
 01  Ws-Mysql-Cid                        pointer.
 01  Ws-Mysql-Result                     pointer.
 01  Ws-Mysql-Result-rg1                 pointer.
 01  Ws-Mysql-Result-rg2                 pointer.
 01  WS-Mysql-Save-Result                pointer.
 01  WS-Mysql-Save-Result-rg1            pointer.
 01  WS-Mysql-Save-Result-rg2            pointer.
 01  WS-Mysql-Swap-Result                pointer.
 01  Ws-Mysql-Count-Rows                 binary-double unsigned.   *>  pic 9(9)  comp. *> s9(9) comp.
 01  WS-Mysql-Count-Rows-Neg redefines WS-Mysql-Count-Rows
                                         binary-double signed.
*>01  Ws-Mysql-Count-Rows                 pic 9(9)  comp-5. *> s9(9) comp-5.
 01  WS-Mysql-Count-Rows-rg1             binary-double unsigned.
 01  WS-Mysql-Count-Rows-rg2             binary-double unsigned.
 01  WS-Mysql-Save-Count-Rows            binary-double unsigned.
 01  WS-Mysql-Save-Count-Rows-rg1        binary-double unsigned.
 01  WS-Mysql-Save-Count-Rows-rg2        binary-double unsigned.
 01  WS-Mysql-Count-Rows-Swap            binary-double unsigned.
*>
 01  Ws-Mysql-Error-Number               pic x(5).   *> changed to 5 char 18/09/16
 01  WS-Mysql-SqlState                   pic x(5).
 01  Ws-Mysql-Error-Message              pic x(160).  *> 80
 01  Ws-Mysql-Host-Name                  pic x(64)   value spaces.
 01  Ws-Mysql-Implementation             pic x(64)   value spaces.
 01  Ws-Mysql-Password                   pic x(64)   value spaces.
 01  Ws-Mysql-Base-Name                  pic x(64)   value spaces.
 01  Ws-Mysql-Port-Number                pic x(4)    value spaces.
 01  Ws-Mysql-Socket                     pic x(64)   value spaces.
 01  Ws-Mysql-Command                    pic x(4096) value spaces.
 01  Ws-Mysql-Command-Hold               pic x(4096).
 01  Ws-Mysql-Data-Buffer                pic x(4096).
*>
*>  Below used in Mysql-Procedures at 1210 & 1300 and both 01's need to be zero
*>  prior to call to 1210 (using /MYSQL INSERT\ etc).
*>
 01  WS-SQL-Retry        pic 99    comp value zero.  *> 1 = yes
 01  WS-Mysql-Time-Step  pic 99    comp value zero.
     88  WS-Wait-Zero                   value zero.
     88  WS-Wait-250ms                  value 1.
     88  WS-Wait-500ms                  value 2.
     88  WS-Wait-1s                     value 4.
