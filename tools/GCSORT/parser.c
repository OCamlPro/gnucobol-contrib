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
     REMOVECC = 319,
     CONVERT = 320,
     EQUALS = 321,
     NOEQUALS = 322,
     NODETAIL = 323,
     DIGIT = 324,
     DIGITBIG = 325,
     CHARTCOND = 326,
     CHARTYPE = 327,
     FILETYPE = 328,
     FORMATTYPE = 329,
     JOINFILE = 330,
     KEY = 331,
     KEYTYPE = 332,
     OCCURFILL = 333,
     OPCOND = 334,
     SUBSTRING = 335,
     ORDER = 336,
     RECTYPEFIX = 337,
     RECTYPEVAR = 338,
     STRING = 339,
     TOKSKIP = 340,
     EXROUT = 341,
     YESNO = 342,
     ERRTRUNC = 343,
     COLLATING = 344,
     SIGNDIGITBIG = 345
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
#line 216 "..\\..\\parser.c"
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
#line 244 "..\\..\\parser.c"
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

    #define  INREC_CASE        1
    #define  OUTREC_CASE    2
    #define  JOIN_CASE      3
    
    /* -->> extern char szMexToken[260];    */

    int yylex    (void);
    void yyerror (char const *);

    struct file_t*           current_file=NULL;
    struct outfil_t*       current_outfil=NULL;
    struct condField_t*       condField=NULL;
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
    int     nIntTmp;
    int  nTypeFormat;            /* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
    int  nTypeIncludeOmit;        /* 0= Nothing, 1 = Include, Omit=2                              */
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
#line 356 "..\\..\\parser.c"

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
#define YYLAST   564

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  97
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  90
/* YYNRULES -- Number of rules.  */
#define YYNRULES  253
/* YYNRULES -- Number of states.  */
#define YYNSTATES  559

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   345

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      92,    93,     2,     2,    91,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    96,     2,
       2,    94,     2,    95,     2,     2,     2,     2,     2,     2,
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
      85,    86,    87,    88,    89,    90
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
     939,   950,   959,   970,   972,   974,   976,   978,   979,   983,
     985,   991,   999,  1006,  1016,  1024,  1033,  1035,  1041,  1049,
    1056,  1066,  1074,  1083
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      98,     0,    -1,    -1,    99,    98,    -1,   186,    -1,   116,
      -1,   118,    -1,   120,    -1,   124,    -1,   126,    -1,   122,
      -1,   125,    -1,   128,    -1,   100,    -1,   102,    -1,   129,
      -1,   178,    -1,   179,    -1,   134,    -1,   133,    -1,   157,
      -1,   171,    -1,   145,    -1,   172,    -1,   177,    -1,   175,
      -1,   176,    -1,   174,    -1,   180,    -1,   183,    -1,   167,
      -1,    -1,    37,    84,   101,   104,    -1,    -1,    31,    84,
     103,   104,    -1,    -1,    33,    73,   104,    -1,    34,    83,
      91,    69,    91,    69,   104,    -1,    34,    92,    83,    91,
      69,    91,    69,    93,   104,    -1,    34,    82,    91,    69,
     104,    -1,    34,    92,    82,    91,    69,    93,   104,    -1,
      76,    92,   105,    93,   104,    -1,   107,    -1,   106,   105,
      -1,    69,    91,    69,    91,    77,    91,    -1,    69,    91,
      69,    91,    77,    91,    89,    91,    -1,    69,    91,    69,
      91,    77,    -1,    69,    91,    69,    91,    77,    91,    89,
      -1,    74,    -1,    80,    -1,    81,    -1,    79,    -1,    80,
      -1,    71,    84,    -1,    72,    84,    -1,    78,    84,    -1,
      69,    -1,    90,    -1,   115,    -1,   115,    91,   114,    -1,
      69,    91,    69,    91,   109,    -1,    69,    91,    69,    91,
     108,    91,   109,    -1,    -1,    35,    29,    92,   117,   114,
      93,    -1,    35,    29,    38,    -1,    -1,    32,    29,    92,
     119,   114,    93,    -1,    32,    29,    38,    -1,    -1,    36,
       6,    94,    75,    91,    29,    92,   121,   114,    93,    -1,
     123,    -1,   123,   122,    -1,    91,    47,    -1,    91,    47,
      91,    48,    -1,    19,    94,    90,    -1,    19,    94,    69,
      -1,    51,    49,    -1,    51,    49,   125,    -1,    51,    49,
      91,    75,   125,    -1,    51,    49,    91,    75,    91,    75,
     125,    -1,    -1,    91,    50,    -1,    -1,    52,    29,    92,
     127,   135,    93,   128,    -1,    -1,    53,    72,    84,    -1,
       7,    94,   108,    -1,     7,    94,    79,    -1,   131,    -1,
      92,   130,    93,    -1,   130,     3,   130,    -1,   130,    13,
     130,    -1,    69,    91,    69,    91,   108,    91,   110,    91,
      69,    91,    69,    91,   108,    -1,    69,    91,    69,    91,
     110,    91,    69,    91,    69,    -1,    69,    91,    69,    91,
     108,    91,   110,    91,   111,    -1,    69,    91,    69,    91,
     108,    91,   110,    91,   113,    -1,    69,    91,    69,    91,
     110,    91,   113,    -1,    69,    91,    69,    91,   110,    91,
     111,    -1,    69,    91,    69,    91,   108,    91,   110,    91,
     132,    -1,    41,    -1,    41,    69,    -1,    42,    -1,    42,
      69,    -1,    43,    -1,    43,    69,    -1,    44,    -1,    11,
       4,   130,    -1,    11,     4,    94,   130,    -1,     8,     4,
     130,    -1,     8,     4,    94,   130,    -1,     8,   129,    91,
       4,   130,    -1,     8,   129,    91,     4,    94,   130,    -1,
     136,    -1,   135,    91,   135,    -1,   141,    -1,    69,    91,
      69,    -1,    95,    -1,    75,    96,    69,    91,    69,    -1,
      69,    96,    72,    84,    -1,    69,    96,    69,    91,    69,
      -1,    78,    -1,    69,    96,    72,    -1,    72,    -1,   112,
      -1,    69,    91,    -1,    55,    94,   112,    91,    56,    94,
     112,   137,    -1,    55,    94,    92,   139,    93,    91,    56,
      94,   112,   137,    -1,    57,    94,    92,   140,    93,   137,
      -1,   138,    -1,   138,    91,   137,    -1,    -1,    58,    94,
      69,    -1,    59,    94,    69,    -1,    60,    94,    69,    -1,
      61,    94,    69,    -1,    62,    94,    88,    -1,    63,    94,
      87,    -1,   112,    -1,   112,    91,   139,    -1,   112,    -1,
     112,    91,   140,    -1,    45,    92,    69,    91,   142,    93,
      91,    46,    92,   144,    93,    -1,    45,    92,    69,    91,
     142,    93,    91,    46,    92,    69,    91,    69,    93,    -1,
      45,    92,    69,    91,   142,    93,    -1,   143,    -1,   143,
      91,   142,    -1,    72,    84,    91,    72,    84,    -1,    72,
      84,    91,    69,    91,    69,    -1,    72,    84,    -1,    -1,
      15,    29,    94,    92,   146,   135,    93,    -1,    -1,    15,
      29,    92,   147,   135,    93,    -1,    -1,    15,    28,    94,
      92,   148,   135,    93,    -1,    -1,    15,    28,    92,   149,
     135,    93,    -1,    -1,    15,    30,    94,    92,   150,   135,
      93,    -1,    -1,    15,    30,    92,   151,   135,    93,    -1,
      -1,    15,    54,    94,   152,   135,    -1,    -1,    15,    54,
      94,    92,   153,   135,    93,   137,    -1,    -1,    15,    54,
     154,   135,    -1,    -1,    15,    94,    92,   155,   135,    93,
      -1,    -1,    15,    92,   156,   135,    93,    -1,    -1,     9,
      29,    94,    92,   158,   135,    93,    -1,    -1,     9,    29,
      92,   159,   135,    93,    -1,    -1,     9,    28,    94,    92,
     160,   135,    93,    -1,    -1,     9,    28,    92,   161,   135,
      93,    -1,    -1,     9,    30,    94,    92,   162,   135,    93,
      -1,    -1,     9,    30,    92,   163,   135,    93,    -1,    -1,
       9,    54,    94,   164,   135,    -1,    -1,     9,    54,    94,
      92,   165,   135,    93,   137,    -1,    -1,     9,    54,   166,
     135,    -1,    -1,    91,    28,    92,   168,   135,    93,    -1,
     170,    -1,   170,    91,   169,    -1,    69,    91,    69,    -1,
      69,    91,    69,    91,    69,    91,    69,    -1,    69,    91,
      69,    91,   108,    -1,    20,    29,    10,    -1,    20,    29,
      10,    21,    -1,    20,    29,    10,    21,     6,    94,    84,
      -1,    20,    29,    92,   169,    93,    -1,    20,    29,    92,
     169,    93,    21,    -1,    20,    29,    92,   169,    93,    21,
       6,    94,    84,    -1,    85,    -1,    84,    -1,   173,    91,
     173,    -1,     6,    94,    92,   173,    93,    -1,     6,    94,
     173,    -1,    22,    -1,    23,    69,    -1,     8,    94,   130,
      -1,    11,    94,   130,    -1,    14,    -1,    18,    94,    90,
      -1,    18,    94,    69,    -1,     5,    94,    90,    -1,     5,
      94,    69,    -1,    16,    -1,   182,    -1,   182,   181,    -1,
      38,    -1,    17,    94,    90,    -1,    17,    94,    69,    -1,
      19,    94,    90,    -1,    19,    94,    69,    -1,    24,    -1,
      25,    -1,    26,    94,    69,    -1,    91,    86,    94,    92,
      84,    93,    -1,    27,    86,    94,    92,    84,    93,    -1,
      27,    86,    94,    92,    84,    91,    70,    93,    -1,    27,
      86,    94,    92,    84,    91,    70,    91,    84,    93,    -1,
      27,    86,    94,    92,    84,    91,    69,    93,    -1,    27,
      86,    94,    92,    84,    91,    69,    91,    84,    93,    -1,
      64,    -1,    66,    -1,    67,    -1,    68,    -1,    -1,    12,
     184,   181,    -1,    82,    -1,    82,    40,    92,    69,    93,
      -1,    82,    40,    92,    69,    91,    69,    93,    -1,    82,
      40,    92,    91,    69,    93,    -1,    82,    40,    92,    69,
      91,    69,    91,    69,    93,    -1,    82,    40,    92,    91,
      91,    69,    93,    -1,    82,    40,    92,    69,    91,    91,
      69,    93,    -1,    83,    -1,    83,    40,    92,    69,    93,
      -1,    83,    40,    92,    69,    91,    69,    93,    -1,    83,
      40,    92,    91,    69,    93,    -1,    83,    40,    92,    69,
      91,    69,    91,    69,    93,    -1,    83,    40,    92,    91,
      91,    69,    93,    -1,    83,    40,    92,    69,    91,    91,
      69,    93,    -1,    34,    39,   185,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   259,   259,   260,   262,   263,   264,   265,   266,   267,
     268,   269,   270,   271,   272,   273,   274,   275,   276,   277,
     278,   279,   280,   281,   282,   283,   284,   285,   287,   288,
     289,   294,   294,   311,   311,   328,   344,   355,   364,   373,
     382,   394,   400,   401,   409,   412,   418,   421,   427,   432,
     438,   445,   450,   462,   477,   491,   506,   519,   538,   540,
     546,   570,   585,   585,   592,   600,   600,   609,   619,   619,
     649,   650,   654,   658,   662,   666,   690,   696,   709,   739,
     756,   757,   777,   777,   788,   789,   805,   816,   841,   844,
     848,   857,   875,   891,   905,   917,   929,   944,   959,   977,
     994,  1018,  1034,  1061,  1079,  1103,  1123,  1132,  1144,  1153,
    1177,  1183,  1195,  1197,  1198,  1206,  1278,  1293,  1321,  1366,
    1408,  1496,  1541,  1595,  1635,  1689,  1780,  1871,  1970,  1973,
    1976,  1977,  1998,  2019,  2040,  2062,  2087,  2114,  2125,  2141,
    2161,  2209,  2229,  2250,  2271,  2275,  2283,  2314,  2342,  2357,
    2357,  2368,  2368,  2378,  2378,  2389,  2389,  2399,  2399,  2411,
    2411,  2422,  2422,  2432,  2432,  2443,  2443,  2458,  2458,  2468,
    2468,  2482,  2482,  2492,  2492,  2502,  2502,  2512,  2512,  2522,
    2522,  2534,  2534,  2545,  2545,  2555,  2555,  2566,  2566,  2580,
    2580,  2591,  2592,  2595,  2605,  2622,  2634,  2638,  2644,  2661,
    2665,  2671,  2691,  2697,  2718,  2724,  2726,  2728,  2732,  2738,
    2750,  2762,  2778,  2783,  2791,  2796,  2803,  2812,  2814,  2817,
    2821,  2825,  2829,  2833,  2837,  2841,  2845,  2849,  2856,  2863,
    2869,  2876,  2882,  2890,  2896,  2899,  2902,  2907,  2907,  2919,
    2925,  2931,  2937,  2943,  2949,  2955,  2962,  2968,  2974,  2980,
    2986,  2992,  2998,  3009
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
  "\"REMOVECC\"", "\"CONVERT\"", "\"EQUALS\"", "\"NOEQUALS\"",
  "\"NODETAIL\"", "\"DIGIT\"", "\"DIGITBIG\"", "\"CHARTCOND\"",
  "\"CHARTYPE\"", "\"FILETYPE\"", "\"FORMATTYPE\"", "\"JOINFILE\"",
  "\"KEY\"", "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"SUBSTRING\"",
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
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,    44,    40,    41,    61,    63,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    97,    98,    98,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,   101,   100,   103,   102,   104,   104,   104,   104,   104,
     104,   104,   105,   105,   106,   106,   107,   107,   108,   108,
     109,   110,   110,   111,   112,   112,   113,   113,   114,   114,
     115,   115,   117,   116,   116,   119,   118,   118,   121,   120,
     122,   122,   123,   123,   123,   123,   124,   124,   124,   124,
     125,   125,   127,   126,   128,   128,   129,   129,   130,   130,
     130,   130,   131,   131,   131,   131,   131,   131,   131,   132,
     132,   132,   132,   132,   132,   132,   133,   133,   134,   134,
     134,   134,   135,   135,   135,   136,   136,   136,   136,   136,
     136,   136,   136,   136,   136,   136,   136,   136,   137,   137,
     138,   138,   138,   138,   138,   138,   138,   139,   139,   140,
     140,   141,   141,   141,   142,   142,   143,   143,   144,   146,
     145,   147,   145,   148,   145,   149,   145,   150,   145,   151,
     145,   152,   145,   153,   145,   154,   145,   155,   145,   156,
     145,   158,   157,   159,   157,   160,   157,   161,   157,   162,
     157,   163,   157,   164,   157,   165,   157,   166,   157,   168,
     167,   169,   169,   170,   170,   170,   171,   171,   171,   171,
     171,   171,   172,   173,   173,   174,   174,   174,   174,   175,
     176,   177,   178,   178,   179,   179,   180,   181,   181,   182,
     182,   182,   182,   182,   182,   182,   182,   182,   182,   182,
     182,   182,   182,   182,   182,   182,   182,   184,   183,   185,
     185,   185,   185,   185,   185,   185,   185,   185,   185,   185,
     185,   185,   185,   186
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
      10,     8,    10,     1,     1,     1,     1,     0,     3,     1,
       5,     7,     6,     9,     7,     8,     1,     5,     7,     6,
       9,     7,     8,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   237,   211,     0,
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
     233,   234,   235,   236,     0,   238,   217,   155,     0,   151,
       0,   159,     0,   161,     0,     0,   167,   213,   212,    75,
      74,   196,     0,    35,    67,    65,   239,   246,   253,    64,
      62,     0,    35,     0,    77,    82,    85,   189,     0,     0,
       0,     0,     0,   109,     0,     0,     0,     0,   175,     0,
     171,     0,   179,   185,     0,     0,     0,     0,     0,   122,
       0,   120,   116,   123,   188,   112,   114,   107,     0,     0,
       0,     0,     0,   218,     0,   153,     0,   149,     0,   157,
     163,     0,   166,     0,     0,   197,     0,     0,   191,     0,
       0,     0,    34,     0,     0,     0,     0,     0,    32,    80,
       0,     0,    73,   205,   204,     0,    89,    90,    91,     0,
     110,     0,     0,     0,     0,     0,     0,     0,   184,     0,
       0,     0,   124,     0,    54,     0,    55,     0,   221,   220,
     223,   222,   226,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   162,   170,     0,     0,     0,   199,     0,    35,
       0,     0,     0,     0,     0,     0,    58,     0,     0,     0,
       0,     0,    78,     0,     0,     0,   111,   178,     0,   174,
       0,   182,     0,     0,     0,     0,     0,     0,     0,     0,
     115,     0,   121,     0,   113,     0,     0,   156,     0,   152,
       0,   160,     0,     0,   168,     0,   193,   200,   192,    36,
       0,     0,     0,     0,     0,     0,     0,    42,     0,    66,
       0,     0,     0,     0,     0,    63,     0,    80,    84,   190,
      51,    49,     0,     0,   176,   172,   180,   130,     0,   137,
       0,     0,   139,     0,     0,   118,     0,     0,     0,   154,
     150,   158,   130,   198,     0,     0,    35,     0,     0,     0,
       0,    35,    43,     0,    59,     0,   240,     0,     0,     0,
     247,     0,     0,    68,     0,    79,    83,     0,     0,     0,
       0,     0,     0,     0,     0,   186,   128,     0,     0,   144,
       0,     0,     0,     0,   130,   119,   117,     0,   228,   227,
     164,     0,   195,     0,    39,     0,     0,     0,     0,    41,
       0,     0,     0,   242,     0,     0,     0,   249,     0,     0,
      52,     0,    56,     0,    57,    97,    96,     0,     0,     0,
       0,     0,     0,   130,     0,   143,     0,   138,     0,     0,
     140,   127,     0,     0,     0,   201,    35,    35,     0,     0,
      50,     0,    60,     0,   241,     0,   244,     0,   248,     0,
     251,     0,     0,     0,    53,   131,   132,   133,   134,   135,
     136,   129,     0,     0,   145,     0,   130,     0,   231,     0,
     229,   194,    37,    40,     0,    46,     0,     0,   245,     0,
     252,    69,    99,   101,   103,   105,    56,    94,    95,    98,
      93,     0,     0,     0,     0,   125,     0,     0,    35,    44,
      61,   243,   250,   100,   102,   104,     0,     0,   146,     0,
     130,   232,   230,    38,    47,     0,   147,     0,     0,     0,
     126,    45,     0,     0,   148,   141,    92,     0,   142
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   162,    30,   153,   222,   335,   336,
     337,   104,   472,   353,   445,   193,   446,   285,   286,    31,
     226,    32,   223,    33,   439,    34,    35,    36,    37,    38,
     230,    39,    40,   108,   109,   519,    41,    42,   194,   195,
     405,   406,   360,   363,   196,   408,   409,   549,    43,   268,
     206,   266,   204,   270,   208,   211,   271,   144,   214,   145,
      44,   244,   179,   242,   177,   246,   181,   184,   247,   119,
      45,   231,   217,   218,    46,    47,   100,    48,    49,    50,
      51,    52,    53,    54,   135,   136,    55,    69,   158,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -368
static const yytype_int16 yypact[] =
{
     135,   -72,   -59,   -46,     4,     8,     3,  -368,  -368,    -9,
    -368,   -27,   -14,    10,  -368,    21,    48,   123,   158,   133,
     238,   230,   172,   182,   244,  -368,    44,   273,   135,  -368,
    -368,  -368,  -368,  -368,  -368,    -4,  -368,  -368,  -368,  -368,
    -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,
    -368,  -368,  -368,  -368,  -368,  -368,  -368,   -40,   110,   121,
     -38,    -8,   224,    84,   104,   131,   223,   -35,    -8,   166,
     137,   143,   149,   225,  -368,   226,    36,    47,     7,  -368,
    -368,   -22,   124,   -15,   227,  -368,   229,   232,   239,   233,
     235,  -368,  -368,  -368,   275,  -368,  -368,  -368,  -368,   245,
     236,  -368,  -368,  -368,  -368,   237,    -8,    -8,    27,  -368,
      27,   326,  -368,   240,  -368,   241,  -368,   242,   246,   167,
      -8,    27,    27,   247,   248,  -368,  -368,   249,   250,  -368,
    -368,  -368,  -368,  -368,   251,  -368,   166,  -368,   252,  -368,
     253,  -368,   254,   255,   167,   167,  -368,  -368,  -368,  -368,
    -368,   310,   266,    -1,  -368,  -368,   299,   300,  -368,  -368,
    -368,   274,    -1,    -7,  -368,  -368,  -368,  -368,   302,   147,
     245,   279,    11,    27,    -8,    -8,   -28,   167,  -368,   167,
    -368,   167,  -368,  -368,   167,   259,   258,   260,    34,   269,
     261,   271,  -368,  -368,   265,  -368,  -368,    27,    70,    87,
     289,   267,   268,  -368,   167,  -368,   167,  -368,   167,  -368,
    -368,   167,   265,   161,   167,   353,   272,   276,   277,   287,
      97,   278,  -368,   295,   280,   281,   295,   283,  -368,   284,
     167,   167,  -368,  -368,   236,   285,  -368,  -368,   362,    -8,
      27,   162,   167,   165,   167,   168,   167,   167,   265,   298,
      56,   286,   308,    41,  -368,   311,  -368,   167,  -368,  -368,
    -368,  -368,  -368,   290,   291,   173,   167,   174,   167,   177,
     167,   167,   265,  -368,   178,   292,   312,   350,   266,    -1,
     288,   293,   145,   316,   296,   297,   301,     9,    12,   303,
     359,    13,  -368,   181,   185,   129,    27,  -368,   186,  -368,
     189,  -368,   190,   193,   304,   269,   271,   127,   306,   127,
    -368,   307,   305,   309,   265,   315,   317,  -368,   194,  -368,
     197,  -368,   198,   201,  -368,   318,   313,   385,  -368,  -368,
     324,   325,   314,   319,   320,   321,   316,  -368,   334,  -368,
     295,   202,    23,   205,    24,  -368,   323,   322,   354,  -368,
    -368,  -368,   327,   328,  -368,  -368,  -368,   188,   336,   329,
     330,   356,   331,   332,   337,  -368,   340,   206,   333,  -368,
    -368,  -368,   188,  -368,    94,   335,    -1,   339,   347,   348,
     352,    -1,  -368,   341,  -368,    32,  -368,   338,   355,    33,
    -368,   342,   358,  -368,   378,  -368,  -368,   231,    37,   343,
     344,   345,   346,   349,   351,  -368,   357,   360,   361,   364,
     127,   365,   363,   127,   188,  -368,  -368,   243,  -368,  -368,
    -368,   367,  -368,   366,  -368,   372,   368,   369,   371,  -368,
     101,   209,   373,  -368,   370,   210,   377,  -368,   374,   295,
    -368,   375,   379,   380,  -368,  -368,  -368,   382,   383,   384,
     390,   381,   386,   188,   387,   388,   336,  -368,   391,   127,
    -368,  -368,   215,   216,   396,  -368,    -1,    -1,   399,   394,
    -368,   389,  -368,   403,  -368,   392,  -368,   405,  -368,   393,
    -368,   395,   -16,   406,  -368,  -368,  -368,  -368,  -368,  -368,
    -368,  -368,   144,   430,  -368,   397,   188,   398,  -368,   400,
    -368,  -368,  -368,  -368,   401,   402,   408,   404,  -368,   407,
    -368,  -368,   412,   414,   418,  -368,   410,  -368,  -368,  -368,
    -368,   411,   415,   413,   127,  -368,   416,   417,    -1,   409,
    -368,  -368,  -368,  -368,  -368,  -368,   421,   423,  -368,   146,
     188,  -368,  -368,  -368,   420,   422,  -368,   424,   419,   425,
    -368,  -368,    85,   426,  -368,  -368,  -368,   427,  -368
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -368,   449,  -368,  -368,  -368,  -368,  -368,  -162,    98,  -368,
    -368,  -292,   -73,    39,   -33,  -249,    14,  -222,  -368,  -368,
    -368,  -368,  -368,  -368,  -368,   469,  -368,  -368,   -84,  -368,
    -368,   159,   502,   -55,  -368,  -368,  -368,  -368,  -135,  -368,
    -367,  -368,   102,    95,  -368,    58,  -368,  -368,  -368,  -368,
    -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,
    -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,  -368,
    -368,  -368,   256,  -368,  -368,  -368,   -81,  -368,  -368,  -368,
    -368,  -368,  -368,  -368,   428,  -368,  -368,  -368,  -368,  -368
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     228,   308,   164,   352,   289,   420,   110,    67,    60,   212,
     213,     3,   121,   122,   174,    12,   154,   151,   169,    70,
      71,    72,    57,   159,   175,   512,   513,   514,   515,    96,
     174,   105,   219,   220,   105,    58,    63,    64,    65,    78,
     175,   105,   241,    91,   243,    73,   245,   461,    59,   248,
      97,   172,   173,   516,   106,   443,   107,   106,   359,   120,
     362,   105,    66,    91,   106,   197,   239,    76,   229,   265,
     155,   267,    89,   269,   444,   221,   272,   160,   341,   274,
      77,   343,   422,    74,   106,    75,   491,    94,   347,   234,
      79,    90,   387,   391,    91,   293,   294,    68,    61,   152,
     342,   431,   435,   344,   236,   147,   442,   298,   443,   300,
     311,   302,   303,   312,   388,   392,   149,   329,   384,   237,
     238,   240,   314,   432,   436,   252,   148,   444,   305,   525,
     253,   318,    80,   320,   306,   322,   323,   150,   471,   258,
       1,     2,     3,     4,     5,   292,     6,     7,   307,     8,
       9,    10,    81,    11,    12,    13,   260,    14,    15,   101,
     259,   359,    83,   421,   362,   103,    16,    17,   101,    18,
      19,    20,    21,   550,   103,   101,   112,   261,   113,   280,
     281,   103,   470,   123,   296,   124,    22,    23,    24,   282,
     125,   126,   127,   128,    98,   101,   114,    82,   115,   305,
     102,   103,    99,   101,   129,   306,   156,   157,   350,   351,
     496,    87,   185,   521,   424,   547,   522,   481,   548,   429,
      25,    86,   186,   116,   187,   117,    26,   332,   333,   137,
     130,   138,   131,   132,   133,   139,   188,   140,   170,   189,
     233,   141,   190,   142,    84,   191,   399,   400,   401,   402,
     403,   404,   257,   257,   273,   297,   257,   134,   299,   257,
     556,   301,   192,   395,   257,   257,   317,   319,   257,   257,
     321,   324,   257,    92,   348,   540,   257,   257,   349,   354,
     257,   257,   355,   356,   257,   257,   357,   369,   257,   257,
     370,   371,   257,   385,   372,   386,   389,   417,   390,   418,
     473,   477,   474,   478,   502,   503,   497,   499,   498,   500,
     350,   440,   462,   463,    85,   111,    88,   118,   146,   143,
     163,   161,    90,   166,   165,   167,   168,   170,   171,    98,
     176,   215,   178,   180,   182,   216,   201,   202,   183,   224,
     225,   198,   199,   200,   205,   207,   209,   210,   235,   227,
     232,   249,   250,   254,   251,   256,   257,   255,   262,   275,
     279,   263,   264,   276,   284,   174,   543,   304,   278,   277,
     283,   327,   287,   288,   290,   291,   295,   310,   309,   330,
     313,   326,   315,   316,   331,   334,   325,   338,   346,   365,
     339,   375,   340,   376,   377,   358,   345,   361,   364,   367,
     366,   368,   373,   383,   374,   378,   415,    24,   407,   416,
     379,   380,   412,   394,   381,   393,   426,   427,   397,   398,
     410,   428,   413,   411,   434,   414,   419,   438,    91,   423,
     425,   433,   430,   530,   382,   437,   441,   447,   448,   449,
     450,   466,   475,   451,   454,   452,   479,   495,   453,   517,
     465,   485,   486,   487,   455,   456,   458,   459,   464,   488,
     468,   467,   469,   476,   484,   501,   482,   480,   504,   489,
     483,   505,   507,   490,   509,   520,   523,    93,   492,   493,
     506,   533,   526,   534,   527,   508,   510,   535,   511,   470,
     545,   524,   546,   529,   528,   557,   518,   531,   544,   538,
     532,   536,   537,   554,    95,   539,    62,   396,   460,   541,
     542,   551,   457,   552,   494,   553,     0,     0,   555,     0,
     558,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   328,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   203
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-368)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
     162,   250,    86,   295,   226,   372,    61,     4,     4,   144,
     145,     7,    67,    68,     3,    19,    38,    10,    99,    28,
      29,    30,    94,    38,    13,    41,    42,    43,    44,    69,
       3,    69,    33,    34,    69,    94,    28,    29,    30,    29,
      13,    69,   177,    50,   179,    54,   181,   414,    94,   184,
      90,   106,   107,    69,    92,    71,    94,    92,   307,    94,
     309,    69,    54,    50,    92,   120,    94,    94,    75,   204,
      92,   206,    28,   208,    90,    76,   211,    92,    69,   214,
      94,    69,   374,    92,    92,    94,   453,    91,    75,   170,
      69,    47,    69,    69,    50,   230,   231,    94,    94,    92,
      91,    69,    69,    91,    93,    69,    69,   242,    71,   244,
      69,   246,   247,    72,    91,    91,    69,   279,   340,   174,
     175,   176,   257,    91,    91,    91,    90,    90,    72,   496,
      96,   266,    84,   268,    78,   270,   271,    90,   430,    69,
       5,     6,     7,     8,     9,   229,    11,    12,    92,    14,
      15,    16,    29,    18,    19,    20,    69,    22,    23,    74,
      90,   410,    29,    69,   413,    80,    31,    32,    74,    34,
      35,    36,    37,   540,    80,    74,    92,    90,    94,    82,
      83,    80,    81,    17,   239,    19,    51,    52,    53,    92,
      24,    25,    26,    27,    84,    74,    92,    39,    94,    72,
      79,    80,    92,    74,    38,    78,    82,    83,    79,    80,
     459,    29,    45,    69,   376,    69,    72,   439,    72,   381,
      85,    49,    55,    92,    57,    94,    91,    82,    83,    92,
      64,    94,    66,    67,    68,    92,    69,    94,    91,    72,
      93,    92,    75,    94,     6,    78,    58,    59,    60,    61,
      62,    63,    91,    91,    93,    93,    91,    91,    93,    91,
     552,    93,    95,   347,    91,    91,    93,    93,    91,    91,
      93,    93,    91,     0,    93,   524,    91,    91,    93,    93,
      91,    91,    93,    93,    91,    91,    93,    93,    91,    91,
      93,    93,    91,    91,    93,    93,    91,    91,    93,    93,
      91,    91,    93,    93,   466,   467,    91,    91,    93,    93,
      79,    80,    69,    70,    84,    91,    72,    94,    92,    94,
      91,    94,    47,    84,    92,    92,    91,    91,    91,    84,
       4,    21,    92,    92,    92,    69,    86,    86,    92,    40,
      40,    94,    94,    94,    92,    92,    92,    92,    69,    75,
      48,    92,    94,    84,    94,    84,    91,    96,    69,     6,
      73,    94,    94,    91,    69,     3,   528,    69,    91,    93,
      92,    21,    92,    92,    91,    91,    91,    69,    92,    91,
      69,    69,    92,    92,    91,    69,    94,    91,    29,    84,
      93,     6,    91,    69,    69,    91,    93,    91,    91,    84,
      91,    84,    84,    69,    91,    91,    69,    53,    72,    69,
      91,    91,    56,    91,    93,    92,    69,    69,    91,    91,
      91,    69,    91,    93,    69,    93,    93,    69,    50,    94,
      91,    93,    91,   506,   336,    93,   397,    94,    94,    94,
      94,    69,    69,    94,    84,    94,    69,    56,    91,   482,
      84,    69,    69,    69,    93,    91,    91,    94,    91,    69,
      91,    93,    91,    93,    84,    69,    91,    93,    69,    88,
      91,    77,    69,    87,    69,    69,    46,    28,    91,    91,
      91,    69,    84,    69,    84,    93,    93,    69,    93,    81,
      69,    94,    69,    91,    93,    69,   482,    93,    89,    84,
      93,    91,    91,    84,    35,    92,     4,   348,   413,    93,
      93,    91,   410,    91,   456,    91,    -1,    -1,    93,    -1,
      93,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   278,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   136
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    22,    23,    31,    32,    34,    35,
      36,    37,    51,    52,    53,    85,    91,    98,    99,   100,
     102,   116,   118,   120,   122,   123,   124,   125,   126,   128,
     129,   133,   134,   145,   157,   167,   171,   172,   174,   175,
     176,   177,   178,   179,   180,   183,   186,    94,    94,    94,
       4,    94,   129,    28,    29,    30,    54,     4,    94,   184,
      28,    29,    30,    54,    92,    94,    94,    94,    29,    69,
      84,    29,    39,    29,     6,    84,    49,    29,    72,    28,
      47,    50,     0,    98,    91,   122,    69,    90,    84,    92,
     173,    74,    79,    80,   108,    69,    92,    94,   130,   131,
     130,    91,    92,    94,    92,    94,    92,    94,    94,   166,
      94,   130,   130,    17,    19,    24,    25,    26,    27,    38,
      64,    66,    67,    68,    91,   181,   182,    92,    94,    92,
      94,    92,    94,    94,   154,   156,    92,    69,    90,    69,
      90,    10,    92,   103,    38,    92,    82,    83,   185,    38,
      92,    94,   101,    91,   125,    92,    84,    92,    91,   173,
      91,    91,   130,   130,     3,    13,     4,   161,    92,   159,
      92,   163,    92,    92,   164,    45,    55,    57,    69,    72,
      75,    78,    95,   112,   135,   136,   141,   130,    94,    94,
      94,    86,    86,   181,   149,    92,   147,    92,   151,    92,
      92,   152,   135,   135,   155,    21,    69,   169,   170,    33,
      34,    76,   104,   119,    40,    40,   117,    75,   104,    75,
     127,   168,    48,    93,   173,    69,    93,   130,   130,    94,
     130,   135,   160,   135,   158,   135,   162,   165,   135,    92,
      94,    94,    91,    96,    84,    96,    84,    91,    69,    90,
      69,    90,    69,    94,    94,   135,   148,   135,   146,   135,
     150,   153,   135,    93,   135,     6,    91,    93,    91,    73,
      82,    83,    92,    92,    69,   114,   115,    92,    92,   114,
      91,    91,   125,   135,   135,    91,   130,    93,   135,    93,
     135,    93,   135,   135,    69,    72,    78,    92,   112,    92,
      69,    69,    72,    69,   135,    92,    92,    93,   135,    93,
     135,    93,   135,   135,    93,    94,    69,    21,   169,   104,
      91,    91,    82,    83,    69,   105,   106,   107,    91,    93,
      91,    69,    91,    69,    91,    93,    29,    75,    93,    93,
      79,    80,   108,   110,    93,    93,    93,    93,    91,   112,
     139,    91,   112,   140,    91,    84,    91,    84,    84,    93,
      93,    93,    93,    84,    91,     6,    69,    69,    91,    91,
      91,    93,   105,    69,   114,    91,    93,    69,    91,    91,
      93,    69,    91,    92,    91,   125,   128,    91,    91,    58,
      59,    60,    61,    62,    63,   137,   138,    72,   142,   143,
      91,    93,    56,    91,    93,    69,    69,    91,    93,    93,
     137,    69,   108,    94,   104,    91,    69,    69,    69,   104,
      91,    69,    91,    93,    69,    69,    91,    93,    69,   121,
      80,   110,    69,    71,    90,   111,   113,    94,    94,    94,
      94,    94,    94,    91,    84,    93,    91,   139,    91,    94,
     140,   137,    69,    70,    91,    84,    69,    93,    91,    91,
      81,   108,   109,    91,    93,    69,    93,    91,    93,    69,
      93,   114,    91,    91,    84,    69,    69,    69,    69,    88,
      87,   137,    91,    91,   142,    56,   112,    91,    93,    91,
      93,    69,   104,   104,    69,    77,    91,    69,    93,    69,
      93,    93,    41,    42,    43,    44,    69,   111,   113,   132,
      69,    69,    72,    46,    94,   137,    84,    84,    93,    91,
     109,    93,    93,    69,    69,    69,    91,    91,    84,    92,
     112,    93,    93,   104,    89,    69,    69,    69,    72,   144,
     137,    91,    91,    91,    84,    93,   108,    69,    93
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
#line 262 "..\\..\\parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 263 "..\\..\\parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 264 "..\\..\\parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 265 "..\\..\\parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 266 "..\\..\\parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 267 "..\\..\\parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 268 "..\\..\\parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 269 "..\\..\\parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 270 "..\\..\\parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 271 "..\\..\\parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 272 "..\\..\\parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 273 "..\\..\\parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 274 "..\\..\\parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 275 "..\\..\\parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 276 "..\\..\\parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 277 "..\\..\\parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 278 "..\\..\\parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 279 "..\\..\\parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 280 "..\\..\\parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 281 "..\\..\\parser.y"
    {}
    break;

  case 24:
/* Line 1792 of yacc.c  */
#line 282 "..\\..\\parser.y"
    {}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 283 "..\\..\\parser.y"
    {}
    break;

  case 26:
/* Line 1792 of yacc.c  */
#line 284 "..\\..\\parser.y"
    {}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 285 "..\\..\\parser.y"
    {}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 287 "..\\..\\parser.y"
    {}
    break;

  case 29:
/* Line 1792 of yacc.c  */
#line 288 "..\\..\\parser.y"
    {}
    break;

  case 30:
/* Line 1792 of yacc.c  */
#line 289 "..\\..\\parser.y"
    {}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 294 "..\\..\\parser.y"
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
#line 305 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 311 "..\\..\\parser.y"
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
#line 322 "..\\..\\parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 328 "..\\..\\parser.y"
    {     
        strcpy(szMexToken, " record org instruction "); 
    }
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 344 "..\\..\\parser.y"
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
#line 355 "..\\..\\parser.y"
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
#line 364 "..\\..\\parser.y"
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
#line 373 "..\\..\\parser.y"
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
#line 382 "..\\..\\parser.y"
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
#line 394 "..\\..\\parser.y"
    {
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 400 "..\\..\\parser.y"
    { strcpy(szMexToken, " key instruction "); }
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 401 "..\\..\\parser.y"
    {}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 409 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (6)].number), (yyvsp[(3) - (6)].number), (yyvsp[(5) - (6)].string), NULL)) YYABORT;
    }
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 412 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (8)].number), (yyvsp[(3) - (8)].number), (yyvsp[(5) - (8)].string), (yyvsp[(7) - (8)].string))) YYABORT;
    }
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 418 "..\\..\\parser.y"
    {
         if (!process_keyfield((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].string), NULL)) YYABORT;
    }
    break;

  case 47:
/* Line 1792 of yacc.c  */
#line 421 "..\\..\\parser.y"
    {
        if (!process_keyfield((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), (yyvsp[(5) - (7)].string), (yyvsp[(7) - (7)].string))) YYABORT;
 }
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 427 "..\\..\\parser.y"
    {
        (yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 432 "..\\..\\parser.y"
    {
        (yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 438 "..\\..\\parser.y"
    {
        (yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
        free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 445 "..\\..\\parser.y"
    {
        (yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 450 "..\\..\\parser.y"
    {
        (yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 462 "..\\..\\parser.y"
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
#line 477 "..\\..\\parser.y"
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
#line 491 "..\\..\\parser.y"
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
#line 506 "..\\..\\parser.y"
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
#line 519 "..\\..\\parser.y"
    {
        char szType[] = "Z";
        pszInt = (char*) malloc(32);         
        #ifdef    _MSC_VER
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
#line 538 "..\\..\\parser.y"
    {
}
    break;

  case 59:
/* Line 1792 of yacc.c  */
#line 540 "..\\..\\parser.y"
    {
        
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 546 "..\\..\\parser.y"
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
#line 570 "..\\..\\parser.y"
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
#line 585 "..\\..\\parser.y"
    {
        current_sortField=1;
        }
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 587 "..\\..\\parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');        /* for Sort */
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 592 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');        /* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 600 "..\\..\\parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 603 "..\\..\\parser.y"
    {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 609 "..\\..\\parser.y"
    {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 619 "..\\..\\parser.y"
    {
        nRecCase=JOIN_CASE;
        job_SetTypeOP('J');        /* for Join */
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
#line 640 "..\\..\\parser.y"
    {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free((yyvsp[(4) - (10)].string));  /* Verify */
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 649 "..\\..\\parser.y"
    {}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 650 "..\\..\\parser.y"
    {}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 654 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 658 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
    break;

  case 74:
/* Line 1792 of yacc.c  */
#line 662 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].llnumber));
}
    break;

  case 75:
/* Line 1792 of yacc.c  */
#line 666 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[(3) - (3)].number));
}
    break;

  case 76:
/* Line 1792 of yacc.c  */
#line 690 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
    break;

  case 77:
/* Line 1792 of yacc.c  */
#line 696 "..\\..\\parser.y"
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
#line 709 "..\\..\\parser.y"
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
#line 739 "..\\..\\parser.y"
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
#line 757 "..\\..\\parser.y"
    {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
        strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 777 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
        nPosAbsRec = 0;
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 782 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 789 "..\\..\\parser.y"
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
#line 805 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " format clause ");
        nFieldType = (yyvsp[(3) - (3)].number);    /* save field type */
        if (nTypeFormat == 1)
            condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
        if (nTypeFormat == 2)
            condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(3) - (3)].number));
        if (nTypeFormat == 3)    /* for SumFields    */
            condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
    }
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 816 "..\\..\\parser.y"
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
#line 841 "..\\..\\parser.y"
    {
        (yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 844 "..\\..\\parser.y"
    {
        (yyval.condField)=(yyvsp[(2) - (3)].condField);
        strcpy(szMexToken, " condition field 01 ");
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 848 "..\\..\\parser.y"
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
#line 857 "..\\..\\parser.y"
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
#line 875 "..\\..\\parser.y"
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
#line 891 "..\\..\\parser.y"
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
#line 905 "..\\..\\parser.y"
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
#line 917 "..\\..\\parser.y"
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
#line 929 "..\\..\\parser.y"
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
#line 944 "..\\..\\parser.y"
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
#line 959 "..\\..\\parser.y"
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
#line 977 "..\\..\\parser.y"
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
#line 994 "..\\..\\parser.y"
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
#line 1018 "..\\..\\parser.y"
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
#line 1034 "..\\..\\parser.y"
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
#line 1061 "..\\..\\parser.y"
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
#line 1079 "..\\..\\parser.y"
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
#line 1103 "..\\..\\parser.y"
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
#line 1123 "..\\..\\parser.y"
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
#line 1132 "..\\..\\parser.y"
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
#line 1144 "..\\..\\parser.y"
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
#line 1153 "..\\..\\parser.y"
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
#line 1177 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(5) - (5)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1183 "..\\..\\parser.y"
    {
        condField_addInclude((yyvsp[(6) - (6)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1195 "..\\..\\parser.y"
    {    
}
    break;

  case 113:
/* Line 1792 of yacc.c  */
#line 1197 "..\\..\\parser.y"
    {    }
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1198 "..\\..\\parser.y"
    {}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1206 "..\\..\\parser.y"
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
#line 1278 "..\\..\\parser.y"
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
#line 1293 "..\\..\\parser.y"
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
#line 1321 "..\\..\\parser.y"
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
#line 1366 "..\\..\\parser.y"
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
#line 1408 "..\\..\\parser.y"
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
#line 1496 "..\\..\\parser.y"
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
                    nPosAbsRec = (yyvsp[(1) - (3)].number);        /* - inrec->change_position.fieldValue->generated_length;   */
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
#line 1541 "..\\..\\parser.y"
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
#line 1595 "..\\..\\parser.y"
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
#line 1635 "..\\..\\parser.y"
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
#line 1689 "..\\..\\parser.y"
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
#line 1780 "..\\..\\parser.y"
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
#line 1871 "..\\..\\parser.y"
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
#line 1970 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " findrep_options instruction ");
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1973 "..\\..\\parser.y"
    {}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1977 "..\\..\\parser.y"
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
#line 1998 "..\\..\\parser.y"
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
#line 2019 "..\\..\\parser.y"
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
#line 2040 "..\\..\\parser.y"
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
#line 2062 "..\\..\\parser.y"
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
#line 2087 "..\\..\\parser.y"
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
#line 2114 "..\\..\\parser.y"
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
#line 2126 "..\\..\\parser.y"
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
#line 2141 "..\\..\\parser.y"
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
#line 2162 "..\\..\\parser.y"
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
#line 2209 "..\\..\\parser.y"
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
#line 2229 "..\\..\\parser.y"
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
#line 2250 "..\\..\\parser.y"
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
#line 2271 "..\\..\\parser.y"
    { 
        strcpy(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[(1) - (1)].changefield);
}
    break;

  case 145:
/* Line 1792 of yacc.c  */
#line 2275 "..\\..\\parser.y"
    {}
    break;

  case 146:
/* Line 1792 of yacc.c  */
#line 2283 "..\\..\\parser.y"
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
#line 2314 "..\\..\\parser.y"
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
#line 2342 "..\\..\\parser.y"
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
#line 2357 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 150:
/* Line 1792 of yacc.c  */
#line 2362 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 151:
/* Line 1792 of yacc.c  */
#line 2368 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 152:
/* Line 1792 of yacc.c  */
#line 2373 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 153:
/* Line 1792 of yacc.c  */
#line 2378 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 154:
/* Line 1792 of yacc.c  */
#line 2383 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        nPosAbsRec = 0;
}
    break;

  case 155:
/* Line 1792 of yacc.c  */
#line 2389 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 156:
/* Line 1792 of yacc.c  */
#line 2394 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 157:
/* Line 1792 of yacc.c  */
#line 2399 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 158:
/* Line 1792 of yacc.c  */
#line 2404 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 159:
/* Line 1792 of yacc.c  */
#line 2411 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
        }
    break;

  case 160:
/* Line 1792 of yacc.c  */
#line 2416 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 161:
/* Line 1792 of yacc.c  */
#line 2422 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 162:
/* Line 1792 of yacc.c  */
#line 2427 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        nPosAbsRec = 0;
}
    break;

  case 163:
/* Line 1792 of yacc.c  */
#line 2432 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 164:
/* Line 1792 of yacc.c  */
#line 2437 "..\\..\\parser.y"
    {     /* 202509 */
        current_outrec=0;
        nRecCase=0;
        nPosAbsRec = 0;
}
    break;

  case 165:
/* Line 1792 of yacc.c  */
#line 2443 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 166:
/* Line 1792 of yacc.c  */
#line 2448 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 167:
/* Line 1792 of yacc.c  */
#line 2458 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
        nPosAbsRec = 0;
}
    break;

  case 168:
/* Line 1792 of yacc.c  */
#line 2463 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 169:
/* Line 1792 of yacc.c  */
#line 2468 "..\\..\\parser.y"
    {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 170:
/* Line 1792 of yacc.c  */
#line 2473 "..\\..\\parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 171:
/* Line 1792 of yacc.c  */
#line 2482 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 172:
/* Line 1792 of yacc.c  */
#line 2487 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 173:
/* Line 1792 of yacc.c  */
#line 2492 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
        }
    break;

  case 174:
/* Line 1792 of yacc.c  */
#line 2497 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 175:
/* Line 1792 of yacc.c  */
#line 2502 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 176:
/* Line 1792 of yacc.c  */
#line 2507 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 177:
/* Line 1792 of yacc.c  */
#line 2512 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 178:
/* Line 1792 of yacc.c  */
#line 2517 "..\\..\\parser.y"
    {
            current_inrec=0;
            nRecCase=0;
}
    break;

  case 179:
/* Line 1792 of yacc.c  */
#line 2522 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 180:
/* Line 1792 of yacc.c  */
#line 2527 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 181:
/* Line 1792 of yacc.c  */
#line 2534 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
        }
    break;

  case 182:
/* Line 1792 of yacc.c  */
#line 2539 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 183:
/* Line 1792 of yacc.c  */
#line 2545 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 184:
/* Line 1792 of yacc.c  */
#line 2550 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        nPosAbsRec = 0;
}
    break;

  case 185:
/* Line 1792 of yacc.c  */
#line 2555 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 186:
/* Line 1792 of yacc.c  */
#line 2560 "..\\..\\parser.y"
    {     /* 202509 */
        current_inrec=0;
        nRecCase=0;
        nPosAbsRec = 0;
}
    break;

  case 187:
/* Line 1792 of yacc.c  */
#line 2566 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
        nPosAbsRec = 0;
}
    break;

  case 188:
/* Line 1792 of yacc.c  */
#line 2571 "..\\..\\parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 189:
/* Line 1792 of yacc.c  */
#line 2580 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
        nPosAbsRec = 0;
}
    break;

  case 190:
/* Line 1792 of yacc.c  */
#line 2585 "..\\..\\parser.y"
    {
        /*  current_inrec=0;    */
        nRecCase=0;
}
    break;

  case 191:
/* Line 1792 of yacc.c  */
#line 2591 "..\\..\\parser.y"
    {}
    break;

  case 192:
/* Line 1792 of yacc.c  */
#line 2592 "..\\..\\parser.y"
    {}
    break;

  case 193:
/* Line 1792 of yacc.c  */
#line 2595 "..\\..\\parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
            YYABORT;
        }
        nTypeFormat=3;            /* for SumFields Format=    */
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 194:
/* Line 1792 of yacc.c  */
#line 2605 "..\\..\\parser.y"
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
            nTypeFormat=3;            /* for SumFields Format=    */
             SumField_addDefinition(SumField1); 
            nTypeFormat=3;            /* for SumFields Format=    */
             SumField_addDefinition(SumField2); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 195:
/* Line 1792 of yacc.c  */
#line 2622 "..\\..\\parser.y"
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
#line 2634 "..\\..\\parser.y"
    {
        SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 197:
/* Line 1792 of yacc.c  */
#line 2638 "..\\..\\parser.y"
    {
        SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        current_file=NULL;
}
    break;

  case 198:
/* Line 1792 of yacc.c  */
#line 2644 "..\\..\\parser.y"
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
#line 2661 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 200:
/* Line 1792 of yacc.c  */
#line 2665 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        /* Attenction file name for XSUM without FNAMES */
}
    break;

  case 201:
/* Line 1792 of yacc.c  */
#line 2671 "..\\..\\parser.y"
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
#line 2691 "..\\..\\parser.y"
    {
        /*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
    break;

  case 203:
/* Line 1792 of yacc.c  */
#line 2697 "..\\..\\parser.y"
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
#line 2718 "..\\..\\parser.y"
    {
        strcpy(szMexToken, " group files outfil ");
}
    break;

  case 205:
/* Line 1792 of yacc.c  */
#line 2724 "..\\..\\parser.y"
    {
}
    break;

  case 206:
/* Line 1792 of yacc.c  */
#line 2726 "..\\..\\parser.y"
    {
}
    break;

  case 207:
/* Line 1792 of yacc.c  */
#line 2728 "..\\..\\parser.y"
    {
       utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 208:
/* Line 1792 of yacc.c  */
#line 2732 "..\\..\\parser.y"
    {
       utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 209:
/* Line 1792 of yacc.c  */
#line 2738 "..\\..\\parser.y"
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
#line 2750 "..\\..\\parser.y"
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
#line 2762 "..\\..\\parser.y"
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
#line 2778 "..\\..\\parser.y"
    {
        if (current_outfil != NULL)
            outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
        strcpy(szMexToken, " start rec clause ");
}
    break;

  case 213:
/* Line 1792 of yacc.c  */
#line 2783 "..\\..\\parser.y"
    {
        if (current_outfil != NULL)
            outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
        strcpy(szMexToken, " start rec clause ");
}
    break;

  case 214:
/* Line 1792 of yacc.c  */
#line 2791 "..\\..\\parser.y"
    {
        if (current_outfil != NULL)
            outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
        strcpy(szMexToken, " end rec clause ");
}
    break;

  case 215:
/* Line 1792 of yacc.c  */
#line 2796 "..\\..\\parser.y"
    {
        if (current_outfil != NULL)
            outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
        strcpy(szMexToken, " end rec clause ");
}
    break;

  case 216:
/* Line 1792 of yacc.c  */
#line 2803 "..\\..\\parser.y"
    {
        if (current_outfil != NULL)
            outfil_SetSave(current_outfil);
        strcpy(szMexToken, " save clause ");
}
    break;

  case 217:
/* Line 1792 of yacc.c  */
#line 2812 "..\\..\\parser.y"
    {}
    break;

  case 218:
/* Line 1792 of yacc.c  */
#line 2814 "..\\..\\parser.y"
    {}
    break;

  case 219:
/* Line 1792 of yacc.c  */
#line 2817 "..\\..\\parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
        strcpy(szMexToken, " option copy clause ");
}
    break;

  case 220:
/* Line 1792 of yacc.c  */
#line 2821 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
        strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 221:
/* Line 1792 of yacc.c  */
#line 2825 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
        strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 222:
/* Line 1792 of yacc.c  */
#line 2829 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
        strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 223:
/* Line 1792 of yacc.c  */
#line 2833 "..\\..\\parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
        strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 224:
/* Line 1792 of yacc.c  */
#line 2837 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
        strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 225:
/* Line 1792 of yacc.c  */
#line 2841 "..\\..\\parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
        strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 226:
/* Line 1792 of yacc.c  */
#line 2845 "..\\..\\parser.y"
    {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[(3) - (3)].number));
        strcpy(szMexToken, " option y2past clause ");
}
    break;

  case 227:
/* Line 1792 of yacc.c  */
#line 2850 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
        strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 228:
/* Line 1792 of yacc.c  */
#line 2857 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (6)].string), (yyvsp[(5) - (6)].string));
        strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[(2) - (6)].string));
        free((yyvsp[(5) - (6)].string));
}
    break;

  case 229:
/* Line 1792 of yacc.c  */
#line 2863 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
        strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 230:
/* Line 1792 of yacc.c  */
#line 2869 "..\\..\\parser.y"
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
#line 2876 "..\\..\\parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[(2) - (8)].string), (yyvsp[(5) - (8)].string));
        strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[(2) - (8)].string));
        free((yyvsp[(5) - (8)].string));
}
    break;

  case 232:
/* Line 1792 of yacc.c  */
#line 2882 "..\\..\\parser.y"
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
#line 2890 "..\\..\\parser.y"
    {
        printf("GCSORT - Warning - Token skipped : REMOVECC in OPTION\n");
    }
    break;

  case 234:
/* Line 1792 of yacc.c  */
#line 2896 "..\\..\\parser.y"
    {
        printf("GCSORT - Warning - Token skipped : EQUALS in OPTION\n");
    }
    break;

  case 235:
/* Line 1792 of yacc.c  */
#line 2899 "..\\..\\parser.y"
    {
        printf("GCSORT - Warning - Token skipped : NOEQUALS in OPTION\n");
    }
    break;

  case 236:
/* Line 1792 of yacc.c  */
#line 2902 "..\\..\\parser.y"
    {
        printf("GCSORT - Warning - Token skipped : NODETAIL in OPTION\n");
    }
    break;

  case 237:
/* Line 1792 of yacc.c  */
#line 2907 "..\\..\\parser.y"
    {
}
    break;

  case 238:
/* Line 1792 of yacc.c  */
#line 2908 "..\\..\\parser.y"
    {
}
    break;

  case 239:
/* Line 1792 of yacc.c  */
#line 2919 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
        strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 240:
/* Line 1792 of yacc.c  */
#line 2925 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 241:
/* Line 1792 of yacc.c  */
#line 2931 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 242:
/* Line 1792 of yacc.c  */
#line 2937 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 243:
/* Line 1792 of yacc.c  */
#line 2943 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 244:
/* Line 1792 of yacc.c  */
#line 2949 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 245:
/* Line 1792 of yacc.c  */
#line 2955 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 246:
/* Line 1792 of yacc.c  */
#line 2962 "..\\..\\parser.y"
    {
/*        utils_SetOptionSort("COPY", NULL, 0); */
        strcpy(szMexToken, " record option clause ");
        free((yyvsp[(1) - (1)].string));
}
    break;

  case 247:
/* Line 1792 of yacc.c  */
#line 2968 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (5)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (5)].number), -1, -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (5)].string));
}
    break;

  case 248:
/* Line 1792 of yacc.c  */
#line 2974 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (7)].number), (yyvsp[(6) - (7)].number), -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 249:
/* Line 1792 of yacc.c  */
#line 2980 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (6)].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[(5) - (6)].number), -1, -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (6)].string));
}
    break;

  case 250:
/* Line 1792 of yacc.c  */
#line 2986 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (9)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (9)].number), (yyvsp[(6) - (9)].number), (yyvsp[(8) - (9)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (9)].string));
}
    break;

  case 251:
/* Line 1792 of yacc.c  */
#line 2992 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (7)].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[(6) - (7)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (7)].string));
}
    break;

  case 252:
/* Line 1792 of yacc.c  */
#line 2998 "..\\..\\parser.y"
    {
        utils_SetRecordOptionSortType((yyvsp[(1) - (8)].string));
        utils_SetRecordOptionSortLen((yyvsp[(4) - (8)].number), -1, (yyvsp[(7) - (8)].number), -1, -1, -1, -1);
        strcpy(szMexToken, "  record option clause ");
        free((yyvsp[(1) - (8)].string));
}
    break;

  case 253:
/* Line 1792 of yacc.c  */
#line 3009 "..\\..\\parser.y"
    {
    /*} allrecordoption { */
}
    break;


/* Line 1792 of yacc.c  */
#line 5622 "..\\..\\parser.c"
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
#line 3014 "..\\..\\parser.y"

