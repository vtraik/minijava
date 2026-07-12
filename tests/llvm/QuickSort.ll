@.QuickSort_vtable = global [0 x ptr] []
@.QS_vtable = global [4 x ptr] [ptr @"QS.Start_int", ptr @"QS.Sort_int_int", ptr @"QS.Print", ptr @"QS.Init_int"]

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
	%r1 = getelementptr [4 x ptr], ptr @.QS_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 10)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"QS.Start_int"(ptr %this, i32 %_sz) {
	%sz = alloca i32
	store i32 %_sz, ptr %sz

	%aux01 = alloca i32
	store i32 0, ptr %aux01

	%r6 = load i32, ptr %sz
	%r7 = load ptr, ptr %this
	%r8 = getelementptr ptr, ptr %r7, i32 3

	%r9 = load ptr, ptr %r8
	%r10 = call i32 %r9(ptr %this, i32 %r6)

	store i32 %r10, ptr %aux01

	%r11 = load ptr, ptr %this
	%r12 = getelementptr ptr, ptr %r11, i32 2

	%r13 = load ptr, ptr %r12
	%r14 = call i32 %r13(ptr %this)

	store i32 %r14, ptr %aux01

	call void @print_int(i32 9999)

	%r15 = getelementptr i8, ptr %this, i32 16
	%r16 = load i32, ptr %r15

	%r17 = sub i32 %r16, 1

	store i32 %r17, ptr %aux01

	%r18 = load i32, ptr %aux01
	%r19 = load ptr, ptr %this
	%r20 = getelementptr ptr, ptr %r19, i32 1

	%r21 = load ptr, ptr %r20
	%r22 = call i32 %r21(ptr %this, i32 0, i32  %r18)

	store i32 %r22, ptr %aux01

	%r23 = load ptr, ptr %this
	%r24 = getelementptr ptr, ptr %r23, i32 2

	%r25 = load ptr, ptr %r24
	%r26 = call i32 %r25(ptr %this)

	store i32 %r26, ptr %aux01

	ret i32 0
}

define i32@"QS.Sort_int_int"(ptr %this, i32 %_left, i32 %_right) {
	%left = alloca i32
	store i32 %_left, ptr %left

	%right = alloca i32
	store i32 %_right, ptr %right

	%v = alloca i32
	store i32 0, ptr %v

	%i = alloca i32
	store i32 0, ptr %i

	%j = alloca i32
	store i32 0, ptr %j

	%nt = alloca i32
	store i32 0, ptr %nt

	%t = alloca i32
	store i32 0, ptr %t

	%cont01 = alloca i1
	store i1 0, ptr %cont01

	%cont02 = alloca i1
	store i1 0, ptr %cont02

	%aux03 = alloca i32
	store i32 0, ptr %aux03

	store i32 0, ptr %t

	%r27 = load i32, ptr %left
	%r28 = load i32, ptr %right
	%r29 = icmp slt i32 %r27, %r28

	br i1 %r29, label %l0, label %l1

l1:
	store i32 0, ptr %nt

	br label %l2

l0:
	%r30 = getelementptr i8, ptr %this, i32 8
	%r31 = load ptr, ptr %r30

	%r32 = load i32, ptr %right
	%r33 = load i32, ptr %r31
	%r34 = icmp sge i32 %r33, 1
	br i1 %r34, label %l4, label %l3

l3:
	call void @throw_oob()
	br label %l4

l4:
	%r35 = add i32 1, %r32
	%r36 = getelementptr i32, ptr %r31, i32 %r35
	%r37 = load i32, ptr %r36

	store i32 %r37, ptr %v

	%r38 = load i32, ptr %left
	%r39 = sub i32 %r38, 1

	store i32 %r39, ptr %i

	%r40 = load i32, ptr %right
	store i32 %r40, ptr %j

	store i1 1, ptr %cont01

	br label %l5
l5:
	%r41 = load i1, ptr %cont01
	br i1 %r41, label %l6, label %l7

l6:
	store i1 1, ptr %cont02

	br label %l8
l8:
	%r42 = load i1, ptr %cont02
	br i1 %r42, label %l9, label %l10

l9:
	%r43 = load i32, ptr %i
	%r44 = add i32 %r43, 1

	store i32 %r44, ptr %i

	%r45 = getelementptr i8, ptr %this, i32 8
	%r46 = load ptr, ptr %r45

	%r47 = load i32, ptr %i
	%r48 = load i32, ptr %r46
	%r49 = icmp sge i32 %r48, 1
	br i1 %r49, label %l12, label %l11

l11:
	call void @throw_oob()
	br label %l12

l12:
	%r50 = add i32 1, %r47
	%r51 = getelementptr i32, ptr %r46, i32 %r50
	%r52 = load i32, ptr %r51

	store i32 %r52, ptr %aux03

	%r53 = load i32, ptr %aux03
	%r54 = load i32, ptr %v
	%r55 = icmp slt i32 %r53, %r54

	%r56 = xor i1 1, %r55

	br i1 %r56, label %l13, label %l14

l14:
	store i1 1, ptr %cont02

	br label %l15

l13:
	store i1 0, ptr %cont02

	br label %l15

l15:
	br label %l8

l10:
	store i1 1, ptr %cont02

	br label %l16
l16:
	%r57 = load i1, ptr %cont02
	br i1 %r57, label %l17, label %l18

l17:
	%r58 = load i32, ptr %j
	%r59 = sub i32 %r58, 1

	store i32 %r59, ptr %j

	%r60 = getelementptr i8, ptr %this, i32 8
	%r61 = load ptr, ptr %r60

	%r62 = load i32, ptr %j
	%r63 = load i32, ptr %r61
	%r64 = icmp sge i32 %r63, 1
	br i1 %r64, label %l20, label %l19

l19:
	call void @throw_oob()
	br label %l20

l20:
	%r65 = add i32 1, %r62
	%r66 = getelementptr i32, ptr %r61, i32 %r65
	%r67 = load i32, ptr %r66

	store i32 %r67, ptr %aux03

	%r68 = load i32, ptr %v
	%r69 = load i32, ptr %aux03
	%r70 = icmp slt i32 %r68, %r69

	%r71 = xor i1 1, %r70

	br i1 %r71, label %l21, label %l22

l22:
	store i1 1, ptr %cont02

	br label %l23

l21:
	store i1 0, ptr %cont02

	br label %l23

l23:
	br label %l16

l18:
	%r72 = getelementptr i8, ptr %this, i32 8
	%r73 = load ptr, ptr %r72

	%r74 = load i32, ptr %i
	%r75 = load i32, ptr %r73
	%r76 = icmp sge i32 %r75, 1
	br i1 %r76, label %l25, label %l24

l24:
	call void @throw_oob()
	br label %l25

l25:
	%r77 = add i32 1, %r74
	%r78 = getelementptr i32, ptr %r73, i32 %r77
	%r79 = load i32, ptr %r78

	store i32 %r79, ptr %t

	%r80 = load i32, ptr %i
	%r81 = getelementptr i8, ptr %this, i32 8
	%r82 = load ptr, ptr %r81

	%r83 = load i32, ptr %j
	%r84 = load i32, ptr %r82
	%r85 = icmp sge i32 %r84, 1
	br i1 %r85, label %l27, label %l26

l26:
	call void @throw_oob()
	br label %l27

l27:
	%r86 = add i32 1, %r83
	%r87 = getelementptr i32, ptr %r82, i32 %r86
	%r88 = load i32, ptr %r87

	%r89 = getelementptr i8, ptr %this, i32 8
	%r90 = load ptr, ptr %r89
	%r91 = load i32, ptr %r90

	%r92 = icmp sge i32 %r91, 1
	br i1 %r92, label %l29, label %l28

l28:
	call void @throw_oob()
	br label %l29

l29:
	%r94 = add i32 1, %r80
	%r95 = getelementptr i32, ptr %r90, i32 %r94

	store i32 %r88, ptr %r95

	%r96 = load i32, ptr %j
	%r97 = load i32, ptr %t
	%r98 = getelementptr i8, ptr %this, i32 8
	%r99 = load ptr, ptr %r98
	%r100 = load i32, ptr %r99

	%r101 = icmp sge i32 %r100, 1
	br i1 %r101, label %l31, label %l30

l30:
	call void @throw_oob()
	br label %l31

l31:
	%r103 = add i32 1, %r96
	%r104 = getelementptr i32, ptr %r99, i32 %r103

	store i32 %r97, ptr %r104

	%r105 = load i32, ptr %j
	%r106 = load i32, ptr %i
	%r107 = add i32 %r106, 1

	%r108 = icmp slt i32 %r105, %r107

	br i1 %r108, label %l32, label %l33

l33:
	store i1 1, ptr %cont01

	br label %l34

l32:
	store i1 0, ptr %cont01

	br label %l34

l34:
	br label %l5

l7:
	%r109 = load i32, ptr %j
	%r110 = getelementptr i8, ptr %this, i32 8
	%r111 = load ptr, ptr %r110

	%r112 = load i32, ptr %i
	%r113 = load i32, ptr %r111
	%r114 = icmp sge i32 %r113, 1
	br i1 %r114, label %l36, label %l35

l35:
	call void @throw_oob()
	br label %l36

l36:
	%r115 = add i32 1, %r112
	%r116 = getelementptr i32, ptr %r111, i32 %r115
	%r117 = load i32, ptr %r116

	%r118 = getelementptr i8, ptr %this, i32 8
	%r119 = load ptr, ptr %r118
	%r120 = load i32, ptr %r119

	%r121 = icmp sge i32 %r120, 1
	br i1 %r121, label %l38, label %l37

l37:
	call void @throw_oob()
	br label %l38

l38:
	%r123 = add i32 1, %r109
	%r124 = getelementptr i32, ptr %r119, i32 %r123

	store i32 %r117, ptr %r124

	%r125 = load i32, ptr %i
	%r126 = getelementptr i8, ptr %this, i32 8
	%r127 = load ptr, ptr %r126

	%r128 = load i32, ptr %right
	%r129 = load i32, ptr %r127
	%r130 = icmp sge i32 %r129, 1
	br i1 %r130, label %l40, label %l39

l39:
	call void @throw_oob()
	br label %l40

l40:
	%r131 = add i32 1, %r128
	%r132 = getelementptr i32, ptr %r127, i32 %r131
	%r133 = load i32, ptr %r132

	%r134 = getelementptr i8, ptr %this, i32 8
	%r135 = load ptr, ptr %r134
	%r136 = load i32, ptr %r135

	%r137 = icmp sge i32 %r136, 1
	br i1 %r137, label %l42, label %l41

l41:
	call void @throw_oob()
	br label %l42

l42:
	%r139 = add i32 1, %r125
	%r140 = getelementptr i32, ptr %r135, i32 %r139

	store i32 %r133, ptr %r140

	%r141 = load i32, ptr %right
	%r142 = load i32, ptr %t
	%r143 = getelementptr i8, ptr %this, i32 8
	%r144 = load ptr, ptr %r143
	%r145 = load i32, ptr %r144

	%r146 = icmp sge i32 %r145, 1
	br i1 %r146, label %l44, label %l43

l43:
	call void @throw_oob()
	br label %l44

l44:
	%r148 = add i32 1, %r141
	%r149 = getelementptr i32, ptr %r144, i32 %r148

	store i32 %r142, ptr %r149

	%r150 = load i32, ptr %left
	%r151 = load i32, ptr %i
	%r152 = sub i32 %r151, 1

	%r153 = load ptr, ptr %this
	%r154 = getelementptr ptr, ptr %r153, i32 1

	%r155 = load ptr, ptr %r154
	%r156 = call i32 %r155(ptr %this, i32 %r150, i32  %r152)

	store i32 %r156, ptr %nt

	%r157 = load i32, ptr %i
	%r158 = add i32 %r157, 1

	%r159 = load i32, ptr %right
	%r160 = load ptr, ptr %this
	%r161 = getelementptr ptr, ptr %r160, i32 1

	%r162 = load ptr, ptr %r161
	%r163 = call i32 %r162(ptr %this, i32 %r158, i32  %r159)

	store i32 %r163, ptr %nt

	br label %l2

l2:
	ret i32 0
}

define i32@"QS.Print"(ptr %this) {
	%j = alloca i32
	store i32 0, ptr %j

	store i32 0, ptr %j

	br label %l45
l45:
	%r164 = load i32, ptr %j
	%r165 = getelementptr i8, ptr %this, i32 16
	%r166 = load i32, ptr %r165

	%r167 = icmp slt i32 %r164, %r166

	br i1 %r167, label %l46, label %l47

l46:
	%r168 = getelementptr i8, ptr %this, i32 8
	%r169 = load ptr, ptr %r168

	%r170 = load i32, ptr %j
	%r171 = load i32, ptr %r169
	%r172 = icmp sge i32 %r171, 1
	br i1 %r172, label %l49, label %l48

l48:
	call void @throw_oob()
	br label %l49

l49:
	%r173 = add i32 1, %r170
	%r174 = getelementptr i32, ptr %r169, i32 %r173
	%r175 = load i32, ptr %r174

	call void @print_int(i32 %r175)

	%r176 = load i32, ptr %j
	%r177 = add i32 %r176, 1

	store i32 %r177, ptr %j

	br label %l45

l47:
	ret i32 0
}

define i32@"QS.Init_int"(ptr %this, i32 %_sz) {
	%sz = alloca i32
	store i32 %_sz, ptr %sz

	%r178 = load i32, ptr %sz
	%r179 = getelementptr i8, ptr %this, i32 16
	store i32 %r178, ptr %r179

	%r180 = load i32, ptr %sz
	%r181 = add i32 1, %r180
	%r182 = icmp sge i32 %r181, 1
	br i1 %r182, label %l51, label %l50

l50:
	call void @throw_oob()
	br label %l51

l51:
	%r183 = call ptr @calloc(i32 %r181, i32 4)
	store i32 %r180, ptr %r183

	%r184 = getelementptr i8, ptr %this, i32 8
	store ptr %r183, ptr %r184

	%r185 = getelementptr i8, ptr %this, i32 8
	%r186 = load ptr, ptr %r185
	%r187 = load i32, ptr %r186

	%r188 = icmp sge i32 %r187, 1
	br i1 %r188, label %l53, label %l52

l52:
	call void @throw_oob()
	br label %l53

l53:
	%r190 = add i32 1, 0
	%r191 = getelementptr i32, ptr %r186, i32 %r190

	store i32 20, ptr %r191

	%r192 = getelementptr i8, ptr %this, i32 8
	%r193 = load ptr, ptr %r192
	%r194 = load i32, ptr %r193

	%r195 = icmp sge i32 %r194, 1
	br i1 %r195, label %l55, label %l54

l54:
	call void @throw_oob()
	br label %l55

l55:
	%r197 = add i32 1, 1
	%r198 = getelementptr i32, ptr %r193, i32 %r197

	store i32 7, ptr %r198

	%r199 = getelementptr i8, ptr %this, i32 8
	%r200 = load ptr, ptr %r199
	%r201 = load i32, ptr %r200

	%r202 = icmp sge i32 %r201, 1
	br i1 %r202, label %l57, label %l56

l56:
	call void @throw_oob()
	br label %l57

l57:
	%r204 = add i32 1, 2
	%r205 = getelementptr i32, ptr %r200, i32 %r204

	store i32 12, ptr %r205

	%r206 = getelementptr i8, ptr %this, i32 8
	%r207 = load ptr, ptr %r206
	%r208 = load i32, ptr %r207

	%r209 = icmp sge i32 %r208, 1
	br i1 %r209, label %l59, label %l58

l58:
	call void @throw_oob()
	br label %l59

l59:
	%r211 = add i32 1, 3
	%r212 = getelementptr i32, ptr %r207, i32 %r211

	store i32 18, ptr %r212

	%r213 = getelementptr i8, ptr %this, i32 8
	%r214 = load ptr, ptr %r213
	%r215 = load i32, ptr %r214

	%r216 = icmp sge i32 %r215, 1
	br i1 %r216, label %l61, label %l60

l60:
	call void @throw_oob()
	br label %l61

l61:
	%r218 = add i32 1, 4
	%r219 = getelementptr i32, ptr %r214, i32 %r218

	store i32 2, ptr %r219

	%r220 = getelementptr i8, ptr %this, i32 8
	%r221 = load ptr, ptr %r220
	%r222 = load i32, ptr %r221

	%r223 = icmp sge i32 %r222, 1
	br i1 %r223, label %l63, label %l62

l62:
	call void @throw_oob()
	br label %l63

l63:
	%r225 = add i32 1, 5
	%r226 = getelementptr i32, ptr %r221, i32 %r225

	store i32 11, ptr %r226

	%r227 = getelementptr i8, ptr %this, i32 8
	%r228 = load ptr, ptr %r227
	%r229 = load i32, ptr %r228

	%r230 = icmp sge i32 %r229, 1
	br i1 %r230, label %l65, label %l64

l64:
	call void @throw_oob()
	br label %l65

l65:
	%r232 = add i32 1, 6
	%r233 = getelementptr i32, ptr %r228, i32 %r232

	store i32 6, ptr %r233

	%r234 = getelementptr i8, ptr %this, i32 8
	%r235 = load ptr, ptr %r234
	%r236 = load i32, ptr %r235

	%r237 = icmp sge i32 %r236, 1
	br i1 %r237, label %l67, label %l66

l66:
	call void @throw_oob()
	br label %l67

l67:
	%r239 = add i32 1, 7
	%r240 = getelementptr i32, ptr %r235, i32 %r239

	store i32 9, ptr %r240

	%r241 = getelementptr i8, ptr %this, i32 8
	%r242 = load ptr, ptr %r241
	%r243 = load i32, ptr %r242

	%r244 = icmp sge i32 %r243, 1
	br i1 %r244, label %l69, label %l68

l68:
	call void @throw_oob()
	br label %l69

l69:
	%r246 = add i32 1, 8
	%r247 = getelementptr i32, ptr %r242, i32 %r246

	store i32 19, ptr %r247

	%r248 = getelementptr i8, ptr %this, i32 8
	%r249 = load ptr, ptr %r248
	%r250 = load i32, ptr %r249

	%r251 = icmp sge i32 %r250, 1
	br i1 %r251, label %l71, label %l70

l70:
	call void @throw_oob()
	br label %l71

l71:
	%r253 = add i32 1, 9
	%r254 = getelementptr i32, ptr %r249, i32 %r253

	store i32 5, ptr %r254

	ret i32 0
}
