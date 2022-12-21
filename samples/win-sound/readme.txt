This is a small wrapper program for the Windows PlaySound function.
This example works only under Windows, and it was tested with cygwin64.

Files:
======
makefile         - for make (the object must be linked with Winmm Windows lib)
readme.txt       - this file
tstwsound.cob    - test program, direct call of Windows functions, without C module 
tstwinsound.cob  - test program
win_sound.c      - C function calls
winsound.cob     - COBOL wrapper for the C functions
Linus-linux.wav  - test file (from Wikimedia Commons, the free media repository, GPL)


Description of the functions:
=============================

PlaySound(TEXT(wav_file), NULL, SND_FILENAME):
----------------------------------------------
The sound is played synchronously, and PlaySound returns after the sound event 
completes. This is the default behavior.

PlaySound(TEXT(wav_file), NULL, SND_FILENAME | SND_ASYNC):
----------------------------------------------------------
The sound is played asynchronously and PlaySound returns immediately after 
beginning the sound. To terminate an asynchronously played waveform sound, 
call PlaySound with pszSound set to NULL.

PlaySound(TEXT(wav_file), NULL, SND_FILENAME | SND_ASYNC | SND_LOOP):
---------------------------------------------------------------------
The sound plays repeatedly until PlaySound is called again with the pszSound 
parameter set to NULL. If the SND_LOOP flag is set, you must also set the 
SND_ASYNC flag.

PlaySound(NULL, 0, 0):
----------------------
Stops playback of a sound that is playing asynchronously.


Return value:
- Returns TRUE ( = 1 ) if successful or FALSE ( = 0 ) otherwise.


Remark according to MS:
=======================
The sound specified by pszSound must fit into available physical memory and be 
playable by an installed waveform-audio device driver.

PlaySound searches the following directories for sound files: the current 
directory; the Windows directory; the Windows system directory; directories 
listed in the PATH environment variable; and the list of directories mapped in a 
network. If the function cannot find the specified sound and the SND_NODEFAULT 
flag is not specified, PlaySound uses the default system event sound instead. 
If the function can find neither the system default entry nor the default sound, 
it makes no sound and returns FALSE.
