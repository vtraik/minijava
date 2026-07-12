@.TreeVisitor_vtable = global [0 x ptr] []
@.TV_vtable = global [1 x ptr] [ptr @"TV.Start"]
@.Tree_vtable = global [21 x ptr] [ptr @"Tree.Init_int", ptr @"Tree.SetRight_Tree", ptr @"Tree.SetLeft_Tree", ptr @"Tree.GetRight", ptr @"Tree.GetLeft", ptr @"Tree.GetKey", ptr @"Tree.SetKey_int", ptr @"Tree.GetHas_Right", ptr @"Tree.GetHas_Left", ptr @"Tree.SetHas_Left_boolean", ptr @"Tree.SetHas_Right_boolean", ptr @"Tree.Compare_int_int", ptr @"Tree.Insert_int", ptr @"Tree.Delete_int", ptr @"Tree.Remove_Tree_Tree", ptr @"Tree.RemoveRight_Tree_Tree", ptr @"Tree.RemoveLeft_Tree_Tree", ptr @"Tree.Search_int", ptr @"Tree.Print", ptr @"Tree.RecPrint_Tree", ptr @"Tree.accept_Visitor"]
@.Visitor_vtable = global [1 x ptr] [ptr @"Visitor.visit_Tree"]
@.MyVisitor_vtable = global [1 x ptr] [ptr @"MyVisitor.visit_Tree"]

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
	%r0 = call ptr @calloc(i32 1, i32 8)
	%r1 = getelementptr [1 x ptr], ptr @.TV_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"TV.Start"(ptr %this) {
	%root = alloca ptr
	store ptr null, ptr %root

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%nti = alloca i32
	store i32 0, ptr %nti

	%v = alloca ptr
	store ptr null, ptr %v

	%r6 = call ptr @calloc(i32 1, i32 38)
	%r7 = getelementptr [21 x ptr], ptr @.Tree_vtable, i32 0, i32 0
	store ptr %r7, ptr %r6

	store ptr %r6, ptr %root

	%r8 = load ptr, ptr %root
	%r9 = load ptr, ptr %r8
	%r10 = getelementptr ptr, ptr %r9, i32 0

	%r11 = load ptr, ptr %r10
	%r12 = call i1 %r11(ptr %r8, i32 16)

	store i1 %r12, ptr %ntb

	%r13 = load ptr, ptr %root
	%r14 = load ptr, ptr %r13
	%r15 = getelementptr ptr, ptr %r14, i32 18

	%r16 = load ptr, ptr %r15
	%r17 = call i1 %r16(ptr %r13)

	store i1 %r17, ptr %ntb

	call void @print_int(i32 100000000)

	%r18 = load ptr, ptr %root
	%r19 = load ptr, ptr %r18
	%r20 = getelementptr ptr, ptr %r19, i32 12

	%r21 = load ptr, ptr %r20
	%r22 = call i1 %r21(ptr %r18, i32 8)

	store i1 %r22, ptr %ntb

	%r23 = load ptr, ptr %root
	%r24 = load ptr, ptr %r23
	%r25 = getelementptr ptr, ptr %r24, i32 12

	%r26 = load ptr, ptr %r25
	%r27 = call i1 %r26(ptr %r23, i32 24)

	store i1 %r27, ptr %ntb

	%r28 = load ptr, ptr %root
	%r29 = load ptr, ptr %r28
	%r30 = getelementptr ptr, ptr %r29, i32 12

	%r31 = load ptr, ptr %r30
	%r32 = call i1 %r31(ptr %r28, i32 4)

	store i1 %r32, ptr %ntb

	%r33 = load ptr, ptr %root
	%r34 = load ptr, ptr %r33
	%r35 = getelementptr ptr, ptr %r34, i32 12

	%r36 = load ptr, ptr %r35
	%r37 = call i1 %r36(ptr %r33, i32 12)

	store i1 %r37, ptr %ntb

	%r38 = load ptr, ptr %root
	%r39 = load ptr, ptr %r38
	%r40 = getelementptr ptr, ptr %r39, i32 12

	%r41 = load ptr, ptr %r40
	%r42 = call i1 %r41(ptr %r38, i32 20)

	store i1 %r42, ptr %ntb

	%r43 = load ptr, ptr %root
	%r44 = load ptr, ptr %r43
	%r45 = getelementptr ptr, ptr %r44, i32 12

	%r46 = load ptr, ptr %r45
	%r47 = call i1 %r46(ptr %r43, i32 28)

	store i1 %r47, ptr %ntb

	%r48 = load ptr, ptr %root
	%r49 = load ptr, ptr %r48
	%r50 = getelementptr ptr, ptr %r49, i32 12

	%r51 = load ptr, ptr %r50
	%r52 = call i1 %r51(ptr %r48, i32 14)

	store i1 %r52, ptr %ntb

	%r53 = load ptr, ptr %root
	%r54 = load ptr, ptr %r53
	%r55 = getelementptr ptr, ptr %r54, i32 18

	%r56 = load ptr, ptr %r55
	%r57 = call i1 %r56(ptr %r53)

	store i1 %r57, ptr %ntb

	call void @print_int(i32 100000000)

	%r58 = call ptr @calloc(i32 1, i32 24)
	%r59 = getelementptr [1 x ptr], ptr @.MyVisitor_vtable, i32 0, i32 0
	store ptr %r59, ptr %r58

	store ptr %r58, ptr %v

	call void @print_int(i32 50000000)

	%r60 = load ptr, ptr %root
	%r61 = load ptr, ptr %v
	%r62 = load ptr, ptr %r60
	%r63 = getelementptr ptr, ptr %r62, i32 20

	%r64 = load ptr, ptr %r63
	%r65 = call i32 %r64(ptr %r60, ptr %r61)

	store i32 %r65, ptr %nti

	call void @print_int(i32 100000000)

	%r66 = load ptr, ptr %root
	%r67 = load ptr, ptr %r66
	%r68 = getelementptr ptr, ptr %r67, i32 17

	%r69 = load ptr, ptr %r68
	%r70 = call i32 %r69(ptr %r66, i32 24)

	call void @print_int(i32 %r70)

	%r71 = load ptr, ptr %root
	%r72 = load ptr, ptr %r71
	%r73 = getelementptr ptr, ptr %r72, i32 17

	%r74 = load ptr, ptr %r73
	%r75 = call i32 %r74(ptr %r71, i32 12)

	call void @print_int(i32 %r75)

	%r76 = load ptr, ptr %root
	%r77 = load ptr, ptr %r76
	%r78 = getelementptr ptr, ptr %r77, i32 17

	%r79 = load ptr, ptr %r78
	%r80 = call i32 %r79(ptr %r76, i32 16)

	call void @print_int(i32 %r80)

	%r81 = load ptr, ptr %root
	%r82 = load ptr, ptr %r81
	%r83 = getelementptr ptr, ptr %r82, i32 17

	%r84 = load ptr, ptr %r83
	%r85 = call i32 %r84(ptr %r81, i32 50)

	call void @print_int(i32 %r85)

	%r86 = load ptr, ptr %root
	%r87 = load ptr, ptr %r86
	%r88 = getelementptr ptr, ptr %r87, i32 17

	%r89 = load ptr, ptr %r88
	%r90 = call i32 %r89(ptr %r86, i32 12)

	call void @print_int(i32 %r90)

	%r91 = load ptr, ptr %root
	%r92 = load ptr, ptr %r91
	%r93 = getelementptr ptr, ptr %r92, i32 13

	%r94 = load ptr, ptr %r93
	%r95 = call i1 %r94(ptr %r91, i32 12)

	store i1 %r95, ptr %ntb

	%r96 = load ptr, ptr %root
	%r97 = load ptr, ptr %r96
	%r98 = getelementptr ptr, ptr %r97, i32 18

	%r99 = load ptr, ptr %r98
	%r100 = call i1 %r99(ptr %r96)

	store i1 %r100, ptr %ntb

	%r101 = load ptr, ptr %root
	%r102 = load ptr, ptr %r101
	%r103 = getelementptr ptr, ptr %r102, i32 17

	%r104 = load ptr, ptr %r103
	%r105 = call i32 %r104(ptr %r101, i32 12)

	call void @print_int(i32 %r105)

	ret i32 0
}

define i1@"Tree.Init_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%r106 = load i32, ptr %v_key
	%r107 = getelementptr i8, ptr %this, i32 24
	store i32 %r106, ptr %r107

	%r108 = getelementptr i8, ptr %this, i32 28
	store i1 0, ptr %r108

	%r109 = getelementptr i8, ptr %this, i32 29
	store i1 0, ptr %r109

	ret i1 1
}

define i1@"Tree.SetRight_Tree"(ptr %this, ptr %_rn) {
	%rn = alloca ptr
	store ptr %_rn, ptr %rn

	%r110 = load ptr, ptr %rn
	%r111 = getelementptr i8, ptr %this, i32 16
	store ptr %r110, ptr %r111

	ret i1 1
}

define i1@"Tree.SetLeft_Tree"(ptr %this, ptr %_ln) {
	%ln = alloca ptr
	store ptr %_ln, ptr %ln

	%r112 = load ptr, ptr %ln
	%r113 = getelementptr i8, ptr %this, i32 8
	store ptr %r112, ptr %r113

	ret i1 1
}

define ptr@"Tree.GetRight"(ptr %this) {
	%r114 = getelementptr i8, ptr %this, i32 16
	%r115 = load ptr, ptr %r114

	ret ptr %r115
}

define ptr@"Tree.GetLeft"(ptr %this) {
	%r116 = getelementptr i8, ptr %this, i32 8
	%r117 = load ptr, ptr %r116

	ret ptr %r117
}

define i32@"Tree.GetKey"(ptr %this) {
	%r118 = getelementptr i8, ptr %this, i32 24
	%r119 = load i32, ptr %r118

	ret i32 %r119
}

define i1@"Tree.SetKey_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%r120 = load i32, ptr %v_key
	%r121 = getelementptr i8, ptr %this, i32 24
	store i32 %r120, ptr %r121

	ret i1 1
}

define i1@"Tree.GetHas_Right"(ptr %this) {
	%r122 = getelementptr i8, ptr %this, i32 29
	%r123 = load i1, ptr %r122

	ret i1 %r123
}

define i1@"Tree.GetHas_Left"(ptr %this) {
	%r124 = getelementptr i8, ptr %this, i32 28
	%r125 = load i1, ptr %r124

	ret i1 %r125
}

define i1@"Tree.SetHas_Left_boolean"(ptr %this, i1 %_val) {
	%val = alloca i1
	store i1 %_val, ptr %val

	%r126 = load i1, ptr %val
	%r127 = getelementptr i8, ptr %this, i32 28
	store i1 %r126, ptr %r127

	ret i1 1
}

define i1@"Tree.SetHas_Right_boolean"(ptr %this, i1 %_val) {
	%val = alloca i1
	store i1 %_val, ptr %val

	%r128 = load i1, ptr %val
	%r129 = getelementptr i8, ptr %this, i32 29
	store i1 %r128, ptr %r129

	ret i1 1
}

define i1@"Tree.Compare_int_int"(ptr %this, i32 %_num1, i32 %_num2) {
	%num1 = alloca i32
	store i32 %_num1, ptr %num1

	%num2 = alloca i32
	store i32 %_num2, ptr %num2

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%nti = alloca i32
	store i32 0, ptr %nti

	store i1 0, ptr %ntb

	%r130 = load i32, ptr %num2
	%r131 = add i32 %r130, 1

	store i32 %r131, ptr %nti

	%r132 = load i32, ptr %num1
	%r133 = load i32, ptr %num2
	%r134 = icmp slt i32 %r132, %r133

	br i1 %r134, label %l0, label %l1

l1:
	%r135 = load i32, ptr %num1
	%r136 = load i32, ptr %nti
	%r137 = icmp slt i32 %r135, %r136

	%r138 = xor i1 1, %r137

	br i1 %r138, label %l3, label %l4

l4:
	store i1 1, ptr %ntb

	br label %l5

l3:
	store i1 0, ptr %ntb

	br label %l5

l5:
	br label %l2

l0:
	store i1 0, ptr %ntb

	br label %l2

l2:
	%r139 = load i1, ptr %ntb
	ret i1 %r139
}

define i1@"Tree.Insert_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%new_node = alloca ptr
	store ptr null, ptr %new_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%cont = alloca i1
	store i1 0, ptr %cont

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	%r140 = call ptr @calloc(i32 1, i32 38)
	%r141 = getelementptr [21 x ptr], ptr @.Tree_vtable, i32 0, i32 0
	store ptr %r141, ptr %r140

	store ptr %r140, ptr %new_node

	%r142 = load ptr, ptr %new_node
	%r143 = load i32, ptr %v_key
	%r144 = load ptr, ptr %r142
	%r145 = getelementptr ptr, ptr %r144, i32 0

	%r146 = load ptr, ptr %r145
	%r147 = call i1 %r146(ptr %r142, i32 %r143)

	store i1 %r147, ptr %ntb

	store ptr %this, ptr %current_node

	store i1 1, ptr %cont

	br label %l6
l6:
	%r148 = load i1, ptr %cont
	br i1 %r148, label %l7, label %l8

l7:
	%r149 = load ptr, ptr %current_node
	%r150 = load ptr, ptr %r149
	%r151 = getelementptr ptr, ptr %r150, i32 5

	%r152 = load ptr, ptr %r151
	%r153 = call i32 %r152(ptr %r149)

	store i32 %r153, ptr %key_aux

	%r154 = load i32, ptr %v_key
	%r155 = load i32, ptr %key_aux
	%r156 = icmp slt i32 %r154, %r155

	br i1 %r156, label %l9, label %l10

l10:
	%r157 = load ptr, ptr %current_node
	%r158 = load ptr, ptr %r157
	%r159 = getelementptr ptr, ptr %r158, i32 7

	%r160 = load ptr, ptr %r159
	%r161 = call i1 %r160(ptr %r157)

	br i1 %r161, label %l12, label %l13

l13:
	store i1 0, ptr %cont

	%r162 = load ptr, ptr %current_node
	%r163 = load ptr, ptr %r162
	%r164 = getelementptr ptr, ptr %r163, i32 10

	%r165 = load ptr, ptr %r164
	%r166 = call i1 %r165(ptr %r162, i1 1)

	store i1 %r166, ptr %ntb

	%r167 = load ptr, ptr %current_node
	%r168 = load ptr, ptr %new_node
	%r169 = load ptr, ptr %r167
	%r170 = getelementptr ptr, ptr %r169, i32 1

	%r171 = load ptr, ptr %r170
	%r172 = call i1 %r171(ptr %r167, ptr %r168)

	store i1 %r172, ptr %ntb

	br label %l14

l12:
	%r173 = load ptr, ptr %current_node
	%r174 = load ptr, ptr %r173
	%r175 = getelementptr ptr, ptr %r174, i32 3

	%r176 = load ptr, ptr %r175
	%r177 = call ptr %r176(ptr %r173)

	store ptr %r177, ptr %current_node

	br label %l14

l14:
	br label %l11

l9:
	%r178 = load ptr, ptr %current_node
	%r179 = load ptr, ptr %r178
	%r180 = getelementptr ptr, ptr %r179, i32 8

	%r181 = load ptr, ptr %r180
	%r182 = call i1 %r181(ptr %r178)

	br i1 %r182, label %l15, label %l16

l16:
	store i1 0, ptr %cont

	%r183 = load ptr, ptr %current_node
	%r184 = load ptr, ptr %r183
	%r185 = getelementptr ptr, ptr %r184, i32 9

	%r186 = load ptr, ptr %r185
	%r187 = call i1 %r186(ptr %r183, i1 1)

	store i1 %r187, ptr %ntb

	%r188 = load ptr, ptr %current_node
	%r189 = load ptr, ptr %new_node
	%r190 = load ptr, ptr %r188
	%r191 = getelementptr ptr, ptr %r190, i32 2

	%r192 = load ptr, ptr %r191
	%r193 = call i1 %r192(ptr %r188, ptr %r189)

	store i1 %r193, ptr %ntb

	br label %l17

l15:
	%r194 = load ptr, ptr %current_node
	%r195 = load ptr, ptr %r194
	%r196 = getelementptr ptr, ptr %r195, i32 4

	%r197 = load ptr, ptr %r196
	%r198 = call ptr %r197(ptr %r194)

	store ptr %r198, ptr %current_node

	br label %l17

l17:
	br label %l11

l11:
	br label %l6

l8:
	ret i1 1
}

define i1@"Tree.Delete_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%parent_node = alloca ptr
	store ptr null, ptr %parent_node

	%cont = alloca i1
	store i1 0, ptr %cont

	%found = alloca i1
	store i1 0, ptr %found

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%is_root = alloca i1
	store i1 0, ptr %is_root

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	store ptr %this, ptr %current_node

	store ptr %this, ptr %parent_node

	store i1 1, ptr %cont

	store i1 0, ptr %found

	store i1 1, ptr %is_root

	br label %l18
l18:
	%r199 = load i1, ptr %cont
	br i1 %r199, label %l19, label %l20

l19:
	%r200 = load ptr, ptr %current_node
	%r201 = load ptr, ptr %r200
	%r202 = getelementptr ptr, ptr %r201, i32 5

	%r203 = load ptr, ptr %r202
	%r204 = call i32 %r203(ptr %r200)

	store i32 %r204, ptr %key_aux

	%r205 = load i32, ptr %v_key
	%r206 = load i32, ptr %key_aux
	%r207 = icmp slt i32 %r205, %r206

	br i1 %r207, label %l21, label %l22

l22:
	%r208 = load i32, ptr %key_aux
	%r209 = load i32, ptr %v_key
	%r210 = icmp slt i32 %r208, %r209

	br i1 %r210, label %l24, label %l25

l25:
	%r211 = load i1, ptr %is_root
	br i1 %r211, label %l27, label %l28

l28:
	%r212 = load ptr, ptr %parent_node
	%r213 = load ptr, ptr %current_node
	%r214 = load ptr, ptr %this
	%r215 = getelementptr ptr, ptr %r214, i32 14

	%r216 = load ptr, ptr %r215
	%r217 = call i1 %r216(ptr %this, ptr %r212, ptr  %r213)

	store i1 %r217, ptr %ntb

	br label %l29

l27:
	%r218 = load ptr, ptr %current_node
	%r219 = load ptr, ptr %r218
	%r220 = getelementptr ptr, ptr %r219, i32 7

	%r221 = load ptr, ptr %r220
	%r222 = call i1 %r221(ptr %r218)

	%r223 = xor i1 1, %r222

	br i1 %r223, label %l30, label %l31

l31:
	br label %l32

l30:
	%r224 = load ptr, ptr %current_node
	%r225 = load ptr, ptr %r224
	%r226 = getelementptr ptr, ptr %r225, i32 8

	%r227 = load ptr, ptr %r226
	%r228 = call i1 %r227(ptr %r224)

	%r229 = xor i1 1, %r228

	br label %l32

l32:
	%r230 = phi i1 [ 0, %l31 ], [ %r229, %l30 ]

	br i1 %r230, label %l33, label %l34

l34:
	%r231 = load ptr, ptr %parent_node
	%r232 = load ptr, ptr %current_node
	%r233 = load ptr, ptr %this
	%r234 = getelementptr ptr, ptr %r233, i32 14

	%r235 = load ptr, ptr %r234
	%r236 = call i1 %r235(ptr %this, ptr %r231, ptr  %r232)

	store i1 %r236, ptr %ntb

	br label %l35

l33:
	store i1 1, ptr %ntb

	br label %l35

l35:
	br label %l29

l29:
	store i1 1, ptr %found

	store i1 0, ptr %cont

	br label %l26

l24:
	%r237 = load ptr, ptr %current_node
	%r238 = load ptr, ptr %r237
	%r239 = getelementptr ptr, ptr %r238, i32 7

	%r240 = load ptr, ptr %r239
	%r241 = call i1 %r240(ptr %r237)

	br i1 %r241, label %l36, label %l37

l37:
	store i1 0, ptr %cont

	br label %l38

l36:
	%r242 = load ptr, ptr %current_node
	store ptr %r242, ptr %parent_node

	%r243 = load ptr, ptr %current_node
	%r244 = load ptr, ptr %r243
	%r245 = getelementptr ptr, ptr %r244, i32 3

	%r246 = load ptr, ptr %r245
	%r247 = call ptr %r246(ptr %r243)

	store ptr %r247, ptr %current_node

	br label %l38

l38:
	br label %l26

l26:
	br label %l23

l21:
	%r248 = load ptr, ptr %current_node
	%r249 = load ptr, ptr %r248
	%r250 = getelementptr ptr, ptr %r249, i32 8

	%r251 = load ptr, ptr %r250
	%r252 = call i1 %r251(ptr %r248)

	br i1 %r252, label %l39, label %l40

l40:
	store i1 0, ptr %cont

	br label %l41

l39:
	%r253 = load ptr, ptr %current_node
	store ptr %r253, ptr %parent_node

	%r254 = load ptr, ptr %current_node
	%r255 = load ptr, ptr %r254
	%r256 = getelementptr ptr, ptr %r255, i32 4

	%r257 = load ptr, ptr %r256
	%r258 = call ptr %r257(ptr %r254)

	store ptr %r258, ptr %current_node

	br label %l41

l41:
	br label %l23

l23:
	store i1 0, ptr %is_root

	br label %l18

l20:
	%r259 = load i1, ptr %found
	ret i1 %r259
}

define i1@"Tree.Remove_Tree_Tree"(ptr %this, ptr %_p_node, ptr %_c_node) {
	%p_node = alloca ptr
	store ptr %_p_node, ptr %p_node

	%c_node = alloca ptr
	store ptr %_c_node, ptr %c_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%auxkey1 = alloca i32
	store i32 0, ptr %auxkey1

	%auxkey2 = alloca i32
	store i32 0, ptr %auxkey2

	%r260 = load ptr, ptr %c_node
	%r261 = load ptr, ptr %r260
	%r262 = getelementptr ptr, ptr %r261, i32 8

	%r263 = load ptr, ptr %r262
	%r264 = call i1 %r263(ptr %r260)

	br i1 %r264, label %l42, label %l43

l43:
	%r265 = load ptr, ptr %c_node
	%r266 = load ptr, ptr %r265
	%r267 = getelementptr ptr, ptr %r266, i32 7

	%r268 = load ptr, ptr %r267
	%r269 = call i1 %r268(ptr %r265)

	br i1 %r269, label %l45, label %l46

l46:
	%r270 = load ptr, ptr %c_node
	%r271 = load ptr, ptr %r270
	%r272 = getelementptr ptr, ptr %r271, i32 5

	%r273 = load ptr, ptr %r272
	%r274 = call i32 %r273(ptr %r270)

	store i32 %r274, ptr %auxkey1

	%r275 = load ptr, ptr %p_node
	%r276 = load ptr, ptr %r275
	%r277 = getelementptr ptr, ptr %r276, i32 4

	%r278 = load ptr, ptr %r277
	%r279 = call ptr %r278(ptr %r275)

	%r280 = load ptr, ptr %r279
	%r281 = getelementptr ptr, ptr %r280, i32 5

	%r282 = load ptr, ptr %r281
	%r283 = call i32 %r282(ptr %r279)

	store i32 %r283, ptr %auxkey2

	%r284 = load i32, ptr %auxkey1
	%r285 = load i32, ptr %auxkey2
	%r286 = load ptr, ptr %this
	%r287 = getelementptr ptr, ptr %r286, i32 11

	%r288 = load ptr, ptr %r287
	%r289 = call i1 %r288(ptr %this, i32 %r284, i32  %r285)

	br i1 %r289, label %l48, label %l49

l49:
	%r290 = load ptr, ptr %p_node
	%r291 = getelementptr i8, ptr %this, i32 30
	%r292 = load ptr, ptr %r291

	%r293 = load ptr, ptr %r290
	%r294 = getelementptr ptr, ptr %r293, i32 1

	%r295 = load ptr, ptr %r294
	%r296 = call i1 %r295(ptr %r290, ptr %r292)

	store i1 %r296, ptr %ntb

	%r297 = load ptr, ptr %p_node
	%r298 = load ptr, ptr %r297
	%r299 = getelementptr ptr, ptr %r298, i32 10

	%r300 = load ptr, ptr %r299
	%r301 = call i1 %r300(ptr %r297, i1 0)

	store i1 %r301, ptr %ntb

	br label %l50

l48:
	%r302 = load ptr, ptr %p_node
	%r303 = getelementptr i8, ptr %this, i32 30
	%r304 = load ptr, ptr %r303

	%r305 = load ptr, ptr %r302
	%r306 = getelementptr ptr, ptr %r305, i32 2

	%r307 = load ptr, ptr %r306
	%r308 = call i1 %r307(ptr %r302, ptr %r304)

	store i1 %r308, ptr %ntb

	%r309 = load ptr, ptr %p_node
	%r310 = load ptr, ptr %r309
	%r311 = getelementptr ptr, ptr %r310, i32 9

	%r312 = load ptr, ptr %r311
	%r313 = call i1 %r312(ptr %r309, i1 0)

	store i1 %r313, ptr %ntb

	br label %l50

l50:
	br label %l47

l45:
	%r314 = load ptr, ptr %p_node
	%r315 = load ptr, ptr %c_node
	%r316 = load ptr, ptr %this
	%r317 = getelementptr ptr, ptr %r316, i32 15

	%r318 = load ptr, ptr %r317
	%r319 = call i1 %r318(ptr %this, ptr %r314, ptr  %r315)

	store i1 %r319, ptr %ntb

	br label %l47

l47:
	br label %l44

l42:
	%r320 = load ptr, ptr %p_node
	%r321 = load ptr, ptr %c_node
	%r322 = load ptr, ptr %this
	%r323 = getelementptr ptr, ptr %r322, i32 16

	%r324 = load ptr, ptr %r323
	%r325 = call i1 %r324(ptr %this, ptr %r320, ptr  %r321)

	store i1 %r325, ptr %ntb

	br label %l44

l44:
	ret i1 1
}

define i1@"Tree.RemoveRight_Tree_Tree"(ptr %this, ptr %_p_node, ptr %_c_node) {
	%p_node = alloca ptr
	store ptr %_p_node, ptr %p_node

	%c_node = alloca ptr
	store ptr %_c_node, ptr %c_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	br label %l51
l51:
	%r326 = load ptr, ptr %c_node
	%r327 = load ptr, ptr %r326
	%r328 = getelementptr ptr, ptr %r327, i32 7

	%r329 = load ptr, ptr %r328
	%r330 = call i1 %r329(ptr %r326)

	br i1 %r330, label %l52, label %l53

l52:
	%r331 = load ptr, ptr %c_node
	%r332 = load ptr, ptr %c_node
	%r333 = load ptr, ptr %r332
	%r334 = getelementptr ptr, ptr %r333, i32 3

	%r335 = load ptr, ptr %r334
	%r336 = call ptr %r335(ptr %r332)

	%r337 = load ptr, ptr %r336
	%r338 = getelementptr ptr, ptr %r337, i32 5

	%r339 = load ptr, ptr %r338
	%r340 = call i32 %r339(ptr %r336)

	%r341 = load ptr, ptr %r331
	%r342 = getelementptr ptr, ptr %r341, i32 6

	%r343 = load ptr, ptr %r342
	%r344 = call i1 %r343(ptr %r331, i32 %r340)

	store i1 %r344, ptr %ntb

	%r345 = load ptr, ptr %c_node
	store ptr %r345, ptr %p_node

	%r346 = load ptr, ptr %c_node
	%r347 = load ptr, ptr %r346
	%r348 = getelementptr ptr, ptr %r347, i32 3

	%r349 = load ptr, ptr %r348
	%r350 = call ptr %r349(ptr %r346)

	store ptr %r350, ptr %c_node

	br label %l51

l53:
	%r351 = load ptr, ptr %p_node
	%r352 = getelementptr i8, ptr %this, i32 30
	%r353 = load ptr, ptr %r352

	%r354 = load ptr, ptr %r351
	%r355 = getelementptr ptr, ptr %r354, i32 1

	%r356 = load ptr, ptr %r355
	%r357 = call i1 %r356(ptr %r351, ptr %r353)

	store i1 %r357, ptr %ntb

	%r358 = load ptr, ptr %p_node
	%r359 = load ptr, ptr %r358
	%r360 = getelementptr ptr, ptr %r359, i32 10

	%r361 = load ptr, ptr %r360
	%r362 = call i1 %r361(ptr %r358, i1 0)

	store i1 %r362, ptr %ntb

	ret i1 1
}

define i1@"Tree.RemoveLeft_Tree_Tree"(ptr %this, ptr %_p_node, ptr %_c_node) {
	%p_node = alloca ptr
	store ptr %_p_node, ptr %p_node

	%c_node = alloca ptr
	store ptr %_c_node, ptr %c_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	br label %l54
l54:
	%r363 = load ptr, ptr %c_node
	%r364 = load ptr, ptr %r363
	%r365 = getelementptr ptr, ptr %r364, i32 8

	%r366 = load ptr, ptr %r365
	%r367 = call i1 %r366(ptr %r363)

	br i1 %r367, label %l55, label %l56

l55:
	%r368 = load ptr, ptr %c_node
	%r369 = load ptr, ptr %c_node
	%r370 = load ptr, ptr %r369
	%r371 = getelementptr ptr, ptr %r370, i32 4

	%r372 = load ptr, ptr %r371
	%r373 = call ptr %r372(ptr %r369)

	%r374 = load ptr, ptr %r373
	%r375 = getelementptr ptr, ptr %r374, i32 5

	%r376 = load ptr, ptr %r375
	%r377 = call i32 %r376(ptr %r373)

	%r378 = load ptr, ptr %r368
	%r379 = getelementptr ptr, ptr %r378, i32 6

	%r380 = load ptr, ptr %r379
	%r381 = call i1 %r380(ptr %r368, i32 %r377)

	store i1 %r381, ptr %ntb

	%r382 = load ptr, ptr %c_node
	store ptr %r382, ptr %p_node

	%r383 = load ptr, ptr %c_node
	%r384 = load ptr, ptr %r383
	%r385 = getelementptr ptr, ptr %r384, i32 4

	%r386 = load ptr, ptr %r385
	%r387 = call ptr %r386(ptr %r383)

	store ptr %r387, ptr %c_node

	br label %l54

l56:
	%r388 = load ptr, ptr %p_node
	%r389 = getelementptr i8, ptr %this, i32 30
	%r390 = load ptr, ptr %r389

	%r391 = load ptr, ptr %r388
	%r392 = getelementptr ptr, ptr %r391, i32 2

	%r393 = load ptr, ptr %r392
	%r394 = call i1 %r393(ptr %r388, ptr %r390)

	store i1 %r394, ptr %ntb

	%r395 = load ptr, ptr %p_node
	%r396 = load ptr, ptr %r395
	%r397 = getelementptr ptr, ptr %r396, i32 9

	%r398 = load ptr, ptr %r397
	%r399 = call i1 %r398(ptr %r395, i1 0)

	store i1 %r399, ptr %ntb

	ret i1 1
}

define i32@"Tree.Search_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%ifound = alloca i32
	store i32 0, ptr %ifound

	%cont = alloca i1
	store i1 0, ptr %cont

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	store ptr %this, ptr %current_node

	store i1 1, ptr %cont

	store i32 0, ptr %ifound

	br label %l57
l57:
	%r400 = load i1, ptr %cont
	br i1 %r400, label %l58, label %l59

l58:
	%r401 = load ptr, ptr %current_node
	%r402 = load ptr, ptr %r401
	%r403 = getelementptr ptr, ptr %r402, i32 5

	%r404 = load ptr, ptr %r403
	%r405 = call i32 %r404(ptr %r401)

	store i32 %r405, ptr %key_aux

	%r406 = load i32, ptr %v_key
	%r407 = load i32, ptr %key_aux
	%r408 = icmp slt i32 %r406, %r407

	br i1 %r408, label %l60, label %l61

l61:
	%r409 = load i32, ptr %key_aux
	%r410 = load i32, ptr %v_key
	%r411 = icmp slt i32 %r409, %r410

	br i1 %r411, label %l63, label %l64

l64:
	store i32 1, ptr %ifound

	store i1 0, ptr %cont

	br label %l65

l63:
	%r412 = load ptr, ptr %current_node
	%r413 = load ptr, ptr %r412
	%r414 = getelementptr ptr, ptr %r413, i32 7

	%r415 = load ptr, ptr %r414
	%r416 = call i1 %r415(ptr %r412)

	br i1 %r416, label %l66, label %l67

l67:
	store i1 0, ptr %cont

	br label %l68

l66:
	%r417 = load ptr, ptr %current_node
	%r418 = load ptr, ptr %r417
	%r419 = getelementptr ptr, ptr %r418, i32 3

	%r420 = load ptr, ptr %r419
	%r421 = call ptr %r420(ptr %r417)

	store ptr %r421, ptr %current_node

	br label %l68

l68:
	br label %l65

l65:
	br label %l62

l60:
	%r422 = load ptr, ptr %current_node
	%r423 = load ptr, ptr %r422
	%r424 = getelementptr ptr, ptr %r423, i32 8

	%r425 = load ptr, ptr %r424
	%r426 = call i1 %r425(ptr %r422)

	br i1 %r426, label %l69, label %l70

l70:
	store i1 0, ptr %cont

	br label %l71

l69:
	%r427 = load ptr, ptr %current_node
	%r428 = load ptr, ptr %r427
	%r429 = getelementptr ptr, ptr %r428, i32 4

	%r430 = load ptr, ptr %r429
	%r431 = call ptr %r430(ptr %r427)

	store ptr %r431, ptr %current_node

	br label %l71

l71:
	br label %l62

l62:
	br label %l57

l59:
	%r432 = load i32, ptr %ifound
	ret i32 %r432
}

define i1@"Tree.Print"(ptr %this) {
	%ntb = alloca i1
	store i1 0, ptr %ntb

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	store ptr %this, ptr %current_node

	%r433 = load ptr, ptr %current_node
	%r434 = load ptr, ptr %this
	%r435 = getelementptr ptr, ptr %r434, i32 19

	%r436 = load ptr, ptr %r435
	%r437 = call i1 %r436(ptr %this, ptr %r433)

	store i1 %r437, ptr %ntb

	ret i1 1
}

define i1@"Tree.RecPrint_Tree"(ptr %this, ptr %_node) {
	%node = alloca ptr
	store ptr %_node, ptr %node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%r438 = load ptr, ptr %node
	%r439 = load ptr, ptr %r438
	%r440 = getelementptr ptr, ptr %r439, i32 8

	%r441 = load ptr, ptr %r440
	%r442 = call i1 %r441(ptr %r438)

	br i1 %r442, label %l72, label %l73

l73:
	store i1 1, ptr %ntb

	br label %l74

l72:
	%r443 = load ptr, ptr %node
	%r444 = load ptr, ptr %r443
	%r445 = getelementptr ptr, ptr %r444, i32 4

	%r446 = load ptr, ptr %r445
	%r447 = call ptr %r446(ptr %r443)

	%r448 = load ptr, ptr %this
	%r449 = getelementptr ptr, ptr %r448, i32 19

	%r450 = load ptr, ptr %r449
	%r451 = call i1 %r450(ptr %this, ptr %r447)

	store i1 %r451, ptr %ntb

	br label %l74

l74:
	%r452 = load ptr, ptr %node
	%r453 = load ptr, ptr %r452
	%r454 = getelementptr ptr, ptr %r453, i32 5

	%r455 = load ptr, ptr %r454
	%r456 = call i32 %r455(ptr %r452)

	call void @print_int(i32 %r456)

	%r457 = load ptr, ptr %node
	%r458 = load ptr, ptr %r457
	%r459 = getelementptr ptr, ptr %r458, i32 7

	%r460 = load ptr, ptr %r459
	%r461 = call i1 %r460(ptr %r457)

	br i1 %r461, label %l75, label %l76

l76:
	store i1 1, ptr %ntb

	br label %l77

l75:
	%r462 = load ptr, ptr %node
	%r463 = load ptr, ptr %r462
	%r464 = getelementptr ptr, ptr %r463, i32 3

	%r465 = load ptr, ptr %r464
	%r466 = call ptr %r465(ptr %r462)

	%r467 = load ptr, ptr %this
	%r468 = getelementptr ptr, ptr %r467, i32 19

	%r469 = load ptr, ptr %r468
	%r470 = call i1 %r469(ptr %this, ptr %r466)

	store i1 %r470, ptr %ntb

	br label %l77

l77:
	ret i1 1
}

define i32@"Tree.accept_Visitor"(ptr %this, ptr %_v) {
	%v = alloca ptr
	store ptr %_v, ptr %v

	%nti = alloca i32
	store i32 0, ptr %nti

	call void @print_int(i32 333)

	%r471 = load ptr, ptr %v
	%r472 = load ptr, ptr %r471
	%r473 = getelementptr ptr, ptr %r472, i32 0

	%r474 = load ptr, ptr %r473
	%r475 = call i32 %r474(ptr %r471, ptr %this)

	store i32 %r475, ptr %nti

	ret i32 0
}

define i32@"Visitor.visit_Tree"(ptr %this, ptr %_n) {
	%n = alloca ptr
	store ptr %_n, ptr %n

	%nti = alloca i32
	store i32 0, ptr %nti

	%r476 = load ptr, ptr %n
	%r477 = load ptr, ptr %r476
	%r478 = getelementptr ptr, ptr %r477, i32 7

	%r479 = load ptr, ptr %r478
	%r480 = call i1 %r479(ptr %r476)

	br i1 %r480, label %l78, label %l79

l79:
	store i32 0, ptr %nti

	br label %l80

l78:
	%r481 = load ptr, ptr %n
	%r482 = load ptr, ptr %r481
	%r483 = getelementptr ptr, ptr %r482, i32 3

	%r484 = load ptr, ptr %r483
	%r485 = call ptr %r484(ptr %r481)

	%r486 = getelementptr i8, ptr %this, i32 16
	store ptr %r485, ptr %r486

	%r487 = getelementptr i8, ptr %this, i32 16
	%r488 = load ptr, ptr %r487

	%r489 = load ptr, ptr %r488
	%r490 = getelementptr ptr, ptr %r489, i32 20

	%r491 = load ptr, ptr %r490
	%r492 = call i32 %r491(ptr %r488, ptr %this)

	store i32 %r492, ptr %nti

	br label %l80

l80:
	%r493 = load ptr, ptr %n
	%r494 = load ptr, ptr %r493
	%r495 = getelementptr ptr, ptr %r494, i32 8

	%r496 = load ptr, ptr %r495
	%r497 = call i1 %r496(ptr %r493)

	br i1 %r497, label %l81, label %l82

l82:
	store i32 0, ptr %nti

	br label %l83

l81:
	%r498 = load ptr, ptr %n
	%r499 = load ptr, ptr %r498
	%r500 = getelementptr ptr, ptr %r499, i32 4

	%r501 = load ptr, ptr %r500
	%r502 = call ptr %r501(ptr %r498)

	%r503 = getelementptr i8, ptr %this, i32 8
	store ptr %r502, ptr %r503

	%r504 = getelementptr i8, ptr %this, i32 8
	%r505 = load ptr, ptr %r504

	%r506 = load ptr, ptr %r505
	%r507 = getelementptr ptr, ptr %r506, i32 20

	%r508 = load ptr, ptr %r507
	%r509 = call i32 %r508(ptr %r505, ptr %this)

	store i32 %r509, ptr %nti

	br label %l83

l83:
	ret i32 0
}

define i32@"MyVisitor.visit_Tree"(ptr %this, ptr %_n) {
	%n = alloca ptr
	store ptr %_n, ptr %n

	%nti = alloca i32
	store i32 0, ptr %nti

	%r510 = load ptr, ptr %n
	%r511 = load ptr, ptr %r510
	%r512 = getelementptr ptr, ptr %r511, i32 7

	%r513 = load ptr, ptr %r512
	%r514 = call i1 %r513(ptr %r510)

	br i1 %r514, label %l84, label %l85

l85:
	store i32 0, ptr %nti

	br label %l86

l84:
	%r515 = load ptr, ptr %n
	%r516 = load ptr, ptr %r515
	%r517 = getelementptr ptr, ptr %r516, i32 3

	%r518 = load ptr, ptr %r517
	%r519 = call ptr %r518(ptr %r515)

	%r520 = getelementptr i8, ptr %this, i32 16
	store ptr %r519, ptr %r520

	%r521 = getelementptr i8, ptr %this, i32 16
	%r522 = load ptr, ptr %r521

	%r523 = load ptr, ptr %r522
	%r524 = getelementptr ptr, ptr %r523, i32 20

	%r525 = load ptr, ptr %r524
	%r526 = call i32 %r525(ptr %r522, ptr %this)

	store i32 %r526, ptr %nti

	br label %l86

l86:
	%r527 = load ptr, ptr %n
	%r528 = load ptr, ptr %r527
	%r529 = getelementptr ptr, ptr %r528, i32 5

	%r530 = load ptr, ptr %r529
	%r531 = call i32 %r530(ptr %r527)

	call void @print_int(i32 %r531)

	%r532 = load ptr, ptr %n
	%r533 = load ptr, ptr %r532
	%r534 = getelementptr ptr, ptr %r533, i32 8

	%r535 = load ptr, ptr %r534
	%r536 = call i1 %r535(ptr %r532)

	br i1 %r536, label %l87, label %l88

l88:
	store i32 0, ptr %nti

	br label %l89

l87:
	%r537 = load ptr, ptr %n
	%r538 = load ptr, ptr %r537
	%r539 = getelementptr ptr, ptr %r538, i32 4

	%r540 = load ptr, ptr %r539
	%r541 = call ptr %r540(ptr %r537)

	%r542 = getelementptr i8, ptr %this, i32 8
	store ptr %r541, ptr %r542

	%r543 = getelementptr i8, ptr %this, i32 8
	%r544 = load ptr, ptr %r543

	%r545 = load ptr, ptr %r544
	%r546 = getelementptr ptr, ptr %r545, i32 20

	%r547 = load ptr, ptr %r546
	%r548 = call i32 %r547(ptr %r544, ptr %this)

	store i32 %r548, ptr %nti

	br label %l89

l89:
	ret i32 0
}
