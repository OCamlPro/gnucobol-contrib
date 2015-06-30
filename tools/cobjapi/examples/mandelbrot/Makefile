COBC = cobc
COBCFLAGS = -x -free -I"../../src_cobol"
# static link
COBJAPI = ../../src_cobol/cobjapi.o
CJAPI = ../../src_c/japilib.o \
		../../src_c/imageio.o \
		../../src_c/fileselect.o

all : mandelbrot1.exe mandelbrot2.exe mandelbrot3.exe

# compile
mandelbrot1.exe : mandelbrot1.cob
	$(COBC) $(COBCFLAGS) mandelbrot1.cob $(COBJAPI) $(CJAPI)

mandelbrot2.exe : mandelbrot2.cob
	$(COBC) $(COBCFLAGS) mandelbrot2.cob $(COBJAPI) $(CJAPI)
	
mandelbrot3.exe : mandelbrot3.cob
	$(COBC) $(COBCFLAGS) mandelbrot3.cob $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	