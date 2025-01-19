COBCEXE = cobc -x -free -Wall -ISystem2_src -debug -lcjson
COBCOBJ = cobc -c -free -Wall -ISystem2_src -debug

all : btc-rate.exe

# compile
btc-rate.exe : btc-rate.cob parse-json.cob system2_cmd.o
	$(COBCEXE) btc-rate.cob parse-json.cob system2_cmd.o

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

	