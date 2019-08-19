#!/bin/bash

# Use to build release-version of CBL_OC_SOCKET under GNU/Linux
# and other POSIX-compatible systems (including cygwin) + MinGW

if test "x$MSYSTEM" = "x"; then
	gcc -shared -fPIC -DHAVE_STRING_H -Wall -O2 -o CBL_GC_SOCKET.so  cob_socket.cpp -lstdc++
else
	gcc -shared       -DHAVE_STRING_H -Wall -O2 -o CBL_GC_SOCKET.dll cob_socket.cpp -lstdc++ -lws2_32
fi
