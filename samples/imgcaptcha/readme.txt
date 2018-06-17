With this small program you can create captcha PNG image files. These can be used
in a HTML form to prevent spam. See more here: https://en.wikipedia.org/wiki/CAPTCHA.

It uses the GD Graphics Library (https://en.wikipedia.org/wiki/GD_Graphics_Library ,
therefore you need this for compilation. (It is usually installed on Linux.) 
And before you compile you have to change the following line in imgcaptcha.c file:

/* TODO: set your true type font with full path */
#define ttf "/home/laszlo.erdoes/imgcaptcha/FreeSerifItalic.ttf"

Sources:
--------
FreeSerifItalic.ttf - one of the GnuFreeFont (also in freefont-ttf-20120503.zip)
imgcaptcha.c        - module with the captcha function
imgcaptcha-test.cob - test program
Makefile            - makefile
readme.txt          - this file

GnuFreeFont/freefont-ttf-20120503.zip       - GnuFreeFont package (see the Licensing
                                              in the ZIP file)

screenshots/0_numbers.jpg                   - screenshots after run the test program
screenshots/1_uppercase-letters.jpg
screenshots/2_lowercase-letters.jpg
screenshots/3_letters.jpg
screenshots/4_letters-numbers.jpg
screenshots/5_uppercase-letters-numbers.jpg
screenshots/6_lowercase-letters-numbers.jpg

This program was developed and tested using GnuCOBOL 2.2.0, cygwin (64 bit)
and Windows 10 (64 bit) running on a HP laptop.
