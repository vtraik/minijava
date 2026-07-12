@.Main_vtable = global [0 x ptr] []

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
	%b = alloca ptr
	store ptr null, ptr %b

	%x = alloca i32
	store i32 0, ptr %x

	%r0 = sub i32 1, 2

	store i32 %r0, ptr %x

	%r1 = load i32, ptr %x
	%r2 = add i32 1, %r1
	%r3 = icmp sge i32 %r2, 1
	br i1 %r3, label %l1, label %l0

l0:
	call void @throw_oob()
	br label %l1

l1:
	%r4 = call ptr @calloc(i32 %r2, i32 4)
	store i32 %r1, ptr %r4

	store ptr %r4, ptr %b

	ret i32 0
}
