      ******************************************************
      *   VARIABLES USED TO WORK WITH MYSQL API            *
      *                                                    *
      *   VERSION 001--ORIGINAL VERSION                    *
      *   VERSION 002--INCREASED SIZE OF MYSQL COMMAND TO  *
      *                4096.                               *
      *                1331214--JIM CURREY                 *
      *                12/17/2009--JOSE ROSADO             *
      *   VERSION 003--CHANGED COUNT ROWS VARIABLE TO      *
      *                TO COMP-5 TO CORRECT PROBLEM ON     *
      *                SYS0U.                              *
      *                1343983--JIM CURREY                 *
      *                03/09/2010--JOSE ROSADO             *
      *   version 005--Changed count rows var to unsigned  *
      *                as not handling > 127 column tables *
      *                15/09/2016--Vincent Coen            *
030910******************************************************
030910* NOTE! WS-MYSQL-COUNT-ROWS MUST BE A COMP-5 ON IA64 *
030910* MACHINES (LITTLE ENDIAN) AND COMP ON OTHER MACHINES*
030910* (BIG-ENDIAN)!                                      *
      ******************************************************
       01  WS-MYSQL-CID                        USAGE POINTER.
       01  WS-MYSQL-RESULT                     USAGE POINTER.
       01  WS-MYSQL-RESULT-2                   USAGE POINTER.
       01  WS-MYSQL-RESULT-3                   USAGE POINTER.
030910 01  WS-MYSQL-COUNT-ROWS                 PIC 9(9)  comp. *> S9(9) COMP.
030910*01  WS-MYSQL-COUNT-ROWS                 PIC S9(9) COMP-5.
       01  WS-MYSQL-ERROR-NUMBER               PIC X(4).
       01  WS-MYSQL-ERROR-MESSAGE              PIC X(80).
121709*01  WS-MYSQL-COMMAND                    PIC X(1024).
121709 01  WS-MYSQL-COMMAND                    PIC X(4096).
121709*01  WS-MYSQL-COMMAND-HOLD               PIC X(1024).
121709 01  WS-MYSQL-COMMAND-HOLD               PIC X(4096).
       01  WS-MYSQL-DATA-BUFFER                PIC X(4096).
      *
061623 01  WS-Mysql-Vars.
061623     03  Ws-Mysql-Host-Name              pic x(64)   value spaces.
061623     03  Ws-Mysql-Implementation         pic x(64)   value spaces.
061623     03  Ws-Mysql-Password               pic x(64)   value spaces.
061623     03  Ws-Mysql-Base-Name              pic x(64)   value spaces.
061623     03  Ws-Mysql-Port-Number            pic x(4)    value spaces.
061623     03  Ws-Mysql-Socket                 pic x(64)   value spaces.
      *
