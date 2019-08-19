#!/bin/bash

# Use to build release-version of CBL_OC_SOCKET under unix

gcc -shared -fPIC -Wall -O2 -o CBL_GC_SOCKET.so cob_socket.cpp -lstdc++
