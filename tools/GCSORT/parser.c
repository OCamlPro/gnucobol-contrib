/* A Bison parser, made by GNU Bison 3.7.5.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30705

/* Bison version string.  */
#define YYBISON_VERSION "3.7.5"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1





# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "parser.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_AND = 3,                        /* "AND clause"  */
  YYSYMBOL_COND = 4,                       /* "COND clause"  */
  YYSYMBOL_ENDREC = 5,                     /* "ENDREC clause"  */
  YYSYMBOL_FNAMES = 6,                     /* "FNAMES clause"  */
  YYSYMBOL_FORMAT = 7,                     /* "FORMAT clause"  */
  YYSYMBOL_INCLUDE = 8,                    /* "INCLUDE clause"  */
  YYSYMBOL_INREC = 9,                      /* "INREC clause"  */
  YYSYMBOL_NONE = 10,                      /* "NONE clause"  */
  YYSYMBOL_OMIT = 11,                      /* "OMIT clause"  */
  YYSYMBOL_OPTION = 12,                    /* "OPTION clause"  */
  YYSYMBOL_OR = 13,                        /* "OR clause"  */
  YYSYMBOL_OUTFIL = 14,                    /* "OUTFIL clause"  */
  YYSYMBOL_OUTREC = 15,                    /* "OUTREC clause"  */
  YYSYMBOL_SAVE = 16,                      /* "SAVE clause"  */
  YYSYMBOL_SKIPREC = 17,                   /* "SKIP clause"  */
  YYSYMBOL_STARTREC = 18,                  /* "STARTREC clause"  */
  YYSYMBOL_STOPAFT = 19,                   /* "STOPAFT clause"  */
  YYSYMBOL_SUM = 20,                       /* "SUM clause"  */
  YYSYMBOL_SPLIT = 21,                     /* "SPLIT clause"  */
  YYSYMBOL_SPLITBY = 22,                   /* "SPLITBY clause"  */
  YYSYMBOL_VLSCMP = 23,                    /* "VLSCMP clause"  */
  YYSYMBOL_VLSHRT = 24,                    /* "VLSHRT clause"  */
  YYSYMBOL_Y2PAST = 25,                    /* "Y2PAST clause"  */
  YYSYMBOL_MODS = 26,                      /* "MODS clause"  */
  YYSYMBOL_BUILD = 27,                     /* "BUILD instruction"  */
  YYSYMBOL_FIELDS = 28,                    /* "FIELDS instruction"  */
  YYSYMBOL_OVERLAY = 29,                   /* "OVERLAY instruction"  */
  YYSYMBOL_GIVE = 30,                      /* "GIVE clause"  */
  YYSYMBOL_MERGE = 31,                     /* "MERGE clause"  */
  YYSYMBOL_ORG = 32,                       /* "ORG instruction"  */
  YYSYMBOL_RECORD = 33,                    /* "RECORD instruction"  */
  YYSYMBOL_SORT = 34,                      /* "SORT clause"  */
  YYSYMBOL_JOINKEYS = 35,                  /* "JOINKEYS clause"  */
  YYSYMBOL_USE = 36,                       /* "USE clause"  */
  YYSYMBOL_COPY = 37,                      /* "COPY"  */
  YYSYMBOL_TYPE = 38,                      /* "TYPE"  */
  YYSYMBOL_LENGTH = 39,                    /* "LENGTH"  */
  YYSYMBOL_DATE1 = 40,                     /* "DATE1"  */
  YYSYMBOL_DATE2 = 41,                     /* "DATE2"  */
  YYSYMBOL_DATE3 = 42,                     /* "DATE3"  */
  YYSYMBOL_DATE4 = 43,                     /* "DATE4"  */
  YYSYMBOL_CHANGE = 44,                    /* "CHANGE"  */
  YYSYMBOL_NOMATCH = 45,                   /* "NOMATCH"  */
  YYSYMBOL_SORTED = 46,                    /* "SORTED"  */
  YYSYMBOL_NOSEQCK = 47,                   /* "NOSEQCK"  */
  YYSYMBOL_UNPAIRED = 48,                  /* "UNPAIRED"  */
  YYSYMBOL_ONLY = 49,                      /* "ONLY"  */
  YYSYMBOL_JOIN = 50,                      /* "JOIN"  */
  YYSYMBOL_JOINREFORMAT = 51,              /* "JOINREFORMAT"  */
  YYSYMBOL_FILL = 52,                      /* "FILL"  */
  YYSYMBOL_FINDREP = 53,                   /* "FINDREP"  */
  YYSYMBOL_INFR = 54,                      /* "IN"  */
  YYSYMBOL_OUTFR = 55,                     /* "OUT"  */
  YYSYMBOL_INOUT = 56,                     /* "INOUT"  */
  YYSYMBOL_STARTPOS = 57,                  /* "STARTPOS"  */
  YYSYMBOL_ENDPOS = 58,                    /* "ENDPOS"  */
  YYSYMBOL_DO = 59,                        /* "DO"  */
  YYSYMBOL_MAXLEN = 60,                    /* "MAXLEN"  */
  YYSYMBOL_OVERRUN = 61,                   /* "OVERRUN"  */
  YYSYMBOL_SHIFT = 62,                     /* "SHIFT"  */
  YYSYMBOL_DIGIT = 63,                     /* "DIGIT"  */
  YYSYMBOL_DIGITBIG = 64,                  /* "DIGITBIG"  */
  YYSYMBOL_CHARTCOND = 65,                 /* "CHARTCOND"  */
  YYSYMBOL_CHARTYPE = 66,                  /* "CHARTYPE"  */
  YYSYMBOL_FILETYPE = 67,                  /* "FILETYPE"  */
  YYSYMBOL_FORMATTYPE = 68,                /* "FORMATTYPE"  */
  YYSYMBOL_JOINFILE = 69,                  /* "JOINFILE"  */
  YYSYMBOL_KEY = 70,                       /* "KEY"  */
  YYSYMBOL_KEYTYPE = 71,                   /* "KEYTYPE"  */
  YYSYMBOL_OCCURFILL = 72,                 /* "OCCURFILL"  */
  YYSYMBOL_OPCOND = 73,                    /* "OPCOND"  */
  YYSYMBOL_SUBSTRING = 74,                 /* "SUBSTRING"  */
  YYSYMBOL_ORDER = 75,                     /* "ORDER"  */
  YYSYMBOL_RECTYPEFIX = 76,                /* "RECTYPEFIX"  */
  YYSYMBOL_RECTYPEVAR = 77,                /* "RECTYPEVAR"  */
  YYSYMBOL_STRING = 78,                    /* "STRING"  */
  YYSYMBOL_TOKSKIP = 79,                   /* "TOKSKIP clause"  */
  YYSYMBOL_EXROUT = 80,                    /* "EXROUT clause"  */
  YYSYMBOL_YESNO = 81,                     /* "YESNO clause"  */
  YYSYMBOL_ERRTRUNC = 82,                  /* "ERRTRUNC clause"  */
  YYSYMBOL_SIGNDIGITBIG = 83,              /* "SIGNDIGITBIG"  */
  YYSYMBOL_84_ = 84,                       /* ','  */
  YYSYMBOL_85_ = 85,                       /* '('  */
  YYSYMBOL_86_ = 86,                       /* ')'  */
  YYSYMBOL_87_ = 87,                       /* '='  */
  YYSYMBOL_88_ = 88,                       /* '?'  */
  YYSYMBOL_89_ = 89,                       /* ':'  */
  YYSYMBOL_YYACCEPT = 90,                  /* $accept  */
  YYSYMBOL_beginning = 91,                 /* beginning  */
  YYSYMBOL_clause = 92,                    /* clause  */
  YYSYMBOL_useclause = 93,                 /* useclause  */
  YYSYMBOL_94_1 = 94,                      /* $@1  */
  YYSYMBOL_giveclause = 95,                /* giveclause  */
  YYSYMBOL_96_2 = 96,                      /* $@2  */
  YYSYMBOL_recordorginstruction = 97,      /* recordorginstruction  */
  YYSYMBOL_allkeyfield = 98,               /* allkeyfield  */
  YYSYMBOL_keyfield = 99,                  /* keyfield  */
  YYSYMBOL_fieldtype = 100,                /* fieldtype  */
  YYSYMBOL_fielddirection = 101,           /* fielddirection  */
  YYSYMBOL_condition = 102,                /* condition  */
  YYSYMBOL_fieldvaluecond = 103,           /* fieldvaluecond  */
  YYSYMBOL_fieldvaluerec = 104,            /* fieldvaluerec  */
  YYSYMBOL_fieldvalueconst = 105,          /* fieldvalueconst  */
  YYSYMBOL_allsortfield = 106,             /* allsortfield  */
  YYSYMBOL_sortfield = 107,                /* sortfield  */
  YYSYMBOL_sortclause = 108,               /* sortclause  */
  YYSYMBOL_109_3 = 109,                    /* $@3  */
  YYSYMBOL_mergeclause = 110,              /* mergeclause  */
  YYSYMBOL_111_4 = 111,                    /* $@4  */
  YYSYMBOL_joinkeysclause = 112,           /* joinkeysclause  */
  YYSYMBOL_113_5 = 113,                    /* $@5  */
  YYSYMBOL_joinkeysalloptions = 114,       /* joinkeysalloptions  */
  YYSYMBOL_joinkeysoptions = 115,          /* joinkeysoptions  */
  YYSYMBOL_joinclause = 116,               /* joinclause  */
  YYSYMBOL_joinoptions = 117,              /* joinoptions  */
  YYSYMBOL_joinreformatclause = 118,       /* joinreformatclause  */
  YYSYMBOL_119_6 = 119,                    /* $@6  */
  YYSYMBOL_fill_char = 120,                /* fill_char  */
  YYSYMBOL_formatclause = 121,             /* formatclause  */
  YYSYMBOL_allcondfield = 122,             /* allcondfield  */
  YYSYMBOL_condfieldcond = 123,            /* condfieldcond  */
  YYSYMBOL_datetype = 124,                 /* datetype  */
  YYSYMBOL_omitclause = 125,               /* omitclause  */
  YYSYMBOL_includeclause = 126,            /* includeclause  */
  YYSYMBOL_allinoutrec = 127,              /* allinoutrec  */
  YYSYMBOL_inoutrec = 128,                 /* inoutrec  */
  YYSYMBOL_findrep_options_all = 129,      /* findrep_options_all  */
  YYSYMBOL_findrep_options = 130,          /* findrep_options  */
  YYSYMBOL_allfieldvaluerec = 131,         /* allfieldvaluerec  */
  YYSYMBOL_inoutfieldvaluerec = 132,       /* inoutfieldvaluerec  */
  YYSYMBOL_changepair = 133,               /* changepair  */
  YYSYMBOL_changepairdet = 134,            /* changepairdet  */
  YYSYMBOL_changeCmdOpt = 135,             /* changeCmdOpt  */
  YYSYMBOL_outrecclause = 136,             /* outrecclause  */
  YYSYMBOL_137_7 = 137,                    /* $@7  */
  YYSYMBOL_138_8 = 138,                    /* $@8  */
  YYSYMBOL_139_9 = 139,                    /* $@9  */
  YYSYMBOL_140_10 = 140,                   /* $@10  */
  YYSYMBOL_141_11 = 141,                   /* $@11  */
  YYSYMBOL_142_12 = 142,                   /* $@12  */
  YYSYMBOL_143_13 = 143,                   /* $@13  */
  YYSYMBOL_144_14 = 144,                   /* $@14  */
  YYSYMBOL_145_15 = 145,                   /* $@15  */
  YYSYMBOL_146_16 = 146,                   /* $@16  */
  YYSYMBOL_147_17 = 147,                   /* $@17  */
  YYSYMBOL_inrecclause = 148,              /* inrecclause  */
  YYSYMBOL_149_18 = 149,                   /* $@18  */
  YYSYMBOL_150_19 = 150,                   /* $@19  */
  YYSYMBOL_151_20 = 151,                   /* $@20  */
  YYSYMBOL_152_21 = 152,                   /* $@21  */
  YYSYMBOL_153_22 = 153,                   /* $@22  */
  YYSYMBOL_154_23 = 154,                   /* $@23  */
  YYSYMBOL_155_24 = 155,                   /* $@24  */
  YYSYMBOL_156_25 = 156,                   /* $@25  */
  YYSYMBOL_157_26 = 157,                   /* $@26  */
  YYSYMBOL_buildclause = 158,              /* buildclause  */
  YYSYMBOL_159_27 = 159,                   /* $@27  */
  YYSYMBOL_allsumfield = 160,              /* allsumfield  */
  YYSYMBOL_sumfield = 161,                 /* sumfield  */
  YYSYMBOL_sumclause = 162,                /* sumclause  */
  YYSYMBOL_tokskipclause = 163,            /* tokskipclause  */
  YYSYMBOL_filesgroup = 164,               /* filesgroup  */
  YYSYMBOL_fnamesclause = 165,             /* fnamesclause  */
  YYSYMBOL_outfilincludeclause = 166,      /* outfilincludeclause  */
  YYSYMBOL_outfilomitclause = 167,         /* outfilomitclause  */
  YYSYMBOL_outfilclause = 168,             /* outfilclause  */
  YYSYMBOL_startrecclause = 169,           /* startrecclause  */
  YYSYMBOL_endrecclause = 170,             /* endrecclause  */
  YYSYMBOL_saveclause = 171,               /* saveclause  */
  YYSYMBOL_alloption = 172,                /* alloption  */
  YYSYMBOL_option = 173,                   /* option  */
  YYSYMBOL_optionclause = 174,             /* optionclause  */
  YYSYMBOL_175_28 = 175,                   /* $@28  */
  YYSYMBOL_recordoption = 176,             /* recordoption  */
  YYSYMBOL_recordclause = 177              /* recordclause  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;



/* Unqualified %code blocks.  */
#line 36 "parser.y"

<<<<<<< .mine
||||||| .r1065
/* Bison implementation for Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.7"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */

/* Line 371 of yacc.c  */
#line 68 "..\\..\\parser.c"

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.h".  */
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
     BUILD = 282,
     FIELDS = 283,
     OVERLAY = 284,
     GIVE = 285,
     MERGE = 286,
     ORG = 287,
     RECORD = 288,
     SORT = 289,
     JOINKEYS = 290,
     USE = 291,
     COPY = 292,
     TYPE = 293,
     LENGTH = 294,
     DATE1 = 295,
     DATE2 = 296,
     DATE3 = 297,
     DATE4 = 298,
     CHANGE = 299,
     NOMATCH = 300,
     SORTED = 301,
     NOSEQCK = 302,
     UNPAIRED = 303,
     ONLY = 304,
     JOIN = 305,
     JOINREFORMAT = 306,
     FILL = 307,
     FINDREP = 308,
     INFR = 309,
     OUTFR = 310,
     INOUT = 311,
     STARTPOS = 312,
     ENDPOS = 313,
     DO = 314,
     MAXLEN = 315,
     OVERRUN = 316,
     SHIFT = 317,
     DIGIT = 318,
     DIGITBIG = 319,
     CHARTCOND = 320,
     CHARTYPE = 321,
     FILETYPE = 322,
     FORMATTYPE = 323,
     JOINFILE = 324,
     KEY = 325,
     KEYTYPE = 326,
     OCCURFILL = 327,
     OPCOND = 328,
     SUBSTRING = 329,
     ORDER = 330,
     RECTYPEFIX = 331,
     RECTYPEVAR = 332,
     STRING = 333,
     TOKSKIP = 334,
     EXROUT = 335,
     YESNO = 336,
     ERRTRUNC = 337,
     SIGNDIGITBIG = 338
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 23 "..\\..\\parser.y"
 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t      *condField;
	struct fieldValue_t     *fieldValue;
	struct SumField_t       *SumField;
    struct changefield_t    *changefield;
    struct findrep_t        *findrep;
    struct findrepfield_t   *findrep_field;


/* Line 387 of yacc.c  */
#line 209 "..\\..\\parser.c"
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

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 237 "..\\..\\parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 36 "..\\..\\parser.y"

=======
/* Bison implementation for Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.7"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */

/* Line 371 of yacc.c  */
#line 68 "..\\..\\parser.c"

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.h".  */
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
     XSUM = 276,
     SPLIT = 277,
     SPLITBY = 278,
     VLSCMP = 279,
     VLSHRT = 280,
     Y2PAST = 281,
     MODS = 282,
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
     FINDREP = 309,
     INFR = 310,
     OUTFR = 311,
     INOUT = 312,
     STARTPOS = 313,
     ENDPOS = 314,
     DO = 315,
     MAXLEN = 316,
     OVERRUN = 317,
     SHIFT = 318,
     DIGIT = 319,
     DIGITBIG = 320,
     CHARTCOND = 321,
     CHARTYPE = 322,
     FILETYPE = 323,
     FORMATTYPE = 324,
     JOINFILE = 325,
     KEY = 326,
     KEYTYPE = 327,
     OCCURFILL = 328,
     OPCOND = 329,
     SUBSTRING = 330,
     ORDER = 331,
     RECTYPEFIX = 332,
     RECTYPEVAR = 333,
     STRING = 334,
     TOKSKIP = 335,
     EXROUT = 336,
     YESNO = 337,
     ERRTRUNC = 338,
     SIGNDIGITBIG = 339
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 24 "..\\..\\parser.y"
 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t      *condField;
	struct fieldValue_t     *fieldValue;
	struct SumField_t       *SumField;
    struct changefield_t    *changefield;
    struct findrep_t        *findrep;
    struct findrepfield_t   *findrep_field;


/* Line 387 of yacc.c  */
#line 210 "..\\..\\parser.c"
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

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 238 "..\\..\\parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 37 "..\\..\\parser.y"
 
>>>>>>> .r1070
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#ifdef _MSC_VER
		#include <io.h>
	#else
		#include <stdlib.h> 
		#include <unistd.h>
	#endif
    #include <time.h>
	#include "gcsort.h"
	#include "file.h"
	#include "keyidxrel.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "sumfield.h"
	#include "utils.h"
    #include "gcshare.h"
    #include "datediff.h"
    #include "changefield.h"
    #include "join.h"
    #include "findreplace.h"

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2
    #define  JOIN_CASE      3
    
    /* -->> extern char szMexToken[260];    */

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		   current_file=NULL;
	struct outfil_t*	   current_outfil=NULL;
	struct condField_t*	   condField=NULL;
    struct inrec_t *       inrec=NULL;
    struct outrec_t *      outrec=NULL;
    struct changefield_t*  current_changefield=NULL;
    struct join_t*         current_join=NULL;
    struct join_t*         F1_join=NULL;
    struct join_t*         F2_join=NULL;
    struct findrep_t*      findrep=NULL;
    struct findrepfield_t* findrep_field=NULL;
    struct findrepfield_t* findrep_field_tmp = NULL;
    struct fieldValue_t*   field_tmp=NULL;
    int    pntChange = 0;  /* 1 = Inrec , 2 = Outrec */

	int nRecCase=0;
	int nTypeFile=0;
	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
    int current_filejoin=0;         /* Join File 1 = F1, 2 = F2  */
    int inrec_overlay=0;
    int outrec_overlay=0;
	int nPosAbsRec=0;
	int nRtc=0;
	int nCountGroupFiles=0;
	char* pszInt;
    int nTmp=0;
    int nSwitchFR=0;
    
    int nDateType=-1;
    int nDateCheck=0;
    int nDateNew=0;
    char szBuf[30];

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			/* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
	int  nTypeIncludeOmit;		/* 0= Nothing, 1 = Include, Omit=2                              */
    int  nFieldType = 0;        /* field type used when format is spicified */
	int  nstate_outfil = 0;
    int  nOnly=0;

<<<<<<< .mine

#line 365 "parser.c"

#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if 1

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* 1 */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  92
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   508

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  90
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  88
/* YYNRULES -- Number of rules.  */
#define YYNRULES  240
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  540

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   338


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      85,    86,     2,     2,    84,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    89,     2,
       2,    87,     2,    88,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   225,   225,   226,   228,   229,   230,   231,   232,   233,
     234,   235,   236,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   253,   254,
     255,   259,   259,   276,   276,   293,   309,   320,   329,   338,
     347,   356,   362,   365,   369,   384,   389,   395,   402,   407,
     419,   434,   449,   462,   481,   483,   489,   513,   528,   528,
     535,   543,   543,   552,   562,   562,   589,   590,   594,   598,
     602,   606,   630,   636,   649,   675,   692,   693,   713,   713,
     724,   725,   741,   752,   777,   780,   784,   793,   811,   827,
     841,   853,   865,   880,   895,   913,   930,   954,   970,   997,
    1015,  1039,  1059,  1068,  1080,  1089,  1113,  1119,  1131,  1133,
    1141,  1213,  1228,  1254,  1299,  1341,  1385,  1429,  1474,  1528,
    1568,  1624,  1644,  1664,  1755,  1846,  1939,  1942,  1945,  1946,
    1967,  1988,  2009,  2031,  2056,  2083,  2094,  2110,  2130,  2174,
    2178,  2186,  2217,  2245,  2260,  2260,  2271,  2271,  2281,  2281,
    2292,  2292,  2302,  2302,  2314,  2314,  2325,  2325,  2335,  2335,
    2346,  2346,  2361,  2361,  2371,  2371,  2385,  2385,  2395,  2395,
    2405,  2405,  2415,  2415,  2425,  2425,  2437,  2437,  2448,  2448,
    2458,  2458,  2469,  2469,  2483,  2483,  2494,  2495,  2498,  2508,
    2525,  2537,  2541,  2548,  2554,  2574,  2580,  2582,  2584,  2588,
    2594,  2606,  2618,  2634,  2639,  2647,  2652,  2659,  2668,  2670,
    2673,  2677,  2681,  2685,  2689,  2693,  2697,  2701,  2705,  2712,
    2719,  2725,  2732,  2738,  2747,  2747,  2759,  2765,  2771,  2777,
    2783,  2789,  2795,  2802,  2808,  2814,  2820,  2826,  2832,  2838,
    2849
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "\"AND clause\"",
  "\"COND clause\"", "\"ENDREC clause\"", "\"FNAMES clause\"",
  "\"FORMAT clause\"", "\"INCLUDE clause\"", "\"INREC clause\"",
  "\"NONE clause\"", "\"OMIT clause\"", "\"OPTION clause\"",
  "\"OR clause\"", "\"OUTFIL clause\"", "\"OUTREC clause\"",
  "\"SAVE clause\"", "\"SKIP clause\"", "\"STARTREC clause\"",
  "\"STOPAFT clause\"", "\"SUM clause\"", "\"SPLIT clause\"",
  "\"SPLITBY clause\"", "\"VLSCMP clause\"", "\"VLSHRT clause\"",
  "\"Y2PAST clause\"", "\"MODS clause\"", "\"BUILD instruction\"",
  "\"FIELDS instruction\"", "\"OVERLAY instruction\"", "\"GIVE clause\"",
  "\"MERGE clause\"", "\"ORG instruction\"", "\"RECORD instruction\"",
  "\"SORT clause\"", "\"JOINKEYS clause\"", "\"USE clause\"", "\"COPY\"",
  "\"TYPE\"", "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"",
  "\"DATE4\"", "\"CHANGE\"", "\"NOMATCH\"", "\"SORTED\"", "\"NOSEQCK\"",
  "\"UNPAIRED\"", "\"ONLY\"", "\"JOIN\"", "\"JOINREFORMAT\"", "\"FILL\"",
  "\"FINDREP\"", "\"IN\"", "\"OUT\"", "\"INOUT\"", "\"STARTPOS\"",
  "\"ENDPOS\"", "\"DO\"", "\"MAXLEN\"", "\"OVERRUN\"", "\"SHIFT\"",
  "\"DIGIT\"", "\"DIGITBIG\"", "\"CHARTCOND\"", "\"CHARTYPE\"",
  "\"FILETYPE\"", "\"FORMATTYPE\"", "\"JOINFILE\"", "\"KEY\"",
  "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"SUBSTRING\"",
  "\"ORDER\"", "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"",
  "\"TOKSKIP clause\"", "\"EXROUT clause\"", "\"YESNO clause\"",
  "\"ERRTRUNC clause\"", "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='",
  "'?'", "':'", "$accept", "beginning", "clause", "useclause", "$@1",
  "giveclause", "$@2", "recordorginstruction", "allkeyfield", "keyfield",
  "fieldtype", "fielddirection", "condition", "fieldvaluecond",
  "fieldvaluerec", "fieldvalueconst", "allsortfield", "sortfield",
  "sortclause", "$@3", "mergeclause", "$@4", "joinkeysclause", "$@5",
  "joinkeysalloptions", "joinkeysoptions", "joinclause", "joinoptions",
  "joinreformatclause", "$@6", "fill_char", "formatclause", "allcondfield",
  "condfieldcond", "datetype", "omitclause", "includeclause",
  "allinoutrec", "inoutrec", "findrep_options_all", "findrep_options",
  "allfieldvaluerec", "inoutfieldvaluerec", "changepair", "changepairdet",
  "changeCmdOpt", "outrecclause", "$@7", "$@8", "$@9", "$@10", "$@11",
  "$@12", "$@13", "$@14", "$@15", "$@16", "$@17", "inrecclause", "$@18",
  "$@19", "$@20", "$@21", "$@22", "$@23", "$@24", "$@25", "$@26",
  "buildclause", "$@27", "allsumfield", "sumfield", "sumclause",
  "tokskipclause", "filesgroup", "fnamesclause", "outfilincludeclause",
  "outfilomitclause", "outfilclause", "startrecclause", "endrecclause",
  "saveclause", "alloption", "option", "optionclause", "$@28",
  "recordoption", "recordclause", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,    44,    40,    41,    61,    63,    58
};
#endif

#define YYPACT_NINF (-446)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     146,   -57,     3,     8,     7,    69,     6,  -446,  -446,    34,
    -446,    60,    72,    58,  -446,   -17,    94,   172,   161,   178,
     225,   205,   202,   236,   239,  -446,    23,   306,   146,  -446,
    -446,  -446,  -446,  -446,  -446,    -2,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,   -34,   -37,   135,
      17,   -32,   223,   136,   137,   141,   221,    43,   -32,     1,
     142,   147,   158,   222,  -446,   226,    18,    80,    -1,  -446,
    -446,   -18,    49,   -14,   227,  -446,   228,   230,   232,   231,
     229,  -446,  -446,  -446,   271,  -446,  -446,  -446,  -446,   241,
     234,  -446,  -446,  -446,  -446,   237,   -32,   -32,   131,  -446,
     131,   316,  -446,   238,  -446,   242,  -446,   243,   244,   148,
     -32,   131,   131,   235,   245,  -446,  -446,   246,   250,  -446,
     251,  -446,     1,  -446,   249,  -446,   252,  -446,   253,   254,
     148,   148,  -446,  -446,  -446,  -446,  -446,  -446,   261,     4,
    -446,  -446,   286,   287,  -446,  -446,  -446,   266,     4,   101,
    -446,  -446,  -446,  -446,   289,   149,   241,   277,     2,   131,
     -32,   -32,    48,   148,  -446,   148,  -446,   148,  -446,  -446,
     148,   256,   255,   257,   -30,   265,   258,   267,  -446,  -446,
     262,  -446,   131,   106,   108,   285,   263,   264,  -446,   148,
    -446,   148,  -446,   148,  -446,  -446,   148,   262,   160,   148,
     268,   269,   272,   282,    98,   273,  -446,   290,   274,   275,
     290,   278,  -446,   279,   148,   148,  -446,  -446,   234,   280,
    -446,  -446,   354,   -32,   131,   163,   148,   167,   148,   170,
     148,   148,   262,   298,   -21,   281,   302,    46,  -446,   304,
    -446,   148,  -446,  -446,  -446,  -446,  -446,   283,   284,   171,
     148,   175,   148,   176,   148,   148,   262,  -446,   179,   307,
    -446,   261,     4,   288,   291,    64,   308,   292,   293,   294,
     -41,   -24,   295,   345,   124,  -446,   182,   183,   139,   131,
    -446,   186,  -446,   187,  -446,   190,   191,   296,   265,   311,
     299,   311,  -446,   300,   309,   301,   262,   310,   312,  -446,
     194,  -446,   195,  -446,   198,   203,  -446,   305,  -446,  -446,
     319,   323,   313,   314,   315,   317,   318,   328,  -446,   290,
     204,    16,   207,    26,  -446,   320,   322,   340,  -446,  -446,
    -446,   324,   325,  -446,  -446,  -446,  -446,   327,   326,   321,
     339,   329,   330,   332,  -446,   333,   208,   331,  -446,  -446,
    -446,  -446,    74,     4,   334,   337,   338,   341,     4,   308,
     335,  -446,    36,  -446,   336,   348,    61,  -446,   342,   349,
    -446,   365,  -446,  -446,   112,    73,   343,   344,   347,   311,
     350,   346,   311,   180,  -446,  -446,   240,  -446,  -446,   351,
    -446,  -446,   352,   353,   356,   357,  -446,  -446,   120,   211,
     360,  -446,   358,   212,   361,  -446,   359,   290,  -446,   362,
     363,   364,  -446,  -446,  -446,   366,   367,   327,  -446,   370,
     311,  -446,   368,   369,   371,   372,   373,   374,  -446,   378,
     215,   216,   375,     4,     4,   380,   303,  -446,   379,  -446,
     385,  -446,   381,  -446,   386,  -446,   382,  -446,   383,    -8,
     389,  -446,   152,   384,  -446,   377,   180,   390,   391,   394,
     402,   355,   392,   180,   388,  -446,   393,  -446,  -446,  -446,
    -446,   395,  -446,   397,   396,  -446,   398,  -446,  -446,   407,
     411,   412,  -446,   399,  -446,  -446,  -446,  -446,   401,   400,
     403,   311,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
     404,   405,     4,  -446,  -446,  -446,  -446,  -446,  -446,   413,
     414,  -446,   153,   180,  -446,  -446,  -446,   408,  -446,   409,
     416,   410,  -446,   116,   417,  -446,  -446,  -446,   415,  -446
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   224,   202,     0,
     207,     0,     0,     0,   198,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   193,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    66,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   182,     0,     0,     0,
       0,     0,     0,   160,   164,     0,     0,     0,     0,   199,
      33,     0,     0,     0,     0,    31,    72,     0,     0,     0,
      68,    77,     1,     3,     0,    67,   206,   205,   194,     0,
     197,    45,    83,    46,    82,     0,     0,     0,   104,    84,
     200,     0,   172,     0,   168,     0,   176,     0,   178,     0,
       0,   102,   201,     0,     0,   215,   216,     0,     0,   210,
       0,   225,   208,   150,     0,   146,     0,   154,     0,   156,
       0,     0,   162,   204,   203,    71,    70,   191,     0,    35,
      63,    61,   226,   233,   240,    60,    58,     0,    35,     0,
      73,    78,    81,   184,     0,     0,     0,     0,     0,   105,
       0,     0,     0,     0,   170,     0,   166,     0,   174,   180,
       0,     0,     0,     0,     0,   118,     0,   115,   111,   119,
     183,   108,   103,     0,     0,     0,     0,     0,   209,     0,
     148,     0,   144,     0,   152,   158,     0,   161,     0,     0,
       0,     0,   186,     0,     0,     0,    34,     0,     0,     0,
       0,     0,    32,    76,     0,     0,    69,   196,   195,     0,
      85,    86,    87,     0,   106,     0,     0,     0,     0,     0,
       0,     0,   179,     0,     0,     0,   120,     0,    51,     0,
     116,     0,   212,   211,   214,   213,   217,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   157,   165,     0,     0,
     192,     0,    35,     0,     0,     0,     0,     0,     0,    54,
       0,     0,     0,     0,     0,    74,     0,     0,     0,   107,
     173,     0,   169,     0,   177,     0,     0,     0,     0,     0,
       0,     0,   110,     0,   117,     0,   109,     0,     0,   151,
       0,   147,     0,   155,     0,     0,   163,   188,   187,    36,
       0,     0,     0,     0,     0,     0,    42,     0,    62,     0,
       0,     0,     0,     0,    59,     0,    76,    80,   185,    48,
      46,     0,     0,   171,   167,   175,   181,     0,   135,     0,
       0,   137,     0,     0,   113,     0,     0,     0,   149,   145,
     153,   159,     0,    35,     0,     0,     0,     0,    35,     0,
       0,    55,     0,   227,     0,     0,     0,   234,     0,     0,
      64,     0,    75,    79,     0,     0,     0,     0,   139,     0,
       0,     0,     0,   128,   114,   112,     0,   219,   218,     0,
     190,    39,     0,     0,     0,     0,    41,    43,     0,     0,
       0,   229,     0,     0,     0,   236,     0,     0,    49,     0,
      52,     0,    53,    93,    92,     0,     0,     0,   136,     0,
       0,   138,     0,     0,     0,     0,     0,     0,   125,   126,
       0,     0,     0,    35,    35,     0,     0,    47,     0,    56,
       0,   228,     0,   231,     0,   235,     0,   238,     0,     0,
       0,    50,     0,     0,   140,     0,   128,     0,     0,     0,
       0,     0,     0,   128,     0,   222,     0,   220,   189,    37,
      40,     0,    44,     0,     0,   232,     0,   239,    65,    95,
      97,    99,   101,    52,    90,    91,    94,    89,     0,     0,
       0,     0,   123,   129,   130,   131,   132,   133,   134,   127,
       0,     0,    35,    57,   230,   237,    96,    98,   100,     0,
       0,   141,     0,   128,   223,   221,    38,     0,   142,     0,
       0,     0,   124,     0,     0,   143,   121,    88,     0,   122
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -446,   451,  -446,  -446,  -446,  -446,  -446,  -158,    51,  -446,
    -285,   -56,    42,   -27,  -243,   -23,  -216,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,   452,  -446,  -446,   -84,  -446,  -446,
     162,   482,   -55,  -446,  -446,  -446,  -446,  -133,  -446,  -445,
    -446,   100,   103,    70,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
     233,  -446,  -446,  -446,   -83,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,   376,  -446,  -446,  -446,  -446,  -446
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,    27,    28,    29,   158,    30,   149,   216,   325,   326,
     104,   449,   342,   423,   189,   424,   278,   279,    31,   220,
      32,   217,    33,   417,    34,    35,    36,    37,    38,   224,
      39,    40,   108,   109,   496,    41,    42,   190,   191,   438,
     439,   349,   352,   387,   388,   531,    43,   262,   201,   260,
     199,   264,   203,   206,   265,   140,   209,   141,    44,   238,
     175,   236,   173,   240,   177,   180,   241,   119,    45,   225,
     211,   212,    46,    47,   100,    48,    49,    50,    51,    52,
      53,    54,   131,   132,    55,    69,   154,    56
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     222,   300,   160,   341,   282,   170,   110,   207,   208,   147,
      67,    60,   121,   122,     3,   171,   165,    12,   123,   150,
     124,   502,   330,   155,   125,   126,   127,   128,   509,    96,
      57,   105,   489,   490,   491,   492,   213,   214,   129,   332,
     235,    98,   237,   331,   239,   298,    79,   242,    99,    97,
      89,   168,   169,   106,   246,   493,   348,   421,   351,   247,
     333,    70,    71,    72,   299,   192,   259,   151,   261,    90,
     263,   156,    91,   266,   215,   422,   268,   400,   532,   374,
     105,   143,    94,   228,   148,   130,    78,    73,   230,   378,
      58,   286,   287,    68,    61,    59,    63,    64,    65,   409,
     375,   144,   106,   291,   107,   293,   105,   295,   296,   303,
     379,   105,   304,   371,   319,   231,   232,   234,   306,    74,
     410,    75,    66,   448,   413,   152,   153,   310,   106,   312,
     120,   314,   315,   106,   170,   233,   420,   399,   421,   285,
     322,   323,   101,   145,   171,   414,   348,    76,   103,   351,
      91,     1,     2,     3,     4,     5,   422,     6,     7,    77,
       8,     9,    10,   146,    11,    12,    13,    14,    15,   252,
     223,   254,    80,    91,   273,   274,    16,    17,   289,    18,
      19,    20,    21,   275,   101,   339,   418,   466,   101,   253,
     103,   255,   181,   336,   103,   447,    22,    23,    24,    82,
      81,   458,   182,   101,   183,   401,    83,   101,   102,   103,
     406,   184,   339,   340,   185,   498,   529,   186,   499,   530,
     187,   112,   114,   113,   115,    25,   116,   133,   117,   134,
      26,    84,   135,   166,   136,   227,   188,   432,   433,   434,
     435,   436,   437,   137,   251,   138,   267,   251,   537,   290,
      86,   251,   382,   292,   251,   251,   294,   309,   523,   251,
     251,   311,   313,   251,    87,   316,   251,   251,   337,   338,
     251,   251,   343,   344,   251,   251,   345,   346,   251,   251,
     358,   359,   251,    85,   360,   479,   480,   251,   372,   361,
     373,   376,   396,   377,   397,   450,   454,   451,   455,   474,
     476,   475,   477,   440,   441,    88,    92,   111,   118,   139,
     162,   142,   159,   164,   157,   161,   163,    90,   166,    98,
     172,   167,   193,   174,   210,   218,   219,   176,   178,   179,
     196,   197,   194,   195,   200,   221,   226,   202,   204,   205,
     229,   243,   244,   248,   245,   250,   251,   249,   256,   272,
     257,   258,   269,   277,   526,   270,   271,   170,   276,   280,
     281,   297,   283,   284,   288,   302,   301,   305,   307,   308,
     317,   324,   320,   335,   482,   321,   327,   298,   329,   328,
     347,   334,   363,   350,   353,   355,   364,   354,   356,   362,
     357,   370,    24,   386,   391,   394,   395,   365,   366,   367,
     403,   404,   369,   368,   405,   380,   381,   390,   384,   385,
     389,   412,   416,   392,    91,   443,   393,   398,   402,   408,
     407,   425,   411,   452,   456,   465,   419,   513,   415,   500,
     426,   427,   494,   430,   429,   442,   495,   507,   478,   444,
     445,   446,   461,   481,   453,   457,   459,   460,   484,   486,
     462,   463,   497,   503,   504,   467,   468,   505,   469,   470,
     471,   472,   473,   483,   501,   506,   510,   485,   487,   488,
     516,   511,   447,   508,   517,   518,   527,   528,   521,    93,
     538,   512,   514,   519,   515,   520,    62,    95,   522,   428,
     524,   525,   533,   534,   535,   431,   536,   464,     0,   383,
       0,   539,     0,     0,   318,     0,     0,     0,   198
};

static const yytype_int16 yycheck[] =
{
     158,   244,    86,   288,   220,     3,    61,   140,   141,    10,
       4,     4,    67,    68,     7,    13,    99,    19,    17,    37,
      19,   466,    63,    37,    23,    24,    25,    26,   473,    63,
      87,    63,    40,    41,    42,    43,    32,    33,    37,    63,
     173,    78,   175,    84,   177,    66,    63,   180,    85,    83,
      27,   106,   107,    85,    84,    63,   299,    65,   301,    89,
      84,    27,    28,    29,    85,   120,   199,    85,   201,    46,
     203,    85,    49,   206,    70,    83,   209,   362,   523,    63,
      63,    63,    84,   166,    85,    84,    28,    53,    86,    63,
      87,   224,   225,    87,    87,    87,    27,    28,    29,    63,
      84,    83,    85,   236,    87,   238,    63,   240,   241,    63,
      84,    63,    66,   329,   272,   170,   171,   172,   251,    85,
      84,    87,    53,   408,    63,    76,    77,   260,    85,   262,
      87,   264,   265,    85,     3,    87,    63,    63,    65,   223,
      76,    77,    68,    63,    13,    84,   389,    87,    74,   392,
      49,     5,     6,     7,     8,     9,    83,    11,    12,    87,
      14,    15,    16,    83,    18,    19,    20,    21,    22,    63,
      69,    63,    78,    49,    76,    77,    30,    31,   233,    33,
      34,    35,    36,    85,    68,    73,    74,   430,    68,    83,
      74,    83,    44,    69,    74,    75,    50,    51,    52,    38,
      28,   417,    54,    68,    56,   363,    28,    68,    73,    74,
     368,    63,    73,    74,    66,    63,    63,    69,    66,    66,
      72,    85,    85,    87,    87,    79,    85,    85,    87,    87,
      84,     6,    85,    84,    87,    86,    88,    57,    58,    59,
      60,    61,    62,    85,    84,    87,    86,    84,   533,    86,
      48,    84,   336,    86,    84,    84,    86,    86,   501,    84,
      84,    86,    86,    84,    28,    86,    84,    84,    86,    86,
      84,    84,    86,    86,    84,    84,    86,    86,    84,    84,
      86,    86,    84,    78,    86,   443,   444,    84,    84,    86,
      86,    84,    84,    86,    86,    84,    84,    86,    86,    84,
      84,    86,    86,    63,    64,    66,     0,    84,    87,    87,
      78,    85,    84,    84,    87,    85,    85,    46,    84,    78,
       4,    84,    87,    85,    63,    39,    39,    85,    85,    85,
      80,    80,    87,    87,    85,    69,    47,    85,    85,    85,
      63,    85,    87,    78,    87,    78,    84,    89,    63,    67,
      87,    87,    84,    63,   512,    86,    84,     3,    85,    85,
      85,    63,    84,    84,    84,    63,    85,    63,    85,    85,
      63,    63,    84,    28,    71,    84,    84,    66,    84,    86,
      84,    86,    63,    84,    84,    84,    63,    78,    78,    84,
      78,    63,    52,    66,    55,    63,    63,    84,    84,    84,
      63,    63,    84,    86,    63,    85,    84,    86,    84,    84,
      84,    63,    63,    84,    49,    63,    86,    86,    84,    84,
     369,    78,    86,    63,    63,    55,   384,   483,    86,    45,
      86,    84,   459,    87,    84,    84,   459,    82,    63,    86,
      84,    84,    78,    63,    86,    86,    84,    84,    63,    63,
      84,    84,    63,    63,    63,    87,    87,    63,    87,    87,
      87,    87,    84,    84,    87,    63,    78,    86,    86,    86,
      63,    78,    75,    81,    63,    63,    63,    63,    78,    28,
      63,    86,    86,    84,    86,    84,     4,    35,    85,   389,
      86,    86,    84,    84,    78,   392,    86,   427,    -1,   337,
      -1,    86,    -1,    -1,   271,    -1,    -1,    -1,   132
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    21,    22,    30,    31,    33,    34,
      35,    36,    50,    51,    52,    79,    84,    91,    92,    93,
      95,   108,   110,   112,   114,   115,   116,   117,   118,   120,
     121,   125,   126,   136,   148,   158,   162,   163,   165,   166,
     167,   168,   169,   170,   171,   174,   177,    87,    87,    87,
       4,    87,   121,    27,    28,    29,    53,     4,    87,   175,
      27,    28,    29,    53,    85,    87,    87,    87,    28,    63,
      78,    28,    38,    28,     6,    78,    48,    28,    66,    27,
      46,    49,     0,    91,    84,   114,    63,    83,    78,    85,
     164,    68,    73,    74,   100,    63,    85,    87,   122,   123,
     122,    84,    85,    87,    85,    87,    85,    87,    87,   157,
      87,   122,   122,    17,    19,    23,    24,    25,    26,    37,
      84,   172,   173,    85,    87,    85,    87,    85,    87,    87,
     145,   147,    85,    63,    83,    63,    83,    10,    85,    96,
      37,    85,    76,    77,   176,    37,    85,    87,    94,    84,
     117,    85,    78,    85,    84,   164,    84,    84,   122,   122,
       3,    13,     4,   152,    85,   150,    85,   154,    85,    85,
     155,    44,    54,    56,    63,    66,    69,    72,    88,   104,
     127,   128,   122,    87,    87,    87,    80,    80,   172,   140,
      85,   138,    85,   142,    85,    85,   143,   127,   127,   146,
      63,   160,   161,    32,    33,    70,    97,   111,    39,    39,
     109,    69,    97,    69,   119,   159,    47,    86,   164,    63,
      86,   122,   122,    87,   122,   127,   151,   127,   149,   127,
     153,   156,   127,    85,    87,    87,    84,    89,    78,    89,
      78,    84,    63,    83,    63,    83,    63,    87,    87,   127,
     139,   127,   137,   127,   141,   144,   127,    86,   127,    84,
      86,    84,    67,    76,    77,    85,    85,    63,   106,   107,
      85,    85,   106,    84,    84,   117,   127,   127,    84,   122,
      86,   127,    86,   127,    86,   127,   127,    63,    66,    85,
     104,    85,    63,    63,    66,    63,   127,    85,    85,    86,
     127,    86,   127,    86,   127,   127,    86,    63,   160,    97,
      84,    84,    76,    77,    63,    98,    99,    84,    86,    84,
      63,    84,    63,    84,    86,    28,    69,    86,    86,    73,
      74,   100,   102,    86,    86,    86,    86,    84,   104,   131,
      84,   104,   132,    84,    78,    84,    78,    78,    86,    86,
      86,    86,    84,    63,    63,    84,    84,    84,    86,    84,
      63,   106,    84,    86,    63,    84,    84,    86,    63,    84,
      85,    84,   117,   120,    84,    84,    66,   133,   134,    84,
      86,    55,    84,    86,    63,    63,    84,    86,    86,    63,
     100,    97,    84,    63,    63,    63,    97,    98,    84,    63,
      84,    86,    63,    63,    84,    86,    63,   113,    74,   102,
      63,    65,    83,   103,   105,    78,    86,    84,   131,    84,
      87,   132,    57,    58,    59,    60,    61,    62,   129,   130,
      63,    64,    84,    63,    86,    84,    84,    75,   100,   101,
      84,    86,    63,    86,    84,    86,    63,    86,   106,    84,
      84,    78,    84,    84,   133,    55,   104,    87,    87,    87,
      87,    87,    87,    84,    84,    86,    84,    86,    63,    97,
      97,    63,    71,    84,    63,    86,    63,    86,    86,    40,
      41,    42,    43,    63,   103,   105,   124,    63,    63,    66,
      45,    87,   129,    63,    63,    63,    63,    82,    81,   129,
      78,    78,    86,   101,    86,    86,    63,    63,    63,    84,
      84,    78,    85,   104,    86,    86,    97,    63,    63,    63,
      66,   135,   129,    84,    84,    78,    86,   100,    63,    86
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    90,    91,    91,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    94,    93,    96,    95,    97,    97,    97,    97,    97,
      97,    97,    98,    98,    99,   100,   100,   101,   102,   102,
     103,   104,   105,   105,   106,   106,   107,   107,   109,   108,
     108,   111,   110,   110,   113,   112,   114,   114,   115,   115,
     115,   115,   116,   116,   116,   116,   117,   117,   119,   118,
     120,   120,   121,   121,   122,   122,   122,   122,   123,   123,
     123,   123,   123,   123,   123,   124,   124,   124,   124,   124,
     124,   124,   125,   125,   126,   126,   126,   126,   127,   127,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   128,
     128,   128,   128,   128,   128,   128,   129,   129,   130,   130,
     130,   130,   130,   130,   130,   131,   131,   132,   132,   133,
     133,   134,   134,   135,   137,   136,   138,   136,   139,   136,
     140,   136,   141,   136,   142,   136,   143,   136,   144,   136,
     145,   136,   146,   136,   147,   136,   149,   148,   150,   148,
     151,   148,   152,   148,   153,   148,   154,   148,   155,   148,
     156,   148,   157,   148,   159,   158,   160,   160,   161,   161,
     161,   162,   162,   163,   164,   164,   165,   165,   165,   165,
     166,   167,   168,   169,   169,   170,   170,   171,   172,   172,
     173,   173,   173,   173,   173,   173,   173,   173,   173,   173,
     173,   173,   173,   173,   175,   174,   176,   176,   176,   176,
     176,   176,   176,   176,   176,   176,   176,   176,   176,   176,
     177
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     3,     5,     1,     1,     1,     1,     1,
       2,     2,     1,     1,     1,     3,     5,     7,     0,     6,
       3,     0,     6,     3,     0,    10,     1,     2,     2,     4,
       3,     3,     2,     3,     5,     7,     0,     2,     0,     7,
       0,     3,     3,     3,     1,     3,     3,     3,    13,     9,
       9,     9,     7,     7,     9,     1,     2,     1,     2,     1,
       2,     1,     3,     4,     3,     4,     5,     6,     1,     3,
       3,     1,     5,     4,     5,     1,     2,     3,     1,     1,
       2,    11,    13,     8,    10,     6,     1,     3,     0,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     5,     6,     2,     0,     7,     0,     6,     0,     7,
       0,     6,     0,     7,     0,     6,     0,     5,     0,     7,
       0,     4,     0,     6,     0,     5,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     5,
       0,     7,     0,     4,     0,     6,     1,     3,     3,     7,
       5,     3,     5,     1,     1,     3,     5,     3,     1,     2,
       3,     3,     1,     3,     3,     3,     3,     1,     1,     2,
       1,     3,     3,     3,     3,     1,     1,     3,     6,     6,
       8,    10,     8,    10,     0,     3,     1,     5,     7,     6,
       9,     7,     8,     1,     5,     7,     6,     9,     7,     8,
       3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
# ifndef YY_LOCATION_PRINT
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif


# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yykind < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yykind], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


/* Context of a parse error.  */
typedef struct
{
  yy_state_t *yyssp;
  yysymbol_kind_t yytoken;
} yypcontext_t;

/* Put in YYARG at most YYARGN of the expected tokens given the
   current YYCTX, and return the number of tokens stored in YYARG.  If
   YYARG is null, return the number of expected tokens (guaranteed to
   be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
   Return 0 if there are more than YYARGN expected tokens, yet fill
   YYARG up to YYARGN. */
static int
yypcontext_expected_tokens (const yypcontext_t *yyctx,
                            yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  int yyn = yypact[+*yyctx->yyssp];
  if (!yypact_value_is_default (yyn))
    {
      /* Start YYX at -YYN if negative to avoid negative indexes in
         YYCHECK.  In other words, skip the first -YYN actions for
         this state because they are default actions.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;
      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yyx;
      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
        if (yycheck[yyx + yyn] == yyx && yyx != YYSYMBOL_YYerror
            && !yytable_value_is_error (yytable[yyx + yyn]))
          {
            if (!yyarg)
              ++yycount;
            else if (yycount == yyargn)
              return 0;
            else
              yyarg[yycount++] = YY_CAST (yysymbol_kind_t, yyx);
          }
    }
  if (yyarg && yycount == 0 && 0 < yyargn)
    yyarg[0] = YYSYMBOL_YYEMPTY;
  return yycount;
}




#ifndef yystrlen
# if defined __GLIBC__ && defined _STRING_H
#  define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
# else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
# endif
#endif

#ifndef yystpcpy
# if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#  define yystpcpy stpcpy
# else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
# endif
#endif

#ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;
      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
#endif


static int
yy_syntax_error_arguments (const yypcontext_t *yyctx,
                           yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yyctx->yytoken != YYSYMBOL_YYEMPTY)
    {
      int yyn;
      if (yyarg)
        yyarg[yycount] = yyctx->yytoken;
      ++yycount;
      yyn = yypcontext_expected_tokens (yyctx,
                                        yyarg ? yyarg + 1 : yyarg, yyargn - 1);
      if (yyn == YYENOMEM)
        return YYENOMEM;
      else
        yycount += yyn;
    }
  return yycount;
}

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return -1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return YYENOMEM if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                const yypcontext_t *yyctx)
{
  enum { YYARGS_MAX = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  yysymbol_kind_t yyarg[YYARGS_MAX];
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* Actual size of YYARG. */
  int yycount = yy_syntax_error_arguments (yyctx, yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM)
    return YYENOMEM;

  switch (yycount)
    {
#define YYCASE_(N, S)                       \
      case N:                               \
        yyformat = S;                       \
        break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
    }

  /* Compute error message size.  Don't count the "%s"s, but reserve
     room for the terminator.  */
  yysize = yystrlen (yyformat) - 2 * yycount + 1;
  {
    int yyi;
    for (yyi = 0; yyi < yycount; ++yyi)
      {
        YYPTRDIFF_T yysize1
          = yysize + yytnamerr (YY_NULLPTR, yytname[yyarg[yyi]]);
        if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
          yysize = yysize1;
        else
          return YYENOMEM;
      }
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return -1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yytname[yyarg[yyi++]]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 4: /* clause: recordclause  */
#line 228 "parser.y"
                       {}
#line 1984 "parser.c"
    break;

  case 5: /* clause: sortclause  */
#line 229 "parser.y"
                             {}
#line 1990 "parser.c"
    break;

  case 6: /* clause: mergeclause  */
#line 230 "parser.y"
                              {}
#line 1996 "parser.c"
    break;

  case 7: /* clause: joinkeysclause  */
#line 231 "parser.y"
                         {}
#line 2002 "parser.c"
    break;

  case 8: /* clause: joinclause  */
#line 232 "parser.y"
                     {}
#line 2008 "parser.c"
    break;

  case 9: /* clause: joinreformatclause  */
#line 233 "parser.y"
                            {}
#line 2014 "parser.c"
    break;

  case 10: /* clause: joinkeysalloptions  */
#line 234 "parser.y"
                            {}
#line 2020 "parser.c"
    break;

  case 11: /* clause: joinoptions  */
#line 235 "parser.y"
                     {}
#line 2026 "parser.c"
    break;

  case 12: /* clause: fill_char  */
#line 236 "parser.y"
                   {}
#line 2032 "parser.c"
    break;

  case 13: /* clause: useclause  */
#line 237 "parser.y"
                    {}
#line 2038 "parser.c"
    break;

  case 14: /* clause: giveclause  */
#line 238 "parser.y"
                             {}
#line 2044 "parser.c"
    break;

  case 15: /* clause: formatclause  */
#line 239 "parser.y"
                               {}
#line 2050 "parser.c"
    break;

  case 16: /* clause: startrecclause  */
#line 240 "parser.y"
                                 {}
#line 2056 "parser.c"
    break;

  case 17: /* clause: endrecclause  */
#line 241 "parser.y"
                               {}
#line 2062 "parser.c"
    break;

  case 18: /* clause: includeclause  */
#line 242 "parser.y"
                                {}
#line 2068 "parser.c"
    break;

  case 19: /* clause: omitclause  */
#line 243 "parser.y"
                             {}
#line 2074 "parser.c"
    break;

  case 20: /* clause: inrecclause  */
#line 244 "parser.y"
                              {}
#line 2080 "parser.c"
    break;

  case 21: /* clause: sumclause  */
#line 245 "parser.y"
                            {}
#line 2086 "parser.c"
    break;

  case 22: /* clause: outrecclause  */
#line 246 "parser.y"
                               {}
#line 2092 "parser.c"
    break;

  case 23: /* clause: tokskipclause  */
#line 247 "parser.y"
                                {}
#line 2098 "parser.c"
    break;

  case 24: /* clause: outfilclause  */
#line 248 "parser.y"
                               {}
#line 2104 "parser.c"
    break;

  case 25: /* clause: outfilincludeclause  */
#line 249 "parser.y"
                                      {}
#line 2110 "parser.c"
    break;

  case 26: /* clause: outfilomitclause  */
#line 250 "parser.y"
                                   {}
#line 2116 "parser.c"
    break;

  case 27: /* clause: fnamesclause  */
#line 251 "parser.y"
                               {}
#line 2122 "parser.c"
    break;

  case 28: /* clause: saveclause  */
#line 253 "parser.y"
                             {}
#line 2128 "parser.c"
    break;

  case 29: /* clause: optionclause  */
#line 254 "parser.y"
                               {}
#line 2134 "parser.c"
    break;

  case 30: /* clause: buildclause  */
#line 255 "parser.y"
                      {}
#line 2140 "parser.c"
    break;

  case 31: /* $@1: %empty  */
#line 259 "parser.y"
                     {   
        struct file_t *file=file_constructor((yyvsp[0].string));
||||||| .r1065


/* Line 391 of yacc.c  */
#line 326 "..\\..\\parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(N) (N)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (YYID (0))
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  92
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   508

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  90
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  88
/* YYNRULES -- Number of rules.  */
#define YYNRULES  240
/* YYNRULES -- Number of states.  */
#define YYNSTATES  540

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   338

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      85,    86,     2,     2,    84,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    89,     2,
       2,    87,     2,    88,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    47,    49,    51,    53,    55,    57,
      59,    61,    62,    67,    68,    73,    74,    78,    86,    96,
     102,   110,   116,   118,   122,   128,   130,   132,   134,   136,
     138,   141,   144,   146,   148,   150,   154,   160,   168,   169,
     176,   180,   181,   188,   192,   193,   204,   206,   209,   212,
     217,   221,   225,   228,   232,   238,   246,   247,   250,   251,
     259,   260,   264,   268,   272,   274,   278,   282,   286,   300,
     310,   320,   330,   338,   346,   356,   358,   361,   363,   366,
     368,   371,   373,   377,   382,   386,   391,   397,   404,   406,
     410,   414,   416,   422,   427,   433,   435,   438,   442,   444,
     446,   449,   461,   475,   484,   495,   502,   504,   508,   509,
     513,   517,   521,   525,   529,   533,   535,   539,   541,   545,
     547,   551,   557,   564,   567,   568,   576,   577,   584,   585,
     593,   594,   601,   602,   610,   611,   618,   619,   625,   626,
     634,   635,   640,   641,   648,   649,   655,   656,   664,   665,
     672,   673,   681,   682,   689,   690,   698,   699,   706,   707,
     713,   714,   722,   723,   728,   729,   736,   738,   742,   746,
     754,   760,   764,   770,   772,   774,   778,   784,   788,   790,
     793,   797,   801,   803,   807,   811,   815,   819,   821,   823,
     826,   828,   832,   836,   840,   844,   846,   848,   852,   859,
     866,   875,   886,   895,   906,   907,   911,   913,   919,   927,
     934,   944,   952,   961,   963,   969,   977,   984,   994,  1002,
    1011
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      91,     0,    -1,    -1,    92,    91,    -1,   177,    -1,   108,
      -1,   110,    -1,   112,    -1,   116,    -1,   118,    -1,   114,
      -1,   117,    -1,   120,    -1,    93,    -1,    95,    -1,   121,
      -1,   169,    -1,   170,    -1,   126,    -1,   125,    -1,   148,
      -1,   162,    -1,   136,    -1,   163,    -1,   168,    -1,   166,
      -1,   167,    -1,   165,    -1,   171,    -1,   174,    -1,   158,
      -1,    -1,    36,    78,    94,    97,    -1,    -1,    30,    78,
      96,    97,    -1,    -1,    32,    67,    97,    -1,    33,    77,
      84,    63,    84,    63,    97,    -1,    33,    85,    77,    84,
      63,    84,    63,    86,    97,    -1,    33,    76,    84,    63,
      97,    -1,    33,    85,    76,    84,    63,    86,    97,    -1,
      70,    85,    98,    86,    97,    -1,    99,    -1,    99,    84,
      98,    -1,    63,    84,    63,    84,    71,    -1,    68,    -1,
      74,    -1,    75,    -1,    73,    -1,    74,    -1,    65,    78,
      -1,    66,    78,    -1,    63,    -1,    83,    -1,   107,    -1,
     107,    84,   106,    -1,    63,    84,    63,    84,   101,    -1,
      63,    84,    63,    84,   100,    84,   101,    -1,    -1,    34,
      28,    85,   109,   106,    86,    -1,    34,    28,    37,    -1,
      -1,    31,    28,    85,   111,   106,    86,    -1,    31,    28,
      37,    -1,    -1,    35,     6,    87,    69,    84,    28,    85,
     113,   106,    86,    -1,   115,    -1,   115,   114,    -1,    84,
      46,    -1,    84,    46,    84,    47,    -1,    19,    87,    83,
      -1,    19,    87,    63,    -1,    50,    48,    -1,    50,    48,
     117,    -1,    50,    48,    84,    69,   117,    -1,    50,    48,
      84,    69,    84,    69,   117,    -1,    -1,    84,    49,    -1,
      -1,    51,    28,    85,   119,   127,    86,   120,    -1,    -1,
      52,    66,    78,    -1,     7,    87,   100,    -1,     7,    87,
      73,    -1,   123,    -1,    85,   122,    86,    -1,   122,     3,
     122,    -1,   122,    13,   122,    -1,    63,    84,    63,    84,
     100,    84,   102,    84,    63,    84,    63,    84,   100,    -1,
      63,    84,    63,    84,   102,    84,    63,    84,    63,    -1,
      63,    84,    63,    84,   100,    84,   102,    84,   103,    -1,
      63,    84,    63,    84,   100,    84,   102,    84,   105,    -1,
      63,    84,    63,    84,   102,    84,   105,    -1,    63,    84,
      63,    84,   102,    84,   103,    -1,    63,    84,    63,    84,
     100,    84,   102,    84,   124,    -1,    40,    -1,    40,    63,
      -1,    41,    -1,    41,    63,    -1,    42,    -1,    42,    63,
      -1,    43,    -1,    11,     4,   122,    -1,    11,     4,    87,
     122,    -1,     8,     4,   122,    -1,     8,     4,    87,   122,
      -1,     8,   121,    84,     4,   122,    -1,     8,   121,    84,
       4,    87,   122,    -1,   128,    -1,   127,    84,   127,    -1,
      63,    84,    63,    -1,    88,    -1,    69,    89,    63,    84,
      63,    -1,    63,    89,    66,    78,    -1,    63,    89,    63,
      84,    63,    -1,    72,    -1,    72,    78,    -1,    63,    89,
      66,    -1,    66,    -1,   104,    -1,    63,    84,    -1,    44,
      85,    63,    84,   133,    86,    84,    45,    85,   135,    86,
      -1,    44,    85,    63,    84,   133,    86,    84,    45,    85,
      63,    84,    63,    86,    -1,    54,    87,   104,    84,    55,
      87,   104,   129,    -1,    54,    87,    85,   131,    86,    84,
      55,    87,   104,   129,    -1,    56,    87,    85,   132,    86,
     129,    -1,   130,    -1,   130,    84,   129,    -1,    -1,    57,
      87,    63,    -1,    58,    87,    63,    -1,    59,    87,    63,
      -1,    60,    87,    63,    -1,    61,    87,    82,    -1,    62,
      87,    81,    -1,   104,    -1,   104,    84,   131,    -1,   104,
      -1,   104,    84,   132,    -1,   134,    -1,   134,    84,   133,
      -1,    66,    78,    84,    66,    78,    -1,    66,    78,    84,
      63,    84,    63,    -1,    66,    78,    -1,    -1,    15,    28,
      87,    85,   137,   127,    86,    -1,    -1,    15,    28,    85,
     138,   127,    86,    -1,    -1,    15,    27,    87,    85,   139,
     127,    86,    -1,    -1,    15,    27,    85,   140,   127,    86,
      -1,    -1,    15,    29,    87,    85,   141,   127,    86,    -1,
      -1,    15,    29,    85,   142,   127,    86,    -1,    -1,    15,
      53,    87,   143,   127,    -1,    -1,    15,    53,    87,    85,
     144,   127,    86,    -1,    -1,    15,    53,   145,   127,    -1,
      -1,    15,    87,    85,   146,   127,    86,    -1,    -1,    15,
      85,   147,   127,    86,    -1,    -1,     9,    28,    87,    85,
     149,   127,    86,    -1,    -1,     9,    28,    85,   150,   127,
      86,    -1,    -1,     9,    27,    87,    85,   151,   127,    86,
      -1,    -1,     9,    27,    85,   152,   127,    86,    -1,    -1,
       9,    29,    87,    85,   153,   127,    86,    -1,    -1,     9,
      29,    85,   154,   127,    86,    -1,    -1,     9,    53,    87,
     155,   127,    -1,    -1,     9,    53,    87,    85,   156,   127,
      86,    -1,    -1,     9,    53,   157,   127,    -1,    -1,    84,
      27,    85,   159,   127,    86,    -1,   161,    -1,   161,    84,
     160,    -1,    63,    84,    63,    -1,    63,    84,    63,    84,
      63,    84,    63,    -1,    63,    84,    63,    84,   100,    -1,
      20,    28,    10,    -1,    20,    28,    85,   160,    86,    -1,
      79,    -1,    78,    -1,   164,    84,   164,    -1,     6,    87,
      85,   164,    86,    -1,     6,    87,   164,    -1,    21,    -1,
      22,    63,    -1,     8,    87,   122,    -1,    11,    87,   122,
      -1,    14,    -1,    18,    87,    83,    -1,    18,    87,    63,
      -1,     5,    87,    83,    -1,     5,    87,    63,    -1,    16,
      -1,   173,    -1,   173,   172,    -1,    37,    -1,    17,    87,
      83,    -1,    17,    87,    63,    -1,    19,    87,    83,    -1,
      19,    87,    63,    -1,    23,    -1,    24,    -1,    25,    87,
      63,    -1,    84,    80,    87,    85,    78,    86,    -1,    26,
      80,    87,    85,    78,    86,    -1,    26,    80,    87,    85,
      78,    84,    64,    86,    -1,    26,    80,    87,    85,    78,
      84,    64,    84,    78,    86,    -1,    26,    80,    87,    85,
      78,    84,    63,    86,    -1,    26,    80,    87,    85,    78,
      84,    63,    84,    78,    86,    -1,    -1,    12,   175,   172,
      -1,    76,    -1,    76,    39,    85,    63,    86,    -1,    76,
      39,    85,    63,    84,    63,    86,    -1,    76,    39,    85,
      84,    63,    86,    -1,    76,    39,    85,    63,    84,    63,
      84,    63,    86,    -1,    76,    39,    85,    84,    84,    63,
      86,    -1,    76,    39,    85,    63,    84,    84,    63,    86,
      -1,    77,    -1,    77,    39,    85,    63,    86,    -1,    77,
      39,    85,    63,    84,    63,    86,    -1,    77,    39,    85,
      84,    63,    86,    -1,    77,    39,    85,    63,    84,    63,
      84,    63,    86,    -1,    77,    39,    85,    84,    84,    63,
      86,    -1,    77,    39,    85,    63,    84,    84,    63,    86,
      -1,    33,    38,   176,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   225,   225,   226,   228,   229,   230,   231,   232,   233,
     234,   235,   236,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   253,   254,
     255,   259,   259,   276,   276,   293,   309,   320,   329,   338,
     347,   356,   362,   365,   369,   384,   389,   395,   402,   407,
     419,   434,   449,   462,   481,   483,   489,   513,   528,   528,
     535,   543,   543,   552,   562,   562,   589,   590,   594,   598,
     602,   606,   630,   636,   649,   675,   692,   693,   713,   713,
     724,   725,   741,   752,   777,   780,   784,   793,   811,   827,
     841,   853,   865,   880,   895,   913,   930,   954,   970,   997,
    1015,  1039,  1059,  1068,  1080,  1089,  1113,  1119,  1131,  1133,
    1141,  1213,  1228,  1254,  1299,  1341,  1385,  1429,  1474,  1528,
    1568,  1624,  1644,  1664,  1755,  1846,  1939,  1942,  1945,  1946,
    1967,  1988,  2009,  2031,  2056,  2083,  2094,  2110,  2130,  2174,
    2178,  2186,  2217,  2245,  2260,  2260,  2271,  2271,  2281,  2281,
    2292,  2292,  2302,  2302,  2314,  2314,  2325,  2325,  2335,  2335,
    2346,  2346,  2361,  2361,  2371,  2371,  2385,  2385,  2395,  2395,
    2405,  2405,  2415,  2415,  2425,  2425,  2437,  2437,  2448,  2448,
    2458,  2458,  2469,  2469,  2483,  2483,  2494,  2495,  2498,  2508,
    2525,  2537,  2541,  2548,  2554,  2574,  2580,  2582,  2584,  2588,
    2594,  2606,  2618,  2634,  2639,  2647,  2652,  2659,  2668,  2670,
    2673,  2677,  2681,  2685,  2689,  2693,  2697,  2701,  2705,  2712,
    2719,  2725,  2732,  2738,  2747,  2747,  2759,  2765,  2771,  2777,
    2783,  2789,  2795,  2802,  2808,  2814,  2820,  2826,  2832,  2838,
    2849
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"AND clause\"", "\"COND clause\"",
  "\"ENDREC clause\"", "\"FNAMES clause\"", "\"FORMAT clause\"",
  "\"INCLUDE clause\"", "\"INREC clause\"", "\"NONE clause\"",
  "\"OMIT clause\"", "\"OPTION clause\"", "\"OR clause\"",
  "\"OUTFIL clause\"", "\"OUTREC clause\"", "\"SAVE clause\"",
  "\"SKIP clause\"", "\"STARTREC clause\"", "\"STOPAFT clause\"",
  "\"SUM clause\"", "\"SPLIT clause\"", "\"SPLITBY clause\"",
  "\"VLSCMP clause\"", "\"VLSHRT clause\"", "\"Y2PAST clause\"",
  "\"MODS clause\"", "\"BUILD instruction\"", "\"FIELDS instruction\"",
  "\"OVERLAY instruction\"", "\"GIVE clause\"", "\"MERGE clause\"",
  "\"ORG instruction\"", "\"RECORD instruction\"", "\"SORT clause\"",
  "\"JOINKEYS clause\"", "\"USE clause\"", "\"COPY\"", "\"TYPE\"",
  "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"", "\"DATE4\"",
  "\"CHANGE\"", "\"NOMATCH\"", "\"SORTED\"", "\"NOSEQCK\"", "\"UNPAIRED\"",
  "\"ONLY\"", "\"JOIN\"", "\"JOINREFORMAT\"", "\"FILL\"", "\"FINDREP\"",
  "\"IN\"", "\"OUT\"", "\"INOUT\"", "\"STARTPOS\"", "\"ENDPOS\"", "\"DO\"",
  "\"MAXLEN\"", "\"OVERRUN\"", "\"SHIFT\"", "\"DIGIT\"", "\"DIGITBIG\"",
  "\"CHARTCOND\"", "\"CHARTYPE\"", "\"FILETYPE\"", "\"FORMATTYPE\"",
  "\"JOINFILE\"", "\"KEY\"", "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"",
  "\"SUBSTRING\"", "\"ORDER\"", "\"RECTYPEFIX\"", "\"RECTYPEVAR\"",
  "\"STRING\"", "\"TOKSKIP clause\"", "\"EXROUT clause\"",
  "\"YESNO clause\"", "\"ERRTRUNC clause\"", "\"SIGNDIGITBIG\"", "','",
  "'('", "')'", "'='", "'?'", "':'", "$accept", "beginning", "clause",
  "useclause", "$@1", "giveclause", "$@2", "recordorginstruction",
  "allkeyfield", "keyfield", "fieldtype", "fielddirection", "condition",
  "fieldvaluecond", "fieldvaluerec", "fieldvalueconst", "allsortfield",
  "sortfield", "sortclause", "$@3", "mergeclause", "$@4", "joinkeysclause",
  "$@5", "joinkeysalloptions", "joinkeysoptions", "joinclause",
  "joinoptions", "joinreformatclause", "$@6", "fill_char", "formatclause",
  "allcondfield", "condfieldcond", "datetype", "omitclause",
  "includeclause", "allinoutrec", "inoutrec", "findrep_options_all",
  "findrep_options", "allfieldvaluerec", "inoutfieldvaluerec",
  "changepair", "changepairdet", "changeCmdOpt", "outrecclause", "$@7",
  "$@8", "$@9", "$@10", "$@11", "$@12", "$@13", "$@14", "$@15", "$@16",
  "$@17", "inrecclause", "$@18", "$@19", "$@20", "$@21", "$@22", "$@23",
  "$@24", "$@25", "$@26", "buildclause", "$@27", "allsumfield", "sumfield",
  "sumclause", "tokskipclause", "filesgroup", "fnamesclause",
  "outfilincludeclause", "outfilomitclause", "outfilclause",
  "startrecclause", "endrecclause", "saveclause", "alloption", "option",
  "optionclause", "$@28", "recordoption", "recordclause", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,    44,    40,    41,    61,    63,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    90,    91,    91,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    94,    93,    96,    95,    97,    97,    97,    97,    97,
      97,    97,    98,    98,    99,   100,   100,   101,   102,   102,
     103,   104,   105,   105,   106,   106,   107,   107,   109,   108,
     108,   111,   110,   110,   113,   112,   114,   114,   115,   115,
     115,   115,   116,   116,   116,   116,   117,   117,   119,   118,
     120,   120,   121,   121,   122,   122,   122,   122,   123,   123,
     123,   123,   123,   123,   123,   124,   124,   124,   124,   124,
     124,   124,   125,   125,   126,   126,   126,   126,   127,   127,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   128,
     128,   128,   128,   128,   128,   128,   129,   129,   130,   130,
     130,   130,   130,   130,   130,   131,   131,   132,   132,   133,
     133,   134,   134,   135,   137,   136,   138,   136,   139,   136,
     140,   136,   141,   136,   142,   136,   143,   136,   144,   136,
     145,   136,   146,   136,   147,   136,   149,   148,   150,   148,
     151,   148,   152,   148,   153,   148,   154,   148,   155,   148,
     156,   148,   157,   148,   159,   158,   160,   160,   161,   161,
     161,   162,   162,   163,   164,   164,   165,   165,   165,   165,
     166,   167,   168,   169,   169,   170,   170,   171,   172,   172,
     173,   173,   173,   173,   173,   173,   173,   173,   173,   173,
     173,   173,   173,   173,   175,   174,   176,   176,   176,   176,
     176,   176,   176,   176,   176,   176,   176,   176,   176,   176,
     177
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     3,     5,     1,     1,     1,     1,     1,
       2,     2,     1,     1,     1,     3,     5,     7,     0,     6,
       3,     0,     6,     3,     0,    10,     1,     2,     2,     4,
       3,     3,     2,     3,     5,     7,     0,     2,     0,     7,
       0,     3,     3,     3,     1,     3,     3,     3,    13,     9,
       9,     9,     7,     7,     9,     1,     2,     1,     2,     1,
       2,     1,     3,     4,     3,     4,     5,     6,     1,     3,
       3,     1,     5,     4,     5,     1,     2,     3,     1,     1,
       2,    11,    13,     8,    10,     6,     1,     3,     0,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     5,     6,     2,     0,     7,     0,     6,     0,     7,
       0,     6,     0,     7,     0,     6,     0,     5,     0,     7,
       0,     4,     0,     6,     0,     5,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     5,
       0,     7,     0,     4,     0,     6,     1,     3,     3,     7,
       5,     3,     5,     1,     1,     3,     5,     3,     1,     2,
       3,     3,     1,     3,     3,     3,     3,     1,     1,     2,
       1,     3,     3,     3,     3,     1,     1,     3,     6,     6,
       8,    10,     8,    10,     0,     3,     1,     5,     7,     6,
       9,     7,     8,     1,     5,     7,     6,     9,     7,     8,
       3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   224,   202,     0,
     207,     0,     0,     0,   198,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   193,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    66,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   182,     0,     0,     0,
       0,     0,     0,   160,   164,     0,     0,     0,     0,   199,
      33,     0,     0,     0,     0,    31,    72,     0,     0,     0,
      68,    77,     1,     3,     0,    67,   206,   205,   194,     0,
     197,    45,    83,    46,    82,     0,     0,     0,   104,    84,
     200,     0,   172,     0,   168,     0,   176,     0,   178,     0,
       0,   102,   201,     0,     0,   215,   216,     0,     0,   210,
       0,   225,   208,   150,     0,   146,     0,   154,     0,   156,
       0,     0,   162,   204,   203,    71,    70,   191,     0,    35,
      63,    61,   226,   233,   240,    60,    58,     0,    35,     0,
      73,    78,    81,   184,     0,     0,     0,     0,     0,   105,
       0,     0,     0,     0,   170,     0,   166,     0,   174,   180,
       0,     0,     0,     0,     0,   118,     0,   115,   111,   119,
     183,   108,   103,     0,     0,     0,     0,     0,   209,     0,
     148,     0,   144,     0,   152,   158,     0,   161,     0,     0,
       0,     0,   186,     0,     0,     0,    34,     0,     0,     0,
       0,     0,    32,    76,     0,     0,    69,   196,   195,     0,
      85,    86,    87,     0,   106,     0,     0,     0,     0,     0,
       0,     0,   179,     0,     0,     0,   120,     0,    51,     0,
     116,     0,   212,   211,   214,   213,   217,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   157,   165,     0,     0,
     192,     0,    35,     0,     0,     0,     0,     0,     0,    54,
       0,     0,     0,     0,     0,    74,     0,     0,     0,   107,
     173,     0,   169,     0,   177,     0,     0,     0,     0,     0,
       0,     0,   110,     0,   117,     0,   109,     0,     0,   151,
       0,   147,     0,   155,     0,     0,   163,   188,   187,    36,
       0,     0,     0,     0,     0,     0,    42,     0,    62,     0,
       0,     0,     0,     0,    59,     0,    76,    80,   185,    48,
      46,     0,     0,   171,   167,   175,   181,     0,   135,     0,
       0,   137,     0,     0,   113,     0,     0,     0,   149,   145,
     153,   159,     0,    35,     0,     0,     0,     0,    35,     0,
       0,    55,     0,   227,     0,     0,     0,   234,     0,     0,
      64,     0,    75,    79,     0,     0,     0,     0,   139,     0,
       0,     0,     0,   128,   114,   112,     0,   219,   218,     0,
     190,    39,     0,     0,     0,     0,    41,    43,     0,     0,
       0,   229,     0,     0,     0,   236,     0,     0,    49,     0,
      52,     0,    53,    93,    92,     0,     0,     0,   136,     0,
       0,   138,     0,     0,     0,     0,     0,     0,   125,   126,
       0,     0,     0,    35,    35,     0,     0,    47,     0,    56,
       0,   228,     0,   231,     0,   235,     0,   238,     0,     0,
       0,    50,     0,     0,   140,     0,   128,     0,     0,     0,
       0,     0,     0,   128,     0,   222,     0,   220,   189,    37,
      40,     0,    44,     0,     0,   232,     0,   239,    65,    95,
      97,    99,   101,    52,    90,    91,    94,    89,     0,     0,
       0,     0,   123,   129,   130,   131,   132,   133,   134,   127,
       0,     0,    35,    57,   230,   237,    96,    98,   100,     0,
       0,   141,     0,   128,   223,   221,    38,     0,   142,     0,
       0,     0,   124,     0,     0,   143,   121,    88,     0,   122
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   158,    30,   149,   216,   325,   326,
     104,   449,   342,   423,   189,   424,   278,   279,    31,   220,
      32,   217,    33,   417,    34,    35,    36,    37,    38,   224,
      39,    40,   108,   109,   496,    41,    42,   190,   191,   438,
     439,   349,   352,   387,   388,   531,    43,   262,   201,   260,
     199,   264,   203,   206,   265,   140,   209,   141,    44,   238,
     175,   236,   173,   240,   177,   180,   241,   119,    45,   225,
     211,   212,    46,    47,   100,    48,    49,    50,    51,    52,
      53,    54,   131,   132,    55,    69,   154,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -446
static const yytype_int16 yypact[] =
{
     146,   -57,     3,     8,     7,    69,     6,  -446,  -446,    34,
    -446,    60,    72,    58,  -446,   -17,    94,   172,   161,   178,
     225,   205,   202,   236,   239,  -446,    23,   306,   146,  -446,
    -446,  -446,  -446,  -446,  -446,    -2,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,   -34,   -37,   135,
      17,   -32,   223,   136,   137,   141,   221,    43,   -32,     1,
     142,   147,   158,   222,  -446,   226,    18,    80,    -1,  -446,
    -446,   -18,    49,   -14,   227,  -446,   228,   230,   232,   231,
     229,  -446,  -446,  -446,   271,  -446,  -446,  -446,  -446,   241,
     234,  -446,  -446,  -446,  -446,   237,   -32,   -32,   131,  -446,
     131,   316,  -446,   238,  -446,   242,  -446,   243,   244,   148,
     -32,   131,   131,   235,   245,  -446,  -446,   246,   250,  -446,
     251,  -446,     1,  -446,   249,  -446,   252,  -446,   253,   254,
     148,   148,  -446,  -446,  -446,  -446,  -446,  -446,   261,     4,
    -446,  -446,   286,   287,  -446,  -446,  -446,   266,     4,   101,
    -446,  -446,  -446,  -446,   289,   149,   241,   277,     2,   131,
     -32,   -32,    48,   148,  -446,   148,  -446,   148,  -446,  -446,
     148,   256,   255,   257,   -30,   265,   258,   267,  -446,  -446,
     262,  -446,   131,   106,   108,   285,   263,   264,  -446,   148,
    -446,   148,  -446,   148,  -446,  -446,   148,   262,   160,   148,
     268,   269,   272,   282,    98,   273,  -446,   290,   274,   275,
     290,   278,  -446,   279,   148,   148,  -446,  -446,   234,   280,
    -446,  -446,   354,   -32,   131,   163,   148,   167,   148,   170,
     148,   148,   262,   298,   -21,   281,   302,    46,  -446,   304,
    -446,   148,  -446,  -446,  -446,  -446,  -446,   283,   284,   171,
     148,   175,   148,   176,   148,   148,   262,  -446,   179,   307,
    -446,   261,     4,   288,   291,    64,   308,   292,   293,   294,
     -41,   -24,   295,   345,   124,  -446,   182,   183,   139,   131,
    -446,   186,  -446,   187,  -446,   190,   191,   296,   265,   311,
     299,   311,  -446,   300,   309,   301,   262,   310,   312,  -446,
     194,  -446,   195,  -446,   198,   203,  -446,   305,  -446,  -446,
     319,   323,   313,   314,   315,   317,   318,   328,  -446,   290,
     204,    16,   207,    26,  -446,   320,   322,   340,  -446,  -446,
    -446,   324,   325,  -446,  -446,  -446,  -446,   327,   326,   321,
     339,   329,   330,   332,  -446,   333,   208,   331,  -446,  -446,
    -446,  -446,    74,     4,   334,   337,   338,   341,     4,   308,
     335,  -446,    36,  -446,   336,   348,    61,  -446,   342,   349,
    -446,   365,  -446,  -446,   112,    73,   343,   344,   347,   311,
     350,   346,   311,   180,  -446,  -446,   240,  -446,  -446,   351,
    -446,  -446,   352,   353,   356,   357,  -446,  -446,   120,   211,
     360,  -446,   358,   212,   361,  -446,   359,   290,  -446,   362,
     363,   364,  -446,  -446,  -446,   366,   367,   327,  -446,   370,
     311,  -446,   368,   369,   371,   372,   373,   374,  -446,   378,
     215,   216,   375,     4,     4,   380,   303,  -446,   379,  -446,
     385,  -446,   381,  -446,   386,  -446,   382,  -446,   383,    -8,
     389,  -446,   152,   384,  -446,   377,   180,   390,   391,   394,
     402,   355,   392,   180,   388,  -446,   393,  -446,  -446,  -446,
    -446,   395,  -446,   397,   396,  -446,   398,  -446,  -446,   407,
     411,   412,  -446,   399,  -446,  -446,  -446,  -446,   401,   400,
     403,   311,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
     404,   405,     4,  -446,  -446,  -446,  -446,  -446,  -446,   413,
     414,  -446,   153,   180,  -446,  -446,  -446,   408,  -446,   409,
     416,   410,  -446,   116,   417,  -446,  -446,  -446,   415,  -446
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -446,   451,  -446,  -446,  -446,  -446,  -446,  -158,    51,  -446,
    -285,   -56,    42,   -27,  -243,   -23,  -216,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,   452,  -446,  -446,   -84,  -446,  -446,
     162,   482,   -55,  -446,  -446,  -446,  -446,  -133,  -446,  -445,
    -446,   100,   103,    70,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,  -446,
     233,  -446,  -446,  -446,   -83,  -446,  -446,  -446,  -446,  -446,
    -446,  -446,   376,  -446,  -446,  -446,  -446,  -446
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     222,   300,   160,   341,   282,   170,   110,   207,   208,   147,
      67,    60,   121,   122,     3,   171,   165,    12,   123,   150,
     124,   502,   330,   155,   125,   126,   127,   128,   509,    96,
      57,   105,   489,   490,   491,   492,   213,   214,   129,   332,
     235,    98,   237,   331,   239,   298,    79,   242,    99,    97,
      89,   168,   169,   106,   246,   493,   348,   421,   351,   247,
     333,    70,    71,    72,   299,   192,   259,   151,   261,    90,
     263,   156,    91,   266,   215,   422,   268,   400,   532,   374,
     105,   143,    94,   228,   148,   130,    78,    73,   230,   378,
      58,   286,   287,    68,    61,    59,    63,    64,    65,   409,
     375,   144,   106,   291,   107,   293,   105,   295,   296,   303,
     379,   105,   304,   371,   319,   231,   232,   234,   306,    74,
     410,    75,    66,   448,   413,   152,   153,   310,   106,   312,
     120,   314,   315,   106,   170,   233,   420,   399,   421,   285,
     322,   323,   101,   145,   171,   414,   348,    76,   103,   351,
      91,     1,     2,     3,     4,     5,   422,     6,     7,    77,
       8,     9,    10,   146,    11,    12,    13,    14,    15,   252,
     223,   254,    80,    91,   273,   274,    16,    17,   289,    18,
      19,    20,    21,   275,   101,   339,   418,   466,   101,   253,
     103,   255,   181,   336,   103,   447,    22,    23,    24,    82,
      81,   458,   182,   101,   183,   401,    83,   101,   102,   103,
     406,   184,   339,   340,   185,   498,   529,   186,   499,   530,
     187,   112,   114,   113,   115,    25,   116,   133,   117,   134,
      26,    84,   135,   166,   136,   227,   188,   432,   433,   434,
     435,   436,   437,   137,   251,   138,   267,   251,   537,   290,
      86,   251,   382,   292,   251,   251,   294,   309,   523,   251,
     251,   311,   313,   251,    87,   316,   251,   251,   337,   338,
     251,   251,   343,   344,   251,   251,   345,   346,   251,   251,
     358,   359,   251,    85,   360,   479,   480,   251,   372,   361,
     373,   376,   396,   377,   397,   450,   454,   451,   455,   474,
     476,   475,   477,   440,   441,    88,    92,   111,   118,   139,
     162,   142,   159,   164,   157,   161,   163,    90,   166,    98,
     172,   167,   193,   174,   210,   218,   219,   176,   178,   179,
     196,   197,   194,   195,   200,   221,   226,   202,   204,   205,
     229,   243,   244,   248,   245,   250,   251,   249,   256,   272,
     257,   258,   269,   277,   526,   270,   271,   170,   276,   280,
     281,   297,   283,   284,   288,   302,   301,   305,   307,   308,
     317,   324,   320,   335,   482,   321,   327,   298,   329,   328,
     347,   334,   363,   350,   353,   355,   364,   354,   356,   362,
     357,   370,    24,   386,   391,   394,   395,   365,   366,   367,
     403,   404,   369,   368,   405,   380,   381,   390,   384,   385,
     389,   412,   416,   392,    91,   443,   393,   398,   402,   408,
     407,   425,   411,   452,   456,   465,   419,   513,   415,   500,
     426,   427,   494,   430,   429,   442,   495,   507,   478,   444,
     445,   446,   461,   481,   453,   457,   459,   460,   484,   486,
     462,   463,   497,   503,   504,   467,   468,   505,   469,   470,
     471,   472,   473,   483,   501,   506,   510,   485,   487,   488,
     516,   511,   447,   508,   517,   518,   527,   528,   521,    93,
     538,   512,   514,   519,   515,   520,    62,    95,   522,   428,
     524,   525,   533,   534,   535,   431,   536,   464,     0,   383,
       0,   539,     0,     0,   318,     0,     0,     0,   198
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-446)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     158,   244,    86,   288,   220,     3,    61,   140,   141,    10,
       4,     4,    67,    68,     7,    13,    99,    19,    17,    37,
      19,   466,    63,    37,    23,    24,    25,    26,   473,    63,
      87,    63,    40,    41,    42,    43,    32,    33,    37,    63,
     173,    78,   175,    84,   177,    66,    63,   180,    85,    83,
      27,   106,   107,    85,    84,    63,   299,    65,   301,    89,
      84,    27,    28,    29,    85,   120,   199,    85,   201,    46,
     203,    85,    49,   206,    70,    83,   209,   362,   523,    63,
      63,    63,    84,   166,    85,    84,    28,    53,    86,    63,
      87,   224,   225,    87,    87,    87,    27,    28,    29,    63,
      84,    83,    85,   236,    87,   238,    63,   240,   241,    63,
      84,    63,    66,   329,   272,   170,   171,   172,   251,    85,
      84,    87,    53,   408,    63,    76,    77,   260,    85,   262,
      87,   264,   265,    85,     3,    87,    63,    63,    65,   223,
      76,    77,    68,    63,    13,    84,   389,    87,    74,   392,
      49,     5,     6,     7,     8,     9,    83,    11,    12,    87,
      14,    15,    16,    83,    18,    19,    20,    21,    22,    63,
      69,    63,    78,    49,    76,    77,    30,    31,   233,    33,
      34,    35,    36,    85,    68,    73,    74,   430,    68,    83,
      74,    83,    44,    69,    74,    75,    50,    51,    52,    38,
      28,   417,    54,    68,    56,   363,    28,    68,    73,    74,
     368,    63,    73,    74,    66,    63,    63,    69,    66,    66,
      72,    85,    85,    87,    87,    79,    85,    85,    87,    87,
      84,     6,    85,    84,    87,    86,    88,    57,    58,    59,
      60,    61,    62,    85,    84,    87,    86,    84,   533,    86,
      48,    84,   336,    86,    84,    84,    86,    86,   501,    84,
      84,    86,    86,    84,    28,    86,    84,    84,    86,    86,
      84,    84,    86,    86,    84,    84,    86,    86,    84,    84,
      86,    86,    84,    78,    86,   443,   444,    84,    84,    86,
      86,    84,    84,    86,    86,    84,    84,    86,    86,    84,
      84,    86,    86,    63,    64,    66,     0,    84,    87,    87,
      78,    85,    84,    84,    87,    85,    85,    46,    84,    78,
       4,    84,    87,    85,    63,    39,    39,    85,    85,    85,
      80,    80,    87,    87,    85,    69,    47,    85,    85,    85,
      63,    85,    87,    78,    87,    78,    84,    89,    63,    67,
      87,    87,    84,    63,   512,    86,    84,     3,    85,    85,
      85,    63,    84,    84,    84,    63,    85,    63,    85,    85,
      63,    63,    84,    28,    71,    84,    84,    66,    84,    86,
      84,    86,    63,    84,    84,    84,    63,    78,    78,    84,
      78,    63,    52,    66,    55,    63,    63,    84,    84,    84,
      63,    63,    84,    86,    63,    85,    84,    86,    84,    84,
      84,    63,    63,    84,    49,    63,    86,    86,    84,    84,
     369,    78,    86,    63,    63,    55,   384,   483,    86,    45,
      86,    84,   459,    87,    84,    84,   459,    82,    63,    86,
      84,    84,    78,    63,    86,    86,    84,    84,    63,    63,
      84,    84,    63,    63,    63,    87,    87,    63,    87,    87,
      87,    87,    84,    84,    87,    63,    78,    86,    86,    86,
      63,    78,    75,    81,    63,    63,    63,    63,    78,    28,
      63,    86,    86,    84,    86,    84,     4,    35,    85,   389,
      86,    86,    84,    84,    78,   392,    86,   427,    -1,   337,
      -1,    86,    -1,    -1,   271,    -1,    -1,    -1,   132
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    21,    22,    30,    31,    33,    34,
      35,    36,    50,    51,    52,    79,    84,    91,    92,    93,
      95,   108,   110,   112,   114,   115,   116,   117,   118,   120,
     121,   125,   126,   136,   148,   158,   162,   163,   165,   166,
     167,   168,   169,   170,   171,   174,   177,    87,    87,    87,
       4,    87,   121,    27,    28,    29,    53,     4,    87,   175,
      27,    28,    29,    53,    85,    87,    87,    87,    28,    63,
      78,    28,    38,    28,     6,    78,    48,    28,    66,    27,
      46,    49,     0,    91,    84,   114,    63,    83,    78,    85,
     164,    68,    73,    74,   100,    63,    85,    87,   122,   123,
     122,    84,    85,    87,    85,    87,    85,    87,    87,   157,
      87,   122,   122,    17,    19,    23,    24,    25,    26,    37,
      84,   172,   173,    85,    87,    85,    87,    85,    87,    87,
     145,   147,    85,    63,    83,    63,    83,    10,    85,    96,
      37,    85,    76,    77,   176,    37,    85,    87,    94,    84,
     117,    85,    78,    85,    84,   164,    84,    84,   122,   122,
       3,    13,     4,   152,    85,   150,    85,   154,    85,    85,
     155,    44,    54,    56,    63,    66,    69,    72,    88,   104,
     127,   128,   122,    87,    87,    87,    80,    80,   172,   140,
      85,   138,    85,   142,    85,    85,   143,   127,   127,   146,
      63,   160,   161,    32,    33,    70,    97,   111,    39,    39,
     109,    69,    97,    69,   119,   159,    47,    86,   164,    63,
      86,   122,   122,    87,   122,   127,   151,   127,   149,   127,
     153,   156,   127,    85,    87,    87,    84,    89,    78,    89,
      78,    84,    63,    83,    63,    83,    63,    87,    87,   127,
     139,   127,   137,   127,   141,   144,   127,    86,   127,    84,
      86,    84,    67,    76,    77,    85,    85,    63,   106,   107,
      85,    85,   106,    84,    84,   117,   127,   127,    84,   122,
      86,   127,    86,   127,    86,   127,   127,    63,    66,    85,
     104,    85,    63,    63,    66,    63,   127,    85,    85,    86,
     127,    86,   127,    86,   127,   127,    86,    63,   160,    97,
      84,    84,    76,    77,    63,    98,    99,    84,    86,    84,
      63,    84,    63,    84,    86,    28,    69,    86,    86,    73,
      74,   100,   102,    86,    86,    86,    86,    84,   104,   131,
      84,   104,   132,    84,    78,    84,    78,    78,    86,    86,
      86,    86,    84,    63,    63,    84,    84,    84,    86,    84,
      63,   106,    84,    86,    63,    84,    84,    86,    63,    84,
      85,    84,   117,   120,    84,    84,    66,   133,   134,    84,
      86,    55,    84,    86,    63,    63,    84,    86,    86,    63,
     100,    97,    84,    63,    63,    63,    97,    98,    84,    63,
      84,    86,    63,    63,    84,    86,    63,   113,    74,   102,
      63,    65,    83,   103,   105,    78,    86,    84,   131,    84,
      87,   132,    57,    58,    59,    60,    61,    62,   129,   130,
      63,    64,    84,    63,    86,    84,    84,    75,   100,   101,
      84,    86,    63,    86,    84,    86,    63,    86,   106,    84,
      84,    78,    84,    84,   133,    55,   104,    87,    87,    87,
      87,    87,    87,    84,    84,    86,    84,    86,    63,    97,
      97,    63,    71,    84,    63,    86,    63,    86,    86,    40,
      41,    42,    43,    63,   103,   105,   124,    63,    63,    66,
      45,    87,   129,    63,    63,    63,    63,    82,    81,   129,
      78,    78,    86,   101,    86,    86,    63,    63,    63,    84,
      84,    78,    85,   104,    86,    86,    97,    63,    63,    63,
      66,   135,   129,    84,    84,    78,    86,   100,    63,    86
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))

/* Error token number */
#define YYTERROR	1
#define YYERRCODE	256


/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
        break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - Assume YYFAIL is not used.  It's too flawed to consider.  See
       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
       for details.  YYERROR is fine as it does not invoke this
       function.
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
        break;
    }
}




/* The lookahead symbol.  */
int yychar;


#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);

/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
/* Line 1792 of yacc.c  */
#line 228 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 229 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 230 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 231 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 232 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 233 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 234 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 235 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 236 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 237 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 238 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 239 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 240 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 241 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 242 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 243 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 244 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 245 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 246 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 247 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 248 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 249 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 250 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 251 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 253 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 254 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 255 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 259 "..\\..\\parser.y"
    {   
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
=======


/* Line 391 of yacc.c  */
#line 327 "..\\..\\parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(N) (N)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (YYID (0))
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  92
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   526

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  91
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  88
/* YYNRULES -- Number of rules.  */
#define YYNRULES  244
/* YYNRULES -- Number of states.  */
#define YYNSTATES  548

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   339

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      86,    87,     2,     2,    85,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    90,     2,
       2,    88,     2,    89,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    47,    49,    51,    53,    55,    57,
      59,    61,    62,    67,    68,    73,    74,    78,    86,    96,
     102,   110,   116,   118,   122,   128,   130,   132,   134,   136,
     138,   141,   144,   146,   148,   150,   154,   160,   168,   169,
     176,   180,   181,   188,   192,   193,   204,   206,   209,   212,
     217,   221,   225,   228,   232,   238,   246,   247,   250,   251,
     259,   260,   264,   268,   272,   274,   278,   282,   286,   300,
     310,   320,   330,   338,   346,   356,   358,   361,   363,   366,
     368,   371,   373,   377,   382,   386,   391,   397,   404,   406,
     410,   414,   416,   422,   427,   433,   435,   438,   442,   444,
     446,   449,   461,   475,   484,   495,   502,   504,   508,   509,
     513,   517,   521,   525,   529,   533,   535,   539,   541,   545,
     547,   551,   557,   564,   567,   568,   576,   577,   584,   585,
     593,   594,   601,   602,   610,   611,   618,   619,   625,   626,
     634,   635,   640,   641,   648,   649,   655,   656,   664,   665,
     672,   673,   681,   682,   689,   690,   698,   699,   706,   707,
     713,   714,   722,   723,   728,   729,   736,   738,   742,   746,
     754,   760,   764,   769,   777,   783,   790,   800,   802,   804,
     808,   814,   818,   820,   823,   827,   831,   833,   837,   841,
     845,   849,   851,   853,   856,   858,   862,   866,   870,   874,
     876,   878,   882,   889,   896,   905,   916,   925,   936,   937,
     941,   943,   949,   957,   964,   974,   982,   991,   993,   999,
    1007,  1014,  1024,  1032,  1041
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      92,     0,    -1,    -1,    93,    92,    -1,   178,    -1,   109,
      -1,   111,    -1,   113,    -1,   117,    -1,   119,    -1,   115,
      -1,   118,    -1,   121,    -1,    94,    -1,    96,    -1,   122,
      -1,   170,    -1,   171,    -1,   127,    -1,   126,    -1,   149,
      -1,   163,    -1,   137,    -1,   164,    -1,   169,    -1,   167,
      -1,   168,    -1,   166,    -1,   172,    -1,   175,    -1,   159,
      -1,    -1,    37,    79,    95,    98,    -1,    -1,    31,    79,
      97,    98,    -1,    -1,    33,    68,    98,    -1,    34,    78,
      85,    64,    85,    64,    98,    -1,    34,    86,    78,    85,
      64,    85,    64,    87,    98,    -1,    34,    77,    85,    64,
      98,    -1,    34,    86,    77,    85,    64,    87,    98,    -1,
      71,    86,    99,    87,    98,    -1,   100,    -1,   100,    85,
      99,    -1,    64,    85,    64,    85,    72,    -1,    69,    -1,
      75,    -1,    76,    -1,    74,    -1,    75,    -1,    66,    79,
      -1,    67,    79,    -1,    64,    -1,    84,    -1,   108,    -1,
     108,    85,   107,    -1,    64,    85,    64,    85,   102,    -1,
      64,    85,    64,    85,   101,    85,   102,    -1,    -1,    35,
      29,    86,   110,   107,    87,    -1,    35,    29,    38,    -1,
      -1,    32,    29,    86,   112,   107,    87,    -1,    32,    29,
      38,    -1,    -1,    36,     6,    88,    70,    85,    29,    86,
     114,   107,    87,    -1,   116,    -1,   116,   115,    -1,    85,
      47,    -1,    85,    47,    85,    48,    -1,    19,    88,    84,
      -1,    19,    88,    64,    -1,    51,    49,    -1,    51,    49,
     118,    -1,    51,    49,    85,    70,   118,    -1,    51,    49,
      85,    70,    85,    70,   118,    -1,    -1,    85,    50,    -1,
      -1,    52,    29,    86,   120,   128,    87,   121,    -1,    -1,
      53,    67,    79,    -1,     7,    88,   101,    -1,     7,    88,
      74,    -1,   124,    -1,    86,   123,    87,    -1,   123,     3,
     123,    -1,   123,    13,   123,    -1,    64,    85,    64,    85,
     101,    85,   103,    85,    64,    85,    64,    85,   101,    -1,
      64,    85,    64,    85,   103,    85,    64,    85,    64,    -1,
      64,    85,    64,    85,   101,    85,   103,    85,   104,    -1,
      64,    85,    64,    85,   101,    85,   103,    85,   106,    -1,
      64,    85,    64,    85,   103,    85,   106,    -1,    64,    85,
      64,    85,   103,    85,   104,    -1,    64,    85,    64,    85,
     101,    85,   103,    85,   125,    -1,    41,    -1,    41,    64,
      -1,    42,    -1,    42,    64,    -1,    43,    -1,    43,    64,
      -1,    44,    -1,    11,     4,   123,    -1,    11,     4,    88,
     123,    -1,     8,     4,   123,    -1,     8,     4,    88,   123,
      -1,     8,   122,    85,     4,   123,    -1,     8,   122,    85,
       4,    88,   123,    -1,   129,    -1,   128,    85,   128,    -1,
      64,    85,    64,    -1,    89,    -1,    70,    90,    64,    85,
      64,    -1,    64,    90,    67,    79,    -1,    64,    90,    64,
      85,    64,    -1,    73,    -1,    73,    79,    -1,    64,    90,
      67,    -1,    67,    -1,   105,    -1,    64,    85,    -1,    45,
      86,    64,    85,   134,    87,    85,    46,    86,   136,    87,
      -1,    45,    86,    64,    85,   134,    87,    85,    46,    86,
      64,    85,    64,    87,    -1,    55,    88,   105,    85,    56,
      88,   105,   130,    -1,    55,    88,    86,   132,    87,    85,
      56,    88,   105,   130,    -1,    57,    88,    86,   133,    87,
     130,    -1,   131,    -1,   131,    85,   130,    -1,    -1,    58,
      88,    64,    -1,    59,    88,    64,    -1,    60,    88,    64,
      -1,    61,    88,    64,    -1,    62,    88,    83,    -1,    63,
      88,    82,    -1,   105,    -1,   105,    85,   132,    -1,   105,
      -1,   105,    85,   133,    -1,   135,    -1,   135,    85,   134,
      -1,    67,    79,    85,    67,    79,    -1,    67,    79,    85,
      64,    85,    64,    -1,    67,    79,    -1,    -1,    15,    29,
      88,    86,   138,   128,    87,    -1,    -1,    15,    29,    86,
     139,   128,    87,    -1,    -1,    15,    28,    88,    86,   140,
     128,    87,    -1,    -1,    15,    28,    86,   141,   128,    87,
      -1,    -1,    15,    30,    88,    86,   142,   128,    87,    -1,
      -1,    15,    30,    86,   143,   128,    87,    -1,    -1,    15,
      54,    88,   144,   128,    -1,    -1,    15,    54,    88,    86,
     145,   128,    87,    -1,    -1,    15,    54,   146,   128,    -1,
      -1,    15,    88,    86,   147,   128,    87,    -1,    -1,    15,
      86,   148,   128,    87,    -1,    -1,     9,    29,    88,    86,
     150,   128,    87,    -1,    -1,     9,    29,    86,   151,   128,
      87,    -1,    -1,     9,    28,    88,    86,   152,   128,    87,
      -1,    -1,     9,    28,    86,   153,   128,    87,    -1,    -1,
       9,    30,    88,    86,   154,   128,    87,    -1,    -1,     9,
      30,    86,   155,   128,    87,    -1,    -1,     9,    54,    88,
     156,   128,    -1,    -1,     9,    54,    88,    86,   157,   128,
      87,    -1,    -1,     9,    54,   158,   128,    -1,    -1,    85,
      28,    86,   160,   128,    87,    -1,   162,    -1,   162,    85,
     161,    -1,    64,    85,    64,    -1,    64,    85,    64,    85,
      64,    85,    64,    -1,    64,    85,    64,    85,   101,    -1,
      20,    29,    10,    -1,    20,    29,    10,    21,    -1,    20,
      29,    10,    21,     6,    88,    79,    -1,    20,    29,    86,
     161,    87,    -1,    20,    29,    86,   161,    87,    21,    -1,
      20,    29,    86,   161,    87,    21,     6,    88,    79,    -1,
      80,    -1,    79,    -1,   165,    85,   165,    -1,     6,    88,
      86,   165,    87,    -1,     6,    88,   165,    -1,    22,    -1,
      23,    64,    -1,     8,    88,   123,    -1,    11,    88,   123,
      -1,    14,    -1,    18,    88,    84,    -1,    18,    88,    64,
      -1,     5,    88,    84,    -1,     5,    88,    64,    -1,    16,
      -1,   174,    -1,   174,   173,    -1,    38,    -1,    17,    88,
      84,    -1,    17,    88,    64,    -1,    19,    88,    84,    -1,
      19,    88,    64,    -1,    24,    -1,    25,    -1,    26,    88,
      64,    -1,    85,    81,    88,    86,    79,    87,    -1,    27,
      81,    88,    86,    79,    87,    -1,    27,    81,    88,    86,
      79,    85,    65,    87,    -1,    27,    81,    88,    86,    79,
      85,    65,    85,    79,    87,    -1,    27,    81,    88,    86,
      79,    85,    64,    87,    -1,    27,    81,    88,    86,    79,
      85,    64,    85,    79,    87,    -1,    -1,    12,   176,   173,
      -1,    77,    -1,    77,    40,    86,    64,    87,    -1,    77,
      40,    86,    64,    85,    64,    87,    -1,    77,    40,    86,
      85,    64,    87,    -1,    77,    40,    86,    64,    85,    64,
      85,    64,    87,    -1,    77,    40,    86,    85,    85,    64,
      87,    -1,    77,    40,    86,    64,    85,    85,    64,    87,
      -1,    78,    -1,    78,    40,    86,    64,    87,    -1,    78,
      40,    86,    64,    85,    64,    87,    -1,    78,    40,    86,
      85,    64,    87,    -1,    78,    40,    86,    64,    85,    64,
      85,    64,    87,    -1,    78,    40,    86,    85,    85,    64,
      87,    -1,    78,    40,    86,    64,    85,    85,    64,    87,
      -1,    34,    39,   177,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   227,   227,   228,   230,   231,   232,   233,   234,   235,
     236,   237,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   255,   256,
     257,   262,   262,   279,   279,   296,   312,   323,   332,   341,
     350,   359,   365,   368,   372,   387,   392,   398,   405,   410,
     422,   437,   452,   465,   484,   486,   492,   516,   531,   531,
     538,   546,   546,   555,   565,   565,   592,   593,   597,   601,
     605,   609,   633,   639,   652,   678,   695,   696,   716,   716,
     727,   728,   744,   755,   780,   783,   787,   796,   814,   830,
     844,   856,   868,   883,   898,   916,   933,   957,   973,  1000,
    1018,  1042,  1062,  1071,  1083,  1092,  1116,  1122,  1134,  1136,
    1144,  1216,  1231,  1257,  1302,  1344,  1388,  1432,  1477,  1531,
    1571,  1627,  1647,  1667,  1758,  1849,  1942,  1945,  1948,  1949,
    1970,  1991,  2012,  2034,  2059,  2086,  2097,  2113,  2133,  2177,
    2181,  2189,  2220,  2248,  2263,  2263,  2274,  2274,  2284,  2284,
    2295,  2295,  2305,  2305,  2317,  2317,  2328,  2328,  2338,  2338,
    2349,  2349,  2364,  2364,  2374,  2374,  2388,  2388,  2398,  2398,
    2408,  2408,  2418,  2418,  2428,  2428,  2440,  2440,  2451,  2451,
    2461,  2461,  2472,  2472,  2486,  2486,  2497,  2498,  2501,  2511,
    2528,  2540,  2544,  2550,  2567,  2571,  2577,  2597,  2603,  2623,
    2629,  2631,  2633,  2637,  2643,  2655,  2667,  2683,  2688,  2696,
    2701,  2708,  2717,  2719,  2722,  2726,  2730,  2734,  2738,  2742,
    2746,  2750,  2754,  2761,  2768,  2774,  2781,  2787,  2796,  2796,
    2808,  2814,  2820,  2826,  2832,  2838,  2844,  2851,  2857,  2863,
    2869,  2875,  2881,  2887,  2898
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"AND clause\"", "\"COND clause\"",
  "\"ENDREC clause\"", "\"FNAMES clause\"", "\"FORMAT clause\"",
  "\"INCLUDE clause\"", "\"INREC clause\"", "\"NONE clause\"",
  "\"OMIT clause\"", "\"OPTION clause\"", "\"OR clause\"",
  "\"OUTFIL clause\"", "\"OUTREC clause\"", "\"SAVE clause\"",
  "\"SKIP clause\"", "\"STARTREC clause\"", "\"STOPAFT clause\"",
  "\"SUM clause\"", "\"XSUM clause\"", "\"SPLIT clause\"",
  "\"SPLITBY clause\"", "\"VLSCMP clause\"", "\"VLSHRT clause\"",
  "\"Y2PAST clause\"", "\"MODS clause\"", "\"BUILD instruction\"",
  "\"FIELDS instruction\"", "\"OVERLAY instruction\"", "\"GIVE clause\"",
  "\"MERGE clause\"", "\"ORG instruction\"", "\"RECORD instruction\"",
  "\"SORT clause\"", "\"JOINKEYS clause\"", "\"USE clause\"", "\"COPY\"",
  "\"TYPE\"", "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"",
  "\"DATE4\"", "\"CHANGE\"", "\"NOMATCH\"", "\"SORTED\"", "\"NOSEQCK\"",
  "\"UNPAIRED\"", "\"ONLY\"", "\"JOIN\"", "\"JOINREFORMAT\"", "\"FILL\"",
  "\"FINDREP\"", "\"IN\"", "\"OUT\"", "\"INOUT\"", "\"STARTPOS\"",
  "\"ENDPOS\"", "\"DO\"", "\"MAXLEN\"", "\"OVERRUN\"", "\"SHIFT\"",
  "\"DIGIT\"", "\"DIGITBIG\"", "\"CHARTCOND\"", "\"CHARTYPE\"",
  "\"FILETYPE\"", "\"FORMATTYPE\"", "\"JOINFILE\"", "\"KEY\"",
  "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"SUBSTRING\"",
  "\"ORDER\"", "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"",
  "\"TOKSKIP clause\"", "\"EXROUT clause\"", "\"YESNO clause\"",
  "\"ERRTRUNC clause\"", "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='",
  "'?'", "':'", "$accept", "beginning", "clause", "useclause", "$@1",
  "giveclause", "$@2", "recordorginstruction", "allkeyfield", "keyfield",
  "fieldtype", "fielddirection", "condition", "fieldvaluecond",
  "fieldvaluerec", "fieldvalueconst", "allsortfield", "sortfield",
  "sortclause", "$@3", "mergeclause", "$@4", "joinkeysclause", "$@5",
  "joinkeysalloptions", "joinkeysoptions", "joinclause", "joinoptions",
  "joinreformatclause", "$@6", "fill_char", "formatclause", "allcondfield",
  "condfieldcond", "datetype", "omitclause", "includeclause",
  "allinoutrec", "inoutrec", "findrep_options_all", "findrep_options",
  "allfieldvaluerec", "inoutfieldvaluerec", "changepair", "changepairdet",
  "changeCmdOpt", "outrecclause", "$@7", "$@8", "$@9", "$@10", "$@11",
  "$@12", "$@13", "$@14", "$@15", "$@16", "$@17", "inrecclause", "$@18",
  "$@19", "$@20", "$@21", "$@22", "$@23", "$@24", "$@25", "$@26",
  "buildclause", "$@27", "allsumfield", "sumfield", "sumclause",
  "tokskipclause", "filesgroup", "fnamesclause", "outfilincludeclause",
  "outfilomitclause", "outfilclause", "startrecclause", "endrecclause",
  "saveclause", "alloption", "option", "optionclause", "$@28",
  "recordoption", "recordclause", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,    44,    40,    41,    61,    63,
      58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    91,    92,    92,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
      93,    95,    94,    97,    96,    98,    98,    98,    98,    98,
      98,    98,    99,    99,   100,   101,   101,   102,   103,   103,
     104,   105,   106,   106,   107,   107,   108,   108,   110,   109,
     109,   112,   111,   111,   114,   113,   115,   115,   116,   116,
     116,   116,   117,   117,   117,   117,   118,   118,   120,   119,
     121,   121,   122,   122,   123,   123,   123,   123,   124,   124,
     124,   124,   124,   124,   124,   125,   125,   125,   125,   125,
     125,   125,   126,   126,   127,   127,   127,   127,   128,   128,
     129,   129,   129,   129,   129,   129,   129,   129,   129,   129,
     129,   129,   129,   129,   129,   129,   130,   130,   131,   131,
     131,   131,   131,   131,   131,   132,   132,   133,   133,   134,
     134,   135,   135,   136,   138,   137,   139,   137,   140,   137,
     141,   137,   142,   137,   143,   137,   144,   137,   145,   137,
     146,   137,   147,   137,   148,   137,   150,   149,   151,   149,
     152,   149,   153,   149,   154,   149,   155,   149,   156,   149,
     157,   149,   158,   149,   160,   159,   161,   161,   162,   162,
     162,   163,   163,   163,   163,   163,   163,   164,   165,   165,
     166,   166,   166,   166,   167,   168,   169,   170,   170,   171,
     171,   172,   173,   173,   174,   174,   174,   174,   174,   174,
     174,   174,   174,   174,   174,   174,   174,   174,   176,   175,
     177,   177,   177,   177,   177,   177,   177,   177,   177,   177,
     177,   177,   177,   177,   178
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     3,     5,     1,     1,     1,     1,     1,
       2,     2,     1,     1,     1,     3,     5,     7,     0,     6,
       3,     0,     6,     3,     0,    10,     1,     2,     2,     4,
       3,     3,     2,     3,     5,     7,     0,     2,     0,     7,
       0,     3,     3,     3,     1,     3,     3,     3,    13,     9,
       9,     9,     7,     7,     9,     1,     2,     1,     2,     1,
       2,     1,     3,     4,     3,     4,     5,     6,     1,     3,
       3,     1,     5,     4,     5,     1,     2,     3,     1,     1,
       2,    11,    13,     8,    10,     6,     1,     3,     0,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     5,     6,     2,     0,     7,     0,     6,     0,     7,
       0,     6,     0,     7,     0,     6,     0,     5,     0,     7,
       0,     4,     0,     6,     0,     5,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     5,
       0,     7,     0,     4,     0,     6,     1,     3,     3,     7,
       5,     3,     4,     7,     5,     6,     9,     1,     1,     3,
       5,     3,     1,     2,     3,     3,     1,     3,     3,     3,
       3,     1,     1,     2,     1,     3,     3,     3,     3,     1,
       1,     3,     6,     6,     8,    10,     8,    10,     0,     3,
       1,     5,     7,     6,     9,     7,     8,     1,     5,     7,
       6,     9,     7,     8,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   228,   206,     0,
     211,     0,     0,     0,   202,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   197,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    66,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   182,     0,     0,     0,
       0,     0,     0,   160,   164,     0,     0,     0,     0,   203,
      33,     0,     0,     0,     0,    31,    72,     0,     0,     0,
      68,    77,     1,     3,     0,    67,   210,   209,   198,     0,
     201,    45,    83,    46,    82,     0,     0,     0,   104,    84,
     204,     0,   172,     0,   168,     0,   176,     0,   178,     0,
       0,   102,   205,     0,     0,   219,   220,     0,     0,   214,
       0,   229,   212,   150,     0,   146,     0,   154,     0,   156,
       0,     0,   162,   208,   207,    71,    70,   191,     0,    35,
      63,    61,   230,   237,   244,    60,    58,     0,    35,     0,
      73,    78,    81,   184,     0,     0,     0,     0,     0,   105,
       0,     0,     0,     0,   170,     0,   166,     0,   174,   180,
       0,     0,     0,     0,     0,   118,     0,   115,   111,   119,
     183,   108,   103,     0,     0,     0,     0,     0,   213,     0,
     148,     0,   144,     0,   152,   158,     0,   161,     0,     0,
     192,     0,     0,   186,     0,     0,     0,    34,     0,     0,
       0,     0,     0,    32,    76,     0,     0,    69,   200,   199,
       0,    85,    86,    87,     0,   106,     0,     0,     0,     0,
       0,     0,     0,   179,     0,     0,     0,   120,     0,    51,
       0,   116,     0,   216,   215,   218,   217,   221,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   157,   165,     0,
       0,     0,   194,     0,    35,     0,     0,     0,     0,     0,
       0,    54,     0,     0,     0,     0,     0,    74,     0,     0,
       0,   107,   173,     0,   169,     0,   177,     0,     0,     0,
       0,     0,     0,     0,   110,     0,   117,     0,   109,     0,
       0,   151,     0,   147,     0,   155,     0,     0,   163,     0,
     188,   195,   187,    36,     0,     0,     0,     0,     0,     0,
      42,     0,    62,     0,     0,     0,     0,     0,    59,     0,
      76,    80,   185,    48,    46,     0,     0,   171,   167,   175,
     181,     0,   135,     0,     0,   137,     0,     0,   113,     0,
       0,     0,   149,   145,   153,   159,   193,     0,     0,    35,
       0,     0,     0,     0,    35,     0,     0,    55,     0,   231,
       0,     0,     0,   238,     0,     0,    64,     0,    75,    79,
       0,     0,     0,     0,   139,     0,     0,     0,     0,   128,
     114,   112,     0,   223,   222,     0,   190,     0,    39,     0,
       0,     0,     0,    41,    43,     0,     0,     0,   233,     0,
       0,     0,   240,     0,     0,    49,     0,    52,     0,    53,
      93,    92,     0,     0,     0,   136,     0,     0,   138,     0,
       0,     0,     0,     0,     0,   125,   126,     0,     0,     0,
     196,    35,    35,     0,     0,    47,     0,    56,     0,   232,
       0,   235,     0,   239,     0,   242,     0,     0,     0,    50,
       0,     0,   140,     0,   128,     0,     0,     0,     0,     0,
       0,   128,     0,   226,     0,   224,   189,    37,    40,     0,
      44,     0,     0,   236,     0,   243,    65,    95,    97,    99,
     101,    52,    90,    91,    94,    89,     0,     0,     0,     0,
     123,   129,   130,   131,   132,   133,   134,   127,     0,     0,
      35,    57,   234,   241,    96,    98,   100,     0,     0,   141,
       0,   128,   227,   225,    38,     0,   142,     0,     0,     0,
     124,     0,     0,   143,   121,    88,     0,   122
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   158,    30,   149,   217,   329,   330,
     104,   457,   346,   430,   189,   431,   280,   281,    31,   221,
      32,   218,    33,   424,    34,    35,    36,    37,    38,   225,
      39,    40,   108,   109,   504,    41,    42,   190,   191,   445,
     446,   353,   356,   393,   394,   539,    43,   263,   201,   261,
     199,   265,   203,   206,   266,   140,   209,   141,    44,   239,
     175,   237,   173,   241,   177,   180,   242,   119,    45,   226,
     212,   213,    46,    47,   100,    48,    49,    50,    51,    52,
      53,    54,   131,   132,    55,    69,   154,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -454
static const yytype_int16 yypact[] =
{
     130,   -37,    -9,    -5,     5,     6,    11,  -454,  -454,     1,
    -454,     8,    22,    92,  -454,    61,    81,   171,   175,   222,
     167,   151,   203,   262,   238,  -454,    24,   306,   130,  -454,
    -454,  -454,  -454,  -454,  -454,    -3,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,    42,    33,   144,
     -24,   -42,   223,   145,   146,   149,   219,    36,   -42,     0,
     150,   153,   154,   221,  -454,   224,    79,    95,    -2,  -454,
    -454,   -20,    56,   -18,   225,  -454,   226,   228,   233,   230,
     232,  -454,  -454,  -454,   268,  -454,  -454,  -454,  -454,   239,
     234,  -454,  -454,  -454,  -454,   235,   -42,   -42,   184,  -454,
     184,   317,  -454,   236,  -454,   237,  -454,   240,   241,    31,
     -42,   184,   184,   242,   243,  -454,  -454,   244,   247,  -454,
     248,  -454,     0,  -454,   249,  -454,   250,  -454,   251,   252,
      31,    31,  -454,  -454,  -454,  -454,  -454,   303,   261,    -1,
    -454,  -454,   293,   294,  -454,  -454,  -454,   269,    -1,   122,
    -454,  -454,  -454,  -454,   292,   158,   239,   277,    10,   184,
     -42,   -42,    83,    31,  -454,    31,  -454,    31,  -454,  -454,
      31,   256,   255,   257,    99,   265,   258,   267,  -454,  -454,
     264,  -454,   184,   110,   111,   283,   263,   266,  -454,    31,
    -454,    31,  -454,    31,  -454,  -454,    31,   264,   159,    31,
     344,   270,   271,   272,   284,   113,   273,  -454,   289,   274,
     275,   289,   278,  -454,   279,    31,    31,  -454,  -454,   234,
     280,  -454,  -454,   353,   -42,   184,   162,    31,   163,    31,
     168,    31,    31,   264,   302,   -25,   281,   304,   -19,  -454,
     305,  -454,    31,  -454,  -454,  -454,  -454,  -454,   285,   286,
     172,    31,   173,    31,   176,    31,    31,   264,  -454,   177,
     282,   309,   354,   261,    -1,   291,   295,   108,   310,   296,
     290,   297,   -27,    -8,   298,   349,   126,  -454,   181,   182,
     148,   184,  -454,   185,  -454,   186,  -454,   189,   190,   299,
     265,   312,   301,   312,  -454,   307,   308,   311,   264,   314,
     315,  -454,   193,  -454,   194,  -454,   197,   198,  -454,   316,
     313,   377,  -454,  -454,   324,   325,   318,   319,   320,   321,
     322,   326,  -454,   289,   201,     9,   202,    26,  -454,   323,
     327,   338,  -454,  -454,  -454,   328,   329,  -454,  -454,  -454,
    -454,   330,   331,   332,   343,   333,   334,   336,  -454,   337,
     205,   335,  -454,  -454,  -454,  -454,  -454,   137,   339,    -1,
     340,   342,   346,   347,    -1,   310,   341,  -454,    38,  -454,
     345,   351,    45,  -454,   348,   356,  -454,   352,  -454,  -454,
     229,   104,   350,   355,   358,   312,   359,   357,   312,   166,
    -454,  -454,   156,  -454,  -454,   361,  -454,   360,  -454,   364,
     362,   363,   365,  -454,  -454,   -22,   210,   366,  -454,   367,
     211,   369,  -454,   368,   289,  -454,   371,   372,   373,  -454,
    -454,  -454,   374,   375,   330,  -454,   378,   312,  -454,   370,
     376,   379,   380,   381,   382,  -454,   386,   214,   215,   383,
    -454,    -1,    -1,   387,   389,  -454,   388,  -454,   398,  -454,
     385,  -454,   399,  -454,   390,  -454,   391,   114,   401,  -454,
     138,   392,  -454,   393,   166,   402,   410,   411,   412,   396,
     400,   166,   404,  -454,   405,  -454,  -454,  -454,  -454,   403,
    -454,   409,   406,  -454,   407,  -454,  -454,   416,   422,   423,
    -454,   413,  -454,  -454,  -454,  -454,   414,   417,   415,   312,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,   408,   418,
      -1,  -454,  -454,  -454,  -454,  -454,  -454,   424,   425,  -454,
     140,   166,  -454,  -454,  -454,   419,  -454,   421,   428,   426,
    -454,   134,   427,  -454,  -454,  -454,   429,  -454
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -454,   395,  -454,  -454,  -454,  -454,  -454,  -158,    49,  -454,
    -287,   -74,    41,   -31,  -244,   -30,  -216,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,   457,  -454,  -454,   -84,  -454,  -454,
     100,   436,   -57,  -454,  -454,  -454,  -454,  -134,  -454,  -453,
    -454,    58,   102,    63,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
     245,  -454,  -454,  -454,   -85,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,   394,  -454,  -454,  -454,  -454,  -454
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     223,   302,   160,   345,   110,   284,   207,   208,   147,    60,
     121,   122,     3,   170,   165,    67,    12,   123,   150,   124,
     155,   510,   105,   171,   125,   126,   127,   128,   517,    70,
      71,    72,   214,   215,    63,    64,    65,   334,   129,   236,
     105,   238,   300,   240,   106,   305,   243,   101,   306,   168,
     169,    57,    89,   103,   455,    73,   336,   352,   335,   355,
      66,   301,   106,   192,   107,   260,   151,   262,   156,   264,
     216,    90,   267,   380,    91,   269,   181,   337,   540,    58,
     406,   229,    94,    59,   148,   130,   182,    74,   183,    75,
     384,   288,   289,    61,   381,   184,    76,   231,   185,    68,
     105,   186,   416,   293,   187,   295,    96,   297,   298,   420,
      77,   385,    98,   232,   233,   235,   323,   377,   308,    99,
     188,    78,   106,   417,   120,    79,    97,   312,   456,   314,
     421,   316,   317,   152,   153,     1,     2,     3,     4,     5,
     287,     6,     7,   143,     8,     9,    10,   105,    11,    12,
      13,   352,    14,    15,   355,   497,   498,   499,   500,   145,
      80,    16,    17,   144,    18,    19,    20,    21,   427,   106,
     428,   234,    91,    84,   253,   255,    91,   291,   501,   146,
     428,    22,    23,    24,   247,   326,   327,   170,   429,   248,
     275,   276,   224,   474,   254,   256,   340,   171,   429,   277,
      81,   405,   506,   101,   537,   507,   101,   538,   466,   103,
      25,   408,   103,   101,    82,    26,   413,   101,   102,   103,
     447,   448,   343,   344,   439,   440,   441,   442,   443,   444,
      85,   112,   114,   113,   115,   116,   133,   117,   134,   135,
     137,   136,   138,   166,   252,   228,   268,   252,   252,   292,
     294,    83,    86,   252,   545,   296,   388,   252,   252,   311,
     313,   252,   252,   315,   318,   531,   252,   252,   341,   342,
     252,   252,   347,   348,   252,   252,   349,   350,   252,   252,
     362,   363,   252,   252,   364,   365,   378,   382,   379,   383,
     402,    87,   403,   487,   488,   458,   462,   459,   463,   482,
     484,   483,   485,   343,   425,    88,    92,   118,   111,   139,
     142,   159,   162,   157,   161,    90,   163,   164,    98,   166,
     167,   172,   174,   176,   210,   211,   178,   179,   196,   197,
     193,   194,   195,   219,   220,   200,   202,   204,   205,   222,
     227,   230,   244,   245,   249,   246,   251,   257,   250,   252,
     270,   258,   274,   279,   259,   271,   170,   273,   272,   278,
     282,   283,   534,   285,   286,   290,   299,   303,   304,   307,
     319,   309,   310,   320,   328,   321,   324,   332,   339,   300,
     325,   331,   333,   368,   351,   338,   354,   358,   369,   370,
     376,    24,   357,   360,   361,   366,   359,   392,   367,   397,
     400,   401,    91,   371,   372,   373,   410,   375,   374,   386,
     411,   412,   387,   390,   391,   419,   395,   521,   398,   396,
     423,   399,   404,    93,   414,   409,   415,   407,   451,   432,
     460,   426,   418,   464,   473,   422,   502,   503,   508,   450,
      62,   389,   433,   434,   436,   437,   449,   486,   453,   452,
     454,   489,   469,   435,   461,   465,   467,   468,   475,   470,
     471,   490,   492,   494,   476,   505,   511,   477,   478,   479,
     480,   481,   493,   491,   512,   513,   514,   495,   496,   515,
     524,   509,   516,   518,   519,   455,   525,   526,   535,   536,
     520,   546,    95,   522,   523,   532,   529,   472,   527,   528,
     438,   530,     0,     0,   541,   533,   542,   543,     0,     0,
       0,     0,     0,   544,     0,     0,   547,     0,   322,     0,
       0,     0,     0,     0,     0,     0,   198
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-454)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     158,   245,    86,   290,    61,   221,   140,   141,    10,     4,
      67,    68,     7,     3,    99,     4,    19,    17,    38,    19,
      38,   474,    64,    13,    24,    25,    26,    27,   481,    28,
      29,    30,    33,    34,    28,    29,    30,    64,    38,   173,
      64,   175,    67,   177,    86,    64,   180,    69,    67,   106,
     107,    88,    28,    75,    76,    54,    64,   301,    85,   303,
      54,    86,    86,   120,    88,   199,    86,   201,    86,   203,
      71,    47,   206,    64,    50,   209,    45,    85,   531,    88,
     367,   166,    85,    88,    86,    85,    55,    86,    57,    88,
      64,   225,   226,    88,    85,    64,    88,    87,    67,    88,
      64,    70,    64,   237,    73,   239,    64,   241,   242,    64,
      88,    85,    79,   170,   171,   172,   274,   333,   252,    86,
      89,    29,    86,    85,    88,    64,    84,   261,   415,   263,
      85,   265,   266,    77,    78,     5,     6,     7,     8,     9,
     224,    11,    12,    64,    14,    15,    16,    64,    18,    19,
      20,   395,    22,    23,   398,    41,    42,    43,    44,    64,
      79,    31,    32,    84,    34,    35,    36,    37,    64,    86,
      66,    88,    50,     6,    64,    64,    50,   234,    64,    84,
      66,    51,    52,    53,    85,    77,    78,     3,    84,    90,
      77,    78,    70,   437,    84,    84,    70,    13,    84,    86,
      29,    64,    64,    69,    64,    67,    69,    67,   424,    75,
      80,   369,    75,    69,    39,    85,   374,    69,    74,    75,
      64,    65,    74,    75,    58,    59,    60,    61,    62,    63,
      79,    86,    86,    88,    88,    86,    86,    88,    88,    86,
      86,    88,    88,    85,    85,    87,    87,    85,    85,    87,
      87,    29,    49,    85,   541,    87,   340,    85,    85,    87,
      87,    85,    85,    87,    87,   509,    85,    85,    87,    87,
      85,    85,    87,    87,    85,    85,    87,    87,    85,    85,
      87,    87,    85,    85,    87,    87,    85,    85,    87,    87,
      85,    29,    87,   451,   452,    85,    85,    87,    87,    85,
      85,    87,    87,    74,    75,    67,     0,    88,    85,    88,
      86,    85,    79,    88,    86,    47,    86,    85,    79,    85,
      85,     4,    86,    86,    21,    64,    86,    86,    81,    81,
      88,    88,    88,    40,    40,    86,    86,    86,    86,    70,
      48,    64,    86,    88,    79,    88,    79,    64,    90,    85,
       6,    88,    68,    64,    88,    85,     3,    85,    87,    86,
      86,    86,   520,    85,    85,    85,    64,    86,    64,    64,
      88,    86,    86,    64,    64,    21,    85,    87,    29,    67,
      85,    85,    85,     6,    85,    87,    85,    79,    64,    64,
      64,    53,    85,    79,    79,    79,    85,    67,    85,    56,
      64,    64,    50,    85,    85,    85,    64,    85,    87,    86,
      64,    64,    85,    85,    85,    64,    85,   491,    85,    87,
      64,    87,    87,    28,   375,    85,    85,    88,    64,    79,
      64,   390,    87,    64,    56,    87,   467,   467,    46,    79,
       4,   341,    87,    85,    85,    88,    85,    64,    85,    87,
      85,    64,    79,   395,    87,    87,    85,    85,    88,    85,
      85,    72,    64,    64,    88,    64,    64,    88,    88,    88,
      88,    85,    87,    85,    64,    64,    64,    87,    87,    83,
      64,    88,    82,    79,    79,    76,    64,    64,    64,    64,
      87,    64,    35,    87,    87,    87,    79,   434,    85,    85,
     398,    86,    -1,    -1,    85,    87,    85,    79,    -1,    -1,
      -1,    -1,    -1,    87,    -1,    -1,    87,    -1,   273,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   132
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    22,    23,    31,    32,    34,    35,
      36,    37,    51,    52,    53,    80,    85,    92,    93,    94,
      96,   109,   111,   113,   115,   116,   117,   118,   119,   121,
     122,   126,   127,   137,   149,   159,   163,   164,   166,   167,
     168,   169,   170,   171,   172,   175,   178,    88,    88,    88,
       4,    88,   122,    28,    29,    30,    54,     4,    88,   176,
      28,    29,    30,    54,    86,    88,    88,    88,    29,    64,
      79,    29,    39,    29,     6,    79,    49,    29,    67,    28,
      47,    50,     0,    92,    85,   115,    64,    84,    79,    86,
     165,    69,    74,    75,   101,    64,    86,    88,   123,   124,
     123,    85,    86,    88,    86,    88,    86,    88,    88,   158,
      88,   123,   123,    17,    19,    24,    25,    26,    27,    38,
      85,   173,   174,    86,    88,    86,    88,    86,    88,    88,
     146,   148,    86,    64,    84,    64,    84,    10,    86,    97,
      38,    86,    77,    78,   177,    38,    86,    88,    95,    85,
     118,    86,    79,    86,    85,   165,    85,    85,   123,   123,
       3,    13,     4,   153,    86,   151,    86,   155,    86,    86,
     156,    45,    55,    57,    64,    67,    70,    73,    89,   105,
     128,   129,   123,    88,    88,    88,    81,    81,   173,   141,
      86,   139,    86,   143,    86,    86,   144,   128,   128,   147,
      21,    64,   161,   162,    33,    34,    71,    98,   112,    40,
      40,   110,    70,    98,    70,   120,   160,    48,    87,   165,
      64,    87,   123,   123,    88,   123,   128,   152,   128,   150,
     128,   154,   157,   128,    86,    88,    88,    85,    90,    79,
      90,    79,    85,    64,    84,    64,    84,    64,    88,    88,
     128,   140,   128,   138,   128,   142,   145,   128,    87,   128,
       6,    85,    87,    85,    68,    77,    78,    86,    86,    64,
     107,   108,    86,    86,   107,    85,    85,   118,   128,   128,
      85,   123,    87,   128,    87,   128,    87,   128,   128,    64,
      67,    86,   105,    86,    64,    64,    67,    64,   128,    86,
      86,    87,   128,    87,   128,    87,   128,   128,    87,    88,
      64,    21,   161,    98,    85,    85,    77,    78,    64,    99,
     100,    85,    87,    85,    64,    85,    64,    85,    87,    29,
      70,    87,    87,    74,    75,   101,   103,    87,    87,    87,
      87,    85,   105,   132,    85,   105,   133,    85,    79,    85,
      79,    79,    87,    87,    87,    87,    79,    85,     6,    64,
      64,    85,    85,    85,    87,    85,    64,   107,    85,    87,
      64,    85,    85,    87,    64,    85,    86,    85,   118,   121,
      85,    85,    67,   134,   135,    85,    87,    56,    85,    87,
      64,    64,    85,    87,    87,    64,   101,    88,    98,    85,
      64,    64,    64,    98,    99,    85,    64,    85,    87,    64,
      64,    85,    87,    64,   114,    75,   103,    64,    66,    84,
     104,   106,    79,    87,    85,   132,    85,    88,   133,    58,
      59,    60,    61,    62,    63,   130,   131,    64,    65,    85,
      79,    64,    87,    85,    85,    76,   101,   102,    85,    87,
      64,    87,    85,    87,    64,    87,   107,    85,    85,    79,
      85,    85,   134,    56,   105,    88,    88,    88,    88,    88,
      88,    85,    85,    87,    85,    87,    64,    98,    98,    64,
      72,    85,    64,    87,    64,    87,    87,    41,    42,    43,
      44,    64,   104,   106,   125,    64,    64,    67,    46,    88,
     130,    64,    64,    64,    64,    83,    82,   130,    79,    79,
      87,   102,    87,    87,    64,    64,    64,    85,    85,    79,
      86,   105,    87,    87,    98,    64,    64,    64,    67,   136,
     130,    85,    85,    79,    87,   101,    64,    87
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))

/* Error token number */
#define YYTERROR	1
#define YYERRCODE	256


/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
        break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - Assume YYFAIL is not used.  It's too flawed to consider.  See
       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
       for details.  YYERROR is fine as it does not invoke this
       function.
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
        break;
    }
}




/* The lookahead symbol.  */
int yychar;


#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);

/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
/* Line 1792 of yacc.c  */
#line 230 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 231 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 232 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 233 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 234 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 235 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 236 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 237 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 238 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 239 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 240 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 241 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 242 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 243 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 244 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 245 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 246 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 247 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 248 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 249 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 250 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 251 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 252 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 253 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 255 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 256 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 257 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 262 "..\\..\\parser.y"
    {   
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
>>>>>>> .r1070
        strcpy(szMexToken, "use clause");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 100, ABEND_SKIP);
			YYABORT;
		}
        file_setInputFile(file);
        current_file=file;
        nTypeFile=0;
<<<<<<< .mine
        free((yyvsp[0].string));
    }
#line 2157 "parser.c"
    break;

  case 32: /* useclause: "USE clause" "STRING" $@1 recordorginstruction  */
#line 270 "parser.y"
                           {
||||||| .r1065
        free((yyvsp[(2) - (2)].string));
    }
    break;

  case 32:
/* Line 1792 of yacc.c  */
#line 270 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(2) - (2)].string));
    }
    break;

  case 32:
/* Line 1792 of yacc.c  */
#line 273 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
<<<<<<< .mine
}
#line 2166 "parser.c"
    break;

  case 33: /* $@2: %empty  */
#line 276 "parser.y"
                 { 
        struct file_t *file=file_constructor((yyvsp[0].string));
||||||| .r1065
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 276 "..\\..\\parser.y"
    { 
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
=======
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 279 "..\\..\\parser.y"
    { 
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
>>>>>>> .r1070
        strcpy(szMexToken, " give clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setOutputFile(file);
        current_file=file;
        nTypeFile=0;
<<<<<<< .mine
        free((yyvsp[0].string));
}
#line 2183 "parser.c"
    break;

  case 34: /* giveclause: "GIVE clause" "STRING" $@2 recordorginstruction  */
#line 287 "parser.y"
                       {
||||||| .r1065
        free((yyvsp[(2) - (2)].string));
}
    break;

  case 34:
/* Line 1792 of yacc.c  */
#line 287 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(2) - (2)].string));
}
    break;

  case 34:
/* Line 1792 of yacc.c  */
#line 290 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
<<<<<<< .mine
}
#line 2192 "parser.c"
    break;

  case 35: /* recordorginstruction: %empty  */
#line 293 "parser.y"
||||||| .r1065
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 293 "..\\..\\parser.y"
=======
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 296 "..\\..\\parser.y"
>>>>>>> .r1070
    { 	
        strcpy(szMexToken, " record org instruction "); 
<<<<<<< .mine
    }
#line 2200 "parser.c"
    break;

  case 36: /* recordorginstruction: "ORG instruction" "FILETYPE" recordorginstruction  */
#line 309 "parser.y"
                                            {  
||||||| .r1065
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 309 "..\\..\\parser.y"
    {  
=======
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 312 "..\\..\\parser.y"
    {  
>>>>>>> .r1070
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[-1].string)));
            if (nRtc == -1)
                exit(GC_RTC_ERROR);
            nTypeFile = utils_parseFileOrganization((yyvsp[-1].string));
        }
<<<<<<< .mine
        free((yyvsp[-1].string));
}
#line 2216 "parser.c"
    break;

  case 37: /* recordorginstruction: "RECORD instruction" "RECTYPEVAR" ',' "DIGIT" ',' "DIGIT" recordorginstruction  */
#line 320 "parser.y"
                                                                     {    
||||||| .r1065
        free((yyvsp[(2) - (3)].string));
}
    break;

  case 37:
/* Line 1792 of yacc.c  */
#line 320 "..\\..\\parser.y"
    {    
=======
        free((yyvsp[(2) - (3)].string));
}
    break;

  case 37:
/* Line 1792 of yacc.c  */
#line 323 "..\\..\\parser.y"
    {    
>>>>>>> .r1070
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-5].string)));
            file_setRecordLength(current_file,(yyvsp[-3].number));
            file_setMaxLength(current_file,(yyvsp[-1].number));
        }
<<<<<<< .mine
        free((yyvsp[-5].string));
}
#line 2230 "parser.c"
    break;

  case 38: /* recordorginstruction: "RECORD instruction" '(' "RECTYPEVAR" ',' "DIGIT" ',' "DIGIT" ')' recordorginstruction  */
#line 329 "parser.y"
                                                                             {
||||||| .r1065
        free((yyvsp[(2) - (7)].string));
}
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 329 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(2) - (7)].string));
}
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 332 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-6].string)));
            file_setRecordLength(current_file,(yyvsp[-4].number));
            file_setMaxLength(current_file,(yyvsp[-2].number));
        }
<<<<<<< .mine
        free((yyvsp[-6].string));
}
#line 2243 "parser.c"
    break;

  case 39: /* recordorginstruction: "RECORD instruction" "RECTYPEFIX" ',' "DIGIT" recordorginstruction  */
#line 338 "parser.y"
                                                           {		
||||||| .r1065
        free((yyvsp[(3) - (9)].string));
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 338 "..\\..\\parser.y"
    {		
=======
        free((yyvsp[(3) - (9)].string));
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 341 "..\\..\\parser.y"
    {		
>>>>>>> .r1070
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-3].string)));
            file_setRecordLength(current_file,(yyvsp[-1].number));
            file_setMaxLength(current_file,(yyvsp[-1].number));
        }
<<<<<<< .mine
        free((yyvsp[-3].string));
}
#line 2257 "parser.c"
    break;

  case 40: /* recordorginstruction: "RECORD instruction" '(' "RECTYPEFIX" ',' "DIGIT" ')' recordorginstruction  */
#line 347 "parser.y"
                                                                   {
||||||| .r1065
        free((yyvsp[(2) - (5)].string));
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 347 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(2) - (5)].string));
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 350 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-4].string)));
            file_setRecordLength(current_file,(yyvsp[-2].number));
            file_setMaxLength(current_file,(yyvsp[-2].number));
        }
<<<<<<< .mine
        free((yyvsp[-4].string));
}
#line 2270 "parser.c"
    break;

  case 41: /* recordorginstruction: "KEY" '(' allkeyfield ')' recordorginstruction  */
#line 356 "parser.y"
                                                       {
}
#line 2277 "parser.c"
    break;

  case 42: /* allkeyfield: keyfield  */
#line 362 "parser.y"
               { 
||||||| .r1065
        free((yyvsp[(3) - (7)].string));
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 356 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 362 "..\\..\\parser.y"
    { 
=======
        free((yyvsp[(3) - (7)].string));
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 359 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 365 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        strcpy(szMexToken, " key instruction ");
<<<<<<< .mine
}
#line 2285 "parser.c"
    break;

  case 43: /* allkeyfield: keyfield ',' allkeyfield  */
#line 365 "parser.y"
                               {}
#line 2291 "parser.c"
    break;

  case 44: /* keyfield: "DIGIT" ',' "DIGIT" ',' "KEYTYPE"  */
#line 369 "parser.y"
                                  {
||||||| .r1065
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 365 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 369 "..\\..\\parser.y"
    {
=======
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 368 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 372 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (current_file!=NULL) {
            struct KeyIdx_t *KeyIdx;
            KeyIdx=KeyIdx_constructor((yyvsp[-4].number), (yyvsp[-2].number), utils_parseKeyType((yyvsp[0].string)));
            if (KeyIdx == NULL) {
               utl_abend_terminate(MEMORYALLOC, 102, ABEND_SKIP);
               YYABORT;
            }
            KeyIdx_addDefinition(KeyIdx, current_file);
        }
<<<<<<< .mine
        free((yyvsp[0].string));
 }
#line 2308 "parser.c"
    break;

  case 45: /* fieldtype: "FORMATTYPE"  */
#line 384 "parser.y"
                 {
		(yyval.number)=utils_parseFieldType((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2317 "parser.c"
    break;

  case 46: /* fieldtype: "SUBSTRING"  */
#line 389 "parser.y"
                {
		(yyval.number)=utils_parseFieldType((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2326 "parser.c"
    break;

  case 47: /* fielddirection: "ORDER"  */
#line 395 "parser.y"
            {
		(yyval.number)=utils_parseSortDirection((yyvsp[0].string));
		free((yyvsp[0].string)); 
}
#line 2335 "parser.c"
    break;

  case 48: /* condition: "OPCOND"  */
#line 402 "parser.y"
             {
		(yyval.number)=utils_parseCondCondition((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2344 "parser.c"
    break;

  case 49: /* condition: "SUBSTRING"  */
#line 407 "parser.y"
                {
		(yyval.number)=utils_parseCondCondition((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2353 "parser.c"
    break;

  case 50: /* fieldvaluecond: "CHARTCOND" "STRING"  */
#line 419 "parser.y"
                         { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
||||||| .r1065
        free((yyvsp[(5) - (5)].string));
 }
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 384 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 389 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 395 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 402 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 407 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 419 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
=======
        free((yyvsp[(5) - (5)].string));
 }
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 387 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 392 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 398 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 405 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 410 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 422 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
>>>>>>> .r1070
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 2367 "parser.c"
    break;

  case 51: /* fieldvaluerec: "CHARTYPE" "STRING"  */
#line 434 "parser.y"
                        { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
||||||| .r1065
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 434 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
=======
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 437 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
>>>>>>> .r1070
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 2381 "parser.c"
    break;

  case 52: /* fieldvalueconst: "DIGIT"  */
#line 449 "parser.y"
            {
||||||| .r1065
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 449 "..\\..\\parser.y"
    {
=======
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 452 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[0].number));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
<<<<<<< .mine
}
#line 2396 "parser.c"
    break;

  case 53: /* fieldvalueconst: "SIGNDIGITBIG"  */
#line 462 "parser.y"
                    {
||||||| .r1065
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 462 "..\\..\\parser.y"
    {
=======
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 465 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[0].llnumber));
		#else
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[0].llnumber));
		#endif
		/*  -->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);    */
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 107, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
<<<<<<< .mine
}
#line 2417 "parser.c"
    break;

  case 54: /* allsortfield: sortfield  */
#line 481 "parser.y"
                {
}
#line 2424 "parser.c"
    break;

  case 55: /* allsortfield: sortfield ',' allsortfield  */
#line 483 "parser.y"
                                 {
||||||| .r1065
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 481 "..\\..\\parser.y"
    {
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 483 "..\\..\\parser.y"
    {
=======
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 484 "..\\..\\parser.y"
    {
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 486 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        
<<<<<<< .mine
}
#line 2432 "parser.c"
    break;

  case 56: /* sortfield: "DIGIT" ',' "DIGIT" ',' fielddirection  */
#line 489 "parser.y"
                                         {
||||||| .r1065
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 489 "..\\..\\parser.y"
    {
=======
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 492 "..\\..\\parser.y"
    {
>>>>>>> .r1070
            /* Sort Fields */
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[-4].number),(yyvsp[-2].number),0, (yyvsp[0].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            nTypeFormat = 1;
        }
            /* JoinKeys */
        if (current_sortField==3) {             
            struct sortField_t *joinField;
            joinField=sortField_constructor((yyvsp[-4].number),(yyvsp[-2].number),0, (yyvsp[0].number));
			if (joinField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            join_addDefinitionJoin(current_filejoin, joinField);
            nTypeFormat = 1;
        }
<<<<<<< .mine
}
#line 2461 "parser.c"
    break;

  case 57: /* sortfield: "DIGIT" ',' "DIGIT" ',' fieldtype ',' fielddirection  */
#line 513 "parser.y"
                                                       {
||||||| .r1065
}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 513 "..\\..\\parser.y"
    {
=======
}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 516 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 109, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            /*  -->> nTypeFormat = 1; // Format external token  */
			}
<<<<<<< .mine
}
#line 2478 "parser.c"
    break;

  case 58: /* $@3: %empty  */
#line 528 "parser.y"
                      {
||||||| .r1065
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 528 "..\\..\\parser.y"
    {
=======
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 531 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_sortField=1;
<<<<<<< .mine
        }
#line 2486 "parser.c"
    break;

  case 59: /* sortclause: "SORT clause" "FIELDS instruction" '(' $@3 allsortfield ')'  */
#line 530 "parser.y"
                           {
||||||| .r1065
        }
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 530 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 533 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
<<<<<<< .mine
}
#line 2496 "parser.c"
    break;

  case 60: /* sortclause: "SORT clause" "FIELDS instruction" "COPY"  */
#line 535 "parser.y"
                       {
||||||| .r1065
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 535 "..\\..\\parser.y"
    {
=======
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 538 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

<<<<<<< .mine
}
#line 2507 "parser.c"
    break;

  case 61: /* $@4: %empty  */
#line 543 "parser.y"
                       {
||||||| .r1065
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 543 "..\\..\\parser.y"
    {
=======
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 546 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
<<<<<<< .mine
        }
#line 2516 "parser.c"
    break;

  case 62: /* mergeclause: "MERGE clause" "FIELDS instruction" '(' $@4 allsortfield ')'  */
#line 546 "parser.y"
                           {
||||||| .r1065
        }
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 546 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 549 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
<<<<<<< .mine
}
#line 2527 "parser.c"
    break;

  case 63: /* mergeclause: "MERGE clause" "FIELDS instruction" "COPY"  */
#line 552 "parser.y"
                        {
||||||| .r1065
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 552 "..\\..\\parser.y"
    {
=======
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 555 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
<<<<<<< .mine
}
#line 2537 "parser.c"
    break;

  case 64: /* $@5: %empty  */
#line 562 "parser.y"
                                                  {
||||||| .r1065
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 562 "..\\..\\parser.y"
    {
=======
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 565 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        job_SetTypeOP('J');		/* for Join */
        current_sortField=3;            /* Sort field / Join field for JOIN STATEMENT */
        if (globalJob->join == NULL) {
            struct join_t* pJoin = join_constructor();
            if (pJoin == NULL) {
                utl_abend_terminate(MEMORYALLOC, 509, ABEND_SKIP);
                YYABORT;
            }
            current_join = pJoin;
            join_SetReferenceJob(current_join);     /* Save reference join into job */
        }
        if (memcmp((yyvsp[-3].string),(char*) "F1",2)==0) {
            current_filejoin = 1;
        }
        if (memcmp((yyvsp[-3].string),(char*) "F2",2)==0) {
            current_filejoin = 2;
        }
<<<<<<< .mine
        }
#line 2561 "parser.c"
    break;

  case 65: /* joinkeysclause: "JOINKEYS clause" "FNAMES clause" '=' "JOINFILE" ',' "FIELDS instruction" '(' $@5 allsortfield ')'  */
#line 580 "parser.y"
                            {
||||||| .r1065
        }
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 580 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 583 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
<<<<<<< .mine
        free((yyvsp[-6].string));  /* Verify */
}
#line 2571 "parser.c"
    break;

  case 66: /* joinkeysalloptions: joinkeysoptions  */
#line 589 "parser.y"
                      {}
#line 2577 "parser.c"
    break;

  case 67: /* joinkeysalloptions: joinkeysoptions joinkeysalloptions  */
#line 590 "parser.y"
                                          {}
#line 2583 "parser.c"
    break;

  case 68: /* joinkeysoptions: ',' "SORTED"  */
#line 594 "parser.y"
                  {
||||||| .r1065
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 589 "..\\..\\parser.y"
    {}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 590 "..\\..\\parser.y"
    {}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 594 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 592 "..\\..\\parser.y"
    {}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 593 "..\\..\\parser.y"
    {}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 597 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
<<<<<<< .mine
}
#line 2592 "parser.c"
    break;

  case 69: /* joinkeysoptions: ',' "SORTED" ',' "NOSEQCK"  */
#line 598 "parser.y"
                             {
||||||| .r1065
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 598 "..\\..\\parser.y"
    {
=======
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 601 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
<<<<<<< .mine
}
#line 2601 "parser.c"
    break;

  case 70: /* joinkeysoptions: "STOPAFT clause" '=' "SIGNDIGITBIG"  */
#line 602 "parser.y"
                               {
||||||| .r1065
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 602 "..\\..\\parser.y"
    {
=======
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 605 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " join option stop after 1");
<<<<<<< .mine
        join_stopAfter(current_filejoin, current_join, (yyvsp[0].llnumber));
}
#line 2610 "parser.c"
    break;

  case 71: /* joinkeysoptions: "STOPAFT clause" '=' "DIGIT"  */
#line 606 "parser.y"
                        {
||||||| .r1065
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 606 "..\\..\\parser.y"
    {
=======
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 609 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " join option stop after 2");
<<<<<<< .mine
        join_stopAfter(current_filejoin, current_join, (yyvsp[0].number));
}
#line 2619 "parser.c"
    break;

  case 72: /* joinclause: "JOIN" "UNPAIRED"  */
#line 630 "parser.y"
                      {
||||||| .r1065
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 630 "..\\..\\parser.y"
    {
=======
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 633 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
<<<<<<< .mine
}
#line 2630 "parser.c"
    break;

  case 73: /* joinclause: "JOIN" "UNPAIRED" joinoptions  */
#line 636 "parser.y"
                                 {
||||||| .r1065
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 636 "..\\..\\parser.y"
    {
=======
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 639 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            join_setUnpaired(1, 'U');
            join_setUnpaired(2, 'U');
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
<<<<<<< .mine
}
#line 2647 "parser.c"
    break;

  case 74: /* joinclause: "JOIN" "UNPAIRED" ',' "JOINFILE" joinoptions  */
#line 649 "parser.y"
                                              {
||||||| .r1065
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 649 "..\\..\\parser.y"
    {
=======
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 652 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            if (memcmp((yyvsp[-1].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'U');
                join_setUnpaired(2, 'I');
            }
            if (memcmp((yyvsp[-1].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'I');
                join_setUnpaired(2, 'U');
            }
        }
        if (nOnly  == 1) {
            if (memcmp((yyvsp[-1].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'O');
                join_setUnpaired(2, 'S');
            }
            if (memcmp((yyvsp[-1].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'S');
                join_setUnpaired(2, 'O');
            }
        }
        nOnly=0;
<<<<<<< .mine
        free((yyvsp[-1].string)); 
}
#line 2677 "parser.c"
    break;

  case 75: /* joinclause: "JOIN" "UNPAIRED" ',' "JOINFILE" ',' "JOINFILE" joinoptions  */
#line 675 "parser.y"
                                                           {          
||||||| .r1065
        free((yyvsp[(4) - (5)].string)); 
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 675 "..\\..\\parser.y"
    {          
=======
        free((yyvsp[(4) - (5)].string)); 
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 678 "..\\..\\parser.y"
    {          
>>>>>>> .r1070
        current_sortField=0;                                          
        strcpy(szMexToken, " sort clause ");                          
        if (nOnly  == 0) {                                            
            join_setUnpaired(1, 'U');                             
            join_setUnpaired(2, 'U');                             
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
<<<<<<< .mine
        free((yyvsp[-3].string)); 
        free((yyvsp[-1].string)); 
}
#line 2697 "parser.c"
    break;

  case 77: /* joinoptions: ',' "ONLY"  */
#line 693 "parser.y"
                  {
||||||| .r1065
        free((yyvsp[(4) - (7)].string)); 
        free((yyvsp[(6) - (7)].string)); 
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 693 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(4) - (7)].string)); 
        free((yyvsp[(6) - (7)].string)); 
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 696 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
<<<<<<< .mine
}
#line 2707 "parser.c"
    break;

  case 78: /* $@6: %empty  */
#line 713 "parser.y"
                             {
||||||| .r1065
}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 713 "..\\..\\parser.y"
    {
=======
}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 716 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 2718 "parser.c"
    break;

  case 79: /* joinreformatclause: "JOINREFORMAT" "FIELDS instruction" '(' $@6 allinoutrec ')' fill_char  */
#line 718 "parser.y"
                            {
||||||| .r1065
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 718 "..\\..\\parser.y"
    {
=======
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 721 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 2727 "parser.c"
    break;

  case 81: /* fill_char: "FILL" "CHARTYPE" "STRING"  */
#line 725 "parser.y"
                              {
||||||| .r1065
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 725 "..\\..\\parser.y"
    {
=======
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 728 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
        strcpy(szMexToken, " join fill clause ");
        /* fill character * */
<<<<<<< .mine
        join_fillbuff(current_filejoin, current_join, (yyvsp[-1].string), (yyvsp[0].string));
        free((yyvsp[-1].string));
        free((yyvsp[0].string));
}
#line 2741 "parser.c"
    break;

  case 82: /* formatclause: "FORMAT clause" '=' fieldtype  */
#line 741 "parser.y"
                           {
||||||| .r1065
        join_fillbuff(current_filejoin, current_join, (yyvsp[(2) - (3)].string), (yyvsp[(3) - (3)].string));
        free((yyvsp[(2) - (3)].string));
        free((yyvsp[(3) - (3)].string));
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 741 "..\\..\\parser.y"
    {
=======
        join_fillbuff(current_filejoin, current_join, (yyvsp[(2) - (3)].string), (yyvsp[(3) - (3)].string));
        free((yyvsp[(2) - (3)].string));
        free((yyvsp[(3) - (3)].string));
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 744 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " format clause ");
        nFieldType = (yyvsp[0].number);    /* save field type */
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[0].number));
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[0].number));
		if (nTypeFormat == 3)	/* for SumFields    */
<<<<<<< .mine
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[0].number));
    }
#line 2756 "parser.c"
    break;

  case 83: /* formatclause: "FORMAT clause" '=' "OPCOND"  */
#line 752 "parser.y"
                         {
||||||| .r1065
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
    }
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 752 "..\\..\\parser.y"
    {
=======
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
    }
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 755 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " format clause substring ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 3)	
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
<<<<<<< .mine
    }
#line 2770 "parser.c"
    break;

  case 84: /* allcondfield: condfieldcond  */
#line 777 "parser.y"
                  {
		(yyval.condField)=(yyvsp[0].condField);
}
#line 2778 "parser.c"
    break;

  case 85: /* allcondfield: '(' allcondfield ')'  */
#line 780 "parser.y"
                               {
		(yyval.condField)=(yyvsp[-1].condField);
||||||| .r1065
    }
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 777 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 780 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
=======
    }
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 780 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 783 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
>>>>>>> .r1070
		strcpy(szMexToken, " condition field 01 ");
<<<<<<< .mine
}
#line 2787 "parser.c"
    break;

  case 86: /* allcondfield: allcondfield "AND clause" allcondfield  */
#line 784 "parser.y"
                                    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[-2].condField), (yyvsp[0].condField));
||||||| .r1065
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 784 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
=======
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 787 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
>>>>>>> .r1070
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 02 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 110, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2801 "parser.c"
    break;

  case 87: /* allcondfield: allcondfield "OR clause" allcondfield  */
#line 793 "parser.y"
                                   {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[-2].condField), (yyvsp[0].condField));
||||||| .r1065
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 793 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
=======
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 796 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
>>>>>>> .r1070
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 03 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 111, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2815 "parser.c"
    break;

  case 88: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' fieldtype ',' condition ',' "DIGIT" ',' "DIGIT" ',' fieldtype  */
#line 811 "parser.y"
                                                                                    {
||||||| .r1065
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 811 "..\\..\\parser.y"
    {
=======
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 814 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[-12].number),(yyvsp[-10].number),(yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number));
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 04 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2830 "parser.c"
    break;

  case 89: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' condition ',' "DIGIT" ',' "DIGIT"  */
#line 827 "parser.y"
                                                          {
||||||| .r1065
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 827 "..\\..\\parser.y"
    {
=======
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 830 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[-8].number),(yyvsp[-6].number),0,(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number),0);
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 05 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2845 "parser.c"
    break;

  case 90: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' fieldtype ',' condition ',' fieldvaluecond  */
#line 841 "parser.y"
                                                                      {    
		(yyval.condField)=condField_constructor_condition((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].fieldValue));
||||||| .r1065
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 841 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
=======
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 844 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
>>>>>>> .r1070
		strcpy(szMexToken, " condition field 06 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
<<<<<<< .mine
}
#line 2858 "parser.c"
    break;

  case 91: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' fieldtype ',' condition ',' fieldvalueconst  */
#line 853 "parser.y"
                                                                      {
        (yyval.condField)=condField_constructor_condition((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].fieldValue));
||||||| .r1065
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 853 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
=======
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 856 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
>>>>>>> .r1070
        strcpy(szMexToken, " condition field 07 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2871 "parser.c"
    break;

  case 92: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' condition ',' fieldvalueconst  */
#line 865 "parser.y"
                                                         {    
||||||| .r1065
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 865 "..\\..\\parser.y"
    {    
=======
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 868 "..\\..\\parser.y"
    {    
>>>>>>> .r1070
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[-6].number),(yyvsp[-4].number),nFieldType,(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 08 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2887 "parser.c"
    break;

  case 93: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' condition ',' fieldvaluecond  */
#line 880 "parser.y"
                                                        {    
||||||| .r1065
}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 880 "..\\..\\parser.y"
    {    
=======
}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 883 "..\\..\\parser.y"
    {    
>>>>>>> .r1070
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[-6].number),(yyvsp[-4].number),nFieldType,(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue)); 
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 09 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2903 "parser.c"
    break;

  case 94: /* condfieldcond: "DIGIT" ',' "DIGIT" ',' fieldtype ',' condition ',' datetype  */
#line 895 "parser.y"
                                                                {    
        condField=condField_constructor_condition4Date((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue));
||||||| .r1065
}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 895 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition4Date((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].fieldValue));
=======
}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 898 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition4Date((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].fieldValue));
>>>>>>> .r1070
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 10 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 141, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2918 "parser.c"
    break;

  case 95: /* datetype: "DATE1"  */
#line 913 "parser.y"
              { 
||||||| .r1065
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 913 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 916 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        memset(szBuf, 0x00, 30);
        /* current date into string */
        sprintf(szBuf, "%d", nDateCheck);   
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2938 "parser.c"
    break;

  case 96: /* datetype: "DATE1" "DIGIT"  */
#line 930 "parser.y"
                    { 
||||||| .r1065
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 930 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 933 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* check range */
        if ((yyvsp[0].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[0].number));
        nDateCheck = nDateNew;

        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2966 "parser.c"
    break;

  case 97: /* datetype: "DATE2"  */
#line 954 "parser.y"
              {             /* Problem ++ to define datetype */
||||||| .r1065
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 954 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
=======
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 957 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
>>>>>>> .r1070
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 2985 "parser.c"
    break;

  case 98: /* datetype: "DATE2" "DIGIT"  */
#line 970 "parser.y"
                   {             /* Problem ++ to define datetype */
||||||| .r1065
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 970 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
=======
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 973 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
>>>>>>> .r1070
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        /* check range */
        if ((yyvsp[0].number) > 12) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub months to date */
        /* from YYYYMM  to YYYYMMDD */
        nDateCheck = nDateCheck * 100 + 1 ;
        /* add Month to date*/
        gcDateAddMonths(nDateCheck, &nDateNew, (yyvsp[0].number));
        /* from YYYYMMDD  to YYYYMM */
        nDateCheck = (nDateNew / 100);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 3016 "parser.c"
    break;

  case 99: /* datetype: "DATE3"  */
#line 997 "parser.y"
              { 
||||||| .r1065
}
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 997 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 1000 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        gcDate2Ord(nDateCheck, &nDateNew);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateNew);   /* current date into string with format yyyyddd */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 3037 "parser.c"
    break;

  case 100: /* datetype: "DATE3" "DIGIT"  */
#line 1015 "parser.y"
                   { 
||||||| .r1065
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1015 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1018 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        /* check range */
        if ((yyvsp[0].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[0].number));
        gcDate2Ord(nDateNew, &nDateCheck);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string with format yyyyddd */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 3065 "parser.c"
    break;

  case 101: /* datetype: "DATE4"  */
#line 1039 "parser.y"
              { 
||||||| .r1065
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1039 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1042 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		nDateType = 4;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Datetime */
        memset(szBuf, 0x00, 30);
        /* Problem with timestamp force to Y2T8 8 bytes  CCYYMMAA without time */
        /* TODO timestamp */
        /* sprintf(szBuf, "%0.4d-%0.2d-%0.2d-%0.2d.%0.2d.%0.2d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);  */ /* current datetime into string */
        /* prepare date like CCYYMMDD */
        sprintf(szBuf, "%04d%02d%02d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday);  
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 145, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
}
#line 3087 "parser.c"
    break;

  case 102: /* omitclause: "OMIT clause" "COND clause" allcondfield  */
#line 1059 "parser.y"
                              {
||||||| .r1065
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1059 "..\\..\\parser.y"
    {
=======
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1062 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addOmit((yyvsp[0].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
<<<<<<< .mine
}
#line 3100 "parser.c"
    break;

  case 103: /* omitclause: "OMIT clause" "COND clause" '=' allcondfield  */
#line 1068 "parser.y"
                                  {
||||||| .r1065
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1068 "..\\..\\parser.y"
    {
=======
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1071 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addOmit((yyvsp[0].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
<<<<<<< .mine
}
#line 3113 "parser.c"
    break;

  case 104: /* includeclause: "INCLUDE clause" "COND clause" allcondfield  */
#line 1080 "parser.y"
                                 {
||||||| .r1065
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1080 "..\\..\\parser.y"
    {
=======
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1083 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
<<<<<<< .mine
}
#line 3126 "parser.c"
    break;

  case 105: /* includeclause: "INCLUDE clause" "COND clause" '=' allcondfield  */
#line 1089 "parser.y"
                                     {
||||||| .r1065
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1089 "..\\..\\parser.y"
    {
=======
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1092 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
<<<<<<< .mine
}
#line 3139 "parser.c"
    break;

  case 106: /* includeclause: "INCLUDE clause" formatclause ',' "COND clause" allcondfield  */
#line 1113 "parser.y"
                                                  {
        condField_addInclude((yyvsp[0].condField));
||||||| .r1065
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1113 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
=======
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1116 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
>>>>>>> .r1070
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
<<<<<<< .mine
}
#line 3149 "parser.c"
    break;

  case 107: /* includeclause: "INCLUDE clause" formatclause ',' "COND clause" '=' allcondfield  */
#line 1119 "parser.y"
                                                      {
        condField_addInclude((yyvsp[0].condField));
||||||| .r1065
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1119 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
=======
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1122 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
>>>>>>> .r1070
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
<<<<<<< .mine
}
#line 3159 "parser.c"
    break;

  case 108: /* allinoutrec: inoutrec  */
#line 1131 "parser.y"
             {	
}
#line 3166 "parser.c"
    break;

  case 109: /* allinoutrec: allinoutrec ',' allinoutrec  */
#line 1133 "parser.y"
                                              {	}
#line 3172 "parser.c"
    break;

  case 110: /* inoutrec: "DIGIT" ',' "DIGIT"  */
#line 1141 "parser.y"
                      {
||||||| .r1065
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1131 "..\\..\\parser.y"
    {	
}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 1133 "..\\..\\parser.y"
    {	}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 1141 "..\\..\\parser.y"
    {
=======
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1134 "..\\..\\parser.y"
    {	
}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 1136 "..\\..\\parser.y"
    {	}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 1144 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 117, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            else
            {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 118, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                    /* struct inrec_t * */
                    inrec=inrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                    if (inrec == NULL) {
                        utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                        YYABORT;
                    }
                    nPosAbsRec += inrec->range.length;
                    inrec->nIsOverlay=inrec_overlay;
                    inrec_addDefinition(inrec);
                    /* save pointer CHANGE option */
                    pntChange = 1; 
            }
            break;
        case JOIN_CASE :
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[-2].number),(yyvsp[0].number));
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            break;
        default:
            break;
        }
<<<<<<< .mine
}
#line 3248 "parser.c"
    break;

  case 111: /* inoutrec: '?'  */
#line 1213 "parser.y"
           {
||||||| .r1065
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1213 "..\\..\\parser.y"
    {
=======
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1216 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nRecCase == 3)
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, -99,1);       /* Fix value */
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
<<<<<<< .mine
}
#line 3268 "parser.c"
    break;

  case 112: /* inoutrec: "JOINFILE" ':' "DIGIT" ',' "DIGIT"  */
#line 1228 "parser.y"
                                   {
||||||| .r1065
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1228 "..\\..\\parser.y"
    {
=======
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1231 "..\\..\\parser.y"
    {
>>>>>>> .r1070
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            if (memcmp((yyvsp[-4].string),(char*) "F1",2)==0) {
                current_filejoin = 1;
            }
            if (memcmp((yyvsp[-4].string),(char*) "F2",2)==0) {
                current_filejoin = 2;
            }
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[-2].number),(yyvsp[0].number));
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }

            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
<<<<<<< .mine
            free((yyvsp[-4].string));
}
#line 3295 "parser.c"
    break;

  case 113: /* inoutrec: "DIGIT" ':' "CHARTYPE" "STRING"  */
#line 1254 "parser.y"
                                {
||||||| .r1065
            free((yyvsp[(1) - (5)].string));
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 1254 "..\\..\\parser.y"
    {
=======
            free((yyvsp[(1) - (5)].string));
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 1257 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_possubstnchar((yyvsp[-3].number), (yyvsp[-1].string), (yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_possubstnchar((yyvsp[-3].number), (yyvsp[-1].string), (yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
<<<<<<< .mine
        free((yyvsp[-1].string)); /* s.m. 202015    */
		free((yyvsp[0].string)); 
}
#line 3340 "parser.c"
    break;

  case 114: /* inoutrec: "DIGIT" ':' "DIGIT" ',' "DIGIT"  */
#line 1299 "parser.y"
                                {
||||||| .r1065
        free((yyvsp[(3) - (4)].string)); /* s.m. 202015    */
		free((yyvsp[(4) - (4)].string)); 
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1299 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(3) - (4)].string)); /* s.m. 202015    */
		free((yyvsp[(4) - (4)].string)); 
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1302 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range_position((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 120, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range_position((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
       }
<<<<<<< .mine
}
#line 3381 "parser.c"
    break;

  case 115: /* inoutrec: "OCCURFILL"  */
#line 1341 "parser.y"
                {
||||||| .r1065
}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1341 "..\\..\\parser.y"
    {
=======
}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1344 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_subst((yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 122, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_subst((yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
<<<<<<< .mine
		free((yyvsp[0].string));
}
#line 3425 "parser.c"
    break;

  case 116: /* inoutrec: "OCCURFILL" "STRING"  */
#line 1385 "parser.y"
                       {
||||||| .r1065
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 1385 "..\\..\\parser.y"
    {
=======
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 1388 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_substnchar((yyvsp[-1].string),(yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_substnchar((yyvsp[-1].string),(yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
<<<<<<< .mine
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 3470 "parser.c"
    break;

  case 117: /* inoutrec: "DIGIT" ':' "CHARTYPE"  */
#line 1429 "parser.y"
                         {
||||||| .r1065
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 117:
/* Line 1792 of yacc.c  */
#line 1429 "..\\..\\parser.y"
    {
=======
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 117:
/* Line 1792 of yacc.c  */
#line 1432 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_padding((yyvsp[-2].number), (yyvsp[0].string), nPosAbsRec);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 126, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[-2].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[-2].number);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_padding((yyvsp[-2].number), (yyvsp[0].string), nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[-2].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[-2].number);		/* - inrec->change_position.fieldValue->generated_length;   */
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
           break;
        default:
            break;
        }
<<<<<<< .mine
        free((yyvsp[0].string)); 
}
#line 3516 "parser.c"
    break;

  case 118: /* inoutrec: "CHARTYPE"  */
#line 1474 "parser.y"
               {
||||||| .r1065
        free((yyvsp[(3) - (3)].string)); 
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 1474 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(3) - (3)].string)); 
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 1477 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
       /*         struct outrec_t *outrec=outrec_constructor_subst($1); */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[0].string));
                /* struct outrec_t * */
                outrec=outrec_constructor_subst(szType01);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 128, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
        /*                inrec=inrec_constructor_subst($1);    */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[0].string));
                inrec=inrec_constructor_subst(szType01);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 129, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
<<<<<<< .mine
        free((yyvsp[0].string)); /* s.m. 202105    */
}
#line 3570 "parser.c"
    break;

  case 119: /* inoutrec: fieldvaluerec  */
#line 1528 "parser.y"
                    {
||||||| .r1065
        free((yyvsp[(1) - (1)].string)); /* s.m. 202105    */
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 1528 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(1) - (1)].string)); /* s.m. 202105    */
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 1531 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * outrec; */
                outrec=outrec_constructor_change((yyvsp[0].fieldValue));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 130, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_change((yyvsp[0].fieldValue));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 131, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
<<<<<<< .mine
	}
#line 3613 "parser.c"
    break;

  case 120: /* inoutrec: "DIGIT" ','  */
#line 1568 "parser.y"
                {
||||||| .r1065
	}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 1568 "..\\..\\parser.y"
    {
=======
	}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 1571 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-1].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_range((yyvsp[-1].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range((yyvsp[-1].number),-1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 134, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
<<<<<<< .mine
}
#line 3670 "parser.c"
    break;

  case 121: /* inoutrec: "CHANGE" '(' "DIGIT" ',' changepair ')' ',' "NOMATCH" '(' changeCmdOpt ')'  */
#line 1624 "parser.y"
                                                                            { 
||||||| .r1065
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 1624 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 1627 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        /* define struct for change field */
        
        struct change_t* chg = change_constructor((yyvsp[-8].number));
        change_setNoMatch(chg, (yyvsp[-1].fieldValue));  
        change_setpairs(chg, (yyvsp[-6].changefield));
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
<<<<<<< .mine
         nPosAbsRec += (yyvsp[-8].number);       /* len output change */
}
#line 3694 "parser.c"
    break;

  case 122: /* inoutrec: "CHANGE" '(' "DIGIT" ',' changepair ')' ',' "NOMATCH" '(' "DIGIT" ',' "DIGIT" ')'  */
#line 1644 "parser.y"
                                                                               { 
||||||| .r1065
         nPosAbsRec += (yyvsp[(3) - (11)].number);       /* len output change */
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 1644 "..\\..\\parser.y"
    { 
=======
         nPosAbsRec += (yyvsp[(3) - (11)].number);       /* len output change */
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 1647 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        /* define struct for change field */       
        struct change_t* chg = change_constructor((yyvsp[-10].number));
        change_setNoMatchPosLen(chg, (yyvsp[-3].number), (yyvsp[-1].number));  
        change_setpairs(chg, (yyvsp[-8].changefield));
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
<<<<<<< .mine
         nPosAbsRec += (yyvsp[-10].number);       /* len output change */
}
#line 3717 "parser.c"
    break;

  case 123: /* inoutrec: "IN" '=' fieldvaluerec ',' "OUT" '=' fieldvaluerec findrep_options_all  */
#line 1664 "parser.y"
                                                                              {
||||||| .r1065
         nPosAbsRec += (yyvsp[(3) - (13)].number);       /* len output change */
}
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 1664 "..\\..\\parser.y"
    {
=======
         nPosAbsRec += (yyvsp[(3) - (13)].number);       /* len output change */
}
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 1667 "..\\..\\parser.y"
    {
>>>>>>> .r1070
          switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }                
                else
                    findrep_setType(findrep, FINDREP_TYPE_INOUT);
                findrep_field = findrepfield_constructor((yyvsp[-5].fieldValue), (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  inrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }                
                else
                    findrep_setType(findrep, FINDREP_TYPE_INOUT);
                findrep_field = findrepfield_constructor((yyvsp[-5].fieldValue), (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct inrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
<<<<<<< .mine
}
#line 3813 "parser.c"
    break;

  case 124: /* inoutrec: "IN" '=' '(' allfieldvaluerec ')' ',' "OUT" '=' fieldvaluerec findrep_options_all  */
#line 1755 "parser.y"
                                                                                         {
||||||| .r1065
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1755 "..\\..\\parser.y"
    {
=======
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1758 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                findrepfield_setOutForAll(findrep_field, (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  outrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                findrepfield_setOutForAll(findrep_field, (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
<<<<<<< .mine
    }
#line 3909 "parser.c"
    break;

  case 125: /* inoutrec: "INOUT" '=' '(' inoutfieldvaluerec ')' findrep_options_all  */
#line 1846 "parser.y"
                                                                {
||||||| .r1065
    }
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 1846 "..\\..\\parser.y"
    {
=======
    }
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 1849 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                /* //-->>findrepfield_setOutForAll(findrep_field, $9); */
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  outrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                /* //-->>findrepfield_setOutForAll(findrep_field, $9); */
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
<<<<<<< .mine
    }
#line 4005 "parser.c"
    break;

  case 126: /* findrep_options_all: findrep_options  */
#line 1939 "parser.y"
                      { 
||||||| .r1065
    }
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1939 "..\\..\\parser.y"
    { 
=======
    }
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1942 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        strcpy(szMexToken, " findrep_options instruction ");
<<<<<<< .mine
}
#line 4013 "parser.c"
    break;

  case 127: /* findrep_options_all: findrep_options ',' findrep_options_all  */
#line 1942 "parser.y"
                                              {}
#line 4019 "parser.c"
    break;

  case 129: /* findrep_options: "STARTPOS" '=' "DIGIT"  */
#line 1946 "parser.y"
                         {
||||||| .r1065
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 1942 "..\\..\\parser.y"
    {}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1946 "..\\..\\parser.y"
    {
=======
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 1945 "..\\..\\parser.y"
    {}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1949 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP STARTPOS ");
            findrep_setStartPos(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP STARTPOS ");
            findrep_setStartPos(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
<<<<<<< .mine
    }
#line 4045 "parser.c"
    break;

  case 130: /* findrep_options: "ENDPOS" '=' "DIGIT"  */
#line 1967 "parser.y"
                       {
||||||| .r1065
    }
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1967 "..\\..\\parser.y"
    {
=======
    }
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1970 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
              switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ENDPOS ");
            findrep_setEndPos(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ENDPOS ");
            findrep_setEndPos(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
<<<<<<< .mine
    }
#line 4071 "parser.c"
    break;

  case 131: /* findrep_options: "DO" '=' "DIGIT"  */
#line 1988 "parser.y"
                   {
||||||| .r1065
    }
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1988 "..\\..\\parser.y"
    {
=======
    }
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1991 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
              switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP DO ");
            findrep_setDo(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP DO ");
            findrep_setDo(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
<<<<<<< .mine
    }
#line 4097 "parser.c"
    break;

  case 132: /* findrep_options: "MAXLEN" '=' "DIGIT"  */
#line 2009 "parser.y"
                       {
||||||| .r1065
    }
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 2009 "..\\..\\parser.y"
    {
=======
    }
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 2012 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP MAXLEN ");
            findrep_setMaxLen(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP MAXLEN ");
            findrep_setMaxLen(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
<<<<<<< .mine
    }
#line 4123 "parser.c"
    break;

  case 133: /* findrep_options: "OVERRUN" '=' "ERRTRUNC clause"  */
#line 2031 "parser.y"
                           {
||||||| .r1065
    }
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 2031 "..\\..\\parser.y"
    {
=======
    }
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 2034 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[0].string), "TRUNC") == 0)
            nTmp = 2;
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP OVERRUN ");
            findrep_setOverRun(findrep, nTmp);
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP OVERRUN ");
            findrep_setOverRun(findrep, nTmp);
            break;
        default:
            break;
        }
<<<<<<< .mine
        free((yyvsp[0].string));
    }
#line 4153 "parser.c"
    break;

  case 134: /* findrep_options: "SHIFT" '=' "YESNO clause"  */
#line 2056 "parser.y"
                      {
||||||| .r1065
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 2056 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 2059 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[0].string), "NO") == 0)
            nTmp = 2;    
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP SHIFT ");
            findrep_setShift(findrep, nTmp);
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP SHIFT ");
            findrep_setShift(findrep, nTmp);
            break;
        default:
            break;
        }
<<<<<<< .mine
        free((yyvsp[0].string));
    }
#line 4183 "parser.c"
    break;

  case 135: /* allfieldvaluerec: fieldvaluerec  */
#line 2083 "parser.y"
                  { 
||||||| .r1065
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 2083 "..\\..\\parser.y"
    { 
=======
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 2086 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        strcpy(szMexToken, " allfieldvaluerec instruction ");
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
        }
        else
        {
            findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
            findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
        }
<<<<<<< .mine
}
#line 4199 "parser.c"
    break;

  case 136: /* allfieldvaluerec: fieldvaluerec ',' allfieldvaluerec  */
#line 2095 "parser.y"
||||||| .r1065
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 2095 "..\\..\\parser.y"
=======
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 2098 "..\\..\\parser.y"
>>>>>>> .r1070
    {
        strcpy(szMexToken, " allfieldvaluerec instruction 2");
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
        }
        else
         {
            findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
            findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
         }
<<<<<<< .mine
    }
#line 4215 "parser.c"
    break;

  case 137: /* inoutfieldvaluerec: fieldvaluerec  */
#line 2110 "parser.y"
                  { 
||||||| .r1065
    }
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 2110 "..\\..\\parser.y"
    { 
=======
    }
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 2113 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        strcpy(szMexToken, " inoutfieldvaluerec instruction ");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[0].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[0].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[0].fieldValue), (struct fieldValue_t*) field_tmp);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
                nSwitchFR = 0;
            }
        }
<<<<<<< .mine
}
#line 4240 "parser.c"
    break;

  case 138: /* inoutfieldvaluerec: fieldvaluerec ',' inoutfieldvaluerec  */
#line 2131 "parser.y"
||||||| .r1065
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 2131 "..\\..\\parser.y"
=======
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 2134 "..\\..\\parser.y"
>>>>>>> .r1070
    {
        strcpy(szMexToken, " inoutfieldvaluerec instruction 2");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[-2].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[-2].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[-2].fieldValue), (struct fieldValue_t*) field_tmp);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
                nSwitchFR = 0;
            }
        }        
        /*
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)NULL, (struct fieldValue_t*) $1);
            nSwitchFR = 1;
        }
        else
        {
            if (nSwitchFR == 2) {
                findrep_fields_setin(findrep_field_tmp, $1);
            }
            if (nSwitchFR == 1) {
                findrep_fields_setin(findrep_field, $1);
                nSwitchFR = 2;
            }
            else {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)NULL, (struct fieldValue_t*) $1);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
            }
        }
        */
<<<<<<< .mine
    }
#line 4285 "parser.c"
    break;

  case 139: /* changepair: changepairdet  */
#line 2174 "parser.y"
                    { 
||||||| .r1065
    }
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 2174 "..\\..\\parser.y"
    { 
=======
    }
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 2177 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        strcpy(szMexToken, " changepairdet instruction ");
<<<<<<< .mine
        (yyval.changefield)=(yyvsp[0].changefield);
}
#line 4294 "parser.c"
    break;

  case 140: /* changepair: changepairdet ',' changepair  */
#line 2178 "parser.y"
                                   {}
#line 4300 "parser.c"
    break;

  case 141: /* changepairdet: "CHARTYPE" "STRING" ',' "CHARTYPE" "STRING"  */
#line 2186 "parser.y"
                                            { 
||||||| .r1065
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 2178 "..\\..\\parser.y"
    {}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 2186 "..\\..\\parser.y"
    { 
=======
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 2181 "..\\..\\parser.y"
    {}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 2189 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
		/* $$=changefield_constructor((char*) $2, $5); */
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[-4].string), (yyvsp[-3].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct fieldValue_t* fv2 = fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if (fv2 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        
        struct changefield_t* pcf = changefield_constructor(fv1, fv2);
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free((yyvsp[-4].string)); 
		free((yyvsp[-3].string)); 
        free((yyvsp[-1].string));
		free((yyvsp[0].string)); 
        (yyval.changefield)=pcf;
<<<<<<< .mine
}
#line 4335 "parser.c"
    break;

  case 142: /* changepairdet: "CHARTYPE" "STRING" ',' "DIGIT" ',' "DIGIT"  */
#line 2217 "parser.y"
                                             { 
||||||| .r1065
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 2217 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 2220 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[-5].string), (yyvsp[-4].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct changefield_t* pcf = changefield_constructorPosLen(fv1, (yyvsp[-2].number), (yyvsp[0].number));
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free((yyvsp[-5].string)); 
		free((yyvsp[-4].string)); 
        (yyval.changefield)=pcf;
<<<<<<< .mine
}
#line 4361 "parser.c"
    break;

  case 143: /* changeCmdOpt: "CHARTYPE" "STRING"  */
#line 2245 "parser.y"
                     { 
||||||| .r1065
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 2245 "..\\..\\parser.y"
    { 
=======
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 2248 "..\\..\\parser.y"
    { 
>>>>>>> .r1070
        /* $$=changefield_constructor((char*) $2, $5); */
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
<<<<<<< .mine
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string));         
}
#line 4376 "parser.c"
    break;

  case 144: /* $@7: %empty  */
#line 2260 "parser.y"
                            {
||||||| .r1065
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string));         
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 2260 "..\\..\\parser.y"
    {
=======
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string));         
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 2263 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4387 "parser.c"
    break;

  case 145: /* outrecclause: "OUTREC clause" "FIELDS instruction" '=' '(' $@7 allinoutrec ')'  */
#line 2265 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2265 "..\\..\\parser.y"
    {
=======
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2268 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4396 "parser.c"
    break;

  case 146: /* $@8: %empty  */
#line 2271 "parser.y"
                        {
||||||| .r1065
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2271 "..\\..\\parser.y"
    {
=======
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2274 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4407 "parser.c"
    break;

  case 147: /* outrecclause: "OUTREC clause" "FIELDS instruction" '(' $@8 allinoutrec ')'  */
#line 2276 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 2276 "..\\..\\parser.y"
    {
=======
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 2279 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4416 "parser.c"
    break;

  case 148: /* $@9: %empty  */
#line 2281 "parser.y"
                           {
||||||| .r1065
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 2281 "..\\..\\parser.y"
    {
=======
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 2284 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4427 "parser.c"
    break;

  case 149: /* outrecclause: "OUTREC clause" "BUILD instruction" '=' '(' $@9 allinoutrec ')'  */
#line 2286 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 2286 "..\\..\\parser.y"
    {
=======
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 2289 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4437 "parser.c"
    break;

  case 150: /* $@10: %empty  */
#line 2292 "parser.y"
                       {
||||||| .r1065
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2292 "..\\..\\parser.y"
    {
=======
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2295 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4448 "parser.c"
    break;

  case 151: /* outrecclause: "OUTREC clause" "BUILD instruction" '(' $@10 allinoutrec ')'  */
#line 2297 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2297 "..\\..\\parser.y"
    {
=======
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2300 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4457 "parser.c"
    break;

  case 152: /* $@11: %empty  */
#line 2302 "parser.y"
                             {
||||||| .r1065
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2302 "..\\..\\parser.y"
    {
=======
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2305 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4468 "parser.c"
    break;

  case 153: /* outrecclause: "OUTREC clause" "OVERLAY instruction" '=' '(' $@11 allinoutrec ')'  */
#line 2307 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2307 "..\\..\\parser.y"
    {
=======
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2310 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
<<<<<<< .mine
}
#line 4479 "parser.c"
    break;

  case 154: /* $@12: %empty  */
#line 2314 "parser.y"
                         {
||||||| .r1065
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2314 "..\\..\\parser.y"
    {
=======
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2317 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
        }
#line 4490 "parser.c"
    break;

  case 155: /* outrecclause: "OUTREC clause" "OVERLAY instruction" '(' $@12 allinoutrec ')'  */
#line 2319 "parser.y"
                          {
||||||| .r1065
        }
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2319 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2322 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
<<<<<<< .mine
}
#line 4501 "parser.c"
    break;

  case 156: /* $@13: %empty  */
#line 2325 "parser.y"
                         {
||||||| .r1065
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2325 "..\\..\\parser.y"
    {
=======
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2328 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4512 "parser.c"
    break;

  case 157: /* outrecclause: "OUTREC clause" "FINDREP" '=' $@13 allinoutrec  */
#line 2330 "parser.y"
               {
||||||| .r1065
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2330 "..\\..\\parser.y"
    {
=======
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2333 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4522 "parser.c"
    break;

  case 158: /* $@14: %empty  */
#line 2335 "parser.y"
                             {
||||||| .r1065
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2335 "..\\..\\parser.y"
    {
=======
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2338 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4533 "parser.c"
    break;

  case 159: /* outrecclause: "OUTREC clause" "FINDREP" '=' '(' $@14 allinoutrec ')'  */
#line 2340 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2340 "..\\..\\parser.y"
    {
=======
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2343 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4543 "parser.c"
    break;

  case 160: /* $@15: %empty  */
#line 2346 "parser.y"
                      {
||||||| .r1065
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2346 "..\\..\\parser.y"
    {
=======
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2349 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4554 "parser.c"
    break;

  case 161: /* outrecclause: "OUTREC clause" "FINDREP" $@15 allinoutrec  */
#line 2351 "parser.y"
               {
||||||| .r1065
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2351 "..\\..\\parser.y"
    {
=======
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2354 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4563 "parser.c"
    break;

  case 162: /* $@16: %empty  */
#line 2361 "parser.y"
                     {
||||||| .r1065
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2361 "..\\..\\parser.y"
    {
=======
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2364 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4574 "parser.c"
    break;

  case 163: /* outrecclause: "OUTREC clause" '=' '(' $@16 allinoutrec ')'  */
#line 2366 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2366 "..\\..\\parser.y"
    {
=======
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2369 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4583 "parser.c"
    break;

  case 164: /* $@17: %empty  */
#line 2371 "parser.y"
               {
||||||| .r1065
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2371 "..\\..\\parser.y"
    {
=======
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2374 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
<<<<<<< .mine
}
#line 4594 "parser.c"
    break;

  case 165: /* outrecclause: "OUTREC clause" '(' $@17 allinoutrec ')'  */
#line 2376 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2376 "..\\..\\parser.y"
    {
=======
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2379 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_outrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4603 "parser.c"
    break;

  case 166: /* $@18: %empty  */
#line 2385 "parser.y"
                           {
||||||| .r1065
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2385 "..\\..\\parser.y"
    {
=======
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2388 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4614 "parser.c"
    break;

  case 167: /* inrecclause: "INREC clause" "FIELDS instruction" '=' '(' $@18 allinoutrec ')'  */
#line 2390 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2390 "..\\..\\parser.y"
    {
=======
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2393 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4623 "parser.c"
    break;

  case 168: /* $@19: %empty  */
#line 2395 "parser.y"
                       {
||||||| .r1065
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2395 "..\\..\\parser.y"
    {
=======
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2398 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
        }
#line 4634 "parser.c"
    break;

  case 169: /* inrecclause: "INREC clause" "FIELDS instruction" '(' $@19 allinoutrec ')'  */
#line 2400 "parser.y"
                          {
||||||| .r1065
        }
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2400 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2403 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4643 "parser.c"
    break;

  case 170: /* $@20: %empty  */
#line 2405 "parser.y"
                          {
||||||| .r1065
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2405 "..\\..\\parser.y"
    {
=======
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2408 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4654 "parser.c"
    break;

  case 171: /* inrecclause: "INREC clause" "BUILD instruction" '=' '(' $@20 allinoutrec ')'  */
#line 2410 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2410 "..\\..\\parser.y"
    {
=======
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2413 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4663 "parser.c"
    break;

  case 172: /* $@21: %empty  */
#line 2415 "parser.y"
                      {
||||||| .r1065
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2415 "..\\..\\parser.y"
    {
=======
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2418 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4674 "parser.c"
    break;

  case 173: /* inrecclause: "INREC clause" "BUILD instruction" '(' $@21 allinoutrec ')'  */
#line 2420 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2420 "..\\..\\parser.y"
    {
=======
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2423 "..\\..\\parser.y"
    {
>>>>>>> .r1070
			current_inrec=0;
			nRecCase=0;
<<<<<<< .mine
}
#line 4683 "parser.c"
    break;

  case 174: /* $@22: %empty  */
#line 2425 "parser.y"
                            {
||||||| .r1065
}
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2425 "..\\..\\parser.y"
    {
=======
}
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2428 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4694 "parser.c"
    break;

  case 175: /* inrecclause: "INREC clause" "OVERLAY instruction" '=' '(' $@22 allinoutrec ')'  */
#line 2430 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2430 "..\\..\\parser.y"
    {
=======
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2433 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
<<<<<<< .mine
}
#line 4705 "parser.c"
    break;

  case 176: /* $@23: %empty  */
#line 2437 "parser.y"
                        {
||||||| .r1065
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2437 "..\\..\\parser.y"
    {
=======
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2440 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
        }
#line 4716 "parser.c"
    break;

  case 177: /* inrecclause: "INREC clause" "OVERLAY instruction" '(' $@23 allinoutrec ')'  */
#line 2442 "parser.y"
                          {
||||||| .r1065
        }
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2442 "..\\..\\parser.y"
    {
=======
        }
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2445 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
<<<<<<< .mine
}
#line 4727 "parser.c"
    break;

  case 178: /* $@24: %empty  */
#line 2448 "parser.y"
                        {
||||||| .r1065
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2448 "..\\..\\parser.y"
    {
=======
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2451 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4738 "parser.c"
    break;

  case 179: /* inrecclause: "INREC clause" "FINDREP" '=' $@24 allinoutrec  */
#line 2453 "parser.y"
               {
||||||| .r1065
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2453 "..\\..\\parser.y"
    {
=======
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2456 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4748 "parser.c"
    break;

  case 180: /* $@25: %empty  */
#line 2458 "parser.y"
                            {
||||||| .r1065
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2458 "..\\..\\parser.y"
    {
=======
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2461 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4759 "parser.c"
    break;

  case 181: /* inrecclause: "INREC clause" "FINDREP" '=' '(' $@25 allinoutrec ')'  */
#line 2463 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2463 "..\\..\\parser.y"
    {
=======
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2466 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4769 "parser.c"
    break;

  case 182: /* $@26: %empty  */
#line 2469 "parser.y"
                     {
||||||| .r1065
}
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2469 "..\\..\\parser.y"
    {
=======
}
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2472 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4780 "parser.c"
    break;

  case 183: /* inrecclause: "INREC clause" "FINDREP" $@26 allinoutrec  */
#line 2474 "parser.y"
               {
||||||| .r1065
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2474 "..\\..\\parser.y"
    {
=======
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2477 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        current_inrec=0;
        nRecCase=0;
<<<<<<< .mine
}
#line 4789 "parser.c"
    break;

  case 184: /* $@27: %empty  */
#line 2483 "parser.y"
                   {
||||||| .r1065
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2483 "..\\..\\parser.y"
    {
=======
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2486 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
<<<<<<< .mine
}
#line 4800 "parser.c"
    break;

  case 185: /* buildclause: ',' "BUILD instruction" '(' $@27 allinoutrec ')'  */
#line 2488 "parser.y"
                  {
||||||| .r1065
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2488 "..\\..\\parser.y"
    {
=======
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2491 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		/*  current_inrec=0;    */
		nRecCase=0;
<<<<<<< .mine
}
#line 4809 "parser.c"
    break;

  case 186: /* allsumfield: sumfield  */
#line 2494 "parser.y"
                      {}
#line 4815 "parser.c"
    break;

  case 187: /* allsumfield: sumfield ',' allsumfield  */
#line 2495 "parser.y"
                                           {}
#line 4821 "parser.c"
    break;

  case 188: /* sumfield: "DIGIT" ',' "DIGIT"  */
#line 2498 "parser.y"
                        {
        struct SumField_t *SumField=SumField_constructor((yyvsp[-2].number), (yyvsp[0].number), 0);
||||||| .r1065
}
    break;

  case 186:
/* Line 1792 of yacc.c  */
#line 2494 "..\\..\\parser.y"
    {}
    break;

  case 187:
/* Line 1792 of yacc.c  */
#line 2495 "..\\..\\parser.y"
    {}
    break;

  case 188:
/* Line 1792 of yacc.c  */
#line 2498 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
=======
}
    break;

  case 186:
/* Line 1792 of yacc.c  */
#line 2497 "..\\..\\parser.y"
    {}
    break;

  case 187:
/* Line 1792 of yacc.c  */
#line 2498 "..\\..\\parser.y"
    {}
    break;

  case 188:
/* Line 1792 of yacc.c  */
#line 2501 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
>>>>>>> .r1070
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			/* for SumFields Format=    */
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
<<<<<<< .mine
}
#line 4836 "parser.c"
    break;

  case 189: /* sumfield: "DIGIT" ',' "DIGIT" ',' "DIGIT" ',' "DIGIT"  */
#line 2508 "parser.y"
                                             {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[-6].number), (yyvsp[-4].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[-2].number), (yyvsp[0].number), 0);
||||||| .r1065
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2508 "..\\..\\parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
=======
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2511 "..\\..\\parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
>>>>>>> .r1070
			if (SumField1 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 136, ABEND_SKIP);
				YYABORT;
			}
			if (SumField2 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 140, ABEND_SKIP);
				YYABORT;
			}
			nTypeFormat=3;			/* for SumFields Format=    */
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			/* for SumFields Format=    */
 			SumField_addDefinition(SumField2); 
		strcpy(szMexToken, " sum fields clause ");
<<<<<<< .mine
}
#line 4858 "parser.c"
    break;

  case 190: /* sumfield: "DIGIT" ',' "DIGIT" ',' fieldtype  */
#line 2525 "parser.y"
                                     {
        struct SumField_t *SumField=SumField_constructor((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
||||||| .r1065
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2525 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
=======
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2528 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
>>>>>>> .r1070
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 137, ABEND_SKIP);
			YYABORT;
		}
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
<<<<<<< .mine
}
#line 4872 "parser.c"
    break;

  case 191: /* sumclause: "SUM clause" "FIELDS instruction" "NONE clause"  */
#line 2537 "parser.y"
                      {
||||||| .r1065
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2537 "..\\..\\parser.y"
    {
=======
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2540 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
<<<<<<< .mine
}
#line 4881 "parser.c"
    break;

  case 192: /* sumclause: "SUM clause" "FIELDS instruction" '(' allsumfield ')'  */
#line 2541 "parser.y"
                                     {
||||||| .r1065
}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2541 "..\\..\\parser.y"
    {
=======
}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2544 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        current_file=NULL;
<<<<<<< .mine
}
#line 4890 "parser.c"
    break;

  case 193: /* tokskipclause: "TOKSKIP clause"  */
#line 2548 "parser.y"
               {
||||||| .r1065
}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2548 "..\\..\\parser.y"
    {
=======
}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2550 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        SumField_enableXSUM(); 
        struct file_t *file=file_constructor((yyvsp[(7) - (7)].string));
        strcpy(szMexToken, " xsum clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setXSUMFile(file);
        current_file=file;
        nTypeFile=0;
        current_file=NULL;
        free((yyvsp[(7) - (7)].string));        
<<<<<<< .mine
}
#line 4898 "parser.c"
    break;

  case 194: /* filesgroup: "STRING"  */
#line 2554 "parser.y"
                {
||||||| .r1065
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2554 "..\\..\\parser.y"
    {
=======
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2567 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2571 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        /* Attenction file name for XSUM without FNAMES */
}
    break;

  case 196:
/* Line 1792 of yacc.c  */
#line 2577 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        struct file_t *file=file_constructor((yyvsp[(9) - (9)].string));
        strcpy(szMexToken, " xsum clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setXSUMFile(file);
        current_file=file;
        nTypeFile=0;
       /* file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); */ /*  Output  */
        current_file=NULL;
        free((yyvsp[(9) - (9)].string));        
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2597 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 198:
/* Line 1792 of yacc.c  */
#line 2603 "..\\..\\parser.y"
    {
        struct file_t *file;
		file=file_constructor((yyvsp[0].string));
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 138, ABEND_SKIP);
			YYABORT;
		}
		nCountGroupFiles++;
		if (nCountGroupFiles == 1)
			outfil_setOutfilFiles(current_outfil, file);
		else
            file_addQueue(&current_outfil->outfil_File, file);
        file_SetInfoForFile(file, COB_OPEN_OUTPUT); 
        outfil_SetVirtualFile(current_outfil, 0);       /* OUTFIL has file name */
        free((yyvsp[0].string));
        strcpy(szMexToken, " files clause ");
<<<<<<< .mine
}
#line 4920 "parser.c"
    break;

  case 195: /* filesgroup: filesgroup ',' filesgroup  */
#line 2574 "parser.y"
                                  {
||||||| .r1065
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2574 "..\\..\\parser.y"
    {
=======
}
    break;

  case 199:
/* Line 1792 of yacc.c  */
#line 2623 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		strcpy(szMexToken, " group files outfil ");
<<<<<<< .mine
}
#line 4928 "parser.c"
    break;

  case 196: /* fnamesclause: "FNAMES clause" '=' '(' filesgroup ')'  */
#line 2580 "parser.y"
                                         {
}
#line 4935 "parser.c"
    break;

  case 197: /* fnamesclause: "FNAMES clause" '=' filesgroup  */
#line 2582 "parser.y"
                                  {
}
#line 4942 "parser.c"
    break;

  case 198: /* fnamesclause: "SPLIT clause"  */
#line 2584 "parser.y"
                 {
||||||| .r1065
}
    break;

  case 196:
/* Line 1792 of yacc.c  */
#line 2580 "..\\..\\parser.y"
    {
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2582 "..\\..\\parser.y"
    {
}
    break;

  case 198:
/* Line 1792 of yacc.c  */
#line 2584 "..\\..\\parser.y"
    {
=======
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2629 "..\\..\\parser.y"
    {
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2631 "..\\..\\parser.y"
    {
}
    break;

  case 202:
/* Line 1792 of yacc.c  */
#line 2633 "..\\..\\parser.y"
    {
>>>>>>> .r1070
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
<<<<<<< .mine
}
#line 4951 "parser.c"
    break;

  case 199: /* fnamesclause: "SPLITBY clause" "DIGIT"  */
#line 2588 "parser.y"
                         {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[0].number));
||||||| .r1065
}
    break;

  case 199:
/* Line 1792 of yacc.c  */
#line 2588 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
=======
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2637 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
>>>>>>> .r1070
       strcpy(szMexToken, " option SPLITBY clause ");
<<<<<<< .mine
}
#line 4960 "parser.c"
    break;

  case 200: /* outfilincludeclause: "INCLUDE clause" '=' allcondfield  */
#line 2594 "parser.y"
                                {
||||||| .r1065
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2594 "..\\..\\parser.y"
    {
=======
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2643 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
			    join_IncludeCondField(current_filejoin, current_join, (yyvsp[0].condField));
        }
		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, (yyvsp[0].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
<<<<<<< .mine
}
#line 4975 "parser.c"
    break;

  case 201: /* outfilomitclause: "OMIT clause" '=' allcondfield  */
#line 2606 "parser.y"
                             {
||||||| .r1065
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2606 "..\\..\\parser.y"
    {
=======
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2655 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
                join_OmitCondField(current_filejoin, current_join, (yyvsp[0].condField));
        }
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, (yyvsp[0].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
<<<<<<< .mine
}
#line 4990 "parser.c"
    break;

  case 202: /* outfilclause: "OUTFIL clause"  */
#line 2618 "parser.y"
              {
||||||| .r1065
}
    break;

  case 202:
/* Line 1792 of yacc.c  */
#line 2618 "..\\..\\parser.y"
    {
=======
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2667 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		struct outfil_t *outfil=outfil_constructor();
        if (outfil == NULL) {
            utl_abend_terminate(MEMORYALLOC, 139, ABEND_SKIP);
			YYABORT;
		}
		if (current_outfil == NULL)
			outfil_addDefinition(outfil); 
		else 
			outfil_addDefinition(outfil); 
		current_outfil=outfil; 
		nstate_outfil=1;
        strcpy(szMexToken, " outfil clause ");
<<<<<<< .mine
}
#line 5009 "parser.c"
    break;

  case 203: /* startrecclause: "STARTREC clause" '=' "SIGNDIGITBIG"  */
#line 2634 "parser.y"
                                {
||||||| .r1065
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2634 "..\\..\\parser.y"
    {
=======
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2683 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[0].llnumber));
		strcpy(szMexToken, " start rec clause ");
<<<<<<< .mine
}
#line 5019 "parser.c"
    break;

  case 204: /* startrecclause: "STARTREC clause" '=' "DIGIT"  */
#line 2639 "parser.y"
                         {
||||||| .r1065
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2639 "..\\..\\parser.y"
    {
=======
}
    break;

  case 208:
/* Line 1792 of yacc.c  */
#line 2688 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[0].number));
		strcpy(szMexToken, " start rec clause ");
<<<<<<< .mine
}
#line 5029 "parser.c"
    break;

  case 205: /* endrecclause: "ENDREC clause" '=' "SIGNDIGITBIG"  */
#line 2647 "parser.y"
                              {
||||||| .r1065
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2647 "..\\..\\parser.y"
    {
=======
}
    break;

  case 209:
/* Line 1792 of yacc.c  */
#line 2696 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[0].llnumber));
		strcpy(szMexToken, " end rec clause ");
<<<<<<< .mine
}
#line 5039 "parser.c"
    break;

  case 206: /* endrecclause: "ENDREC clause" '=' "DIGIT"  */
#line 2652 "parser.y"
                       {
||||||| .r1065
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2652 "..\\..\\parser.y"
    {
=======
}
    break;

  case 210:
/* Line 1792 of yacc.c  */
#line 2701 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[0].number));
		strcpy(szMexToken, " end rec clause ");
<<<<<<< .mine
}
#line 5049 "parser.c"
    break;

  case 207: /* saveclause: "SAVE clause"  */
#line 2659 "parser.y"
                 {
||||||| .r1065
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2659 "..\\..\\parser.y"
    {
=======
}
    break;

  case 211:
/* Line 1792 of yacc.c  */
#line 2708 "..\\..\\parser.y"
    {
>>>>>>> .r1070
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
<<<<<<< .mine
}
#line 5059 "parser.c"
    break;

  case 208: /* alloption: option  */
#line 2668 "parser.y"
             {}
#line 5065 "parser.c"
    break;

  case 209: /* alloption: option alloption  */
#line 2670 "parser.y"
                        {}
#line 5071 "parser.c"
    break;

  case 210: /* option: "COPY"  */
#line 2673 "parser.y"
           {
||||||| .r1065
}
    break;

  case 208:
/* Line 1792 of yacc.c  */
#line 2668 "..\\..\\parser.y"
    {}
    break;

  case 209:
/* Line 1792 of yacc.c  */
#line 2670 "..\\..\\parser.y"
    {}
    break;

  case 210:
/* Line 1792 of yacc.c  */
#line 2673 "..\\..\\parser.y"
    {
=======
}
    break;

  case 212:
/* Line 1792 of yacc.c  */
#line 2717 "..\\..\\parser.y"
    {}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2719 "..\\..\\parser.y"
    {}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2722 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
<<<<<<< .mine
}
#line 5080 "parser.c"
    break;

  case 211: /* option: "SKIP clause" '=' "SIGNDIGITBIG"  */
#line 2677 "parser.y"
                               {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[0].llnumber));
||||||| .r1065
}
    break;

  case 211:
/* Line 1792 of yacc.c  */
#line 2677 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
=======
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2726 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
>>>>>>> .r1070
		strcpy(szMexToken, " option skip rec clause ");
<<<<<<< .mine
}
#line 5089 "parser.c"
    break;

  case 212: /* option: "SKIP clause" '=' "DIGIT"  */
#line 2681 "parser.y"
                        {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[0].number));
||||||| .r1065
}
    break;

  case 212:
/* Line 1792 of yacc.c  */
#line 2681 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
=======
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2730 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
>>>>>>> .r1070
		strcpy(szMexToken, " option skip rec clause ");
<<<<<<< .mine
}
#line 5098 "parser.c"
    break;

  case 213: /* option: "STOPAFT clause" '=' "SIGNDIGITBIG"  */
#line 2685 "parser.y"
                               {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[0].llnumber));
||||||| .r1065
}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2685 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
=======
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2734 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
>>>>>>> .r1070
		strcpy(szMexToken, " option stop after clause ");
<<<<<<< .mine
}
#line 5107 "parser.c"
    break;

  case 214: /* option: "STOPAFT clause" '=' "DIGIT"  */
#line 2689 "parser.y"
                        {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[0].number));
||||||| .r1065
}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2689 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
=======
}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2738 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
>>>>>>> .r1070
		strcpy(szMexToken, " option stop after clause ");
<<<<<<< .mine
}
#line 5116 "parser.c"
    break;

  case 215: /* option: "VLSCMP clause"  */
#line 2693 "parser.y"
             {
||||||| .r1065
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2693 "..\\..\\parser.y"
    {
=======
}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2742 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
<<<<<<< .mine
}
#line 5125 "parser.c"
    break;

  case 216: /* option: "VLSHRT clause"  */
#line 2697 "parser.y"
             {
||||||| .r1065
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2697 "..\\..\\parser.y"
    {
=======
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2746 "..\\..\\parser.y"
    {
>>>>>>> .r1070
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
<<<<<<< .mine
}
#line 5134 "parser.c"
    break;

  case 217: /* option: "Y2PAST clause" '=' "DIGIT"  */
#line 2701 "parser.y"
                       {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[0].number));
||||||| .r1065
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2701 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
=======
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2750 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
>>>>>>> .r1070
		strcpy(szMexToken, " option y2past clause ");
<<<<<<< .mine
}
#line 5143 "parser.c"
    break;

  case 218: /* option: ',' "EXROUT clause" '=' '(' "STRING" ')'  */
#line 2706 "parser.y"
||||||| .r1065
}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2706 "..\\..\\parser.y"
=======
}
    break;

  case 222:
/* Line 1792 of yacc.c  */
#line 2755 "..\\..\\parser.y"
>>>>>>> .r1070
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[-4].string), (yyvsp[-1].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
<<<<<<< .mine
        free((yyvsp[-4].string));
        free((yyvsp[-1].string));
}
#line 5154 "parser.c"
    break;

  case 219: /* option: "MODS clause" "EXROUT clause" '=' '(' "STRING" ')'  */
#line 2713 "parser.y"
||||||| .r1065
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2713 "..\\..\\parser.y"
=======
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2762 "..\\..\\parser.y"
>>>>>>> .r1070
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[-4].string), (yyvsp[-1].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
<<<<<<< .mine
        free((yyvsp[-4].string));
        free((yyvsp[-1].string));
}
#line 5165 "parser.c"
    break;

  case 220: /* option: "MODS clause" "EXROUT clause" '=' '(' "STRING" ',' "DIGITBIG" ')'  */
#line 2719 "parser.y"
                                                  {
        utils_SetOptionExRoutine("MODS", (yyvsp[-6].string), (yyvsp[-3].string));
||||||| .r1065
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2719 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
=======
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 224:
/* Line 1792 of yacc.c  */
#line 2768 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
>>>>>>> .r1070
		strcpy(szMexToken, " option MODS E15 clause 2");
<<<<<<< .mine
        free((yyvsp[-6].string));
        free((yyvsp[-3].string));
}
#line 5176 "parser.c"
    break;

  case 221: /* option: "MODS clause" "EXROUT clause" '=' '(' "STRING" ',' "DIGITBIG" ',' "STRING" ')'  */
#line 2725 "parser.y"
                                                             {
        utils_SetOptionExRoutine("MODS", (yyvsp[-8].string), (yyvsp[-5].string));
||||||| .r1065
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2725 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
=======
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 225:
/* Line 1792 of yacc.c  */
#line 2774 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
>>>>>>> .r1070
		strcpy(szMexToken, " option MODS E15 clause 3");
<<<<<<< .mine
        free((yyvsp[-8].string));
        free((yyvsp[-5].string));
        free((yyvsp[-1].string));
}
#line 5188 "parser.c"
    break;

  case 222: /* option: "MODS clause" "EXROUT clause" '=' '(' "STRING" ',' "DIGIT" ')'  */
#line 2732 "parser.y"
                                               {
        utils_SetOptionExRoutine("MODS", (yyvsp[-6].string), (yyvsp[-3].string));
||||||| .r1065
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 222:
/* Line 1792 of yacc.c  */
#line 2732 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
=======
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 226:
/* Line 1792 of yacc.c  */
#line 2781 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
>>>>>>> .r1070
		strcpy(szMexToken, " option MODS E15 clause 2");
<<<<<<< .mine
        free((yyvsp[-6].string));
        free((yyvsp[-3].string));
}
#line 5199 "parser.c"
    break;

  case 223: /* option: "MODS clause" "EXROUT clause" '=' '(' "STRING" ',' "DIGIT" ',' "STRING" ')'  */
#line 2738 "parser.y"
                                                          {
        utils_SetOptionExRoutine("MODS", (yyvsp[-8].string), (yyvsp[-5].string));
||||||| .r1065
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2738 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
=======
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2787 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
>>>>>>> .r1070
		strcpy(szMexToken, " option MODS E15 clause 3");
<<<<<<< .mine
        free((yyvsp[-8].string));
        free((yyvsp[-5].string));
        free((yyvsp[-1].string));
}
#line 5211 "parser.c"
    break;

  case 224: /* $@28: %empty  */
#line 2747 "parser.y"
              {
}
#line 5218 "parser.c"
    break;

  case 225: /* optionclause: "OPTION clause" $@28 alloption  */
#line 2748 "parser.y"
            {
}
#line 5225 "parser.c"
    break;

  case 226: /* recordoption: "RECTYPEFIX"  */
#line 2759 "parser.y"
                 {
||||||| .r1065
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 224:
/* Line 1792 of yacc.c  */
#line 2747 "..\\..\\parser.y"
    {
}
    break;

  case 225:
/* Line 1792 of yacc.c  */
#line 2748 "..\\..\\parser.y"
    {
}
    break;

  case 226:
/* Line 1792 of yacc.c  */
#line 2759 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2796 "..\\..\\parser.y"
    {
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2797 "..\\..\\parser.y"
    {
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2808 "..\\..\\parser.y"
    {
>>>>>>> .r1070
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
<<<<<<< .mine
        free((yyvsp[0].string));
}
#line 5235 "parser.c"
    break;

  case 227: /* recordoption: "RECTYPEFIX" "LENGTH" '(' "DIGIT" ')'  */
#line 2765 "parser.y"
                                        {
        utils_SetRecordOptionSortType((yyvsp[-4].string));
        utils_SetRecordOptionSortLen((yyvsp[-1].number), -1, -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2765 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 231:
/* Line 1792 of yacc.c  */
#line 2814 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-4].string));
}
#line 5246 "parser.c"
    break;

  case 228: /* recordoption: "RECTYPEFIX" "LENGTH" '(' "DIGIT" ',' "DIGIT" ')'  */
#line 2771 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen((yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2771 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2820 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-6].string));
}
#line 5257 "parser.c"
    break;

  case 229: /* recordoption: "RECTYPEFIX" "LENGTH" '(' ',' "DIGIT" ')'  */
#line 2777 "parser.y"
                                            {
        utils_SetRecordOptionSortType((yyvsp[-5].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[-1].number), -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2777 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 233:
/* Line 1792 of yacc.c  */
#line 2826 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-5].string));
}
#line 5268 "parser.c"
    break;

  case 230: /* recordoption: "RECTYPEFIX" "LENGTH" '(' "DIGIT" ',' "DIGIT" ',' "DIGIT" ')'  */
#line 2783 "parser.y"
                                                            {
        utils_SetRecordOptionSortType((yyvsp[-8].string));
        utils_SetRecordOptionSortLen((yyvsp[-5].number), (yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2783 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2832 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-8].string));
}
#line 5279 "parser.c"
    break;

  case 231: /* recordoption: "RECTYPEFIX" "LENGTH" '(' ',' ',' "DIGIT" ')'  */
#line 2789 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 231:
/* Line 1792 of yacc.c  */
#line 2789 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2838 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-6].string));
}
#line 5290 "parser.c"
    break;

  case 232: /* recordoption: "RECTYPEFIX" "LENGTH" '(' "DIGIT" ',' ',' "DIGIT" ')'  */
#line 2795 "parser.y"
                                                       {
        utils_SetRecordOptionSortType((yyvsp[-7].string));
        utils_SetRecordOptionSortLen((yyvsp[-4].number), -1, (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2795 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2844 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-7].string));
}
#line 5301 "parser.c"
    break;

  case 233: /* recordoption: "RECTYPEVAR"  */
#line 2802 "parser.y"
                  {
||||||| .r1065
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 233:
/* Line 1792 of yacc.c  */
#line 2802 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2851 "..\\..\\parser.y"
    {
>>>>>>> .r1070
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
<<<<<<< .mine
        free((yyvsp[0].string));
}
#line 5311 "parser.c"
    break;

  case 234: /* recordoption: "RECTYPEVAR" "LENGTH" '(' "DIGIT" ')'  */
#line 2808 "parser.y"
                                       {
        utils_SetRecordOptionSortType((yyvsp[-4].string));
        utils_SetRecordOptionSortLen((yyvsp[-1].number), -1, -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2808 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 238:
/* Line 1792 of yacc.c  */
#line 2857 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-4].string));
}
#line 5322 "parser.c"
    break;

  case 235: /* recordoption: "RECTYPEVAR" "LENGTH" '(' "DIGIT" ',' "DIGIT" ')'  */
#line 2814 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen((yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2814 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 239:
/* Line 1792 of yacc.c  */
#line 2863 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-6].string));
}
#line 5333 "parser.c"
    break;

  case 236: /* recordoption: "RECTYPEVAR" "LENGTH" '(' ',' "DIGIT" ')'  */
#line 2820 "parser.y"
                                           {
        utils_SetRecordOptionSortType((yyvsp[-5].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[-1].number), -1, -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2820 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 240:
/* Line 1792 of yacc.c  */
#line 2869 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-5].string));
}
#line 5344 "parser.c"
    break;

  case 237: /* recordoption: "RECTYPEVAR" "LENGTH" '(' "DIGIT" ',' "DIGIT" ',' "DIGIT" ')'  */
#line 2826 "parser.y"
                                                            {
        utils_SetRecordOptionSortType((yyvsp[-8].string));
        utils_SetRecordOptionSortLen((yyvsp[-5].number), (yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2826 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 241:
/* Line 1792 of yacc.c  */
#line 2875 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-8].string));
}
#line 5355 "parser.c"
    break;

  case 238: /* recordoption: "RECTYPEVAR" "LENGTH" '(' ',' ',' "DIGIT" ')'  */
#line 2832 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 238:
/* Line 1792 of yacc.c  */
#line 2832 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 242:
/* Line 1792 of yacc.c  */
#line 2881 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-6].string));
}
#line 5366 "parser.c"
    break;

  case 239: /* recordoption: "RECTYPEVAR" "LENGTH" '(' "DIGIT" ',' ',' "DIGIT" ')'  */
#line 2838 "parser.y"
                                                     {
        utils_SetRecordOptionSortType((yyvsp[-7].string));
        utils_SetRecordOptionSortLen((yyvsp[-4].number), -1, (yyvsp[-1].number), -1, -1, -1, -1);
||||||| .r1065
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 239:
/* Line 1792 of yacc.c  */
#line 2838 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
=======
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 243:
/* Line 1792 of yacc.c  */
#line 2887 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
>>>>>>> .r1070
		strcpy(szMexToken, "  record option clause ");
<<<<<<< .mine
        free((yyvsp[-7].string));
}
#line 5377 "parser.c"
    break;

  case 240: /* recordclause: "RECORD instruction" "TYPE" recordoption  */
#line 2849 "parser.y"
                                {
||||||| .r1065
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 240:
/* Line 1792 of yacc.c  */
#line 2849 "..\\..\\parser.y"
    {
=======
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 244:
/* Line 1792 of yacc.c  */
#line 2898 "..\\..\\parser.y"
    {
>>>>>>> .r1070
    /*} allrecordoption { */
}
#line 5385 "parser.c"
    break;


#line 5389 "parser.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      {
        yypcontext_t yyctx
          = {yyssp, yytoken};
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == -1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *,
                             YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (yymsg)
              {
                yysyntax_error_status
                  = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
                yymsgp = yymsg;
              }
            else
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = YYENOMEM;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == YYENOMEM)
          goto yyexhaustedlab;
      }
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if 1
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturn;
#endif


/*-------------------------------------------------------.
| yyreturn -- parsing is finished, clean up and return.  |
`-------------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
  return yyresult;
}

#line 2854 "parser.y"

<<<<<<< .mine
||||||| .r1065

/* Line 1792 of yacc.c  */
#line 5434 "..\\..\\parser.c"
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


/* Line 2055 of yacc.c  */
#line 2854 "..\\..\\parser.y"

=======

/* Line 1792 of yacc.c  */
#line 5513 "..\\..\\parser.c"
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


/* Line 2055 of yacc.c  */
#line 2903 "..\\..\\parser.y"

>>>>>>> .r1070
