# ==============================================================================
# Project: gcsort
# Description: Cross-Platform Makefile for Linux, MinGW (32/64-bit), and AIX
# Author: Sauro Menna & Gnucobol project team  
# Date: October 30, 2026
# ==============================================================================

# 1. AUTOMATIC OPERATING SYSTEM DETECTION
UNAME_S := $(shell uname -s)

# Specific MSYS2 / MinGW detection (avoids falling back to cmd.exe)
ifneq (,$(findstring MINGW,$(UNAME_S)))
    IS_MINGW = YES
else
    IS_MINGW = NO
endif

# --- COMMON POSIX CONFIGURATION ---
RM = rm -f
MKDIR_CMD = mkdir -p $(1)
INSTALL = cp
BISON = bison
FLEX = flex

# --- PLATFORM CONFIGURATION MAP ---
ifeq ($(IS_MINGW),YES)
    EXE_EXT = .exe
    DLL_EXT = .dll
    LIB_EXT = .lib
    LINK_IMPORT = -Wl,--out-implib,lib/libgcs.a
    CC_OS_FLAGS = 
    PIC_FLAG = 
    COB_CFLAGS :=
    COB_LIBS   := -lcob
    BITS =
    LFS = 
else
    EXE_EXT =
    LIB_EXT = .lib
    LINK_IMPORT =
    CC_OS_FLAGS = 

    # GnuCOBOL Configuration
    COB_PREFIX ?= /usr/local /usr /opt/freeware
    COBCONFIG  ?= $(firstword $(shell command -v cob-config 2>/dev/null) \
                              $(wildcard $(addsuffix /bin/cob-config,$(COB_PREFIX))))
    ifneq ($(COBCONFIG),)
        COB_CFLAGS := $(filter -I%,$(shell $(COBCONFIG) --cflags))
        COB_LIBS   := $(shell $(COBCONFIG) --libs)
    else
        COB_CFLAGS :=
        COB_LIBS   := -lcob
    endif

    # AIX vs Linux Configuration
    ifeq ($(UNAME_S),AIX)
        OBJECT_MODE ?= 64
        BITS = -maix$(OBJECT_MODE)
        LFS = -D_LARGE_FILES -D_LARGE_FILE_API
        PIC_FLAG = 
        DLL_EXT = .so
    else
        BITS =
        LFS = -D_FILE_OFFSET_BITS="64" -D_LARGEFILE64_SOURCE
        PIC_FLAG = -fPIC
        DLL_EXT = .so
    endif
endif

CC = gcc -std=gnu99 -pthread $(BITS) $(LFS) $(CC_OS_FLAGS) -I. -I./libgcs
CCFLAGS = $(COB_CFLAGS) -O3 -fsigned-char -fkeep-inline-functions
LD = gcc $(BITS) -o
LDFLAGS =
LIBS = $(COB_LIBS) -lm -pthread

# Output directories
DIST_BIN = bin
DIST_LIB = lib
OUTDIR = tests/bin

# Targets
TARGET = gcsort$(EXE_EXT)
LIBGCS_DLL = libgcs$(DLL_EXT)
EXTSM_DLL  = EXTSM$(DLL_EXT)

ifeq ($(MAKECMDGOALS),Debug)
        DEBUG=YES
endif
ifeq ($(MAKECMDGOALS),cleanDebug)
        DEBUG=YES
endif

ifeq ($(DEBUG),YES)
    DEBUGFLAGS=-g -O0
else
    DEBUGFLAGS=
endif

# =========================================================================
# MANAGING SOURCES AND OBJECTS
# =========================================================================
SRCS_SHARED = \
	changefield.c \
	condfield.c \
	copyfile.c \
	datediff.c \
	gcsorthelp.c \
	gcsort.c \
	gcthread.c \
	exitroutines.c \
	fieldvalue.c \
	findreplace.c \
	file.c \
	keyidxrel.c \
	inrec.c \
	job.c \
	join.c \
	mmfioc.c \
	outfil.c \
	outrec.c \
	parser.c \
	scanner.c \
	sortfield.c \
	sumfield.c \
	utils.c \
	symnames.c

SRCS_LIB_EXTRA = libgcs/libgcs.c

OBJS_EXE = $(SRCS_SHARED:.c=_exe.o)
OBJS_LIB = $(SRCS_SHARED:.c=_lib.o) $(SRCS_LIB_EXTRA:.c=_lib.o)
GENERATED = parser.h parser.c scanner.h scanner.c

# =========================================================================
# MAIN TARGETS
# =========================================================================

all: setup $(TARGET) $(LIBGCS_DLL) $(EXTSM_DLL)
	@echo ' --- Starting the compilation of testlibgcs.mak ---'
	$(MAKE) -f testlibgcs/testlibgcs.mak

setup:
	mkdir -p $(DIST_BIN) $(DIST_LIB) $(OUTDIR)

Debug:all
Release:all

.PHONY: clean check all Debug Release deploy setup

# --- 1) Compiling the gcsort Standalone Executable ---
$(TARGET): $(OBJS_EXE)
	@echo ' Generate gcsort executable inside bin/'
	$(LD) $(DIST_BIN)/$(TARGET) $(LDFLAGS) $(OBJS_EXE) $(LIBS) $(DEBUGFLAGS)
	@echo ' Copy gcsort to test environment'
	$(INSTALL) $(DIST_BIN)/$(TARGET) $(OUTDIR)

%_exe.o: %.c
	$(CC) -c -o $@ $< $(CCFLAGS) -DGCSORT_EXE $(DEBUGFLAGS)

# --- 2) Compiling the libgcs Shared Library ---
$(LIBGCS_DLL): $(OBJS_LIB)
	@echo ' Generate libgcs shared library inside lib/ or bin/'
	$(LD) $(if $(filter YES,$(IS_MINGW)),$(DIST_BIN),$(DIST_LIB))/$(LIBGCS_DLL) -shared $(LINK_IMPORT) $(LDFLAGS) $(OBJS_LIB) $(LIBS) $(DEBUGFLAGS)
	$(INSTALL) $(if $(filter YES,$(IS_MINGW)),$(DIST_BIN),$(DIST_LIB))/$(LIBGCS_DLL) $(OUTDIR)
ifneq ($(IS_MINGW),YES)
	@echo "Installing libgcs on Unix system..."
	sudo $(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) /usr/local/lib/
	sudo $(INSTALL) libgcs/libgcs.h /usr/local/include/
	sudo ldconfig
endif

%_lib.o: %.c
	$(CC) -c -o $@ $< $(CCFLAGS) $(PIC_FLAG) $(DEBUGFLAGS)

# --- 3) Compiling the extsm Library (uses libgcs) ---
$(EXTSM_DLL): extsm.o $(LIBGCS_DLL)
	@echo ' Generate EXTSM shared library inside bin/'
ifeq ($(IS_MINGW),YES)
	$(LD) $(DIST_BIN)/$(EXTSM_DLL) -shared $(LDFLAGS) extsm.o $(DIST_BIN)/$(LIBGCS_DLL) $(LIBS) $(DEBUGFLAGS)
else
	$(LD) $(DIST_BIN)/$(EXTSM_DLL) -shared $(LDFLAGS) extsm.o -L$(DIST_LIB) -lgcs $(LIBS) $(DEBUGFLAGS)
endif
	@echo ' Copy EXTSM to test environment'
	$(INSTALL) $(DIST_BIN)/$(EXTSM_DLL) $(OUTDIR)

extsm.o: EXTSM/extsm.c
	$(CC) -c -o $@ $< $(CCFLAGS) $(PIC_FLAG) $(DEBUGFLAGS)


# =========================================================================
# PARSER / SCANNER GENERATION AND DEPENDENCIES
# =========================================================================
parser.c parser.h: parser.y
	$(BISON) --defines=parser.h -o parser.c parser.y

scanner.c scanner.h: scanner.l
	$(FLEX) --header-file=scanner.h -o scanner.c $(FLEX_FLAGS) scanner.l

changefield_exe.o changefield_lib.o: changefield.h gcsort.h fieldvalue.h utils.h
condfield_exe.o condfield_lib.o: condfield.h gcsort.h fieldvalue.h file.h gcshare.h job.h sortfield.h sumfield.h utils.h
copyfile_exe.o copyfile_lib.o: condfield.h copyfile.h file.h gcshare.h gcsort.h inrec.h job.h outfil.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h exitroutines.h
exitroutines_exe.o exitroutines_lib.o: file.h exitroutines.h utils.h
datediff_exe.o datediff_lib.o: gcsort.h job.h utils.h datediff.h
fieldvalue_exe.o fieldvalue_lib.o: fieldvalue.h gcsort.h job.h outrec.h utils.h
file_exe.o file_lib.o: file.h gcshare.h gcsort.h job.h utils.h
findreplace_exe.o findreplace_lib.o: fieldvalue.h findreplace.h utils.h
gcsort_exe.o gcsort_lib.o: gcsort.h job.h utils.h file.h gcshare.h exitroutines.h copyfile.h datediff.h join.h
gcsorthelp_exe.o gcsorthelp_lib.o: gcsort.h job.h
gcthread_exe.o gcthread_lib.o: gcthread.h job.h file.h gcsort.h sumfield.h outrec.h
inrec_exe.o inrec_lib.o: fieldvalue.h gcshare.h gcsort.h inrec.h job.h utils.h changefield.h join.h
job_exe.o job_lib.o: gcsort.h gcthread.h utils.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h sumfield.h outfil.h mmfioc.h exitroutines.h join.h gcshare.h symnames.h
join_exe.o join_lib.o: job.h join.h sortfield.h utils.h gcshare.h job.h file.h sumfield.h outrec.h
keyidxrel_exe.o keyidxrel_lib.o: keyidxrel.h file.h
mmfioc_exe.o mmfioc_lib.o: gcshare.h gcsort.h mmfioc.h job.h utils.h
outfil_exe.o outfil_lib.o: gcsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sortfield.h sumfield.h utils.h outfil.h gcshare.h
outrec_exe.o outrec_lib.o: gcshare.h gcsort.h fieldvalue.h job.h outrec.h utils.h changefield.h
parser_exe.o parser_lib.o: condfield.h fieldvalue.h file.h inrec.h job.h gcshare.h gcsort.h keyidxrel.h outrec.h outfil.h sortfield.h sumfield.h parser.y scanner.l utils.h
scanner_exe.o scanner_lib.o: gcsort.h parser.h utils.h parser.y scanner.l
sortfield_exe.o sortfield_lib.o: gcshare.h gcsort.h job.h sortfield.h sumfield.h utils.h
sumfield_exe.o sumfield_lib.o: gcshare.h gcsort.h job.h sumfield.h utils.h
utils_exe.o utils_lib.o: gcshare.h gcsort.h gcthread.h job.h utils.h outfil.h exitroutines.h
symnames_exe.o symnames_lib.o: gcshare.h gcsort.h symnames.h job.h utils.h
extsm.o: EXTSM/extsm.c
	$(CC) -c -o $@ $< $(CCFLAGS) $(PIC_FLAG) $(DEBUGFLAGS)
libgcs_lib.o: libgcs/libgcs.c
	$(CC) -c -o $@ $< $(CCFLAGS) $(PIC_FLAG) $(DEBUGFLAGS)

# =========================================================================
# CLEANING AND TESTING
# =========================================================================
clean:
	rm -f *.o *$(DLL_EXT) gcsort gcsort.exe libgcs.lib libgcs.a EXTSM$(DLL_EXT)
	rm -f *_exe.o *_lib.o EXTSM.o
	rm -rf $(DIST_BIN) $(DIST_LIB)
	@echo "--- Cleaning testlibgcs ---"
	-$(MAKE) -f testlibgcs/testlibgcs.mak clean

deploy:
	$(INSTALL) $(DIST_BIN)/$(TARGET) $(OUTDIR)
ifeq ($(IS_MINGW),YES)
	$(INSTALL) $(DIST_BIN)/$(LIBGCS_DLL) $(OUTDIR)
else
	$(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) $(OUTDIR)
	@echo "Installing libgcs on Unix system..."
	sudo $(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) /usr/local/lib/
	sudo $(INSTALL) libgcs/libgcs.h /usr/local/include/
	sudo ldconfig
endif
	$(INSTALL) $(DIST_BIN)/$(EXTSM_DLL) $(OUTDIR)

check: all
	mkdir -p tests/listing tests/log
	cd tests/script && ./compile.sh || true
	cd tests/bin    && ./gctestset
	cd tests/bin    && ./gctestrun

cleanDebug:clean
cleanRelease:clean
