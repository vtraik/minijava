@.MoreThan4_vtable = global [0 x ptr] []
@.MT4_vtable = global [2 x ptr] [ptr @"MT4.Start_int_int_int_int_int_int", ptr @"MT4.Change_int_int_int_int_int_int"]

declare ptr @calloc(i32, i32)
declare i32 @printf(ptr, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"

define void @print_int(i32 %i) {
	call i32 (ptr, ...) @printf(ptr @_cint, i32 %i)
	ret void
}

define void @throw_oob() {
	call i32 (ptr, ...) @printf(ptr @_cOOB)
	call void @exit(i32 1)
	ret void
}

define i32 @main() {
	%r0 = call ptr @calloc(i32 1, i32 8)
	%r1 = getelementptr [2 x ptr], ptr @.MT4_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 1, i32  2, i32  3, i32  4, i32  5, i32  6)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"MT4.Start_int_int_int_int_int_int"(ptr %this, i32 %_p1, i32 %_p2, i32 %_p3, i32 %_p4, i32 %_p5, i32 %_p6) {
	%p1 = alloca i32
	store i32 %_p1, ptr %p1

	%p2 = alloca i32
	store i32 %_p2, ptr %p2

	%p3 = alloca i32
	store i32 %_p3, ptr %p3

	%p4 = alloca i32
	store i32 %_p4, ptr %p4

	%p5 = alloca i32
	store i32 %_p5, ptr %p5

	%p6 = alloca i32
	store i32 %_p6, ptr %p6

	%aux = alloca i32
	store i32 0, ptr %aux

	%r6 = load i32, ptr %p1
	call void @print_int(i32 %r6)

	%r7 = load i32, ptr %p2
	call void @print_int(i32 %r7)

	%r8 = load i32, ptr %p3
	call void @print_int(i32 %r8)

	%r9 = load i32, ptr %p4
	call void @print_int(i32 %r9)

	%r10 = load i32, ptr %p5
	call void @print_int(i32 %r10)

	%r11 = load i32, ptr %p6
	call void @print_int(i32 %r11)

	%r12 = load i32, ptr %p6
	%r13 = load i32, ptr %p5
	%r14 = load i32, ptr %p4
	%r15 = load i32, ptr %p3
	%r16 = load i32, ptr %p2
	%r17 = load i32, ptr %p1
	%r18 = load ptr, ptr %this
	%r19 = getelementptr ptr, ptr %r18, i32 1

	%r20 = load ptr, ptr %r19
	%r21 = call i32 %r20(ptr %this, i32 %r12, i32  %r13, i32  %r14, i32  %r15, i32  %r16, i32  %r17)

	store i32 %r21, ptr %aux

	%r22 = load i32, ptr %aux
	ret i32 %r22
}

define i32@"MT4.Change_int_int_int_int_int_int"(ptr %this, i32 %_p1, i32 %_p2, i32 %_p3, i32 %_p4, i32 %_p5, i32 %_p6) {
	%p1 = alloca i32
	store i32 %_p1, ptr %p1

	%p2 = alloca i32
	store i32 %_p2, ptr %p2

	%p3 = alloca i32
	store i32 %_p3, ptr %p3

	%p4 = alloca i32
	store i32 %_p4, ptr %p4

	%p5 = alloca i32
	store i32 %_p5, ptr %p5

	%p6 = alloca i32
	store i32 %_p6, ptr %p6

	%r23 = load i32, ptr %p1
	call void @print_int(i32 %r23)

	%r24 = load i32, ptr %p2
	call void @print_int(i32 %r24)

	%r25 = load i32, ptr %p3
	call void @print_int(i32 %r25)

	%r26 = load i32, ptr %p4
	call void @print_int(i32 %r26)

	%r27 = load i32, ptr %p5
	call void @print_int(i32 %r27)

	%r28 = load i32, ptr %p6
	call void @print_int(i32 %r28)

	ret i32 0
}
