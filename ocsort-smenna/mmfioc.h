/*
 *  Copyright (C) 2014 Geoff McLane

 *  Copyright (C) 2016 Sauro Menna
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

#ifndef _MMFIOC_H_
#define _MMFIOC_H_
//#ifdef _WIN32

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <windows.h>
#endif
#include <math.h>
#include <stdint.h>
#include <string.h>

#include "job.h"
#include "utils.h"

#define MMF_ERR_ZERO_BYTE_FILE           "Cannot open zero byte file."
#define MMF_ERR_INVALID_SET_FILE_POINTER "The file pointer cannot be set to specified location."
#define MMF_ERR_WRONG_OPEN               "Close previous file before opening another."
#define MMF_ERR_OPEN_FILE                "Error encountered during file open."
#define MMF_ERR_CREATEFILEMAPPING        "Failed to create file mapping object."
#define MMF_ERR_MAPVIEWOFFILE            "Failed to map view of file."
#define MMF_ERR_SETENDOFFILE             "Failed to set end of file."
#define MMF_ERR_INVALIDSEEK              "Seek request lies outside file boundary."
#define MMF_ERR_WRONGSEEK                "Offset must be negative while seeking from file end."


enum SEEKPOS
{
	SP_BEGIN = 0,
	SP_CUR,
	SP_END,
};

enum OPENFLAGS
{
	OPN_READ = 0, //Opens the file for reading only
	OPN_READWRITE, //Opens the file for reading and writing
	OPN_WRITE	  //Opens the file for writing
};


struct mmfio_t
{
	unsigned char		m_cRefCount;
	enum OPENFLAGS		m_eOpenflags;
//#ifdef _WIN32
#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	void*				m_hFileMapping;
#else
	int				m_hFileMapping;
#endif
	unsigned char*		m_pbFile;
	int64_t				m_dwBytesInView;
	int64_t				m_qwFileSize;
	int64_t				m_nViewBegin;
	int64_t				m_nCurPos;
	int64_t				m_nSeekPos;
//#ifdef _WIN32
#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	void*				m_hFile;
#else
	int					m_hFile;
#endif
	unsigned long		m_dwAllocGranularity;
	long				m_lExtendOnWriteLength;
	unsigned long		m_dwflagsFileMapping;
	unsigned long		m_dwflagsView;
	int					m_bFileExtended;
	int64_t				maxsize;
	char				m_strErrMsg[256];
	long				m_lHowManyUnmap;
	int64_t				nDataEndPos; 
	int64_t				_N ;
	int64_t				nCount;
	int64_t				nViewEndPos;
	unsigned char*		pBufRead;
	int					nReadBytes ;
	int					nWriteBytes;

	//unsigned char*		pBufData;

};

struct mmfio_t* mmfio_constructor( void );
void   mmfio_destructor(struct mmfio_t* mmf);
uint64_t mmfio_GetPosition(struct mmfio_t* mmf);
int mmfio_SeekRead(void* pBuf, int64_t lOffset, int nCountIn, struct mmfio_t* mmf);
int mmfio_Open(const unsigned char*  strfile, enum OPENFLAGS oflags,int64_t maxsize, struct mmfio_t*);
int mmfio_Close(struct mmfio_t*);
uint64_t mmfio_GetLength(struct mmfio_t* mmf);
long mmfio_GetHowManyUnMap( struct mmfio_t* mmf );

extern INLINE int mmfio_seek(int64_t lOffset, enum SEEKPOS eseekpos, struct mmfio_t** mmf);

extern INLINE int mmfio_Seek(int64_t lOffset, enum SEEKPOS eseekpos, struct mmfio_t* mmf);

extern INLINE int mmfio_Read(unsigned char* pBuf, int nCountIn, struct mmfio_t** mmf);



#endif // _MMFIOC_H