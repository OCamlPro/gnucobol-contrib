*> **  >>SOURCE FORMAT IS FREE

identification division.

  program-id.                          cobolmac.

*><* ====================================
*><* CobolMac User Guide for Version B.04
*>
*>   Only modify the above line when there is a MAJOR or VERSION change.
*>
*><* ====================================
*><*
*><* .. sidebar:: Table of Contents
*><*
*><*     .. contents:: :local:
*><*
*><* ::
*><*
*><*    ____      _           _ __  __
*><*   / ___|___ | |__   ___ | |  \/  | __ _  ___
*><*  | |   / _ \| '_ \ / _ \| | |\/  |/ _` |/ __|
*><*  | |__| (_) | |_) | (_) | | |  | | (_| | (__
*><*   \____\___/|_.__/ \___/|_|_|  |_|\__,_|\___|
*><*
*><* :Author:   Robert W.Mills
*><* :Date:     December 2015
*><* :Rights:   Copyright © 2014-2015, Robert W.Mills.
*><* :Email:    RobertW-Mills@users.sf.net
*><* :Purpose:  A COBOL Macro Preprocessor.
*><*
*><* -------
*><* License
*><* -------
*><*
*><*   This program is free software: you can redistribute it and/or modify it
*><+    under the terms of the GNU General Public License as published by the Free
*><+    Software Foundation, either version 3 of the License, or (at your option)
*><+    any later version.
*><*
*><*   This program is distributed in the hope that it will be useful, but WITHOUT
*><+    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*><+    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
*><+    more details.
*><*
*><*   You should have received a copy of the GNU General Public License along with
*><+    this program. If not, see <http://www.gnu.org/licenses/#GPL>.
*><*
*><* -----------
*><* Description
*><* -----------
*><*
*><*   *CobolMac* is a COBOL source preprocessor that emulates the macro capability
*><+    that is available with the Hewlett-Packard HPe3000 COBOL II/ix compiler.
*><*
*><*   It associates a macro name with a string of text. Macros can have up to
*><+    nine formal parameters. In the definition actual parameters are supplied
*><+    to replace the formal parameters when the macro is called in the source
*><+    program.
*><*
*><*   The processed source code can then be passed to a COBOL compiler to create
*><+    an executable or library module.
*><*
*><* -----------------
*><* CobolMac Commands
*><* -----------------
*><*
*><*   The following commands are supported by the *CobolMac* Preprocessor.
*><*
*><* $DEFINE
*><* ~~~~~~~
*><*
*><*   The *$DEFINE* command is used to associate a string of text with a macro
*><+    name. When the preprocessor encounters a defined macro name in the source
*><+    program, it invokes the macro and passes the associated string of text.
*><*
*><* SYNTAX
*><* ######
*><*
*><*     The *$DEFINE* command has the following format:
*><*
*><*       $DEFINE %macro-name=[string-text]#
*><*
*><* PARAMETERS
*><* ##########
*><*
*><*     *macro-name* is the name of the macro being defined. It is limited to a
*><+  length of 30 characters and is, by default, prefixed by a '%' (percent).
*><*
*><*     *string-text* is the string of text to replace occurrences of the macro
*><+  call within the body of the program code.
*><*
*><*     It can be any text you choose. However, because this text is sent to the
*><+  compiler, it must be a valid COBOL statement or sentence, with one exception.
*><+  This exception is the use of formal parameters in the *string-text*. Formal
*><+  parameters are described later in this section.
*><*
*><*     *string-text* may contain formal parameters (referred to as variables).
*><+  They are designated by an integer in the range 1 to 9 that are, by default,
*><+  prefixed by an '!' (exclamation).
*><*
*><* DESCRIPTION
*><* ###########
*><*
*><*     This command may appear anywhere in your source program.
*><*
*><*     The *$DEFINE* command is, by default, terminated by a '#' (hash).
*><*
*><*     Recursive macros are not supported.
*><*
*><*     The macro-name prefix, formal parameter prefix and *$DEFINE* terminator
*><+      can be changed by using the *$PREPROCESSOR* command (see below).
*><*
*><* $PREPROCESSOR
*><* ~~~~~~~~~~~~~
*><*
*><*   The *$PREPROCESSOR* command allows you to change the default character used
*><+    in the macro definitions and names.
*><*
*><* SYNTAX
*><* ######
*><*
*><*     The *$PREPROCESSOR* command has the following format:
*><*
*><*       $PREPROCESSOR parameter=new-char [, ...]
*><*
*><* PARAMETERS
*><* ##########
*><*
*><*     *parameter* is one of the following:
*><*
*><*       KEYCHAR is the macro-name prefix character. The default character is
*><+  the % (percent).
*><*
*><*       PARMCHAR is the formal parameter prefix character used within the macro
*><+  text-string. The default character is the ! (exclamation).
*><*
*><*       DELIMITER is the character that delimits the end of macro text strings
*><+  and the actual parameters used with macro calls. The default character is
*><+  the # (hash).
*><*
*><*       *new-char* specifies the new character to be used for the specified
*><+  parameter.
*><*
*><* DESCRIPTION
*><* ###########
*><*
*><*   You must ensure that any parameter you change does not contain a character
*><+  that will appear in the *$DEFINE* text-string. If it does then processing of
*><+  the *$DEFINE* will terminated early or give unexpected results.
*><*
*><*   The following example shows how the *$PREPROCESSOR* command is used when
*><+  you define a macro that invokes another macro (aka a Nested Macro). It is
*><+  the only time that you should need to use the *$PREPROCESSOR* command.
*><*
*><*   .. code:: cobolfree
*><*
*><*     *> Macro ReadError(paragraph#,file-name#,file-status#)
*><*
*><*     $define %ReadError=
*><*     display
*><*       "Error ", !3, " in paragraph ", !1, " reading file ", !2
*><*     end-display
*><*     goback#
*><*
*><*     *> Change the macro delimiter to something other than #. If this is not
*><*     *> done then the first # character in the call to the %ReadError macro
*><*     *> will be treated as the %ReadFile macro terminator.
*><*
*><*     *> Macro ReadFile(paragraph#,file-name#)
*><*     $preprocessor delimiter=~
*><*
*><*     $define %ReadFile=
*><*     read !2 end-read
*><*     evaluate file-status
*><*       when read-success
*><*         perform process-record
*><*       when end-of-file
*><*         perform process-eof
*><*       when other *> Report the error and exit the program.
*><*         %ReadError(!1#,!2#,file-status#)
*><*     end-evaluate~
*><*
*><*     *> Return the macro define terminator to its default value.
*><*     $preprocessor delimiter=#
*><*
*><*   **Note:** The above example assumes the following:
*><*
*><*   - file-status is a pic x(2) data item assigned to the FILE STATUS option
*><+  in the files SELECT statement.
*><*   - read-success is an 88 level under file-status with a value of "00".
*><*   - end-of-file is an 88 level under file-status with a value of "10".
*><*   - process-record and process-eof is an existing section/paragraph.
*><*
*><* $INCLUDE
*><* ~~~~~~~~
*><*
*><*   The *$INCLUDE* command allows you to specify a file to be copied into your
*><+    source program.
*><*
*><* SYNTAX
*><* ######
*><*
*><*     The *$INCLUDE* command has the following format:
*><*
*><*       $INCLUDE filename
*><*
*><* PARAMETERS
*><* ##########
*><*
*><*     *filename* is the name of the file, including path, to be copied into
*><+  your source program.
*><*
*><* DESCRIPTION
*><* ###########
*><*
*><*     This command may appear anywhere in your source program.
*><*
*><*     *$INCLUDE* commands may be nested to whatever depth you require. That
*><+  is, the file that is being copied may itself have $INCLUDE commands in it.
*><*
*><*     If you use this command to load macro $DEFINE commands then its suggested
*><+  you follow the recommendations given above for the $DEFINE command.
*><*
*><* $COPY
*><* ~~~~~
*><*
*><*   **Not yet implemented as it is a planned enhancement.**
*><*
*><*   The *$COPY* command allows you to specify a copybook module, held in a
*><+    library, to be copied into your source program.
*><*
*><* SYNTAX
*><* ######
*><*
*><*     The *$COPY* command has the following format:
*><*
*><*       $COPY copybook IN|OF library
*><*
*><* PARAMETERS
*><* ##########
*><*
*><*     *copybook* is the name of the module to be copied into your source program.
*><*
*><*     *library* is the name of the library file, including path, in which the
*><+  module resides. The *library* file must have been created by the *cpylibeditor*
*><+  program. **DO NOT** include the .cpylib file extension.
*><*
*><* DESCRIPTION
*><* ###########
*><*
*><*     This command may appear anywhere in your source program.
*><*
*><* --------------
*><* Calling Macros
*><* --------------
*><*
*><*   There are two different forms of a macro call:
*><*
*><*     *%macroname*
*><*
*><*   and
*><*
*><*     *%macroname(p1#, p2#, p3#, ..., p9#)*
*><*
*><* Parameters
*><* ~~~~~~~~~~
*><*
*><*  *%macroname* is the name of a macro which has been previously defined in the
*><+   source program, using a *$DEFINE* command.
*><*
*><*  *p1*, *p2*, ..., *p9* is the actual parameters. Each of parameters may be
*><+   either a null string or any combination of characters and numerals,
*><+   including spaces. Each actual parameter begins with the first character
*><+   after a preceding comma (except *p1*, which begins after the left
*><+   parenthesis), and ends with the # (hash) character.
*><*
*><*  If no characters are specified for an actual parameter (that is, if an
*><+   actual parameter is specified by "#"), then a null string replaces its
*><+   corresponding formal parameter in the macro definition.
*><*
*><*  **Note:** There can be no intervening spaces between the end of *macroname*
*><+   and the left parenthesis of the actual parameter list.
*><*
*><*  The first form of calling a macro is used when the macro definition has no
*><+   formal parameters.
*><*
*><*  The second form must be used when formal parameters are specified in the
*><+   definition of the macro.
*><*
*><*  When a macro name is encountered in a source program, it is replaced by the
*><+   associated macro definition. Any formal parameters are replaced by actual
*><+   parameters listed in the macro call.
*><*
*><*  With one exception, macro names are replaced wherever they occur in the
*><+   source program, including quoted strings. Macro names are not expanded in a
*><+    comment, unless the comment itself is found in a macro.
*><*
*><* -----------------------
*><* Standard Macros Library
*><* -----------------------
*><*
*><*   At some point you will find yourself using a standard set of macros. When
*><+    this happens you can add the *$DEFINE* commands into a file named
*><+    *cobolmac.standard.macros* and *CobolMac* will automatically add them to
*><+    the start of your source programs Working-Storage Section.
*><*
*><*   The reason for placing the contents of *cobolmac.standard.macros* within
*><+    the Working-Storage Section is so you can also include any variable
*><+    definitions that are specific to the macros.
*><*
*><*   The file *cobolmac.standard.macros* is assumed to reside in the current
*><+    working directory. The *--stdlib* (*-s*) option can be used to point
*><+    *CobolMac* to a library file with a different name and/or in a different
*><+    location.
*><*
*><* ------------
*><* Command line
*><* ------------
*><*
*><*   *CobolMac* runs in two forms.
*><*
*><*   1. Without arguments, *CobolMac* will act as a pipe filter. Reading from
*><+    Standard In (stdin), expanding the macro calls, and writing processed
*><+    code to Standard Out (stdout).
*><*
*><*   2. The *CobolMac* command also takes an input filename, output filename, and
*><+    several options (see Usage below).
*><*
*><*   In both forms, any error and warning messages will be written to Standard
*><+    Error (stderr). stderr can be redirected to a file by adding the following
*><+    to the command line
*><*
*><*     2>filename
*><*
*><*   where *filename* is the name of the file to hold the messages. *filename* can
*><+    optionally include a directory path.
*><*
*><*   Note: *CobolMac* assumes that it is preprocessing FREE FORMAT files. If used
*><+    to preprocess a FIXED FORMAT file then extra care must be taken when
*><+    defining the macros to ensure that all added code resides in the
*><+    correct areas - Area A (cols 7 to 11) and Area B (cols 12 to 72).
*><*
*><* Usage
*><* ~~~~~
*><*
*><*   $ program1 | cobolmac [options] [2>stderr] | program2
*><*
*><*   $ cobolmac [options] --stdin=input --stdout=output [2>stderr]
*><*
*><*   $ cobolmac [options] <input [2>stderr] | program2
*><*
*><*   +--------+------------------------------------------------------------------+
*><*   |        |Description                                                       |
*><*   +========+==================================================================+
*><*   |input   |[path/]name of file Standard Input redirected to.                 |
*><*   +--------+------------------------------------------------------------------+
*><*   |output  |[path/]name of file Standard Output redirected to.                |
*><*   +--------+------------------------------------------------------------------+
*><*   |stderr  |optional [path/]name of file Standard Error redirected to.        |
*><*   +--------+------------------------------------------------------------------+
*><*   |program1|[path/]name of program that writes to Standard Output.            |
*><*   +--------+------------------------------------------------------------------+
*><*   |program2|[path/]name of program that reads from Standard Input.            |
*><*   +--------+------------------------------------------------------------------+
*><*
*><* Options
*><* ~~~~~~~
*><*
*><*   +------+-------------+------------------------------------------------------+
*><*   |Short |Long         |Description                                           |
*><*   +======+=============+======================================================+
*><*   |-h    |--help       |Display the help text and exit.                       |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-v    |--version    |Display the version id and exit.                      |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-H    |--hardwarn   |Treat all warnings like an error.                     |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-V    |--verbose    |Include Macro Begin/End comment lines. (default)      |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-q    |--quiet      |Suppress the Macro Begin/End comment lines.           |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-d    |--debug      |Display additional error information.                 |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-m    |--maclib     |List the contents of the Macro Library.               |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-sfile|--stdlib=file|[path/]name of *file* holding Standard Macros Library.|
*><*   |      |             |Overrides the *cobolmac.standard.macros* default.     |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-ifile|--stdin=file |[path/]name of *file* containg source code.           |
*><*   |      |             |Overrides the Standard Input (stdin).                 |
*><*   +------+-------------+------------------------------------------------------+
*><*   |-ofile|--stdout=file|[path/]name of *file* to write processed code to.     |
*><*   |      |             |Overrides the Standard Output (stdout).               |
*><*   +------+-------------+------------------------------------------------------+
*><*
*><*   **Note:** *CobolMac*, by default, will use the *CBL_OC_GETOPT* system routine
*><+    to process the command line options. If the compiler you are using does
*><+    not have this routine then *CobolMac* will use its own internal
*><+    routine. Due to limitations with this routine, the options *--stdin*
*><+    (*-i*), *--stdout* (*-o*) and *--stdlib* (*-s*) are not supported. If this
*><+    happens then the following messages will be displayed on stderr.
*><*
*><*   ::
*><*
*><*       *W* CBL_OC_GETOPT is not available with your version of COBOL.
*><*       *W* An alternative method is being used to read your command line.
*><*       *W* The --stdlib, --stdin and --stdout options are not supported.
*><*
*><* Return Codes
*><* ~~~~~~~~~~~~
*><*
*><*   +--------+------------------------------------------------------------------+
*><*   |Code    |Description                                                       |
*><*   +========+==================================================================+
*><*   |0 (zero)|Program completed without any errors.                             |
*><*   +--------+------------------------------------------------------------------+
*><*   |1 (one) |Program terminated in an error state.                             |
*><*   |        |Details sent to Standard Error (stderr) prior to exit.            |
*><*   |        |The output file, if created, is incomplete/corrupt.               |
*><*   +--------+------------------------------------------------------------------+
*><*
*><* ----------------------
*><* Configuration Settings
*><* ----------------------
*><*
*><*   *CobolMac* supports multiple operating systems.
*><*
*><*   Set the **OS** constant to one of the following values before compiling.
*><*
*><*   +--------+----------------+
*><*   |OS Value|Operating System|
*><*   +========+================+
*><*   |LINUX   |GNU/Linux       |
*><*   +--------+----------------+
*><*   |UNIX    |UNIX            |
*><*   +--------+----------------+
*><*   |OSX     |Apple Mac OS X  |
*><*   +--------+----------------+
*><*   |WINDOWS |Windows (Native)|
*><*   +--------+----------------+
*><*   |CYGWIN  |Windows (Cygwin)|
*><*   +--------+----------------+
*><*   |MINGW   |Windows (MinGW) |
*><*   +--------+----------------+
*><*
        >>DEFINE CONSTANT OS AS 'LINUX'

*><* ------------------------
*><* Compilation Instructions
*><* ------------------------
*><*
*><* Linux/UNIX
*><* ~~~~~~~~~~
*><*
*><*   Compile the *CobolMac* source (cobolmac.cob) by entering the following
*><+  command within any terminal program.
*><*
*><*     cobc -x cobolmac.cob
*><*
*><*   Now place the file cobolmac in a directory that is within your PATH,
*><+  making sure that the execute flag is set (chmod +x cobolmac).
*><*
*><* Apple Mac OS X
*><* ~~~~~~~~~~~~~~
*><*
*><*   Compile the source file as for Linux/Unix.
*><*
*><*   This might not work 'as is' with Tiny Cobol or ANY other compiler.
*><+  Check to see if the compiler supports the C\$DELETE built-in system
*><+  subroutine. If not then the *s022-delete-workfiles* paragraph will need
*><+  modification to perform this function some other way (for eg. drop into a
*><+  command shell and issue the file delete/purge commands).
*><*
*><* Windows
*><* ~~~~~~~
*><*
*><*   I do not have access to Windows, Wingows/Cygwin or Windows/MinGW but I
*><+  understand that the following commands should work [YMMV].
*><*
*><*   Windows/MinGW and Windows/Cygwin (inside the terminal program):
*><*
*><*     Compile the source file as for Linux/Unix.
*><*
*><*   Windows/MinGW and Windows/Cygwin (outside the terminal program):
*><*
*><*     cobc -x [*drive*:][path/to/]cobolmac.cob
*><*
*><*   Native Windows:
*><*
*><*     cobc -x [*drive*:][path\\to\\]cobolmac.cob
*><*
*><* ------------
*><* Installation
*><* ------------
*><*
*><* Requirements
*><* ~~~~~~~~~~~~
*><*
*><*   **GnuCOBOL:** Version 2.0 (or greater) installed and tested fully working.
*><*   See the documentation supplied with *GnuCOBOL*. You MUST have run both the
*><+    sanity checks created by the test procedures included within the cobol85
*><+    suite as well as the make check procedure.
*><*
*><* Temporary Files
*><* ~~~~~~~~~~~~~~~
*><*
*><*   The following environment variables are used to find where the temporary files,
*><+    used by *CobolMac*, are to be placed.
*><*
*><*   - If TMPDIR exists and contains a value then use it, else continue.
*><*
*><*   - If TEMP exists and contains a value then use it, else continue.
*><*
*><*   - If TMP exists and contains a value then use it, else continue.
*><*
*><*   - If running on a Windows (Native, Cygwin, or MinGW) platform then
*><*
*><*     - If USERPROFILE exists and contains a value then use it, else use "." (dot).
*><*
*><*   - If **not** running on a Windows platform then use "/tmp".
*><*
*><*   **GnuCOBOL:** This may change when version 2.0 is the official release.
*><*
*><* Directory Seperator
*><* ~~~~~~~~~~~~~~~~~~~
*><*
*><*   The directory separator is *Operating System* dependent. The character used
*><+    is set by the value of the *CDF* variable named **OS** (see Configuration
*><+    Settings) as follows.
*><*
*><*   +--------------+------------------------------------------------------------+
*><*   |Seperator     |Operating System                                            |
*><*   +==============+============================================================+
*><*   |/ (slash)     |GNU/Linux, UNIX, Apple Mac OS X and Windows/Cygwin.         |
*><*   +--------------+------------------------------------------------------------+
*><*   |\\ (backslash)|Windows and Windows/MinGW.                                  |
*><*   +--------------+------------------------------------------------------------+
*><*
*><* -------------------
*><* Quotes about Macros
*><* -------------------
*><*
*><*   A good library of pre-tested Macros can greatly speed program writing, and
*><+    can also be used to assist portability of code, with the differences between
*><+    COBOL dialects being hidden in the Macro Definitions.
*><*
*><*      -- Anonymouse
*><*
*><*   RE: the COPY...REPLACING and REPLACE statements.
*><*
*><*   "The rules are complex and are actually ambiguous in some cases."
*><*
*><*   "One problem is that only words are replaced, not parts of words."
*><*
*><*      -- Don Nelson in "COBOL 85 for Programmers"
*><*
*><* -------------------------------
*><* Migration from HPe3000 COBOL/ix
*><* -------------------------------
*><*
*><*   The following Hewlett-Packard HPe3000 COBOL II/ix preprocessor commands
*><+    are **not** supported by *CobolMac*. They will be automatically dropped
*><+    from the source file and any files that are read in by the $INCLUDE and
*><+    $COPY commands.
*><*
*><*   +----------+----------------------------------------------------------------+
*><*   |Command   |Description                                                     |
*><*   +==========+================================================================+
*><*   |$CONTROL  |Controls compilation and list options.                          |
*><*   +----------+----------------------------------------------------------------+
*><*   |$COPYRIGHT|Enters a copyright string into the object file.                 |
*><*   +----------+----------------------------------------------------------------+
*><*   |$IF       |Interrogates the compilation software switches.                 |
*><*   +----------+----------------------------------------------------------------+
*><*   |$PAGE     |Advance to the next logical page in the listfile.               |
*><*   |          |Allows replacement of the 1st page header line.                 |
*><*   +----------+----------------------------------------------------------------+
*><*   |$SET      |Turns compilation switches on/off.                              |
*><*   +----------+----------------------------------------------------------------+
*><*   |$TITLE    |Allows replacement of the page header lines.                    |
*><*   +----------+----------------------------------------------------------------+
*><*   |$VERSION  |Enters a version string into the object file.                   |
*><*   +----------+----------------------------------------------------------------+
*><*
*><* --------------------
*><* Modification History
*><* --------------------
*><*
*><*   .. include:: ChangeLog
*><*
*><* --------------------
*><* Planned Enhancements
*><* --------------------
*><*
*><*   .. include:: ToDo
*><*
*><* ---------------
*><* Developer Notes
*><* ---------------
*><*
*><*   .. include:: DevNotes
*><*
*><* .. footer:: End of CobolMac User Guide
*><*
*> -----------------------------------------------------------------------------

environment division.

  configuration section.

    source-computer.                   Linux Mint Rosa; Cinnamon Edition.
    object-computer.                   Linux Mint Rosa; Cinnamon Edition.

    repository.

      function instr
      function all intrinsic.

  input-output section.

    file-control.

      select stdin                     assign to keyboard
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select stdinfile                 assign to w501-stdin-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select stdout                    assign to display
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select stdoutfile                assign to w501-stdout-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select workin                    assign to w501-workin-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select workout                   assign to w501-workout-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select macrolib                  assign to w501-macrolib-filename
                                       access is dynamic
                                       organization is indexed
                                       record key is macrolib-key
                                       file status is w500-file-status
                                       .
      select incfile                   assign to w501-incfile-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .
      select optional macrostd         assign to w501-macrostd-filename
                                       access is sequential
                                       organization is line sequential
                                       file status is w500-file-status
                                       .

data division.

  file section.

  fd  stdin.
    01  stdin-record                   pic x(256).
  fd  stdinfile.
    01  stdinfile-record               pic x(256).

  fd  stdout.
    01  stdout-record                  pic x(256).
  fd  stdoutfile.
    01  stdoutfile-record              pic x(256).

  fd  workin.
    01  workin-record                  pic x(256).
  fd  workout.
    01  workout-record                 pic x(256).

  fd  macrolib.
    01  macrolib-record.
      05  macrolib-key.
        10  macrolib-name              pic x(030).
        10  macrolib-line-number       pic 9(004).
      05  macrolib-data.
        10  macrolib-code-line         pic x(256).

  fd  incfile.
    01  incfile-record                 pic x(256).

  fd  macrostd.
    01  macrostd-record                pic x(256).

  working-storage section.

    *> -------------------------------------------------------------------------
    *>  w1nn - Program Identification and Usage.
    *> -------------------------------------------------------------------------

    01  w100-program-identity.
      05  w100-program-id-line-01.
        10                             pic x(009) value "cobolmac/".
        10  w100-program-v-uu-ff       pic x(007) value "B.04.00". *> Version.Update.Fix
        10                             pic x(063) value " - COBOL Macro Preprocessor.".
      05  w100-program-id-line-02.
        10  w100-copyright             pic x(079) value "Copyright (c) Robert W. Mills (robertw-mills@users.sf.net), 2014-2015.".
      05  w100-program-id-line-03      pic x(079) value "This is free software; see the source for copying conditions. There is NO".
      05  w100-program-id-line-04      pic x(079) value "WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.".

    01  w101-program-usage.
      05  w101-usage-index             pic s9(04) comp.
      05  w101-usage-text.
                            *>"         1         2         3         4         5         6         7         "
                            *>"1234567890123456789012345678901234567890123456789012345678901234567890123456789"
        10  pic x(316)  value "  Usage:                                                                       " &
                              "    $ program1 | cobolmac [options] [2>stderr] | program2                      " &
                              "    $ cobolmac [options] --stdin=input --stdout=output [2>stderr]              " &
                              "    $ cobolmac [options] <input [2>stderr] | program2                          ".
        10  pic x(079)  value spaces.
        10  pic x(1343) value "  Options:                                                                     " &
                              "    -h, --help     Display the help text and exit.                             " &
                              "    -v, --version  Display the version id and exit.                            " &
                              "    -H, --hardwarn Treat all warnings like an error.                           " &
                              "    -V, --verbose  Include Macro Begin/End comment lines (default)             " &
                              "    -q, --quiet    Suppress the Macro Begin/End comment lines.                 " &
                              "    -d, --debug    Display additional error information.                       " &
                              "    -m, --maclib   List the contents of the Macro Library.                     " &
                              "    -sfile, --stdlib=file                                                      " &
                              "                   [path/]name of file holding Standard Macros Library.        " &
                              "                   Overrides the *cobolmac.standard.macros* default.           " &
                              "    -ifile, --stdin=file                                                       " &
                              "                   [path/]name of file containing source code.                 " &
                              "                   Overrides the Standard Input (stdin).                       " &
                              "    -ofile, --stdout=file                                                      " &
                              "                   [path/]name of file to write processed code to.             " &
                              "                   Overrides the Standard Output (stdout).                     ".
        10  pic x(079)  value spaces.
        10  pic x(395)  value "    input          [path/]name of file Standard Input redirected to.           " &
                              "    output         [path/]name of file Standard Output redirected to.          " &
                              "    stderr         optional [path/]name of file Standard Error redirected to.  " &
                              "    program1       [path/]name of program that writes to Standard Output.      " &
                              "    program2       [path/]name of program that reads from Standard Input.      ".
        10  pic x(079)  value spaces.
        10  pic x(395)  value "  Return Codes:                                                                " &
                              "    0 (zero)       Program completed without any errors.                       " &
                              "    1 (one)        Program terminated in an error state.                       " &
                              "                   Details written to Standard Error prior to termination.     " &
                              "                   The output file, if created, is incomplete/corrupt.         ".
        10  pic x(079)  value spaces.
        10  pic x(079)  value "***". *> end of program usage text marker.
                            *>"         1         2         3         4         5         6         7         "
                            *>"1234567890123456789012345678901234567890123456789012345678901234567890123456789"
      05  redefines w101-usage-text.
        10  w101-usage-line            pic x(079) occurs 36.
            *> Update occurs count if number of fillers below w101-usage-text changes.

    *> -------------------------------------------------------------------------
    *>  w2nn - SQL Host Variables.
    *> -------------------------------------------------------------------------

    *> -------------------------------------------------------------------------
    *>  w3nn - Program Constants.
    *> -------------------------------------------------------------------------

    01  w300-preprocessor-defaults.
      05  w300-keychar                 pic x(001) value "%".
            *> This specifies the initial character of the macro name in both
            *> the macro definition and macro call.
      05  w300-parmchar                pic x(001) value "!".
            *> This specifies the initial character of the formal parameters in
            *> the macro definition.
      05  w300-delimiter               pic x(001) value "#".
            *> This specifies the character to be used to terminate the macro
            *> definition and the actual parameters in a macro call.

    01  w301-max-call-parms            pic s9(04) comp value 9.

    01  w302-id-markers.
      05  w302-id-marker-values.
        10  pic x(002)                            value "!1".
        10  pic x(002)                            value "!2".
        10  pic x(002)                            value "!3".
        10  pic x(002)                            value "!4".
        10  pic x(002)                            value "!5".
        10  pic x(002)                            value "!6".
        10  pic x(002)                            value "!7".
        10  pic x(002)                            value "!8".
        10  pic x(002)                            value "!9".
      05  redefines w302-id-marker-values.
        10  w302-id-marker             pic x(002) occurs 9.

    01  w303-os-specific-variables.
>>IF OS='LINUX'
      >>SET OSTYPE AS 'LINUX'
      05  w303-os-build                pic x(079) value "GNU/Linux".
      05  w303-dir-file-slash          pic x(001) value "/".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".

>>ELIF OS='UNIX'
      >>SET OSTYPE AS 'UNIX'
      05  w303-os-build                pic x(079) value "UNIX".
      05  w303-dir-file-slash          pic x(001) value "/".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".

>>ELIF OS='OSX'
      >>SET OSTYPE AS 'OSX'
      05  w303-os-build                pic x(079) value "Mac OSX".
      05  w303-dir-file-slash          pic x(001) value "/".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".

>>ELIF OS='WINDOWS'
      >>SET OSTYPE AS 'WIN32'
      05  w303-os-build                pic x(079) value "Windows".
      05  w303-dir-file-slash          pic x(001) value "\".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".

>>ELIF OS='CYGWIN'
      >>SET OSTYPE AS 'WIN32'
      05  w303-os-build                pic x(079) value "Windows/Cygwin".
      05  w303-dir-file-slash          pic x(001) value "/".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".

>>ELIF OS='MINGW'
      >>SET OSTYPE AS 'WIN32'
      05  w303-os-build                pic x(079) value "Windows/MinGW".
      05  w303-dir-file-slash          pic x(001) value "\".
      05  w303-macrostd-filename       pic x(256) value "cobolmac.standard.macros".
>>END-IF

    *> -------------------------------------------------------------------------
    *>  w4nn - System Intrinsic Parameters.
    *> -------------------------------------------------------------------------

    *>  Parameters required by CBL_OC_GETOPT

    78  w400-short-options                        value "hvHVqdms:i:o:".

    01  w400-long-options.
      05  w400-long-option-record      occurs 10 times.
        10  w400-long-option-name      pic x(025).
        10  w400-long-option-argument  pic 9(001).
          88  w400-no-argument                    value zero.
          88  w400-required-argument              value 1.
          88  w400-optional-argument              value 2.
        10                             pointer    value NULL.
        10  w400-long-option-alias     pic x(004).

    01  w400-long-option-index         pic 9(002) value zero.

    01  w400-long-option-prefix        pic 9(001) value zero.

    01  w400-option-id                 pic x(004).

    01  w400-option-argument           pic x(256).

    *> -------------------------------------------------------------------------
    *>  w5nn - File Status, Handles and Buffers.
    *> -------------------------------------------------------------------------

    01  w500-file-status               pic x(002).

      88  w500-success                            value "00".
      88  w500-success-duplicate                  value "02".
      88  w500-success-incomplete                 value "04".
      88  w500-success-optional                   value "05".
      88  w500-success-no-unit                    value "07".
      88  w500-directory-full-missing             value "09".

      88  w500-end-of-file                        value "10".
      88  w500-out-of-key-range                   value "14".

      88  w500-key-invalid                        value "21".
      88  w500-key-exists                         value "22".
      88  w500-key-not-exists                     value "23".

      88  w500-permanent-error                    value "30".
      88  w500-inconsistent-filename              value "31".
      88  w500-boundary-violation                 value "34".
      88  w500-not-exists                         value "35".
      88  w500-permission-denied                  value "37".
      88  w500-closed-with-lock                   value "38".
      88  w500-conflict-attribute                 value "39".

      88  w500-already-open                       value "41".
      88  w500-not-open                           value "42".
      88  w500-read-not-done                      value "43".
      88  w500-record-overflow                    value "44".
      88  w500-read-error                         value "46".
      88  w500-input-denied                       value "47".
      88  w500-output-denied                      value "48".
      88  w500-i-o-denied                         value "49".

      88  w500-record-locked                      value "51".
      88  w500-end-of-page                        value "52".
      88  w500-i-o-linage                         value "57".

      88  w500-file-sharing                       value "61".

      88  w500-not-available                      value "91".

    *> The following 7 variables have to be at the 01 level.

    01  w501-workin-filename           pic x(256) value spaces.
    01  w501-workout-filename          pic x(256) value spaces.
    01  w501-macrolib-filename         pic x(256) value spaces.
    01  w501-incfile-filename          pic x(256) value spaces.
    01  w501-macrostd-filename         pic x(256) value spaces.
    01  w501-stdin-filename            pic x(256) value spaces.
    01  w501-stdout-filename           pic x(256) value spaces.

    01  w502-work-files.
      05  w502-work-file-one           pic x(256).
      05  w502-work-file-two           pic x(256).
      05  w502-work-file-swap          pic x(256).

    *> -------------------------------------------------------------------------
    *>  w6nn - General Work Variables.
    *> -------------------------------------------------------------------------

    01  w600-error-handling.
      05  w600-location                pic x(080) value spaces.
      05  w600-sub-location            pic x(080) value spaces.
      05  w600-message                 pic x(240) value spaces.
      05  w600-message-2               pic x(240) value spaces.
      05  w600-file-status             pic x(080) value spaces.

    01  w601-temporary-directory       pic x(256) value spaces.

    01  w602-temp-record               pic x(256).

    01  w603-random-number             pic 9(009) value zero.

    01  w604-getopt-status             pic s9(9) comp.
      88  w604-no-more-options                    value -1.
      88  w604-non-option                         value 1.
      88  w604-option-argument-truncated          value 2.
      88  w604-valid-option-name                  value 3.
      88  w604-invalid-option-name                value 63.

    01  w605-macro-define-workarea.
      05  w605-define-name             pic x(080).
      05  w605-define-code             pic x(256).
      05  w605-define-line-number      pic 9(004).
      05  w605-define-delimiter        pic x(001).
      05  w605-not-used                pic x(256).

    01  w606-macro-call-workarea.
      05  w606-call-start              pic s9(04) comp.
      05  w606-call-end                pic s9(04) comp.
      05  w606-call-name               pic x(256) value spaces.
      05  w606-call-name-start         pic s9(04) comp.
      05  w606-call-name-delimiter     pic x(001) value spaces.
      05  w606-call-parms-list         pic x(256).
      05  w606-call-parameters.
        10  w606-call-parms-count      pic s9(04) comp value zero.
        10  w606-call-parm-number      pic s9(04) comp.
        10  w606-call-parameter        occurs 9.
          15  w606-call-parm           pic x(080).
      05  w606-call-count              pic s9(04) comp.
      05  w606-pre-call                pic x(256) value spaces.
      05  w606-pre-call-delimiter      pic x(001) value spaces.
      05  w606-post-call               pic x(256) value spaces.
      05  w606-post-call-delimiter     pic x(001) value spaces.
      05  w606-not-used                pic x(256).

    01  w607-comment-start             pic s9(04) comp.

    01  w608-preprocessor.
      05  w608-keychar                 pic x(001).
      05  w608-parmchar                pic x(001).
      05  w608-delimiter               pic x(001).

    01  w609-include-file-unstring.
      05  w609-not-used                pic x(256).
      05  w609-include-file            pic x(256).

    01  w610-macrolib-name             pic x(030).

    01  w611-new-preprocessor-parms.
      05  w611-not-used-1              pic x(080).
      05  w611-parameter-1             pic x(010).
      05  w611-subparameter-1          pic x(010).
      05  w611-parameter-2             pic x(010).
      05  w611-subparameter-2          pic x(010).
      05  w611-parameter-3             pic x(010).
      05  w611-subparameter-3          pic x(010).
      05  w611-not-used-2              pic x(256).

    *> Used by paragraph a201-getopt-alternative.

    01  w612-argv-option               pic x(256) value spaces.
      88  w612-help                               value "-h", "--help".
      88  w612-version                            value "-v", "--version".
      88  w612-hard-warnings                      value "-H", "--hardwarn".
      88  w612-verbose                            value "-V", "--verbose".
      88  w612-quiet                              value "-q", "--quiet".
      88  w612-debug                              value "-d", "--debug".
      88  w612-list-macrolib                      value "-m", "--maclib".

    *> -------------------------------------------------------------------------
    *>  w7nn - Hard Coded Messages.
    *> -------------------------------------------------------------------------

    *> Information (*I*) messages:

*>  01  w700-                          constant "*I* ?.".

    *> Warning (*W*) messages:

*>  01  w701-                          constant "*W* ?.".

    *> Error (*E*) messages:

*>  01  w702-                          constant "*E* ?.".

    *> Prompts and other messages:

*>  01  w703-                          constant "?.".

    *> -------------------------------------------------------------------------
    *>  w8nn - Printer Output Lines.
    *> -------------------------------------------------------------------------

    *> -------------------------------------------------------------------------
    *>  w9nn - Process Control Switches.
    *> -------------------------------------------------------------------------

    *> Only the 88 levels are named thus preventing entry of undefined values.
    *> Use the SET verb to set the required condition to TRUE.
    *> If there is a default condition it must be placed first in the list.
    *>
    *> Example entry without a default value:
    *>
    *>   01  pic x(001). *> description/reason for this switch.
    *>     88  w9nn-condition-one                 value "1".
    *>     88  w9nn-condition-two                 value "2".
    *>
    *> Example entry with a default value:
    *>
    *>   01  pic x(001) value "1". *> description/reason for this switch.
    *>     88  w9nn-condition-one                 value "1". *> Default setting.
    *>     88  w9nn-condition-two                 value "2".

    01  . *> End-of-file flags.

      05  pic x(001). *> Standard Input end-of-file?
        88  w900-more-stdin                       value "M".
        88  w900-end-of-stdin                     value "E".

      05  pic x(001). *> Work Input end-of-file?
        88  w900-more-workin                      value "M".
        88  w900-end-of-workin                    value "E".

      05  pic x(001). *> Macro Library end-of-file?
        88  w900-more-macrolib                    value "M".
        88  w900-end-of-macrolib                  value "E".

      05  pic x(001). *> $INCLUDE end-of-file?
        88  w900-more-incfile                     value "M".
        88  w900-end-of-incfile                   value "E".

      05  pic x(001). *> $INCLUDE end-of-file?
        88  w900-more-macrostd                    value "M".
        88  w900-end-of-macrostd                  value "E".

    01  pic x(001) value "N". *> Has the --stdin option been used?
      88  w901-stdin-option-not-used              value "N". *> Default setting.
      88  w901-stdin-option-used                  value "U".

    01  pic x(001) value "N". *> Has the --stdout option been used?
      88  w902-stdout-option-not-used             value "N". *> Default setting.
      88  w902-stdout-option-used                 value "U".

    01  pic x(001) value "N". *> Have we processed the working-storage section?
      88  w903-ws-section-not-found               value "N". *> Default setting.
      88  w903-ws-section-found                   value "F".

    01  pic x(001) value "S". *> Are Warnings Hard or Soft?
      88  w904-soft-warnings                      value "S". *> Default setting.
      88  w904-hard-warnings                      value "H".

    01  pic x(001). *> Have we found a $DEFINE Delimiter?
      88  w905-define-delimiter-found             value "F".
      88  w905-define-delimiter-not-found         value "N".

    01  pic x(001). *> Have we found an entry in the Macro Library?
      88  w906-macrolib-key-found                 value "F".
      88  w906-macrolib-key-not-found             value "N".

    01  pic x(001) value "I". *> Do we output a Macro Begin/End Marker?
      88  w907-include-macro-begin-end            value "I". *> Default setting.
      88  w907-exclude-macro-begin-end            value "E".

    01  pic x(001). *> Are there any more Macro Calls?
      88  w908-more-macro-calls                   value "M".
      88  w908-no-more-macro-calls                value "N".

    01  pic x(001) value "F". *> Is the internal debug flag set?
      88  w909-internal-debug-off                 value "F". *> Default setting.
      88  w909-internal-debug-on                  value "N".

    01  pic x(001) value "H". *> Do we display the contents of the Macro Library?
      88  w910-hide-macrolib                      value "H". *> Default setting.
      88  w910-list-macrolib                      value "D".

    01  pic x(001) value "N". *> Do we have any $DEFINEd Macros?
      88  w911-no-defined-macros                  value "N". *> Default setting.
      88  w911-defined-macros                     value "D".

    01  pic x(001) value "N". *> Are there any more $INCLUDE files to be loaded?
      88  w912-no-include-files                   value "N". *> Default setting.
      88  w912-more-include-files                 value "M".

    01  pic x(001) value "N". *> Have we found a Macro Call?
      88  w913-macro-call-not-found               value "N". *> Default setting.
      88  w913-macro-call-found                   value "F".

    01  pic x(001). *> Have we found a Macro Call?
      88  w914-unsupported-cmd                    value "U".
      88  w914-supported-cmd                      value "S".

    *> Delete following when GnuCOBOL 2.0 has replaced previous versions.

    01  pic x(001) value "M". *> Are there any more Command Line options?
      88  w999-more-commands                      value "M". *> Default setting.
      88  w999-last-command                       value "L".

procedure division.

  cobolmac-mainline.
    *> -------------------------------------------------------------------------
    *>  Program Control Block.
    *> -------------------------------------------------------------------------

    perform a000-initialise
    perform b000-copy-stdin-to-workout

    perform c000-load-include-files
      until w912-no-include-files

    perform d000-load-define-commands

    if w911-defined-macros then *> We have some preprocessing to do.
      set w908-more-macro-calls to true
      perform e000-expand-macro-calls

    else *> No macro definitions were found.
      move "cobolmac-mainline" to w600-location
      move "No macro definitions have been found." to w600-message
      move "N/A" to w600-file-status

      if w904-hard-warnings then *> Terminate the program.
        perform z999-abort

      else *> Display message and exit.
        display "*W* ", w600-message upon stderr end-display
      end-if

    end-if

    perform z000-finalise
    .

  a000-initialise.
    *> --------------------------------------------------------------------------
    *>  Start of Program Processing.
    *> --------------------------------------------------------------------------

    perform a100-find-temporary-directory
    perform a200-get-command-line-options
    perform a300-generate-work-filenames
    perform a400-initialise-defaults
    .

  a100-find-temporary-directory.
    *> -------------------------------------------------------------------------
    *>  Find name of directory to hold the temporary files.
    *> -------------------------------------------------------------------------

    move spaces to w601-temporary-directory

    accept w601-temporary-directory from environment "TMPDIR" end-accept

    if w601-temporary-directory = spaces then
      accept w601-temporary-directory from environment "TEMP" end-accept
    end-if

    if w601-temporary-directory = spaces then
      accept w601-temporary-directory from environment "TMP" end-accept
    end-if

>>IF OSTYPE='WIN32'

    if w601-temporary-directory = spaces then
      accept w601-temporary-directory from environment "USERPROFILE" end-accept
    end-if

    if w601-temporary-directory = spaces then
      move "." to w601-temporary-directory *> Use the current directory.
    end-if

>>ELSE

    if w601-temporary-directory = spaces then
      move "/tmp" to w601-temporary-directory
    end-if

>>END-IF
    .

  a200-get-command-line-options.
    *> -------------------------------------------------------------------------
    *>  Get the command-line options and validate them.
    *> -------------------------------------------------------------------------

    move "help" to w400-long-option-name(1)
    move "h" to w400-long-option-alias(1)
    set w400-no-argument(1) to true

    move "version" to w400-long-option-name(2)
    move "v" to w400-long-option-alias(2)
    set w400-no-argument(1) to true

    move "hardwarn" to w400-long-option-name(3)
    move "H" to w400-long-option-alias(3)
    set w400-no-argument(3) to true

    move "verbose" to w400-long-option-name(4)
    move "V" to w400-long-option-alias(4)
    set w400-no-argument(4) to true

    move "quiet" to w400-long-option-name(5)
    move "q" to w400-long-option-alias(5)
    set w400-no-argument(5) to true

    move "debug" to w400-long-option-name(6)
    move "d" to w400-long-option-alias(6)
    set w400-no-argument(6) to true

    move "maclib" to w400-long-option-name(7)
    move "m" to w400-long-option-alias(7)
    set w400-no-argument(7) to true

    move "stdlib" to w400-long-option-name(8)
    move "s" to w400-long-option-alias(8)
    set w400-required-argument(8) to true

    move "stdin" to w400-long-option-name(9)
    move "i" to w400-long-option-alias(9)
    set w400-required-argument(9) to true

    move "stdout" to w400-long-option-name(10)
    move "o" to w400-long-option-alias(10)
    set w400-required-argument(10) to true

    perform with test after
      until w604-no-more-options

      move spaces to w400-option-argument

      call 'CBL_OC_GETOPT' using by reference w400-short-options,
                                 by reference w400-long-options,
                                 by reference w400-long-option-index,
                                 by value w400-long-option-prefix,
                                 by reference w400-option-id,
                                 by reference w400-option-argument
        on exception
          *> CBL_OC_GETOPT is not available so we need to use the old (B.01.00) method.
          perform a201-getopt-alternative
          exit perform
      end-call

      move return-code to w604-getopt-status

      evaluate true

        when w604-valid-option-name
          *> Action(s) to perform if we find a valid option.

          evaluate trim(w400-option-id)

            when "h" *> --help
              perform a210-display-program-usage
              move zero to return-code
              goback

            when "v" *> --version
              perform a220-display-program-version
              move zero to return-code
              goback

            when "H" *> --hardwarn
              set w904-hard-warnings to true

            when "V" *> --verbose
              set w907-include-macro-begin-end to true

            when "q" *> --quiet
              set w907-exclude-macro-begin-end to true

            when "d" *> --debug
              set w909-internal-debug-on to true

            when "m" *> --maclib
              set w910-list-macrolib to true

            when "s" *> --stdlib
              move trim(w400-option-argument) to w501-macrostd-filename

            when "i" *> --stdin
              set w901-stdin-option-used to true
              move trim(w400-option-argument) to w501-stdin-filename

            when "o" *> --stdout
              set w902-stdout-option-used to true
              move trim(w400-option-argument) to w501-stdout-filename

          end-evaluate

        when w604-option-argument-truncated
          *> Action(s) to perform if we find a valid option BUT the argument has
          *> been truncated. This situation will occur if the option-argument
          *> variable is not large enought to hold the required data.

        when w604-invalid-option-name
          display "*W* Unknown command-line option: ", trim(w400-option-id) upon stderr end-display

        when w604-no-more-options
          continue

        when other
          *> If we get here then we have probably detected an return status we are
          *> unable to handle. Suggest you treat is as a FATAL ERROR.
          move "a200-get-command-line-options" to w600-location
          move spaces to w600-message
          string
            "The CBL_OC_GETOPT routine returned an unknown status ", w604-getopt-status, "." delimited by size
            into w600-message
          end-string
          move "N/A" to w600-file-status
          perform z999-abort

      end-evaluate

    end-perform
    .

  a201-getopt-alternative.
    *> -------------------------------------------------------------------------
    *>  An alternative method of getting the command-line options.
    *>  Only use if the routine CBL_OC_GETOPT is not available.
    *>  NOTE: The --stdlib (-s) option is not supported.
    *> -------------------------------------------------------------------------

    *> Tell user what is happening.

    display space upon stderr end-display
    display "*W* CBL_OC_GETOPT is not available with your version of COBOL." upon stderr end-display
    display "*W* An alternative method is being used to read your command line." upon stderr end-display
    display "*W* The --stdlib, --stdin and --stdout options are not supported." upon stderr end-display
    display space upon stderr end-display

    *> Get the command-line options and validate them.

    perform
      until w999-last-command

      move low-values to w612-argv-option
      accept w612-argv-option from argument-value end-accept

      if w612-argv-option > low-values then *> Found argument.

        evaluate true

          when w612-help *> -h or --help
            perform a210-display-program-usage
            move zero to return-code
            goback

          when w612-version *> -v or --version
            perform a220-display-program-version
            move zero to return-code
            goback

          when w612-hard-warnings *> -H or --hardwarn
            set w904-hard-warnings to true

          when w612-verbose *> -V or --verbose
            set w907-include-macro-begin-end to true

          when w612-quiet *> -q or --quiet
            set w907-exclude-macro-begin-end to true

          when w612-debug *> -d or --debug
            set w909-internal-debug-on to true

          when w612-list-macrolib *> -m or --maclib
            set w910-list-macrolib to true

          when other *> Unknown/Unsupported option.
            display "*W* Unknown/Unsupported command-line option: ", w612-argv-option upon stderr end-display

        end-evaluate

      else *> No more options were found.
        set w999-last-command to true
      end-if

    end-perform
    .

  a210-display-program-usage.
    *> -------------------------------------------------------------------------
    *>  Display the program usage on the Standard Error stream.
    *> -------------------------------------------------------------------------

    display space upon stderr end-display
    display w100-program-id-line-01 upon stderr end-display
    display w100-program-id-line-02 upon stderr end-display
    display w100-program-id-line-03 upon stderr end-display
    display w100-program-id-line-04 upon stderr end-display
    display space upon stderr end-display

    perform
      varying w101-usage-index from 1 by 1
      until w101-usage-line(w101-usage-index) = "***"

      display w101-usage-line(w101-usage-index) upon stderr end-display

    end-perform
    .

  a220-display-program-version.
    *> -------------------------------------------------------------------------
    *>  Display the program version on the Standard Error stream.
    *> -------------------------------------------------------------------------

    display space upon stderr end-display
    display w100-program-id-line-01 upon stderr end-display
    display w100-program-id-line-02 upon stderr end-display
    display w100-program-id-line-03 upon stderr end-display
    display w100-program-id-line-04 upon stderr end-display
    display "Built ", module-formatted-date, " for ", w303-os-build upon stderr end-display
    display space upon stderr end-display
    .

  a300-generate-work-filenames.
    *> -------------------------------------------------------------------------
    *>  Generate the Macro Library, Work Input and Work Output filenames.
    *> -------------------------------------------------------------------------

    compute w603-random-number
      = random(current-date(1:16)) * 1000000000
    end-compute

    move spaces to w502-work-file-one
    string
      trim(w601-temporary-directory), w303-dir-file-slash, "cobolmac-", w603-random-number, "-1" delimited by size
      into w502-work-file-one
    end-string

    move spaces to w502-work-file-two
    string
      trim(w601-temporary-directory), w303-dir-file-slash, "cobolmac-", w603-random-number, "-2" delimited by size
      into w502-work-file-two
    end-string

    move spaces to w501-macrolib-filename
    string
      trim(w601-temporary-directory), w303-dir-file-slash, "cobolmac-", w603-random-number, "-0" delimited by size
      into w501-macrolib-filename
    end-string
    .

  a400-initialise-defaults.
    *> -------------------------------------------------------------------------
    *>  Initialise the default variable values.
    *> -------------------------------------------------------------------------

    move w300-keychar to w608-keychar
    move w300-parmchar to w608-parmchar
    move w300-delimiter to w608-delimiter

    if w501-macrostd-filename = spaces then
      move trim(w303-macrostd-filename) to w501-macrostd-filename
    end-if
    .

  b000-copy-stdin-to-workout.
    *> -------------------------------------------------------------------------
    *>  Copy the Standard Input stream to the Work Output file.
    *> -------------------------------------------------------------------------

    move "b000-copy-stdin-to-workout (1)" to w600-location
    perform s001-open-read-stdin

    if w900-end-of-stdin then

      move "b000-copy-stdin-to-workout (2)" to w600-location
      perform s003-close-stdin

      move "The specified input file was empty." to w600-message
      move "N/A" to w600-file-status
      perform z999-abort

    end-if

    move w502-work-file-one to w501-workout-filename
    move "b000-copy-stdin-to-workout (3)" to w600-location
    perform s010-open-workout

    move "b000-copy-stdin-to-workout (4)" to w600-location
    perform s025-open-read-macrostd

    perform
      until w900-end-of-stdin

      if instr(stdin-record, "$include") > zero then *> $INCLUDE file found.
        set w912-more-include-files to true
      end-if

      move stdin-record to w602-temp-record

      perform s028-check-for-unsupported-cmd

      if w914-unsupported-cmd then
        move "This record type is not supported." to workout-record *> This is not used anywhere.

      else
        move stdin-record to workout-record
        move "b000-copy-stdin-to-workout (5)" to w600-location
        perform s011-write-workout

        if w903-ws-section-not-found and w900-more-macrostd then
          perform b100-check-for-working-storage
          if w903-ws-section-found then
            perform b200-load-macrostd
          end-if
        end-if

      end-if

      move "b000-copy-stdin-to-workout (6)" to w600-location
      perform s002-read-stdin

    end-perform

    move "b000-copy-stdin-to-workout (7)" to w600-location
    perform s012-close-workout

    move "b000-copy-stdin-to-workout (8)" to w600-location
    perform s003-close-stdin
    .

  b100-check-for-working-storage.
    *> -------------------------------------------------------------------------
    *>  Check if we have found the source files working-storage section.
    *> -------------------------------------------------------------------------

    if instr(stdin-record, "working-storage") > zero
    and instr(stdin-record, "section") > zero then *> Found start of working-storage.
      set w903-ws-section-found to true
    end-if
    .

  b200-load-macrostd.
    *> -------------------------------------------------------------------------
    *>  Load the Standard Macros file into the Work Output file.
    *> -------------------------------------------------------------------------

    perform
      until w900-end-of-macrostd

      move macrostd-record to workout-record
      move "b200-load-macrostd (1)" to w600-location
      perform s011-write-workout

      move "b200-load-macrostd (2)" to w600-location
      perform s026-read-macrostd

    end-perform

    move "b200-load-macrostd (3)" to w600-location
    perform s027-close-macrostd
    .

  c000-load-include-files.
    *> -------------------------------------------------------------------------
    *>  Load the $INCLUDE file into the Work Output file.
    *> -------------------------------------------------------------------------

    move w502-work-file-one to w501-workin-filename
    move "c000-load-include-files (1)" to w600-location
    perform s007-open-read-workin

    move w502-work-file-two to w501-workout-filename
    move "c000-load-include-files (2)" to w600-location
    perform s010-open-workout

    perform s023-swop-work-file-assignments

    set w912-no-include-files to true

    perform
      until w900-end-of-workin

      if instr(workin-record, "$include") > zero then *> $INCLUDE file found.

        move trim(workin-record) to workin-record
        unstring workin-record delimited by space
          into
            w609-not-used
            w609-include-file
        end-unstring

>>D     display "-- debug:   Loading file " trim(w609-include-file) upon stderr end-display

        move trim(w609-include-file) to w501-incfile-filename
        move "c000-load-include-files (3)" to w600-location
        perform s019-open-read-incfile

        perform
          until w900-end-of-incfile

          if instr(incfile-record, "$include") > zero then *> Nested $INCLUDE file found.
            set w912-more-include-files to true
          end-if

          move incfile-record to w602-temp-record

          perform s028-check-for-unsupported-cmd

          if w914-unsupported-cmd then
            move "This record type is not supported." to workout-record *> This is not used anywhere.

          else
            move incfile-record to workout-record
            move "c000-load-include-files (4)" to w600-location
            perform s011-write-workout
          end-if

          move "c000-load-include-files (5)" to w600-location
          perform s020-read-incfile

        end-perform

        perform s021-close-incfile

      else *> Normal record found.
        move workin-record to workout-record
        move "c000-load-include-files (6)" to w600-location
        perform s011-write-workout
      end-if

      move "c000-load-include-files (7)" to w600-location
      perform s008-read-workin

    end-perform

    move "c000-load-include-files (8)" to w600-location
    perform s009-close-workin

    move "c000-load-include-files (9)" to w600-location
    perform s012-close-workout
    .

  d000-load-define-commands.
    *> -------------------------------------------------------------------------
    *>  Extract the $DEFINEd macros and load them into the Macro Library file.
    *> -------------------------------------------------------------------------

    move w502-work-file-one to w501-workin-filename
    move "d000-load-define-commands (1)" to w600-location
    perform s007-open-read-workin

    move w502-work-file-two to w501-workout-filename
    move "d000-load-define-commands (2)" to w600-location
    perform s010-open-workout

    perform s023-swop-work-file-assignments

    move "d000-load-define-commands (3)" to w600-location
    perform s013-create-macrolib

    move "d000-load-define-commands (4)" to w600-location
    perform s014-open-macrolib

    perform
      until w900-end-of-workin

      move workin-record to w602-temp-record

      perform s028-check-for-unsupported-cmd

      if w914-unsupported-cmd then
        move "This record type is not supported." to workout-record *> This is not used anywhere.

      else if instr(workin-record, "$preprocessor") > zero then *> $PREPROCESSOR command found.
        perform s024-preprocessor-command

      else if instr(workin-record, "$define") = zero then *> $DEFINE command not found.
        move workin-record to workout-record
        move "d000-load-define-commands (5)" to w600-location
        perform s011-write-workout

      else
        perform d100-process-define-command

      end-if end-if end-if

      move "d000-load-define-commands (6)" to w600-location
      perform s008-read-workin

    end-perform

    move "d000-load-define-commands (7)" to w600-location
    perform s012-close-workout

    move "d000-load-define-commands (8)" to w600-location
    perform s018-close-macrolib

    move "d000-load-define-commands (9)" to w600-location
    perform s009-close-workin

    if w910-list-macrolib and w911-defined-macros then
      perform d200-list-macrolib
    end-if
    .

  d100-process-define-command.
    *> -------------------------------------------------------------------------
    *>  Process the $DEFINE command.
    *> -------------------------------------------------------------------------

    unstring workin-record
      delimited by w608-keychar or "="
      into
        w605-not-used
        w605-define-name
        w605-define-code
    end-unstring

*>D display "-- debug:   Looking in Macro Library for %", trim(w605-define-name), "." upon stderr end-display

    move trim(w605-define-name) to macrolib-name
    move zeros to macrolib-line-number
    move "d100-process-define-command" to w600-location
    perform s015-read-key-macrolib

    if w906-macrolib-key-found then *> We have a duplicate macro name.
      perform d110-found-duplicate-macro

    else *> We have a new macro. Add it to Macro Library.
      perform d120-add-macro-to-library
    end-if
    .

  d110-found-duplicate-macro.
    *> -------------------------------------------------------------------------
    *> Found a duplicate macro name. Generate an error/warning message.
    *> -------------------------------------------------------------------------

    move spaces to w600-message
    string
      "The ", trim(w605-define-name), " macro has already been $DEFINEd." delimited by size
      into w600-message
    end-string

    move "N/A" to w600-file-status

    if w904-hard-warnings then *> Terminate the program.
      move "d110-found-duplicate-macro (1)" to w600-location
      perform z999-abort

    else *> Write warning messages and continue.
      display "*W* ", trim(w600-message) upon stderr end-display

      move workin-record to workout-record
      move "d110-found-duplicate-macro (2)" to w600-location
      perform s011-write-workout

      move spaces to workout-record
      string
        "*> *W* ", trim(w600-message) delimited by size
        into workout-record
      end-string

      move "d110-found-duplicate-macro (3)" to w600-location
      perform s011-write-workout

    end-if
    .

  d120-add-macro-to-library.
    *> -------------------------------------------------------------------------
    *> Add the macro definition to the Macro Library file.
    *> -------------------------------------------------------------------------

*>D display "-- debug:     Adding %", trim(w605-define-name), " to Macro Library." upon stderr end-display

    set w911-defined-macros to true
    set w905-define-delimiter-not-found to true

    move zeros to w605-define-line-number
    unstring w605-define-code delimited by w608-delimiter
      into
        w605-define-code delimiter in w605-define-delimiter
    end-unstring

    move trim(w605-define-name) to macrolib-name
    move w605-define-line-number to macrolib-line-number
    move w605-define-code to macrolib-code-line
    move "d120-add-macro-to-library (1)" to w600-location
    perform s017-write-macrolib

    if w605-define-delimiter = w608-delimiter then *> $DEFINE delimiter was found.
      set w905-define-delimiter-found to true

    else *> $DEFINE delimiter was not found.
      move "d120-add-macro-to-library (2)" to w600-location
      perform s008-read-workin
    end-if

    perform
      until w905-define-delimiter-found

      unstring workin-record delimited by w608-delimiter
        into
          w605-define-code delimiter in w605-define-delimiter
      end-unstring

      if w605-define-delimiter = w608-delimiter then *> $DEFINE delimiter found.
        set w905-define-delimiter-found to true
      end-if

      add 1 to w605-define-line-number end-add
      move w605-define-line-number to macrolib-line-number
      move trim(w605-define-name) to macrolib-name
      move w605-define-code to macrolib-code-line
      move "d120-add-macro-to-library (3)" to w600-location
      perform s017-write-macrolib

      if w905-define-delimiter-not-found then
        move "d120-add-macro-to-library (4)" to w600-location
        perform s008-read-workin
      end-if

    end-perform
    .

  d200-list-macrolib.
    *> -------------------------------------------------------------------------
    *>  List the contents of the Macro Library file to the Standard Error stream.
    *> -------------------------------------------------------------------------

    move "d200-list-macrolib (1)" to w600-location
    perform s014-open-macrolib

    display space upon stderr end-display
    display "---------- Start of Macros Library." upon stderr end-display
    move "d200-list-macrolib (2)" to w600-location
    perform s016-read-next-macrolib

    perform
      until w900-end-of-macrolib

      if macrolib-line-number = zeros then *> 1st line for macro. Output macro name.
        display space upon stderr end-display
        display "Macro %", trim(macrolib-name) upon stderr end-display
      end-if

      display "[" macrolib-line-number "] ", trim(macrolib-data, trailing) upon stderr end-display

      move "d200-list-macrolib (3)" to w600-location
      perform s016-read-next-macrolib

    end-perform

    display space upon stderr end-display
    display "---------- End of Macro Library." upon stderr end-display
    display space upon stderr end-display

    move "d200-list-macrolib (4)" to w600-location
    perform s018-close-macrolib
    .

  e000-expand-macro-calls.
    *> -------------------------------------------------------------------------
    *>  Replace the Macro Calls with code held in the Macro Library file.
    *> -------------------------------------------------------------------------

    move "e000-expand-macro-calls (1)" to w600-location
    perform s014-open-macrolib

    perform
      until w908-no-more-macro-calls

      move zero to w606-call-count
      move w502-work-file-one to w501-workin-filename
      move "e000-expand-macro-calls (2)" to w600-location
      perform s007-open-read-workin

      move w502-work-file-two to w501-workout-filename
      move "e000-expand-macro-calls (3)" to w600-location
      perform s010-open-workout

      perform s023-swop-work-file-assignments

      perform
        until w900-end-of-workin

        perform e100-find-macro-call

        if w913-macro-call-found then
          perform e200-convert-call-to-code

        else *> Write record to workout.
          move workin-record to workout-record
          move "e000-expand-macro-calls (4)" to w600-location
          perform s011-write-workout
        end-if

        move "e000-expand-macro-calls (5)" to w600-location
        perform s008-read-workin

      end-perform

      move "e000-expand-macro-calls (6)" to w600-location
      perform s012-close-workout

      move "e000-expand-macro-calls (7)" to w600-location
      perform s009-close-workin

      if w606-call-count = 0 then
        set w908-no-more-macro-calls to true
      end-if

    end-perform

    move "e000-expand-macro-calls (7)" to w600-location
    perform s018-close-macrolib
    .

  e100-find-macro-call.
    *> -------------------------------------------------------------------------
    *>  Search the current workin record for a macro call.
    *> -------------------------------------------------------------------------

    *> Search for a comment marker and macro keychar.
    move zero to w607-comment-start
    move instr(workin-record, "*>") to w607-comment-start
    move zero to w606-call-start
    move instr(workin-record, w300-keychar) to w606-call-start

    evaluate true

      when w606-call-start = zero *> Macro keychar not found.
        set w913-macro-call-not-found to true

      when (w607-comment-start > 0) and (w606-call-start > w607-comment-start) *> Macro keychar found in a comment.
        set w913-macro-call-not-found to true

      when other
        *> Extract the 'word' following the macro keychar.
        move spaces to w606-call-name, w606-call-name-delimiter
        add 1 to w606-call-start giving w606-call-name-start end-add
        unstring workin-record delimited by "(" or ")" or "." or space or '"' or ","
          into
            w606-call-name delimiter in w606-call-name-delimiter
          with pointer w606-call-name-start
        end-unstring
        *> Look in the Macro Library to see if this 'word' is a valid macro name.
        move trim(w606-call-name) to macrolib-name
        move zeros to macrolib-line-number
        move "e100-find-macro-call" to w600-location
        perform s015-read-key-macrolib
        if w906-macrolib-key-found then *> We've found a macro call.
          move macrolib-name to w610-macrolib-name
          add 1 to w606-call-count end-add
          set w913-macro-call-found to true

        else *> It is not a macro call.
          set w913-macro-call-not-found to true
        end-if

    end-evaluate
    .

  e200-convert-call-to-code.
    *> -------------------------------------------------------------------------
    *>  Replace the macro call with its code.
    *> -------------------------------------------------------------------------

    *> TODO:
    *>
    *>   Replace the 3 performs of e230-macro-as-a-constant with the following code:
    *>
    *>     move substitue-case(workin-record, w606-call-name, trim(macrolib-code-line))
    *>       to workout-record
    *>     move "e200-convert-call-to-code (n)" to w600-location
    *>     perform s011-write-workout
    *>
    *>   If it works then remove the performs and the performed paragraph.

    evaluate w606-call-name-delimiter

      when "("
>>D     display "macro [", trim(workin-record, trailing) upon syserr end-display
        perform e210-macro-with-parameters

      when " "
        perform e220-macro-without-parameters

      when "."
        perform e230-macro-as-a-constant
*>      move substitue-case(workin-record, w606-call-name, trim(macrolib-code-line)) to workout-record
*>      move "e200-convert-call-to-code (1)" to w600-location
*>      perform s011-write-workout

      when ")"
        perform e230-macro-as-a-constant
*>      move substitue-case(workin-record, w606-call-name, trim(macrolib-code-line)) to workout-record
*>      move "e200-convert-call-to-code (2)" to w600-location
*>      perform s011-write-workout

      when ","
        perform e230-macro-as-a-constant
*>      move substitue-case(workin-record, w606-call-name, trim(macrolib-code-line)) to workout-record
*>      move "e200-convert-call-to-code (3)" to w600-location
*>      perform s011-write-workout

      when other
        move "e200-convert-call-to-code (4)" to w600-location
        move "Unable to determine the macro call type." to w600-message
        move "N/A" to w600-file-status
        perform z999-abort

    end-evaluate
    .

  e210-macro-with-parameters.
    *> -------------------------------------------------------------------------
    *>  Insert the macro code and replace parameter markers with actual values.
    *> -------------------------------------------------------------------------

    unstring workin-record delimited by w300-keychar or "("
      into
        w606-not-used *> line # (if present), leading spaces and marker.
        w606-call-name delimiter in w606-call-name-delimiter
        w606-call-parms-list
    end-unstring

    initialize w606-call-parameters
    unstring w606-call-parms-list delimited by "#," or "#)"
      into
        w606-call-parm(1)
        w606-call-parm(2)
        w606-call-parm(3)
        w606-call-parm(4)
        w606-call-parm(5)
        w606-call-parm(6)
        w606-call-parm(7)
        w606-call-parm(8)
        w606-call-parm(9)
      tallying in w606-call-parms-count
    end-unstring

    subtract 1 from w606-call-parms-count end-subtract

>>D display "  num parms [", w606-call-parms-count upon syserr end-display

    if w907-include-macro-begin-end then
      move spaces to workout-record
      string
        "*> **** Begin Macro ", trim(w606-call-name), "(", trim(w606-call-parms-list) delimited by size
        into workout-record(w606-call-start:)
      end-string
      move "e210-macro-with-parameters (1)" to w600-location
      perform s011-write-workout
    end-if

    if macrolib-code-line <> space then *> Filters out an initial blank line in the macro definition.

      move substitute(macrolib-code-line,
                      w302-id-marker(1), trim(w606-call-parm(1))
                      w302-id-marker(2), trim(w606-call-parm(2))
                      w302-id-marker(3), trim(w606-call-parm(3))
                      w302-id-marker(4), trim(w606-call-parm(4))
                      w302-id-marker(5), trim(w606-call-parm(5))
                      w302-id-marker(6), trim(w606-call-parm(6))
                      w302-id-marker(7), trim(w606-call-parm(7))
                      w302-id-marker(8), trim(w606-call-parm(8))
                      w302-id-marker(9), trim(w606-call-parm(9))
                      ) to macrolib-code-line

      move spaces to workout-record
      move macrolib-code-line to workout-record(w606-call-start:)
      move "e210-macro-with-parameters (2)" to w600-location
      perform s011-write-workout
    end-if

    move "e210-macro-with-parameters (3)" to w600-location
    perform s016-read-next-macrolib

    if macrolib-name <> w610-macrolib-name then
      set w900-end-of-macrolib to true
    end-if

    perform
      until w900-end-of-macrolib

      move substitute(macrolib-code-line,
                      w302-id-marker(1), trim(w606-call-parm(1))
                      w302-id-marker(2), trim(w606-call-parm(2))
                      w302-id-marker(3), trim(w606-call-parm(3))
                      w302-id-marker(4), trim(w606-call-parm(4))
                      w302-id-marker(5), trim(w606-call-parm(5))
                      w302-id-marker(6), trim(w606-call-parm(6))
                      w302-id-marker(7), trim(w606-call-parm(7))
                      w302-id-marker(8), trim(w606-call-parm(8))
                      w302-id-marker(9), trim(w606-call-parm(9))
                      ) to macrolib-code-line

      move spaces to workout-record
      move macrolib-code-line to workout-record(w606-call-start:)
      move "e210-macro-with-parameters (4)" to w600-location
      perform s011-write-workout
      move "e210-macro-with-parameters (5)" to w600-location
      perform s016-read-next-macrolib

      if macrolib-name <> w610-macrolib-name then
        set w900-end-of-macrolib to true
      end-if

    end-perform

    if w907-include-macro-begin-end then
      move spaces to workout-record
      string
        "*> **** End Macro ", trim(w610-macrolib-name) delimited by size
        into workout-record(w606-call-start:)
      end-string
      move "e210-macro-with-parameters (6)" to w600-location
      perform s011-write-workout
    end-if
    .

  e220-macro-without-parameters.
    *> -------------------------------------------------------------------------
    *>  Insert the macro code.
    *> -------------------------------------------------------------------------

    if w907-include-macro-begin-end then
      move spaces to workout-record
      string
        "*> **** Begin Macro ", trim(macrolib-name) delimited by size
        into workout-record(w606-call-start:)
      end-string
      move "e220-macro-without-parameters (1)" to w600-location
      perform s011-write-workout
    end-if

    if macrolib-code-line <> space then *> Filter out an initial blank line in the macro definition.
      move spaces to workout-record
      move macrolib-code-line to workout-record(w606-call-start:)
      move "e220-macro-without-parameters (2)" to w600-location
      perform s011-write-workout
    end-if

    move "e220-macro-without-parameters (3)" to w600-location
    perform s016-read-next-macrolib

    if macrolib-name <> w610-macrolib-name then
      set w900-end-of-macrolib to true
    end-if

    perform
      until w900-end-of-macrolib

      move spaces to workout-record
      move macrolib-code-line to workout-record(w606-call-start:)
      move "e220-macro-without-parameters (4)" to w600-location
      perform s011-write-workout
      move "e220-macro-without-parameters (5)" to w600-location
      perform s016-read-next-macrolib

      if macrolib-name <> w610-macrolib-name then
        set w900-end-of-macrolib to true
      end-if

    end-perform

    if w907-include-macro-begin-end then
      move spaces to workout-record
      string
        "*> **** End Macro ", trim(w610-macrolib-name) delimited by size
        into workout-record(w606-call-start:)
      end-string
      move "e220-macro-without-parameters (6)" to w600-location
      perform s011-write-workout
    end-if
    .

  e230-macro-as-a-constant.
    *> -------------------------------------------------------------------------
    *>  Replace the macro name with its value and write record to workout.
    *> -------------------------------------------------------------------------

    move zero to w606-call-start
    move instr(workin-record, w300-keychar) to w606-call-start
    move length(trim(w606-call-name)) to w606-call-end
    add w606-call-start to w606-call-end end-add

    move spaces to workout-record
    string
      workin-record(1:w606-call-start - 1), trim(macrolib-code-line), workin-record(w606-call-end + 1:)
      delimited by size
      into workout-record
    end-string

    move "e230-macro-as-a-constant" to w600-location
    perform s011-write-workout
    .

  z000-finalise.
    *> -------------------------------------------------------------------------
    *>  End of Program Processing.
    *> -------------------------------------------------------------------------

    perform z100-copy-workin-to-stdout
    perform s022-delete-workfiles

    move zero to return-code
    goback
    .

  z100-copy-workin-to-stdout.
    *> -------------------------------------------------------------------------
    *>  Copy the Work Input file to the Standard Output stream.
    *> -------------------------------------------------------------------------

    move w502-work-file-one to w501-workin-filename
    move "z100-copy-workin-to-stdout (1)" to w600-location
    perform s007-open-read-workin
    move "z100-copy-workin-to-stdout (2)" to w600-location
    perform s004-open-stdout

    perform
      until w900-end-of-workin

      move workin-record to stdout-record
      move "z100-copy-workin-to-stdout (3)" to w600-location
      perform s005-write-stdout
      move "z100-copy-workin-to-stdout (4)" to w600-location
      perform s008-read-workin

    end-perform

    move "z100-copy-workin-to-stdout (5)" to w600-location
    perform s006-close-stdout
    move "z100-copy-workin-to-stdout (6)" to w600-location
    perform s009-close-workin
    .

  z999-abort.
    *> -------------------------------------------------------------------------
    *>  Abnormal Termination Processing.
    *> -------------------------------------------------------------------------

    perform s022-delete-workfiles
    display space upon stderr end-display
    display w100-program-id-line-01 upon stderr end-display
    display w100-program-id-line-02 upon stderr end-display
    display w100-program-id-line-03 upon stderr end-display
    display w100-program-id-line-04 upon stderr end-display
    display space upon stderr end-display

    if w909-internal-debug-on then
      display "  Detected in ", trim(w600-location) " at ", trim(w600-sub-location) upon stderr end-display
    end-if

    display "  Error: ", trim(w600-message) upon stderr end-display

    if trim(w600-message-2) <> spaces then
      display "       : ", trim(w600-message-2) upon stderr end-display
    end-if

    if trim(w600-file-status) <> "N/A" then
      display "  File Status: ", trim(w600-file-status) upon stderr end-display
    end-if

    display space upon stderr end-display
    move 1 to return-code
    goback
    .

*> *****************************************************************************
*> Start of Internal Subroutines.

  s000-set-file-error-status.
    *> -------------------------------------------------------------------------
    *>  Set the file error status for display by z999-abort.
    *> -------------------------------------------------------------------------

    evaluate true

      when w500-success
        move "00: Successful completion." to w600-file-status
          *> Nothing extra to say.

      when w500-success-duplicate
        move "02: Next record has same key (Read) or Duplicate key value (Write)." to w600-file-status
        *> The READ statement was successfully executed, but a duplicate key was
        *> detected. That is, the key value for the current key of reference was
        *> equal to the value of the key in the next record.

      when w500-success-incomplete
        move "04: Record length does not match fixed file attributes." to w600-file-status
        *> An attempt was made to read a record that is larger than the largest,
        *> or smaller than the smallest record allowed by the RECORD IS VARYING
        *> clause of the associated file-name.

      when w500-success-optional
        move "05: Optional file not present at the time of Open." to w600-file-status
        *> An OPEN statement is successfully executed, but the referenced
        *> optional file is not present at the time the OPEN statement is
        *> executed. If the open mode is I-O or EXTEND, the file has been
        *> created.

      when w500-success-no-unit
        move "07: REEL/UNIT specified but file is non-reel/unit medium." to w600-file-status
        *> For a CLOSE statement with the NO REWIND, REEL/UNIT, or FOR REMOVAL
        *> phrase or for an OPEN statement with the NO REWIND phrase, the
        *> referenced file was on a non-reel/unit medium.

      when w500-directory-full-missing
        move "09: No room in directory or directory does not exist." to w600-file-status
        *> Nothing extra to say.

      when w500-end-of-file
        move "10: No next logical record exists (end of file)." to w600-file-status
        *> A sequential READ statement was attempted and no next logical record
        *> existed in the file because the end of the file had been reached.

      when w500-out-of-key-range
        move "14: Number of significant digits in relative record number > key data item size." to w600-file-status
        *> A sequential READ statement was attempted for a relative file and the
        *> number of significant digits in the relative record number was larger
        *> than the size of the relative key data item described for the file.

      when w500-key-invalid
        move "21: Key sequence error." to w600-file-status
        *> A sequence error exists for a sequentially accessed indexed file. The
        *> prime record key value has been changed by the program between the
        *> successful execution of a READ statement and the execution of the
        *> next REWRITE statement for that file, or the ascending requirements
        *> for successive record key values were violated.
        *>
        *> Alternatively, the program has changed the record key value between a
        *> successful READ and subsequent REWRITE or DELETE operation on a
        *> randomly or dynamically-accessed file with duplicate keys.

      when w500-key-exists
        move "22: Duplicate key and duplicates not allowed." to w600-file-status
        *> An attempt was made to write a record that would create a duplicate
        *> key in a relative file; or an attempt was made to write or rewrite a
        *> record that would create a duplicate prime record key in an indexed
        *> file.

      when w500-key-not-exists
        move "23: Record not found." to w600-file-status
        *> An attempt was made to randomly access a record that does not exist
        *> in the file.

      when w500-permanent-error
        move "30: No further information." to w600-file-status
        *> Nothing extra to say.

      when w500-inconsistent-filename
        move "31: Dynamic file attribute conflict." to w600-file-status
        *> Nothing extra to say.

      when w500-boundary-violation
        move "34: Failed because of a boundry violation." to w600-file-status
        *> The I/O statement failed because of a boundary violation. This
        *> condition indicates that an attempt has been made to write beyond
        *> the externally defined boundaries of a sequential file.

      when w500-not-exists
        move "35: Missing file." to w600-file-status
        *> An OPEN operation with the I-O, INPUT, or EXTEND phrases has been
        *> tried on a non-OPTIONAL file that is not present.

      when w500-permission-denied
        move "37: Invalid device/unwritable file." to w600-file-status
        *> An OPEN operation has been tried on a file which does not support
        *> the open mode specified in the OPEN statement. Possible violations
        *> are:
        *>   1. The EXTEND or OUTPUT phrase was specified but the file would not
        *>      support write operations.
        *>   2. The I-O phrase was specified but the file would not support the
        *>      input and output operations permitted.
        *>   3. The INPUT phrase was specified but the file would not support
        *>      read operations.

      when w500-closed-with-lock
        move "38: Open on file closed with LOCK." to w600-file-status
        *> An OPEN operation has been tried on a file previously closed with a
        *> lock.

      when w500-conflict-attribute
        move "39: Fixed file attribute conflict." to w600-file-status
        *> A conflict has been detected between the fixed file attributes and
        *> the attributes specified for the file in the program. This is usually
        *> caused by a conflict with record-length, key-length, key-position or
        *> file organization. Other possible causes are:
        *>   1. Alternate indexes are incorrectly defined.
        *>   2. The Recording Mode is Variable or Fixed or not defined the same
        *>      as when the file was created..

      when w500-already-open
        move "41: File is already open." to w600-file-status
        *> An OPEN operation has been tried on file already opened.

      when w500-not-open
        move "42: File is already closed." to w600-file-status
        *> A CLOSE operation has been tried on file already closed.

      when w500-read-not-done
        move "43: No read before rewrite/delete." to w600-file-status
        *> For a sequential file in the sequential access mode, the last input-
        *> output statement executed for the associated file prior to the
        *> execution of a REWRITE statement was not a successfully executed READ
        *> statement. For relative and indexed files in the sequential access
        *> mode, the last input-output statement executed for the file prior to
        *> the execution of a DELETE or REWRITE statement was not a successfully
        *> executed READ statement.

      when w500-record-overflow
        move "44: Boundry violation." to w600-file-status
        *> A boundary violation exists because an attempt was made to rewrite a
        *> record to a file and the record was not the same size as the record
        *> being replaced. An attempt was made to write or rewrite a record that
        *> is larger than the largest, or smaller than the smallest record
        *> allowed by the RECORD IS VARYING clause of the associated file-name.

      when w500-read-error
        move "46: Unsuccessful read/start." to w600-file-status
        *> A sequential READ, READ NEXT or READ PRIOR statement was attempted on
        *> a file open in the input or I-O mode and no valid next record had
        *> been established because the preceding START statement was
        *> unsuccessful, or the preceding READ statement was unsuccessful or
        *> caused an at end condition.

      when w500-input-denied
        move "47: File not open for input." to w600-file-status
        *> The execution of a READ or START statement was attempted on a file
        *> not open in the input or I-O mode.

      when w500-output-denied
        move "48: File not open for output." to w600-file-status
        *> The execution of a WRITE statement was attempted on a sequential file
        *> not open in the output, or extend mode. The execution of a WRITE
        *> statement was attempted on an indexed or relative file not open in
        *> the I-O, output, or extend mode.

      when w500-i-o-denied
        move "49: File not open for I-O." to w600-file-status
        *> The execution of a DELETE or REWRITE statement was attempted on a
        *> file not open in the I-O mode.

      when w500-record-locked
        move "51: Record already locked." to w600-file-status
        *> Nothing extra to say.

      when w500-end-of-page
        move "52: End of page." to w600-file-status
        *> Nothing extra to say.

      when w500-i-o-linage
        move "57: I-O Linage." to w600-file-status
        *> Nothing extra to say.

      when w500-file-sharing
        move "61: File sharing." to w600-file-status
        *> Nothing extra to say.

      when w500-not-available
        move "91: Not available." to w600-file-status
        *> Nothing extra to say.

      when other
        move spaces to w600-file-status
        string
          "Unknown error code (", w500-file-status, ") detected." delimited by size
          into w600-file-status
        end-string

    end-evaluate
    .

  s001-open-read-stdin.
    *> -------------------------------------------------------------------------
    *>  Open the Standard Input stream/file and read the first record.
    *> -------------------------------------------------------------------------

    if w901-stdin-option-not-used then
      open input stdin
    else
      open input stdinfile
    end-if

    if not w500-success then
      move "s001-open-read-stdin" to w600-sub-location
      move "Unable to open Standard Input." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if

    perform s002-read-stdin
    .

  s002-read-stdin.
    *> -------------------------------------------------------------------------
    *>  Read the next record from the Standard Input stream/file.
    *> -------------------------------------------------------------------------

    if w901-stdin-option-not-used then
      read stdin end-read
    else
      read stdinfile into stdin-record end-read
    end-if

    evaluate true

      when w500-success
        set w900-more-stdin to true

      when w500-end-of-file
        set w900-end-of-stdin to true

      when other
        move "s002-read-stdin" to w600-sub-location
        move "Unable to read a record from Standard Input." to w600-message
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s003-close-stdin.
    *> -------------------------------------------------------------------------
    *>  Close the Standard Input stream/file.
    *> -------------------------------------------------------------------------

    if w901-stdin-option-not-used then
      close stdin
    else
      close stdinfile
    end-if

    if not w500-success then
      move "s003-close-stdin" to w600-sub-location
      move "Unable to close Standard Input." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s004-open-stdout.
    *> -------------------------------------------------------------------------
    *>  Open the Standard Output stream/file.
    *> -------------------------------------------------------------------------

    if w902-stdout-option-not-used then
      open output stdout
    else
      open output stdoutfile
    end-if

    if not w500-success then
      move "s004-open-stdout" to w600-sub-location
      move "Unable to open Standard Output." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s005-write-stdout.
    *> -------------------------------------------------------------------------
    *>  Write a record to the Standard Output stream/file.
    *> -------------------------------------------------------------------------

    if w902-stdout-option-not-used then
      write stdout-record end-write
    else
      write stdoutfile-record from stdout-record end-write
    end-if

    if not w500-success then
      move "s005-write-stdout" to w600-sub-location
      move "Unable to write a record to Standard Output." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s006-close-stdout.
    *> -------------------------------------------------------------------------
    *>  Close the Standard Output stream/file.
    *> -------------------------------------------------------------------------

    if w902-stdout-option-not-used then
      close stdout
    else
      close stdoutfile
    end-if

    if not w500-success then
      move "s006-close-stdout" to w600-sub-location
      move "Unable to close Standard Output." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s007-open-read-workin.
    *> -------------------------------------------------------------------------
    *>  Open the Work Input file and read the first record.
    *> -------------------------------------------------------------------------

    open input workin

    if not w500-success then
      move "s007-open-read-workin" to w600-sub-location
      move "Unable to open Work Input." to w600-message
      move trim(w501-workin-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if

    perform s008-read-workin
    .

  s008-read-workin.
    *> -------------------------------------------------------------------------
    *>  Read the next record from the Work Input file.
    *> -------------------------------------------------------------------------

    read workin end-read

    evaluate true

      when w500-success
        set w900-more-workin to true

      when w500-end-of-file
        set w900-end-of-workin to true

      when other
        move "s005-read-workin" to w600-sub-location
        move "Unable to read a record from Work Input." to w600-message
        move trim(w501-workin-filename) to w600-message-2
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s009-close-workin.
    *> -------------------------------------------------------------------------
    *>  Close the Work Input file.
    *> -------------------------------------------------------------------------

    close workin

    if not w500-success then
      move "s009-close-workin" to w600-sub-location
      move "Unable to close Work Input." to w600-message
      move trim(w501-workin-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s010-open-workout.
    *> -------------------------------------------------------------------------
    *>  Open the Work Output file.
    *> -------------------------------------------------------------------------

    open output workout

    if not w500-success then
      move "s010-open-workout" to w600-sub-location
      move "Unable to open Work Output." to w600-message
      move trim(w501-workout-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s011-write-workout.
    *> -------------------------------------------------------------------------
    *>  Write a record to the Work Output file.
    *> -------------------------------------------------------------------------

    write workout-record end-write

    if not w500-success then
      move "s011-write-workout" to w600-sub-location
      move "Unable to write a record to Work Output." to w600-message
      move trim(w501-workout-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s012-close-workout.
    *> -------------------------------------------------------------------------
    *>  Close the Work Output file.
    *> -------------------------------------------------------------------------

    close workout

    if not w500-success then
      move "s012-close-workout" to w600-sub-location
      move "Unable to close Work Output." to w600-message
      move trim(w501-workout-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s013-create-macrolib.
    *> -------------------------------------------------------------------------
    *>  Create the Macro Library file.
    *> -------------------------------------------------------------------------

    open output macrolib

    if not w500-success then
      move "s013-create-macrolib" to w600-sub-location
      move "Unable to create Macro Library." to w600-message
      move trim(w501-macrolib-filename) to w600-message-2
      perform z999-abort
    end-if

    *> Macro Library must be closed before it can be opened for use.
    perform s018-close-macrolib
    .

  s014-open-macrolib.
    *> -------------------------------------------------------------------------
    *>  Open the Macro Library file.
    *> -------------------------------------------------------------------------

    open i-o macrolib

    if not w500-success then
      move "s014-open-macrolib" to w600-sub-location
      move "Unable to open Macro Library." to w600-message
      move trim(w501-macrolib-filename) to w600-message-2
      perform z999-abort
    end-if
    .

  s015-read-key-macrolib.
    *> -------------------------------------------------------------------------
    *>  Read a record with the specified key from the Macro Library file.
    *> -------------------------------------------------------------------------

    read macrolib end-read

    evaluate true

      when w500-success
        set w906-macrolib-key-found to true

      when w500-key-not-exists
        set w906-macrolib-key-not-found to true

      when other
        move "s015-read-key-macrolib" to w600-sub-location
        move "Unable to read a record from Macro Library." to w600-message
        move trim(w501-macrolib-filename) to w600-message-2
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s016-read-next-macrolib.
    *> -------------------------------------------------------------------------
    *>  Read the next record from the Macro Library file.
    *> -------------------------------------------------------------------------

    read macrolib next end-read

    evaluate true

      when w500-success
        set w900-more-macrolib to true

      when w500-end-of-file
        set w900-end-of-macrolib to true

      when other
        move "s016-read-next-macrolib" to w600-sub-location
        move "Unable to read a record from Macro Library." to w600-message
        move trim(w501-macrolib-filename) to w600-message-2
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s017-write-macrolib.
    *> -------------------------------------------------------------------------
    *>  Write a record to the Macro Library file.
    *> -------------------------------------------------------------------------

    write macrolib-record end-write

    if not w500-success then
      move "s017-write-macrolib" to w600-sub-location
      move "Unable to write a record to Macro Library." to w600-message
      move trim(w501-macrolib-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s018-close-macrolib.
    *> -------------------------------------------------------------------------
    *>  Close the Macro Library file.
    *> -------------------------------------------------------------------------

    close macrolib

    if not w500-success then
      move "s018-close-macrolib" to w600-sub-location
      move "Unable to close MacroLibrary." to w600-message
      move trim(w501-macrolib-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s019-open-read-incfile.
    *> -------------------------------------------------------------------------
    *>  Open the $INCLUDE file and read the first record.
    *> -------------------------------------------------------------------------

    open input incfile

    if not w500-success then
      move "s019-open-read-incfile" to w600-sub-location
      move "Unable to open $INCLUDE file." to w600-message
      move trim(w501-incfile-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if

    perform s020-read-incfile
    .

  s020-read-incfile.
    *> -------------------------------------------------------------------------
    *>  Read the next record from the $INCLUDE file.
    *> -------------------------------------------------------------------------

    read incfile end-read

    evaluate true

      when w500-success
        set w900-more-incfile to true

      when w500-end-of-file
        set w900-end-of-incfile to true

      when other
        move "s020-read-incfile" to w600-sub-location
        move "Unable to read a record from $INCLUDE file." to w600-message
        move trim(w501-incfile-filename) to w600-message-2
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s021-close-incfile.
    *> -------------------------------------------------------------------------
    *>  Close the $INCLUDE file.
    *> -------------------------------------------------------------------------

    close incfile

    if not w500-success then
      move "s021-close-incfile" to w600-sub-location
      move "Unable to close $INCLUDE file." to w600-message
      move trim(w501-incfile-filename) to w600-message-2
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s022-delete-workfiles.
    *> -------------------------------------------------------------------------
    *>  Delete the work workfiles.
    *> -------------------------------------------------------------------------

    call "C$DELETE" using w501-workin-filename, 0 end-call
    call "C$DELETE" using w501-workout-filename, 0 end-call
    call "C$DELETE" using w501-macrolib-filename, 0 end-call
    .

  s023-swop-work-file-assignments.
    *> -------------------------------------------------------------------------
    *>  Swop the Work Input and Work Output file assignments.
    *> -------------------------------------------------------------------------

    move w502-work-file-one to w502-work-file-swap
    move w502-work-file-two to w502-work-file-one
    move w502-work-file-swap to w502-work-file-two
    move spaces to w502-work-file-swap
    .

  s024-preprocessor-command.
    *> -------------------------------------------------------------------------
    *>  Change the default characters used in the macro definitions and names.
    *> -------------------------------------------------------------------------

    move trim(workin-record) to workin-record

    move spaces to w611-new-preprocessor-parms
    unstring workin-record delimited by space or "=" or ","
      into
        w611-not-used-1
        w611-parameter-1 w611-subparameter-1
        w611-parameter-2 w611-subparameter-2
        w611-parameter-3 w611-subparameter-3
        w611-not-used-2
    end-unstring

    evaluate true

      when trim(lower-case(w611-parameter-1)) = "keychar"
        move trim(w611-subparameter-1) to w608-keychar

      when trim(lower-case(w611-parameter-2)) = "keychar"
        move trim(w611-subparameter-2) to w608-keychar

      when trim(lower-case(w611-parameter-3)) = "keychar"
        move trim(w611-subparameter-3) to w608-keychar

      when trim(lower-case(w611-parameter-1)) = "parmchar"
        move trim(w611-subparameter-1) to w608-parmchar

      when trim(lower-case(w611-parameter-2)) = "parmchar"
        move trim(w611-subparameter-2) to w608-parmchar

      when trim(lower-case(w611-parameter-3)) = "parmchar"
        move trim(w611-subparameter-3) to w608-parmchar

      when trim(lower-case(w611-parameter-1)) = "delimiter"
        move trim(w611-subparameter-1) to w608-delimiter

      when trim(lower-case(w611-parameter-2)) = "delimiter"
        move trim(w611-subparameter-2) to w608-delimiter

      when trim(lower-case(w611-parameter-3)) = "delimiter"
        move trim(w611-subparameter-3) to w608-delimiter

    end-evaluate

>>D display "-- debug:   keychar = [" w608-keychar "] parmchar = [" w608-parmchar "] delimiter = [" w608-delimiter "]" upon stderr end-display
    .

  s025-open-read-macrostd.
    *> -------------------------------------------------------------------------
    *>  Open the Standard Macros file and read the first record.
    *> -------------------------------------------------------------------------

    open input macrostd

    evaluate true

      when w500-success
        perform s026-read-macrostd

      when w500-success-optional
        set w900-end-of-macrostd to true

      when other
        move "s025-open-read-macrostd" to w600-sub-location
        move "Unable to open Standard Input." to w600-message
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s026-read-macrostd.
    *> -------------------------------------------------------------------------
    *>  Read the next record from the Standard Macros file.
    *> -------------------------------------------------------------------------

    read macrostd end-read

    evaluate true

      when w500-success
        set w900-more-macrostd to true

      when w500-end-of-file
        set w900-end-of-macrostd to true

      when other
        move "s026-read-macrostd" to w600-sub-location
        move "Unable to read a record from Standard Macros." to w600-message
        perform s000-set-file-error-status
        perform z999-abort

    end-evaluate
    .

  s027-close-macrostd.
    *> -------------------------------------------------------------------------
    *>  Close the Standard Macros file.
    *> -------------------------------------------------------------------------

    close macrostd

    if not w500-success then
      move "s027-close-macrostd" to w600-sub-location
      move "Unable to close Standard Macros." to w600-message
      perform s000-set-file-error-status
      perform z999-abort
    end-if
    .

  s028-check-for-unsupported-cmd.
    *> -------------------------------------------------------------------------
    *>  Check if we have found an unsupported HP compiler command.
    *> -------------------------------------------------------------------------

    if instr(w602-temp-record, "$if") > zero
    or instr(w602-temp-record, "$set") > zero
    or instr(w602-temp-record, "$page") > zero
    or instr(w602-temp-record, "$title") > zero
    or instr(w602-temp-record, "$control") > zero
    or instr(w602-temp-record, "$version") > zero
    or instr(w602-temp-record, "$copyright") > zero then
      set w914-unsupported-cmd to true
    else
      set w914-supported-cmd to true
    end-if
    .

*> End of Internal Subroutines.
*> *****************************************************************************

end program cobolmac.

*> *****************************************************************************
*> Start of Functions.

identification division.

  function-id.                         instr.

*> -----------------------------------------------------------------------------
*> Purpose:          An InStr function in COBOL for COBOL.
*>
*> Usage:            found-pos = instr(source-str, search-str)
*>
*> Parameters:
*>   source-str      The string to be searched starting at character 1.
*>   search-str      The string to search for.
*>
*> Returns:
*>   found-pos       The char position in source-str where search-str starts.
*>                   Returns zero if search-str is not found.
*>
*> Notes:            Before the search is started the following is done:
*>                   1) Trailing spaces removed from source string.
*>                   2) Leading and trailing spaces removed from search string.
*>                   3) Source and search strings are case downshifted.
*> -----------------------------------------------------------------------------

environment division.

  configuration section.

    repository.
      function all intrinsic.

data division.

  working-storage section.
    01  source-lstr                    pic x(256).
    01  source-length                  pic s9(04) comp.
    01  search-lstr                    pic x(256).
    01  search-length                  pic s9(04) comp.
    01  start-index                    pic s9(04) comp value zero.
    01  stop-index                     pic s9(04) comp value zero.

  linkage section.
    01  source-str                     pic x(001) any length.
    01  search-str                     pic x(001) any length.
    01  found-pos                      pic s9(04) comp.

procedure division using source-str, search-str returning found-pos.

  instr-mainline.

    *> Downshift the source and search strings and get their lengths.

    move lower-case(source-str) to source-lstr
    move length(trim(source-lstr, trailing)) to source-length
    move lower-case(search-str) to search-lstr
    move length(trim(search-lstr)) to search-length

    *> Return zero if search string longer than source string.

    if search-length > source-length then
      move zero to found-pos
      goback
    end-if

    *> Return one if the search and source strings are the same.

    if trim(search-lstr) = trim(source-lstr) then
      move 1 to found-pos
      goback
    end-if

    *> Calculate where the stop index is (stops us getting a bounds violation).

    compute stop-index
      = (source-length - search-length) + 1
    end-compute

    *> Loop until we find the search string or we hit the stop index.

    perform
      varying start-index from 1 by 1
      until (source-lstr(start-index:search-length) = search-lstr(1:search-length))
         or (start-index = stop-index)

      *> Nothing to do here as it's all done in the perform statement.

    end-perform

    *> If we've found the search string then return where.

    if start-index < stop-index then
      move start-index to found-pos
      goback
    end-if

    *> If we get here then the search string was not found.

    move zero to found-pos
    goback
    .

end function instr.

*> End of source code.
*> *****************************************************************************
