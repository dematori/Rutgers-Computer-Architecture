# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 3

## MIPS Version
# Registers Used:		$s0 -> value of n
#						$f0 -> k! -> 1/k!
#						$f12 -> output register

.data
	input:		.asciiz		"Enter the value of n: "
	output:		.asciiz		"Approximate value of e is "

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
	li $v0, 4					# loading syscall service for print_string
	la $a0, output				# loading syscall argument for print_string
	syscall						# making syscall to print_string
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

