# GNU MAKE Makefile for japi library used in COBJAPI
# note: most of the actual compilation work is done in make.sh

uname_S := $(shell uname -s 2>/dev/null)
ifeq ($(uname_S),)
	DELETE = -del
	COPY = -copy
else
	DELETE = rm -f
	COPY = cp
endif

# actual target...
#all : bin JAPI.jar
all : JAPI.jar

.PHONY: clean
	
bin :
	make -C ../bin
	
#JAPI_Calls.java: ../lib/japicalls.def ../bin/makejapicallsjava
#	../bin/makejapicallsjava > JAPI_Calls.java
#JAPI_Const.java: ../lib/japiconst.def ../bin/makejapiconstjava
#	../bin/makejapiconstjava > JAPI_Const.java

japi2.jar :
	@./make.sh

JAPI.jar : japi2.jar
	$(COPY) japi2.jar JAPI.jar

	@echo WARNING: no generation of JAPI_Calls.java used
	@echo WARNING: no generation of JAPI_Const.java used



# clean
clean :
	$(DELETE) JAPI.jar japi2.jar

