G8cpplex 1.0
========
*This is the first version. With next release (i hope) i will change the problems input and output structure for a much easy implementation.
*

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

How to use
========

Suppose that you have a problem into the problems folder:

<pre>
NSBundle *bundle = [NSBundle mainBundle];
NSString *problemPath = [bundle pathForResource:@"small" ofType:@"problem"];
[simplex optimize:problemPath];
</pre>


If you are using G8cpplex in a static library, create a custom bundle for use problems files in your project.


Author Infos
========

Daniele Galiotto www.g8production.com

License
========
This project is based to cpplex http://cpplex.googlecode.com

This project is under MIT License. 
Cpplex is under GPLv3 license. Cpplex is wrote in c++.
