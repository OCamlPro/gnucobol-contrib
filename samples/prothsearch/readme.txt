Program:      prothsearch.cob
Purpose:      This is a primality test for Proth numbers
Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2015.05.14 Laszlo Erdos: 
*>            First version created.
*> 2017.10.19 Laszlo Erdos: 
*>            - GMP mpz_powm() function replaced with other algorithm.
*>            - Small-prime test with parameter: max-small-prime <num>.
*>            - Save / Load state parameter.
*> 2021.10.07 Laszlo Erdos: 
*>            - GMP functions in a separeted file.
*>******************************************************************************

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

THE LARGEST KNOWN PRIMES (on 02.11.2017):
-----  -------------------------------- ------- ----- ---- --------------
 rank           description              digits  who year comment
-----  -------------------------------- ------- ----- ---- --------------
    1  2^74207281-1                    22338618   G14 2016 Mersenne 49?? 
    2  2^57885161-1                    17425170   G13 2013 Mersenne 48? 
    3  2^43112609-1                    12978189   G10 2008 Mersenne 47? 
    4  2^42643801-1                    12837064   G12 2009 Mersenne 46? 
    5  2^37156667-1                    11185272   G11 2008 Mersenne 45 
    6  2^32582657-1                     9808358    G9 2006 Mersenne 44 
    7  10223*2^31172165+1               9383761  SB12 2016 Proth prime
    8  2^30402457-1                     9152052    G9 2005 Mersenne 43 
    9  2^25964951-1                     7816230    G8 2005 Mersenne 42 
   10  2^24036583-1                     7235733    G7 2004 Mersenne 41 

Presently the 7th largest known prime is a Proth prime. [Ref. 2.]   
Remember, there have been only a few Mersenne primes, but a lot of Proth primes
found yet. 

With prothsearch.cob you can participate in the EFF Awards:

Through the EFF Cooperative Computing Awards, EFF will confer prizes of:
- $150,000 to the first individual or group who discovers a prime number
  with at least 100,000,000 decimal digits.
- $250,000 to the first individual or group who discovers a prime number
  with at least 1,000,000,000 decimal digits.
Prize money comes from a special donation provided by an individual EFF
supporter, earmarked specifically for this project. [Ref. 3.]

Mathematical theory
-------------------
In number theory, Proth's theorem is a primality test for Proth numbers.
It states that if "p" is a Proth number, of the form k*2^n + 1 with k odd and 
k < 2^n, and if there exists an integer "a" for which

   a^((p - 1) / 2) congruence -1 modulo p

then p is prime. [Ref. 4.]

In this case "p" is called a Proth prime. This is a practical test because if 
"p" is prime, any chosen "a" has about a 50 percent chance of working.

If "a" is a quadratic non-residue modulo "p" then the converse is also true,
and the test is conclusive. Such an "a" may be found by iterating "a" over small
primes and computing the Jacobi symbol until:

   (a / p) = -1

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
6. The sequence 6*j-1 and 6*j+1 includes all primes (and other numbers). 
   Do this test first. After it, do a primitive division pre check. Divide the
   Proth number with the first 20.000 small prime numbers. If the Proth number
   is exactly divisible, then set result V-PRIME-NO, return. (In this case the
   Proth number is definitively no prime.)
7. With the powm algorithm compute the congruence:
   a^((p - 1) / 2) modulo p, "a" stands for the small Jacobi prime from step 5,
   "p" is the Proth number from step 3, and the value (p - 1) / 2 from step 4.
   If the congruence = -1, then set result V-PRIME-YES, return. (In this case 
   the Proth number is definitively prime.)
   If the congruence does not equal -1, then set result V-NO-RESULT, return. (In 
   this case the Proth number is maybe prime.)
   
Remember that step 7 (the powm algorithm) is the bottleneck in this
algorithm. It can take a lot of time for large numbers. 

The GMP mpz_powm() function was used in the first version of this program. Now
it is replaced with another algorithm. The new algorithm is based on Knuth's 
book, "The Art of Computer Programming Volume 2". [5]
See more in Chapter 4. Arithmetic, Section 4.6.3 Evaluation of Powers. 
And in Answers to Exercises, Section 4.5.4, Answer 27.

This algorithm has several advantages:
- It is faster than the GMP mpz_powm() function.
- We can use a countdown counter, so we can see when the program will end.
- Now it is possible to save and reload the state of the program.

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
- You can save the program state after x countdown steps with the 
  parameter -save <num>. With the parameter -load, you can restart and continue
  the program from the saved point. With -save  a log file will also be created. 

Test
----
This program was developed using GnuCOBOL 2.2.0. 
Built Sep 07 2017 09:26:43, and Windows 10 (64 bit) running on a HP laptop. 
It was successfully tested: 
- With cygwin (64 bit).
- With mingw32 VBISAM (32 bit). 


Installation and Configuration
==============================

The delivered files:
- makefile                - for compile
- prothsearch.cob         - main program (command line parameter processing)
- prothtest.cob           - module       (Proth prime test algorithm)
- readme.txt              - this file
- win_mingw32_compile.bat - for compile with mingw32 VBISAM

Compiling with cygwin
---------------------
Use the makefile.

Compiling with mingw32 VBISAM
-----------------------------
Use the batch file win_mingw32_compile.bat. First change the batch compile file 
according to your environment.


Usage
=====

prothsearch { -k <num> -n <num> [-v] [-wf] [-pre] [-msp <num>] [-sv <num>] [ld] }
            { -kmin <num> -kmax <num> -nmin <num> -nmax <num> [-v] [-wf] [-pre] [-msp <num>] }

protsearch is a primality test for Proth numbers

Options:

-k <num> -n <num>       Test one number in the form k*2^n + 1
-kmin <num> -kmax <num> -nmin <num> -nmax <num>
                        Test an intervall
-v,   -verbose          Verbose mode
-wf,  -write-file       Write Proth numbers in files
-pre, -precheck         Only precheck, no powm test
-msp, -max-small-prime <num>
                        For small prime div test, default = 20,000
                        Value: 20,000 <= <num> <= 715,827,882
-sv,  -save <num>       Save state after <num> countdown steps, write log file
-ld,  -load             Load last saved state


--------------------------------------------------------------------------------
Example 1, one number test:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -k 13 -n 1000

Program start: 2017-11-05:19:17:42.71

K: 0000000013; N: 0000001000; Digits: 0000000303; prime found!!!; Start: 2017-11-05:19:17:42.71; End: 2017-11-05:19:17:42.73

Number of primes: 0000000001

Program end:   2017-11-05:19:17:42.73


--------------------------------------------------------------------------------
Example 2, interval test:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -kmin 3 -kmax 5 -nmin 1000 -nmax 2500

Program start: 2017-11-05:19:18:14.73

K: 0000000003; N: 0000002208; Digits: 0000000666; prime found!!!; Start: 2017-11-05:19:18:25.61; End: 2017-11-05:19:18:25.63
K: 0000000005; N: 0000001947; Digits: 0000000588; prime found!!!; Start: 2017-11-05:19:18:36.57; End: 2017-11-05:19:18:36.59

Number of primes: 0000000002

Program end:   2017-11-05:19:18:42.09


--------------------------------------------------------------------------------
Example 3, interval with verbose test:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -kmin 3 -kmax 5 -nmin 5 -nmax 7 -v

Program start: 2017-11-05:19:19:19.66


Start Proth primality test with K: 0000000003, N: 0000000005
Proth test Countdown: 0000000004
Proth test Countdown: 0000000003
Proth test Countdown: 0000000002
Proth test Countdown: 0000000001
Proth test Countdown: 0000000000
K: 0000000003; N: 0000000005; Digits: 0000000003; prime found!!!; Jacobi a-num: 0000000005; Divisor: 0000000000; Start: 2017-11-05:19:19:19.66; End: 2017-11-05:19:19:19.67

Start Proth primality test with K: 0000000003, N: 0000000006
Proth test Countdown: 0000000005
Proth test Countdown: 0000000004
Proth test Countdown: 0000000003
Proth test Countdown: 0000000002
Proth test Countdown: 0000000001
Proth test Countdown: 0000000000
K: 0000000003; N: 0000000006; Digits: 0000000003; prime found!!!; Jacobi a-num: 0000000005; Divisor: 0000000000; Start: 2017-11-05:19:19:19.67; End: 2017-11-05:19:19:19.68
K: 0000000003; N: 0000000007; Digits: 0000000003; no prime      ; Jacobi a-num: 0000000013; Divisor: 0000000005; Start: 2017-11-05:19:19:19.68; End: 2017-11-05:19:19:19.69
K: 0000000004; N: 0000000005; Digits: 0000000000; K not odd     ; Jacobi a-num: 0000000000; Divisor: 0000000000; Start: 2017-11-05:19:19:19.69; End: 2017-11-05:19:19:19.69
K: 0000000004; N: 0000000006; Digits: 0000000000; K not odd     ; Jacobi a-num: 0000000000; Divisor: 0000000000; Start: 2017-11-05:19:19:19.69; End: 2017-11-05:19:19:19.69
K: 0000000004; N: 0000000007; Digits: 0000000000; K not odd     ; Jacobi a-num: 0000000000; Divisor: 0000000000; Start: 2017-11-05:19:19:19.69; End: 2017-11-05:19:19:19.69
K: 0000000005; N: 0000000005; Digits: 0000000003; no prime      ; Jacobi a-num: 0000000003; Divisor: 0000000007; Start: 2017-11-05:19:19:19.69; End: 2017-11-05:19:19:19.70
K: 0000000005; N: 0000000006; Digits: 0000000003; not in 6*j+-1 ; Jacobi a-num: 0000000007; Divisor: 0000000000; Start: 2017-11-05:19:19:19.70; End: 2017-11-05:19:19:19.70

Start Proth primality test with K: 0000000005, N: 0000000007
Proth test Countdown: 0000000007
Proth test Countdown: 0000000006
Proth test Countdown: 0000000005
Proth test Countdown: 0000000004
Proth test Countdown: 0000000003
Proth test Countdown: 0000000002
Proth test Countdown: 0000000001
Proth test Countdown: 0000000000
K: 0000000005; N: 0000000007; Digits: 0000000004; prime found!!!; Jacobi a-num: 0000000003; Divisor: 0000000000; Start: 2017-11-05:19:19:19.70; End: 2017-11-05:19:19:19.71

Number of primes: 0000000003

Program end:   2017-11-05:19:19:19.71


--------------------------------------------------------------------------------
Example 4, interval with write file test:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -kmin 15 -kmax 15 -nmin 6800 -nmax 6810 -wf

Program start: 2017-11-05:19:20:00.46

K: 0000000015; N: 0000006804; Digits: 0000002050; prime found!!!; Start: 2017-11-05:19:20:00.54; End: 2017-11-05:19:20:00.60

Number of primes: 0000000001

Program end:   2017-11-05:19:20:00.82


The sub directory "Proth_Primes" will be created.
The file K0000000015-N0000006804.txt with the digits of the Proth number 
will be written in the new sub directory.


--------------------------------------------------------------------------------
Example 5, interval with pre check:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -kmin 19249 -kmax 19249 -nmin 13018580 -nmax 13018590 -pre

Program start: 2017-11-05:19:20:52.97

K: 0000019249; N: 0013018586; Digits: 0003918990; maybe prime   ; Start: 2017-11-05:19:20:53.29; End: 2017-11-05:19:21:34.36

Program end:   2017-11-05:19:21:34.58


--------------------------------------------------------------------------------
Example 6, max-small-prime (msp) parameter:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -k 19249 -n 13018586 -msp 50000 -v -pre

Program start: 2017-11-05:19:26:52.97

Small primes division test: 0000001000 / 0000050000
Small primes division test: 0000002000 / 0000050000
Small primes division test: 0000003000 / 0000050000
Small primes division test: 0000004000 / 0000050000
Small primes division test: 0000005000 / 0000050000
Small primes division test: 0000006000 / 0000050000
Small primes division test: 0000007000 / 0000050000
Small primes division test: 0000008000 / 0000050000
Small primes division test: 0000009000 / 0000050000
Small primes division test: 0000010000 / 0000050000
Small primes division test: 0000011000 / 0000050000
Small primes division test: 0000012000 / 0000050000
Small primes division test: 0000013000 / 0000050000
Small primes division test: 0000014000 / 0000050000
Small primes division test: 0000015000 / 0000050000
Small primes division test: 0000016000 / 0000050000
Small primes division test: 0000017000 / 0000050000
Small primes division test: 0000018000 / 0000050000
Small primes division test: 0000019000 / 0000050000
Small primes division test: 0000020000 / 0000050000
Small primes division test: 0000021000 / 0000050000
Small primes division test: 0000022000 / 0000050000
Small primes division test: 0000023000 / 0000050000
Small primes division test: 0000024000 / 0000050000
Small primes division test: 0000025000 / 0000050000
Small primes division test: 0000026000 / 0000050000
Small primes division test: 0000027000 / 0000050000
Small primes division test: 0000028000 / 0000050000
Small primes division test: 0000029000 / 0000050000
Small primes division test: 0000030000 / 0000050000
Small primes division test: 0000031000 / 0000050000
Small primes division test: 0000032000 / 0000050000
Small primes division test: 0000033000 / 0000050000
Small primes division test: 0000034000 / 0000050000
Small primes division test: 0000035000 / 0000050000
Small primes division test: 0000036000 / 0000050000
Small primes division test: 0000037000 / 0000050000
Small primes division test: 0000038000 / 0000050000
Small primes division test: 0000039000 / 0000050000
Small primes division test: 0000040000 / 0000050000
Small primes division test: 0000041000 / 0000050000
Small primes division test: 0000042000 / 0000050000
Small primes division test: 0000043000 / 0000050000
Small primes division test: 0000044000 / 0000050000
Small primes division test: 0000045000 / 0000050000
Small primes division test: 0000046000 / 0000050000
Small primes division test: 0000047000 / 0000050000
Small primes division test: 0000048000 / 0000050000
Small primes division test: 0000049000 / 0000050000
Small primes division test: 0000050000 / 0000050000
K: 0000019249; N: 0013018586; Digits: 0003918990; maybe prime   ; Jacobi a-num: 0000000003; Divisor: 0000000000; Start: 2017-11-05:19:26:52.97; End: 2017-11-05:19:28:35.51

Program end:   2017-11-05:19:28:35.51


--------------------------------------------------------------------------------
Example 7, -save 1000 -load with verbose parameter, Countdown will be displayed.
           A SAVE-file will be written after every 1000 Countdown steps:
--------------------------------------------------------------------------------

$ ./prothsearch.exe -k 10223 -n 31172165 -wf -sv 1000 -ld -v

Program start: 2017-11-05:20:10:43.14


Start Proth primality test with K: 0000010223, N: 0031172165
Proth test Countdown: 0031172176
Proth test Countdown: 0031172175
Proth test Countdown: 0031172174
...
...
Proth test Countdown: 0031172003
Proth test Countdown: 0031172002
Proth test Countdown: 0031172001

Save state in file: SAVE-K0000010223-N0031172165-C0031172000.txt

Proth test Countdown: 0031172000
Proth test Countdown: 0031171999
Proth test Countdown: 0031171998
...
...
Proth test Countdown: 0031171003
Proth test Countdown: 0031171002
Proth test Countdown: 0031171001

Save state in file: SAVE-K0000010223-N0031172165-C0031171000.txt

Proth test Countdown: 0031171000
Proth test Countdown: 0031170999
Proth test Countdown: 0031170998
...
...
Proth test Countdown: 0031170003
Proth test Countdown: 0031170002
Proth test Countdown: 0031170001

Save state in file: SAVE-K0000010223-N0031172165-C0031170000.txt

Proth test Countdown: 0031170000
Proth test Countdown: 0031169999
Proth test Countdown: 0031169998
...
...
Proth test Countdown: 0031169003
Proth test Countdown: 0031169002
Proth test Countdown: 0031169001

Save state in file: SAVE-K0000010223-N0031172165-C0031169000.txt

Proth test Countdown: 0031169000
Proth test Countdown: 0031168999
Proth test Countdown: 0031168998
...
...
Proth test Countdown: 0031168266
Proth test Countdown: 0031168265
Proth test Countdown: 0031168264

caught signal (signal SIGINT)
abnormal termination - file contents may be incorrect

The program was aborted with Ctrl + c. We restart it later:
***********************************************************


$ ./prothsearch.exe -k 10223 -n 31172165 -wf -sv 1000 -ld -v

Program start: 2017-11-05:20:34:06.46


Start Proth primality test with K: 0000010223, N: 0031172165

Load state from file: SAVE-K0000010223-N0031172165-C0031169000.txt


Save state in file: SAVE-K0000010223-N0031172165-C0031169000.txt

Proth test Countdown: 0031169000
Proth test Countdown: 0031168999
Proth test Countdown: 0031168998
...
...
Proth test Countdown: 0031168003
Proth test Countdown: 0031168002
Proth test Countdown: 0031168001

Save state in file: SAVE-K0000010223-N0031172165-C0031168000.txt

Proth test Countdown: 0031168000
Proth test Countdown: 0031167999
Proth test Countdown: 0031167998
...
...
Proth test Countdown: 0031167997
Proth test Countdown: 0031167996
Proth test Countdown: 0031167995
...
...
Proth test Countdown: 0031167352
Proth test Countdown: 0031167351
Proth test Countdown: 0031167350

caught signal (signal SIGINT)
abnormal termination - file contents may be incorrect

The program was aborted with Ctrl + c.
**************************************


The sub directory "Save_State_K0000010223-N0031172165" will be created.
Two files will be written in the new sub directory:
- LOG-K0000010223-N0031172165.txt
- SAVE-K0000010223-N0031172165-C0031168000.txt

The SAVE-file includes a partial result, the saved state. The LOG-file has the
following lines:

Start; Proth primality test.                  2017-11-05:20:12:22.94
SAVE-K0000010223-N0031172165-C0031172000.txt  2017-11-05:20:12:50.60
SAVE-K0000010223-N0031172165-C0031171000.txt  2017-11-05:20:15:35.70
SAVE-K0000010223-N0031172165-C0031170000.txt  2017-11-05:20:18:18.67
SAVE-K0000010223-N0031172165-C0031169000.txt  2017-11-05:20:21:02.96
Start; Proth primality test.                  2017-11-05:20:35:46.41
Load; Countdown: 0031169000                   2017-11-05:20:35:47.99
SAVE-K0000010223-N0031172165-C0031169000.txt  2017-11-05:20:35:51.35
SAVE-K0000010223-N0031172165-C0031168000.txt  2017-11-05:20:38:35.39

After restart, the program looking for the last SAVE-file name in the LOG-file,
and reload the saved partial result from the SAVE-file.


--------------------------------------------------------------------------------
Example 9, save / load without verbose parameter:
--------------------------------------------------------------------------------

This is same as Example 8, but without displaying the Countdown counter.



Some measurement results
========================

Testing environment:
- MS Windows 10 Professional (64 bit) 
- HP laptop, Intel(R) Core(TM) i7-7500U CPU @ 2,70 GHz  2,90 gHz ; 16 GB RAM


 K, N                      | cygwin        | mingw32 VBISAM|       
 number of digits          | 64 bit        | 32 bit        |
---------------------------|---------------|---------------|
 K = 13,    N = 28280      | 1 sec         | 2 sec         |
 digits = 8515             |               |               |
---------------------------|---------------|---------------|
 K = 3,     N = 213321     | 1 min 38 sec  | 3 min 54 sec  |
 digits = 64217            |               |               |
---------------------------|---------------|---------------|
 K = 46157, N = 698207     | 20 min 35 sec | 50 min 42 sec |
 digits = 210187           |               |               |
---------------------------|---------------|---------------|
 K = 10223, N = 31172165   | about         | about         |
 digits = 9383761          | 58 days       | 112 days      |
---------------------------|---------------|---------------|
               

Known Problems
==============
- There are compiler warnings because of the GMP mpz_ptr C structure. The GMP
  functions expected this to be a C structure, but they recognise the type 
  "unsigned char". 

  
References
==========
1. https://gmplib.org/
2. http://primes.utm.edu/primes/lists/short.txt
3. https://www.eff.org/de/awards/coop
4. http://en.wikipedia.org/wiki/Proth%27s_theorem
5. https://en.wikipedia.org/wiki/The_Art_of_Computer_Programming