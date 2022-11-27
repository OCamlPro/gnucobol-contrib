/*
    Copyright (C) 2016-2021 Sauro Menna
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
#include <string.h>
#include <libcob.h>
#include "file.h"
#include "exitroutines.h"
#include "libgcsort.h"
#include "utils.h"

static unsigned int	    E15initialized = 0;
static cob_module*      E15module = NULL;
cob_global*             E15cob_glob_ptr;
cob_call_union		    E15cob_unifunc;
cob_field*              E15cob_procedure_params[10];
struct cob_frame*       E15frame_ptr;
struct cob_frame	    E15frame_stack[255];
static int	            E15ex_retcode;	/* RETURN-CODE */

static unsigned int	    E35initialized = 0;
static cob_module*      E35module = NULL;
cob_global*             E35cob_glob_ptr;
cob_call_union		    E35cob_unifunc;
cob_field*              E35cob_procedure_params[10];
struct cob_frame*       E35frame_ptr;
struct cob_frame	    E35frame_stack[255];
static int	            E35ex_retcode;	/* RETURN-CODE */
/* Function prototypes */
 
/* START Routine E15 */
static void		E15CALL_module_init (cob_module *module);

struct E15Call_t* E15Call_constructor(int nLenRecSize)
{
    struct E15Call_t* pE15c= (struct E15Call_t*)malloc(sizeof(struct E15Call_t));
    if (pE15c == NULL) {
        fprintf(stdout,"*GCSORT*S701*ERROR: Problem with allocation E15 routine \n");
        return NULL;
    }        
    pE15c->pCallE15 = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, FILENAME_MAX, 0, 0, FILENAME_MAX, ALLOCATE_DATA);
    memset(pE15c->pCallE15->data, 0x00, FILENAME_MAX);
    pE15c->pRecFlag = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pRecFlag->data, 0x00, 4);

    pE15c->pSendRec = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, nLenRecSize, 0, 0, nLenRecSize, ALLOCATE_DATA);
    memset(pE15c->pSendRec->data, 0x00, nLenRecSize);
    pE15c->pReceiveRec = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, nLenRecSize, 0, 0, nLenRecSize, ALLOCATE_DATA);
    memset(pE15c->pReceiveRec->data, 0x00, nLenRecSize);
    pE15c->pUnused1 = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pUnused1->data, 0x00, 4);
    pE15c->pUnused2 = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pUnused2->data, 0x00, 4);
    pE15c->pNewRecLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pNewRecLen->data, 0x00, 4);
    pE15c->pReturnRecLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pReturnRecLen->data, 0x00, 4);
    pE15c->pUnused5 = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE15c->pUnused5->data, 0x00, 4);
    pE15c->pExitAreaLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 4, 0, 0, 2, ALLOCATE_DATA);
    memset(pE15c->pExitAreaLen->data, 0x00, 2);
    pE15c->pExitArea = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, 256, 0, 0, 256, ALLOCATE_DATA);
    memset(pE15c->pExitArea->data, 0x20, 256);      /* Set space in area    */
   /* Check initialized, check module allocated, */
   /* set global pointer, */
   /* push module stack, save call parameter count */
    int entry = 0;
    if (cob_module_global_enter(&E15module, &E15cob_glob_ptr, 0, entry, 0))
        return NULL;

    /* Set address of module parameter list */
    E15module->cob_procedure_params = E15cob_procedure_params;

    /* Set frame stack pointer */
    E15frame_ptr = E15frame_stack;
    E15frame_ptr->perform_through = 0;

    E15CALL_module_init(E15module);

    E15ex_retcode = 0;
    E15initialized = 1;

    E15module->module_active++;

    return pE15c;
}

void E15Call_destructor(struct E15Call_t* pE15C) 
{

    util_cob_field_del(pE15C->pCallE15, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pRecFlag, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pSendRec, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pReceiveRec, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pUnused1, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pUnused2, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pNewRecLen, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pReturnRecLen, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pUnused5, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pExitAreaLen, ALLOCATE_DATA);
    util_cob_field_del(pE15C->pExitArea, ALLOCATE_DATA);
    if (E15module->module_active) {
        E15module->module_active--;
    }

    /* Pop module stack */
    cob_module_leave(E15module);

    /* Program return */
    if (!E15initialized)
        return;
    if (E15module && E15module->module_active)
        cob_fatal_error(COB_FERROR_CANCEL);
    E15ex_retcode = 0;
    cob_module_free(&E15module);

    E15initialized = 0;

    return;
}

void E15ResetParams(int* nrekE15, int* nrekFlagE15, int nLastRecord)
{

    /*
     nrekFlagE15
        0 indicates the first record passed.
        4 indicates subsequent records passed.
        8 indicates the last record passed.
    */
    if (*nrekE15 == 1)
        *nrekFlagE15 = 4;	/* Middle record   */
    if (*nrekE15 == 0) {
        *nrekE15 = 1;		/* First record    */
        *nrekFlagE15 = 0;
    }
    if (nLastRecord == 1)
        *nrekFlagE15 = 8;	/* End record      */
    return;
}

int E15Call_SetCallName (struct E15Call_t* pE15C, char * szCallName)
{
    strcpy(pE15C->pCallE15->data, szCallName);  /* set CALL Name */
    return 0;
}


int	E15Run(const int entry, struct E15Call_t* pE15C, int nRecFlag, int nLen, unsigned char* pSendRec, unsigned char* pReceiveRec, int* newLen, int nIsFileVariable)
{
    /*
    LINKAGE     for fixed records
    01  RECORD - FLAGS            PIC 9(8) BINARY.
        88  FIRST - REC                VALUE 00.
        88  MIDDLE - REC               VALUE 04.
        88  END - REC                  VALUE 08.
    01  NEW-REC                   PIC X(nn).
    01  RETURN-REC                PIC X(nn).
    01  UNUSED1                   PIC 9(8) BINARY.
    01  UNUSED2                   PIC 9(8) BINARY.
    01  NEW-REC-LEN               PIC 9(8) BINARY	                (Only for Variable Length)
    01  RETURN-REC-LEN            PIC 9(8) BINARY                   (Only for Variable Length)
    01  UNUSED5                   PIC 9(8) BINARY.
    01  EXITAREA-LEN              PIC 9(4) BINARY.
    01  EXITAREA.
       05  EAREA   OCCURS 1 TO 256 TIMES
                   DEPENDING ON EXITAREA-LEN   PIC X.
    */

   /* s.m. 20220625 if (unlikely(entry < 0)) */
    if (entry < 0)
        return -1;

  cob_set_int(pE15C->pRecFlag, nRecFlag);
  memmove(pE15C->pSendRec->data, pSendRec, nLen);
  cob_set_int(pE15C->pNewRecLen, nLen); /* set length   */
  cob_set_int(pE15C->pExitAreaLen, 256);


  E15cob_procedure_params[0] = pE15C->pRecFlag;
  E15cob_procedure_params[1] = pE15C->pSendRec;
  E15cob_procedure_params[2] = pE15C->pReceiveRec;
  E15cob_procedure_params[3] = NULL;
  E15cob_procedure_params[4] = NULL;
  E15cob_procedure_params[5] = pE15C->pNewRecLen;
  E15cob_procedure_params[6] = pE15C->pReturnRecLen;
  E15cob_procedure_params[7] = NULL;
  E15cob_procedure_params[8] = pE15C->pExitAreaLen;
  E15cob_procedure_params[9] = pE15C->pExitArea;

  E15cob_glob_ptr->cob_call_params = 10; /* 3;  */
  E15cob_glob_ptr->cob_stmt_exception = 0;

  /* 20220625 if (unlikely((E15cob_glob_ptr->cob_exception_code & 0x0b00) == 0x0b00)) E15cob_glob_ptr->cob_exception_code = 0; */
  if ((E15cob_glob_ptr->cob_exception_code & 0x0b00) == 0x0b00) 
      E15cob_glob_ptr->cob_exception_code = 0; 

  E15cob_unifunc.funcvoid = cob_call_field(pE15C->pCallE15, NULL, 1, 0);
  E15ex_retcode = ((int (*)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void* ))E15cob_unifunc.funcint)
      (pE15C->pRecFlag->data, pE15C->pSendRec->data, pE15C->pReceiveRec->data, 0, 0, pE15C->pNewRecLen->data, pE15C->pReturnRecLen->data, 0, pE15C->pExitAreaLen->data, pE15C->pExitArea->data);

  /* set new record or modified record in return record */
  if ((E15ex_retcode == 12) || (E15ex_retcode == 20)) {
      memmove(pReceiveRec, pE15C->pReceiveRec->data, nLen);     /* modify/new record    */
      if (nIsFileVariable == 1)
          *newLen = cob_get_int(pE15C->pReceiveRec);            /* Get new len only for Variable File   */
  }
  /* Program return */
  return E15ex_retcode;
}
/* End PROGRAM-ID 'E15CALL' */
 
/* Initialize module structure for E15CALL */
static void E15CALL_module_init (cob_module *module)
{
  module->module_name = "E15";
  module->module_formatted_date = COB_MODULE_FORMATTED_DATE;
  module->module_source = COB_SOURCE_FILE;
  module->module_entry.funcptr = (void *(*)())E15Run;
  module->module_cancel.funcptr = (void *(*)())E15Run;
  module->module_ref_count = NULL;
  module->module_path = &cob_module_path2;
  module->module_active = 0;
  module->module_date = COB_MODULE_DATE;
  module->module_time = COB_MODULE_TIME;
  module->module_type = 0;
  module->module_param_cnt = 0;
  /* //-->> module->ebcdic_sign = 0; */
  module->ebcdic_sign = g_cb_ebcdic_sign;
  module->decimal_point = '.';
  module->currency_symbol = '$';
  module->numeric_separator = ',';
  module->flag_filename_mapping = 1;
  module->flag_binary_truncate = 1;
  module->flag_pretty_display = 1;
  module->flag_host_sign = 0;
  module->flag_no_phys_canc = 0;
  module->flag_main = 0;
  module->flag_fold_call = 0;
  module->flag_exit_program = 0;
#if __LIBCOB_VERSION >= 3
      module->flag_debug_trace = 0;
      module->flag_dump_ready = 0;
      module->module_stmt = 0;
      module->module_sources = NULL;
#endif /* __LIBCOB_VERSION >= 3  */

}
/* END Routine E15 */

/* START Routine E35 */
static void		E35CALL_module_init(cob_module* module);

struct E35Call_t* E35Call_constructor(int nLenRecSize)
{
    struct E35Call_t* pE35c = (struct E35Call_t*)malloc(sizeof(struct E35Call_t));
    if (pE35c == NULL) {
        fprintf(stdout,"*GCSORT*S701*ERROR: Problem with allocation E35 routine \n");
        return NULL;
    }
    pE35c->pCallE35 = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, FILENAME_MAX, 0, 0, FILENAME_MAX, ALLOCATE_DATA);
    memset(pE35c->pCallE35->data, 0x00, FILENAME_MAX);
    /* pE35c->pRecFlag = util_cob_field_make(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);   */
    pE35c->pRecFlag = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE35c->pRecFlag->data, 0x00, 4);

    pE35c->pSendRec = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, nLenRecSize, 0, 0, nLenRecSize, ALLOCATE_DATA);
    memset(pE35c->pSendRec->data, 0x00, nLenRecSize);
    pE35c->pReceiveRec = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, nLenRecSize, 0, 0, nLenRecSize, ALLOCATE_DATA);
    memset(pE35c->pReceiveRec->data, 0x00, nLenRecSize);
    pE35c->pOutputRec = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, nLenRecSize, 0, 0, nLenRecSize, ALLOCATE_DATA);
    memset(pE35c->pOutputRec->data, 0x30, nLenRecSize);
    pE35c->pUnused1 = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE35c->pUnused1->data, 0x30, 4);
    pE35c->pNewRecLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE35c->pNewRecLen->data, 0x30, 4);
    pE35c->pReturnRecLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE35c->pReturnRecLen->data, 0x30, 4);
    pE35c->pOutputRecLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 8, 0, 0, 4, ALLOCATE_DATA);
    memset(pE35c->pOutputRecLen->data, 0x30, 4);
    pE35c->pExitAreaLen = util_MakeAttrib_call(COB_TYPE_NUMERIC_BINARY, 4, 0, 0, 2, ALLOCATE_DATA);
    memset(pE35c->pExitAreaLen->data, 0x30, 2);
    pE35c->pExitArea = util_MakeAttrib_call(COB_TYPE_ALPHANUMERIC, 256, 0, 0, 256, ALLOCATE_DATA);
    memset(pE35c->pExitArea->data, 0x20, 256);      /* Set space in area    */

   /* Check initialized, check module allocated, */
   /* set global pointer, */
    /* push module stack, save call parameter count */
   int entry = 0;
   if (cob_module_global_enter(&E35module, &E35cob_glob_ptr, 0, entry, 0))
        return NULL;
 
    /* Set address of module parameter list */
   E35module->cob_procedure_params = E35cob_procedure_params;
 
    /* Set frame stack pointer */
   E35frame_ptr = E35frame_stack;
   E35frame_ptr->perform_through = 0;
/*
 P_initialize:
*/
    E35CALL_module_init(E35module);
    /*  da inserire nella destructor    module->crt_status = NULL; */

    /* Initialize cancel callback */
  /*da inserire nella destructor   cob_set_cancel(module); */

    /* Initialize WORKING-STORAGE */
    E35ex_retcode = 0;
    E35initialized = 1;
    
    E35module->module_active++;

    return pE35c;
}

void E35Call_destructor(struct E35Call_t* pE35C)
{
    util_cob_field_del(pE35C->pCallE35, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pRecFlag, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pSendRec, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pReceiveRec, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pOutputRec, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pUnused1, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pNewRecLen, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pReturnRecLen, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pOutputRecLen, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pExitAreaLen, ALLOCATE_DATA);
    util_cob_field_del(pE35C->pExitArea, ALLOCATE_DATA);

    if (E35module->module_active) {
        E35module->module_active--;
    }

    /* Pop module stack */
    cob_module_leave(E35module);

    /* Program return */
    if (!E35initialized)
        return;

    if (E35module && E35module->module_active)
        cob_fatal_error(COB_FERROR_CANCEL);
    E35ex_retcode = 0;
    cob_module_free(&E35module);

    E35initialized = 0;

    return;
}

void E35ResetParams(int* nrekE35, int* nrekFlagE35, int nLastRecord)
{
    /*
     nrekFlagE35
        0 indicates the first record passed.
        4 indicates subsequent records passed.
        8 indicates the last record passed.
    */
    if (*nrekE35 == 1)
        *nrekFlagE35 = 4;	/* Middle record  */
    if (*nrekE35 == 0) {
        *nrekE35 = 1;		/* First record   */
        *nrekFlagE35 = 0;
    }
    if (nLastRecord == 1)
        *nrekFlagE35 = 8;	/* End record     */
    return;
}

int E35Call_SetCallName(struct E35Call_t* pE35C, char* szCallName)
{
    strcpy(pE35C->pCallE35->data, szCallName);  /* set CALL Name */
    return 0;
}


int	E35Run(const int entry, struct E35Call_t* pE35C, int nRecFlag, int nLen, unsigned char* pSendRec, unsigned char* pReceiveRec, unsigned char* pOutRec, int* newLen, int* nOutLen, int nIsFileVariable)
{
    /*
    LINKAGE     for fixed records
   01  RECORD-FLAGS       PIC 9(8) BINARY.
       88  FIRST-REC            VALUE 00.
       88  MIDDLE-REC           VALUE 04.
       88  END-REC              VALUE 08.
   01  LEAVING-REC.
       05 LREC OCCURS 1 TO 200 TIMES
               DEPENDING ON LEAVING-REC-LEN      PIC X.
   01  RETURN-REC.
       05 RREC OCCURS 1 TO 200 TIMES
               DEPENDING ON RETURN-REC-LEN   PIC X.
   01  OUTPUT-REC.
       05 OREC OCCURS 1 TO 200 TIMES
               DEPENDING ON OUTPUT-REC-LEN   PIC X.
   01  UNUSED1            PIC 9(8) BINARY.
   01  LEAVING-REC-LEN    PIC 9(8) BINARY.
   01  RETURN-REC-LEN     PIC 9(8) BINARY.
   01  OUTPUT-REC-LEN     PIC 9(8) BINARY.
   01  EXITAREA-LEN       PIC 9(4) BINARY.
   01  EXITAREA.
       05  EAREA   OCCURS 1 TO 256 TIMES
               DEPENDING ON EXITAREA-LEN   PIC X.
    */

   /* 20220625  if (unlikely(entry < 0)) */
    if (entry < 0)
        return -1;

    cob_set_int(pE35C->pRecFlag, nRecFlag);
    memmove(pE35C->pSendRec->data, pSendRec, nLen);
    memmove(pE35C->pOutputRec->data, pOutRec, *nOutLen);
    cob_set_int(pE35C->pNewRecLen, 0);               /* set length  */
    cob_set_int(pE35C->pNewRecLen, 0);               /* set length  */
    cob_set_int(pE35C->pReturnRecLen, 0);            /* set length  */
    cob_set_int(pE35C->pOutputRecLen, *nOutLen);     /* set length  */
    cob_set_int(pE35C->pExitAreaLen, 256);

    E35cob_procedure_params[0] = pE35C->pRecFlag;
    E35cob_procedure_params[1] = pE35C->pSendRec;           /* new record           */
    E35cob_procedure_params[2] = pE35C->pReceiveRec;        /* modified record      */
    E35cob_procedure_params[3] = pE35C->pOutputRec;         /* previous record      */
    E35cob_procedure_params[4] = pE35C->pUnused1;
    E35cob_procedure_params[5] = pE35C->pNewRecLen;
    E35cob_procedure_params[6] = pE35C->pReturnRecLen;
    E35cob_procedure_params[7] = pE35C->pOutputRecLen;
    E35cob_procedure_params[8] = pE35C->pExitAreaLen;
    E35cob_procedure_params[9] = pE35C->pExitArea;

    E35cob_glob_ptr->cob_call_params = 10; 
    E35cob_glob_ptr->cob_stmt_exception = 0;

    /* 20220625 if (unlikely((E35cob_glob_ptr->cob_exception_code & 0x0b00) == 0x0b00)) E35cob_glob_ptr->cob_exception_code = 0; */
    if ((E35cob_glob_ptr->cob_exception_code & 0x0b00) == 0x0b00) 
        E35cob_glob_ptr->cob_exception_code = 0;

    E35cob_unifunc.funcvoid = cob_call_field(pE35C->pCallE35, NULL, 1, 0);
    E35ex_retcode = ((int (*)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*))E35cob_unifunc.funcint)
        (pE35C->pRecFlag->data, pE35C->pSendRec->data, pE35C->pReceiveRec->data, pE35C->pOutputRec->data, pE35C->pUnused1->data, pE35C->pNewRecLen->data, pE35C->pReturnRecLen->data, pE35C->pOutputRecLen->data, pE35C->pExitAreaLen->data, pE35C->pExitArea->data);

    /* set new record or modified record in return record   */
    if (E35ex_retcode == 12)  {
        memmove(pReceiveRec, pE35C->pReceiveRec->data, nLen);     /* modify/new record  */
        if (nIsFileVariable == 1)
            *newLen = cob_get_int(pE35C->pReceiveRec);            /* Get new len only for Variable File */
    }
    if (E35ex_retcode == 20) {
        memmove(pReceiveRec, pE35C->pOutputRec->data, nLen);      /* modify/new record  */
        if (nIsFileVariable == 1)
            *newLen = cob_get_int(pE35C->pOutputRecLen);          /* Get new len only for Variable File */
    }

    return E35ex_retcode;
}


/* End PROGRAM-ID 'E35CALL' */

/* Initialize module structure for E35CALL */
static void E35CALL_module_init(cob_module* module)
{
    module->module_name = "E35";
    module->module_formatted_date = COB_MODULE_FORMATTED_DATE;
    module->module_source = COB_SOURCE_FILE;
    module->module_entry.funcptr = (void* (*)())E35Run;
    module->module_cancel.funcptr = (void* (*)())E35Run;
    module->module_ref_count = NULL;
    module->module_path = &cob_module_path2;
    module->module_active = 0;
    module->module_date = COB_MODULE_DATE;
    module->module_time = COB_MODULE_TIME;
    module->module_type = 0;
    module->module_param_cnt = 0;
    /* module->ebcdic_sign = 0; */
    module->ebcdic_sign = g_cb_ebcdic_sign;
    module->decimal_point = '.';
    module->currency_symbol = '$';
    module->numeric_separator = ',';
    module->flag_filename_mapping = 1;
    module->flag_binary_truncate = 1;
    module->flag_pretty_display = 1;
    module->flag_host_sign = 0;
    module->flag_no_phys_canc = 0;
    module->flag_main = 0;
    module->flag_fold_call = 0;
    module->flag_exit_program = 0;
#if __LIBCOB_VERSION >= 3
        module->flag_debug_trace = 0;
        module->flag_dump_ready = 0;
        module->module_stmt = 0;
        module->module_sources = NULL;
#endif /* __LIBCOB_VERSION >= 3 */
}

/* END   Routine E35 */
/* End functions */
