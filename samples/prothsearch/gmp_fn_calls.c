/*
*>******************************************************************************
*>  gmp_fn_calls.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  gmp_fn_calls.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with gmp_fn_calls.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      gmp_fn_calls.c
*>
*> Purpose:      This is a primality test for Proth numbers
*>               http://en.wikipedia.org/wiki/Proth%27s_theorem
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2021.10.07
*>
*> Tectonics:    cobc -c gmp_fn_calls.c -o gmp_fn_calls.o
*>
*> Usage:        This module implements the call of GMP functions.
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2021.10.07 Laszlo Erdos: 
*>            First version created.
*>******************************************************************************
*/

#include <stdio.h>
#include "gmp.h"

void
gmp_fn_mpz_init2 (mpz_t x, mp_bitcnt_t n)
{
  mpz_init2 (x, n);
  return;
}

void 
gmp_fn_mpz_clear (mpz_t x)
{
  mpz_clear (x);
  return;
}

void 
gmp_fn_mpz_ui_pow_ui (mpz_t rop, unsigned long int base, unsigned long int exp)
{
  mpz_ui_pow_ui (rop, base, exp);
  return;
}

void 
gmp_fn_mpz_set_ui (mpz_t rop, unsigned long int op)
{
  mpz_set_ui (rop, op);
}

int 
gmp_fn_mpz_cmp (const mpz_t op1, const mpz_t op2)
{
  return(mpz_cmp (op1, op2));
}

void 
gmp_fn_mpz_mul_ui (mpz_t rop, const mpz_t op1, unsigned long int op2)
{
  mpz_mul_ui (rop, op1, op2);
  return;
}

void 
gmp_fn_mpz_add_ui (mpz_t rop, const mpz_t op1, unsigned long int op2)
{
  mpz_add_ui (rop, op1, op2);
  return;
}

void 
gmp_fn_mpz_sub_ui (mpz_t rop, const mpz_t op1, unsigned long int op2)
{
  mpz_sub_ui (rop, op1, op2);
  return;
}

unsigned long int 
gmp_fn_mpz_tdiv_q_ui (mpz_t q, const mpz_t n, unsigned long int d)
{
  return(mpz_tdiv_q_ui (q, n, d));
}

size_t 
gmp_fn_mpz_sizeinbase (const mpz_t op, int base)
{
  return(mpz_sizeinbase (op, base));
}

int 
gmp_fn_mpz_jacobi (const mpz_t a, const mpz_t b)
{
  return(mpz_jacobi (a, b));
}

int 
gmp_fn_mpz_divisible_ui_p (const mpz_t n, unsigned long int d)
{
  return(mpz_divisible_ui_p (n, d));
}

void 
gmp_fn_mpz_sqrt (mpz_t rop, const mpz_t op)
{
  return(mpz_sqrt (rop, op));
}

int 
gmp_fn_mpz_tstbit (const mpz_t op, mp_bitcnt_t bit_index)
{
  return(mpz_tstbit (op, bit_index));
}

void 
gmp_fn_mpz_mul (mpz_t rop, const mpz_t op1, const mpz_t op2)
{
  mpz_mul (rop, op1, op2);
  return;
}

void 
gmp_fn_mpz_mod (mpz_t r, const mpz_t n, const mpz_t d)
{
  mpz_mod (r, n, d);
  return;
}

void 
gmp_fn_mpz_set (mpz_t rop, const mpz_t op)
{
  mpz_set (rop, op);
  return;
}

void 
gmp_fn_mpz_tdiv_q_2exp (mpz_t q, const mpz_t n, mp_bitcnt_t b)
{
  mpz_tdiv_q_2exp (q, n, b);
  return;
}

void 
gmp_fn_mpz_tdiv_r_2exp (mpz_t r, const mpz_t n, mp_bitcnt_t b)
{
  mpz_tdiv_r_2exp (r, n, b);
  return;
}

unsigned long int 
gmp_fn_mpz_tdiv_qr_ui (mpz_t q, mpz_t r, const mpz_t n, unsigned long int d)
{
  return(mpz_tdiv_qr_ui (q, r, n, d));
}

void 
gmp_fn_mpz_add (mpz_t rop, const mpz_t op1, const mpz_t op2)
{
  mpz_add (rop, op1, op2);
  return;  
}

void 
gmp_fn_mpz_sub (mpz_t rop, const mpz_t op1, const mpz_t op2)
{
  mpz_sub (rop, op1, op2);
  return;
}

int 
gmp_fn_gmp_fprintf (FILE *fp, const char *fmt)
{
  return(gmp_fprintf (fp, fmt));
}

int 
gmp_fn_gmp_fscanf (FILE *fp, const char *fmt)
{
  return(gmp_fscanf (fp, fmt));
}

FILE *
gmp_fn_fopen(const char *filename, const char *mode)
{
  return(fopen(filename, mode));
}

int 
gmp_fn_fclose(FILE *stream)
{
  return(fclose(stream));    
}

