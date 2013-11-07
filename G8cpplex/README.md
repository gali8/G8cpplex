G8cpplex 1.0
========

G8cpplex is a Objective-C wrapper for ccplex.

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

1 3 4 > 0
0 0 1 < 1
1 2 0 < 2

[OBJECTIVE]

maximize 1 3 1
</pre>

With next release (maybe) i will change the problems structure for a much easy implementation.


Author Infos
========

Daniele Galiotto www.g8production.com

License
========
This project is based to cpplex http://cpplex.googlecode.com

This project is under MIT License. 
Cpplex is under GPLv3 license. Cpplex is wrote in c++.
