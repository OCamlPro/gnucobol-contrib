      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     20170103  
      * LICENSE
      *  Copyright (c) 2016 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  generate test environment for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestsetup gctestsetup.cbl 
      ****************************************************************
 	   identification division.
       program-id. gctestset.
       environment division.
       configuration section.
           repository.
            function all intrinsic.       
       input-output section.
       file-control.
           select fdef assign to '../cfg/gctestsetup.def'
           organization is line sequential
           file status is f-s.
           select fsetup assign to '../cfg/gctestsetup.cfg'
           organization is line sequential
           file status is f-s.
       data division.
       file section.
       fd  fdef.
       01  r-def.
           03     r-defcommand      pic x(10).
           03     r-definition      pic x(512).
      *    
       fd  fsetup.
       01  r-setup.
           03     r-command         pic x(10).
           03     r-row             pic x(80).
           03     filler redefines r-row.
             05   r-param1          pic x(40).
             05   r-param2          pic x(40).
           03     filler            pic x(10).
      *    
       working-storage section.
       77 f-s                   pic xx.
	   77 retcode               BINARY-LONG SIGNED.
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
       01 cmd-line              pic x(512).
       01 cmd-cmd               pic x(10).
       01 cmd-def               pic x(512).
       01 cmd-param             pic x(512).
       01 cmd-run               pic x(512).
       77 bfound                pic 9.
       77 count-errors          pic 9(3) value zero.
      *
       77   posstart            pic 9(3).
       77   lensub              pic 9(3).
      *
       77   ntype               BINARY-LONG .
       77   cmd-go              pic x(80) value space.
      *
       01     parm-def.
           03 parm-ele.
             05 p1                  pic x(256).
             05 np1                 pic 9(3).
             05 p2                  pic x(256).
             05 np2                 pic 9(3).
             05 p3                  pic x(256).
             05 np3                 pic 9(3).
             05 p4                  pic x(256).
             05 np4                 pic 9(3).
             05 p5                  pic x(256).
             05 np5                 pic 9(3).
             05 p6                  pic x(256).
             05 np6                 pic 9(3).
             05 p7                  pic x(256).
             05 np7                 pic 9(3).
             05 p8                  pic x(256).
             05 np8                 pic 9(3).
             05 p9                  pic x(256).
             05 np9                 pic 9(3).
             05 p10                 pic x(256).
             05 np10                pic 9(3).
           03 parm-ele-singleoccur redefines parm-ele
                     occurs 10 times.
             05 parm-ele-single     pic x(256).
             05 parm-ele-pos        pic 999.
           
      *
       77 idx                   pic 99 value zero.
       77 idx-sep               pic 99 value zero.
       77 posstring             pic 9(4).
      *
       01      array-def-cmd.
          03   ar-max-ele       pic 99.
          03   ar-def-cmd occurs 20 times.
            05 ar-cmd           pic x(10).
            05 ar-def           pic x(512).
      *
       01 cmd-tmp               pic x(512).
      *
      *-------------------------------------------------------*
       procedure division.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
           display '*===============================================*'
           display ' GCSort test environment ' gcsort-tests-ver
           display '*===============================================*'
           display '*===============================================*'
           display '  gctestsetup          '
           display '             Setup test enviroment '
           display '*===============================================*'
      *    call 'gcsysop' returning ntype
           call 'gctestgetop' using ntype
TEST00***          display ' after call gcsysop ntype = ' ntype  
           open input fdef
           if (f-s not = '00')
                display '*gctestsetup* error opening gctestsetup.def'
                display ' file status ' f-s
                goback
           end-if
           perform read-file-def    until f-s not = '00'
           close fdef
      *
           open input fsetup
           if (f-s not = '00')
                display '*gctestsetup* error opening gctestsetup.cfg'
                display ' file status ' f-s
                goback
           end-if
           move  idx        to ar-max-ele
           perform read-file-setup  until f-s not = '00'
           close fsetup
           
           display '----------------------------------------------'
           if count-errors > 0
              display '*gctestsetup* num. errors : ' count-errors 
              display '       setup failed '
           else
              display '       setup ok '
           end-if
           display '----------------------------------------------'
           .
       end-99.
           goback.
      *
      *---------------------------------------------------------*
       read-file-def              section.
      *---------------------------------------------------------*
       refs-00.
           read fdef
           if (f-s = '00')
              perform get-command
           end-if
           .
       refs-99.
           exit.
      *
      *
      *---------------------------------------------------------*
       get-command                section.
      *---------------------------------------------------------*
       geco-00.
           if (r-defcommand(1:1) NOT = '*')
               display ' r-defcommand ' r-defcommand    
               display ' r-definition ' r-definition    
               add  1  to idx
               move r-defcommand    to  ar-cmd(idx)
               move r-definition    to  ar-def(idx)
           end-if
           .
       geco-99.
           exit.
      *
      *---------------------------------------------------------*
       read-file-setup            section.
      *---------------------------------------------------------*
       refs-00.
           read fsetup
           if (f-s = '00')
              perform exec-command
           end-if
           .
       refs-99.
           exit.
      *
      *---------------------------------------------------------*
       exec-command               section.
      *---------------------------------------------------------*
       exco-00.
      * skip comment
           move zero   to retcode
           if (r-command(1:1) NOT = '*') AND
              (r-command(1:1) NOT = SPACE) 
             evaluate TRIM(r-command, TRAILING)
               when 'compdll'
                   move TRIM(r-command, TRAILING) to cmd-cmd 
                   move TRIM(r-param1, TRAILING)  to cmd-param
                   perform get-command-line
                   if (bfound = zero)
                     display 
                     '*gctestsetup* command not defined into file .def'
                     display ' command : ' cmd-cmd 
                     goback
                   end-if
                   perform set-command-line
                   call 'SYSTEM' using cmd-def
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                   end-if
               when 'compile'
                   move TRIM(r-command, TRAILING) to cmd-cmd 
                   move TRIM(r-param1, TRAILING)  to cmd-param
                   perform get-command-line
                   if (bfound = zero)
                     display 
                     '*gctestsetup* command not defined into file .def'
                     display ' command : ' cmd-cmd 
                     goback
                   end-if
                   perform set-command-line
                   call 'SYSTEM' using cmd-def
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                   end-if
               when 'setvar'
                   move TRIM(r-param1, TRAILING) to env-set-name
                   move TRIM(r-param2, TRAILING) to env-set-value
                   perform set-value-env
               when 'unsetvar'
                   move TRIM(r-param1, TRAILING) to env-set-name
                   move space                    to env-set-value
                   perform set-value-env
               when 'execute'
Win                if (ntype = 1)
                    call 'SYSTEM' using r-param1
                   else
Linux                if (ntype = 2)
                        move space to cmd-go
                        string './' delimited by size 
                               r-param1 delimited by size
                                  into cmd-go
TEST00***               display ' cmd:>' cmd-go  '<'          
                        call 'SYSTEM' using cmd-go
                       end-if
                   end-if
                              
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                   end-if
               when 'copy'                       
                   call 'CBL_COPY_FILE' USING 
                           TRIM(r-param1, TRAILING) 
                           TRIM(r-param2, TRAILING) 
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                   end-if
      D            display 'r-param1 = ' r-param1
      D            display 'r-param2 = ' r-param2
               when other
                   display 'gctestsetup* command not found = ' 
                        TRIM(r-command, TRAILING)
                   add 1 to count-errors
              end-evaluate
             display 'command:'  r-setup ' Retcode:' retcode
           end-if
           .
       exco-99.
           exit.       
       
      *
      *---------------------------------------------------------*
       set-value-env             section.
      *---------------------------------------------------------*
       sv-00.
	       display env-set-name  upon ENVIRONMENT-NAME
           display env-set-value upon ENVIRONMENT-VALUE          
           .
       sv-99.
           exit.
      *
      *---------------------------------------------------------*
       get-command-line           section.
      *---------------------------------------------------------*
       gecl-00.
           move zero    to bfound
           perform search-command  varying idx from 1 by 1
                 until idx > ar-max-ele  or  bfound = 1
           .
       gecl-99.
           exit.       
      *
      *---------------------------------------------------------*
       search-command             section.
      *---------------------------------------------------------*
       gecl-00.
           if (cmd-cmd = ar-cmd(idx))
               move ar-def(idx)  to cmd-def
               move 1            to bfound
           end-if
           .
       gecl-99.
           exit.
      *
      *---------------------------------------------------------*
       set-command-line           section.
      *---------------------------------------------------------*
       secl-00.
      **   substitute only $1 single parameter 
            move SUBSTITUTE(cmd-def, '$1',TRIM(cmd-param, TRAILING))
                to cmd-def
           .
       secl-99.
           exit.
      *
