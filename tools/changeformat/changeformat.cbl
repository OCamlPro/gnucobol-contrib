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
*>
*> tofixed includes change to upper case
*> tofree includes change to lower case
*>
*> cobc -x changeformat.cbl
*> chmod +x changeformat
*> ./changeformat <inprogram> <outprogram> tofixed/tofree \
*>     ws-after pd-after nocc1
*>
*>  tofixed option ws-after places comments after
*>  the working-storage section line
*>
*>  tofree option pd-after places comments after
*>  the procedure division line
*>
*>  tofree option nocc1 moves uncommented lines starting in
*>  cc2
*>=======================================================

*>=======================================================
*> advice:
*> if you want to debug, put the following
*> at strategic locations in the code:
*>     if line-number = nnnnnn
*>         call 'dumpscancontrol'
*>             using input-record scan-control
*>         end-call
*>     end-if
*>=======================================================

*>=======================================================
*> 2014-10-20 1) tested with Vincent Voen's ACAS st010
*>            2) added area-a-indent
*>            3) add tab to scanner
*>            4) rewrite free comment processing
*> 2014-10-26 1) area-a-indent lost after comment
*>            2) find-comment-break-point not recognizing
*>               short remaining text
*>            4) default format-type FREE not set
*>            5) unclosed continuation losing closing
*>               quote
*>            6) rewrite free literal processing
*>            7) tested with gary cutler's OCic.cbl
*>            8) added ( ) and , to scanner
*>
*> n.b. except for testing changeformat.cbl itself,
*> testing a program means getting a clean compile of
*> the converted code  -- no actual execution of
*> converted code
*>
*> 2014-10-29 v1.0.2
*>            1) added ws-after pd-after and nocc1
*>               command line optionss
*>=======================================================

environment division.
configuration section.
repository. function all intrinsic.
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
01  Program-Version pic x(15) "chgfmt v1.00.02".
01  output-file-name pic x(128) value spaces.
01  output-file-status pic xx.

01  area-a-indent pic 9.
01  fixed-start pic 999.
01  fixed-length pic 999.
01  fixed-end pic 999.
01  s pic 999.
01  t pic 999.

01  input-file-name pic x(128).
01  input-file-status pic xx.

01  change pic x(16) value spaces.
01  option1 pic x(8) value spaces.
01  option2 pic x(8) value spaces.
01  option3 pic x(8) value spaces.
01  option4 pic x(8) value spaces.
01  option5 pic x(8) value spaces.

01  ws-after pic x value 'n'.
01  pd-after pic x value 'n'.
01  cc1 pic x value 'y'.

01  scan-values.
    03 scan-type pic 99.
    03 scan-start pic 999.
    03 scan-length pic 999.
    03 scan-end pic 999.

01  scan-control.
    03  cobol-current pic xx.
    03  line-number pic 9(6).
    03  record-type pic x(8).
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
        05  word-end pic 999.

01  work-control.
    03  woutx pic 999.
    03  woutx-max pic 999.
    03  woutx-lim pic 999 value 20.
    03  work-output-area occurs 20.
        05  work-output-len pic 999.
        05  work-output pic x(256).

01  comment-control.
    03  coutx pic 999.
    03  coutx-max pic 999.
    03  coutx-lim pic 999 value 20.
    03  comment-output-area occurs 20.
        05  comment-output-len pic 999.
        05  comment-output pic x(256).

01  process-state.
    03  format-type pic x(5).

01  run-line pic x(72).
01  work-record pic x(256).
01  work-word pic x(16).
01  dont-convert pic x value space.

01  break-point pic 999.
01  quote-state pic 9.
01  last-space pic 999.
01  test-record pic x(256).

01  pattern-info.
    03  pattern-result pic x.
    03  pattern-code pic x(8).
    03  pattern-value pic x(30).
    03  pattern-word pic x(30).

*>  pattern tables
01  cobol-table.
    03  pic x(28) value '1216        IDENTIFICATION'.
    03  pic x(28) value 'SF16ID      DIVISION'.
    03  pic x(28) value 'S116PID     PROGRAM-ID'.
    03  pic x(28) value '1216        ENVIRONMENT'.
    03  pic x(28) value 'SF16ED      DIVISION'.
    03  pic x(28) value '1216        DATA'.
    03  pic x(28) value 'SF16DD      DIVISION'.
    03  pic x(28) value '1216        WORKING-STORAGE'.
    03  pic x(28) value 'SF16WS      SECTION'.
    03  pic x(28) value '1216        LOCAL-STORAGE'.
    03  pic x(28) value 'SF16XS      SECTION'.
    03  pic x(28) value '1216        SCREEN'.
    03  pic x(28) value 'SF16WS      SECTION'.
    03  pic x(28) value '1216        LINKAGE'.
    03  pic x(28) value 'SF16LS      SECTION'.
    03  pic x(28) value '1216        REPORT'.
    03  pic x(28) value 'SF16RS      SECTION'.
    03  pic x(28) value '1216        PROCEDURE'.
    03  pic x(28) value 'SF16PD      DIVISION'.
    03  pic x(28) value '1F16        END'.
    03  pic x(28) value 'SF16END     PROGRAM'.

procedure division chaining input-file-name output-file-name
    change option1 option2 option3 option4 option5.
start-changeformat.

    if input-file-name = output-file-name
        move 'ERROR: input and output files are identical' to run-line
        perform abort-run
    end-if

    evaluate true
    when 'TOFIXED' = upper-case(change)
        move 'TOFIXED' to change
    when 'TOFREE' = upper-case(change)
        move 'TOFREE' to change
    when other
        move 'valid change values are:' to run-line
        display run-line end-display
        move '    TOFREE, TOFIXED' to run-line
        display run-line end-display
        move 'ERROR: no valid change function specified' to run-line
        perform abort-run
    end-evaluate
*>  default format-type
    move 'FIXED' to format-type

    if 'WS-AFTER' = upper-case(option1) or upper-case(option2) or upper-case(option3)
    or upper-case(option4) or upper-case(option5)
        move 'y' to ws-after
    end-if
    if 'PD-AFTER' = upper-case(option1) or upper-case(option2) or upper-case(option3)
    or upper-case(option4) or upper-case(option5)
        move 'y' to pd-after
    end-if
    if 'NOCC1' = upper-case(option1) or upper-case(option2) or upper-case(option3)
    or upper-case(option4) or upper-case(option5)
        move 'n' to cc1
    end-if

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
    move 0 to area-a-indent

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
*>  find out where we are in the program
    call 'parsepattern' using cobol-table pattern-info
        input-record scan-control end-call
    if pattern-code <> space
        move pattern-code to cobol-current
    end-if

    move 0 to woutx-max
    move 0 to coutx-max

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
    evaluate true
    when cobol-current = 'WS' and ws-after = 'y'
    when cobol-current = 'PD' and pd-after = 'y'
        perform output-work
        perform output-comment
    when cobol-current = 'WS' and ws-after = 'n'
    when cobol-current = 'PD' and pd-after = 'n'
        perform output-comment
        perform output-work
    when other
        perform output-comment
        perform output-work
    end-evaluate
    .
output-work.
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
output-comment.
    perform varying coutx from 1 by 1
    until coutx > coutx-max
        evaluate true
        when change = 'TOFIXED'
            write output-record-fixed
                from comment-output(coutx)(1:80) end-write
        when change = 'TOFREE'
            write output-record
                from comment-output(coutx) end-write
        end-evaluate
        perform check-output-file
    end-perform
    .
change-case.
    move input-record to work-record
    perform varying wordx from 1 by 1
    until wordx > wordx-max
        move word-values(wordx) to scan-values
        move upper-case(input-record(scan-start:scan-length)) to work-word
        evaluate true
        when dont-convert = '2'
*>          don't convert this word
            move space to dont-convert
        when work-word = 'PROGRAM-ID'
*>          don't convert the second word after this one
            move '1' to dont-convert
            perform change-word
        when work-word = 'END'
*>          don't convert the second word after this one
            move '1' to dont-convert
            perform change-word
        when work-word = 'PROGRAM'
            if dont-convert = 1
*>              don't convert the next word
                move '2' to dont-convert
            end-if
            perform change-word
        when work-word = 'COPY'
*>          don't convert the next word
            move '2' to dont-convert
            perform change-word
        when work-word = 'INCLUDE'
*>          don't convert the next word
            move '2' to dont-convert
            perform change-word
        when scan-type = 3 *> leading alpha
            perform change-word
            move space to dont-convert
        when scan-type = 6 *> leading non-alpha
            perform change-word
            move space to dont-convert
        when dont-convert = '1'
            move '2' to dont-convert
        end-evaluate
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
    call 'scancobol' using input-record scan-control end-call

*> start embedded test if running changeformat on itself
*>    move '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' to test-record
*>    move """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" to test-record
*> end embedded test

*>  convert and remove any comment from input-record
    if word-type(wordx-max) = 9 *> free comment
        move word-values(wordx-max) to scan-values
        evaluate true
        when input-record(scan-start + 2:) = spaces
*>          empty comment
            perform increment-coutx-max
            move '*' to comment-output(coutx-max)(7:1)
        when scan-end <= 67
*>          comment fits
            perform increment-coutx-max
            move '*' to comment-output(coutx-max)(7:1)
            move input-record(scan-start + 2:scan-length - 2)
                to comment-output(coutx-max)(7 + scan-start:scan-length - 2)
        when other
*>          comment text is beyond the fixed limit
            perform convert-comment
        end-evaluate
*>      remove the comment
        move spaces to input-record(scan-start:)
        compute wordx-max = wordx-max - 1 end-compute
    end-if

*>  remove a debug marker from the line
    if record-type = 'DEBUG'
        move word-values(1) to scan-values
        move spaces to input-record(scan-start:scan-length)
        if input-record = spaces
            perform increment-woutx-max
            move 'd' to work-output(woutx-max)(7:1)
        end-if
    end-if

*>  output a blank record
    if record-type = 'BLANK'
        perform increment-woutx-max
    end-if

*> at this point we have removed comments, removed debug markers
*> and put an empty input-record

*>==============================================
*>  area-a-indent is the indent found before an
*>  area A word.  It may be 0. It is subtracted
*>  from fixed-start for all free words in all free
*>  records subordinate to the area A word
*>
*>  we assume the free text uses input-record(1:4)
*>  as area A.  if not, then not
*>===================================================
*> check area A for an indent
    if wordx-max > 0
    and word-start(1) <= 4
        compute area-a-indent = word-start(1) - 1 end-compute
    end-if

*> we now move free words until input-record is empty
    perform until input-record = spaces
        call 'scancobol' using input-record scan-control end-call

*>      check to see of we need to break the line
        perform varying wordx from 1 by 1
        until wordx > wordx-max
           compute fixed-end = 7 - area-a-indent + word-end(wordx) end-compute
           if fixed-end > 71
                exit perform
           end-if
        end-perform

        evaluate true
        when wordx > wordx-max
*>          the entire line fits
            perform increment-woutx-max
            if record-type = 'DEBUG'
                move 'd' to work-output(woutx-max)(7:1)
            end-if
            move word-start(1) to scan-start
            compute fixed-start = 7 - area-a-indent + scan-start end-compute
            compute fixed-length = recx-max - scan-start + 1 end-compute
            move input-record(scan-start:fixed-length)
                to work-output(woutx-max)(fixed-start:fixed-length)
            move spaces to input-record(scan-start:fixed-length)
       when wordx = 1
*>          the first word ends beyond column 71. assumed to be a literal

*>          break the word into two parts with the length of the first part
*>          less than or equal to 60 and insert close-quote & open-quote
*>          between the parts

            move word-values(1) to scan-values
            move 0 to quote-state
            move 0 to last-space
            perform varying s from 1 by 1
            until s > 60 - scan-start + 1
*>              check for an embedded quote
                evaluate input-record(scan-start + s:1) also quote-state
                when input-record(scan-start:1) also 0
*>                  a first embedded quote
                    move 1 to quote-state
                when input-record(scan-start:1) also 1
*>                  a second embedded quote
                    move 0 to quote-state
                    move s to break-point
                when space also any
                    move s to last-space
                    move s to break-point
                when other
                    move s to break-point
                end-evaluate
            end-perform
*>          break at a space, if possible
            if last-space > break-point - 10
                move last-space to break-point
            end-if

            move spaces to work-record
            evaluate true
            when scan-type = 1 *> single-quoted literal
                string input-record(1:scan-start + break-point)
                    "' & '" delimited by size
                    input-record(scan-start + break-point + 1:)
                    delimited by size into work-record
                end-string
            when scan-type = 2 *> double-quoted literal
                string input-record(1:scan-start + break-point)
                    '" & "'
                    input-record(scan-start + break-point + 1:)
                    delimited by size into work-record
                end-string
            end-evaluate
            move work-record to input-record
        when other

*>          break the line before wordx
            if wordx > 1
            and word-length(wordx) = 1
*>              subtract 2 from wordx
            else
                subtract 1 from wordx
            end-if
            move word-start(1) to scan-start
            compute fixed-start = 7 - area-a-indent + scan-start end-compute
            compute fixed-length = word-end(wordx) - scan-start + 1
            perform increment-woutx-max
            if record-type = 'DEBUG'
                move 'd' to work-output(woutx-max)(7:1)
            end-if
            move input-record(scan-start:fixed-length)
                to work-output(woutx-max)(fixed-start:fixed-length)
            move spaces to input-record(scan-start:fixed-length)

*>          rejustify the remainder
            compute scan-start = word-end(wordx) + 1
            compute scan-length = recx-max - word-end(wordx)
            move input-record(scan-start:) to work-record
            if scan-length > 60
*>              punt
                move work-record to input-record(1:)
            else
                move work-record to input-record(61 - scan-length:)
            end-if
        end-evaluate
    end-perform
    .
convert-comment.
*>  comment text ends beyond the fixed limit

*>  find the start of the comment text
    compute s = scan-start + 2 end-compute
    perform varying s
    from s by 1
    until s > recx-max
    or input-record(s:1) <> space
        continue
    end-perform

*>  find the length of the comment text
    compute t = recx-max - s + 1

    evaluate true
    when t <= 65
    and wordx-max > 1
*>      the comment text will fit right justified in the fixed area
        compute fixed-start = 65 - t + 1 end-compute
        compute fixed-length = t
        perform increment-coutx-max
        move '*' to comment-output(coutx-max)(7:1)
        move input-record(s:t) to comment-output(coutx-max)(fixed-start:t)
    when wordx-max > 1
*>      the comment is not the entire line
        perform find-comment-break-point
        if break-point = 0
            compute t = 65 - s + 1 end-compute
        else
            move break-point to t
        end-if
        compute fixed-start = 7 + s end-compute
        perform increment-coutx-max
        move '*' to comment-output(coutx-max)(7:1)
        move input-record(s:t) to comment-output(coutx-max)(fixed-start:t)
        compute s = s + t end-compute
*>      continuations start in column 8
        perform until s > recx-max
            perform find-comment-break-point
            if break-point = 0
                move 65 to t
            else
                move break-point to t
            end-if
            perform increment-coutx-max
            move '*' to comment-output(coutx-max)(7:1)
            move input-record(s:t) to comment-output(coutx-max)(8:t)
            compute s = s + t end-compute
        end-perform
    when other
*>      the entire line is a comment
        compute s = scan-start + 2 end-compute
        perform find-comment-break-point
        if break-point = 0
            move 65 to t
        else
            move break-point to t
        end-if
        compute fixed-start = 5 + s end-compute
        perform increment-coutx-max
        move '*' to comment-output(coutx-max)(7:1)
        move input-record(s:t) to comment-output(coutx-max)(fixed-start:t)
        compute s = s + t end-compute
*>      continuations are right justified
        perform until s > recx-max
            perform find-comment-break-point
            if break-point = 0
                move 65 to t
            else
                move break-point to t
            end-if
            compute fixed-start = 72 - t + 1
            perform increment-coutx-max
            move '*' to comment-output(coutx-max)(7:1)
            move input-record(s:t) to comment-output(coutx-max)(fixed-start:t)
            compute s = s + t end-compute
        end-perform
    end-evaluate
    .
find-comment-break-point.
    if recx-max - s + 1 <= 65
        compute break-point = recx-max - s + 1 end-compute
    else
        move 0 to break-point
        perform varying t from 1 by 1
        until s + t > recx-max
        or t > 65
*>          take the last space in the comment
            if input-record(s + t:1) = space
                move t to break-point
            end-if
        end-perform
        if break-point = 0
        and s + t > recx-max
            compute break-point = recx-max - s + 1 end-compute
        end-if
    end-if
    .
convert-to-free.
    if wordx-max > 0
*>      check for unclosed quotes at end of line
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
    when record-type = 'BLANK'
        perform increment-woutx-max
    when record-type = 'COMMENT'
        perform increment-woutx-max
        if input-record(7:2) = '*>'
            string input-record(7:) delimited by size
                into work-output(woutx-max) end-string
        else
            string '*>' input-record(8:) delimited by size
                into work-output(woutx-max) end-string
        end-if
    when record-type = 'DEBUG'
        perform increment-woutx-max
        string '>>D' input-record(8:) delimited by size
            into work-output(woutx-max) end-string
    when record-type = 'CONTINUE'
        move word-values(1) to scan-values
        perform increment-woutx-max
        string '& ' input-record(8:)
            delimited by size into worK-output(woutx-max)
        end-string
    when cc1 = 'n'
        perform increment-woutx-max
        move input-record(8:) to work-output(woutx-max)(2:)
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
increment-coutx-max.
    if coutx-max >= coutx-lim
        string 'ERROR: generated comment count exceeds ' coutx-lim
            delimited by size into run-line
        end-string
        perform abort-run
    end-if
    add 1 to coutx-max end-add
    move spaces to comment-output(coutx-max)
    .
abort-run.
    display Program-Version end-display
    display run-line end-display
    call 'dumpscancontrol' using input-record scan-control end-call
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
    03 scan-end pic 999.

linkage section.
01  input-record pic x(256).

01  scan-control.
    03  cobol-current pic xx.
    03  line-number pic 9(6).
    03  record-type pic x(8).
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
        05  word-end pic 999.

01  process-state.
    03  format-type pic x(5).

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
    when input-record = spaces
        move 'BLANK' to record-type
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
*>          perform abort-run
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
    call 'dumpscancontrol' using input-record scan-control end-call
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
    03  cobol-current pic xx.
    03  line-number pic 9(6).
    03  record-type pic x(8).
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
        05  word-end pic 999.

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
    03  cobol-current pic xx.
    03  line-number pic 9(6).
    03  record-type pic x(8).
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
        05  word-end pic 999.

procedure division using input-record scan-control.
start-scancobol.
    move 0 to wordx-max
    move 0 to scan-state
    perform varying recx-max from recx-begin by 1
    until recx-max > recx-end
    or input-record(recx-max:) = spaces
        evaluate scan-state also input-record(recx-max:1)
        when 0 also space *> nothing found
        when 0 also ';' *> not interesting
        when 0 also x'09' *> not interesting
            continue
        when 0 also '('
        when 0 also ')'
        when 0 also ',' *> isolated (leading) comma
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
        when 4 also '('
        when 4 also ')'
        when 4 also ',' *> end of single quote by comma
        when 4 also '.' *> end of single quote by period
            move 1 to scan-state
            perform stop-word
            move 7 to scan-state
            move recx-max to recx-start
            perform stop-word
        when 4 also any *> continue of single quote
            move 1 to scan-state
            perform stop-word

        when 5 also '"' *> consecutive double quote
            move 2 to scan-state
        when 5 also '('
        when 5 also ')'
        when 5 also ',' *> end of double quote by comma
        when 5 also '.' *> end of double quote by period
            move 2 to scan-state
            perform stop-word
            move 7 to scan-state
            move recx-max to recx-start
            perform stop-word
        when 5 also any *> end of double quote
            move 2 to scan-state
            perform stop-word

        when 8 also '>' *> definitely a comment
            move 9 to scan-state
        when 8 also space *> definitely not a comment
            move 6 to scan-state
            perform stop-word
        when 8 also any *> definitely not a comment
            move 6 to scan-state

        when 9 also any *> comment to end of line
            continue

        when any also space
            perform stop-word
        when any also ';'
            perform stop-word
        when any also x'09'
            perform stop-word
        when any also '('
        when any also ')'
        when any also ',' *> ending comma
        when any also '.' *> ending period
            perform stop-word
            move 7 to scan-state
            move recx-max to recx-start
            perform stop-word
        end-evaluate
    end-perform
*>  at the end of the line
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

    goback
    .
stop-word.
    if wordx-max >= wordx-lim
        display 'wordx-max exceeds ' wordx-lim end-display
        call 'dumpscancontrol' using input-record scan-control
        stop run
    end-if
    add 1 to wordx-max end-add
    move recx-start to word-start(wordx-max)
    if recx-max = recx-start
        move 1 to word-length(wordx-max)
        move recx-max to word-end(wordx-max)
    else
        compute word-length(wordx-max) =
            recx-max - recx-start end-compute
        compute word-end(wordx-max) =
            recx-max - 1 end-compute
    end-if

    move scan-state to word-type(wordx-max)
    move 0 to scan-state
    .
end program scancobol.

identification division.
program-id. dumpscancontrol.
data division.
working-storage section.
01  w pic 999.
linkage section.
01  input-record pic x(256).
01  scan-control.
    03  cobol-current pic xx.
    03  line-number pic 9(6).
    03  record-type pic x(8).
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
        05  word-end pic 999.

procedure division using input-record scan-control.
start-dumpscancontrol.
    display space end-display
    display input-record(1:recx-max) end-display
    display cobol-current
        space line-number
        space record-type
        space recx-max '=max'
        space recx-begin '=begin'
        space recx-end '=end'
        space wordx-max '=words'
    end-display
    perform varying w from 1 by 1
    until w > wordx-max
        display w
            space word-type(w)

            space word-start(w)
            space word-length(w)
            space word-end(w)
            '/'
            with no advancing
        end-display
    end-perform
    display space end-display
    goback
    .
end program dumpscancontrol.

