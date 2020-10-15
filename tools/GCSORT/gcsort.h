/*
    Copyright (C) 2016-2019 Sauro Menna
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

#define _CRT_NONSTDC_NO_DEPRECATE 

// x64 ini

#ifdef	_MSC_VER
#ifdef VBISAM_LIB
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
// x64 end



#define GCSORT_ALLOCATE				50
#define GCSORT_ALLOCATE_MEMSIZE		512000000 
#define GCSORT_MAX_BUFF_REK			32768+SZPOSPNT

// value 1 : generate temp file fixed name : cob17, cob18, cob19, cob1a, cob1b
#define GCSORT_DEBUG                0  // 0 no debug - 1 debug
#define GCSORT_TESTCMD 0
#define GCSORT_VERSION "01.01.00"
#define GCSORT_TAR_DATE "Oct 15 2020 18:21:00 UTC"

// Return Code
#define OC_RTC_OK	 0
#define OC_RTC_ERROR 16


// Variables
char szMexToken[260];


void GCSORT_Config( void );
void GCSORT_Usage ( void ) ;
void GCSORT_Version( void ) ;

#endif // GCSORT_H_INCLUDED
