@.Main_vtable = global [0 x ptr] []

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
	%flag = alloca i1
	store i1 0, ptr %flag

	br i1 1, label %l0, label %l1

l1:
	call void @print_int(i32 0)

	br label %l2

l0:
	br i1 1, label %l3, label %l4

l4:
	call void @print_int(i32 0)

	br label %l5

l3:
	br i1 1, label %l6, label %l7

l7:
	call void @print_int(i32 0)

	br label %l8

l6:
	br i1 1, label %l9, label %l10

l10:
	call void @print_int(i32 0)

	br label %l11

l9:
	br i1 1, label %l12, label %l13

l13:
	call void @print_int(i32 0)

	br label %l14

l12:
	call void @print_int(i32 1)

	br label %l14

l14:
	call void @print_int(i32 2)

	br label %l11

l11:
	call void @print_int(i32 3)

	br label %l8

l8:
	call void @print_int(i32 4)

	br label %l5

l5:
	call void @print_int(i32 5)

	br label %l2

l2:
	br i1 1, label %l15, label %l16

l16:
	br label %l17

l15:
	br label %l17

l17:
	%r0 = phi i1 [ 0, %l16 ], [ 1, %l15 ]

	br i1 %r0, label %l18, label %l19

l19:
	br label %l20

l18:
	%r1 = xor i1 1, 0

	br i1 %r1, label %l21, label %l22

l22:
	br label %l23

l21:
	%r2 = xor i1 1, 0

	br label %l23

l23:
	%r3 = phi i1 [ 0, %l22 ], [ %r2, %l21 ]

	br label %l20

l20:
	%r4 = phi i1 [ 0, %l19 ], [ %r3, %l23 ]

	br i1 %r4, label %l24, label %l25

l25:
	br label %l26

l24:
	%r5 = icmp slt i32 100, 1000

	br label %l26

l26:
	%r6 = phi i1 [ 0, %l25 ], [ %r5, %l24 ]

	store i1 %r6, ptr %flag

	br i1 1, label %l27, label %l28

l28:
	br label %l29

l27:
	%r7 = load i1, ptr %flag
	br label %l29

l29:
	%r8 = phi i1 [ 0, %l28 ], [ %r7, %l27 ]

	br i1 %r8, label %l30, label %l31

l31:
	br label %l32

l30:
	%r9 = xor i1 1, 0

	br i1 %r9, label %l33, label %l34

l34:
	br label %l35

l33:
	%r10 = xor i1 1, 0

	br label %l35

l35:
	%r11 = phi i1 [ 0, %l34 ], [ %r10, %l33 ]

	br label %l32

l32:
	%r12 = phi i1 [ 0, %l31 ], [ %r11, %l35 ]

	br i1 %r12, label %l36, label %l37

l37:
	call void @print_int(i32 0)

	br label %l38

l36:
	br i1 1, label %l39, label %l40

l40:
	br label %l41

l39:
	%r13 = load i1, ptr %flag
	br label %l41

l41:
	%r14 = phi i1 [ 0, %l40 ], [ %r13, %l39 ]

	br i1 %r14, label %l42, label %l43

l43:
	br label %l44

l42:
	%r15 = xor i1 1, 0

	br i1 %r15, label %l45, label %l46

l46:
	br label %l47

l45:
	%r16 = xor i1 1, 0

	br label %l47

l47:
	%r17 = phi i1 [ 0, %l46 ], [ %r16, %l45 ]

	br label %l44

l44:
	%r18 = phi i1 [ 0, %l43 ], [ %r17, %l47 ]

	br i1 %r18, label %l48, label %l49

l49:
	call void @print_int(i32 0)

	br label %l50

l48:
	br i1 1, label %l51, label %l52

l52:
	br label %l53

l51:
	%r19 = load i1, ptr %flag
	br label %l53

l53:
	%r20 = phi i1 [ 0, %l52 ], [ %r19, %l51 ]

	br i1 %r20, label %l54, label %l55

l55:
	br label %l56

l54:
	%r21 = xor i1 1, 0

	br i1 %r21, label %l57, label %l58

l58:
	br label %l59

l57:
	%r22 = xor i1 1, 0

	br label %l59

l59:
	%r23 = phi i1 [ 0, %l58 ], [ %r22, %l57 ]

	br label %l56

l56:
	%r24 = phi i1 [ 0, %l55 ], [ %r23, %l59 ]

	br i1 %r24, label %l60, label %l61

l61:
	call void @print_int(i32 0)

	br label %l62

l60:
	br i1 1, label %l63, label %l64

l64:
	br label %l65

l63:
	%r25 = load i1, ptr %flag
	br label %l65

l65:
	%r26 = phi i1 [ 0, %l64 ], [ %r25, %l63 ]

	br i1 %r26, label %l66, label %l67

l67:
	br label %l68

l66:
	%r27 = xor i1 1, 0

	br i1 %r27, label %l69, label %l70

l70:
	br label %l71

l69:
	%r28 = xor i1 1, 0

	br label %l71

l71:
	%r29 = phi i1 [ 0, %l70 ], [ %r28, %l69 ]

	br label %l68

l68:
	%r30 = phi i1 [ 0, %l67 ], [ %r29, %l71 ]

	br i1 %r30, label %l72, label %l73

l73:
	call void @print_int(i32 0)

	br label %l74

l72:
	%r31 = load i1, ptr %flag
	br i1 %r31, label %l75, label %l76

l76:
	br label %l77

l75:
	%r32 = load i1, ptr %flag
	br label %l77

l77:
	%r33 = phi i1 [ 0, %l76 ], [ %r32, %l75 ]

	br i1 %r33, label %l78, label %l79

l79:
	br label %l80

l78:
	%r34 = xor i1 1, 0

	br i1 %r34, label %l81, label %l82

l82:
	br label %l83

l81:
	%r35 = xor i1 1, 0

	br label %l83

l83:
	%r36 = phi i1 [ 0, %l82 ], [ %r35, %l81 ]

	br label %l80

l80:
	%r37 = phi i1 [ 0, %l79 ], [ %r36, %l83 ]

	br i1 %r37, label %l84, label %l85

l85:
	call void @print_int(i32 0)

	br label %l86

l84:
	call void @print_int(i32 1)

	br label %l86

l86:
	call void @print_int(i32 2)

	br label %l74

l74:
	call void @print_int(i32 3)

	br label %l62

l62:
	call void @print_int(i32 4)

	br label %l50

l50:
	call void @print_int(i32 5)

	br label %l38

l38:
	ret i32 0
}
