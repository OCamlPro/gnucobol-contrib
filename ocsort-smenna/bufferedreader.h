/*
 *  Copyright (C) 2016 Sauro Menna / Mauro Balcerini
 *
 *	This file is part of OCSort.
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
#ifndef BUFFEREDREADER_H_INCLUDED
#define BUFFEREDREADER_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

//#ifdef	_WIN32
#ifdef _MSC_VER
	#include <windows.h>
	#include <io.h>
	#include <fcntl.h>
	#include <sys/types.h>
	#include <sys/stat.h>
#else
	#if !defined(__MINGW32__) && !defined(__MINGW64__)
		 #include <sys/io.h>
		 #include <sys/types.h>
		 #include <sys/stat.h>
    #endif
	#include <unistd.h>
#endif
#include "job.h"

#define MAX_BUFFER			65536*62 //65536*124
//-->>#define MAX_WORK_BUFFER		4096
#define MAX_LEN_REK_AREA	32768

struct BufferedReader_t
{
        unsigned char* readbuf;
        unsigned char* aux_eof_buf;
        unsigned char* aux_bof_buf;
        unsigned char* aux_readbuf;
		
		int nTypeFile;  
        int64_t offset; // = 0;
        int64_t length; // = MAX_BUFFER;
        int64_t num_bytes_read;// = 0;
        int64_t file_length;// = 0;
        int64_t actual_length;// = 0;
        int64_t readed_length;// = 0;
		int64_t nLenLastRecord;

        int internal_handle; // = NULL;
        int file_EOF;// = false;  true 1 false 0
};

struct BufferedReader_t* BufferedReaderConstructor( void );
void BufferedReaderDestructor( struct BufferedReader_t *BufferedReader );
int BufferedReader_open_file( struct BufferedReader_t *BufferedReader, char* filename);
void BufferedReader_close_file(struct BufferedReader_t *BufferedReader);
void BufferedReader_SetFileType(struct BufferedReader_t *BufferedReader, int nType);
int BufferedReader_GetFileType(struct BufferedReader_t *BufferedReader);
void BufferedReader_Adjust_filesize( struct BufferedReader_t *BufferedReader, int64_t nPosAbs);

void BufferedReader_getsize_filefromName( struct BufferedReader_t *BufferedReader, char* filename);

extern INLINE int BufferedReader_FindCRLF(struct BufferedReader_t *BufferedReader, int* bFoundCRLF, int nLastPosKey);
extern INLINE void  BufferedReader_next_record(struct BufferedReader_t *BufferedReader, int handle, int len_rec, int bIsFirstTime, unsigned char* szBuf, int nLastPosKey);
extern INLINE void  BufferedReader_byn_next_record(struct BufferedReader_t *BufferedReader, int handle, int len_rec, int bIsFirstTime, unsigned char* szBuf);


#endif // BUFFEREDREADER_H_INCLUDED
