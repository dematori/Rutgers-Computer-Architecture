# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 2

# Registers:	$t0 -> array index counter for Array1
#				$t1 -> temporary array base address (Array1)
#				$t2 -> 
#				$t3 -> 
#				$t4 -> 
#				$t5 -> 
#				$t6 -> value LO
#				$t7 ->
#				$t8 ->
#				$t9 -> 
#				$s0 -> Array1 base location
#				$s1 -> array size (abitrary value)
#				$s2 -> 
#				$s3 -> number to be inserted
#				$s4 -> copy of array size
#				$s5 -> 

.data
	Array1:			.space		400
	arraySize: 		.asciiz 	"Enter size of array: "
	inputArr:		.asciiz		"Enter the number in the array: "
	inputNum:		.asciiz		"\nEnter the number to be inserted: "
	arraySort:		.asciiz		"\nSorted Array: "
	arrayInsert:	.asciiz		"\nModified array: "
	space:			.asciiz		" "
	
.text

main:
	la $s0, Array1								# loading array base address to $s0
	move $t1, $s0								# moving array base address to $t1
	li $v0, 4									# loading syscall service for print_string
	la $a0, arraySize							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 5									# loading syscall service for read_int
	syscall										# making syscall for read_int
	move $s1, $v0								# moving array size to register
	addi $s1, $v0, -1							# size-- for index adjustment
	move $s4, $s1								# copy of array size
## Getting user input
input:
	bgt $t0, $s1, endInput						# if counter == size, branch to endInput
	li $v0, 4									# loading syscall service for print_string
	la $a0, inputArr							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 5									# loading syscall service for read_int
	syscall										# making syscall for read_int
	sw $v0, ($t1)								# storing input into array
	addi $t0, $t0, 1							# incrementing the array index counter
	addi $t1, $t1, 4							# incrementing the address by 4 for word
	j input										# jump to input
endInput:
	la $s0, Array1								# loading base address from Array1
	li $t0, 0									# changing the index counter to 0
	
## Bubblesort algorithm
outerLoop:
	beq $t0, $s1, printArraySort				# if counter == size, branch to intialize
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
	j innerLoop									# jump to innerLoop

printArraySort:
	li $v0, 4									# loading syscall service for print_string
	la $a0, arraySort							# loading syscall argument for print_string
	syscall										# making syscall for print_string
printArray:
	blt $s1, $0, getInput						# if $s1 < 0, branch to getInput
	lb $a0, 0($s0)								# load byte from sorted array
	li $v0, 1									# loading syscall service for print_integer
	syscall										# making syscall for print_integer
	li $v0, 4									# loading syscall service for print_string
	la $a0, space								# loading syscall argument for print_string
	syscall										# making syscall for print_integer
	addi $s0, $s0, 4							# incrementing the array address by word factor (4)
	addi $s1, $s1, -1							# decrementing array size by 1
	j printArray								# jump to printArray
	
getInput:
	move $s1, $s4								# copying original array size
	li $v0, 4									# loading syscall service for print_string
	la $a0, inputNum							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $v0, 5									# loading syscall service for read_int
	syscall										# making syscall for read_int
	move $s3, $v0								# moving number to be inserted to $s3
	j binSearchStart							# jump to binSearchStart
	
## Binary Search Algorithm
binSearchStart:
	la $t1, Array1								# loading Array1 into $s0
	li $t4, 0									# loading beginning location
	move $t5, $s4								# size--
	li $s0, 2									# temporary division by 2

binSearch:
	add $t6, $t5, $t4							# ( HI + LO )
	div $t6, $s0								# ( HI + LO ) / 2
	move $s1, $t6								# moving LO to temporary register
	sll $t6, $t6, 2								# shifting two into mid
	add $t1, $t1, $t6							# array[mid]
	lw $t7, 0($t1)								# temp = array[mid]
	bgt	$s3, $t7, greaterThan					# if input > array[mid], branch to greaterThan
	blt $s3, $t7, lessThan						# if input < array[mid], branch to lessThan
	sub $t1, $t1, $t6							# else input == array[mid]
	move $t5, $s1								# saving input value to location
	j shiftArray								# jump to shiftArray
	
greaterThan:
	bge $t4, $t5, insertAfter					# if beginning >= size, then branch to insertAfter
	addi $t4, $s1, 1							# else LO = mid + 1
	sub $t1, $t1, $t6							# returning to array base address
	j binSearch									# jump to binSearch
	
lessThan:
	bge $t4, $t5, insertBefore					# if beginning >= size, then branch to insertBefore
	addi $t5, $s1, -1							# else HI = mid - 1
	sub $t1, $t1, $t6							# returning to array base address
	j binSearch									# jump to binSearch
	
insertAfter:
	sub $t1, $t1, $t6							# returning to array base address
	addi $t5, $t5, 1							# size++
	j shiftArray								# jump to shiftArray
	
insertBefore:
	move $t5, $t4								# starting position is insert location
	sub $t1, $t1, $t6							# returning to array base address	
	move $s1, $t6								# insert at current position

shiftArray:
	sll $t6, $t5, 2								# finding the address with offset
	add $t1, $t1, $t6							# returning array to base address
	lw $t4, 0($t1)								# storing previous value temporarily
	sw $s3, 0($t1)								# inserting the new value
	move $s3, $t4								# replacing the inserted value with previous value
	addi $t1, $t1, 4							# incrementing the address by 4
shift:
	lw $t4, 0($t1)								# storing previous value temporarily
	sw $s3, 0($t1)								# inserting the new value
	move $s3, $t4								# replacing the inserted value with previous value
	addi $t5, $t5, 1							# incrementing the array counter
	bgt $t5, $t0, outputArray					# if counter >= size, branch to 
	addi $t1, $t1, 4							# incrementing the address by 4
	j shift										# jump to shift	
outputArray:
	li $v0, 4									# loading syscall service for print_string
	la $a0, arrayInsert							# loading syscall argument for print_string
	syscall										# making syscall for print_string
	li $s1, -1									# loading offset counter for array
	la $s0, Array1								# return to array base address
printSorted:
	lb $a0, 0($s0)								# load byte from sorted array
	li $v0, 1									# loading syscall service for print_integer
	syscall										# making syscall for print_integer
	li $v0, 4									# loading syscall service for print_string
	la $a0, space								# loading syscall argument for print_string
	syscall										# making syscall for print_integer
	addi $s0, $s0, 4							# incrementing the array address by word factor (4)
	addi $s1, $s1, 1							# decrementing array size by 1
	bgt $s1, $s4, exit							# if $s1 == size, branch to exit
	j printSorted								# jump to printSorted
	
exit:
	li $v0, 10									# loading syscall service for end_program
	syscall										# making syscall for end_program