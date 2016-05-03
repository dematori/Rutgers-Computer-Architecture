# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 3

## PART (a)
#----------------------------------------------------------------------------------
## MIPS Version
# Registers Used:		$s0 -> value of n
#						$f0 -> k! -> 1/k!
#						$f12 -> output register

.data
	input:		.asciiz		"Enter the value of n: "

.text
main:
	li.s $f12, 0.0				# loading intial value of register $12
	li.s $f1, 1.0				# loading constant 1 into register $f1
	li $v0, 4					# loading syscall service for print_string
	la $a0, input				# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 5					# loading syscall service for read_int
	syscall						# making syscall to read_int
	move $s0, $v0				# moving user input into register $s0
	
loop:
	bltz $s0, printOutput		# if $s0 == 0, branch to printOutput
	move $a0, $s0				# moving $s0 to $a0 for factorial function use.
	jal fact					# jump and load factorial.
	mtc1 $v0, $f0				# moving k! to floating point regsister
	cvt.s.w	$f0, $f0			# converting from double to single.
	div.s $f0, $f1, $f0			# 1 / k!
	add.s $f12, $f12, $f0		# 1/(k-1)! + 1/k!
	addi $s0, $s0, -1			# decrementing the value of n
	j loop						# jump to loop
	
printOutput:
	li $v0, 2					# loading syscall service for print_float
	syscall						# making syscall to print_float
	li $v0, 10					# loading syscall service for end_program
	syscall						# making syscall service to end_program
	
# FACTORIAL FUNCTION - Provided in lecture 3
fact: 
	addi $sp, $sp, -8 			#adjust stack pointer
	sw $ra, 4($sp) 				#save return address
	sw $a0, 0($sp) 				#save argument n
	slti $t0, $a0, 1 			#test for n < 1
	beq $t0, $zero, L1 			#if n >=1, go to L1
	addi $v0, $zero, 1 			#else return 1 in $v0
	addi $sp, $sp, 8 			#adjust stack pointer
	jr $ra 						#return to caller
	
L1:
	addi $a0, $a0, -1 			#n >=1, so decrement n
	jal fact 					#call fact with (n-1)

bk_f: 
	lw $a0, 0($sp) 				#restore argument n
	lw $ra, 4($sp) 				#restore return addr
	addi $sp, $sp, 8 			#adjust stack pointer
	mul $v0, $a0, $v0 			#$v0 = n * fact(n-1)
	jr $ra 						#return to caller
#----------------------------------------------------------------------------------
// PTX ISA Version

.data
	
main:
//	add.u32 r1, 0, 10;		// given that n is already stored into r1
	add.f32	r2, 0, 0;		// initialize r2 as 0 -> output register
	add.f32 r3, 1, 0;		// initialize r3 as 1 -> factorial = k!
	
loop:
	cvt.f32.u32, r4, r1;		// converting counter to floating counter
factLoop:
	mul.f32 r3, r3, r4;		// r4 * r3
	sub.f32 r4, r4, 1.0;		// decrement r4 by 1
	set.lt.f32 r5, r4, 0;	// set r5 to r4 < 0
	@r5 bra summation;		// branch to summation if r4 < 0
	@!r5 bra factLoop;		// branch to factLoop if !(r4 < 0)
summation:
	rcp.f32 r6, r3;			// 1 / k!
	add.f32 r2, r2, r6;		// 1 / (k-1)! + 1 / k!
	sub.f32	r1, r1, 1.0;		// decrementing r1 by 1
	setp.eq.s32 r5, r1, 0;	// set r5 to r1 == 0
	@r5 bra endProgram;		// branch to printOutput if r1 == 0
	@!r5 bra loop;			// branch to loop if r1 != 0
endProgram:
	exit;					// end the program

#----------------------------------------------------------------------------------
## PART (b)
#----------------------------------------------------------------------------------
# The PTX ISA version is significantly shorter than the MIPS version. The number of
# cycles for the MIPS version for the polynomial of degree 10 would result in around 
# about 10000 cycles. As compared to the PTX ISA version, the number of cycles would
# dramatically decrease because there is no stack pointer to adjust or factorial
# function to call upon. It just compares and loops through the factorial and 
# reciprocates the value and adds the sum together. Thus the number of cycles for
# the PTX ISA version would come to around a close 5000 cycles, which is about half
# the number of cycles required for the MIPS version.