/*
    Copyright (C) 2016-2026 Sauro Menna
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
/* extsm.c - Reference EXTSM (in-memory sort/merge) with I/O
 * of USING/GIVING files.
 *
 * Supported function codes:
 *   FA01 SORT   FA40 MERGE   FAF3 RELEASE   FA10 end of input
 *   FAF5 RETURN FA88 terminate
 * Mode selected by the FCD-USE-FILES / FCD-GIVE-FILES counters:
 *   USING=0  GIVING=0 : RELEASE / RETURN
 *   USING>0  GIVING=0 : input from file, RETURN
 *   USING=0  GIVING>0 : RELEASE, output to file at FA10
 *   USING>0  GIVING>0 : everything within a single FA01 / FA40 call
 *
 *
 * The FCD3 offsets match those of FCD3 in libcob
 * (verified with `offsetof`; `sizeof` = 216).
 * 
 * 
 *> EXTSMTST5 - (cobol) prepares the FCD3s for 3 input files, 1 output file, and
 *> the FCD for SORT, then calls EXTSM.  No subprograms:
 *> FCDSET is a SECTION.
 *>
 *> Usage:  extsmtst           -> SORT   (function code X“FA01”)
 *>         extsmtst MERGE     -> MERGE  (function code X“FA40”)
 *>
 *> The file xfhfcd3.cpy (with constants 78) is included ONCE,
 *> in LINKAGE as CUR-FCD: it is a “view” that is moved with
 *> SET ADDRESS OF CUR-FCD TO ... to the FCD to be processed.
 *>
 *> Pointer chain:
 *>   SORT-FCD-AREA --FCD-FILDEF-ADDRESS--> FDB (pointer table)
 *>                                          |-> FILE-FCD(1) in 1
 *>                                          |-> FILE-FCD(2) in 2
 *>                                          |-> FILE-FCD(3) in 3
 *>                                          '-> FILE-FCD(4) out
 *>   SORT-FCD-AREA --FCD-KEY-DEF-ADDRESS--> KDB-AREA
 * 
 * 
 * Set Environment variables
 * export COB_LIBRARY_PATH=".:${COB_LIBRARY_PATH:+:$COB_LIBRARY_PATH}"
 * export COB_PRE_LOAD="libgcs"
 * export LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
 * 
 * 
 */


#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

#include "libgcs.h"

#include "../gcshare.h"
#include "extsm.h"

/* Key format type */
#define B0_DESCENDING       0x40
#define B1_NUMERIC          0x80
#define B1_SIGNED           0x40
#define B1_NON_DISPLAY      0x20
#define B1_FLOAT            0x04
#define B1_MASK_BITS_01     0x03

static KDB_GLOBAL* cached_kdb_glob = NULL;

struct job_t* globalJob = NULL;
struct job_t* job= NULL;
struct Job_tmpfile_t* g_tmpf = NULL;

static unsigned char* szBuffRek;
static unsigned char* szBuffKey;

int nLenRek = 0;
int nSplitBuf = 0;
int64_t nLim01 = 0;
int64_t nLim02 = 0;

FCD3* fcd;

int save_curRecLen=0;
int save_maxRecLen=0;
int save_minRecLen=0;
unsigned char save_recordMode = 0;  /*#REC_MODE_FIXED 0, REC_MODE_VARIABLE	1 */

unsigned short last_opcode = 99;
unsigned short sTypeJob = 0; /* 1-Sort, 2-Merge */

typedef struct {
    uint32_t pos, len;
    int type;                       /* CT_* */
    int is_signed;
    int sign_mode;                  /* SG_* (solo DISPLAY con segno) */
    int descending;
    int ebcdic_data, ebcdic_sign;
    int use_collating;              /* solo non numerici */
} sk_comp;


static struct {
    int      phase;                 /* 0 chiuso, 1 input, 2 output */
    int      use, give;
    sk_comp  comp[16];
    int      nc;
    size_t   n, cap, pos;
} S;

static void set_status(FCD3* fcd, int k1, int k2)
{
    fcd->fileStatus[0] = (unsigned char)k1;
    fcd->fileStatus[1] = (unsigned char)k2;
}
static void set_ok(FCD3* f) { set_status(f, '0', '0'); }
static void set_eof(FCD3* f) { set_status(f, '1', '0'); }
static void set_err(FCD3* f, int code) { set_status(f, '9', code); }

enum {
    O_ST1 = 0, O_ST2 = 1, O_ORG = 5, O_RECMODE = 8, O_NAMELEN = 54,
    O_USE = 64, O_GIVE = 65, O_CURLEN = 88, O_MINLEN = 92,
    O_MAXLEN = 96, O_RECADDR = 160, O_NAMEPTR = 168, O_KEYDEF = 184,
    O_FILDEF = 200
};


/* status 9/x restituiti dal motore (codici scelti qui, non MF) */
enum {
    E_ORDER = 1, E_KDB = 2, E_KEYTYPE = 3, E_FILES = 4, E_MEM = 5,
    E_FUNC = 6, E_FCD = 7
};

//
/*
* 
============
SORT - Buffer
============
0 (Initialization - Open/Start): Initializes the sort session. Configures the module by allocating the necessary memory and analyzing the key definitions passed in the second parameter (FCD).
1 (Record Insertion - Put/Release): Passes a single record to the EXTSM module to insert it into the set to be sorted. This is equivalent to the RELEASE statement in internal COBOL. 
    This code is repeated in a loop for each record to be sorted.
2 (Sort Execution - Sort/Process): Signals to EXTSM that record submission is complete. The module physically executes the sort algorithm on the data accumulated in memory or in temporary 
    files.
3 (Record Retrieval - Get/Return): Retrieves a single, already sorted record from the module. This is equivalent to the RETURN statement. It is repeated in a loop until the module 
    returns an “End of File” (File Status) code.
4 (Termination - Close/End): Closes the sort session, releases all internally allocated memory, and deletes any temporary swap files created on disk.


============
MERGE
============
0 (Initialization): Opens the session and analyzes the list of multiple input files to be merged (Micro Focus supports up to 128 concurrent input files via EXTSM).
2 (Merge Execution): Runs the merge algorithm on the configured files. The engine verifies the record sequence (if the input files are not sorted, the runtime will return the classic runtime error 9/222—Merge files out of
sequence—at this stage).
3 (Record Extraction / Get): Extracts one record at a time, returning the data that has already been merged and sorted.
4 (Termination): Closes all files and releases memory resources.
*/

/* ========================================================================== */
/*  DEFINITION OF OPERATION CODES (OPCODES)                            */
/* ========================================================================== */
#define OP_SORT_EX_LE_INIT          0xFA01      //0x0000
#define OP_SORT_MERGE               0xFA40
#define OP_SORT_EX_LE_RELEASE       0xFAF3      //0x0001
#define OP_SORT_EX_LE_END           0xFA10      //0x0002
#define OP_SORT_EX_LE_RETURN        0xFAF5      //0x0003
#define OP_SORT_EX_LE_CLEANUP       0xFA88      //0x0004


/* Field Data type */
enum { CT_ALNUM, CT_DISP, CT_BIN, CT_PACKED, CT_COMPX, CT_COMP5, CT_FLOAT };


/* util */
static void* getp(const unsigned char* fcd, int off)
{
    void* p;
    memcpy(&p, fcd + off, sizeof p);
    return p;
}

/* util */
static void free_all(void)
{
    memset(&S, 0, sizeof S);
}
/* Verify data type */
static int supported(const sk_comp* c)
{
    if (c->ebcdic_data || c->ebcdic_sign || c->use_collating) return 0;
    switch (c->type) {
    case CT_ALNUM: return 1;
    case CT_DISP:  return !c->is_signed;
    case CT_COMPX: return !c->is_signed;
    case CT_BIN:   return 1;
    default:       return 0;
    }
}

static bool is_sort_operation(unsigned short opcodep) {
    return ((opcodep >= OP_SORT_EX_LE_INIT && opcodep <= OP_SORT_EX_LE_CLEANUP));
}

/* Entry point COBOL Program */
GCSORT_API int EXTSM(unsigned char* func, FCD3* fcdin)
{
    unsigned short current_opcode = LDCOMPX2(func);
    int nRC = 0;
    fcd = (FCD3*)fcdin;
/* Condizione SORT */
    if (!(is_sort_operation(current_opcode) || (fcd->fnamePtr == NULL))) {
#ifdef EXTSM_DEBUG
        printf("[EXTSM] Opcode SORT ricevuto: [0x%X] - [%u] \n", current_opcode, current_opcode);
#endif
        return -1;
    }

    unsigned lo = func[1];
    if (func[0] != 0xFA) { 
        set_err(fcd, E_FUNC); 
        return 0; 
    }

    switch (lo) {
        /* ================== */
        /* FA01 SORT  */
        /* FA40 MERGE */
        /* ================== */
    case 0x01:
    case 0x40:                         
        /* INIT */
        nRC = EXTSMGC_init(fcd);

        /* set operation to merge */
        if (lo == 0x40)
            gcs_sort_set_oper('M');

        free_all();
        S.use = fcd->useFiles;
        S.give = fcd->giveFiles;
        if ((S.use + S.give > 0) && (fcd->fileDef == NULL)) {
            set_err(fcd, E_FCD);
            break;
        }
        if (lo == 0x40 && S.use == 0) {
            set_err(fcd, E_FILES);
            break;
        }
        if (get_key_definition(fcd) == -1) {
            set_err(fcd, E_KDB);
            break;
        }
        for (int i = 0; i < S.nc; i++)
            if (!supported(&S.comp[i])) {
                set_err(fcd, E_KEYTYPE);
                goto fail;
            }
        if (S.use > 0){
            if (load_use_files(fcd) != 0)
                goto fail;
        }
        else {
            S.phase = 1;                        /* then FAF3 */
        }


        if (S.give > 0)                   /* All in one call */
            if (load_give_files(fcd) != 0)
                goto fail;                

        /* Made correct file name */
        if ((S.use > 0) || (S.give > 0)) {
            gcs_sort_review_name();
        }



        /* Case  Using >0 and Giving >0 */
        if ((S.use > 0) && (S.give > 0)) {
            nRC = gcs_sort_LoadFile();
            nRC = gcs_sort_run();
            free_all();
        }
        /* Case  Using >0 and Giving = 0 */
        if ((S.use > 0) && (S.give == 0)) {
            nRC = gcs_sort_LoadFile();
        }


        if (S.use > 0) {
            S.phase = 2;
            S.pos = 0;         /* then FAF5 */
        }
        set_ok(fcd);
        break;
    
    /* ================== */
    /* FAF3 RELEASE */
    /* ================== */
    case 0xF3:
        if (S.phase != 1 || S.use != 0) { 
            set_err(fcd, E_ORDER); 
            break; 
        }
        /* Push record from Cobol program */
        nRC = EXTSMGC_push_record(fcd);
        set_ok(fcd);
        break;
    /* ================== */
    /* FA10 EOF input file */
    /* ================== */
    case 0x10:
        if (S.phase != 1 || S.use != 0) { 
            set_err(fcd, E_ORDER); 
            break; 
        }
       
        gcs_sort_data(job);

        if (S.give > 0) {
            if (job->bIsPresentSegmentation == 1)
                nRC = gcs_save_tempfinal(job);
            else
                nRC = gcs_save_out(job);
            free_all();
        }
        else {
            S.phase = 2; S.pos = 0;
        }
        set_ok(fcd);
        break;
    /* ================== */
    /* FAF5 RETURN */
    /* ================== */
    case 0xF5: {
        if (S.phase != 2 || S.give != 0) { 
            set_err(fcd, E_ORDER); 
            break; 
        }
        /* Pop record from memory */
        nRC = EXTSMGC_pop_record(fcd);
        if (nRC == 0)
            set_ok(fcd);
        else
            set_eof(fcd);
        break;
    }
    /* ================== */
    /* FA88 END           */
    /* ================== */
    case 0x88:
        free_all();
        nRC = EXTSMGC_cleanup();
        set_ok(fcd);
        break;
    default:
        set_err(fcd, E_FUNC);
    }
    return 0;
fail:
    free_all();
    return 0;
}

/* --- function that returns the type directly as a string --- */
char* utils_getExtsmFieldTypeName(EXTKEY* componente, int* out_is_descending) {

    /* 1. Retrieve the direction (UP/DOWN) from Byte 0 */
    if (out_is_descending != NULL) {
        *out_is_descending = (componente->desc & B0_DESCENDING) ? 1 : 0;
    }

    /* Data type */
    uint8_t b1 = componente->type;

    /* Alphanumeric case (Bit 7 not set) */
    if (!(b1 & B1_NUMERIC)) {
        return "CH";
    }

    /* FLOATING POINT case (Bit 2 set for numeric field) */ 
    if (b1 & B1_FLOAT) {
        return "FL";
    }

    /* Let's isolate bits 0 and 1 for specific numeric formats */
    uint8_t format_bits = b1 & B1_MASK_BITS_01;

    /* non-display numeric case (bit 5 set) */
    if (b1 & B1_NON_DISPLAY) {
        switch (format_bits) {
        case 0: // BINARY
            return (b1 & B1_SIGNED) ? "FI" : "BI";

        case 1: // PACKED-DECIMAL (COMP-3)
            return "PD";

        case 2: // COMP-X
            return "BI"; // Spesso mappato su Binary, o "BIX" se hai una stringa custom

        case 3: // COMP-5
            return (b1 & B1_SIGNED) ? "FI" : "BI";

        default:
            return "";
        }
    }
    /* numeric display case (bit 5 not set) */
    else {
        /* If it is a numeric DISPLAY but UNSIGNED, it is ZONED */
        if (!(b1 & B1_SIGNED)) {
            return "ZD";
        }
        /*  If it is SIGNED, we check the sign's position */
        else {
            switch (format_bits) {
            case 0: /* SIGN TRAILING INCLUDED */
                return "ZD";
            case 1: /* SIGN TRAILING SEPARATE */
                return "CST";
            case 2: /* SIGN LEADING INCLUDED */
                return "CLO";
            case 3: /* SIGN LEADING SEPARATE */
                return "CSL";
            default:
                return "";
            }
        }
    }
}

/* retrieves the definitions of the key fields */
int get_key_definition(FCD3* fcd)
{
    int rtc = 0;
    KDB_GLOBAL* kdb_glob = NULL;
    if (fcd != NULL) {
        uintptr_t kdb_address = *(uintptr_t*)(&(fcd->kdbPtr));
        if (kdb_address != 0) //{
            kdb_glob = (KDB_GLOBAL*)kdb_address;
    }

    if (kdb_glob != NULL) {
        /* Decodifica Big-Endian nativa */
        unsigned short totale_chiavi = LDCOMPX2(kdb_glob->nkeys);
        KDB* kdb_completo = (KDB*)kdb_glob;

        for (int i = 0; i < totale_chiavi; i++) {
            KDB_KEY* chiave_corrente = &(kdb_completo->key[i]);
            unsigned short num_componenti = LDCOMPX2(chiave_corrente->count);
            unsigned short offset_componenti = LDCOMPX2(chiave_corrente->offset);
            EXTKEY* extkey_array = (EXTKEY*)((unsigned char*)kdb_completo + offset_componenti);

            char szType[3] = { 0x00,0x00,0x00 };
            char szOrd[2] = { 0x00,0x00 };
            for (int s = 0; s < num_componenti; s++) {
                EXTKEY* componente = &extkey_array[s];
                char* pType = NULL;

                unsigned int pos = LDCOMPX4(componente->pos);
                unsigned int len = LDCOMPX4(componente->len);

                job->nLenKeys += len;

                int nOrd = SORT_DIRECTION_ASCENDING;
                strncpy(szOrd, "A\0", 2);
                int nType = 0;
                pType = utils_getExtsmFieldTypeName(componente, &nOrd);

                if (nOrd == 1)
                    strncpy(szOrd, "D\0", 2);

                gcs_sort_init_key(pos, len, (const char*)pType, (const char*)szOrd);
            }
        }

    }
    return rtc;
}

/* Reads all USING files (FCD in table, positions 0..use-1) */
static int load_use_files(FCD3* fcd)
{
    char szName[FILENAME_MAX];
    unsigned char recMode[2] = "F\0";
    /* debug - Use this function to dump the FCD             */
    /* dump_fcd_structure(fcd, "Puntatore COBOL Originale"); */
    /*                                                       */

    FCD3** fdb_table = (FCD3**)fcd->_fileDef.ptr_name;   /* tabella puntatori (FDB) */
    if (fdb_table == NULL) {
        set_err(fcd, E_FCD);
        return -1;
    }

    for (int i = 0; i < S.use; i++) {
        FCD3* ffcd = fdb_table[i];
        if (ffcd == NULL) { set_err(fcd, E_FILES); return -1; }

        uint16_t nameLen = LDCOMPX2(ffcd->fnameLen);
        char* pName = (char*)ffcd->_fnamePtr.ptr_name;

        if (pName && nameLen > 0) {
            printf("[EXTSM] USING[%d]: %.*s\n", i, nameLen, pName);
            memset(szName, 0x00, FILENAME_MAX);
            strncpy(szName, pName, nameLen);
            unsigned short curLen = LDCOMPX4(fcd->curRecLen);
            unsigned short maxLen = LDCOMPX4(fcd->maxRecLen);
            if (fcd->recordMode == '1')
                strncpy(recMode, "V\0", 2);
            gcs_sort_use(szName, gcs_sort_FileTypeFCD2GCS(fcd->fileOrg), recMode, curLen, maxLen);
            job->inputLength = maxLen;
        }
    }
    return 0;
}
static int load_give_files(FCD3* fcd)
{
    char szName[FILENAME_MAX];
    unsigned char recMode[2] = "F\0";
    /* debug - Use this function to dump the FCD */
    /* dump_fcd_structure(fcd, "Puntatore COBOL Originale"); */
    /* */

    FCD3** fdb_table = (FCD3**)fcd->_fileDef.ptr_name;   /* tabella puntatori (FDB) */
    if (fdb_table == NULL) {
        set_err(fcd, E_FCD);
        return -1;
    }

    for (int i = S.use; i < S.use+ S.give; i++) {
        FCD3* ffcd = fdb_table[i];
        if (ffcd == NULL) { set_err(fcd, E_FILES); return -1; }

        uint16_t nameLen = LDCOMPX2(ffcd->fnameLen);
        char* pName = (char*)ffcd->_fnamePtr.ptr_name;

        if (pName && nameLen > 0) {
            printf("[EXTSM] GIVING[%d]: %.*s\n", i, nameLen, pName);
            memset(szName, 0x00, FILENAME_MAX);
            strncpy(szName, pName, nameLen);
            unsigned short curLen = LDCOMPX4(fcd->curRecLen);
            unsigned short maxLen = LDCOMPX4(fcd->maxRecLen);
            if (fcd->recordMode == '1')
                strncpy(recMode, "V\0", 2);
            gcs_sort_give(szName, gcs_sort_FileTypeFCD2GCS(fcd->fileOrg), recMode, curLen, maxLen);
            job->outputLength = maxLen;

        }
    }
    return 0;
}

int EXTSMGC_init(FCD3* fcd)
{

#pragma message ("--- ================================================================================== ---")
#pragma message ("-- Define how to enable the collating sequence >>> fcd->confFlags2 - Collating sequence ? ")
#pragma message ("--- ================================================================================== ---")

    int nRC = 0;
    if (nRC >= 0) {
        gcs_sort_init();
        struct job_t* p1 = (struct job_t*) gcs_get_job();
        job = p1;
        globalJob = job;
        gcs_sort_set_oper('S');

    }
    szBuffRek = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
    if (szBuffRek == 0)
        fprintf(stdout, "*EXTSM*S323*ERROR: Cannot Allocate szBuffRek : %s\n", strerror(errno));
    szBuffKey = (unsigned char*)malloc((size_t)GCSORT_MAX_BUFF_REK);
    if (szBuffKey == 0)
        fprintf(stdout, "*EXTSM*S321*ERROR: Cannot Allocate szBuffKey : %s\n", strerror(errno));

    nSplitBuf = SZPOSPNT + SZLENREC + SZPNTDATA;

    nLim01 = (((int64_t)job->nLenMemory) * 2);
    nLim02 = (((int64_t)job->nLenKeys + (int64_t)SIZESRTBUFF) * 2);

    return nRC;
}
int EXTSMGC_push_record(FCD3* fcd)
{
    /* Review with temporary files */
    int nRC = 0;
    int nIdxFileIn = 0;  /* non ci sono più file in input */

    nRC = gcs_LoadInMemory(job, fcd->_recPtr.ptr_name, szBuffKey, LDCOMPX4(fcd->curRecLen), nSplitBuf, nIdxFileIn, nLim01, nLim02);

#ifdef EXTSMGC_DEBUG
    printf("[EXTSM] EXTSMGC_push_record: [" NUM_FMT_LLD "]\n", job->recordNumber);
#endif
    /* Save to temp file */
    if (nRC == -2) {
        if (job->bIsPresentSegmentation == 1) {
            EXTSMGC_sort_core(fcd);
            nRC = gcs_save_tempfile(job);
        }
        /* Reset counter and area */
        job->ulMemSizeRead = 0;
        job->ulMemSizeSort = 0;
        memset(job->recordData, 0x00, (size_t)job->ulMemSizeAllocData);
        memset(job->buffertSort, 0x00, (size_t)job->ulMemSizeAllocSort);
        job->phSrt->lPosPnt = 0;
        job->phSrt->nLenRek = 0;
        job->phSrt->pAddress = NULL;
    }

    return nRC;

}
int EXTSMGC_pop_record(FCD3* fcd)
{
    int nRC = 0;

    /* Temporary files */
    if (job->bIsPresentSegmentation == 1) {
        /* if records sorted are in memory */
        if ((job->recordNumber > job->recordWriteSortTotal))
            nRC = gcs_save_tempfile(job);
        /* Merge temp files and write outfile file */
        if (g_tmpf == NULL) /* Init areas */
            g_tmpf = gcs_tmpfile_init(job);
        gcs_tmpfile_get(job, g_tmpf, fcd);
        if (g_tmpf->nSumEof >= MAX_HANDLE_TEMPFILE) {
            set_eof(fcd);
            return 10;
        }
    }
    else
    {
        if (job->recordReadInCurrent >= job->recordNumber) {
            set_eof(fcd);
            return 10;
        }
        gc_memcpy((job->phSrt), (job->buffertSort + (job->recordReadInCurrent) * ((int64_t)job->nLenKeys + SIZESRTBUFF) + job->nLenKeys), SIZESRTBUFF);
        gc_memcpy(fcd->recPtr, job->phSrt->pAddress, job->phSrt->nLenRek); /* buffer   */
        /* save record len */
        STCOMPX4(job->phSrt->nLenRek, fcd->curRecLen);
    }
    job->recordReadInCurrent++;
#ifdef EXTSMGC_DEBUG
    printf("[EXTSM] EXTSMGC_pop_record: [" NUM_FMT_LLD " / [" NUM_FMT_LLD "]\n", job->recordReadInCurrent, job->recordNumber);
#endif
    return nRC;

}
int EXTSMGC_sort_core(FCD3* fcd)
{
    int nRC = 0;
    job->recordReadInCurrent = 0;
    nRC = gcs_sort_data(job);

    if ((nRC == 0) && (job->bIsPresentSegmentation == 0)) {
        set_ok(fcd);
    }

    return nRC;
}
int EXTSMGC_cleanup(void)
{
    int nRC = 0;

    if (job->bIsPresentSegmentation == 1)
        gcs_tmpfile_cleanup(job, g_tmpf);

    gcs_job_destroy(job);
    gcs_job_destructor(job);

    if (szBuffRek != NULL)
        free(szBuffRek);
    if (szBuffKey != NULL)
        free(szBuffKey);

    gcs_sort_cleanup();

    return nRC;

}

void dump_fcd_structure(const FCD3* fcd, const char* label) {
    if (!fcd) {
        printf("--- DUMP FCD [%s]: NULL POINTER ---\n", label ? label : "UNKNOWN");
        return;
    }

    printf("\n==================================================\n");
    printf("--- FCD DUMP: %s ---\n", label ? label : "ANALYSIS");
    printf("FCD Base Memory Address: %p\n", (void*)fcd);
    printf("==================================================\n");

    /* states and initial check */
    printf("[State & Info]\n");
    printf("  fileStatus      : %c%c (0x%02X 0x%02X)\n",
        fcd->fileStatus[0] >= 32 ? fcd->fileStatus[0] : '.',
        fcd->fileStatus[1] >= 32 ? fcd->fileStatus[1] : '.',
        fcd->fileStatus[0], fcd->fileStatus[1]);
    printf("  fcdLen          : %u byte\n", LDCOMPX2(fcd->fcdLen));
    printf("  fcdVer          : %u\n", fcd->fcdVer);
    printf("  fileOrg         : 0x%02X (1=SEQ, 2=REL, 3=IDX)\n", fcd->fileOrg);
    printf("  openMode        : 0x%02X (1=INPUT, 2=OUTPUT, 3=I-O, 4=EXTEND)\n", fcd->openMode);
    printf("  recordMode      : 0x%02X (0=FIXED, 1=VARIABLE)\n", fcd->recordMode);
    printf("  fileFormat      : 0x%02X\n", fcd->fileFormat);

    /* flags and configurations managed in the image */
    printf("\n[Flags]\n");
    printf("  accessFlags     : 0x%02X\n", fcd->accessFlags);
    printf("  lockAction      : 0x%02X\n", fcd->lockAction);
    printf("  otherFlags      : 0x%02X\n", fcd->otherFlags);
    printf("  configFlags     : 0x%02X\n", fcd->confFlags);
    printf("  miscFlags       : 0x%02X\n", fcd->miscFlags);
    printf("  lockMode        : 0x%02X\n", fcd->lockMode);

    /* dimensions and meters */
    printf("\n[Lengths & Counters]\n");
    uint16_t fnLen = LDCOMPX2(fcd->fnameLen);
    uint16_t idxLen = LDCOMPX2(fcd->idxNameLen);
    printf("  fnameLen        : %u\n", fnLen);
    printf("  idxNameLen      : %u\n", idxLen);
    printf("  useFiles        : %u\n", fcd->useFiles);
    printf("  giveFiles       : %u\n", fcd->giveFiles);
    printf("  refKey          : %u\n", LDCOMPX2(fcd->refKey));

    printf("  effKeyLen       :  %u\n", LDCOMPX2(fcd->effKeyLen));

    uint32_t curLen = LDCOMPX4(fcd->curRecLen);
    uint32_t maxLen = LDCOMPX4(fcd->maxRecLen);
    printf("  curRecLen       : %u\n", curLen);
    printf("  maxRecLen       : %u\n", maxLen);

    printf("\n[Keys and Related Addresses]\n");

    /* Reconstruction of FCD-SESSION-ID (4 byte) */
    uint32_t session_id = 0;
    for (int i = 0; i < 4; i++) {
        session_id |= ((uint32_t)fcd->fsv2SessionId[i]) << (i * 8);
    }
    printf("  FCD-SESSION-ID   (dec): %u\n", session_id);
    printf("  FCD-SESSION-ID   (hex): %02X %02X %02X %02X\n",
            fcd->fsv2SessionId[0], fcd->fsv2SessionId[1],
            fcd->fsv2SessionId[2], fcd->fsv2SessionId[3]);

    /* Reconstruction of FCD-RELATIVE-KEY (8 byte) */
    uint64_t relative_key = 0;
    for (int i = 0; i < 8; i++) {
        relative_key |= ((uint64_t)fcd->relByteAdrs[i]) << (i * 8);
    }

    printf("Raw relByteAdrs: "); 
    for (int i = 0; i < 8; i++) 
        printf("%02X ", fcd->relByteAdrs[i]); 
    printf("\n");
    printf("Raw maxRelKey:   "); 
    for (int i = 0; i < 8; i++) 
        printf("%02X ", fcd->maxRelKey[i]);   
    printf("\n");

    printf("BYTE Raw: ");
    for (int i = 0; i < 8; i++) {
        printf("%02X ", fcd->relKey[i]);
    }
    printf("\n");

    /* TREATMENT COMP-X 64-BIT CROSS-PLATFORM */
    uint64_t raw_value2 = 0;
    memcpy(&raw_value2, fcd->relKey, 8);

    uint64_t relative_key_C2 = COB_BSWAP_64(raw_value2);
    printf("ACTUAL value of FCD-RELATIVE-KEY: %llu\n", (unsigned long long)relative_key_C2);

    printf("  FCD-RELATIVE-KEY (dec): %llu\n", (unsigned long long)relative_key);
    printf("  FCD-RELATIVE-KEY (hex): ");
    for (int i = 0; i < 8; i++) printf("%02X ", fcd->relByteAdrs[i]);
    printf("\n");

    uint32_t naxrelkey = ((uint32_t)fcd->maxRelKey[0] << 24) | ((uint32_t)fcd->maxRelKey[1] << 16) | ((uint32_t)fcd->maxRelKey[2] << 8) | fcd->maxRelKey[3];
    printf("\n\n  maxrelkey       : %u\n", naxrelkey);
    uint32_t nrelKey = ((uint32_t)fcd->relKey[0] << 24) | ((uint32_t)fcd->relKey[1] << 16) | ((uint32_t)fcd->relKey[2] << 8) | fcd->relKey[3];
    printf("  relKey       : %u\n", nrelKey);

    /* 64-BIT POINTER MAP */
    printf("\n[Memory Pointers (64-bit)]\n");
    printf("  _fileHandle     : %p\n", (void*)(uintptr_t)fcd->_fileHandle.ptr_name);
    printf("  _recPtr         : %p\n", (void*)(uintptr_t)fcd->_recPtr.ptr_name);
    printf("  _ptr_name       : %p\n", (void*)(uintptr_t)fcd->_fnamePtr.ptr_name);
    printf("  _idxNamePtr     : %p\n", (void*)(uintptr_t)fcd->_idxNamePtr.ptr_name);
    printf("  _kdbPtr         : %p\n", (void*)(uintptr_t)fcd->_kdbPtr.ptr_name);
    printf("  _fileDef        : %p\n", (void*)(uintptr_t)fcd->_fileDef.ptr_name);

    /* STRINGS DIAGNOSTICS */
    printf("\n[String Content Resolved]\n");
    if (fcd->_fnamePtr.ptr_name && fnLen > 0) {
        printf("  Physical File Name: %.*s\n", (int)fnLen, (char*)fcd->_fnamePtr.ptr_name);
    }
    else {
        printf("  Physical File Name: [NULL pointer or length 0]\n");
    }

    if (fcd->_idxNamePtr.ptr_name && idxLen > 0) {
        printf("  Index Name     : %.*s\n", (int)idxLen, (char*)fcd->_idxNamePtr.ptr_name);
    }

    printf("==================================================\n\n");
}
