COBCEXE = cobc -x -free
COBCOBJ = cobc -c -free

all : prothsearch.exe

# compile
prothsearch.exe : prothsearch.cob prothtest.o
	$(COBCEXE) prothsearch.cob -o prothsearch.exe prothtest.o

prothtest.o : prothtest.cob
	$(COBCOBJ) prothtest.cob -o prothtest.o -fno-gen-c-decl-static-call
	
# clean
clean :
	rm *.exe
	rm *.o

	