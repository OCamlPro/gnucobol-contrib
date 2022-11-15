RM=rm -f 
MKDIR=mkdir -p
INSTALL=cp
BISON=bison
FLEX=flex
CC=gcc -std=gnu99 -D_FILE_OFFSET_BITS="64" -c -o 
CCFLAGS= -fkeep-inline-functions
LD=gcc -o 
LDFLAGS= -O3
LIBS=-L${exec_prefix}/lib -L/usr/local/lib/ -lcob -lm
OUTDIR=tests/bin


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
    changefield.o \
	condfield.o \
    copyfile.o \
    datediff.o \
    gcsorthelp.o \
    gcsort.o \
	exitroutines.o \
	fieldvalue.o \
	findreplace.o \
	file.o \
	keyidxrel.o \
    inrec.o \
    job.o \
    join.o \
    mmfioc.o \
    outfil.o \
	outrec.o \
	parser.o \
	scanner.o \
	sortfield.o \
    sumfield.o \
	utils.o
 
##   
GENERATED=parser.h parser.c scanner.h scanner.c


all: $(TARGET)
Debug:all
Release:all


$(TARGET): $(OBJS)
	@echo ' Generate gcsort'
		$(LD) $(TARGET) $(LDFLAGS) $(OBJS) $(LIBS) $(DEBUGFLAGS)
	@echo ' Copy gcsort in tests environment'
		$(INSTALL) $(TARGET) $(OUTDIR)


%.o: %.c 
		$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

## 
parser.c parser.h: parser.y
## # windows   win_bison --defines=parser.h -o parser.c parser.y
## 		
	@echo ' Generate parser'
	$(BISON) --defines=parser.h -o parser.c parser.y


##
scanner.c scanner.h: scanner.l
## # windows   win_flex.exe  --header-file=scanner.h  -d --nounistd --wincompat -o scanner.c scanner.l
## 		 $(FLEX) --header-file=scanner.h   --debug  -o scanner.c scanner.l
## 
## 		# 
	@echo ' Generate scanner'
	$(FLEX) --header-file=scanner.h -o scanner.c scanner.l

changefield.o:changefield.h gcsort.h fieldvalue.h utils.h
condfield.o:condfield.h gcsort.h fieldvalue.h file.h gcshare.h job.h sortfield.h sumfield.h utils.h 
copyfile.o:condfield.h copyfile.h file.h gcshare.h gcsort.h inrec.h  job.h libgcsort.h outfil.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h exitroutines.h
exitroutines.o:file.h exitroutines.h libgcsort.h utils.h
datediff.o:gcsort.h libgcsort.h utils.h datediff.h
fieldvalue.o:fieldvalue.h gcsort.h job.h libgcsort.h outrec.h  utils.h 
file.o:file.h gcshare.h gcsort.h job.h utils.h 
findreplace.o:fieldvalue.h findreplace.h utils.h
gcsort.o:libgcsort.h gcsort.h job.h utils.h file.h gcshare.h exitroutines.h copyfile.h datediff.h join.h
gcsorthelp.o:gcsort.h job.h
inrec.o:fieldvalue.h gcshare.h gcsort.h inrec.h job.h utils.h changefield.h join.h
job.o:libgcsort.h gcsort.h utils.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h sumfield.h outfil.h mmfioc.h exitroutines.h join.h gcshare.h 
join.o:job.h join.h sortfield.h utils.h gcshare.h job.h file.h sumfield.h outrec.h
keyidxrel.o: keyidxrel.h file.h
mmfioc.o:gcshare.h gcsort.h mmfioc.h job.h utils.h
outfil.o:libgcsort.h gcsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h outfil.h gcshare.h
outrec.o:gcshare.h gcsort.h fieldvalue.h job.h outrec.h utils.h changefield.h
parser.o:condfield.h fieldvalue.h file.h file.h inrec.h job.h gcshare.h gcsort.h keyidxrel.h outrec.h outfil.h sortfield.h sumfield.h parser.y scanner.l utils.h 
scanner.o:gcsort.h parser.h utils.h parser.y scanner.l 
sortfield.o:gcshare.h gcsort.h job.h sortfield.h sumfield.h utils.h
sumfield.o:gcshare.h gcsort.h job.h libgcsort.h sumfield.h utils.h  
utils.o:gcshare.h gcsort.h libgcsort.h utils.h outfil.h exitroutines.h

clean:
	$(RM) $(TARGET) $(OBJS) 

deploy:		
	$(INSTALL) $(TARGET) $(OUTDIR)
		
cleanDebug:clean
cleanRelease:clean
