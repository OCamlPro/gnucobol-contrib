RM=rm -f
MKDIR=mkdir -p
INSTALL=cp
CC=cc -c -o
CCFLAGS=
LDFLAGS=
LD=cc -o


TARGET=gcstats
MAINSRC=gcstats.bat
OBJS=

all: $(TARGET) 

Debug:all
Release:all

$(TARGET): 
	cobc -Wall -std=mf -fstatic-call -fimplicit-init -fnotrunc -fmf-files -fdump=all -debug -x -o gcstats gcstats.bat 


%.o: %.c
	$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

install:
	if test -d /usr/local/bin ; then \
	$(INSTALL) $(TARGET) /usr/local/bin; \
	else \
	if test -d $(HOME)/bin ; then \
	$(INSTALL) $(TARGET) $(HOME)/bin; \
	fi; \
	fi

clean:
	$(RM) $(TARGET) $(OBJS) 

clobber:
	$(RM) $(TARGET) $(OBJS) 
	$(RM) /usr/local/bin/$(TARGET)
	$(RM) $(HOME)/bin/$(TARGET)

cleanDebug:clean
cleanRelease:clean
