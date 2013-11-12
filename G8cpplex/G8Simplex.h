//
//  Simplex.h
//  SimplexTest
//
//  Created by Daniele on 07/11/13.
//  Copyright (c) 2013 Daniele Galiotto. All rights reserved.
//

#import <Foundation/Foundation.h>

enum GoalType {
    MAXIMIZE,
    MINIMIZE
};

enum ConstraintRelationship {
    EQ,
    GEQ,
    LEQ
};

@interface G8SimplexResult : NSObject

@property (nonatomic, strong) NSMutableArray *solutionOptimal;
@property (nonatomic) NSNumber *solutionValueCost;
@property (nonatomic) NSNumber *solutionDualProblemValue;

@end

@interface G8Variable : NSObject

@property (nonatomic, weak, readonly) NSString *left;
@property (nonatomic, weak, readonly) NSString *name;
@property (nonatomic, weak, readonly) NSString *right;

+(id)variableWithLeft:(NSString *)left name:(NSString *)name right:(NSString *)right;
-(id)initWithLeft:(NSString *)left name:(NSString *)name right:(NSString *)right;

@end

@interface G8Constraint : NSObject

@property (nonatomic, weak, readonly) NSArray *left;
@property (nonatomic, readonly) enum ConstraintRelationship relation;
@property (nonatomic, weak, readonly) NSString *right;

+(id)constraintWithLeft:(NSArray *)left relation:(enum ConstraintRelationship)relation right:(NSString *)right;
-(id)initWithLeft:(NSArray *)left relation:(enum ConstraintRelationship)relation right:(NSString *)right;

@end

@interface G8Simplex : NSObject

-(G8SimplexResult *)optimize:(NSArray *)variables constaints:(NSArray *)constraints goalType:(enum GoalType)goalType objective:(NSArray *)objective;
-(G8SimplexResult *)optimize:(NSString *)theProblem;

@end
