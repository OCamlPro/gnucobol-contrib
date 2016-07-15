The game of 24
==============

By Steve Williams, as seen on Rosetta Code

http://rosettacode.org/wiki/24_game#COBOL

    prompt$ cobc -x twentyfour.cob
    prompt$ ./twentyfour

    start twentyfour
    
    numbers: 3 9 1 5
    type h <enter> to see instructions

    h
    1)  Type h <enter> to repeat these instructions.
    2)  The program will display four randomly-generated
        single-digit numbers and will then prompt you to enter
        an arithmetic expression followed by <enter> to sum
        the given numbers to 24.
        The four numbers may contain duplicates and the entered
        expression must reference all the generated numbers and duplicates.
        Warning:  the program converts the entered infix expression
        to a reverse polish notation (rpn) expression
        which is then interpreted from RIGHT to LEFT.
        So, for instance, 8*4 - 5 - 3 will not sum to 24.
    3)  Type n <enter> to generate a new set of four numbers.
        The program will ensure the generated numbers are solvable.
    4)  Type m#### <enter> (e.g. m1234) to create a fixed set of numbers
        for testing purposes.
        The program will test the solvability of the entered numbers.
        For example, m1234 is solvable and m9999 is not solvable.
    5)  Type d0, d1, d2 or d3 followed by <enter> to display none or
        increasingly detailed diagnostic information as the program evaluates
        the entered expression.
    6)  Type e <enter> to see a list of example expressions and results
    7)  Type <enter> or q <enter> to exit the program
    instruction?

Have some fun exercising your math skills.
