# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 3


# Registers:		$t0 -> base address of Matrix_T
#					$t1 -> base address of Vector_Y
#					$t2 -> number of rows for Matrix_T
#					$t3 -> number of columns for Matrix_T
#					$t4 -> Matrix_T($t2, $t3)
#					$t5 -> Vector_Y($t3))
#					$t6 -> 
#					$t7 -> 

		.data 0x10000860
Vector_X:	.word	1, 2, 3, 4, 5, 6, 7
		.data 0x10000880
Vector_Y:	.word	4, 5, 6, 7, 8, 9, 10
		.data 0x10000c80
Matrix_T:	.word	0, -4, -7, 2, -6, 5, 3
		.data 0x10001080
			.word	4, 0, -5, -1, 3, -7, 6
		.data 0x10001480
			.word	7, 5, 0, -6, -2, 4, -1
		.data 0x10001880
			.word	-2, 1, 6, 0, -7, -3, 5
		.data 0x10001c80
			.word	6, -3, 2, 7, 0, -1, -4
		.data 0x10002080
			.word	-5, 7, -4, 3, 1, 0, -2
		.data 0x10002480
			.word	-3, -6, 1, -5, 4, 2, 0
		.data 0x10002880
Vector_Z:	.word	0, 0, 0, 0, 0, 0, 0
space:		.asciiz	" "

		.text 0x00400000
			.globl main
main:
	la $t0, Matrix_T					# loading address of Matrix_T to $t0
	la $t1, Vector_Y					# loading address of Vector_Y to $t1
	la $t7, Vector_Z					# loading address of Vector_Z to $t7
	li $t2, 7							# loading number of rows as a constant into $t2
	li $t3, 7							# loading number of columns as a constant into $t3

loop:
	beqz $t3, moveToNextRow				# if $t3 == 0, branch to moveToNextRow
	lw $t4, 0($t0)						# loading element of Matrix_T
	lw $t5, 0($t1)						# loading element of Vector_Y
	addi $t3, $t3, -1					# decrementing number of elements left to multiply
	mult $t4, $t5						# Vector_Y[x,y] * Matrix_T[x,y]
	mflo $t6							# getting product from mult function
	add $t9, $t9, $t6					# adding new product to sum
	addi $t0, $t0, 4					# incrementing address of Matrix_T
	addi $t1, $t1, 4					# incrementing address of Vector_Y
	j loop								# jump to loop
	
moveToNextRow:
	addi $t2, $t2, -1					# decrementing number of rows left to multiply
	sw $t9, 0($t7)						# storing partial result into Vector_Z[x,y]
	li $t9, 0							# loading initial sum value of each row.
	addi $t7, $t7, 4					# incrementing to the next empty element
	addi $t0, $t0, 996					# incrementing to the next row.
	la $t1, Vector_Y					# reloading the base address to the register
	li $t3, 7							# reloading the number of elements left to multipy
	beqz $t2, printSetup				# if $t2 == 0, branch to printSetup
	j loop								# else jump to loop
	
printSetup:
	la $t7, Vector_Z					# reloading base address to Vector_Z
	li $t3, 7							# loading counter to size of Vector_Z
	
printVector:
	lw $a0, 0($t7)						# loading element from Vector_Z to $t9
	li $v0, 1							# loading syscall service for print_int
	syscall								# making syscall to print_int
	la $a0, space						# loading blank space for print_string
	li $v0, 4							# loading syscall service for print_string
	syscall								# making syscall to print_string
	addi $t3, $t3, -1					# decrementing the number of elements remaining
	beqz $t3, exit						# if $t3 == 0, branch to exit
	addi $t7, $t7, 4					# incrementing to the next element in the vector
	j printVector						# jump to printVector
	
exit:
	li $v0, 10							# loading syscall service for end_program
	syscall								# making syscall service to end_program
	
	