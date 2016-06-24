#!/bin/bash

# Use to build release-version of CBL_OC_SOCKET under unix

gcc -shared -Wall -O2 -o CBL_OC_SOCKET.so cob_socket.cpp
