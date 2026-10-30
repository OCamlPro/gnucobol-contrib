/*
    Copyright (C) 2016-2026 Sauro Menna
 *
 *	This file is part of GCSORT.
 *
 *  GCSORT is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GCSORT is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GCSORT.  If not, see <http://www.gnu.org/licenses/>.
*/ 
/*
Environment Variables Configuration
The naming convention remains completely clean. 

On Windows (Targeting .dll)
:: Preload the unified library into memory
set COB_PRELOAD=C:\path\to\libraries\EXTSM.dll

:: 1. Diciamo a GnuCOBOL quale libreria ospita il gestore dei verbi nativi
set COB_FILE_HANDLER=all_io

:: 2. Inseriamo la cartella corrente nel PATH per fare in modo che le 
set PATH=.;%PATH%

:: 3. Start COBOL program
il_tuo_programma.exe


export COB_PRELOAD=/opt/libs/libgcs.so:/opt/libs/EXTSM.so
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
export COB_LIBRARY_PATH=.:$COB_LIBRARY_PATH
*/
#ifndef EXTSM_H_INCLUDED
#define EXTSM_H_INCLUDED

/* --- BLOCCO DI PORTABILITÀ UNIVERSALE --- */
#if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#define EXTALL_API __declspec(dllexport)
#define COB_TARGET_CALL __cdecl
#else
#if defined(__GNUC__) && __GNUC__ >= 4
#define EXTALL_API __attribute__((visibility("default")))
#else
#define EXTALL_API
#endif
#define COB_TARGET_CALL
#endif

/* Enable debug */
#define EXTSM_DEBUG    /* 0 no (#undef), 1 active */
/* */
#undef EXTSM_DEBUG 
/* */

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <libcob.h> 

#ifdef _MSC_VER
#define _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif

/*
 EXTSM entry point (called directly by the COBOL CALL statement)
 */
GCSORT_API int EXTSM(unsigned char* func, FCD3* fcdin);

int  EXTSMGC_init(FCD3* fcd);
int  EXTSMGC_push_record(FCD3* fcd);
int  EXTSMGC_pop_record(FCD3* fcd);
int  EXTSMGC_sort_core(FCD3* fcd);
int  EXTSMGC_cleanup(void);

static int load_use_files(FCD3* fcd);
static int load_give_files(FCD3* fcd);
int get_key_definition(FCD3* fcd);

struct Job_tmpfile_t* gcs_tmpfile_init(struct job_t* job);
int gcs_tmpfile_get(struct job_t* job, struct Job_tmpfile_t* tmpf, FCD3* fcd);
void gcs_tmpfile_cleanup(struct job_t* job, struct Job_tmpfile_t* tmpf);

static void free_all(void);

/* debug */
void dump_fcd_structure(const FCD3* fcd, const char* label);
    /* */


char* utils_getExtsmFieldTypeName(EXTKEY* componente, int* out_is_descending);


#endif /* EXTSM_H_INCLUDED   */