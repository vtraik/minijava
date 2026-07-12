@.LinkedList_vtable = global [0 x ptr] []
@.Element_vtable = global [6 x ptr] [ptr @"Element.Init_int_int_boolean", ptr @"Element.GetAge", ptr @"Element.GetSalary", ptr @"Element.GetMarried", ptr @"Element.Equal_Element", ptr @"Element.Compare_int_int"]
@.List_vtable = global [10 x ptr] [ptr @"List.Init", ptr @"List.InitNew_Element_List_boolean", ptr @"List.Insert_Element", ptr @"List.SetNext_List", ptr @"List.Delete_Element", ptr @"List.Search_Element", ptr @"List.GetEnd", ptr @"List.GetElem", ptr @"List.GetNext", ptr @"List.Print"]
@.LL_vtable = global [1 x ptr] [ptr @"LL.Start"]

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
	%r1 = getelementptr [1 x ptr], ptr @.LL_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i1@"Element.Init_int_int_boolean"(ptr %this, i32 %_v_Age, i32 %_v_Salary, i1 %_v_Married) {
	%v_Age = alloca i32
	store i32 %_v_Age, ptr %v_Age

	%v_Salary = alloca i32
	store i32 %_v_Salary, ptr %v_Salary

	%v_Married = alloca i1
	store i1 %_v_Married, ptr %v_Married

	%r6 = load i32, ptr %v_Age
	%r7 = getelementptr i8, ptr %this, i32 8
	store i32 %r6, ptr %r7

	%r8 = load i32, ptr %v_Salary
	%r9 = getelementptr i8, ptr %this, i32 12
	store i32 %r8, ptr %r9

	%r10 = load i1, ptr %v_Married
	%r11 = getelementptr i8, ptr %this, i32 16
	store i1 %r10, ptr %r11

	ret i1 1
}

define i32@"Element.GetAge"(ptr %this) {
	%r12 = getelementptr i8, ptr %this, i32 8
	%r13 = load i32, ptr %r12

	ret i32 %r13
}

define i32@"Element.GetSalary"(ptr %this) {
	%r14 = getelementptr i8, ptr %this, i32 12
	%r15 = load i32, ptr %r14

	ret i32 %r15
}

define i1@"Element.GetMarried"(ptr %this) {
	%r16 = getelementptr i8, ptr %this, i32 16
	%r17 = load i1, ptr %r16

	ret i1 %r17
}

define i1@"Element.Equal_Element"(ptr %this, ptr %_other) {
	%other = alloca ptr
	store ptr %_other, ptr %other

	%ret_val = alloca i1
	store i1 0, ptr %ret_val

	%aux01 = alloca i32
	store i32 0, ptr %aux01

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	%nt = alloca i32
	store i32 0, ptr %nt

	store i1 1, ptr %ret_val

	%r18 = load ptr, ptr %other
	%r19 = load ptr, ptr %r18
	%r20 = getelementptr ptr, ptr %r19, i32 1

	%r21 = load ptr, ptr %r20
	%r22 = call i32 %r21(ptr %r18)

	store i32 %r22, ptr %aux01

	%r23 = load i32, ptr %aux01
	%r24 = getelementptr i8, ptr %this, i32 8
	%r25 = load i32, ptr %r24

	%r26 = load ptr, ptr %this
	%r27 = getelementptr ptr, ptr %r26, i32 5

	%r28 = load ptr, ptr %r27
	%r29 = call i1 %r28(ptr %this, i32 %r23, i32  %r25)

	%r30 = xor i1 1, %r29

	br i1 %r30, label %l0, label %l1

l1:
	%r31 = load ptr, ptr %other
	%r32 = load ptr, ptr %r31
	%r33 = getelementptr ptr, ptr %r32, i32 2

	%r34 = load ptr, ptr %r33
	%r35 = call i32 %r34(ptr %r31)

	store i32 %r35, ptr %aux02

	%r36 = load i32, ptr %aux02
	%r37 = getelementptr i8, ptr %this, i32 12
	%r38 = load i32, ptr %r37

	%r39 = load ptr, ptr %this
	%r40 = getelementptr ptr, ptr %r39, i32 5

	%r41 = load ptr, ptr %r40
	%r42 = call i1 %r41(ptr %this, i32 %r36, i32  %r38)

	%r43 = xor i1 1, %r42

	br i1 %r43, label %l3, label %l4

l4:
	%r44 = getelementptr i8, ptr %this, i32 16
	%r45 = load i1, ptr %r44

	br i1 %r45, label %l6, label %l7

l7:
	%r46 = load ptr, ptr %other
	%r47 = load ptr, ptr %r46
	%r48 = getelementptr ptr, ptr %r47, i32 3

	%r49 = load ptr, ptr %r48
	%r50 = call i1 %r49(ptr %r46)

	br i1 %r50, label %l9, label %l10

l10:
	store i32 0, ptr %nt

	br label %l11

l9:
	store i1 0, ptr %ret_val

	br label %l11

l11:
	br label %l8

l6:
	%r51 = load ptr, ptr %other
	%r52 = load ptr, ptr %r51
	%r53 = getelementptr ptr, ptr %r52, i32 3

	%r54 = load ptr, ptr %r53
	%r55 = call i1 %r54(ptr %r51)

	%r56 = xor i1 1, %r55

	br i1 %r56, label %l12, label %l13

l13:
	store i32 0, ptr %nt

	br label %l14

l12:
	store i1 0, ptr %ret_val

	br label %l14

l14:
	br label %l8

l8:
	br label %l5

l3:
	store i1 0, ptr %ret_val

	br label %l5

l5:
	br label %l2

l0:
	store i1 0, ptr %ret_val

	br label %l2

l2:
	%r57 = load i1, ptr %ret_val
	ret i1 %r57
}

define i1@"Element.Compare_int_int"(ptr %this, i32 %_num1, i32 %_num2) {
	%num1 = alloca i32
	store i32 %_num1, ptr %num1

	%num2 = alloca i32
	store i32 %_num2, ptr %num2

	%retval = alloca i1
	store i1 0, ptr %retval

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	store i1 0, ptr %retval

	%r58 = load i32, ptr %num2
	%r59 = add i32 %r58, 1

	store i32 %r59, ptr %aux02

	%r60 = load i32, ptr %num1
	%r61 = load i32, ptr %num2
	%r62 = icmp slt i32 %r60, %r61

	br i1 %r62, label %l15, label %l16

l16:
	%r63 = load i32, ptr %num1
	%r64 = load i32, ptr %aux02
	%r65 = icmp slt i32 %r63, %r64

	%r66 = xor i1 1, %r65

	br i1 %r66, label %l18, label %l19

l19:
	store i1 1, ptr %retval

	br label %l20

l18:
	store i1 0, ptr %retval

	br label %l20

l20:
	br label %l17

l15:
	store i1 0, ptr %retval

	br label %l17

l17:
	%r67 = load i1, ptr %retval
	ret i1 %r67
}

define i1@"List.Init"(ptr %this) {
	%r68 = getelementptr i8, ptr %this, i32 24
	store i1 1, ptr %r68

	ret i1 1
}

define i1@"List.InitNew_Element_List_boolean"(ptr %this, ptr %_v_elem, ptr %_v_next, i1 %_v_end) {
	%v_elem = alloca ptr
	store ptr %_v_elem, ptr %v_elem

	%v_next = alloca ptr
	store ptr %_v_next, ptr %v_next

	%v_end = alloca i1
	store i1 %_v_end, ptr %v_end

	%r69 = load i1, ptr %v_end
	%r70 = getelementptr i8, ptr %this, i32 24
	store i1 %r69, ptr %r70

	%r71 = load ptr, ptr %v_elem
	%r72 = getelementptr i8, ptr %this, i32 8
	store ptr %r71, ptr %r72

	%r73 = load ptr, ptr %v_next
	%r74 = getelementptr i8, ptr %this, i32 16
	store ptr %r73, ptr %r74

	ret i1 1
}

define ptr@"List.Insert_Element"(ptr %this, ptr %_new_elem) {
	%new_elem = alloca ptr
	store ptr %_new_elem, ptr %new_elem

	%ret_val = alloca i1
	store i1 0, ptr %ret_val

	%aux03 = alloca ptr
	store ptr null, ptr %aux03

	%aux02 = alloca ptr
	store ptr null, ptr %aux02

	store ptr %this, ptr %aux03

	%r75 = call ptr @calloc(i32 1, i32 25)
	%r76 = getelementptr [10 x ptr], ptr @.List_vtable, i32 0, i32 0
	store ptr %r76, ptr %r75

	store ptr %r75, ptr %aux02

	%r77 = load ptr, ptr %aux02
	%r78 = load ptr, ptr %new_elem
	%r79 = load ptr, ptr %aux03
	%r80 = load ptr, ptr %r77
	%r81 = getelementptr ptr, ptr %r80, i32 1

	%r82 = load ptr, ptr %r81
	%r83 = call i1 %r82(ptr %r77, ptr %r78, ptr  %r79, i1  0)

	store i1 %r83, ptr %ret_val

	%r84 = load ptr, ptr %aux02
	ret ptr %r84
}

define i1@"List.SetNext_List"(ptr %this, ptr %_v_next) {
	%v_next = alloca ptr
	store ptr %_v_next, ptr %v_next

	%r85 = load ptr, ptr %v_next
	%r86 = getelementptr i8, ptr %this, i32 16
	store ptr %r85, ptr %r86

	ret i1 1
}

define ptr@"List.Delete_Element"(ptr %this, ptr %_e) {
	%e = alloca ptr
	store ptr %_e, ptr %e

	%my_head = alloca ptr
	store ptr null, ptr %my_head

	%ret_val = alloca i1
	store i1 0, ptr %ret_val

	%aux05 = alloca i1
	store i1 0, ptr %aux05

	%aux01 = alloca ptr
	store ptr null, ptr %aux01

	%prev = alloca ptr
	store ptr null, ptr %prev

	%var_end = alloca i1
	store i1 0, ptr %var_end

	%var_elem = alloca ptr
	store ptr null, ptr %var_elem

	%aux04 = alloca i32
	store i32 0, ptr %aux04

	%nt = alloca i32
	store i32 0, ptr %nt

	store ptr %this, ptr %my_head

	store i1 0, ptr %ret_val

	%r87 = sub i32 0, 1

	store i32 %r87, ptr %aux04

	store ptr %this, ptr %aux01

	store ptr %this, ptr %prev

	%r88 = getelementptr i8, ptr %this, i32 24
	%r89 = load i1, ptr %r88

	store i1 %r89, ptr %var_end

	%r90 = getelementptr i8, ptr %this, i32 8
	%r91 = load ptr, ptr %r90

	store ptr %r91, ptr %var_elem

	br label %l21
l21:
	%r92 = load i1, ptr %var_end
	%r93 = xor i1 1, %r92

	br i1 %r93, label %l24, label %l25

l25:
	br label %l26

l24:
	%r94 = load i1, ptr %ret_val
	%r95 = xor i1 1, %r94

	br label %l26

l26:
	%r96 = phi i1 [ 0, %l25 ], [ %r95, %l24 ]

	br i1 %r96, label %l22, label %l23

l22:
	%r97 = load ptr, ptr %e
	%r98 = load ptr, ptr %var_elem
	%r99 = load ptr, ptr %r97
	%r100 = getelementptr ptr, ptr %r99, i32 4

	%r101 = load ptr, ptr %r100
	%r102 = call i1 %r101(ptr %r97, ptr %r98)

	br i1 %r102, label %l27, label %l28

l28:
	store i32 0, ptr %nt

	br label %l29

l27:
	store i1 1, ptr %ret_val

	%r103 = load i32, ptr %aux04
	%r104 = icmp slt i32 %r103, 0

	br i1 %r104, label %l30, label %l31

l31:
	%r105 = sub i32 0, 555

	call void @print_int(i32 %r105)

	%r106 = load ptr, ptr %prev
	%r107 = load ptr, ptr %aux01
	%r108 = load ptr, ptr %r107
	%r109 = getelementptr ptr, ptr %r108, i32 8

	%r110 = load ptr, ptr %r109
	%r111 = call ptr %r110(ptr %r107)

	%r112 = load ptr, ptr %r106
	%r113 = getelementptr ptr, ptr %r112, i32 3

	%r114 = load ptr, ptr %r113
	%r115 = call i1 %r114(ptr %r106, ptr %r111)

	store i1 %r115, ptr %aux05

	%r116 = sub i32 0, 555

	call void @print_int(i32 %r116)

	br label %l32

l30:
	%r117 = load ptr, ptr %aux01
	%r118 = load ptr, ptr %r117
	%r119 = getelementptr ptr, ptr %r118, i32 8

	%r120 = load ptr, ptr %r119
	%r121 = call ptr %r120(ptr %r117)

	store ptr %r121, ptr %my_head

	br label %l32

l32:
	br label %l29

l29:
	%r122 = load i1, ptr %ret_val
	%r123 = xor i1 1, %r122

	br i1 %r123, label %l33, label %l34

l34:
	store i32 0, ptr %nt

	br label %l35

l33:
	%r124 = load ptr, ptr %aux01
	store ptr %r124, ptr %prev

	%r125 = load ptr, ptr %aux01
	%r126 = load ptr, ptr %r125
	%r127 = getelementptr ptr, ptr %r126, i32 8

	%r128 = load ptr, ptr %r127
	%r129 = call ptr %r128(ptr %r125)

	store ptr %r129, ptr %aux01

	%r130 = load ptr, ptr %aux01
	%r131 = load ptr, ptr %r130
	%r132 = getelementptr ptr, ptr %r131, i32 6

	%r133 = load ptr, ptr %r132
	%r134 = call i1 %r133(ptr %r130)

	store i1 %r134, ptr %var_end

	%r135 = load ptr, ptr %aux01
	%r136 = load ptr, ptr %r135
	%r137 = getelementptr ptr, ptr %r136, i32 7

	%r138 = load ptr, ptr %r137
	%r139 = call ptr %r138(ptr %r135)

	store ptr %r139, ptr %var_elem

	store i32 1, ptr %aux04

	br label %l35

l35:
	br label %l21

l23:
	%r140 = load ptr, ptr %my_head
	ret ptr %r140
}

define i32@"List.Search_Element"(ptr %this, ptr %_e) {
	%e = alloca ptr
	store ptr %_e, ptr %e

	%int_ret_val = alloca i32
	store i32 0, ptr %int_ret_val

	%aux01 = alloca ptr
	store ptr null, ptr %aux01

	%var_elem = alloca ptr
	store ptr null, ptr %var_elem

	%var_end = alloca i1
	store i1 0, ptr %var_end

	%nt = alloca i32
	store i32 0, ptr %nt

	store i32 0, ptr %int_ret_val

	store ptr %this, ptr %aux01

	%r141 = getelementptr i8, ptr %this, i32 24
	%r142 = load i1, ptr %r141

	store i1 %r142, ptr %var_end

	%r143 = getelementptr i8, ptr %this, i32 8
	%r144 = load ptr, ptr %r143

	store ptr %r144, ptr %var_elem

	br label %l36
l36:
	%r145 = load i1, ptr %var_end
	%r146 = xor i1 1, %r145

	br i1 %r146, label %l37, label %l38

l37:
	%r147 = load ptr, ptr %e
	%r148 = load ptr, ptr %var_elem
	%r149 = load ptr, ptr %r147
	%r150 = getelementptr ptr, ptr %r149, i32 4

	%r151 = load ptr, ptr %r150
	%r152 = call i1 %r151(ptr %r147, ptr %r148)

	br i1 %r152, label %l39, label %l40

l40:
	store i32 0, ptr %nt

	br label %l41

l39:
	store i32 1, ptr %int_ret_val

	br label %l41

l41:
	%r153 = load ptr, ptr %aux01
	%r154 = load ptr, ptr %r153
	%r155 = getelementptr ptr, ptr %r154, i32 8

	%r156 = load ptr, ptr %r155
	%r157 = call ptr %r156(ptr %r153)

	store ptr %r157, ptr %aux01

	%r158 = load ptr, ptr %aux01
	%r159 = load ptr, ptr %r158
	%r160 = getelementptr ptr, ptr %r159, i32 6

	%r161 = load ptr, ptr %r160
	%r162 = call i1 %r161(ptr %r158)

	store i1 %r162, ptr %var_end

	%r163 = load ptr, ptr %aux01
	%r164 = load ptr, ptr %r163
	%r165 = getelementptr ptr, ptr %r164, i32 7

	%r166 = load ptr, ptr %r165
	%r167 = call ptr %r166(ptr %r163)

	store ptr %r167, ptr %var_elem

	br label %l36

l38:
	%r168 = load i32, ptr %int_ret_val
	ret i32 %r168
}

define i1@"List.GetEnd"(ptr %this) {
	%r169 = getelementptr i8, ptr %this, i32 24
	%r170 = load i1, ptr %r169

	ret i1 %r170
}

define ptr@"List.GetElem"(ptr %this) {
	%r171 = getelementptr i8, ptr %this, i32 8
	%r172 = load ptr, ptr %r171

	ret ptr %r172
}

define ptr@"List.GetNext"(ptr %this) {
	%r173 = getelementptr i8, ptr %this, i32 16
	%r174 = load ptr, ptr %r173

	ret ptr %r174
}

define i1@"List.Print"(ptr %this) {
	%aux01 = alloca ptr
	store ptr null, ptr %aux01

	%var_end = alloca i1
	store i1 0, ptr %var_end

	%var_elem = alloca ptr
	store ptr null, ptr %var_elem

	store ptr %this, ptr %aux01

	%r175 = getelementptr i8, ptr %this, i32 24
	%r176 = load i1, ptr %r175

	store i1 %r176, ptr %var_end

	%r177 = getelementptr i8, ptr %this, i32 8
	%r178 = load ptr, ptr %r177

	store ptr %r178, ptr %var_elem

	br label %l42
l42:
	%r179 = load i1, ptr %var_end
	%r180 = xor i1 1, %r179

	br i1 %r180, label %l43, label %l44

l43:
	%r181 = load ptr, ptr %var_elem
	%r182 = load ptr, ptr %r181
	%r183 = getelementptr ptr, ptr %r182, i32 1

	%r184 = load ptr, ptr %r183
	%r185 = call i32 %r184(ptr %r181)

	call void @print_int(i32 %r185)

	%r186 = load ptr, ptr %aux01
	%r187 = load ptr, ptr %r186
	%r188 = getelementptr ptr, ptr %r187, i32 8

	%r189 = load ptr, ptr %r188
	%r190 = call ptr %r189(ptr %r186)

	store ptr %r190, ptr %aux01

	%r191 = load ptr, ptr %aux01
	%r192 = load ptr, ptr %r191
	%r193 = getelementptr ptr, ptr %r192, i32 6

	%r194 = load ptr, ptr %r193
	%r195 = call i1 %r194(ptr %r191)

	store i1 %r195, ptr %var_end

	%r196 = load ptr, ptr %aux01
	%r197 = load ptr, ptr %r196
	%r198 = getelementptr ptr, ptr %r197, i32 7

	%r199 = load ptr, ptr %r198
	%r200 = call ptr %r199(ptr %r196)

	store ptr %r200, ptr %var_elem

	br label %l42

l44:
	ret i1 1
}

define i32@"LL.Start"(ptr %this) {
	%head = alloca ptr
	store ptr null, ptr %head

	%last_elem = alloca ptr
	store ptr null, ptr %last_elem

	%aux01 = alloca i1
	store i1 0, ptr %aux01

	%el01 = alloca ptr
	store ptr null, ptr %el01

	%el02 = alloca ptr
	store ptr null, ptr %el02

	%el03 = alloca ptr
	store ptr null, ptr %el03

	%r201 = call ptr @calloc(i32 1, i32 25)
	%r202 = getelementptr [10 x ptr], ptr @.List_vtable, i32 0, i32 0
	store ptr %r202, ptr %r201

	store ptr %r201, ptr %last_elem

	%r203 = load ptr, ptr %last_elem
	%r204 = load ptr, ptr %r203
	%r205 = getelementptr ptr, ptr %r204, i32 0

	%r206 = load ptr, ptr %r205
	%r207 = call i1 %r206(ptr %r203)

	store i1 %r207, ptr %aux01

	%r208 = load ptr, ptr %last_elem
	store ptr %r208, ptr %head

	%r209 = load ptr, ptr %head
	%r210 = load ptr, ptr %r209
	%r211 = getelementptr ptr, ptr %r210, i32 0

	%r212 = load ptr, ptr %r211
	%r213 = call i1 %r212(ptr %r209)

	store i1 %r213, ptr %aux01

	%r214 = load ptr, ptr %head
	%r215 = load ptr, ptr %r214
	%r216 = getelementptr ptr, ptr %r215, i32 9

	%r217 = load ptr, ptr %r216
	%r218 = call i1 %r217(ptr %r214)

	store i1 %r218, ptr %aux01

	%r219 = call ptr @calloc(i32 1, i32 17)
	%r220 = getelementptr [6 x ptr], ptr @.Element_vtable, i32 0, i32 0
	store ptr %r220, ptr %r219

	store ptr %r219, ptr %el01

	%r221 = load ptr, ptr %el01
	%r222 = load ptr, ptr %r221
	%r223 = getelementptr ptr, ptr %r222, i32 0

	%r224 = load ptr, ptr %r223
	%r225 = call i1 %r224(ptr %r221, i32 25, i32  37000, i1  0)

	store i1 %r225, ptr %aux01

	%r226 = load ptr, ptr %head
	%r227 = load ptr, ptr %el01
	%r228 = load ptr, ptr %r226
	%r229 = getelementptr ptr, ptr %r228, i32 2

	%r230 = load ptr, ptr %r229
	%r231 = call ptr %r230(ptr %r226, ptr %r227)

	store ptr %r231, ptr %head

	%r232 = load ptr, ptr %head
	%r233 = load ptr, ptr %r232
	%r234 = getelementptr ptr, ptr %r233, i32 9

	%r235 = load ptr, ptr %r234
	%r236 = call i1 %r235(ptr %r232)

	store i1 %r236, ptr %aux01

	call void @print_int(i32 10000000)

	%r237 = call ptr @calloc(i32 1, i32 17)
	%r238 = getelementptr [6 x ptr], ptr @.Element_vtable, i32 0, i32 0
	store ptr %r238, ptr %r237

	store ptr %r237, ptr %el01

	%r239 = load ptr, ptr %el01
	%r240 = load ptr, ptr %r239
	%r241 = getelementptr ptr, ptr %r240, i32 0

	%r242 = load ptr, ptr %r241
	%r243 = call i1 %r242(ptr %r239, i32 39, i32  42000, i1  1)

	store i1 %r243, ptr %aux01

	%r244 = load ptr, ptr %el01
	store ptr %r244, ptr %el02

	%r245 = load ptr, ptr %head
	%r246 = load ptr, ptr %el01
	%r247 = load ptr, ptr %r245
	%r248 = getelementptr ptr, ptr %r247, i32 2

	%r249 = load ptr, ptr %r248
	%r250 = call ptr %r249(ptr %r245, ptr %r246)

	store ptr %r250, ptr %head

	%r251 = load ptr, ptr %head
	%r252 = load ptr, ptr %r251
	%r253 = getelementptr ptr, ptr %r252, i32 9

	%r254 = load ptr, ptr %r253
	%r255 = call i1 %r254(ptr %r251)

	store i1 %r255, ptr %aux01

	call void @print_int(i32 10000000)

	%r256 = call ptr @calloc(i32 1, i32 17)
	%r257 = getelementptr [6 x ptr], ptr @.Element_vtable, i32 0, i32 0
	store ptr %r257, ptr %r256

	store ptr %r256, ptr %el01

	%r258 = load ptr, ptr %el01
	%r259 = load ptr, ptr %r258
	%r260 = getelementptr ptr, ptr %r259, i32 0

	%r261 = load ptr, ptr %r260
	%r262 = call i1 %r261(ptr %r258, i32 22, i32  34000, i1  0)

	store i1 %r262, ptr %aux01

	%r263 = load ptr, ptr %head
	%r264 = load ptr, ptr %el01
	%r265 = load ptr, ptr %r263
	%r266 = getelementptr ptr, ptr %r265, i32 2

	%r267 = load ptr, ptr %r266
	%r268 = call ptr %r267(ptr %r263, ptr %r264)

	store ptr %r268, ptr %head

	%r269 = load ptr, ptr %head
	%r270 = load ptr, ptr %r269
	%r271 = getelementptr ptr, ptr %r270, i32 9

	%r272 = load ptr, ptr %r271
	%r273 = call i1 %r272(ptr %r269)

	store i1 %r273, ptr %aux01

	%r274 = call ptr @calloc(i32 1, i32 17)
	%r275 = getelementptr [6 x ptr], ptr @.Element_vtable, i32 0, i32 0
	store ptr %r275, ptr %r274

	store ptr %r274, ptr %el03

	%r276 = load ptr, ptr %el03
	%r277 = load ptr, ptr %r276
	%r278 = getelementptr ptr, ptr %r277, i32 0

	%r279 = load ptr, ptr %r278
	%r280 = call i1 %r279(ptr %r276, i32 27, i32  34000, i1  0)

	store i1 %r280, ptr %aux01

	%r281 = load ptr, ptr %head
	%r282 = load ptr, ptr %el02
	%r283 = load ptr, ptr %r281
	%r284 = getelementptr ptr, ptr %r283, i32 5

	%r285 = load ptr, ptr %r284
	%r286 = call i32 %r285(ptr %r281, ptr %r282)

	call void @print_int(i32 %r286)

	%r287 = load ptr, ptr %head
	%r288 = load ptr, ptr %el03
	%r289 = load ptr, ptr %r287
	%r290 = getelementptr ptr, ptr %r289, i32 5

	%r291 = load ptr, ptr %r290
	%r292 = call i32 %r291(ptr %r287, ptr %r288)

	call void @print_int(i32 %r292)

	call void @print_int(i32 10000000)

	%r293 = call ptr @calloc(i32 1, i32 17)
	%r294 = getelementptr [6 x ptr], ptr @.Element_vtable, i32 0, i32 0
	store ptr %r294, ptr %r293

	store ptr %r293, ptr %el01

	%r295 = load ptr, ptr %el01
	%r296 = load ptr, ptr %r295
	%r297 = getelementptr ptr, ptr %r296, i32 0

	%r298 = load ptr, ptr %r297
	%r299 = call i1 %r298(ptr %r295, i32 28, i32  35000, i1  0)

	store i1 %r299, ptr %aux01

	%r300 = load ptr, ptr %head
	%r301 = load ptr, ptr %el01
	%r302 = load ptr, ptr %r300
	%r303 = getelementptr ptr, ptr %r302, i32 2

	%r304 = load ptr, ptr %r303
	%r305 = call ptr %r304(ptr %r300, ptr %r301)

	store ptr %r305, ptr %head

	%r306 = load ptr, ptr %head
	%r307 = load ptr, ptr %r306
	%r308 = getelementptr ptr, ptr %r307, i32 9

	%r309 = load ptr, ptr %r308
	%r310 = call i1 %r309(ptr %r306)

	store i1 %r310, ptr %aux01

	call void @print_int(i32 2220000)

	%r311 = load ptr, ptr %head
	%r312 = load ptr, ptr %el02
	%r313 = load ptr, ptr %r311
	%r314 = getelementptr ptr, ptr %r313, i32 4

	%r315 = load ptr, ptr %r314
	%r316 = call ptr %r315(ptr %r311, ptr %r312)

	store ptr %r316, ptr %head

	%r317 = load ptr, ptr %head
	%r318 = load ptr, ptr %r317
	%r319 = getelementptr ptr, ptr %r318, i32 9

	%r320 = load ptr, ptr %r319
	%r321 = call i1 %r320(ptr %r317)

	store i1 %r321, ptr %aux01

	call void @print_int(i32 33300000)

	%r322 = load ptr, ptr %head
	%r323 = load ptr, ptr %el01
	%r324 = load ptr, ptr %r322
	%r325 = getelementptr ptr, ptr %r324, i32 4

	%r326 = load ptr, ptr %r325
	%r327 = call ptr %r326(ptr %r322, ptr %r323)

	store ptr %r327, ptr %head

	%r328 = load ptr, ptr %head
	%r329 = load ptr, ptr %r328
	%r330 = getelementptr ptr, ptr %r329, i32 9

	%r331 = load ptr, ptr %r330
	%r332 = call i1 %r331(ptr %r328)

	store i1 %r332, ptr %aux01

	call void @print_int(i32 44440000)

	ret i32 0
}
