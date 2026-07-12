@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [1 x ptr] [ptr @"A.foo_int"]

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
	%r1 = getelementptr [1 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 1)

	call void @print_int(i32 %r5)

	%r6 = call ptr @calloc(i32 1, i32 8)
	%r7 = getelementptr [1 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r7, ptr %r6

	%r8 = load ptr, ptr %r6
	%r9 = getelementptr ptr, ptr %r8, i32 0

	%r10 = load ptr, ptr %r9
	%r11 = call i32 %r10(ptr %r6, i32 2)

	call void @print_int(i32 %r11)

	ret i32 0
}

define i32@"A.foo_int"(ptr %this, i32 %_a) {
	%a = alloca i32
	store i32 %_a, ptr %a

	%r12 = load i32, ptr %a
	%r13 = icmp slt i32 %r12, 2

	br i1 %r13, label %l0, label %l1

l1:
	store i32 4, ptr %a

	br label %l2

l0:
	store i32 3, ptr %a

	br label %l2

l2:
	%r14 = load i32, ptr %a
	ret i32 %r14
}
