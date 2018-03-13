# GNU MAKE Makefile for all directories in COBJAPI
#
# Usage: make [DEBUG=Y] [VERBOSE=Y] [COBFLAGS=-Wno-unfinished] [CFLAGS=-Wno-unused-result]

SUBDIRS = src_c src_cobol src_java
SUBDIRS_SAMPLES = examples_simple examples

.PHONY: all clean $(SUBDIRS) $(SUBDIRS_SAMPLES)

ifdef DEBUG
	SUBFLAGS += DEBUG=$(DEBUG)
endif
ifdef VERBOSE
	SUBFLAGS += VERBOSE=$(VERBOSE)
endif
ifdef COBC
	SUBFLAGS += COBC="$(COBC)"
endif
ifdef COBFLAGS
	SUBFLAGS += COBFLAGS="$(COBFLAGS)"
endif
ifdef CFLAGS
	SUBFLAGS += CFLAGS="$(CFLAGS)"
endif
ifdef LDFLAGS
	SUBFLAGS += LDFLAGS="$(LDFLAGS)"
endif

default: all

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS) $(SUBFLAGS)

$(SUBDIRS_SAMPLES): src_c src_cobol
	$(MAKE) -C $@ $(MAKECMDGOALS) $(SUBFLAGS)

all clean : $(SUBDIRS) $(SUBDIRS_SAMPLES)
