CC        = cc -c -o
CCFLAGS   = 
INSTALL   = $(firstword $(shell sh -c 'command -v install') cp)
LD        = cc -o
LDFLAGS   = 
MKDIR     = mkdir -p
RM        = rm -f

#
# PREFIX defines the default installation location, chosen from some
# likely candidates. 
# Override PREFIX by using "make install PREFIX=DIR", where DIR/bin
#          is the directory you'd like gctest installed in .
#

PREFIXES  = /usr/local/bin $(HOME)/bin
PREFIX    = $(dir $(firstword $(foreach d,$(PREFIXES),$(wildcard $(d)))))
DOCDIR = $(PREFIX)/share/man/man7

TARGET    = gctest
MAINSRC   = gctest.c

OBJS=

all: $(TARGET) 

Debug:all
Release:all

$(TARGET): $(OBJS) $(MAINSRC)
		$(LD) $(TARGET) $(DEBUGFLAGS) $(LDFLAGS) $(MAINSRC) $(OBJS) 


%.o: %.c
	$(CC) $@ $< $(CCFLAGS) $(DEBUGFLAGS)

install:
	@if test -d "$(PREFIX)/bin"; \
	then $(INSTALL) $(TARGET) $(PREFIX)/bin; \
	     mkdir -p $(DOCDIR); \
	     { $(INSTALL) gctest.7 $(DOCDIR)/; \
	       chmod -x $(DOCDIR)/gctest.7; } || exit 1; \
	else echo install target $(PREFIX)/bin does not exist >&2; \
	fi

clean:
		$(RM) $(TARGET) $(OBJS) $(GENERATED)

cleanDebug:clean
cleanRelease:clean
