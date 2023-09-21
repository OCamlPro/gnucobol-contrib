/*
   Copyright (C) 2023 Chuck Haatvedt

   This file is part of GnuCOBOL contribution "F-VFILES"

   F-VFILES is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License
   as published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   F-VFILES is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with F-VFILES.  If not, see <https://www.gnu.org/licenses/>.
*/


#ifdef ALT_NAME
   #define  CBL_OPEN_VFILE         CWH_OPEN_VFILE
   #define  CBL_READ_VFILE         CWH_READ_VFILE
   #define  CBL_WRITE_VFILE        CWH_WRITE_VFILE
   #define  CBL_CLOSE_VFILE        CWH_CLOSE_VFILE
#ifdef  _WIN32
   #define  CBL_MEMORY_STATUS      CWH_MEMORY_STATUS
   #define  CBL_CPU_CYCLES         CWH_CPU_CYCLES
#endif
   #define  CBL_GET_HEAP_POINTER   CWH_GET_HEAP_POINTER
   #define  CBL_START_TIME         CWH_START_TIME
   #define  CBL_TIME_DIFF          CWH_TIME_DIFF
   #define  CBL_SPLIT_FILENAME     CWH_SPLIT_FILENAME
   #define  CBL_VFILES             CWH_VFILES
#endif


#include <windows.h>
#include <stdio.h>
#include <psapi.h>
#include <malloc.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <sys\timeb.h>
#include <libcob.h>

   typedef struct _SPLITPATH
   {
    short  parameter_length;
    short  split_join_flag_1;
    short  split_join_flag_2;
    short  relative_address_of_device_name;
    short  device_name_length;
    short  relative_address_of_basic_name;
    short  basic_name_length;
    short  relative_address_of_extension;
    short  extension_length;
    short  total_length;
    short  split_name_buffer_size;
    short  joined_name_buffer_size;
    short  length_of_first_path_name_component;
   }SPLITPATH, *PSPLITPATH;


   typedef struct _POINTER
   {
       void                *ptr_void;
   }POINTER,   *PPOINTER;


   typedef struct _BIT_DATA
   {
       unsigned char bit_4hi : 4;
       unsigned char bit_4lo : 4;
   }BIT_DATA,   *PBIT_DATA;

#pragma scalar_storage_order big-endian

   typedef struct _BITS
   {
       unsigned char bit_7   : 1;
       unsigned char bit_6   : 1;
       unsigned char bit_5   : 1;
       unsigned char bit_4   : 1;
       unsigned char bit_3   : 1;
       unsigned char bit_2   : 1;
       unsigned char bit_1   : 1;
       unsigned char bit_0   : 1;
   }BITS,   *PBITS;

#pragma scalar_storage_order default

//
// ======> note that the _SEG structure is
//         actually just the header of the
//         segment, the segment data
//         is located after the header
//         add is addressed via a void pointer
//
   typedef struct _SEG_HDR
   {
       char            eye_ball[10];
       short           heap_id;
       struct _SEG_HDR *ptr_prev_seg;
       struct _SEG_HDR *ptr_next_seg;
       int             seg_num;
       int             seg_size;
       int             seg_data_size;
       int             seg_data_rel_start;
       int             seg_data_rel_end;
   }SEG_HDR,        *PSEG_HDR;

   typedef struct _HEAP_ENTRY
   {
       char            eye_ball[10];
       short           heap_id;
       PSEG_HDR        ptr_seg_first;
       PSEG_HDR        ptr_seg_last;
       int             seg_count;
       int             total_alloc;
       int             total_data_alloc;
   }HEAP_ENTRY,    *PHEAP_ENTRY;

//   prototypes for CBL called functions.

/* You should define ADD_EXPORTS *only* when building the DLL. */
   #define ADDAPI __declspec(dllexport)

/* Define calling convention in one place, for convenience. */
   #define ADDCALL __cdecl

   #define MAX_HEAP                        512
   #define DEFAULT_ALLOC                   64

//
// =======> DEFINE ERROR CODES.
//
   #define MISSING_VOPEN                   1
   #define NO_HEAP_FOUND                   2
   #define INSUFFICIENT_MEMORY             3
   #define ERROR_BEFORE_RELATIVE_LOC_1     4
   #define ERROR_OUT_OF_DATA_RANGE         5
   #define HEAP_OUT_BOUNDS                 6
   #define MISSING_VFILE_OPEN              7
   #define MISSING_START_TIME              8
   #define PATH_EXCEEDS_MAX                4

/* Make sure functions are exported with C linkage under C++ compilers. */

#ifdef __cplusplus
extern "C"
{
#endif

   ADDAPI int ADDCALL  CBL_OPEN_VFILE(void *a, void *b);
   ADDAPI int ADDCALL  CBL_READ_VFILE(short a, int b, int c, void *d);
   ADDAPI int ADDCALL  CBL_WRITE_VFILE(short a, int b, int c, void *d);
   ADDAPI int ADDCALL  CBL_CLOSE_VFILE(short a);
#ifdef  _WIN32
   ADDAPI int ADDCALL  CBL_MEMORY_STATUS(void *a);
   ADDAPI int ADDCALL  CBL_CPU_CYCLES(void *a);
#endif
   ADDAPI int ADDCALL  CBL_GET_HEAP_POINTER(void *a);
   ADDAPI int ADDCALL  CBL_START_TIME();
   ADDAPI int ADDCALL  CBL_TIME_DIFF(void *a);
   ADDAPI int ADDCALL  CBL_SPLIT_FILENAME(void *a, void *b);

   ADDAPI int ADDCALL  CBL_VFILES();
   ADDAPI void ADDCALL DUMP_HEX(void *source, int length);

#ifdef __cplusplus
} // __cplusplus defined.
#endif


//   prototypes for miscellaneous internal functions


   int  CREATE_FIRST_SEGMENT(PHEAP_ENTRY ptr_a);
   int  GET_NEW_SEGMENT(PHEAP_ENTRY ptr_a, PSEG_HDR ptr_b);
   int  LOCATE_SEGMENT(unsigned short heap,
                       unsigned int   data_loc,
                       unsigned int   data_len,
                       void           *data_buffer);
   void PRINT_HEAP_ENTRY(PHEAP_ENTRY ptr_a);
   void PRINT_SEG_HDR(PSEG_HDR ptr_b);
   void GET_DEFAULT_ALLOC();

   char                    *ptr_char;
   int                     return_code;
   int                     last_error;
   static FILE             *fptr_log;
   static int              got_start_time  = FALSE;
   static int              diagnostic  = FALSE;
   static int              first_vopen = TRUE;
   static int              first_time  = TRUE;
   static int              vfile_read  = FALSE;
   static int              alloc_init  = FALSE;
   static int              search_down = FALSE;
   static unsigned int     default_alloc;

   HEAP_ENTRY      heap_array[MAX_HEAP];
   PHEAP_ENTRY     ptr_heap;
   PSEG_HDR        ptr_seg;

   struct timeb t_start, t_current;


//
//     CALL "CBL_OPEN_VFILE"
//         USING heap-ID
//               heap-status
//         RETURNING status-code.
//

/* ============================================ */
/* Wrapper for CBL_OPEN_VFILE                  */
/* ============================================ */

int CBL_OPEN_VFILE(void *a, void *b)
{

   short           heap;

   return_code = 0;

   if (first_time == TRUE)
   {
       first_time = FALSE;
       if ((ptr_char = getenv("CBL_DIAGNOSTIC")) == NULL)
       {
//         continue;
       }
       else if (strcmp(ptr_char, "ON") == 0)
       {
           fptr_log = fopen("VFILE-DIAGNOSTIC.LOG", "w");
           fprintf(fptr_log, " \n  In CBL_OPEN_VFILE function     \n\n");
           fprintf(fptr_log, "CBL_DIAGNOSTIC is %s \n", ptr_char);
           fprintf(fptr_log, "Setting diagnostic to TRUE \n");
           fflush(fptr_log);
           diagnostic = TRUE;
       }
   }
//
// if first vfile open then initial heap_array
//
   if (first_vopen == TRUE)
   {
       first_vopen = FALSE;
       GET_DEFAULT_ALLOC(&default_alloc);
       ptr_heap = &heap_array[0];
       for(heap = 0; heap < MAX_HEAP; heap++, ptr_heap++)
       {
           memcpy((void *)&ptr_heap->eye_ball ,"HEAP ENTRY", 10);
           ptr_heap->heap_id          = heap + 1;
           ptr_heap->ptr_seg_first    = NULL;
           ptr_heap->ptr_seg_last     = NULL;
           ptr_heap->seg_count        = 0;
           ptr_heap->total_alloc      = 0;
           ptr_heap->total_data_alloc = 0;
       }
   }
//
// find next available heap id
//
   ptr_heap = &heap_array[0];
   for(heap = 0; heap < MAX_HEAP && ptr_heap->ptr_seg_first != NULL; ptr_heap++, heap++)
   {
   }
   if (heap < MAX_HEAP)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, " found unused heap_id %03hd \n", ptr_heap->heap_id);
           fflush(fptr_log);
       }
   }
   else
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, " No unused heap_id found \n");
           fflush(fptr_log);
       }
       memcpy(b, "99", 2);
       return(NO_HEAP_FOUND);
   }

// a  = COB_BSWAP_16(&ptr_heap->heap_id);
   memcpy(a, &ptr_heap->heap_id, sizeof(heap));
   memcpy(b, "00", 2);
   return_code = CREATE_FIRST_SEGMENT(ptr_heap);

   if (return_code != 0)
       memcpy(b, "99", 2);

   return(return_code);
}


int CBL_READ_VFILE(short a, int b, int c, void *d)
{
   if (first_vopen == TRUE)
       return(MISSING_VFILE_OPEN);

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  In CBL_READ_VFILE function \n\n");
       fprintf(fptr_log, " a     is %04hu    ", a);
       DUMP_HEX(&a, 2);
       fprintf(fptr_log, " b is %07u ",b);
       DUMP_HEX(&b, 4);
       fprintf(fptr_log, " c is %07u ",c);
       DUMP_HEX(&c, 4);
       fflush(fptr_log);
   }

   vfile_read = TRUE;
   return_code = LOCATE_SEGMENT(a, b, c, d);
   return(return_code);
}


int CBL_WRITE_VFILE(short a, int b, int c, void *d)
{
   if (first_vopen == TRUE)
       return(MISSING_VFILE_OPEN);

// if ((diagnostic == TRUE) && ( b < 0))
   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  In CBL_WRITE_VFILE function \n\n");
       fprintf(fptr_log, " a     is %04hu    ", a);
       DUMP_HEX(&a, 2);
       fprintf(fptr_log, " b is %7u ",b);
       DUMP_HEX(&b, 4);
       fprintf(fptr_log, " c is %7u ",c);
       DUMP_HEX(&c, 4);
       fflush(fptr_log);
   }

   vfile_read = FALSE;
   return_code = LOCATE_SEGMENT(a, b, c, d);
   return(return_code);
}


int CBL_CLOSE_VFILE(short a)
{
   PSEG_HDR    ptr_seg_delete;
   void        *ptr_void;
   int         sub;
   short       heap;

   heap    = a;

   if (first_vopen == TRUE)
       return(MISSING_VFILE_OPEN);

   return_code = 0;

   if (heap < 0 || heap > MAX_HEAP)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, " heap out of bounds %03hu \n", heap);
           DUMP_HEX(&heap, 2);
       }
       return(HEAP_OUT_BOUNDS);
   }


//
// =====> first locate HEAP_ENTRY
//
   sub                        = (int)(heap - 1);
   ptr_void                   = &heap_array[sub];
   ptr_heap                   = ptr_void;
   ptr_seg                    = ptr_heap->ptr_seg_first;

   while (ptr_seg != NULL)
   {
       ptr_seg_delete = ptr_seg;
       ptr_seg        = ptr_seg->ptr_next_seg;
       free(ptr_seg_delete);
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "Free of Heap ID %03hu  segment address %p \n", heap, ptr_seg_delete);
       }
   }

   ptr_heap->ptr_seg_first    = NULL;
   ptr_heap->ptr_seg_last     = NULL;
   ptr_heap->seg_count        = 0;
   ptr_heap->total_alloc      = 0;
   ptr_heap->total_data_alloc = 0;
   return(return_code);
}


int  CBL_CPU_CYCLES(void *a)
{
   DWORD   processID;
   HANDLE  hProcess;
   UINT64  clock_cycles;
   UINT64  *ptr_clock_cycles;
   UINT64  *ptr_cycle_time;

   ptr_cycle_time  = &clock_cycles;
   ptr_clock_cycles    = (UINT64 *)a;

   processID = GetCurrentProcessId();

   if (diagnostic == TRUE)
        fprintf(fptr_log, "\nProcess ID: %lu\n", processID);

   hProcess = OpenProcess(  PROCESS_QUERY_INFORMATION |
                                    PROCESS_VM_READ,
                                    FALSE, GetCurrentProcessId() );
   if (NULL == hProcess)
        return(99);

   return_code = (int)QueryProcessCycleTime(hProcess, ptr_cycle_time);

   if (return_code)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CPU clock cycles ==> %llu \n", *ptr_cycle_time);
       }
       *ptr_clock_cycles  = *ptr_cycle_time;
   }
   else
   {
       last_error = GetLastError();
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "QueryProcessCycleTime bad error code is %d \n", last_error);
           fprintf(fptr_log, "return_code is %d \n", return_code);
           fflush(fptr_log);
           return(last_error);
       }
   }

   return(0);
}


int  CBL_MEMORY_STATUS(void *a)
{
   DWORD     processID;
   HANDLE  hProcess;
   PROCESS_MEMORY_COUNTERS pmc;

   pmc.cb = (DWORD)sizeof (pmc);
   if (diagnostic == TRUE)
       fprintf(fptr_log, " Size of PROCESS_MEMORY_COUNTERS ==> %d \n", sizeof(pmc));

   processID = GetCurrentProcessId();

// Print the process identifier.

   if (diagnostic == TRUE)
        fprintf(fptr_log, "\nProcess ID: %lu\n", processID);

    // Print information about the memory usage of the process.

    hProcess = OpenProcess(  PROCESS_QUERY_INFORMATION |
                                    PROCESS_VM_READ,
                                    FALSE, GetCurrentProcessId() );
    if (NULL == hProcess)
        return(99);

    return_code = GetProcessMemoryInfo( hProcess, &pmc, sizeof(pmc));
//  return_code = GetProcessMemoryInfo( hProcess,(PPROCESS_MEMORY_COUNTERS)&pmc, (DWORD)sizeof(pmc));

   if (return_code)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "\tStructure size:             0x%08lX\n",
                     pmc.cb );
           fprintf(fptr_log, "\tPageFaultCount:             0x%08lX\n",
                     pmc.PageFaultCount );
           fprintf(fptr_log, "\tPeakWorkingSetSize:         0x%08lX\n",
                     pmc.PeakWorkingSetSize );
           fprintf(fptr_log, "\tWorkingSetSize:             0x%08lX\n",
                     pmc.WorkingSetSize );
           fprintf(fptr_log, "\tQuotaPeakPagedPoolUsage:    0x%08lX\n",
                     pmc.QuotaPeakPagedPoolUsage );
           fprintf(fptr_log, "\tQuotaPagedPoolUsage:        0x%08lX\n",
                     pmc.QuotaPagedPoolUsage );
           fprintf(fptr_log, "\tQuotaPeakNonPagedPoolUsage: 0x%08lX\n",
                     pmc.QuotaPeakNonPagedPoolUsage );
           fprintf(fptr_log, "\tQuotaNonPagedPoolUsage:     0x%08lX\n",
                     pmc.QuotaNonPagedPoolUsage );
           fprintf(fptr_log, "\tPagefileUsage:              0x%08lX\n",
                     pmc.PagefileUsage );
           fprintf(fptr_log, "\tPeakPagefileUsage:          0x%08lX\n",
                     pmc.PeakPagefileUsage );
       }
       memcpy(a, &pmc, sizeof(pmc));
   }
   else
   {
       last_error = GetLastError();
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "GetProcessMemoryInfo bad error code is %d \n", last_error);
           fprintf(fptr_log, "return_code is %d \n", return_code);
           fflush(fptr_log);
           return(last_error);
       }
   }

   return(0);
}


int CBL_GET_HEAP_POINTER(void *a)
{
   PPOINTER    ptr_pointer;

   ptr_pointer             = a;
   ptr_pointer->ptr_void   = &heap_array[0];
   return(0);
}


//
// =====> this function just gets the starting timeb data
//        it will be used by a subsequent call to
//        CBL_TIME_DIFF
//

int CBL_START_TIME()
{
   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  In CBL_START_TIME function     \n\n");
       fflush(fptr_log);
   }

   ftime(&t_start);
   got_start_time = TRUE;
   return(0);
}


//
// =====> this function just gets the current timeb data
//        and uses it to calculate the difference in
//        milliseconds.
//

int CBL_TIME_DIFF(void *a)
{
   int     *ptr_int;

   ptr_int     = a;

   if (got_start_time == FALSE)
   {
       *ptr_int    = 0;
       return(MISSING_START_TIME);
   }

   ftime(&t_current);

   *ptr_int = (int) (1000.0 * (t_current.time - t_start.time)
     + (t_current.millitm - t_start.millitm));
   return(0);
}


int CBL_SPLIT_FILENAME(void *a, void *b)
{
   SPLITPATH         work;
   PSPLITPATH        ptr_parm;
   PSPLITPATH        ptr_work;
   PBITS             ptr_bits;
   short            *ptr_short1;
   short            *ptr_short2;
   char             *ptr_char;
   char             *ptr_path;
   int               cntr;
   int               len, buff_size;
   unsigned short    len_path;
   unsigned short    len_drive;
   unsigned short    len_dir;
   unsigned short    len_file;
   unsigned short    len_ext;
   BOOL              caps_on   = FALSE;
   BOOL              end_null  = FALSE;
   BOOL              from_gnucobol  = FALSE;
   cob_field        *f2;
   char path_buffer[270];
   char drive[256];
   char dir[256];
   char fname[256];
   char ext[256];

   if (first_time == TRUE)
   {
       first_time = FALSE;
       if ((ptr_char = getenv("CBL_DIAGNOSTIC")) == NULL)
       {
//         continue;
       }
       else if (strcmp(ptr_char, "ON") == 0)
       {
           fptr_log = fopen("VFILE-DIAGNOSTIC.LOG", "w");
           fprintf(fptr_log, " \n  In CBL_SPLIT_FILENAME function     \n\n");
           fprintf(fptr_log, "CBL_DIAGNOSTIC is %s \n", ptr_char);
           fprintf(fptr_log, "Setting diagnostic to TRUE \n");
           fflush(fptr_log);
           diagnostic = TRUE;
       }
   }

   ptr_parm        = a;
   ptr_work        = &work;

   ptr_bits        = (PBITS)&ptr_work->split_join_flag_1;

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, "\n dump of split_join_flag_1 before swap ==> ");
       DUMP_HEX((void *)ptr_bits, 1);
       fprintf(fptr_log, "\n\n");
       fprintf(fptr_log, "   address of work     is %p \n", &work);
       fprintf(fptr_log, "   address of ptr_bits is %p \n", ptr_bits);
       fprintf(fptr_log, " bit 7 is %d \n", (int)ptr_bits->bit_7);
       fprintf(fptr_log, " bit 6 is %d \n", (int)ptr_bits->bit_6);
       fprintf(fptr_log, " bit 5 is %d \n", (int)ptr_bits->bit_5);
       fprintf(fptr_log, " bit 4 is %d \n", (int)ptr_bits->bit_4);
       fprintf(fptr_log, " bit 3 is %d \n", (int)ptr_bits->bit_3);
       fprintf(fptr_log, " bit 2 is %d \n", (int)ptr_bits->bit_2);
       fprintf(fptr_log, " bit 1 is %d \n", (int)ptr_bits->bit_1);
       fprintf(fptr_log, " bit 0 is %d \n", (int)ptr_bits->bit_0);
       fflush(fptr_log);
   }

//
// =====> first convert the parms to Little Endian
//
   ptr_short1      = (short *)ptr_parm;
   ptr_short2      = (short *)ptr_work;

   for (cntr = 0; cntr < 13;  ptr_short1++, ptr_short2++, cntr++)
   {
       *ptr_short2  = COB_BSWAP_16(*ptr_short1);
   }

   if (ptr_work->split_name_buffer_size > 260)
       return(PATH_EXCEEDS_MAX);

   ptr_bits        = (PBITS)&ptr_work->split_join_flag_1;

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, "\n dump of split_join_flag_1 after  swap ==> ");
       DUMP_HEX((void *)ptr_bits, 1);
       fprintf(fptr_log, "\n\n");
       fprintf(fptr_log, "   address of work     is %p \n", &work);
       fprintf(fptr_log, "   address of ptr_bits is %p \n", ptr_bits);
       fprintf(fptr_log, " bit 7 is %d \n", (int)ptr_bits->bit_7);
       fprintf(fptr_log, " bit 6 is %d \n", (int)ptr_bits->bit_6);
       fprintf(fptr_log, " bit 5 is %d \n", (int)ptr_bits->bit_5);
       fprintf(fptr_log, " bit 4 is %d \n", (int)ptr_bits->bit_4);
       fprintf(fptr_log, " bit 3 is %d \n", (int)ptr_bits->bit_3);
       fprintf(fptr_log, " bit 2 is %d \n", (int)ptr_bits->bit_2);
       fprintf(fptr_log, " bit 1 is %d \n", (int)ptr_bits->bit_1);
       fprintf(fptr_log, " bit 0 is %d \n", (int)ptr_bits->bit_0);
       fflush(fptr_log);
   }


   if (ptr_bits->bit_0 == 1)
       caps_on     = TRUE;

   if (ptr_bits->bit_1 == 1)
       end_null    = TRUE;

// if (f2->size < (int)ptr_work->split_name_buffer_size)
// {
//     buff_size = f2->size;
//     if (diagnostic == TRUE)
//     {
//         fprintf(fptr_log, " Using parm 2 for buff size ==> %d \n", f2->size);
//         fflush(fptr_log);
//     }
// }
// else
       buff_size = (int)ptr_work->split_name_buffer_size;

   if (buff_size > 260)
       buff_size = 260;

   ptr_path = b;
   ptr_char = b + (buff_size - 1);

   if (end_null)
   {
       len = strnlen(ptr_path, buff_size);
   }
   else
   {
       while (ptr_char > ptr_path && (*ptr_char == ' ' || *ptr_char == '\0'))
       {
           ptr_char--;
       }
       len = (ptr_char - ptr_path) + 1;
   }

   memset(path_buffer, '\0', sizeof(path_buffer));
   memcpy(path_buffer, b, len);

   if (caps_on == TRUE)
   {
       for (cntr = 0; cntr < len; cntr++)
       {
           if (path_buffer[cntr]  >= 'a' && path_buffer[cntr] <= 'z')
               path_buffer[cntr] -=32;
       }
   }

   _splitpath(path_buffer,
       drive,
       dir,
       fname,
       ext);

   len_path        = (short)strlen(path_buffer);
   len_drive       = (short)strlen(drive);
   len_dir         = (short)strlen(dir);
   len_file        = (short)strlen(fname);
   len_ext         = (short)strlen(ext);

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, "\n dump of BE parm ");
       DUMP_HEX(a, 6);
       fprintf(fptr_log, "\n dump of LE parm ");
       DUMP_HEX(&work, 6);
       fprintf(fptr_log, "\n\n");
       fprintf(fptr_log, " end_null is %04hu \n", end_null);
       fprintf(fptr_log, " caps_on  is %04hu \n", caps_on);
       fprintf(fptr_log, " split_join_flag_1 is %04hu \n", ptr_work->split_join_flag_1);
       fprintf(fptr_log, "\nPath extracted with _splitpath_s():\n");
       fprintf(fptr_log, " Path     ==>%s<==\n", path_buffer);
       fprintf(fptr_log, " Drive    ==>%s<==\n", drive);
       fprintf(fptr_log, " Dir      ==>%s<==\n", dir);
       fprintf(fptr_log, " Filename ==>%s<==\n", fname);
       fprintf(fptr_log, " Ext      ==>%s<==\n", ext);
       fprintf(fptr_log, " length of Path     ==> %04d \n", len_path);
       fprintf(fptr_log, " length of Drive    ==> %04d \n", len_drive);
       fprintf(fptr_log, " length of Dir      ==> %04d \n", len_dir);
       fprintf(fptr_log, " length of Filename ==> %04d \n", len_file);
       fprintf(fptr_log, " length of Ext      ==> %04d \n", len_ext);
       fflush(fptr_log);
   }

   ptr_work->relative_address_of_device_name = 1;
   ptr_work->device_name_length              = (len_drive + len_dir - 1);
   ptr_work->relative_address_of_basic_name  = (len_drive + len_dir + 1);
   ptr_work->basic_name_length               = len_file;
   ptr_work->relative_address_of_extension   = (len_drive + len_dir + 1 + len_file + 1);
   ptr_work->extension_length                = (len_ext - 1);
   ptr_work->total_length                    = len_path;
   if (len_drive == 0)
   {
       ptr_work->length_of_first_path_name_component = 1;
   } else
   {
       ptr_work->length_of_first_path_name_component = len_drive;
   }

   ptr_parm        = a;
   ptr_work        = &work;
//
// =====> first convert the work area to Big Endian in the parm area
//
   ptr_short1      = (short *)ptr_parm;
   ptr_short2      = (short *)ptr_work;

   for (cntr = 0; cntr < 13;  ptr_short1++, ptr_short2++, cntr++)
   {
       *ptr_short1  = COB_BSWAP_16(*ptr_short2);
   }

   if (caps_on == TRUE)
   {
       memcpy(b, path_buffer, (int)len_path);
   }

   return(0);
}


//
// =====> The following functions are locale to this
// =====> source member only
//

void GET_DEFAULT_ALLOC()
{
   unsigned int    i;

   alloc_init = FALSE;

   if ((ptr_char = getenv("CBL_MEM_ALLOC_INIT")) == NULL)
   {
       if (diagnostic == TRUE)
           fprintf(fptr_log, "CBL_MEM_ALLOC_INIT does not exist \n");
   }
   else if (strcmp(ptr_char, "ON") == 0)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CBL_MEM_ALLOC_INIT is %s \n", ptr_char);
           fprintf(fptr_log, "Setting alloc_init to TRUE \n");
       }
       alloc_init = TRUE;
   }
   else
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CBL_MEM_ALLOC_INIT is %s \n", ptr_char);
           fprintf(fptr_log, "Setting alloc_init to FALSE \n");
       }
   }

   default_alloc = 64;
   if ((ptr_char = getenv("CBL_MEM_ALLOC_KB")) == NULL)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CBL_MEM_ALLOC_KB does not exist using default values \n");
           fprintf(fptr_log, " Default Memmory Allocation is %d KB \n", default_alloc);
           fflush(fptr_log);
       }
       default_alloc = default_alloc * 1024;
       return;
   }
   if (strlen(ptr_char) > 4)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CBL_MEM_ALLOC_KB max value exceeded \n");
           fflush(fptr_log);
       }
       default_alloc = 1024 *1024;
       return;
   }
   i = (unsigned int)atoi(ptr_char);
   if (i == 0)
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "CBL_MEM_ALLOC_KB is ZERO using default values \n");
           fprintf(fptr_log, " Default Memmory Allocation is %d KB \n", default_alloc);
       }
       default_alloc = default_alloc * 1024;
       return;
   }
//
// ROUND UP TO THE NEXT MULTIPLE OF 4
//
   default_alloc = i>>2;
   default_alloc = default_alloc<<2;
   if (default_alloc != i)
       default_alloc = default_alloc + 4;
   if (default_alloc < 16)
       default_alloc = 16;
   if (default_alloc > 1024)
       default_alloc = 1024;

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " Default Memmory Allocation is %d KB \n", default_alloc);
       fflush(fptr_log);
   }

   default_alloc = default_alloc * 1024;
   return;
}


int CREATE_FIRST_SEGMENT(PHEAP_ENTRY ptr_a)
{
   void        *ptr_malloc;
   PSEG_HDR    ptr_seg;
   int         data_size;

   return_code = 0;
   ptr_heap    = ptr_a;
   data_size = default_alloc - sizeof(SEG_HDR);

   if (alloc_init == FALSE)
       ptr_malloc = malloc(default_alloc);
   else
       ptr_malloc = calloc(default_alloc, sizeof(char));

   if (ptr_malloc == NULL)
       return(INSUFFICIENT_MEMORY);

   ptr_seg = ptr_malloc;

//
// ====> first populate HEAP_ENTRY
//
   ptr_heap->ptr_seg_first     = ptr_seg;
   ptr_heap->ptr_seg_last      = ptr_seg;
   ptr_heap->seg_count         = 1;
   ptr_heap->total_alloc       = default_alloc;
   ptr_heap->total_data_alloc  = data_size;

//
// ====> next populate SEG header info
//
   memcpy((void *)&ptr_seg->eye_ball ,"SEGMENT   ", 10);
   ptr_seg->heap_id            = ptr_heap->heap_id;
   ptr_seg->ptr_prev_seg       = NULL;
   ptr_seg->ptr_next_seg       = NULL;
   ptr_seg->seg_num            = 1;
   ptr_seg->seg_size           = default_alloc;
   ptr_seg->seg_data_size      = data_size;
   ptr_seg->seg_data_rel_start = 1;
   ptr_seg->seg_data_rel_end   = ptr_seg->seg_data_size;

   return(return_code);
}


int GET_NEW_SEGMENT(PHEAP_ENTRY ptr_a, PSEG_HDR ptr_seg_curr)
{
   void        *ptr_malloc;
   PSEG_HDR    ptr_seg;
   int         data_size;

   return_code = 0;
   ptr_heap    = ptr_a;
   data_size = default_alloc - sizeof(SEG_HDR);

   if (alloc_init == FALSE)
       ptr_malloc = malloc(default_alloc);
   else
       ptr_malloc = calloc(default_alloc, sizeof(char));

   if (ptr_malloc == NULL)
       return(INSUFFICIENT_MEMORY);

   ptr_seg = ptr_malloc;

//
// ====> first populate HEAP_ENTRY
//
   ptr_heap->ptr_seg_last      = ptr_seg;
   ptr_heap->seg_count++;
   ptr_heap->total_alloc       = default_alloc * ptr_heap->seg_count;
   ptr_heap->total_data_alloc  = data_size     * ptr_heap->seg_count;

//
// ====> next populate new SEG header info
//
   memcpy((void *)&ptr_seg->eye_ball ,"SEGMENT   ", 10);
   ptr_seg->heap_id            = ptr_heap->heap_id;
   ptr_seg->ptr_prev_seg       = ptr_seg_curr;
   ptr_seg->ptr_next_seg       = NULL;
   ptr_seg->seg_num            = ptr_seg_curr->seg_num + 1;
   ptr_seg->seg_size           = default_alloc;
   ptr_seg->seg_data_size      = data_size;
   ptr_seg->seg_data_rel_start = ptr_seg_curr->seg_data_rel_end + 1;
   ptr_seg->seg_data_rel_end   = ptr_seg_curr->seg_data_rel_end + data_size;

//
// ====> next populate curr SEG header info
//
   ptr_seg_curr->ptr_next_seg       = ptr_seg;

   return(return_code);
}


int  LOCATE_SEGMENT(unsigned short a,
                    unsigned int   b,
                    unsigned int   c,
                    void           *data_buffer)
{
   unsigned short  heap;
   unsigned int    data_loc;
   unsigned int    data_len;
   void            *ptr_data;
   void            *ptr_buffer;
   void            *ptr_void;
   unsigned int    move_len;
   unsigned int    offset;
   unsigned int    data_remain;
   unsigned int    data_middle;
   PHEAP_ENTRY     ptr_heap;
   PSEG_HDR        ptr_seg;
   PSEG_HDR        ptr_seg_last;
   int             sub;

   return_code     = 0;

   heap        = a;
   data_loc    = b;
   data_len    = c;


// if ((diagnostic == TRUE) && ( b < 0))
   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  In LOCATE_SEGMENT function \n\n");
       fprintf(fptr_log, " a     is %04hu    ", a);
       DUMP_HEX(&a, 2);
       fprintf(fptr_log, " b is %07u ",b);
       DUMP_HEX(&b, 4);
       fprintf(fptr_log, " c is %07u ",c);
       DUMP_HEX(&c, 4);
       fprintf(fptr_log, " heap     is %04hu    ", heap);
       DUMP_HEX(&heap, 2);
       fprintf(fptr_log, " data_loc is %07u ",data_loc);
       DUMP_HEX(&data_loc, 4);
       fprintf(fptr_log, " data_len is %07u ",data_len);
       DUMP_HEX(&data_len, 4);
       fflush(fptr_log);
   }

   move_len    = data_len;
   ptr_buffer  = data_buffer;

//
// =====> first locate HEAP_ENTRY
//

   if (heap < 0 || heap > MAX_HEAP)
   {
       fprintf(fptr_log, " heap out of bounds %03hu \n", heap);
       return(HEAP_OUT_BOUNDS);
   }

//
// =====> first locate HEAP_ENTRY
//
   sub                        = (int)(heap - 1);
   ptr_void                   = &heap_array[sub];
   ptr_heap                   = ptr_void;
   data_middle   = ptr_heap->total_data_alloc>>2;
   search_down   = FALSE;
   ptr_seg       = ptr_heap->ptr_seg_first;
   ptr_seg_last  = ptr_heap->ptr_seg_last;

// if ((diagnostic == TRUE) && ( b < 0))
   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  printing HEAP entry  \n\n");
       PRINT_HEAP_ENTRY(ptr_heap);
       fflush(fptr_log);
   }

   if (data_loc > data_middle)
   {
       search_down = TRUE;
       if (search_down == TRUE)
           ptr_seg    = ptr_heap->ptr_seg_last;
   }

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " \n  printing SEG_HDR \n\n");
       fprintf(fptr_log, "  this is the starting segment \n");
       PRINT_SEG_HDR(ptr_seg);
       if (search_down == TRUE)
           fprintf(fptr_log, "  searching from last segment \n");
       else
           fprintf(fptr_log, "  searching from first segment \n");
       fflush(fptr_log);
   }

//
// =====> find the first segment with a matching range
//        on the data_loc
//
   while ((data_loc < ptr_seg->seg_data_rel_start)
       || (data_loc > ptr_seg->seg_data_rel_end))
   {
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, " \n  checking segment data range  \n\n");
           fprintf(fptr_log, "  this is the while loop ");
           fprintf(fptr_log, "to find a matching range \n ");
           fprintf(fptr_log, " data_loc is %u \n ", data_loc);
           PRINT_SEG_HDR(ptr_seg);
           fflush(fptr_log);
       }
       if (data_loc < ptr_seg->seg_data_rel_start)
       {
           if (ptr_seg->ptr_prev_seg != NULL)
           {
               ptr_seg = ptr_seg->ptr_prev_seg;
           } else
           {
               return(ERROR_BEFORE_RELATIVE_LOC_1);
           }
       } else if (data_loc > ptr_seg->seg_data_rel_end)
       {
           if (ptr_seg->ptr_next_seg != NULL)
           {
               ptr_seg = ptr_seg->ptr_next_seg;
           } else
           {
               return_code = GET_NEW_SEGMENT(ptr_heap, ptr_seg);
               if (return_code != 0)
                   return(return_code);
               ptr_seg = ptr_heap->ptr_seg_last;
           }
       }
   }

// if ((diagnostic == TRUE) && ( b < 0))
   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, "  this after finding matching range \n ");
       PRINT_SEG_HDR(ptr_seg);
       fflush(fptr_log);
   }

//
// ====> FIND THE OFFSET IN THE CURRENT DATA AREA
//

   ptr_data = ptr_seg;
   ptr_data = ptr_data + sizeof(SEG_HDR);
   offset = data_loc - ptr_seg->seg_data_rel_start;

   if ((offset < 0 ) || (offset > ptr_seg->seg_data_size))
       return(ERROR_OUT_OF_DATA_RANGE);

//
// ====> NOW START MOVING THE DATA EITHER IN OR OUT
//

   while (move_len > 0)
   {
       ptr_data = ptr_data + offset;
       data_remain = ptr_seg->seg_data_size - offset;
       if (diagnostic == TRUE)
       {
           fprintf(fptr_log, "  this in the MOVE while loop \n ");
           fprintf(fptr_log, " move_len %u == offset %u == data_remain %u \n ",
               move_len, offset, data_remain);
           fprintf(fptr_log, "  ptr_data is %p \n ", ptr_data);
           fflush(fptr_log);
       }
       if (data_remain >= move_len)
       {
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " in data_remain true \n");
                   fprintf(fptr_log, " vfile_read is %d \n", vfile_read);
                   fflush(fptr_log);
               }
           if (vfile_read == TRUE)
           {
               memcpy(ptr_buffer, ptr_data, move_len);
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " data read is \n");
                   fwrite(ptr_buffer, sizeof(char), move_len, fptr_log);
                   fprintf(fptr_log, "\n");
                   fflush(fptr_log);
               }
           } else
           {
               memcpy(ptr_data, ptr_buffer, move_len);
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " data written is \n");
                   fwrite(ptr_data, sizeof(char), move_len, fptr_log);
                   fprintf(fptr_log, "\n");
                   fflush(fptr_log);
               }
           }
           move_len = 0;
       } else
       {
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " in data_remain false \n");
                   fprintf(fptr_log, " vfile_read is %d \n", vfile_read);
                   fflush(fptr_log);
               }
           if (vfile_read == TRUE)
           {
               memcpy(ptr_buffer, ptr_data, data_remain);
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " data read is \n");
                   fwrite(ptr_buffer, sizeof(char), data_remain, fptr_log);
                   fprintf(fptr_log, "\n");
                   fflush(fptr_log);
               }
           } else
           {
               memcpy(ptr_data, ptr_buffer, data_remain);
               if (diagnostic == TRUE)
               {
                   fprintf(fptr_log, " data written is \n");
                   fwrite(ptr_data, sizeof(char), data_remain, fptr_log);
                   fprintf(fptr_log, "\n");
                   fflush(fptr_log);
               }
           }
           move_len = move_len - data_remain;
           if (ptr_seg->ptr_next_seg != NULL)
           {
               ptr_seg = ptr_seg->ptr_next_seg;
           } else
           {
               return_code = GET_NEW_SEGMENT(ptr_heap, ptr_seg);
               if (return_code != 0)
                   return(return_code);
               ptr_seg = ptr_seg->ptr_next_seg;
           }
           offset      = 0;
           ptr_buffer  = ptr_buffer + data_remain;
           ptr_data    = ptr_seg;
           ptr_data    = ptr_data + sizeof(SEG_HDR);
       }
   }

   if (diagnostic == TRUE)
   {
       fprintf(fptr_log, " End of LOCATE_SEGMENT function \n");
       fflush(fptr_log);
   }

   return(return_code);

}


void PRINT_HEAP_ENTRY(PHEAP_ENTRY ptr_heap)
{
   fprintf(fptr_log, " eyeball found is --> ");
   fwrite(ptr_heap->eye_ball, sizeof(char), 10, fptr_log);
   fprintf(fptr_log, "\n heap_id is %03hu \n", ptr_heap->heap_id);
   fprintf(fptr_log, " ptr_seg is %p \n", ptr_heap->ptr_seg_first);
   fprintf(fptr_log, " seg_count is %u \n", ptr_heap->seg_count);
   fprintf(fptr_log, " total_alloc is %u \n", ptr_heap->total_alloc);
   fprintf(fptr_log, " total_data_alloc is %u \n", ptr_heap->total_data_alloc);
}


void PRINT_SEG_HDR(PSEG_HDR ptr_seg)
{
   fprintf(fptr_log, " eyeball found is --> ");
   fwrite(ptr_seg->eye_ball, sizeof(char), 10, fptr_log);
   fprintf(fptr_log, "\n heap_id is %03hu \n", ptr_seg->heap_id);
   fprintf(fptr_log, " ptr_seg is      %p \n", ptr_seg);
   fprintf(fptr_log, " ptr_prev_seg is %p \n", ptr_seg->ptr_prev_seg);
   fprintf(fptr_log, " ptr_prev_seg is %p \n", ptr_seg->ptr_prev_seg);
   fprintf(fptr_log, " seg_num is      %u \n", ptr_seg->seg_num);
   fprintf(fptr_log, " seg_size is     %u \n", ptr_seg->seg_size);
   fprintf(fptr_log, " seg_data_size is      %u \n", ptr_seg->seg_data_size);
   fprintf(fptr_log, " seg_data_rel_start is %u \n", ptr_seg->seg_data_rel_start);
   fprintf(fptr_log, " seg_data_rel_end is   %u \n", ptr_seg->seg_data_rel_end);
}


void DUMP_HEX(void *source, int len)
{
   unsigned char   *ptr;
   int             cntr;
   if (diagnostic == FALSE)
       return;
   ptr             = (unsigned char *)source;
   fprintf(fptr_log, "  Hex Dump ==>  ");
   for(cntr = 0; cntr < len; cntr++, ptr++)
   {
       fprintf(fptr_log, "%02X", *ptr);
   }
   fprintf(fptr_log, " <== \n");
   fflush(fptr_log);
}


int CBL_VFILES()
{

   if (first_time == TRUE)
   {
       first_time = FALSE;
       if ((ptr_char = getenv("CBL_DIAGNOSTIC")) == NULL)
       {
//         continue;
       }
       else if (strcmp(ptr_char, "ON") == 0)
       {
           fptr_log = fopen("VFILE-DIAGNOSTIC.LOG", "w");
           fprintf(fptr_log, " \n  In CBL_VFILES function     \n\n");
           fprintf(fptr_log, "CBL_DIAGNOSTIC is %s \n", ptr_char);
           fprintf(fptr_log, "Setting diagnostic to TRUE \n");
           fflush(fptr_log);
           diagnostic = TRUE;
       }
   }

   return 0;
}


