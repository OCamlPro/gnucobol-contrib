RM=rm -f 
MKDIR=mkdir -p
INSTALL=cp
BISON=bison
FLEX=flex
CC=gcc -std=gnu99 -D_FILE_OFFSET_BITS="64"  -c -o 
LD=gcc -o 
LDFLAGS= -O3
LIBS=-L${exec_prefix}/lib -L/usr/local/lib/ -lcob -lm -lgmp

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

TARGET=gcsort
OBJS=\
	condfield.o \
    gcsorthelp.o \
    gcsort.o \
	fieldvalue.o \
	file.o \
	keyidxrel.o \
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
 
##   GENERATED=parser.h parser.c scanner.h scanner.c


all: $(TARGET)
Debug:all
Release:all


$(TARGET): $(OBJS)
		$(LD) $(TARGET) $(LDFLAGS) $(OBJS) $(LIBS) $(DEBUGFLAGS)


%.o: %.c
		$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

## parser.c parser.h: parser.y
## # windows   win_bison --defines=parser.h -o parser.c parser.y
## 		$(BISON) --defines=parser.h -o parser.c parser.y


## scanner.c scanner.h: scanner.l
## # windows   win_flex.exe  --header-file=scanner.h  -d --nounistd --wincompat -o scanner.c scanner.l
## 		 $(FLEX) --header-file=scanner.h   --debug  -o scanner.c scanner.l
## 
## 		# $(FLEX) --header-file=scanner.h -o scanner.c scanner.l

condfield.o:condfield.h gcsort.h file.h job.h utils.h fieldvalue.h sortfield.h sumfield.h
fieldvalue.o:fieldvalue.h utils.h job.h
file.o:file.h utils.h job.h
inrec.o:inrec.h fieldvalue.h utils.h job.h
job.o:gcsort.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h utils.h outfil.h sumfield.h utils.h outfil.h 
keyidxrel.o: keyidxrel.h file.h
mmfioc.o:mmfioc.h job.h utils.h
gcsorthelp.o:
gcsort.o:gcsort.h job.h 
outfil.o:outfil.h  gcsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h 
outrec.o:outrec.h fieldvalue.h utils.h job.h
parser.o:gcsort.h file.h job.h sortfield.h condfield.h fieldvalue.h outrec.h utils.h file.h inrec.h outfil.h sumfield.h 
scanner.o:parser.h utils.h 
sortfield.o:gcsort.h utils.h sumfield.h job.h sortfield.h
sumfield.o:sumfield.h gcsort.h utils.h job.h
utils.o:utils.h

clean:
		$(RM) $(TARGET) $(OBJS) 
		## $(GENERATED)
cleanDebug:clean
cleanRelease:clean
