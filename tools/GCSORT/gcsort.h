/*
    Copyright (C) 2016-2024 Sauro Menna
    Copyright (C) 2009 Cedric ISSALY
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

#ifndef GCSORT_H_INCLUDED
#define GCSORT_H_INCLUDED

#include "libgcsort.h"

#define _CRT_NONSTDC_NO_DEPRECATE 

/* x64 ini  */
#ifdef	_MSC_VER
#ifdef VBISAM_LIB
_LIB
#ifdef __cplusplus
#define DLL_EXPIMP extern "C" __declspec(dllexport)
#else
#define DLL_EXPIMP extern __declspec(dllexport)
#endif
#else
#ifdef __cplusplus
#define DLL_EXPIMP extern "C" __declspec(dllimport)
#else
#define DLL_EXPIMP extern __declspec(dllimport)
#endif
#endif
#else
#ifdef __cplusplus
#define DLL_EXPIMP extern "C"
#else
#define DLL_EXPIMP extern
#endif
#endif
/* x64 end */

#define GCSORT_NEWFEATURES              /* 0=Disable, 1=Enable - DISABLE release */
#undef  GCSORT_NEWFEATURES             

/* GCSDEBUG   used to view info details Scanner-Parser - DISABLE release*/
#define GCSDEBUG 
    /* */
#undef  GCSDEBUG 
    /* */


/* GCSTHREAD   used to view info details Thread - DISABLE release*/
#define GCSTHREAD 
    /* */
#undef  GCSTHREAD
   /* */

#if defined(snprintf) && defined(_MSC_VER) 
        #undef snprintf
#endif

#define GCSORT_ALLOCATE				50
#define GCSORT_ALLOCATE_MEMSIZE		512000000 
/* to debug #define GCSORT_ALLOCATE_MEMSIZE		512000  */

#define GCSORT_MAX_BUFF_REK			32768+SZPOSPNT

#define GCSORT_KEY_MAX              1024
#define GCSORT_SIZE_FILENAME        1024

#define GCSORT_SIZE_ENVVAR          256

/* value 1 : generate temp file fixed name : cob17, cob18, cob19, cob1a, cob1b  */
#define GCSORT_DEBUG   0        /* 0 no debug - 1 debug */
#define GCSORT_TESTCMD 0
#define GCSORT_VERSION "01.04.05"
#define GCSORT_TAR_DATE "Jan 14 2025 20:00:00 UTC"

/* Return Code */
#define GC_RTC_OK	 0
#define GC_RTC_WARN	 4
#define GC_RTC_ERROR 16

#define GC_MAX_THREADS 16

#if	!defined(_MSC_VER) /* defined(__MINGW32__) || defined(__MINGW64__)  */
#define strtok_s __strtok_r
#endif

/* start - compatibility version 3.1 and 4.0 */
#if !defined (__LIBCOB_VERSION)
    /* CHECKME: does this work and pass tests? */
    #define  COB_PACKAGE_VERSION	"2.2"
#elif __LIBCOB_VERSION >= 4
    #define flag        tf_ascending
    #define linorkeyptr linage
    #define  COB_PACKAGE_VERSION	"3.2"
#elif __LIBCOB_VERSION_MINOR >= 2   /* < 4 ==> 3.1+*/
    #define  COB_PACKAGE_VERSION	"3.2"
#else
    #define  COB_PACKAGE_VERSION	"3.1.2"
#endif
/*  end - compatibility version 3.1 and 4.0 */


void GCSORT_Config( void );
void GCSORT_Usage ( unsigned char* cmd) ;
void GCSORT_Version( void ) ;
void verify_options(int numargs, char** args);
void GCSORT_Usage_all(void);
void gcsort_help_header(void);
void gcsort_help_header2(void);
void gcsort_help_body_SMC(void);
void gcsort_help_body_JOIN(void);
void gcsort_help_footer(void);

#endif /* GCSORT_H_INCLUDED */
