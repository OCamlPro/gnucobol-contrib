/*
    Copyright (C) 2026  Sauro Menna
 *
 *    This file is part of GCSORT.
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
#define _POSIX_C_SOURCE 200809L
#include <string.h> 
#include <stdio.h>
#include <stdint.h> 
#include <stdlib.h>
#include <libgcs.h>

/* 

-p SORT -i  "../files/extsm_inputsqv.dat"  -o "../files/extsm_outputsqv.dat"

-p MERGE -i  "../files/extsm_inputsqv.dat"   -i  "../files/extsm_inputsqv.dat"   -o "../files/extsm_outputsqv.dat"

*/
// Inclusione di getopt (nativa su Linux/MinGW, simulata se necessario)
#if defined(__linux__) || defined(__MINGW32__) || defined(__MINGW64__)
#include <getopt.h>
#endif

#define MAX_FILES 10


#if defined(_WIN32) && !defined(__MINGW32__) && !defined(__MINGW64__)
#define NUM_FMT_LLD     "%9I64d"
#else
#define NUM_FMT_LLD     "%9lld"
#endif

#define SWAP_UINT32(x) ((((x) & 0x000000FF) << 24) | \
                        (((x) & 0x0000FF00) << 8)  | \
                        (((x) & 0x00FF0000) >> 8)  | \
                        (((x) & 0xFF000000) >> 24))

#define BUFLEN 64
#define MAX_RECORD_SIZE 90
#define LIMITE_STAMPA 50 

#define INREC  1
#define OUTREC 1

/* Configurazione cross-platform per il confronto case-insensitive */
#if defined(_WIN32) || defined(__WIN32__) || defined(__MINGW32__)
    /* Ambiente Windows (inclusi MinGW a 32 e 64 bit) */
#define STRCASECMP _stricmp
#else
    /* Ambiente Linux / macOS / POSIX standard */
#include <strings.h>
#define STRCASECMP strcasecmp
#endif


#define SWAP_UINT16(x) ((((x) & 0x00FF) << 8) | (((x) & 0xFF00) >> 8))

// --- IMPLEMENTATION OF GETOPT FOR WINDOWS (MSVC) ---
#ifdef _MSC_VER

#define no_argument       0
#define required_argument 1
#define optional_argument 2

struct option {
    const char* name;
    int         has_arg;
    int* flag;
    int         val;
};

// Variabili globali richieste da getopt
char* optarg = NULL;
int optind = 1;
int opterr = 1;
int optopt = 0;

#endif

int gnAlloc_manual_out = 0;
int gnAlloc_manual_inp = 0;

static struct option long_options[] = {
    {"input-file",   required_argument, 0, 'i'},
    {"output-file",  required_argument, 0, 'o'},
    {"sign-ebcdic",  no_argument,       0, 's'},
    {"sequence-col", required_argument, 0, 'c'},
    {"ebcdic-table", required_argument, 0, 't'},
    {"operation",    required_argument, 0, 'p'},
    {"inrec",        no_argument,       0, 'R'},
    {"outrec",       no_argument,       0, 'W'},
    {"include",      no_argument,       0, 'I'}, 
    {"omit",         no_argument,       0, 'O'}, 
    {"help",         no_argument,       0, 'h'},
    {0, 0, 0, 0}
};

// 1. Definition of the global structure to hold all parameter values
typedef struct {
    char* input_files[MAX_FILES];
    int input_file_count;
    char* output_file;
    int sign_ebcdic;
    int sequence_col;
    unsigned char* ebcdic_table;
    char* operation;
    int inrec_flag;
    int outrec_flag;
    int include_flag;
    int omit_flag;
} CmdLineParams;

// Global instance of the parameters, accessible by name anywhere in the code
CmdLineParams params;

void key_def(void);
void file_def(void);
void inrec_def(void);
void outrec_def(void);
void include_def(void);
void omit_def(void);

void print_statistics(void);
int get_cmdline_params(int argc, char* argv[]);
void read_file_gnucobol(const char* nome_file);
void print_help(const char* program_name);
int getopt_long(int argc, char* const argv[], const char* optstring, const struct option* longopts, int* longindex);
int check_parameters(void);

int main(int argc, char* argv[]) {

    int nRC = 0;
    printf("Testlib - Test module for libgcs (GCSort library) \n");

    if (get_cmdline_params(argc, argv) == 1)
        exit(0);


    check_parameters();

    /* collating sequence */
/* [NATIVE = 0 | ASCII = 1 | EBCDIC = 2] */
    if ((params.sequence_col > 2) || (params.sequence_col < 0)) {
        printf("[Error: Collating Sequence error]. \nValid values [NATIVE = 0 | ASCII = 1 | EBCDIC = 2]\n");
        goto lberr;
    }
    gcs_colseq(params.sequence_col);

    /* Sign */
    if ((params.sign_ebcdic > 1) || (params.sign_ebcdic < 0)) {
        printf("[Error: Sign error]. \nValid values [0 -> ASCII, 1 -> EBCDIC]\n");
        goto lberr;
    }

    g_cb_ebcdic_sign = params.sign_ebcdic;
    gcs_cb_sign(params.sign_ebcdic);

    /* Table */
    if (params.ebcdic_table != NULL)
        gcs_ebcdic_table(params.ebcdic_table);


    nRC = gcs_sort_init();
    if (nRC != 0) {
        printf("[Error: gcs_sort_init() error]. ReturnCode:%d\n", nRC);
    }

    /* Set environment variables */
    /* GCSORT_........ */

    /* enable multithread with 4 threads */
    /* not implemented \*/
    /* gcs_sort_enable_multithread(4); */
    if (params.operation == NULL) {
        gcs_sort_set_oper('S');  /* S=sort - M=merge / copy ???)*/
        printf("Sort operation\n");
    }
    else
    {
        if (STRCASECMP(params.operation, "Sort") == 0) {
            gcs_sort_set_oper('S');  /* S=sort - M=merge / copy ???)*/
            printf("Sort operation\n");
        }
        if (STRCASECMP(params.operation, "Merge") == 0) {
            gcs_sort_set_oper('M');  /* S=sort - M=merge / copy ???)*/
            printf("Merge operation\n");
            if (params.input_file_count < 2) {
                printf("[Error: Merging is not possible with just one file]\n");
                goto lberr;
            }
        }
        if (STRCASECMP(params.operation, "Copy") == 0) {
            gcs_sort_set_oper('C');  /* S=sort - M=merge / copy ???)*/
            printf("Copy operation\n");
        }
    }
    /* Sort Key definition */
    key_def();

    /* Use/Give definition */
    file_def();

    /* Inrec - Outrec definitions 
       They cannot coexist at the same time  
    */

    if (params.inrec_flag == 1)
        inrec_def();

    if (params.outrec_flag == 1)
        outrec_def();


    if (params.include_flag == 1)
        include_def();

    if (params.omit_flag == 1)
        omit_def();

    printf("======== START INPUT  FILE =========================\n");
    for (int i = 0; i < params.input_file_count; i++) {
        printf("Input file:%s\n", params.input_files[i]);
        read_file_gnucobol(params.input_files[i]);
    }
    printf("======== END   INPUT  FILE =========================\n");

    /* Run Command */

    int nRetCode = gcs_sort_run();
    
    printf(" Return code function gcs_sort_run():%d\n", nRetCode);

    printf("======== START OUTPUT FILE =========================\n");
    printf("Output file:%s\n", params.output_file);
    read_file_gnucobol(params.output_file);
    printf("======== END   OUTPUT FILE =========================\n");


    /* Get statistics from gcsort */
    print_statistics();


    /* Get Return of activity */
    printf(" Return code:%d\n", gcs_get_returncode());

    gcs_sort_cleanup();

    return 0; // Indica che il programma è terminato con successo
lberr:
    if (gnAlloc_manual_inp == 1)
        free(params.input_files[0]);
    if (gnAlloc_manual_out == 1)
        free(params.output_file);
    return 16;
}

int check_parameters(void)
{
    /* check parameters */
    if ((params.inrec_flag > 0) && (params.outrec_flag > 0)) {
        printf("[Error: inrec and outrec definition cannot be present at the same time]\n");
        exit(16);
    }

    if ((params.input_files[0] == NULL) || (params.output_file == NULL)) {
        printf("[Error: input file and or output file not defined]\n");
        exit(16);
    }

    if ((params.include_flag > 0) && (params.omit_flag > 0)) {
        printf("[Error: include and omit definition cannot be present at the same time]\n");
        exit(16);
    }


    return 0;
}

void key_def(void)
{
    int position, length;
    char type[4];
    char direction[4];
    /* Sort Key - First field */
    position = 1;
    length = 3;
    sprintf(type, "%s", "ZD\0");
    sprintf(direction, "%s", "D\0");
    gcs_sort_init_key(position, length, type, (const char*)direction);

    printf("Key definition\n");
    printf("Pos:%d, Len:%d, type:%s, direction:%s\n", position, length, type, direction);

    /* Sort Key - Second field */
    position = 4;
    length = 5;
    sprintf(type, "%s", "ZD\0");
    sprintf(direction, "%s", "A\0");
    gcs_sort_init_key(position, length, type, (const char*)direction);
    printf("Pos:%d, Len:%d, type:%s, direction:%s\n", position, length, type, direction);

}

void file_def(void)
{
    int minrec, maxrec;
    char org[3];
    char fixvar[3];
    /* Organization */
    sprintf(org, "%s", "SQ\0");

    /* Record Type */
    sprintf(fixvar, "%s", "V\0");
    minrec = 20;
    maxrec = 90;

    /* Use file */
    for (int i=0; i < params.input_file_count;i++) 
        gcs_sort_use(params.input_files[i], (const char*)org, fixvar, minrec, maxrec);

    /* Give file */
    gcs_sort_give(params.output_file, (const char*)org, fixvar, minrec, maxrec);


}

void inrec_def(void)
{
    unsigned char szType[BUFLEN];
    unsigned char szValue[BUFLEN];
    int nPosAbs = 0;
    int nPosAbsRec = 0;
    int nPos = 0;
    int nLen = 0;
    int nOccur = 0;

    memset(szType, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);


    /* input structure 
    *   Pos - Len
            01 - 08   file input
            09 - 06   'libgcs'
            20 - 08
            28 - 10
            40 - 02
    */
    /* Inrec _  DIGIT ',' DIGIT  */
    gcs_inrec_range(1, 10);
        
    /* DIGIT ':' CHARTYPE STRING */
    /*  Char Type  CharType = C(char) | X(hexdical) |Z(zero binary) <String>    */
    nPosAbs = 9;
    sprintf((char*)szType, "%s", "C");
    sprintf((char*)szValue, "%s", "libgcs");
    gcs_inrec_substnchar(nPosAbs, (unsigned char*) szType, (unsigned char*) szValue);

    /* DIGIT ':' DIGIT ',' DIGIT */
    /* abspos output, position input, length input   */
    nPosAbs = 20;
    nPos = 1;
    nLen = 10;
    gcs_inrec_range_position(nPosAbs, nPos, nLen);


    /* OCCURFILL = <n><Type> - Type = C|X|Z  */
    /* <n>{1,5}[C|X|Z] */

    memset((char*)szValue, 0x00, BUFLEN);
    sprintf((char*)szValue, "%s", "X");
    nOccur = 12;
    gcs_inrec_subst(nOccur, (unsigned char*)szValue);

    /* DIGIT ':' CHARTYPE  - case 80:X  */
    /* nPosAbsRec is last position previous function */
    /* nPosAbsRec must be major of nPosAbs */
    nPosAbsRec = 8 + 6 + 10 + 12;
    nPosAbs = 40;
    nOccur = 2;
    memset((char*)szValue, 0x00, BUFLEN);
    sprintf((char*)szValue, "%s", "C");
    gcs_inrec_padding(nPosAbs, nOccur, (unsigned char*)szValue, nPosAbsRec);
    return;
}

void outrec_def(void)
{
    unsigned char szType[BUFLEN];
    unsigned char szValue[BUFLEN];
    int nPosAbs = 0;
    int nPosAbsRec = 0;
    int nPos = 0;
    int nLen = 0;
    int nOccur;

    memset(szType, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);


    /* input structure
    *   Pos - Len
            01 - 08   file input
            09 - 06   'libgcs'
            20 - 08
            28 - 10
            40 - 02
    */
    /* Inrec _  DIGIT ',' DIGIT  */
    gcs_outrec_range(1, 10);

    /* DIGIT ':' CHARTYPE STRING */
    /*  Char Type  CharType = C(char) | X(hexdical) |Z(zero binary) <String>    */
    nPosAbs = 9;
    sprintf((char*)szType, "%s", "C");
    sprintf((char*)szValue, "%s", "gcs-library");
    gcs_outrec_substnchar(nPosAbs, (unsigned char*)szType, (unsigned char*)szValue);

    /* DIGIT ':' DIGIT ',' DIGIT */
    /* abspos output, position input, length input   */
    nPosAbs = 20;
    nPos = 1;
    nLen = 11;
    gcs_outrec_range_position(nPosAbs, nPos, nLen);


    /* OCCURFILL = <n><Type> - Type = C|X|Z  */
    /* <n>{1,5}[C|X|Z] */

    memset(szType, 0x00, BUFLEN);
    sprintf((char*)szType, "%s", "X");

    nOccur = 12;
    gcs_outrec_subst(nOccur, (unsigned char*)szType);

    /* DIGIT ':' CHARTYPE  - case 80:X  */
    /* nPosAbsRec is last position previous function */
    /* nPosAbsRec must be major of nPosAbs */
    nPosAbsRec = 8 + 6 + 10 + 12;
    nPosAbs = 40;
    memset(szType, 0x00, BUFLEN);
    sprintf((char*) szType, "%s", "C");
    nOccur = 2;
    gcs_outrec_padding(nPosAbs, nOccur, (unsigned char*)szType, nPosAbsRec);
    return;
}


void include_def(void)
{
    int nPos = 0;
    int nLen = 0;

    char szType1[BUFLEN];
    char szType2[BUFLEN];
    char szValue[BUFLEN];
    char szOpCond[BUFLEN];
    memset(szType1, 0x00, BUFLEN);
    memset(szType2, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);
    memset(szOpCond, 0x00, BUFLEN);

    /* pos 1, len 3  > 1  AND  pos 1, len 3 < 100 */
    nPos = 1;
    nLen = 3;
    sprintf((char*)szType1, "%s", "ZD");
    sprintf((char*)szType2, "%s", "Z");
    sprintf((char*)szValue, "%s", "1");
    sprintf((char*)szOpCond, "%s", "GT");

    struct condField_t* cf1 = gcs_cond_value(nPos, nLen, szType1, szOpCond, szType2, szValue);

    memset(szType1, 0x00, BUFLEN);
    memset(szType2, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);
    memset(szOpCond, 0x00, BUFLEN);

    nPos = 1;
    nLen = 3;
    sprintf((char*)szType1, "%s", "ZD");
    sprintf((char*)szType2, "%s", "Z");
    sprintf((char*)szValue, "%s", "100");
    sprintf((char*)szOpCond, "%s", "LT");
    struct condField_t* cf2 = gcs_cond_value(nPos, nLen, szType1, szOpCond, szType2, szValue);

    struct condField_t* cfroot = gcs_cond_AND(cf1, cf2);
    gcs_addInclude(cfroot);
}

void omit_def(void)
{
    int nPos = 0;
    int nLen = 0;

    char szType1[BUFLEN];
    char szType2[BUFLEN];
    char szValue[BUFLEN];
    char szOpCond[BUFLEN];
    memset(szType1, 0x00, BUFLEN);
    memset(szType2, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);
    memset(szOpCond, 0x00, BUFLEN);

    /* pos 1, len 3  > 1  AND  pos 1, len 3 < 100 */
    nPos = 1;
    nLen = 3;
    sprintf((char*)szType1, "%s", "ZD");
    sprintf((char*)szType2, "%s", "Z");
    sprintf((char*)szValue, "%s", "1");
    sprintf((char*)szOpCond, "%s", "GT");

    struct condField_t* cf1 = gcs_cond_value(nPos, nLen, szType1, szOpCond, szType2, szValue);

    memset(szType1, 0x00, BUFLEN);
    memset(szType2, 0x00, BUFLEN);
    memset(szValue, 0x00, BUFLEN);
    memset(szOpCond, 0x00, BUFLEN);

    nPos = 1;
    nLen = 3;
    sprintf((char*)szType1, "%s", "ZD");
    sprintf((char*)szType2, "%s", "Z");
    sprintf((char*)szValue, "%s", "100");
    sprintf((char*)szOpCond, "%s", "LT");
    struct condField_t* cf2 = gcs_cond_value(nPos, nLen, szType1, szOpCond, szType2, szValue);

    struct condField_t* cfroot = gcs_cond_AND(cf1, cf2);
    gcs_addOmit(cfroot);

}

void read_file_gnucobol(const char* nome_file) {

    char szBuff[COB_MEDIUM_BUFF];
    cob_file* f = NULL;
    cob_file_malloc(&f, NULL, 0, 0);
    if (f == NULL) {
        fprintf(stdout, "*GCSORT*S771A*ERROR: cob_file allocation failed.\n");
        return ;
    }

    /* Sequential */
    f->organization = COB_ORG_SEQUENTIAL;
    f->access_mode = 1;   /* Accesso sequenziale standard */
    f->flag_optional = 0; /* Genera errore (Status 35) se il file non esiste fisicamente */
    f->record_min = 20;
    f->record_max = 100;

    // Nome logico del file (usato per i report interni di errore del runtime)
    f->select_name = (const char*)"testlibgcs";

    // 4. Configurazione dei campi cob_field (File Name e File Status) secondo le specifiche libcob
    static cob_field_attr name_attr = { COB_TYPE_ALPHANUMERIC, 0, 0, 0, NULL };
    static cob_field name_field;
    name_field.size = strlen(nome_file);
    name_field.data = (unsigned char*) strdup(nome_file);
    name_field.attr = &name_attr;

    f->assign = &name_field; // Assegnazione per la risoluzione automatica delle variabili d'ambiente

    /* Configurazione del File Status (2 byte) come array statico per stabilità di memoria */
    static unsigned char status_buffer[2] = { '0', '0' };
    static cob_field_attr status_attr = { COB_TYPE_ALPHANUMERIC, 0, 0, 0, NULL };

    f->file_status = status_buffer;

    /* Memory allocation input record */
    f->record = (cob_field*)malloc(sizeof(cob_field));
    if (f->record == NULL) {
        cob_file_free(&f, NULL);
        return ;
    }
    f->record->size = f->record_max;
    f->record->attr = &status_attr; // Riutilizza l'attributo alfanumerico standard
    f->record->data = (unsigned char*)malloc(f->record->size);
    if (f->record->data == NULL) {
        free(f->record);
        cob_file_free(&f, NULL);
        return ;
    }
    memset(f->record->data, 0x00, f->record->size);

    /* Open file with cob_open */
    cob_open(f, COB_OPEN_INPUT, 0, NULL);

    if (status_buffer[0] != '0' || status_buffer[1] != '0') {
        fprintf(stderr, "*testlibgcs*S771C*ERROR: Unable to open %s file (File Status: %c%c)\n",
            params.output_file, status_buffer[0], status_buffer[1]);
        free(f->record->data);
        free(f->record);
        cob_file_free(&f, NULL);
        free(name_field.data);
        return ;
    }
    int contatore_record = 1;
    while (1) {
        cob_read(f, NULL, NULL, 0);

        /* check  EOF */
        if (status_buffer[0] == '1' && status_buffer[1] == '0') {
            break;
        }

        /* Check file status */
        if (status_buffer[0] != '0' || status_buffer[1] != '0') {
            fprintf(stderr, "*testlibgcs*S771D*ERROR: Error reading SYMNAMES file (File Status: %c%c)\n",
                status_buffer[0], status_buffer[1]);
            break;
        }
        memset(szBuff, 0x00, COB_MEDIUM_BUFF);
        memcpy(szBuff, (char*) f->record->data, f->record->size);

        int caratteri_da_stampare = (f->record->size > LIMITE_STAMPA) ? (int) LIMITE_STAMPA : (int) f->record->size;
        printf("Rec #%03d | Actual Length: %2zu | Content (First 50 characters):[%.*s]\n",
            contatore_record, f->record->size, caratteri_da_stampare, szBuff);

        contatore_record++;

    }
    cob_close(f, NULL, 0, 0);
    free(f->record->data);
    free(f->record);
    free(name_field.data);
    cob_file_free(&f, NULL);
}


void print_statistics(void)
{
    fprintf(stdout, " Total Records Number..............: " NUM_FMT_LLD "\n", (long long) gcs_stats_rec_total());
    fprintf(stdout, " Total Records Write Sort TMP......: " NUM_FMT_LLD "\n", (long long) gcs_stats_rec_writesort());
    fprintf(stdout, " Total Records Write Output........: " NUM_FMT_LLD "\n", (long long) gcs_stats_rec_writeout());
    fprintf(stdout, " Total Records Omit/Include........: " NUM_FMT_LLD "\n", (long long) gcs_stats_rec_omitinclude());
    fprintf(stdout, " Total Records Discard XSUM Output.: " NUM_FMT_LLD "\n", (long long) gcs_stats_rec_discardXSUM());
}

#ifdef _MSC_VER
// Minimal getopt_long function compatible with Windows
int getopt_long(int argc, char* const argv[], const char* optstring,
    const struct option* longopts, int* longindex)
{
    if (optind >= argc) return -1;

    char* arg = argv[optind];
    if (arg[0] != '-') {
        return -1;
    }

    // Long Options Handling (--option)
    if (arg[0] == '-' && arg[1] == '-') {
        char* name = arg + 2;
        char* equal = strchr(name, '=');
        int name_len = equal ? (int)(equal - name) : (int)strlen(name);

        for (int i = 0; longopts[i].name != NULL; i++) {
            if (strncmp(longopts[i].name, name, name_len) == 0 && longopts[i].name[name_len] == '\0') {
                if (longindex) *longindex = i;

                if (longopts[i].has_arg == required_argument) {
                    if (equal) {
                        optarg = equal + 1;
                    }
                    else {
                        optind++;
                        if (optind < argc) {
                            optarg = argv[optind];
                        }
                        else {
                            optopt = longopts[i].val;
                            if (opterr) fprintf(stderr, "Option requires an argument -- %s\n", name);
                            optind++;
                            return '?';
                        }
                    }
                }
                else {
                    optarg = NULL;
                }
                optind++;
                if (longopts[i].flag) {
                    *longopts[i].flag = longopts[i].val;
                    return 0;
                }
                return longopts[i].val;
            }
        }
        if (opterr) fprintf(stderr, "Unrecognized option -- %s\n", name);
        optind++;
        return '?';
    }

    // Short Options Handling (-o)
    char opt = arg[1];
    char* p = strchr(optstring, opt);
    if (p == NULL || opt == ':') {
        optopt = opt;
        if (opterr) fprintf(stderr, "Invalid option -- %c\n", opt);
        optind++;
        return '?';
    }

    if (*(p + 1) == ':') {
        if (arg[2] != '\0') {
            optarg = arg + 2;
        }
        else {
            optind++;
            if (optind < argc) {
                optarg = argv[optind];
            }
            else {
                optopt = opt;
                if (opterr) fprintf(stderr, "Option requires an argument -- %c\n", opt);
                optind++;
                return '?';
            }
        }
    }
    else {
        optarg = NULL;
    }
    optind++;
    return opt;
}
#endif
// --- END OF COMPATIBILITY SECTION ---

int get_cmdline_params(int argc, char* argv[])
{
        // Initialize structure fields with default values
        memset(&params, 0, sizeof(CmdLineParams));
        params.input_file_count = 0;
        params.output_file = NULL;
        params.sign_ebcdic = 0;
        params.sequence_col = 0;
        params.ebcdic_table = NULL;
        params.operation = NULL;
        params.inrec_flag = 0;
        params.outrec_flag = 0;
        params.include_flag = 0;
        params.omit_flag = 0;

        int opt;
        int option_index = 0;
        opterr = 0;

        if (argc == 1) {
            print_help(argv[0]);
            return 1;
        }

        // Aggiunte 'I' e 'O' (case-sensitive nel parser) alla stringa delle opzioni corte. Rimossi i vecchi 'K' e 'T'.
        while ((opt = getopt_long(argc, argv, "i:o:sc:t:p:RWIOh", long_options, &option_index)) != -1) {
            switch (opt) {
            case 'h':
                print_help(argv[0]);
                return 1;

            case 'i': /* Save into the struct array */
                if (params.input_file_count < MAX_FILES) {
                    params.input_files[params.input_file_count++] = optarg;
                }
                else {
                    fprintf(stderr, "Error: Maximum limit of %d input files exceeded.\n", MAX_FILES);
                    return 1;
                }
                break;

            case 'o': /* Save directly by field name */
                params.output_file = optarg;
                break;

            case 's':
                params.sign_ebcdic = 1;
                break;

            case 'c':
                params.sequence_col = atoi(optarg);
                break;

            case 't':
                params.ebcdic_table = (unsigned char*)optarg;
                break;

            case 'p':
                if (STRCASECMP(optarg, "Sort") == 0 || STRCASECMP(optarg, "Merge") == 0 || STRCASECMP(optarg, "Copy") == 0) {
                    params.operation = optarg;
                }
                else {
                    fprintf(stderr, "Error: --operation only accepts 'Sort', 'Merge' or 'Copy'. Provided: %s\n", optarg);
                    return 1;
                }
                break;

            case 'R':
                params.inrec_flag = 1;
                break;

            case 'W':
                params.outrec_flag = 1;
                break;

            case 'I': // Gestisce sia -I che --include
                params.include_flag = 1;
                break;

            case 'O': // Gestisce sia -O che --omit
                params.omit_flag = 1;
                break;

            case '?':
                if (optopt == 'i' || optopt == 'o' || optopt == 'c' || optopt == 't' || optopt == 'p') {
                    fprintf(stderr, "Error: The selected option requires a value.\n");
                }
                else {
                    fprintf(stderr, "Error: Unknown option. Use --help to view valid options.\n");
                }
                return 1;

            default:
                return 1;
            }
        }

    if (params.input_file_count == 0) {
        params.input_file_count++;
        params.input_files[0] = calloc(COB_MEDIUM_BUFF, sizeof(char));
        strcpy(params.input_files[0], "../files/extsm_inputsqv.dat");
        gnAlloc_manual_inp = 1;
    }

    if (params.output_file == NULL) {
        params.output_file = calloc(COB_MEDIUM_BUFF, sizeof(char));
        gnAlloc_manual_out = 1;
        strcpy(params.output_file, "../files/extsm_outputsqv.dat");
    }


    // --- Summary using the struct fields ---
    printf("\n--- Start Parameter Summary ---\n");
    printf("Input Files (%d): \n", params.input_file_count);
    for (int i = 0; i < params.input_file_count; i++) {
        printf("  - %s\n", params.input_files[i]);
    }
    printf("Output File: %s\n", params.output_file ? params.output_file : "Not specified");
    printf("Sign EBCDIC: %s\n", params.sign_ebcdic ? "Enabled" : "Disabled");
    printf("Sequence Col: %d\n", params.sequence_col);
    printf("EBCDIC Table: %s\n", params.ebcdic_table ? (char*) params.ebcdic_table : "Not specified");
    printf("Operation: %s\n", params.operation ? params.operation : "Not specified");
    printf("Inrec   Flag: %s\n", params.inrec_flag ? "Enabled" : "Disabled");
    printf("Outrec  Flag: %s\n", params.outrec_flag ? "Enabled" : "Disabled");
    printf("Include Flag: %s\n", params.include_flag ? "Enabled" : "Disabled");
    printf("Omit    Flag: %s\n", params.omit_flag ? "Enabled" : "Disabled");
    printf("--- End  Parameter Summary ---\n");

    return 0;
}

// Function dedicated to printing the help menu
void print_help(const char* program_name) {
    printf("\n=== Help ===\n");
    printf("Usage: %s [OPTIONS]\n\n", program_name);
    printf("Available Options:\n");
    printf("  -i, --input-file  <file>  Specify an input file (can be repeated up to %d times). (Default: ../files/extsm_inputsqv.dat)\n", MAX_FILES);
    printf("  -o, --output-file <file>  Specify the output file. (Default: ../files/extsm_outputsqv.dat)\n");
    printf("  -s, --sign-ebcdic         Enable EBCDIC sign (takes no arguments).\n");
    printf("  -c, --sequence-col <num>  Specify the sequence column (numeric value). [NATIVE = 0 | ASCII = 1 | EBCDIC = 2] \n");
    printf("  -t, --ebcdic-table <Name> Specify the EBCDIC table file.\n");
    printf("  -p, --operation <type>    Specify the operation to run. Accepted values: 'Sort', 'Merge' or 'Copy'.\n");
    printf("      --inrec               Enable INREC processing (takes no arguments).\n");
    printf("      --outrec              Enable OUTREC processing (takes no arguments).\n");
    printf("      --include             Enable Include processing (takes no arguments).\n");
    printf("      --omit                Enable Omit processing (takes no arguments).\n");
    printf("  -h, --help                Show this help screen.\n\n");
    printf("\n\n Example:\n");
    printf("   testlibgcs -p SORT\n");
    printf("   testlibgcs -p SORT --inrec\n");
    printf("   testlibgcs -p SORT --outrec\n");
    printf("   testlibgcs -p SORT --include\n");
    printf("   testlibgcs -p SORT --omit\n");
    printf("   testlibgcs -p SORT  -i ../files/extsm_inputsqv.dat -o  ../files/extsm_outputsqv.dat --inrec \n");
    printf("   testlibgcs -p MERGE -i ../files/extsm_inputsqv.dat -i  ../files/extsm_inputsqv.dat -o ../files/extsm_outputsqv.dat\n");
}