@.LinearSearch_vtable = global [0 x ptr] []
@.LS_vtable = global [4 x ptr] [ptr @"LS.Start_int", ptr @"LS.Print", ptr @"LS.Search_int", ptr @"LS.Init_int"]

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
	%r0 = call ptr @calloc(i32 1, i32 20)
	%r1 = getelementptr [4 x ptr], ptr @.LS_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 10)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"LS.Start_int"(ptr %this, i32 %_sz) {
	%sz = alloca i32
	store i32 %_sz, ptr %sz

	%aux01 = alloca i32
	store i32 0, ptr %aux01

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	%r6 = load i32, ptr %sz
	%r7 = load ptr, ptr %this
	%r8 = getelementptr ptr, ptr %r7, i32 3

	%r9 = load ptr, ptr %r8
	%r10 = call i32 %r9(ptr %this, i32 %r6)

	store i32 %r10, ptr %aux01

	%r11 = load ptr, ptr %this
	%r12 = getelementptr ptr, ptr %r11, i32 1

	%r13 = load ptr, ptr %r12
	%r14 = call i32 %r13(ptr %this)

	store i32 %r14, ptr %aux02

	call void @print_int(i32 9999)

	%r15 = load ptr, ptr %this
	%r16 = getelementptr ptr, ptr %r15, i32 2

	%r17 = load ptr, ptr %r16
	%r18 = call i32 %r17(ptr %this, i32 8)

	call void @print_int(i32 %r18)

	%r19 = load ptr, ptr %this
	%r20 = getelementptr ptr, ptr %r19, i32 2

	%r21 = load ptr, ptr %r20
	%r22 = call i32 %r21(ptr %this, i32 12)

	call void @print_int(i32 %r22)

	%r23 = load ptr, ptr %this
	%r24 = getelementptr ptr, ptr %r23, i32 2

	%r25 = load ptr, ptr %r24
	%r26 = call i32 %r25(ptr %this, i32 17)

	call void @print_int(i32 %r26)

	%r27 = load ptr, ptr %this
	%r28 = getelementptr ptr, ptr %r27, i32 2

	%r29 = load ptr, ptr %r28
	%r30 = call i32 %r29(ptr %this, i32 50)

	call void @print_int(i32 %r30)

	ret i32 55
}

define i32@"LS.Print"(ptr %this) {
	%j = alloca i32
	store i32 0, ptr %j

	store i32 1, ptr %j

	br label %l0
l0:
	%r31 = load i32, ptr %j
	%r32 = getelementptr i8, ptr %this, i32 16
	%r33 = load i32, ptr %r32

	%r34 = icmp slt i32 %r31, %r33

	br i1 %r34, label %l1, label %l2

l1:
	%r35 = getelementptr i8, ptr %this, i32 8
	%r36 = load ptr, ptr %r35

	%r37 = load i32, ptr %j
	%r38 = load i32, ptr %r36
	%r39 = icmp sge i32 %r38, 1
	br i1 %r39, label %l4, label %l3

l3:
	call void @throw_oob()
	br label %l4

l4:
	%r40 = add i32 1, %r37
	%r41 = getelementptr i32, ptr %r36, i32 %r40
	%r42 = load i32, ptr %r41

	call void @print_int(i32 %r42)

	%r43 = load i32, ptr %j
	%r44 = add i32 %r43, 1

	store i32 %r44, ptr %j

	br label %l0

l2:
	ret i32 0
}

define i32@"LS.Search_int"(ptr %this, i32 %_num) {
	%num = alloca i32
	store i32 %_num, ptr %num

	%j = alloca i32
	store i32 0, ptr %j

	%ls01 = alloca i1
	store i1 0, ptr %ls01

	%ifound = alloca i32
	store i32 0, ptr %ifound

	%aux01 = alloca i32
	store i32 0, ptr %aux01

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	%nt = alloca i32
	store i32 0, ptr %nt

	store i32 1, ptr %j

	store i1 0, ptr %ls01

	store i32 0, ptr %ifound

	br label %l5
l5:
	%r45 = load i32, ptr %j
	%r46 = getelementptr i8, ptr %this, i32 16
	%r47 = load i32, ptr %r46

	%r48 = icmp slt i32 %r45, %r47

	br i1 %r48, label %l6, label %l7

l6:
	%r49 = getelementptr i8, ptr %this, i32 8
	%r50 = load ptr, ptr %r49

	%r51 = load i32, ptr %j
	%r52 = load i32, ptr %r50
	%r53 = icmp sge i32 %r52, 1
	br i1 %r53, label %l9, label %l8

l8:
	call void @throw_oob()
	br label %l9

l9:
	%r54 = add i32 1, %r51
	%r55 = getelementptr i32, ptr %r50, i32 %r54
	%r56 = load i32, ptr %r55

	store i32 %r56, ptr %aux01

	%r57 = load i32, ptr %num
	%r58 = add i32 %r57, 1

	store i32 %r58, ptr %aux02

	%r59 = load i32, ptr %aux01
	%r60 = load i32, ptr %num
	%r61 = icmp slt i32 %r59, %r60

	br i1 %r61, label %l10, label %l11

l11:
	%r62 = load i32, ptr %aux01
	%r63 = load i32, ptr %aux02
	%r64 = icmp slt i32 %r62, %r63

	%r65 = xor i1 1, %r64

	br i1 %r65, label %l13, label %l14

l14:
	store i1 1, ptr %ls01

	store i32 1, ptr %ifound

	%r66 = getelementptr i8, ptr %this, i32 16
	%r67 = load i32, ptr %r66

	store i32 %r67, ptr %j

	br label %l15

l13:
	store i32 0, ptr %nt

	br label %l15

l15:
	br label %l12

l10:
	store i32 0, ptr %nt

	br label %l12

l12:
	%r68 = load i32, ptr %j
	%r69 = add i32 %r68, 1

	store i32 %r69, ptr %j

	br label %l5

l7:
	%r70 = load i32, ptr %ifound
	ret i32 %r70
}

define i32@"LS.Init_int"(ptr %this, i32 %_sz) {
	%sz = alloca i32
	store i32 %_sz, ptr %sz

	%j = alloca i32
	store i32 0, ptr %j

	%k = alloca i32
	store i32 0, ptr %k

	%aux01 = alloca i32
	store i32 0, ptr %aux01

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	%r71 = load i32, ptr %sz
	%r72 = getelementptr i8, ptr %this, i32 16
	store i32 %r71, ptr %r72

	%r73 = load i32, ptr %sz
	%r74 = add i32 1, %r73
	%r75 = icmp sge i32 %r74, 1
	br i1 %r75, label %l17, label %l16

l16:
	call void @throw_oob()
	br label %l17

l17:
	%r76 = call ptr @calloc(i32 %r74, i32 4)
	store i32 %r73, ptr %r76

	%r77 = getelementptr i8, ptr %this, i32 8
	store ptr %r76, ptr %r77

	store i32 1, ptr %j

	%r78 = getelementptr i8, ptr %this, i32 16
	%r79 = load i32, ptr %r78

	%r80 = add i32 %r79, 1

	store i32 %r80, ptr %k

	br label %l18
l18:
	%r81 = load i32, ptr %j
	%r82 = getelementptr i8, ptr %this, i32 16
	%r83 = load i32, ptr %r82

	%r84 = icmp slt i32 %r81, %r83

	br i1 %r84, label %l19, label %l20

l19:
	%r85 = load i32, ptr %j
	%r86 = mul i32 2, %r85

	store i32 %r86, ptr %aux01

	%r87 = load i32, ptr %k
	%r88 = sub i32 %r87, 3

	store i32 %r88, ptr %aux02

	%r89 = load i32, ptr %j
	%r90 = load i32, ptr %aux01
	%r91 = load i32, ptr %aux02
	%r92 = add i32 %r90, %r91

	%r93 = getelementptr i8, ptr %this, i32 8
	%r94 = load ptr, ptr %r93
	%r95 = load i32, ptr %r94

	%r96 = icmp sge i32 %r95, 1
	br i1 %r96, label %l22, label %l21

l21:
	call void @throw_oob()
	br label %l22

l22:
	%r98 = add i32 1, %r89
	%r99 = getelementptr i32, ptr %r94, i32 %r98

	store i32 %r92, ptr %r99

	%r100 = load i32, ptr %j
	%r101 = add i32 %r100, 1

	store i32 %r101, ptr %j

	%r102 = load i32, ptr %k
	%r103 = sub i32 %r102, 1

	store i32 %r103, ptr %k

	br label %l18

l20:
	ret i32 0
}
