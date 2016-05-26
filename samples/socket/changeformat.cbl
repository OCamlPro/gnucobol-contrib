       >>SOURCE FORMAT IS FREE
identification division.
program-id. changeformat.
*>
*> Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
*>
*> This program is free software; you can redistribute it and/or
*> modify it under the terms of the GNU General Public License
*> as published by the Free Software Foundation; either
*> version 2, or (at your option) any later version.
*> 
*> This program is distributed in the hope that it will be
*> useful, but WITHOUT ANY WARRANTY; without even the implied
*> warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
*> PURPOSE.  See the GNU General Public License for more
*> details.
*> 
*> You should have received a copy of the GNU General Public
*> License along with this software; see the file COPYING.
*> If not, write to the Free Software Foundation, Inc.,
*> 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

*>=======================================================
*> change a cobol program format tofixed/tofree
*> tofixed includes change to upper case
*> tofree includes change to lower case
*>
*> cobc -x changeformat.cbl
*> chmod +x changeformat
*> ./changeformat <inprogram> <outprogram> tofixed/tofree
*>=======================================================

environment division.
configuration section.
repository. function all intrinsic.
special-names. C01 is one-page.
input-output section.
file-control.

    select input-file
        assign to input-file-name
        file status is input-file-status
        organization is line sequential.

     select output-file
        assign to output-file-name
        file status is output-file-status
        organization is line sequential.

data division.
file section.
fd  input-file.
01  input-record pic x(256).

fd  output-file.
01  output-record pic x(256).
01  output-record-fixed pic x(80).

working-storage section.

01  output-file-name pic x(128) value spaces.
01  output-file-status pic xx.

01  indent pic 999.
01  from-start pic 999.
01  to-start pic 999.
01  move-length pic 999.

01  input-file-name pic x(128).
01  input-file-status pic xx.

01  change pic x(16) value spaces.

01  scan-values.
    03 scan-type pic 99.
    03 scan-start pic 999.
    03 scan-length pic 999.

01  scan-control.
    03  recx-max pic 999.
    03  recx-begin pic 999.
    03  recx-end pic 999.
    03  recx-start pic 999.
    03  scan-state pic 99.
    03  wordx pic 99.
    03  wordx-max pic 99.
    03  wordx-lim pic 99 value 64.
    03  word-values occurs 64.
        05  word-type pic 99.
        05  word-start pic 999.
        05  word-length pic 999.

01  work-control.
    03  woutx pic 999.
    03  woutx-max pic 999.
    03  woutx-lim pic 999 value 100.
    03  work-output-area occurs 100.
        05  work-output-len pic 999.
        05  work-output pic x(256).

01  process-state.
    03  format-type pic x(5).
    03  record-type pic x(8).
    03  line-number pic 9(6).

01  pattern-info.
    03  pattern-result pic x.
    03  pattern-code pic x(8).
    03  pattern-value pic x(30).
    03  pattern-word pic x(30).

01  run-line pic x(72).
01  work-record pic x(256).
01  work-word pic x(16).
01  dont-convert pic x.

01  break-point binary-short.
01  test-record pic x(256).
01  b binary-short.
01  break-state pic 9.

procedure division chaining input-file-name output-file-name
    change.
start-changeformat.

    if input-file-name = output-file-name
        move 'ERROR: input and output files are identical' to run-line
        perform abort-run
    end-if

    evaluate true
    when 'TOFIXED' = upper-case(change)
        move 'TOFIXED' to change
        move 'FIXED' to format-type
    when 'TOFREE' = upper-case(change)
        move 'TOFREE' to change
        move 'FREE' to format-type
    when other
        move 'valid change values are:' to run-line
        display run-line end-display
        move '    TOFREE, TOFIXED' to run-line
        display run-line end-display
        move 'ERROR: no valid change function specified' to run-line
        perform abort-run
    end-evaluate

    open output output-file
    perform check-output-file
    evaluate true
    when change = 'TOFREE'
        write output-record
            from '       >>SOURCE FORMAT IS FREE'
        end-write
    when change = 'TOFIXED'
        write output-record-fixed
            from '       >>SOURCE FORMAT IS FIXED'
        end-write
    end-evaluate

    move 0 to line-number

    open input input-file
    perform check-input-file
    read input-file end-read
    perform check-input-file
    perform until input-file-status = '10'
        add 1 to line-number end-add

        call 'classifyrecord' using input-record scan-control
            process-state end-call

        if record-type <> 'FORMAT'
            perform process-record
        end-if

        read input-file end-read
        perform check-input-file
    end-perform

    close input-file
    close output-file
    
    stop run
    .
check-output-file.
    if output-file-status <> '00'
        display output-file-status
            space 'open failure'
            space output-file-name
        end-display
        stop run
    end-if
    .
check-input-file.
    if input-file-status <> '00' and '10'
        display input-file-status
            space 'open failure'
            space input-file-name
        end-display
        stop run
    end-if
    .
process-record.
    move 0 to woutx-max

*>  apply the change
    perform change-case
    evaluate change also format-type
    when 'TOFIXED' also 'FIXED'
        perform increment-woutx-max
        move input-record to work-output(woutx-max)
    when 'TOFREE' also 'FREE'
        perform increment-woutx-max
        move input-record to work-output(woutx-max)
    when 'TOFIXED' also 'FREE'
        perform convert-to-fixed
    when 'TOFREE' also 'FIXED'
        perform convert-to-free
    end-evaluate

*>  write the output record(s)
    perform varying woutx from 1 by 1
    until woutx > woutx-max
        evaluate true
        when change = 'TOFIXED'
            write output-record-fixed
                from work-output(woutx)(1:80) end-write
        when change = 'TOFREE'
            write output-record
                from work-output(woutx) end-write
        end-evaluate
        perform check-output-file
    end-perform
    .
change-case.
    move input-record to work-record
    perform varying wordx from 1 by 1
    until wordx > wordx-max
        move word-values(wordx) to scan-values
        if scan-type = 3 or 6
        or input-record(scan-start:scan-length) = '.'
            move upper-case(input-record(scan-start:scan-length)) to work-word 
            evaluate true
            when work-word = 'PROGRAM-ID'
            when work-word = 'END'
*>              don't convert the second word after this one
                move '1' to dont-convert
                perform change-word
            when dont-convert = '1' and (work-word = '.' or 'PROGRAM')
            when work-word = 'COPY' or 'INCLUDE'
*>              don't convert the next word after this one
                move '2' to dont-convert
                perform change-word
            when dont-convert = '2'
*>             don't convert this word
               move space to dont-convert
            when other
                perform change-word
                move space to dont-convert
            end-evaluate
        end-if
    end-perform
    move work-record to input-record
    .
change-word.
    evaluate true
    when change = 'TOFIXED'
        move upper-case(input-record(scan-start:scan-length))
        to work-record(scan-start:scan-length)
    when change = 'TOFREE'
        move lower-case(input-record(scan-start:scan-length))
        to work-record(scan-start:scan-length)
    end-evaluate
    .
convert-to-fixed.
*>  look for a free comment
    perform varying wordx from 1 by 1
    until wordx > wordx-max
    or word-type(wordx) = 9
        continue
    end-perform
    if wordx <= wordx-max
*>      write the comment on a separate line
        perform increment-woutx-max
        move word-values(wordx) to scan-values
        move '*' to work-output(woutx-max)(7:1)
        move input-record(scan-start + 2:scan-length - 2)
            to work-output(woutx-max)(scan-start + 7:)
*>      remove the comment
        move spaces to input-record(scan-start:scan-length)
    end-if

    if record-type = 'DEBUG'
*>      remove the '>>D'
        move word-values(1) to scan-values
        move spaces to input-record(scan-start:scan-length)
    end-if

    if input-record = spaces
    and record-type <> 'COMMENT'
*>      put the blank line
        perform increment-woutx-max
        if record-type = 'DEBUG'
            move 'd' to work-output(woutx-max)(7:1)
        end-if
    end-if

    move 0 to to-start
    move 0 to indent
    perform until input-record = spaces
*>      if we delete or break words we need to rescan 
        call 'scancobol' using input-record scan-control end-call
        move word-values(1) to scan-values

*>      the first word might end past column 72
        if indent + scan-start + scan-length > 62
*>          shift left as much as we can
            move input-record(scan-start:) to work-record
            move spaces to input-record
            move work-record to input-record(indent + 12:)
            call 'scancobol' using input-record scan-control end-call
        end-if

*>      check to see if we need to break the line
        move wordx-max to wordx
        move word-values(wordx) to scan-values
        perform until wordx < 1
        or scan-start + scan-length < 70
            subtract 1 from wordx end-subtract
            move word-values(wordx) to scan-values
        end-perform

        evaluate true
        when wordx < 1
*>          there's no break point -- long quoted literal
            *> start embedded test
            move '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' to test-record
            move """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" to test-record
            *> end embedded test
            move word-values(1) to scan-values
            perform find-break-point
            move spaces to work-record
            evaluate true
            when scan-type = 1 *> single-quoted literal
                string input-record(1:break-point)
                    "' & '" delimited by size
                    input-record(break-point + 1:)
                    delimited by size into work-record
                end-string
            when scan-type = 2 *> double-quoted literal
                string input-record(1:break-point)
                    '" & "'
                    input-record(break-point + 1:)
                    delimited by size into work-record
                end-string
            end-evaluate
            move work-record to input-record
        when wordx = wordx-max
*>          we don't need to break the line
            move word-values(1) to scan-values
            move scan-start to from-start
            if to-start = 0 
                move scan-start to to-start
            end-if
            compute move-length =
                recx-max - scan-start + 1
            end-compute
            perform move-free-to-fixed
        when other
*>          break the line at the current word
            move word-values(1) to scan-values
            if to-start = 0
                move scan-start to to-start
            end-if
            move scan-start to from-start
            move word-values(wordx) to scan-values
            compute move-length =
                scan-start + scan-length - from-start + 1
            end-compute
            perform move-free-to-fixed
            move 4 to indent
        end-evaluate
    end-perform
    .
find-break-point.
    *> we want the break-point to be <= 66 so we have room for
    *> quote & quote at the break-point
    move 0 to break-state
    perform varying b from 1 by 1
    until b >= 66
        evaluate input-record(scan-start + b:1) also break-state
        when input-record(scan-start:1) also 0
           move 1 to break-state
        when input-record(scan-start:1) also 1
           move 0 to break-state
           move b to break-point
        when other
           move b to break-point
        end-evaluate
    end-perform
    .
move-free-to-fixed.
    perform increment-woutx-max
    if record-type = 'DEBUG'
        move 'd' to work-output(woutx-max)(7:1)
    end-if
    if (to-start + move-length + indent + 6) > 70
        compute to-start =
            72 - move-length - indent - 7
        end-compute
    end-if
    move input-record(from-start:move-length)
        to work-output(woutx-max)(to-start + indent + 7:move-length)
    move spaces to input-record(from-start:move-length)
    .
convert-to-free.
    if wordx-max > 0
        evaluate true
        when word-type(wordx-max) = 10
*>          unclosed single quote
            move "'" to input-record(73:1)
        when word-type(wordx-max) = 11
*>          unclosed double quote
            move '"' to input-record(73:1)
        end-evaluate
    end-if
    evaluate true
    when record-type = 'COMMENT'
        perform increment-woutx-max
        string '*>' input-record(8:) delimited by size
            into work-output(woutx-max) end-string
    when record-type = 'DEBUG'
        perform increment-woutx-max
        string '>>D' input-record(8:) delimited by size
            into work-output(woutx-max) end-string
    when record-type = 'CONTINUE'
        move word-values(1) to scan-values
        *> we need room at the start for & space
        if scan-start < 10
            display line-number
                space input-record(1:80) end-display
            move 'ERROR: unable to process literal continuation'
                to run-line
            perform abort-run
        end-if
        move '&' to input-record(scan-start - 2:1)
        perform increment-woutx-max
        move input-record(8:) to work-output(woutx-max)
    when other
        perform increment-woutx-max
        move input-record(8:) to work-output(woutx-max)
    end-evaluate
    .
increment-woutx-max.
    if woutx-max >= woutx-lim
        string 'ERROR: generated record count exceeds ' woutx-lim
            delimited by size into run-line
        end-string
        perform abort-run
    end-if
    add 1 to woutx-max end-add
    move spaces to work-output(woutx-max)
    .
abort-run.
    display run-line end-display
    stop run
    .
end program changeformat
.
identification division.
program-id. classifyrecord.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.

01  pattern-info.
    03  pattern-result pic x.
    03  pattern-code pic x(8).
    03  pattern-value pic x(30).
    03  pattern-word pic x(30).

*>  pattern tables
01  format-table.
    03  pic x(28) value '3116        >>SOURCE'.
    03  pic x(28) value '1F16        >>'.
    03  pic x(28) value '1F16        SOURCE'. 
    03  pic x(28) value '1116        FORMAT'. 
    03  pic x(28) value '1116        IS'. 
    03  pic x(28) value 'S116FORMAT  FREE'. 
    03  pic x(28) value 'SF16FORMAT  FIXED'. 

01  free-table.
    03  pic x(28) value 'S102COMMENT *>'.
    03  pic x(28) value 'S103DEBUG   >>D'.
    03  pic x(28) value 'SS01TEXT     '.

01  run-line pic x(72).

01  scan-values.
    03 scan-type pic 99.
    03 scan-start pic 999.
    03 scan-length pic 999.

linkage section.
01  input-record pic x(256).

01  scan-control.
    03  recx-max pic 999.
    03  recx-begin pic 999.
    03  recx-end pic 999.
    03  recx-start pic 999.
    03  scan-state pic 99.
    03  wordx pic 99.
    03  wordx-max pic 99.
    03  wordx-lim pic 99 value 64.
    03  word-values occurs 64.
        05  word-type pic 99.
        05  word-start pic 999.
        05  word-length pic 999.

01  process-state.
    03  format-type pic x(5).
    03  record-type pic x(8).
    03  line-number pic 9(6).

procedure division using input-record scan-control
    process-state.
start-classifyrecord.
*>  scan as a fixed format-type
    move 7 to recx-begin
    move 72 to recx-end
    call 'scancobol' using input-record scan-control end-call

*>  check for >>SOURCE [FORMAT] [IS] (FREE/FIXED)
    call 'parsepattern' using format-table pattern-info
        input-record scan-control end-call
    if pattern-result = 'S'
*>      this is a >>SOURCE FORMAT line
        move trim(pattern-value) to format-type
        move 'FORMAT' to record-type
        goback
    end-if
    evaluate true
    when format-type = 'FIXED'
        evaluate input-record(7:1)
        when '*'
        when '/'
            move 'COMMENT' to record-type
        when 'D'
        when 'd'
            move 'DEBUG' to record-type
        when '-'
            move 'CONTINUE' to record-type
        when space
            move 'TEXT' to record-type
        when other
            string 'ERROR: invalid fixed record type in column 7'
                space input-record(7:1)
                space input-record
                delimited by size into run-line
            end-string
            perform abort-run
        end-evaluate
    when format-type = 'FREE'
*>      rescan the record as FREE
        move 1 to recx-begin
        move length of input-record to recx-end
        call 'scancobol' using input-record scan-control end-call
        call 'parsepattern' using free-table pattern-info
            input-record scan-control end-call
        move pattern-code to record-type
    when other
        move 'ERROR: source format is neither FIXED nor FREE'
            to run-line
        perform abort-run
    end-evaluate

    goback
    .
abort-run.
    display run-line end-display
    stop run
    .
end program classifyrecord
.
identification division.
program-id. parsepattern.

*>=====================================================
*> We're not  parsing COBOL here, we're just looking at
*> input records and categorizing them with a simple
*> pattern recognizer
*>=====================================================

environment division.
configuration section.
repository. function all intrinsic.
special-names. C01 is one-page.
data division.
working-storage section.

01  match-idx pic 99.
01  w pic 999.
01  l pic 999.

01  test-word pic x(16).
01  test-length pic 99.

linkage section.
01  pattern-table.
    03  command occurs 64.
        05  match-success.
            07  match-success-n pic 9.
        05  match-failure.
            07  match-failure-n pic 9.
        05  match-length pic 99.
        05  match-code pic x(8).
        05  match-value pic x(16).

01  pattern-info.
    03  pattern-result.
        05  pattern-result-n pic 9.
    03  pattern-code pic x(8).
    03  pattern-value pic x(30).
    03  pattern-word pic x(30).

01  record-text pic x(256).

01  scan-control.
    03  recx-max pic 999.
    03  recx-begin pic 999.
    03  recx-end pic 999.
    03  recx-start pic 999.
    03  scan-state pic 99.
    03  wordx pic 99.
    03  wordx-max pic 99.
    03  wordx-lim pic 99 value 64.
    03  word-values occurs 64.
        05  word-type pic 99.
        05  word-start pic 999.
        05  word-length pic 999.

procedure division using pattern-table pattern-info
    record-text scan-control.
start-parsepattern.
    move spaces to pattern-info
    if wordx-max = 0
*>      blank line
        move 'F' to pattern-result
        goback
    end-if
    move 1 to match-idx wordx
    move 0 to pattern-result-n
    perform until pattern-result = 'S' or 'F'
    or wordx > wordx-max
        add pattern-result-n to match-idx end-add
        move word-start(wordx) to w
        move word-length(wordx) to l
        unstring record-text(w:l) into pattern-word end-unstring
        move upper-case(pattern-word) to pattern-value
        move match-length(match-idx) to test-length
        if pattern-value(1:test-length) = match-value(match-idx)
            move match-success(match-idx) to pattern-result
            add 1 to wordx end-add
        else
            move match-failure(match-idx) to pattern-result
        end-if
        move match-code(match-idx) to pattern-code
    end-perform
    if pattern-result <> 'S' and 'F'
*>      success with missing optionals/alternatives
        move 'S' to pattern-result
    end-if
    goback
    .
end program parsepattern.

identification division.
program-id.  scancobol.
data division.
linkage section.
01  input-record pic x(256).
01  scan-control.
    03  recx-max pic 999.
    03  recx-begin pic 999.
    03  recx-end pic 999.
    03  recx-start pic 999.
    03  scan-state pic 99.
        88  nothing-found value 0.
        88  start-single-quote value 1.
        88  start-double-quote value 2.
        88  start-leading-alpha value 3.
        88  single-quote-in-single-quote value 4.
        88  double-quote-in-double-quote value 5.
        88  start-leading-nonalpha value 6.
        88  isolated-period value 7.
        88  start-free-comment value 8.
        88  free-comment value 9.
        88  unclosed-single-quote value 10.
        88  unclosed-double-quote value 11.
    03  wordx pic 99.
    03  wordx-max pic 99.
    03  wordx-lim pic 99 value 64.
    03  word-values occurs 64.
        05  word-type pic 99.
        05  word-start pic 999.
        05  word-length pic 999.

procedure division using input-record scan-control.
start-scancobol.
    move 0 to wordx-max
    move 0 to scan-state
    perform varying recx-max from recx-begin by 1
    until recx-max > recx-end
    or input-record(recx-max:) = spaces
        evaluate scan-state also input-record(recx-max:1)
        when 0 also space *> nothing found
        when 0 also ',' *> not interesting
        when 0 also ';' *> not interesting
            continue
        when 0 also '.' *> isolated (leading) period
            move 7 to scan-state
            move recx-max to recx-start
            perform stop-word
        when 0 also '&' *> isolated (leading) ampersand
            move 7 to scan-state
            move recx-max to recx-start
            perform stop-word
        when 0 also '*' *> maybe a comment
            move 8 to scan-state
            move recx-max to recx-start
        when 0 also "'" *> start a single quote literal
            move 1 to scan-state
            move recx-max to recx-start
        when 0 also '"' *> start a double quote literal
            move 2 to scan-state
            move recx-max to recx-start
        when 0 also alphabetic *> start leading alphabetic
            move 3 to scan-state
            move recx-max to recx-start
        when 0 also any *> start leading non-alphabetic
            move 6 to scan-state
            move recx-max to recx-start

        when 1 also "'" *> single quote in single quote
            move 4 to scan-state
        when 1 also any *> continuing the single quote
            continue
        when 2 also '"' *> double quote in double quote
            move 5 to scan-state
        when 2 also any *> continuing the double quote
            continue

        when 4 also "'" *> consecutive single quote
            move 1 to scan-state
        when 4 also any *> end of single quote
            move 1 to scan-state
            perform stop-word

        when 5 also '"' *> consecutive double quote
            move 2 to scan-state
        when 5 also any *> end of double quote
            move 2 to scan-state
            perform stop-word

        when 8 also '>' *> definitely a comment
            move 9 to scan-state
        when 8 also space *> not a comment
            move 6 to scan-state
            perform stop-word 
        when 8 also any *> shouldn't happen
            move 6 to scan-state

        when 9 also any *> comment to end of line
            continue

        when any also space
            perform stop-word
        when any also ','
            perform stop-word
        when any also ';'
            perform stop-word
        when any also '.' *> ending period
            perform stop-word
            move 7 to scan-state
            move recx-max to recx-start
        end-evaluate
    end-perform       
    evaluate true
    when scan-state = 0
        continue
    when scan-state = 4 *> close quote at end of line
        move 1 to scan-state
        perform stop-word
    when scan-state = 5 *> close quote at end of line
        move 2 to scan-state
        perform stop-word
    when scan-state = 1 *> unclosed single quote
        move 10 to scan-state
        perform stop-word
    when scan-state = 2 *> unclosed double quote
        move 11 to scan-state
        perform stop-word
    when other
        perform stop-word
    end-evaluate
    subtract 1 from recx-max end-subtract

    if 'n' = 'y'
        call 'dumpscancontrol' using input-record
            scan-control end-call
    end-if
    goback
    .
stop-word.
    if wordx-max >= wordx-lim
        display 'wordx-max exceeds ' wordx-lim end-display
        stop run
    end-if
    add 1 to wordx-max end-add
    move recx-start to word-start(wordx-max)
    if recx-max = recx-start
        move 1 to word-length(wordx-max)
    else
        compute word-length(wordx-max) =
            recx-max - recx-start end-compute
    end-if
    move scan-state to word-type(wordx-max)
    move 0 to scan-state
    .
end program scancobol.

identification division.
program-id. dumpscancontrol.
data division.
linkage section.
01  input-record pic x(256).
01  scan-control.
    03  recx-max pic 999.
    03  recx-begin pic 999.
    03  recx-end pic 999.
    03  recx-start pic 999.
    03  scan-state pic 99.
    03  wordx pic 99.
    03  wordx-max pic 99.
    03  wordx-lim pic 99 value 64.
    03  word-values occurs 64.
        05  word-type pic 99.
        05  word-start pic 999.
        05  word-length pic 999.

procedure division using input-record scan-control.
start-dumpscancontrol.
    display input-record(1:recx-max) end-display
    display recx-max '=recx-max'
        space recx-begin '=recx-begin'
        space recx-end '=recx-end'
        space wordx-max '=wordx-max'
    end-display
    perform varying wordx from 1 by 1
    until wordx > wordx-max
        display word-type(wordx)
            space word-start(wordx)
            space word-length(wordx)
            space
            with no advancing
        end-display
    end-perform
    display space end-display
    goback
    .
end program dumpscancontrol.

