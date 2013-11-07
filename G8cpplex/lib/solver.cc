/*
Copyright (c) 2010-2013 Tommaso Urli

Tommaso Urli    tommaso.urli@uniud.it   University of Udine

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#include <iostream>
#include "pilal.h"
#include "simplex.h"

using namespace pilal;
using namespace optimization;

int main( int argc, char* argv[]) {

    if ( argc == 2 ) {
        Simplex problem("Simplex Instance");

        try {                                         
            problem.load_problem( argv[1] );
            
			
            // Solve
            problem.solve();         
            std::cout << std::endl;
            
            if (problem.must_be_fixed()) {
                std::cout << "Problem formulation is incorrect." << std::endl;
                return 1;
            }
            
            if ( problem.has_solutions() ) {
                if ( !problem.is_unlimited() ) 
                    problem.print_solution();
                else
                    std::cout << "Problem is unlimited." << std::endl;
                
            } else {
                std::cout << "Problem is overconstrained." << std::endl;
            }                                                           
            
        } catch ( DataMismatchException c ) {
            std::cout << "Error: " << c.error << std::endl;
        } 
        
        return 0;
    } else {  
        std::cout << "Error: omitted problem file." << std::endl;
        return 1;
    }    
    
	std::cout << "Quitting ..." << std::endl;
    
}


