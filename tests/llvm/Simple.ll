@.Simple_vtable = global [0 x ptr] []

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
	%x = alloca i32
	store i32 0, ptr %x

	store i32 10, ptr %x

	%r0 = load i32, ptr %x
	call void @print_int(i32 %r0)

	ret i32 0
}
