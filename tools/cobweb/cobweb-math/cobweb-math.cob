GCobol >>SOURCE FORMAT IS FREE
>>IF docpass NOT DEFINED
      *> ***************************************************************
      *>****J* gnucobol/cobweb-math
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20160721  Modified: 2016-07-23/17:09-0400
      *> LICENSE
      *>   Copyright 2016 Brian Tiffin
      *>   GNU Lesser General Public License, LGPL, 3.0 (or superior)
      *> PURPOSE
      *>   Runtime defined mathematical equation evaluation
      *> TECTONICS
      *>   cobc -b cobweb-math.cob wrapmath.c -lmatheval -lreadline
      *> ***************************************************************
       identification division.
       program-id. cobweb-math.
       author. Brian Tiffin.
       date-written. 2016-07-15/10:20-0400.
       date-modified. 2016-07-23/17:09-0400.
       date-compiled.
       installation.
       remarks.
       security.

       environment division.
       configuration section.
       source-computer. gnulinux.
       object-computer. gnulinux
           classification is canadian.

       special-names.
           locale canadian is "en_CA.UTF-8".

       repository.
           function evaluate-math
           function create-equation
           function evaluate-equation
           function destroy-equation
           function evaluate-x
           function all intrinsic.

       data division.
       working-storage section.

       REPLACE ==:EVALUATOR-RECORD:== BY ==
       01 evaluator-record.
          05 evaluator         usage pointer.
          05 evaluator-image   usage pointer.
          05 evaluator-prime   usage pointer.
          05 prime-image       usage pointer.
          05 variable-names    usage pointer.
          05 variable-count    usage binary-long.
       ==.
       :EVALUATOR-RECORD:

       01 NAME-LIMIT           constant as 16.
       01 name-list            based.               
          05 variable-name     usage pointer occurs NAME-LIMIT times.
       01 value-list.
          05 variable-value    usage float-long occurs NAME-LIMIT times.
       01 answer               usage float-long.

       01 cli                  pic x(80).
          88 helping               values "help", "-help", "--help".
          88 demoing               value "demo".
          88 calcing               value "calc".
          88 repoing               values "repository", "repo".

       01 command-ptr          usage pointer.
       01 command-buf          pic x(80) based.
       01 command              pic x(80).
          88 quitting              values "q", "quit".
          88 replhelp              values "h", "help".
       01 last-command         pic x(80).

       01 variable             pic x(80).
          88 setting               values "X", "x".
       01 the-number           pic x(80).
          88 want-answer           values "ans".
       01 got-equal            pic x.

       01 calculation.
          05 value "(1 + 2 * 3 / 4 - 5)^3".
       01 equation.
          05 value "x^4 + sin(x^2) + 2*x^y + 42".
       01 x                    usage float-long value 1.0.
       01 y                    usage float-long value 1.0.
       01 ans                  usage float-long.

       01 extraneous           usage binary-long.

      *> ***************************************************************
       procedure division.
       accept cli from command-line
       if helping then
           display "cobweb-math: enter equations and get numbers"
           display "options include: help, demo, repository, [calc]"
           goback
       end-if
      
       if repoing then
           display "       *> Repository for cobweb-math"
           display "           function create-equation"
           display "           function evaluate-equation"
           display "           function destroy-equation"
           display "           function evaluate-x"
           display "           function evaluate-x-y"
           display "           function evaluate-x-y-z"
           goback
       end-if

       if demoing then
           *> simple math
           display "cobweb-math internal demo"
           display calculation " = " evaluate-math(calculation)
           display evaluate-math("5 +")
           display space

           *> two variable equation, with derivative 
           move create-equation(equation, "derivative, variables")
             to evaluator-record

           display "Given: " equation
           if evaluator-image not equal null then
               call "printf" using 
                   by content "seen as :%s: " & x"0a00"
                   by value evaluator-image
               end-call
           end-if

           display variable-count " variables in equation"
           if variable-names not equal null then
               set address of name-list to variable-names
               display "    " with no advancing
               perform varying tally from 1 by 1 until
                   tally > variable-count
                   call "printf" using
                       by content z"%s "
                       by value variable-name(tally)
               end-perform
               display space
           end-if
           if prime-image not equal null then
               call "printf" using 
                   by content "with derivative :%s: " & x"0a00"
                   by value prime-image
               end-call
           end-if

           move 2.0 to variable-value(1)
           move 8.0 to variable-value(2)
           move evaluate-equation(evaluator, variable-count,
                                  variable-names, value-list) to answer 
           display "f(" variable-value(1) ", " variable-value(2)
                   ")  = " answer

           move evaluate-equation(evaluator-prime, variable-count,
                                  variable-names, value-list) to answer 
           display "f'(" variable-value(1) ", " variable-value(2)
                   ") = " answer

           move 0 to return-code
           goback
       end-if

      *> throw up a little REPL, setting variable syntax is ... basic
       display "REPL: x = number (or ans) or equation in relation to x"
       display "  (using x is optional, basic math is ok too)" 
       perform until exit
           call "readline" using z"> " returning command-ptr
           if command-ptr equal null then exit perform end-if

           move spaces to command
           set address of command-buf to command-ptr
           string command-buf delimited by low-value into command
           move lower-case(trim(command)) to command
           if quitting then exit perform end-if

           if command not equal spaces and last-command then
               move command to last-command
               call "add_history" using by value command-ptr
           end-if
           if replhelp then
               display "libmatheval supports: "
               display "  Constants:"
               display "    e, log2e, log10e, ln2, ln10, pi, pi_2,"
               display "    pi_4, 1_pi, 2_pi, 2_sqrtpi, sqrt2, sqrt1_2"
               display "  Elementary Functions:"
               display "    exp(x), log, sqrt, sin, cos, tan, cot, sec,"
               display "    csc, acsc, sinh, cosh, tanh, coth, sech,"
               display "    csch, asinh, acosh, atanh, acoth, asech,"
               display "    acsch. abs, step, delta, nandelta, erf"
               display "  Basic arthimetic:"
               display "    - (negation), +, -, * , /, ^, (, )"
               display "  This repl only uses one optional variable, x"
               display "  x = ans           to put current result in x"
               display "  q to quit"
               exit perform cycle
           end-if
           unstring command delimited by "="
               into variable delimiter in got-equal
                    the-number
           end-unstring

           if setting and (got-equal equal "=") then
               move lower-case(trim(the-number)) to the-number
               if want-answer then
                   move ans to x
               else
                   move numval(the-number) to x
                   move x to ans
               end-if
           else 
               move create-equation(command, "") to evaluator-record
               move evaluate-x(evaluator, x) to ans
               move destroy-equation(evaluator-record) to extraneous
           end-if
           display space ans

       end-perform

       move 0 to return-code
       goback.

      *> ***************************************************************

       REPLACE ALSO ==:EXCEPTION-HANDLERS:== BY
       ==
      *> informational warnings and abends
       soft-exception.
         display space upon syserr
         display "--Exception Report-- " upon syserr
         display "Time of exception:   " current-date upon syserr
         display "Module:              " module-id upon syserr
         display "Module-path:         " module-path upon syserr
         display "Module-source:       " module-source upon syserr
         display "Exception-file:      " exception-file upon syserr
         display "Exception-status:    " exception-status upon syserr
         display "Exception-location:  " exception-location upon syserr
         display "Exception-statement: " exception-statement upon syserr
       .

       hard-exception.
           perform soft-exception
           stop run returning 127
       .
       ==.

       :EXCEPTION-HANDLERS:

       end program cobweb-math.
      *> ***************************************************************
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/create-equation
       identification division.
       function-id. create-equation.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 option-mod           pic x(10).
          88 make-derivative       value 'derivative'.
          88 get-names             value 'variables'.
       01 option-scanner       usage binary-long.

       linkage section.
       01 equation             pic x any length.
       01 requested-options    pic x any length.
       :EVALUATOR-RECORD:

       procedure division using equation requested-options
           returning evaluator-record.

      *> compile given equation
       call "evaluator_create" using
           by content concatenate(trim(equation), x"00")
           returning evaluator
           on exception
               display "error: cannot initialize evaluator (-lmatheval)"
                  upon syserr
               perform soft-exception
               goback
       end-call
       if evaluator equal null then
           display "error: could not define " trim(equation)
              upon syserr
           goback
       end-if
      
      *> get the evaluator view of the equation
       call "evaluator_get_string" using
           by value evaluator
           returning evaluator-image
       end-call

      *> loop over any options
       move 1 to option-scanner       
       perform until option-scanner > length(requested-options)

           unstring requested-options delimited by ","
               into option-mod
               with pointer option-scanner
           end-unstring
           move lower-case(trim(option-mod)) to option-mod

      *> let matheval create the first derivative (of x) from equation
           if make-derivative then
               call "evaluator_derivative_x" using
                   by value evaluator
                   returning evaluator-prime
               end-call

               call "evaluator_get_string" using
                   by value evaluator-prime
                   returning prime-image
               end-call
           end-if
       
      *> query matheval for the names used inside the equation
           if get-names then
               call "evaluator_get_variables" using
                   by value evaluator
                   by reference variable-names
                   by reference variable-count
                   returning omitted
               end-call
           end-if
       end-perform

       goback.

       :EXCEPTION-HANDLERS:

       end function create-equation.
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/destroy-equation
       identification division.
       function-id. destroy-equation.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
       :EVALUATOR-RECORD:
       01 extraneous           usage binary-long.
       
       procedure division using evaluator-record
           returning extraneous.

      *> destroy evaluator(s)
      *> free up library resources
       if evaluator not equal null then
           call "evaluator_destroy" using
               by value evaluator
               returning omitted
           end-call
       end-if
       if evaluator-prime not equal null then
           call "evaluator_destroy" using
               by value evaluator-prime
               returning omitted
           end-call
       end-if

       move 0 to extraneous
       goback.

       end function destroy-equation.
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/evaluation-equation
       identification division.
       function-id. evaluate-equation.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 answer               usage float-long.
       01 NAME-LIMIT           constant as 16.

       linkage section.
       01 given-evaluator      usage pointer.
       01 given-count          usage binary-long.
       01 given-names          usage pointer.
       01 given-values.
          05 variable-value    usage float-long occurs NAME-LIMIT times.
       01 result               usage float-long.

       :EVALUATOR-RECORD:

       procedure division using
           given-evaluator given-count given-names given-values
           returning result.

      *> compile given equation
       call "evaluate_function" using
           by value given-evaluator
           by value given-count
           by value given-names
           by reference given-values
           by reference answer
       end-call

       move answer to result
       goback.

       :EXCEPTION-HANDLERS:

       end function evaluate-equation.
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/evaluate-math
       identification division.
       function-id. evaluate-math.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 ans                  usage float-long.
       01 x                    usage float-long value 0.0.

       :EVALUATOR-RECORD:

       linkage section.
       01 calculation          pic x any length.
       01 result               usage float-long.

       procedure division using calculation returning result.

      *> compile given equation
       call "evaluator_create" using
           by content concatenate(trim(calculation), x"00")
           returning evaluator
           on exception
               display "error: cannot initialize evaluator (-lmatheval)"
                  upon syserr
               perform soft-exception
               goback
       end-call
       if evaluator equal null then
           display "error: could not compute " trim(calculation)
              upon syserr
           goback
       else
          *> x is actually unused
           call "evaluate_x" using
              by value evaluator
              by value x
              by reference ans
           end-call
       end-if

      *> free up library resources
       if evaluator not equal null then
           call "evaluator_destroy" using
               by value evaluator
               returning omitted
           end-call
       end-if

       move ans to result
       goback.

       :EXCEPTION-HANDLERS:

       end function evaluate-math.
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/evaluate-x
       identification division.
       function-id. evaluate-x.

       data division.
       working-storage section.
       01 ans                  usage float-long.

       linkage section.
       01 given-evaluator      usage pointer.
       01 x                    usage float-long.
       01 result               usage float-long.

       procedure division using given-evaluator x returning result.

       if given-evaluator not equal null then
           call "evaluate_x" using
              by value given-evaluator
              by value x
              by reference ans
           end-call
       else
           display "error: invalid evaluator" upon syserr
       end-if

       move ans to result
       goback.
       end function evaluate-x.
      *>****
      
      *> ***************************************************************
      *>****F* cobweb-math/evaluate-xy
       identification division.
       function-id. evaluate-xy.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 ans                  usage float-long.

       linkage section.
       01 given-evaluator      usage pointer.
       01 x                    usage float-long.
       01 y                    usage float-long.
       01 result               usage float-long.

       procedure division using given-evaluator x y returning result.

       if given-evaluator not equal null then
           call "evaluate_xy" using
              by value given-evaluator
              by value x y
              by reference ans
           end-call
       else
           display "error: invalid evaluator" upon syserr
       end-if

       move ans to result
       goback.
       end function evaluate-xy.
      *>****

      *> ***************************************************************
      *>****F* cobweb-math/evaluate-xyz
       identification division.
       function-id. evaluate-xyz.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 ans                  usage float-long.

       linkage section.
       01 given-evaluator      usage pointer.
       01 x                    usage float-long.
       01 y                    usage float-long.
       01 z                    usage float-long.
       01 result               usage float-long.

       procedure division using given-evaluator x y z returning result.

       if given-evaluator not equal null then
           call "evaluate_xyz" using
              by value given-evaluator
              by value x y z
              by reference ans
           end-call
       else
           display "error: invalid evaluator" upon syserr
       end-if

       move ans to result
       goback.
       end function evaluate-xyz.
      *>****
>>ELSE
!doc-marker!
===========
cobweb-math
===========

.. contents::

Introduction
------------

cobweb-math, a mathematical equation evaluator

Accepts equations from a character field and a table of variable values
and creates an evaluator, using ``libmatheval`` a GNU project.

The basic user function repository wraps ``libmatheval`` for *somewhat*
easy use from GnuCOBOL programs.

Inputs and return values are ``float-long`` (C ``double``) type.

Repository
..........

Functions include:

- create-equation(equation, "options") to evaluator-record
- evaluate-equation(evaluator, variable-count, names, values) to answer
- destroy-equation(evaluator-record) to extraneous

Options to ``create-equation`` include *derivative* and *variables* and
can be used to create a first order derivative from the equation and/or
return the list of variable names used in the equation.  Upto 16 named
variables are supported by ``cobweb-math``.  Options are passed as a
character field, separated by commas.

Values are held in a table of ``float-long``, upto 16, corresponding to
the names used, first name encounterd in the equation is 1, next is 2,
and so on.  Convenience functions exist for equations that use

``x``, ``y``, and ``z`` as the variable names. 

Convenience functions include:

- evaluate-math(calculation) to answer  (for use as a calculator)
- evaluate-x(evaluator, x) to answer
- evaluate-xy(evaluator, x, y) to answer
- evaluate-xyz(evaluator, x, y, z) to answer

Copybook
........
There is a small ``cobweb-math.cpy`` copybook that ships with
``cobweb-math``, that defines the structure of the ``evaluator-record``.

It requires a working storage name prefix change before use.

.. sourcecode:: cobolfree

    COPY cobweb-math REPLACING ==:tag:== BY ==user-prefix==.

Where ``user-prefix`` is developer choice.

libmatheval
...........

The GNU ``libmatheval`` library supports:

- Constants:
    - e, log2e, log10e, ln2, ln10, pi, pi_2,
    - pi_4, 1_pi, 2_pi, 2_sqrtpi, sqrt2, sqrt1_2

- Elementary Functions:
    - exp(x), log, sqrt, sin, cos, tan, cot, sec
    - csc, acsc, sinh, cosh, tanh, coth, sech
    - csch, asinh, acosh, atanh, acoth, asech
    - acsch. abs, step, delta, nandelta, erf
- Basic arthimetic:
    - (negation), +, -, * , /, ^, (, and )


Tectonics
---------

Requires:

``libmatheval``, ``libmatheval-dev``,
``libreadline`` and ``libreadline-dev`` 

::

    prompt$ cobc -bd cobweb-math.cob wrapmath.c -lmatheval -lreadline
    prompt$ cobc -x user-program.cob -l:cobweb-math.so -L.


Usage
-----

::

    prompt$ cobcrun cobweb-math help|demo|repository|[calc]

``calc`` is the default top level option, and will display a small
calculator Read-Evaluate-Print-Loop, suitable for basic math or single
variable equations.  The only supported variable for the small ``calc``
engine is ``x``.

See cobweb-math-demo.cob_ for an example.  And the ``calc``
engine inside ``cobweb-math.cob`` itself for more usage hints.

Source
------

Makefile
........

.. include:: Makefile
   :code: make

cobweb-math.cob
...............

.. include:: cobweb-math.cob
   :code: cobolfree

cobweb-math.cpy
...............

.. include:: cobweb-math.cpy
   :code: cobolfree

wrapmath.c
..........

.. include:: wrapmath.c
   :code: c

cobweb-math-demo.cob
....................

.. include:: cobweb-math-demo.cob
   :code: cobolfree

Subject to change, but that produces

.. include:: cobweb-math-demo.out
   :literal:
>>END-IF
