/*
 *  Copyright (C) 2016 Sauro Menna
 *
 *	This file is part of ocsort_gentestcase.
 *
 *  OCSort is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  OCSort is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with OCSort.  If not, see <http://www.gnu.org/licenses/>.

*/
#ifndef _OCSORT_GENTESTCASE_H_
#define _OCSORT_GENTESTCASE_H_
//#ifdef _WIN32

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <windows.h>
#endif

#if	defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <fcntl.h> 
	#include <windows.h>
	#include <io.h>
	#include <sys\types.h>
	#include <sys\stat.h>
#else
	#include <limits.h>
	#include <sys/io.h>
	#include <sys/stat.h>
	#include <time.h>
	#include <fcntl.h>
	#include <errno.h>
	#include <unistd.h>
#endif

#define   GEN_TYPE_ALL			0
#define   GEN_TYPE_CHARUPP		1
#define   GEN_TYPE_CHARLOW		2
#define   GEN_TYPE_CHARALL		3
#define   GEN_TYPE_NUMBER		4
#define   GEN_TYPE_SIGN			5

#define	  MAX_RECORD		32768
#define	  SIZEINT64				8
#define	  FIELD_TYPE_BINARY		1
#define	  FIELD_TYPE_FIXED		4



#if	defined(__GNUC__) && !defined(__MINGW32__) && !defined(__MINGW64__)
	#if !defined(__MINGW32__) && !defined(__MINGW64__)
		typedef int HANDLE;
		#define INVALID_HANDLE_VALUE 0
		#define _S_IREAD	S_IREAD
		#define _S_IWRITE	S_IWRITE

		#define _O_TRUNC 	O_TRUNC
		#define _O_RDONLY	O_RDONLY
		#define _O_CREAT 	O_CREAT 
		#define _O_BINARY 	O_BINARY
		#define O_BINARY 	0
		#define _O_WRONLY   O_WRONLY

		#define _strtoll   strtoll
	#endif
#else
	#define _strtoll    _strtoi64

#endif



struct key_t {
	int		pos;
	int		len;
	int		iskey;
	int		seqkey;
	char    order[5];
	char	type[12];
	char	value[128];
} keysort;

struct params_t {
	char PgmCheckData[50];
	char PgmCheckSort[50];
	char ScriptName[50];
	char PathGen[FILENAME_MAX];
	char PathSrc[FILENAME_MAX];
	char PathTake[FILENAME_MAX];
	char PathBatsh[FILENAME_MAX];
	char Config[FILENAME_MAX];
	char szFileName[80];
	char szOrg[10];
	char szRec[10];
	int	 nLenMin, nLenMax;
	int  nMaxFields;
	unsigned long  nNumRec;
	int  byteorder;
	int  nNumKeys;
} params;


char gen_char ( int nT ) ;
int	read_fileCFG ( char* szCmdLine, struct params_t* params, struct key_t** pKey  );
int print_paramCFG (FILE* pFile, struct params_t* params, struct key_t** pKey );
int writeHeader (FILE* pFile, struct params_t* params, struct key_t** pKey );
int generate_file ( struct params_t* params, struct key_t** pKey );
int generate_Takefile ( struct params_t* params, struct key_t** pKey );
int destroy_paramCFG ( struct params_t* params, struct key_t** pKey );
void Usage ( void );
void CreateExampleFileConfig (void );
int Sort_Fields ( struct params_t* params, struct key_t** pKey );
int compare4qsort (const void *first, const void *second);
int check_param( struct params_t* params, struct key_t** pKey );
void write_line(FILE* pFile, char* pBuf);
#endif //_OCSORT_GENTESTCASE_H_
