//
//  Simplex.m
//  SimplexTest
//
//  Created by Daniele on 07/11/13.
//  Copyright (c) 2013 Daniele Galiotto. All rights reserved.
//

#import "G8Simplex.h"

#include <iostream>
#include "pilal.h"
#include "simplex.h"

namespace pilal
{
    
};

namespace optimization
{
    class Simplex;
    class DataMismatchException;
};

@interface G8Simplex ()
{
    optimization::Simplex * _simplex;
    optimization::DataMismatchException *_dataMismatchException;
}

@end

@implementation G8Simplex

-(int)optimize:(NSString *)theProblem  //argc, char* argv[])
{
    _simplex = new optimization::Simplex("banana");
    
    //optimization::Simplex::banana chiama qualcosa di statico
    //_simplex::banana chiama qualcosa di non statico
    
    //_simplex::problem("Simplex Instance");
    NSLog(@"Simplex Instance");
    
    try {
        //problem.load_problem( argv[1] );
        _simplex->load_problem([theProblem UTF8String]);
        
        // Solve
        //problem.solve();
        _simplex->solve();
        
        std::cout << std::endl;
        
        //if (problem.must_be_fixed()) {
        if (_simplex->must_be_fixed()) {
            std::cout << "Problem formulation is incorrect." << std::endl;
            return 1;
        }
        
        //if ( problem.has_solutions() ) {
        //if ( !problem.is_unlimited() )
        if ( _simplex->has_solutions() ) {
            if ( !_simplex->is_unlimited() )
            //problem.print_solution();
            _simplex->print_solution();
            else
            std::cout << "Problem is unlimited." << std::endl;
            
        } else {
            std::cout << "Problem is overconstrained." << std::endl;
        }
        
    }
    //catch ( DataMismatchException c ) {
    catch (optimization::DataMismatchException c ) {
        std::cout << "Error: " << c.error << std::endl;
    }
    
    return 0;
    
	std::cout << "Quitting ..." << std::endl;
}

@end
