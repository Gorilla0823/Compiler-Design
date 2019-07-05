;.source myCompiler.j
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 100
.limit locals 100
	ldc 20
	istore 3
	ldc 7
	istore 2
	iload 3
	iload 2
	iload 3
	iload 2
	if_icmpeq L1
	ldc 5
	istore 2
	goto L2
L1:
	ldc 9
	istore 2
L2:
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "---The result of test3.c---"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "The result of b is "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 2
	invokevirtual java/io/PrintStream/print(I)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	ldc 6.8
	fstore 1
	ldc 9.1
	fstore 0
	fload 1
	ldc 5.2
	fload 1
	ldc 5.2
	fcmpl
	ifge L3
	ldc 5.0
	fstore 0
	goto L4
L3:
	ldc 8.9
	fstore 0
L4:
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "The result of d is "
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	fload 0
	invokevirtual java/io/PrintStream/print(F)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	; print the value.
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "------------END------------"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
return
.end method
