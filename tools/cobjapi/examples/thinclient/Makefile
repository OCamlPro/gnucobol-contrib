# ToDo: makefile for unix system

COBC = cobc
COBCFLAGS = -x -free -I"../../src_cobol" -lws2_32
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : thinclient.exe

# compile
thinclient.exe : thinclient.cob
	$(COBC) $(COBCFLAGS) thinclient.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	