# ==============================================================================
# Project: gcsort
# Description: Cross-Platform Makefile for compiling the project in Linux and MinGW
# Author: Sauro Menna & Gnucobol project team  
# Date: October 30, 2026
# ==============================================================================
#
# 1. AUTOMATIC OPERATING SYSTEM DETECTION
ifeq ($(OS),Windows_NT)
    # --- CONFIGURAZIONE WINDOWS (MinGW) ---
    SHELL = cmd.exe
    CC_OS_FLAGS = 
    
    RM = del /Q /F
    MKDIR_CMD = if not exist $(subst /,\,$(1)) mkdir $(subst /,\,$(1))
    INSTALL=cp
    BISON=win_bison
    FLEX=win_flex
    EXE_EXT = .exe
    DLL_EXT = .dll
    LIB_EXT = .lib
    LINK_IMPORT = -Wl,--out-implib,lib/libgcs.a
    CLEAN_CMD = if exist *.o del /Q *.o && if exist *.exe del /Q *.exe && if exist *.dll del /Q *.dll && if exist *.a del /Q *.a
    
    COB_CFLAGS :=
    COB_LIBS   := -lcob
    BITS =
    LFS = 
else
    # --- LINUX CONFIGURATION (GCC) ---
    CC_OS_FLAGS = 
    RM = rm -f
    MKDIR_CMD = mkdir -p $(1)
    INSTALL=cp
    BISON=bison
    FLEX=flex
    EXE_EXT =
    DLL_EXT = .so
    LIB_EXT = .lib
    LINK_IMPORT =
    CLEAN_CMD = rm -f *.o *$(DLL_EXT) gcsort libgcs.lib libgcs.a EXTSM$(DLL_EXT)

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

    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),AIX)
        OBJECT_MODE ?= 64
        BITS = -maix$(OBJECT_MODE)
        LFS = -D_LARGE_FILES -D_LARGE_FILE_API
    else
        BITS =
        LFS = -D_FILE_OFFSET_BITS="64" -D_LARGEFILE64_SOURCE
    endif
endif

CC=gcc -std=gnu99 -pthread $(BITS) $(LFS) $(CC_OS_FLAGS) -I. -I./libgcs
CCFLAGS=$(COB_CFLAGS) -O3 -fsigned-char -fkeep-inline-functions 
LD=gcc $(BITS) -o
LDFLAGS=
LIBS=$(COB_LIBS) -lm -pthread

# Definizione dei percorsi di output (Centralizzati)
DIST_BIN = bin
DIST_LIB = lib
OUTDIR=tests/bin

# Nomi dei target finali
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
GENERATED=parser.h parser.c scanner.h scanner.c

# =========================================================================
# MAIN TARGETS
# =========================================================================

# setup viene ora eseguito come pre-requisito obbligatorio
all: setup $(TARGET) $(LIBGCS_DLL) $(EXTSM_DLL)
	@echo ' --- Starting the compilation of testlibgcs.mak ---'
	$(MAKE) -f testlibgcs/testlibgcs.mak

# Target setup per creare la struttura ad albero delle cartelle
setup:
ifeq ($(OS),Windows_NT)
	@if not exist $(DIST_BIN) mkdir $(DIST_BIN)
	@if not exist $(DIST_LIB) mkdir $(DIST_LIB)
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
else
	@mkdir -p $(DIST_BIN) $(DIST_LIB) $(OUTDIR)
endif

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
ifeq ($(OS),Windows_NT)
	$(LD) $(DIST_BIN)/$(LIBGCS_DLL) -shared $(LINK_IMPORT) $(LDFLAGS) $(OBJS_LIB) $(LIBS) $(DEBUGFLAGS)
	$(INSTALL) $(DIST_BIN)/$(LIBGCS_DLL) $(OUTDIR)
else
	$(LD) $(DIST_LIB)/$(LIBGCS_DLL) -shared $(LDFLAGS) $(OBJS_LIB) $(LIBS) $(DEBUGFLAGS)
	$(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) $(OUTDIR)
	@echo "Installing libgcs on Linux system..."
	sudo $(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) /usr/local/lib/
	sudo $(INSTALL) libgcs/libgcs.h /usr/local/include/
	sudo ldconfig
endif

%_lib.o: %.c
	$(CC) -c -o $@ $< $(CCFLAGS) -fPIC $(DEBUGFLAGS)

# --- 3) Compiling the extsm Library (uses libgcs) ---
$(EXTSM_DLL): extsm.o $(LIBGCS_DLL)
	@echo ' Generate EXTSM shared library inside bin/'
ifeq ($(OS),Windows_NT)
	$(LD) $(DIST_BIN)/$(EXTSM_DLL) -shared $(LDFLAGS) extsm.o $(DIST_BIN)/$(LIBGCS_DLL) $(LIBS) $(DEBUGFLAGS)
else
	$(LD) $(DIST_BIN)/$(EXTSM_DLL) -shared $(LDFLAGS) extsm.o -L$(DIST_LIB) -lgcs $(LIBS) $(DEBUGFLAGS)
endif
	@echo ' Copy EXTSM to test environment'
	$(INSTALL) $(DIST_BIN)/$(EXTSM_DLL) $(OUTDIR)

extsm.o: EXTSM/extsm.c
	$(CC) -c -o $@ $< $(CCFLAGS) -fPIC $(DEBUGFLAGS)


# =========================================================================
# PARSER / SCANNER GENERATION AND DEPENDENCIES (Mantenuti Invariati)
# =========================================================================
parser.c parser.h: parser.y
	$(BISON) --defines=parser.h -o parser.c parser.y

scanner.c scanner.h: scanner.l
	$(FLEX) --header-file=scanner.h -o scanner.c $(FLEX_FLAGS) scanner.l

changefield_exe.o changefield_lib.o: fieldvalue.h changefield.h utils.h
condfield_exe.o condfield_lib.o: file.h job.h condfield.h gcsort.h utils.h fieldvalue.h sortfield.h sumfield.h gcshare.h
copyfile_exe.o copyfile_lib.o: gcsort.h utils.h job.h file.h sortfield.h condfield.h outrec.h inrec.h sortfield.h sumfield.h outfil.h exitroutines.h copyfile.h gcshare.h
datediff_exe.o datediff_lib.o: gcsort.h utils.h datediff.h
exitroutines_exe.o exitroutines_lib.o: file.h exitroutines.h gcshare.h utils.h libgcs/libgcs.h
fieldvalue_exe.o fieldvalue_lib.o: gcsort.h fieldvalue.h utils.h job.h outrec.h
file_exe.o file_lib.o: gcsort.h job.h file.h utils.h gcshare.h
findreplace_exe.o findreplace_lib.o: fieldvalue.h findreplace.h utils.h
gcsort_exe.o gcsort_lib.o: libgcs/libgcs.h gcsort.h job.h utils.h file.h gcshare.h exitroutines.h copyfile.h datediff.h join.h gcthread.h
gcsorthelp_exe.o gcsorthelp_lib.o: gcsort.h job.h
gcthread_exe.o gcthread_lib.o: job.h file.h gcthread.h gcsort.h sumfield.h outrec.h gcshare.h sortfield.h libgcs/libgcs.h
inrec_exe.o inrec_lib.o: job.h inrec.h fieldvalue.h utils.h gcsort.h gcshare.h changefield.h join.h findreplace.h
job_exe.o job_lib.o: libgcs/libgcs.h gcsort.h utils.h job.h file.h sortfield.h condfield.h outrec.h inrec.h parser.h scanner.h sortfield.h sumfield.h outfil.h mmfioc.h exitroutines.h join.h gcthread.h symnames.h gcshare.h
join_exe.o join_lib.o: job.h join.h sortfield.h utils.h gcshare.h file.h sumfield.h outrec.h
keyidxrel_exe.o keyidxrel_lib.o: file.h keyidxrel.h
mmfioc_exe.o mmfioc_lib.o: gcsort.h mmfioc.h job.h gcshare.h
outfil_exe.o outfil_lib.o: libgcs/libgcs.h gcsort.h job.h file.h sortfield.h condfield.h outrec.h parser.h scanner.h sumfield.h utils.h outfil.h gcshare.h
outrec_exe.o outrec_lib.o: gcsort.h fieldvalue.h utils.h job.h file.h outrec.h gcshare.h changefield.h findreplace.h
parser_exe.o parser_lib.o: gcsort.h file.h keyidxrel.h job.h sortfield.h condfield.h fieldvalue.h outrec.h inrec.h outfil.h sumfield.h utils.h gcshare.h datediff.h changefield.h join.h findreplace.h
scanner_exe.o scanner_lib.o: utils.h gcsort.h parser.h
sortfield_exe.o sortfield_lib.o: job.h sumfield.h gcsort.h utils.h gcshare.h
sumfield_exe.o sumfield_lib.o: sumfield.h gcsort.h utils.h job.h gcshare.h
symnames_exe.o symnames_lib.o: symnames.h gcshare.h gcsort.h job.h utils.h
utils_exe.o utils_lib.o: gcsort.h utils.h file.h outfil.h exitroutines.h gcshare.h
extsm.o: libgcs/libgcs.h gcshare.h EXTSM/extsm.h
libgcs_lib.o: gcshare.h gcsort.h gcthread.h job.h sortfield.h libgcs/libgcs.h file.h utils.h

# =========================================================================
# CLEANING AND TESTING
# =========================================================================
clean:
ifeq ($(OS),Windows_NT)
	$(CLEAN_CMD)
	if exist *_exe.o del /Q /F *_exe.o
	if exist *_lib.o del /Q /F *_lib.o
	if exist EXTSM.o del /Q /F EXTSM.o
	@if exist $(DIST_BIN) rmdir /S /Q $(DIST_BIN)
	@if exist $(DIST_LIB) rmdir /S /Q $(DIST_LIB)
	@echo --- Cleaning testlibgcs (Windows) ---
	if exist testlibgcs/testlibgcs.mak $(MAKE) -f testlibgcs/testlibgcs.mak clean
else
	$(CLEAN_CMD)
	-$(RM) *_exe.o *_lib.o EXTSM.o
	rm -rf $(DIST_BIN) $(DIST_LIB)
	@echo "--- Cleaning testlibgcs (Linux) ---"
	-$(MAKE) -f testlibgcs/testlibgcs.mak clean
endif

deploy:
	$(INSTALL) $(DIST_BIN)/$(TARGET) $(OUTDIR)
ifeq ($(OS),Windows_NT)
	$(INSTALL) $(DIST_BIN)/$(LIBGCS_DLL) $(OUTDIR)
else
	$(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) $(OUTDIR)
	@echo "Installing libgcs on Linux system..."
	sudo $(INSTALL) $(DIST_LIB)/$(LIBGCS_DLL) /usr/local/lib/
	sudo $(INSTALL) libgcs/libgcs.h /usr/local/include/
	sudo ldconfig
endif
	$(INSTALL) $(DIST_BIN)/$(EXTSM_DLL) $(OUTDIR)

check: all
	$(call MKDIR_CMD,tests/listing)
	$(call MKDIR_CMD,tests/log)
	cd tests/script && ./compile.sh || true
	cd tests/bin    && ./gctestset
	cd tests/bin    && ./gctestrun

cleanDebug:clean
cleanRelease:clean
