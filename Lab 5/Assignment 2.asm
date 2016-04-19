# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 2

# Registers:		$t0 -> address of ArrayA
#					$t1 -> address of ArrayB
#					$t2 -> address of ArrayC
#					$t3 -> size of ArrayA
#					$t4 -> size of ArrayB
#					$t5 -> A[index]
#					$t6 -> B[index]
#					$t7 -> C[index]

			.data 0x10000480
ArrayA:		.word 		1, 2, 3
ArrayB:		.word		8, 7, 6
ArrayC:		.space		36
space:		.asciiz		" "

			.text
			.globl main
main:
	la $t0, ArrayA					# loading address of ArrayA into register $t0
	la $t2, ArrayC					# loading address of ArrayC into register $t2
	li $t3, 3						# loading array size of ArrayA into register $s0

outerLoop:
	beqz $t3, printSetup			# if $t3 == 0, branch to printSetup
	la $t1, ArrayB					# loading address of ArrayB into register $t1
	li $t4, 3						# loading array size of ArrayB into register $s1
	sub $t3, $t3, 1					# (size of ArrayA)--
	lw $t5, 0($t0)					# A[index]
	addi $t0, $t0, 4				# incrementing address of ArrayB
innerLoop:
	beqz $t4, outerLoop				# if $t4 == 0, branch to outerLoop
	lw $t6, 0($t1)					# B[index]
	mult $t6, $t5					# A[index] * B[index]
	mflo $t7						# moving product from $LO
	sw $t7, 0($t2)					# storing product into C[index]
	sub $t4, $t4, 1					# (size of ArrayB)--
	addi $t1, $t1, 4				# incrementing address of ArrayB
	addi $t2, $t2, 4				# incrementing address of ArrayC
	j innerLoop						# jump to innerLoop
	
printSetup:
	la $t2, ArrayC					# reloading address of ArrayC into register $t2
	li $t3, 9						# loading size of ArrayC
printLoop:
	beqz $t3, exit					# if $t3 == 0, branch to exit
	lw $a0, 0($t2)					# loading syscall argument for print_integer
	li $v0, 1						# loading syscall service for print_integer
	syscall							# making syscall to print_integer
	la $a0, space					# loading syscall argument for print_string
	li $v0, 4						# loading syscall service for print_string
	syscall
	addi $t2, $t2, 4				# incrementing address of ArrayC
	sub $t3, $t3, 1					# decrementing size of ArrayC
	j printLoop						# jump to printLoop
exit:
	li $v0, 10						# load syscall service for exit_program
	syscall							# making syscall to exit_program
	
## ASSIGNMENT 2 PROBLEM:
#			Set		V	LRU		Tag(h)	Data (h) Way 0							Acc
#			0		1	0		400012	00000001 00000002 00000003 00000008		
#			1		1	0		400012	00000007 00000006 00000008 00000007
#			2		1	0		400012	00000006 00000010 0000000e 0000000c	
#			3		0	0		400012	00000018 00000015 00000012 00000020		hit
#			EXPLANATION:	The elements of A and B are mapped in each slot in the data cache right next to
#							to each other. Since the cache isn't filled from one array, the elements of ArrayA
#							will leave one open slot for the first element of ArrayB. This means that the cache
#							utilizes each space regardless of whether or not the elements are part of different
#							arrays.
