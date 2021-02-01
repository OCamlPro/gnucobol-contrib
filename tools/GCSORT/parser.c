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
     BUILD = 280,
     FIELDS = 281,
     OVERLAY = 282,
     GIVE = 283,
     MERGE = 284,
     ORG = 285,
     RECORD = 286,
     SORT = 287,
     USE = 288,
     COPY = 289,
     DIGIT = 290,
     CHARTCOND = 291,
     CHARTYPE = 292,
     FILETYPE = 293,
     FORMATTYPE = 294,
     KEY = 295,
     KEYTYPE = 296,
     OCCURFILL = 297,
     OPCOND = 298,
     ORDER = 299,
     RECTYPEFIX = 300,
     RECTYPEVAR = 301,
     STRING = 302,
     TOKSKIP = 303,
     SIGNDIGITBIG = 304
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 23 "parser.y"
 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t  *condField;
	struct fieldValue_t *fieldValue;
	struct SumField_t   *SumField;


/* Line 387 of yacc.c  */
#line 172 "parser.c"
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
#line 200 "parser.c"
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

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2

    //-->> extern char szMexToken[260];

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		current_file=NULL;
	struct outfil_t*	current_outfil=NULL;
	struct condField_t*	condField=NULL;
    struct inrec_t *    inrec=NULL;
    struct outrec_t *   outrec=NULL;


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

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			// 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields
	int  nTypeIncludeOmit;		// 0= Nothing, 1 = Include, Omit=2
	int  nstate_outfil = 0;



/* Line 391 of yacc.c  */
#line 265 "parser.c"

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
#define YYFINAL  64
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   262

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  55
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  61
/* YYNRULES -- Number of rules.  */
#define YYNRULES  140
/* YYNRULES -- Number of states.  */
#define YYNSTATES  294

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   304

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      51,    52,     2,     2,    50,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    54,     2,
       2,    53,     2,     2,     2,     2,     2,     2,     2,     2,
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
      45,    46,    47,    48,    49
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    46,    51,    52,    57,    58,    62,
      70,    80,    86,    94,   100,   102,   106,   112,   114,   116,
     118,   121,   124,   126,   128,   130,   134,   140,   148,   149,
     156,   160,   161,   168,   172,   176,   178,   182,   186,   190,
     204,   214,   224,   234,   242,   250,   254,   259,   263,   268,
     270,   274,   278,   283,   289,   291,   294,   298,   300,   302,
     305,   306,   314,   315,   322,   323,   331,   332,   339,   340,
     348,   349,   356,   357,   364,   365,   371,   372,   380,   381,
     388,   389,   397,   398,   405,   406,   414,   415,   422,   424,
     428,   432,   440,   446,   450,   456,   458,   460,   464,   470,
     474,   476,   479,   483,   487,   489,   493,   497,   501,   505,
     507,   509,   512,   514,   518,   522,   526,   530,   532,   534,
     535
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      56,     0,    -1,    -1,    57,    56,    -1,    73,    -1,    75,
      -1,    58,    -1,    60,    -1,    77,    -1,   109,    -1,   110,
      -1,    81,    -1,    80,    -1,    93,    -1,   102,    -1,    84,
      -1,   103,    -1,   108,    -1,   106,    -1,   107,    -1,   105,
      -1,   111,    -1,   114,    -1,    -1,    33,    47,    59,    62,
      -1,    -1,    28,    47,    61,    62,    -1,    -1,    30,    38,
      62,    -1,    31,    46,    50,    35,    50,    35,    62,    -1,
      31,    51,    46,    50,    35,    50,    35,    52,    62,    -1,
      31,    45,    50,    35,    62,    -1,    31,    51,    45,    50,
      35,    52,    62,    -1,    40,    51,    63,    52,    62,    -1,
      64,    -1,    64,    50,    63,    -1,    35,    50,    35,    50,
      41,    -1,    39,    -1,    44,    -1,    43,    -1,    36,    47,
      -1,    37,    47,    -1,    35,    -1,    49,    -1,    72,    -1,
      72,    50,    71,    -1,    35,    50,    35,    50,    66,    -1,
      35,    50,    35,    50,    65,    50,    66,    -1,    -1,    32,
      26,    51,    74,    71,    52,    -1,    32,    26,    34,    -1,
      -1,    29,    26,    51,    76,    71,    52,    -1,    29,    26,
      34,    -1,     7,    53,    65,    -1,    79,    -1,    51,    78,
      52,    -1,    78,     3,    78,    -1,    78,    13,    78,    -1,
      35,    50,    35,    50,    65,    50,    67,    50,    35,    50,
      35,    50,    65,    -1,    35,    50,    35,    50,    67,    50,
      35,    50,    35,    -1,    35,    50,    35,    50,    65,    50,
      67,    50,    68,    -1,    35,    50,    35,    50,    65,    50,
      67,    50,    70,    -1,    35,    50,    35,    50,    67,    50,
      70,    -1,    35,    50,    35,    50,    67,    50,    68,    -1,
      11,     4,    78,    -1,    11,     4,    53,    78,    -1,     8,
       4,    78,    -1,     8,     4,    53,    78,    -1,    83,    -1,
      82,    50,    82,    -1,    35,    50,    35,    -1,    35,    54,
      37,    47,    -1,    35,    54,    35,    50,    35,    -1,    42,
      -1,    42,    47,    -1,    35,    54,    37,    -1,    37,    -1,
      69,    -1,    35,    50,    -1,    -1,    15,    26,    53,    51,
      85,    82,    52,    -1,    -1,    15,    26,    51,    86,    82,
      52,    -1,    -1,    15,    25,    53,    51,    87,    82,    52,
      -1,    -1,    15,    25,    51,    88,    82,    52,    -1,    -1,
      15,    27,    53,    51,    89,    82,    52,    -1,    -1,    15,
      27,    51,    90,    82,    52,    -1,    -1,    15,    53,    51,
      91,    82,    52,    -1,    -1,    15,    51,    92,    82,    52,
      -1,    -1,     9,    26,    53,    51,    94,    82,    52,    -1,
      -1,     9,    26,    51,    95,    82,    52,    -1,    -1,     9,
      25,    53,    51,    96,    82,    52,    -1,    -1,     9,    25,
      51,    97,    82,    52,    -1,    -1,     9,    27,    53,    51,
      98,    82,    52,    -1,    -1,     9,    27,    51,    99,    82,
      52,    -1,   101,    -1,   101,    50,   100,    -1,    35,    50,
      35,    -1,    35,    50,    35,    50,    35,    50,    35,    -1,
      35,    50,    35,    50,    65,    -1,    20,    26,    10,    -1,
      20,    26,    51,   100,    52,    -1,    48,    -1,    47,    -1,
     104,    50,   104,    -1,     6,    53,    51,   104,    52,    -1,
       6,    53,   104,    -1,    21,    -1,    22,    35,    -1,     8,
      53,    78,    -1,    11,    53,    78,    -1,    14,    -1,    18,
      53,    49,    -1,    18,    53,    35,    -1,     5,    53,    49,
      -1,     5,    53,    35,    -1,    16,    -1,   113,    -1,   113,
     112,    -1,    34,    -1,    17,    53,    49,    -1,    17,    53,
      35,    -1,    19,    53,    49,    -1,    19,    53,    35,    -1,
      23,    -1,    24,    -1,    -1,    12,   115,   112,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   156,   156,   157,   159,   160,   161,   162,   163,   164,
     165,   166,   167,   168,   169,   170,   171,   172,   173,   174,
     175,   177,   178,   182,   182,   199,   199,   216,   219,   230,
     239,   248,   257,   266,   271,   274,   278,   293,   299,   306,
     318,   333,   348,   361,   380,   382,   388,   400,   415,   415,
     422,   429,   429,   438,   450,   472,   475,   479,   488,   506,
     522,   536,   548,   560,   574,   586,   592,   601,   607,   618,
     620,   627,   682,   725,   766,   809,   852,   896,   948,   988,
    1041,  1041,  1052,  1052,  1062,  1062,  1073,  1073,  1083,  1083,
    1095,  1095,  1111,  1111,  1121,  1121,  1135,  1135,  1145,  1145,
    1155,  1155,  1165,  1165,  1175,  1175,  1187,  1187,  1203,  1204,
    1207,  1217,  1234,  1246,  1250,  1257,  1263,  1282,  1288,  1290,
    1292,  1296,  1302,  1311,  1319,  1335,  1340,  1348,  1353,  1360,
    1369,  1371,  1374,  1378,  1382,  1386,  1390,  1394,  1398,  1404,
    1404
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
  "\"VLSCMP clause\"", "\"VLSHRT clause\"", "\"BUILD instruction\"",
  "\"FIELDS instruction\"", "\"OVERLAY instruction\"", "\"GIVE clause\"",
  "\"MERGE clause\"", "\"ORG instruction\"", "\"RECORD instruction\"",
  "\"SORT clause\"", "\"USE clause\"", "\"COPY\"", "\"DIGIT\"",
  "\"CHARTCOND\"", "\"CHARTYPE\"", "\"FILETYPE\"", "\"FORMATTYPE\"",
  "\"KEY\"", "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"ORDER\"",
  "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"", "\"TOKSKIP clause\"",
  "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='", "':'", "$accept",
  "beginning", "clause", "useclause", "$@1", "giveclause", "$@2",
  "recordorginstruction", "allkeyfield", "keyfield", "fieldtype",
  "fielddirection", "condition", "fieldvaluecond", "fieldvaluerec",
  "fieldvalueconst", "allsortfield", "sortfield", "sortclause", "$@3",
  "mergeclause", "$@4", "formatclause", "allcondfield", "condfield",
  "omitclause", "includeclause", "allinoutrec", "inoutrec", "outrecclause",
  "$@5", "$@6", "$@7", "$@8", "$@9", "$@10", "$@11", "$@12", "inrecclause",
  "$@13", "$@14", "$@15", "$@16", "$@17", "$@18", "allsumfield",
  "sumfield", "sumclause", "tokskipclause", "filesgroup", "fnamesclause",
  "outfilincludeclause", "outfilomitclause", "outfilclause",
  "startrecclause", "endrecclause", "saveclause", "alloption", "option",
  "optionclause", "$@19", YY_NULL
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
      44,    40,    41,    61,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    55,    56,    56,    57,    57,    57,    57,    57,    57,
      57,    57,    57,    57,    57,    57,    57,    57,    57,    57,
      57,    57,    57,    59,    58,    61,    60,    62,    62,    62,
      62,    62,    62,    62,    63,    63,    64,    65,    66,    67,
      68,    69,    70,    70,    71,    71,    72,    72,    74,    73,
      73,    76,    75,    75,    77,    78,    78,    78,    78,    79,
      79,    79,    79,    79,    79,    80,    80,    81,    81,    82,
      82,    83,    83,    83,    83,    83,    83,    83,    83,    83,
      85,    84,    86,    84,    87,    84,    88,    84,    89,    84,
      90,    84,    91,    84,    92,    84,    94,    93,    95,    93,
      96,    93,    97,    93,    98,    93,    99,    93,   100,   100,
     101,   101,   101,   102,   102,   103,   104,   104,   105,   105,
     105,   105,   106,   107,   108,   109,   109,   110,   110,   111,
     112,   112,   113,   113,   113,   113,   113,   113,   113,   115,
     114
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     0,     4,     0,     4,     0,     3,     7,
       9,     5,     7,     5,     1,     3,     5,     1,     1,     1,
       2,     2,     1,     1,     1,     3,     5,     7,     0,     6,
       3,     0,     6,     3,     3,     1,     3,     3,     3,    13,
       9,     9,     9,     7,     7,     3,     4,     3,     4,     1,
       3,     3,     4,     5,     1,     2,     3,     1,     1,     2,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     7,
       0,     6,     0,     6,     0,     5,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     1,     3,
       3,     7,     5,     3,     5,     1,     1,     3,     5,     3,
       1,     2,     3,     3,     1,     3,     3,     3,     3,     1,
       1,     2,     1,     3,     3,     3,     3,     1,     1,     0,
       3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   139,   124,     0,
     129,     0,     0,   120,     0,     0,     0,     0,     0,   115,
       0,     2,     6,     7,     4,     5,     8,    12,    11,    15,
      13,    14,    16,    20,    18,    19,    17,     9,    10,    21,
      22,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    94,     0,     0,     0,   121,
      25,     0,     0,    23,     1,     3,   128,   127,   116,     0,
     119,    37,    54,     0,     0,     0,    67,    55,   122,   102,
       0,    98,     0,   106,     0,     0,    65,   123,     0,     0,
     137,   138,   132,   140,   130,    86,     0,    82,     0,    90,
       0,     0,    92,   126,   125,   113,     0,    27,    53,    51,
      50,    48,    27,     0,     0,     0,     0,    68,     0,     0,
       0,   100,     0,    96,     0,   104,    66,     0,     0,   131,
       0,    84,     0,    80,     0,    88,     0,    77,    74,    78,
       0,    69,     0,     0,     0,   108,     0,     0,     0,    26,
       0,     0,    24,   118,   117,     0,    56,    57,    58,     0,
       0,     0,     0,     0,     0,   134,   133,   136,   135,     0,
       0,     0,     0,     0,     0,    79,     0,    41,    75,     0,
      95,     0,     0,   114,     0,    27,     0,     0,     0,     0,
       0,     0,    44,     0,     0,   103,     0,    99,     0,   107,
       0,    87,     0,    83,     0,    91,     0,    71,     0,    76,
      70,    93,   110,   109,    28,     0,     0,     0,     0,     0,
       0,    34,     0,    52,     0,    49,    39,     0,     0,   101,
      97,   105,    85,    81,    89,     0,    72,     0,    27,     0,
       0,     0,     0,    27,     0,     0,    45,     0,     0,    73,
       0,   112,    31,     0,     0,     0,     0,    33,    35,     0,
       0,    42,     0,    43,    64,    63,     0,    27,    27,     0,
       0,    38,     0,    46,     0,     0,    40,   111,    29,    32,
       0,    36,     0,    42,    61,    62,    60,    27,    47,     0,
      30,     0,     0,    59
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    20,    21,    22,   112,    23,   107,   149,   220,   221,
      72,   273,   228,   264,   139,   265,   191,   192,    24,   151,
      25,   150,    26,    76,    77,    27,    28,   140,   141,    29,
     172,   132,   170,   130,   174,   134,   142,   101,    30,   162,
     122,   160,   120,   164,   124,   144,   145,    31,    32,    70,
      33,    34,    35,    36,    37,    38,    39,    93,    94,    40,
      51
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -194
static const yytype_int16 yypact[] =
{
      73,   -29,    -5,    21,    -1,   112,     1,  -194,  -194,     9,
    -194,    54,    42,  -194,    93,    87,   109,   118,   106,  -194,
     154,    73,  -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,
    -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,
    -194,   -19,    20,   134,   -25,    -8,    -4,    39,    47,   -13,
      -8,    22,    62,    69,    89,  -194,   126,    15,     7,  -194,
    -194,   -22,   -14,  -194,  -194,  -194,  -194,  -194,  -194,   138,
     136,  -194,  -194,   139,    -8,    -8,     6,  -194,     6,  -194,
     133,  -194,   140,  -194,   141,    -8,     6,     6,   135,   142,
    -194,  -194,  -194,  -194,    22,  -194,   143,  -194,   145,  -194,
     146,    77,  -194,  -194,  -194,  -194,   152,    78,  -194,  -194,
    -194,  -194,    78,    91,   138,   155,     5,     6,    -8,    -8,
      77,  -194,    77,  -194,    77,  -194,     6,    34,    37,  -194,
      77,  -194,    77,  -194,    77,  -194,    82,   151,   153,  -194,
      95,  -194,    77,   149,   150,   156,   163,    79,   157,  -194,
     158,   158,  -194,  -194,   136,   159,  -194,  -194,   200,    96,
      77,    99,    77,   100,    77,  -194,  -194,  -194,  -194,   107,
      77,   108,    77,   111,    77,   169,   127,  -194,  -194,    77,
    -194,   115,   170,  -194,   152,    78,   160,   161,   137,   172,
     162,   164,   165,   166,    84,  -194,   116,  -194,   119,  -194,
     120,  -194,   124,  -194,   128,  -194,   129,  -194,   167,   173,
     171,  -194,   174,  -194,  -194,   178,   179,   175,   176,   177,
     180,   181,   184,  -194,   158,  -194,  -194,   183,   185,  -194,
    -194,  -194,  -194,  -194,  -194,   187,  -194,    94,    78,   186,
     188,   193,   194,    78,   172,   189,  -194,   191,    61,  -194,
     190,  -194,  -194,   195,   192,   196,   197,  -194,  -194,    72,
     198,   199,   203,  -194,  -194,  -194,   202,    78,    78,   206,
     201,  -194,   204,  -194,    68,   208,  -194,  -194,  -194,  -194,
     205,  -194,   207,   209,  -194,  -194,  -194,    78,  -194,   210,
    -194,   211,   134,  -194
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -194,   217,  -194,  -194,  -194,  -194,  -194,  -112,     8,  -194,
    -193,   -27,    11,   -21,  -194,   -18,  -147,  -194,  -194,  -194,
    -194,  -194,  -194,   -43,  -194,  -194,  -194,  -109,  -194,  -194,
    -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,  -194,
    -194,  -194,  -194,  -194,  -194,    76,  -194,  -194,  -194,   -55,
    -194,  -194,  -194,  -194,  -194,  -194,  -194,   168,  -194,  -194,
    -194
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
     152,   227,    78,    44,   193,    49,    86,    87,   118,   118,
      73,   159,   108,   161,   113,   163,    66,   105,   119,   119,
     110,   169,    73,   171,    41,   173,    74,    73,    75,   109,
      67,   116,   117,   181,    52,    53,    54,   111,    74,    88,
      85,    89,   126,    74,   251,    90,    91,    79,    42,    80,
     103,   196,    45,   198,    50,   200,    92,   156,   106,   154,
      55,   202,    56,   204,   104,   206,   272,    68,    58,   165,
     210,    69,   167,   214,    43,   157,   158,   246,     1,     2,
       3,     4,     5,   166,     6,     7,   168,     8,     9,    10,
      81,    11,    82,    12,    13,    14,   261,   262,    83,   293,
      84,    15,    16,   283,   262,    17,    18,    57,   146,   147,
     263,    71,   136,    95,   137,    96,   271,   263,   148,   138,
      97,    19,    98,    71,   186,   187,   252,   226,    59,   250,
     188,   257,   175,    71,    60,    61,   176,    46,    47,    48,
      99,   114,   100,   153,    62,   179,   179,   180,   195,   179,
     179,   197,   199,    63,    64,   278,   279,   179,   179,   201,
     203,   179,   208,   205,   209,   179,   179,   211,   229,   179,
     179,   230,   231,    71,   179,   290,   232,   102,   179,   179,
     233,   234,   217,   218,   121,    68,   114,   143,   127,   115,
     155,   123,   125,   190,   131,   128,   133,   135,   177,   182,
     178,   185,   183,   118,   207,   212,   184,   219,   189,   194,
     215,   216,   222,   238,   239,   224,   223,   235,   225,   245,
     236,   179,   249,   254,   237,   240,   241,   242,   255,   256,
     267,   244,   243,   247,   226,   248,   253,   277,    65,   259,
     266,   280,   281,   286,   268,   291,   269,   270,   274,   275,
     276,   271,   258,   284,   282,   288,   285,   287,   260,   289,
     213,   292,   129
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-194)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_uint16 yycheck[] =
{
     112,   194,    45,     4,   151,     4,    49,    50,     3,     3,
      35,   120,    34,   122,    69,   124,    35,    10,    13,    13,
      34,   130,    35,   132,    53,   134,    51,    35,    53,    51,
      49,    74,    75,   142,    25,    26,    27,    51,    51,    17,
      53,    19,    85,    51,   237,    23,    24,    51,    53,    53,
      35,   160,    53,   162,    53,   164,    34,    52,    51,   114,
      51,   170,    53,   172,    49,   174,   259,    47,    26,    35,
     179,    51,    35,   185,    53,   118,   119,   224,     5,     6,
       7,     8,     9,    49,    11,    12,    49,    14,    15,    16,
      51,    18,    53,    20,    21,    22,    35,    36,    51,   292,
      53,    28,    29,    35,    36,    32,    33,    53,    30,    31,
      49,    39,    35,    51,    37,    53,    44,    49,    40,    42,
      51,    48,    53,    39,    45,    46,   238,    43,    35,    35,
      51,   243,    50,    39,    47,    26,    54,    25,    26,    27,
      51,    50,    53,    52,    26,    50,    50,    52,    52,    50,
      50,    52,    52,    47,     0,   267,   268,    50,    50,    52,
      52,    50,    35,    52,    37,    50,    50,    52,    52,    50,
      50,    52,    52,    39,    50,   287,    52,    51,    50,    50,
      52,    52,    45,    46,    51,    47,    50,    35,    53,    50,
      35,    51,    51,    35,    51,    53,    51,    51,    47,    50,
      47,    38,    52,     3,    35,    35,    50,    35,    51,    50,
      50,    50,    50,    35,    35,    50,    52,    50,    52,    35,
      47,    50,    35,    35,    50,    50,    50,    50,    35,    35,
      35,    50,    52,    50,    43,    50,    50,    35,    21,    50,
      50,    35,    41,    35,    52,    35,    50,    50,    50,    50,
      47,    44,   244,   274,    50,   282,   274,    52,   247,    50,
     184,    50,    94
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    20,    21,    22,    28,    29,    32,    33,    48,
      56,    57,    58,    60,    73,    75,    77,    80,    81,    84,
      93,   102,   103,   105,   106,   107,   108,   109,   110,   111,
     114,    53,    53,    53,     4,    53,    25,    26,    27,     4,
      53,   115,    25,    26,    27,    51,    53,    53,    26,    35,
      47,    26,    26,    47,     0,    56,    35,    49,    47,    51,
     104,    39,    65,    35,    51,    53,    78,    79,    78,    51,
      53,    51,    53,    51,    53,    53,    78,    78,    17,    19,
      23,    24,    34,   112,   113,    51,    53,    51,    53,    51,
      53,    92,    51,    35,    49,    10,    51,    61,    34,    51,
      34,    51,    59,   104,    50,    50,    78,    78,     3,    13,
      97,    51,    95,    51,    99,    51,    78,    53,    53,   112,
      88,    51,    86,    51,    90,    51,    35,    37,    42,    69,
      82,    83,    91,    35,   100,   101,    30,    31,    40,    62,
      76,    74,    62,    52,   104,    35,    52,    78,    78,    82,
      96,    82,    94,    82,    98,    35,    49,    35,    49,    82,
      87,    82,    85,    82,    89,    50,    54,    47,    47,    50,
      52,    82,    50,    52,    50,    38,    45,    46,    51,    51,
      35,    71,    72,    71,    50,    52,    82,    52,    82,    52,
      82,    52,    82,    52,    82,    52,    82,    35,    35,    37,
      82,    52,    35,   100,    62,    50,    50,    45,    46,    35,
      63,    64,    50,    52,    50,    52,    43,    65,    67,    52,
      52,    52,    52,    52,    52,    50,    47,    50,    35,    35,
      50,    50,    50,    52,    50,    35,    71,    50,    50,    35,
      35,    65,    62,    50,    35,    35,    35,    62,    63,    50,
      67,    35,    36,    49,    68,    70,    50,    35,    52,    50,
      50,    44,    65,    66,    50,    50,    47,    35,    62,    62,
      35,    41,    50,    35,    68,    70,    35,    52,    66,    50,
      62,    35,    50,    65
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
#line 159 "parser.y"
    {}
    break;

  case 5:
/* Line 1792 of yacc.c  */
#line 160 "parser.y"
    {}
    break;

  case 6:
/* Line 1792 of yacc.c  */
#line 161 "parser.y"
    {}
    break;

  case 7:
/* Line 1792 of yacc.c  */
#line 162 "parser.y"
    {}
    break;

  case 8:
/* Line 1792 of yacc.c  */
#line 163 "parser.y"
    {}
    break;

  case 9:
/* Line 1792 of yacc.c  */
#line 164 "parser.y"
    {}
    break;

  case 10:
/* Line 1792 of yacc.c  */
#line 165 "parser.y"
    {}
    break;

  case 11:
/* Line 1792 of yacc.c  */
#line 166 "parser.y"
    {}
    break;

  case 12:
/* Line 1792 of yacc.c  */
#line 167 "parser.y"
    {}
    break;

  case 13:
/* Line 1792 of yacc.c  */
#line 168 "parser.y"
    {}
    break;

  case 14:
/* Line 1792 of yacc.c  */
#line 169 "parser.y"
    {}
    break;

  case 15:
/* Line 1792 of yacc.c  */
#line 170 "parser.y"
    {}
    break;

  case 16:
/* Line 1792 of yacc.c  */
#line 171 "parser.y"
    {}
    break;

  case 17:
/* Line 1792 of yacc.c  */
#line 172 "parser.y"
    {}
    break;

  case 18:
/* Line 1792 of yacc.c  */
#line 173 "parser.y"
    {}
    break;

  case 19:
/* Line 1792 of yacc.c  */
#line 174 "parser.y"
    {}
    break;

  case 20:
/* Line 1792 of yacc.c  */
#line 175 "parser.y"
    {}
    break;

  case 21:
/* Line 1792 of yacc.c  */
#line 177 "parser.y"
    {}
    break;

  case 22:
/* Line 1792 of yacc.c  */
#line 178 "parser.y"
    {}
    break;

  case 23:
/* Line 1792 of yacc.c  */
#line 182 "parser.y"
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

  case 24:
/* Line 1792 of yacc.c  */
#line 193 "parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); // Input
        current_file=NULL;
}
    break;

  case 25:
/* Line 1792 of yacc.c  */
#line 199 "parser.y"
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

  case 26:
/* Line 1792 of yacc.c  */
#line 210 "parser.y"
    {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); //Output
        current_file=NULL;
}
    break;

  case 27:
/* Line 1792 of yacc.c  */
#line 216 "parser.y"
    { 	
        strcat(szMexToken, " record org instruction "); 
}
    break;

  case 28:
/* Line 1792 of yacc.c  */
#line 219 "parser.y"
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

  case 29:
/* Line 1792 of yacc.c  */
#line 230 "parser.y"
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

  case 30:
/* Line 1792 of yacc.c  */
#line 239 "parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (9)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (9)].number));
            file_setMaxLength(current_file,(yyvsp[(7) - (9)].number));
        }
        free((yyvsp[(3) - (9)].string));
}
    break;

  case 31:
/* Line 1792 of yacc.c  */
#line 248 "parser.y"
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

  case 32:
/* Line 1792 of yacc.c  */
#line 257 "parser.y"
    {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[(3) - (7)].string)));
            file_setRecordLength(current_file,(yyvsp[(5) - (7)].number));
            file_setMaxLength(current_file,(yyvsp[(5) - (7)].number));
        }
        free((yyvsp[(3) - (7)].string));
}
    break;

  case 33:
/* Line 1792 of yacc.c  */
#line 266 "parser.y"
    {
}
    break;

  case 34:
/* Line 1792 of yacc.c  */
#line 271 "parser.y"
    { 
        strcat(szMexToken, " key instruction ");
}
    break;

  case 35:
/* Line 1792 of yacc.c  */
#line 274 "parser.y"
    {}
    break;

  case 36:
/* Line 1792 of yacc.c  */
#line 278 "parser.y"
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

  case 37:
/* Line 1792 of yacc.c  */
#line 293 "parser.y"
    {
		(yyval.number)=utils_parseFieldType((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 38:
/* Line 1792 of yacc.c  */
#line 299 "parser.y"
    {
		(yyval.number)=utils_parseSortDirection((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string)); 
}
    break;

  case 39:
/* Line 1792 of yacc.c  */
#line 306 "parser.y"
    {
		(yyval.number)=utils_parseCondCondition((yyvsp[(1) - (1)].string));
		free((yyvsp[(1) - (1)].string));
}
    break;

  case 40:
/* Line 1792 of yacc.c  */
#line 318 "parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 41:
/* Line 1792 of yacc.c  */
#line 333 "parser.y"
    { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].string), TYPE_STRUCT_STD);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[(1) - (2)].string)); 
		free((yyvsp[(2) - (2)].string)); 
}
    break;

  case 42:
/* Line 1792 of yacc.c  */
#line 348 "parser.y"
    {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[(1) - (1)].number));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    break;

  case 43:
/* Line 1792 of yacc.c  */
#line 361 "parser.y"
    {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, CB_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
		#else
			sprintf(pszInt, CB_FMT_LLD , (yyvsp[(1) - (1)].llnumber));
		#endif
		//-->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 107, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
    break;

  case 44:
/* Line 1792 of yacc.c  */
#line 380 "parser.y"
    {
}
    break;

  case 45:
/* Line 1792 of yacc.c  */
#line 382 "parser.y"
    {
        
}
    break;

  case 46:
/* Line 1792 of yacc.c  */
#line 388 "parser.y"
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

  case 47:
/* Line 1792 of yacc.c  */
#line 400 "parser.y"
    {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),(yyvsp[(5) - (7)].number),(yyvsp[(7) - (7)].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 109, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            //-->> nTypeFormat = 1; // Format external token
			}
}
    break;

  case 48:
/* Line 1792 of yacc.c  */
#line 415 "parser.y"
    {
        current_sortField=1;
        }
    break;

  case 49:
/* Line 1792 of yacc.c  */
#line 417 "parser.y"
    {
        current_sortField=0;
        job_SetTypeOP('S');		// for Sort
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 50:
/* Line 1792 of yacc.c  */
#line 422 "parser.y"
    {
        job_SetTypeOP('M');		// for Merge
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");
}
    break;

  case 51:
/* Line 1792 of yacc.c  */
#line 429 "parser.y"
    {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
    break;

  case 52:
/* Line 1792 of yacc.c  */
#line 432 "parser.y"
    {
        current_sortField=0;
        // typeOP = 'M'; // for Merge
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 53:
/* Line 1792 of yacc.c  */
#line 438 "parser.y"
    {
        job_SetTypeOP('M');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
    break;

  case 54:
/* Line 1792 of yacc.c  */
#line 450 "parser.y"
    {
		strcpy(szMexToken, " format clause ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[(3) - (3)].number));
		if (nTypeFormat == 3)	// for SumFields
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[(3) - (3)].number));
}
    break;

  case 55:
/* Line 1792 of yacc.c  */
#line 472 "parser.y"
    {
		(yyval.condField)=(yyvsp[(1) - (1)].condField);
}
    break;

  case 56:
/* Line 1792 of yacc.c  */
#line 475 "parser.y"
    {
		(yyval.condField)=(yyvsp[(2) - (3)].condField);
		strcat(szMexToken, " condition field ");
}
    break;

  case 57:
/* Line 1792 of yacc.c  */
#line 479 "parser.y"
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

  case 58:
/* Line 1792 of yacc.c  */
#line 488 "parser.y"
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

  case 59:
/* Line 1792 of yacc.c  */
#line 506 "parser.y"
    {
        nTypeFormat = 2; // Format external token
        condField=condField_constructor_conditionfield((yyvsp[(1) - (13)].number),(yyvsp[(3) - (13)].number),(yyvsp[(5) - (13)].number),(yyvsp[(7) - (13)].number),(yyvsp[(9) - (13)].number),(yyvsp[(11) - (13)].number),(yyvsp[(13) - (13)].number));
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 60:
/* Line 1792 of yacc.c  */
#line 522 "parser.y"
    {
        nTypeFormat = 2; // Format external token
        condField=condField_constructor_conditionfield((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),0,(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].number),0);
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
#line 536 "parser.y"
    {    
		(yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
		strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
    break;

  case 62:
/* Line 1792 of yacc.c  */
#line 548 "parser.y"
    {
        (yyval.condField)=condField_constructor_condition((yyvsp[(1) - (9)].number),(yyvsp[(3) - (9)].number),(yyvsp[(5) - (9)].number),(yyvsp[(7) - (9)].number),(yyvsp[(9) - (9)].fieldValue));
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 63:
/* Line 1792 of yacc.c  */
#line 560 "parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; // Format external token
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 64:
/* Line 1792 of yacc.c  */
#line 574 "parser.y"
    {    
        condField=condField_constructor_condition((yyvsp[(1) - (7)].number),(yyvsp[(3) - (7)].number),0,(yyvsp[(5) - (7)].number),(struct fieldValue_t *)(yyvsp[(7) - (7)].fieldValue));
        nTypeFormat = 2; // Format external token
        (yyval.condField)=condField;
        strcat(szMexToken, " condition field ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
    break;

  case 65:
/* Line 1792 of yacc.c  */
#line 586 "parser.y"
    {
        condField_addOmit((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 66:
/* Line 1792 of yacc.c  */
#line 592 "parser.y"
    {
        condField_addOmit((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
    break;

  case 67:
/* Line 1792 of yacc.c  */
#line 601 "parser.y"
    {
        condField_addInclude((yyvsp[(3) - (3)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 68:
/* Line 1792 of yacc.c  */
#line 607 "parser.y"
    {
        condField_addInclude((yyvsp[(4) - (4)].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
    break;

  case 69:
/* Line 1792 of yacc.c  */
#line 618 "parser.y"
    {	
}
    break;

  case 70:
/* Line 1792 of yacc.c  */
#line 620 "parser.y"
    {	}
    break;

  case 71:
/* Line 1792 of yacc.c  */
#line 627 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
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
            }
            else
            {
                struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
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
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                    // struct inrec_t *
                    inrec=inrec_constructor_range((yyvsp[(1) - (3)].number),(yyvsp[(3) - (3)].number));
                    if (inrec == NULL) {
                        utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                        YYABORT;
                    }
                    nPosAbsRec += inrec->range.length;
                    inrec->nIsOverlay=inrec_overlay;
                    inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
}
    break;

  case 72:
/* Line 1792 of yacc.c  */
#line 682 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_possubstnchar((yyvsp[(1) - (4)].number), (yyvsp[(3) - (4)].string), (yyvsp[(4) - (4)].string));
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
                // struct inrec_t *
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
		free((yyvsp[(4) - (4)].string)); 
}
    break;

  case 73:
/* Line 1792 of yacc.c  */
#line 725 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range_position((yyvsp[(1) - (5)].number), (yyvsp[(3) - (5)].number), (yyvsp[(5) - (5)].number));
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
                // struct inrec_t *
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

  case 74:
/* Line 1792 of yacc.c  */
#line 766 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_subst((yyvsp[(1) - (1)].string));
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
                // struct inrec_t *
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

  case 75:
/* Line 1792 of yacc.c  */
#line 809 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_substnchar((yyvsp[(1) - (2)].string),(yyvsp[(2) - (2)].string));
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
                // struct inrec_t *
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

  case 76:
/* Line 1792 of yacc.c  */
#line 852 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
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
                // struct inrec_t *
                inrec=inrec_constructor_padding((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].string), nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[(1) - (3)].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[(1) - (3)].number);		// - inrec->change_position.fieldValue->generated_length;
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

  case 77:
/* Line 1792 of yacc.c  */
#line 896 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
       //         struct outrec_t *outrec=outrec_constructor_subst($1);
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[(1) - (1)].string));
                struct outrec_t *outrec=outrec_constructor_subst(szType01);
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
                // struct inrec_t *
        //                inrec=inrec_constructor_subst($1);
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
}
    break;

  case 78:
/* Line 1792 of yacc.c  */
#line 948 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec;
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
                // struct inrec_t *
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

  case 79:
/* Line 1792 of yacc.c  */
#line 988 "parser.y"
    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
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
                struct outrec_t *outrec=outrec_constructor_range((yyvsp[(1) - (2)].number),-1);
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
                // struct inrec_t *
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

  case 80:
/* Line 1792 of yacc.c  */
#line 1041 "parser.y"
    {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 81:
/* Line 1792 of yacc.c  */
#line 1046 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 82:
/* Line 1792 of yacc.c  */
#line 1052 "parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 83:
/* Line 1792 of yacc.c  */
#line 1057 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 84:
/* Line 1792 of yacc.c  */
#line 1062 "parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 85:
/* Line 1792 of yacc.c  */
#line 1067 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
    break;

  case 86:
/* Line 1792 of yacc.c  */
#line 1073 "parser.y"
    {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 87:
/* Line 1792 of yacc.c  */
#line 1078 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 88:
/* Line 1792 of yacc.c  */
#line 1083 "parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
}
    break;

  case 89:
/* Line 1792 of yacc.c  */
#line 1088 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 90:
/* Line 1792 of yacc.c  */
#line 1095 "parser.y"
    {
        strcpy(szMexToken, " outrec clause Overlay");
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
        }
    break;

  case 91:
/* Line 1792 of yacc.c  */
#line 1100 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
    break;

  case 92:
/* Line 1792 of yacc.c  */
#line 1111 "parser.y"
    {
        current_outrec=1;
        nRecCase=2;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
    break;

  case 93:
/* Line 1792 of yacc.c  */
#line 1116 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 94:
/* Line 1792 of yacc.c  */
#line 1121 "parser.y"
    {
        current_outrec=1;
        nRecCase=2;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
    break;

  case 95:
/* Line 1792 of yacc.c  */
#line 1126 "parser.y"
    {
        current_outrec=0;
        nRecCase=0;
}
    break;

  case 96:
/* Line 1792 of yacc.c  */
#line 1135 "parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 97:
/* Line 1792 of yacc.c  */
#line 1140 "parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 98:
/* Line 1792 of yacc.c  */
#line 1145 "parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
        }
    break;

  case 99:
/* Line 1792 of yacc.c  */
#line 1150 "parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 100:
/* Line 1792 of yacc.c  */
#line 1155 "parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 101:
/* Line 1792 of yacc.c  */
#line 1160 "parser.y"
    {
        current_inrec=0;
        nRecCase=0;
}
    break;

  case 102:
/* Line 1792 of yacc.c  */
#line 1165 "parser.y"
    {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 103:
/* Line 1792 of yacc.c  */
#line 1170 "parser.y"
    {
			current_inrec=0;
			nRecCase=0;
}
    break;

  case 104:
/* Line 1792 of yacc.c  */
#line 1175 "parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
}
    break;

  case 105:
/* Line 1792 of yacc.c  */
#line 1180 "parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 106:
/* Line 1792 of yacc.c  */
#line 1187 "parser.y"
    {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=1;
		nPosAbsRec = 0;
        }
    break;

  case 107:
/* Line 1792 of yacc.c  */
#line 1192 "parser.y"
    {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
    break;

  case 108:
/* Line 1792 of yacc.c  */
#line 1203 "parser.y"
    {}
    break;

  case 109:
/* Line 1792 of yacc.c  */
#line 1204 "parser.y"
    {}
    break;

  case 110:
/* Line 1792 of yacc.c  */
#line 1207 "parser.y"
    {
        struct SumField_t *SumField=SumField_constructor((yyvsp[(1) - (3)].number), (yyvsp[(3) - (3)].number), 0);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			// for SumFields Format=
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 111:
/* Line 1792 of yacc.c  */
#line 1217 "parser.y"
    {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[(1) - (7)].number), (yyvsp[(3) - (7)].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[(5) - (7)].number), (yyvsp[(7) - (7)].number), 0);
			if (SumField1 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 136, ABEND_SKIP);
				YYABORT;
			}
			if (SumField2 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 103, ABEND_SKIP);
				YYABORT;
			}
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			// for SumFields Format=
 			SumField_addDefinition(SumField2); 
		strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 112:
/* Line 1792 of yacc.c  */
#line 1234 "parser.y"
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

  case 113:
/* Line 1792 of yacc.c  */
#line 1246 "parser.y"
    {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
    break;

  case 114:
/* Line 1792 of yacc.c  */
#line 1250 "parser.y"
    {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
    break;

  case 115:
/* Line 1792 of yacc.c  */
#line 1257 "parser.y"
    {
		//printf("GCSORT: Warning Token skipped : %s\n",yylval.string);
}
    break;

  case 116:
/* Line 1792 of yacc.c  */
#line 1263 "parser.y"
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

  case 117:
/* Line 1792 of yacc.c  */
#line 1282 "parser.y"
    {
		strcat(szMexToken, " group files outfil ");
}
    break;

  case 118:
/* Line 1792 of yacc.c  */
#line 1288 "parser.y"
    {
}
    break;

  case 119:
/* Line 1792 of yacc.c  */
#line 1290 "parser.y"
    {
}
    break;

  case 120:
/* Line 1792 of yacc.c  */
#line 1292 "parser.y"
    {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
    break;

  case 121:
/* Line 1792 of yacc.c  */
#line 1296 "parser.y"
    {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[(2) - (2)].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
    break;

  case 122:
/* Line 1792 of yacc.c  */
#line 1302 "parser.y"
    {

		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
    break;

  case 123:
/* Line 1792 of yacc.c  */
#line 1311 "parser.y"
    {
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, (yyvsp[(3) - (3)].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
}
    break;

  case 124:
/* Line 1792 of yacc.c  */
#line 1319 "parser.y"
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

  case 125:
/* Line 1792 of yacc.c  */
#line 1335 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 126:
/* Line 1792 of yacc.c  */
#line 1340 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " start rec clause ");
}
    break;

  case 127:
/* Line 1792 of yacc.c  */
#line 1348 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 128:
/* Line 1792 of yacc.c  */
#line 1353 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " end rec clause ");
}
    break;

  case 129:
/* Line 1792 of yacc.c  */
#line 1360 "parser.y"
    {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
    break;

  case 130:
/* Line 1792 of yacc.c  */
#line 1369 "parser.y"
    {}
    break;

  case 131:
/* Line 1792 of yacc.c  */
#line 1371 "parser.y"
    {}
    break;

  case 132:
/* Line 1792 of yacc.c  */
#line 1374 "parser.y"
    {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
    break;

  case 133:
/* Line 1792 of yacc.c  */
#line 1378 "parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 134:
/* Line 1792 of yacc.c  */
#line 1382 "parser.y"
    {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option skip rec clause ");
}
    break;

  case 135:
/* Line 1792 of yacc.c  */
#line 1386 "parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 136:
/* Line 1792 of yacc.c  */
#line 1390 "parser.y"
    {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[(3) - (3)].number));
		strcpy(szMexToken, " option stop after clause ");
}
    break;

  case 137:
/* Line 1792 of yacc.c  */
#line 1394 "parser.y"
    {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 138:
/* Line 1792 of yacc.c  */
#line 1398 "parser.y"
    {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
    break;

  case 139:
/* Line 1792 of yacc.c  */
#line 1404 "parser.y"
    {
}
    break;

  case 140:
/* Line 1792 of yacc.c  */
#line 1405 "parser.y"
    {
}
    break;


/* Line 1792 of yacc.c  */
#line 3454 "parser.c"
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
#line 1410 "parser.y"

