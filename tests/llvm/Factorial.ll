@.Factorial_vtable = global [0 x ptr] []
@.Fac_vtable = global [1 x ptr] [ptr @"Fac.ComputeFac_int"]

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
	%r1 = getelementptr [1 x ptr], ptr @.Fac_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 10)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"Fac.ComputeFac_int"(ptr %this, i32 %_num) {
	%num = alloca i32
	store i32 %_num, ptr %num

	%num_aux = alloca i32
	store i32 0, ptr %num_aux

	%r6 = load i32, ptr %num
	%r7 = icmp slt i32 %r6, 1

	br i1 %r7, label %l0, label %l1

l1:
	%r8 = load i32, ptr %num
	%r9 = load i32, ptr %num
	%r10 = sub i32 %r9, 1

	%r11 = load ptr, ptr %this
	%r12 = getelementptr ptr, ptr %r11, i32 0

	%r13 = load ptr, ptr %r12
	%r14 = call i32 %r13(ptr %this, i32 %r10)

	%r15 = mul i32 %r8, %r14

	store i32 %r15, ptr %num_aux

	br label %l2

l0:
	store i32 1, ptr %num_aux

	br label %l2

l2:
	%r16 = load i32, ptr %num_aux
	ret i32 %r16
}
