/* 
 *  Copyright (C) 2015 Sauro Menna - Mauro Balcerini
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

#include <io.h> 
#include "utils.h"
#include "BufferedReader.h"

struct BufferedReader_t* BufferedReaderConstructor( void )
{
	struct BufferedReader_t *BufferedReader=(struct BufferedReader_t *)malloc(sizeof(struct BufferedReader_t));
	BufferedReader->readbuf = (unsigned char*)calloc(MAX_BUFFER + 1, sizeof(unsigned char));
    BufferedReader->aux_eof_buf = BufferedReader->readbuf + MAX_BUFFER;
    BufferedReader->aux_readbuf = BufferedReader->aux_eof_buf;
    BufferedReader->offset = 0;
    BufferedReader->length = MAX_BUFFER;
    BufferedReader->num_bytes_read = 0;
    BufferedReader->file_length = 0;
    BufferedReader->actual_length = 0;
    BufferedReader->internal_handle = 0;
    BufferedReader->file_EOF = 0;
	BufferedReader->nTypeFile=0;
	BufferedReader->readed_length = 0;
	BufferedReader->nLenLastRecord = 0;

	return BufferedReader;
}

void BufferedReaderDestructor( struct BufferedReader_t *BufferedReader )
{
    free(BufferedReader->readbuf);
	BufferedReader=NULL;

	return;
}
void BufferedReader_SetFileType(struct BufferedReader_t *BufferedReader, int nType)
{
	BufferedReader->nTypeFile = nType;
}

int BufferedReader_GetFileType(struct BufferedReader_t *BufferedReader)
{
	return BufferedReader->nTypeFile;
}

int BufferedReader_open_file( struct BufferedReader_t *BufferedReader, char* filename)
{
    BufferedReader->internal_handle = _open(filename, O_RDONLY | O_BINARY);
    BufferedReader->actual_length = BufferedReader->file_length = _filelengthi64(BufferedReader->internal_handle);
    return BufferedReader->internal_handle;
}

void BufferedReader_getsize_file( struct BufferedReader_t *BufferedReader, int handle)
{
    BufferedReader->actual_length = BufferedReader->file_length = _filelengthi64(handle);
    return ;
}
void BufferedReader_Adjust_filesize( struct BufferedReader_t *BufferedReader, int64_t nPosAbs)
{
	BufferedReader->actual_length = BufferedReader->actual_length - nPosAbs;
    return ;
}

void BufferedReader_close_file(struct BufferedReader_t *BufferedReader)
{
    _close(BufferedReader->internal_handle);
	return;
}


INLINE int BufferedReader_FindCRLF(struct BufferedReader_t *BufferedReader, int* bFoundCRLF, int nLastPosKey)
{
	int len = 0;
	unsigned char* pPosChar;
	*bFoundCRLF=0;
	BufferedReader->aux_bof_buf = BufferedReader->aux_readbuf;
	if (BufferedReader->aux_eof_buf-BufferedReader->aux_bof_buf <= 0){
		*bFoundCRLF = 1;
		return len;
	}
	pPosChar = (unsigned char*)memchr ( (unsigned char*)BufferedReader->aux_bof_buf+nLastPosKey, 0x0a, (size_t)(BufferedReader->aux_eof_buf-BufferedReader->aux_bof_buf+nLastPosKey));
	if (pPosChar != NULL) {
		len = pPosChar - BufferedReader->aux_readbuf + 1 - NUMCHAREOL;
		BufferedReader->aux_bof_buf=BufferedReader->aux_bof_buf+len + NUMCHAREOL;
		*bFoundCRLF = 1;
	} 
	else
	{
		len = (BufferedReader->aux_eof_buf-BufferedReader->aux_bof_buf); //BufferedReader->actual_length - BufferedReader->readed_length;
		if (len > 0) 
			BufferedReader->aux_bof_buf=BufferedReader->aux_bof_buf+len;
	}
	return len;
}


INLINE void  BufferedReader_byn_next_record(struct BufferedReader_t *BufferedReader, int handle, int len_rec, int bIsFirstTime, unsigned char* szBuf)
{
	int len = 0;
	int bFoundCRLF=0;
	bFoundCRLF=0;
	if ((BufferedReader->readed_length+len_rec > MAX_BUFFER) || (bIsFirstTime == 1)){
		if (BufferedReader->file_EOF == 1) {
			BufferedReader->nLenLastRecord=0;
			return ;
		}
		BufferedReader->offset = BufferedReader->aux_eof_buf - BufferedReader->aux_readbuf;
		if (BufferedReader->offset > 0)
			memmove(BufferedReader->readbuf, BufferedReader->aux_readbuf, (int)BufferedReader->offset);
		else
			BufferedReader->offset = 0;
		BufferedReader->aux_readbuf = BufferedReader->readbuf;
		BufferedReader->num_bytes_read = _read(handle, BufferedReader->readbuf + BufferedReader->offset, (unsigned int) (MAX_BUFFER - BufferedReader->offset));

		BufferedReader->actual_length -= BufferedReader->num_bytes_read;
		if ((BufferedReader->actual_length <= 0)) //&& (BufferedReader->num_bytes_read <= 0))
		{
			BufferedReader->aux_eof_buf = BufferedReader->readbuf + BufferedReader->offset + BufferedReader->num_bytes_read;
			*BufferedReader->aux_eof_buf = '\0';
			BufferedReader->file_EOF = 1;
		}
		BufferedReader->readed_length = 0;
		if (BufferedReader->num_bytes_read <= 0){
			BufferedReader->file_EOF = 1;
			*BufferedReader->aux_eof_buf = '\0';
			*szBuf = '\0';
			return ;
		}
	}
	len = len_rec;
	BufferedReader->nLenLastRecord = len;

	if (len <= 0)
		return ;

	if ((BufferedReader->readed_length >= BufferedReader->num_bytes_read) && (BufferedReader->file_EOF == 1)){
		BufferedReader->nLenLastRecord = 0;
		*BufferedReader->aux_eof_buf = '\0';
		*szBuf = '\0';
		return;
	}
	BufferedReader->readed_length = BufferedReader->readed_length  + len;
	memmove(szBuf, BufferedReader->aux_readbuf, len);
	BufferedReader->aux_readbuf = BufferedReader->aux_readbuf + len;
	return;
}

INLINE void  BufferedReader_next_record(struct BufferedReader_t *BufferedReader, int handle, int len_rec, int bIsFirstTime, unsigned char* szBuf, int nLastPosKey)
{
	int len = 0;
	int bFoundCRLF=0;
	do 
	{
		bFoundCRLF=0;
		if ((BufferedReader->readed_length >= MAX_BUFFER) || (bIsFirstTime == 1)){
			if (BufferedReader->file_EOF == 1) {
				BufferedReader->nLenLastRecord=0;
				return ;
			}
			BufferedReader->offset = BufferedReader->aux_eof_buf - BufferedReader->aux_readbuf;
			if (BufferedReader->offset > 0)
				memmove(BufferedReader->readbuf, BufferedReader->aux_readbuf, (int)BufferedReader->offset);
			else
				BufferedReader->offset = 0;
			BufferedReader->aux_readbuf = BufferedReader->readbuf;
			BufferedReader->num_bytes_read = _read(handle, BufferedReader->readbuf + BufferedReader->offset, (unsigned int) (MAX_BUFFER - BufferedReader->offset));
			BufferedReader->actual_length -= BufferedReader->num_bytes_read;
			if (BufferedReader->actual_length <= 0)
			{
				BufferedReader->aux_eof_buf = BufferedReader->readbuf + BufferedReader->offset + BufferedReader->num_bytes_read;
				*BufferedReader->aux_eof_buf = '\0';
				BufferedReader->file_EOF = 1;
			}
			BufferedReader->readed_length = 0;
			if (BufferedReader->num_bytes_read <= 0){
				BufferedReader->file_EOF = 1;
				*BufferedReader->aux_eof_buf = '\0';
				*szBuf = '\0';
				return ;
			}
		}
		len = BufferedReader_FindCRLF(BufferedReader, &bFoundCRLF, nLastPosKey);
		if ((len == 1) && (bFoundCRLF == 0))
			len = 0;
		if ((BufferedReader->nTypeFile == FORG_LINESEQ) && (bFoundCRLF == 0) && (len > 0)) {
				BufferedReader->readed_length+=len;
				continue;
		}
		break;
	} while(BufferedReader->file_EOF == 0);
	BufferedReader->nLenLastRecord = len;
	if (len <= 0)
		return ;
	if ((BufferedReader->readed_length >= MAX_BUFFER) && (BufferedReader->file_EOF == 1)) {
		BufferedReader->nLenLastRecord = 0;
		*BufferedReader->aux_eof_buf = '\0';
		*szBuf = '\0';
		return;
	}
	BufferedReader->readed_length = BufferedReader->readed_length + len + NUMCHAREOL;
	memmove(szBuf, BufferedReader->aux_readbuf, len);
	BufferedReader->aux_readbuf = BufferedReader->aux_readbuf + len + NUMCHAREOL;
	return;
}

