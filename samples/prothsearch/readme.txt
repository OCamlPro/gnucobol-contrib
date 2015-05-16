Program:      prothsearch.cob
Purpose:      This is a primality test for Proth numbers
Date-Written: 2015.05.14 
Author:       Laszlo Erdos - https://www.facebook.com/wortfee
================================================================================

Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

Introduction
============
This sample program demonstrates the usage of the GMP library (GNU Multiple 
Precision Arithmetic Library) with GnuCOBOL. GnuCOBOL uses the GMP
library, therefore this library is always present. You can also call the 
functions from the GMP library directly from your GnuCOBOL program. For example
you can call the cryptographic functions from the GMP library. [Ref. 1.]

What does it do?
----------------
This program implements a primality test for Proth numbers. With prothsearch.cob
you can search for really large prime numbers. (Please let me know if you found
a large prime number with this program!)

THE LARGEST KNOWN PRIMES (on Sat May 16 02:20:59 CDT 2015):
-----  ------------------------------- -------- ----- ---- --------------
 rank  description                     digits   who   year comment
-----  ------------------------------- -------- ----- ---- --------------
    1  2^57885161-1                    17425170 G13   2013 Mersenne 48??
    2  2^43112609-1                    12978189 G10   2008 Mersenne 47??
    3  2^42643801-1                    12837064 G12   2009 Mersenne 46??
    4  2^37156667-1                    11185272 G11   2008 Mersenne 45?
    5  2^32582657-1                     9808358 G9    2006 Mersenne 44
    6  2^30402457-1                     9152052 G9    2005 Mersenne 43
    7  2^25964951-1                     7816230 G8    2005 Mersenne 42
    8  2^24036583-1                     7235733 G7    2004 Mersenne 41
    9  2^20996011-1                     6320430 G6    2003 Mersenne 40
   10  2^13466917-1                     4053946 G5    2001 Mersenne 39
   11  19249*2^13018586+1               3918990 SB10  2007 

Presently the 11th largest known prime is a Proth prime. [Ref. 2.]   
Remember, there were only a few Mersenne primes, but a lot of Proth primes found
yet. For a full list of Proth primes see the "Proth Search Page" Project. 
[Ref. 3.]

With prothsearch.cob you can participate in the EFF Awards:

Through the EFF Cooperative Computing Awards, EFF will confer prizes of:
- $150,000 to the first individual or group who discovers a prime number
  with at least 100,000,000 decimal digits.
- $250,000 to the first individual or group who discovers a prime number
  with at least 1,000,000,000 decimal digits.
Prize money comes from a special donation provided by an individual EFF
supporter, earmarked specifically for this project. [Ref. 4.]

Mathematical theory
-------------------
In number theory, Proth's theorem is a primality test for Proth numbers.
It states that if "p" is a Proth number, of the form k*2^n + 1 with k odd and 
k < 2^n, and if there exists an integer "a" for which

   a^((p - 1) / 2) congruence -1 modulo p

then p is prime. [Ref. 5.]

In this case "p" is called a Proth prime. This is a practical test because if 
"p" is prime, any chosen "a" has about a 50 percent chance of working.

If "a" is a quadratic non-residue modulo "p" then the converse is also true,
and the test is conclusive. Such an "a" may be found by iterating "a" over small
primes and computing the Jacobi symbol until:

   (a / p) = -1

The primality testing algorithm based on Proth's theorem is a Las Vegas 
algorithm, always returning the correct answer but with a running time that
varies randomly. [Ref. 6.]

Algorithm in prothtest.cob module (pseudo code)
-----------------------------------------------
The following algorithm was implemented in the prothtest.cob module for testing
a Proth number for primality. 

Input parameters are K and N. (Type BINARY-LONG UNSIGNED)

1. If K is not odd, then set result V-K-NOT-ODD, return.
2. Compare: k < 2^n. If not, then set result V-K-GE-2-POWER-N, return.
3. Compute the Proth number: k*2^n + 1.
4. Compute (p - 1) / 2, where "p" is the Proth number. (This will be used in
   step 7.)
5. Compute the Jacobi symbol (a/p), "a" stands for a small prime, and "p" is the
   Proth number. Iterate "a" through the first 25 small prime numbers. If the
   Jacobi symbol (a/p) = -1, then break and save "a". If we ran out of small 
   primes, then set result V-NO-JACOBI-FOUND, return. (In this case the Proth
   number is maybe prime.)
6. Do a primitive division pre check. Divide the Proth number with the first
   20.000 small prime numbers. If the Proth number is exactly divisible, then
   set result V-PRIME-NO, return. (In this case the Proth number is definitively
   no prime.)
7. With the GMP mpz_powm() function compute the congruence:
   a^((p - 1) / 2) modulo p, "a" stands for the small Jacobi prime from step 5,
   "p" is the Proth number from step 3, and the value (p - 1) / 2 from step 4.
   If the congruence = -1, then set result V-PRIME-YES, return. (In this case 
   the Proth number is definitively prime.)
   If the congruence does not equal -1, then set result V-NO-RESULT, return. (In 
   this case the Proth number is maybe prime.)
   
Remember that the step 7 (the GMP mpz_powm() function) is the bottleneck in this
algorithm. It can take a lot of time for large numbers. Suggestion: if you have
only one computer to test a large number, then you can run the prothsearch 
program in a VM (virtual machine). Before you turn off your computer, suspend 
the VM, and later can you without restart continue the program. The program will
however not run as fast as on real hardware.

Additionally there are two input parameters for the prothtest.cob module:
- If the parameter V-PRECHECK-ONLY-YES is set, then only the steps from 1 to 6
  will be done. You can then select a right number for a later full test.
- If the parameter V-WRITE-FILE-YES is set, then a sub directory will be
  created. If the module found a Proth prime, then this prime number (all 
  digits) will be written in a file in the sub directory.   

The prothtest.cob module gives back the following information:
- The result flag.
- The number of digits in the Proth number.
- The "a" small prime number in the Jacobi symbol (a/p). (Step 5 in the 
  algorithm.)  
- The divisor, if the Proth number is exactly divisible with a small prime
  number. (Step 6 in the algorithm.)
  
Features
--------
- You can test a single Proth number with the parameters -k and -n.
- You can test an interval with the parameters -kmin, -kmax, -nmin, -nmax. 

Test
----
This program was developed using GnuCOBOL 2.0.0. 
Built Jan 19 2015 20:28:46, and Windows 7 (64 bit) running on a HP laptop. 
It was successfully tested: 
- With cygwin (64 bit).
- With MS Visual Studio Express V12 (32 bit). 

Installation and Configuration
==============================

The delivered files:
- prothsearch.cob  - main program (command line parameter processing)
- prothtest.cob    - module       (Proth prime test algorithm)
- smallprimes.cpy  - copy file    (small prime numbers)

Compile with cygwin
-------------------
Use the makefile.

Compile with MS Visual Studio
-----------------------------
Use the batch file win_compile.bat. First change the batch compile file 
according to your environment.

Usage
=====

prothsearch { -k <num> -n <num> [-v] [-wf] [-pre] }
            { -kmin <num> -kmax <num> -nmin <num> -nmax <num> [-v] [-wf] [-pre] }

protsearch is a primality test for Proth numbers

Options:

-k <num> -n <num>       Test one number in the form k*2^n + 1
-kmin <num> -kmax <num> -nmin <num> -nmax <num>
                        Test an intervall
-v,   -verbose          Verbose mode
-wf,  -write-file       Write Proth numbers in files
-pre, -precheck         Only precheck, no powm test


Example 1, one number test:
---------------------------

$ ./prothsearch.exe -k 13 -n 1000

Program start: 2015-05-16:18:39:10.23

K: 0000000013; N: 0000001000; Digits: 0000000303; prime found!!!; Start: 2015-05-16:18:39:10.24; End: 2015-05-16:18:39:10.25

Number of primes: 0000000001

Program end:   2015-05-16:18:39:10.25


Example 2, interval test:
-------------------------

$ ./prothsearch.exe -kmin 3 -kmax 5 -nmin 1000 -nmax 2500

Program start: 2015-05-16:18:42:29.39

K: 0000000003; N: 0000002208; Digits: 0000000666; prime found!!!; Start: 2015-05-16:18:42:33.85; End: 2015-05-16:18:42:33.87
K: 0000000005; N: 0000001947; Digits: 0000000588; prime found!!!; Start: 2015-05-16:18:42:38.08; End: 2015-05-16:18:42:38.09

Number of primes: 0000000002

Program end:   2015-05-16:18:42:40.04


Example 3, interval with verbose test:
--------------------------------------

$ ./prothsearch.exe -kmin 15 -kmax 15 -nmin 6800 -nmax 6810 -v

Program start: 2015-05-16:18:54:48.03

K: 0000000015; N: 0000006800; Digits: 0000002049; maybe prime   ; Jacobi a-num: 0000000007; Divisor: 0000000000; Start: 2015-05-16:18:54:48.03; End: 2015-05-16:18:54:48.23
K: 0000000015; N: 0000006801; Digits: 0000002049; no prime      ; Jacobi a-num: 0000000013; Divisor: 0000000031; Start: 2015-05-16:18:54:48.23; End: 2015-05-16:18:54:48.23
K: 0000000015; N: 0000006802; Digits: 0000002049; no prime      ; Jacobi a-num: 0000000007; Divisor: 0000000019; Start: 2015-05-16:18:54:48.23; End: 2015-05-16:18:54:48.23
K: 0000000015; N: 0000006803; Digits: 0000002050; no prime      ; Jacobi a-num: 0000000007; Divisor: 0000000011; Start: 2015-05-16:18:54:48.23; End: 2015-05-16:18:54:48.23
K: 0000000015; N: 0000006804; Digits: 0000002050; prime found!!!; Jacobi a-num: 0000000011; Divisor: 0000000000; Start: 2015-05-16:18:54:48.23; End: 2015-05-16:18:54:48.42
K: 0000000015; N: 0000006805; Digits: 0000002050; maybe prime   ; Jacobi a-num: 0000000007; Divisor: 0000000000; Start: 2015-05-16:18:54:48.42; End: 2015-05-16:18:54:48.61
K: 0000000015; N: 0000006806; Digits: 0000002051; no prime      ; Jacobi a-num: 0000000007; Divisor: 0000000023; Start: 2015-05-16:18:54:48.61; End: 2015-05-16:18:54:48.61
K: 0000000015; N: 0000006807; Digits: 0000002051; no prime      ; Jacobi a-num: 0000000011; Divisor: 0000000017; Start: 2015-05-16:18:54:48.61; End: 2015-05-16:18:54:48.61
K: 0000000015; N: 0000006808; Digits: 0000002051; maybe prime   ; Jacobi a-num: 0000000007; Divisor: 0000000000; Start: 2015-05-16:18:54:48.61; End: 2015-05-16:18:54:48.81
K: 0000000015; N: 0000006809; Digits: 0000002051; no prime      ; Jacobi a-num: 0000000007; Divisor: 0000000013; Start: 2015-05-16:18:54:48.81; End: 2015-05-16:18:54:48.81
K: 0000000015; N: 0000006810; Digits: 0000002052; maybe prime   ; Jacobi a-num: 0000000017; Divisor: 0000000000; Start: 2015-05-16:18:54:48.81; End: 2015-05-16:18:54:49.00

Number of primes: 0000000001

Program end:   2015-05-16:18:54:49.00


Example 4, interval with write file test:
-----------------------------------------

$ ./prothsearch.exe -kmin 15 -kmax 15 -nmin 6800 -nmax 6810 -wf

Program start: 2015-05-16:18:58:21.62

K: 0000000015; N: 0000006804; Digits: 0000002050; prime found!!!; Start: 2015-05-16:18:58:21.84; End: 2015-05-16:18:58:22.04

Number of primes: 0000000001

Program end:   2015-05-16:18:58:22.62


The sub directory RUN_2015-05-16_18-58-21_62 will be created.
The file K0000000015-N0000006804.txt with the digits of the Proth number 
will be written in the new sub directory.


Example 5, interval with pre check:
-----------------------------------

$ ./prothsearch.exe -kmin 19249 -kmax 19249 -nmin 13018580 -nmax 13018590 -pre

Program start: 2015-05-16:19:18:52.47

K: 0000019249; N: 0013018586; Digits: 0003918990; maybe prime   ; Start: 2015-05-16:19:18:53.87; End: 2015-05-16:19:19:25.18

Program end:   2015-05-16:19:19:26.11


Some measurement results
========================

Testing environment:
- MS Windows 7 Professional (64 bit) 
- HP laptop, Intel(R) Core(TM) i7 M 620 CPU, 2,67 GHz, 8 GB RAM


 K, N                      | cygwin        | Debian in VM  | Visual Studio |        
 number of digits          | 64 bit        | 64 bit        | 32 bit        |
---------------------------|---------------|---------------|---------------|
 K = 13,    N = 28280      | 6 sec         | 16 sec        | 2 min 23 sec  |
 digits = 8515             |               |               |               |
---------------------------|---------------|---------------|---------------|
 K = 3,     N = 213321     | 12 min 27 sec | 31 min 10 sec | ???           |
 digits = 64217            |               |               |               |
---------------------------|---------------|---------------|---------------|
 K = 46157, N = 698207     | 2 hour 32 min | ???           | ???           |
 digits = 210187           |               |               |               |
---------------------------|---------------|---------------|---------------|
 K = 19249, N = 13018586   | ???           | ???           | ???           |
 digits = 3918990          |               |               |               |
---------------------------|---------------|---------------|---------------|


Known Problems
==============
- In the file smallprimes.cpy there is a COBOL table with 20.000 lines, 
  therefore the compilation is a little slow.
- There are compiler warnings because of the GMP mpz_ptr C structure. The GMP
  functions expected this to be a C structure, but they recognise the type 
  "unsigned char". 

Changelog
=========
Program history, changes and bug fixes are listed in program headers.

References
==========
1. https://gmplib.org/gmp-man-6.0.0a.pdf
2. http://primes.utm.edu/primes/lists/short.txt
3. http://www.prothsearch.net/
4. https://www.eff.org/de/awards/coop
5. http://en.wikipedia.org/wiki/Proth%27s_theorem
6. http://en.wikipedia.org/wiki/Las_Vegas_algorithm
