//
//  AppDelegate.m
//  SimplexTest
//
//  Created by Daniele on 07/11/13.
//  Copyright (c) 2013 Daniele Galiotto. All rights reserved.
//

#import "AppDelegate.h"
#import "G8Simplex.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    G8Simplex *simplex = [G8Simplex new];
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    /* print the problem */
    NSURL *problemUrl = [bundle URLForResource:@"toy" withExtension:@"problem"];
    NSError *error = nil;
    NSString *problem = [NSString stringWithContentsOfURL:problemUrl encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"This is the problem: \n\r%@", problem);
    /* end print the problem */
    
    
    /*simplex: solving the problem  from .problem FILE*/
    NSString *problemPath = [bundle pathForResource:@"toy" ofType:@"problem"];
    G8SimplexResult *simplexResult = [simplex optimize:problemPath];
    
    NSLog(@"Optimal:\n%@\n\nValue/Cost:\n%@\n\nDoubleValue:\n%@\n", simplexResult.solutionOptimal, simplexResult.solutionValueCost, simplexResult.solutionDualProblemValue);
    
    
    
 /*simplex: solving the problem  PROGRAMMATICALLY*/
    
    //VARIABLES
    NSMutableArray *variables = [NSMutableArray new];
    [variables addObject:[G8Variable variableWithLeft:@"0" name:@"x1" right:@"inf"]];
    [variables addObject:[G8Variable variableWithLeft:@"0" name:@"x2" right:@"inf"]];
    [variables addObject:[G8Variable variableWithLeft:@"0" name:@"x3" right:@"inf"]];
    [variables addObject:[G8Variable variableWithLeft:@"0" name:@"x4" right:@"inf"]];
    
    //CONSTRAINTS
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[G8Constraint constraintWithLeft:@[@"1.2", @"6", @"70", @"2.5"] relation:LEQ right:@"10000"]];
    [constraints addObject:[G8Constraint constraintWithLeft:@[@"1", @"1", @"0", @"0"] relation:EQ right:@"1"]];
    [constraints addObject:[G8Constraint constraintWithLeft:@[@"0", @"0", @"1", @"1"] relation:EQ right:@"1"]];
    
    //OBJECTIVE
    NSArray *objective = @[@"1.2", @"6", @"70", @"2.5"];
    
    G8SimplexResult *simplexProgrammaticallyResult = [simplex optimize:variables constaints:constraints goalType:MINIMIZE objective:objective];
    
    NSLog(@"Optimal:\n%@\n\nValue/Cost:\n%@\n\nDoubleValue:\n%@\n", simplexProgrammaticallyResult.solutionOptimal, simplexProgrammaticallyResult.solutionValueCost, simplexProgrammaticallyResult.solutionDualProblemValue);
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
