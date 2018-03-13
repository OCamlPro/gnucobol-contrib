# GNU MAKE Makefile for japi library used in COBJAPI

JAVAC = javac
JAR = jar
JARFLAGS = cvfm

uname_S := $(shell uname -s 2>/dev/null)
ifeq ($(uname_S),)
	DELETE = -del
else
	DELETE = rm -f
endif


# actual target...
all : JAPI.jar

.PHONY: clean

# create class files
JAPI.class : $(wildcard *.java)
# Generate all debugging information, including local variables. 
# By default, only line number and source file information is generated. 
#	$(JAVAC) -g *.java
#
# Some input files use or override a deprecated API.
# Recompile with -Xlint:deprecation for details.
#	$(JAVAC) -Xlint:deprecation *.java
#
	$(JAVAC) *.java

# create jar 
JAPI.jar  : JAPI.class 
	$(JAR) $(JARFLAGS) JAPI.jar JAPI.mf *.class *.gif

# clean
clean :
	$(DELETE) JAPI.jar *.class 

