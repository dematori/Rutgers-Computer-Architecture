# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 7

# Registers:	$t0 -> array index counter
#				$t1 -> temporary array base address
#				$t2 -> 
#				$t3 -> temporary array base address
#				$t4 -> 
#				$t5 -> 
#				$t6 -> 
#				$t7 -> 
#				$t8 -> 
#				$t9 -> 
#				$s0 -> Array1 base location
#				$s1 -> array size (abitrary value)
#				$s2 -> median value
#				$s3 -> negatives counter
#				$s4 -> positives counter
#				$s5 -> zeroes counter

.data
#	Array1: .word 12, 2, -4, 16, 5, -20, 0, 10, 0xF
	Array1: .space 400							# array size allows to hold 100 words
	arraySize: .asciiz "Enter size of array: "
	array: .asciiz "Sorted Array: "
	median: .asciiz "\nThe median is: "
	positives: .asciiz "\n\nThe number of positives is: "
	negatives: .asciiz "\nThe number of negatives is: "
	zeroes: .asciiz "\nThe number of zeroes is: "
	space: .asciiz "  "

.text
main:
	la $s0, Array1
	move $t1, $s0								# moving array base address to $t1
	li $s1, -1									# setting initial size = -1
	li $v0, 4									# loading syscall service for print_string
	la $a0, arraySize							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 5									# loading syscall service for read_int
	syscall										# making syscall for read_int
	beq $v0, $0, exit							# if $v0 == 0, branch to exit
	addi $s1, $v0, -1							# size-- for index adjustment
## Getting user input
input:
	bgt $t0, $s1, endInput						# if counter == size, branch to endInput
	li $v0, 5									# loading syscall service for read_int
	syscall										# making syscall for read_int
	sw $v0, ($t1)								# storing input into array
	addi $t0, $t0, 1							# incrementing the array index counter
	addi $t1, $t1, 4							# incrementing the address by 4 for word
	j input										# jump to input
endInput:
	li $v0, 0xF									# ending marker of 0xF
	sw $v0, ($t1)								# storying input into the array
	la $s0, Array1								# loading base address from Array1
	li $t0, 0									# changing the index counter to 0
	
## Bubblesort algorithm
outerLoop:
	beq $t0, $s1, calculate						# if $t0 == $s1, branch to calculate
	addi $t0, $t0, 1							# array index ++
	li $t1, 0									# changing base address to 0
	move $t3, $s0								# moving the base array address to $t3
	
innerLoop:
	beq $t1, $s1, outerLoop						# if $t1 == $s1, branch to outerLoop
	lw $t4, ($t3)								# loading first element to $t4
	lw $t5, 4($t3)								# loading second element to $t5
	addi $t1, $t1, 1							# incrementing array counter by 1
	blt $t5, $t4, swap							# if $t5 < $t4, branch to swap
	addi $t3, $t3, 4							# increment the counter by 4 for word
	j innerLoop									# jump to innerLoop

swap:
	sw $t5, ($t3)								# storing the second element as first element
	sw $t4, 4($t3)								# storing the first element as second element
	addi $t3, $t3, 4							# increment the counter by 4 for word
	j innerLoop									# jumpt to innerLoop

calculate:
	li $t0, 2									# loading division for even numbers
	rem $t1, $s1, $t0 							# if $s1 % 2 == 1 -> even
	bnez $t1, evenSize							# if $t1 == 1, branch to evenSize
	beqz $t1, oddSize							# if $t1 == 0, branch to oddSize

oddSize:
	div $t1, $s1, $t0							# finding the mid point of the array
	mul $t1, $t1, 4								# multiply by 4 (word factor size)
	move $t2, $s0								# move the middle element to $t2
	add $t2, $t2, $t1							# $t2 = $t2 + $t1
	lw $s2, ($t2)  								# load into $s0 for median value
	j negativeCounter							# jump to negativeCounter

evenSize:
	div $t1, $s1, $t0							# finding the mid point of the array
	mul $t1, $t1, 4								# multiply by 4 (word factor size)
	move $t2, $s0								# moving address to $t2
	add $t2, $t2, $t1							# adding 4 to the address to get next address
	lw $t0, ($t2) 								# loading lower middle element
	lw $t1, 4($t2)								# loading higher middle element
	add $t0, $t0, $t1							# lower middle element + higher middle element
	li $t1, 2									# loading 2 for division purposes
	div $s2, $t0, $t1							# dividing sum of lower and higher middle element by 2
	j negativeCounter							# jump to negativeCounter

negativeCounter:
	move $t0, $s0								# move array base address to $t0
	li $s6, -1									# setting base to recognize the negatives
	addi $t1, $t1, -4							# subtracting base array address by 4
	
negativeLoop:
	lw $t1, ($t0)								# loading first element to register $t1
	bgt $t1, $s6, positiveCounter				# if $t1 > $s6, branch to positiveCounter
	addi $s3, $s3, 1							# negative++
	addi $t0, $t0, 4							# incrementing array address by 4
	j negativeLoop								# jump to negativeLoop

positiveCounter:
	move $t0, $s0								# load array base address to $t0
	li $s6, 1									# setting base to recognize the positives
	mul $t1, $s1, 4								# incrementing array address by 4
	add $t0, $t0, $t1							# adding top of address to base of address

positiveLoop:
	lw $t1, ($t0)								# loading last element to register $t0
	blt $t1, $s6, zeroCounter					# if $t1 < $s6, branch to zeroCounter
	addi $s4, $s4, 1							# positive++
	addi $t0, $t0, -4							# decrementing array address by 4
	j positiveLoop								# jump to positiveLoop

zeroCounter:
	sub $s5, $s1, $s3							# total - negatives = zeroes + positives
	sub $s5, $s5, $s4							# zeores + positives - positives = zeroes
	addi $s5, $s5, 1							# adding 1 to adjust for size change
	j printArrayHeader								# jump to printArrayHeader

printArrayHeader:
	li $v0, 4									# loading syscall service for print_string
	la $a0, array								# loading syscall argument for print_string
	syscall										# making syscall for print_string
	j printArray								# jump to printArray
	
printArray:
	blt $s1, $0, printMedian					# if $s1 < 0, branch to printMedian
	lb $a0, ($s0)								# load byte from sorted array
	li $v0, 1									# loading syscall service for print_integer
	syscall										# making syscall for print_integer
	li $v0, 4									# loading syscall service for print_string
	la $a0, space								# loading syscall argument for print_string
	syscall										# making syscall for print_integer
	addi $s0, $s0, 4							# incrementing the array address by word factor (4)
	addi $s1, $s1, -1							# decrementing array size by 1
	j printArray								# jump to printArray

printMedian:
	li $v0, 4									# loading syscall service for print_string	
	la $a0, median								# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 1									# loading syscall service for print_integer
	move $a0, $s2								# loading syscall argument for print_integer
	syscall										# making syscall for print_integer
	j printPositives							# jump to printPositives

printNegatives:
	li $v0, 4									# loading syscall service for print_string
	la $a0, negatives							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 1									# loading syscall service for print_integer
	move $a0, $s3								# loading syscall argument for print_integer
	syscall										# making syscall for print_integer
	j printZeroes								# jump to printZeroes
	
printPositives:
	li $v0, 4									# loading syscall service for print_string
	la $a0, positives							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 1									# loading syscall service for print_integer
	move $a0, $s4								# loading syscall argument for print_integer
	syscall										# making syscall for print_integer
	j printNegatives							# jump to printNegatives

printZeroes:
	li $v0, 4									# loading syscall service for print_string
	la $a0, zeroes								# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 1									# loading syscall service for print_integer
	move $a0, $s5								# loading syscall argument for print_integer
	syscall										# making syscall for print_integer
	j exit										# jump to exit

exit:
	li $v0, 10									# loading syscall service for end_program
	syscall										# making syscall for end_program
