RM=rm -f
MKDIR=mkdir -p
INSTALL=cp
BISON=bison
FLEX=flex
CC=gcc -c -o
CCFLAGS=-Wall
LD=gcc -o

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

TARGET=ocsort
OBJS=\
		condfield.o \
		fieldvalue.o \
		file.o \
		job.o \
		ocsort.o \
		outrec.o \
		parser.o \
		scanner.o \
		sortfield.o \
		utils.o

GENERATED=parser.h parser.c scanner.h scanner.c


all: $(TARGET)
Debug:all
Release:all

$(TARGET): $(OBJS)
		$(LD) $(TARGET) $(LDFLAGS) $(OBJS) $(DEBUGFLAGS)


%.o: %.c
		$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

parser.c parser.h: parser.y
		$(BISON) --defines=parser.h -o parser.c parser.y

scanner.c scanner.h: scanner.l
		$(FLEX) --header-file=scanner.h -o scanner.c scanner.l

condfield.o:condfield.h ocsort.h utils.h fieldvalue.h
fieldvalue.o:fieldvalue.h utils.h
file.o:file.h utils.h
job.o:ocsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h utils.h
ocsort.o:ocsort.h job.h
outrec.o:outrec.h fieldvalue.h
parser.o:ocsort.h file.h job.h sortfield.h condfield.h fieldvalue.h outrec.h utils.h
scanner.o:parser.h sortfield.h
sortfield.o:ocsort.h utils.h
utils.o:utils.h

clean:
		$(RM) $(TARGET) $(OBJS) $(GENERATED)
cleanDebug:clean
cleanRelease:clean
