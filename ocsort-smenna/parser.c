/* A Bison parser, made by GNU Bison 2.7.  */ 

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
#line 68 "parser.c"

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
     USE = 258,
     GIVE = 259,
     SORT = 260,
     MERGE = 261,
     FIELDS = 262,
     BUILD = 263,
     RECORD = 264,
     ORG = 265,
     OUTREC = 266,
     INREC = 267,
     SUM = 268,
     INCLUDE = 269,
     OMIT = 270,
     COND = 271,
     NONE = 272,
     AND = 273,
     OR = 274,
     FORMAT = 275,
     OUTFIL = 276,
     FNAMES = 277,
     FILES = 278,
     STARTREC = 279,
     ENDREC = 280,
     SAVE = 281,
     OPTION = 282,
     SKIPREC = 283,
     STOPAFT = 284,
     TOKSKIP = 285,
     NUMBER = 286,
     STRING = 287,
     FIELDTYPE = 288,
     ORDER = 289,
     COPY = 290,
     LITERAL = 291,
     SIGNDIGITBIG = 292
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 3 "parser.y"
 
	int number;
	int number64;
	char *string;
	char character;
	struct condField_t *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t *SumField;


/* Line 387 of yacc.c  */
#line 159 "parser.c"
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
#line 187 "parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 12 "parser.y"

	#include <stdio.h>
	#include <string.h>
	#include <io.h>
	#include "ocsort.h"
	#include "file.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "SumField.h"
	#include "utils.h"
	int yylex (void);
	void yyerror (char const *);

	struct file_t *current_file=NULL;
	struct outfil_t *current_outfil=NULL;

	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
	int nPosAbsRec=-1;

	extern int nTypeFieldsCmd;
	char szTmp[5];
	char szPath[260];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;



/* Line 391 of yacc.c  */
#line 228 "parser.c"

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
#define YYFINAL  68
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   278

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  43
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  58
/* YYNRULES -- Number of rules.  */
#define YYNRULES  144
/* YYNRULES -- Number of states.  */
#define YYNSTATES  304

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   292

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      38,    39,     2,     2,    40,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    42,     2,
       2,    41,     2,     2,     2,     2,     2,     2,     2,     2,
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
      35,    36,    37
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    47,    48,    53,    54,    59,    60,
      64,    70,    78,    84,    94,   102,   104,   106,   108,   111,
     114,   116,   118,   122,   128,   136,   138,   139,   146,   147,
     155,   160,   167,   168,   175,   176,   184,   191,   196,   198,
     202,   206,   210,   214,   219,   229,   239,   249,   259,   269,
     277,   291,   295,   300,   304,   309,   311,   315,   319,   323,
     327,   333,   335,   337,   340,   341,   349,   350,   357,   358,
     366,   367,   374,   376,   380,   384,   388,   392,   398,   400,
     402,   403,   411,   412,   419,   420,   428,   429,   436,   438,
     442,   447,   452,   460,   466,   470,   476,   481,   488,   495,
     497,   501,   506,   510,   515,   519,   523,   524,   531,   532,
     538,   540,   544,   548,   550,   553,   556,   558,   562,   565,
     567,   569,   573,   577,   578
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      44,     0,    -1,    -1,    45,    44,    -1,    46,    -1,    65,
      -1,    48,    -1,    58,    -1,    61,    -1,    67,    -1,    68,
      -1,    71,    -1,    78,    -1,    85,    -1,    86,    -1,    93,
      -1,    87,    -1,    88,    -1,    89,    -1,    90,    -1,    94,
      -1,    95,    -1,    96,    -1,    99,    -1,    -1,     3,    32,
      47,    50,    -1,    -1,     4,    32,    49,    50,    -1,    -1,
      10,    32,    50,    -1,    10,    38,    32,    39,    50,    -1,
       9,    32,    40,    31,    40,    31,    50,    -1,     9,    32,
      40,    31,    50,    -1,     9,    38,    32,    40,    31,    40,
      31,    39,    50,    -1,     9,    38,    32,    40,    31,    39,
      50,    -1,    33,    -1,    34,    -1,    32,    -1,    32,    32,
      -1,    31,    32,    -1,    37,    -1,    57,    -1,    57,    40,
      56,    -1,    31,    40,    31,    40,    52,    -1,    31,    40,
      31,    40,    51,    40,    52,    -1,    32,    -1,    -1,     5,
       7,    38,    59,    56,    39,    -1,    -1,     5,     7,    41,
      38,    60,    56,    39,    -1,     5,     7,    41,    35,    -1,
       5,     7,    41,    38,    35,    39,    -1,    -1,     6,     7,
      38,    62,    56,    39,    -1,    -1,     6,     7,    41,    38,
      63,    56,    39,    -1,     6,     7,    41,    38,    35,    39,
      -1,     6,     7,    41,    35,    -1,    66,    -1,    38,    64,
      39,    -1,    64,    18,    64,    -1,    64,    19,    64,    -1,
      20,    41,    51,    -1,    40,    20,    41,    51,    -1,    31,
      40,    31,    40,    51,    40,    53,    40,    54,    -1,    31,
      40,    31,    40,    51,    40,    53,    40,    31,    -1,    31,
      40,    31,    40,    51,    40,    53,    40,    55,    -1,    31,
      40,    31,    40,    32,    40,    53,    40,    54,    -1,    31,
      40,    31,    40,    32,    40,    53,    40,    31,    -1,    31,
      40,    31,    40,    32,    40,    54,    -1,    31,    40,    31,
      40,    51,    40,    53,    40,    31,    40,    31,    40,    51,
      -1,    15,    16,    64,    -1,    15,    16,    41,    64,    -1,
      14,    16,    64,    -1,    14,    16,    41,    64,    -1,    70,
      -1,    70,    40,    69,    -1,    31,    40,    31,    -1,    31,
      42,    54,    -1,    31,    42,    32,    -1,    31,    42,    31,
      40,    31,    -1,    32,    -1,    54,    -1,    31,    40,    -1,
      -1,    11,     7,    41,    38,    72,    69,    39,    -1,    -1,
      11,     7,    38,    73,    69,    39,    -1,    -1,    11,     8,
      41,    38,    74,    69,    39,    -1,    -1,    11,     8,    38,
      75,    69,    39,    -1,    77,    -1,    77,    40,    76,    -1,
      31,    40,    31,    -1,    31,    42,    54,    -1,    31,    42,
      32,    -1,    31,    42,    31,    40,    31,    -1,    32,    -1,
      54,    -1,    -1,    12,     7,    41,    38,    79,    76,    39,
      -1,    -1,    12,     7,    38,    80,    76,    39,    -1,    -1,
      12,     8,    41,    38,    81,    76,    39,    -1,    -1,    12,
       8,    38,    82,    76,    39,    -1,    84,    -1,    84,    40,
      83,    -1,    38,    31,    40,    31,    -1,    40,    31,    40,
      31,    -1,    31,    40,    31,    40,    31,    40,    31,    -1,
      40,    31,    40,    31,    39,    -1,    31,    40,    31,    -1,
      31,    40,    31,    40,    51,    -1,    13,     7,    41,    17,
      -1,    13,     7,    41,    38,    17,    39,    -1,    13,     7,
      41,    38,    83,    39,    -1,    30,    -1,    22,    41,    32,
      -1,    40,    22,    41,    32,    -1,    23,    41,    32,    -1,
      40,    23,    41,    32,    -1,    14,    41,    64,    -1,    15,
      41,    64,    -1,    -1,    11,    41,    38,    91,    69,    39,
      -1,    -1,    11,    38,    92,    69,    39,    -1,    21,    -1,
      24,    41,    31,    -1,    25,    41,    31,    -1,    26,    -1,
      26,    40,    -1,    40,    26,    -1,    98,    -1,    98,    40,
      97,    -1,    98,    97,    -1,    32,    -1,    35,    -1,    28,
      41,    31,    -1,    29,    41,    31,    -1,    -1,    27,   100,
      97,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    98,    98,    99,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   119,   120,   125,   125,   134,   134,   143,   144,
     150,   157,   165,   173,   181,   192,   197,   202,   207,   211,
     216,   222,   223,   226,   234,   242,   249,   249,   255,   255,
     261,   265,   270,   270,   278,   278,   284,   288,   295,   298,
     301,   304,   309,   321,   336,   340,   351,   355,   359,   362,
     367,   373,   377,   383,   387,   395,   396,   398,   420,   432,
     441,   448,   462,   474,   496,   496,   501,   501,   506,   506,
     511,   511,   518,   519,   521,   528,   536,   545,   552,   559,
     568,   568,   573,   573,   578,   578,   583,   583,   593,   594,
     596,   601,   606,   614,   619,   624,   629,   632,   635,   642,
     647,   653,   660,   665,   672,   680,   687,   687,   692,   692,
     699,   710,   716,   722,   726,   730,   737,   738,   739,   741,
     744,   747,   750,   755,   755
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"USE clause\"", "\"GIVE clause\"",
  "\"SORT clause\"", "\"MERGE clause\"", "\"FIELDS instruction\"",
  "\"BUILD instruction\"", "\"RECORD instruction\"", "\"ORG instruction\"",
  "\"OUTREC clause\"", "\"INREC clause\"", "\"SUM clause\"",
  "\"INCLUDE clause\"", "\"OMIT clause\"", "\"COND clause\"",
  "\"NONE clause\"", "\"AND clause\"", "\"OR clause\"",
  "\"FORMAT clause\"", "\"OUTFIL clause\"", "\"FNAMES clause\"",
  "\"FILES  clause\"", "\"STARTREC clause\"", "\"ENDREC clause\"",
  "\"SAVE clause\"", "\"OPTION clause\"", "\"SKIP clause\"",
  "\"STOPAFT clause\"", "\"TOKSKIP clause\"", "\"NUMBER\"", "\"STRING\"",
  "\"FIELDTYPE\"", "\"ORDER\"", "\"COPY\"", "\"LITERAL\"",
  "\"SIGNDIGITBIG\"", "'('", "')'", "','", "'='", "':'", "$accept",
  "beginning", "clause", "useclause", "$@1", "giveclause", "$@2",
  "recordorginstruction", "fieldtype", "fielddirection", "fieldcondition",
  "fieldvalue", "signdigitvalue", "allsortfield", "sortfield",
  "sortclause", "$@3", "$@4", "mergeclause", "$@5", "$@6", "allcondfield",
  "formatclause", "condfield", "omitclause", "includeclause", "alloutrec",
  "outrec", "outrecclause", "$@7", "$@8", "$@9", "$@10", "allinrec",
  "inrec", "inrecclause", "$@11", "$@12", "$@13", "$@14", "allsumfield",
  "sumfield", "sumclause", "tokskipclause", "fnamesclause", "filesclause",
  "outfilincludeclause", "outfilomitclause", "$@15", "$@16",
  "outfilclause", "startrecclause", "endrecclause", "saveclause",
  "alloption", "option", "optionclause", "$@17", YY_NULL
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
     285,   286,   287,   288,   289,   290,   291,   292,    40,    41,
      44,    61,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    43,    44,    44,    45,    45,    45,    45,    45,    45,
      45,    45,    45,    45,    45,    45,    45,    45,    45,    45,
      45,    45,    45,    45,    47,    46,    49,    48,    50,    50,
      50,    50,    50,    50,    50,    51,    52,    53,    54,    54,
      55,    56,    56,    57,    57,    57,    59,    58,    60,    58,
      58,    58,    62,    61,    63,    61,    61,    61,    64,    64,
      64,    64,    65,    65,    66,    66,    66,    66,    66,    66,
      66,    67,    67,    68,    68,    69,    69,    70,    70,    70,
      70,    70,    70,    70,    72,    71,    73,    71,    74,    71,
      75,    71,    76,    76,    77,    77,    77,    77,    77,    77,
      79,    78,    80,    78,    81,    78,    82,    78,    83,    83,
      84,    84,    84,    84,    84,    84,    85,    85,    85,    86,
      87,    87,    88,    88,    89,    90,    91,    71,    92,    71,
      93,    94,    95,    96,    96,    96,    97,    97,    97,    98,
      98,    98,    98,   100,    99
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     4,     0,     4,     0,     3,
       5,     7,     5,     9,     7,     1,     1,     1,     2,     2,
       1,     1,     3,     5,     7,     1,     0,     6,     0,     7,
       4,     6,     0,     6,     0,     7,     6,     4,     1,     3,
       3,     3,     3,     4,     9,     9,     9,     9,     9,     7,
      13,     3,     4,     3,     4,     1,     3,     3,     3,     3,
       5,     1,     1,     2,     0,     7,     0,     6,     0,     7,
       0,     6,     1,     3,     3,     3,     3,     5,     1,     1,
       0,     7,     0,     6,     0,     7,     0,     6,     1,     3,
       4,     4,     7,     5,     3,     5,     4,     6,     6,     1,
       3,     4,     3,     4,     3,     3,     0,     6,     0,     5,
       1,     3,     3,     1,     2,     2,     1,     3,     2,     1,
       1,     3,     3,     0,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   130,     0,     0,     0,     0,   133,   143,   119,     0,
       0,     2,     4,     6,     7,     8,     5,     9,    10,    11,
      12,    13,    14,    16,    17,    18,    19,    15,    20,    21,
      22,    23,    24,    26,     0,     0,     0,     0,   128,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   134,     0,     0,     0,     0,   135,     1,     3,
      28,    28,    46,     0,    52,     0,    86,     0,    90,     0,
       0,   126,   102,     0,   106,     0,     0,     0,     0,     0,
      73,    58,   124,     0,    71,   125,    35,    62,   120,   122,
     131,   132,     0,     0,   139,   140,   144,   136,     0,     0,
       0,     0,     0,    25,    27,     0,    50,    48,     0,    57,
      54,     0,    84,     0,    88,     0,    81,    82,     0,    75,
       0,     0,   100,     0,   104,   116,     0,     0,     0,    74,
       0,     0,    72,     0,     0,     0,   138,    63,   121,   123,
       0,     0,    28,     0,     0,    45,     0,    41,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    39,    83,     0,
      38,   129,     0,     0,     0,    98,    99,     0,    92,     0,
       0,     0,     0,     0,     0,     0,     0,   108,     0,    59,
      60,    61,   141,   142,   137,     0,     0,    29,     0,     0,
      47,     0,    51,     0,    53,    56,     0,    87,     0,    91,
       0,    77,     0,    79,    78,    76,   127,     0,     0,   103,
       0,     0,   107,     0,   117,     0,     0,     0,   118,     0,
       0,    28,     0,    28,     0,    42,    49,    55,    85,    89,
       0,    94,     0,    96,    95,    93,   101,   105,   114,     0,
       0,   109,     0,     0,     0,    32,     0,    30,     0,    80,
       0,     0,   110,   111,     0,     0,    28,    28,     0,    36,
       0,    43,    97,     0,   115,   113,     0,    37,     0,    69,
      37,     0,    31,    34,     0,     0,     0,     0,     0,    28,
      44,   112,    68,     0,    67,    65,    40,    64,    66,    33,
       0,     0,     0,    70
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    20,    21,    22,    70,    23,    71,   113,    97,   271,
     278,   127,   298,   156,   157,    24,   115,   159,    25,   118,
     162,    90,    26,    91,    27,    28,   128,   129,    29,   164,
     121,   166,   123,   177,   178,    30,   179,   131,   181,   133,
     186,   187,    31,    32,    33,    34,    35,    36,   130,    80,
      37,    38,    39,    40,   106,   107,    41,    63
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -133
static const yytype_int16 yypact[] =
{
      93,   -21,     0,    67,    78,    10,    13,   105,   -10,    -6,
       3,  -133,    81,    89,    91,    96,   103,  -133,  -133,   116,
     155,    93,  -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,
    -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,
    -133,  -133,  -133,  -133,    45,    49,    83,    88,  -133,   123,
     106,   107,   122,   -12,   -16,    35,   -16,   141,   151,   152,
     154,   156,  -133,    99,   145,   147,   149,  -133,  -133,  -133,
     101,   101,  -133,   114,  -133,   119,  -133,   153,  -133,   160,
      71,  -133,  -133,   161,  -133,   162,    16,   163,   -16,   -16,
     132,  -133,   132,   -16,   132,   132,  -133,  -133,  -133,  -133,
    -133,  -133,   164,   165,  -133,  -133,  -133,    32,   141,   157,
     169,     7,    30,  -133,  -133,   133,  -133,   158,   133,  -133,
     159,    71,  -133,    71,  -133,    37,   170,  -133,   168,   171,
      71,   135,  -133,   135,  -133,  -133,    -4,   173,    19,   132,
     -16,   -16,   132,   177,   178,    99,  -133,  -133,  -133,  -133,
     172,   181,   101,   182,   175,  -133,   180,   176,   183,   133,
     184,   185,   133,   186,    71,   187,    71,  -133,   179,   137,
    -133,  -133,    71,   188,    38,   170,  -133,   189,   190,   135,
     192,   135,   193,   194,   198,   202,   196,   197,   199,  -133,
    -133,   174,  -133,  -133,  -133,   205,   200,  -133,   203,   207,
    -133,   133,  -133,   204,  -133,  -133,   206,  -133,   208,  -133,
     209,  -133,    31,   170,  -133,  -133,  -133,   210,   139,  -133,
     135,   211,  -133,   212,  -133,   213,   214,   215,  -133,    44,
     140,    15,   218,   101,   216,  -133,  -133,  -133,  -133,  -133,
     221,  -133,    60,   170,  -133,  -133,  -133,  -133,   217,   222,
     227,  -133,   219,   220,   230,  -133,   136,  -133,   144,  -133,
     231,    -3,  -133,   224,   148,   232,   101,   101,   234,  -133,
     226,  -133,  -133,   228,  -133,  -133,   235,   170,   229,  -133,
    -133,   233,  -133,  -133,   236,   237,   239,   150,   109,   101,
    -133,  -133,   235,   170,  -133,    69,  -133,  -133,  -133,  -133,
     241,   238,   141,  -133
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -133,   225,  -133,  -133,  -133,  -133,  -133,   -71,  -105,   -68,
     -45,  -129,  -133,  -106,  -133,  -133,  -133,  -133,  -133,  -133,
    -133,   -47,  -133,  -133,  -133,  -133,  -107,  -133,  -133,  -133,
    -133,  -133,  -133,  -132,  -133,  -133,  -133,  -133,  -133,  -133,
      -8,  -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,  -133,
    -133,  -133,  -133,  -133,  -102,  -133,  -133,  -133
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     114,   180,   176,   147,   176,   146,    53,    92,    94,    95,
      55,    42,   160,   182,   163,    87,   165,    46,    47,    87,
      50,    51,    88,   173,   111,   112,    88,   183,   273,    89,
      96,    54,    43,   135,   184,    56,   185,   140,   141,   150,
     214,   138,   139,   194,    57,   151,   142,   221,    48,   223,
     176,    49,   176,   203,   136,   254,   206,   208,   189,   210,
     102,   103,   152,   167,   104,   215,    87,   105,   153,   167,
     167,   240,   145,    88,    44,   183,    93,   168,   217,   169,
     218,   197,   184,    72,   185,    45,    73,    74,   245,   244,
      75,   176,   167,   190,   191,   235,     1,     2,     3,     4,
     260,   167,   125,   126,     5,     6,     7,     8,     9,   300,
     111,   112,    52,    10,    11,    12,    13,    14,    15,    16,
      17,    76,    58,    18,    77,   253,    78,   102,   103,    79,
      59,   104,    60,    19,   105,   279,    64,    61,    65,    66,
     295,   293,    67,    62,    82,    84,   296,    83,    85,   116,
     140,   141,   117,   270,   119,    68,   274,   120,   294,   297,
     255,    81,   257,    86,   154,   155,   174,   175,   212,   213,
     242,   243,   252,    96,    96,   267,   268,    96,   269,   276,
     277,   292,   293,    98,    99,   100,   108,   101,   109,   148,
     110,   122,   140,   158,   161,   282,   283,   303,   124,   132,
     134,   149,   170,   137,   188,   143,   144,   171,   192,   193,
     211,   172,   195,   196,   198,   199,   201,   290,   299,   200,
     281,   251,   202,   204,   205,   207,   209,   216,   219,   226,
     220,   222,   224,   227,   225,   228,   231,   229,   234,   230,
     232,   241,   233,   236,   248,   237,    69,   238,   239,   256,
     246,   247,   259,   262,   249,   250,   258,   261,   263,   264,
     265,   266,   272,   275,   280,   284,   285,   167,   286,   287,
     291,   269,   301,   288,     0,   289,     0,     0,   302
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-133)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
      71,   133,   131,   108,   133,   107,    16,    54,    55,    56,
      16,    32,   118,    17,   121,    31,   123,     7,     8,    31,
       7,     8,    38,   130,     9,    10,    38,    31,    31,    41,
      33,    41,    32,    17,    38,    41,    40,    18,    19,    32,
     169,    88,    89,   145,    41,    38,    93,   179,    38,   181,
     179,    41,   181,   159,    38,    40,   162,   164,    39,   166,
      28,    29,    32,    32,    32,   172,    31,    35,    38,    32,
      32,    40,    40,    38,     7,    31,    41,    40,    40,    42,
      42,   152,    38,    38,    40,     7,    41,    38,   220,   218,
      41,   220,    32,   140,   141,   201,     3,     4,     5,     6,
      40,    32,    31,    32,    11,    12,    13,    14,    15,    40,
       9,    10,     7,    20,    21,    22,    23,    24,    25,    26,
      27,    38,    41,    30,    41,   230,    38,    28,    29,    41,
      41,    32,    41,    40,    35,   264,    20,    41,    22,    23,
      31,    32,    26,    40,    38,    38,    37,    41,    41,    35,
      18,    19,    38,   258,    35,     0,   261,    38,   287,   288,
     231,    38,   233,    41,    31,    32,    31,    32,    31,    32,
      31,    32,    32,    33,    33,    39,    40,    33,    34,    31,
      32,    31,    32,    32,    32,    31,    41,    31,    41,    32,
      41,    38,    18,    35,    35,   266,   267,   302,    38,    38,
      38,    32,    32,    40,    31,    41,    41,    39,    31,    31,
      31,    40,    40,    32,    32,    40,    40,   285,   289,    39,
     265,   229,    39,    39,    39,    39,    39,    39,    39,    31,
      40,    39,    39,    31,    40,    39,    31,    40,    31,    40,
      40,    31,    39,    39,    31,    39,    21,    39,    39,    31,
      39,    39,    31,    31,    40,    40,    40,    40,    31,    40,
      40,    31,    31,    39,    32,    31,    40,    32,    40,    40,
      31,    34,    31,    40,    -1,    39,    -1,    -1,    40
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,    11,    12,    13,    14,    15,
      20,    21,    22,    23,    24,    25,    26,    27,    30,    40,
      44,    45,    46,    48,    58,    61,    65,    67,    68,    71,
      78,    85,    86,    87,    88,    89,    90,    93,    94,    95,
      96,    99,    32,    32,     7,     7,     7,     8,    38,    41,
       7,     8,     7,    16,    41,    16,    41,    41,    41,    41,
      41,    41,    40,   100,    20,    22,    23,    26,     0,    44,
      47,    49,    38,    41,    38,    41,    38,    41,    38,    41,
      92,    38,    38,    41,    38,    41,    41,    31,    38,    41,
      64,    66,    64,    41,    64,    64,    33,    51,    32,    32,
      31,    31,    28,    29,    32,    35,    97,    98,    41,    41,
      41,     9,    10,    50,    50,    59,    35,    38,    62,    35,
      38,    73,    38,    75,    38,    31,    32,    54,    69,    70,
      91,    80,    38,    82,    38,    17,    38,    40,    64,    64,
      18,    19,    64,    41,    41,    40,    97,    51,    32,    32,
      32,    38,    32,    38,    31,    32,    56,    57,    35,    60,
      56,    35,    63,    69,    72,    69,    74,    32,    40,    42,
      32,    39,    40,    69,    31,    32,    54,    76,    77,    79,
      76,    81,    17,    31,    38,    40,    83,    84,    31,    39,
      64,    64,    31,    31,    97,    40,    32,    50,    32,    40,
      39,    40,    39,    56,    39,    39,    56,    39,    69,    39,
      69,    31,    31,    32,    54,    69,    39,    40,    42,    39,
      40,    76,    39,    76,    39,    40,    31,    31,    39,    40,
      40,    31,    40,    39,    31,    56,    39,    39,    39,    39,
      40,    31,    31,    32,    54,    76,    39,    39,    31,    40,
      40,    83,    32,    51,    40,    50,    31,    50,    40,    31,
      40,    40,    31,    31,    40,    40,    31,    39,    40,    34,
      51,    52,    31,    31,    51,    39,    31,    32,    53,    54,
      32,    53,    50,    50,    31,    40,    40,    40,    40,    39,
      52,    31,    31,    32,    54,    31,    37,    54,    55,    50,
      40,    31,    40,    51
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
#line 101 "parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 102 "parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 103 "parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 104 "parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 105 "parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 106 "parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 107 "parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 108 "parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 109 "parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 110 "parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 111 "parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 112 "parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 113 "parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 114 "parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 115 "parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 116 "parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 117 "parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 118 "parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 119 "parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 120 "parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 125 "parser.y"
    { 
	struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
	file_setInputFile(file);
	current_file=file;
	free((yyvsp[(2) - (2)].string));
}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 130 "parser.y"
    {
	current_file=NULL;
}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 134 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
	file_setOutputFile(file);
	current_file=file;
	free((yyvsp[(2) - (2)].string));
}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 139 "parser.y"
    {
	current_file=NULL;
}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 143 "parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 144 "parser.y"
    {
	if (current_file!=NULL) {
		file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[(2) - (3)].string)));
	}
	free((yyvsp[(2) - (3)].string));
}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 150 "parser.y"
    {
	if (current_file!=NULL) {
		file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[(3) - (5)].string)));
	}
	free((yyvsp[(3) - (5)].string));
}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 157 "parser.y"
    {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat((yyvsp[(2) - (7)].string)));
		file_setRecordLength(current_file,(yyvsp[(4) - (7)].number));
		file_setMaxLength(current_file,(yyvsp[(6) - (7)].number));
	}
	free((yyvsp[(2) - (7)].string));
}
    break;

  case 32:
/* Line 1792 of yacc.c  */
#line 165 "parser.y"
    {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat((yyvsp[(2) - (5)].string)));
		file_setRecordLength(current_file,(yyvsp[(4) - (5)].number));
		file_setMaxLength(current_file,(yyvsp[(4) - (5)].number));
	}
	free((yyvsp[(2) - (5)].string));
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 173 "parser.y"
    {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (9)].string)));
		file_setRecordLength(current_file,(yyvsp[(5) - (9)].number));
		file_setMaxLength(current_file,(yyvsp[(7) - (9)].number));
	}
	free((yyvsp[(3) - (9)].string));
}
    break;

  case 34:
/* Line 1792 of yacc.c  */
#line 181 "parser.y"
    {
	if (current_file!=NULL) {
		file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (7)].string)));
		file_setRecordLength(current_file,(yyvsp[(5) - (7)].number));
		file_setMaxLength(current_file,(yyvsp[(5) - (7)].number));
	}
	free((yyvsp[(3) - (7)].string));
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 192 "parser.y"
    {
	(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
	free((yyvsp[(1) - (1)].string));
}
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 197 "parser.y"
    {
	(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
}
    break;

  case 37:
/* Line 1792 of yacc.c  */
#line 202 "parser.y"
    {
	(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
	free((yyvsp[(1) - (1)].string));
}
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 207 "parser.y"
    {
	(yyval.fieldValue)=fieldValue_constructor((yyvsp[(1) - (2)].string),(yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
	free((yyvsp[(1) - (2)].string));
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 211 "parser.y"
    {
	(yyval.fieldValue)=fieldValue_constructor2((char*)(yyvsp[(1) - (2)].number),(yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 216 "parser.y"
    {
		char szType[] = "Z";
		(yyval.string)=(char *)fieldValue_constructor(szType,(yyvsp[(1) - (1)].string), TYPE_STRUCT_NEW);		// flag 3° for value
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 222 "parser.y"
    {}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 223 "parser.y"
    {}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 226 "parser.y"
    {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor((yyvsp[(1) - (5)].number),(yyvsp[(3) - (5)].number),0, (yyvsp[(5) - (5)].number));
				sortField_addDefinition(sortField);
				nTypeFormat = 1;
			}
		}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 234 "parser.y"
    {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),(yyvsp[(5) - (7)].number),(yyvsp[(7) - (7)].number));
				sortField_addDefinition(sortField);
				//-->> nTypeFormat = 1; // Format external token
			}
		}
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 242 "parser.y"
    {
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
		}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 249 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 251 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('S');		// for Sort
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 255 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 257 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('S');
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 261 "parser.y"
    {
			job_SetTypeOP('M');		// for Merge
			job_SetFieldCopy(1);
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 265 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 270 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 272 "parser.y"
    {
			current_sortField=0;
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');

}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 278 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 280 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('M');
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 284 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 288 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 295 "parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 298 "parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 301 "parser.y"
    {
		(yyval.condField)=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 304 "parser.y"
    {
		(yyval.condField)=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 309 "parser.y"
    {
//-->>nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
//-->>nTypeIncludeOmit;		// 0= Nothing, 1 = Include, 2 = Omit

			if (nTypeFormat == 1)
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
			if (nTypeFormat == 2)
				condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(3) - (3)].number));
			if (nTypeFormat == 3)	// for SumFields
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 321 "parser.y"
    {
			if (nTypeFormat == 1)
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(4) - (4)].number));
			if (nTypeFormat == 2)
				condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(4) - (4)].number));
			if (nTypeFormat == 3)	// for SumFields
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(4) - (4)].number));

}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 336 "parser.y"
    {
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 340 "parser.y"
    {    
			struct fieldValue_t *fieldValue_temp;
			char szType[] = "Z";
			char* pszInt;
			pszInt = (char*) malloc(32);		// 
			// itoa($9, pszInt, 10);
			sprintf(pszInt, "%ld", (yyvsp[(9) - (9)].number));
			fieldValue_temp=fieldValue_constructor(szType, pszInt, TYPE_STRUCT_NEW);		// flag 3° for value
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),fieldValue_temp);
}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 351 "parser.y"
    {    
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].string));
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 355 "parser.y"
    {
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),utils_parseFieldType((yyvsp[(5) - (9)].string)),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
			//-->> nTypeFormat = 2; // Format external token
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 359 "parser.y"
    {
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(int)(yyvsp[(5) - (9)].string),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].number));
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 362 "parser.y"
    {
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0, utils_parseCondCondition((yyvsp[(5) - (7)].string)),(yyvsp[(7) - (7)].fieldValue));
			nTypeFormat = 2; // Format external token
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 367 "parser.y"
    {
			(yyval.condField)=condField_constructor_conditionfield((yyvsp[(1) - (13)].number),(yyvsp[(3) - (13)].number),(yyvsp[(5) - (13)].number),(yyvsp[(7) - (13)].number),(yyvsp[(9) - (13)].number),(yyvsp[(11) - (13)].number),(yyvsp[(13) - (13)].number));
			nTypeFormat = 2; // Format external token
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 373 "parser.y"
    {
			condField_addOmit((yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 2;
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 377 "parser.y"
    {
			condField_addOmit((yyvsp[(4) - (4)].condField));
			nTypeIncludeOmit = 2;
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 383 "parser.y"
    {
			condField_addInclude((yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 387 "parser.y"
    {
			condField_addInclude((yyvsp[(4) - (4)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 395 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 396 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 398 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}
		else
		{
			struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}

}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 420 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change_position((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].fieldValue));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->change_position.fieldValue->generated_length;
		}
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 432 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
			if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
				nPosAbsRec = (yyvsp[(1) - (3)].number);		// 
			outrec_addDefinition(outrec);
		}
}
    break;

  case 80:
/* Line 1792 of yacc.c  */
#line 441 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
			nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
			outrec_addDefinition(outrec);
		}
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 448 "parser.y"
    {    
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_subst((yyvsp[(1) - (1)].string));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
		}
		// new		
		free((yyvsp[(1) - (1)].string));
		// new
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 462 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
		}
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 474 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}
		else
		{
			struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec += outrec->range.length;
		}
}
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 496 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 498 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 501 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 503 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 506 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 508 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 511 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 513 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 518 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 519 "parser.y"
    {	nPosAbsRec = -1; }
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 521 "parser.y"
    {
		if (current_inrec==1) {
				struct inrec_t *inrec=inrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
				nPosAbsRec += inrec->range.length;
				inrec_addDefinition(inrec);
		}
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 528 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change_position((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].fieldValue));
			nPosAbsRec += inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 536 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
			if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
				nPosAbsRec = (yyvsp[(1) - (3)].number);		// - inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 545 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
			nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
			inrec_addDefinition(inrec);
		}
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 552 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_subst((yyvsp[(1) - (1)].string));
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
}
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 559 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 568 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 570 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 573 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 575 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 578 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 580 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 583 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 585 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 593 "parser.y"
    {}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 594 "parser.y"
    {}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 596 "parser.y"
    { 
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (4)].number), (yyvsp[(4) - (4)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 601 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (4)].number), (yyvsp[(4) - (4)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 606 "parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 614 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (5)].number), (yyvsp[(4) - (5)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 619 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 624 "parser.y"
    {
 			struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
 			SumField_addDefinition(SumField); 
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 629 "parser.y"
    {
			SumField_setFunction(1);
}
    break;

  case 117:
/* Line 1792 of yacc.c  */
#line 632 "parser.y"
    {
			SumField_setFunction(1);
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 635 "parser.y"
    {
			SumField_setFunction(2);
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 642 "parser.y"
    {
		//printf("ENGSORT: Warning Token skipped : %s\n",yylval.string);
}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 647 "parser.y"
    {

	struct file_t *file=file_constructor((yyvsp[(3) - (3)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(3) - (3)].string));
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 653 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(4) - (4)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(4) - (4)].string));
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 660 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(3) - (3)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(3) - (3)].string));
}
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 665 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(4) - (4)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(4) - (4)].string));
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 672 "parser.y"
    {
			if (current_outfil != NULL)
				setOutfilIncludeCondField(current_outfil, (yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 680 "parser.y"
    {
			if (current_outfil != NULL)
				setOutfilOmitCondField(current_outfil, (yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 687 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 689 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 128:
/* Line 1792 of yacc.c  */
#line 692 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 694 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 699 "parser.y"
    {
			struct outfil_t *outfil=outfil_constructor();
			if (current_outfil == NULL)
				outfil_addDefinition(outfil); 
			else 
				outfil_addDefinition(outfil); 
			current_outfil=outfil; 
			nstate_outfil=1;
}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 710 "parser.y"
    {
			if (current_outfil != NULL)
				outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
}
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 716 "parser.y"
    {
			if (current_outfil != NULL)
				outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
}
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 722 "parser.y"
    {
			if (current_outfil != NULL)
				outfil_SetSave(current_outfil);
}
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 726 "parser.y"
    {
			if (current_outfil != NULL)
				outfil_SetSave(current_outfil);
}
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 730 "parser.y"
    {
			if (current_outfil != NULL)
				outfil_SetSave(current_outfil);
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 737 "parser.y"
    {}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 738 "parser.y"
    {}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 739 "parser.y"
    {}
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 741 "parser.y"
    {
	job_SetOptionSort((yyvsp[(1) - (1)].string));
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 744 "parser.y"
    {
	job_SetOptionSort("COPY");
}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 747 "parser.y"
    {
	job_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 750 "parser.y"
    {
	job_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 755 "parser.y"
    {
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 756 "parser.y"
    {
}
    break;


/* Line 1792 of yacc.c  */
#line 2984 "parser.c"
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
#line 761 "parser.y"

