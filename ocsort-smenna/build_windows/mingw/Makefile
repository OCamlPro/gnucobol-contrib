# RM=rm -f
RM=del 
MKDIR=mkdir -p
INSTALL=cp
BISON=win_bison
FLEX=win_flex
CC=gcc -c  -D_FILE_OFFSET_BITS="64" -o
# CCFLAGS=-Wall 
# CCFLAGS=-W  -IC:\ocsort_1_0_0\libcob\ -IC:\ocsort_1_0_0\libcob\libcob\libcob -IC:\ocsort_1_0_0\gmp_mpir
CCFLAGS=-W  -IC:\ocsort_1_0_0\libcob\ -IC:\ocsort_1_0_0\gmp_mpir
LD=gcc -o 
LDFLAGS= -O3
LIBS=-LC:\ocsort_1_0_0\LIB -LC..\gmp_mpir -lmpir -llibcob 

ifeq ($(MAKECMDGOALS),Debug)
        #DEBUG=YES
		DEBUG=NO
endif
ifeq ($(MAKECMDGOALS),cleanDebug)
        #DEBUG=YES
		DEBUG=NO
endif

ifeq ($(DEBUG),YES)
    DEBUGFLAGS=-g
else
    DEBUGFLAGS=
endif

TARGET=ocsort.exe
OBJS=\
        bufferedreader.o \
		bufferedwriter.o \
		condfield.o \
        ocsorthelp.o \
        ocsort.o \
		fieldvalue.o \
		file.o \
        inrec.o \
        job.o \
        mmfioc.o \
        outfil.o \
		outrec.o \
		parser.o \
		scanner.o \
		sortfield.o \
        sumfield.o \
		utils.o
 
GENERATED=parser.h parser.c scanner.h scanner.c


all: $(TARGET)
Debug:all
Release:all


$(TARGET): $(OBJS)
		$(LD) $(TARGET) $(LDFLAGS) $(OBJS) $(LIBS) $(DEBUGFLAGS)


%.o: %.c
		$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

parser.c parser.h: parser.y
		$(BISON) --defines=parser.h -o parser.c parser.y

scanner.c scanner.h: scanner.l
		$(FLEX) --header-file=scanner.h -o scanner.c scanner.l

bufferedreader.o:bufferedreader.h 
bufferedwriter.o:bufferedwriter.h 
condfield.o:condfield.h ocsort.h file.h job.h utils.h fieldvalue.h sortfield.h sumfield.h
fieldvalue.o:fieldvalue.h utils.h job.h
file.o:file.h utils.h job.h
inrec.o:inrec.h fieldvalue.h utils.h job.h
job.o:ocsort.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h SumField.h utils.h outfil.h bufferedreader.h mmfioc.h SumField.h utils.h outfil.h bufferedwriter.h
mmfioc.o:mmfioc.h ocsort.h job.h
ocsorthelp.o:
ocsort.o:ocsort.h job.h 
outfil.o:outfil.h  ocsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sortfield.h SumField.h utils.h 
outrec.o:outrec.h fieldvalue.h utils.h job.h
parser.o:ocsort.h file.h job.h sortfield.h condfield.h fieldvalue.h outrec.h utils.h file.h inrec.h outfil.h SumField.h 
scanner.o:parser.h 
sortfield.o:ocsort.h utils.h sumfield.h job.h
sumfield.o:sumfield.h ocsort.h utils.h job.h
utils.o:utils.h

clean:
#		$(RM) $(TARGET) $(OBJS) $(GENERATED)
#		$(RM) $(TARGET) 
		$(RM) $(OBJS) 
cleanDebug:clean
cleanRelease:clean
