*> ** >>SOURCE FORMAT IS FREE

identification division.

  program-id.                          BITLIB-test.

data division.

  working-storage section.

    01  TARGET-WORD                    pic s9(4) comp sync.

    01  BIT-NUMBER                     pic s9(4) comp sync.
      88  BIT-NUMBER-valid             value 1 thru 16.

    01  BIT-RESULT                     pic s9(4) comp sync.
      88  bit-is-off                   value zero.
      88  bit-is-on                    value 1.
      88  TARGET-WORD-negative         value -1.
      88  BIT-NUMBER-invalid           value -2.

    01  test-option                    pic 9(001) value zero.

procedure division.

  perform until test-option = 9

    display space end-display
    display "Test harness for: Bit Manipulation Library for COBOL" end-display
    display space end-display
    display "1. SETBIT   - Turn a bit ON" end-display
    display "2. UNSETBIT - Turn a bit OFF" end-display
    display "3. FLIPBIT  - Toggle a bit" end-display
    display "4. TESTBIT  - Examine a bit" end-display
    display space end-display
    display "9. Exit." end-display
    display space end-display
    display "Enter an option (1-4,9): " with no advancing end-display
    accept test-option end-accept

    display space end-display

    evaluate test-option
      when 1 perform setbit-test
      when 2 perform unsetbit-test
      when 3 perform flipbit-test
      when 4 perform testbit-test
      when 9 goback
    end-evaluate

  end-perform
  .

setbit-test.

  display "SETBIT - Turn a bit ON" end-display

  perform get-input

  call "SETBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT end-call
  .

unsetbit-test.

  display "UNSETBIT - Turn a bit OFF" end-display

  perform get-input

  call "UNSETBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT end-call
  .

flipbit-test.

  display "FLIPBIT - Toggle a bit" end-display

  perform get-input

  call "FLIPBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT end-call
  .

testbit-test.

  display "TESTBIT - Examine a bit" end-display

  perform get-input

  call "TESTBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT end-call

  evaluate true
    when bit-is-off
      display "The bit is OFF." end-display
    when bit-is-on
      display "The bit is ON." end-display
  end-evaluate
  .
 get-input.

  display space end-display
  display "Enter a number: " with no advancing end-display
  accept TARGET-WORD end-accept

  display "Enter the bit number [1 to 16]: " with no advancing end-display
  accept BIT-NUMBER end-accept
  .

end program BITLIB-test.

copy "/home/robert/Cobol/CobolMac-Dev/BITLIB.cob".
