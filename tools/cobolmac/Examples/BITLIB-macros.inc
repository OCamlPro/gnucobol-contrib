*>******************************************************************************
*> Macros for manipulating individual bits.
*>------------------------------------------------------------------------------
*> Requires that BITLIB has been installed.
*>******************************************************************************

  *> Areas for the setbit, unsetbit, flipbit and testbit macros.
  *> (bits are numbered 1 to 16, left to right)

    01  bitlib-macros.
      05  target-word                  pic s9(4) comp sync.
      05  bit-number                   pic s9(4) comp sync.
      05  bit-result                   pic s9(4) comp sync.
        88  bit-is-off                 value zero.
        88  bit-is-on                  value 1.
        88  target-word-negative       value -1.
        88  bit-number-invalid         value -2.

*> %setbit(target-word#, bit-number#)
*> -----------------------------------------------------------------------------
*> Sets bit <bit-number> in <target-word>.

$define %setbit=
move !1 to target-word
move !2 to bit-number
call "SETBIT" using target-word, bit-number, bit-result
if bit-result >= zero then
  move target-word to !1
end-if#

*> %unsetbit(target-word#, bit-number#)
*> -----------------------------------------------------------------------------
*> Unsets bit <bit-number> in <target-word>.

$define %unsetbit=
move !1 to target-word
move !2 to bit-number
call "UNSETBIT" using target-word, bit-number, bit-result
if bit-result >= zero then
  move target-word to !1
end-if#

*> %flipbit(target-word#, bit-number#)
*> -----------------------------------------------------------------------------
*> Flips bit <bit-number> in <target-word>.

$define %flipbit=
move !1 to target-word
move !2 to bit-number
call "FLIPBIT" using target-word, bit-number, bit-result
if bit-result >= zero then
  move target-word to !1
end-if#

*> %testbit(target-word#, bit-number#)
*> -----------------------------------------------------------------------------
*> Examines bit <bit-number> in <target-word>, result in bit-result.

$define %testbit=
move !1 to target-word
move !2 to bit-number
call "TESTBIT" using target-word, bit-number, bit-result#

*>******************************************************************************
