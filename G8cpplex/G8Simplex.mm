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

-(void)optimize:(NSString *)theProblem  //argc, char* argv[])
{
    _simplex = new optimization::Simplex("banana");
    
    NSLog(@"Simplex Instance");
    
    try {
        _simplex->load_problem([theProblem UTF8String]);
        
        // Solve
        _simplex->solve();
        
        std::cout << std::endl;
        
        if (_simplex->must_be_fixed()) {
            std::cout << "Problem formulation is incorrect." << std::endl;
            return;
        }

        if ( _simplex->has_solutions() ) {
            if ( !_simplex->is_unlimited() )
            _simplex->print_solution();
            else
            std::cout << "Problem is unlimited." << std::endl;
            
        } else {
            std::cout << "Problem is overconstrained." << std::endl;
        }
        
    }
    catch (optimization::DataMismatchException c ) {
        std::cout << "Error: " << c.error << std::endl;
    }
    
    return;
    
	std::cout << "Quitting ..." << std::endl;
}

@end
