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
     ORDER = 329,
     RECTYPEFIX = 330,
     RECTYPEVAR = 331,
     STRING = 332,
     TOKSKIP = 333,
     EXROUT = 334,
     YESNO = 335,
     ERRTRUNC = 336,
     SIGNDIGITBIG = 337
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
#line 208 "..\\..\\parser.c"
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
#line 236 "..\\..\\parser.c"
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
	int  nstate_outfil = 0;
    int  nOnly=0;



/* Line 391 of yacc.c  */
#line 324 "..\\..\\parser.c"

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
#define YYNTOKENS  89
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  88
/* YYNRULES -- Number of rules.  */
#define YYNRULES  237
/* YYNRULES -- Number of states.  */
#define YYNSTATES  536

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   337

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      84,    85,     2,     2,    83,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    88,     2,
       2,    86,     2,    87,     2,     2,     2,     2,     2,     2,
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
      75,    76,    77,    78,    79,    80,    81,    82
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
     369,   374,   378,   383,   389,   396,   398,   402,   406,   408,
     414,   419,   425,   427,   430,   434,   436,   438,   441,   453,
     467,   476,   487,   494,   496,   500,   501,   505,   509,   513,
     517,   521,   525,   527,   531,   533,   537,   539,   543,   549,
     556,   559,   560,   568,   569,   576,   577,   585,   586,   593,
     594,   602,   603,   610,   611,   617,   618,   626,   627,   632,
     633,   640,   641,   647,   648,   656,   657,   664,   665,   673,
     674,   681,   682,   690,   691,   698,   699,   705,   706,   714,
     715,   720,   721,   728,   730,   734,   738,   746,   752,   756,
     762,   764,   766,   770,   776,   780,   782,   785,   789,   793,
     795,   799,   803,   807,   811,   813,   815,   818,   820,   824,
     828,   832,   836,   838,   840,   844,   851,   858,   867,   878,
     887,   898,   899,   903,   905,   911,   919,   926,   936,   944,
     953,   955,   961,   969,   976,   986,   994,  1003
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      90,     0,    -1,    -1,    91,    90,    -1,   176,    -1,   107,
      -1,   109,    -1,   111,    -1,   115,    -1,   117,    -1,   113,
      -1,   116,    -1,   119,    -1,    92,    -1,    94,    -1,   120,
      -1,   168,    -1,   169,    -1,   125,    -1,   124,    -1,   147,
      -1,   161,    -1,   135,    -1,   162,    -1,   167,    -1,   165,
      -1,   166,    -1,   164,    -1,   170,    -1,   173,    -1,   157,
      -1,    -1,    36,    77,    93,    96,    -1,    -1,    30,    77,
      95,    96,    -1,    -1,    32,    67,    96,    -1,    33,    76,
      83,    63,    83,    63,    96,    -1,    33,    84,    76,    83,
      63,    83,    63,    85,    96,    -1,    33,    75,    83,    63,
      96,    -1,    33,    84,    75,    83,    63,    85,    96,    -1,
      70,    84,    97,    85,    96,    -1,    98,    -1,    98,    83,
      97,    -1,    63,    83,    63,    83,    71,    -1,    68,    -1,
      74,    -1,    73,    -1,    65,    77,    -1,    66,    77,    -1,
      63,    -1,    82,    -1,   106,    -1,   106,    83,   105,    -1,
      63,    83,    63,    83,   100,    -1,    63,    83,    63,    83,
      99,    83,   100,    -1,    -1,    34,    28,    84,   108,   105,
      85,    -1,    34,    28,    37,    -1,    -1,    31,    28,    84,
     110,   105,    85,    -1,    31,    28,    37,    -1,    -1,    35,
       6,    86,    69,    83,    28,    84,   112,   105,    85,    -1,
     114,    -1,   114,   113,    -1,    83,    46,    -1,    83,    46,
      83,    47,    -1,    19,    86,    82,    -1,    19,    86,    63,
      -1,    50,    48,    -1,    50,    48,   116,    -1,    50,    48,
      83,    69,   116,    -1,    50,    48,    83,    69,    83,    69,
     116,    -1,    -1,    83,    49,    -1,    -1,    51,    28,    84,
     118,   126,    85,   119,    -1,    -1,    52,    66,    77,    -1,
       7,    86,    99,    -1,   122,    -1,    84,   121,    85,    -1,
     121,     3,   121,    -1,   121,    13,   121,    -1,    63,    83,
      63,    83,    99,    83,   101,    83,    63,    83,    63,    83,
      99,    -1,    63,    83,    63,    83,   101,    83,    63,    83,
      63,    -1,    63,    83,    63,    83,    99,    83,   101,    83,
     102,    -1,    63,    83,    63,    83,    99,    83,   101,    83,
     104,    -1,    63,    83,    63,    83,   101,    83,   104,    -1,
      63,    83,    63,    83,   101,    83,   102,    -1,    63,    83,
      63,    83,    99,    83,   101,    83,   123,    -1,    40,    -1,
      40,    63,    -1,    41,    -1,    41,    63,    -1,    42,    -1,
      42,    63,    -1,    43,    -1,    11,     4,   121,    -1,    11,
       4,    86,   121,    -1,     8,     4,   121,    -1,     8,     4,
      86,   121,    -1,     8,   120,    83,     4,   121,    -1,     8,
     120,    83,     4,    86,   121,    -1,   127,    -1,   126,    83,
     126,    -1,    63,    83,    63,    -1,    87,    -1,    69,    88,
      63,    83,    63,    -1,    63,    88,    66,    77,    -1,    63,
      88,    63,    83,    63,    -1,    72,    -1,    72,    77,    -1,
      63,    88,    66,    -1,    66,    -1,   103,    -1,    63,    83,
      -1,    44,    84,    63,    83,   132,    85,    83,    45,    84,
     134,    85,    -1,    44,    84,    63,    83,   132,    85,    83,
      45,    84,    63,    83,    63,    85,    -1,    54,    86,   103,
      83,    55,    86,   103,   128,    -1,    54,    86,    84,   130,
      85,    83,    55,    86,   103,   128,    -1,    56,    86,    84,
     131,    85,   128,    -1,   129,    -1,   129,    83,   128,    -1,
      -1,    57,    86,    63,    -1,    58,    86,    63,    -1,    59,
      86,    63,    -1,    60,    86,    63,    -1,    61,    86,    81,
      -1,    62,    86,    80,    -1,   103,    -1,   103,    83,   130,
      -1,   103,    -1,   103,    83,   131,    -1,   133,    -1,   133,
      83,   132,    -1,    66,    77,    83,    66,    77,    -1,    66,
      77,    83,    63,    83,    63,    -1,    66,    77,    -1,    -1,
      15,    28,    86,    84,   136,   126,    85,    -1,    -1,    15,
      28,    84,   137,   126,    85,    -1,    -1,    15,    27,    86,
      84,   138,   126,    85,    -1,    -1,    15,    27,    84,   139,
     126,    85,    -1,    -1,    15,    29,    86,    84,   140,   126,
      85,    -1,    -1,    15,    29,    84,   141,   126,    85,    -1,
      -1,    15,    53,    86,   142,   126,    -1,    -1,    15,    53,
      86,    84,   143,   126,    85,    -1,    -1,    15,    53,   144,
     126,    -1,    -1,    15,    86,    84,   145,   126,    85,    -1,
      -1,    15,    84,   146,   126,    85,    -1,    -1,     9,    28,
      86,    84,   148,   126,    85,    -1,    -1,     9,    28,    84,
     149,   126,    85,    -1,    -1,     9,    27,    86,    84,   150,
     126,    85,    -1,    -1,     9,    27,    84,   151,   126,    85,
      -1,    -1,     9,    29,    86,    84,   152,   126,    85,    -1,
      -1,     9,    29,    84,   153,   126,    85,    -1,    -1,     9,
      53,    86,   154,   126,    -1,    -1,     9,    53,    86,    84,
     155,   126,    85,    -1,    -1,     9,    53,   156,   126,    -1,
      -1,    83,    27,    84,   158,   126,    85,    -1,   160,    -1,
     160,    83,   159,    -1,    63,    83,    63,    -1,    63,    83,
      63,    83,    63,    83,    63,    -1,    63,    83,    63,    83,
      99,    -1,    20,    28,    10,    -1,    20,    28,    84,   159,
      85,    -1,    78,    -1,    77,    -1,   163,    83,   163,    -1,
       6,    86,    84,   163,    85,    -1,     6,    86,   163,    -1,
      21,    -1,    22,    63,    -1,     8,    86,   121,    -1,    11,
      86,   121,    -1,    14,    -1,    18,    86,    82,    -1,    18,
      86,    63,    -1,     5,    86,    82,    -1,     5,    86,    63,
      -1,    16,    -1,   172,    -1,   172,   171,    -1,    37,    -1,
      17,    86,    82,    -1,    17,    86,    63,    -1,    19,    86,
      82,    -1,    19,    86,    63,    -1,    23,    -1,    24,    -1,
      25,    86,    63,    -1,    83,    79,    86,    84,    77,    85,
      -1,    26,    79,    86,    84,    77,    85,    -1,    26,    79,
      86,    84,    77,    83,    64,    85,    -1,    26,    79,    86,
      84,    77,    83,    64,    83,    77,    85,    -1,    26,    79,
      86,    84,    77,    83,    63,    85,    -1,    26,    79,    86,
      84,    77,    83,    63,    83,    77,    85,    -1,    -1,    12,
     174,   171,    -1,    75,    -1,    75,    39,    84,    63,    85,
      -1,    75,    39,    84,    63,    83,    63,    85,    -1,    75,
      39,    84,    83,    63,    85,    -1,    75,    39,    84,    63,
      83,    63,    83,    63,    85,    -1,    75,    39,    84,    83,
      83,    63,    85,    -1,    75,    39,    84,    63,    83,    83,
      63,    85,    -1,    76,    -1,    76,    39,    84,    63,    85,
      -1,    76,    39,    84,    63,    83,    63,    85,    -1,    76,
      39,    84,    83,    63,    85,    -1,    76,    39,    84,    63,
      83,    63,    83,    63,    85,    -1,    76,    39,    84,    83,
      83,    63,    85,    -1,    76,    39,    84,    63,    83,    83,
      63,    85,    -1,    33,    38,   175,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   223,   223,   224,   226,   227,   228,   229,   230,   231,
     232,   233,   234,   235,   236,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   251,   252,
     253,   257,   257,   274,   274,   291,   307,   318,   327,   336,
     345,   354,   360,   363,   367,   382,   388,   395,   407,   422,
     437,   450,   469,   471,   477,   501,   516,   516,   523,   531,
     531,   540,   550,   550,   577,   578,   582,   586,   590,   594,
     618,   624,   637,   663,   680,   681,   701,   701,   712,   713,
     729,   764,   767,   771,   780,   798,   814,   828,   840,   852,
     866,   880,   898,   915,   939,   955,   982,  1000,  1024,  1044,
    1050,  1059,  1065,  1086,  1092,  1104,  1106,  1114,  1186,  1201,
    1227,  1272,  1314,  1358,  1402,  1447,  1501,  1541,  1597,  1617,
    1637,  1728,  1819,  1912,  1915,  1918,  1919,  1940,  1961,  1982,
    2004,  2029,  2056,  2067,  2083,  2103,  2147,  2151,  2159,  2190,
    2218,  2233,  2233,  2244,  2244,  2254,  2254,  2265,  2265,  2275,
    2275,  2287,  2287,  2298,  2298,  2308,  2308,  2319,  2319,  2334,
    2334,  2344,  2344,  2358,  2358,  2368,  2368,  2378,  2378,  2388,
    2388,  2398,  2398,  2410,  2410,  2421,  2421,  2431,  2431,  2442,
    2442,  2456,  2456,  2467,  2468,  2471,  2481,  2498,  2510,  2514,
    2521,  2527,  2546,  2552,  2554,  2556,  2560,  2566,  2578,  2590,
    2606,  2611,  2619,  2624,  2631,  2640,  2642,  2645,  2649,  2653,
    2657,  2661,  2665,  2669,  2673,  2677,  2684,  2691,  2697,  2704,
    2710,  2719,  2719,  2731,  2737,  2743,  2749,  2755,  2761,  2767,
    2774,  2780,  2786,  2792,  2798,  2804,  2810,  2821
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
     335,   336,   337,    44,    40,    41,    61,    63,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    89,    90,    90,    91,    91,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    91,    91,    91,
      91,    93,    92,    95,    94,    96,    96,    96,    96,    96,
      96,    96,    97,    97,    98,    99,   100,   101,   102,   103,
     104,   104,   105,   105,   106,   106,   108,   107,   107,   110,
     109,   109,   112,   111,   113,   113,   114,   114,   114,   114,
     115,   115,   115,   115,   116,   116,   118,   117,   119,   119,
     120,   121,   121,   121,   121,   122,   122,   122,   122,   122,
     122,   122,   123,   123,   123,   123,   123,   123,   123,   124,
     124,   125,   125,   125,   125,   126,   126,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     127,   127,   127,   128,   128,   129,   129,   129,   129,   129,
     129,   129,   130,   130,   131,   131,   132,   132,   133,   133,
     134,   136,   135,   137,   135,   138,   135,   139,   135,   140,
     135,   141,   135,   142,   135,   143,   135,   144,   135,   145,
     135,   146,   135,   148,   147,   149,   147,   150,   147,   151,
     147,   152,   147,   153,   147,   154,   147,   155,   147,   156,
     147,   158,   157,   159,   159,   160,   160,   160,   161,   161,
     162,   163,   163,   164,   164,   164,   164,   165,   166,   167,
     168,   168,   169,   169,   170,   171,   171,   172,   172,   172,
     172,   172,   172,   172,   172,   172,   172,   172,   172,   172,
     172,   174,   173,   175,   175,   175,   175,   175,   175,   175,
     175,   175,   175,   175,   175,   175,   175,   176
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
       4,     3,     4,     5,     6,     1,     3,     3,     1,     5,
       4,     5,     1,     2,     3,     1,     1,     2,    11,    13,
       8,    10,     6,     1,     3,     0,     3,     3,     3,     3,
       3,     3,     1,     3,     1,     3,     1,     3,     5,     6,
       2,     0,     7,     0,     6,     0,     7,     0,     6,     0,
       7,     0,     6,     0,     5,     0,     7,     0,     4,     0,
       6,     0,     5,     0,     7,     0,     6,     0,     7,     0,
       6,     0,     7,     0,     6,     0,     5,     0,     7,     0,
       4,     0,     6,     1,     3,     3,     7,     5,     3,     5,
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
       2,     0,     0,     0,     0,     0,     0,   221,   199,     0,
     204,     0,     0,     0,   195,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   190,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    64,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   179,     0,     0,     0,
       0,     0,     0,   157,   161,     0,     0,     0,     0,   196,
      33,     0,     0,     0,     0,    31,    70,     0,     0,     0,
      66,    75,     1,     3,     0,    65,   203,   202,   191,     0,
     194,    45,    80,     0,     0,     0,   101,    81,   197,     0,
     169,     0,   165,     0,   173,     0,   175,     0,     0,    99,
     198,     0,     0,   212,   213,     0,     0,   207,     0,   222,
     205,   147,     0,   143,     0,   151,     0,   153,     0,     0,
     159,   201,   200,    69,    68,   188,     0,    35,    61,    59,
     223,   230,   237,    58,    56,     0,    35,     0,    71,    76,
      79,   181,     0,     0,     0,     0,     0,   102,     0,     0,
       0,     0,   167,     0,   163,     0,   171,   177,     0,     0,
       0,     0,     0,   115,     0,   112,   108,   116,   180,   105,
     100,     0,     0,     0,     0,     0,   206,     0,   145,     0,
     141,     0,   149,   155,     0,   158,     0,     0,     0,     0,
     183,     0,     0,     0,    34,     0,     0,     0,     0,     0,
      32,    74,     0,     0,    67,   193,   192,     0,    82,    83,
      84,     0,   103,     0,     0,     0,     0,     0,     0,     0,
     176,     0,     0,     0,   117,     0,    49,     0,   113,     0,
     209,   208,   211,   210,   214,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   154,   162,     0,     0,   189,     0,
      35,     0,     0,     0,     0,     0,     0,    52,     0,     0,
       0,     0,     0,    72,     0,     0,     0,   104,   170,     0,
     166,     0,   174,     0,     0,     0,     0,     0,     0,     0,
     107,     0,   114,     0,   106,     0,     0,   148,     0,   144,
       0,   152,     0,     0,   160,   185,   184,    36,     0,     0,
       0,     0,     0,     0,    42,     0,    60,     0,     0,     0,
       0,     0,    57,     0,    74,    78,   182,    47,     0,     0,
     168,   164,   172,   178,     0,   132,     0,     0,   134,     0,
       0,   110,     0,     0,     0,   146,   142,   150,   156,     0,
      35,     0,     0,     0,     0,    35,     0,     0,    53,     0,
     224,     0,     0,     0,   231,     0,     0,    62,     0,    73,
      77,     0,     0,     0,     0,   136,     0,     0,     0,     0,
     125,   111,   109,     0,   216,   215,     0,   187,    39,     0,
       0,     0,     0,    41,    43,     0,     0,     0,   226,     0,
       0,     0,   233,     0,     0,     0,    50,     0,    51,    90,
      89,     0,     0,     0,   133,     0,     0,   135,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    35,
      35,     0,     0,    46,     0,    54,     0,   225,     0,   228,
       0,   232,     0,   235,     0,     0,     0,    48,     0,     0,
     137,     0,   125,     0,     0,     0,     0,     0,     0,   125,
       0,   219,     0,   217,   186,    37,    40,     0,    44,     0,
       0,   229,     0,   236,    63,    92,    94,    96,    98,    50,
      87,    88,    91,    86,     0,     0,     0,     0,   120,   126,
     127,   128,   129,   130,   131,   124,     0,     0,    35,    55,
     227,   234,    93,    95,    97,     0,     0,   138,     0,   125,
     220,   218,    38,     0,   139,     0,     0,     0,   121,     0,
       0,   140,   118,    85,     0,   119
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   156,    30,   147,   214,   323,   324,
     102,   445,   339,   419,   187,   420,   276,   277,    31,   218,
      32,   215,    33,   414,    34,    35,    36,    37,    38,   222,
      39,    40,   106,   107,   492,    41,    42,   188,   189,   434,
     435,   346,   349,   384,   385,   527,    43,   260,   199,   258,
     197,   262,   201,   204,   263,   138,   207,   139,    44,   236,
     173,   234,   171,   238,   175,   178,   239,   117,    45,   223,
     209,   210,    46,    47,   100,    48,    49,    50,    51,    52,
      53,    54,   129,   130,    55,    69,   152,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -434
static const yytype_int16 yypact[] =
{
     146,   -56,   -43,    86,     9,    35,     1,  -434,  -434,    -5,
    -434,   106,   121,   173,  -434,   185,    58,   182,   206,   254,
     285,   215,   245,   266,   229,  -434,    72,   296,   146,  -434,
    -434,  -434,  -434,  -434,  -434,    -1,  -434,  -434,  -434,  -434,
    -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,
    -434,  -434,  -434,  -434,  -434,  -434,  -434,    48,    59,   230,
     -25,   -18,   214,    14,    63,   134,   213,   -13,   -18,     2,
     135,   141,   144,   216,  -434,   217,    64,    77,    -4,  -434,
    -434,   -17,   112,     0,   218,  -434,   220,   221,   223,   222,
     224,  -434,  -434,  -434,   262,  -434,  -434,  -434,  -434,   232,
     227,  -434,  -434,   228,   -18,   -18,   181,  -434,   181,   308,
    -434,   231,  -434,   233,  -434,   234,   235,   139,   -18,   181,
     181,   236,   237,  -434,  -434,   238,   241,  -434,   242,  -434,
       2,  -434,   243,  -434,   244,  -434,   246,   247,   139,   139,
    -434,  -434,  -434,  -434,  -434,  -434,   250,    21,  -434,  -434,
     275,   277,  -434,  -434,  -434,   256,    21,   -38,  -434,  -434,
    -434,  -434,   279,    88,   232,   269,     4,   181,   -18,   -18,
       6,   139,  -434,   139,  -434,   139,  -434,  -434,   139,   249,
     248,   251,    13,   252,   253,   258,  -434,  -434,   255,  -434,
     181,    81,    87,   273,   257,   259,  -434,   139,  -434,   139,
    -434,   139,  -434,  -434,   139,   255,   148,   139,   261,   263,
     264,   272,   115,   265,  -434,   283,   267,   270,   283,   274,
    -434,   276,   139,   139,  -434,  -434,   227,   278,  -434,  -434,
     337,   -18,   181,   149,   139,   152,   139,   153,   139,   139,
     255,   287,    90,   271,   290,    75,  -434,   293,  -434,   139,
    -434,  -434,  -434,  -434,  -434,   280,   281,   156,   139,   157,
     139,   160,   139,   139,   255,  -434,   164,   295,  -434,   250,
      21,   284,   286,   147,   297,   288,   289,   292,   -23,    20,
     291,   314,    55,  -434,   168,   169,    29,   181,  -434,   172,
    -434,   175,  -434,   176,   179,   294,   252,   300,   298,   300,
    -434,   299,   301,   302,   255,   303,   306,  -434,   180,  -434,
     183,  -434,   184,   187,  -434,   304,  -434,  -434,   305,   307,
     309,   310,   311,   312,   313,   316,  -434,   283,   188,    43,
     191,    45,  -434,   315,   317,   320,  -434,  -434,   318,   319,
    -434,  -434,  -434,  -434,   322,   321,   323,   329,   324,   325,
     326,  -434,   327,   192,   328,  -434,  -434,  -434,  -434,   107,
      21,   331,   332,   335,   340,    21,   297,   333,  -434,    49,
    -434,   330,   342,    56,  -434,   334,   343,  -434,   360,  -434,
    -434,   338,    60,   341,   336,   339,   300,   344,   345,   300,
     155,  -434,  -434,   226,  -434,  -434,   346,  -434,  -434,   349,
     347,   350,   351,  -434,  -434,   -27,   195,   354,  -434,   352,
     196,   357,  -434,   353,   283,   356,   358,   348,  -434,  -434,
    -434,   359,   361,   322,  -434,   368,   300,  -434,   362,   363,
     364,   365,   366,   367,  -434,   371,   202,   203,   372,    21,
      21,   373,   355,  -434,   374,  -434,   377,  -434,   370,  -434,
     380,  -434,   375,  -434,   376,    -8,   382,  -434,   123,   379,
    -434,   378,   155,   383,   384,   393,   395,   282,   385,   155,
     386,  -434,   389,  -434,  -434,  -434,  -434,   387,  -434,   388,
     390,  -434,   391,  -434,  -434,   396,   404,   405,  -434,   394,
    -434,  -434,  -434,  -434,   397,   392,   398,   300,  -434,  -434,
    -434,  -434,  -434,  -434,  -434,  -434,   399,   400,    21,  -434,
    -434,  -434,  -434,  -434,  -434,   407,   408,  -434,   140,   155,
    -434,  -434,  -434,   403,  -434,   406,   401,   402,  -434,   230,
     410,  -434,  -434,  -434,   409,  -434
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -434,   446,  -434,  -434,  -434,  -434,  -434,  -156,     7,  -434,
    -283,  -117,     5,   -64,  -241,    24,  -214,  -434,  -434,  -434,
    -434,  -434,  -434,  -434,   448,  -434,  -434,   -84,  -434,  -434,
      93,   426,   -53,  -434,  -434,  -434,  -434,  -129,  -434,  -433,
    -434,    95,    99,    67,  -434,  -434,  -434,  -434,  -434,  -434,
    -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,
    -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,  -434,
     239,  -434,  -434,  -434,   -87,  -434,  -434,  -434,  -434,  -434,
    -434,  -434,   369,  -434,  -434,  -434,  -434,  -434
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     220,   298,   158,   338,   280,    67,   145,   168,   108,   205,
     206,    91,   163,    60,   119,   120,     3,   169,    12,   121,
     148,   122,    70,    71,    72,   123,   124,   125,   126,   498,
      57,   221,   485,   486,   487,   488,   505,   153,   103,   127,
     328,   101,   233,    58,   235,   103,   237,   443,    73,   240,
     103,   166,   167,   211,   212,   489,   345,   417,   348,   104,
     329,   105,    63,    64,    65,   190,   104,   149,   257,   103,
     259,   104,   261,   118,   418,   264,   397,   226,   266,    74,
     146,    75,    94,   330,   154,   128,   528,    68,    66,   228,
     104,   213,   231,   284,   285,    61,   244,   101,   110,    89,
     111,   245,   337,   331,    91,   289,   371,   291,   375,   293,
     294,    96,   406,   368,   317,   229,   230,   232,    90,   410,
     304,    91,   444,   416,   334,   417,   372,   141,   376,   308,
      97,   310,   407,   312,   313,    80,    98,   283,   301,   411,
     143,   302,   418,    99,   250,   345,   142,   112,   348,   113,
     252,     1,     2,     3,     4,     5,   296,     6,     7,   144,
       8,     9,    10,   251,    11,    12,    13,    14,    15,   253,
     396,   164,    59,   225,   297,   101,    16,    17,   287,    18,
      19,    20,    21,   179,   168,   462,   494,   150,   151,   495,
     271,   272,    76,   180,   169,   181,    22,    23,    24,   273,
     454,    78,   182,   525,   398,   183,   526,    77,   184,   403,
      81,   185,   428,   429,   430,   431,   432,   433,   114,   131,
     115,   132,   320,   321,    25,   133,   186,   134,   135,    26,
     136,   249,   249,   265,   288,   249,   249,   290,   292,   249,
     249,   307,   309,   249,    82,   311,   533,   249,    79,   314,
     379,   249,   249,   335,   336,   249,   519,   340,   249,   249,
     341,   342,   249,   249,   343,   355,   249,   249,   356,   357,
     249,   369,   358,   370,   373,   393,   374,   394,   446,   450,
     447,   451,    83,   475,   476,   470,   472,   471,   473,   436,
     437,    84,    85,    86,    87,    88,    92,   109,   101,   116,
     160,   140,   137,   157,   155,   159,   161,   162,    90,    98,
     164,   165,   170,   208,   216,   172,   217,   174,   176,   177,
     194,   195,   191,   192,   193,   219,   224,   198,   200,   246,
     202,   203,   227,   241,   242,   248,   254,   243,   249,   270,
     168,   247,   333,   255,   267,   256,   275,   269,   268,   274,
     295,   278,   522,   300,   279,   299,   303,   281,   315,   282,
     322,   286,   509,   503,   305,   306,   296,   318,   360,   319,
     361,   325,    24,   404,   326,   327,   332,   344,   351,   367,
     353,   347,   350,   354,   388,   352,   415,   359,   383,   391,
     392,   490,   362,   363,   364,   400,   366,   365,   401,   377,
     378,   381,   382,   402,   386,   409,   413,   389,   387,    91,
     390,   337,   439,   395,   399,   408,   405,   448,   421,   412,
     452,   422,   423,   461,   496,   457,   478,   425,   380,   438,
      62,   426,   440,   441,   442,   474,   477,   449,   453,   455,
     480,   456,   458,   482,   459,   493,   499,   500,   463,   464,
     465,   466,   467,   468,   469,   481,   501,   479,   502,   512,
     483,   484,   443,   506,   497,   504,   507,   513,   514,   517,
     523,   524,   508,   534,    93,   510,   511,   515,   531,   491,
     516,   424,   518,    95,   520,   521,   529,   532,   427,   530,
     460,     0,     0,     0,   535,     0,     0,     0,     0,   196,
       0,     0,     0,     0,     0,     0,     0,     0,   316
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-434)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     156,   242,    86,   286,   218,     4,    10,     3,    61,   138,
     139,    49,    99,     4,    67,    68,     7,    13,    19,    17,
      37,    19,    27,    28,    29,    23,    24,    25,    26,   462,
      86,    69,    40,    41,    42,    43,   469,    37,    63,    37,
      63,    68,   171,    86,   173,    63,   175,    74,    53,   178,
      63,   104,   105,    32,    33,    63,   297,    65,   299,    84,
      83,    86,    27,    28,    29,   118,    84,    84,   197,    63,
     199,    84,   201,    86,    82,   204,   359,   164,   207,    84,
      84,    86,    83,    63,    84,    83,   519,    86,    53,    85,
      84,    70,    86,   222,   223,    86,    83,    68,    84,    27,
      86,    88,    73,    83,    49,   234,    63,   236,    63,   238,
     239,    63,    63,   327,   270,   168,   169,   170,    46,    63,
     249,    49,   405,    63,    69,    65,    83,    63,    83,   258,
      82,   260,    83,   262,   263,    77,    77,   221,    63,    83,
      63,    66,    82,    84,    63,   386,    82,    84,   389,    86,
      63,     5,     6,     7,     8,     9,    66,    11,    12,    82,
      14,    15,    16,    82,    18,    19,    20,    21,    22,    82,
      63,    83,    86,    85,    84,    68,    30,    31,   231,    33,
      34,    35,    36,    44,     3,   426,    63,    75,    76,    66,
      75,    76,    86,    54,    13,    56,    50,    51,    52,    84,
     414,    28,    63,    63,   360,    66,    66,    86,    69,   365,
      28,    72,    57,    58,    59,    60,    61,    62,    84,    84,
      86,    86,    75,    76,    78,    84,    87,    86,    84,    83,
      86,    83,    83,    85,    85,    83,    83,    85,    85,    83,
      83,    85,    85,    83,    38,    85,   529,    83,    63,    85,
     334,    83,    83,    85,    85,    83,   497,    85,    83,    83,
      85,    85,    83,    83,    85,    85,    83,    83,    85,    85,
      83,    83,    85,    85,    83,    83,    85,    85,    83,    83,
      85,    85,    28,   439,   440,    83,    83,    85,    85,    63,
      64,     6,    77,    48,    28,    66,     0,    83,    68,    86,
      77,    84,    86,    83,    86,    84,    84,    83,    46,    77,
      83,    83,     4,    63,    39,    84,    39,    84,    84,    84,
      79,    79,    86,    86,    86,    69,    47,    84,    84,    77,
      84,    84,    63,    84,    86,    77,    63,    86,    83,    67,
       3,    88,    28,    86,    83,    86,    63,    83,    85,    84,
      63,    84,   508,    63,    84,    84,    63,    83,    63,    83,
      63,    83,   479,    81,    84,    84,    66,    83,    63,    83,
      63,    83,    52,   366,    85,    83,    85,    83,    77,    63,
      77,    83,    83,    77,    55,    83,   381,    83,    66,    63,
      63,   455,    83,    83,    83,    63,    83,    85,    63,    84,
      83,    83,    83,    63,    83,    63,    63,    83,    85,    49,
      85,    73,    63,    85,    83,    85,    83,    63,    77,    85,
      63,    85,    83,    55,    45,    77,    71,    83,   335,    83,
       4,    86,    85,    83,    83,    63,    63,    85,    85,    83,
      63,    83,    83,    63,    83,    63,    63,    63,    86,    86,
      86,    86,    86,    86,    83,    85,    63,    83,    63,    63,
      85,    85,    74,    77,    86,    80,    77,    63,    63,    77,
      63,    63,    85,    63,    28,    85,    85,    83,    77,   455,
      83,   386,    84,    35,    85,    85,    83,    85,   389,    83,
     423,    -1,    -1,    -1,    85,    -1,    -1,    -1,    -1,   130,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   269
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    21,    22,    30,    31,    33,    34,
      35,    36,    50,    51,    52,    78,    83,    90,    91,    92,
      94,   107,   109,   111,   113,   114,   115,   116,   117,   119,
     120,   124,   125,   135,   147,   157,   161,   162,   164,   165,
     166,   167,   168,   169,   170,   173,   176,    86,    86,    86,
       4,    86,   120,    27,    28,    29,    53,     4,    86,   174,
      27,    28,    29,    53,    84,    86,    86,    86,    28,    63,
      77,    28,    38,    28,     6,    77,    48,    28,    66,    27,
      46,    49,     0,    90,    83,   113,    63,    82,    77,    84,
     163,    68,    99,    63,    84,    86,   121,   122,   121,    83,
      84,    86,    84,    86,    84,    86,    86,   156,    86,   121,
     121,    17,    19,    23,    24,    25,    26,    37,    83,   171,
     172,    84,    86,    84,    86,    84,    86,    86,   144,   146,
      84,    63,    82,    63,    82,    10,    84,    95,    37,    84,
      75,    76,   175,    37,    84,    86,    93,    83,   116,    84,
      77,    84,    83,   163,    83,    83,   121,   121,     3,    13,
       4,   151,    84,   149,    84,   153,    84,    84,   154,    44,
      54,    56,    63,    66,    69,    72,    87,   103,   126,   127,
     121,    86,    86,    86,    79,    79,   171,   139,    84,   137,
      84,   141,    84,    84,   142,   126,   126,   145,    63,   159,
     160,    32,    33,    70,    96,   110,    39,    39,   108,    69,
      96,    69,   118,   158,    47,    85,   163,    63,    85,   121,
     121,    86,   121,   126,   150,   126,   148,   126,   152,   155,
     126,    84,    86,    86,    83,    88,    77,    88,    77,    83,
      63,    82,    63,    82,    63,    86,    86,   126,   138,   126,
     136,   126,   140,   143,   126,    85,   126,    83,    85,    83,
      67,    75,    76,    84,    84,    63,   105,   106,    84,    84,
     105,    83,    83,   116,   126,   126,    83,   121,    85,   126,
      85,   126,    85,   126,   126,    63,    66,    84,   103,    84,
      63,    63,    66,    63,   126,    84,    84,    85,   126,    85,
     126,    85,   126,   126,    85,    63,   159,    96,    83,    83,
      75,    76,    63,    97,    98,    83,    85,    83,    63,    83,
      63,    83,    85,    28,    69,    85,    85,    73,    99,   101,
      85,    85,    85,    85,    83,   103,   130,    83,   103,   131,
      83,    77,    83,    77,    77,    85,    85,    85,    85,    83,
      63,    63,    83,    83,    83,    85,    83,    63,   105,    83,
      85,    63,    83,    83,    85,    63,    83,    84,    83,   116,
     119,    83,    83,    66,   132,   133,    83,    85,    55,    83,
      85,    63,    63,    83,    85,    85,    63,    99,    96,    83,
      63,    63,    63,    96,    97,    83,    63,    83,    85,    63,
      63,    83,    85,    63,   112,   101,    63,    65,    82,   102,
     104,    77,    85,    83,   130,    83,    86,   131,    57,    58,
      59,    60,    61,    62,   128,   129,    63,    64,    83,    63,
      85,    83,    83,    74,    99,   100,    83,    85,    63,    85,
      83,    85,    63,    85,   105,    83,    83,    77,    83,    83,
     132,    55,   103,    86,    86,    86,    86,    86,    86,    83,
      83,    85,    83,    85,    63,    96,    96,    63,    71,    83,
      63,    85,    63,    85,    85,    40,    41,    42,    43,    63,
     102,   104,   123,    63,    63,    66,    45,    86,   128,    63,
      63,    63,    63,    81,    80,   128,    77,    77,    85,   100,
      85,    85,    63,    63,    63,    83,    83,    77,    84,   103,
      85,    85,    96,    63,    63,    63,    66,   134,   128,    83,
      83,    77,    85,    99,    63,    85
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
#line 226 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 227 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 228 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 229 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 230 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 231 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 232 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 233 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 234 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 235 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 236 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 237 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 238 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 239 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 240 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 241 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 242 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 243 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 244 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 245 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 246 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 247 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 248 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 249 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 251 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 252 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 253 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 257 "..\\..\\parser.y"
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
#line 268 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 274 "..\\..\\parser.y"
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
#line 285 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 291 "..\\..\\parser.y"
    { 	
        strcpy(szMexToken, " record org instruction "); 
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 307 "..\\..\\parser.y"
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
#line 318 "..\\..\\parser.y"
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
#line 327 "..\\..\\parser.y"
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
#line 336 "..\\..\\parser.y"
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
#line 345 "..\\..\\parser.y"
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
#line 354 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 360 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " key instruction ");
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 363 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 367 "..\\..\\parser.y"
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
#line 382 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 388 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 395 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 407 "..\\..\\parser.y"
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
#line 422 "..\\..\\parser.y"
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
#line 437 "..\\..\\parser.y"
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
#line 450 "..\\..\\parser.y"
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

  case 52:
/* Line 1792 of yacc.c  */
#line 469 "..\\..\\parser.y"
    {
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 471 "..\\..\\parser.y"
    {
        
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 477 "..\\..\\parser.y"
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
#line 501 "..\\..\\parser.y"
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
#line 516 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 518 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 58:
/* Line 1792 of yacc.c  */
#line 523 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 531 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 534 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 61:
/* Line 1792 of yacc.c  */
#line 540 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 550 "..\\..\\parser.y"
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
#line 568 "..\\..\\parser.y"
    {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 577 "..\\..\\parser.y"
    {}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 578 "..\\..\\parser.y"
    {}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 582 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 586 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 590 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 594 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 618 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 624 "..\\..\\parser.y"
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
#line 637 "..\\..\\parser.y"
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
#line 663 "..\\..\\parser.y"
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
#line 681 "..\\..\\parser.y"
    {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 701 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 706 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 713 "..\\..\\parser.y"
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
#line 729 "..\\..\\parser.y"
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
#line 764 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 767 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
		strcpy(szMexToken, " condition field 01 ");
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 771 "..\\..\\parser.y"
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

  case 84:
/* Line 1792 of yacc.c  */
#line 780 "..\\..\\parser.y"
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

  case 85:
/* Line 1792 of yacc.c  */
#line 798 "..\\..\\parser.y"
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

  case 86:
/* Line 1792 of yacc.c  */
#line 814 "..\\..\\parser.y"
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

  case 87:
/* Line 1792 of yacc.c  */
#line 828 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcpy(szMexToken, " condition field 06 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 840 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcpy(szMexToken, " condition field 07 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 852 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 08 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 866 "..\\..\\parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 09 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 880 "..\\..\\parser.y"
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

  case 92:
/* Line 1792 of yacc.c  */
#line 898 "..\\..\\parser.y"
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
#line 915 "..\\..\\parser.y"
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
#line 939 "..\\..\\parser.y"
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
#line 955 "..\\..\\parser.y"
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
#line 982 "..\\..\\parser.y"
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
#line 1000 "..\\..\\parser.y"
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
#line 1024 "..\\..\\parser.y"
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
#line 1044 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1050 "..\\..\\parser.y"
    {
        condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1059 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1065 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1086 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1092 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1104 "..\\..\\parser.y"
    {	
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1106 "..\\..\\parser.y"
    {	}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1114 "..\\..\\parser.y"
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

  case 108:
/* Line 1792 of yacc.c  */
#line 1186 "..\\..\\parser.y"
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

  case 109:
/* Line 1792 of yacc.c  */
#line 1201 "..\\..\\parser.y"
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

  case 110:
/* Line 1792 of yacc.c  */
#line 1227 "..\\..\\parser.y"
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

  case 111:
/* Line 1792 of yacc.c  */
#line 1272 "..\\..\\parser.y"
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

  case 112:
/* Line 1792 of yacc.c  */
#line 1314 "..\\..\\parser.y"
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

  case 113:
/* Line 1792 of yacc.c  */
#line 1358 "..\\..\\parser.y"
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

  case 114:
/* Line 1792 of yacc.c  */
#line 1402 "..\\..\\parser.y"
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

  case 115:
/* Line 1792 of yacc.c  */
#line 1447 "..\\..\\parser.y"
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

  case 116:
/* Line 1792 of yacc.c  */
#line 1501 "..\\..\\parser.y"
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

  case 117:
/* Line 1792 of yacc.c  */
#line 1541 "..\\..\\parser.y"
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

  case 118:
/* Line 1792 of yacc.c  */
#line 1597 "..\\..\\parser.y"
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

  case 119:
/* Line 1792 of yacc.c  */
#line 1617 "..\\..\\parser.y"
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

  case 120:
/* Line 1792 of yacc.c  */
#line 1637 "..\\..\\parser.y"
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
                    outfil_addoutfilrec(outrec);
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
                    outfil_addoutfilrec(outrec);
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

  case 121:
/* Line 1792 of yacc.c  */
#line 1728 "..\\..\\parser.y"
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
                    outfil_addoutfilrec(outrec);
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
                    outfil_addoutfilrec(outrec);
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

  case 122:
/* Line 1792 of yacc.c  */
#line 1819 "..\\..\\parser.y"
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
                    outfil_addoutfilrec(outrec);
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
                    outfil_addoutfilrec(outrec);
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

  case 123:
/* Line 1792 of yacc.c  */
#line 1912 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " findrep_options instruction ");
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1915 "..\\..\\parser.y"
    {}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1919 "..\\..\\parser.y"
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

  case 127:
/* Line 1792 of yacc.c  */
#line 1940 "..\\..\\parser.y"
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

  case 128:
/* Line 1792 of yacc.c  */
#line 1961 "..\\..\\parser.y"
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

  case 129:
/* Line 1792 of yacc.c  */
#line 1982 "..\\..\\parser.y"
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

  case 130:
/* Line 1792 of yacc.c  */
#line 2004 "..\\..\\parser.y"
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

  case 131:
/* Line 1792 of yacc.c  */
#line 2029 "..\\..\\parser.y"
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

  case 132:
/* Line 1792 of yacc.c  */
#line 2056 "..\\..\\parser.y"
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

  case 133:
/* Line 1792 of yacc.c  */
#line 2068 "..\\..\\parser.y"
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

  case 134:
/* Line 1792 of yacc.c  */
#line 2083 "..\\..\\parser.y"
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

  case 135:
/* Line 1792 of yacc.c  */
#line 2104 "..\\..\\parser.y"
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

  case 136:
/* Line 1792 of yacc.c  */
#line 2147 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 2151 "..\\..\\parser.y"
    {}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 2159 "..\\..\\parser.y"
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

  case 139:
/* Line 1792 of yacc.c  */
#line 2190 "..\\..\\parser.y"
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

  case 140:
/* Line 1792 of yacc.c  */
#line 2218 "..\\..\\parser.y"
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

  case 141:
/* Line 1792 of yacc.c  */
#line 2233 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 142:
/* Line 1792 of yacc.c  */
#line 2238 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 143:
/* Line 1792 of yacc.c  */
#line 2244 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 2249 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2254 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2259 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 147:
/* Line 1792 of yacc.c  */
#line 2265 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 148:
/* Line 1792 of yacc.c  */
#line 2270 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 149:
/* Line 1792 of yacc.c  */
#line 2275 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2280 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2287 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2292 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2298 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2303 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2308 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2313 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2319 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2324 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2334 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2339 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2344 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2349 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2358 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2363 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2368 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2373 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2378 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2383 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2388 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2393 "..\\..\\parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2398 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2403 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2410 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2415 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2421 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2426 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2431 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2436 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2442 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2447 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2456 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
}
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2461 "..\\..\\parser.y"
    {
		/*  current_inrec=0;    */
		nRecCase=0;
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2467 "..\\..\\parser.y"
    {}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2468 "..\\..\\parser.y"
    {}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2471 "..\\..\\parser.y"
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

  case 186:
/* Line 1792 of yacc.c  */
#line 2481 "..\\..\\parser.y"
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

  case 187:
/* Line 1792 of yacc.c  */
#line 2498 "..\\..\\parser.y"
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

  case 188:
/* Line 1792 of yacc.c  */
#line 2510 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2514 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2521 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2527 "..\\..\\parser.y"
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

  case 192:
/* Line 1792 of yacc.c  */
#line 2546 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " group files outfil ");
}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2552 "..\\..\\parser.y"
    {
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2554 "..\\..\\parser.y"
    {
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2556 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 196:
/* Line 1792 of yacc.c  */
#line 2560 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2566 "..\\..\\parser.y"
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

  case 198:
/* Line 1792 of yacc.c  */
#line 2578 "..\\..\\parser.y"
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

  case 199:
/* Line 1792 of yacc.c  */
#line 2590 "..\\..\\parser.y"
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

  case 200:
/* Line 1792 of yacc.c  */
#line 2606 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2611 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 202:
/* Line 1792 of yacc.c  */
#line 2619 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2624 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2631 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2640 "..\\..\\parser.y"
    {}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2642 "..\\..\\parser.y"
    {}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2645 "..\\..\\parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 208:
/* Line 1792 of yacc.c  */
#line 2649 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 209:
/* Line 1792 of yacc.c  */
#line 2653 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 210:
/* Line 1792 of yacc.c  */
#line 2657 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 211:
/* Line 1792 of yacc.c  */
#line 2661 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 212:
/* Line 1792 of yacc.c  */
#line 2665 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2669 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2673 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2678 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2685 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2691 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2697 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2704 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2710 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2719 "..\\..\\parser.y"
    {
}
    break;

  case 222:
/* Line 1792 of yacc.c  */
#line 2720 "..\\..\\parser.y"
    {
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2731 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 224:
/* Line 1792 of yacc.c  */
#line 2737 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 225:
/* Line 1792 of yacc.c  */
#line 2743 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 226:
/* Line 1792 of yacc.c  */
#line 2749 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2755 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2761 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2767 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2774 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 231:
/* Line 1792 of yacc.c  */
#line 2780 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2786 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 233:
/* Line 1792 of yacc.c  */
#line 2792 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2798 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2804 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2810 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2821 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


/* Line 1792 of yacc.c  */
#line 5379 "..\\..\\parser.c"
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
#line 2826 "..\\..\\parser.y"

