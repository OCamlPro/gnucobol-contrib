/*
    Copyright (C) 2016-2024 Sauro Menna
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

#ifndef SYMNAMES_H_INCLUDED
#define SYMNAMES_H_INCLUDED 

#define MAX_SYM_NAME 50
#define MAX_FORMAT_LEN 4
#define MAX_LINE_LEN 80
#define INITIAL_CAPACITY 32

/* --- DATA STRUCTURES --- */
enum SymbolType {
    SYM_TYPE_FIELD,
    SYM_TYPE_CONSTANT
};

struct Symbol {
    char name[MAX_SYM_NAME + 1];
    enum SymbolType type;
    int position;
    int length;
    char format[MAX_FORMAT_LEN + 1];
    char* constant_value;
};

int add_symb_table(struct Symbol sym);
struct Symbol* find_symbol(const char* name);
void free_symb_table(void);
void parse_symnames_line(const char* line);
int  load_file_symnames(void);
int  load_buf_symnames(const char* out_buf, size_t out_size);
int  is_symb_char(char c);
int  translate_symbols(const char* cmd_in, char* cmd_out);
int convert_symbols_cmdline(char* cmd_in, char* cmd_out, int nOrigin, char* szTakeBuf);
void filter_Take_buffer(const char* in_buf, size_t in_size, char* out_buf, char* take_buf);
void replace_characters_with_space(char* buffer, size_t buffer_size);
void trim_and_replace_newlines(char* buffer, size_t buffer_size);


#endif /* SYMNAMES_H_INCLUDED   */
