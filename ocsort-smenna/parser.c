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
     STRING = 286,
     XFIELDTYPE = 287,
     CHARTYPE = 288,
     DIGIT = 289,
     ORDER = 290,
     COPY = 291,
     LITERAL = 292,
     SIGNDIGITBIG = 293
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 23 "parser.y"
 
	int number;
	long lnumber;
	long long llnumber;
	char *string;
	char character;
	struct condField_t  *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t   *SumField;


/* Line 387 of yacc.c  */
#line 161 "parser.c"
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
#line 189 "parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 33 "parser.y"

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#ifdef _MSC_VER
		#include <io.h>
	#else
		#include <stdlib.h> 
		#include <unistd.h>
	#endif
	#include "ocsort.h"
	#include "file.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "sumfield.h"
	#include "utils.h"
	int yylex (void);
	void yyerror (char const *);

	struct file_t*		current_file=NULL;
	struct outfil_t*	current_outfil=NULL;
	struct condField_t*	condField=NULL;

	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
	int nPosAbsRec=0;
	int nRtc=0;
	char* pszInt;

	extern int nTypeFieldsCmd;
	char szTmp[5];
	char szPath[260];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;



/* Line 391 of yacc.c  */
#line 239 "parser.c"

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
#define YYLAST   285

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  44
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  58
/* YYNRULES -- Number of rules.  */
#define YYNRULES  148
/* YYNRULES -- Number of states.  */
#define YYNSTATES  306

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   293

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      39,    40,     2,     2,    41,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    43,     2,
       2,    42,     2,     2,     2,     2,     2,     2,     2,     2,
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
      35,    36,    37,    38
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
     114,   117,   120,   122,   124,   126,   130,   136,   144,   146,
     147,   154,   155,   163,   168,   175,   176,   183,   184,   192,
     199,   204,   206,   210,   214,   218,   222,   227,   237,   247,
     255,   263,   277,   281,   286,   290,   295,   297,   301,   305,
     311,   313,   317,   319,   321,   324,   325,   333,   334,   341,
     342,   350,   351,   358,   360,   364,   368,   372,   376,   382,
     384,   386,   388,   389,   397,   398,   405,   406,   414,   415,
     422,   424,   428,   433,   438,   446,   452,   456,   462,   467,
     474,   481,   483,   487,   492,   496,   501,   505,   509,   510,
     517,   518,   524,   526,   530,   534,   536,   539,   542,   544,
     548,   551,   553,   555,   559,   563,   567,   571,   572
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      45,     0,    -1,    -1,    46,    45,    -1,    47,    -1,    66,
      -1,    49,    -1,    59,    -1,    62,    -1,    68,    -1,    69,
      -1,    72,    -1,    79,    -1,    86,    -1,    87,    -1,    94,
      -1,    88,    -1,    89,    -1,    90,    -1,    91,    -1,    95,
      -1,    96,    -1,    97,    -1,   100,    -1,    -1,     3,    31,
      48,    51,    -1,    -1,     4,    31,    50,    51,    -1,    -1,
      10,    31,    51,    -1,    10,    39,    31,    40,    51,    -1,
       9,    31,    41,    34,    41,    34,    51,    -1,     9,    31,
      41,    34,    51,    -1,     9,    39,    31,    41,    34,    41,
      34,    40,    51,    -1,     9,    39,    31,    41,    34,    40,
      51,    -1,    32,    -1,    35,    -1,    31,    -1,    33,    31,
      -1,    34,    31,    -1,    34,    33,    -1,    31,    31,    -1,
      34,    -1,    38,    -1,    58,    -1,    58,    41,    57,    -1,
      34,    41,    34,    41,    53,    -1,    34,    41,    34,    41,
      52,    41,    53,    -1,    31,    -1,    -1,     5,     7,    39,
      60,    57,    40,    -1,    -1,     5,     7,    42,    39,    61,
      57,    40,    -1,     5,     7,    42,    36,    -1,     5,     7,
      42,    39,    36,    40,    -1,    -1,     6,     7,    39,    63,
      57,    40,    -1,    -1,     6,     7,    42,    39,    64,    57,
      40,    -1,     6,     7,    42,    39,    36,    40,    -1,     6,
       7,    42,    36,    -1,    67,    -1,    39,    65,    40,    -1,
      65,    18,    65,    -1,    65,    19,    65,    -1,    20,    42,
      52,    -1,    41,    20,    42,    52,    -1,    34,    41,    34,
      41,    52,    41,    54,    41,    55,    -1,    34,    41,    34,
      41,    52,    41,    54,    41,    56,    -1,    34,    41,    34,
      41,    54,    41,    56,    -1,    34,    41,    34,    41,    54,
      41,    55,    -1,    34,    41,    34,    41,    52,    41,    54,
      41,    34,    41,    34,    41,    52,    -1,    15,    16,    65,
      -1,    15,    16,    42,    65,    -1,    14,    16,    65,    -1,
      14,    16,    42,    65,    -1,    71,    -1,    71,    41,    70,
      -1,    34,    41,    34,    -1,    34,    43,    34,    41,    34,
      -1,    31,    -1,    34,    43,    33,    -1,    33,    -1,    55,
      -1,    34,    41,    -1,    -1,    11,     7,    42,    39,    73,
      70,    40,    -1,    -1,    11,     7,    39,    74,    70,    40,
      -1,    -1,    11,     8,    42,    39,    75,    70,    40,    -1,
      -1,    11,     8,    39,    76,    70,    40,    -1,    78,    -1,
      78,    41,    77,    -1,    34,    41,    34,    -1,    34,    43,
      55,    -1,    34,    43,    33,    -1,    34,    43,    34,    41,
      34,    -1,    31,    -1,    33,    -1,    55,    -1,    -1,    12,
       7,    42,    39,    80,    77,    40,    -1,    -1,    12,     7,
      39,    81,    77,    40,    -1,    -1,    12,     8,    42,    39,
      82,    77,    40,    -1,    -1,    12,     8,    39,    83,    77,
      40,    -1,    85,    -1,    85,    41,    84,    -1,    39,    34,
      41,    34,    -1,    41,    34,    41,    34,    -1,    34,    41,
      34,    41,    34,    41,    34,    -1,    41,    34,    41,    34,
      40,    -1,    34,    41,    34,    -1,    34,    41,    34,    41,
      52,    -1,    13,     7,    42,    17,    -1,    13,     7,    42,
      39,    17,    40,    -1,    13,     7,    42,    39,    84,    40,
      -1,    30,    -1,    22,    42,    31,    -1,    41,    22,    42,
      31,    -1,    23,    42,    31,    -1,    41,    23,    42,    31,
      -1,    14,    42,    65,    -1,    15,    42,    65,    -1,    -1,
      11,    42,    39,    92,    70,    40,    -1,    -1,    11,    39,
      93,    70,    40,    -1,    21,    -1,    24,    42,    38,    -1,
      25,    42,    38,    -1,    26,    -1,    26,    41,    -1,    41,
      26,    -1,    99,    -1,    99,    41,    98,    -1,    99,    98,
      -1,    31,    -1,    36,    -1,    28,    42,    38,    -1,    28,
      42,    34,    -1,    29,    42,    38,    -1,    29,    42,    34,
      -1,    -1,    27,   101,    98,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   127,   127,   128,   130,   131,   132,   133,   134,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,   148,   149,   154,   154,   163,   163,   172,   173,
     181,   187,   195,   203,   211,   221,   226,   232,   237,   242,
     250,   257,   265,   271,   280,   281,   284,   292,   300,   309,
     309,   315,   315,   321,   325,   331,   331,   339,   339,   345,
     349,   356,   359,   362,   366,   372,   383,   400,   404,   410,
     415,   423,   430,   434,   440,   444,   450,   451,   453,   476,
     488,   500,   514,   526,   541,   563,   563,   568,   568,   573,
     573,   578,   578,   585,   586,   589,   596,   604,   615,   622,
     632,   641,   650,   650,   655,   655,   660,   660,   665,   665,
     675,   676,   678,   683,   688,   696,   701,   706,   711,   714,
     717,   724,   729,   735,   742,   747,   754,   762,   769,   769,
     774,   774,   781,   792,   798,   804,   808,   812,   819,   820,
     821,   823,   827,   830,   833,   836,   839,   844,   844
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
  "\"STOPAFT clause\"", "\"TOKSKIP clause\"", "\"STRING\"",
  "\"XFIELDTYPE\"", "\"CHARTYPE\"", "\"DIGIT\"", "\"ORDER\"", "\"COPY\"",
  "\"LITERAL\"", "\"SIGNDIGITBIG\"", "'('", "')'", "','", "'='", "':'",
  "$accept", "beginning", "clause", "useclause", "$@1", "giveclause",
  "$@2", "recordorginstruction", "fieldtype", "fielddirection",
  "fieldcondition", "fieldvalue", "fieldvalueconst", "allsortfield",
  "sortfield", "sortclause", "$@3", "$@4", "mergeclause", "$@5", "$@6",
  "allcondfield", "formatclause", "condfield", "omitclause",
  "includeclause", "alloutrec", "outrec", "outrecclause", "$@7", "$@8",
  "$@9", "$@10", "allinrec", "inrec", "inrecclause", "$@11", "$@12",
  "$@13", "$@14", "allsumfield", "sumfield", "sumclause", "tokskipclause",
  "fnamesclause", "filesclause", "outfilincludeclause", "outfilomitclause",
  "$@15", "$@16", "outfilclause", "startrecclause", "endrecclause",
  "saveclause", "alloption", "option", "optionclause", "$@17", YY_NULL
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
     285,   286,   287,   288,   289,   290,   291,   292,   293,    40,
      41,    44,    61,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    44,    45,    45,    46,    46,    46,    46,    46,    46,
      46,    46,    46,    46,    46,    46,    46,    46,    46,    46,
      46,    46,    46,    46,    48,    47,    50,    49,    51,    51,
      51,    51,    51,    51,    51,    52,    53,    54,    55,    55,
      55,    55,    56,    56,    57,    57,    58,    58,    58,    60,
      59,    61,    59,    59,    59,    63,    62,    64,    62,    62,
      62,    65,    65,    65,    65,    66,    66,    67,    67,    67,
      67,    67,    68,    68,    69,    69,    70,    70,    71,    71,
      71,    71,    71,    71,    71,    73,    72,    74,    72,    75,
      72,    76,    72,    77,    77,    78,    78,    78,    78,    78,
      78,    78,    80,    79,    81,    79,    82,    79,    83,    79,
      84,    84,    85,    85,    85,    85,    85,    85,    86,    86,
      86,    87,    88,    88,    89,    89,    90,    91,    92,    72,
      93,    72,    94,    95,    96,    97,    97,    97,    98,    98,
      98,    99,    99,    99,    99,    99,    99,   101,   100
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     4,     0,     4,     0,     3,
       5,     7,     5,     9,     7,     1,     1,     1,     2,     2,
       2,     2,     1,     1,     1,     3,     5,     7,     1,     0,
       6,     0,     7,     4,     6,     0,     6,     0,     7,     6,
       4,     1,     3,     3,     3,     3,     4,     9,     9,     7,
       7,    13,     3,     4,     3,     4,     1,     3,     3,     5,
       1,     3,     1,     1,     2,     0,     7,     0,     6,     0,
       7,     0,     6,     1,     3,     3,     3,     3,     5,     1,
       1,     1,     0,     7,     0,     6,     0,     7,     0,     6,
       1,     3,     4,     4,     7,     5,     3,     5,     4,     6,
       6,     1,     3,     4,     3,     4,     3,     3,     0,     6,
       0,     5,     1,     3,     3,     1,     2,     2,     1,     3,
       2,     1,     1,     3,     3,     3,     3,     0,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   132,     0,     0,     0,     0,   135,   147,   121,     0,
       0,     2,     4,     6,     7,     8,     5,     9,    10,    11,
      12,    13,    14,    16,    17,    18,    19,    15,    20,    21,
      22,    23,    24,    26,     0,     0,     0,     0,   130,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   136,     0,     0,     0,     0,   137,     1,     3,
      28,    28,    49,     0,    55,     0,    87,     0,    91,     0,
       0,   128,   104,     0,   108,     0,     0,     0,     0,     0,
      74,    61,   126,     0,    72,   127,    35,    65,   122,   124,
     133,   134,     0,     0,   141,   142,   148,   138,     0,     0,
       0,     0,     0,    25,    27,     0,    53,    51,     0,    60,
      57,     0,    85,     0,    89,    80,    82,     0,    83,     0,
      76,     0,     0,   102,     0,   106,   118,     0,     0,     0,
      75,     0,     0,    73,     0,     0,     0,   140,    66,   123,
     125,     0,     0,    28,     0,    48,     0,     0,    44,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    41,    38,
      39,    40,    84,     0,   131,     0,     0,    99,   100,     0,
     101,     0,    93,     0,     0,     0,     0,     0,     0,     0,
       0,   110,     0,    62,    63,    64,   144,   143,   146,   145,
     139,     0,     0,    29,     0,     0,    50,     0,    54,     0,
      56,    59,     0,    88,     0,    92,     0,    78,    81,     0,
      77,   129,     0,     0,   105,     0,     0,   109,     0,   119,
       0,     0,     0,   120,     0,     0,    28,     0,    28,     0,
      45,    52,    58,    86,    90,     0,    95,     0,    97,     0,
      96,    94,   103,   107,   116,     0,     0,   111,    37,     0,
       0,     0,    32,     0,    30,     0,    79,     0,     0,   112,
     113,     0,     0,    28,    28,     0,    36,     0,    46,    98,
       0,   117,   115,     0,     0,    42,    43,    70,    69,    31,
      34,     0,     0,     0,     0,    28,    47,   114,    42,    67,
      68,    33,     0,     0,     0,    71
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    20,    21,    22,    70,    23,    71,   113,    97,   278,
     260,   128,   288,   157,   158,    24,   115,   160,    25,   118,
     163,    90,    26,    91,    27,    28,   129,   130,    29,   165,
     121,   167,   123,   181,   182,    30,   183,   132,   185,   134,
     190,   191,    31,    32,    33,    34,    35,    36,   131,    80,
      37,    38,    39,    40,   106,   107,    41,    63
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -132
static const yytype_int16 yypact[] =
{
      95,    -8,    19,    54,    85,     0,    25,   119,   -11,    -4,
      88,  -132,    93,    99,   105,   134,   147,  -132,  -132,   123,
     189,    95,  -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,
    -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,
    -132,  -132,  -132,  -132,    63,   113,   114,   115,  -132,   151,
     120,   121,   150,    46,   -17,    90,   -17,   159,   163,   164,
     155,   158,  -132,    55,   156,   157,   165,  -132,  -132,  -132,
     169,   169,  -132,    39,  -132,   130,  -132,   161,  -132,   166,
      56,  -132,  -132,   167,  -132,   170,    -2,   160,   -17,   -17,
     162,  -132,   162,   -17,   162,   162,  -132,  -132,  -132,  -132,
    -132,  -132,   168,   171,  -132,  -132,  -132,    -1,   159,   173,
     177,   -18,    73,  -132,  -132,   137,  -132,   175,   137,  -132,
     176,    56,  -132,    56,  -132,   183,   184,    33,  -132,   178,
     179,    56,    80,  -132,    80,  -132,  -132,    24,   182,     6,
     162,   -17,   -17,   162,    34,    89,    55,  -132,  -132,  -132,
    -132,   180,   186,   169,   188,  -132,   181,   185,   187,   190,
     137,   191,   192,   137,   193,    56,   194,    56,  -132,  -132,
    -132,  -132,   195,   149,  -132,    56,   196,   183,   184,    36,
    -132,   197,   198,    80,   200,    80,   201,   202,   204,   208,
     205,   203,   206,  -132,  -132,   209,  -132,  -132,  -132,  -132,
    -132,   212,   207,  -132,   210,   215,  -132,   137,  -132,   211,
    -132,  -132,   213,  -132,   214,  -132,   216,  -132,  -132,   217,
    -132,  -132,   218,   117,  -132,    80,   219,  -132,   220,  -132,
     221,   222,   223,  -132,    -5,   153,    10,   227,   169,   224,
    -132,  -132,  -132,  -132,  -132,   228,  -132,   183,   184,    16,
    -132,  -132,  -132,  -132,   225,   233,   234,  -132,  -132,   229,
     230,   235,  -132,   146,  -132,   138,  -132,   238,   140,  -132,
     236,   226,   100,   169,   169,   239,  -132,   237,  -132,  -132,
     240,  -132,  -132,   241,   184,   144,  -132,  -132,  -132,  -132,
    -132,   243,   242,   245,   106,   169,  -132,  -132,    40,  -132,
    -132,  -132,   246,   244,   159,  -132
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -132,   253,  -132,  -132,  -132,  -132,  -132,   -71,  -107,   -69,
     -36,  -130,   -68,  -104,  -132,  -132,  -132,  -132,  -132,  -132,
    -132,   -45,  -132,  -132,  -132,  -132,  -105,  -132,  -132,  -132,
    -132,  -132,  -132,  -131,  -132,  -132,  -132,  -132,  -132,  -132,
      41,  -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,  -132,
    -132,  -132,  -132,  -132,  -101,  -132,  -132,  -132
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     114,   148,   180,   184,   180,    53,   147,    46,    47,    92,
      94,    95,    55,   151,   161,   136,   164,    87,   166,   111,
     112,   152,    88,    42,   141,   142,   176,   102,   103,   187,
     104,    54,    50,    51,   188,   105,   189,   137,    56,    48,
     146,   186,    49,   139,   140,   200,   193,   170,   143,   171,
      43,   261,   226,   180,   228,   180,   209,   267,   187,   212,
     214,    44,   216,   188,   170,   189,   171,   170,   196,   171,
     220,   170,   197,   171,   172,   116,   173,   222,   117,   223,
      87,   302,   203,   102,   103,    88,   104,   125,    89,   126,
     127,   105,    45,   250,   251,   180,   194,   195,     1,     2,
       3,     4,    72,   240,   153,    73,     5,     6,     7,     8,
       9,   177,   154,   178,   179,    10,    11,    12,    13,    14,
      15,    16,    17,   198,    87,    18,    52,   199,   259,    88,
      57,   247,    93,   284,   285,    58,    19,   247,   286,   284,
     298,    59,   287,    64,   286,    65,    66,    60,   247,    67,
     248,   249,    74,    76,    78,    75,    77,    79,   277,    82,
      84,   281,    83,    85,   299,   262,   119,   264,   155,   120,
      96,   156,    96,   276,   280,   170,    61,   171,   111,   112,
     141,   142,   218,   219,   258,    96,   274,   275,    62,    68,
      81,    96,    86,   100,    98,    99,   101,   305,   108,   109,
     122,   138,   289,   290,   149,   124,   133,   110,   150,   135,
     144,   159,   162,   145,   168,   169,   192,   202,   174,   204,
     175,   201,   205,   296,   301,   206,   300,   141,   207,   217,
     208,   210,   211,   213,   215,   283,   221,   224,   231,   225,
     227,   229,   232,   230,   234,   233,   236,   235,   237,   239,
     238,   241,   246,   242,   243,   254,   244,   258,   245,   252,
     253,   263,   266,   255,   256,   265,   268,   269,   270,   273,
     271,   272,   279,   291,    69,   257,   282,   276,   292,   297,
     303,   293,   294,   295,     0,   304
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-132)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
      71,   108,   132,   134,   134,    16,   107,     7,     8,    54,
      55,    56,    16,    31,   118,    17,   121,    34,   123,     9,
      10,    39,    39,    31,    18,    19,   131,    28,    29,    34,
      31,    42,     7,     8,    39,    36,    41,    39,    42,    39,
      41,    17,    42,    88,    89,   146,    40,    31,    93,    33,
      31,    41,   183,   183,   185,   185,   160,    41,    34,   163,
     165,     7,   167,    39,    31,    41,    33,    31,    34,    33,
     175,    31,    38,    33,    41,    36,    43,    41,    39,    43,
      34,    41,   153,    28,    29,    39,    31,    31,    42,    33,
      34,    36,     7,   223,   225,   225,   141,   142,     3,     4,
       5,     6,    39,   207,    31,    42,    11,    12,    13,    14,
      15,    31,    39,    33,    34,    20,    21,    22,    23,    24,
      25,    26,    27,    34,    34,    30,     7,    38,   235,    39,
      42,    31,    42,    33,    34,    42,    41,    31,    38,    33,
      34,    42,   272,    20,    38,    22,    23,    42,    31,    26,
      33,    34,    39,    39,    39,    42,    42,    42,   265,    39,
      39,   268,    42,    42,   294,   236,    36,   238,    31,    39,
      32,    34,    32,    35,    34,    31,    42,    33,     9,    10,
      18,    19,    33,    34,    31,    32,    40,    41,    41,     0,
      39,    32,    42,    38,    31,    31,    38,   304,    42,    42,
      39,    41,   273,   274,    31,    39,    39,    42,    31,    39,
      42,    36,    36,    42,    31,    31,    34,    31,    40,    31,
      41,    41,    41,   292,   295,    40,   294,    18,    41,    34,
      40,    40,    40,    40,    40,   271,    40,    40,    34,    41,
      40,    40,    34,    41,    41,    40,    34,    41,    41,    34,
      40,    40,    34,    40,    40,    34,    40,    31,    41,    40,
      40,    34,    34,    41,    41,    41,    41,    34,    34,    34,
      41,    41,    34,    34,    21,   234,    40,    35,    41,    34,
      34,    41,    41,    40,    -1,    41
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,    11,    12,    13,    14,    15,
      20,    21,    22,    23,    24,    25,    26,    27,    30,    41,
      45,    46,    47,    49,    59,    62,    66,    68,    69,    72,
      79,    86,    87,    88,    89,    90,    91,    94,    95,    96,
      97,   100,    31,    31,     7,     7,     7,     8,    39,    42,
       7,     8,     7,    16,    42,    16,    42,    42,    42,    42,
      42,    42,    41,   101,    20,    22,    23,    26,     0,    45,
      48,    50,    39,    42,    39,    42,    39,    42,    39,    42,
      93,    39,    39,    42,    39,    42,    42,    34,    39,    42,
      65,    67,    65,    42,    65,    65,    32,    52,    31,    31,
      38,    38,    28,    29,    31,    36,    98,    99,    42,    42,
      42,     9,    10,    51,    51,    60,    36,    39,    63,    36,
      39,    74,    39,    76,    39,    31,    33,    34,    55,    70,
      71,    92,    81,    39,    83,    39,    17,    39,    41,    65,
      65,    18,    19,    65,    42,    42,    41,    98,    52,    31,
      31,    31,    39,    31,    39,    31,    34,    57,    58,    36,
      61,    57,    36,    64,    70,    73,    70,    75,    31,    31,
      31,    33,    41,    43,    40,    41,    70,    31,    33,    34,
      55,    77,    78,    80,    77,    82,    17,    34,    39,    41,
      84,    85,    34,    40,    65,    65,    34,    38,    34,    38,
      98,    41,    31,    51,    31,    41,    40,    41,    40,    57,
      40,    40,    57,    40,    70,    40,    70,    34,    33,    34,
      70,    40,    41,    43,    40,    41,    77,    40,    77,    40,
      41,    34,    34,    40,    41,    41,    34,    41,    40,    34,
      57,    40,    40,    40,    40,    41,    34,    31,    33,    34,
      55,    77,    40,    40,    34,    41,    41,    84,    31,    52,
      54,    41,    51,    34,    51,    41,    34,    41,    41,    34,
      34,    41,    41,    34,    40,    41,    35,    52,    53,    34,
      34,    52,    40,    54,    33,    34,    38,    55,    56,    51,
      51,    34,    41,    41,    41,    40,    53,    34,    34,    55,
      56,    51,    41,    34,    41,    52
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
#line 130 "parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 131 "parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 132 "parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 133 "parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 134 "parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 135 "parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 136 "parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 137 "parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 138 "parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 139 "parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 140 "parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 141 "parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 142 "parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 143 "parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 144 "parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 145 "parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 146 "parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 147 "parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 148 "parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 149 "parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 154 "parser.y"
    { 
	struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
	file_setInputFile(file);
	current_file=file;
	free((yyvsp[(2) - (2)].string));
}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 159 "parser.y"
    {
	current_file=NULL;
}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 163 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
	file_setOutputFile(file);
	current_file=file;
	free((yyvsp[(2) - (2)].string));
}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 168 "parser.y"
    {
	current_file=NULL;
}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 172 "parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 173 "parser.y"
    {
	if (current_file!=NULL) {
		nRtc = file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[(2) - (3)].string)));
		if (nRtc == -1)
			exit(OC_RTC_ERROR);
	}
	free((yyvsp[(2) - (3)].string));
}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 181 "parser.y"
    {
	if (current_file!=NULL) {
		file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[(3) - (5)].string)));
	}
	free((yyvsp[(3) - (5)].string));
}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 187 "parser.y"
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
#line 195 "parser.y"
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
#line 203 "parser.y"
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
#line 211 "parser.y"
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
#line 221 "parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 226 "parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 37:
/* Line 1792 of yacc.c  */
#line 232 "parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 237 "parser.y"
    {
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 242 "parser.y"
    {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[(1) - (2)].number));
		(yyval.fieldValue)=fieldValue_constr_newF((char*)pszInt, (char*)(yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		free((yyvsp[(2) - (2)].string)); 
		(pszInt); 
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 250 "parser.y"
    {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[(1) - (2)].number));
		(yyval.fieldValue)=fieldValue_constr_newF((char*)pszInt, (char*)(yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		free((yyvsp[(2) - (2)].string)); 
		free(pszInt); 
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 257 "parser.y"
    {
		(yyval.fieldValue)=fieldValue_constructor((yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 265 "parser.y"
    {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[(1) - (1)].number));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)"Z",pszInt, TYPE_STRUCT_STD);
		free(pszInt); 
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 271 "parser.y"
    {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%lld", (yyvsp[(1) - (1)].llnumber));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);
		free(pszInt); 
}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 280 "parser.y"
    {}
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 281 "parser.y"
    {}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 284 "parser.y"
    {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor((yyvsp[(1) - (5)].number),(yyvsp[(3) - (5)].number),0, (yyvsp[(5) - (5)].number));
				sortField_addDefinition(sortField);
				nTypeFormat = 1;
			}
		}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 292 "parser.y"
    {
			if (current_sortField==1) {
				struct sortField_t *sortField;
				sortField=sortField_constructor((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),(yyvsp[(5) - (7)].number),(yyvsp[(7) - (7)].number));
				sortField_addDefinition(sortField);
				//-->> nTypeFormat = 1; // Format external token
			}
		}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 300 "parser.y"
    {
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');
			job_SetFieldCopy(1);

			free((yyvsp[(1) - (1)].string)); //201512
		}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 309 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 311 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('S');		// for Sort
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 315 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 317 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('S');
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 321 "parser.y"
    {
			job_SetTypeOP('M');		// for Merge
			job_SetFieldCopy(1);
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 325 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 331 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 333 "parser.y"
    {
			current_sortField=0;
			// typeOP = 'M'; // for Merge
			job_SetTypeOP('M');

}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 339 "parser.y"
    {
			current_sortField=1;
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 341 "parser.y"
    {
			current_sortField=0;
			job_SetTypeOP('M');
}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 345 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 349 "parser.y"
    {
			job_SetTypeOP('M');
			job_SetFieldCopy(1);
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 356 "parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 359 "parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 362 "parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 366 "parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 372 "parser.y"
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

  case 66:
/* Line 1792 of yacc.c  */
#line 383 "parser.y"
    {
			if (nTypeFormat == 1)
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(4) - (4)].number));
			if (nTypeFormat == 2)
				condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(4) - (4)].number));
			if (nTypeFormat == 3)	// for SumFields
				condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(4) - (4)].number));

}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 400 "parser.y"
    {    
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));

}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 404 "parser.y"
    {
			(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 410 "parser.y"
    {    
			condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
			nTypeFormat = 2; // Format external token
			(yyval.condField)=condField;
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 415 "parser.y"
    {    
			condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
			nTypeFormat = 2; // Format external token
			(yyval.condField)=condField;
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 423 "parser.y"
    {
			nTypeFormat = 2; // Format external token
			condField=condField_constructor_conditionfield((yyvsp[(1) - (13)].number),(yyvsp[(3) - (13)].number),(yyvsp[(5) - (13)].number),(yyvsp[(7) - (13)].number),(yyvsp[(9) - (13)].number),(yyvsp[(11) - (13)].number),(yyvsp[(13) - (13)].number));
			(yyval.condField)=condField;
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 430 "parser.y"
    {
			condField_addOmit((yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 2;
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 434 "parser.y"
    {
			condField_addOmit((yyvsp[(4) - (4)].condField));
			nTypeIncludeOmit = 2;
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 440 "parser.y"
    {
			condField_addInclude((yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 444 "parser.y"
    {
			condField_addInclude((yyvsp[(4) - (4)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 450 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 451 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 453 "parser.y"
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

  case 79:
/* Line 1792 of yacc.c  */
#line 476 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
			nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
		}
}
    break;

  case 80:
/* Line 1792 of yacc.c  */
#line 488 "parser.y"
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
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 500 "parser.y"
    {
		if (current_outrec==1) {
			struct outrec_t *outrec=outrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
			if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
				nPosAbsRec = (yyvsp[(1) - (3)].number);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
		}
		free((yyvsp[(3) - (3)].string)); 
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 514 "parser.y"
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
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 526 "parser.y"
    {
		// | DIGIT CHARTYPE  {
		if (current_outrec==1) {
			struct outrec_t *outrec;
			outrec=outrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
			nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
			if (nstate_outfil==1) {
				outfil_addoutfilrec(outrec);
			} else {
				outrec_addDefinition(outrec);
			}
		}
	}
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 541 "parser.y"
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

  case 85:
/* Line 1792 of yacc.c  */
#line 563 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 565 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 568 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 570 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 573 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 575 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 578 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 580 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 585 "parser.y"
    {	nPosAbsRec = -1;}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 586 "parser.y"
    {	nPosAbsRec = -1; }
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 589 "parser.y"
    {
		if (current_inrec==1) {
				struct inrec_t *inrec=inrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
				nPosAbsRec += inrec->range.length;
				inrec_addDefinition(inrec);
		}
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 596 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change_position((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].fieldValue));
			nPosAbsRec += inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 604 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
			if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
				nPosAbsRec = (yyvsp[(1) - (3)].number);		// - inrec->change_position.fieldValue->generated_length;
			inrec_addDefinition(inrec);
		}

		free((yyvsp[(3) - (3)].string)); 
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 615 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
			nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
			inrec_addDefinition(inrec);
		}
}
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 622 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_subst((yyvsp[(1) - (1)].string));
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
		free((yyvsp[(1) - (1)].string)); 

}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 632 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_subst((yyvsp[(1) - (1)].string));
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 641 "parser.y"
    {
		if (current_inrec==1) {
			struct inrec_t *inrec=inrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
			inrec_addDefinition(inrec);
			nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
		}
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 650 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 652 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 655 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 657 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 660 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 662 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 665 "parser.y"
    {
			current_inrec=1;
}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 667 "parser.y"
    {
			current_inrec=0;
}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 675 "parser.y"
    {}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 676 "parser.y"
    {}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 678 "parser.y"
    { 
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (4)].number), (yyvsp[(4) - (4)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 683 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (4)].number), (yyvsp[(4) - (4)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 688 "parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 696 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(2) - (5)].number), (yyvsp[(4) - (5)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 701 "parser.y"
    {
			struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField); 
}
    break;

  case 117:
/* Line 1792 of yacc.c  */
#line 706 "parser.y"
    {
 			struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
 			SumField_addDefinition(SumField); 
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 711 "parser.y"
    {
			SumField_setFunction(1);
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 714 "parser.y"
    {
			SumField_setFunction(1);
}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 717 "parser.y"
    {
			SumField_setFunction(2);
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 724 "parser.y"
    {
		//printf("ENGSORT: Warning Token skipped : %s\n",yylval.string);
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 729 "parser.y"
    {

	struct file_t *file=file_constructor((yyvsp[(3) - (3)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(3) - (3)].string));
}
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 735 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(4) - (4)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(4) - (4)].string));
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 742 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(3) - (3)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(3) - (3)].string));
}
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 747 "parser.y"
    {
	struct file_t *file=file_constructor((yyvsp[(4) - (4)].string));
	outfil_setOutfilFiles(current_outfil, file);
	free((yyvsp[(4) - (4)].string));
}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 754 "parser.y"
    {
			if (current_outfil != NULL)
				setOutfilIncludeCondField(current_outfil, (yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 762 "parser.y"
    {
			if (current_outfil != NULL)
				setOutfilOmitCondField(current_outfil, (yyvsp[(3) - (3)].condField));
			nTypeIncludeOmit = 1;
}
    break;

  case 128:
/* Line 1792 of yacc.c  */
#line 769 "parser.y"
    {
			current_outrec=1;
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 771 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 774 "parser.y"
    {
		current_outrec=1;
}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 776 "parser.y"
    {
			current_outrec=0;
}
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 781 "parser.y"
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

  case 133:
/* Line 1792 of yacc.c  */
#line 792 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 798 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 804 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 808 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 812 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 819 "parser.y"
    {}
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 820 "parser.y"
    {}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 821 "parser.y"
    {}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 823 "parser.y"
    {
	utils_SetOptionSort((yyvsp[(1) - (1)].string));
	free((yyvsp[(1) - (1)].string));
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 827 "parser.y"
    {
	utils_SetOptionSort("COPY");
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 830 "parser.y"
    {
	utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 833 "parser.y"
    {
	utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 836 "parser.y"
    {
	utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 839 "parser.y"
    {
	utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 844 "parser.y"
    {
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 845 "parser.y"
    {
}
    break;


/* Line 1792 of yacc.c  */
#line 3068 "parser.c"
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
#line 850 "parser.y"

