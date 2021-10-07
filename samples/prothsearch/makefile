COBCEXE = cobc -x -free -Wall
COBCOBJ = cobc -c -free -Wall

all : prothsearch.exe

# compile
prothsearch.exe : prothsearch.cob prothtest.o gmp_fn_calls.o
	$(COBCEXE) prothsearch.cob prothtest.o gmp_fn_calls.o -lgmp

prothtest.o : prothtest.cob
	$(COBCOBJ) prothtest.cob 

gmp_fn_calls.o : gmp_fn_calls.c
	$(COBCOBJ) gmp_fn_calls.c 
	
# clean
clean :
	rm *.exe
	rm *.o

	