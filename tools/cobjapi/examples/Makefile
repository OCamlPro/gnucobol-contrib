# GNU MAKE Makefile for all normal examples in COBJAPI
#
# Usage: make [DEBUG=Y] [VERBOSE=Y] [COBFLAGS=-Wno-unfinished]

SUBDIRS = colorpicker digits drawables imageviewer mandelbrot texteditor thinclient video

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

.PHONY: all clean $(SUBDIRS)

default: all

# dependencies

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS) $(SUBFLAGS)

all clean : $(SUBDIRS)
