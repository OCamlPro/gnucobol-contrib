This is a small wrapper program for the Windows Beep and MessageBeep functions.
This example works only under Windows, and it was tested with cygwin64.

Files:
======
makefile         - for make (the object must be linked with User32 Windows lib)
readme.txt       - this file
tstwbeep.cob     - test program, direct call of Windows functions, without C module 
tstwinbeep.cob   - test program
win_beep.c       - C function calls
winbeep.cob      - COBOL wrapper for the C functions


Description of the functions:
=============================

Beep(freq, duration):
---------------------
The Beep function generates simple tones on the speaker. The function is 
synchronous; it performs an alertable wait and does not return control to its 
caller until the sound finishes.

Parameters:
- freq:     The frequency of the sound, in hertz. This parameter must be in the 
            range 37 through 32,767 (0x25 through 0x7FFF).
- duration: The duration of the sound, in milliseconds.

Return value:
- If the function succeeds, the return value is nonzero.
- If the function fails, the return value is zero. 


MessageBeep(sound_type):
------------------------
The MessageBeep plays a waveform sound. The waveform sound for each sound type 
is identified by an entry in the registry. After queuing the sound, the 
MessageBeep function returns control to the calling function and plays the sound
asynchronously.

The parameter can be one of the following values (sound_type):
Value (sound_type)              Meaning

                   0xFFFFFFFF   A simple beep. If the sound card is not available, 
                                the sound is generated using the speaker.

MB_ICONASTERISK    0x00000040L  See MB_ICONINFORMATION.

MB_ICONEXCLAMATION 0x00000030L  See MB_ICONWARNING.

MB_ICONERROR       0x00000010L  The sound specified as the Windows Critical Stop sound.

MB_ICONHAND        0x00000010L  See MB_ICONERROR.

MB_ICONINFORMATION 0x00000040L  The sound specified as the Windows Asterisk sound.

MB_ICONQUESTION    0x00000020L  The sound specified as the Windows Question sound.

MB_ICONSTOP        0x00000010L  See MB_ICONERROR.

MB_ICONWARNING     0x00000030L  The sound specified as the Windows Exclamation sound.

MB_OK              0x00000000L  The sound specified as the Windows Default Beep sound.

Return value:
- If the function succeeds, the return value is nonzero.
- If the function fails, the return value is zero.


Remark according to MS:
=======================
A long time ago, all PC computers shared a common 8254 programmable interval 
timer chip for the generation of primitive sounds. Since then, sound cards have 
become standard equipment on almost all PC computers. As sound cards became more
common, manufacturers began to remove the old timer chip from computers. The
support for Beep was dropped in Windows Vista and Windows XP 64-Bit Edition.
But in Windows 7 (and later), Beep was rewritten to pass the beep to the default
sound device.

