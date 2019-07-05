;.source myCompiler.j
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 100
.limit locals 100
	ldc 2.0
	fstore 1
	ldc 7.0
	fload 1
	fmul
	ldc 1.3
	fadd
	fstore 0
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "---The result of test2.c---"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "I like to eat "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	fload 1
	invokevirtual java/io/PrintStream/print(F)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " or "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	fload 0
	invokevirtual java/io/PrintStream/print(F)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " bananas"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "The number of bananas won't be floating-points,OK?"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "------------END------------"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return
.end method
