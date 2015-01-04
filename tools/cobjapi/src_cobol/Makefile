COBC = cobc
COBCFLAGS = -c -free

all : cobjapi.o

# compile
cobjapi.o : cobjapi.cob 
	$(COBC) $(COBCFLAGS) cobjapi.cob
	
# clean
clean :
	rm *.o
	