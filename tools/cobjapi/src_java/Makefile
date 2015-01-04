JAVAC = javac
JAR = jar
JARFLAGS = cvfm

all : JAPI.jar

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
	rm JAPI.jar *.class 
	
