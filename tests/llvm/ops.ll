@.Main_vtable = global [0 x ptr] []
@.A_vtable = global [7 x ptr] [ptr @"A.t", ptr @"A.t2", ptr @"A.lispy_int[]", ptr @"A.t3", ptr @"A.t4_int_int[]", ptr @"A.t5_int[]", ptr @"A.t6_boolean_int[]"]
@.C_vtable = global [1 x ptr] [ptr @"C.test_boolean"]
@.B_vtable = global [2 x ptr] [ptr @"C.test_boolean", ptr @"B.test2_int"]

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
	ret i32 0
}

define i1@"A.t"(ptr %this) {
	%r0 = icmp slt i32 1, 2

	%r1 = xor i1 1, %r0

	br i1 %r1, label %l0, label %l1

l1:
	br label %l2

l0:
	br i1 1, label %l3, label %l4

l4:
	br label %l5

l3:
	br label %l5

l5:
	%r2 = phi i1 [ 0, %l4 ], [ 0, %l3 ]

	br label %l2

l2:
	%r3 = phi i1 [ 0, %l1 ], [ %r2, %l5 ]

	ret i1 %r3
}

define i32@"A.t2"(ptr %this) {
	%r4 = add i32 1, 2

	%r5 = add i32 %r4, 3

	%r6 = add i32 %r5, 4

	ret i32 %r6
}

define i32@"A.lispy_int[]"(ptr %this, ptr %_a) {
	%a = alloca ptr
	store ptr %_a, ptr %a

	%r7 = add i32 1, 2

	%r8 = load ptr, ptr %a
	%r9 = load i32, ptr %r8
	%r10 = icmp sge i32 %r9, 1
	br i1 %r10, label %l7, label %l6

l6:
	call void @throw_oob()
	br label %l7

l7:
	%r11 = add i32 1, 3
	%r12 = getelementptr i32, ptr %r8, i32 %r11
	%r13 = load i32, ptr %r12

	%r14 = add i32 %r7, %r13

	ret i32 %r14
}

define i1@"A.t3"(ptr %this) {
	%a = alloca i32
	store i32 0, ptr %a

	%b = alloca i32
	store i32 0, ptr %b

	store i32 2, ptr %a

	store i32 2, ptr %b

	%r15 = add i32 349, 908

	%r16 = load i32, ptr %a
	%r17 = mul i32 23, %r16

	%r18 = load i32, ptr %b
	%r19 = sub i32 %r18, 2

	%r20 = sub i32 %r17, %r19

	%r21 = icmp slt i32 %r15, %r20

	ret i1 %r21
}

define i1@"A.t4_int_int[]"(ptr %this, i32 %_a, ptr %_b) {
	%a = alloca i32
	store i32 %_a, ptr %a

	%b = alloca ptr
	store ptr %_b, ptr %b

	%arr = alloca ptr
	store ptr null, ptr %arr

	%r22 = add i32 1, 10
	%r23 = icmp sge i32 %r22, 1
	br i1 %r23, label %l9, label %l8

l8:
	call void @throw_oob()
	br label %l9

l9:
	%r24 = call ptr @calloc(i32 %r22, i32 4)
	store i32 10, ptr %r24

	store ptr %r24, ptr %arr

	%r25 = load ptr, ptr %this
	%r26 = getelementptr ptr, ptr %r25, i32 1

	%r27 = load ptr, ptr %r26
	%r28 = call i32 %r27(ptr %this)

	%r29 = add i32 29347, %r28

	%r30 = icmp slt i32 %r29, 12

	br i1 %r30, label %l10, label %l11

l11:
	br label %l12

l10:
	%r31 = load i32, ptr %a
	%r32 = load ptr, ptr %arr
	%r33 = load i32, ptr %r32
	%r34 = icmp sge i32 %r33, 1
	br i1 %r34, label %l14, label %l13

l13:
	call void @throw_oob()
	br label %l14

l14:
	%r35 = add i32 1, 0
	%r36 = getelementptr i32, ptr %r32, i32 %r35
	%r37 = load i32, ptr %r36

	%r38 = icmp slt i32 %r31, %r37

	br i1 %r38, label %l15, label %l16

l16:
	br label %l17

l15:
	%r39 = load ptr, ptr %this
	%r40 = getelementptr ptr, ptr %r39, i32 3

	%r41 = load ptr, ptr %r40
	%r42 = call i1 %r41(ptr %this)

	br label %l17

l17:
	%r43 = phi i1 [ 0, %l16 ], [ %r42, %l15 ]

	br i1 %r43, label %l18, label %l19

l19:
	br label %l20

l18:
	%r44 = load ptr, ptr %this
	%r45 = getelementptr ptr, ptr %r44, i32 1

	%r46 = load ptr, ptr %r45
	%r47 = call i32 %r46(ptr %this)

	%r48 = load ptr, ptr %arr
	%r49 = load ptr, ptr %this
	%r50 = getelementptr ptr, ptr %r49, i32 4

	%r51 = load ptr, ptr %r50
	%r52 = call i1 %r51(ptr %this, i32 %r47, ptr  %r48)

	br label %l20

l20:
	%r53 = phi i1 [ 0, %l19 ], [ %r52, %l18 ]

	br label %l12

l12:
	%r54 = phi i1 [ 0, %l11 ], [ %r53, %l20 ]

	ret i1 %r54
}

define i32@"A.t5_int[]"(ptr %this, ptr %_a) {
	%a = alloca ptr
	store ptr %_a, ptr %a

	%b = alloca i32
	store i32 0, ptr %b

	%r55 = load ptr, ptr %this
	%r56 = getelementptr ptr, ptr %r55, i32 1

	%r57 = load ptr, ptr %r56
	%r58 = call i32 %r57(ptr %this)

	%r59 = load ptr, ptr %a
	%r60 = load i32, ptr %r59
	%r61 = icmp sge i32 %r60, 1
	br i1 %r61, label %l22, label %l21

l21:
	call void @throw_oob()
	br label %l22

l22:
	%r62 = add i32 1, 0
	%r63 = getelementptr i32, ptr %r59, i32 %r62
	%r64 = load i32, ptr %r63

	%r65 = add i32 1, %r64
	%r66 = icmp sge i32 %r65, 1
	br i1 %r66, label %l24, label %l23

l23:
	call void @throw_oob()
	br label %l24

l24:
	%r67 = call ptr @calloc(i32 %r65, i32 4)
	store i32 %r64, ptr %r67

	%r68 = load ptr, ptr %this
	%r69 = getelementptr ptr, ptr %r68, i32 2

	%r70 = load ptr, ptr %r69
	%r71 = call i32 %r70(ptr %this, ptr %r67)

	%r72 = add i32 %r58, %r71

	%r73 = add i32 1, %r72
	%r74 = icmp sge i32 %r73, 1
	br i1 %r74, label %l26, label %l25

l25:
	call void @throw_oob()
	br label %l26

l26:
	%r75 = call ptr @calloc(i32 %r73, i32 4)
	store i32 %r72, ptr %r75

	%r76 = load i32, ptr %r75
	%r77 = icmp sge i32 %r76, 1
	br i1 %r77, label %l28, label %l27

l27:
	call void @throw_oob()
	br label %l28

l28:
	%r78 = add i32 1, 0
	%r79 = getelementptr i32, ptr %r75, i32 %r78
	%r80 = load i32, ptr %r79

	%r81 = add i32 %r80, 10

	%r82 = add i32 1, %r81
	%r83 = icmp sge i32 %r82, 1
	br i1 %r83, label %l30, label %l29

l29:
	call void @throw_oob()
	br label %l30

l30:
	%r84 = call ptr @calloc(i32 %r82, i32 4)
	store i32 %r81, ptr %r84

	%r85 = load i32, ptr %r84
	%r86 = icmp sge i32 %r85, 1
	br i1 %r86, label %l32, label %l31

l31:
	call void @throw_oob()
	br label %l32

l32:
	%r87 = add i32 1, 2
	%r88 = getelementptr i32, ptr %r84, i32 %r87
	%r89 = load i32, ptr %r88

	store i32 %r89, ptr %b

	%r90 = load ptr, ptr %a
	%r91 = load i32, ptr %b
	%r92 = load i32, ptr %r90
	%r93 = icmp sge i32 %r92, 1
	br i1 %r93, label %l34, label %l33

l33:
	call void @throw_oob()
	br label %l34

l34:
	%r94 = add i32 1, %r91
	%r95 = getelementptr i32, ptr %r90, i32 %r94
	%r96 = load i32, ptr %r95

	ret i32 %r96
}

define i1@"A.t6_boolean_int[]"(ptr %this, i1 %_dummy, ptr %_arr) {
	%dummy = alloca i1
	store i1 %_dummy, ptr %dummy

	%arr = alloca ptr
	store ptr %_arr, ptr %arr

	%a = alloca i32
	store i32 0, ptr %a

	%c = alloca ptr
	store ptr null, ptr %c

	store i32 2, ptr %a

	%r97 = call ptr @calloc(i32 1, i32 8)
	%r98 = getelementptr [1 x ptr], ptr @.C_vtable, i32 0, i32 0
	store ptr %r98, ptr %r97

	store ptr %r97, ptr %c

	%r99 = load ptr, ptr %this
	%r100 = getelementptr ptr, ptr %r99, i32 1

	%r101 = load ptr, ptr %r100
	%r102 = call i32 %r101(ptr %this)

	%r103 = add i32 29347, %r102

	%r104 = icmp slt i32 %r103, 12

	br i1 %r104, label %l35, label %l36

l36:
	br label %l37

l35:
	%r105 = load i32, ptr %a
	%r106 = load ptr, ptr %arr
	%r107 = load i32, ptr %r106
	%r108 = icmp sge i32 %r107, 1
	br i1 %r108, label %l39, label %l38

l38:
	call void @throw_oob()
	br label %l39

l39:
	%r109 = add i32 1, 0
	%r110 = getelementptr i32, ptr %r106, i32 %r109
	%r111 = load i32, ptr %r110

	%r112 = icmp slt i32 %r105, %r111

	br i1 %r112, label %l40, label %l41

l41:
	br label %l42

l40:
	%r113 = load ptr, ptr %this
	%r114 = getelementptr ptr, ptr %r113, i32 3

	%r115 = load ptr, ptr %r114
	%r116 = call i1 %r115(ptr %this)

	br label %l42

l42:
	%r117 = phi i1 [ 0, %l41 ], [ %r116, %l40 ]

	br i1 %r117, label %l43, label %l44

l44:
	br label %l45

l43:
	%r118 = call ptr @calloc(i32 1, i32 8)
	%r119 = getelementptr [2 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r119, ptr %r118

	%r120 = load ptr, ptr %r118
	%r121 = getelementptr ptr, ptr %r120, i32 0

	%r122 = load ptr, ptr %r121
	%r123 = call ptr %r122(ptr %r118, i1 1)

	%r124 = load i32, ptr %r123
	%r125 = icmp sge i32 %r124, 1
	br i1 %r125, label %l47, label %l46

l46:
	call void @throw_oob()
	br label %l47

l47:
	%r126 = add i32 1, 0
	%r127 = getelementptr i32, ptr %r123, i32 %r126
	%r128 = load i32, ptr %r127

	%r129 = load ptr, ptr %arr
	%r130 = load ptr, ptr %this
	%r131 = getelementptr ptr, ptr %r130, i32 4

	%r132 = load ptr, ptr %r131
	%r133 = call i1 %r132(ptr %this, i32 %r128, ptr  %r129)

	%r134 = load ptr, ptr %arr
	%r135 = load i32, ptr %r134
	%r136 = icmp sge i32 %r135, 1
	br i1 %r136, label %l49, label %l48

l48:
	call void @throw_oob()
	br label %l49

l49:
	%r137 = add i32 1, 0
	%r138 = getelementptr i32, ptr %r134, i32 %r137
	%r139 = load i32, ptr %r138

	%r140 = add i32 1, %r139
	%r141 = icmp sge i32 %r140, 1
	br i1 %r141, label %l51, label %l50

l50:
	call void @throw_oob()
	br label %l51

l51:
	%r142 = call ptr @calloc(i32 %r140, i32 4)
	store i32 %r139, ptr %r142

	%r143 = load ptr, ptr %this
	%r144 = getelementptr ptr, ptr %r143, i32 6

	%r145 = load ptr, ptr %r144
	%r146 = call i1 %r145(ptr %this, i1 %r133, ptr  %r142)

	br label %l45

l45:
	%r147 = phi i1 [ 0, %l44 ], [ %r146, %l51 ]

	br label %l37

l37:
	%r148 = phi i1 [ 0, %l36 ], [ %r147, %l45 ]

	ret i1 %r148
}

define ptr@"C.test_boolean"(ptr %this, i1 %_a) {
	%a = alloca i1
	store i1 %_a, ptr %a

	%r149 = add i32 1, 10
	%r150 = icmp sge i32 %r149, 1
	br i1 %r150, label %l53, label %l52

l52:
	call void @throw_oob()
	br label %l53

l53:
	%r151 = call ptr @calloc(i32 %r149, i32 4)
	store i32 10, ptr %r151

	ret ptr %r151
}

define ptr@"B.test2_int"(ptr %this, i32 %_i) {
	%i = alloca i32
	store i32 %_i, ptr %i

	%r152 = load i32, ptr %i
	%r153 = add i32 1, %r152
	%r154 = icmp sge i32 %r153, 1
	br i1 %r154, label %l55, label %l54

l54:
	call void @throw_oob()
	br label %l55

l55:
	%r155 = call ptr @calloc(i32 %r153, i32 4)
	store i32 %r152, ptr %r155

	ret ptr %r155
}
