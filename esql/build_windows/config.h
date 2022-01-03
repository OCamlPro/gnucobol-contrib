/* config.h.  For Windows  */

/* Use external log functions */
/* #undef EXTERNAL_LOG */

/* Define to 1 if you have the `strupr' function. */
#if defined (_MSC_VER) && _MSC_VER >= 1500
#define HAVE_STRUPR 1
#endif

/* Define to 1 if you have the <unistd.h> header file. */
/* #undef HAVE_UNISTD_H */

/* Debugging log level */
/* #undef LOGLEVEL */

/* Database is DB2 */
/* #undef ESQL_DB2 */

/* Database is Microsoft SQL Server */
#define MSSQL

/* Disable debug log */
/* #undef NO_LOG */

/* Name of package */
#define PACKAGE "gnucobol-sql"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "gnucobol-users@gnu.org"

/* Define to the full name of this package. */
#define PACKAGE_NAME "ESQL for GnuCOBOL"

/* Define to the version of this package. */
#define PACKAGE_VERSION "3.0"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING PACKAGE_NAME " " PACKAGE_VERSION

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "gnucobol-sql"

/* Define to the home page for this package. */
#define PACKAGE_URL "http://www.kiska.net/opencobol/esql"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Use multiple schemas/databases (default) */
/* #undef USE_NOT_USED */

#define LITTLE_ENDIAN

