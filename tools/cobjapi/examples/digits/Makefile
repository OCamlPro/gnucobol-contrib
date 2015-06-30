COBC = cobc
COBCFLAGS = -x -free -I"../../src_cobol"
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : digits.exe

# compile
digits.exe : digits.cob
	$(COBC) $(COBCFLAGS) digits.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	