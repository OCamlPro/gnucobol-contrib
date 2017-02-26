       >>source free
*>***********************************************
*>                                              *
*>                    Stock                     *
*>               File/Table Handler             *
*>                                              *
*>  The Program name is taken from the FILE-nn  *
*>       used in the cobol file select.         *
*>***********************************************
*>
 identification division.
 Program-Id.            acas011.
*>**
*> Author.              Vincent B Coen, FBCS, FIDMP, CPL
*>                      for Applewood Computers.
*>**
*> Security.            Copyright (C) 2016, Vincent Bryan Coen.
*>                      Distributed under the GNU General Public License
*>                      v2.0. Only. See the file COPYING for details.
*>**
*> Remarks.             Stock File Handler.
*>                      ******************
*>                      This and associated modules relate to ACAS versions v3.02 and later.
*>                      --------------------------------------------------- ^^^^^ ---------
*>
*>   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING
*>
*>        This module acas011 (along with stockMT) are the first FH (cobol File Handler for I/O)
*>            and DAL (Data Access Layer) for RDBMS direct I/O processing and these two modules
*>                 are the first modules written (& tested) for the ACAS system and specifically
*>                  for stock control.
*>
*>        Therefore they are the models for all other FH and DALs.
*>          This means that any bugs found in one of them that is NOT file specific code changes
*>            have to be added to all existing other FH and or DAL modules.
*>               This must be done immediately after all changes to any one so that no mods are
*>                    forgotten about.
*>
*>   **************************************** END OF WARNING ********************************
*>
*>                      This modules does all Cobol file handling for the file
*>                                     (Stock File).
*>
*>                      If Cobol Flat files are in use (via the system parameter file settings)
*>                      which is passed via the wsfnctn (via copybook) / File-Access data block
*>                      via the application module and each FH & DAL.
*>                      It will read/write/delete/update/open/close as required and requested.
*>                      NOTE the same fields are used for ALL of the FL and DAL modules so
*>                      checking the error flags have to be done after each call before clearing.
*>
*>                      If RDBMS (Relational DataBase Management Systems) is in use it will call
*>                      the specific module to handle similar processing passing the equivelent
*>                      RDB (Relational DataBase) row as a Cobol file record (01 level) moving
*>                      row by row to the correct Cobol flat file fields as required.
*>                      These retrieve ALL columns and there fore the DAL modules cannot handle
*>                      processing for selective columns, e.g., only updating one field/column
*>                      as the whole record / row must be read or written to/from the RDB table.
*>
*>                      Module naming is based on the File ID variable name and for the Stock
*>                      file which uses file-11  the FH is therefore acas011 - the last two chars
*>                      reflect the same number as last two chars the 'file-nn' name.
*>
*>                      Did it have to be this way ? no but it is easy to see in the original
*>                      code the name in the select statement for the Cobol file.
*>
*>                      RDB DAL (Data Access Layer) modules are individually modified to handle:
*>                      MS SQL server, Mysql, DB2, Postgres and Oracle as available and tested.
*>                      These are contained in seperate directories for each RDB, eg
*>                       'MSSQL' (MS SQL Server), 'Mysql', 'DB2', 'Postgres'. 'Oracle'.
*>                       You need to compile from the correct directory for the specific
*>                       RDB you will use and have installed along with all of the development
*>                       libraries and include files etc using the correct pre-compiler tool
*>                       to process the EXEC SQL code converting to Cobol calls etc.
*>
*>                      For specific SQL servers supported the pre-compiler system is included
*>                       where ever possible but for some, copyright reasons may prevent
*>                       inclusion. In some cases for one specific RDB more than one precompiler
*>                       is used as an experiment to help find the ideal one to use.
*>
*>                      In addition:
*>                        If the system has been set up to (see the System File set up via the
*>                        main menu module for each sub system), also process BOTH flat file
*>                        AND the correct rdb table/s,
*>                        it will write/delete/update etc to both but read from 1=Flat and be
*>                        overwritten by the rdb access. This was set up more for testing the
*>                        new code for both cobol files and the rdb accessing modules.
*>                       This can help in transferring the Cobol flat files to rdb tables but
*>                        see below regarding the Load programs/modules.
*>
*>                      If you wish to convert a running ACAS system over from Flat files
*>                      to RDBMS see below. However it is strongly recommended to not to use
*>                      the Duplicate processing of files/table as outlined above but:
*>
*>                      Included are LM's (Load Modules) to convert each ISAM
*>                      (Indexed Sequential) file to the rdb database tables if you wish to
*>                      convert the system in one hit, without using the Duplicate file/RDB
*>                      processing procedures. These will also need to be compiled from the
*>                      specific LM directory that contains the rdb DAL modules.
*>
*>                      A specific program or bash process will be created to use, that will run
*>                      each LM process for all existing Cobol files. These are created during
*>                      writing of the FH and DAL for each file/table if only to help in testing
*>                      them.
*>**
*> Called Modules:
*>                      stockMT -
*>                                DAL (RDB Data Access Layer) or a variation
*>                      Selected via CDF etc [to be added].
*>
*>**
*> Error Messages Used.
*>
*>                      AC901 Note error and hit return
*>                      AC902 Program Error: Temp rec =yyy < Stock-Rec = zzz
*>**
*> Version.             1.00 29/02/2012. Rewritten June 2016 after creating the DAL.
*>
*>                      This module is the first of the ACAS File Handlers and
*>                      will act as the model for all the others which in turn
*>                      is lightly modelled on the irsub modules for IRS.
*>
*>
*> Changes.
*> 29/02/12 vbc - Created for Gnu Cobol v1.1 & v2.0. Code also to be tested with MF VC
*>                ** UNDER TEST ** but there again every thing is!
*> 17/05/16 vbc - Adding code for log file.
*>                Notes about error messages.
*> 24/06/16 vbc - Minor coding errors with a evaluate.
*> 02/07/16 vbc - .01 Missing DB params in system rec not moved to DB-xx in wsfnctn.
*> 04/08/16 vbc       Moved logging code into a new module to be called
*>                    from here and the stockMT code.
*> 04/08/16 vbc - .02 Test on read for read next at end bypass moves etc.
*> 21/07/16 vbc - .03 Minor tidy up  of code & comments near the call to the DAL.
*>                    Extra module comments and notes.
*> 27/07/16 vbc - .04 Rem'd out some mv zero to fs-reply but don't think it is causing issues, may be
*> 24/10/16 vbc - .   ALL programs now using wsnames.cob in copybooks
*>
*>**
*>  Module USAGE
*>**************
*>
*>    On Entry:         Set up Linkage areas -
*>    ********              1. File and table WS record : -
*>    acas011 ONLY             WS-Stock-Record = Contents of data record to be written/read
*>                          2. File-Access = File-Function as needed.
*>                                        Access-Type   as needed.
*>                          3. File-Defs (File-Definitions) = Paths set up.
*>
*>    On Exit:          Linkage contains and apples to ALL FH and DAL modules:
*>    *******               Record = containing a read data record or table row
*>                          Fs-Reply = 0, 99 or other value where
*>                                     0  = Operation completed successfully
*>                                     10 = End of file
*>                                     21 = Invalid key | key not found
*>                                     99 = Indicates an error see WE-Error for more info
*>                          WE-Error   0    = Operation completed successfully
*>                                     999  = Undefined / unknown error
*>                                     998* = File-Key-No Out Of Range not 1, 2 or 3.
*>                                     997* = Access-Type wrong (< 5 or > 8)
*>                                     996* = File Delete key out of range (not = 1 or 2)
*>                                     995* = During Delete SQLSTATE not '00000' investigate using MSG-Err/Msg
*>                                     994* = During Rewrite,                     ^^ see above ^^
*>                                     990* = Unknown and unexpected error, again ^^ see above ^^
*>                                     989* = Unexpected error on Read-Indexed, investigate as above.
*>                                     911* = Rdb Error during initializing,
*>                                            possibly can not connect to database
*>                                             Check connect data and
*>                                             see SQL-Err & SQL-MSG
*>                                            Produced by Mysql-1100-Db-Error in copy
*>                                            module mysql-procedure.
*>                                     901  = File Def Record size not =< than ws record size
*>                                            Module needs ws definition changing to correct size
*>                                            FATAL, Stop using system, fix source code
*>                                            and recompile before using system again.
*>                                     Other = any other rdbms errors see specific
*>                                             (Rdbms) manual
*>                          SQL-Err  = Error code from RDBMS is set if above 2 are non zero
*>                          SQL-Msg  = Non space providing more info if SQL-Err non '00000'
*>                                     * = FS-Reply = 99.
*>
*>       During testing a log file will be created containing datetime stamp, task and return codes
*>       for both FS-Reply and WE-Error and table used along with the RDB error number and message
*>         In this case for the
*>                Stock File.
*>
*>       WARNING - This file could get large so needs manually deleting after examination.
*>
*>  Programmer note : CONSIDER WRITING A reporting program for this with report selection criteria.
*>
*>******************************************************************************
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of the Applewood Computers Accounting System
*> and is copyright (c) Vincent B Coen. 1976-2016 and later.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 ONLY.
*>
*> ACAS is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endevor
*> to fix it, providing you tell me about the problem. See below for my
*> email address to use for this purpose.
*>
*> You should have received a copy of the GNU General Public License along
*> with ACAS; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>
*>**********************************************************************************
*>
*> WARNING:
*> *******
*> Some of the RDB handlers (DAL for MS SQL server) are NOT covered under the above
*> GPL but authority to use, WITHOUT the right of ANY FORM OF PAID REDISTRIBUTION
*> is given. HOWEVER, distribution licensing can be offered on a case by case basis.
*>
*> Contact the Lead Programmer at vbcoen@gmail.com with details of your requirements.
*>
*>**********************************************************************************
*>
 environment division.
*> copy "envdiv.cob".
 configuration section.
 source-computer.      Linux.
 object-computer.      Linux.
*> special-names.
*>     console is crt.
*>
 input-output section.
 file-control.
*>
*> copy "selstock.cob".
*>
     select  Stock-File      assign               File-11
                             access               dynamic
                             organization         indexed
                             status               Fs-Reply
                             record key           Stock-Key
                             alternate record key Stock-Abrev-Key
                             alternate record key Stock-Desc with duplicates.
*>
 data division.
 file section.
*>***********
*> copy "fdstock.cob".
*>*******************************************
*>                                          *
*>  File Definition For The Stock Control   *
*>                                          *
*>*******************************************
*> rec size 385 bytes (with WIP) 26/05/09
*> rec size 400 bytes (with fillers) 11/12/11
*> 02/06/09 vbc - Added PA code
*> 17/03/12 vbc - Field types chgd from bin long to comp still 400
*>
 fd  Stock-File.
*>
 01  Stock-Record.
     03  Stock-Key                pic x(13).
     03  Stock-Abrev-Key          pic x(7).
     03  Stock-Suppliers-Group.
         05  Stock-Supplier-P1    pic x(7).                          *> Primary   Supplier
         05  Stock-Supplier-P2    pic x(7).                          *> Secondary Supplier
         05  Stock-Supplier-P3    pic x(7).                          *> Back Up   Supplier
     03  filler redefines Stock-Suppliers-Group.
         05  Stock-Suppliers      pic x(7)     occurs 3.  *> 41
     03  Stock-Desc               pic x(32).              *> 73
     03  Stock-Construct-Item     pic x(13).              *> 86
     03  Stock-Location           pic x(10).
     03  Stock-PA-Code.
         05  Stock-pa-System      pic x.
         05  Stock-pa-Group.
             07  Stock-pa-First   pic x.
             07  Stock-pa-Second  pic x.
     03  Stock-SA-Code.
         05  Stock-sa-System      pic x.
         05  Stock-sa-Group.
             07  Stock-sa-First   pic x.
             07  Stock-sa-Second  pic x.
     03  Stock-Services-Flag      pic x.                  *> 103        flag for services, not product (Y/N)
     03  Stock-Last-Actual-Cost   pic 9(7)v99     comp-3. *> (5)
     03  filler                   pic x(8).               *> 116
     03  Stock-Construct-Bundle   pic s9(6)       comp.
     03  Stock-Under-Construction pic s9(6)       comp.
     03  Stock-Work-in-Progress   pic s9(6)       comp.
     03  Stock-ReOrder-Pnt        pic s9(6)       comp.
     03  Stock-Std-ReOrder        pic s9(6)       comp.
     03  Stock-Back-Ordered       pic s9(6)       comp.
     03  Stock-On-Order           pic s9(6)       comp.
     03  Stock-Held               pic s9(6)       comp.
     03  Stock-Pre-Sales          pic s9(6)       comp.   *> 36 = 152
     03  Stock-Retail             pic 9(7)v99     comp-3. *> 5    *> This 3 increased by 1 leading digit
     03  Stock-Cost               pic 9(7)v9999   comp-3. *> 6          Based on last Order Only
     03  Stock-Value              pic 9(9)v99     comp-3. *> 6 = 169
     03  Stock-Order-Due          pic 9(8)    comp.
     03  Stock-Order-Date         pic 9(8)    comp.   *> 177
     03  Stock-Mthly-Running-Totals.                 *> 16:    cleared at EOY cycle
         05  Stock-Adds           pic 9(8)    comp.  *> binary-long.
         05  Stock-Deducts        pic 9(8)    comp.  *> binary-long.
         05  Stock-Wip-Adds       pic 9(8)    comp.  *> binary-long.
         05  Stock-Wip-Deds       pic 9(8)    comp.  *> binary-long.
     03  Stock-History.
         05  Stock-History-Data.    *> 193:       zeroed for new year
             07  Stock-TD-Adds     pic 9(8)   comp  occurs 12.
             07  Stock-TD-Deds     pic 9(8)   comp  occurs 12.
             07  Stock-TD-Wip-Adds pic 9(8)   comp  occurs 12.
             07  Stock-TD-Wip-Deds pic 9(8)   comp  occurs 12.
     03  filler                   pic x(15).                           *> 400  expansion
*>
 working-storage section.
*>**********************
*>
 77  prog-name           pic x(17)    value "acas011 (3.02.04)".
*>
 77  ws-reply           pic x      value space.
*>
 77  A                  pic s9(4)     comp    value zero.  *> A & B used in 1st test ONLY
 77  B                  pic s9(4)     comp    value zero.  *>  in ba-Process-RDBMS
 77  Display-Blk        pic x(75)             value spaces.
 77  Cobol-File-Status  pic 9                 value zero.
     88  Cobol-File-Eof                       value 1.
*>
 01  Error-Messages.
*> System Wide
*> Module Specific
     03  ST901          pic x(31) value "AC901 Note error and hit return".
     03  ST902          pic x(32) value "AC902 Program Error: Temp rec = ".
*>                                        yyy < Stock-Rec = zzz
 *>    03  ST906          pic x(41) value "AC906 Stock File not found, nothing to do".
*>
 Linkage Section.
*>**************
*> copy "wsstock.cob".
*>*******************************************
*>                                          *
*>          Stock Control record            *
*>                                          *
*>*******************************************
*> rec size 400 bytes (with fillers) 11/12/11
*> 02/06/09 vbc - Added PA code
*> 26/02/12 vbc - Chngd bins to comps 4 sql still 400
*> 01/07/16 vbc - Note that some programs use a 400 byte block to
*>                hold a copy of the record so if increased, these
*>                need to be changed throughtout the system.
*> 21/07/16 vbc - Remap Stock-History-Data content so each occurs 12
*>                instead of just Stock-History-Data.
*>
 01  WS-Stock-Record.
     03  WS-Stock-Key             pic x(13).
     03  WS-Stock-Abrev-Key       pic x(7).
     03  Stock-Suppliers-Group.
         05  Stock-Supplier-P1    pic x(7).                          *> Primary   Supplier
         05  Stock-Supplier-P2    pic x(7).                          *> Secondary Supplier
         05  Stock-Supplier-P3    pic x(7).                          *> Back Up   Supplier
     03  filler redefines Stock-Suppliers-Group.
         05  Stock-Suppliers      pic x(7)     occurs 3.  *> 41
     03  WS-Stock-Desc            pic x(32).              *> 73
     03  Stock-Construct-Item     pic x(13).              *> 86
     03  Stock-Location           pic x(10).
     03  Stock-PA-Code.
         05  Stock-pa-System      pic x.
         05  Stock-pa-Group.
             07  Stock-pa-First   pic x.
             07  Stock-pa-Second  pic x.
     03  Stock-SA-Code.
         05  Stock-sa-System      pic x.
         05  Stock-sa-Group.
             07  Stock-sa-First   pic x.
             07  Stock-sa-Second  pic x.
     03  Stock-Services-Flag      pic x.                  *> 103  flag 4 services, not product (Y/N)
     03  Stock-Last-Actual-Cost   pic 9(7)v99     comp-3. *> (5) +1
     03  filler                   pic x(8).               *> 116
     03  Stock-Construct-Bundle   pic s9(6)       comp.
     03  Stock-Under-Construction pic s9(6)       comp.
     03  Stock-Work-in-Progress   pic s9(6)       comp.
     03  Stock-ReOrder-Pnt        pic s9(6)       comp.
     03  Stock-Std-ReOrder        pic s9(6)       comp.
     03  Stock-Back-Ordered       pic s9(6)       comp.
     03  Stock-On-Order           pic s9(6)       comp.
     03  Stock-Held               pic s9(6)       comp.
     03  Stock-Pre-Sales          pic s9(6)       comp.   *> 36 = 152
     03  Stock-Retail             pic 9(7)v99     comp-3. *> 5
     03  Stock-Cost               pic 9(7)v9999   comp-3. *> 6          Based on last Order Only
     03  Stock-Value              pic 9(9)v99     comp-3. *> 6 = 169
     03  Stock-Order-Due          pic 9(8)    comp.  *> binary-long unsigned.
     03  Stock-Order-Date         pic 9(8)    comp.  *> binary-long unsigned.   *> 177
     03  Stock-Mthly-Running-Totals.                    *> 16:        cleared at EOY cycle
         05  Stock-Adds           pic 9(8)    comp.  *> binary-long.
         05  Stock-Deducts        pic 9(8)    comp.  *> binary-long.
         05  Stock-Wip-Adds       pic 9(8)    comp.  *> binary-long.
         05  Stock-Wip-Deds       pic 9(8)    comp.  *> binary-long.  *> 193
     03  Stock-History.
         05  Stock-History-Data.            *> 192:  zeroed for new year
             07  Stock-TD-Adds     pic 9(8)   comp    occurs 12. *> binary-long
             07  Stock-TD-Deds     pic 9(8)   comp    occurs 12. *> binary-long
             07  Stock-TD-Wip-Adds pic 9(8)   comp    occurs 12. *> binary-long
             07  Stock-TD-Wip-Deds pic 9(8)   comp    occurs 12. *> binary-long     *> 48 (x4) = 192 == 385
     03  filler                   pic x(15).                          *>400  expansion
*>
*> copy "wssystem.cob".
*>*******************************************
*>                                          *
*>  Record Definition For The System File   *
*>                                          *
*>*******************************************
*>  file size 1024 with fillers
*> 01/02/09 vbc - Repacked to reduce slack bytes.
*> 05/04/09 vbc - Light clean up
*> 07/04/09 vbc - Remove op-gen to filler (general)
*> 22/04/09 vbc - Stock control data added.
*> 29/05/09 vbc - Added 'system wide' Print-Lines for all ledgers.
*>  1/06/09 vbc - Added Stock link for PL and SL.
*> 14/09/10 vbc - Added Print-Spool-Name.
*> 15/09/10 vbc - Need to increase rec size by 128 bytes in system-data and more in the others
*>                to bring it up to 1024, the other 2 rec types will also increase to same.
*>                Epos remarked out for Open source versions.
*> 07/11/10 vbc - New fields added as above including vers & sub vers for file for auto
*>                updating of changed file layouts by system
*> 16/11/11 vbc - Added extra 88 in op-system
*> 11/12/11 vbc - Added Date-Form for all of ACAS and removed stk-Date-Form
*> 04/03/12 vbc - Added File-Duplicates-In-Use & FS-Duplicate-Processing + support for MS SQL server.
*> 09/04/12 vbc - Added Needed RDB data, DB Name, User Name and password requred for connecting
*>                 to Database tables.
*> 15/05/13 vbc - Added SL-Stock-Audit to invoicing replacing a filler. Needs adding to rdbms layouts!!!
*> 19/05/13 vbc - Added 4 fields at end of SL block for company name/address headings in
*>                Inv, Stat, Pick, Letters, Vat-prints And VAT registration
*>                number in system block - NEEDS adding to in RDBMS layouts.
*> 04/06/13 vbc - Added fields Print-Spool-Name2 & Print-Spool-Name3 in filler
*>                areas but really need to be moved to system data block
*>                AND moving around some other fields. File size NOT changed
*> 12/06/13 vbc - Added IRS fields to main system file - Starter for 10.
*> 22/09/15 vbc - Added Param-Restrict (Access) within a current filler.
*>                Set this will stop display of option Z in sub-system menus.
*>                Need to detect actual user though when setup or could just use
*>                chown for sys002 to admin user?
*> 25/06/16 vbc - Added RDBMS-Port & needs RDBMS-Host, RDBMS-Socket.
*>                Increased 'System-data' from 384 to 512 bytes & removed O/E
*>                  Block (128) as it is unused.
*> 26/06/16 vbc - Updated MySQL Load scripts ACASDB.sql in ACAS/mysql.
*>                  Prima is yet to be done !!!
*> 19/10/16 vbc - Changed PL-Approp-AC in IRS block from 9(5) to 9(6) for GL
*>                support & reduced filler by 1.
*>                With IRS data mapped into ACAS the IRS block can reduce to 32 bytes
*>                Just need to change all of the IRS programs to use ACAS fields but
*>                also NEED to change the date processing to use same in rest of ACAS
*>                and not binary days since 01/01/2000 and hold dates in dd/mm/yy form.
*>                Added 2 88s to Op-System for IRS.
*> 27/10/16 vbc - Changed level-5 to IRS instead of omitted O/E.
*>
 01  System-Record.
*>******************
*>   System Data   *
*>******************
     03  System-Data-Block.                                  *>   384 changed to 512 bytes (25/06/16)
         05  System-Record-Version-Prime      binary-char.   *>  1
         05  System-Record-Version-Secondary  binary-char.   *>  3  Updated 25/08/16
         05  Vat-Rates                    comp.
             07 Vat-Rate-1   pic 99v99.                      *> Standard rate
             07 Vat-Rate-2   pic 99v99.                      *> Reduced rate
             07 Vat-Rate-3   pic 99v99.                      *> Minimal or exempt
             07 Vat-Rate-4   pic 99v99.   *> 2b used for local sales tax   Not UK
             07 Vat-Rate-5   pic 99v99.   *> 2b used for local sales tax   Not UK
         05  Vat-Rate redefines Vat-Rates pic 99v99 comp occurs 5.
         05  Cyclea          binary-char.  *> 99.
         05  Scycle Redefines cyclea  binary-char.
         05  Period          binary-char.  *> 99.
         05  Page-Lines      binary-char  unsigned. *> 999.
         05  Next-Invoice    binary-long. *> 9(8) comp.
         05  Run-Date        binary-long. *> 9(8) comp.
         05  Start-Date      binary-long. *> 9(8) comp.
         05  End-Date        binary-long. *> 9(8) comp.
         05  Suser.				*> IRS
             07  Usera       pic x(32).
         05  User-Code       pic x(32).   *> encrypted username not used on OS versions so also b 4 client?
         05  Address-1       pic x(24).
         05  Address-2       pic x(24).
         05  Address-3       pic x(24).
         05  Address-4       pic x(24).
         05  Post-Code       pic x(12).   *> or ZipCode size should cover all countries
         05  Country         pic x(24).
         05  Print-Spool-Name pic x(48).
         05  File-Statuses.
             07  File-Status pic 9          occurs 32.
         05  Pass-Value      pic 9.
         05  Level.
             07  Level-1     pic 9.
                 88  G-L                    value 1.   *> General (Nominal) ledger
             07  Level-2     pic 9.
                 88  B-L                    value 1.   *> Purchase (Payables) ledger
             07  Level-3     pic 9.
                 88  S-L                    value 1.   *> Sales (Receivables) ledger
             07  Level-4     pic 9.
                 88  Stock                  value 1.   *> Stock Control (Inventory)
             07  Level-5     pic 9.
                 88  IRS                    value 1.   *> IRS used (instead of General).
             07  Level-6     pic 9.
                 88  Payroll                value 1.   *> Payroll
         05  Pass-Word       pic x(4).                 *>
         05  Host            pic 9.
             88  Multi-User                 value 1.
         05  Op-System       pic 9.
             88  valid-os-type            values 1 2 3 4 5 6.
             88  No-OS                    value zero.
             88  Dos                        value 1.
             88  Windows                    value 2.
             88  Mac                        value 3.
             88  Os2                        value 4.
             88  Unix                       value 5.
             88  Linux                      value 6.
             88  OS-Single                  values 1 2 4.
         05  Current-Quarter pic 9.
         05  RDBMS-Flat-Statuses.
             07  File-System-Used  pic 9.
                 88  FS-Cobol-Files-Used        value zero.
                 88  FS-RDBMS-Used              value 1.
*>                 88  FS-Oracle-Used             value 1.  *> THESE NOT IN USE
*>                 88  FS-MySql-Used              value 2.  *> ditto
*>                 88  FS-Postgres-Used           value 3.  *> ditto
*>                 88  FS-DB2-Used                value 4.  *> ditto
*>                 88  FS-MS-SQL-Used             value 5.  *> ditto
                 88  FS-Valid-Options           values 0 thru 1.    *> 5. (not in use unless 1-5)
             07  File-Duplicates-In-Use pic 9.
                 88  FS-Duplicate-Processing    value 1.
         05  Maps-Ser.      *> Not needed in OpenSource version, = 9999 (No Maintainence Contract]
             07  Maps-Ser-xx pic xx.        *> Allows for 36^2 * 100 customers
             07  Maps-Ser-nn binary-short.  *>       =  129600 - 2
         05  Date-Form       pic 9.
             88  Date-UK                    value 1.  		*> dd/mm/yyyy
             88  Date-USA                   value 2.  		*> mm/dd/yyyy
             88  Date-Intl                  value 3.  		*> yyyy/mm/dd
             88  Date-Valid-Formats         values 1 2 3.
         05  Data-Capture-Used pic 9.
             88  DC-Cobol-Standard          value zero.
             88  DC-GUI                     value 1.
             88  DC-Widget                  value 2.
         05  RDBMS-DB-Name   pic x(12)      value "ACASDB".     *> change in setup
         05  RDBMS-User      pic x(12)      value "ACAS-User".  *> change in setup
         05  RDBMS-Passwd    pic x(12)      value "PaSsWoRd".   *> change in setup
         05  VAT-Reg-Number  pic x(11)      value spaces.
         05  Param-Restrict  pic x.                             *> Only via ACAS?
         05  RDBMS-Port      pic x(5)       value "3306".       *> change in setup
         05  RDBMS-Host      pic x(32)      value spaces.       *> change in setup
         05  RDBMS-Socket    pic x(64)      value spaces.       *> change in setup v3
         05  filler          pic x(34).                         *> for expansion v3
*>***************
*>   G/L Data   *
*>***************
     03  General-Ledger-Block.               *> 80 bytes
         05  P-C             pic x.
             88  Profit-Centres             value "P".
             88  Branches                   value "B".
         05  P-C-Grouped     pic x.
             88  Grouped                    value "Y".
         05  P-C-Level       pic x.
             88  Revenue-Only               value "R".
         05  Comps           pic x.
             88  Comparatives               value "Y".
         05  Comps-Active    pic x.
             88  Comparatives-Active        vaLUE "Y".
         05  M-V             pic x.
             88  Minimum-Validation         vaLUE "Y".
         05  Arch            pic x.
             88  Archiving                  value "Y".
         05  Trans-Print     pic x.
             88  Mandatory                  value "Y".
         05  Trans-Printed   pic x.
             88  Trans-Done                 value "Y".
         05  Header-Level    pic 9.
         05  Sales-Range     pic 9.
         05  Purchase-Range  pic 9.
         05  Vat             pic x.
             88  Auto-Vat                   value "Y".
         05  Batch-Id        pic x.
             88  Preserve-Batch             value "Y".
         05  Ledger-2nd-Index pic x.                     *> But file uses SINGLE INDEX only ???
             88  Index-2                    value "Y".
         05  IRS-Instead     pic x.
             88  IRS-Used                   value "Y".
             88  IRS-Both-Used              value "B".   *> 26/11/16
         05  Ledger-Sec      binary-short.  *> 9(4) comp
         05  Updates         binary-short.  *> 9(4) comp
         05  Postings        binary-short.  *> 9(4) comp
         05  Next-Batch      binary-short.  *> 9(4) comp  should be unsigned used for all ledgers
         05  Extra-Charge-Ac binary-long.   *> 9(8) comp
         05  Vat-Ac          binary-long.   *> 9(8) comp
         05  Print-Spool-Name2 pic x(48).
*>******************
*>   P(B)/L Data   *
*>******************
     03  Purchase-Ledger-Block.              *> 88 bytes
         05  Next-Folio      binary-long.   *> 9(8) comp
         05  BL-Pay-Ac       binary-long.   *> 9(8) comp
         05  P-Creditors     binary-long.   *> 9(8) comp
         05  BL-Purch-Ac     binary-long.   *> 9(8) comp
         05  BL-End-Cycle-Date binary-long.   *> 9(8) comp
         05  BL-Next-Batch   binary-short.   *> 9(4) comp  should be unsigned - unused ?
         05  Age-To-Pay      binary-char.   *> 9(4) comp should be unsigned
         05  Purchase-Ledger pic x.
             88  P-L-Exists                 value "Y".
         05  PL-Delim        pic x.
         05  Entry-Level     pic 9.
         05  P-Flag-A        pic 9.
         05  P-Flag-I        pic 9.
         05  P-Flag-P        pic 9.
         05  PL-Stock-Link   pic x.
         05  Print-Spool-Name3 pic x(48).
         05  filler          pic x(10).
*>***************
*>   S/L Data   *
*>***************
     03  Sales-Ledger-Block.                 *> 128 bytes
         05  Sales-Ledger    pic x.
             88  S-L-Exists                 value "Y".
         05  SL-Delim        pic x.
         05  Oi-3-Flag       pic x.		*> 'Y' used in sl060 why?
         05  Cust-Flag       pic x.
         05  Oi-5-Flag       pic x.
         05  S-Flag-Oi-3     pic x.		*> 'z' when otm3 created, used in sl060 why? NO LONGER USED
         05  Full-Invoicing  pic 9.
         05  S-Flag-A        pic 9.		*> '1' used in sl060 why?
         05  S-Flag-I        pic 9.		*> '2' used in sl060 why?
         05  S-Flag-P        pic 9.
         05  SL-Dunning      pic 9.
         05  SL-Charges      pic 9.
         05  Sl-Own-Nos      pic x.
         05  SL-Stats-Run    pic 9.
         05  Sl-Day-Book     pic 9.
         05  invoicer        pic 9.
             88  I-Level-0                  value 0.  *> show totals only (no net & vat) not used?
             88  I-Level-1                  value 1.  *> Show net, vat
             88  I-Level-2                  value 2.  *> show Details + vat etc looks wrong in sl910 totals only (no net & vat)
             88  Not-Invoicing              value 9.  *> show totals only (no net & vat) but not found yet nor level 3 (see sl900)
         05  Extra-Desc      pic x(14).
         05  Extra-Type      pic x.
             88  Discount                   value "D".
             88  Charge                     value "C".
         05  Extra-Print     pic x.
         05  SL-Stock-Link   pic x.
         05  SL-Stock-Audit  pic x.
             88  Stock-Audit-On             value "Y".   *> Invoicing will create an audit record (15/05/13)
         05  SL-Late-Per     pic 99v99    comp.
         05  SL-Disc         pic 99v99    comp.
         05  Extra-Rate      pic 99v99    comp.
         05  SL-Days-1       binary-char.  *> 999  comp.
         05  SL-Days-2       binary-char.  *> 999  comp.
         05  SL-Days-3       binary-char.  *> 999  comp.
         05  SL-Credit       binary-char.  *> 999  comp.
         05  filler          binary-short.   *> No longer used.
         05  SL-Min          binary-short.  *> 9999  comp.
         05  SL-Max          binary-short.  *> 9999  comp.
         05  PF-Retention    binary-short.  *> 9999  comp.
         05  First-Sl-Batch  binary-short.  *> 9999  comp.   *>unused ?
         05  First-Sl-Inv    binary-long.   *> 9(8) comp.
         05  SL-Limit        binary-long.   *> 9(8) comp.
         05  SL-Pay-Ac       binary-long.   *> 9(8) comp.
         05  S-Debtors       binary-long.   *> 9(8) comp.
         05  SL-Sales-Ac     binary-long.   *> 9(8) comp.
         05  S-End-Cycle-Date binary-long.   *> 9(8) comp.
         05  SL-Comp-Head-Pick Pic x.
             88  SL-Comp-Pick               value "Y".
         05  SL-Comp-Head-Inv  pic x.
             88  SL-Comp-Inv                value "Y".
         05  SL-Comp-Head-Stat pic x.
             88  SL-Comp-Stat               value "Y".
         05  SL-Comp-Head-Lets pic x.
             88  SL-Comp-Lets               value "Y".
         05  SL-VAT-Printed  pic x.
             88  SL-VAT-Prints              value "Y".
         05  filler          pic x(45).      *>  just in case
*>***************
*> Stock Data   *
*>***************
*>
     03  Stock-Control-Block.                *> 88 bytes
         05  Stk-Abrev-Ref   pic x(6).
         05  Stk-Debug       pic 9.          *> T/F (1/0).
         05  Stk-Manu-Used   pic 9.          *> T/F (Bomp/Wip)
         05  Stk-OE-Used     pic 9.          *> T/F.
         05  Stk-Audit-Used  pic 9.          *> T/F.
         05  Stk-Mov-Audit   pic 9.          *> T/F.
         05  Stk-Period-Cur  pic x.          *> M=Monthly, Q=Quarterly, Y=Yearly
         05  Stk-Period-dat  pic x.          *>  --  ditto  --
         05  filler          pic x.    	     *> was stk-date-form
         05  Stock-Control   pic x.
             88  Stock-Control-Exists   value "Y".
         05  Stk-Averaging   pic 9.          *> T/F.
             88  Stock-Averaging        value 1.
         05  Stk-Activity-Rep-Run pic 9.     *> T/F.  =17 bytes 0=no, 1=add, 2=del, 3=both
         05  filler          pic x.          *> slack byte
         05  Stk-Page-Lines  binary-char unsigned.  *> 9999 comp. Taken from Print-Lines
         05  Stk-Audit-No    binary-char unsigned.  *> 9999 comp.
         05  filler          pic x(68).             *> 64    (just in case)
*>     03  Order-Entry-Block.                         *> 128 bytes
*>         05  filler-Dummy    pic x(128).          *> space moved to System block as un-used v1.2
     03  IRS-Entry-Block.			*> NEW 12/06/13
         05  Client             pic x(24). 	*> 		24      *> Not needed as will use suser
         05  Next-Post          pic 9(5).  	*> 		29                                                  N   5
         05  Vat-Rates2.                                             *> these can be replaced by the other VAT blk
             07  vat1           pic 99v99. 	*> 		33   *> Standard  changed from vat (11/06/13)
             07  vat2           pic 99v99. 	*> 		37   *> reduced 1 [not yet used]
             07  vat3           pic 99v99. 	*> 		41   *> reduced 2 [not yet used]
         05  Vat-Group redefines Vat-Rates2.
             07  Vat-Psent      pic 99v99    occurs 3.
         05  IRS-Pass-Value     pic 9.	 	 *>		42  (Was Pass-Value in IRS system file)
         05  Save-Sequ          pic 9.     	 *> 		43
         05  System-Work-Group  pic x(18).	 *> 		61
         05  PL-App-Created     pic x.    	 *> 		62
         05  PL-Approp-AC6      pic 9(6). 	 *> 		68   changed for GL support if needed ?. Both needed in RDB
         05  filler redefines PL-Approp-AC6.
             07  PL-Approp-AC   pic 9(5).        *>                   For IRS
             07  filler         pic 9.
         05  1st-Time-Flag      pic 9.    	 *> 		69    (was First-Time-Flag in IRS system file)      N  32
         05  filler             pic x(59).       *>             128  Old fn-1 to 5 files
     03  IRS-Data-Block redefines IRS-Entry-Block.
         05  filler-dummy4   pic x(128).
*>
*>         05  filler             pic x(12).     *> when vat rates killed and the main ones used in System-data-block
*>     03  Payroll-Data-Block.                        *> 128 bytes
*>         05  filler-dummy2   pic x(128).		*> Content Removed
*>     03  Epos-Data-Block.
*>         05  filler-dummy3   pic x(128).		*> Content Removed
*>
*> copy "wsfnctn.cob".
*>**********************************
*>                                 *
*>  File Access Control Functions  *
*>                                 *
*>**********************************
*> 28/05/16 vbc - Added RDB setup fields - socket, host, port to user, passwd, schema.
*> 25/08/16 vbc - Amended size of RDBMS-Socket from 32 to 64 chars.
*> 01/10/16 vbc - Changed WE-Error & Rrn to pic 999 / 9.  To see if it is the cause
*>                of No data in SYSTOT-REC bug after running sys4LD.
*> 29/10/16 vbc - FS-Action increased size from 20 to 22 for logest msg in sys002.
*>  7/12/16 vbc - Increased Access-Type to 99 from 9 for extra adhoc functions
*>                such as select x ORDER BY etc.
*>                Not used yet.
*> 22/12/16 vbc - Oops, previous chg should have been for File-Function.
*>                next-read-raw changed to 13.
*> 06/01/17 vbc - Increased size of rrn for GL. System to be recompiled.
*>
 01  File-Access.
     03  We-Error        pic 999.
     03  Rrn             pic 9(5)   comp.     *> increased from 9 for GL.
     03  Fs-Reply        pic 99.
     03  s1              pic x.   *> not sure this is used so lets rem it out and see
     03  Curs            pic 9(4).
     03  filler redefines Curs.
         05  Lin         pic 99.
         05  Cole        pic 99.
     03  Curs2           pic 9(4).
     03  filler redefines Curs2.
         05  Lin2        pic 99.
         05  Col2        pic 99.
*>
     03  FS-Action       pic x(22)  value spaces.
*> current range 1 thru 3
*>     1 = Stock-Key (or only key), 2 = Stock-Abrev-Key, 3 = Stock-Desc
     03  Logging-Data.
         05  Accept-Reply    pic x      value space.
         05  File-Key-No     pic 9.
         05  ws-Log-System   pic 9      value zero.       *> loaded by caller of FHlogger
         05  ws-No-Paragraph pic 999.
         05  SQL-Err         pic x(5).
         05  SQL-Msg         pic x(512) value spaces.
         05  SQL-State       pic x(5).
*>         05  File-Key        pic x(32).                   *> Max size of any key  NOT USED ANYWHERE SO FAR as taken from Rec (03/04/12)
         05  WS-File-Key     pic x(64)  value spaces.     *> loaded by caller of FHlogging increased to 64-- 30/12/16
         05  WS-Log-Where    pic x(231) value spaces.
         05  WS-Log-File-No  pic 99     value zeroes.     *> loaded by caller of FHlogger
         05  WS-Count-Rows   pic 9(7)   value zeroes.     *> used in Delete-All in valueMT
     03  RDB-Data.
         05  DB-Schema   pic x(12)  value spaces.
         05  DB-UName    pic x(12)  value spaces.
         05  DB-UPass    pic x(12)  value spaces.
         05  DB-Host     pic x(32)  value spaces.
         05  DB-Socket   pic x(64)  value spaces.
         05  DB-Port     pic x(5)   value spaces.
*>
*>  Helps to tell MT to move file record from the FD or the WS record. NOT YET USED
*>
     03  Main-Record-Move-Flag pic 9 value zero.
         88  MRMF-Move-FD           value 1.
         88  MRMF-Move-WS           value 2.
*>
*>   need to change next one if used in the DAL, e.g., move "22" ...
*>
     03  FA-RDBMS-Flat-Statuses.                        *> Comes from System-Record via acas0nn
         07  FA-File-System-Used  pic 9.
             88  FA-FS-Cobol-Files-Used        value zero.
             88  FA-FS-RDBMS-Used              value 1.
*>                 88  FA-FS-Oracle-Used         value 1.  *> THESE NOT IN USE
*>                 88  FA-FS-MySql-Used          value 2.  *> ditto
*>                 88  FA-FS-Postgres-Used       value 3.  *> ditto
*>                 88  FA-FS-DB2-Used            value 4.  *> ditto
*>                 88  FA-FS-MS-SQL-Used         value 5.  *> ditto
             88  FA-FS-Valid-Options           values 0 thru 1.    *> 5. (not in use unless 1-5)
         07  FA-File-Duplicates-In-Use pic 9.
             88  FA-FS-Duplicate-Processing    value 1.
*>
*> Block for File/table access via acas000 thru acas033 for IS files and rdbms
*> Also see RDBMS-Flat-Statuses in System-Record
*>
     03  File-Function   pic 99.
         88  fn-open            value 1.
         88  fn-close           value 2.
         88  fn-read-next       value 3.
         88  fn-read-indexed    value 4.
         88  fn-write           value 5.
         88  fn-Delete-All      value 6.       *> 10/10/16 - Delete all records.
         88  fn-re-write        value 7.
         88  fn-delete          value 8.
         88  fn-start           value 9.
*>
         88  fn-Write-Raw       value 15.
         88  fn-Read-Next-Raw   value 13.       *> 14/11/16 - Special 4 LD.
*>
         88  fn-Read-By-Name    value 31.       *> 15/01/17 for Salesled (SL160)
         88  fn-Read-By-Batch   value 32.       *> 08/02/17 for OTM3 (sl095)
         88  fn-Read-By-Cust    value 33.       *> 09/02/17 for OTM3 (sl110, 120, 190)
*>
     03  Access-Type     pic 9.                *> For rdbms 2 should cover all !!!
         88  fn-input           value 1.
         88  fn-i-o             value 2.
         88  fn-output          value 3.
         88  fn-extend          value 4.       *> not valid for ISAM
         88  fn-equal-to        value 5.
         88  fn-less-than       value 6.
         88  fn-greater-than    value 7.
         88  fn-not-less-than   value 8.
         88  fn-not-greater-than value 9.      *> Not currently used (06/04/2012)
*>
*>
*> As this module sits in the common directory we need to get the right one.
*>   although we could use the one in the copybook for ALL systems it's just a
*>    lot larger so wasting RAM.
*>
*> copy "wsnames.cob" in "../copybooks".   *> uses the full version.
*>
*> Sales, Purchase, Stock, General & now IRS for v3.02 with integrated IRS
*>    for use in xl150 and ??
*>
*>  Files used in Sales, Stock, Purchase, General & IRS
*> 17/11/16 vbc - Added IRS files + their renaming with irs prefix.
*> 04/12/16 vbc - Added irs055 sort file as file-38.
*>
 01  File-Defs.
     02  file-defs-a.
         03  pre-trans-name      pic x(532)  value "pretrans.tmp". *> gl071
         03  post-trans-name     pic x(532)  value "postrans.tmp". *> gl071
*> copy "file00.cob".    *> "system"
      03  file-0          pic x(532)      value "system.dat".
*> copy "file02.cob".    *> "archive".
     03  file-2             pic x(532)       value "archive.dat".
*> copy "file03.cob".    *> "final".
     03  file-3         pic x(532)        value "final.dat".
*> copy "file05.cob".    *> "ledger".
     03  file-5         pic x(532)      value "ledger.dat".
*> copy "file06.cob".    *> "posting".
     03  file-6         pic x(532)      value "posting.dat".
*> copy "file07.cob".    *> "batch".
     03  file-7         pic x(532)      value "batch.dat".
*> copy "file08.cob".    *> "postings2irs.dat"
      03  file-8        pic x(532)       value "postings2irs.dat".
*> copy "file09.cob".    *> "tmp-stock".
      03  file-9        pic x(532)      value "tmp-stock.dat".
*> copy "file10.cob".    *> "staudit".
      03  file-10         pic x(532)      value "staudit.dat".
*> copy "file11.cob".    *> "stockctl".
      03  file-11         pic x(532)      value "stockctl.dat".
*> copy "file12.cob".    *> "salesled".
     03  file-12        pic x(532)      value "salesled.dat".
*> copy "file13.cob".    *> "value.dat"
      03  file-13         pic x(532)       value "value.dat".
*> copy "file14.cob".    *> "delivery.dat"
     03  file-14        pic x(532)      value "delivery.dat".
*> copy "file15.cob".    *> "analysis.dat"
      03  file-15         pic x(532)       value "analysis.dat".
*> copy "file16.cob".    *> "invoice ".
      03  file-16            pic x(532)      value "invoice.dat".
*> copy "file17.cob".    *> "delinvno".
      03  file-17            pic x(532)      value "delinvno.dat".
*> copy "file18.cob".    *> "openitm2".
      03  file-18       pic x(532)      value "openitm2.dat".
*> copy "file19.cob".    *> "openitm3".
      03  file-19            pic x(532)      value "openitm3.dat".
*> copy "file20.cob".    *> "oisort".
      03  file-20            pic x(532)      value "oisort.wrk".
*> copy "file21.cob".    *> "work.tmp"
     03  file-21             pic x(532)       value "work.tmp".
*> copy "file22.cob".    *> "purchled"
     03  file-22        pic x(532)      value "purchled.dat".
*> copy "file23.cob".    *> "delfolio.dat"
     03  file-23           pic x(532)    value "delfolio.dat".
*> copy "file24.cob".    *> dummy to build file-02
     03  file-24           pic x(532)    value spaces.
*> copy "file26.cob".    *> "pinvoice"
     03  file-26           pic x(532)    value "pinvoice.dat".
*> copy "file27.cob".    *> "poisort"
     03  file-27         pic x(532)       value "poisort.wrk".
*> copy "file28.cob".    *> "openitm4"
     03  file-28         pic x(532)       value "openitm4.dat".
*> copy "file29.cob".    *> "openitm5"
     03  file-29         pic x(532)       value "openitm5.dat".
*> copy "file32.cob".    *> "pay.dat"
     03  file-32        pic x(532)        value "pay.dat".
*> copy "file33.cob".    *> "cheque.dat"
     03  file-33        pic x(532)        value "cheque.dat".
         03  file-34             pic x(532)   value "irsacnts.dat".        *>   IRS ex file 1  These 4 added 19/10/16 for IRS integration
         03  file-35             pic x(532)   value "irsdflt.dat".         *>   IRS ex file 3  all name have 'irs' prefix.
         03  file-36             pic x(532)   value "irspost.dat".         *>   IRS ex file 4
         03  file-37             pic x(532)   value "irsfinal.dat".        *>   IRS ex file 5
         03  file-38             pic x(532)   value "postsort.dat".        *>   IRS ex irs055 sort file.
     02  filler         redefines file-defs-a.
         03  System-File-Names   pic x(532) occurs 36.            *> WAS 31 changed for IRS
     02  File-Defs-Count         binary-short value 36.           *> MUST be the same as above occurs
     02  File-Defs-os-Delimiter  pic x.                           *> if = \ or / then paths have been set.
*>
*>
*> copy "Test-Data-Flags.cob".  *> set sw-testing to zero to stop logging.
*>
*>  This data is present in ALL ACAS modules.
*>   When testing comlete you can set SW-Testing to zero
*>    to stop the logging file being produced.
*>
 01 ACAS-DAL-Common-data.     *> For DAL processing.
*>
*> log file reporting for testing otherwise zero
*>
     03  SW-Testing               pic 9   value 1.    *>   zero.
         88  Testing-1                    value 1.
*>
*>  Testing only for displays ws-where etc  otherwise zero
*>
     03  SW-Testing-2             pic 9   value zero.
         88  Testing-2                    value 1.
*>
     03  Log-File-Rec-Written     pic 9(6) value zero.    *> in both acas0nn and a DAL.
*>
*>
 Procedure Division Using System-Record

                          WS-Stock-Record

                          File-Access
                          File-Defs
                          ACAS-DAL-Common-data.
*>********************************************
*>
 aa-Process-Flat-File Section.
*>***************************
 aa010-main.
*>
*>  For logging only.
*>
     move     5      to WS-Log-System.   *> 1 = IRS, 2=GL, 3=SL, 4=PL, 5=Stock used in FH logging
     move     12     to WS-Log-File-No.  *> RDB, File/Table
*>
*>   Now Test for valid key for start, read-indexed and delete
*>
     evaluate File-Function
              when  4   *> fn-read-indexed
              when  9   *> fn-start
                if     File-Key-No < 1 or > 3
                       move 998 to WE-Error       *> file seeks key type out of range        998
                       move 99 to fs-reply
                       go   to aa999-main-exit
                end-if
              when     8  *> fn-delete
                if     File-Key-No < 1 or > 2     *> 1 or 2 is only for RDB as Cobol does it on primary key
                       move 996 to WE-Error       *> file seeks key type out of range        996
                       move 99 to fs-reply
                       go   to aa999-main-exit
                end-if
     end-evaluate.
*>
*> Check if data files or RDBMS processing or are we doing both !!
*>
     if       not FS-Cobol-Files-Used
              move RDBMS-Flat-Statuses to FA-RDBMS-Flat-Statuses    *> needed for DAL? not JC/dbpre versions
              go to ba-Process-RDBMS                                *>  Can't hurt
     end-if.
*>
*>  File paths for Cobol File has already done in main menu module
*>
*>******************************************************************************
*> So we are processing Cobol Flat files, as Dup processing, or by themselves. *
*>    if reading, get it but will be overwritten by rdb processing if set,     *
*>      otherwise will write/rewrite/delete etc, to both formats               *
*>******************************************************************************
*>
*>  ?   move     zero   to  WE-Error
 *>  ?                      FS-Reply.
     move     spaces to SQL-Err SQL-Msg SQL-State.
*>
     evaluate File-Function
        when  1
              go to aa020-Process-Open
        when  2
              go to aa030-Process-Close
        when  3
              go to aa040-Process-Read-Next
        when  4
              go to aa050-Process-Read-Indexed
        when  5
              go to aa070-Process-Write
        when  7
              go to aa090-Process-Rewrite
        when  8
              go to aa080-Process-Delete
        when  9
              go to aa060-Process-Start
        when  other                          *> 6 is spare / unused
              go to aa100-Bad-Function
     end-evaluate.
*>
*>  Should never get here but in case :(
     go       to aa100-Bad-Function.
*>
 aa020-Process-Open.
     move     spaces to WS-File-Key.     *> for logging
     move     201 to WS-No-Paragraph.
     if       fn-input
              open input Stock-File
              if   Fs-Reply not = zero
 *>                  display ST906 at 2301 with erase eos
                   move 35 to fs-Reply
                   close Stock-File
                   go to aa999-Main-Exit
              end-if
      else
       if     fn-i-o
              open i-o Stock-File
              if       fs-reply not = zero              *> this block was in st010 at ba000-Setup-Stock
                       close       Stock-File
                       open output Stock-File           *> Doesnt create in i-o
                       close       Stock-File
                       open i-o    Stock-File
              end-if                                      *> file-status will NOT be updated   ????
       else
        if    fn-output                      *> should not need to be used
              open output Stock-File         *> caller should check fs-reply
        else
         if   fn-extend                      *> Must not be used for ISAM files
*>              open extend Stock-File
              move 997 to WE-Error
              move 99  to FS-Reply
              go to aa999-main-exit
         end-if
        end-if
       end-if
     end-if.
*> 27/07/16 16:30     move     zeros to FS-Reply WE-Error.
     move     zero to Cobol-File-Status.
     move     "OPEN STOCK File" to WS-File-Key.
     if       fs-reply not = zero
              move  999 to WE-Error
     go       to aa999-main-exit.            *> with test for dup processing
*>
 aa030-Process-Close.
     move     202 to WS-No-Paragraph.
     move     spaces to WS-File-Key.     *> for logging
     close    Stock-File.
*> 27/07/16 16:30     move     zeros to FS-Reply WE-Error.
     move     zero to Cobol-File-Status.
     move     "CLOSE STOCK File" to WS-File-Key
     perform  aa999-main-exit.
     move     zero to  File-Function
                       Access-Type.              *> close log file
     perform  Ca-Process-Logs.
     go       to aa-main-exit.
*>
 aa040-Process-Read-Next.
*>
*>   Process READs, 1st is read next then read by key This is processed after
*>    Start code as its really Start/Read next
*>
     move     203 to WS-No-Paragraph.
     if       Cobol-File-Eof
              move 10 to FS-Reply
                         WE-Error
              move spaces to Stock-Key
                             SQL-Err
                             SQL-Msg
              stop "Cobol File EOF"               *> for testing
              go to aa999-main-exit
     end-if
*>
     read     Stock-File next record at end
              move 10 to we-error fs-reply        *> EOF
              set Cobol-File-EoF to true
              move 1 to Cobol-File-Status         *> JIC above don't work :)
              initialize Stock-Record
              move "EOF" to WS-File-Key           *> for logging
              go to aa999-main-exit
     end-read.
     if       FS-Reply not = zero
              go to aa999-main-exit.
     move     Stock-Record to WS-Stock-Record.
     move     WS-Stock-Key to WS-File-Key.
     move     zeros to WE-Error.
     go to    aa999-main-exit.
*>
*>   The next block will never get executed unless performed  so is it needed ?
*>
 aa045-Eval-Keys.
     evaluate File-Function      *> Set up keys just for logging
              when  4             *> fn-read-indexed
              when  5             *> fn-write
              when  7             *> fn-re-write
              when  8             *> fn-delete    For delete can ignore Desc key
              when  9             *> fn-start
                    evaluate  File-Key-No
                              when   1
                                     move   WS-Stock-Key       to WS-File-Key
                                                                  Stock-Key
                              when   2
                                     move   WS-Stock-Abrev-Key to WS-File-Key
                                                                  Stock-Abrev-Key
                              when   3
                                     move   WS-Stock-Desc      to WS-File-Key
                                                                  Stock-Desc
                              when   other
                                     move   spaces             to WS-File-Key
                    end-evaluate
              when  other
                    move   spaces             to WS-File-Key
     end-evaluate.
*>
 aa050-Process-Read-Indexed.
*>
*> copy the three possible keys to main file area
*>
     move     204 to WS-No-Paragraph.
     perform  aa045-Eval-keys.
     if       File-Key-No = 1
              read     Stock-File key Stock-Key       invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Key to WS-File-Key
              else
                       move     spaces     to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     if       File-Key-No = 2
              read     Stock-File key Stock-Abrev-Key invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Abrev-Key to WS-File-Key
              else
                       move     spaces to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     if       File-Key-No = 3                           *> can also use start, read next
              read     Stock-File key Stock-Desc      invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Desc to WS-File-Key
              else
                       move     spaces to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     move     998 to WE-Error       *> file seeks key type out of range but should never get here       998
     move     99 to fs-reply
     go       to aa999-main-exit.
*>
 aa060-Process-Start.
*>
*>  Check for Param error 1st on start   WARNING Not logging starts
*>
     move     205 to WS-No-Paragraph.
     perform  aa045-Eval-keys.
     move     zeros to fs-reply
                       WE-Error.
*>
     if       access-type < 5 or > 8                   *> NOT using 'not >'
              move 998 to WE-Error                     *> 998 Invalid calling parameter settings
              go to aa999-main-exit
     end-if
*>
*>  Now do Start primary key before read-next
*>
     if       File-Key-No = 1
        and   fn-equal-to
              start Stock-File key = Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-less-than
              start Stock-File key < Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-greater-than
              start Stock-File key > Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-not-less-than
              start Stock-File key not < Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
              move     WS-Stock-Key to WS-File-Key.
*>
*>  Now do 1st alternate key (Stock-Abrev-Key) before read-next
*>
     if       File-Key-No = 2
        and   fn-equal-to
              start Stock-File key = Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-less-than
              start Stock-File key < Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-greater-than
              start Stock-File key > Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-not-less-than
              start Stock-File key not < Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
              move     WS-Stock-Abrev-Key to WS-File-Key
*>
*>  Now do 2nd alternate key (Stock-Desc) before read-next
*>
     if       File-Key-No = 3
        and   fn-equal-to
              start Stock-File key = Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-less-than
              start Stock-File key < Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-greater-than
              start Stock-File key > Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-not-less-than
              start Stock-File key not < Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
              move     WS-Stock-Desc to WS-File-Key
     go       to aa999-main-exit.
*>
 aa070-Process-Write.
     move     206 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     write    Stock-Record invalid key
              move 22 to FS-Reply
     end-write.
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa080-Process-Delete.
     move     207 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     delete   Stock-File record invalid key
              move 21 to FS-Reply
     end-delete.
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa090-Process-Rewrite.
*>
     move     208 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     rewrite  Stock-Record invalid key
              move 21 to FS-Reply
     end-rewrite
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa100-Bad-Function.
*>
*> Houston; We have a problem
*>
     move     999 to WE-Error.                         *> 999
     move     99  to fs-reply.
*>
 aa999-main-exit.
     if       Testing-1
              perform Ca-Process-Logs
     end-if.
*>
 aa-main-exit.
*>
*> Now have processed cobol flat file,  so ..
*>
 aa-Exit.
     exit program.
*>
 ba-Process-RDBMS section.
*>***********************
*>
*>********************************************************************
*>  Here we call the relevent RDBMS module for this table            *
*>   which will include processing any other joined tables as needed *
*>********************************************************************
*>
 ba010-Test-WS-Rec-Size.
*>
*>     Test on very first call only  (So do NOT use var A & B again)
*>       Lets test that Data-record size is = or > than declared Rec in DAL
*>          as we can't adjust at compile/run time due to ALL Cobol compilers ?
*>
     move     22 to WS-Log-File-no.        *> for FHlogger
*>
     if       A = zero                        *> so it is being called first time
              move     function Length (
                                        WS-Stock-Record
                                                 ) to A
              move     function length (
                                        Stock-Record
                                                 ) to B
              if   A < B                      *> COULD LET caller module deal with these errors !!!!!!!
                   move 901 to WE-Error       *> 901 Programming error; temp rec length is wrong caller must stop
                   move 99 to fs-reply        *> allow for last field ( FILLER) not being present in layout.
              end-if
              if       WE-Error = 901                  *> record length wrong so display error, accept and then stop run.
                       move spaces to Display-Blk
                       string ST902          delimited by size
                              A              delimited by size
                              " < "          delimited by size
                              "Stock-Rec = " delimited by size
                              B              delimited by size    into Display-Blk
                       end-string
                       display Display-Blk at 2301 with erase eol     *> BUT WILL REMIND ME TO SET IT UP correctly
                       display ST901 at 2401 with erase eol
                       if  Testing-1
                           perform Ca-Process-Logs
                       end-if
                       accept Accept-Reply at 2433
                       go to ba-rdbms-exit
              end-if
*>
*>  Not a error comparing the length of records so - -
*>  Load up the DB settings from the system record as its not passed on
*>           hopefully once is enough  :)
*>
              move     RDBMS-DB-Name to DB-Schema
              move     RDBMS-User    to DB-UName
              move     RDBMS-Passwd  to DB-UPass
              move     RDBMS-Port    to DB-Port
              move     RDBMS-Host    to DB-Host
              move     RDBMS-Socket  to DB-Socket
     end-if.
*>
*>
*>   HERE we need a CDF [Compiler Directive] to select the correct DAL based
*>     on the pre SQL compiler e.g., JC's or dbpre or Prima conversions <<<<  ? >>>>>
*>        Do this after system testing and pre code release.
*>
*>  NOW SET UP FOR JC pre-sql compiler system.
*>   DAL-Datablock not needed unless using RDBMS DAL from Prima & MS Sql
*>
     call     "stockMT" using File-Access
                              ACAS-DAL-Common-data

                              WS-Stock-Record
     end-call.
*>
*>   Any errors leave it to caller to recover from
*>
 ba-rdbms-exit.
     exit     program.
*>   ****     *******
*>
 Ca-Process-Logs. *> Not called on DAL access as it does it already
*>**************
*>
     call     "fhlogger" using File-Access
                               ACAS-DAL-Common-data.
*>
 ca-Exit.     exit.
*>
 end program acas011.
