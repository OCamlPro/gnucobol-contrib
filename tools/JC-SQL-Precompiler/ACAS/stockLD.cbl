       >>source free
*>********************************************
*>                                           *
*>    Stock Table Load via the Stock file    *
*>                 for MySQL                 *
*>     Used as Modal for the others.         *
*>                                           *
*>-------------------------------------------*
*>  This modules uses commit and rollback so *
*>  you MUST ensure that autocommit is OFF   *
*>   in the rdb settings. It is as default   *
*>   set ON.                                 *
*>********************************************
*>
 identification division.
 program-id.             StockLD.
*>**
*>   author.             V.B.Coen FBCS.
*>                       For Applewood Computers.
*>**
*>   Security.           Copyright (C) 2016, Vincent Bryan Coen.
*>                       Distributed under the GNU General Public License
*>                       v2.0. Only. See the file COPYING for details.
*>**
*>   Remarks.            Stock RDB Table load from the Stock File
*>                       using the Mysql RDBMS.
*>                       For use with ACAS v3.02 and later only.
*>**
*>   Version.            See prog-name in Ws.
*>**
*>   Called Modules.     acas011   } For file and table access.
*>                       stockMT   }
*>                       fhlogger
*>
*>**
*>   Error messages used.
*>                       SY001.
*>                       SY004.
*>                       SY006.
*>                       SY007.
*>                       SY008.
*>                       SY009.
*>                       ST010.
*>                       ST011.
*>                       ST012.
*>                       ST013.
*>                       ST014.
*>                       ST015.
*>                       ST018.
*>                       ST097.
*>                       ST099.
*>**
*>   Changes.
*> 04/08/16 vbc - .01 Forgot to mv stock rec to ws - Der!
*>                    Move zero to File-Function & Access-Type to close
*>                    log file via fh-logger before last call to stockMT
*>                     at RDB close.
*>                    Hopefully will clear error 34.
*>                    LS bugs rearing it head again
*> 07/07/16 vbc - .02 Replace calls to acas011 for stockMT.
*>                    Will still need to test acas011 though !
*> 11/07/16 vbc - .03 Added Log rec count & removed clearing fs-reply.
*>                .04 Clear out un-needed testing displays.
*> 29/07/16 vbc - .05 Display extra error details on writing + new msg ST018.
*> 30/07/16 vbc - .06 Use Cobol file accessing and not acas011.
*> 24/10/16 vbc - .   ALL programs now using wsnames.cob in copybooks
*> 03/01/17 vbc - .07 Clean up displays & msgs.
*>**
*>
*>*************************************************************************
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of the Applewood Computers Accounting System
*> and is copyright (c) Vincent B Coen. 2016 and later.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 ONLY.
*>
*> ACAS is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endevor
*> to fix it, providing you tell me about the problem by using the Bug
*> reporting system on Sourceforge for the ACAS system.
*>
*> You should have received a copy of the GNU General Public License along
*> with ACAS; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>*************************************************************************
*>
*>
 environment division.
*>-------------------
*>
*> copy "envdiv.cob".
 configuration section.
 source-computer.      Linux.
 object-computer.      Linux.
*> special-names.
*>     console is crt.
 input-output            section.
*>------------------------------
*>
 file-control.
*>-----------
*>
*> copy "selsys.cob".
     select  system-file     assign        file-0
                             access        dynamic
                             organization  is relative
                             relative key  is rrn
                             status        fs-reply.
*>
 data division.
*>------------
*>
 file section.
*>-----------
*>
*> copy "fdsys.cob".
*>*******************************************
*>                                          *
*>  File Definition For The System File     *
*>                                          *
*>*******************************************
*>   Record Size 534 Bytes (02/02/09)
*>  FORMAT CHANGES MADE 14/09/10 for Stock Control
*>   see wssystem.cob for later updates
*>
 fd  system-file.
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
 working-storage section.
*>----------------------
 77  prog-name           pic x(17)    value "stockLD (3.02.07)".
 77  z                   binary-char  value zero.
 77  OS-Delimiter        pic x        value "/".
 77  ACAS_BIN            pic x(512)   value spaces.
 77  ACAS_LEDGERS        pic x(500)   value spaces.
 77  Arg-Number          pic 9        value zero.
*>
*> holds program parameter values from command line
 01  Arg-Vals                         value spaces.
     03  Arg-Value       pic x(525)  occurs 2.
 01  Arg-Test            pic x(525)   value spaces.
*>
 01  work-fields.
     03  ws-Rec-Cnt-In   pic 9(4)     value zero.
     03  ws-Rec-Cnt-Out  pic 9(4)     value zero.
     03  ws-Rec-Cnt-R-Out pic 9(6)    value zero.
     03  ws-reply        pic x.
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
 01  Error-Messages.
*> System Wide
     03  ST001          pic x(26) value "SY001 System 1 read err = ".
     03  ST004          pic x(59) value "SY004 Problem with opening system file. Hit return to clear".
     03  SY006          pic x(62) value "SY006 Program Arguments limited to two and you have specified ".
     03  SY007          pic x(35) value "SY007 Program arguments incorrect: ".
     03  SY008          pic x(31) value "SY008 Note message & Hit return".
     03  SY009          pic x(53) value "SY009 Environment variables not yet set up : ABORTING".
*> Program specific
     03  ST010          pic x(30) value "ST010 Duplicate key/s found = ".
     03  ST011          pic x(33) value "ST011 Error on stockMT processing".
     03  ST012          pic x(33) value "ST012 Error opening Stock File = ".
     03  ST013          pic x(30) value "ST013 Error on reading file = ".
     03  ST014          pic x(31) value "ST014 Error on writing table = ".
     03  ST015          pic x(34) value "ST015 Error opening Stock Table = ".
     03  ST018          pic x(22) value "ST018 RDBMS details : ".
     03  ST097          pic x(30) value "ST097 No Stock file present".
     03  ST099          pic x(15) value "ST099 Ignoring.".
*>
 procedure division.
*>=================
*>
 aa000-main-start.
     perform  zz020-Get-Program-Args.
     display  prog-name at 0101 with foreground-color 2 erase eos.
     move     5      to WS-Log-System.   *> 1 = IRS, 2=GL, 3=SL, 4=PL, 5=Stock used in FH logging
     move     22     to WS-Log-File-No.  *> RDB, File/Table
*>
*>  Get the system param for the various RDB fields
*>
     open     input System-File.
     if       fs-reply not = zero
              display ST001 fs-reply
              display ST004
              close System-File
              goback
     end-if
     move     1 to rrn.
     read     system-file record.
     if       fs-reply not = zero
              display ST001 fs-reply
              close System-File
              goback
     end-if
*>
*>  Over-ride processes for acas011/stockMT for Dup modes
*>
     move     zero to File-System-Used
                      File-Duplicates-In-Use
                      FA-File-System-Used
                      FA-File-Duplicates-In-Use.   *>  Cobol file in use
     move     zero to Log-file-rec-written.        *> for logging.
*>
     perform  acas011-Open-Input.      *> open input Cobol stock FILE
     if       FS-Reply = 35
              display ST097 at 0301
              display " Terminating nothing to do" at 0338
              close System-File
              perform acas011-Close
              goback.
     if       FS-Reply not = zero
              display ST012       at 0301
              display "FS-Reply=" at 0338
              display FS-Reply    at 0347
              display SY008       at 0401
              accept  ws-Reply    at 0433
              close System-File
              perform acas011-Close
              goback.
     move     1 to File-Key-No.
     move     1 to File-System-Used
                   FA-File-System-Used.            *> RDB in use
     perform  acas011-Open.                        *> Open/Init RDB via FH - acas011
     if       FS-Reply not = zero
              display ST015      at 0301
              close System-File
              perform acas011-Close
              move zero to File-System-Used
                           File-Duplicates-In-Use
              perform acas011-Close
              goback
     end-if.
     move     zero to Access-Type.
     go       to aa010-Read.
*>
 acas011.
     call     "acas011" using System-Record
                              WS-Stock-Record
                              File-Access
                              File-Defs
                              ACAS-DAL-Common-data.
*>
 acas011-Open.
     set      fn-open to true.
     set      fn-i-o  to true.
     perform  acas011.
     perform  aa100-Check-4-Errors.
*>
 acas011-Open-Input.
     set      fn-open  to true.
     set      fn-input to true.
     perform  acas011.
     perform  aa100-Check-4-Errors.
*>
 acas011-Close.
     set      fn-Close to true.
     perform  acas011.
*>
 acas011-Read-Next.
     set      fn-Read-Next to true.
     perform  acas011.
*>
 acas011-Write.
     set      fn-Write to true.
     perform  acas011.
*>
 acas011-Rewrite.
     set      fn-re-write to true.
     perform  acas011.
*>
*>  We will Rollback on any errors but Mysql has to be set up to do it
*>      otherwise as normally it is set to autocommit !!!!!
*>
 aa010-Read.
     move     zero to File-System-Used
                      FA-File-System-Used.            *> Cobol file in use
     perform  acas011-Read-Next.
     if       fs-Reply = 10                        *> EOF
              go to aa999-Finish
     end-if
*>
     if       FS-Reply not = zero
              display ST013    at 1401 with highlight erase eol
              display fs-reply at 1425  with highlight
 *>             perform aa020-Rollback
              go to aa999-Finish
     end-if
*>
     add      1 to ws-Rec-Cnt-In.
*>
     move     1 to File-System-Used     *> acas0nn set to process RDB
                   FA-File-System-Used.
     perform  acas011-Write.
     if       Sql-State = "23000"  *> Dup key (rec already present)
         or   fs-reply = 22                    *> Check for dup key/record and continue at least while testing
         or   SQL-Err (1:4) = "1062"
                           or "1022"
              perform acas011-Rewrite
              if   FS-Reply not = zero
                   display ST010        at 0701 with foreground-color 2 highlight erase eol
                   display WS-File-Key  at 0731 with foreground-color 2 highlight
                   display ST099        at 0801
              else
                   add 1 to ws-Rec-Cnt-R-Out
              end-if
              go to aa010-Read
     end-if
*>
     if       fs-reply not = zero              *> Anything else
              display ST014         at 0701 with foreground-color 2 highlight erase eol
              display fs-reply      at 0732 with foreground-color 2 highlight
              display "WE-Error = " at 0801 with foreground-color 2 highlight
              display WE-Error      at 0811 with foreground-color 2 highlight
              display ST018         at 0901 with foreground-color 2 highlight
              display SQL-Err       at 0923 with foreground-color 2
              display SQL-Msg       at 1001 with foreground-color 2
 *>             perform aa020-Rollback
              display SY008         at 0901 with erase eol
              accept  Accept-Reply  at 0935
              go to aa999-Finish
     end-if
     add      1 to ws-Rec-Cnt-Out.
     go       to aa010-Read.
*>
 aa020-Rollback.
*>
*> These do not work during testing with mariadb - Non transactional model or autocommit set ON
*>           exec sql
*>                rollback
*>           end-exec.
     call     "MySQL_rollback".
*>     if       return-code not = zero
*>              display "Rollback failed " at 0501
*>              display return-code        at 0517
*>     end-if.
*>
 aa030-Commit.
*>           exec sql
*>                commit
*>           end-exec.
     call     "MySQL_commit".
*>     if       return-code not = zero
*>              display "Commit failed " at 0501
*>              display return-code      at 0515
*>     end-if.
*>
 aa100-Check-4-Errors.
     if       fs-reply not = zero
              display ST011            at 0801   *> acas011/StockMT processing
              display "Fs-reply = "    at 0901
              display fs-reply         at 0912
              display "WE-Error = "    at 1001
              display  WE-Error        at 1012
              display SQL-Err          at 1101
              display SQL-Msg          at 1201
 *>             perform aa020-Rollback
              display SY008            at 2001 with erase eol
              accept  Accept-Reply     at 2035
              go to aa999-Finish
     end-if.
*>
 aa999-Finish.
     display  "Rec cnt  in = "     at 1601 with erase eol.
     display  ws-Rec-Cnt-In        at 1615.
     display  "Rec cnt out = "     at 1622.
     display  ws-Rec-Cnt-Out       at 1637.
     display  "Rec Cnt rewrite = " at 1646
     display  ws-Rec-Cnt-R-Out     at 1665
     display  "Log Recs out   = "  at 1801 with erase eol.
     display  Log-File-Rec-Written at 1817.
     move     1 to File-System-Used
                   FA-File-System-Used.
     move     zero to Access-Type.
     move     2 to File-Function.
     perform  acas011-Close.                     *> Close RDB
     close    System-File.
     move     zero to File-System-Used
                      FA-File-System-Used.
     perform  acas011-close.    *> Close cobol stock file
     Display  "EOJ - Load Stock Table" at 2001 with erase eol.
     display  SY008    at 2401.
     accept   ws-reply at 2435.
     goback.
*>
*> copy "Proc-Get-Env-Set-Files.cob".  *> Only uses ACAS_LEDGERS now
*>
*>  28/10/16 vbc - .00   Made a copybook to make it easier for maintenance
*>                       All msgs start with SY00.
*>                       Rem out all refs to ACAS_IRS as all files in same dir
*>                       after RDB conv and using ACAS system param file.
*>
 zz010-Get-Env-Set-Files section.
*>******************************
*>
     accept   ACAS_LEDGERS from Environment "ACAS_LEDGERS".
 *>    accept   ACAS_IRS     from Environment "ACAS_IRS".
     accept   ACAS_BIN     from Environment "ACAS_BIN".
*>
     if       ACAS_LEDGERS (1:1) = spaces
           or ACAS_BIN (1:1) = spaces
*>           or ACAS_IRS (1:1) = space
              display SY009   at 0505 with erase eos highlight
              display SY008   at 1210 with           foreground-color 3 highlight
              accept ws-reply at 1243
              stop run
     end-if
     if       ACAS_LEDGERS (1:1) = "\" or "/"   *> Its Windows or Linux/Unix/OSX
              move ACAS_LEDGERS (1:1) to OS-Delimiter
     end-if.
*>
 zz010-GESF-Exit.
     exit     section.
*>
 zz020-Get-Program-Args      section.
*>**********************************
*>
     perform  zz010-Get-Env-Set-Files.          *> This must be set so get it 1st + need os-delimiter
*>
*> See if we have temporary overrides that have ben supplied whwn calling program
*>
     accept   Arg-Number from argument-number.
     if       Arg-Number = zero
              go to zz020-Set-the-Paths.
*>
     if       Arg-Number > 2
              display SY006        at 0101 with erase eos foreground-color 3
              display Arg-Number   at 0164 with           foreground-color 3
              display SY008        at 1210 with           foreground-color 3 highlight
              accept ws-reply      at 1243
              stop run.
*>
     move     zero to z.
     perform  Arg-Number times
              add      1 to z
              accept   Arg-Value (z) from argument-value
              move     Arg-Value (z) to Arg-Test
              if       Arg-Test (1:13) not = "ACAS_LEDGERS="
 *>                and   Arg-Test (1:9)  not = "ACAS_IRS="
                       display SY007 at 0101  with erase eos foreground-color 3
                       display SY008        at 1210 with           foreground-color 3 highlight
                       accept ws-reply      at 1243
                       stop run
              end-if
              if       Arg-Test (1:13) = "ACAS_LEDGERS="
                       move Arg-Test (14:512) to ACAS_LEDGERS
 *>             else
 *>                if    Arg-Test (1:9) = "ACAS_IRS="
 *>                      move Arg-Test (10:512) to ACAS_IRS
 *>                end-if
              end-if
     end-perform
     if       ACAS_LEDGERS (1:1) = "\" or "/"   *> Its Windows or Linux/Unix/OSX
              move ACAS_LEDGERS (1:1) to OS-Delimiter
     end-if.
*>
*>  Put absolute path with file names into the file-id areas over-writing filename.
*>    Note that count in perform is equal to number of files used in system & wsnames.cob held
*>       in File-Defs-Count
*>
 zz020-Set-the-Paths.
*>
*>  first if is an experiment only
*>
     if       function MODULE-CALLER-ID = "ACAS"      *> Called by ACAS main program
              go to zz020-Exit                        *> so done already
     end-if
     if       File-Defs-os-Delimiter = "\" or "/"     *> shows its been done already
              go to zz020-Exit.
*>
     move     zero to z.
     perform  File-Defs-Count times
              add 1 to z
              move space to Arg-Test
              string ACAS_LEDGERS          delimited by space
                     OS-Delimiter          delimited by size
                     System-File-Names (z) delimited by space
                                             into Arg-Test
              end-string
              move     Arg-Test to System-File-Names (z)
     end-perform
     move     zero to z.
     move     OS-Delimiter to File-Defs-os-Delimiter.    *> in wsnames showing paths has been setup.
*>
 zz020-Exit.
     exit   section.
*>
*>
