@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [2 x ptr] [ptr @"A.foo", ptr @"A.bar_int_boolean"]

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
	%dummy = alloca i32
	store i32 0, ptr %dummy

	%a = alloca ptr
	store ptr null, ptr %a

	%r0 = call ptr @calloc(i32 1, i32 8)
	%r1 = getelementptr [2 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	store ptr %r0, ptr %a

	%r2 = load ptr, ptr %a
	%r3 = load ptr, ptr %r2
	%r4 = getelementptr ptr, ptr %r3, i32 0

	%r5 = load ptr, ptr %r4
	%r6 = call i32 %r5(ptr %r2)

	store i32 %r6, ptr %dummy

	ret i32 0
}

define i32@"A.foo"(ptr %this) {
	%a = alloca i32
	store i32 0, ptr %a

	%b = alloca i32
	store i32 0, ptr %b

	store i32 3, ptr %a

	br label %l0
l0:
	%r7 = load i32, ptr %a
	%r8 = icmp slt i32 %r7, 4

	br i1 %r8, label %l1, label %l2

l1:
	%r9 = load i32, ptr %a
	%r10 = add i32 %r9, 1

	store i32 %r10, ptr %a

	br label %l0

l2:
	%r11 = load i32, ptr %a
	call void @print_int(i32 %r11)

	%r12 = load ptr, ptr %this
	%r13 = getelementptr ptr, ptr %r12, i32 1

	%r14 = load ptr, ptr %r13
	%r15 = call i32 %r14(ptr %this, i32 7, i1  1)

	store i32 %r15, ptr %b

	%r16 = load i32, ptr %b
	call void @print_int(i32 %r16)

	ret i32 0
}

define i32@"A.bar_int_boolean"(ptr %this, i32 %_a, i1 %_cond) {
	%a = alloca i32
	store i32 %_a, ptr %a

	%cond = alloca i1
	store i1 %_cond, ptr %cond

	%b = alloca i32
	store i32 0, ptr %b

	br label %l3
l3:
	%r17 = load i1, ptr %cond
	br i1 %r17, label %l4, label %l5

l4:
	%r18 = load i32, ptr %a
	store i32 %r18, ptr %b

	%r19 = load i1, ptr %cond
	br i1 %r19, label %l6, label %l7

l7:
	br label %l8

l6:
	store i32 2, ptr %a

	br label %l8

l8:
	store i1 0, ptr %cond

	br label %l3

l5:
	%r20 = load i32, ptr %b
	ret i32 %r20
}
