@.Main_vtable = global [0 x ptr] []
@.Receiver_vtable = global [8 x ptr] [ptr @"Receiver.A_A", ptr @"Receiver.B_B", ptr @"Receiver.C_C", ptr @"Receiver.D_D", ptr @"Receiver.alloc_B_for_A", ptr @"Receiver.alloc_C_for_A", ptr @"Receiver.alloc_D_for_A", ptr @"Receiver.alloc_D_for_B"]
@.A_vtable = global [3 x ptr] [ptr @"A.foo", ptr @"A.bar", ptr @"A.test"]
@.B_vtable = global [5 x ptr] [ptr @"A.foo", ptr @"B.bar", ptr @"A.test", ptr @"B.not_overriden", ptr @"B.another"]
@.C_vtable = global [3 x ptr] [ptr @"A.foo", ptr @"C.bar", ptr @"A.test"]
@.D_vtable = global [6 x ptr] [ptr @"A.foo", ptr @"D.bar", ptr @"A.test", ptr @"B.not_overriden", ptr @"D.another", ptr @"D.stef"]

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

	%b = alloca ptr
	store ptr null, ptr %b

	%c = alloca ptr
	store ptr null, ptr %c

	%d = alloca ptr
	store ptr null, ptr %d

	%separator = alloca i32
	store i32 0, ptr %separator

	%cls_separator = alloca i32
	store i32 0, ptr %cls_separator

	store i32 1111111111, ptr %separator

	store i32 333333333, ptr %cls_separator

	%r0 = call ptr @calloc(i32 1, i32 8)
	%r1 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = call ptr @calloc(i32 1, i32 8)
	%r3 = getelementptr [3 x ptr], ptr @.A_vtable, i32 0, i32 0
	store ptr %r3, ptr %r2

	%r4 = load ptr, ptr %r0
	%r5 = getelementptr ptr, ptr %r4, i32 0

	%r6 = load ptr, ptr %r5
	%r7 = call i1 %r6(ptr %r0, ptr %r2)

	store i1 %r7, ptr %dummy

	%r8 = load i32, ptr %separator
	call void @print_int(i32 %r8)

	%r9 = call ptr @calloc(i32 1, i32 8)
	%r10 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r10, ptr %r9

	%r11 = call ptr @calloc(i32 1, i32 8)
	%r12 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r12, ptr %r11

	%r13 = load ptr, ptr %r11
	%r14 = getelementptr ptr, ptr %r13, i32 4

	%r15 = load ptr, ptr %r14
	%r16 = call ptr %r15(ptr %r11)

	%r17 = load ptr, ptr %r9
	%r18 = getelementptr ptr, ptr %r17, i32 0

	%r19 = load ptr, ptr %r18
	%r20 = call i1 %r19(ptr %r9, ptr %r16)

	store i1 %r20, ptr %dummy

	%r21 = load i32, ptr %separator
	call void @print_int(i32 %r21)

	%r22 = call ptr @calloc(i32 1, i32 8)
	%r23 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r23, ptr %r22

	%r24 = call ptr @calloc(i32 1, i32 8)
	%r25 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r25, ptr %r24

	%r26 = load ptr, ptr %r24
	%r27 = getelementptr ptr, ptr %r26, i32 5

	%r28 = load ptr, ptr %r27
	%r29 = call ptr %r28(ptr %r24)

	%r30 = load ptr, ptr %r22
	%r31 = getelementptr ptr, ptr %r30, i32 0

	%r32 = load ptr, ptr %r31
	%r33 = call i1 %r32(ptr %r22, ptr %r29)

	store i1 %r33, ptr %dummy

	%r34 = load i32, ptr %separator
	call void @print_int(i32 %r34)

	%r35 = call ptr @calloc(i32 1, i32 8)
	%r36 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r36, ptr %r35

	%r37 = call ptr @calloc(i32 1, i32 8)
	%r38 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r38, ptr %r37

	%r39 = load ptr, ptr %r37
	%r40 = getelementptr ptr, ptr %r39, i32 6

	%r41 = load ptr, ptr %r40
	%r42 = call ptr %r41(ptr %r37)

	%r43 = load ptr, ptr %r35
	%r44 = getelementptr ptr, ptr %r43, i32 0

	%r45 = load ptr, ptr %r44
	%r46 = call i1 %r45(ptr %r35, ptr %r42)

	store i1 %r46, ptr %dummy

	%r47 = load i32, ptr %cls_separator
	call void @print_int(i32 %r47)

	%r48 = call ptr @calloc(i32 1, i32 8)
	%r49 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r49, ptr %r48

	%r50 = call ptr @calloc(i32 1, i32 8)
	%r51 = getelementptr [5 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r51, ptr %r50

	%r52 = load ptr, ptr %r48
	%r53 = getelementptr ptr, ptr %r52, i32 1

	%r54 = load ptr, ptr %r53
	%r55 = call i1 %r54(ptr %r48, ptr %r50)

	store i1 %r55, ptr %dummy

	%r56 = load i32, ptr %separator
	call void @print_int(i32 %r56)

	%r57 = call ptr @calloc(i32 1, i32 8)
	%r58 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r58, ptr %r57

	%r59 = call ptr @calloc(i32 1, i32 8)
	%r60 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r60, ptr %r59

	%r61 = load ptr, ptr %r59
	%r62 = getelementptr ptr, ptr %r61, i32 7

	%r63 = load ptr, ptr %r62
	%r64 = call ptr %r63(ptr %r59)

	%r65 = load ptr, ptr %r57
	%r66 = getelementptr ptr, ptr %r65, i32 1

	%r67 = load ptr, ptr %r66
	%r68 = call i1 %r67(ptr %r57, ptr %r64)

	store i1 %r68, ptr %dummy

	%r69 = load i32, ptr %cls_separator
	call void @print_int(i32 %r69)

	%r70 = call ptr @calloc(i32 1, i32 8)
	%r71 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r71, ptr %r70

	%r72 = call ptr @calloc(i32 1, i32 8)
	%r73 = getelementptr [3 x ptr], ptr @.C_vtable, i32 0, i32 0
	store ptr %r73, ptr %r72

	%r74 = load ptr, ptr %r70
	%r75 = getelementptr ptr, ptr %r74, i32 2

	%r76 = load ptr, ptr %r75
	%r77 = call i1 %r76(ptr %r70, ptr %r72)

	store i1 %r77, ptr %dummy

	%r78 = load i32, ptr %cls_separator
	call void @print_int(i32 %r78)

	%r79 = call ptr @calloc(i32 1, i32 8)
	%r80 = getelementptr [8 x ptr], ptr @.Receiver_vtable, i32 0, i32 0
	store ptr %r80, ptr %r79

	%r81 = call ptr @calloc(i32 1, i32 8)
	%r82 = getelementptr [6 x ptr], ptr @.D_vtable, i32 0, i32 0
	store ptr %r82, ptr %r81

	%r83 = load ptr, ptr %r79
	%r84 = getelementptr ptr, ptr %r83, i32 3

	%r85 = load ptr, ptr %r84
	%r86 = call i1 %r85(ptr %r79, ptr %r81)

	store i1 %r86, ptr %dummy

	ret i32 0
}

define i1@"Receiver.A_A"(ptr %this, ptr %_a) {
	%a = alloca ptr
	store ptr %_a, ptr %a

	%r87 = load ptr, ptr %a
	%r88 = load ptr, ptr %r87
	%r89 = getelementptr ptr, ptr %r88, i32 0

	%r90 = load ptr, ptr %r89
	%r91 = call i32 %r90(ptr %r87)

	call void @print_int(i32 %r91)

	%r92 = load ptr, ptr %a
	%r93 = load ptr, ptr %r92
	%r94 = getelementptr ptr, ptr %r93, i32 1

	%r95 = load ptr, ptr %r94
	%r96 = call i32 %r95(ptr %r92)

	call void @print_int(i32 %r96)

	%r97 = load ptr, ptr %a
	%r98 = load ptr, ptr %r97
	%r99 = getelementptr ptr, ptr %r98, i32 2

	%r100 = load ptr, ptr %r99
	%r101 = call i32 %r100(ptr %r97)

	call void @print_int(i32 %r101)

	ret i1 1
}

define i1@"Receiver.B_B"(ptr %this, ptr %_b) {
	%b = alloca ptr
	store ptr %_b, ptr %b

	%r102 = load ptr, ptr %b
	%r103 = load ptr, ptr %r102
	%r104 = getelementptr ptr, ptr %r103, i32 0

	%r105 = load ptr, ptr %r104
	%r106 = call i32 %r105(ptr %r102)

	call void @print_int(i32 %r106)

	%r107 = load ptr, ptr %b
	%r108 = load ptr, ptr %r107
	%r109 = getelementptr ptr, ptr %r108, i32 1

	%r110 = load ptr, ptr %r109
	%r111 = call i32 %r110(ptr %r107)

	call void @print_int(i32 %r111)

	%r112 = load ptr, ptr %b
	%r113 = load ptr, ptr %r112
	%r114 = getelementptr ptr, ptr %r113, i32 2

	%r115 = load ptr, ptr %r114
	%r116 = call i32 %r115(ptr %r112)

	call void @print_int(i32 %r116)

	%r117 = load ptr, ptr %b
	%r118 = load ptr, ptr %r117
	%r119 = getelementptr ptr, ptr %r118, i32 3

	%r120 = load ptr, ptr %r119
	%r121 = call i32 %r120(ptr %r117)

	call void @print_int(i32 %r121)

	%r122 = load ptr, ptr %b
	%r123 = load ptr, ptr %r122
	%r124 = getelementptr ptr, ptr %r123, i32 4

	%r125 = load ptr, ptr %r124
	%r126 = call i32 %r125(ptr %r122)

	call void @print_int(i32 %r126)

	ret i1 1
}

define i1@"Receiver.C_C"(ptr %this, ptr %_c) {
	%c = alloca ptr
	store ptr %_c, ptr %c

	%r127 = load ptr, ptr %c
	%r128 = load ptr, ptr %r127
	%r129 = getelementptr ptr, ptr %r128, i32 0

	%r130 = load ptr, ptr %r129
	%r131 = call i32 %r130(ptr %r127)

	call void @print_int(i32 %r131)

	%r132 = load ptr, ptr %c
	%r133 = load ptr, ptr %r132
	%r134 = getelementptr ptr, ptr %r133, i32 1

	%r135 = load ptr, ptr %r134
	%r136 = call i32 %r135(ptr %r132)

	call void @print_int(i32 %r136)

	%r137 = load ptr, ptr %c
	%r138 = load ptr, ptr %r137
	%r139 = getelementptr ptr, ptr %r138, i32 2

	%r140 = load ptr, ptr %r139
	%r141 = call i32 %r140(ptr %r137)

	call void @print_int(i32 %r141)

	ret i1 1
}

define i1@"Receiver.D_D"(ptr %this, ptr %_d) {
	%d = alloca ptr
	store ptr %_d, ptr %d

	%r142 = load ptr, ptr %d
	%r143 = load ptr, ptr %r142
	%r144 = getelementptr ptr, ptr %r143, i32 0

	%r145 = load ptr, ptr %r144
	%r146 = call i32 %r145(ptr %r142)

	call void @print_int(i32 %r146)

	%r147 = load ptr, ptr %d
	%r148 = load ptr, ptr %r147
	%r149 = getelementptr ptr, ptr %r148, i32 1

	%r150 = load ptr, ptr %r149
	%r151 = call i32 %r150(ptr %r147)

	call void @print_int(i32 %r151)

	%r152 = load ptr, ptr %d
	%r153 = load ptr, ptr %r152
	%r154 = getelementptr ptr, ptr %r153, i32 2

	%r155 = load ptr, ptr %r154
	%r156 = call i32 %r155(ptr %r152)

	call void @print_int(i32 %r156)

	%r157 = load ptr, ptr %d
	%r158 = load ptr, ptr %r157
	%r159 = getelementptr ptr, ptr %r158, i32 3

	%r160 = load ptr, ptr %r159
	%r161 = call i32 %r160(ptr %r157)

	call void @print_int(i32 %r161)

	%r162 = load ptr, ptr %d
	%r163 = load ptr, ptr %r162
	%r164 = getelementptr ptr, ptr %r163, i32 4

	%r165 = load ptr, ptr %r164
	%r166 = call i32 %r165(ptr %r162)

	call void @print_int(i32 %r166)

	%r167 = load ptr, ptr %d
	%r168 = load ptr, ptr %r167
	%r169 = getelementptr ptr, ptr %r168, i32 5

	%r170 = load ptr, ptr %r169
	%r171 = call i32 %r170(ptr %r167)

	call void @print_int(i32 %r171)

	ret i1 1
}

define ptr@"Receiver.alloc_B_for_A"(ptr %this) {
	%r172 = call ptr @calloc(i32 1, i32 8)
	%r173 = getelementptr [5 x ptr], ptr @.B_vtable, i32 0, i32 0
	store ptr %r173, ptr %r172

	ret ptr %r172
}

define ptr@"Receiver.alloc_C_for_A"(ptr %this) {
	%r174 = call ptr @calloc(i32 1, i32 8)
	%r175 = getelementptr [3 x ptr], ptr @.C_vtable, i32 0, i32 0
	store ptr %r175, ptr %r174

	ret ptr %r174
}

define ptr@"Receiver.alloc_D_for_A"(ptr %this) {
	%r176 = call ptr @calloc(i32 1, i32 8)
	%r177 = getelementptr [6 x ptr], ptr @.D_vtable, i32 0, i32 0
	store ptr %r177, ptr %r176

	ret ptr %r176
}

define ptr@"Receiver.alloc_D_for_B"(ptr %this) {
	%r178 = call ptr @calloc(i32 1, i32 8)
	%r179 = getelementptr [6 x ptr], ptr @.D_vtable, i32 0, i32 0
	store ptr %r179, ptr %r178

	ret ptr %r178
}

define i32@"A.foo"(ptr %this) {
	ret i32 1
}

define i32@"A.bar"(ptr %this) {
	ret i32 2
}

define i32@"A.test"(ptr %this) {
	ret i32 3
}

define i32@"B.bar"(ptr %this) {
	ret i32 12
}

define i32@"B.not_overriden"(ptr %this) {
	ret i32 14
}

define i32@"B.another"(ptr %this) {
	ret i32 15
}

define i32@"C.bar"(ptr %this) {
	ret i32 22
}

define i32@"D.bar"(ptr %this) {
	ret i32 32
}

define i32@"D.another"(ptr %this) {
	ret i32 35
}

define i32@"D.stef"(ptr %this) {
	ret i32 36
}
