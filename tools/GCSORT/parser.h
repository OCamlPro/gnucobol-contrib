/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     AND = 258,
     COND = 259,
     ENDREC = 260,
     FNAMES = 261,
     FORMAT = 262,
     INCLUDE = 263,
     INREC = 264,
     NONE = 265,
     OMIT = 266,
     OPTION = 267,
     OR = 268,
     OUTFIL = 269,
     OUTREC = 270,
     SAVE = 271,
     SKIPREC = 272,
     STARTREC = 273,
     STOPAFT = 274,
     SUM = 275,
     SPLIT = 276,
     SPLITBY = 277,
     VLSCMP = 278,
     VLSHRT = 279,
     Y2PAST = 280,
     MODS = 281,
     EXROUT = 282,
     BUILD = 283,
     FIELDS = 284,
     OVERLAY = 285,
     GIVE = 286,
     MERGE = 287,
     ORG = 288,
     RECORD = 289,
     SORT = 290,
     JOINKEYS = 291,
     USE = 292,
     COPY = 293,
     TYPE = 294,
     LENGTH = 295,
     DATE1 = 296,
     DATE2 = 297,
     DATE3 = 298,
     DATE4 = 299,
     CHANGE = 300,
     NOMATCH = 301,
     SORTED = 302,
     NOSEQCK = 303,
     UNPAIRED = 304,
     ONLY = 305,
     JOIN = 306,
     JOINREFORMAT = 307,
     FILL = 308,
     DIGIT = 309,
     DIGITBIG = 310,
     CHARTCOND = 311,
     CHARTYPE = 312,
     FILETYPE = 313,
     FORMATTYPE = 314,
     JOINFILE = 315,
     KEY = 316,
     KEYTYPE = 317,
     OCCURFILL = 318,
     OPCOND = 319,
     ORDER = 320,
     RECTYPEFIX = 321,
     RECTYPEVAR = 322,
     STRING = 323,
     TOKSKIP = 324,
     SIGNDIGITBIG = 325
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2058 of yacc.c  */
#line 23 "..\\..\\parser.y"
 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t  *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t   *SumField;
    struct changefield_t *changefield;


/* Line 2058 of yacc.c  */
#line 140 "..\\..\\parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_PARSER_H_INCLUDED  */
