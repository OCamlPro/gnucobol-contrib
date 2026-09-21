/*
    Copyright (C) 2016-2026 Sauro Menna
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
 *
 *  Generated with the support of the AI Assistant
*/

#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symnames.h"
#include "gcshare.h"
#include "gcsort.h"
#include "libgcsort.h"
#include "job.h"
#include "utils.h"



/* Global state variables for the emulator */
struct Symbol *symb_table = NULL;
int symb_count = 0;
int symb_capacity = 0;
int current_position = 1;

/* Global flag for GnuCOBOL vs Mainframe hardware compatibility 
   0 = Native GnuCOBOL (compact records, ALIGN is ignored)
   1 = IBM z/OS Emulation (calculates Slack Bytes for ALIGN) */
int MAINFRAME_COMPAT_MODE = 0;

/* --- SYMBOL TABLE MANAGEMENT FUNCTIONS --- */

/* Initializes or dynamically expands the symbol table to prevent static overflows */
int add_symb_table(struct Symbol sym) {
    if (symb_table == NULL) {
        symb_capacity = INITIAL_CAPACITY;
        symb_table = (struct Symbol *)malloc(symb_capacity * sizeof(struct Symbol));
        if (symb_table == NULL) return -1;
    } else if (symb_count >= symb_capacity) {
        symb_capacity *= 2;
        struct Symbol *temp = (struct Symbol *)realloc(symb_table, symb_capacity * sizeof(struct Symbol));
        if (temp == NULL) return -1;
        symb_table = temp;
    }
    
    symb_table[symb_count] = sym;
    symb_count++;
    return 0;
}

/* Searches for a symbol in the table by its name */
struct Symbol* find_symbol(const char *name) {
    for (int i = 0; i < symb_count; i++) {
        if (strcmp(symb_table[i].name, name) == 0) {
            return &symb_table[i];
        }
    }
    return NULL;
}

/* Releases dynamic memory allocated for the symbol table and string constants */
void free_symb_table(void) {
    if (symb_table != NULL) {
        for (int i = 0; i < symb_count; i++) {
            if (symb_table[i].type == SYM_TYPE_CONSTANT && symb_table[i].constant_value != NULL) {
                free(symb_table[i].constant_value);
            }
        }
        free(symb_table);
        symb_table = NULL;
    }
    symb_count = 0;
    symb_capacity = 0;
}

/* --- SYMNAMES CONTROL STATEMENT PARSING --- */
void parse_symnames_line(const char *line) {
    // Skip leading whitespaces and tabs
    while (*line == ' ' || *line == '\t') line++;

    // Skip standard SYMNAMES comments (asterisk at start of line) or empty lines
    if (*line == '*' || *line == '\0' || *line == '\n' || *line == '\r') 
        return;

    // 1. Handle "SKIP" directive (Syntax: SKIP,n)
    if (strncmp(line, "SKIP,", 5) == 0) {
        int bytes_to_skip = atoi(line + 5);
        if (bytes_to_skip > 0) {
            current_position += bytes_to_skip;
        }
        return;
    }

    // 2. Handle "ALIGN" directive (Syntax: ALIGN,x) Tailored for GnuCOBOL environment
    if (strncmp(line, "ALIGN,", 6) == 0) {
        char alignment_type = line[6];
        
        // If in native GnuCOBOL mode, ignore hardware alignment (no Slack Bytes)
        if (MAINFRAME_COMPAT_MODE == 0) {
            return; 
        }

        int alignment_boundary = 1;
        switch (alignment_type) {
            case 'H': case 'h': alignment_boundary = 2; break; // Halfword
            case 'F': case 'f': alignment_boundary = 4; break; // Fullword
            case 'D': case 'd': alignment_boundary = 8; break; // Doubleword
            default: return; // Invalid type, skip
        }

        int remainder = (current_position - 1) % alignment_boundary;
        if (remainder != 0) {
            current_position += (alignment_boundary - remainder);
        }
        return;
    }

    // 3. Parse generic tokens (Fields or Constants)
    char name[MAX_SYM_NAME + 1] = {0};
    char pos_str[16] = {0};
    int len = 0;
    char fmt[MAX_FORMAT_LEN + 1] = {0};

    // Check for FIELD format (name,position,length,format)
    int parsed = sscanf(line, " %50[^,],%15[^,],%d,%4s", name, pos_str, &len, fmt);

    if (parsed == 4) {
        struct Symbol s;
        memset(&s, 0, sizeof(struct Symbol));
        strncpy(s.name, name, MAX_SYM_NAME);
        s.type = SYM_TYPE_FIELD;
        strncpy(s.format, fmt, MAX_FORMAT_LEN);
        s.length = len;

        // Handle special asterisk '*' character for relative positioning
        if (strcmp(pos_str, "*") == 0) {
            s.position = current_position;
        } else {
            s.position = atoi(pos_str);
            current_position = s.position; // Sync pointer to the explicit position
        }

        // Advance current position based on field length
        current_position += s.length;
        
        add_symb_table(s);
    } 
    else {
        // --- CONSTANT HANDLING SECTION INCLUDING HEXADECIMAL SUPPORT ---
        char const_val[MAX_LINE_LEN] = {0};
        char type_prefix = 0;

        // Case A: Explicit hex or character prefix syntax (e.g. Name,X'001F' or Name,C'TEST')
        parsed = sscanf(line, " %50[^,],%c'%255[^']'", name, &type_prefix, const_val);

        if (parsed == 3 && (type_prefix == 'X' || type_prefix == 'x')) {
            // Hexadecimal constant detected
            struct Symbol s;
            memset(&s, 0, sizeof(struct Symbol));
            strncpy(s.name, name, MAX_SYM_NAME);
            s.type = SYM_TYPE_CONSTANT;

            // Retain the standard z/OS X'value' notation for GCSORT compatibility
            size_t req_len = strlen(const_val) + 6; 
            s.constant_value = (char *)malloc(req_len);
            if (s.constant_value != NULL) {
                snprintf(s.constant_value, req_len, "X('%s')", const_val);
                add_symb_table(s);
            }
            return;
        }
        else if (parsed == 3 && (type_prefix == 'C' || type_prefix == 'c')) {
            // Explicit character constant detected (C'abc')
            struct Symbol s;
            memset(&s, 0, sizeof(struct Symbol));
            strncpy(s.name, name, MAX_SYM_NAME);
            s.type = SYM_TYPE_CONSTANT;

            size_t req_len = strlen(const_val) + 6;
            s.constant_value = (char *)malloc(req_len);
            if (s.constant_value != NULL) {
                snprintf(s.constant_value, req_len, "C'%s'", const_val);
                add_symb_table(s);
            }
            return;
        }

        // Case B: Implicit constant syntax without prefix (e.g. Name,'value')
        parsed = sscanf(line, " %50[^,],'%255[^']'", name, const_val);
        if (parsed == 2) {
            struct Symbol s;
            memset(&s, 0, sizeof(struct Symbol));
            strncpy(s.name, name, MAX_SYM_NAME);
            s.type = SYM_TYPE_CONSTANT;
            
            size_t req_len = strlen(const_val) + 4; 
            s.constant_value = (char *)malloc(req_len);
            if (s.constant_value != NULL) {
                snprintf(s.constant_value, req_len, "'%s'", const_val);
                add_symb_table(s);
            }
        }
    }
}

/* --- BINARY LOADING AND SANITIZATION FUNCTION --- */
extern int symb_count;

int load_file_symnames(void) {
    // 1. Verifica preliminare della presenza della variabile d'ambiente
    int nOrg = 1; /* COB_ORG_LINE_SEQUENTIAL */
    char* pOrgFile = getenv("SYMORG");
    if (pOrgFile != NULL) {
        if ((strcasecmp(pOrgFile, "LS") == 0) || (strcasecmp(pOrgFile, "LSF") == 0))
            nOrg = 1;
        else
        {
            if (strcasecmp(pOrgFile, "SQ") == 0)
                nOrg = 0;   /* COB_ORG_SEQUENTIAL */
            else
            {
                fprintf(stdout, "*GCSORT*S770*ERROR: Env Variable SYMORG invalid : %s. Valid are SQ, LF, LSF.\n", pOrgFile);
                return -1;
            }
        }
    }

    cob_file* file_symb = NULL;
    cob_file_key* keys = NULL;

    cob_file_malloc(&file_symb, &keys, 0, 0);
    if (file_symb == NULL) {
        fprintf(stdout, "*GCSORT*S770A*ERROR: cob_file allocation failed.\n");
        return -1;
    }

    file_symb->organization = nOrg; /* default : COB_ORG_LINE_SEQUENTIAL */
    file_symb->access_mode = 1;   
    file_symb->flag_optional = 0; 
    file_symb->record_min = 1;
    file_symb->record_max = MAX_LINE_LEN;

    /* Logical name */ 
    file_symb->select_name = (const char*)"SYMNAMES";

    static cob_field_attr name_attr = { COB_TYPE_ALPHANUMERIC, 0, 0, 0, NULL };
    static cob_field name_field;
    name_field.size = 8; // Lunghezza del nome logico "SYMNAMES"
    name_field.data = (unsigned char*)"SYMNAMES";
    name_field.attr = &name_attr;

    file_symb->assign = &name_field; // Assegnazione per la risoluzione automatica delle variabili d'ambiente

    // File Status (2 bytes)
    static unsigned char status_buffer[2] = { '0', '0' };
    static cob_field_attr status_attr = { COB_TYPE_ALPHANUMERIC, 0, 0, 0, NULL };
    static cob_field file_status_field;
    file_status_field.size = 2;
    file_status_field.data = status_buffer;
    file_status_field.attr = &status_attr;

    file_symb->file_status = status_buffer;

    /* Memory allocation for input record */
    file_symb->record = (cob_field*)malloc(sizeof(cob_field));
    if (file_symb->record == NULL) {
        cob_file_free(&file_symb, &keys);
        return -1;
    }
    file_symb->record->size = file_symb->record_max;
    file_symb->record->attr = &status_attr; // Riutilizza l'attributo alfanumerico standard
    file_symb->record->data = (unsigned char*)malloc(file_symb->record->size);
    if (file_symb->record->data == NULL) {
        free(file_symb->record);
        cob_file_free(&file_symb, &keys);
        return -1;
    }
    memset(file_symb->record->data, ' ', file_symb->record->size);


    /* Open File */
    cob_open(file_symb, COB_OPEN_INPUT, 0, NULL);

    // Analisi del File Status di apertura
    if (status_buffer[0] != '0' || status_buffer[1] != '0') {
        fprintf(stderr, "*GCSORT*S770C*ERROR: Unable to open SYMNAMES file (File Status: %c%c), ORG file is %s\n",
            status_buffer[0], status_buffer[1], pOrgFile);
        free(file_symb->record->data);
        free(file_symb->record);
        cob_file_free(&file_symb, &keys);
        return -1;
    }

    /* Read row */
    while (1) {
        cob_read(file_symb, NULL, NULL, 0);

        /* check EOF */
        if (status_buffer[0] == '1' && status_buffer[1] == '0') {
            break;
        }

        /* check File Status */
        if (status_buffer[0] != '0' || status_buffer[1] != '0') {
            fprintf(stderr, "*GCSORT*S770D*ERROR: Error reading SYMNAMES file (File Status: %c%c), ORG file is %s\n",
                status_buffer[0], status_buffer[1], pOrgFile);
            break;
        }

        /* row size and trim right spaces */
        size_t bytes_read = file_symb->record->size;
        while (bytes_read > 0 && file_symb->record->data[bytes_read - 1] == ' ') {
            bytes_read--;
        }

         if (bytes_read > 0 && file_symb->record->data[bytes_read - 1] == '\r') {
            bytes_read--;
        }

        if (bytes_read == 0) {
            continue; /* skip empty row */
        }

        size_t extra_spaces = 0;
        for (size_t i = 0; i < bytes_read; i++) {
            if (file_symb->record->data[i] == '\t') {
                extra_spaces += 3; // 1 TAB diventa 4 spazi (+3 rispetto al singolo byte corrente)
            }
        }

        char* clean_line = (char*)malloc(bytes_read + extra_spaces + 1);
        if (clean_line == NULL) {
            fprintf(stderr, "*GCSORT*S770E*ERROR: Out of memory during line sanitization.\n");
            break;
        }

        // Copia e mappatura binaria del contenuto del record
        size_t dst = 0;
        for (size_t src = 0; src < bytes_read; src++) {
            if (file_symb->record->data[src] == '\0') {
                clean_line[dst++] = ' '; /* Sostituisce i NULL binari con uno spazio sicuro */
            }
            else if (file_symb->record->data[src] == '\t') {
                clean_line[dst++] = ' '; /* Espande il carattere TAB in 4 spazi reali */
                clean_line[dst++] = ' ';
                clean_line[dst++] = ' ';
                clean_line[dst++] = ' ';
            }
            else {
                clean_line[dst++] = (char)file_symb->record->data[src];
            }
        }
        clean_line[dst] = '\0'; /* Chiusura della stringa standard C garantita */

        /* parse line */
        parse_symnames_line(clean_line);

        free(clean_line);
    }

    /* Close file and release memory */
    cob_close(file_symb, NULL, 0, 0);
    free(file_symb->record->data);
    free(file_symb->record);
    cob_file_free(&file_symb, &keys);

    return symb_count;
}


int load_buf_symnames(const char* out_buf, size_t out_size) {
    const char* current = out_buf;
    const char* out_end = out_buf + out_size;
    int record_counter = 1;

    while (current < out_end && *current != '\0') {
        /* Find the next Line Feed '\n' character */
        const char* next_nl = strchr(current, '\n');

        /* Safety check to ensure strchr doesn't overshoot the buffer boundaries */
        if (next_nl == NULL || next_nl >= out_end) {
            next_nl = out_end;
        }

        /* Calculate the length of the current record (excluding the '\n')  */
        size_t record_len = next_nl - current;

        /* Handle Carriage Return (\r) for Windows-style CRLF line endings  */
        size_t text_len = record_len;
        if (text_len > 0 && current[text_len - 1] == '\r') {
            text_len--; // Exclude '\r' from the printable text length
        }

        /* Process the record if it contains valid data (skipping empty lines if desired)  */
        if (text_len > 0) {
            parse_symnames_line(current);
            record_counter++;
        }

        /* Advance the pointer to the next record (past the '\n' character)  */
        if (next_nl < out_end) {
            current = next_nl + 1;
        }
        else {
            break; /* End of buffer reached */
        }
    }
    return 0;
}


/* --- TOKEN INTERCEPTION AND SYSIN STATEMENT TRANSLATION --- */
int is_symb_char(char c) {
	return isalnum((unsigned char)c) || c == '_' || c == '-' || c == '#' || c == '$' || c == '@';
	}

/* --- DYNAMIC TOKEN INTERCEPTION AND SYSIN TRANSLATION --- */

/* Translates the original SYSIN by expanding symbols. 
   Allocates and expands the output buffer dynamically as needed.
   RETURNS: A dynamically allocated null-terminated string, or NULL on memory failure. */

int translate_symbols(const char *cmd_in, char* cmd_out) {
    size_t src = 0;
    size_t dst = 0;
    
    if (cmd_out == NULL) {
        return -1;
    }

    while (cmd_in[src] != '\0') {
        
        /* Safety check: ensure we have enough space for at least COB_MEDIUM_BUFF bytes ahead. */
        /* If the remaining space is getting tight, expand the buffer dynamically.             */
        if (dst >= COB_MEDIUM_BUFF) {
            fprintf(stdout, "*GCSORT*S001E*ERROR: current_capacity >= COB_MEDIUM_BUFF(%d)\n", COB_MEDIUM_BUFF);
            return -1; // Memory allocation failed
        }
        /* Detect start of a literal token (must not start with a digit or a hyphen) */
        if (is_symb_char(cmd_in[src]) && !isdigit((unsigned char)cmd_in[src]) && cmd_in[src] != '-') {
            char token[MAX_SYM_NAME + 1];
            size_t token_len = 0;

            while (cmd_in[src] != '\0' && is_symb_char(cmd_in[src]) && token_len < MAX_SYM_NAME) {
                token[token_len++] = cmd_in[src++];
            }
            token[token_len] = '\0';

            /* Verify mapping against the compiled symbol table */
            struct Symbol *sym = find_symbol(token);
            if (sym != NULL) {
                char exp_buf[COB_MEDIUM_BUFF];
                
                if (sym->type == SYM_TYPE_FIELD) {
                    snprintf(exp_buf, sizeof(exp_buf), "%d,%d,%s", sym->position, sym->length, sym->format);
                } else {
                    snprintf(exp_buf, sizeof(exp_buf), "%s", sym->constant_value);
                }

                size_t exp_len = strlen(exp_buf);
                strcpy(&cmd_out[dst], exp_buf);
                dst += exp_len;
            } else {
                /* Not a registered symbol: copy the standard control keyword as-is (e.g. SORT, FIELDS) */
                size_t tok_len = strlen(token);
                strcpy(&cmd_out[dst], token);
                dst += tok_len;
            }
        } else {
            /* Direct copy of structural symbols and delimiters(parentheses, commas, spaces, equals) */
            cmd_out[dst++] = cmd_in[src++];
        }
    }
    
    cmd_out[dst] = '\0';
    return 0;
}

int convert_symbols_cmdline(char *cmd_in, char* cmd_out, int nOrigin, char* szTakeBuf) {
    int result = 0;
    int nRC = 0;
    size_t szb = 0;
    size_t szbout = 0;

    char* szNewcmdIn = (char*)malloc(COB_MEDIUM_BUFF);
    memset(szNewcmdIn, 0x00, COB_MEDIUM_BUFF);

    /* Deep reset of the internal state to support sequential multiple calls safely */
    free_symb_table();
    current_position = 1; 
    
    /*  Configure ALIGN behavior : 0 = GnuCOBOL(Default), 1 = Mainframe hardware */
    MAINFRAME_COMPAT_MODE = 0; 

    if (nOrigin == GC_TAKEFILE) {
        szb = strlen(cmd_in);
        memset(szTakeBuf, 0x00, strlen(cmd_in));
        filter_Take_buffer(cmd_in, szb, szTakeBuf, szNewcmdIn);
        result = load_buf_symnames(szTakeBuf, strlen(szTakeBuf));
        nRC = translate_symbols(szNewcmdIn, cmd_out);
        memset(cmd_in, 0x00, COB_MEDIUM_BUFF);
        memcpy(cmd_in, cmd_out, COB_MEDIUM_BUFF);
    } else {
        result = load_file_symnames();
        if (result >= 0) {
            nRC = translate_symbols(cmd_in, cmd_out);
            memset(cmd_in, 0x00, COB_MEDIUM_BUFF);
            memcpy(cmd_in, cmd_out, COB_MEDIUM_BUFF);
        }
        else
            nRC = 16;
    }
    free(szNewcmdIn);
    free_symb_table();

    return nRC;
}

void filter_Take_buffer(const char* in_buf, size_t in_size, char* out_buf, char* take_buf) {
    const char* current = in_buf;
    const char* in_end = in_buf + in_size;
    char* write_ptr = out_buf;
    char* take_ptr = take_buf;

    int inside_block = 0; /* Flag to track if we are between SYMNAMES and END */

    while (current < in_end && *current != '\0') {
        /* Find the end of the current line */
        const char* next_nl = strchr(current, '\n');
        if (next_nl == NULL || next_nl >= in_end) {
            next_nl = in_end;
        }

        /* Calculate the total line length(including newline characters) */
        size_t total_line_len = next_nl - current;
        if (next_nl < in_end) {
            total_line_len++; // Include the '\n' character
        }

        /* Calculate the text length (excluding \r and \n for string comparison) */
        size_t text_len = total_line_len;
        while (text_len > 0 && (current[text_len - 1] == '\n' || current[text_len - 1] == '\r')) {
            text_len--;
        }

        /* Check for block start marker */
        if (text_len >= 8 && strncmp(current, "SYMNAMES", 8) == 0) {
            inside_block = 1;
            /* Advance to the next record without copying this marker */
            current += total_line_len;
            continue;
        }

        /* Check for block end marker */
        if (text_len >= 3 && strncmp(current, "END", 3) == 0) {
            inside_block = 0;
            // Advance to the next record without copying this marker
            current += total_line_len;
            continue;
        }

        if (inside_block && total_line_len > 0) {
            memcpy(write_ptr, current, total_line_len);
            write_ptr += total_line_len;
        }
        /* If the line is OUTSIDE the SYMNAMES/END block, copy it to the output buffer */
        if (!inside_block && total_line_len > 0) {
            memcpy(take_ptr, current, total_line_len);
            take_ptr += total_line_len;
        }

        /* Advance to the next record */
        current += total_line_len;
    }

    /* Null-terminate the output buffer */
    *write_ptr = '\0';

}

void replace_characters_with_space(char* buffer, size_t buffer_size) {
    char* current = buffer;
    char* buffer_end = buffer + buffer_size;

    /* Loop through the buffer character by character in - place */
    while (current < buffer_end && *current != '\0') {
        /* Check if the current character matches any of the targets */
        if (*current == '\n' || *current == '\r' || *current == 'd') {
            *current = ' '; // Replace with a space
        }
        current++; /* Move to the next character */
    }
}


void trim_and_replace_newlines(char* buffer, size_t buffer_size) {
    if (buffer == NULL || buffer_size == 0 || *buffer == '\0') {
        return;
    }

    char* read_ptr = buffer;
    char* write_ptr = buffer;
    char* buffer_end = buffer + buffer_size;

    int last_was_newline = 0;

    while (read_ptr < buffer_end && *read_ptr != '\0') {
        if (*read_ptr == '\n' || *read_ptr == '\r') {
            if (!last_was_newline) {
                // RIGHT TRIM
                while (write_ptr > buffer && isspace((unsigned char)*(write_ptr - 1))) {
                    write_ptr--;
                }

                *write_ptr = ' ';
                write_ptr++;

                last_was_newline = 1;
            }
            read_ptr++;
        }
        else {
            /* write char */
            *write_ptr = *read_ptr;
            write_ptr++;
            read_ptr++;
            last_was_newline = 0; 
        }
    }

    /* If the entire buffer ends with a space, final trim */
    if (write_ptr > buffer && isspace((unsigned char)*(write_ptr - 1))) {
        write_ptr--;
    }

    /* Closes the in-place-remodeled string */
    *write_ptr = '\0';
}
