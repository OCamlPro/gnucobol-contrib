RM=rm -f 
MKDIR=mkdir -p
INSTALL=cp
CC=gcc  -D_FILE_OFFSET_BITS="64"  -c -o  
CCFLAGS=-W -I./ -I/opt/open-cobol-2.0/libcob
LD=gcc -o 
LDFLAGS= -O3
LIBS=-L${exec_prefix}/lib -L/usr/local/lib/ -L/opt/open-cobol-2.0/libcob/.libs -lcob -lm -lgmp -lncurses -ldl

ifeq ($(MAKECMDGOALS),Debug)
        DEBUG=YES
endif
ifeq ($(MAKECMDGOALS),cleanDebug)
        DEBUG=YES
endif

ifeq ($(DEBUG),YES)
    DEBUGFLAGS=-g
else
    DEBUGFLAGS=
endif

TARGET=gcsort_gentestcase
OBJS=\
       gcsort_gentestcase.o \
	genscript.o \
	gencob4sort.o \
	gencob4check.o \
	gencfg.o  


all: $(TARGET)
Debug:all
Release:all


$(TARGET): $(OBJS)
		$(LD) $(TARGET) $(LDFLAGS) $(OBJS) $(LIBS) $(DEBUGFLAGS)


%.o: %.c
		$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

gcsort_gentestcase.o: gcsort_gentestcase.h libgcsort.h genscript.h  gencob4sort.h  gencob4check.h  gencfg.h 
genscript.o: genscript.h
gencob4sort.o: gencob4sort.h genrows.hpp
gencob4check.o: gencob4check.h  genrows.hpp
gencfg.o: gencfg.h 

clean:
		$(RM) $(TARGET) $(OBJS)
cleanDebug:clean
cleanRelease:clean
