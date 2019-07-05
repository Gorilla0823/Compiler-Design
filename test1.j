;.source myCompiler.j
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 100
.limit locals 100
	ldc 2
	istore 1
	iload 1
	ldc 2
	ldc 1
	ldc 100
	ineg
	iadd
	imul
	iadd
	istore 0
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "---The result of test1.c---"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "I like to eat "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 0
	invokevirtual java/io/PrintStream/print(I)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " or "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 1
	invokevirtual java/io/PrintStream/print(I)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " bananas"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "The number of bananas won't be negative,OK?"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "------------END------------"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return
.end method
