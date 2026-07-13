@.Alsdfjasdjfl_vtable = global [0 x ptr] []
@.A_vtable = global [3 x ptr] [ptr @"A.foo_boolean_boolean_boolean", ptr @"A.bar_boolean_boolean", ptr @"A.print_boolean"]
@.B_vtable = global [2 x ptr] [ptr @"B.foo_int", ptr @"B.t_int_int_boolean_boolean"]

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
	%dummy = alloca i1
	store i1 0, ptr %dummy

	%a = alloca ptr
	store ptr null, ptr %a

	%r0 = call ptr @calloc(i32 1, i32 8)
	%r1 = getelementptr [3 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	store ptr %r0, ptr %a

	%r2 = load ptr, ptr %a
	%r3 = load ptr, ptr %a
	%r4 = load ptr, ptr %r3
	%r5 = getelementptr ptr, ptr %r4, i32 0

	%r6 = load ptr, ptr %r5
	%r7 = call i1 %r6(ptr %r3, i1 0, i1  0, i1  0)

	%r8 = load ptr, ptr %r2
	%r9 = getelementptr ptr, ptr %r8, i32 2

	%r10 = load ptr, ptr %r9
	%r11 = call i1 %r10(ptr %r2, i1 %r7)

	store i1 %r11, ptr %dummy

	%r12 = load ptr, ptr %a
	%r13 = load ptr, ptr %a
	%r14 = load ptr, ptr %r13
	%r15 = getelementptr ptr, ptr %r14, i32 0

	%r16 = load ptr, ptr %r15
	%r17 = call i1 %r16(ptr %r13, i1 0, i1  0, i1  1)

	%r18 = load ptr, ptr %r12
	%r19 = getelementptr ptr, ptr %r18, i32 2

	%r20 = load ptr, ptr %r19
	%r21 = call i1 %r20(ptr %r12, i1 %r17)

	store i1 %r21, ptr %dummy

	%r22 = load ptr, ptr %a
	%r23 = load ptr, ptr %a
	%r24 = load ptr, ptr %r23
	%r25 = getelementptr ptr, ptr %r24, i32 0

	%r26 = load ptr, ptr %r25
	%r27 = call i1 %r26(ptr %r23, i1 0, i1  1, i1  0)

	%r28 = load ptr, ptr %r22
	%r29 = getelementptr ptr, ptr %r28, i32 2

	%r30 = load ptr, ptr %r29
	%r31 = call i1 %r30(ptr %r22, i1 %r27)

	store i1 %r31, ptr %dummy

	%r32 = load ptr, ptr %a
	%r33 = load ptr, ptr %a
	%r34 = load ptr, ptr %r33
	%r35 = getelementptr ptr, ptr %r34, i32 0

	%r36 = load ptr, ptr %r35
	%r37 = call i1 %r36(ptr %r33, i1 0, i1  1, i1  1)

	%r38 = load ptr, ptr %r32
	%r39 = getelementptr ptr, ptr %r38, i32 2

	%r40 = load ptr, ptr %r39
	%r41 = call i1 %r40(ptr %r32, i1 %r37)

	store i1 %r41, ptr %dummy

	%r42 = load ptr, ptr %a
	%r43 = load ptr, ptr %a
	%r44 = load ptr, ptr %r43
	%r45 = getelementptr ptr, ptr %r44, i32 0

	%r46 = load ptr, ptr %r45
	%r47 = call i1 %r46(ptr %r43, i1 1, i1  0, i1  0)

	%r48 = load ptr, ptr %r42
	%r49 = getelementptr ptr, ptr %r48, i32 2

	%r50 = load ptr, ptr %r49
	%r51 = call i1 %r50(ptr %r42, i1 %r47)

	store i1 %r51, ptr %dummy

	%r52 = load ptr, ptr %a
	%r53 = load ptr, ptr %a
	%r54 = load ptr, ptr %r53
	%r55 = getelementptr ptr, ptr %r54, i32 0

	%r56 = load ptr, ptr %r55
	%r57 = call i1 %r56(ptr %r53, i1 1, i1  0, i1  1)

	%r58 = load ptr, ptr %r52
	%r59 = getelementptr ptr, ptr %r58, i32 2

	%r60 = load ptr, ptr %r59
	%r61 = call i1 %r60(ptr %r52, i1 %r57)

	store i1 %r61, ptr %dummy

	%r62 = load ptr, ptr %a
	%r63 = load ptr, ptr %a
	%r64 = load ptr, ptr %r63
	%r65 = getelementptr ptr, ptr %r64, i32 0

	%r66 = load ptr, ptr %r65
	%r67 = call i1 %r66(ptr %r63, i1 1, i1  1, i1  0)

	%r68 = load ptr, ptr %r62
	%r69 = getelementptr ptr, ptr %r68, i32 2

	%r70 = load ptr, ptr %r69
	%r71 = call i1 %r70(ptr %r62, i1 %r67)

	store i1 %r71, ptr %dummy

	%r72 = load ptr, ptr %a
	%r73 = load ptr, ptr %a
	%r74 = load ptr, ptr %r73
	%r75 = getelementptr ptr, ptr %r74, i32 0

	%r76 = load ptr, ptr %r75
	%r77 = call i1 %r76(ptr %r73, i1 1, i1  1, i1  1)

	%r78 = load ptr, ptr %r72
	%r79 = getelementptr ptr, ptr %r78, i32 2

	%r80 = load ptr, ptr %r79
	%r81 = call i1 %r80(ptr %r72, i1 %r77)

	store i1 %r81, ptr %dummy

	%r82 = load ptr, ptr %a
	%r83 = load ptr, ptr %a
	%r84 = load ptr, ptr %r83
	%r85 = getelementptr ptr, ptr %r84, i32 1

	%r86 = load ptr, ptr %r85
	%r87 = call i1 %r86(ptr %r83, i1 1, i1  1)

	%r88 = load ptr, ptr %r82
	%r89 = getelementptr ptr, ptr %r88, i32 2

	%r90 = load ptr, ptr %r89
	%r91 = call i1 %r90(ptr %r82, i1 %r87)

	store i1 %r91, ptr %dummy

	%r92 = load ptr, ptr %a
	%r93 = load ptr, ptr %a
	%r94 = load ptr, ptr %r93
	%r95 = getelementptr ptr, ptr %r94, i32 1

	%r96 = load ptr, ptr %r95
	%r97 = call i1 %r96(ptr %r93, i1 0, i1  1)

	%r98 = load ptr, ptr %r92
	%r99 = getelementptr ptr, ptr %r98, i32 2

	%r100 = load ptr, ptr %r99
	%r101 = call i1 %r100(ptr %r92, i1 %r97)

	store i1 %r101, ptr %dummy

	%r102 = load ptr, ptr %a
	%r103 = call ptr @calloc(i32 1, i32 8)
	%r104 = getelementptr [2 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r104, ptr %r103

	%r105 = load ptr, ptr %r103
	%r106 = getelementptr ptr, ptr %r105, i32 0

	%r107 = load ptr, ptr %r106
	%r108 = call i1 %r107(ptr %r103, i32 1)

	%r109 = load ptr, ptr %r102
	%r110 = getelementptr ptr, ptr %r109, i32 2

	%r111 = load ptr, ptr %r110
	%r112 = call i1 %r111(ptr %r102, i1 %r108)

	store i1 %r112, ptr %dummy

	%r113 = load ptr, ptr %a
	%r114 = call ptr @calloc(i32 1, i32 8)
	%r115 = getelementptr [2 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r115, ptr %r114

	%r116 = load ptr, ptr %r114
	%r117 = getelementptr ptr, ptr %r116, i32 0

	%r118 = load ptr, ptr %r117
	%r119 = call i1 %r118(ptr %r114, i32 2)

	%r120 = load ptr, ptr %r113
	%r121 = getelementptr ptr, ptr %r120, i32 2

	%r122 = load ptr, ptr %r121
	%r123 = call i1 %r122(ptr %r113, i1 %r119)

	store i1 %r123, ptr %dummy

	%r124 = load ptr, ptr %a
	%r125 = call ptr @calloc(i32 1, i32 8)
	%r126 = getelementptr [2 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r126, ptr %r125

	%r127 = load ptr, ptr %r125
	%r128 = getelementptr ptr, ptr %r127, i32 1

	%r129 = load ptr, ptr %r128
	%r130 = call i1 %r129(ptr %r125, i32 2, i32  2, i1  1, i1  1)

	%r131 = load ptr, ptr %r124
	%r132 = getelementptr ptr, ptr %r131, i32 2

	%r133 = load ptr, ptr %r132
	%r134 = call i1 %r133(ptr %r124, i1 %r130)

	store i1 %r134, ptr %dummy

	ret i32 0
}

define i1@"A.foo_boolean_boolean_boolean"(ptr %this, i1 %_a, i1 %_b, i1 %_c) {
	%a = alloca i1
	store i1 %_a, ptr %a

	%b = alloca i1
	store i1 %_b, ptr %b

	%c = alloca i1
	store i1 %_c, ptr %c

	%r135 = load i1, ptr %a
	br i1 %r135, label %l0, label %l1

l1:
	br label %l2

l0:
	%r136 = load i1, ptr %b
	br label %l2

l2:
	%r137 = phi i1 [ 0, %l1 ], [ %r136, %l0 ]

	br i1 %r137, label %l3, label %l4

l4:
	br label %l5

l3:
	%r138 = load i1, ptr %c
	br label %l5

l5:
	%r139 = phi i1 [ 0, %l4 ], [ %r138, %l3 ]

	ret i1 %r139
}

define i1@"A.bar_boolean_boolean"(ptr %this, i1 %_a, i1 %_b) {
	%a = alloca i1
	store i1 %_a, ptr %a

	%b = alloca i1
	store i1 %_b, ptr %b

	%r140 = load i1, ptr %a
	br i1 %r140, label %l6, label %l7

l7:
	br label %l8

l6:
	%r141 = load i1, ptr %a
	%r142 = load i1, ptr %b
	%r143 = load ptr, ptr %this
	%r144 = getelementptr ptr, ptr %r143, i32 0

	%r145 = load ptr, ptr %r144
	%r146 = call i1 %r145(ptr %this, i1 %r141, i1  %r142, i1  1)

	br label %l8

l8:
	%r147 = phi i1 [ 0, %l7 ], [ %r146, %l6 ]

	br i1 %r147, label %l9, label %l10

l10:
	br label %l11

l9:
	%r148 = load i1, ptr %b
	br label %l11

l11:
	%r149 = phi i1 [ 0, %l10 ], [ %r148, %l9 ]

	ret i1 %r149
}

define i1@"A.print_boolean"(ptr %this, i1 %_res) {
	%res = alloca i1
	store i1 %_res, ptr %res

	%r150 = load i1, ptr %res
	br i1 %r150, label %l12, label %l13

l13:
	call void @print_int(i32 0)

	br label %l14

l12:
	call void @print_int(i32 1)

	br label %l14

l14:
	ret i1 1
}

define i1@"B.foo_int"(ptr %this, i32 %_a) {
	%a = alloca i32
	store i32 %_a, ptr %a

	%r151 = load i32, ptr %a
	%r152 = add i32 %r151, 2

	%r153 = icmp slt i32 3, %r152

	%r154 = xor i1 1, %r153

	br i1 %r154, label %l15, label %l16

l16:
	br label %l17

l15:
	%r155 = xor i1 1, 0

	br label %l17

l17:
	%r156 = phi i1 [ 0, %l16 ], [ %r155, %l15 ]

	ret i1 %r156
}

define i1@"B.t_int_int_boolean_boolean"(ptr %this, i32 %_a, i32 %_b, i1 %_c, i1 %_d) {
	%a = alloca i32
	store i32 %_a, ptr %a

	%b = alloca i32
	store i32 %_b, ptr %b

	%c = alloca i1
	store i1 %_c, ptr %c

	%d = alloca i1
	store i1 %_d, ptr %d

	%r157 = load i32, ptr %a
	%r158 = load i32, ptr %b
	%r159 = icmp slt i32 %r157, %r158

	%r160 = xor i1 1, %r159

	br i1 %r160, label %l18, label %l19

l19:
	br label %l20

l18:
	%r161 = load i1, ptr %c
	br i1 %r161, label %l21, label %l22

l22:
	br label %l23

l21:
	%r162 = load i1, ptr %d
	br label %l23

l23:
	%r163 = phi i1 [ 0, %l22 ], [ %r162, %l21 ]

	br label %l20

l20:
	%r164 = phi i1 [ 0, %l19 ], [ %r163, %l23 ]

	ret i1 %r164
}
