/*
* Evaluate math expressions with libmatheval
* wrappers place the double return values in references passed from GnuCOBOL
*/

#include <stdio.h>
#include <matheval.h>

/* evaluate a function with one variable */
int
evaluate_x(void *f, double x, double *ans)
{
    *ans = evaluator_evaluate_x(f, x);
    return 0;
}

/* evaluate a function with two variables */
int
evaluate_xy(void *f, double x, double y, double *ans)
{
    *ans = evaluator_evaluate_x_y(f, x, y);
    return 0;
}

/* evaluate a function with three variables */
int
evaluate_xyz(void *f, double x, double y, double z, double *ans)
{
    *ans = evaluator_evaluate_x_y_z(f, x, y, z);
    return 0;
}

/*
* evaluate a function given arbitrary variables, using the data names returned
* from evaluator_get_variables
*/
int
evaluate_function(void *f, int vars, char **names, double *values, double *ans)
{
    *ans = evaluator_evaluate(f, vars, names, values);
    return 0;
}

