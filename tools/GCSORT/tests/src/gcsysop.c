/*
    Copyright (C) 2016-2020 Sauro Menna
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
#include <stdio.h>
#include <stdlib.h>
#if defined(_WIN32) && ( !defined(__MINGW32__) && !defined(__MINGW64__))

	#ifdef	_MSC_VER
	#pragma warning(disable: 4800)
	#endif

	#if defined (__cplusplus)
		#include <mpirxx.h>
		#else
		#include <mpir.h>
	#endif

	#include <libcob/common.h>

#else
#include <gmp.h>
#ifdef __cplusplus
extern "C" {
#endif
#include <libcob/common.h>
#ifdef __cplusplus
}
#endif
#endif 



int gcsysop(void) ;
int main(int argc, char *argv[]) {
    FILE * fp;
    
    char *ver = malloc(256);
    int nret=gcsysop();
    printf("gcsysop - Get System Type  : %d       \n", nret);
    #ifdef __LIBCOB_RELEASE
	    printf("gcsysop - GNUCobol version : %0.9d\n", __LIBCOB_RELEASE);
    #endif
    
    fp = fopen ("gcsysoprun.txt", "w+");
    fprintf(fp, "%d\n", nret);
    #ifdef __LIBCOB_RELEASE
	    fprintf(fp, "%.9d\n", __LIBCOB_RELEASE);
    #else
    	    fprintf(fp, "000020200\n");
    #endif
    fclose(fp);
    return nret;
}

int gcsysop(void) {
int systype = 0;
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
    systype = 1;
   /* define something for Windows (32-bit and 64-bit, this part is common) */
   #ifdef _WIN64
      /* define something for Windows(64 - bit only) */
   #else
      /* define something for Windows (32-bit only)  */   
   #endif
#elif __APPLE__
    systype = 4;
    #include <TargetConditionals.h>
    #if TARGET_IPHONE_SIMULATOR
         /* iOS Simulator */
    #elif TARGET_OS_IPHONE
        /* iOS device */
    #elif TARGET_OS_MAC
        /* Other kinds of Mac OS */
    #else#include <stdlib.h>
    #   error "Unknown Apple platform"
    #endif#include <stdlib.h>
#elif __linux__
    systype = 2;
    /* linux */
#elif __unix__ // all unices not caught above
    /* Unix */
    systype = 3;
#elif defined(_POSIX_VERSION)
    /* POSIX */
    systype = 5;
#else
#   error "Unknown compiler"
    systype = -1;
#endif

/* printf("%d\n", systype); */

return systype;
}