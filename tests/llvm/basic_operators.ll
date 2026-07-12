@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [1 x ptr] [ptr @"A.getData"]

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
	%i = alloca i32
	store i32 0, ptr %i

	%j = alloca i32
	store i32 0, ptr %j

	store i32 10, ptr %i

	store i32 20, ptr %j

	%r0 = add i32 1, 2

	%r1 = add i32 %r0, 3

	%r2 = load i32, ptr %i
	%r3 = add i32 %r1, %r2

	%r4 = load i32, ptr %j
	%r5 = add i32 %r3, %r4

	call void @print_int(i32 %r5)

	%r6 = mul i32 1, 2

	%r7 = mul i32 %r6, 3

	%r8 = load i32, ptr %i
	%r9 = mul i32 %r7, %r8

	%r10 = load i32, ptr %j
	%r11 = mul i32 %r9, %r10

	call void @print_int(i32 %r11)

	%r12 = mul i32 1, 2

	%r13 = mul i32 %r12, 3

	%r14 = load i32, ptr %i
	%r15 = sub i32 %r13, %r14

	%r16 = load i32, ptr %j
	%r17 = add i32 %r15, %r16

	call void @print_int(i32 %r17)

	%r18 = call ptr @calloc(i32 1, i32 8)
	%r19 = getelementptr [1 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r19, ptr %r18

	%r20 = load ptr, ptr %r18
	%r21 = getelementptr ptr, ptr %r20, i32 0

	%r22 = load ptr, ptr %r21
	%r23 = call i32 %r22(ptr %r18)

	%r24 = mul i32 1, %r23

	%r25 = mul i32 %r24, 3

	%r26 = load i32, ptr %i
	%r27 = sub i32 %r25, %r26

	%r28 = add i32 %r27, 20

	call void @print_int(i32 %r28)

	ret i32 0
}

define i32@"A.getData"(ptr %this) {
	ret i32 100
}
