COBC = cobc
COBCFLAGS = -x -free
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : imageviewer.exe

# compile
imageviewer.exe : imageviewer.cob
	$(COBC) $(COBCFLAGS) imageviewer.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	