      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     20240220  
      * LICENSE
      *  Copyright (c) 2024 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  generate test environment for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestcmd gctestcmd.cbl 
      ****************************************************************
 	   identification division.
       program-id. gctestcmd.
       environment division.
       configuration section.
           repository.
            function all intrinsic.       
       input-output section.
       file-control.
           select fdef assign to '../cfg/gctestcmd.cfg'
           organization is line sequential
           file status is f-s.
           select ftake assign to '../takefile/tmp/takecmd.prm'
           organization is line sequential
           file status is f-s.
       data division.
       file section.
       fd  fdef.
       01  r-def.
      *    prefix       - <blank> command, <*> comment, <P> print line 
           03     r-prefix          pic x.
           03     filler            pic x.
      *    groupcmd     - identifier command group            
           03     r-groupcmd        pic x(10).
           03     filler            pic x.
      *    commandtype  - print = printline, exec = exec command, check = check file result
           03     r-commandtype     pic x(10).
           03     filler            pic x.
      *    commandline  - command line     
           03     r-commandline     pic x(512).
      *    
       fd  ftake.
       01  t-defline                pic x(512).
      *    
       working-storage section.
       77 chrsl                 pic x value '/'.
       77 chrbs                 pic x value '\'.
       77 wk-group              pic x(10) value space.
       77 wk-commandtype        pic x(10) value space.
       77 f-s                   pic xx.
	   77 retcode               BINARY-LONG SIGNED.
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
       01 cmd-line              pic x(512).
       01 cmd-cmd               pic x(512).
       77 count-errors          pic 9(3) value zero.
       77 group-errors          pic 9(5) value zero.
      *
       77 evide                 pic x(10).
      *
       77   ntype               BINARY-LONG .
       77   nver                pic 9(9) .
       77   cmd-go              pic x(1024) value space.
      *
      *
       77 idx                   pic 9(3) value zero.
       77 idx-sep               pic 9(3) value zero.
       77 idx-rc                pic 9(3) value zero.
      *
       01      array-def-cmd.
          03   ar-max-ele       pic 9(3).
          03   ar-def-cmd occurs 1024 times.
            05 ar-prefix        pic x.
            05 ar-groupcmd      pic x(10).
            05 ar-commandtype   pic x(10).
            05 ar-commandline   pic x(512).
      *
       01      array-retcode.
          03   rc-max-ele       pic 9(3).
          03   rc-def-cmd occurs 1024 times.
            05 rc-groupcmd      pic x(10).
            05 rc-commandtype   pic x(10).
            05 rc-retcode       BINARY-LONG SIGNED.
      *     
       01 cmd-tmp               pic x(512).
      *
      *-------------------------------------------------------*
       procedure division.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
           display '*===============================================*'
           display ' GCSort test JOIN environment ' gcsort-tests-ver
           display '*===============================================*'
           display '*===============================================*'
           display '  gctestcmd           '
           display '*===============================================*'
           move zero        to ntype
           move zero        to nver
           call 'gctestgetop' using ntype, nver
           display ' Environment : ' ntype 
           display ' Version     : ' nver 
TEST00***          display ' after call gcsysop ntype = ' ntype  
           open input fdef
           if (f-s not = '00')
                display '*gctestcmd* error opening gctestcmd.cfg'
                display ' file status ' f-s
                goback
           end-if
           perform read-file-def    until f-s not = '00'
           close fdef
      *      
           move idx  to idx-sep
           move zero to idx
           move zero to rc-max-ele.
           
           perform read-array-cmd until idx > idx-sep
           close ftake
           move idx-rc to rc-max-ele.
           
           perform print-final
           
           perform print-summary

           display '----------------------------------------------'
           if count-errors > 0
              display '*gctestcmd* num. errors : ' count-errors 
              display '       test command failed '
           else
              display '       test command ok '
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
       
           if (r-prefix NOT = '*')
               add  1  to idx
               move r-prefix        to  ar-prefix(idx)
               move r-groupcmd      to  ar-groupcmd(idx)
               move r-commandtype   to  ar-commandtype(idx)
               move r-commandline   to  ar-commandline(idx)
           end-if
           .
       geco-99.
           exit.
      *
      *---------------------------------------------------------*
       read-array-cmd            section.
      *---------------------------------------------------------*
       refs-00.
           add 1 to idx
           if (idx <= idx-sep)
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
           if (ar-prefix(idx)  NOT = '*') AND 
              (ar-commandline(idx) NOT = SPACE)
               if (wk-group not = ar-groupcmd(idx))  
                   close ftake
                   perform open-out-takefile
                   move ar-groupcmd(idx) to wk-group
               end-if
               
               if (wk-commandtype not = ar-commandtype(idx))
                    move ar-commandtype(idx) to wk-commandtype
                    add 1 to idx-rc
               end-if
             move ar-groupcmd(idx)    to rc-groupcmd(idx-rc)
             move ar-commandtype(idx) to rc-commandtype(idx-rc)
             move zero                to rc-retcode(idx-rc)
               
      **-->>       display ' command ' TRIM(ar-commandtype(idx), TRAILING)  
               
               
             evaluate TRIM(ar-commandtype(idx), TRAILING)
      **................................................................................. gentake
               when 'echo'
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd 
                   display TRIM(cmd-cmd, TRAILING)
      **................................................................................. gentake
               when 'gentake'
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd 
                   inspect cmd-cmd replacing all chrsl by chrbs
                   move cmd-cmd to t-defline
                   write t-defline
                   move t-defline to cmd-cmd 
                   display TRIM(cmd-cmd, TRAILING) 
      **................................................................................. gcsort
               when 'gcsort'
                   close ftake
                   move space to wk-group, cmd-cmd 
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd 
Win                if (ntype = 1)
                        move 1 to ntype
                        string 'gcsort 'delimited by size 
                               cmd-cmd  delimited by size
                                  into cmd-go                        
                        inspect cmd-go replacing all chrsl by chrbs
                        move cmd-go to cmd-cmd
                   else
Linux                if (ntype = 2)
                        move space to cmd-go
                        string './gcsort ' delimited by size 
                               cmd-cmd  delimited by size
                                  into cmd-go
                        move cmd-go to cmd-cmd          
                      end-if
                   end-if
                   
                   display TRIM(cmd-cmd, TRAILING) 
                   
                   call 'SYSTEM' using cmd-cmd
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                        add 1 to rc-retcode(idx-rc)
                   end-if
      **-->>             move cmd-go to cmd-cmd 
      **-->>                   display TRIM(cmd-cmd, TRAILING) 

               when 'exec'
                   move space to wk-group, cmd-cmd 
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd 
Win                if (ntype = 1)
                        move 1 to ntype
                        inspect cmd-cmd replacing all chrsl by chrbs
                        move cmd-cmd to cmd-go
                   else
Linux                if (ntype = 2)
                        move space to cmd-go
                        string './' delimited by size 
                               cmd-cmd  delimited by size
                                  into cmd-go
                        move cmd-go to cmd-cmd          
                      end-if
                   end-if
                   
                   display TRIM(cmd-cmd, TRAILING) 
                   
                   call 'SYSTEM' using cmd-cmd
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                        add 1 to rc-retcode(idx-rc)
                   end-if
      **-->>             move cmd-go to cmd-cmd 
      **-->>                   display TRIM(cmd-cmd, TRAILING) 

      **................................................................................. check
               when 'check'
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd
Win                if (ntype = 1)
                        move space to cmd-go
                        move 1 to ntype
                        string 'fc ' delimited by size 
                               TRIM(cmd-cmd, TRAILING) delimited by size
                                  into cmd-go
                        inspect cmd-go replacing all chrsl by chrbs
                   else
Linux                 if (ntype = 2)
                        move space to cmd-go
                         string 'diff -a -Z ' delimited by size 
                              TRIM(cmd-cmd, TRAILING) delimited by size
                                  into cmd-go
                     end-if
                   end-if
                   display TRIM(cmd-cmd, TRAILING) 
                   
                   call 'SYSTEM' using cmd-go 
                   move RETURN-CODE   to retcode
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                        add 1 to rc-retcode(idx-rc)
                   end-if
                   move cmd-go to cmd-cmd 
      **-->>             display TRIM(cmd-cmd, TRAILING) 

      **           display 'Command:' TRIM(cmd-cmd, TRAILING) 
      **                   ' - Retcode:' retcode
      
      **................................................................................. setvar
               when 'setvar'
                   move TRIM(ar-commandline(idx), TRAILING) to cmd-cmd
                   unstring  cmd-cmd delimited by '=' or space into 
                           env-set-name, env-set-value
Win                if (ntype = 1)
                      inspect env-set-value replacing all chrsl by chrbs
                   end-if
      **           display 'cmd-cmd = ' TRIM(cmd-cmd, TRAILING)
      **           display 'env-set-name  ' TRIM(env-set-name, TRAILING)
      **                   ' - env-set-value ' 
      **                        TRIM(env-set-value, TRAILING)
                   display TRIM(cmd-cmd, TRAILING) 
                   perform set-value-env
      ** Check return code [Problem in Linux environment]     
                   if (retcode > 256)
                        divide retcode by 256
                        giving retcode
                   end-if
                   if retcode not = zero
                        add 1 to count-errors
                        add 1 to rc-retcode(idx-rc)
                   end-if
      **-->>             move cmd-go to cmd-cmd                    
               when other
                   display 'gctestcmd* command not found = ' 
                        TRIM(ar-commandline(idx), TRAILING)
                   add 1 to count-errors
              end-evaluate
      **-->>              display TRIM(cmd-cmd, TRAILING) 

           end-if
           .
       exco-99.
           exit.       
      *
      *---------------------------------------------------------*
       open-out-takefile         section.
      *---------------------------------------------------------*
      *
       oo-00.
           open output ftake.
           if (f-s not = '00')
             display '*gctestcmd* error opening take file takecmd.prm'
             display ' file status ' f-s
             goback
           end-if
           .
        oo-99.
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
       print-final               section.
      *---------------------------------------------------------*
       prfi-00.
           move zero to idx-rc 
           display 
           '========================================================='
           display 
           ' GroupID      Command Type        RetCode '
           display
           '========================================================='
           perform varying idx-rc from 1 by 1 
                until idx-rc > rc-max-ele
              display ' ' rc-groupcmd(idx-rc)    '      ' 
                          rc-commandtype(idx-rc) '      ' 
                          rc-retcode(idx-rc)       
           end-perform
           .           
       prfi-99.
           exit.
      *---------------------------------------------------------*
       print-summary               section.
      *---------------------------------------------------------*
       prfi-00.
           move zero to idx-rc 
           display 
           '========================================================='
           display 
           '     RETCODE SUMMARY '
           display 
           '========================================================='
           display 
           '  GroupID       RetCode '
           display
           '========================================================='
           move space to wk-group
           perform varying idx-rc from 1 by 1 
                until idx-rc > rc-max-ele
              if (wk-group  = SPACE)
                  move rc-groupcmd(idx-rc) to wk-group
              end-if

              move space to evide
              if (group-errors > 0) 
                move '  <------ ' to evide
              end-if
              
              if (wk-group not = rc-groupcmd(idx-rc))
               
                 display ' ' wk-group    '      ' 
                             group-errors evide
                  move rc-groupcmd(idx-rc) to wk-group
                  move zero to group-errors
              end-if   
              
              if (wk-group = rc-groupcmd(idx-rc))
                  add rc-retcode(idx-rc)  to group-errors
              end-if
              
           end-perform
           .           
       prfi-99.
           exit.
       
       
           