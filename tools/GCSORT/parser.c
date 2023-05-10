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
#line 270 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 276 "..\\..\\parser.y"
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
#line 287 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 293 "..\\..\\parser.y"
    { 	
        strcpy(szMexToken, " record org instruction "); 
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 309 "..\\..\\parser.y"
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
#line 320 "..\\..\\parser.y"
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
#line 329 "..\\..\\parser.y"
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
#line 338 "..\\..\\parser.y"
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
#line 347 "..\\..\\parser.y"
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
#line 356 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 362 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " key instruction ");
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
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 434 "..\\..\\parser.y"
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

  case 52:
/* Line 1792 of yacc.c  */
#line 449 "..\\..\\parser.y"
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

  case 53:
/* Line 1792 of yacc.c  */
#line 462 "..\\..\\parser.y"
    {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
		#else
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
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
        
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 489 "..\\..\\parser.y"
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

  case 57:
/* Line 1792 of yacc.c  */
#line 513 "..\\..\\parser.y"
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

  case 58:
/* Line 1792 of yacc.c  */
#line 528 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 530 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 535 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 543 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 546 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 552 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 562 "..\\..\\parser.y"
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

  case 65:
/* Line 1792 of yacc.c  */
#line 580 "..\\..\\parser.y"
    {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
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
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 598 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 602 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 606 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 630 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 636 "..\\..\\parser.y"
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

  case 74:
/* Line 1792 of yacc.c  */
#line 649 "..\\..\\parser.y"
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

  case 75:
/* Line 1792 of yacc.c  */
#line 675 "..\\..\\parser.y"
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

  case 77:
/* Line 1792 of yacc.c  */
#line 693 "..\\..\\parser.y"
    {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 713 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 718 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 725 "..\\..\\parser.y"
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

  case 82:
/* Line 1792 of yacc.c  */
#line 741 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " format clause ");
        nFieldType = (yyvsp[(3) - (3)].number);    /* save field type */
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 3)	/* for SumFields    */
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
    }
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 752 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " format clause substring ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 3)	
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
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
		strcpy(szMexToken, " condition field 01 ");
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 784 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 02 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 110, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 793 "..\\..\\parser.y"
    {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[(1) - (3)].condField), (yyvsp[(3) - (3)].condField));
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 03 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 111, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 811 "..\\..\\parser.y"
    {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[(1) - (13)].number),(yyvsp[(3) - (13)].number),(yyvsp[(5) - (13)].number),(yyvsp[(7) - (13)].number),(yyvsp[(9) - (13)].number),(yyvsp[(11) - (13)].number),(yyvsp[(13) - (13)].number));
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 04 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 827 "..\\..\\parser.y"
    {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),0,(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].number),0);
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 05 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 841 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcpy(szMexToken, " condition field 06 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 853 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcpy(szMexToken, " condition field 07 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 865 "..\\..\\parser.y"
    {    
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),nFieldType,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 08 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 880 "..\\..\\parser.y"
    {    
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),nFieldType,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue)); 
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 09 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 895 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition4Date((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(struct fieldValue_t *)(yyvsp[(9) - (9)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 10 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 141, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 913 "..\\..\\parser.y"
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

  case 96:
/* Line 1792 of yacc.c  */
#line 930 "..\\..\\parser.y"
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

  case 97:
/* Line 1792 of yacc.c  */
#line 954 "..\\..\\parser.y"
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

  case 98:
/* Line 1792 of yacc.c  */
#line 970 "..\\..\\parser.y"
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

  case 99:
/* Line 1792 of yacc.c  */
#line 997 "..\\..\\parser.y"
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

  case 100:
/* Line 1792 of yacc.c  */
#line 1015 "..\\..\\parser.y"
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

  case 101:
/* Line 1792 of yacc.c  */
#line 1039 "..\\..\\parser.y"
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

  case 102:
/* Line 1792 of yacc.c  */
#line 1059 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[(3) - (3)].condField));
        else 
            condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1068 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[(4) - (4)].condField));
        else 
            condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1080 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[(3) - (3)].condField));
        else 
            condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1089 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[(4) - (4)].condField));
        else 
            condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1113 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1119 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
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
                outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
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

  case 111:
/* Line 1792 of yacc.c  */
#line 1213 "..\\..\\parser.y"
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

  case 112:
/* Line 1792 of yacc.c  */
#line 1228 "..\\..\\parser.y"
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

  case 113:
/* Line 1792 of yacc.c  */
#line 1254 "..\\..\\parser.y"
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

  case 114:
/* Line 1792 of yacc.c  */
#line 1299 "..\\..\\parser.y"
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

  case 115:
/* Line 1792 of yacc.c  */
#line 1341 "..\\..\\parser.y"
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

  case 116:
/* Line 1792 of yacc.c  */
#line 1385 "..\\..\\parser.y"
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

  case 117:
/* Line 1792 of yacc.c  */
#line 1429 "..\\..\\parser.y"
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

  case 118:
/* Line 1792 of yacc.c  */
#line 1474 "..\\..\\parser.y"
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

  case 119:
/* Line 1792 of yacc.c  */
#line 1528 "..\\..\\parser.y"
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

  case 120:
/* Line 1792 of yacc.c  */
#line 1568 "..\\..\\parser.y"
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
                    outfil_addoutfilrec(current_outfil, outrec);
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

  case 121:
/* Line 1792 of yacc.c  */
#line 1624 "..\\..\\parser.y"
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

  case 122:
/* Line 1792 of yacc.c  */
#line 1644 "..\\..\\parser.y"
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

  case 123:
/* Line 1792 of yacc.c  */
#line 1664 "..\\..\\parser.y"
    {
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
                findrep_field = findrepfield_constructor((yyvsp[(3) - (8)].fieldValue), (yyvsp[(7) - (8)].fieldValue));
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
                findrep_field = findrepfield_constructor((yyvsp[(3) - (8)].fieldValue), (yyvsp[(7) - (8)].fieldValue));
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
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1755 "..\\..\\parser.y"
    {
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
                findrepfield_setOutForAll(findrep_field, (yyvsp[(9) - (10)].fieldValue));
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
                findrepfield_setOutForAll(findrep_field, (yyvsp[(9) - (10)].fieldValue));
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
    }
    break;

  case 125:
/* Line 1792 of yacc.c  */
#line 1846 "..\\..\\parser.y"
    {
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
    }
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1939 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " findrep_options instruction ");
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
            findrep_setStartPos(findrep, (yyvsp[(3) - (3)].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP STARTPOS ");
            findrep_setStartPos(findrep, (yyvsp[(3) - (3)].number));            
            break;
        default:
            break;
        }
    }
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1967 "..\\..\\parser.y"
    {
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
            findrep_setEndPos(findrep, (yyvsp[(3) - (3)].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ENDPOS ");
            findrep_setEndPos(findrep, (yyvsp[(3) - (3)].number));            
            break;
        default:
            break;
        }
    }
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1988 "..\\..\\parser.y"
    {
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
            findrep_setDo(findrep, (yyvsp[(3) - (3)].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP DO ");
            findrep_setDo(findrep, (yyvsp[(3) - (3)].number));            
            break;
        default:
            break;
        }
    }
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 2009 "..\\..\\parser.y"
    {
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
            findrep_setMaxLen(findrep, (yyvsp[(3) - (3)].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP MAXLEN ");
            findrep_setMaxLen(findrep, (yyvsp[(3) - (3)].number));            
            break;
        default:
            break;
        }
    }
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 2031 "..\\..\\parser.y"
    {
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[(3) - (3)].string), "TRUNC") == 0)
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
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 2056 "..\\..\\parser.y"
    {
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[(3) - (3)].string), "NO") == 0)
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
        free((yyvsp[(3) - (3)].string));
    }
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 2083 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " allfieldvaluerec instruction ");
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
        }
        else
        {
            findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
            findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
        }
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 2095 "..\\..\\parser.y"
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
    }
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 2110 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " inoutfieldvaluerec instruction ");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[(1) - (1)].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[(1) - (1)].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[(1) - (1)].fieldValue), (struct fieldValue_t*) field_tmp);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
                nSwitchFR = 0;
            }
        }
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 2131 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inoutfieldvaluerec instruction 2");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[(1) - (3)].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[(1) - (3)].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[(1) - (3)].fieldValue), (struct fieldValue_t*) field_tmp);
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
    }
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 2174 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " changepairdet instruction ");
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

  case 142:
/* Line 1792 of yacc.c  */
#line 2217 "..\\..\\parser.y"
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

  case 143:
/* Line 1792 of yacc.c  */
#line 2245 "..\\..\\parser.y"
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

  case 144:
/* Line 1792 of yacc.c  */
#line 2260 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2265 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2271 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 2276 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 2281 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 2286 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2292 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2297 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2302 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2307 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2314 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2319 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2325 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2330 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2335 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2340 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2346 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2351 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2361 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2366 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2371 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2376 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2385 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2390 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2395 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2400 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2405 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2410 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2415 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2420 "..\\..\\parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2425 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2430 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2437 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2442 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2448 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2453 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2458 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2463 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2469 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2474 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2483 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2488 "..\\..\\parser.y"
    {
		/*  current_inrec=0;    */
		nRecCase=0;
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
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			/* for SumFields Format=    */
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2508 "..\\..\\parser.y"
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

  case 190:
/* Line 1792 of yacc.c  */
#line 2525 "..\\..\\parser.y"
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

  case 191:
/* Line 1792 of yacc.c  */
#line 2537 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2541 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2548 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2554 "..\\..\\parser.y"
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
        outfil_SetVirtualFile(current_outfil, 0);       /* OUTFIL has file name */
        free((yyvsp[(1) - (1)].string));
        strcpy(szMexToken, " files clause ");
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2574 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " group files outfil ");
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
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 199:
/* Line 1792 of yacc.c  */
#line 2588 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2594 "..\\..\\parser.y"
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

  case 201:
/* Line 1792 of yacc.c  */
#line 2606 "..\\..\\parser.y"
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

  case 202:
/* Line 1792 of yacc.c  */
#line 2618 "..\\..\\parser.y"
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

  case 203:
/* Line 1792 of yacc.c  */
#line 2634 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2639 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2647 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2652 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2659 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
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
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 211:
/* Line 1792 of yacc.c  */
#line 2677 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 212:
/* Line 1792 of yacc.c  */
#line 2681 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2685 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2689 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2693 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2697 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2701 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2706 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2713 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2719 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2725 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
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
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2738 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
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
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2765 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2771 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2777 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2783 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 231:
/* Line 1792 of yacc.c  */
#line 2789 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2795 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 233:
/* Line 1792 of yacc.c  */
#line 2802 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2808 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2814 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2820 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2826 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 238:
/* Line 1792 of yacc.c  */
#line 2832 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 239:
/* Line 1792 of yacc.c  */
#line 2838 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 240:
/* Line 1792 of yacc.c  */
#line 2849 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


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

