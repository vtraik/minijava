@.BinaryTree_vtable = global [0 x ptr] []
@.BT_vtable = global [1 x ptr] [ptr @"BT.Start"]
@.Tree_vtable = global [20 x ptr] [ptr @"Tree.Init_int", ptr @"Tree.SetRight_Tree", ptr @"Tree.SetLeft_Tree", ptr @"Tree.GetRight", ptr @"Tree.GetLeft", ptr @"Tree.GetKey", ptr @"Tree.SetKey_int", ptr @"Tree.GetHas_Right", ptr @"Tree.GetHas_Left", ptr @"Tree.SetHas_Left_boolean", ptr @"Tree.SetHas_Right_boolean", ptr @"Tree.Compare_int_int", ptr @"Tree.Insert_int", ptr @"Tree.Delete_int", ptr @"Tree.Remove_Tree_Tree", ptr @"Tree.RemoveRight_Tree_Tree", ptr @"Tree.RemoveLeft_Tree_Tree", ptr @"Tree.Search_int", ptr @"Tree.Print", ptr @"Tree.RecPrint_Tree"]

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
	%r1 = getelementptr [1 x ptr], ptr @.BT_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"BT.Start"(ptr %this) {
	%root = alloca ptr
	store ptr null, ptr %root

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%nti = alloca i32
	store i32 0, ptr %nti

	%r6 = call ptr @calloc(i32 1, i32 38)
	%r7 = getelementptr [20 x ptr], ptr @.Tree_vtable, i32 0, i32 0
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
	%r25 = getelementptr ptr, ptr %r24, i32 18

	%r26 = load ptr, ptr %r25
	%r27 = call i1 %r26(ptr %r23)

	store i1 %r27, ptr %ntb

	%r28 = load ptr, ptr %root
	%r29 = load ptr, ptr %r28
	%r30 = getelementptr ptr, ptr %r29, i32 12

	%r31 = load ptr, ptr %r30
	%r32 = call i1 %r31(ptr %r28, i32 24)

	store i1 %r32, ptr %ntb

	%r33 = load ptr, ptr %root
	%r34 = load ptr, ptr %r33
	%r35 = getelementptr ptr, ptr %r34, i32 12

	%r36 = load ptr, ptr %r35
	%r37 = call i1 %r36(ptr %r33, i32 4)

	store i1 %r37, ptr %ntb

	%r38 = load ptr, ptr %root
	%r39 = load ptr, ptr %r38
	%r40 = getelementptr ptr, ptr %r39, i32 12

	%r41 = load ptr, ptr %r40
	%r42 = call i1 %r41(ptr %r38, i32 12)

	store i1 %r42, ptr %ntb

	%r43 = load ptr, ptr %root
	%r44 = load ptr, ptr %r43
	%r45 = getelementptr ptr, ptr %r44, i32 12

	%r46 = load ptr, ptr %r45
	%r47 = call i1 %r46(ptr %r43, i32 20)

	store i1 %r47, ptr %ntb

	%r48 = load ptr, ptr %root
	%r49 = load ptr, ptr %r48
	%r50 = getelementptr ptr, ptr %r49, i32 12

	%r51 = load ptr, ptr %r50
	%r52 = call i1 %r51(ptr %r48, i32 28)

	store i1 %r52, ptr %ntb

	%r53 = load ptr, ptr %root
	%r54 = load ptr, ptr %r53
	%r55 = getelementptr ptr, ptr %r54, i32 12

	%r56 = load ptr, ptr %r55
	%r57 = call i1 %r56(ptr %r53, i32 14)

	store i1 %r57, ptr %ntb

	%r58 = load ptr, ptr %root
	%r59 = load ptr, ptr %r58
	%r60 = getelementptr ptr, ptr %r59, i32 18

	%r61 = load ptr, ptr %r60
	%r62 = call i1 %r61(ptr %r58)

	store i1 %r62, ptr %ntb

	%r63 = load ptr, ptr %root
	%r64 = load ptr, ptr %r63
	%r65 = getelementptr ptr, ptr %r64, i32 17

	%r66 = load ptr, ptr %r65
	%r67 = call i32 %r66(ptr %r63, i32 24)

	call void @print_int(i32 %r67)

	%r68 = load ptr, ptr %root
	%r69 = load ptr, ptr %r68
	%r70 = getelementptr ptr, ptr %r69, i32 17

	%r71 = load ptr, ptr %r70
	%r72 = call i32 %r71(ptr %r68, i32 12)

	call void @print_int(i32 %r72)

	%r73 = load ptr, ptr %root
	%r74 = load ptr, ptr %r73
	%r75 = getelementptr ptr, ptr %r74, i32 17

	%r76 = load ptr, ptr %r75
	%r77 = call i32 %r76(ptr %r73, i32 16)

	call void @print_int(i32 %r77)

	%r78 = load ptr, ptr %root
	%r79 = load ptr, ptr %r78
	%r80 = getelementptr ptr, ptr %r79, i32 17

	%r81 = load ptr, ptr %r80
	%r82 = call i32 %r81(ptr %r78, i32 50)

	call void @print_int(i32 %r82)

	%r83 = load ptr, ptr %root
	%r84 = load ptr, ptr %r83
	%r85 = getelementptr ptr, ptr %r84, i32 17

	%r86 = load ptr, ptr %r85
	%r87 = call i32 %r86(ptr %r83, i32 12)

	call void @print_int(i32 %r87)

	%r88 = load ptr, ptr %root
	%r89 = load ptr, ptr %r88
	%r90 = getelementptr ptr, ptr %r89, i32 13

	%r91 = load ptr, ptr %r90
	%r92 = call i1 %r91(ptr %r88, i32 12)

	store i1 %r92, ptr %ntb

	%r93 = load ptr, ptr %root
	%r94 = load ptr, ptr %r93
	%r95 = getelementptr ptr, ptr %r94, i32 18

	%r96 = load ptr, ptr %r95
	%r97 = call i1 %r96(ptr %r93)

	store i1 %r97, ptr %ntb

	%r98 = load ptr, ptr %root
	%r99 = load ptr, ptr %r98
	%r100 = getelementptr ptr, ptr %r99, i32 17

	%r101 = load ptr, ptr %r100
	%r102 = call i32 %r101(ptr %r98, i32 12)

	call void @print_int(i32 %r102)

	ret i32 0
}

define i1@"Tree.Init_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%r103 = load i32, ptr %v_key
	%r104 = getelementptr i8, ptr %this, i32 24
	store i32 %r103, ptr %r104

	%r105 = getelementptr i8, ptr %this, i32 28
	store i1 0, ptr %r105

	%r106 = getelementptr i8, ptr %this, i32 29
	store i1 0, ptr %r106

	ret i1 1
}

define i1@"Tree.SetRight_Tree"(ptr %this, ptr %_rn) {
	%rn = alloca ptr
	store ptr %_rn, ptr %rn

	%r107 = load ptr, ptr %rn
	%r108 = getelementptr i8, ptr %this, i32 16
	store ptr %r107, ptr %r108

	ret i1 1
}

define i1@"Tree.SetLeft_Tree"(ptr %this, ptr %_ln) {
	%ln = alloca ptr
	store ptr %_ln, ptr %ln

	%r109 = load ptr, ptr %ln
	%r110 = getelementptr i8, ptr %this, i32 8
	store ptr %r109, ptr %r110

	ret i1 1
}

define ptr@"Tree.GetRight"(ptr %this) {
	%r111 = getelementptr i8, ptr %this, i32 16
	%r112 = load ptr, ptr %r111

	ret ptr %r112
}

define ptr@"Tree.GetLeft"(ptr %this) {
	%r113 = getelementptr i8, ptr %this, i32 8
	%r114 = load ptr, ptr %r113

	ret ptr %r114
}

define i32@"Tree.GetKey"(ptr %this) {
	%r115 = getelementptr i8, ptr %this, i32 24
	%r116 = load i32, ptr %r115

	ret i32 %r116
}

define i1@"Tree.SetKey_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%r117 = load i32, ptr %v_key
	%r118 = getelementptr i8, ptr %this, i32 24
	store i32 %r117, ptr %r118

	ret i1 1
}

define i1@"Tree.GetHas_Right"(ptr %this) {
	%r119 = getelementptr i8, ptr %this, i32 29
	%r120 = load i1, ptr %r119

	ret i1 %r120
}

define i1@"Tree.GetHas_Left"(ptr %this) {
	%r121 = getelementptr i8, ptr %this, i32 28
	%r122 = load i1, ptr %r121

	ret i1 %r122
}

define i1@"Tree.SetHas_Left_boolean"(ptr %this, i1 %_val) {
	%val = alloca i1
	store i1 %_val, ptr %val

	%r123 = load i1, ptr %val
	%r124 = getelementptr i8, ptr %this, i32 28
	store i1 %r123, ptr %r124

	ret i1 1
}

define i1@"Tree.SetHas_Right_boolean"(ptr %this, i1 %_val) {
	%val = alloca i1
	store i1 %_val, ptr %val

	%r125 = load i1, ptr %val
	%r126 = getelementptr i8, ptr %this, i32 29
	store i1 %r125, ptr %r126

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

	%r127 = load i32, ptr %num2
	%r128 = add i32 %r127, 1

	store i32 %r128, ptr %nti

	%r129 = load i32, ptr %num1
	%r130 = load i32, ptr %num2
	%r131 = icmp slt i32 %r129, %r130

	br i1 %r131, label %l0, label %l1

l1:
	%r132 = load i32, ptr %num1
	%r133 = load i32, ptr %nti
	%r134 = icmp slt i32 %r132, %r133

	%r135 = xor i1 1, %r134

	br i1 %r135, label %l3, label %l4

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
	%r136 = load i1, ptr %ntb
	ret i1 %r136
}

define i1@"Tree.Insert_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%new_node = alloca ptr
	store ptr null, ptr %new_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%cont = alloca i1
	store i1 0, ptr %cont

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%r137 = call ptr @calloc(i32 1, i32 38)
	%r138 = getelementptr [20 x ptr], ptr @.Tree_vtable, i32 0, i32 0
	store ptr %r138, ptr %r137

	store ptr %r137, ptr %new_node

	%r139 = load ptr, ptr %new_node
	%r140 = load i32, ptr %v_key
	%r141 = load ptr, ptr %r139
	%r142 = getelementptr ptr, ptr %r141, i32 0

	%r143 = load ptr, ptr %r142
	%r144 = call i1 %r143(ptr %r139, i32 %r140)

	store i1 %r144, ptr %ntb

	store ptr %this, ptr %current_node

	store i1 1, ptr %cont

	br label %l6
l6:
	%r145 = load i1, ptr %cont
	br i1 %r145, label %l7, label %l8

l7:
	%r146 = load ptr, ptr %current_node
	%r147 = load ptr, ptr %r146
	%r148 = getelementptr ptr, ptr %r147, i32 5

	%r149 = load ptr, ptr %r148
	%r150 = call i32 %r149(ptr %r146)

	store i32 %r150, ptr %key_aux

	%r151 = load i32, ptr %v_key
	%r152 = load i32, ptr %key_aux
	%r153 = icmp slt i32 %r151, %r152

	br i1 %r153, label %l9, label %l10

l10:
	%r154 = load ptr, ptr %current_node
	%r155 = load ptr, ptr %r154
	%r156 = getelementptr ptr, ptr %r155, i32 7

	%r157 = load ptr, ptr %r156
	%r158 = call i1 %r157(ptr %r154)

	br i1 %r158, label %l12, label %l13

l13:
	store i1 0, ptr %cont

	%r159 = load ptr, ptr %current_node
	%r160 = load ptr, ptr %r159
	%r161 = getelementptr ptr, ptr %r160, i32 10

	%r162 = load ptr, ptr %r161
	%r163 = call i1 %r162(ptr %r159, i1 1)

	store i1 %r163, ptr %ntb

	%r164 = load ptr, ptr %current_node
	%r165 = load ptr, ptr %new_node
	%r166 = load ptr, ptr %r164
	%r167 = getelementptr ptr, ptr %r166, i32 1

	%r168 = load ptr, ptr %r167
	%r169 = call i1 %r168(ptr %r164, ptr %r165)

	store i1 %r169, ptr %ntb

	br label %l14

l12:
	%r170 = load ptr, ptr %current_node
	%r171 = load ptr, ptr %r170
	%r172 = getelementptr ptr, ptr %r171, i32 3

	%r173 = load ptr, ptr %r172
	%r174 = call ptr %r173(ptr %r170)

	store ptr %r174, ptr %current_node

	br label %l14

l14:
	br label %l11

l9:
	%r175 = load ptr, ptr %current_node
	%r176 = load ptr, ptr %r175
	%r177 = getelementptr ptr, ptr %r176, i32 8

	%r178 = load ptr, ptr %r177
	%r179 = call i1 %r178(ptr %r175)

	br i1 %r179, label %l15, label %l16

l16:
	store i1 0, ptr %cont

	%r180 = load ptr, ptr %current_node
	%r181 = load ptr, ptr %r180
	%r182 = getelementptr ptr, ptr %r181, i32 9

	%r183 = load ptr, ptr %r182
	%r184 = call i1 %r183(ptr %r180, i1 1)

	store i1 %r184, ptr %ntb

	%r185 = load ptr, ptr %current_node
	%r186 = load ptr, ptr %new_node
	%r187 = load ptr, ptr %r185
	%r188 = getelementptr ptr, ptr %r187, i32 2

	%r189 = load ptr, ptr %r188
	%r190 = call i1 %r189(ptr %r185, ptr %r186)

	store i1 %r190, ptr %ntb

	br label %l17

l15:
	%r191 = load ptr, ptr %current_node
	%r192 = load ptr, ptr %r191
	%r193 = getelementptr ptr, ptr %r192, i32 4

	%r194 = load ptr, ptr %r193
	%r195 = call ptr %r194(ptr %r191)

	store ptr %r195, ptr %current_node

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

	%is_root = alloca i1
	store i1 0, ptr %is_root

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	%ntb = alloca i1
	store i1 0, ptr %ntb

	store ptr %this, ptr %current_node

	store ptr %this, ptr %parent_node

	store i1 1, ptr %cont

	store i1 0, ptr %found

	store i1 1, ptr %is_root

	br label %l18
l18:
	%r196 = load i1, ptr %cont
	br i1 %r196, label %l19, label %l20

l19:
	%r197 = load ptr, ptr %current_node
	%r198 = load ptr, ptr %r197
	%r199 = getelementptr ptr, ptr %r198, i32 5

	%r200 = load ptr, ptr %r199
	%r201 = call i32 %r200(ptr %r197)

	store i32 %r201, ptr %key_aux

	%r202 = load i32, ptr %v_key
	%r203 = load i32, ptr %key_aux
	%r204 = icmp slt i32 %r202, %r203

	br i1 %r204, label %l21, label %l22

l22:
	%r205 = load i32, ptr %key_aux
	%r206 = load i32, ptr %v_key
	%r207 = icmp slt i32 %r205, %r206

	br i1 %r207, label %l24, label %l25

l25:
	%r208 = load i1, ptr %is_root
	br i1 %r208, label %l27, label %l28

l28:
	%r209 = load ptr, ptr %parent_node
	%r210 = load ptr, ptr %current_node
	%r211 = load ptr, ptr %this
	%r212 = getelementptr ptr, ptr %r211, i32 14

	%r213 = load ptr, ptr %r212
	%r214 = call i1 %r213(ptr %this, ptr %r209, ptr  %r210)

	store i1 %r214, ptr %ntb

	br label %l29

l27:
	%r215 = load ptr, ptr %current_node
	%r216 = load ptr, ptr %r215
	%r217 = getelementptr ptr, ptr %r216, i32 7

	%r218 = load ptr, ptr %r217
	%r219 = call i1 %r218(ptr %r215)

	%r220 = xor i1 1, %r219

	br i1 %r220, label %l30, label %l31

l31:
	br label %l32

l30:
	%r221 = load ptr, ptr %current_node
	%r222 = load ptr, ptr %r221
	%r223 = getelementptr ptr, ptr %r222, i32 8

	%r224 = load ptr, ptr %r223
	%r225 = call i1 %r224(ptr %r221)

	%r226 = xor i1 1, %r225

	br label %l32

l32:
	%r227 = phi i1 [ 0, %l31 ], [ %r226, %l30 ]

	br i1 %r227, label %l33, label %l34

l34:
	%r228 = load ptr, ptr %parent_node
	%r229 = load ptr, ptr %current_node
	%r230 = load ptr, ptr %this
	%r231 = getelementptr ptr, ptr %r230, i32 14

	%r232 = load ptr, ptr %r231
	%r233 = call i1 %r232(ptr %this, ptr %r228, ptr  %r229)

	store i1 %r233, ptr %ntb

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
	%r234 = load ptr, ptr %current_node
	%r235 = load ptr, ptr %r234
	%r236 = getelementptr ptr, ptr %r235, i32 7

	%r237 = load ptr, ptr %r236
	%r238 = call i1 %r237(ptr %r234)

	br i1 %r238, label %l36, label %l37

l37:
	store i1 0, ptr %cont

	br label %l38

l36:
	%r239 = load ptr, ptr %current_node
	store ptr %r239, ptr %parent_node

	%r240 = load ptr, ptr %current_node
	%r241 = load ptr, ptr %r240
	%r242 = getelementptr ptr, ptr %r241, i32 3

	%r243 = load ptr, ptr %r242
	%r244 = call ptr %r243(ptr %r240)

	store ptr %r244, ptr %current_node

	br label %l38

l38:
	br label %l26

l26:
	br label %l23

l21:
	%r245 = load ptr, ptr %current_node
	%r246 = load ptr, ptr %r245
	%r247 = getelementptr ptr, ptr %r246, i32 8

	%r248 = load ptr, ptr %r247
	%r249 = call i1 %r248(ptr %r245)

	br i1 %r249, label %l39, label %l40

l40:
	store i1 0, ptr %cont

	br label %l41

l39:
	%r250 = load ptr, ptr %current_node
	store ptr %r250, ptr %parent_node

	%r251 = load ptr, ptr %current_node
	%r252 = load ptr, ptr %r251
	%r253 = getelementptr ptr, ptr %r252, i32 4

	%r254 = load ptr, ptr %r253
	%r255 = call ptr %r254(ptr %r251)

	store ptr %r255, ptr %current_node

	br label %l41

l41:
	br label %l23

l23:
	store i1 0, ptr %is_root

	br label %l18

l20:
	%r256 = load i1, ptr %found
	ret i1 %r256
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

	%r257 = load ptr, ptr %c_node
	%r258 = load ptr, ptr %r257
	%r259 = getelementptr ptr, ptr %r258, i32 8

	%r260 = load ptr, ptr %r259
	%r261 = call i1 %r260(ptr %r257)

	br i1 %r261, label %l42, label %l43

l43:
	%r262 = load ptr, ptr %c_node
	%r263 = load ptr, ptr %r262
	%r264 = getelementptr ptr, ptr %r263, i32 7

	%r265 = load ptr, ptr %r264
	%r266 = call i1 %r265(ptr %r262)

	br i1 %r266, label %l45, label %l46

l46:
	%r267 = load ptr, ptr %c_node
	%r268 = load ptr, ptr %r267
	%r269 = getelementptr ptr, ptr %r268, i32 5

	%r270 = load ptr, ptr %r269
	%r271 = call i32 %r270(ptr %r267)

	store i32 %r271, ptr %auxkey1

	%r272 = load ptr, ptr %p_node
	%r273 = load ptr, ptr %r272
	%r274 = getelementptr ptr, ptr %r273, i32 4

	%r275 = load ptr, ptr %r274
	%r276 = call ptr %r275(ptr %r272)

	%r277 = load ptr, ptr %r276
	%r278 = getelementptr ptr, ptr %r277, i32 5

	%r279 = load ptr, ptr %r278
	%r280 = call i32 %r279(ptr %r276)

	store i32 %r280, ptr %auxkey2

	%r281 = load i32, ptr %auxkey1
	%r282 = load i32, ptr %auxkey2
	%r283 = load ptr, ptr %this
	%r284 = getelementptr ptr, ptr %r283, i32 11

	%r285 = load ptr, ptr %r284
	%r286 = call i1 %r285(ptr %this, i32 %r281, i32  %r282)

	br i1 %r286, label %l48, label %l49

l49:
	%r287 = load ptr, ptr %p_node
	%r288 = getelementptr i8, ptr %this, i32 30
	%r289 = load ptr, ptr %r288

	%r290 = load ptr, ptr %r287
	%r291 = getelementptr ptr, ptr %r290, i32 1

	%r292 = load ptr, ptr %r291
	%r293 = call i1 %r292(ptr %r287, ptr %r289)

	store i1 %r293, ptr %ntb

	%r294 = load ptr, ptr %p_node
	%r295 = load ptr, ptr %r294
	%r296 = getelementptr ptr, ptr %r295, i32 10

	%r297 = load ptr, ptr %r296
	%r298 = call i1 %r297(ptr %r294, i1 0)

	store i1 %r298, ptr %ntb

	br label %l50

l48:
	%r299 = load ptr, ptr %p_node
	%r300 = getelementptr i8, ptr %this, i32 30
	%r301 = load ptr, ptr %r300

	%r302 = load ptr, ptr %r299
	%r303 = getelementptr ptr, ptr %r302, i32 2

	%r304 = load ptr, ptr %r303
	%r305 = call i1 %r304(ptr %r299, ptr %r301)

	store i1 %r305, ptr %ntb

	%r306 = load ptr, ptr %p_node
	%r307 = load ptr, ptr %r306
	%r308 = getelementptr ptr, ptr %r307, i32 9

	%r309 = load ptr, ptr %r308
	%r310 = call i1 %r309(ptr %r306, i1 0)

	store i1 %r310, ptr %ntb

	br label %l50

l50:
	br label %l47

l45:
	%r311 = load ptr, ptr %p_node
	%r312 = load ptr, ptr %c_node
	%r313 = load ptr, ptr %this
	%r314 = getelementptr ptr, ptr %r313, i32 15

	%r315 = load ptr, ptr %r314
	%r316 = call i1 %r315(ptr %this, ptr %r311, ptr  %r312)

	store i1 %r316, ptr %ntb

	br label %l47

l47:
	br label %l44

l42:
	%r317 = load ptr, ptr %p_node
	%r318 = load ptr, ptr %c_node
	%r319 = load ptr, ptr %this
	%r320 = getelementptr ptr, ptr %r319, i32 16

	%r321 = load ptr, ptr %r320
	%r322 = call i1 %r321(ptr %this, ptr %r317, ptr  %r318)

	store i1 %r322, ptr %ntb

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
	%r323 = load ptr, ptr %c_node
	%r324 = load ptr, ptr %r323
	%r325 = getelementptr ptr, ptr %r324, i32 7

	%r326 = load ptr, ptr %r325
	%r327 = call i1 %r326(ptr %r323)

	br i1 %r327, label %l52, label %l53

l52:
	%r328 = load ptr, ptr %c_node
	%r329 = load ptr, ptr %c_node
	%r330 = load ptr, ptr %r329
	%r331 = getelementptr ptr, ptr %r330, i32 3

	%r332 = load ptr, ptr %r331
	%r333 = call ptr %r332(ptr %r329)

	%r334 = load ptr, ptr %r333
	%r335 = getelementptr ptr, ptr %r334, i32 5

	%r336 = load ptr, ptr %r335
	%r337 = call i32 %r336(ptr %r333)

	%r338 = load ptr, ptr %r328
	%r339 = getelementptr ptr, ptr %r338, i32 6

	%r340 = load ptr, ptr %r339
	%r341 = call i1 %r340(ptr %r328, i32 %r337)

	store i1 %r341, ptr %ntb

	%r342 = load ptr, ptr %c_node
	store ptr %r342, ptr %p_node

	%r343 = load ptr, ptr %c_node
	%r344 = load ptr, ptr %r343
	%r345 = getelementptr ptr, ptr %r344, i32 3

	%r346 = load ptr, ptr %r345
	%r347 = call ptr %r346(ptr %r343)

	store ptr %r347, ptr %c_node

	br label %l51

l53:
	%r348 = load ptr, ptr %p_node
	%r349 = getelementptr i8, ptr %this, i32 30
	%r350 = load ptr, ptr %r349

	%r351 = load ptr, ptr %r348
	%r352 = getelementptr ptr, ptr %r351, i32 1

	%r353 = load ptr, ptr %r352
	%r354 = call i1 %r353(ptr %r348, ptr %r350)

	store i1 %r354, ptr %ntb

	%r355 = load ptr, ptr %p_node
	%r356 = load ptr, ptr %r355
	%r357 = getelementptr ptr, ptr %r356, i32 10

	%r358 = load ptr, ptr %r357
	%r359 = call i1 %r358(ptr %r355, i1 0)

	store i1 %r359, ptr %ntb

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
	%r360 = load ptr, ptr %c_node
	%r361 = load ptr, ptr %r360
	%r362 = getelementptr ptr, ptr %r361, i32 8

	%r363 = load ptr, ptr %r362
	%r364 = call i1 %r363(ptr %r360)

	br i1 %r364, label %l55, label %l56

l55:
	%r365 = load ptr, ptr %c_node
	%r366 = load ptr, ptr %c_node
	%r367 = load ptr, ptr %r366
	%r368 = getelementptr ptr, ptr %r367, i32 4

	%r369 = load ptr, ptr %r368
	%r370 = call ptr %r369(ptr %r366)

	%r371 = load ptr, ptr %r370
	%r372 = getelementptr ptr, ptr %r371, i32 5

	%r373 = load ptr, ptr %r372
	%r374 = call i32 %r373(ptr %r370)

	%r375 = load ptr, ptr %r365
	%r376 = getelementptr ptr, ptr %r375, i32 6

	%r377 = load ptr, ptr %r376
	%r378 = call i1 %r377(ptr %r365, i32 %r374)

	store i1 %r378, ptr %ntb

	%r379 = load ptr, ptr %c_node
	store ptr %r379, ptr %p_node

	%r380 = load ptr, ptr %c_node
	%r381 = load ptr, ptr %r380
	%r382 = getelementptr ptr, ptr %r381, i32 4

	%r383 = load ptr, ptr %r382
	%r384 = call ptr %r383(ptr %r380)

	store ptr %r384, ptr %c_node

	br label %l54

l56:
	%r385 = load ptr, ptr %p_node
	%r386 = getelementptr i8, ptr %this, i32 30
	%r387 = load ptr, ptr %r386

	%r388 = load ptr, ptr %r385
	%r389 = getelementptr ptr, ptr %r388, i32 2

	%r390 = load ptr, ptr %r389
	%r391 = call i1 %r390(ptr %r385, ptr %r387)

	store i1 %r391, ptr %ntb

	%r392 = load ptr, ptr %p_node
	%r393 = load ptr, ptr %r392
	%r394 = getelementptr ptr, ptr %r393, i32 9

	%r395 = load ptr, ptr %r394
	%r396 = call i1 %r395(ptr %r392, i1 0)

	store i1 %r396, ptr %ntb

	ret i1 1
}

define i32@"Tree.Search_int"(ptr %this, i32 %_v_key) {
	%v_key = alloca i32
	store i32 %_v_key, ptr %v_key

	%cont = alloca i1
	store i1 0, ptr %cont

	%ifound = alloca i32
	store i32 0, ptr %ifound

	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%key_aux = alloca i32
	store i32 0, ptr %key_aux

	store ptr %this, ptr %current_node

	store i1 1, ptr %cont

	store i32 0, ptr %ifound

	br label %l57
l57:
	%r397 = load i1, ptr %cont
	br i1 %r397, label %l58, label %l59

l58:
	%r398 = load ptr, ptr %current_node
	%r399 = load ptr, ptr %r398
	%r400 = getelementptr ptr, ptr %r399, i32 5

	%r401 = load ptr, ptr %r400
	%r402 = call i32 %r401(ptr %r398)

	store i32 %r402, ptr %key_aux

	%r403 = load i32, ptr %v_key
	%r404 = load i32, ptr %key_aux
	%r405 = icmp slt i32 %r403, %r404

	br i1 %r405, label %l60, label %l61

l61:
	%r406 = load i32, ptr %key_aux
	%r407 = load i32, ptr %v_key
	%r408 = icmp slt i32 %r406, %r407

	br i1 %r408, label %l63, label %l64

l64:
	store i32 1, ptr %ifound

	store i1 0, ptr %cont

	br label %l65

l63:
	%r409 = load ptr, ptr %current_node
	%r410 = load ptr, ptr %r409
	%r411 = getelementptr ptr, ptr %r410, i32 7

	%r412 = load ptr, ptr %r411
	%r413 = call i1 %r412(ptr %r409)

	br i1 %r413, label %l66, label %l67

l67:
	store i1 0, ptr %cont

	br label %l68

l66:
	%r414 = load ptr, ptr %current_node
	%r415 = load ptr, ptr %r414
	%r416 = getelementptr ptr, ptr %r415, i32 3

	%r417 = load ptr, ptr %r416
	%r418 = call ptr %r417(ptr %r414)

	store ptr %r418, ptr %current_node

	br label %l68

l68:
	br label %l65

l65:
	br label %l62

l60:
	%r419 = load ptr, ptr %current_node
	%r420 = load ptr, ptr %r419
	%r421 = getelementptr ptr, ptr %r420, i32 8

	%r422 = load ptr, ptr %r421
	%r423 = call i1 %r422(ptr %r419)

	br i1 %r423, label %l69, label %l70

l70:
	store i1 0, ptr %cont

	br label %l71

l69:
	%r424 = load ptr, ptr %current_node
	%r425 = load ptr, ptr %r424
	%r426 = getelementptr ptr, ptr %r425, i32 4

	%r427 = load ptr, ptr %r426
	%r428 = call ptr %r427(ptr %r424)

	store ptr %r428, ptr %current_node

	br label %l71

l71:
	br label %l62

l62:
	br label %l57

l59:
	%r429 = load i32, ptr %ifound
	ret i32 %r429
}

define i1@"Tree.Print"(ptr %this) {
	%current_node = alloca ptr
	store ptr null, ptr %current_node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	store ptr %this, ptr %current_node

	%r430 = load ptr, ptr %current_node
	%r431 = load ptr, ptr %this
	%r432 = getelementptr ptr, ptr %r431, i32 19

	%r433 = load ptr, ptr %r432
	%r434 = call i1 %r433(ptr %this, ptr %r430)

	store i1 %r434, ptr %ntb

	ret i1 1
}

define i1@"Tree.RecPrint_Tree"(ptr %this, ptr %_node) {
	%node = alloca ptr
	store ptr %_node, ptr %node

	%ntb = alloca i1
	store i1 0, ptr %ntb

	%r435 = load ptr, ptr %node
	%r436 = load ptr, ptr %r435
	%r437 = getelementptr ptr, ptr %r436, i32 8

	%r438 = load ptr, ptr %r437
	%r439 = call i1 %r438(ptr %r435)

	br i1 %r439, label %l72, label %l73

l73:
	store i1 1, ptr %ntb

	br label %l74

l72:
	%r440 = load ptr, ptr %node
	%r441 = load ptr, ptr %r440
	%r442 = getelementptr ptr, ptr %r441, i32 4

	%r443 = load ptr, ptr %r442
	%r444 = call ptr %r443(ptr %r440)

	%r445 = load ptr, ptr %this
	%r446 = getelementptr ptr, ptr %r445, i32 19

	%r447 = load ptr, ptr %r446
	%r448 = call i1 %r447(ptr %this, ptr %r444)

	store i1 %r448, ptr %ntb

	br label %l74

l74:
	%r449 = load ptr, ptr %node
	%r450 = load ptr, ptr %r449
	%r451 = getelementptr ptr, ptr %r450, i32 5

	%r452 = load ptr, ptr %r451
	%r453 = call i32 %r452(ptr %r449)

	call void @print_int(i32 %r453)

	%r454 = load ptr, ptr %node
	%r455 = load ptr, ptr %r454
	%r456 = getelementptr ptr, ptr %r455, i32 7

	%r457 = load ptr, ptr %r456
	%r458 = call i1 %r457(ptr %r454)

	br i1 %r458, label %l75, label %l76

l76:
	store i1 1, ptr %ntb

	br label %l77

l75:
	%r459 = load ptr, ptr %node
	%r460 = load ptr, ptr %r459
	%r461 = getelementptr ptr, ptr %r460, i32 3

	%r462 = load ptr, ptr %r461
	%r463 = call ptr %r462(ptr %r459)

	%r464 = load ptr, ptr %this
	%r465 = getelementptr ptr, ptr %r464, i32 19

	%r466 = load ptr, ptr %r465
	%r467 = call i1 %r466(ptr %this, ptr %r463)

	store i1 %r467, ptr %ntb

	br label %l77

l77:
	ret i1 1
}
