RM=rm -f
MKDIR=mkdir -p
INSTALL=cp
CC=cc -c -o
CCFLAGS=
LDFLAGS=
LD=cc -o


TARGET=gctest
MAINSRC=gctest.c
OBJS=

all: $(TARGET) 

Debug:all
Release:all

$(TARGET): $(OBJS) $(MAINSRC)
		$(LD) $(TARGET) $(DEBUGFLAGS) $(LDFLAGS) $(MAINSRC) $(OBJS) 


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
		$(RM) $(TARGET) $(OBJS) $(GENERATED)

cleanDebug:clean
cleanRelease:clean
