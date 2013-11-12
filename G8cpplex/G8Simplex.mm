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

@implementation G8SimplexResult

@end

@implementation G8Variable

+(id)variableWithLeft:(NSString *)left name:(NSString *)name right:(NSString *)right
{
    return [[G8Variable alloc] initWithLeft:left name:name right:right];
}

-(id)initWithLeft:(NSString *)left name:(NSString *)name right:(NSString *)right
{
    if(self = [super init])
    {
        _left = left;
        _name = name;
        _right = right;
    }
    return self;
}

@end

@implementation G8Constraint

+(id)constraintWithLeft:(NSArray *)left relation:(enum ConstraintRelationship)relation right:(NSString *)right
{
    return [[G8Constraint alloc] initWithLeft:left relation:relation right:right];
}

-(id)initWithLeft:(NSArray *)left relation:(enum ConstraintRelationship)relation right:(NSString *)right
{
    if(self = [super init])
    {
        _left = left;
        _relation = relation;
        _right = right;
    }
    return self;
}

@end

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

-(G8SimplexResult *)optimize:(NSArray *)variables constaints:(NSArray *)constraints goalType:(enum GoalType)goalType  objective:(NSArray *)objective
{
    NSMutableString *theProblemContent = [NSMutableString new];
    
    [theProblemContent appendFormat:@"[METADATA]\n\nname G8Simplex\nvars %i\n", variables.count];
    
    [theProblemContent appendFormat:@"\n[VARIABLES]\n\n"];
    for (G8Variable *var in variables)
    {
        [theProblemContent appendFormat:@"%@ %@ %@\n", var.left, var.name, var.right];
    }
    
    [theProblemContent appendFormat:@"\n[CONSTRAINTS]\n\n"];
    for (G8Constraint *cons in constraints)
    {
        NSMutableString *leftString = [NSMutableString new];
        
        //nsstring or nssnumber
        for (id c in cons.left)
        {
            [leftString appendFormat:@"%f ", [c floatValue]];
        }
        
        NSString *rel = nil;
        
        switch (cons.relation)
        {
            case EQ:
                rel = @"=";
                break;
            case GEQ:
                rel = @">";
                break;
                
            case LEQ:
                rel = @"<";
                break;
        }
        
        [theProblemContent appendString:leftString];
        [theProblemContent appendFormat:@"%@ ", rel];
        [theProblemContent appendFormat:@"%@\n", cons.right];
    }
    
    [theProblemContent appendFormat:@"\n[OBJECTIVE]\n\n"];
    
    [theProblemContent appendFormat:@"%@ ", goalType == MAXIMIZE ? @"maximize" : @"minimize"];
    //nsstring or nssnumber
    for (id o in objective)
    {
        [theProblemContent appendFormat:@"%f ", [o floatValue]];
    }
    
    NSString *theProblem = [self tempFilePathWithContent:theProblemContent];
    
    return [self optimize:theProblem];
}

-(G8SimplexResult *)optimize:(NSString *)theProblem
{
    _simplex = new optimization::Simplex("Problem");
    
    NSLog(@"Simplex Instance");
    
    try {
        _simplex->load_problem([theProblem UTF8String]);
        
        // Solve
        _simplex->solve();
        
        std::cout << std::endl;
        
        if (_simplex->must_be_fixed()) {
            std::cout << "Problem formulation is incorrect." << std::endl;
            NSException *ex = [NSException exceptionWithName:@"must_be_fixed" reason:@"Problem formulation is incorrect." userInfo:nil];
            @throw ex;
            return nil;
        }
        
        if ( _simplex->has_solutions() )
        {
            if ( !_simplex->is_unlimited() )
            {
                std::vector<double> solutionVector = _simplex->print_solution();
                
                if(solutionVector.size() < 2)
                    return nil;
                
                int optimalSize = solutionVector.size()-2;
                
                G8SimplexResult *result = [G8SimplexResult new];
                result.solutionOptimal = [NSMutableArray new];
                
                for (int i = 0; i < optimalSize; i++)
                {
                    [result.solutionOptimal addObject:[NSNumber numberWithDouble:solutionVector[i]]];
                }
                
                result.solutionValueCost = [NSNumber numberWithDouble:solutionVector[optimalSize]];
                result.solutionDualProblemValue = [NSNumber numberWithDouble:solutionVector[optimalSize + 1]];
                
                return result;
            }
            else
            {
                std::cout << "Problem is unlimited." << std::endl;
                NSException *ex = [NSException exceptionWithName:@"is_unlimited" reason:@"Problem is unlimited." userInfo:nil];
                @throw ex;
            }
            
        } else
        {
            std::cout << "Problem is overconstrained." << std::endl;
            NSException *ex = [NSException exceptionWithName:@"has_solutions" reason:@"Problem is overconstrained." userInfo:nil];
            @throw ex;
        }
        
    }
    catch (optimization::DataMismatchException c )
    {
        std::cout << "Error: " << c.error << std::endl;
        NSException *ex = [NSException exceptionWithName:@"optimization" reason:@"Error" userInfo:nil];
        @throw ex;
    }
    
    return nil;
    
	std::cout << "Quitting ..." << std::endl;
}

-(NSString *)tempFilePathWithContent:(NSString *)fileContent
{
    NSString *tempFileTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"g8problemfile.problem"];
    const char *tempFileTemplateCString = [tempFileTemplate fileSystemRepresentation];
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);

    NSString *filePath = [NSString stringWithUTF8String:tempFileNameCString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    int fileDescriptor = mkstemp(tempFileNameCString);
    
    if (fileDescriptor == -1)
    {
        // handle file creation failure
        return nil;
    }
    
    free(tempFileNameCString);
    
    NSFileHandle *tempFileHandle =  [[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:NO];
    [tempFileHandle writeData:[fileContent dataUsingEncoding:NSUTF8StringEncoding]];
    [tempFileHandle synchronizeFile];
    
    return filePath;
}

@end
