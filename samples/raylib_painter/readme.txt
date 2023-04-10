***********************************************************
***********       GNUCobol Raylib Paint      **************
***********************************************************
***********     Author: Giancarlo Canini     **************
***********     Date written: 14/10/2022     **************
***********************************************************

                   The RayLib Project...

https://www.raylib.com/

                      ...for Linux

https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux

Install RayLib by possibly running a 'cmake' in
"/src". Recompiling downloaded RayLibs with 'cmake'
(follow instruction in links above) reconfigure libraries
"RayLib" graphics for your operating system before
install them with 'make' and 'make install'.

A possible sequence of instructions for a correct
installing RayLib on Debian Linux:
    git clone https://github.com/raysan5/raylib.git raylib
    raylib cd
    mkdir build && cd build
    cmake -DSHARED=ON -DSTATIC=ON ..
    make make RAYLIB_LIBTYPE=SHARED
    sudo make install RAYLIB_LIBTYPE=SHARED

***********************************************************
************   Tectonics (on Debian Linux)   **************
***********************************************************
************  cobc -c particelle.c -lraylib  **************
*** cobc -x -free CobolDraw.cob particelle.o -lraylib  ****
***********************************************************
************         ./CobolDraw             **************
***********************************************************
