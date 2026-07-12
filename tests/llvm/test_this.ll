@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [2 x ptr] [ptr @"A.InitA", ptr @"A.f1"]
@.B_vtable = global [4 x ptr] [ptr @"A.InitA", ptr @"A.f1", ptr @"B.InitB", ptr @"B.f2"]
@.C_vtable = global [6 x ptr] [ptr @"A.InitA", ptr @"A.f1", ptr @"B.InitB", ptr @"B.f2", ptr @"C.InitC", ptr @"C.f3"]
@.D_vtable = global [8 x ptr] [ptr @"A.InitA", ptr @"A.f1", ptr @"B.InitB", ptr @"B.f2", ptr @"C.InitC", ptr @"C.f3", ptr @"D.InitD", ptr @"D.f4"]
@.E_vtable = global [10 x ptr] [ptr @"A.InitA", ptr @"A.f1", ptr @"B.InitB", ptr @"B.f2", ptr @"C.InitC", ptr @"C.f3", ptr @"D.InitD", ptr @"D.f4", ptr @"E.InitE", ptr @"E.f5"]
@.F_vtable = global [1 x ptr] [ptr @"F.InitF_E"]

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
	%e = alloca ptr
	store ptr null, ptr %e

	%f = alloca ptr
	store ptr null, ptr %f

	%r0 = call ptr @calloc(i32 1, i32 28)
	%r1 = getelementptr [10 x ptr], ptr @.E_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	store ptr %r0, ptr %e

	%r2 = call ptr @calloc(i32 1, i32 16)
	%r3 = getelementptr [1 x ptr], ptr @.F_vtable, i32 0, i32 0
	store ptr %r3, ptr %r2

	store ptr %r2, ptr %f

	%r4 = load ptr, ptr %e
	%r5 = load ptr, ptr %r4
	%r6 = getelementptr ptr, ptr %r5, i32 8

	%r7 = load ptr, ptr %r6
	%r8 = call i32 %r7(ptr %r4)

	call void @print_int(i32 %r8)

	%r9 = load ptr, ptr %e
	%r10 = load ptr, ptr %r9
	%r11 = getelementptr ptr, ptr %r10, i32 9

	%r12 = load ptr, ptr %r11
	%r13 = call i32 %r12(ptr %r9)

	call void @print_int(i32 %r13)

	%r14 = load ptr, ptr %f
	%r15 = load ptr, ptr %e
	%r16 = load ptr, ptr %r14
	%r17 = getelementptr ptr, ptr %r16, i32 0

	%r18 = load ptr, ptr %r17
	%r19 = call i32 %r18(ptr %r14, ptr %r15)

	call void @print_int(i32 %r19)

	ret i32 0
}

define i32@"A.InitA"(ptr %this) {
	%r20 = getelementptr i8, ptr %this, i32 8
	store i32 1024, ptr %r20

	%r21 = getelementptr i8, ptr %this, i32 8
	%r22 = load i32, ptr %r21

	ret i32 %r22
}

define i32@"A.f1"(ptr %this) {
	ret i32 1
}

define i32@"B.InitB"(ptr %this) {
	%r23 = getelementptr i8, ptr %this, i32 12
	store i32 2048, ptr %r23

	%r24 = getelementptr i8, ptr %this, i32 12
	%r25 = load i32, ptr %r24

	%r26 = load ptr, ptr %this
	%r27 = getelementptr ptr, ptr %r26, i32 0

	%r28 = load ptr, ptr %r27
	%r29 = call i32 %r28(ptr %this)

	%r30 = add i32 %r25, %r29

	ret i32 %r30
}

define i32@"B.f2"(ptr %this) {
	%r31 = load ptr, ptr %this
	%r32 = getelementptr ptr, ptr %r31, i32 1

	%r33 = load ptr, ptr %r32
	%r34 = call i32 %r33(ptr %this)

	%r35 = add i32 2, %r34

	ret i32 %r35
}

define i32@"C.InitC"(ptr %this) {
	%r36 = getelementptr i8, ptr %this, i32 16
	store i32 4096, ptr %r36

	%r37 = getelementptr i8, ptr %this, i32 16
	%r38 = load i32, ptr %r37

	%r39 = load ptr, ptr %this
	%r40 = getelementptr ptr, ptr %r39, i32 2

	%r41 = load ptr, ptr %r40
	%r42 = call i32 %r41(ptr %this)

	%r43 = add i32 %r38, %r42

	ret i32 %r43
}

define i32@"C.f3"(ptr %this) {
	%r44 = load ptr, ptr %this
	%r45 = getelementptr ptr, ptr %r44, i32 3

	%r46 = load ptr, ptr %r45
	%r47 = call i32 %r46(ptr %this)

	%r48 = add i32 3, %r47

	ret i32 %r48
}

define i32@"D.InitD"(ptr %this) {
	%r49 = getelementptr i8, ptr %this, i32 20
	store i32 8192, ptr %r49

	%r50 = getelementptr i8, ptr %this, i32 20
	%r51 = load i32, ptr %r50

	%r52 = load ptr, ptr %this
	%r53 = getelementptr ptr, ptr %r52, i32 4

	%r54 = load ptr, ptr %r53
	%r55 = call i32 %r54(ptr %this)

	%r56 = add i32 %r51, %r55

	ret i32 %r56
}

define i32@"D.f4"(ptr %this) {
	%r57 = load ptr, ptr %this
	%r58 = getelementptr ptr, ptr %r57, i32 5

	%r59 = load ptr, ptr %r58
	%r60 = call i32 %r59(ptr %this)

	%r61 = add i32 4, %r60

	ret i32 %r61
}

define i32@"E.InitE"(ptr %this) {
	%r62 = getelementptr i8, ptr %this, i32 24
	store i32 16384, ptr %r62

	%r63 = getelementptr i8, ptr %this, i32 24
	%r64 = load i32, ptr %r63

	%r65 = load ptr, ptr %this
	%r66 = getelementptr ptr, ptr %r65, i32 6

	%r67 = load ptr, ptr %r66
	%r68 = call i32 %r67(ptr %this)

	%r69 = add i32 %r64, %r68

	ret i32 %r69
}

define i32@"E.f5"(ptr %this) {
	%r70 = load ptr, ptr %this
	%r71 = getelementptr ptr, ptr %r70, i32 7

	%r72 = load ptr, ptr %r71
	%r73 = call i32 %r72(ptr %this)

	%r74 = add i32 5, %r73

	ret i32 %r74
}

define i32@"F.InitF_E"(ptr %this, ptr %_e) {
	%e = alloca ptr
	store ptr %_e, ptr %e

	%r75 = load ptr, ptr %e
	%r76 = getelementptr i8, ptr %this, i32 8
	store ptr %r75, ptr %r76

	%r77 = load ptr, ptr %e
	%r78 = load ptr, ptr %r77
	%r79 = getelementptr ptr, ptr %r78, i32 9

	%r80 = load ptr, ptr %r79
	%r81 = call i32 %r80(ptr %r77)

	ret i32 %r81
}
