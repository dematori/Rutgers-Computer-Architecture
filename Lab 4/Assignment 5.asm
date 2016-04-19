# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 6

.data
	ask_index: 		.asciiz 	"Please enter the value of n that you would like to get use: \n"
	tell_result:	.asciiz 	"Result of a[n] = "
## Arithemtic Overflow Interrupt Message
.kdata
	error:		.asciiz		"Arithemtic Overflow.\n"
.text

main:
	la $a0, ask_index		# Load and print string asking for string
    li $v0, 4				# load syscall print_string into $v0
    syscall					# make the syscall.
	li $v0, 5				# load syscall read_into into $v0	
	syscall					# make the syscall.
	move $t0, $v0			# move the number read into $t0
	addi $t0, $t0, 1		# making number input the nuber of inputs.
	li $t1, 3				# initializing i = 2
	li $t2, 0				# a[0] = 0
	li $t3, 1				# a[1] = 1
	li $t4, 1				# a[2] = 1
	j loop
	
loop:
	bge $t1, $t0, END		# for loop from 3 to n
	addi $t1, $t1, 1		# incremement the counter
	add $t5, $t2, $t3		# adding a[n-3] and a[n-2]
	add $t5, $t5, $t4		# adding $t5 to a[n-1]
	move $t2, $t3			# moving the $t3 into $t2
	move $t3, $t4			# moving the $t4 into $t3
	move $t4, $t5			# moving the $t5 into $t4
	j loop					# jump to loop
	
END:
	la $a0, tell_result		# print string with tell header
    li $v0, 4				# load syscall print_string into $v0
    syscall					# make the syscall.
	move $a0, $t4			# move the number to print into $a0.
	li $v0, 1 				# load syscall print_int into $v0.
	syscall 				# make the syscall
	li $v0, 10      		# syscall code 10 is for exit.
    syscall					# make the syscall.
	
## Arithmetic Overflow Interrupt
.ktext 0x80000180
	move $k0, $v0		# moving to interrupt register
	move $k1, $a0		# moving to interrupt register
	la $a0, error		# loading syscall argument for print_string
	li $v0, 4			# loading syscall service to print_string
	syscall				# making syscall to print_string
	move $v0, $k0		# retrieving interrupt register
	move $a0, $k1		# retrieving interrupt register
	mfc0 $k0, $14		
	lui $k0, 0x0040		# loading upper to base address
	ori $k0, 0x0000		# loading lower to base address
	mtc0 $k0, $14
	eret