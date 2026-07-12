@.And_vtable = global [0 x ptr] []

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
	%b = alloca i1
	store i1 0, ptr %b

	%c = alloca i1
	store i1 0, ptr %c

	%x = alloca i32
	store i32 0, ptr %x

	store i1 0, ptr %b

	store i1 1, ptr %c

	%r0 = load i1, ptr %b
	br i1 %r0, label %l0, label %l1

l1:
	br label %l2

l0:
	%r1 = load i1, ptr %c
	br label %l2

l2:
	%r2 = phi i1 [ 0, %l1 ], [ %r1, %l0 ]

	br i1 %r2, label %l3, label %l4

l4:
	store i32 1, ptr %x

	br label %l5

l3:
	store i32 0, ptr %x

	br label %l5

l5:
	%r3 = load i32, ptr %x
	call void @print_int(i32 %r3)

	ret i32 0
}
