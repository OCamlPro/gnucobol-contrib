RM=rm -f 
MKDIR=mkdir -p
INSTALL=cp
BISON=bison
FLEX=flex
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

TARGET=ocsort
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
# windows   win_bison --defines=parser.h -o parser.c parser.y
		$(BISON) --defines=parser.h -o parser.c parser.y


scanner.c scanner.h: scanner.l
# windows   win_flex.exe  --header-file=scanner.h  -d --nounistd --wincompat -o scanner.c scanner.l
		 $(FLEX) --header-file=scanner.h   --debug  -o scanner.c scanner.l

		# $(FLEX) --header-file=scanner.h -o scanner.c scanner.l

bufferedreader.o:bufferedreader.h 
bufferedwriter.o:bufferedwriter.h 
condfield.o:condfield.h ocsort.h file.h job.h utils.h fieldvalue.h sortfield.h sumfield.h
fieldvalue.o:fieldvalue.h utils.h job.h
file.o:file.h utils.h job.h
inrec.o:inrec.h fieldvalue.h utils.h job.h
job.o:ocsort.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h utils.h outfil.h bufferedreader.h sumfield.h utils.h outfil.h bufferedwriter.h
mmfioc.o:mmfioc.h job.h utils.h
ocsorthelp.o:
ocsort.o:ocsort.h job.h 
outfil.o:outfil.h  ocsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h 
outrec.o:outrec.h fieldvalue.h utils.h job.h
parser.o:ocsort.h file.h job.h sortfield.h condfield.h fieldvalue.h outrec.h utils.h file.h inrec.h outfil.h sumfield.h 
scanner.o:parser.h utils.h 
sortfield.o:ocsort.h utils.h sumfield.h job.h sortfield.h
sumfield.o:sumfield.h ocsort.h utils.h job.h
utils.o:utils.h

clean:
		$(RM) $(TARGET) $(OBJS) $(GENERATED)
cleanDebug:clean
cleanRelease:clean
