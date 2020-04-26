Introduction:
-------------
This example shows you how to allocate shared memory, which can also be 
read and written in child processes. The following functions are 
used: mmap, munmap, CBL_OC_HOSTED, CBL_GC_FORK, CBL_GC_WAITPID. These functions
will only run on a posix system. (It was tested on cygwin and on Debian.)


Sources:
--------
testmmul.cob                - main program
mmul.cob                    - modular multiplication module
Makefile                    - make file for cygwin
readme.txt                  - this file
copy_files/z-constants.cpy  - copy file for constants


What does it do?
----------------
The main program testmmul.cob allocates the shared memory. Four arrays are 
defined and the shared memory allocated to them: A, B, C and P. Test data are 
filled in A, B and P. After calling the mmul.cob module, the result is checked 
in C and the shared memory deallocated with the munmap function.

The module mmul.cob calculates the following modular multiplication: 
C(i) = (A(i) * B(i)) mod P(i).

This will not proceed linearly, but several children's processes will be 
created. Each process works in a defined area. These are controlled with a start
and end index. The number of child processes can be set with the 
C-MAX-NUM-CHILD-PID constant in the COPY file. The start and end index are 
calculated automatically depending on the C-MAX-NUM-CHILD-PID.


Performance test:
-----------------
The following measurement was made with:
- HP laptop with 2 core 4 logical processors 
- Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz 2.90 GHz
- RAM: 16,0 GB
- Windows 10 Pro, 64-Bit
- cygwin (64 bit)
- cobc (GnuCOBOL) 3.1-dev.0; Aug 17 2019 17:12:47


Time in sec. 
20+
  |
  |
  |
  |**
15+ 
  |
  |                                                                          *    *
  |                                                           *    *    *
  |  *                                    *    *    *    *
10+                          *************     
  |   *    ******************
  |    ****
  |
  |
 5+
  |
  |
  |
  |                                                       
 0+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
  0    5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80
                           Number of child processes (parameter C-MAX-NUM-CHILD-PID)


You can see that it has a minimum time between 5 and 8. It is very likely 
because this laptop has 4 logical processors. 



================================================================================
Appendix about the modular arithmetic
================================================================================
If you want to know more about the modular arithmetic, here are a few key words
you can search for:
- Chinese remainder theorem
- Modular arithmetic
- RNS: Residue number system
- Mixed radix number system

Only briefly, all numbers can be represented with their residue. If we have this
represantion, then we can make parallel calculations with the residue. And at 
the end we convert the result back into the decimal number system. The advantage
is not only the parallelism, but the residues are always small numbers that fit
in the register of the processor.

Example:
Let the moduli system 4, 3, 5, 11.

Convert 21, 25 and 525 in RNS system. That means, calculate the residues.

21 mod  4 =  1      25 mod  4 =  1      525 mod  4 =  1
21 mod  3 =  0      25 mod  3 =  1      525 mod  3 =  0
21 mod  5 =  1      25 mod  5 =  0      525 mod  5 =  0
21 mod 11 = 10      25 mod 11 =  3      525 mod 11 =  8

The RNS representations with the residues:

 21 <--> { 1,  0,  1, 10}   
 25 <--> { 1,  1,  0,  3}
525 <--> { 1,  0,  0,  8}

Now we multiply 21 with 25: 21 * 25 = 525.

We can get the same result, if we use the RNS representations. But after the 
multiplication we have to calculate the "mod" with the moduli.  

In this example:

21 * 25
--------
 1 *  1 mod  4 = 1 
 0 *  1 mod  3 = 0
 1 *  0 mod  5 = 0
10 *  3 mod 11 = 8


  21 <--> { 1,  0,  1, 10}    You can see here that the residues can be
* 25 <--> { 1,  1,  0,  3}    multiplied in parallel.
--------------------------
 525 <--> { 1,  0,  0,  8}


Addition and subtraction works similar parallel, but the division is not so easy.


Bibliography and references:
----------------------------
There are only few books on this subject and there are a lot of secrets
because fast calculations and parallelism are very important in cryptography.
In Ananda's book there is a chapter: "RNS in Cryptography".

- N.S. Szabo, R.I. Tanaka: Residue Arithmetic and Its Applications to Computer 
  Technology. ISBN-13: 978-0070626591; McGraw-Hill Inc.,US (Dezember 1967)
  
- Knuth, D: Art of Computer Programming, Volume 2. ISBN-13: 978-0201896848;
  Prentice Hall; Chapter 4, 4.3.2 Modular Arithmetic (about 10 pages).

- P.V. Ananda Mohan: Residue Number Systems: Theory and Applications.
  ISBN-13: 978-3319413839; Birkhäuser; 2016 
