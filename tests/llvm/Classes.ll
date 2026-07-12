@.Classes_vtable = global [0 x ptr] []
@.Base_vtable = global [2 x ptr] [ptr @"Base.set_int", ptr @"Base.get"]
@.Derived_vtable = global [2 x ptr] [ptr @"Derived.set_int", ptr @"Base.get"]

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

	%d = alloca ptr
	store ptr null, ptr %d

	%r0 = call ptr @calloc(i32 1, i32 12)
	%r1 = getelementptr [2 x ptr], ptr @.Base_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	store ptr %r0, ptr %b

	%r2 = call ptr @calloc(i32 1, i32 12)
	%r3 = getelementptr [2 x ptr], ptr @.Derived_vtable, i32 0, i32 0
	store ptr %r3, ptr %r2

	store ptr %r2, ptr %d

	%r4 = load ptr, ptr %b
	%r5 = load ptr, ptr %r4
	%r6 = getelementptr ptr, ptr %r5, i32 0

	%r7 = load ptr, ptr %r6
	%r8 = call i32 %r7(ptr %r4, i32 1)

	call void @print_int(i32 %r8)

	%r9 = load ptr, ptr %d
	store ptr %r9, ptr %b

	%r10 = load ptr, ptr %b
	%r11 = load ptr, ptr %r10
	%r12 = getelementptr ptr, ptr %r11, i32 0

	%r13 = load ptr, ptr %r12
	%r14 = call i32 %r13(ptr %r10, i32 3)

	call void @print_int(i32 %r14)

	ret i32 0
}

define i32@"Base.set_int"(ptr %this, i32 %_x) {
	%x = alloca i32
	store i32 %_x, ptr %x

	%r15 = load i32, ptr %x
	%r16 = getelementptr i8, ptr %this, i32 8
	store i32 %r15, ptr %r16

	%r17 = getelementptr i8, ptr %this, i32 8
	%r18 = load i32, ptr %r17

	ret i32 %r18
}

define i32@"Base.get"(ptr %this) {
	%r19 = getelementptr i8, ptr %this, i32 8
	%r20 = load i32, ptr %r19

	ret i32 %r20
}

define i32@"Derived.set_int"(ptr %this, i32 %_x) {
	%x = alloca i32
	store i32 %_x, ptr %x

	%r21 = load i32, ptr %x
	%r22 = mul i32 %r21, 2

	%r23 = getelementptr i8, ptr %this, i32 8
	store i32 %r22, ptr %r23

	%r24 = getelementptr i8, ptr %this, i32 8
	%r25 = load i32, ptr %r24

	ret i32 %r25
}
