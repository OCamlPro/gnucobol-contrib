COBCEXE = cobc -x -free -O3
COBCOBJ = cobc -c -free -O3 -fno-gen-c-decl-static-call

all : prothsearch.exe

# compile
prothsearch.exe : prothsearch.cob prothtest.o
	$(COBCEXE) prothsearch.cob prothtest.o

prothtest.o : prothtest.cob
	$(COBCOBJ) prothtest.cob 
	
# clean
clean :
	rm *.exe
	rm *.o

	