G8cpplex 1.2
========
**G8cpplex** is a **iOS** wrapper for **ccplex**.

**G8Simplex** is the wrapper class between Objective-C and ccplex. Use it!

Follow AppDelegate for understand how optimize problems.

Problems are in the "problems" folder. 
They have the ccplex structure. 

Example of problem file content:

<pre>
[METADATA]

name Problema semplice
vars 3

[VARIABLES]

0   x1  4
-2   x2  inf
-3   x3  232

[CONSTRAINTS]

1 3 4 &gt; 0
0 0 1 &lt; 1
1 2 0 &lt; 2

[OBJECTIVE]

maximize 1 3 1
</pre>

With next release (i hope) i will change the problems input and output structure for a much easy implementation.

What's new?
========
- Static Library added
- Bundle added

- Solving a problem **programmatically** without use a .problem file, using the new classes G8Variable, G8Constraint...

- **G8SimplexResult** class added. It contains the result of the optimization.

<pre>
@property (nonatomic, strong) NSMutableArray *solutionOptimal;
@property (nonatomic) NSNumber *solutionValueCost;
@property (nonatomic) NSNumber *solutionDualProblemValue;
</pre>

- New Objective-C exceptions available (you can edit them in the G8Simplex.mm file)

- Some .problem files added


How to use
========

1) USE A ***.PROBLEM FILE***

Suppose that you have a problem into the problems folder:

<pre>
G8Simplex *simplex = [G8Simplex new];
NSBundle *bundle = [NSBundle mainBundle];
NSString *problemPath = [bundle pathForResource:@"small" ofType:@"problem"];

G8SimplexResult *simplexResult = [simplex optimize:problemPath];
    
NSLog(@"Optimal:\n%@\n\nValue/Cost:\n%@\n\nDoubleValue:\n%@\n", simplexResult.solutionOptimal, simplexResult.solutionValueCost, simplexResult.solutionDualProblemValue);
    
</pre>


2) ***PROGRAMMATICALLY***

<pre>
G8Simplex *simplex = [G8Simplex new];
    
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
</pre>


___________

**Warning**!

If you are using G8cpplex in a static library, create a custom bundle for use problems files in your project.


Author Infos
========

Daniele Galiotto www.g8production.com

License
========
This project is based to cpplex http://cpplex.googlecode.com

This project is under MIT License. 
Cpplex is under GPLv3 license. Cpplex is wrote in c++.
