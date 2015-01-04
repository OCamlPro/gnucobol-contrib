COBC = cobc
COBCFLAGS = -x -free
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : texteditor.exe

# compile
texteditor.exe : texteditor.cob
	$(COBC) $(COBCFLAGS) texteditor.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	