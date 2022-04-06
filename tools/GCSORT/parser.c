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
#line 194 "..\\..\\parser.c"
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
#line 222 "..\\..\\parser.c"
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
    #include "join.h"

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2
    #define  JOIN_CASE      3
    
    /* -->> extern char szMexToken[260];    */

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		  current_file=NULL;
	struct outfil_t*	  current_outfil=NULL;
	struct condField_t*	  condField=NULL;
    struct inrec_t *      inrec=NULL;
    struct outrec_t *     outrec=NULL;
    struct changefield_t* current_changefield=NULL;
    struct join_t*        current_join=NULL;
    struct join_t*        F1_join=NULL;
    struct join_t*        F2_join=NULL;
    int    pntChange = 0;  /* 1 = Inrec , 2 = Inrec */

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
    int  nOnly=0;



/* Line 391 of yacc.c  */
#line 303 "..\\..\\parser.c"

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
#define YYFINAL  89
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   476

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  77
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  78
/* YYNRULES -- Number of rules.  */
#define YYNRULES  207
/* YYNRULES -- Number of states.  */
#define YYNSTATES  460

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   325

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      72,    73,     2,     2,    71,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    76,     2,
       2,    74,     2,    75,     2,     2,     2,     2,     2,     2,
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
      65,    66,    67,    68,    69,    70
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
     102,   110,   116,   118,   122,   128,   130,   132,   134,   137,
     140,   142,   144,   146,   150,   156,   164,   165,   172,   176,
     177,   184,   188,   189,   200,   202,   205,   208,   213,   217,
     221,   224,   228,   234,   242,   243,   246,   247,   255,   256,
     260,   264,   266,   270,   274,   278,   292,   302,   312,   322,
     330,   338,   348,   350,   353,   355,   358,   360,   363,   365,
     369,   374,   378,   383,   385,   389,   393,   395,   401,   406,
     412,   414,   417,   421,   423,   425,   428,   440,   454,   456,
     460,   466,   473,   476,   477,   485,   486,   493,   494,   502,
     503,   510,   511,   519,   520,   527,   528,   535,   536,   542,
     543,   551,   552,   559,   560,   568,   569,   576,   577,   585,
     586,   593,   594,   601,   603,   607,   611,   619,   625,   629,
     635,   637,   639,   643,   649,   653,   655,   658,   662,   666,
     668,   672,   676,   680,   684,   686,   688,   691,   693,   697,
     701,   705,   709,   711,   713,   717,   724,   731,   740,   751,
     760,   771,   772,   776,   778,   784,   792,   799,   809,   817,
     826,   828,   834,   842,   849,   859,   867,   876
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      78,     0,    -1,    -1,    79,    78,    -1,   154,    -1,    95,
      -1,    97,    -1,    99,    -1,   103,    -1,   105,    -1,   101,
      -1,   104,    -1,   107,    -1,    80,    -1,    82,    -1,   108,
      -1,   146,    -1,   147,    -1,   113,    -1,   112,    -1,   128,
      -1,   139,    -1,   119,    -1,   140,    -1,   145,    -1,   143,
      -1,   144,    -1,   142,    -1,   148,    -1,   151,    -1,   135,
      -1,    -1,    37,    68,    81,    84,    -1,    -1,    31,    68,
      83,    84,    -1,    -1,    33,    58,    84,    -1,    34,    67,
      71,    54,    71,    54,    84,    -1,    34,    72,    67,    71,
      54,    71,    54,    73,    84,    -1,    34,    66,    71,    54,
      84,    -1,    34,    72,    66,    71,    54,    73,    84,    -1,
      61,    72,    85,    73,    84,    -1,    86,    -1,    86,    71,
      85,    -1,    54,    71,    54,    71,    62,    -1,    59,    -1,
      65,    -1,    64,    -1,    56,    68,    -1,    57,    68,    -1,
      54,    -1,    70,    -1,    94,    -1,    94,    71,    93,    -1,
      54,    71,    54,    71,    88,    -1,    54,    71,    54,    71,
      87,    71,    88,    -1,    -1,    35,    29,    72,    96,    93,
      73,    -1,    35,    29,    38,    -1,    -1,    32,    29,    72,
      98,    93,    73,    -1,    32,    29,    38,    -1,    -1,    36,
       6,    74,    60,    71,    29,    72,   100,    93,    73,    -1,
     102,    -1,   102,   101,    -1,    71,    47,    -1,    71,    47,
      71,    48,    -1,    19,    74,    70,    -1,    19,    74,    54,
      -1,    51,    49,    -1,    51,    49,   104,    -1,    51,    49,
      71,    60,   104,    -1,    51,    49,    71,    60,    71,    60,
     104,    -1,    -1,    71,    50,    -1,    -1,    52,    29,    72,
     106,   114,    73,   107,    -1,    -1,    53,    57,    68,    -1,
       7,    74,    87,    -1,   110,    -1,    72,   109,    73,    -1,
     109,     3,   109,    -1,   109,    13,   109,    -1,    54,    71,
      54,    71,    87,    71,    89,    71,    54,    71,    54,    71,
      87,    -1,    54,    71,    54,    71,    89,    71,    54,    71,
      54,    -1,    54,    71,    54,    71,    87,    71,    89,    71,
      90,    -1,    54,    71,    54,    71,    87,    71,    89,    71,
      92,    -1,    54,    71,    54,    71,    89,    71,    92,    -1,
      54,    71,    54,    71,    89,    71,    90,    -1,    54,    71,
      54,    71,    87,    71,    89,    71,   111,    -1,    41,    -1,
      41,    54,    -1,    42,    -1,    42,    54,    -1,    43,    -1,
      43,    54,    -1,    44,    -1,    11,     4,   109,    -1,    11,
       4,    74,   109,    -1,     8,     4,   109,    -1,     8,     4,
      74,   109,    -1,   115,    -1,   114,    71,   114,    -1,    54,
      71,    54,    -1,    75,    -1,    60,    76,    54,    71,    54,
      -1,    54,    76,    57,    68,    -1,    54,    76,    54,    71,
      54,    -1,    63,    -1,    63,    68,    -1,    54,    76,    57,
      -1,    57,    -1,    91,    -1,    54,    71,    -1,    45,    72,
      54,    71,   116,    73,    71,    46,    72,   118,    73,    -1,
      45,    72,    54,    71,   116,    73,    71,    46,    72,    54,
      71,    54,    73,    -1,   117,    -1,   117,    71,   116,    -1,
      57,    68,    71,    57,    68,    -1,    57,    68,    71,    54,
      71,    54,    -1,    57,    68,    -1,    -1,    15,    29,    74,
      72,   120,   114,    73,    -1,    -1,    15,    29,    72,   121,
     114,    73,    -1,    -1,    15,    28,    74,    72,   122,   114,
      73,    -1,    -1,    15,    28,    72,   123,   114,    73,    -1,
      -1,    15,    30,    74,    72,   124,   114,    73,    -1,    -1,
      15,    30,    72,   125,   114,    73,    -1,    -1,    15,    74,
      72,   126,   114,    73,    -1,    -1,    15,    72,   127,   114,
      73,    -1,    -1,     9,    29,    74,    72,   129,   114,    73,
      -1,    -1,     9,    29,    72,   130,   114,    73,    -1,    -1,
       9,    28,    74,    72,   131,   114,    73,    -1,    -1,     9,
      28,    72,   132,   114,    73,    -1,    -1,     9,    30,    74,
      72,   133,   114,    73,    -1,    -1,     9,    30,    72,   134,
     114,    73,    -1,    -1,    71,    28,    72,   136,   114,    73,
      -1,   138,    -1,   138,    71,   137,    -1,    54,    71,    54,
      -1,    54,    71,    54,    71,    54,    71,    54,    -1,    54,
      71,    54,    71,    87,    -1,    20,    29,    10,    -1,    20,
      29,    72,   137,    73,    -1,    69,    -1,    68,    -1,   141,
      71,   141,    -1,     6,    74,    72,   141,    73,    -1,     6,
      74,   141,    -1,    21,    -1,    22,    54,    -1,     8,    74,
     109,    -1,    11,    74,   109,    -1,    14,    -1,    18,    74,
      70,    -1,    18,    74,    54,    -1,     5,    74,    70,    -1,
       5,    74,    54,    -1,    16,    -1,   150,    -1,   150,   149,
      -1,    38,    -1,    17,    74,    70,    -1,    17,    74,    54,
      -1,    19,    74,    70,    -1,    19,    74,    54,    -1,    23,
      -1,    24,    -1,    25,    74,    54,    -1,    71,    27,    74,
      72,    68,    73,    -1,    26,    27,    74,    72,    68,    73,
      -1,    26,    27,    74,    72,    68,    71,    55,    73,    -1,
      26,    27,    74,    72,    68,    71,    55,    71,    68,    73,
      -1,    26,    27,    74,    72,    68,    71,    54,    73,    -1,
      26,    27,    74,    72,    68,    71,    54,    71,    68,    73,
      -1,    -1,    12,   152,   149,    -1,    66,    -1,    66,    40,
      72,    54,    73,    -1,    66,    40,    72,    54,    71,    54,
      73,    -1,    66,    40,    72,    71,    54,    73,    -1,    66,
      40,    72,    54,    71,    54,    71,    54,    73,    -1,    66,
      40,    72,    71,    71,    54,    73,    -1,    66,    40,    72,
      54,    71,    71,    54,    73,    -1,    67,    -1,    67,    40,
      72,    54,    73,    -1,    67,    40,    72,    54,    71,    54,
      73,    -1,    67,    40,    72,    71,    54,    73,    -1,    67,
      40,    72,    54,    71,    54,    71,    54,    73,    -1,    67,
      40,    72,    71,    71,    54,    73,    -1,    67,    40,    72,
      54,    71,    71,    54,    73,    -1,    34,    39,   153,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   200,   200,   201,   203,   204,   205,   206,   207,   208,
     209,   210,   211,   212,   213,   214,   215,   216,   217,   218,
     219,   220,   221,   222,   223,   224,   225,   226,   228,   229,
     230,   234,   234,   251,   251,   268,   284,   295,   304,   313,
     322,   331,   337,   340,   344,   359,   365,   372,   384,   399,
     414,   427,   446,   448,   454,   478,   493,   493,   500,   508,
     508,   517,   527,   527,   554,   555,   559,   563,   567,   571,
     595,   601,   614,   640,   657,   658,   679,   679,   690,   691,
     707,   729,   732,   736,   745,   763,   779,   793,   805,   817,
     831,   845,   863,   880,   904,   920,   947,   965,   989,  1009,
    1015,  1024,  1030,  1041,  1043,  1051,  1123,  1138,  1164,  1209,
    1251,  1295,  1339,  1384,  1438,  1478,  1534,  1554,  1576,  1580,
    1588,  1619,  1647,  1662,  1662,  1673,  1673,  1683,  1683,  1694,
    1694,  1704,  1704,  1716,  1716,  1732,  1732,  1742,  1742,  1756,
    1756,  1766,  1766,  1776,  1776,  1786,  1786,  1796,  1796,  1808,
    1808,  1823,  1823,  1834,  1835,  1838,  1848,  1865,  1877,  1881,
    1888,  1894,  1913,  1919,  1921,  1923,  1927,  1933,  1945,  1957,
    1973,  1978,  1986,  1991,  1998,  2007,  2009,  2012,  2016,  2020,
    2024,  2028,  2032,  2036,  2040,  2044,  2051,  2058,  2064,  2071,
    2077,  2086,  2086,  2098,  2104,  2110,  2116,  2122,  2128,  2134,
    2141,  2147,  2153,  2159,  2165,  2171,  2177,  2188
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
  "\"SORT clause\"", "\"JOINKEYS clause\"", "\"USE clause\"", "\"COPY\"",
  "\"TYPE\"", "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"",
  "\"DATE4\"", "\"CHANGE\"", "\"NOMATCH\"", "\"SORTED\"", "\"NOSEQCK\"",
  "\"UNPAIRED\"", "\"ONLY\"", "\"JOIN\"", "\"JOINREFORMAT\"", "\"FILL\"",
  "\"DIGIT\"", "\"DIGITBIG\"", "\"CHARTCOND\"", "\"CHARTYPE\"",
  "\"FILETYPE\"", "\"FORMATTYPE\"", "\"JOINFILE\"", "\"KEY\"",
  "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"ORDER\"",
  "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"", "\"TOKSKIP clause\"",
  "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='", "'?'", "':'", "$accept",
  "beginning", "clause", "useclause", "$@1", "giveclause", "$@2",
  "recordorginstruction", "allkeyfield", "keyfield", "fieldtype",
  "fielddirection", "condition", "fieldvaluecond", "fieldvaluerec",
  "fieldvalueconst", "allsortfield", "sortfield", "sortclause", "$@3",
  "mergeclause", "$@4", "joinkeysclause", "$@5", "joinkeysalloptions",
  "joinkeysoptions", "joinclause", "joinoptions", "joinreformatclause",
  "$@6", "fill_char", "formatclause", "allcondfield", "condfieldcond",
  "datetype", "omitclause", "includeclause", "allinoutrec", "inoutrec",
  "changepair", "changepairdet", "changeCmdOpt", "outrecclause", "$@7",
  "$@8", "$@9", "$@10", "$@11", "$@12", "$@13", "$@14", "inrecclause",
  "$@15", "$@16", "$@17", "$@18", "$@19", "$@20", "buildclause", "$@21",
  "allsumfield", "sumfield", "sumclause", "tokskipclause", "filesgroup",
  "fnamesclause", "outfilincludeclause", "outfilomitclause",
  "outfilclause", "startrecclause", "endrecclause", "saveclause",
  "alloption", "option", "optionclause", "$@22", "recordoption",
  "recordclause", YY_NULL
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
     325,    44,    40,    41,    61,    63,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    77,    78,    78,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    81,    80,    83,    82,    84,    84,    84,    84,    84,
      84,    84,    85,    85,    86,    87,    88,    89,    90,    91,
      92,    92,    93,    93,    94,    94,    96,    95,    95,    98,
      97,    97,   100,    99,   101,   101,   102,   102,   102,   102,
     103,   103,   103,   103,   104,   104,   106,   105,   107,   107,
     108,   109,   109,   109,   109,   110,   110,   110,   110,   110,
     110,   110,   111,   111,   111,   111,   111,   111,   111,   112,
     112,   113,   113,   114,   114,   115,   115,   115,   115,   115,
     115,   115,   115,   115,   115,   115,   115,   115,   116,   116,
     117,   117,   118,   120,   119,   121,   119,   122,   119,   123,
     119,   124,   119,   125,   119,   126,   119,   127,   119,   129,
     128,   130,   128,   131,   128,   132,   128,   133,   128,   134,
     128,   136,   135,   137,   137,   138,   138,   138,   139,   139,
     140,   141,   141,   142,   142,   142,   142,   143,   144,   145,
     146,   146,   147,   147,   148,   149,   149,   150,   150,   150,
     150,   150,   150,   150,   150,   150,   150,   150,   150,   150,
     150,   152,   151,   153,   153,   153,   153,   153,   153,   153,
     153,   153,   153,   153,   153,   153,   153,   154
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     3,     5,     1,     1,     1,     2,     2,
       1,     1,     1,     3,     5,     7,     0,     6,     3,     0,
       6,     3,     0,    10,     1,     2,     2,     4,     3,     3,
       2,     3,     5,     7,     0,     2,     0,     7,     0,     3,
       3,     1,     3,     3,     3,    13,     9,     9,     9,     7,
       7,     9,     1,     2,     1,     2,     1,     2,     1,     3,
       4,     3,     4,     1,     3,     3,     1,     5,     4,     5,
       1,     2,     3,     1,     1,     2,    11,    13,     1,     3,
       5,     6,     2,     0,     7,     0,     6,     0,     7,     0,
       6,     0,     7,     0,     6,     0,     6,     0,     5,     0,
       7,     0,     6,     0,     7,     0,     6,     0,     7,     0,
       6,     0,     6,     1,     3,     3,     7,     5,     3,     5,
       1,     1,     3,     5,     3,     1,     2,     3,     3,     1,
       3,     3,     3,     3,     1,     1,     2,     1,     3,     3,
       3,     3,     1,     1,     3,     6,     6,     8,    10,     8,
      10,     0,     3,     1,     5,     7,     6,     9,     7,     8,
       1,     5,     7,     6,     9,     7,     8,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   191,   169,     0,
     174,     0,     0,     0,   165,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   160,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    64,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   137,     0,     0,     0,     0,   166,    33,     0,     0,
       0,     0,    31,    70,     0,     0,     0,    66,    75,     1,
       3,     0,    65,   173,   172,   161,     0,   164,    45,    80,
       0,     0,     0,   101,    81,   167,   145,     0,   141,     0,
     149,     0,     0,    99,   168,     0,     0,   182,   183,     0,
       0,   177,     0,   192,   175,   129,     0,   125,     0,   133,
       0,     0,   135,   171,   170,    69,    68,   158,     0,    35,
      61,    59,   193,   200,   207,    58,    56,     0,    35,     0,
      71,    76,    79,   151,     0,     0,     0,     0,     0,   102,
       0,     0,     0,   143,     0,   139,     0,   147,   100,     0,
       0,     0,     0,     0,   176,     0,   127,     0,   123,     0,
     131,     0,     0,   113,     0,   110,   106,   114,     0,   103,
       0,     0,     0,   153,     0,     0,     0,    34,     0,     0,
       0,     0,     0,    32,    74,     0,     0,    67,   163,   162,
       0,    82,    83,    84,     0,     0,     0,     0,     0,     0,
     179,   178,   181,   180,   184,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   115,     0,    49,     0,   111,     0,
     138,     0,     0,   159,     0,    35,     0,     0,     0,     0,
       0,     0,    52,     0,     0,     0,     0,     0,    72,     0,
       0,     0,   146,     0,   142,     0,   150,     0,     0,     0,
     130,     0,   126,     0,   134,     0,     0,   105,     0,   112,
       0,   104,   136,   155,   154,    36,     0,     0,     0,     0,
       0,     0,    42,     0,    60,     0,     0,     0,     0,     0,
      57,     0,    74,    78,   152,    47,     0,     0,   144,   140,
     148,     0,     0,   128,   124,   132,     0,     0,   108,     0,
       0,    35,     0,     0,     0,     0,    35,     0,     0,    53,
       0,   194,     0,     0,     0,   201,     0,     0,    62,     0,
      73,    77,     0,     0,     0,   186,   185,     0,     0,   118,
     109,   107,     0,   157,    39,     0,     0,     0,     0,    41,
      43,     0,     0,     0,   196,     0,     0,     0,   203,     0,
       0,     0,    50,     0,    51,    90,    89,     0,     0,     0,
       0,     0,     0,    35,    35,     0,     0,    46,     0,    54,
       0,   195,     0,   198,     0,   202,     0,   205,     0,     0,
       0,    48,     0,   189,     0,   187,     0,     0,   119,   156,
      37,    40,     0,    44,     0,     0,   199,     0,   206,    63,
      92,    94,    96,    98,    50,    87,    88,    91,    86,     0,
       0,     0,     0,     0,    35,    55,   197,   204,    93,    95,
      97,     0,   190,   188,     0,   120,     0,    38,     0,   121,
       0,     0,     0,     0,     0,   122,   116,    85,     0,   117
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   148,    30,   139,   197,   291,   292,
      99,   389,   307,   375,   187,   376,   251,   252,    31,   201,
      32,   198,    33,   370,    34,    35,    36,    37,    38,   205,
      39,    40,   103,   104,   427,    41,    42,   188,   189,   348,
     349,   452,    43,   230,   177,   228,   175,   232,   179,   190,
     131,    44,   217,   164,   215,   162,   219,   166,    45,   206,
     192,   193,    46,    47,    97,    48,    49,    50,    51,    52,
      53,    54,   123,   124,    55,    67,   144,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -260
static const yytype_int16 yypact[] =
{
     112,   -41,    -8,    31,     3,   156,     7,  -260,  -260,   -10,
    -260,    41,    68,    23,  -260,   138,   101,    56,   131,   198,
     247,   186,   206,   227,   200,  -260,    -7,   258,   112,  -260,
    -260,  -260,  -260,  -260,  -260,    -2,  -260,  -260,  -260,  -260,
    -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,
    -260,  -260,  -260,  -260,  -260,  -260,  -260,    30,    73,   201,
      17,   -30,    42,   103,   115,    34,   -30,    11,   116,   119,
     123,  -260,   187,    55,    82,    -4,  -260,  -260,   -22,   183,
     -16,   188,  -260,   190,   191,   196,   193,   195,  -260,  -260,
    -260,   220,  -260,  -260,  -260,  -260,   202,   197,  -260,  -260,
     203,   -30,   -30,    26,  -260,    26,  -260,   199,  -260,   204,
    -260,   205,   -30,    26,    26,   207,   208,  -260,  -260,   209,
     242,  -260,   245,  -260,    11,  -260,   212,  -260,   213,  -260,
     215,    38,  -260,  -260,  -260,  -260,  -260,  -260,   219,    13,
    -260,  -260,   235,   238,  -260,  -260,  -260,   228,    13,    -9,
    -260,  -260,  -260,  -260,   231,   109,   202,   226,     0,    26,
     -30,   -30,    38,  -260,    38,  -260,    38,  -260,    26,    84,
      85,   236,   217,   218,  -260,    38,  -260,    38,  -260,    38,
    -260,   221,    86,   229,   222,   232,  -260,  -260,   125,  -260,
      38,   223,   216,   224,   241,    94,   230,  -260,   249,   233,
     234,   249,   225,  -260,   237,    38,    38,  -260,  -260,   197,
     239,  -260,  -260,   298,   128,    38,   129,    38,   132,    38,
    -260,  -260,  -260,  -260,  -260,   240,   243,   133,    38,   136,
      38,   137,    38,   250,   253,   102,  -260,   255,  -260,    38,
    -260,   140,   257,  -260,   219,    13,   246,   248,   185,   259,
     251,   252,   256,   -23,    25,   260,   285,    90,  -260,   141,
     144,   108,  -260,   145,  -260,   148,  -260,   151,   261,   262,
    -260,   152,  -260,   155,  -260,   158,   263,  -260,   264,   268,
     266,   267,  -260,   269,  -260,  -260,   270,   272,   271,   273,
     274,   275,   276,   277,  -260,   249,   159,    36,   166,    39,
    -260,   244,   278,   265,  -260,  -260,   279,   280,  -260,  -260,
    -260,   167,   281,  -260,  -260,  -260,   282,   287,  -260,   289,
      99,    13,   284,   292,   299,   302,    13,   259,   286,  -260,
      40,  -260,   288,   304,    58,  -260,   290,   305,  -260,   310,
    -260,  -260,   300,    81,   179,  -260,  -260,   294,   293,   296,
    -260,  -260,   297,  -260,  -260,   311,   301,   306,   307,  -260,
    -260,   -33,   170,   315,  -260,   303,   171,   316,  -260,   308,
     249,   309,   312,   314,  -260,  -260,  -260,   174,   175,   313,
     317,   282,   318,    13,    13,   319,   323,  -260,   320,  -260,
     321,  -260,   322,  -260,   325,  -260,   324,  -260,   326,    16,
     332,  -260,   328,  -260,   330,  -260,   114,   341,  -260,  -260,
    -260,  -260,   327,  -260,   329,   331,  -260,   333,  -260,  -260,
     335,   336,   338,  -260,   334,  -260,  -260,  -260,  -260,   337,
     339,   340,   345,   342,    13,  -260,  -260,  -260,  -260,  -260,
    -260,   347,  -260,  -260,   348,  -260,   122,  -260,   344,  -260,
     346,   350,   343,   201,   349,  -260,  -260,  -260,   351,  -260
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -260,   295,  -260,  -260,  -260,  -260,  -260,  -148,    -6,  -260,
    -259,   -94,   -14,   -67,  -260,   -47,  -196,  -260,  -260,  -260,
    -260,  -260,  -260,  -260,   358,  -260,  -260,   -82,  -260,  -260,
     104,  -260,   -57,  -260,  -260,  -260,  -260,  -152,  -260,    27,
    -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,
    -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,  -260,
     127,  -260,  -260,  -260,   -81,  -260,  -260,  -260,  -260,  -260,
    -260,  -260,   352,  -260,  -260,  -260,  -260,  -260
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     203,   150,   306,   160,   105,   255,   137,    60,   113,   114,
     214,    65,   216,   161,   218,   155,   140,    12,    68,    69,
      70,    86,   145,   227,   100,   229,    98,   231,   115,   160,
     116,   296,   387,    57,   117,   118,   119,   120,   241,   161,
      87,    88,   101,    88,   158,   159,   194,   195,   297,   121,
     141,   204,    75,   259,   260,   168,   146,   420,   421,   422,
     423,   353,    71,   263,    72,   265,    58,   267,   138,    91,
     424,   100,   373,   211,   196,   209,   271,    61,   273,   298,
     275,    66,   122,   181,    93,    78,   374,   281,   100,   101,
     332,   102,   182,   336,   362,   183,   299,   285,   184,   329,
      94,   185,   388,   212,   213,    59,   101,   333,   112,   133,
     337,   363,   366,   186,   106,    73,   107,     1,     2,     3,
       4,     5,   258,     6,     7,   134,     8,     9,    10,   367,
      11,    12,    13,    14,    15,   372,   135,   373,   220,   222,
      88,    95,    74,    16,    17,    96,    18,    19,    20,    21,
     302,   374,   136,   352,   221,   223,   278,   234,    98,   279,
     246,   247,   235,    22,    23,    24,   248,    98,   431,    77,
      79,   432,   305,   354,   398,   108,   450,   109,   359,   451,
     156,    25,   208,    26,    62,    63,    64,   110,   125,   111,
     126,   127,    76,   128,   457,   129,   239,   130,   240,   239,
     239,   262,   264,   239,   239,   266,   270,   239,   239,   272,
     274,   239,   239,   282,   303,   239,   239,   304,   308,   239,
     340,   309,   239,   239,   310,   313,   239,    80,   314,   239,
     330,   315,   331,   377,   378,   410,   411,   334,   344,   335,
     345,   390,   394,   391,   395,   402,   404,   403,   405,   142,
     143,   288,   289,    81,    82,    83,    84,    85,    89,   132,
      98,   149,   147,   151,   152,   153,   154,    87,   156,   172,
      95,   163,   173,   191,   157,   199,   165,   167,   200,   207,
     210,   169,   170,   171,   176,   178,   447,   180,   202,   243,
     224,   225,   226,   233,   242,   244,   256,   236,   237,   245,
     238,   160,   249,   250,   276,   253,   254,   277,   257,   280,
     261,   283,   268,   290,   301,   269,   338,   286,    24,   287,
     435,   360,   293,    90,   321,   294,   322,   295,   371,   311,
     312,   328,   425,   300,   316,   317,   318,   319,   239,   347,
     320,   350,   323,   351,   324,   325,   356,   327,   326,   339,
     342,   343,   426,   357,   346,   355,   358,   361,   365,   369,
      88,   364,   379,   368,   305,   383,   380,   381,   382,   392,
     396,   284,   409,   412,   384,   415,   393,   385,   386,   417,
     399,   397,   401,   400,   406,   413,   428,   433,   407,   438,
     439,   414,   440,    92,   387,   416,   429,   418,   430,   419,
     434,   448,   449,   458,   436,   441,   437,   341,   408,     0,
     442,   444,   443,   445,   446,   453,   456,   454,   455,     0,
       0,     0,     0,     0,   459,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   174
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-260)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     148,    83,   261,     3,    61,   201,    10,     4,    65,    66,
     162,     4,   164,    13,   166,    96,    38,    19,    28,    29,
      30,    28,    38,   175,    54,   177,    59,   179,    17,     3,
      19,    54,    65,    74,    23,    24,    25,    26,   190,    13,
      47,    50,    72,    50,   101,   102,    33,    34,    71,    38,
      72,    60,    29,   205,   206,   112,    72,    41,    42,    43,
      44,   320,    72,   215,    74,   217,    74,   219,    72,    71,
      54,    54,    56,    73,    61,   156,   228,    74,   230,    54,
     232,    74,    71,    45,    54,    29,    70,   239,    54,    72,
      54,    74,    54,    54,    54,    57,    71,   245,    60,   295,
      70,    63,   361,   160,   161,    74,    72,    71,    74,    54,
      71,    71,    54,    75,    72,    74,    74,     5,     6,     7,
       8,     9,   204,    11,    12,    70,    14,    15,    16,    71,
      18,    19,    20,    21,    22,    54,    54,    56,    54,    54,
      50,    68,    74,    31,    32,    72,    34,    35,    36,    37,
      60,    70,    70,    54,    70,    70,    54,    71,    59,    57,
      66,    67,    76,    51,    52,    53,    72,    59,    54,    68,
      39,    57,    64,   321,   370,    72,    54,    74,   326,    57,
      71,    69,    73,    71,    28,    29,    30,    72,    72,    74,
      74,    72,    54,    74,   453,    72,    71,    74,    73,    71,
      71,    73,    73,    71,    71,    73,    73,    71,    71,    73,
      73,    71,    71,    73,    73,    71,    71,    73,    73,    71,
     302,    73,    71,    71,    73,    73,    71,    29,    73,    71,
      71,    73,    73,    54,    55,   383,   384,    71,    71,    73,
      73,    71,    71,    73,    73,    71,    71,    73,    73,    66,
      67,    66,    67,     6,    68,    49,    29,    57,     0,    72,
      59,    71,    74,    72,    68,    72,    71,    47,    71,    27,
      68,    72,    27,    54,    71,    40,    72,    72,    40,    48,
      54,    74,    74,    74,    72,    72,   434,    72,    60,    73,
      54,    74,    74,    72,    71,    71,    71,    68,    76,    58,
      68,     3,    72,    54,    54,    72,    72,    54,    71,    54,
      71,    54,    72,    54,    29,    72,    72,    71,    53,    71,
     414,   327,    71,    28,    54,    73,    54,    71,   342,    68,
      68,    54,   399,    73,    71,    71,    68,    71,    71,    57,
      71,    54,    71,    54,    71,    71,    54,    71,    73,    71,
      71,    71,   399,    54,    73,    71,    54,    71,    54,    54,
      50,    73,    68,    73,    64,    54,    73,    71,    71,    54,
      54,   244,    54,    54,    73,    54,    73,    71,    71,    54,
      71,    73,    68,    71,    71,    62,    54,    46,    71,    54,
      54,    71,    54,    35,    65,    73,    68,    73,    68,    73,
      73,    54,    54,    54,    73,    71,    73,   303,   381,    -1,
      73,    71,    73,    68,    72,    71,    73,    71,    68,    -1,
      -1,    -1,    -1,    -1,    73,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   124
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    21,    22,    31,    32,    34,    35,
      36,    37,    51,    52,    53,    69,    71,    78,    79,    80,
      82,    95,    97,    99,   101,   102,   103,   104,   105,   107,
     108,   112,   113,   119,   128,   135,   139,   140,   142,   143,
     144,   145,   146,   147,   148,   151,   154,    74,    74,    74,
       4,    74,    28,    29,    30,     4,    74,   152,    28,    29,
      30,    72,    74,    74,    74,    29,    54,    68,    29,    39,
      29,     6,    68,    49,    29,    57,    28,    47,    50,     0,
      78,    71,   101,    54,    70,    68,    72,   141,    59,    87,
      54,    72,    74,   109,   110,   109,    72,    74,    72,    74,
      72,    74,    74,   109,   109,    17,    19,    23,    24,    25,
      26,    38,    71,   149,   150,    72,    74,    72,    74,    72,
      74,   127,    72,    54,    70,    54,    70,    10,    72,    83,
      38,    72,    66,    67,   153,    38,    72,    74,    81,    71,
     104,    72,    68,    72,    71,   141,    71,    71,   109,   109,
       3,    13,   132,    72,   130,    72,   134,    72,   109,    74,
      74,    74,    27,    27,   149,   123,    72,   121,    72,   125,
      72,    45,    54,    57,    60,    63,    75,    91,   114,   115,
     126,    54,   137,   138,    33,    34,    61,    84,    98,    40,
      40,    96,    60,    84,    60,   106,   136,    48,    73,   141,
      54,    73,   109,   109,   114,   131,   114,   129,   114,   133,
      54,    70,    54,    70,    54,    74,    74,   114,   122,   114,
     120,   114,   124,    72,    71,    76,    68,    76,    68,    71,
      73,   114,    71,    73,    71,    58,    66,    67,    72,    72,
      54,    93,    94,    72,    72,    93,    71,    71,   104,   114,
     114,    71,    73,   114,    73,   114,    73,   114,    72,    72,
      73,   114,    73,   114,    73,   114,    54,    54,    54,    57,
      54,   114,    73,    54,   137,    84,    71,    71,    66,    67,
      54,    85,    86,    71,    73,    71,    54,    71,    54,    71,
      73,    29,    60,    73,    73,    64,    87,    89,    73,    73,
      73,    68,    68,    73,    73,    73,    71,    71,    68,    71,
      71,    54,    54,    71,    71,    71,    73,    71,    54,    93,
      71,    73,    54,    71,    71,    73,    54,    71,    72,    71,
     104,   107,    71,    71,    71,    73,    73,    57,   116,   117,
      54,    54,    54,    87,    84,    71,    54,    54,    54,    84,
      85,    71,    54,    71,    73,    54,    54,    71,    73,    54,
     100,    89,    54,    56,    70,    90,    92,    54,    55,    68,
      73,    71,    71,    54,    73,    71,    71,    65,    87,    88,
      71,    73,    54,    73,    71,    73,    54,    73,    93,    71,
      71,    68,    71,    73,    71,    73,    71,    71,   116,    54,
      84,    84,    54,    62,    71,    54,    73,    54,    73,    73,
      41,    42,    43,    44,    54,    90,    92,   111,    54,    68,
      68,    54,    57,    46,    73,    88,    73,    73,    54,    54,
      54,    71,    73,    73,    71,    68,    72,    84,    54,    54,
      54,    57,   118,    71,    71,    68,    73,    87,    54,    73
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
#line 203 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 204 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 205 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 206 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 207 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 208 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 209 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 210 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 211 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 212 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 213 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 214 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 215 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 216 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 217 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 218 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 219 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 220 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 221 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 222 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 223 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 224 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 225 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 226 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 228 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 229 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 230 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 234 "..\\..\\parser.y"
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

  case 32:
/* Line 1792 of yacc.c  */
#line 245 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 251 "..\\..\\parser.y"
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

  case 34:
/* Line 1792 of yacc.c  */
#line 262 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 268 "..\\..\\parser.y"
    { 	
        strcat(szMexToken, " record org instruction "); 
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 284 "..\\..\\parser.y"
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

  case 37:
/* Line 1792 of yacc.c  */
#line 295 "..\\..\\parser.y"
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

  case 38:
/* Line 1792 of yacc.c  */
#line 304 "..\\..\\parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (9)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (9)].number));
            file_setMaxLength(current_file,(yyvsp[(7) - (9)].number));
        }
        free((yyvsp[(3) - (9)].string));
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 313 "..\\..\\parser.y"
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

  case 40:
/* Line 1792 of yacc.c  */
#line 322 "..\\..\\parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (7)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (7)].number));
            file_setMaxLength(current_file,(yyvsp[(5) - (7)].number));
        }
        free((yyvsp[(3) - (7)].string));
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 331 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 337 "..\\..\\parser.y"
    { 
        strcat(szMexToken, " key instruction ");
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 340 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 344 "..\\..\\parser.y"
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

  case 45:
/* Line 1792 of yacc.c  */
#line 359 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 365 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 372 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 384 "..\\..\\parser.y"
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

  case 49:
/* Line 1792 of yacc.c  */
#line 399 "..\\..\\parser.y"
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

  case 50:
/* Line 1792 of yacc.c  */
#line 414 "..\\..\\parser.y"
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

  case 51:
/* Line 1792 of yacc.c  */
#line 427 "..\\..\\parser.y"
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

  case 52:
/* Line 1792 of yacc.c  */
#line 446 "..\\..\\parser.y"
    {
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 448 "..\\..\\parser.y"
    {
        
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 454 "..\\..\\parser.y"
    {
            /* Sort Fields */
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
            /* JoinKeys */
        if (current_sortField==3) {             
            struct sortField_t *joinField;
            joinField=sortField_constructor((yyvsp[(1) - (5)].number),(yyvsp[(3) - (5)].number),0, (yyvsp[(5) - (5)].number));
			if (joinField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            join_addDefinitionJoin(current_filejoin, joinField);
            nTypeFormat = 1;
        }
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 478 "..\\..\\parser.y"
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

  case 56:
/* Line 1792 of yacc.c  */
#line 493 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 495 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 500 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 508 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 511 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 517 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 527 "..\\..\\parser.y"
    {
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
        if (memcmp((yyvsp[(4) - (7)].string),(char*) "F1",2)==0) {
            current_filejoin = 1;
        }
        if (memcmp((yyvsp[(4) - (7)].string),(char*) "F2",2)==0) {
            current_filejoin = 2;
        }
        }
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 545 "..\\..\\parser.y"
    {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 554 "..\\..\\parser.y"
    {}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 555 "..\\..\\parser.y"
    {}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 559 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 563 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 567 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 571 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 595 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 601 "..\\..\\parser.y"
    {
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
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 614 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            if (memcmp((yyvsp[(4) - (5)].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'U');
                join_setUnpaired(2, 'I');
            }
            if (memcmp((yyvsp[(4) - (5)].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'I');
                join_setUnpaired(2, 'U');
            }
        }
        if (nOnly  == 1) {
            if (memcmp((yyvsp[(4) - (5)].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'O');
                join_setUnpaired(2, 'S');
            }
            if (memcmp((yyvsp[(4) - (5)].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'S');
                join_setUnpaired(2, 'O');
            }
        }
        nOnly=0;
        free((yyvsp[(4) - (5)].string)); 
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 640 "..\\..\\parser.y"
    {          
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
        free((yyvsp[(4) - (7)].string)); 
        free((yyvsp[(6) - (7)].string)); 
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 658 "..\\..\\parser.y"
    {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 679 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 684 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 691 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        strcpy(szMexToken, " join fill clause ");
        /* fill character * */
        join_fillbuff(current_filejoin, current_join, (yyvsp[(2) - (3)].string), (yyvsp[(3) - (3)].string));
        free((yyvsp[(2) - (3)].string));
        free((yyvsp[(3) - (3)].string));
}
    break;

  case 80:
/* Line 1792 of yacc.c  */
#line 707 "..\\..\\parser.y"
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

  case 81:
/* Line 1792 of yacc.c  */
#line 729 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 732 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
		strcat(szMexToken, " condition field ");
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 736 "..\\..\\parser.y"
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

  case 84:
/* Line 1792 of yacc.c  */
#line 745 "..\\..\\parser.y"
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

  case 85:
/* Line 1792 of yacc.c  */
#line 763 "..\\..\\parser.y"
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

  case 86:
/* Line 1792 of yacc.c  */
#line 779 "..\\..\\parser.y"
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

  case 87:
/* Line 1792 of yacc.c  */
#line 793 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 805 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 817 "..\\..\\parser.y"
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

  case 90:
/* Line 1792 of yacc.c  */
#line 831 "..\\..\\parser.y"
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

  case 91:
/* Line 1792 of yacc.c  */
#line 845 "..\\..\\parser.y"
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

  case 92:
/* Line 1792 of yacc.c  */
#line 863 "..\\..\\parser.y"
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

  case 93:
/* Line 1792 of yacc.c  */
#line 880 "..\\..\\parser.y"
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

  case 94:
/* Line 1792 of yacc.c  */
#line 904 "..\\..\\parser.y"
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

  case 95:
/* Line 1792 of yacc.c  */
#line 920 "..\\..\\parser.y"
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

  case 96:
/* Line 1792 of yacc.c  */
#line 947 "..\\..\\parser.y"
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

  case 97:
/* Line 1792 of yacc.c  */
#line 965 "..\\..\\parser.y"
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

  case 98:
/* Line 1792 of yacc.c  */
#line 989 "..\\..\\parser.y"
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

  case 99:
/* Line 1792 of yacc.c  */
#line 1009 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1015 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1024 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1030 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1041 "..\\..\\parser.y"
    {	
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1043 "..\\..\\parser.y"
    {	}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1051 "..\\..\\parser.y"
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
        case JOIN_CASE :
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
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
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1123 "..\\..\\parser.y"
    {
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
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1138 "..\\..\\parser.y"
    {
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            if (memcmp((yyvsp[(1) - (5)].string),(char*) "F1",2)==0) {
                current_filejoin = 1;
            }
            if (memcmp((yyvsp[(1) - (5)].string),(char*) "F2",2)==0) {
                current_filejoin = 2;
            }
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[(3) - (5)].number),(yyvsp[(5) - (5)].number));
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }

            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            free((yyvsp[(1) - (5)].string));
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1164 "..\\..\\parser.y"
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

  case 109:
/* Line 1792 of yacc.c  */
#line 1209 "..\\..\\parser.y"
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

  case 110:
/* Line 1792 of yacc.c  */
#line 1251 "..\\..\\parser.y"
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

  case 111:
/* Line 1792 of yacc.c  */
#line 1295 "..\\..\\parser.y"
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

  case 112:
/* Line 1792 of yacc.c  */
#line 1339 "..\\..\\parser.y"
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

  case 113:
/* Line 1792 of yacc.c  */
#line 1384 "..\\..\\parser.y"
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

  case 114:
/* Line 1792 of yacc.c  */
#line 1438 "..\\..\\parser.y"
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

  case 115:
/* Line 1792 of yacc.c  */
#line 1478 "..\\..\\parser.y"
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

  case 116:
/* Line 1792 of yacc.c  */
#line 1534 "..\\..\\parser.y"
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

  case 117:
/* Line 1792 of yacc.c  */
#line 1554 "..\\..\\parser.y"
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

  case 118:
/* Line 1792 of yacc.c  */
#line 1576 "..\\..\\parser.y"
    { 
        strcat(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 1580 "..\\..\\parser.y"
    {}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 1588 "..\\..\\parser.y"
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

  case 121:
/* Line 1792 of yacc.c  */
#line 1619 "..\\..\\parser.y"
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

  case 122:
/* Line 1792 of yacc.c  */
#line 1647 "..\\..\\parser.y"
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

  case 123:
/* Line 1792 of yacc.c  */
#line 1662 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1667 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 1673 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1678 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 1683 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 128:
/* Line 1792 of yacc.c  */
#line 1688 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1694 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1699 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1704 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 1709 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 1716 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 1721 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 1732 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 1737 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 1742 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 1747 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 1756 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 1761 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 141:
/* Line 1792 of yacc.c  */
#line 1766 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 1771 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 1776 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 1781 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 1786 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 1791 "..\\..\\parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 1796 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 1801 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 1808 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 1813 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 1823 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 1828 "..\\..\\parser.y"
    {
		/*  current_inrec=0;    */
		nRecCase=0;
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 1834 "..\\..\\parser.y"
    {}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 1835 "..\\..\\parser.y"
    {}
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 1838 "..\\..\\parser.y"
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

  case 156:
/* Line 1792 of yacc.c  */
#line 1848 "..\\..\\parser.y"
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

  case 157:
/* Line 1792 of yacc.c  */
#line 1865 "..\\..\\parser.y"
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

  case 158:
/* Line 1792 of yacc.c  */
#line 1877 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 1881 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 1888 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 1894 "..\\..\\parser.y"
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

  case 162:
/* Line 1792 of yacc.c  */
#line 1913 "..\\..\\parser.y"
    {
		strcat(szMexToken, " group files outfil ");
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 1919 "..\\..\\parser.y"
    {
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 1921 "..\\..\\parser.y"
    {
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 1923 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 1927 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 1933 "..\\..\\parser.y"
    {
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
			    join_IncludeCondField(current_filejoin, current_join, (yyvsp[(3) - (3)].condField));
        }
		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 1945 "..\\..\\parser.y"
    {
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
                join_OmitCondField(current_filejoin, current_join, (yyvsp[(3) - (3)].condField));
        }
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
}
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 1957 "..\\..\\parser.y"
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

  case 170:
/* Line 1792 of yacc.c  */
#line 1973 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 1978 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 1986 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 1991 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 1998 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2007 "..\\..\\parser.y"
    {}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2009 "..\\..\\parser.y"
    {}
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2012 "..\\..\\parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2016 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2020 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2024 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2028 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2032 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2036 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2040 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2045 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 186:
/* Line 1792 of yacc.c  */
#line 2052 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 187:
/* Line 1792 of yacc.c  */
#line 2058 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 188:
/* Line 1792 of yacc.c  */
#line 2064 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2071 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2077 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2086 "..\\..\\parser.y"
    {
}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2087 "..\\..\\parser.y"
    {
}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2098 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2104 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2110 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 196:
/* Line 1792 of yacc.c  */
#line 2116 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2122 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 198:
/* Line 1792 of yacc.c  */
#line 2128 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 199:
/* Line 1792 of yacc.c  */
#line 2134 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2141 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2147 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 202:
/* Line 1792 of yacc.c  */
#line 2153 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2159 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2165 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2171 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2177 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2188 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


/* Line 1792 of yacc.c  */
#line 4584 "..\\..\\parser.c"
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
#line 2193 "..\\..\\parser.y"

