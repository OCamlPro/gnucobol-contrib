COBC = cobc
COBCFLAGS = -x -free
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : drawables.exe

# compile
drawables.exe : drawables.cob
	$(COBC) $(COBCFLAGS) drawables.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	