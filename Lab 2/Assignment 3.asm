# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 3

# Pseudocode:	(1) Get user inputs for the first and second number. -> $t0 = a; $t1 = b;
#				(2) check if the numbers are in bounds.	-> $t2 = 10; $t3 = 500;
#					return error if false 
#				(3) check if $t0 is divisable by $t1, return error if true
#				(4) check if $t1 is divisable by $t0, return error if true
#				(5) order the two input numbers are use them as counters
#				(6) if the lower number is odd, add 1 then increment by 2 until
#					counter is greater than or equal to the larger number inputted
#					if the lower number is odd, increment by 2 until the counter is
#					greater than or equal to the larger number inputted
#				(7) Check if number is even, if even, add to sum then increment by 2
#					Check if number is even, if odd, increment number by 1 to make even.
#				(8)	Print out sum


.data
	str1: .asciiz "Enter the first number: "
	str2: .asciiz "Enter the second number: "
	errorStr: .asciiz "Error: numbers are divisable by one another or not in the range of 10 ~ 500"

.text
main:
## Get first number from user, put into $t0.
	li $v0, 4 				# load syscall print string
	la $a0, str1 			# load address of str1 to register a0
	syscall 				# make the syscall.
	li $v0, 5 				# load syscall read_int into $v0.
	syscall 				# make the syscall.
	move $t0, $v0 			# move the number read into $t0.

## Get second number from user, put into $t1.
	li $v0, 4 				# load syscall print string
	la $a0, str2 			# load address of str2 to register a0
	syscall 				# make the syscall.
	li $v0, 5				# load syscall read_int into $v0.
	syscall 				# make the syscall.
	move $t1, $v0 			# move the number read into $t1.

## Condition: Checking bounds
	li $t2, 10				# loading lower bound to 10
	li $t3, 500				# loading upper bound to 400
	blt $t0, $t2, error		# branch if first input is less than 10
	bgt $t0, $t3, error		# branch if first input is greater than 500
	blt $t1, $t2, error		# branch if second input is less than 10
	bgt $t1, $t3, error		# branch if second input is greater than 500

## Condition: Checking divisibility
	rem $t2, $t0, $t1		# finding the remainder of $t0 / $t1
	beq $t2, $0, error 		# If remainder is 0, then first input is divisable by the second input
	rem $t2, $t1, $t0		# finding the remainder of $t1 / $t0
	beq $t2, $0, error		# If remainder is 0, then second input is divisable by the first input

## Condition: Check which number is larger
	bgt $t0, $t1, swap 		# If $t0 > $t1, then swap values
	move $t4, $t0 			# $t4 will be used as a counter register
	addi $t4, $t4, 1 		# Two inputs are exclusive in the calculations
	li $t5, 2 				# Used for remainder check
	
loop:
	bge $t4, $t1, exit 		# If $t4 >= $t1, then exit
	rem $t6, $t4, $t5 		# Find whether the number is divisable by 2
	beqz $t6, even	 		# if remainder == 0, then the number is even
	bnez $t6, odd			# if remainder != 0, then the number is odd
	j loop					# jump to loop

even:
	add $t7, $t7, $t4		# number is even, add to sum
	addi $t4, $t4, 2		# increment number by 2 to get next even number
	j loop					# jump to loop
	
odd:
	addi $t4, $t4, 1		# number is even, increment by 1
	j loop					# jump to loop
	
swap:
	move $t2, $t1 			# $t2 temporary place holder for the value to be swapped
	move $t1, $t0			# moving $t0 to $t1
	move $t0, $t2			# moving $t2 to $t0
	j loop					# jump to loop
	
error:
	li $v0, 4				# setting the syscall argument to print string
	la $a0, errorStr 		# loading the string to the argument register
	syscall					# syscall to print out the string
	li $v0, 10 				# setting the syscall argument to end the program
	syscall					# syscall to end the program
	
exit:
	li $v0, 1				# setting the syscall argument to print integer
	move $a0, $t7			# moving the sum to the argument register
	syscall					# syscall to print out the integer
	li $v0, 10				# setting the syscall argument to end the program
	syscall					# syscall to end the program

