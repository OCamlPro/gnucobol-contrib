COBCEXE = cobc -x -free -Wall -ISystem2_src -debug
COBCOBJ = cobc -c -free -Wall -ISystem2_src -debug

all : testsys2.exe

# compile
testsys2.exe : testsys2.cob system2_cmd.o
	$(COBCEXE) testsys2.cob system2_cmd.o

system2_cmd.o : system2_cmd.c System2_src/System2.o
	$(COBCOBJ) system2_cmd.c 

System2_src/System2.o : System2_src/System2.c System2_src/System2.h
	$(COBCOBJ) System2_src/System2.c 
	
# clean
clean :
#	rm *.exe
#	rm *.o
	del *.exe
	del *.o

	