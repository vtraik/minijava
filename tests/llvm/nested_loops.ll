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
	%i = alloca i32
	store i32 0, ptr %i

	%j = alloca i32
	store i32 0, ptr %j

	%z = alloca i32
	store i32 0, ptr %z

	%x = alloca i32
	store i32 0, ptr %x

	%sum = alloca i32
	store i32 0, ptr %sum

	%flag = alloca i1
	store i1 0, ptr %flag

	store i32 0, ptr %sum

	store i32 0, ptr %i

	br label %l0
l0:
	%r0 = load i32, ptr %i
	%r1 = icmp slt i32 %r0, 6

	br i1 %r1, label %l1, label %l2

l1:
	store i32 0, ptr %j

	br label %l3
l3:
	%r2 = load i32, ptr %j
	%r3 = icmp slt i32 %r2, 5

	br i1 %r3, label %l4, label %l5

l4:
	store i32 0, ptr %z

	br label %l6
l6:
	%r4 = load i32, ptr %z
	%r5 = icmp slt i32 %r4, 4

	br i1 %r5, label %l7, label %l8

l7:
	store i32 0, ptr %x

	br label %l9
l9:
	%r6 = load i32, ptr %x
	%r7 = icmp slt i32 %r6, 4

	br i1 %r7, label %l10, label %l11

l10:
	%r8 = load i32, ptr %sum
	%r9 = load i32, ptr %i
	%r10 = load i32, ptr %j
	%r11 = add i32 %r9, %r10

	%r12 = load i32, ptr %z
	%r13 = add i32 %r11, %r12

	%r14 = load i32, ptr %x
	%r15 = add i32 %r13, %r14

	%r16 = add i32 %r8, %r15

	store i32 %r16, ptr %sum

	%r17 = load i32, ptr %x
	%r18 = add i32 %r17, 1

	store i32 %r18, ptr %x

	br label %l9

l11:
	%r19 = load i32, ptr %z
	%r20 = add i32 %r19, 1

	store i32 %r20, ptr %z

	br label %l6

l8:
	%r21 = load i32, ptr %j
	%r22 = add i32 %r21, 1

	store i32 %r22, ptr %j

	br label %l3

l5:
	%r23 = load i32, ptr %i
	%r24 = add i32 %r23, 1

	store i32 %r24, ptr %i

	br label %l0

l2:
	%r25 = load i32, ptr %sum
	call void @print_int(i32 %r25)

	store i32 0, ptr %sum

	store i32 0, ptr %i

	store i1 1, ptr %flag

	br label %l12
l12:
	%r26 = load i32, ptr %i
	%r27 = icmp slt i32 %r26, 6

	br i1 %r27, label %l13, label %l14

l13:
	store i32 0, ptr %j

	%r28 = load i1, ptr %flag
	br i1 %r28, label %l15, label %l16

l16:
	br label %l18
l18:
	%r29 = load i32, ptr %j
	%r30 = icmp slt i32 %r29, 4

	br i1 %r30, label %l19, label %l20

l19:
	store i32 0, ptr %z

	br label %l21
l21:
	%r31 = load i32, ptr %z
	%r32 = icmp slt i32 %r31, 10

	br i1 %r32, label %l22, label %l23

l22:
	store i32 0, ptr %x

	br label %l24
l24:
	%r33 = load i32, ptr %x
	%r34 = icmp slt i32 %r33, 4

	br i1 %r34, label %l25, label %l26

l25:
	%r35 = load i32, ptr %sum
	%r36 = load i32, ptr %i
	%r37 = load i32, ptr %j
	%r38 = mul i32 %r36, %r37

	%r39 = load i32, ptr %z
	%r40 = add i32 %r38, %r39

	%r41 = load i32, ptr %x
	%r42 = add i32 %r40, %r41

	%r43 = add i32 %r35, %r42

	store i32 %r43, ptr %sum

	%r44 = load i32, ptr %x
	%r45 = add i32 %r44, 1

	store i32 %r45, ptr %x

	br label %l24

l26:
	%r46 = load i32, ptr %z
	%r47 = add i32 %r46, 1

	store i32 %r47, ptr %z

	br label %l21

l23:
	%r48 = load i32, ptr %j
	%r49 = add i32 %r48, 1

	store i32 %r49, ptr %j

	br label %l18

l20:
	store i1 0, ptr %flag

	br label %l17

l15:
	br label %l27
l27:
	%r50 = load i32, ptr %j
	%r51 = icmp slt i32 %r50, 5

	br i1 %r51, label %l28, label %l29

l28:
	store i32 0, ptr %z

	br label %l30
l30:
	%r52 = load i32, ptr %z
	%r53 = icmp slt i32 %r52, 4

	br i1 %r53, label %l31, label %l32

l31:
	store i32 0, ptr %x

	br label %l33
l33:
	%r54 = load i32, ptr %x
	%r55 = icmp slt i32 %r54, 4

	br i1 %r55, label %l34, label %l35

l34:
	%r56 = load i32, ptr %sum
	%r57 = load i32, ptr %i
	%r58 = load i32, ptr %j
	%r59 = add i32 %r57, %r58

	%r60 = load i32, ptr %z
	%r61 = add i32 %r59, %r60

	%r62 = load i32, ptr %x
	%r63 = add i32 %r61, %r62

	%r64 = add i32 %r56, %r63

	store i32 %r64, ptr %sum

	%r65 = load i32, ptr %x
	%r66 = add i32 %r65, 1

	store i32 %r66, ptr %x

	br label %l33

l35:
	%r67 = load i32, ptr %z
	%r68 = add i32 %r67, 1

	store i32 %r68, ptr %z

	br label %l30

l32:
	%r69 = load i32, ptr %j
	%r70 = add i32 %r69, 1

	store i32 %r70, ptr %j

	br label %l27

l29:
	store i1 0, ptr %flag

	br label %l17

l17:
	%r71 = load i32, ptr %i
	%r72 = add i32 %r71, 1

	store i32 %r72, ptr %i

	br label %l12

l14:
	%r73 = load i32, ptr %sum
	call void @print_int(i32 %r73)

	ret i32 0
}
