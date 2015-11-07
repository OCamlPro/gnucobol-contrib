*> **  >>SOURCE FORMAT IS FREE

identification division.

  program-id.                          BITLIB.

*> -----------------------------------------------------------------------------
*>  Bit Manipulation Library for COBOL (c) Copyright Robert W.Mills, 1993-2015.
*> -----------------------------------------------------------------------------
*>
*> Description:
*>
*>   The smallest area that can be manipulated within a COBOL program is a
*>   single byte or character, which is comprised of 8 bits. However, there
*>   are times when it becomes necessary to change/test individual bits, which
*>   is made possible by this set of routines.
*>
*>   The calling sequence for these routines is as follows:
*>
*>     CALL "routine" USING TARGET-WORD
*>                          BIT-NUMBER
*>                          BIT-RESULT
*>     END-CALL
*>
*>     TARGET-WORD is the two-byte (16-bit) area within the COBOL program that
*>     is to be processed. The bits are numbered from right to left.
*>
*>     BIT-NUMBER identifies which bit is to be processed. Only one bit can be
*>     processed with each call.
*>
*>     BIT-RESULT will contain the result: 0 (zero) is OFF and 1 is ON.
*>     The following values may also be returned (message set to stderr):
*>       -1 (minus one) indicates that BIT-NUMBER was invalid.
*>       -2 (minus two) indicates that TARGET-WORD is negative.
*>
*>     The "routine" names are as follows:
*>
*>       SETBIT
*>
*>         Set the bit identified by BIT-NUMBER to ON.
*>         The contents of TARGET-WORD will be changed accordingly.
*>
*>       UNSETBIT
*>
*>         Set the bit identified by BIT-NUMBER to OFF.
*>         The contents of TARGET-WORD will be changed accordingly.
*>
*>       FLIPBIT
*>
*>         Set the bit identified by BIT-NUMBER to ON (if OFF) or OFF (if ON).
*>         The contents of TARGET-WORD will be changed accordingly.
*>
*>       TESTBIT
*>
*>         Test the bit identified by BIT-NUMBER and place result in BIT-RESULT.
*>         The contents of TARGET-WORD will be unchanged.
*>
*> <plug>
*>
*>   The CobolMac utility, also available from the Contributions section of the
*>   GnuCobol Project, has an 'include' file that contains the Working-Storage
*>   definitions and a set Macros that simplyfies the usage of these routines.
*>
*> </plug>
*>
*> -----------------------------------------------------------------------------

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.

  01  TARGET-WORD-expanded.
    05  TARGET-WORD-bit                pic 9(001) occurs 16
                                                  indexed by bit-index.

  01  TARGET-WORD-work                 pic 9(004) comp.

  01  BIT-NUMBER-translated            pic s9(04) comp.

  linkage section.

    01  TARGET-WORD                    pic s9(04) comp.

    01  BIT-NUMBER                     pic s9(04) comp.
      88  BIT-NUMBER-valid             value 1 thru 16.

    01  BIT-RESULT                     pic s9(04) comp.
      88  bit-is-off                   value zero.
      88  bit-is-on                    value 1.
      88  TARGET-WORD-negative         value -1.
      88  BIT-NUMBER-invalid           value -2.

procedure division.

  bitlib-version section.

    *> -------------------------------------------------------------------------
    *>  Display version and copyright information.
    *> -------------------------------------------------------------------------

    display "BITLIB / A.01.01 - Bit Manipulation Library for COBOL" end-display
    display "Copyright (c) Robert W.Mills <robertw.mills@fsmail.net>, 1993-2015." end-display

    goback
    .

  bitlib-setbit section.

  entry "SETBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT.
    *> -------------------------------------------------------------------------
    *>  Turn ON the specified bit.
    *> -------------------------------------------------------------------------

    perform s001-validate-input

    perform s002-expand-target-word

    move 1 to TARGET-WORD-bit(BIT-NUMBER-translated), BIT-RESULT

    perform s003-rebuild-target-word

    goback
    .

  bitlib-unsetbit section.

  entry "UNSETBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT.
    *> -------------------------------------------------------------------------
    *>  Turn OFF the specified bit.
    *> -------------------------------------------------------------------------

    perform s001-validate-input

    perform s002-expand-target-word

    move zero to TARGET-WORD-bit(BIT-NUMBER-translated), BIT-RESULT

    perform s003-rebuild-target-word

    goback
    .

  bitlib-flipbit section.

  entry "FLIPBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT.
    *> -------------------------------------------------------------------------
    *>  Flip the specified bit. ON becomes OFF and OFF becomes ON.
    *> -------------------------------------------------------------------------

    perform s001-validate-input

    perform s002-expand-target-word

    if TARGET-WORD-bit(BIT-NUMBER-translated) = zero then
      move 1 to TARGET-WORD-bit(BIT-NUMBER-translated), BIT-RESULT
    else
      move zero to TARGET-WORD-bit(BIT-NUMBER-translated), BIT-RESULT
    end-if

    perform s003-rebuild-target-word

    goback
    .

  bitlib-testbit section.

  entry "TESTBIT" using TARGET-WORD, BIT-NUMBER, BIT-RESULT.
    *> -------------------------------------------------------------------------
    *>  Report if the specified bit is ON or OFF.
    *> -------------------------------------------------------------------------

    perform s001-validate-input

    perform s002-expand-target-word

    move TARGET-WORD-bit(BIT-NUMBER-translated) to BIT-RESULT

    goback
    .

*> *****************************************************************************
*> Start of Internal Subroutines.

  subroutine section.

  s001-validate-input.
    *> -------------------------------------------------------------------------
    *>  Check that input values are valid and translate BIT-NUMBER.
    *> -------------------------------------------------------------------------

    if TARGET-WORD < 0 then
      display "BITLIB Error: TARGET-WORD is negative." upon stderr end-display
      set TARGET-WORD-negative to true
      goback
    end-if

    if not BIT-NUMBER-valid then
      display "BITLIB Error: BIT-NUMBER is invalid." upon stderr end-display
      set BIT-NUMBER-invalid to true
      goback

    else
      subtract BIT-NUMBER from 17 giving BIT-NUMBER-translated end-subtract
    end-if
    .

  s002-expand-target-word.
    *> -------------------------------------------------------------------------
    *>  Expand the TARGET-WORD into an 'array of bits'.
    *> -------------------------------------------------------------------------

    move TARGET-WORD to TARGET-WORD-work

    perform with test after
      varying bit-index from 16 by -1
      until bit-index = 1

      divide TARGET-WORD-work by 2 giving TARGET-WORD-work
        remainder TARGET-WORD-bit(bit-index)
      end-divide

    end-perform

>>D display "Expanded TARGET-WORD is [", TARGET-WORD-expanded, "]" end-display

    exit
    .

  s003-rebuild-target-word.
    *> -------------------------------------------------------------------------
    *>  Rebuild the TARGET-WORD from the 'array of bits'.
    *> -------------------------------------------------------------------------

    perform with test after
      varying bit-index from 1 by 1
      until bit-index = 16

      multiply 2 by TARGET-WORD-work end-multiply
      add TARGET-WORD-bit(bit-index) to TARGET-WORD-work end-add

    end-perform

    move TARGET-WORD-work to TARGET-WORD

>>D display "TARGET-WORD is now [", TARGET-WORD, "]" end-display

    exit
    .

.end program BITLIB.
