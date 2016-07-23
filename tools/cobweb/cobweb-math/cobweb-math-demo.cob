       identification division.
       program-id. cobweb-math-demo.

       environment division.
       configuration section.
       repository.
           function create-equation
           function evaluate-equation
           function evaluate-math
           function destroy-equation
           function all intrinsic.

       data division.
       working-storage section.
       COPY cobweb-math REPLACING ==:tag:== by ==demo-==.
 
       01 x                    usage float-long.
       01 ans                  usage float-long.
       01 extraneous           usage binary-long.

       01 calculation.
          05 value "(1 + 2 * 3 / 4 - 5)^6".
 
       01 equation             pic x(40).
       01 show-input           pic +9.99.
       01 show-y-input         pic 9.99.

       procedure division.
       demo-main.

      *> some simple math       
       display "cobweb-math (libmatheval) demonstration"

       display calculation " = " evaluate-math(calculation)
       display space

      *> a more complex example
       move "x^2 * sin(x) + 42" to equation
       perform show-equation-x

       display space
       move "x^2 + 2 * y^3" to equation
       perform show-equation-xy

       move 0 to return-code
       goback
       .


       show-equation-x.              
       move create-equation(equation, "derivative,variables")
         to demo-evaluator-record

       display " f(x) = " with no advancing
       call "printf" using "%s" & x"0a00" by value demo-evaluator-image

       display "f'(x) = " with no advancing
       call "printf" using "%s" & x"0a0a00" by value demo-prime-image
      
       perform varying demo-variable-value(1) from -1.0 by 0.5
           until demo-variable-value(1) > 2.0
           perform x-equation
       end-perform

       move destroy-equation(demo-evaluator-record) to extraneous
       .

      *> calculate the equation and it's first derivative
       x-equation.
       move demo-variable-value(1) to show-input
       move evaluate-equation(demo-evaluator, demo-variable-count,
                              demo-variable-names, demo-value-list)
         to ans
       display " f(" show-input ") = " ans

       move evaluate-equation(demo-evaluator-prime, demo-variable-count,
                              demo-variable-names, demo-value-list)
         to ans
       display "f'(" show-input ") = " ans
       .

      *> an x,y equation example
       show-equation-xy.              
       move create-equation(equation, "derivative,variables")
         to demo-evaluator-record

       display " f(x, y) = " with no advancing
       call "printf" using "%s" & x"0a00" by value demo-evaluator-image

       display "f'(x, y) = " with no advancing
       call "printf" using "%s" & x"0a0a00" by value demo-prime-image

      *> set y to 3, vary x
       perform varying demo-variable-value(1) from -1.0 by 0.5
           until demo-variable-value(1) > 1.0
           after demo-variable-value(2) from 3.0 by 1.0
               until demo-variable-value(2) > 4.0
           perform xy-equation
       end-perform

       move destroy-equation(demo-evaluator-record) to extraneous
       .

      *> calculate the x,y equation and it's first derivative
       xy-equation.
       move demo-variable-value(1) to show-input
       move demo-variable-value(2) to show-y-input
       move evaluate-equation(demo-evaluator, demo-variable-count,
                              demo-variable-names, demo-value-list)
         to ans
       display " f(" show-input ", " show-y-input ") = " ans

       move evaluate-equation(demo-evaluator-prime, demo-variable-count,
                              demo-variable-names, demo-value-list)
         to ans
       display "f'(" show-input ", " show-y-input ") = " ans
       .

       end program cobweb-math-demo.
