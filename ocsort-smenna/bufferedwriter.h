/* 
 *  Copyright (C) 2009 Cedric ISSALY
 *  Copyright (C) 2015 Sauro Menna
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
#ifndef BUFFEREDWRITER_H_INCLUDED
#define BUFFEREDWRITER_H_INCLUDED
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>

/*
INLINE int write_buffered (int  desc, int buffer_pointer, int  nLenRek, int  bufferwriteglobal, int* position_buf_write);
INLINE int write_buffered_save_final (int  desc, int buffer_pointer, int  nLenRek, int  bufferwriteglobal, int* position_buf_write);
INLINE int write_buffered_final (int  desc, int  buffer_pointer, int  nLenRek, int  bufferwriteglobal, int* position_buf_write);
*/
INLINE int write_buffered (int		desc, 
		            int		buffer_pointer, 
			        int		nLenRek, 
				    int		bufferwriteglobal,
					int*	position_buf_write
					)
{
	int nSplit;
    int tempPosition = *position_buf_write + nLenRek;  
    if (tempPosition > MAX_SIZE_CACHE_WRITE) {
		if (_write(desc, (unsigned char*)(bufferwriteglobal), (unsigned int) *position_buf_write) < 0) 
		{
    		fprintf(stderr,"*OCSort*S069* Cannot write output file  %s\n",strerror(errno));
    		return -1;
		}
    	*position_buf_write=0;
    }
	nSplit = *position_buf_write;
	memmove((unsigned char*)bufferwriteglobal+nSplit, (unsigned char*)buffer_pointer, nLenRek);
   *position_buf_write=*position_buf_write+nLenRek;
    return 0;
}

INLINE int write_buffered_save_final (int		desc, 
		            int		buffer_pointer, 
			        int		nLenRek, 
				    int		bufferwriteglobal,
					int*	position_buf_write
					)
{
    if (*position_buf_write + nLenRek > MAX_SIZE_CACHE_WRITE_FINAL) {
    	if (_write(desc, (unsigned char*)(bufferwriteglobal), (unsigned int) *position_buf_write) < 0) 
    	{
    		fprintf(stderr,"*OCSort*S070* Cannot write output file  %s\n",strerror(errno));
    		return -1;
    	}
    	*position_buf_write=0;
    }
	memmove((unsigned char*)bufferwriteglobal+(*position_buf_write), (unsigned char*)buffer_pointer, nLenRek);
   *position_buf_write=*position_buf_write+nLenRek;
    return 0;
}

INLINE int write_buffered_final (int  desc, 
						int		buffer_pointer, 
						int		nLenRek, 
						int  bufferwriteglobal,
						int*	position_buf_write
					)
{
	if (*position_buf_write == 0)
		return 0;
    if (write(desc, (unsigned char*)bufferwriteglobal , *position_buf_write) < 0) 
    {
    	fprintf(stderr,"*OCSort*S040* Cannot write output file  %s\n",strerror(errno));
    	return -1;
    }
	*position_buf_write=0;
    return 0;
}


#endif // BUFFEREDWRITER_H_INCLUDED
