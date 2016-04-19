# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 2

# Registers:	$t0 -> address of array
#				$t1 -> user inputted value of array size
#				$t2 -> standard counter
#				$t3 -> 
#				$t4 -> 
#				$f0	-> user input values
#				$f1	-> sum of inputted values -> mean
#				$f2	-> float value of size -> temporary place holder -> temp
#				$f3	-> summation of (temp - mean) ^ 2 / (size - 1)
#				$f4	-> value of standard deviation

.data
	array:				.space		400
	arraySize: 			.asciiz 	"Enter size of array: "
	inputArr:			.asciiz		"Enter the number in the array: "
	outputMean:			.asciiz		"\nMean: "
	outputDeviation:	.asciiz		"\nStandard Deviation: "
.text

main:
	la $t0, array				# loading array into $t0
	li $v0, 4					# loading syscall service for print_string
	la $a0, arraySize			# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 5					# loading syscall service for read_int
	syscall						# making syscall service for read_int
	move $t1, $v0				# copying user input to arraySize
	li.s $f1, 0.0				# sum = 0;
	
input:
	li $v0, 4					# loading syscall service for print_string
	la $a0, inputArr			# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 6					# loading syscall service for read_float
	syscall						# making syscall to read_float
	s.s $f0, 0($t0)				# copying user input to array[i]
	add.s $f1, $f1, $f0			# sum += input
	addi $t0, $t0, 4			# address += 4
	addi $t2, $t2, 1			# i++
	beq $t2, $t1, endInput		# if i == size, branch to endInput
	j input						# jump to input

endInput:
	sll $t2, $t1, 2				# returning the counter to the original value
	sub $t0, $t0, $t2			# returning the address of array to base value
	mtc1 $t1, $f2				# convert (int) size to (float) size
	cvt.s.w	$f2, $f2			# convert float to int to register $f2
	div.s $f1, $f1, $f2			# mean = sum / size
	li $v0, 4					# loading syscall service for print_string
	la $a0, outputMean			# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 2					# loading syscall service for print_float
	mov.s $f12, $f1				# loading syscall argument for print_float
	syscall						# making syscall to print_float
	li $t2, 0					# counter = 0
	
StdDeviation:
	l.s $f2, 0($t0)				# temp = array[i]
	sub.s $f3, $f2, $f1			# temp - mean
	mul.s $f3, $f3, $f3			# (temp - mean) * (temp - mean) = (temp - mean) ^ 2
	addi $t0, $t0, 4			# address += 4
	addi $t2, $t2, 1			# i++
	bge $t2, $t1, calculate		# if $t2 >= $t1, branch to calculate
	j StdDeviation				# jump to StdDeviation
	
calculate:
	addi $t2, $t1, -1			# size += -1
	mtc1 $t2, $f2				# convert (int) size-1 to (float) size-1
	cvt.s.w $f2, $f2			# convert float to int to register $f2
	div.s $f3, $f3, $f2			# (temp - mean) ^ 2 / (size - 1)	
	li.s $f13, 0.00001			# loading 0.00001 into $f13
	li.s $f14, 0.00001			# copying $f13 to $f14 = x_i
	li.s $f15, 0.5				# derivative coefficient = 0.5
	
squareRoot:
	div.s $f7, $f3, $f14		# ((temp - mean) ^ 2 / (size - 1)) / x_i
	add.s $f7, $f7, $f14		# ((temp - mean) ^ 2 / (size - 1)) / x_i + x_i
	mul.s $f7, $f15, $f7		# 0.5 * (((temp - mean) ^ 2 / (size - 1)) / x_i + x_i)
	sub.s $f4, $f7, $f14		# 0.5 * (((temp - mean) ^ 2 / (size - 1)) / x_i + x_i) - x_i
	abs.s $f4, $f4				# | 0.5 * (((temp - mean) ^ 2 / (size - 1)) / x_i + x_i) - x_i |
	c.lt.s $f4, $f13			# if | 0.5 * (((temp - mean) ^ 2 / (size - 1)) / x_i + x_i) - x_i | < 0.00001
	bc1t printDeviation			# then branch to surfaceArea
	mov.s $f14, $f7				# else x_i = x_(i+1)
	j squareRoot				# jump to squareRoot

printDeviation:
	li $v0, 4					# loading syscall service for print_string
	la $a0, outputDeviation		# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 2					# loading syscall service for print_float
	mov.s $f12, $f4				# loading syscall argument for print_float
	syscall						# making syscall to print_float
	li $v0, 10					# loading syscall argument for end_program
	syscall						# making syscall to end_program