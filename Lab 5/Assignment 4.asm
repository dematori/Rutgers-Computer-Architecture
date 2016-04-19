# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 4
 
			.data 0x10000800
OrinRow_0:	.word	 1,  2,  3,  4,  5,  6
OrinRow_1:	.word	 7,  8,  9, 10, 11, 12
OrinRow_2:	.word	13, 14, 15, 16, 17, 18
OrinRow_3:	.word	19, 20, 21, 22, 23, 24
OrinRow_4:	.word	25, 26, 27, 28, 29, 30
OrinRow_5:	.word	31, 32, 33, 34, 35, 36

			.data 0x10000900
TransRow_0:	.word	 0,  0,  0,  0,  0,  0
TransRow_1:	.word	 0,  0,  0,  0,  0,  0
TransRow_2:	.word	 0,  0,  0,  0,  0,  0
TransRow_3:	.word	 0,  0,  0,  0,  0,  0
TransRow_4:	.word	 0,  0,  0,  0,  0,  0
TransRow_5:	.word	 0,  0,  0,  0,  0,  0

			.text 0x00400000
main:
	la $t0, OrinRow_0				# loading first row to $t0
	la $s0, TransRow_0				# loading first row to $s0
	la $s1, TransRow_1				# loading second row to $s1
	la $s2, TransRow_2				# loading third row to $s2
	la $s3, TransRow_3				# loading fourth row to $s3
	la $s4, TransRow_4				# loading fifth row to $s4
	la $s5, TransRow_5				# loading sixth row to $s5
	li $t6, 7						# initializing counter to 7
loop:
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s0)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s1)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s2)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s3)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s4)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	lw $t8, 0($t0)					# loading element from original
	sw $t8, 0($s5)					# storing element into transposed
	addi $t0, $t0, 4				# incrementing index of original
	addi $t6, $t6, -1				# decrementing counter
	addi $s0, $s0, 4				# incrementing index of transpose
	addi $s1, $s1, 4				# incrementing index of transpose
	addi $s2, $s2, 4				# incrementing index of transpose
	addi $s3, $s3, 4				# incrementing index of transpose
	addi $s4, $s4, 4				# incrementing index of transpose	
	addi $s5, $s5, 4				# incrementing index of transpose
	beq $t6, 6, row1				# changing all values to neccessary
	beq $t6, 5, row2				# changing all values to neccessary
	beq $t6, 4, row3				# changing all values to neccessary
	beq $t6, 3, row4				# changing all values to neccessary
	beq $t6, 2, row5				# changing all values to neccessary
	beq $t6, 1, exit				# changing all values to neccessary
	
row1:
	la $t0, OrinRow_1				# loading second row to $t0
	j loop							# jump to loop
	
row2:
	la $t0, OrinRow_2				# loading third row to $t0
	j loop							# jump to loop
	
row3:
	la $t0, OrinRow_3				# loading fourth row to $t0
	j loop							# jump to loop
	
row4:
	la $t0, OrinRow_4				# loading fifth row to $t0
	j loop							# jump to loop
	
row5:
	la $t0, OrinRow_5				# loading sixth row to $t0
	j loop							# jump to loop
	
exit:
	li $v0, 10					 	# load syscall service for end_program
	syscall							# making syscall to end_program
	