       >> SOURCE FORMAT IS FREE
identification division.
program-id. checkfilestatus.

data division.
working-storage section.
01  status-message pic x(72).
01  display-message pic x(72) value spaces.

linkage section.
01  file-name pic x(64).
01  file-status pic x(2).

procedure division using file-name file-status.
start-checkfilestatus.
    if file-status = '00' or '10'
        goback
    end-if
    evaluate file-status
    when 00 move 'SUCCESS.' TO status-message   
    when 02 move 'SUCCESS DUPLICATE.' TO status-message 
    when 04 move 'SUCCESS INCOMPLETE.' TO status-message 
    when 05 move 'SUCCESS OPTIONAL.' TO status-message 
    when 07 move 'SUCCESS NO UNIT.' TO status-message 
    when 10 move 'END OF FILE.' TO status-message 
    when 14 move 'OUT OF KEY RANGE.' TO status-message 
    when 21 move 'KEY INVALID.' TO status-message 
    when 22 move 'KEY EXISTS.' TO status-message 
    when 23 move 'KEY NOT EXISTS.' TO status-message 
    when 30 move 'PERMANENT ERROR.' TO status-message 
    when 31 move 'INCONSISTENT FILENAME.' TO status-message 
    when 34 move 'BOUNDARY VIOLATION.' TO status-message 
    when 35 move 'FILE NOT FOUND.' TO status-message 
    when 37 move 'PERMISSION DENIED.' TO status-message 
    when 38 move 'CLOSED WITH LOCK.' TO status-message 
    when 39 move 'CONFLICT ATTRIBUTE.' TO status-message 
    when 41 move 'ALREADY OPEN.' TO status-message 
    when 42 move 'NOT OPEN.' TO status-message 
    when 43 move 'READ NOT DONE.' TO status-message 
    when 44 move 'RECORD OVERFLOW.' TO status-message 
    when 46 move 'READ ERROR.' TO status-message 
    when 47 move 'INPUT DENIED.' TO status-message 
    when 48 move 'OUTPUT DENIED.' TO status-message 
    when 49 move 'I/O DENIED.' TO status-message 
    when 51 move 'RECORD LOCKED.' TO status-message 
    when 52 move 'END-OF-PAGE.' TO status-message 
    when 57 move 'I/O LINAGE.' TO status-message 
    when 61 move 'FILE SHARING FAILURE.' TO status-message 
    when 91 move 'FILE NOT AVAILABLE.' TO status-message    
    end-evaluate
    string 'ERROR ' delimited by size
        file-name delimited by space
        space delimited by size
        status-message delimited by '.'
        into display-message
    end-string
    display display-message end-display
    stop run
    .
end program checkfilestatus.
       >>SOURCE FORMAT IS FREE
identification division.
program-id. printrunreport.

environment division.
configuration section.
special-names. C01 is one-page.
input-output section.
file-control.
     select run-file
        assign to run-file-name
        file status is run-file-status.

data division.
file section.
fd  run-file.
01  run-record pic x(72).

working-storage section.
01  run-file-name pic x(64) value 'run-file'.
01  run-file-status pic x(2).

01  run-heading.
    03  program-name pic x(31).
    03  filler pic x(14) value 'run report'.
    03  run-date.
        05  run-month pic xx.
        05  filler pic x value '/'.
        05  run-day-of-month pic xx.
        05  filler pic x value '/'.
        05  run-year pic xx.
    03  filler pic x value space. 
    03  run-time.
        05  run-hour pic xx.
        05  filler pic x value ':'.
        05  run-minute pic xx.
        05  filler pic x value "'".
        05  run-second pic xx.
        05  filler pic x value '"'.
   03  filler pic x value space.
   03  filler pic x(5) value 'page'.
   03  run-page pic zz9.

01  ct-time.
    03  ct-hour pic 99.
    03  ct-minute pic 99.
    03  ct-second pic 99.
    03  ct-hundredth pic 99.

01  cd-date.
    03  cd-year pic xx.
    03  cd-month pic xx.
    03  cd-day-of-month pic xx.


linkage section.
01  print-run-control.
    03  print-run-function pic x(5).
    03  run-program-name pic x(31).
    03  run-line pic x(72).
    03  run-page-count pic 999.
    03  run-line-count pic 99.
    03  run-line-limit pic 99 value 55.
    03  run-skip-count pic 9.
    03  display-run-line pic x.

procedure division using print-run-control.
open-entry.
    evaluate true
    when print-run-function = 'none'
        goback
    when print-run-function = 'open'
    when print-run-function = 'OPEN'

        move run-program-name to program-name

        accept cd-date from date end-accept
        move cd-year to run-year
        move cd-month to run-month
        move cd-day-of-month to run-day-of-month

        accept ct-time from time end-accept
        move ct-hour to run-hour
        move ct-minute to run-minute
        move ct-second to run-second

        move 0 to run-page-count
        move run-line-limit to run-line-count
        move 1 to run-skip-count

        move 'write' to print-run-function

    when print-run-function = 'WRITE'
    when print-run-function = 'write'
        if run-line-count + run-skip-count > run-line-limit
            add 1 to run-page-count end-add
            move run-page-count to run-page
            if run-page-count = 1
                open extend run-file
                if run-file-status = '35'
                    open output run-file
                    write run-record from run-heading after advancing 0 lines end-write
                else
                    write run-record from run-heading after advancing one-page end-write
                end-if
            else
                write run-record from run-heading after advancing one-page end-write
            end-if
            move 1 to run-line-count
            move 2 to run-skip-count
        end-if
        write run-record from run-line after advancing run-skip-count lines end-write
        add run-skip-count to run-line-count end-add

        move 1 to run-skip-count
        if display-run-line = 'y'
            display run-line end-display
        end-if
        move spaces to run-line

    when print-run-function = 'close'
    when print-run-function = 'CLOSE'
        close run-file
        move 'open' to print-run-function

    when other
        display 'print run report invalid function: ' end-display
        display print-run-control end-display
        stop run

    end-evaluate
    goback
    .
end program printrunreport.

identification division.
program-id. techtonics.
environment division.
input-output section.
file-control.
    select command-file
        assign to command-file-name
        organization is line sequential.
data division.
file section.
fd  command-file.
01  command-record pic x(128).
working-storage section.
01  tcx pic 99.
linkage section.
01  command-file-name pic x(128).
01  techtonics.
    03  techtonics-line pic x(128) occurs 30.
procedure division using command-file-name techtonics.
start-techtonics.
    display 'creating command-file '
        command-file-name end-display
    open output command-file
    perform varying tcx from 1 by 1
    until tcx > 30
    or techtonics-line(tcx) = 'end'
        write command-record
            from techtonics-line(tcx) end-write
    end-perform
    close command-file
    display space end-display
    goback
    .
end program techtonics.


