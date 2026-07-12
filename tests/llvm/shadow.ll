@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [3 x ptr] [ptr @"A.set_x", ptr @"A.x", ptr @"A.y"]
@.B_vtable = global [3 x ptr] [ptr @"B.set_x", ptr @"B.x", ptr @"A.y"]
@.C_vtable = global [3 x ptr] [ptr @"C.get_class_x", ptr @"C.get_method_x", ptr @"C.set_int_x"]
@.D_vtable = global [4 x ptr] [ptr @"C.get_class_x", ptr @"C.get_method_x", ptr @"C.set_int_x", ptr @"D.get_class_x2"]
@.E_vtable = global [6 x ptr] [ptr @"C.get_class_x", ptr @"C.get_method_x", ptr @"C.set_int_x", ptr @"D.get_class_x2", ptr @"E.set_bool_x", ptr @"E.get_bool_x"]

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
	%a = alloca ptr
	store ptr null, ptr %a

	%c = alloca ptr
	store ptr null, ptr %c

	%d = alloca ptr
	store ptr null, ptr %d

	%e = alloca ptr
	store ptr null, ptr %e

	%dummy = alloca i1
	store i1 0, ptr %dummy

	%r0 = call ptr @calloc(i32 1, i32 16)
	%r1 = getelementptr [3 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	store ptr %r0, ptr %a

	%r2 = load ptr, ptr %a
	%r3 = load ptr, ptr %r2
	%r4 = getelementptr ptr, ptr %r3, i32 0

	%r5 = load ptr, ptr %r4
	%r6 = call i1 %r5(ptr %r2)

	store i1 %r6, ptr %dummy

	%r7 = load ptr, ptr %a
	%r8 = load ptr, ptr %r7
	%r9 = getelementptr ptr, ptr %r8, i32 1

	%r10 = load ptr, ptr %r9
	%r11 = call i32 %r10(ptr %r7)

	call void @print_int(i32 %r11)

	%r12 = load ptr, ptr %a
	%r13 = load ptr, ptr %r12
	%r14 = getelementptr ptr, ptr %r13, i32 2

	%r15 = load ptr, ptr %r14
	%r16 = call i32 %r15(ptr %r12)

	call void @print_int(i32 %r16)

	%r17 = call ptr @calloc(i32 1, i32 20)
	%r18 = getelementptr [3 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r18, ptr %r17

	store ptr %r17, ptr %a

	%r19 = load ptr, ptr %a
	%r20 = load ptr, ptr %r19
	%r21 = getelementptr ptr, ptr %r20, i32 0

	%r22 = load ptr, ptr %r21
	%r23 = call i1 %r22(ptr %r19)

	store i1 %r23, ptr %dummy

	%r24 = load ptr, ptr %a
	%r25 = load ptr, ptr %r24
	%r26 = getelementptr ptr, ptr %r25, i32 1

	%r27 = load ptr, ptr %r26
	%r28 = call i32 %r27(ptr %r24)

	call void @print_int(i32 %r28)

	%r29 = load ptr, ptr %a
	%r30 = load ptr, ptr %r29
	%r31 = getelementptr ptr, ptr %r30, i32 2

	%r32 = load ptr, ptr %r31
	%r33 = call i32 %r32(ptr %r29)

	call void @print_int(i32 %r33)

	%r34 = call ptr @calloc(i32 1, i32 12)
	%r35 = getelementptr [3 x ptr], ptr @.C_vtable, i32 0, i32 0
	store ptr %r35, ptr %r34

	store ptr %r34, ptr %c

	%r36 = load ptr, ptr %c
	%r37 = load ptr, ptr %r36
	%r38 = getelementptr ptr, ptr %r37, i32 1

	%r39 = load ptr, ptr %r38
	%r40 = call i32 %r39(ptr %r36)

	call void @print_int(i32 %r40)

	%r41 = load ptr, ptr %c
	%r42 = load ptr, ptr %r41
	%r43 = getelementptr ptr, ptr %r42, i32 0

	%r44 = load ptr, ptr %r43
	%r45 = call i32 %r44(ptr %r41)

	call void @print_int(i32 %r45)

	%r46 = call ptr @calloc(i32 1, i32 13)
	%r47 = getelementptr [4 x ptr], ptr @.D_vtable, i32 0, i32 0
	store ptr %r47, ptr %r46

	store ptr %r46, ptr %d

	%r48 = load ptr, ptr %d
	%r49 = load ptr, ptr %r48
	%r50 = getelementptr ptr, ptr %r49, i32 2

	%r51 = load ptr, ptr %r50
	%r52 = call i1 %r51(ptr %r48)

	store i1 %r52, ptr %dummy

	%r53 = load ptr, ptr %d
	%r54 = load ptr, ptr %r53
	%r55 = getelementptr ptr, ptr %r54, i32 3

	%r56 = load ptr, ptr %r55
	%r57 = call i1 %r56(ptr %r53)

	br i1 %r57, label %l0, label %l1

l1:
	call void @print_int(i32 0)

	br label %l2

l0:
	call void @print_int(i32 1)

	br label %l2

l2:
	%r58 = call ptr @calloc(i32 1, i32 14)
	%r59 = getelementptr [6 x ptr], ptr @.E_vtable, i32 0, i32 0
	store ptr %r59, ptr %r58

	store ptr %r58, ptr %e

	%r60 = load ptr, ptr %e
	%r61 = load ptr, ptr %r60
	%r62 = getelementptr ptr, ptr %r61, i32 2

	%r63 = load ptr, ptr %r62
	%r64 = call i1 %r63(ptr %r60)

	store i1 %r64, ptr %dummy

	%r65 = load ptr, ptr %e
	%r66 = load ptr, ptr %r65
	%r67 = getelementptr ptr, ptr %r66, i32 3

	%r68 = load ptr, ptr %r67
	%r69 = call i1 %r68(ptr %r65)

	br i1 %r69, label %l3, label %l4

l4:
	call void @print_int(i32 0)

	br label %l5

l3:
	call void @print_int(i32 1)

	br label %l5

l5:
	%r70 = load ptr, ptr %e
	%r71 = load ptr, ptr %r70
	%r72 = getelementptr ptr, ptr %r71, i32 4

	%r73 = load ptr, ptr %r72
	%r74 = call i1 %r73(ptr %r70)

	store i1 %r74, ptr %dummy

	%r75 = load ptr, ptr %e
	%r76 = load ptr, ptr %r75
	%r77 = getelementptr ptr, ptr %r76, i32 5

	%r78 = load ptr, ptr %r77
	%r79 = call i1 %r78(ptr %r75)

	br i1 %r79, label %l6, label %l7

l7:
	call void @print_int(i32 0)

	br label %l8

l6:
	call void @print_int(i32 1)

	br label %l8

l8:
	ret i32 0
}

define i1@"A.set_x"(ptr %this) {
	%r80 = getelementptr i8, ptr %this, i32 8
	store i32 1, ptr %r80

	ret i1 1
}

define i32@"A.x"(ptr %this) {
	%r81 = getelementptr i8, ptr %this, i32 8
	%r82 = load i32, ptr %r81

	ret i32 %r82
}

define i32@"A.y"(ptr %this) {
	%r83 = getelementptr i8, ptr %this, i32 12
	%r84 = load i32, ptr %r83

	ret i32 %r84
}

define i1@"B.set_x"(ptr %this) {
	%r85 = getelementptr i8, ptr %this, i32 16
	store i32 2, ptr %r85

	ret i1 1
}

define i32@"B.x"(ptr %this) {
	%r86 = getelementptr i8, ptr %this, i32 16
	%r87 = load i32, ptr %r86

	ret i32 %r87
}

define i32@"C.get_class_x"(ptr %this) {
	%r88 = getelementptr i8, ptr %this, i32 8
	%r89 = load i32, ptr %r88

	ret i32 %r89
}

define i32@"C.get_method_x"(ptr %this) {
	%x = alloca i32
	store i32 0, ptr %x

	store i32 3, ptr %x

	%r90 = load i32, ptr %x
	ret i32 %r90
}

define i1@"C.set_int_x"(ptr %this) {
	%r91 = getelementptr i8, ptr %this, i32 8
	store i32 20, ptr %r91

	ret i1 1
}

define i1@"D.get_class_x2"(ptr %this) {
	%r92 = getelementptr i8, ptr %this, i32 12
	%r93 = load i1, ptr %r92

	ret i1 %r93
}

define i1@"E.set_bool_x"(ptr %this) {
	%r94 = getelementptr i8, ptr %this, i32 13
	store i1 1, ptr %r94

	ret i1 1
}

define i1@"E.get_bool_x"(ptr %this) {
	%r95 = getelementptr i8, ptr %this, i32 13
	%r96 = load i1, ptr %r95

	ret i1 %r96
}
