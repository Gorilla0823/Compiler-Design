# Compiler-Design
## A simple C compiler using ANTLR and Jasmin

Input **`make`** to execute all files,including test1.c,test2.c,and test3.c.

Its main features are as follows.

**`Integer and floating –point data type:int,float`**

If you mixed different data type together , you’ll get an error.

**`Statements for arithmetic computation.`**

Support for the priority of the parentheses , and with fully arithmetic computation.

**`Comparison expression.`**

Support for the logical operator , such as > , >= , < , <= , != , and == , right and left operand can both be an Identifier , Number , etc.

**`If-then-else program construct`**

**`Printf() function with one/two parameters.(support types:%d,%f)`**

Support for more than two parameters.

**Details of makefile:**

all:test1 test2 test3

test1:
	java  -cp antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
	javac -cp antlr-3.5.2-complete.jar:. myCompiler_test.java
	java  -cp antlr-3.5.2-complete.jar:. myCompiler_test test1.c > test1.j
	java -jar jasmin.jar test1.j
	java myResult
	rm myResult.class

test2:
	java  -cp antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
	javac -cp antlr-3.5.2-complete.jar:. myCompiler_test.java
	java  -cp antlr-3.5.2-complete.jar:. myCompiler_test test2.c > test2.j
	java -jar jasmin.jar test2.j
	java myResult
	rm myResult.class

test3:
	java  -cp antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
	javac -cp antlr-3.5.2-complete.jar:. myCompiler_test.java
	java  -cp antlr-3.5.2-complete.jar:. myCompiler_test test3.c > test3.j
	java -jar jasmin.jar test3.j
	java myResult
	rm myResult.class

clean:
	rm myCompilerLexer.java 
	rm myCompiler.tokens 
	rm *.class 
	rm myCompilerParser.java 
	
bytecode:
	rm test*.j


If you want to test a program alone, try to input make **file_name** .

( The instruction you use will clean myResult.class which produced by "java -jar jasmin.jar <bytecode>.")

The instruction ,"make clean", will clean the lexer,parser,all classes,and tokens files.

The remain instruction, make bytecode,will clean the bytecode produced by the previous instruction.
