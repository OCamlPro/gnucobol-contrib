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
     COLLATING = 339,
     SIGNDIGITBIG = 340
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
#line 211 "..\\..\\parser.c"
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
#line 239 "..\\..\\parser.c"
/* Unqualified %code blocks.  */
/* Line 391 of yacc.c  */
#line 37 "..\\..\\parser.y"
 
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
	char szTmp[256];
	int	 nIntTmp;
	int  nTypeFormat;			/* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
	int  nTypeIncludeOmit;		/* 0= Nothing, 1 = Include, Omit=2                              */
    int  nFieldType = 0;        /* field type used when format is spicified */
	int  nstate_outfil = 0;
    int  nOnly=0;
static int process_keyfield(int position, int length, char *keyType, char *keyCollating)
{
    if (current_file != NULL) {
        struct KeyIdx_t *KeyIdx;
        int sColSeq = CB_COLSEQ_NATIVE;
#if __LIBCOB_RELEASE >= 30300
        if (keyCollating != NULL) {
            sColSeq = utils_parseKeyCollating(keyCollating);
        }
#endif
        KeyIdx = KeyIdx_constructor(position, length, utils_parseKeyType(keyType), sColSeq);
        if (KeyIdx == NULL) {
            utl_abend_terminate(MEMORYALLOC, 102, ABEND_SKIP);
            return 0;
        }
        KeyIdx_addDefinition(KeyIdx, current_file);
    }
    free(keyType);
    if (keyCollating != NULL) {
        free(keyCollating);
    }
    return 1;
}



/* Line 391 of yacc.c  */
#line 351 "..\\..\\parser.c"

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
#define YYLAST   524

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  92
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  90
/* YYNRULES -- Number of rules.  */
#define YYNRULES  249
/* YYNRULES -- Number of states.  */
#define YYNSTATES  555

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   340

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      87,    88,     2,     2,    86,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    91,     2,
       2,    89,     2,    90,     2,     2,     2,     2,     2,     2,
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
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85
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
     102,   110,   116,   118,   121,   128,   137,   143,   151,   153,
     155,   157,   159,   161,   164,   167,   170,   172,   174,   176,
     180,   186,   194,   195,   202,   206,   207,   214,   218,   219,
     230,   232,   235,   238,   243,   247,   251,   254,   258,   264,
     272,   273,   276,   277,   285,   286,   290,   294,   298,   300,
     304,   308,   312,   326,   336,   346,   356,   364,   372,   382,
     384,   387,   389,   392,   394,   397,   399,   403,   408,   412,
     417,   423,   430,   432,   436,   438,   442,   444,   450,   455,
     461,   463,   467,   469,   471,   474,   483,   494,   501,   503,
     507,   508,   512,   516,   520,   524,   528,   532,   534,   538,
     540,   544,   556,   570,   577,   579,   583,   589,   596,   599,
     600,   608,   609,   616,   617,   625,   626,   633,   634,   642,
     643,   650,   651,   657,   658,   667,   668,   673,   674,   681,
     682,   688,   689,   697,   698,   705,   706,   714,   715,   722,
     723,   731,   732,   739,   740,   746,   747,   756,   757,   762,
     763,   770,   772,   776,   780,   788,   794,   798,   803,   811,
     817,   824,   834,   836,   838,   842,   848,   852,   854,   857,
     861,   865,   867,   871,   875,   879,   883,   885,   887,   890,
     892,   896,   900,   904,   908,   910,   912,   916,   923,   930,
     939,   950,   959,   970,   971,   975,   977,   983,   991,   998,
    1008,  1016,  1025,  1027,  1033,  1041,  1048,  1058,  1066,  1075
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      93,     0,    -1,    -1,    94,    93,    -1,   181,    -1,   111,
      -1,   113,    -1,   115,    -1,   119,    -1,   121,    -1,   117,
      -1,   120,    -1,   123,    -1,    95,    -1,    97,    -1,   124,
      -1,   173,    -1,   174,    -1,   129,    -1,   128,    -1,   152,
      -1,   166,    -1,   140,    -1,   167,    -1,   172,    -1,   170,
      -1,   171,    -1,   169,    -1,   175,    -1,   178,    -1,   162,
      -1,    -1,    37,    79,    96,    99,    -1,    -1,    31,    79,
      98,    99,    -1,    -1,    33,    68,    99,    -1,    34,    78,
      86,    64,    86,    64,    99,    -1,    34,    87,    78,    86,
      64,    86,    64,    88,    99,    -1,    34,    77,    86,    64,
      99,    -1,    34,    87,    77,    86,    64,    88,    99,    -1,
      71,    87,   100,    88,    99,    -1,   102,    -1,   101,   100,
      -1,    64,    86,    64,    86,    72,    86,    -1,    64,    86,
      64,    86,    72,    86,    84,    86,    -1,    64,    86,    64,
      86,    72,    -1,    64,    86,    64,    86,    72,    86,    84,
      -1,    69,    -1,    75,    -1,    76,    -1,    74,    -1,    75,
      -1,    66,    79,    -1,    67,    79,    -1,    73,    79,    -1,
      64,    -1,    85,    -1,   110,    -1,   110,    86,   109,    -1,
      64,    86,    64,    86,   104,    -1,    64,    86,    64,    86,
     103,    86,   104,    -1,    -1,    35,    29,    87,   112,   109,
      88,    -1,    35,    29,    38,    -1,    -1,    32,    29,    87,
     114,   109,    88,    -1,    32,    29,    38,    -1,    -1,    36,
       6,    89,    70,    86,    29,    87,   116,   109,    88,    -1,
     118,    -1,   118,   117,    -1,    86,    47,    -1,    86,    47,
      86,    48,    -1,    19,    89,    85,    -1,    19,    89,    64,
      -1,    51,    49,    -1,    51,    49,   120,    -1,    51,    49,
      86,    70,   120,    -1,    51,    49,    86,    70,    86,    70,
     120,    -1,    -1,    86,    50,    -1,    -1,    52,    29,    87,
     122,   130,    88,   123,    -1,    -1,    53,    67,    79,    -1,
       7,    89,   103,    -1,     7,    89,    74,    -1,   126,    -1,
      87,   125,    88,    -1,   125,     3,   125,    -1,   125,    13,
     125,    -1,    64,    86,    64,    86,   103,    86,   105,    86,
      64,    86,    64,    86,   103,    -1,    64,    86,    64,    86,
     105,    86,    64,    86,    64,    -1,    64,    86,    64,    86,
     103,    86,   105,    86,   106,    -1,    64,    86,    64,    86,
     103,    86,   105,    86,   108,    -1,    64,    86,    64,    86,
     105,    86,   108,    -1,    64,    86,    64,    86,   105,    86,
     106,    -1,    64,    86,    64,    86,   103,    86,   105,    86,
     127,    -1,    41,    -1,    41,    64,    -1,    42,    -1,    42,
      64,    -1,    43,    -1,    43,    64,    -1,    44,    -1,    11,
       4,   125,    -1,    11,     4,    89,   125,    -1,     8,     4,
     125,    -1,     8,     4,    89,   125,    -1,     8,   124,    86,
       4,   125,    -1,     8,   124,    86,     4,    89,   125,    -1,
     131,    -1,   130,    86,   130,    -1,   136,    -1,    64,    86,
      64,    -1,    90,    -1,    70,    91,    64,    86,    64,    -1,
      64,    91,    67,    79,    -1,    64,    91,    64,    86,    64,
      -1,    73,    -1,    64,    91,    67,    -1,    67,    -1,   107,
      -1,    64,    86,    -1,    55,    89,   107,    86,    56,    89,
     107,   132,    -1,    55,    89,    87,   134,    88,    86,    56,
      89,   107,   132,    -1,    57,    89,    87,   135,    88,   132,
      -1,   133,    -1,   133,    86,   132,    -1,    -1,    58,    89,
      64,    -1,    59,    89,    64,    -1,    60,    89,    64,    -1,
      61,    89,    64,    -1,    62,    89,    83,    -1,    63,    89,
      82,    -1,   107,    -1,   107,    86,   134,    -1,   107,    -1,
     107,    86,   135,    -1,    45,    87,    64,    86,   137,    88,
      86,    46,    87,   139,    88,    -1,    45,    87,    64,    86,
     137,    88,    86,    46,    87,    64,    86,    64,    88,    -1,
      45,    87,    64,    86,   137,    88,    -1,   138,    -1,   138,
      86,   137,    -1,    67,    79,    86,    67,    79,    -1,    67,
      79,    86,    64,    86,    64,    -1,    67,    79,    -1,    -1,
      15,    29,    89,    87,   141,   130,    88,    -1,    -1,    15,
      29,    87,   142,   130,    88,    -1,    -1,    15,    28,    89,
      87,   143,   130,    88,    -1,    -1,    15,    28,    87,   144,
     130,    88,    -1,    -1,    15,    30,    89,    87,   145,   130,
      88,    -1,    -1,    15,    30,    87,   146,   130,    88,    -1,
      -1,    15,    54,    89,   147,   130,    -1,    -1,    15,    54,
      89,    87,   148,   130,    88,   132,    -1,    -1,    15,    54,
     149,   130,    -1,    -1,    15,    89,    87,   150,   130,    88,
      -1,    -1,    15,    87,   151,   130,    88,    -1,    -1,     9,
      29,    89,    87,   153,   130,    88,    -1,    -1,     9,    29,
      87,   154,   130,    88,    -1,    -1,     9,    28,    89,    87,
     155,   130,    88,    -1,    -1,     9,    28,    87,   156,   130,
      88,    -1,    -1,     9,    30,    89,    87,   157,   130,    88,
      -1,    -1,     9,    30,    87,   158,   130,    88,    -1,    -1,
       9,    54,    89,   159,   130,    -1,    -1,     9,    54,    89,
      87,   160,   130,    88,   132,    -1,    -1,     9,    54,   161,
     130,    -1,    -1,    86,    28,    87,   163,   130,    88,    -1,
     165,    -1,   165,    86,   164,    -1,    64,    86,    64,    -1,
      64,    86,    64,    86,    64,    86,    64,    -1,    64,    86,
      64,    86,   103,    -1,    20,    29,    10,    -1,    20,    29,
      10,    21,    -1,    20,    29,    10,    21,     6,    89,    79,
      -1,    20,    29,    87,   164,    88,    -1,    20,    29,    87,
     164,    88,    21,    -1,    20,    29,    87,   164,    88,    21,
       6,    89,    79,    -1,    80,    -1,    79,    -1,   168,    86,
     168,    -1,     6,    89,    87,   168,    88,    -1,     6,    89,
     168,    -1,    22,    -1,    23,    64,    -1,     8,    89,   125,
      -1,    11,    89,   125,    -1,    14,    -1,    18,    89,    85,
      -1,    18,    89,    64,    -1,     5,    89,    85,    -1,     5,
      89,    64,    -1,    16,    -1,   177,    -1,   177,   176,    -1,
      38,    -1,    17,    89,    85,    -1,    17,    89,    64,    -1,
      19,    89,    85,    -1,    19,    89,    64,    -1,    24,    -1,
      25,    -1,    26,    89,    64,    -1,    86,    81,    89,    87,
      79,    88,    -1,    27,    81,    89,    87,    79,    88,    -1,
      27,    81,    89,    87,    79,    86,    65,    88,    -1,    27,
      81,    89,    87,    79,    86,    65,    86,    79,    88,    -1,
      27,    81,    89,    87,    79,    86,    64,    88,    -1,    27,
      81,    89,    87,    79,    86,    64,    86,    79,    88,    -1,
      -1,    12,   179,   176,    -1,    77,    -1,    77,    40,    87,
      64,    88,    -1,    77,    40,    87,    64,    86,    64,    88,
      -1,    77,    40,    87,    86,    64,    88,    -1,    77,    40,
      87,    64,    86,    64,    86,    64,    88,    -1,    77,    40,
      87,    86,    86,    64,    88,    -1,    77,    40,    87,    64,
      86,    86,    64,    88,    -1,    78,    -1,    78,    40,    87,
      64,    88,    -1,    78,    40,    87,    64,    86,    64,    88,
      -1,    78,    40,    87,    86,    64,    88,    -1,    78,    40,
      87,    64,    86,    64,    86,    64,    88,    -1,    78,    40,
      87,    86,    86,    64,    88,    -1,    78,    40,    87,    64,
      86,    86,    64,    88,    -1,    34,    39,   180,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   251,   251,   252,   254,   255,   256,   257,   258,   259,
     260,   261,   262,   263,   264,   265,   266,   267,   268,   269,
     270,   271,   272,   273,   274,   275,   276,   277,   279,   280,
     281,   286,   286,   303,   303,   320,   336,   347,   356,   365,
     374,   386,   392,   393,   401,   404,   410,   413,   419,   424,
     430,   437,   442,   454,   469,   483,   498,   511,   530,   532,
     538,   562,   577,   577,   584,   592,   592,   601,   611,   611,
     641,   642,   646,   650,   654,   658,   682,   688,   701,   731,
     748,   749,   769,   769,   780,   781,   797,   808,   833,   836,
     840,   849,   867,   883,   897,   909,   921,   936,   951,   969,
     986,  1010,  1026,  1053,  1071,  1095,  1115,  1124,  1136,  1145,
    1169,  1175,  1187,  1189,  1190,  1198,  1270,  1285,  1313,  1358,
    1400,  1488,  1533,  1587,  1627,  1681,  1772,  1863,  1962,  1965,
    1968,  1969,  1990,  2011,  2032,  2054,  2079,  2106,  2117,  2133,
    2153,  2201,  2221,  2242,  2263,  2267,  2275,  2306,  2334,  2349,
    2349,  2360,  2360,  2370,  2370,  2381,  2381,  2391,  2391,  2403,
    2403,  2414,  2414,  2424,  2424,  2435,  2435,  2450,  2450,  2460,
    2460,  2474,  2474,  2484,  2484,  2494,  2494,  2504,  2504,  2514,
    2514,  2526,  2526,  2537,  2537,  2547,  2547,  2558,  2558,  2572,
    2572,  2583,  2584,  2587,  2597,  2614,  2626,  2630,  2636,  2653,
    2657,  2663,  2683,  2689,  2710,  2716,  2718,  2720,  2724,  2730,
    2742,  2754,  2770,  2775,  2783,  2788,  2795,  2804,  2806,  2809,
    2813,  2817,  2821,  2825,  2829,  2833,  2837,  2841,  2848,  2855,
    2861,  2868,  2874,  2883,  2883,  2895,  2901,  2907,  2913,  2919,
    2925,  2931,  2938,  2944,  2950,  2956,  2962,  2968,  2974,  2985
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
  "\"TOKSKIP\"", "\"EXROUT\"", "\"YESNO\"", "\"ERRTRUNC\"",
  "\"COLLATING\"", "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='", "'?'",
  "':'", "$accept", "beginning", "clause", "useclause", "$@1",
  "giveclause", "$@2", "recordorginstruction", "allkeyfield",
  "keyfield_comma", "keyfield", "fieldtype", "fielddirection", "condition",
  "fieldvaluecond", "fieldvaluerec", "fieldvalueconst", "allsortfield",
  "sortfield", "sortclause", "$@3", "mergeclause", "$@4", "joinkeysclause",
  "$@5", "joinkeysalloptions", "joinkeysoptions", "joinclause",
  "joinoptions", "joinreformatclause", "$@6", "fill_char", "formatclause",
  "allcondfield", "condfieldcond", "datetype", "omitclause",
  "includeclause", "allinoutrec", "inoutrec", "findrep_options_all",
  "findrep_options", "allfieldvaluerec", "inoutfieldvaluerec",
  "change_options_all", "changepair", "changepairdet", "changeCmdOpt",
  "outrecclause", "$@7", "$@8", "$@9", "$@10", "$@11", "$@12", "$@13",
  "$@14", "$@15", "$@16", "$@17", "inrecclause", "$@18", "$@19", "$@20",
  "$@21", "$@22", "$@23", "$@24", "$@25", "$@26", "buildclause", "$@27",
  "allsumfield", "sumfield", "sumclause", "tokskipclause", "filesgroup",
  "fnamesclause", "outfilincludeclause", "outfilomitclause",
  "outfilclause", "startrecclause", "endrecclause", "saveclause",
  "alloption", "option", "optionclause", "$@28", "recordoption",
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
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,    44,    40,    41,    61,
      63,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    92,    93,    93,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    94,
      94,    96,    95,    98,    97,    99,    99,    99,    99,    99,
      99,    99,   100,   100,   101,   101,   102,   102,   103,   103,
     104,   105,   105,   106,   107,   107,   108,   108,   109,   109,
     110,   110,   112,   111,   111,   114,   113,   113,   116,   115,
     117,   117,   118,   118,   118,   118,   119,   119,   119,   119,
     120,   120,   122,   121,   123,   123,   124,   124,   125,   125,
     125,   125,   126,   126,   126,   126,   126,   126,   126,   127,
     127,   127,   127,   127,   127,   127,   128,   128,   129,   129,
     129,   129,   130,   130,   130,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   131,   131,   131,   132,   132,
     133,   133,   133,   133,   133,   133,   133,   134,   134,   135,
     135,   136,   136,   136,   137,   137,   138,   138,   139,   141,
     140,   142,   140,   143,   140,   144,   140,   145,   140,   146,
     140,   147,   140,   148,   140,   149,   140,   150,   140,   151,
     140,   153,   152,   154,   152,   155,   152,   156,   152,   157,
     152,   158,   152,   159,   152,   160,   152,   161,   152,   163,
     162,   164,   164,   165,   165,   165,   166,   166,   166,   166,
     166,   166,   167,   168,   168,   169,   169,   169,   169,   170,
     171,   172,   173,   173,   174,   174,   175,   176,   176,   177,
     177,   177,   177,   177,   177,   177,   177,   177,   177,   177,
     177,   177,   177,   179,   178,   180,   180,   180,   180,   180,
     180,   180,   180,   180,   180,   180,   180,   180,   180,   181
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     2,     6,     8,     5,     7,     1,     1,
       1,     1,     1,     2,     2,     2,     1,     1,     1,     3,
       5,     7,     0,     6,     3,     0,     6,     3,     0,    10,
       1,     2,     2,     4,     3,     3,     2,     3,     5,     7,
       0,     2,     0,     7,     0,     3,     3,     3,     1,     3,
       3,     3,    13,     9,     9,     9,     7,     7,     9,     1,
       2,     1,     2,     1,     2,     1,     3,     4,     3,     4,
       5,     6,     1,     3,     1,     3,     1,     5,     4,     5,
       1,     3,     1,     1,     2,     8,    10,     6,     1,     3,
       0,     3,     3,     3,     3,     3,     3,     1,     3,     1,
       3,    11,    13,     6,     1,     3,     5,     6,     2,     0,
       7,     0,     6,     0,     7,     0,     6,     0,     7,     0,
       6,     0,     5,     0,     8,     0,     4,     0,     6,     0,
       5,     0,     7,     0,     6,     0,     7,     0,     6,     0,
       7,     0,     6,     0,     5,     0,     8,     0,     4,     0,
       6,     1,     3,     3,     7,     5,     3,     4,     7,     5,
       6,     9,     1,     1,     3,     5,     3,     1,     2,     3,
       3,     1,     3,     3,     3,     3,     1,     1,     2,     1,
       3,     3,     3,     3,     1,     1,     3,     6,     6,     8,
      10,     8,    10,     0,     3,     1,     5,     7,     6,     9,
       7,     8,     1,     5,     7,     6,     9,     7,     8,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   233,   211,     0,
     216,     0,     0,     0,   207,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   202,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    70,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   187,     0,     0,     0,
       0,     0,     0,   165,   169,     0,     0,     0,     0,   208,
      33,     0,     0,     0,     0,    31,    76,     0,     0,     0,
      72,    81,     1,     3,     0,    71,   215,   214,   203,     0,
     206,    48,    87,    49,    86,     0,     0,     0,   108,    88,
     209,     0,   177,     0,   173,     0,   181,     0,   183,     0,
       0,   106,   210,     0,     0,   224,   225,     0,     0,   219,
       0,   234,   217,   155,     0,   151,     0,   159,     0,   161,
       0,     0,   167,   213,   212,    75,    74,   196,     0,    35,
      67,    65,   235,   242,   249,    64,    62,     0,    35,     0,
      77,    82,    85,   189,     0,     0,     0,     0,     0,   109,
       0,     0,     0,     0,   175,     0,   171,     0,   179,   185,
       0,     0,     0,     0,     0,   122,     0,   120,   116,   123,
     188,   112,   114,   107,     0,     0,     0,     0,     0,   218,
       0,   153,     0,   149,     0,   157,   163,     0,   166,     0,
       0,   197,     0,     0,   191,     0,     0,     0,    34,     0,
       0,     0,     0,     0,    32,    80,     0,     0,    73,   205,
     204,     0,    89,    90,    91,     0,   110,     0,     0,     0,
       0,     0,     0,     0,   184,     0,     0,     0,   124,     0,
      54,     0,    55,     0,   221,   220,   223,   222,   226,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   162,   170,
       0,     0,     0,   199,     0,    35,     0,     0,     0,     0,
       0,     0,    58,     0,     0,     0,     0,     0,    78,     0,
       0,     0,   111,   178,     0,   174,     0,   182,     0,     0,
       0,     0,     0,     0,     0,     0,   115,     0,   121,     0,
     113,     0,     0,   156,     0,   152,     0,   160,     0,     0,
     168,     0,   193,   200,   192,    36,     0,     0,     0,     0,
       0,     0,     0,    42,     0,    66,     0,     0,     0,     0,
       0,    63,     0,    80,    84,   190,    51,    49,     0,     0,
     176,   172,   180,   130,     0,   137,     0,     0,   139,     0,
       0,   118,     0,     0,     0,   154,   150,   158,   130,   198,
       0,     0,    35,     0,     0,     0,     0,    35,    43,     0,
      59,     0,   236,     0,     0,     0,   243,     0,     0,    68,
       0,    79,    83,     0,     0,     0,     0,     0,     0,     0,
       0,   186,   128,     0,     0,   144,     0,     0,     0,     0,
     130,   119,   117,     0,   228,   227,   164,     0,   195,     0,
      39,     0,     0,     0,     0,    41,     0,     0,     0,   238,
       0,     0,     0,   245,     0,     0,    52,     0,    56,     0,
      57,    97,    96,     0,     0,     0,     0,     0,     0,   130,
       0,   143,     0,   138,     0,     0,   140,   127,     0,     0,
       0,   201,    35,    35,     0,     0,    50,     0,    60,     0,
     237,     0,   240,     0,   244,     0,   247,     0,     0,     0,
      53,   131,   132,   133,   134,   135,   136,   129,     0,     0,
     145,     0,   130,     0,   231,     0,   229,   194,    37,    40,
       0,    46,     0,     0,   241,     0,   248,    69,    99,   101,
     103,   105,    56,    94,    95,    98,    93,     0,     0,     0,
       0,   125,     0,     0,    35,    44,    61,   239,   246,   100,
     102,   104,     0,     0,   146,     0,   130,   232,   230,    38,
      47,     0,   147,     0,     0,     0,   126,    45,     0,     0,
     148,   141,    92,     0,   142
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   158,    30,   149,   218,   331,   332,
     333,   104,   468,   349,   441,   189,   442,   281,   282,    31,
     222,    32,   219,    33,   435,    34,    35,    36,    37,    38,
     226,    39,    40,   108,   109,   515,    41,    42,   190,   191,
     401,   402,   356,   359,   192,   404,   405,   545,    43,   264,
     202,   262,   200,   266,   204,   207,   267,   140,   210,   141,
      44,   240,   175,   238,   173,   242,   177,   180,   243,   119,
      45,   227,   213,   214,    46,    47,   100,    48,    49,    50,
      51,    52,    53,    54,   131,   132,    55,    69,   154,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -363
static const yytype_int16 yypact[] =
{
     193,   -36,   -27,   -23,     6,    96,    12,  -363,  -363,     9,
    -363,    39,    59,    56,  -363,    88,    93,   130,   158,   197,
     237,   142,   202,   228,   210,  -363,   104,   302,   193,  -363,
    -363,  -363,  -363,  -363,  -363,    -4,  -363,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,    -5,   -61,   106,
      15,   -41,   226,    84,   144,   145,   224,    49,   -41,     3,
     148,   149,   152,   225,  -363,   230,    27,    58,    -1,  -363,
    -363,   -19,   108,   -17,   227,  -363,   232,   233,   236,   235,
     238,  -363,  -363,  -363,   272,  -363,  -363,  -363,  -363,   242,
     239,  -363,  -363,  -363,  -363,   240,   -41,   -41,   165,  -363,
     165,   319,  -363,   241,  -363,   243,  -363,   244,   245,    33,
     -41,   165,   165,   247,   248,  -363,  -363,   249,   252,  -363,
     253,  -363,     3,  -363,   254,  -363,   255,  -363,   256,   257,
      33,    33,  -363,  -363,  -363,  -363,  -363,   306,   265,     2,
    -363,  -363,   295,   299,  -363,  -363,  -363,   270,     2,   -25,
    -363,  -363,  -363,  -363,   297,   134,   242,   282,    11,   165,
     -41,   -41,    57,    33,  -363,    33,  -363,    33,  -363,  -363,
      33,   260,   259,   261,   132,   273,   258,   274,  -363,  -363,
     268,  -363,  -363,   165,    75,    81,   287,   266,   267,  -363,
      33,  -363,    33,  -363,    33,  -363,  -363,    33,   268,   154,
      33,   351,   275,   271,   276,   290,    78,   277,  -363,   296,
     278,   280,   296,   283,  -363,   284,    33,    33,  -363,  -363,
     239,   285,  -363,  -363,   360,   -41,   165,   161,    33,   162,
      33,   166,    33,    33,   268,   304,    80,   286,   308,   -15,
    -363,   310,  -363,    33,  -363,  -363,  -363,  -363,  -363,   288,
     289,   167,    33,   170,    33,   175,    33,    33,   268,  -363,
     176,   291,   313,   357,   265,     2,   293,   298,   229,   317,
     300,   294,   301,   -21,    -3,   303,   354,    22,  -363,   179,
     180,   113,   165,  -363,   183,  -363,   184,  -363,   188,   192,
     307,   273,   274,   116,   309,   116,  -363,   311,   315,   312,
     268,   320,   321,  -363,   195,  -363,   196,  -363,   199,   200,
    -363,   322,   316,   379,  -363,  -363,   324,   325,   318,   323,
     326,   327,   317,  -363,   328,  -363,   296,   203,    55,   204,
      63,  -363,   329,   331,   337,  -363,  -363,  -363,   332,   333,
    -363,  -363,  -363,   133,   336,   334,   335,   340,   338,   339,
     341,  -363,   342,   207,   343,  -363,  -363,  -363,   133,  -363,
      94,   344,     2,   346,   347,   349,   350,     2,  -363,   348,
    -363,    71,  -363,   352,   358,    76,  -363,   353,   361,  -363,
     371,  -363,  -363,   234,    -9,   355,   356,   359,   362,   363,
     364,  -363,   368,   367,   369,   370,   116,   372,   366,   116,
     133,  -363,  -363,   246,  -363,  -363,  -363,   373,  -363,   381,
    -363,   365,   374,   375,   377,  -363,   101,   208,   378,  -363,
     376,   211,   383,  -363,   380,   296,  -363,   384,   385,   386,
    -363,  -363,  -363,   402,   403,   405,   408,   345,   391,   133,
     388,   389,   336,  -363,   382,   116,  -363,  -363,   212,   215,
     412,  -363,     2,     2,   413,   406,  -363,   393,  -363,   416,
    -363,   394,  -363,   417,  -363,   395,  -363,   396,   -10,   421,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,    44,   390,
    -363,   397,   133,   409,  -363,   410,  -363,  -363,  -363,  -363,
     399,   404,   415,   407,  -363,   411,  -363,  -363,   428,   429,
     430,  -363,   414,  -363,  -363,  -363,  -363,   418,   419,   420,
     116,  -363,   422,   423,     2,   424,  -363,  -363,  -363,  -363,
    -363,  -363,   432,   433,  -363,   139,   133,  -363,  -363,  -363,
     426,   427,  -363,   431,   435,   434,  -363,  -363,   115,   437,
    -363,  -363,  -363,   436,  -363
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -363,   398,  -363,  -363,  -363,  -363,  -363,  -158,    98,  -363,
    -363,  -289,   -95,    17,   -70,  -245,   -43,  -218,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,   467,  -363,  -363,   -83,  -363,
    -363,    95,   439,   -56,  -363,  -363,  -363,  -363,  -133,  -363,
    -362,  -363,    31,    40,  -363,    -2,  -363,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    -363,  -363,   231,  -363,  -363,  -363,   -82,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,   387,  -363,  -363,  -363,  -363,  -363
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     224,   304,   348,   160,   285,   110,   416,   208,   209,   147,
      60,   121,   122,     3,   170,    12,    67,   165,    98,   150,
     123,   155,   124,   105,   171,    91,    99,   125,   126,   127,
     128,   508,   509,   510,   511,   215,   216,    70,    71,    72,
     237,   129,   239,   337,   241,   225,   106,   244,   457,   307,
     168,   169,   308,    57,   512,   438,   439,   439,   355,    96,
     358,   339,    58,    73,   193,   338,    59,   261,   151,   263,
     156,   265,    91,   217,   268,   440,   440,   270,   181,   105,
      97,   418,    94,   340,   230,    78,   148,   487,   182,   130,
     183,   143,   343,   289,   290,    61,    74,   184,    75,   232,
     185,    68,   106,   186,   107,   294,   187,   296,   517,   298,
     299,   518,   144,   105,   233,   234,   236,   325,   380,   383,
     310,   105,   145,   188,    63,    64,    65,   387,    76,   314,
     521,   316,    89,   318,   319,   427,   106,   467,   120,   254,
     431,   384,   288,   146,   106,   256,   235,   301,    77,   388,
      66,    90,    79,   302,    91,   276,   277,   428,   417,    81,
     255,   355,   432,   101,   358,   278,   257,   303,   170,   103,
     101,   112,    80,   113,   546,   101,   103,   466,   171,   292,
     102,   103,   101,   301,   101,   152,   153,   346,   347,   302,
     103,   395,   396,   397,   398,   399,   400,    82,     1,     2,
       3,     4,     5,   543,     6,     7,   544,     8,     9,    10,
     492,    11,    12,    13,   420,    14,    15,   477,   248,   425,
     166,    85,   229,   249,    16,    17,    83,    18,    19,    20,
      21,   114,   116,   115,   117,   133,   135,   134,   136,   137,
     253,   138,   269,    84,    22,    23,    24,   253,   253,   293,
     295,    86,   253,   253,   297,   313,   253,    87,   315,   552,
     391,   253,   253,   317,   320,   253,   253,   344,   345,   253,
     253,   350,   351,    25,   253,   536,   352,    88,   253,    26,
     353,   253,   253,   365,   366,   253,   253,   367,   368,   381,
     385,   382,   386,   413,   469,   414,   470,   473,   493,   474,
     494,   495,    92,   496,   498,   499,   328,   329,   346,   436,
     458,   459,   111,   118,   139,   162,   157,   142,   159,    90,
     161,    98,   163,   172,   164,   166,   167,   211,   174,   212,
     176,   178,   179,   197,   198,   220,   194,   195,   196,   221,
     223,   201,   203,   205,   206,   228,   231,   245,   246,   251,
     247,   258,   250,   252,   253,   259,   260,   271,   275,   273,
     280,   272,   274,   170,   279,   283,   539,   284,   300,   286,
     287,   291,   306,   305,   309,   311,   312,   322,   323,   326,
     321,   330,   335,   342,   327,   371,   334,   336,   372,   373,
      24,   341,   379,   354,   361,   357,   408,   360,   362,   363,
     364,   369,   370,   403,   374,   411,   412,   526,   513,   375,
     437,   422,   376,   423,   424,   377,   389,   390,   393,   394,
     406,    91,   430,   407,   409,   434,    93,   410,   485,   462,
     378,   415,   421,   419,   426,   514,   519,   453,   491,   392,
     429,   433,   471,    62,   443,   444,   450,   475,   445,   456,
     490,   446,   447,   448,   449,   455,   452,   451,   454,   460,
     461,   464,   463,   465,   472,   480,   481,   482,   476,   483,
     478,   479,   484,   486,   488,   489,   497,   500,   501,   502,
     503,   505,   504,   506,   507,   516,   520,   524,   522,   523,
     525,   466,   529,   530,   531,   527,   541,   542,   534,   528,
     532,   553,    95,     0,   533,   324,     0,   535,   540,     0,
     537,   538,   547,   548,   550,     0,     0,   549,     0,   199,
       0,     0,   551,     0,   554
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-363)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     158,   246,   291,    86,   222,    61,   368,   140,   141,    10,
       4,    67,    68,     7,     3,    19,     4,    99,    79,    38,
      17,    38,    19,    64,    13,    50,    87,    24,    25,    26,
      27,    41,    42,    43,    44,    33,    34,    28,    29,    30,
     173,    38,   175,    64,   177,    70,    87,   180,   410,    64,
     106,   107,    67,    89,    64,    64,    66,    66,   303,    64,
     305,    64,    89,    54,   120,    86,    89,   200,    87,   202,
      87,   204,    50,    71,   207,    85,    85,   210,    45,    64,
      85,   370,    86,    86,   166,    29,    87,   449,    55,    86,
      57,    64,    70,   226,   227,    89,    87,    64,    89,    88,
      67,    89,    87,    70,    89,   238,    73,   240,    64,   242,
     243,    67,    85,    64,   170,   171,   172,   275,   336,    64,
     253,    64,    64,    90,    28,    29,    30,    64,    89,   262,
     492,   264,    28,   266,   267,    64,    87,   426,    89,    64,
      64,    86,   225,    85,    87,    64,    89,    67,    89,    86,
      54,    47,    64,    73,    50,    77,    78,    86,    64,    29,
      85,   406,    86,    69,   409,    87,    85,    87,     3,    75,
      69,    87,    79,    89,   536,    69,    75,    76,    13,   235,
      74,    75,    69,    67,    69,    77,    78,    74,    75,    73,
      75,    58,    59,    60,    61,    62,    63,    39,     5,     6,
       7,     8,     9,    64,    11,    12,    67,    14,    15,    16,
     455,    18,    19,    20,   372,    22,    23,   435,    86,   377,
      86,    79,    88,    91,    31,    32,    29,    34,    35,    36,
      37,    87,    87,    89,    89,    87,    87,    89,    89,    87,
      86,    89,    88,     6,    51,    52,    53,    86,    86,    88,
      88,    49,    86,    86,    88,    88,    86,    29,    88,   548,
     343,    86,    86,    88,    88,    86,    86,    88,    88,    86,
      86,    88,    88,    80,    86,   520,    88,    67,    86,    86,
      88,    86,    86,    88,    88,    86,    86,    88,    88,    86,
      86,    88,    88,    86,    86,    88,    88,    86,    86,    88,
      88,    86,     0,    88,   462,   463,    77,    78,    74,    75,
      64,    65,    86,    89,    89,    79,    89,    87,    86,    47,
      87,    79,    87,     4,    86,    86,    86,    21,    87,    64,
      87,    87,    87,    81,    81,    40,    89,    89,    89,    40,
      70,    87,    87,    87,    87,    48,    64,    87,    89,    91,
      89,    64,    79,    79,    86,    89,    89,     6,    68,    88,
      64,    86,    86,     3,    87,    87,   524,    87,    64,    86,
      86,    86,    64,    87,    64,    87,    87,    64,    21,    86,
      89,    64,    88,    29,    86,     6,    86,    86,    64,    64,
      53,    88,    64,    86,    79,    86,    56,    86,    86,    79,
      79,    79,    86,    67,    86,    64,    64,   502,   478,    86,
     393,    64,    86,    64,    64,    88,    87,    86,    86,    86,
      86,    50,    64,    88,    86,    64,    28,    88,    83,    64,
     332,    88,    86,    89,    86,   478,    46,   406,    56,   344,
      88,    88,    64,     4,    89,    89,    79,    64,    89,   409,
     452,    89,    89,    89,    86,    89,    86,    88,    86,    86,
      79,    86,    88,    86,    88,    79,    64,    64,    88,    64,
      86,    86,    64,    82,    86,    86,    64,    64,    72,    86,
      64,    64,    88,    88,    88,    64,    89,    88,    79,    79,
      86,    76,    64,    64,    64,    88,    64,    64,    79,    88,
      86,    64,    35,    -1,    86,   274,    -1,    87,    84,    -1,
      88,    88,    86,    86,    79,    -1,    -1,    86,    -1,   132,
      -1,    -1,    88,    -1,    88
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    22,    23,    31,    32,    34,    35,
      36,    37,    51,    52,    53,    80,    86,    93,    94,    95,
      97,   111,   113,   115,   117,   118,   119,   120,   121,   123,
     124,   128,   129,   140,   152,   162,   166,   167,   169,   170,
     171,   172,   173,   174,   175,   178,   181,    89,    89,    89,
       4,    89,   124,    28,    29,    30,    54,     4,    89,   179,
      28,    29,    30,    54,    87,    89,    89,    89,    29,    64,
      79,    29,    39,    29,     6,    79,    49,    29,    67,    28,
      47,    50,     0,    93,    86,   117,    64,    85,    79,    87,
     168,    69,    74,    75,   103,    64,    87,    89,   125,   126,
     125,    86,    87,    89,    87,    89,    87,    89,    89,   161,
      89,   125,   125,    17,    19,    24,    25,    26,    27,    38,
      86,   176,   177,    87,    89,    87,    89,    87,    89,    89,
     149,   151,    87,    64,    85,    64,    85,    10,    87,    98,
      38,    87,    77,    78,   180,    38,    87,    89,    96,    86,
     120,    87,    79,    87,    86,   168,    86,    86,   125,   125,
       3,    13,     4,   156,    87,   154,    87,   158,    87,    87,
     159,    45,    55,    57,    64,    67,    70,    73,    90,   107,
     130,   131,   136,   125,    89,    89,    89,    81,    81,   176,
     144,    87,   142,    87,   146,    87,    87,   147,   130,   130,
     150,    21,    64,   164,   165,    33,    34,    71,    99,   114,
      40,    40,   112,    70,    99,    70,   122,   163,    48,    88,
     168,    64,    88,   125,   125,    89,   125,   130,   155,   130,
     153,   130,   157,   160,   130,    87,    89,    89,    86,    91,
      79,    91,    79,    86,    64,    85,    64,    85,    64,    89,
      89,   130,   143,   130,   141,   130,   145,   148,   130,    88,
     130,     6,    86,    88,    86,    68,    77,    78,    87,    87,
      64,   109,   110,    87,    87,   109,    86,    86,   120,   130,
     130,    86,   125,    88,   130,    88,   130,    88,   130,   130,
      64,    67,    73,    87,   107,    87,    64,    64,    67,    64,
     130,    87,    87,    88,   130,    88,   130,    88,   130,   130,
      88,    89,    64,    21,   164,    99,    86,    86,    77,    78,
      64,   100,   101,   102,    86,    88,    86,    64,    86,    64,
      86,    88,    29,    70,    88,    88,    74,    75,   103,   105,
      88,    88,    88,    88,    86,   107,   134,    86,   107,   135,
      86,    79,    86,    79,    79,    88,    88,    88,    88,    79,
      86,     6,    64,    64,    86,    86,    86,    88,   100,    64,
     109,    86,    88,    64,    86,    86,    88,    64,    86,    87,
      86,   120,   123,    86,    86,    58,    59,    60,    61,    62,
      63,   132,   133,    67,   137,   138,    86,    88,    56,    86,
      88,    64,    64,    86,    88,    88,   132,    64,   103,    89,
      99,    86,    64,    64,    64,    99,    86,    64,    86,    88,
      64,    64,    86,    88,    64,   116,    75,   105,    64,    66,
      85,   106,   108,    89,    89,    89,    89,    89,    89,    86,
      79,    88,    86,   134,    86,    89,   135,   132,    64,    65,
      86,    79,    64,    88,    86,    86,    76,   103,   104,    86,
      88,    64,    88,    86,    88,    64,    88,   109,    86,    86,
      79,    64,    64,    64,    64,    83,    82,   132,    86,    86,
     137,    56,   107,    86,    88,    86,    88,    64,    99,    99,
      64,    72,    86,    64,    88,    64,    88,    88,    41,    42,
      43,    44,    64,   106,   108,   127,    64,    64,    67,    46,
      89,   132,    79,    79,    88,    86,   104,    88,    88,    64,
      64,    64,    86,    86,    79,    87,   107,    88,    88,    99,
      84,    64,    64,    64,    67,   139,   132,    86,    86,    86,
      79,    88,   103,    64,    88
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
#line 254 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 255 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 256 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 257 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 258 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 259 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 260 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 261 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 262 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 263 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 264 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 265 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 266 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 267 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 268 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 269 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 270 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 271 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 272 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 273 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 274 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 275 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 276 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 277 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 279 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 280 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 281 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 286 "..\\..\\parser.y"
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
#line 297 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 303 "..\\..\\parser.y"
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
#line 314 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 320 "..\\..\\parser.y"
    { 	
        strcpy(szMexToken, " record org instruction "); 
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 336 "..\\..\\parser.y"
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
#line 347 "..\\..\\parser.y"
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
#line 356 "..\\..\\parser.y"
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
#line 365 "..\\..\\parser.y"
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
#line 374 "..\\..\\parser.y"
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
#line 386 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 392 "..\\..\\parser.y"
    { strcpy(szMexToken, " key instruction "); }
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 393 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 401 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (6)].number), (yyvsp[(3) - (6)].number), (yyvsp[(5) - (6)].string), NULL)) YYABORT;
    }
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 404 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (8)].number), (yyvsp[(3) - (8)].number), (yyvsp[(5) - (8)].string), (yyvsp[(7) - (8)].string))) YYABORT;
    }
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 410 "..\\..\\parser.y"
    {
         if (!process_keyfield((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].string), NULL)) YYABORT;
    }
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 413 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), (yyvsp[(5) - (7)].string), (yyvsp[(7) - (7)].string))) YYABORT;
 }
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 419 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 424 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 430 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 437 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 442 "..\\..\\parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 454 "..\\..\\parser.y"
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

  case 54:
/* Line 1792 of yacc.c  */
#line 469 "..\\..\\parser.y"
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

  case 55:
/* Line 1792 of yacc.c  */
#line 483 "..\\..\\parser.y"
    { 
  		(yyval.fieldValue)=fieldValue_constructor((yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD, 0);
  		if ((yyval.fieldValue) == NULL) {
              utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
  			YYABORT;
  		}
  		free((yyvsp[(1) - (2)].string)); 
  		free((yyvsp[(2) - (2)].string)); 
  }
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 498 "..\\..\\parser.y"
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

  case 57:
/* Line 1792 of yacc.c  */
#line 511 "..\\..\\parser.y"
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

  case 58:
/* Line 1792 of yacc.c  */
#line 530 "..\\..\\parser.y"
    {
}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 532 "..\\..\\parser.y"
    {
        
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 538 "..\\..\\parser.y"
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

  case 61:
/* Line 1792 of yacc.c  */
#line 562 "..\\..\\parser.y"
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

  case 62:
/* Line 1792 of yacc.c  */
#line 577 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 579 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 584 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 592 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 595 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 601 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 611 "..\\..\\parser.y"
    {
        nRecCase=JOIN_CASE;
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
        if ((memcmp((yyvsp[(4) - (7)].string),(char*) "F1",2)==0) ||
            (memcmp((yyvsp[(4) - (7)].string),(char*) "f1",2)==0)) {
            current_filejoin = 1;
        }
        if ((memcmp((yyvsp[(4) - (7)].string),(char*) "F2",2)==0) ||
            (memcmp((yyvsp[(4) - (7)].string),(char*) "f2",2)==0)) {
            current_filejoin = 2;
        }
        }
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 632 "..\\..\\parser.y"
    {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 641 "..\\..\\parser.y"
    {}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 642 "..\\..\\parser.y"
    {}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 646 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 650 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 654 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 658 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 682 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 688 "..\\..\\parser.y"
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

  case 78:
/* Line 1792 of yacc.c  */
#line 701 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            if ((memcmp((yyvsp[(4) - (5)].string),(char*) "F1",2)==0) ||
                (memcmp((yyvsp[(4) - (5)].string),(char*) "f1",2)==0)) {
                join_setUnpaired(1, 'U');
                join_setUnpaired(2, 'I');
            }
            if ((memcmp((yyvsp[(4) - (5)].string),(char*) "F2",2)==0) ||
                (memcmp((yyvsp[(4) - (5)].string),(char*) "f2",2)==0)) {
                join_setUnpaired(1, 'I');
                join_setUnpaired(2, 'U');
            }
        }
        if (nOnly  == 1) {
            if ((memcmp((yyvsp[(4) - (5)].string),(char*) "F1",2)==0) ||
                (memcmp((yyvsp[(4) - (5)].string),(char*) "f1",2)==0)) { 
                join_setUnpaired(1, 'O');
                join_setUnpaired(2, 'S');
            }
            if ((memcmp((yyvsp[(4) - (5)].string),(char*) "F2",2)==0) ||
                (memcmp((yyvsp[(4) - (5)].string),(char*) "f2",2)==0)) {
                join_setUnpaired(1, 'S');
                join_setUnpaired(2, 'O');
            }
        }
        nOnly=0;
        free((yyvsp[(4) - (5)].string)); 
}
    break;

  case 79:
/* Line 1792 of yacc.c  */
#line 731 "..\\..\\parser.y"
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

  case 81:
/* Line 1792 of yacc.c  */
#line 749 "..\\..\\parser.y"
    {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 769 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 774 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 781 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        strcpy(szMexToken, " join fill clause ");
        /* fill character * */
        join_fillbuff(current_filejoin, current_join, (unsigned char*) (yyvsp[(2) - (3)].string), (unsigned char*) (yyvsp[(3) - (3)].string));
        free((yyvsp[(2) - (3)].string));
        free((yyvsp[(3) - (3)].string));
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 797 "..\\..\\parser.y"
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

  case 87:
/* Line 1792 of yacc.c  */
#line 808 "..\\..\\parser.y"
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

  case 88:
/* Line 1792 of yacc.c  */
#line 833 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 836 "..\\..\\parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
		strcpy(szMexToken, " condition field 01 ");
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 840 "..\\..\\parser.y"
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

  case 91:
/* Line 1792 of yacc.c  */
#line 849 "..\\..\\parser.y"
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

  case 92:
/* Line 1792 of yacc.c  */
#line 867 "..\\..\\parser.y"
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

  case 93:
/* Line 1792 of yacc.c  */
#line 883 "..\\..\\parser.y"
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

  case 94:
/* Line 1792 of yacc.c  */
#line 897 "..\\..\\parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcpy(szMexToken, " condition field 06 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 909 "..\\..\\parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcpy(szMexToken, " condition field 07 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 921 "..\\..\\parser.y"
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

  case 97:
/* Line 1792 of yacc.c  */
#line 936 "..\\..\\parser.y"
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

  case 98:
/* Line 1792 of yacc.c  */
#line 951 "..\\..\\parser.y"
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

  case 99:
/* Line 1792 of yacc.c  */
#line 969 "..\\..\\parser.y"
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

  case 100:
/* Line 1792 of yacc.c  */
#line 986 "..\\..\\parser.y"
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

  case 101:
/* Line 1792 of yacc.c  */
#line 1010 "..\\..\\parser.y"
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

  case 102:
/* Line 1792 of yacc.c  */
#line 1026 "..\\..\\parser.y"
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

  case 103:
/* Line 1792 of yacc.c  */
#line 1053 "..\\..\\parser.y"
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

  case 104:
/* Line 1792 of yacc.c  */
#line 1071 "..\\..\\parser.y"
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

  case 105:
/* Line 1792 of yacc.c  */
#line 1095 "..\\..\\parser.y"
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

  case 106:
/* Line 1792 of yacc.c  */
#line 1115 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[(3) - (3)].condField));
        else 
            condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1124 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[(4) - (4)].condField));
        else 
            condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1136 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[(3) - (3)].condField));
        else 
            condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 1145 "..\\..\\parser.y"
    {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[(4) - (4)].condField));
        else 
            condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 1169 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1175 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1187 "..\\..\\parser.y"
    {	
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 1189 "..\\..\\parser.y"
    {	}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1190 "..\\..\\parser.y"
    {}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1198 "..\\..\\parser.y"
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

  case 116:
/* Line 1792 of yacc.c  */
#line 1270 "..\\..\\parser.y"
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

  case 117:
/* Line 1792 of yacc.c  */
#line 1285 "..\\..\\parser.y"
    {
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            if ((memcmp((yyvsp[(1) - (5)].string),(char*) "F1",2)==0) ||
                (memcmp((yyvsp[(1) - (5)].string),(char*) "f1",2)==0)) {
                current_filejoin = 1;
            }
            if ((memcmp((yyvsp[(1) - (5)].string),(char*) "F2",2)==0) ||
                (memcmp((yyvsp[(1) - (5)].string),(char*) "f2",2)==0)) {
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

  case 118:
/* Line 1792 of yacc.c  */
#line 1313 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_possubstnchar((yyvsp[(1) - (4)].number), (unsigned char*) (yyvsp[(3) - (4)].string), (unsigned char*) (yyvsp[(4) - (4)].string));
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
                inrec=inrec_constructor_possubstnchar((yyvsp[(1) - (4)].number), (unsigned char*) (yyvsp[(3) - (4)].string), (unsigned char*) (yyvsp[(4) - (4)].string));
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

  case 119:
/* Line 1792 of yacc.c  */
#line 1358 "..\\..\\parser.y"
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

  case 120:
/* Line 1792 of yacc.c  */
#line 1400 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_subst((unsigned char*) (yyvsp[(1) - (1)].string));
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
                inrec=inrec_constructor_subst((unsigned char*) (yyvsp[(1) - (1)].string));
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

  case 121:
/* Line 1792 of yacc.c  */
#line 1488 "..\\..\\parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_padding((yyvsp[(1) - (3)].number), (unsigned char*) (yyvsp[(3) - (3)].string), nPosAbsRec);
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
                inrec=inrec_constructor_padding((yyvsp[(1) - (3)].number), (unsigned char*) (yyvsp[(3) - (3)].string), nPosAbsRec);
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

  case 122:
/* Line 1792 of yacc.c  */
#line 1533 "..\\..\\parser.y"
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
                outrec=outrec_constructor_subst((unsigned char*) szType01);
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
                inrec=inrec_constructor_subst((unsigned char*)szType01);
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

  case 123:
/* Line 1792 of yacc.c  */
#line 1587 "..\\..\\parser.y"
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

  case 124:
/* Line 1792 of yacc.c  */
#line 1627 "..\\..\\parser.y"
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

  case 125:
/* Line 1792 of yacc.c  */
#line 1681 "..\\..\\parser.y"
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

  case 126:
/* Line 1792 of yacc.c  */
#line 1772 "..\\..\\parser.y"
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

  case 127:
/* Line 1792 of yacc.c  */
#line 1863 "..\\..\\parser.y"
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
                    /* findrep = findrep_constructor(FINDREP_TYPE_ININOUT); */
                     findrep = findrep_constructor(FINDREP_TYPE_INOUTPAIR); 
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                   /* findrep_setType(findrep, FINDREP_TYPE_ININOUT); */
                    findrep_setType(findrep, FINDREP_TYPE_INOUTPAIR);
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
                  /*  findrep = findrep_constructor(FINDREP_TYPE_ININOUT); */
                    findrep = findrep_constructor(FINDREP_TYPE_INOUTPAIR); 
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                   /* findrep_setType(findrep, FINDREP_TYPE_ININOUT); */
                    findrep_setType(findrep, FINDREP_TYPE_INOUTPAIR);
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

  case 128:
/* Line 1792 of yacc.c  */
#line 1962 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " findrep_options instruction ");
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1965 "..\\..\\parser.y"
    {}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1969 "..\\..\\parser.y"
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

  case 132:
/* Line 1792 of yacc.c  */
#line 1990 "..\\..\\parser.y"
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

  case 133:
/* Line 1792 of yacc.c  */
#line 2011 "..\\..\\parser.y"
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

  case 134:
/* Line 1792 of yacc.c  */
#line 2032 "..\\..\\parser.y"
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

  case 135:
/* Line 1792 of yacc.c  */
#line 2054 "..\\..\\parser.y"
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

  case 136:
/* Line 1792 of yacc.c  */
#line 2079 "..\\..\\parser.y"
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

  case 137:
/* Line 1792 of yacc.c  */
#line 2106 "..\\..\\parser.y"
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

  case 138:
/* Line 1792 of yacc.c  */
#line 2118 "..\\..\\parser.y"
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

  case 139:
/* Line 1792 of yacc.c  */
#line 2133 "..\\..\\parser.y"
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

  case 140:
/* Line 1792 of yacc.c  */
#line 2154 "..\\..\\parser.y"
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

  case 141:
/* Line 1792 of yacc.c  */
#line 2201 "..\\..\\parser.y"
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

  case 142:
/* Line 1792 of yacc.c  */
#line 2221 "..\\..\\parser.y"
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

  case 143:
/* Line 1792 of yacc.c  */
#line 2242 "..\\..\\parser.y"
    { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor((yyvsp[(3) - (6)].number));
        /* s.m. 20240201 change_setNoMatch(chg, $10);  */
        change_setpairs(chg, (yyvsp[(5) - (6)].changefield));
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
         nPosAbsRec += (yyvsp[(3) - (6)].number);       /* len output change */
}
    break;

  case 144:
/* Line 1792 of yacc.c  */
#line 2263 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2267 "..\\..\\parser.y"
    {}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2275 "..\\..\\parser.y"
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

  case 147:
/* Line 1792 of yacc.c  */
#line 2306 "..\\..\\parser.y"
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

  case 148:
/* Line 1792 of yacc.c  */
#line 2334 "..\\..\\parser.y"
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

  case 149:
/* Line 1792 of yacc.c  */
#line 2349 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2354 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2360 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2365 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2370 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2375 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2381 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2386 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2391 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2396 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2403 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2408 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2414 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2419 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2424 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2429 "..\\..\\parser.y"
    {     /* 202509 */
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2435 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2440 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2450 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2455 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2460 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2465 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2474 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2479 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2484 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2489 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2494 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2499 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2504 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2509 "..\\..\\parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2514 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2519 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2526 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2531 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2537 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2542 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2547 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 186:
/* Line 1792 of yacc.c  */
#line 2552 "..\\..\\parser.y"
    {     /* 202509 */
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 187:
/* Line 1792 of yacc.c  */
#line 2558 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
    break;

  case 188:
/* Line 1792 of yacc.c  */
#line 2563 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2572 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2577 "..\\..\\parser.y"
    {
		/*  current_inrec=0;    */
		nRecCase=0;
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2583 "..\\..\\parser.y"
    {}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2584 "..\\..\\parser.y"
    {}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2587 "..\\..\\parser.y"
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

  case 194:
/* Line 1792 of yacc.c  */
#line 2597 "..\\..\\parser.y"
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

  case 195:
/* Line 1792 of yacc.c  */
#line 2614 "..\\..\\parser.y"
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

  case 196:
/* Line 1792 of yacc.c  */
#line 2626 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2630 "..\\..\\parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        current_file=NULL;
}
    break;

  case 198:
/* Line 1792 of yacc.c  */
#line 2636 "..\\..\\parser.y"
    {
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
}
    break;

  case 199:
/* Line 1792 of yacc.c  */
#line 2653 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2657 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        /* Attenction file name for XSUM without FNAMES */
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2663 "..\\..\\parser.y"
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

  case 202:
/* Line 1792 of yacc.c  */
#line 2683 "..\\..\\parser.y"
    {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2689 "..\\..\\parser.y"
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
        /* verify current_outfil or file */
        outfil_SetVirtualFile(current_outfil, 0);       /* OUTFIL has file name */
        free((yyvsp[(1) - (1)].string));
        strcpy(szMexToken, " files clause ");
}
    break;

  case 204:
/* Line 1792 of yacc.c  */
#line 2710 "..\\..\\parser.y"
    {
		strcpy(szMexToken, " group files outfil ");
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2716 "..\\..\\parser.y"
    {
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2718 "..\\..\\parser.y"
    {
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2720 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 208:
/* Line 1792 of yacc.c  */
#line 2724 "..\\..\\parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 209:
/* Line 1792 of yacc.c  */
#line 2730 "..\\..\\parser.y"
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

  case 210:
/* Line 1792 of yacc.c  */
#line 2742 "..\\..\\parser.y"
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

  case 211:
/* Line 1792 of yacc.c  */
#line 2754 "..\\..\\parser.y"
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

  case 212:
/* Line 1792 of yacc.c  */
#line 2770 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2775 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2783 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2788 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2795 "..\\..\\parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2804 "..\\..\\parser.y"
    {}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2806 "..\\..\\parser.y"
    {}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2809 "..\\..\\parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2813 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2817 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 222:
/* Line 1792 of yacc.c  */
#line 2821 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2825 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 224:
/* Line 1792 of yacc.c  */
#line 2829 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 225:
/* Line 1792 of yacc.c  */
#line 2833 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 226:
/* Line 1792 of yacc.c  */
#line 2837 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2842 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2849 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2855 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2861 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 231:
/* Line 1792 of yacc.c  */
#line 2868 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2874 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (10)].string), (yyvsp[(5) - (10)].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[(2) - (10)].string));
        free((yyvsp[(5) - (10)].string));
        free((yyvsp[(9) - (10)].string));
}
    break;

  case 233:
/* Line 1792 of yacc.c  */
#line 2883 "..\\..\\parser.y"
    {
}
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2884 "..\\..\\parser.y"
    {
}
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2895 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2901 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2907 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 238:
/* Line 1792 of yacc.c  */
#line 2913 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 239:
/* Line 1792 of yacc.c  */
#line 2919 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 240:
/* Line 1792 of yacc.c  */
#line 2925 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 241:
/* Line 1792 of yacc.c  */
#line 2931 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 242:
/* Line 1792 of yacc.c  */
#line 2938 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 243:
/* Line 1792 of yacc.c  */
#line 2944 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 244:
/* Line 1792 of yacc.c  */
#line 2950 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 245:
/* Line 1792 of yacc.c  */
#line 2956 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 246:
/* Line 1792 of yacc.c  */
#line 2962 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 247:
/* Line 1792 of yacc.c  */
#line 2968 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 248:
/* Line 1792 of yacc.c  */
#line 2974 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 249:
/* Line 1792 of yacc.c  */
#line 2985 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


/* Line 1792 of yacc.c  */
#line 5571 "..\\..\\parser.c"
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
#line 2990 "..\\..\\parser.y"

