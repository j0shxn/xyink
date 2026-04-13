	.file	"xycal.c"
	.text
.Ltext0:
	.file 0 "/home/bcskn/reps/XY" "xycal.c"
	.globl	z
	.section	.rodata
	.align 8
	.type	z, @object
	.size	z, 12
z:
	.long	0
	.long	0
	.long	1065353216
	.text
	.globl	dotp
	.type	dotp, @function
dotp:
.LFB6:
	.file 1 "xycal.c"
	.loc 1 18 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	.loc 1 20 12
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)
.LBB2:
	.loc 1 22 14
	movl	$0, -12(%rbp)
	.loc 1 22 5
	jmp	.L2
.L3:
	.loc 1 24 22 discriminator 3
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	.loc 1 24 27 discriminator 3
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	.loc 1 24 25 discriminator 3
	mulsd	%xmm1, %xmm0
	.loc 1 24 13 discriminator 3
	movsd	-8(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	.loc 1 22 31 discriminator 3
	addl	$1, -12(%rbp)
.L2:
	.loc 1 22 24 discriminator 1
	cmpl	$2, -12(%rbp)
	jle	.L3
.LBE2:
	.loc 1 26 12
	movsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	.loc 1 27 1
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	dotp, .-dotp
	.globl	crossp
	.type	crossp, @function
crossp:
.LFB7:
	.loc 1 31 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%rdx, -136(%rbp)
	.loc 1 31 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 41 12
	movl	$0, -100(%rbp)
	.loc 1 41 5
	jmp	.L6
.L7:
	.loc 1 45 21 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-120(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 45 16 discriminator 3
	movsd	(%rax), %xmm0
	.loc 1 45 14 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	movsd	%xmm0, -96(%rbp,%rax,8)
	.loc 1 46 21 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 46 16 discriminator 3
	movsd	(%rax), %xmm0
	.loc 1 46 14 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	movsd	%xmm0, -64(%rbp,%rax,8)
	.loc 1 41 27 discriminator 3
	addl	$1, -100(%rbp)
.L6:
	.loc 1 41 20 discriminator 1
	cmpl	$2, -100(%rbp)
	jle	.L7
	.loc 1 50 13
	movsd	-88(%rbp), %xmm1
	.loc 1 50 18
	movsd	-48(%rbp), %xmm0
	.loc 1 50 16
	mulsd	%xmm1, %xmm0
	.loc 1 50 25
	movsd	-80(%rbp), %xmm2
	.loc 1 50 30
	movsd	-56(%rbp), %xmm1
	.loc 1 50 28
	mulsd	%xmm2, %xmm1
	.loc 1 50 22
	subsd	%xmm1, %xmm0
	.loc 1 50 10
	movsd	%xmm0, -32(%rbp)
	.loc 1 51 13
	movsd	-80(%rbp), %xmm1
	.loc 1 51 18
	movsd	-64(%rbp), %xmm0
	.loc 1 51 16
	mulsd	%xmm1, %xmm0
	.loc 1 51 25
	movsd	-96(%rbp), %xmm2
	.loc 1 51 30
	movsd	-48(%rbp), %xmm1
	.loc 1 51 28
	mulsd	%xmm2, %xmm1
	.loc 1 51 22
	subsd	%xmm1, %xmm0
	.loc 1 51 10
	movsd	%xmm0, -24(%rbp)
	.loc 1 52 13
	movsd	-96(%rbp), %xmm1
	.loc 1 52 18
	movsd	-56(%rbp), %xmm0
	.loc 1 52 16
	mulsd	%xmm1, %xmm0
	.loc 1 52 25
	movsd	-88(%rbp), %xmm2
	.loc 1 52 30
	movsd	-64(%rbp), %xmm1
	.loc 1 52 28
	mulsd	%xmm2, %xmm1
	.loc 1 52 22
	subsd	%xmm1, %xmm0
	.loc 1 52 10
	movsd	%xmm0, -16(%rbp)
	.loc 1 56 12
	movl	$0, -100(%rbp)
	.loc 1 56 5
	jmp	.L8
.L9:
	.loc 1 58 14 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-136(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 58 22 discriminator 3
	movl	-100(%rbp), %eax
	cltq
	movsd	-32(%rbp,%rax,8), %xmm0
	.loc 1 58 19 discriminator 3
	movsd	%xmm0, (%rdx)
	.loc 1 56 27 discriminator 3
	addl	$1, -100(%rbp)
.L8:
	.loc 1 56 20 discriminator 1
	cmpl	$2, -100(%rbp)
	jle	.L9
	.loc 1 60 1
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	crossp, .-crossp
	.globl	sp2ca
	.type	sp2ca, @function
sp2ca:
.LFB8:
	.loc 1 63 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movsd	%xmm0, -56(%rbp)
	movsd	%xmm1, -64(%rbp)
	movq	%rdi, -72(%rbp)
	.loc 1 63 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 70 13
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -80(%rbp)
	.loc 1 70 24
	movq	-56(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	.loc 1 70 22
	mulsd	-80(%rbp), %xmm0
	.loc 1 70 11
	movsd	%xmm0, -32(%rbp)
	.loc 1 71 13
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -80(%rbp)
	.loc 1 71 24
	movq	-56(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	.loc 1 71 22
	mulsd	-80(%rbp), %xmm0
	.loc 1 71 11
	movsd	%xmm0, -24(%rbp)
	.loc 1 72 13
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	.loc 1 72 11
	movq	%rax, -16(%rbp)
.LBB3:
	.loc 1 75 14
	movl	$0, -36(%rbp)
	.loc 1 75 5
	jmp	.L12
.L13:
	.loc 1 77 15 discriminator 3
	movl	-36(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-72(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 77 24 discriminator 3
	movl	-36(%rbp), %eax
	cltq
	movsd	-32(%rbp,%rax,8), %xmm0
	.loc 1 77 20 discriminator 3
	movsd	%xmm0, (%rdx)
	.loc 1 75 31 discriminator 3
	addl	$1, -36(%rbp)
.L12:
	.loc 1 75 24 discriminator 1
	cmpl	$2, -36(%rbp)
	jle	.L13
.LBE3:
	.loc 1 79 1
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L14
	call	__stack_chk_fail@PLT
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	sp2ca, .-sp2ca
	.globl	deg2rad
	.type	deg2rad, @function
deg2rad:
.LFB9:
	.loc 1 82 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -8(%rbp)
	.loc 1 84 17
	movsd	-8(%rbp), %xmm0
	movsd	.LC1(%rip), %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	.loc 1 84 26
	movsd	.LC2(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	.loc 1 85 1
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	deg2rad, .-deg2rad
	.section	.rodata
.LC3:
	.string	"[ xyPik v0.1-alpha ]"
	.align 8
.LC4:
	.string	"No XY angle entered, defaulting to 90 degrees"
.LC6:
	.string	"%lf"
.LC7:
	.string	"ERROR: ILLEGAL INPUT"
	.align 8
.LC8:
	.string	"USE                xypik <Azimuth Angle> <Elevation Angle> <(opt) XY Angle> \n                You don't need to enter the XY angle if it's 90 degrees"
.LC9:
	.string	"Azimuth angle: %.2f radians\n"
	.align 8
.LC10:
	.string	"Elevation angle: %.2f radians\n"
	.align 8
.LC11:
	.string	"XY joint angle: %.2f radians.\n"
.LC16:
	.string	"%f"
	.text
	.globl	main
	.type	main, @function
main:
.LFB10:
	.loc 1 88 1
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$296, %rsp
	.cfi_offset 3, -24
	movl	%edi, -276(%rbp)
	movq	%rsi, -288(%rbp)
	.loc 1 88 1
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	.loc 1 94 5
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	.loc 1 97 8
	cmpl	$3, -276(%rbp)
	jne	.L18
	.loc 1 101 9
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	.loc 1 102 13
	movsd	.LC5(%rip), %xmm0
	movsd	%xmm0, -272(%rbp)
	jmp	.L19
.L18:
	.loc 1 105 13
	cmpl	$4, -276(%rbp)
	jne	.L20
	.loc 1 110 20
	movq	-288(%rbp), %rax
	addq	$24, %rax
	.loc 1 110 9
	movq	(%rax), %rax
	leaq	-272(%rbp), %rdx
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	.loc 1 111 15
	movq	-272(%rbp), %rax
	movq	%rax, %xmm0
	call	deg2rad
	movq	%xmm0, %rax
	.loc 1 111 13
	movq	%rax, -272(%rbp)
	jmp	.L19
.L20:
	.loc 1 116 9
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	.loc 1 117 9
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	.loc 1 120 16
	movl	$0, %eax
	jmp	.L22
.L19:
	.loc 1 126 16
	movq	-288(%rbp), %rax
	addq	$8, %rax
	.loc 1 126 5
	movq	(%rax), %rax
	leaq	-264(%rbp), %rdx
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	.loc 1 127 16
	movq	-288(%rbp), %rax
	addq	$16, %rax
	.loc 1 127 5
	movq	(%rax), %rax
	leaq	-256(%rbp), %rdx
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	.loc 1 128 23
	movq	-264(%rbp), %rax
	movq	%rax, %xmm0
	call	deg2rad
	movq	%xmm0, %rax
	movq	%rax, -232(%rbp)
	.loc 1 129 23
	movq	-256(%rbp), %rax
	movq	%rax, %xmm0
	call	deg2rad
	movq	%xmm0, %rax
	movq	%rax, -224(%rbp)
	.loc 1 130 18
	movsd	-272(%rbp), %xmm0
	movsd	%xmm0, -216(%rbp)
	.loc 1 131 5
	movq	-232(%rbp), %rax
	movq	%rax, %xmm0
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	.loc 1 132 5
	movq	-224(%rbp), %rax
	movq	%rax, %xmm0
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	.loc 1 133 5
	movq	-216(%rbp), %rax
	movq	%rax, %xmm0
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	.loc 1 136 39
	leaq	-112(%rbp), %rax
	movq	%rax, -208(%rbp)
	.loc 1 140 5
	movq	-208(%rbp), %rdx
	movsd	-224(%rbp), %xmm0
	movq	-232(%rbp), %rax
	movq	%rdx, %rdi
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	sp2ca
	.loc 1 143 20
	movq	-216(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rbx
	.loc 1 143 28
	movq	-216(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movapd	%xmm0, %xmm1
	.loc 1 143 12
	movq	%rbx, %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -200(%rbp)
	.loc 1 144 25
	movsd	-112(%rbp), %xmm0
	.loc 1 144 28
	mulsd	-200(%rbp), %xmm0
	.loc 1 144 12
	movq	.LC12(%rip), %xmm1
	xorpd	%xmm1, %xmm0
	movsd	%xmm0, -192(%rbp)
	.loc 1 146 16
	movq	-112(%rbp), %rax
	movsd	.LC13(%rip), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	movsd	%xmm0, -296(%rbp)
	.loc 1 146 31
	movsd	.LC13(%rip), %xmm0
	movq	-200(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	.loc 1 146 30
	movapd	%xmm0, %xmm5
	mulsd	-296(%rbp), %xmm5
	movsd	%xmm5, -296(%rbp)
	.loc 1 146 44
	movq	-104(%rbp), %rax
	movsd	.LC13(%rip), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	.loc 1 146 43
	movsd	-296(%rbp), %xmm5
	subsd	%xmm0, %xmm5
	movsd	%xmm5, -296(%rbp)
	.loc 1 146 58
	movq	-96(%rbp), %rax
	movsd	.LC13(%rip), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	.loc 1 146 57
	movsd	-296(%rbp), %xmm1
	subsd	%xmm0, %xmm1
	.loc 1 146 9
	movq	%xmm1, %rax
	pxor	%xmm0, %xmm0
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	csqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	.loc 1 145 12
	movsd	%xmm0, -184(%rbp)
	.loc 1 147 12
	movsd	-192(%rbp), %xmm0
	addsd	-184(%rbp), %xmm0
	movsd	%xmm0, -176(%rbp)
	.loc 1 148 12
	movsd	-192(%rbp), %xmm0
	subsd	-184(%rbp), %xmm0
	movsd	%xmm0, -168(%rbp)
	.loc 1 149 42
	movsd	-96(%rbp), %xmm0
	.loc 1 149 29
	movsd	-104(%rbp), %xmm1
	.loc 1 149 33
	pxor	%xmm2, %xmm2
	mulsd	%xmm0, %xmm2
	subsd	%xmm2, %xmm1
	movsd	%xmm1, -248(%rbp)
	movq	.LC12(%rip), %xmm1
	xorpd	%xmm1, %xmm0
	movsd	%xmm0, -240(%rbp)
	.loc 1 149 20
	movsd	-240(%rbp), %xmm0
	movsd	-248(%rbp), %xmm1
	movsd	%xmm1, -128(%rbp)
	movsd	%xmm0, -120(%rbp)
	.loc 1 151 31
	movsd	-240(%rbp), %xmm1
	movsd	-248(%rbp), %xmm0
	movq	-176(%rbp), %rax
	movapd	%xmm1, %xmm3
	movapd	%xmm0, %xmm2
	pxor	%xmm1, %xmm1
	movq	%rax, %xmm0
	call	__divdc3@PLT
	movq	%xmm0, %rax
	movapd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	%rdx, %xmm1
	movq	%rax, %xmm0
	call	clog@PLT
	movq	%xmm0, %rax
	movapd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	%rdx, %xmm4
	.loc 1 151 29
	movsd	.LC14(%rip), %xmm1
	movsd	.LC15(%rip), %xmm0
	movapd	%xmm1, %xmm3
	movapd	%xmm0, %xmm2
	movapd	%xmm4, %xmm1
	movq	%rax, %xmm0
	call	__muldc3@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	.loc 1 151 12
	movsd	%xmm0, -160(%rbp)
	.loc 1 152 31
	movsd	-240(%rbp), %xmm1
	movsd	-248(%rbp), %xmm0
	movq	-168(%rbp), %rax
	movapd	%xmm1, %xmm3
	movapd	%xmm0, %xmm2
	pxor	%xmm1, %xmm1
	movq	%rax, %xmm0
	call	__divdc3@PLT
	movq	%xmm0, %rax
	movapd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	%rdx, %xmm1
	movq	%rax, %xmm0
	call	clog@PLT
	movq	%xmm0, %rax
	movapd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	%rdx, %xmm4
	.loc 1 152 29
	movsd	.LC14(%rip), %xmm1
	movsd	.LC15(%rip), %xmm0
	movapd	%xmm1, %xmm3
	movapd	%xmm0, %xmm2
	movapd	%xmm4, %xmm1
	movq	%rax, %xmm0
	call	__muldc3@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	.loc 1 152 12
	movsd	%xmm0, -152(%rbp)
	.loc 1 154 5
	movq	-160(%rbp), %rax
	movq	%rax, %xmm0
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	.loc 1 157 12
	movsd	.LC17(%rip), %xmm0
	movsd	%xmm0, -80(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -72(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -64(%rbp)
	.loc 1 159 12
	movsd	.LC18(%rip), %xmm0
	movsd	%xmm0, -48(%rbp)
	movsd	.LC19(%rip), %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	.LC20(%rip), %xmm0
	movsd	%xmm0, -32(%rbp)
	.loc 1 159 43
	leaq	-48(%rbp), %rax
	movq	%rax, -144(%rbp)
	.loc 1 160 22
	leaq	-48(%rbp), %rax
	movq	%rax, -136(%rbp)
	.loc 1 191 12
	movl	$0, %eax
.L22:
	.loc 1 192 1 discriminator 1
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L23
	.loc 1 192 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L23:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1081507840
	.align 8
.LC2:
	.long	1413754136
	.long	1075388923
	.align 8
.LC5:
	.long	1841940611
	.long	1071931184
	.align 16
.LC12:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC13:
	.long	0
	.long	1073741824
	.align 8
.LC14:
	.long	0
	.long	-1074790400
	.align 8
.LC15:
	.long	0
	.long	-2147483648
	.align 8
.LC17:
	.long	0
	.long	1072693248
	.align 8
.LC18:
	.long	0
	.long	1076101120
	.align 8
.LC19:
	.long	0
	.long	1075970048
	.align 8
.LC20:
	.long	0
	.long	1075838976
	.text
.Letext0:
	.file 2 "/usr/include/bits/cmathcalls.h"
	.file 3 "/usr/include/stdio.h"
	.file 4 "/usr/include/bits/mathcalls.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x470
	.value	0x5
	.byte	0x1
	.byte	0x8
	.long	.Ldebug_abbrev0
	.uleb128 0x10
	.long	.LASF33
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF2
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF4
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF5
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF6
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF7
	.uleb128 0x11
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF8
	.uleb128 0x6
	.long	0x6b
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF9
	.uleb128 0x7
	.long	0x6b
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF10
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF11
	.uleb128 0x2
	.byte	0x4
	.byte	0x4
	.long	.LASF12
	.uleb128 0x7
	.long	0x85
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF13
	.uleb128 0x7
	.long	0x91
	.uleb128 0x9
	.long	0x8c
	.long	0xac
	.uleb128 0xa
	.long	0x2e
	.byte	0
	.uleb128 0x7
	.long	0x9d
	.uleb128 0x12
	.string	"z"
	.byte	0x1
	.byte	0xf
	.byte	0xd
	.long	0xac
	.uleb128 0x9
	.byte	0x3
	.quad	z
	.uleb128 0xb
	.long	.LASF15
	.byte	0x5c
	.long	0xd9
	.long	0xd9
	.uleb128 0x3
	.long	0xd9
	.byte	0
	.uleb128 0x2
	.byte	0x10
	.byte	0x3
	.long	.LASF14
	.uleb128 0xb
	.long	.LASF16
	.byte	0x6a
	.long	0xd9
	.long	0xf4
	.uleb128 0x3
	.long	0xd9
	.byte	0
	.uleb128 0x8
	.string	"pow"
	.byte	0x8c
	.long	0x91
	.long	0x10d
	.uleb128 0x3
	.long	0x91
	.uleb128 0x3
	.long	0x91
	.byte	0
	.uleb128 0x13
	.long	.LASF17
	.byte	0x3
	.value	0x164
	.byte	0xc
	.long	0x58
	.long	0x125
	.uleb128 0x3
	.long	0x125
	.uleb128 0xc
	.byte	0
	.uleb128 0x6
	.long	0x72
	.uleb128 0x14
	.long	.LASF34
	.byte	0x3
	.value	0x1b7
	.byte	0xc
	.long	.LASF35
	.long	0x58
	.long	0x14b
	.uleb128 0x3
	.long	0x125
	.uleb128 0x3
	.long	0x125
	.uleb128 0xc
	.byte	0
	.uleb128 0x8
	.string	"sin"
	.byte	0x40
	.long	0x91
	.long	0x15f
	.uleb128 0x3
	.long	0x91
	.byte	0
	.uleb128 0x8
	.string	"cos"
	.byte	0x3e
	.long	0x91
	.long	0x173
	.uleb128 0x3
	.long	0x91
	.byte	0
	.uleb128 0x15
	.long	.LASF28
	.byte	0x1
	.byte	0x57
	.byte	0x5
	.long	0x58
	.quad	.LFB10
	.quad	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x2d7
	.uleb128 0xd
	.long	.LASF18
	.byte	0x57
	.byte	0xe
	.long	0x58
	.uleb128 0x3
	.byte	0x91
	.sleb128 -292
	.uleb128 0xd
	.long	.LASF19
	.byte	0x57
	.byte	0x1a
	.long	0x2d7
	.uleb128 0x3
	.byte	0x91
	.sleb128 -304
	.uleb128 0x1
	.string	"_ld"
	.byte	0x5f
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -288
	.uleb128 0x1
	.string	"_az"
	.byte	0x7d
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -280
	.uleb128 0x1
	.string	"_el"
	.byte	0x7d
	.byte	0x11
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -272
	.uleb128 0x1
	.string	"az"
	.byte	0x80
	.byte	0x12
	.long	0x98
	.uleb128 0x3
	.byte	0x91
	.sleb128 -248
	.uleb128 0x1
	.string	"el"
	.byte	0x81
	.byte	0x12
	.long	0x98
	.uleb128 0x3
	.byte	0x91
	.sleb128 -240
	.uleb128 0x1
	.string	"ld"
	.byte	0x82
	.byte	0x12
	.long	0x98
	.uleb128 0x3
	.byte	0x91
	.sleb128 -232
	.uleb128 0x1
	.string	"los"
	.byte	0x88
	.byte	0xc
	.long	0x2dc
	.uleb128 0x3
	.byte	0x91
	.sleb128 -128
	.uleb128 0x5
	.long	.LASF20
	.byte	0x88
	.byte	0x1c
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -224
	.uleb128 0x5
	.long	.LASF21
	.byte	0x8f
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -216
	.uleb128 0x5
	.long	.LASF22
	.byte	0x90
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -208
	.uleb128 0x5
	.long	.LASF23
	.byte	0x91
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -200
	.uleb128 0x5
	.long	.LASF24
	.byte	0x93
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -192
	.uleb128 0x5
	.long	.LASF25
	.byte	0x94
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -184
	.uleb128 0x1
	.string	"den"
	.byte	0x95
	.byte	0x14
	.long	0xd9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -144
	.uleb128 0x5
	.long	.LASF26
	.byte	0x97
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -176
	.uleb128 0x5
	.long	.LASF27
	.byte	0x98
	.byte	0xc
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -168
	.uleb128 0x1
	.string	"t"
	.byte	0x9d
	.byte	0xc
	.long	0x2dc
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x1
	.string	"v"
	.byte	0x9f
	.byte	0xc
	.long	0x2dc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x1
	.string	"pv"
	.byte	0x9f
	.byte	0x24
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -160
	.uleb128 0x1
	.string	"pav"
	.byte	0xa0
	.byte	0xd
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -152
	.byte	0
	.uleb128 0x6
	.long	0x66
	.uleb128 0x9
	.long	0x91
	.long	0x2eb
	.uleb128 0xa
	.long	0x2e
	.byte	0
	.uleb128 0x6
	.long	0x91
	.uleb128 0x16
	.long	.LASF29
	.byte	0x1
	.byte	0x51
	.byte	0x8
	.long	0x91
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x321
	.uleb128 0x4
	.string	"deg"
	.byte	0x51
	.byte	0x17
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0xe
	.long	.LASF30
	.byte	0x3e
	.quad	.LFB8
	.quad	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x396
	.uleb128 0x4
	.string	"azr"
	.byte	0x3e
	.byte	0x13
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x4
	.string	"elr"
	.byte	0x3e
	.byte	0x1f
	.long	0x91
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x4
	.string	"pca"
	.byte	0x3e
	.byte	0x2c
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0x1
	.string	"ca"
	.byte	0x43
	.byte	0xc
	.long	0x2dc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0xf
	.quad	.LBB3
	.quad	.LBE3-.LBB3
	.uleb128 0x1
	.string	"i"
	.byte	0x4b
	.byte	0xe
	.long	0x58
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.byte	0
	.byte	0
	.uleb128 0xe
	.long	.LASF31
	.byte	0x1e
	.quad	.LFB7
	.quad	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x410
	.uleb128 0x4
	.string	"pv"
	.byte	0x1e
	.byte	0x15
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -136
	.uleb128 0x4
	.string	"pu"
	.byte	0x1e
	.byte	0x21
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -144
	.uleb128 0x4
	.string	"pr"
	.byte	0x1e
	.byte	0x2d
	.long	0x2eb
	.uleb128 0x3
	.byte	0x91
	.sleb128 -152
	.uleb128 0x1
	.string	"v"
	.byte	0x24
	.byte	0xc
	.long	0x2dc
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0x1
	.string	"u"
	.byte	0x24
	.byte	0x12
	.long	0x2dc
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x1
	.string	"r"
	.byte	0x24
	.byte	0x18
	.long	0x2dc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.string	"i"
	.byte	0x26
	.byte	0x9
	.long	0x58
	.uleb128 0x3
	.byte	0x91
	.sleb128 -116
	.byte	0
	.uleb128 0x17
	.long	.LASF32
	.byte	0x1
	.byte	0x11
	.byte	0x8
	.long	0x91
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x4
	.string	"v"
	.byte	0x11
	.byte	0x14
	.long	0x2eb
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x4
	.string	"u"
	.byte	0x11
	.byte	0x20
	.long	0x2eb
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.string	"sum"
	.byte	0x14
	.byte	0xc
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xf
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.uleb128 0x1
	.string	"i"
	.byte	0x16
	.byte	0xe
	.long	0x58
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x21
	.sleb128 2
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF12:
	.string	"float"
.LASF26:
	.string	"PSI0"
.LASF27:
	.string	"PSI1"
.LASF29:
	.string	"deg2rad"
.LASF20:
	.string	"plos"
.LASF24:
	.string	"nom0"
.LASF25:
	.string	"nom1"
.LASF31:
	.string	"crossp"
.LASF32:
	.string	"dotp"
.LASF15:
	.string	"clog"
.LASF4:
	.string	"unsigned char"
.LASF5:
	.string	"short unsigned int"
.LASF13:
	.string	"double"
.LASF22:
	.string	"nomp0"
.LASF23:
	.string	"nomp1"
.LASF2:
	.string	"long unsigned int"
.LASF3:
	.string	"unsigned int"
.LASF21:
	.string	"cotld"
.LASF11:
	.string	"long long unsigned int"
.LASF35:
	.string	"__isoc99_sscanf"
.LASF28:
	.string	"main"
.LASF16:
	.string	"csqrt"
.LASF33:
	.string	"GNU C17 12.2.0 -mtune=generic -march=x86-64 -g"
.LASF10:
	.string	"long long int"
.LASF9:
	.string	"char"
.LASF17:
	.string	"printf"
.LASF7:
	.string	"short int"
.LASF14:
	.string	"complex double"
.LASF19:
	.string	"argv"
.LASF8:
	.string	"long int"
.LASF34:
	.string	"sscanf"
.LASF6:
	.string	"signed char"
.LASF30:
	.string	"sp2ca"
.LASF18:
	.string	"argc"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"xycal.c"
.LASF1:
	.string	"/home/bcskn/reps/XY"
	.ident	"GCC: (GNU) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
