# GNU MAKE Makefile for COBJAPI library
#
# Usage: make [DEBUG=Y] [VERBOSE=Y] [COBFLAGS=-Wno-unfinished]

O = o

ifndef COBC
	COBC = cobc
endif

ifeq ($(DEBUG),Y)
	COBCFLAGS = $(COBFLAGS) -g
else
	COBCFLAGS = $(COBFLAGS) -O2
endif

ifeq ($(VERBOSE),Y)
	COBCFLAGS += -v
endif

ifdef CFLAGS
	COBCFLAGS += -A "$(CFLAGS)"
endif
ifdef LDFLAGS
	COBCFLAGS += -Q "$(LDFLAGS)"
endif

uname_S := $(shell uname -s 2>/dev/null)
ifeq ($(uname_S),)
	DELETE = -del
	# we may check for COB_OBJECT_EXT and set O here
else
	DELETE = rm -f
endif


# actual target...
all : cobjapi.$(O)

.PHONY: clean

# Object Files
cobjapi.$(O) : cobjapi.cob
	$(COBC) $(COBCFLAGS) -free -c cobjapi.cob


clean :
	$(DELETE) cobjapi.$(O)
