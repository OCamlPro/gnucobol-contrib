
all : bin JAPI.jar
	
bin :
	make -C ../bin
	
#JAPI_Calls.java: ../lib/japicalls.def ../bin/makejapicallsjava
#	../bin/makejapicallsjava > JAPI_Calls.java
#JAPI_Const.java: ../lib/japiconst.def ../bin/makejapiconstjava
#	../bin/makejapiconstjava > JAPI_Const.java

JAPI.jar : 
	@./make.sh
	cp japi2.jar JAPI.jar

	@echo WARNING: no generation of JAPI_Calls.java used
	@echo WARNING: no generation of JAPI_Const.java used


clean:
	rm JAPI.jar japi2.jar