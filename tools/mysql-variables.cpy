       >>source free
*>*****************************************************
*>   variables used to work with mysql api            *
*>                                                    *
*>   version 001--original version                    *
*>   version 002--increased size of mysql command to  *
*>                4096.                               *
*>                1331214--jim currey                 *
*>                12/17/2009--jose rosado             *
*>   version 003--changed count rows variable to      *
*>                to comp-5 to correct problem on     *
*>                sys0u.                              *
*>                1343983--jim currey                 *
*>                03/09/2010--jose rosado             *
*>   version 004--Changed to free format              *
*>                160616-- Vincent Coen               *
*>   version 005--Changed count rows var to unsigned  *
*>                as not handling > 127 column tables *
*>                No I don't understand it as well !  *
*>                15/09/2016--Vincent Coen            *
*>                Increase command buffer for larger  *
*>                tables from 4096 to 8192            *
*>*****************************************************
*> NOTE! ws-mysql-count-rows must be a comp-5 on ia64 *
*> machines (little endian) and comp on other machines*
*> (big-endian)!                                      *
*>*****************************************************
*>
 01  Ws-Mysql-Cid                        usage pointer.
 01  Ws-Mysql-Result                     usage pointer.
 01  Ws-Mysql-Result-2                   usage pointer.
 01  Ws-Mysql-Result-3                   usage pointer.
 01  Ws-Mysql-Count-Rows                 pic 9(9)  comp. *> s9(9) comp.
*>01  Ws-Mysql-Count-Rows                 pic 9(9)  comp-5. *> s9(9) comp-5.
 01  Ws-Mysql-Error-Number               pic x(4).
 01  Ws-Mysql-Error-Message              pic x(80).
 01  Ws-Mysql-Host-Name                  pic x(64).
 01  Ws-Mysql-Implementation             pic x(64).
 01  Ws-Mysql-Password                   pic x(64).
 01  Ws-Mysql-Base-Name                  pic x(64).
 01  Ws-Mysql-Port-Number                pic x(4).
 01  Ws-Mysql-Socket                     pic x(64).
 01  Ws-Mysql-Command                    pic x(8192).
 01  Ws-Mysql-Command-Hold               pic x(8192).
 01  Ws-Mysql-Data-Buffer                pic x(4096).
*>
