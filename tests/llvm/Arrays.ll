@.Arrays_vtable = global [0 x ptr] []

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
	%x = alloca ptr
	store ptr null, ptr %x

	%r0 = add i32 1, 2
	%r1 = icmp sge i32 %r0, 1
	br i1 %r1, label %l1, label %l0

l0:
	call void @throw_oob()
	br label %l1

l1:
	%r2 = call ptr @calloc(i32 %r0, i32 4)
	store i32 2, ptr %r2

	store ptr %r2, ptr %x

	%r3 = load ptr, ptr %x
	%r4 = load i32, ptr %r3

	%r5 = icmp sge i32 %r4, 1
	br i1 %r5, label %l3, label %l2

l2:
	call void @throw_oob()
	br label %l3

l3:
	%r7 = add i32 1, 0
	%r8 = getelementptr i32, ptr %r3, i32 %r7

	store i32 1, ptr %r8

	%r9 = load ptr, ptr %x
	%r10 = load i32, ptr %r9

	%r11 = icmp sge i32 %r10, 1
	br i1 %r11, label %l5, label %l4

l4:
	call void @throw_oob()
	br label %l5

l5:
	%r13 = add i32 1, 1
	%r14 = getelementptr i32, ptr %r9, i32 %r13

	store i32 2, ptr %r14

	%r15 = load ptr, ptr %x
	%r16 = load i32, ptr %r15
	%r17 = icmp sge i32 %r16, 1
	br i1 %r17, label %l7, label %l6

l6:
	call void @throw_oob()
	br label %l7

l7:
	%r18 = add i32 1, 0
	%r19 = getelementptr i32, ptr %r15, i32 %r18
	%r20 = load i32, ptr %r19

	%r21 = load ptr, ptr %x
	%r22 = load i32, ptr %r21
	%r23 = icmp sge i32 %r22, 1
	br i1 %r23, label %l9, label %l8

l8:
	call void @throw_oob()
	br label %l9

l9:
	%r24 = add i32 1, 1
	%r25 = getelementptr i32, ptr %r21, i32 %r24
	%r26 = load i32, ptr %r25

	%r27 = add i32 %r20, %r26

	call void @print_int(i32 %r27)

	ret i32 0
}
