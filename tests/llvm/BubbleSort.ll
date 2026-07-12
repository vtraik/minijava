@.BubbleSort_vtable = global [0 x ptr] []
@.BBS_vtable = global [4 x ptr] [ptr @"BBS.Start_int", ptr @"BBS.Sort", ptr @"BBS.Print", ptr @"BBS.Init_int"]

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
	%r1 = getelementptr [4 x ptr], ptr @.BBS_vtable, i32 0, i32 0
	store ptr %r1, ptr %r0

	%r2 = load ptr, ptr %r0
	%r3 = getelementptr ptr, ptr %r2, i32 0

	%r4 = load ptr, ptr %r3
	%r5 = call i32 %r4(ptr %r0, i32 10)

	call void @print_int(i32 %r5)

	ret i32 0
}

define i32@"BBS.Start_int"(ptr %this, i32 %_sz) {
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

	call void @print_int(i32 99999)

	%r15 = load ptr, ptr %this
	%r16 = getelementptr ptr, ptr %r15, i32 1

	%r17 = load ptr, ptr %r16
	%r18 = call i32 %r17(ptr %this)

	store i32 %r18, ptr %aux01

	%r19 = load ptr, ptr %this
	%r20 = getelementptr ptr, ptr %r19, i32 2

	%r21 = load ptr, ptr %r20
	%r22 = call i32 %r21(ptr %this)

	store i32 %r22, ptr %aux01

	ret i32 0
}

define i32@"BBS.Sort"(ptr %this) {
	%nt = alloca i32
	store i32 0, ptr %nt

	%i = alloca i32
	store i32 0, ptr %i

	%aux02 = alloca i32
	store i32 0, ptr %aux02

	%aux04 = alloca i32
	store i32 0, ptr %aux04

	%aux05 = alloca i32
	store i32 0, ptr %aux05

	%aux06 = alloca i32
	store i32 0, ptr %aux06

	%aux07 = alloca i32
	store i32 0, ptr %aux07

	%j = alloca i32
	store i32 0, ptr %j

	%t = alloca i32
	store i32 0, ptr %t

	%r23 = getelementptr i8, ptr %this, i32 16
	%r24 = load i32, ptr %r23

	%r25 = sub i32 %r24, 1

	store i32 %r25, ptr %i

	%r26 = sub i32 0, 1

	store i32 %r26, ptr %aux02

	br label %l0
l0:
	%r27 = load i32, ptr %aux02
	%r28 = load i32, ptr %i
	%r29 = icmp slt i32 %r27, %r28

	br i1 %r29, label %l1, label %l2

l1:
	store i32 1, ptr %j

	br label %l3
l3:
	%r30 = load i32, ptr %j
	%r31 = load i32, ptr %i
	%r32 = add i32 %r31, 1

	%r33 = icmp slt i32 %r30, %r32

	br i1 %r33, label %l4, label %l5

l4:
	%r34 = load i32, ptr %j
	%r35 = sub i32 %r34, 1

	store i32 %r35, ptr %aux07

	%r36 = getelementptr i8, ptr %this, i32 8
	%r37 = load ptr, ptr %r36

	%r38 = load i32, ptr %aux07
	%r39 = load i32, ptr %r37
	%r40 = icmp sge i32 %r39, 1
	br i1 %r40, label %l7, label %l6

l6:
	call void @throw_oob()
	br label %l7

l7:
	%r41 = add i32 1, %r38
	%r42 = getelementptr i32, ptr %r37, i32 %r41
	%r43 = load i32, ptr %r42

	store i32 %r43, ptr %aux04

	%r44 = getelementptr i8, ptr %this, i32 8
	%r45 = load ptr, ptr %r44

	%r46 = load i32, ptr %j
	%r47 = load i32, ptr %r45
	%r48 = icmp sge i32 %r47, 1
	br i1 %r48, label %l9, label %l8

l8:
	call void @throw_oob()
	br label %l9

l9:
	%r49 = add i32 1, %r46
	%r50 = getelementptr i32, ptr %r45, i32 %r49
	%r51 = load i32, ptr %r50

	store i32 %r51, ptr %aux05

	%r52 = load i32, ptr %aux05
	%r53 = load i32, ptr %aux04
	%r54 = icmp slt i32 %r52, %r53

	br i1 %r54, label %l10, label %l11

l11:
	store i32 0, ptr %nt

	br label %l12

l10:
	%r55 = load i32, ptr %j
	%r56 = sub i32 %r55, 1

	store i32 %r56, ptr %aux06

	%r57 = getelementptr i8, ptr %this, i32 8
	%r58 = load ptr, ptr %r57

	%r59 = load i32, ptr %aux06
	%r60 = load i32, ptr %r58
	%r61 = icmp sge i32 %r60, 1
	br i1 %r61, label %l14, label %l13

l13:
	call void @throw_oob()
	br label %l14

l14:
	%r62 = add i32 1, %r59
	%r63 = getelementptr i32, ptr %r58, i32 %r62
	%r64 = load i32, ptr %r63

	store i32 %r64, ptr %t

	%r65 = load i32, ptr %aux06
	%r66 = getelementptr i8, ptr %this, i32 8
	%r67 = load ptr, ptr %r66

	%r68 = load i32, ptr %j
	%r69 = load i32, ptr %r67
	%r70 = icmp sge i32 %r69, 1
	br i1 %r70, label %l16, label %l15

l15:
	call void @throw_oob()
	br label %l16

l16:
	%r71 = add i32 1, %r68
	%r72 = getelementptr i32, ptr %r67, i32 %r71
	%r73 = load i32, ptr %r72

	%r74 = getelementptr i8, ptr %this, i32 8
	%r75 = load ptr, ptr %r74
	%r76 = load i32, ptr %r75

	%r77 = icmp sge i32 %r76, 1
	br i1 %r77, label %l18, label %l17

l17:
	call void @throw_oob()
	br label %l18

l18:
	%r79 = add i32 1, %r65
	%r80 = getelementptr i32, ptr %r75, i32 %r79

	store i32 %r73, ptr %r80

	%r81 = load i32, ptr %j
	%r82 = load i32, ptr %t
	%r83 = getelementptr i8, ptr %this, i32 8
	%r84 = load ptr, ptr %r83
	%r85 = load i32, ptr %r84

	%r86 = icmp sge i32 %r85, 1
	br i1 %r86, label %l20, label %l19

l19:
	call void @throw_oob()
	br label %l20

l20:
	%r88 = add i32 1, %r81
	%r89 = getelementptr i32, ptr %r84, i32 %r88

	store i32 %r82, ptr %r89

	br label %l12

l12:
	%r90 = load i32, ptr %j
	%r91 = add i32 %r90, 1

	store i32 %r91, ptr %j

	br label %l3

l5:
	%r92 = load i32, ptr %i
	%r93 = sub i32 %r92, 1

	store i32 %r93, ptr %i

	br label %l0

l2:
	ret i32 0
}

define i32@"BBS.Print"(ptr %this) {
	%j = alloca i32
	store i32 0, ptr %j

	store i32 0, ptr %j

	br label %l21
l21:
	%r94 = load i32, ptr %j
	%r95 = getelementptr i8, ptr %this, i32 16
	%r96 = load i32, ptr %r95

	%r97 = icmp slt i32 %r94, %r96

	br i1 %r97, label %l22, label %l23

l22:
	%r98 = getelementptr i8, ptr %this, i32 8
	%r99 = load ptr, ptr %r98

	%r100 = load i32, ptr %j
	%r101 = load i32, ptr %r99
	%r102 = icmp sge i32 %r101, 1
	br i1 %r102, label %l25, label %l24

l24:
	call void @throw_oob()
	br label %l25

l25:
	%r103 = add i32 1, %r100
	%r104 = getelementptr i32, ptr %r99, i32 %r103
	%r105 = load i32, ptr %r104

	call void @print_int(i32 %r105)

	%r106 = load i32, ptr %j
	%r107 = add i32 %r106, 1

	store i32 %r107, ptr %j

	br label %l21

l23:
	ret i32 0
}

define i32@"BBS.Init_int"(ptr %this, i32 %_sz) {
	%sz = alloca i32
	store i32 %_sz, ptr %sz

	%r108 = load i32, ptr %sz
	%r109 = getelementptr i8, ptr %this, i32 16
	store i32 %r108, ptr %r109

	%r110 = load i32, ptr %sz
	%r111 = add i32 1, %r110
	%r112 = icmp sge i32 %r111, 1
	br i1 %r112, label %l27, label %l26

l26:
	call void @throw_oob()
	br label %l27

l27:
	%r113 = call ptr @calloc(i32 %r111, i32 4)
	store i32 %r110, ptr %r113

	%r114 = getelementptr i8, ptr %this, i32 8
	store ptr %r113, ptr %r114

	%r115 = getelementptr i8, ptr %this, i32 8
	%r116 = load ptr, ptr %r115
	%r117 = load i32, ptr %r116

	%r118 = icmp sge i32 %r117, 1
	br i1 %r118, label %l29, label %l28

l28:
	call void @throw_oob()
	br label %l29

l29:
	%r120 = add i32 1, 0
	%r121 = getelementptr i32, ptr %r116, i32 %r120

	store i32 20, ptr %r121

	%r122 = getelementptr i8, ptr %this, i32 8
	%r123 = load ptr, ptr %r122
	%r124 = load i32, ptr %r123

	%r125 = icmp sge i32 %r124, 1
	br i1 %r125, label %l31, label %l30

l30:
	call void @throw_oob()
	br label %l31

l31:
	%r127 = add i32 1, 1
	%r128 = getelementptr i32, ptr %r123, i32 %r127

	store i32 7, ptr %r128

	%r129 = getelementptr i8, ptr %this, i32 8
	%r130 = load ptr, ptr %r129
	%r131 = load i32, ptr %r130

	%r132 = icmp sge i32 %r131, 1
	br i1 %r132, label %l33, label %l32

l32:
	call void @throw_oob()
	br label %l33

l33:
	%r134 = add i32 1, 2
	%r135 = getelementptr i32, ptr %r130, i32 %r134

	store i32 12, ptr %r135

	%r136 = getelementptr i8, ptr %this, i32 8
	%r137 = load ptr, ptr %r136
	%r138 = load i32, ptr %r137

	%r139 = icmp sge i32 %r138, 1
	br i1 %r139, label %l35, label %l34

l34:
	call void @throw_oob()
	br label %l35

l35:
	%r141 = add i32 1, 3
	%r142 = getelementptr i32, ptr %r137, i32 %r141

	store i32 18, ptr %r142

	%r143 = getelementptr i8, ptr %this, i32 8
	%r144 = load ptr, ptr %r143
	%r145 = load i32, ptr %r144

	%r146 = icmp sge i32 %r145, 1
	br i1 %r146, label %l37, label %l36

l36:
	call void @throw_oob()
	br label %l37

l37:
	%r148 = add i32 1, 4
	%r149 = getelementptr i32, ptr %r144, i32 %r148

	store i32 2, ptr %r149

	%r150 = getelementptr i8, ptr %this, i32 8
	%r151 = load ptr, ptr %r150
	%r152 = load i32, ptr %r151

	%r153 = icmp sge i32 %r152, 1
	br i1 %r153, label %l39, label %l38

l38:
	call void @throw_oob()
	br label %l39

l39:
	%r155 = add i32 1, 5
	%r156 = getelementptr i32, ptr %r151, i32 %r155

	store i32 11, ptr %r156

	%r157 = getelementptr i8, ptr %this, i32 8
	%r158 = load ptr, ptr %r157
	%r159 = load i32, ptr %r158

	%r160 = icmp sge i32 %r159, 1
	br i1 %r160, label %l41, label %l40

l40:
	call void @throw_oob()
	br label %l41

l41:
	%r162 = add i32 1, 6
	%r163 = getelementptr i32, ptr %r158, i32 %r162

	store i32 6, ptr %r163

	%r164 = getelementptr i8, ptr %this, i32 8
	%r165 = load ptr, ptr %r164
	%r166 = load i32, ptr %r165

	%r167 = icmp sge i32 %r166, 1
	br i1 %r167, label %l43, label %l42

l42:
	call void @throw_oob()
	br label %l43

l43:
	%r169 = add i32 1, 7
	%r170 = getelementptr i32, ptr %r165, i32 %r169

	store i32 9, ptr %r170

	%r171 = getelementptr i8, ptr %this, i32 8
	%r172 = load ptr, ptr %r171
	%r173 = load i32, ptr %r172

	%r174 = icmp sge i32 %r173, 1
	br i1 %r174, label %l45, label %l44

l44:
	call void @throw_oob()
	br label %l45

l45:
	%r176 = add i32 1, 8
	%r177 = getelementptr i32, ptr %r172, i32 %r176

	store i32 19, ptr %r177

	%r178 = getelementptr i8, ptr %this, i32 8
	%r179 = load ptr, ptr %r178
	%r180 = load i32, ptr %r179

	%r181 = icmp sge i32 %r180, 1
	br i1 %r181, label %l47, label %l46

l46:
	call void @throw_oob()
	br label %l47

l47:
	%r183 = add i32 1, 9
	%r184 = getelementptr i32, ptr %r179, i32 %r183

	store i32 5, ptr %r184

	ret i32 0
}
