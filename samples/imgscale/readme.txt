With this small program you can convert and scale images in formats BMP, GIF, 
JPG, PNG, TIFF. That means, it converts from an image format in an other format. 
And with the parameter "width" you can give a new (proportional) size for the
new image.  

It uses the GD Graphics Library (https://en.wikipedia.org/wiki/GD_Graphics_Library ,
therefore you need this for compilation. (It is usually installed on Linux.) 

Sources:
--------

imgscale.c         - module with the convert and scale function
imgscale-test.cob  - test program 

rainbow.jpg        - input test image, size 3968x2976, (rainbow in Grindelwald)

The test program creates the following output images with size 400x300: 
rainbow_400.bmp
rainbow_400.gif
rainbow_400.jpg
rainbow_400.png
rainbow_400.tiff

This program was developed and tested using GnuCOBOL 2.2.0, cygwin (64 bit)
and Windows 10 (64 bit) running on a HP laptop.
