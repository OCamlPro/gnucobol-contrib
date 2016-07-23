cobweb-math
-----------

Evaluation of mathematical equations, given at runtime, using GNU libmatheval.

Defines some GnuCOBOL user defined functions that allow mathematical
expressions to be created and evaluated. Supports automatic computation of the
first order derivative of the given equation.  The library includes a small
read-evaluate-print-loop for quick calculations, but it is really meant to
provide a little bit of end-user application programmability. 

    prompt$ cobcrun cobweb-math
    REPL: x = number (or ans) or equation in relation to x
      (using x is optional, basic math is ok too)
    > 6 * 7
     42
    > x
     1
    > sin(x)
     0.8414709848078965
    > x = 23
     23
    > x^5 + x*5 - 42
     6436416
    > x = 42
     42
    > x ^ 5
     130691232
    > x = ans
     130691232
    > x + 1 / 3
     130691232.3333333
    > (x + 1) / 3
     43563744.33333334
    > quit    

See cobweb-math.html for more details.
