# Jeffrey Huang
# Assignment 5

.data
    buffer: .space 100
    ask_index:  .asciiz "Please enter the number of integers you would like to multiply:\n"
	ask_number: .asciiz "Please enter the number that you would like to multiply:\n"
    tell:  .asciiz "The product that you made:\n"

.text

main:
	li $t3, 1
## Getting the number of integers that the user wants to enter
	la $a0, ask_index		# Load and print string asking for string
    li $v0, 4				# load syscall print_string into $v0	
    syscall					# make the syscall.
## Get first number from user, put into $t0 (number of integers)
	li $v0, 5				# load syscall read_into into $v0	
	syscall					# make the syscall.
	move $t0, $v0			# move the number read into $t0
	#addi $t0, $t0, 1		# making number input the nuber of inputs.
	li $t1, 0				# initializing i = 0
	j loop					# jump to loop
	
loop:
	bge $t1, $t0, END		# from i = 0 to n - 1 (n times)
	addi $t1, $t1, 1		# incremementing i by 1
	la $a0, ask_number		# Load and print string asking for string
    li $v0, 4				# load syscall print_string into $v0	
    syscall					# make the syscall.
	li $v0, 5				# load syscall read_into into $v0	
	syscall					# make the syscall.
	move $t2, $v0			# move the number read into $t0
	mul $t3, $t3, $t2		# $t3 = $t3 * $t2
	j loop					# jump to loop
	
END:
	la $a0, tell   			# print string with tell header
    li $v0, 4				# load syscall print_string into $v0
    syscall					# make the syscall.
	move $a0, $t3			# move the number to print into $a0.
	li $v0, 1 				# load syscall print_int into $v0.
	syscall 				# make the syscall
	li $v0, 10      		# syscall code 10 is for exit.
    syscall					# make the syscall.
