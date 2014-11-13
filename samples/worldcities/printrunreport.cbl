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

procedure division using print-run-control.
open-entry.
    display run-line
    evaluate true
    when print-run-function = 'open'
    when print-run-function = 'OPEN'

        open output run-file
        call 'checkfilestatus' using run-file-name run-file-status end-call

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
                write run-record from run-heading after advancing 0 lines end-write
            else
                write run-record from run-heading after advancing one-page end-write
            end-if
            move 1 to run-line-count
            move 2 to run-skip-count
        end-if
        write run-record from run-line after advancing run-skip-count lines end-write
        add run-skip-count to run-line-count end-add

        move 1 to run-skip-count
        move spaces to run-line

    when print-run-function = 'close'
    when print-run-function = 'CLOSE'
        close run-file
        move 'open' to print-run-function

    when other
        display 'print run report invalid function: ' print-run-function end-display
        stop run

    end-evaluate
    goback
    .
end program printrunreport.

