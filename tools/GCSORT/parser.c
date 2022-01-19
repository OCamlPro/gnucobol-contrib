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
     EXROUT = 282,
     BUILD = 283,
     FIELDS = 284,
     OVERLAY = 285,
     GIVE = 286,
     MERGE = 287,
     ORG = 288,
     RECORD = 289,
     SORT = 290,
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
     DIGIT = 301,
     DIGITBIG = 302,
     CHARTCOND = 303,
     CHARTYPE = 304,
     FILETYPE = 305,
     FORMATTYPE = 306,
     KEY = 307,
     KEYTYPE = 308,
     OCCURFILL = 309,
     OPCOND = 310,
     ORDER = 311,
     RECTYPEFIX = 312,
     RECTYPEVAR = 313,
     STRING = 314,
     TOKSKIP = 315,
     SIGNDIGITBIG = 316
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
	struct condField_t  *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t   *SumField;
    struct changefield_t *changefield;


/* Line 387 of yacc.c  */
#line 185 "..\\..\\parser.c"
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
#line 213 "..\\..\\parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 34 "..\\..\\parser.y"

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

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2

    /* -->> extern char szMexToken[260];    */

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		  current_file=NULL;
	struct outfil_t*	  current_outfil=NULL;
	struct condField_t*	  condField=NULL;
    struct inrec_t *      inrec=NULL;
    struct outrec_t *     outrec=NULL;
    struct changefield_t* current_changefield=NULL;
    int    pntChange = 0;  /* 1 = Inrec , 2 = Inrec */

	int nRecCase=0;
	int nTypeFile=0;
	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
    int inrec_overlay=0;
    int outrec_overlay=0;
	int nPosAbsRec=0;
	int nRtc=0;
	int nCountGroupFiles=0;
	char* pszInt;
    
    int nDateType=-1;
    int nDateCheck=0;
    int nDateNew=0;
    char szBuf[30];

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			/* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
	int  nTypeIncludeOmit;		/* 0= Nothing, 1 = Include, Omit=2                              */
	int  nstate_outfil = 0;



/* Line 391 of yacc.c  */
#line 287 "..\\..\\parser.c"

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
#define YYFINAL  67
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   399

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  67
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  67
/* YYNRULES -- Number of rules.  */
#define YYNRULES  178
/* YYNRULES -- Number of states.  */
#define YYNSTATES  400

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   316

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      63,    64,     2,     2,    62,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    66,     2,
       2,    65,     2,     2,     2,     2,     2,     2,     2,     2,
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
      55,    56,    57,    58,    59,    60,    61
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    47,    48,    53,    54,    59,    60,
      64,    72,    82,    88,    96,   102,   104,   108,   114,   116,
     118,   120,   123,   126,   128,   130,   132,   136,   142,   150,
     151,   158,   162,   163,   170,   174,   178,   180,   184,   188,
     192,   206,   216,   226,   236,   244,   252,   262,   264,   267,
     269,   272,   274,   277,   279,   283,   288,   292,   297,   299,
     303,   307,   312,   318,   320,   323,   327,   329,   331,   334,
     346,   360,   362,   366,   372,   379,   382,   383,   391,   392,
     399,   400,   408,   409,   416,   417,   425,   426,   433,   434,
     441,   442,   448,   449,   457,   458,   465,   466,   474,   475,
     482,   483,   491,   492,   499,   501,   505,   509,   517,   523,
     527,   533,   535,   537,   541,   547,   551,   553,   556,   560,
     564,   566,   570,   574,   578,   582,   584,   586,   589,   591,
     595,   599,   603,   607,   609,   611,   615,   622,   629,   638,
     649,   658,   669,   670,   674,   676,   682,   690,   697,   707,
     715,   724,   726,   732,   740,   747,   757,   765,   774
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      68,     0,    -1,    -1,    69,    68,    -1,   133,    -1,    85,
      -1,    87,    -1,    70,    -1,    72,    -1,    89,    -1,   125,
      -1,   126,    -1,    94,    -1,    93,    -1,   109,    -1,   118,
      -1,   100,    -1,   119,    -1,   124,    -1,   122,    -1,   123,
      -1,   121,    -1,   127,    -1,   130,    -1,    -1,    36,    59,
      71,    74,    -1,    -1,    31,    59,    73,    74,    -1,    -1,
      33,    50,    74,    -1,    34,    58,    62,    46,    62,    46,
      74,    -1,    34,    63,    58,    62,    46,    62,    46,    64,
      74,    -1,    34,    57,    62,    46,    74,    -1,    34,    63,
      57,    62,    46,    64,    74,    -1,    52,    63,    75,    64,
      74,    -1,    76,    -1,    76,    62,    75,    -1,    46,    62,
      46,    62,    53,    -1,    51,    -1,    56,    -1,    55,    -1,
      48,    59,    -1,    49,    59,    -1,    46,    -1,    61,    -1,
      84,    -1,    84,    62,    83,    -1,    46,    62,    46,    62,
      78,    -1,    46,    62,    46,    62,    77,    62,    78,    -1,
      -1,    35,    29,    63,    86,    83,    64,    -1,    35,    29,
      37,    -1,    -1,    32,    29,    63,    88,    83,    64,    -1,
      32,    29,    37,    -1,     7,    65,    77,    -1,    91,    -1,
      63,    90,    64,    -1,    90,     3,    90,    -1,    90,    13,
      90,    -1,    46,    62,    46,    62,    77,    62,    79,    62,
      46,    62,    46,    62,    77,    -1,    46,    62,    46,    62,
      79,    62,    46,    62,    46,    -1,    46,    62,    46,    62,
      77,    62,    79,    62,    80,    -1,    46,    62,    46,    62,
      77,    62,    79,    62,    82,    -1,    46,    62,    46,    62,
      79,    62,    82,    -1,    46,    62,    46,    62,    79,    62,
      80,    -1,    46,    62,    46,    62,    77,    62,    79,    62,
      92,    -1,    40,    -1,    40,    46,    -1,    41,    -1,    41,
      46,    -1,    42,    -1,    42,    46,    -1,    43,    -1,    11,
       4,    90,    -1,    11,     4,    65,    90,    -1,     8,     4,
      90,    -1,     8,     4,    65,    90,    -1,    96,    -1,    95,
      62,    95,    -1,    46,    62,    46,    -1,    46,    66,    49,
      59,    -1,    46,    66,    46,    62,    46,    -1,    54,    -1,
      54,    59,    -1,    46,    66,    49,    -1,    49,    -1,    81,
      -1,    46,    62,    -1,    44,    63,    46,    62,    97,    64,
      62,    45,    63,    99,    64,    -1,    44,    63,    46,    62,
      97,    64,    62,    45,    63,    46,    62,    46,    64,    -1,
      98,    -1,    98,    62,    97,    -1,    49,    59,    62,    49,
      59,    -1,    49,    59,    62,    46,    62,    46,    -1,    49,
      59,    -1,    -1,    15,    29,    65,    63,   101,    95,    64,
      -1,    -1,    15,    29,    63,   102,    95,    64,    -1,    -1,
      15,    28,    65,    63,   103,    95,    64,    -1,    -1,    15,
      28,    63,   104,    95,    64,    -1,    -1,    15,    30,    65,
      63,   105,    95,    64,    -1,    -1,    15,    30,    63,   106,
      95,    64,    -1,    -1,    15,    65,    63,   107,    95,    64,
      -1,    -1,    15,    63,   108,    95,    64,    -1,    -1,     9,
      29,    65,    63,   110,    95,    64,    -1,    -1,     9,    29,
      63,   111,    95,    64,    -1,    -1,     9,    28,    65,    63,
     112,    95,    64,    -1,    -1,     9,    28,    63,   113,    95,
      64,    -1,    -1,     9,    30,    65,    63,   114,    95,    64,
      -1,    -1,     9,    30,    63,   115,    95,    64,    -1,   117,
      -1,   117,    62,   116,    -1,    46,    62,    46,    -1,    46,
      62,    46,    62,    46,    62,    46,    -1,    46,    62,    46,
      62,    77,    -1,    20,    29,    10,    -1,    20,    29,    63,
     116,    64,    -1,    60,    -1,    59,    -1,   120,    62,   120,
      -1,     6,    65,    63,   120,    64,    -1,     6,    65,   120,
      -1,    21,    -1,    22,    46,    -1,     8,    65,    90,    -1,
      11,    65,    90,    -1,    14,    -1,    18,    65,    61,    -1,
      18,    65,    46,    -1,     5,    65,    61,    -1,     5,    65,
      46,    -1,    16,    -1,   129,    -1,   129,   128,    -1,    37,
      -1,    17,    65,    61,    -1,    17,    65,    46,    -1,    19,
      65,    61,    -1,    19,    65,    46,    -1,    23,    -1,    24,
      -1,    25,    65,    46,    -1,    62,    27,    65,    63,    59,
      64,    -1,    26,    27,    65,    63,    59,    64,    -1,    26,
      27,    65,    63,    59,    62,    47,    64,    -1,    26,    27,
      65,    63,    59,    62,    47,    62,    59,    64,    -1,    26,
      27,    65,    63,    59,    62,    46,    64,    -1,    26,    27,
      65,    63,    59,    62,    46,    62,    59,    64,    -1,    -1,
      12,   131,   128,    -1,    57,    -1,    57,    39,    63,    46,
      64,    -1,    57,    39,    63,    46,    62,    46,    64,    -1,
      57,    39,    63,    62,    46,    64,    -1,    57,    39,    63,
      46,    62,    46,    62,    46,    64,    -1,    57,    39,    63,
      62,    62,    46,    64,    -1,    57,    39,    63,    46,    62,
      62,    46,    64,    -1,    58,    -1,    58,    39,    63,    46,
      64,    -1,    58,    39,    63,    46,    62,    46,    64,    -1,
      58,    39,    63,    62,    46,    64,    -1,    58,    39,    63,
      46,    62,    46,    62,    46,    64,    -1,    58,    39,    63,
      62,    62,    46,    64,    -1,    58,    39,    63,    46,    62,
      62,    46,    64,    -1,    34,    38,   132,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   183,   183,   184,   186,   187,   188,   189,   190,   191,
     192,   193,   194,   195,   196,   197,   198,   199,   200,   201,
     202,   203,   205,   206,   210,   210,   227,   227,   244,   260,
     271,   280,   289,   298,   307,   313,   316,   320,   335,   341,
     348,   360,   375,   390,   403,   422,   424,   430,   442,   457,
     457,   464,   472,   472,   481,   493,   515,   518,   522,   531,
     549,   565,   579,   591,   603,   617,   631,   649,   666,   690,
     706,   733,   751,   775,   795,   801,   810,   816,   827,   829,
     838,   899,   944,   986,  1030,  1074,  1119,  1173,  1213,  1269,
    1289,  1311,  1315,  1323,  1354,  1382,  1397,  1397,  1408,  1408,
    1418,  1418,  1429,  1429,  1439,  1439,  1451,  1451,  1467,  1467,
    1477,  1477,  1491,  1491,  1501,  1501,  1511,  1511,  1521,  1521,
    1531,  1531,  1543,  1543,  1558,  1559,  1562,  1572,  1589,  1601,
    1605,  1612,  1618,  1637,  1643,  1645,  1647,  1651,  1657,  1666,
    1674,  1690,  1695,  1703,  1708,  1715,  1724,  1726,  1729,  1733,
    1737,  1741,  1745,  1749,  1753,  1757,  1761,  1768,  1775,  1781,
    1788,  1794,  1803,  1803,  1815,  1821,  1827,  1833,  1839,  1845,
    1851,  1858,  1864,  1870,  1876,  1882,  1888,  1894,  1905
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
  "\"MODS clause\"", "\"EXROUT clause\"", "\"BUILD instruction\"",
  "\"FIELDS instruction\"", "\"OVERLAY instruction\"", "\"GIVE clause\"",
  "\"MERGE clause\"", "\"ORG instruction\"", "\"RECORD instruction\"",
  "\"SORT clause\"", "\"USE clause\"", "\"COPY\"", "\"TYPE\"",
  "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"", "\"DATE4\"",
  "\"CHANGE\"", "\"NOMATCH\"", "\"DIGIT\"", "\"DIGITBIG\"",
  "\"CHARTCOND\"", "\"CHARTYPE\"", "\"FILETYPE\"", "\"FORMATTYPE\"",
  "\"KEY\"", "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"ORDER\"",
  "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"", "\"TOKSKIP clause\"",
  "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='", "':'", "$accept",
  "beginning", "clause", "useclause", "$@1", "giveclause", "$@2",
  "recordorginstruction", "allkeyfield", "keyfield", "fieldtype",
  "fielddirection", "condition", "fieldvaluecond", "fieldvaluerec",
  "fieldvalueconst", "allsortfield", "sortfield", "sortclause", "$@3",
  "mergeclause", "$@4", "formatclause", "allcondfield", "condfieldcond",
  "datetype", "omitclause", "includeclause", "allinoutrec", "inoutrec",
  "changepair", "changepairdet", "changeCmdOpt", "outrecclause", "$@5",
  "$@6", "$@7", "$@8", "$@9", "$@10", "$@11", "$@12", "inrecclause",
  "$@13", "$@14", "$@15", "$@16", "$@17", "$@18", "allsumfield",
  "sumfield", "sumclause", "tokskipclause", "filesgroup", "fnamesclause",
  "outfilincludeclause", "outfilomitclause", "outfilclause",
  "startrecclause", "endrecclause", "saveclause", "alloption", "option",
  "optionclause", "$@19", "recordoption", "recordclause", YY_NULL
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
     315,   316,    44,    40,    41,    61,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    67,    68,    68,    69,    69,    69,    69,    69,    69,
      69,    69,    69,    69,    69,    69,    69,    69,    69,    69,
      69,    69,    69,    69,    71,    70,    73,    72,    74,    74,
      74,    74,    74,    74,    74,    75,    75,    76,    77,    78,
      79,    80,    81,    82,    82,    83,    83,    84,    84,    86,
      85,    85,    88,    87,    87,    89,    90,    90,    90,    90,
      91,    91,    91,    91,    91,    91,    91,    92,    92,    92,
      92,    92,    92,    92,    93,    93,    94,    94,    95,    95,
      96,    96,    96,    96,    96,    96,    96,    96,    96,    96,
      96,    97,    97,    98,    98,    99,   101,   100,   102,   100,
     103,   100,   104,   100,   105,   100,   106,   100,   107,   100,
     108,   100,   110,   109,   111,   109,   112,   109,   113,   109,
     114,   109,   115,   109,   116,   116,   117,   117,   117,   118,
     118,   119,   120,   120,   121,   121,   121,   121,   122,   123,
     124,   125,   125,   126,   126,   127,   128,   128,   129,   129,
     129,   129,   129,   129,   129,   129,   129,   129,   129,   129,
     129,   129,   131,   130,   132,   132,   132,   132,   132,   132,
     132,   132,   132,   132,   132,   132,   132,   132,   133
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     4,     0,     4,     0,     3,
       7,     9,     5,     7,     5,     1,     3,     5,     1,     1,
       1,     2,     2,     1,     1,     1,     3,     5,     7,     0,
       6,     3,     0,     6,     3,     3,     1,     3,     3,     3,
      13,     9,     9,     9,     7,     7,     9,     1,     2,     1,
       2,     1,     2,     1,     3,     4,     3,     4,     1,     3,
       3,     4,     5,     1,     2,     3,     1,     1,     2,    11,
      13,     1,     3,     5,     6,     2,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     6,
       0,     5,     0,     7,     0,     6,     0,     7,     0,     6,
       0,     7,     0,     6,     1,     3,     3,     7,     5,     3,
       5,     1,     1,     3,     5,     3,     1,     2,     3,     3,
       1,     3,     3,     3,     3,     1,     1,     2,     1,     3,
       3,     3,     3,     1,     1,     3,     6,     6,     8,    10,
       8,    10,     0,     3,     1,     5,     7,     6,     9,     7,
       8,     1,     5,     7,     6,     9,     7,     8,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   162,   140,     0,
     145,     0,     0,   136,     0,     0,     0,     0,     0,     0,
     131,     0,     2,     7,     8,     5,     6,     9,    13,    12,
      16,    14,    15,    17,    21,    19,    20,    18,    10,    11,
      22,    23,     4,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   110,     0,     0,
       0,   137,    26,     0,     0,     0,    24,     1,     3,   144,
     143,   132,     0,   135,    38,    55,     0,     0,     0,    76,
      56,   138,   118,     0,   114,     0,   122,     0,     0,    74,
     139,     0,     0,   153,   154,     0,     0,   148,     0,   163,
     146,   102,     0,    98,     0,   106,     0,     0,   108,   142,
     141,   129,     0,    28,    54,    52,   164,   171,   178,    51,
      49,    28,     0,     0,     0,     0,    77,     0,     0,     0,
     116,     0,   112,     0,   120,    75,     0,     0,     0,     0,
       0,   147,     0,   100,     0,    96,     0,   104,     0,     0,
      86,    83,    87,     0,    78,     0,     0,     0,   124,     0,
       0,     0,    27,     0,     0,     0,     0,    25,   134,   133,
       0,    57,    58,    59,     0,     0,     0,     0,     0,     0,
     150,   149,   152,   151,   155,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    88,     0,    42,    84,     0,   111,
       0,     0,   130,     0,    28,     0,     0,     0,     0,     0,
       0,    45,     0,     0,     0,     0,   119,     0,   115,     0,
     123,     0,     0,     0,   103,     0,    99,     0,   107,     0,
       0,    80,     0,    85,    79,   109,   126,   125,    29,     0,
       0,     0,     0,     0,     0,    35,     0,    53,     0,     0,
       0,     0,     0,    50,    40,     0,     0,   117,   113,   121,
       0,     0,   101,    97,   105,     0,     0,    81,     0,    28,
       0,     0,     0,     0,    28,     0,     0,    46,     0,   165,
       0,     0,     0,   172,     0,     0,     0,     0,     0,   157,
     156,     0,     0,    91,    82,     0,   128,    32,     0,     0,
       0,     0,    34,    36,     0,     0,     0,   167,     0,     0,
       0,   174,     0,     0,    43,     0,    44,    65,    64,     0,
       0,     0,     0,     0,     0,    28,    28,     0,     0,    39,
       0,    47,     0,   166,     0,   169,     0,   173,     0,   176,
       0,     0,    41,     0,   160,     0,   158,     0,     0,    92,
     127,    30,    33,     0,    37,     0,     0,   170,     0,   177,
      67,    69,    71,    73,    43,    62,    63,    66,    61,     0,
       0,     0,     0,     0,    28,    48,   168,   175,    68,    70,
      72,     0,   161,   159,     0,    93,     0,    31,     0,    94,
       0,     0,     0,     0,     0,    95,    89,    60,     0,    90
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    21,    22,    23,   121,    24,   113,   162,   244,   245,
      75,   331,   256,   317,   152,   318,   210,   211,    25,   166,
      26,   163,    27,    79,    80,   367,    28,    29,   153,   154,
     292,   293,   392,    30,   190,   144,   188,   142,   192,   146,
     155,   107,    31,   177,   131,   175,   129,   179,   133,   157,
     158,    32,    33,    73,    34,    35,    36,    37,    38,    39,
      40,    99,   100,    41,    53,   118,    42
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -215
static const yytype_int16 yypact[] =
{
      86,   -45,   -15,     4,    -1,   126,     2,  -215,  -215,   -12,
    -215,    23,   173,  -215,   106,    82,   186,   185,   195,   118,
    -215,   225,    86,  -215,  -215,  -215,  -215,  -215,  -215,  -215,
    -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,
    -215,  -215,  -215,    35,    -7,   176,   -25,   -19,    94,    95,
      98,   -24,   -19,     6,    99,   102,   103,  -215,   163,    67,
      -3,  -215,  -215,   -29,   160,   -18,  -215,  -215,  -215,  -215,
    -215,  -215,   169,   167,  -215,  -215,   168,   -19,   -19,    96,
    -215,    96,  -215,   170,  -215,   171,  -215,   172,   -19,    96,
      96,    80,   166,  -215,  -215,   174,   205,  -215,   209,  -215,
       6,  -215,   177,  -215,   178,  -215,   179,    89,  -215,  -215,
    -215,  -215,   191,    14,  -215,  -215,   199,   204,  -215,  -215,
    -215,    14,    87,   169,   198,     1,    96,   -19,   -19,    89,
    -215,    89,  -215,    89,  -215,    96,    69,    73,   200,   180,
     182,  -215,    89,  -215,    89,  -215,    89,  -215,   187,    13,
     189,   190,  -215,   107,  -215,    89,   192,   188,   193,   201,
      19,   194,  -215,   210,   196,   197,   210,  -215,  -215,   167,
     202,  -215,  -215,   255,   108,    89,   111,    89,   112,    89,
    -215,  -215,  -215,  -215,  -215,   203,   206,   116,    89,   119,
      89,   120,    89,   215,   216,    91,  -215,  -215,    89,  -215,
     123,   217,  -215,   191,    14,   208,   211,   162,   219,   212,
     207,   213,   -13,    -4,   214,    81,  -215,   124,  -215,   127,
    -215,   128,   218,   220,  -215,   131,  -215,   132,  -215,   135,
     221,  -215,   222,   223,   224,  -215,   226,  -215,  -215,   230,
     234,   227,   228,   229,   231,   232,   235,  -215,   210,   136,
       9,   139,    16,  -215,  -215,   236,   237,  -215,  -215,  -215,
     144,   233,  -215,  -215,  -215,   238,   239,  -215,    59,    14,
     240,   246,   247,   250,    14,   219,   241,  -215,    27,  -215,
     242,   254,    41,  -215,   243,   258,   253,    66,   175,  -215,
    -215,   251,   245,   249,  -215,   252,  -215,  -215,   259,   248,
     256,   257,  -215,  -215,    60,   145,   267,  -215,   260,   148,
     269,  -215,   261,   264,   265,   262,  -215,  -215,  -215,   149,
     152,   266,   268,   238,   270,    14,    14,   271,   276,  -215,
     272,  -215,   274,  -215,   273,  -215,   277,  -215,   275,  -215,
      83,   285,  -215,   263,  -215,   279,  -215,    93,   287,  -215,
    -215,  -215,  -215,   278,  -215,   280,   281,  -215,   282,  -215,
     289,   294,   295,  -215,   286,  -215,  -215,  -215,  -215,   283,
     288,   291,   284,   292,    14,  -215,  -215,  -215,  -215,  -215,
    -215,   298,  -215,  -215,   303,  -215,   101,  -215,   296,  -215,
     297,   301,   290,   176,   304,  -215,  -215,  -215,   293,  -215
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -215,   311,  -215,  -215,  -215,  -215,  -215,  -121,    -8,  -215,
    -214,   -87,   -14,   -39,  -215,    11,  -164,  -215,  -215,  -215,
    -215,  -215,  -215,   -42,  -215,  -215,  -215,  -215,  -118,  -215,
      33,  -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,
    -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,  -215,   158,
    -215,  -215,  -215,   -60,  -215,  -215,  -215,  -215,  -215,  -215,
    -215,   299,  -215,  -215,  -215,  -215,  -215
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     167,   255,   214,    46,   127,    81,    51,   111,   114,    89,
      90,   174,   122,   176,   128,   178,    54,    55,    56,   119,
      43,    76,    76,    91,   187,    92,   189,    76,   191,    93,
      94,    95,    96,   249,   115,   125,   126,   200,    77,    77,
      78,    88,   251,    97,    77,   120,   135,   159,   160,   250,
      44,    57,    71,    58,   296,   280,    72,   217,   252,   219,
     112,   221,   284,   169,    47,   171,   161,    52,    98,    45,
     225,   281,   227,   305,   229,   194,   205,   206,   285,   195,
     234,    69,   207,   238,   277,   172,   173,   309,    59,   306,
     330,     1,     2,     3,     4,     5,    70,     6,     7,   127,
       8,     9,    10,   310,    11,   295,    12,    13,    14,   128,
      74,    74,   314,   109,   315,   180,   329,    15,    16,   182,
      17,    18,    19,   360,   361,   362,   363,   316,   110,   364,
     181,   315,    74,   148,   183,   149,   254,   232,   150,   371,
     233,    62,   372,   151,   316,   136,    20,   390,   297,   123,
     391,   168,    61,   302,    48,    49,    50,    82,    84,    83,
      85,    86,   101,    87,   102,   103,   105,   104,   106,   198,
     198,   199,   216,   198,   198,   218,   220,    66,   198,   397,
     224,   198,   198,   226,   228,   198,   198,   235,   257,   198,
     198,   258,   259,   198,   198,   262,   263,   198,   278,   264,
     279,   282,    60,   283,   351,   352,   288,   332,   289,   333,
     336,   343,   337,   344,   345,    63,   346,   116,   117,   241,
     242,   319,   320,    64,    65,    67,   108,    74,    71,   123,
     124,   137,   139,   130,   132,   134,   140,   156,   164,   138,
     143,   145,   147,   165,   170,   185,   184,   186,   196,   197,
     193,   204,   202,   387,   201,   203,   209,   208,   127,   212,
     213,   230,   231,   236,   215,   243,   222,   303,   375,   223,
     239,   247,   313,   240,   246,   248,   269,   260,   253,   261,
     270,   276,   267,   265,   266,   294,   198,   291,   268,   271,
     272,   273,   299,   300,   275,   274,   301,   290,   286,   287,
     308,   365,   298,   304,   312,   325,   307,   311,   254,   322,
     321,   323,   326,   334,   324,   338,   350,   353,   327,   328,
     356,   342,   369,   358,   335,   339,   340,   341,   347,   354,
     348,   368,   373,    68,   355,   378,   329,   357,   370,   359,
     379,   380,   374,   385,   388,   376,   377,   382,   381,   389,
     398,   366,   383,   384,   396,   386,   349,   399,   393,   394,
     395,   237,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   141
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-215)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     121,   215,   166,     4,     3,    47,     4,    10,    37,    51,
      52,   129,    72,   131,    13,   133,    28,    29,    30,    37,
      65,    46,    46,    17,   142,    19,   144,    46,   146,    23,
      24,    25,    26,    46,    63,    77,    78,   155,    63,    63,
      65,    65,    46,    37,    63,    63,    88,    33,    34,    62,
      65,    63,    59,    65,   268,    46,    63,   175,    62,   177,
      63,   179,    46,   123,    65,    64,    52,    65,    62,    65,
     188,    62,   190,    46,   192,    62,    57,    58,    62,    66,
     198,    46,    63,   204,   248,   127,   128,    46,    65,    62,
     304,     5,     6,     7,     8,     9,    61,    11,    12,     3,
      14,    15,    16,    62,    18,    46,    20,    21,    22,    13,
      51,    51,    46,    46,    48,    46,    56,    31,    32,    46,
      34,    35,    36,    40,    41,    42,    43,    61,    61,    46,
      61,    48,    51,    44,    61,    46,    55,    46,    49,    46,
      49,    59,    49,    54,    61,    65,    60,    46,   269,    62,
      49,    64,    46,   274,    28,    29,    30,    63,    63,    65,
      65,    63,    63,    65,    65,    63,    63,    65,    65,    62,
      62,    64,    64,    62,    62,    64,    64,    59,    62,   393,
      64,    62,    62,    64,    64,    62,    62,    64,    64,    62,
      62,    64,    64,    62,    62,    64,    64,    62,    62,    64,
      64,    62,    29,    64,   325,   326,    62,    62,    64,    64,
      62,    62,    64,    64,    62,    29,    64,    57,    58,    57,
      58,    46,    47,    38,    29,     0,    63,    51,    59,    62,
      62,    65,    27,    63,    63,    63,    27,    46,    39,    65,
      63,    63,    63,    39,    46,    65,    46,    65,    59,    59,
      63,    50,    64,   374,    62,    62,    46,    63,     3,    63,
      63,    46,    46,    46,    62,    46,    63,   275,   355,    63,
      62,    64,   286,    62,    62,    62,    46,    59,    64,    59,
      46,    46,    59,    62,    62,    46,    62,    49,    62,    62,
      62,    62,    46,    46,    62,    64,    46,    64,    62,    62,
      46,   340,    62,    62,    46,    46,    64,    64,    55,    64,
      59,    62,    64,    46,    62,    46,    46,    46,    62,    62,
      46,    59,    59,    46,    64,    64,    62,    62,    62,    53,
      62,    46,    45,    22,    62,    46,    56,    64,    59,    64,
      46,    46,    64,    59,    46,    64,    64,    64,    62,    46,
      46,   340,    64,    62,    64,    63,   323,    64,    62,    62,
      59,   203,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   100
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    20,    21,    22,    31,    32,    34,    35,    36,
      60,    68,    69,    70,    72,    85,    87,    89,    93,    94,
     100,   109,   118,   119,   121,   122,   123,   124,   125,   126,
     127,   130,   133,    65,    65,    65,     4,    65,    28,    29,
      30,     4,    65,   131,    28,    29,    30,    63,    65,    65,
      29,    46,    59,    29,    38,    29,    59,     0,    68,    46,
      61,    59,    63,   120,    51,    77,    46,    63,    65,    90,
      91,    90,    63,    65,    63,    65,    63,    65,    65,    90,
      90,    17,    19,    23,    24,    25,    26,    37,    62,   128,
     129,    63,    65,    63,    65,    63,    65,   108,    63,    46,
      61,    10,    63,    73,    37,    63,    57,    58,   132,    37,
      63,    71,   120,    62,    62,    90,    90,     3,    13,   113,
      63,   111,    63,   115,    63,    90,    65,    65,    65,    27,
      27,   128,   104,    63,   102,    63,   106,    63,    44,    46,
      49,    54,    81,    95,    96,   107,    46,   116,   117,    33,
      34,    52,    74,    88,    39,    39,    86,    74,    64,   120,
      46,    64,    90,    90,    95,   112,    95,   110,    95,   114,
      46,    61,    46,    61,    46,    65,    65,    95,   103,    95,
     101,    95,   105,    63,    62,    66,    59,    59,    62,    64,
      95,    62,    64,    62,    50,    57,    58,    63,    63,    46,
      83,    84,    63,    63,    83,    62,    64,    95,    64,    95,
      64,    95,    63,    63,    64,    95,    64,    95,    64,    95,
      46,    46,    46,    49,    95,    64,    46,   116,    74,    62,
      62,    57,    58,    46,    75,    76,    62,    64,    62,    46,
      62,    46,    62,    64,    55,    77,    79,    64,    64,    64,
      59,    59,    64,    64,    64,    62,    62,    59,    62,    46,
      46,    62,    62,    62,    64,    62,    46,    83,    62,    64,
      46,    62,    62,    64,    46,    62,    62,    62,    62,    64,
      64,    49,    97,    98,    46,    46,    77,    74,    62,    46,
      46,    46,    74,    75,    62,    46,    62,    64,    46,    46,
      62,    64,    46,    79,    46,    48,    61,    80,    82,    46,
      47,    59,    64,    62,    62,    46,    64,    62,    62,    56,
      77,    78,    62,    64,    46,    64,    62,    64,    46,    64,
      62,    62,    59,    62,    64,    62,    64,    62,    62,    97,
      46,    74,    74,    46,    53,    62,    46,    64,    46,    64,
      40,    41,    42,    43,    46,    80,    82,    92,    46,    59,
      59,    46,    49,    45,    64,    78,    64,    64,    46,    46,
      46,    62,    64,    64,    62,    59,    63,    74,    46,    46,
      46,    49,    99,    62,    62,    59,    64,    77,    46,    64
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
#line 186 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 187 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 188 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 189 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 190 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 191 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 192 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 193 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 194 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 195 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 196 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 197 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 198 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 199 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 200 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 201 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 202 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 203 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 205 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 206 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 210 "..\\..\\parser.y"
    { 
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
        strcpy(szMexToken, "use clause");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 100, ABEND_SKIP);
			YYABORT;
		}
        file_setInputFile(file);
        current_file=file;
        nTypeFile=0;
        free((yyvsp[(2) - (2)].string));
    }
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 221 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 227 "..\\..\\parser.y"
    {
        struct file_t *file=file_constructor((yyvsp[(2) - (2)].string));
        strcpy(szMexToken, " give clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setOutputFile(file);
        current_file=file;
        nTypeFile=0;
        free((yyvsp[(2) - (2)].string));
}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 238 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 244 "..\\..\\parser.y"
    { 	
        strcat(szMexToken, " record org instruction "); 
    }
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 260 "..\\..\\parser.y"
    {  
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[(2) - (3)].string)));
            if (nRtc == -1)
                exit(GC_RTC_ERROR);
            nTypeFile = utils_parseFileOrganization((yyvsp[(2) - (3)].string));
        }
        free((yyvsp[(2) - (3)].string));
}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 271 "..\\..\\parser.y"
    {    
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(2) - (7)].string)));
            file_setRecordLength(current_file,(yyvsp[(4) - (7)].number));
            file_setMaxLength(current_file,(yyvsp[(6) - (7)].number));
        }
        free((yyvsp[(2) - (7)].string));
}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 280 "..\\..\\parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (9)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (9)].number));
            file_setMaxLength(current_file,(yyvsp[(7) - (9)].number));
        }
        free((yyvsp[(3) - (9)].string));
}
    break;

  case 32:
/* Line 1792 of yacc.c  */
#line 289 "..\\..\\parser.y"
    {		
        strcpy(szMexToken, " record type ");
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
#line 298 "..\\..\\parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (7)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (7)].number));
            file_setMaxLength(current_file,(yyvsp[(5) - (7)].number));
        }
        free((yyvsp[(3) - (7)].string));
}
    break;

  case 34:
/* Line 1792 of yacc.c  */
#line 307 "..\\..\\parser.y"
    {
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 313 "..\\..\\parser.y"
    { 
        strcat(szMexToken, " key instruction ");
}
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 316 "..\\..\\parser.y"
    {}
    break;

  case 37:
/* Line 1792 of yacc.c  */
#line 320 "..\\..\\parser.y"
    {
        if (current_file!=NULL) {
            struct KeyIdx_t *KeyIdx;
            KeyIdx=KeyIdx_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), utils_parseKeyType((yyvsp[(5) - (5)].string)));
            if (KeyIdx == NULL) {
               utl_abend_terminate(MEMORYALLOC, 102, ABEND_SKIP);
               YYABORT;
            }
            KeyIdx_addDefinition(KeyIdx, current_file);
        }
        free((yyvsp[(5) - (5)].string));
 }
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 335 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 341 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 348 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 360 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 375 "..\\..\\parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 390 "..\\..\\parser.y"
    {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[(1) - (1)].number));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 403 "..\\..\\parser.y"
    {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, CB_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
		#else
			sprintf(pszInt, CB_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
		#endif
		/*  -->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);    */
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 107, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 422 "..\\..\\parser.y"
    {
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 424 "..\\..\\parser.y"
    {
        
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 430 "..\\..\\parser.y"
    {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[(1) - (5)].number),(yyvsp[(3) - (5)].number),0, (yyvsp[(5) - (5)].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            nTypeFormat = 1;
        }
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 442 "..\\..\\parser.y"
    {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),(yyvsp[(5) - (7)].number),(yyvsp[(7) - (7)].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 109, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            /*  -->> nTypeFormat = 1; // Format external token  */
			}
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 457 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 459 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 464 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 472 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 475 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 481 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 493 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " format clause ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 3)	/* for SumFields    */
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 515 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 518 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
		strcat(szMexToken, " condition field ");
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 522 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
		strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 110, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 531 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
		strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 111, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 549 "..\\..\\parser.y"
    {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[(1) - (13)].number),(yyvsp[(3) - (13)].number),(yyvsp[(5) - (13)].number),(yyvsp[(7) - (13)].number),(yyvsp[(9) - (13)].number),(yyvsp[(11) - (13)].number),(yyvsp[(13) - (13)].number));
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 565 "..\\..\\parser.y"
    {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),0,(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].number),0);
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 579 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 591 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 603 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 617 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 631 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition4Date((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 141, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 649 "..\\..\\parser.y"
    { 
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
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 666 "..\\..\\parser.y"
    { 
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* check range */
        if ((yyvsp[(2) - (2)].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[(2) - (2)].number));
        nDateCheck = nDateNew;

        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 690 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
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
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 706 "..\\..\\parser.y"
    {             /* Problem ++ to define datetype */
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        /* check range */
        if ((yyvsp[(2) - (2)].number) > 12) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub months to date */
        /* from YYYYMM  to YYYYMMDD */
        nDateCheck = nDateCheck * 100 + 1 ;
        /* add Month to date*/
        gcDateAddMonths(nDateCheck, &nDateNew, (yyvsp[(2) - (2)].number));
        /* from YYYYMMDD  to YYYYMM */
        nDateCheck = (nDateNew / 100);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 733 "..\\..\\parser.y"
    { 
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
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 751 "..\\..\\parser.y"
    { 
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        /* check range */
        if ((yyvsp[(2) - (2)].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[(2) - (2)].number));
        gcDate2Ord(nDateNew, &nDateCheck);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string with format yyyyddd */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 775 "..\\..\\parser.y"
    { 
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
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 795 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 801 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 810 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 816 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 827 "..\\..\\parser.y"
    {	
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 829 "..\\..\\parser.y"
    {	}
    break;

  case 80:
/* Line 1792 of yacc.c  */
#line 838 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 117, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            else
            {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 118, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                    inrec=inrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
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
        default:
            break;
        }
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 899 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_possubstnchar((yyvsp[(1) - (4)].number), (yyvsp[(3) - (4)].string), (yyvsp[(4) - (4)].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_possubstnchar((yyvsp[(1) - (4)].number), (yyvsp[(3) - (4)].string), (yyvsp[(4) - (4)].string));
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
        free((yyvsp[(3) - (4)].string)); /* s.m. 202015    */
		free((yyvsp[(4) - (4)].string)); 
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 944 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 120, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
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
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 986 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_subst((yyvsp[(1) - (1)].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 122, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_subst((yyvsp[(1) - (1)].string));
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
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 1030 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_substnchar((yyvsp[(1) - (2)].string),(yyvsp[(2) - (2)].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_substnchar((yyvsp[(1) - (2)].string),(yyvsp[(2) - (2)].string));
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
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 1074 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 126, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[(1) - (3)].number);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[(1) - (3)].number);		/* - inrec->change_position.fieldValue->generated_length;   */
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
           break;
        default:
            break;
        }
        free((yyvsp[(3) - (3)].string)); 
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 1119 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
       /*         struct outrec_t *outrec=outrec_constructor_subst($1); */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[(1) - (1)].string));
                /* struct outrec_t * */
                outrec=outrec_constructor_subst(szType01);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 128, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                strcat(szType01, (yyvsp[(1) - (1)].string));
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
        free((yyvsp[(1) - (1)].string)); /* s.m. 202105    */
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 1173 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * outrec; */
                outrec=outrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 130, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_change((yyvsp[(1) - (1)].fieldValue));
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
	}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 1213 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(outrec);
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
                inrec=inrec_constructor_range((yyvsp[(1) - (2)].number),-1);
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
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 1269 "..\\..\\parser.y"
    { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor((yyvsp[(3) - (11)].number));
        change_setNoMatch(chg, (yyvsp[(10) - (11)].fieldValue));  
        change_setpairs(chg, (yyvsp[(5) - (11)].changefield));
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
         nPosAbsRec += (yyvsp[(3) - (11)].number);       /* len output change */
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 1289 "..\\..\\parser.y"
    { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor((yyvsp[(3) - (13)].number));
        change_setNoMatchPosLen(chg, (yyvsp[(10) - (13)].number), (yyvsp[(12) - (13)].number));  
        change_setpairs(chg, (yyvsp[(5) - (13)].changefield));
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
         nPosAbsRec += (yyvsp[(3) - (13)].number);       /* len output change */
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 1311 "..\\..\\parser.y"
    { 
        strcat(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 1315 "..\\..\\parser.y"
    {}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 1323 "..\\..\\parser.y"
    { 
		/* $$=changefield_constructor((char*) $2, $5); */
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[(1) - (5)].string), (yyvsp[(2) - (5)].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct fieldValue_t* fv2 = fieldValue_constructor((char*) (yyvsp[(4) - (5)].string), (yyvsp[(5) - (5)].string), TYPE_STRUCT_STD, 0);
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
		free((yyvsp[(1) - (5)].string)); 
		free((yyvsp[(2) - (5)].string)); 
        free((yyvsp[(4) - (5)].string));
		free((yyvsp[(5) - (5)].string)); 
        (yyval.changefield)=pcf;
}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 1354 "..\\..\\parser.y"
    { 
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[(1) - (6)].string), (yyvsp[(2) - (6)].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct changefield_t* pcf = changefield_constructorPosLen(fv1, (yyvsp[(4) - (6)].number), (yyvsp[(6) - (6)].number));
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free((yyvsp[(1) - (6)].string)); 
		free((yyvsp[(2) - (6)].string)); 
        (yyval.changefield)=pcf;
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 1382 "..\\..\\parser.y"
    { 
        /* $$=changefield_constructor((char*) $2, $5); */
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string));         
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 1397 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 1402 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 1408 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 1413 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1418 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1423 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1429 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1434 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1439 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1444 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1451 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
        }
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1456 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1467 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=2;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 1472 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 1477 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1482 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1491 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 1496 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1501 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
        }
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1506 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 1511 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 117:
/* Line 1792 of yacc.c  */
#line 1516 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 1521 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 1526 "..\\..\\parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 1531 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 1536 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 1543 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
        }
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 1548 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1558 "..\\..\\parser.y"
    {}
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 1559 "..\\..\\parser.y"
    {}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1562 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			/* for SumFields Format=    */
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 1572 "..\\..\\parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
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
}
    break;

  case 128:
/* Line 1792 of yacc.c  */
#line 1589 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 137, ABEND_SKIP);
			YYABORT;
		}
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1601 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1605 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1612 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 1618 "..\\..\\parser.y"
    {
        struct file_t *file;
		file=file_constructor((yyvsp[(1) - (1)].string));
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
        free((yyvsp[(1) - (1)].string));
        strcpy(szMexToken, " files clause ");
}
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 1637 "..\\..\\parser.y"
    {
		strcat(szMexToken, " group files outfil ");
}
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 1643 "..\\..\\parser.y"
    {
}
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 1645 "..\\..\\parser.y"
    {
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 1647 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 1651 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 1657 "..\\..\\parser.y"
    {

		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 1666 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 1674 "..\\..\\parser.y"
    {
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
}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 1690 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 1695 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 1703 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 1708 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 1715 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 1724 "..\\..\\parser.y"
    {}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 1726 "..\\..\\parser.y"
    {}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 1729 "..\\..\\parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 1733 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 1737 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 1741 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 1745 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 1749 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 1753 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 1757 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 1762 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 1769 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 1775 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 1781 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 1788 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 1794 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 1803 "..\\..\\parser.y"
    {
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 1804 "..\\..\\parser.y"
    {
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 1815 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 1821 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 1827 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 1833 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 1839 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 1845 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 1851 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 1858 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 1864 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 1870 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 1876 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 1882 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 1888 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 1894 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 1905 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


/* Line 1792 of yacc.c  */
#line 4157 "..\\..\\parser.c"
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
#line 1910 "..\\..\\parser.y"

