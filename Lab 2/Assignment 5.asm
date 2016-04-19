# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 5

# Registers:	$t0 -> 1st input password
#				$t1 -> length of 1st password
#				$t2 -> temporary byte holder for $t1
#				$t3 -> 2nd input password
#				$t4 -> temporary byte holder for $t3
#				$t5 -> copy of $t1
#				$t6 -> copy of $t3
#				$t7 -> number of tries remaining
#				$s0 -> password minimum length = 6
#				$s1 -> password maximum length = 10
#				$s2 -> constant 2
#				$s3 -> contant 1

.data
	blank:		.space		100
	blank2:		.space		100
	setPass: 	.asciiz 	"Set a password: " 
	badPass: 	.asciiz 	"Failed. Please enter a password with the size of 6 to 10!\n"
	retryPass: 	.asciiz 	"Re-enter the password: "
	goodPass: 	.asciiz 	"Password is setup."
	twoTry: 	.asciiz 	"Incorrect, you have 2 more chances! Please re-enter the password: "
	oneTry:		.asciiz 	"Incorrect, you have 1 more chance! Please re-enter the password: "
	noTry: 		.asciiz 	"Incorrect, you have no more chances! Password setup has failed."
	
.text

main: 
# Initializing all the values needed.
	li $s0, 6					# min length = 6
	li $s1, 10					# max length = 10
	li $s2, 2					# tries remaining -> 2
	li $s3, 1					# tries remaining -> 1
	li $t7, 3					# number of tries remaining = 3
	j getPassword1				# jump to getPassword1

getPassword1:
	li $t1, 0					# setting length = 0
	li $v0, 4					# load syscall service print_string
	la $a0, setPass				# load syscall argument for print_string
	syscall						# make syscall to print_string
	li $v0, 8					# load syscall service read_string
	la $a0, blank				# load syscall argument for read_string
	syscall						# make syscall to read_string
	move $t0, $a0				# moving user input into register $t0
	move $t5, $t0				# copy of address
	j getLength1				# jump to getLength1
	
getPassword2:
	li $v0, 4					# load syscall service print_string
	la $a0, retryPass			# load syscall argument for print_string
	syscall						# make syscall to print_string
	li $v0, 8					# load syscall service read_string
	la $a0, blank2				# load syscall argument for read_string
	syscall						# make syscall to read_string
	move $t3, $a0				# moving user input into register $t0
	move $t6, $t3				# copy of address
	j checkPassword2			# jump to checkPassword2
	
getLength1:
	lb $t2, 0($t0)				# load the first byte from address in $t0
	beqz $t2, checkPassword1	# if $t2 == 0, then go to checkPassword1
	add $t0, 1					# else increment the address
	add $t1, $t1, 1				# incremenent the counter
	j getLength1				# jump to getLength1
	
checkPassword1:
	sub $t0, $t0, $t1			# returning the address back to the original location
	sub $t1, $t1, 1				# adjustment so the end byte isn't counted
	blt $t1, $s0, passError		# if length < 6, return error and loop
	bgt $t1, $s1, passError		# if length > 10, return error and loop
	j getPassword2				# jump to getPassword2
	
checkPassword2:
	lb $t2, 0($t0)				# load the first byte from address in $t0
	lb $t4, 0($t3)				# load the first byte from address in $t3
	bne $t2, $t4, retryError	# if A[i] != B[i], return error and loop
	add $t0, 1					# else increment the address
	add $t3, 1					# else increment the address
	sub $t1, $t1, 1				# length--
	beqz $t1, goodSetup			# if nothing is bad go to goodSetup
	j checkPassword2			# jump to checkPassword2
	
passError:
	li $v0, 4					# load syscall service print_string
	la $a0, badPass				# load syscall argument for print_string
	syscall						# make syscall to print_string
	j getPassword1				# jump to getPassword1
	
retryError:
	addi $t7, $t7, -1			# numOfTries--
	move $t0, $t5					# restarting address
	move $t3, $t6					# restarting address
	beq $t7, $s2, twoTriesLeft	# if $t7 == 2, go to twoTriesLeft
	beq $t7, $s3, oneTryLeft	# if $t7 == 1, go to oneTryLeft
	beqz $t7, noTriesLeft		# if $t7 == 0, go to noTriesLeft
	
twoTriesLeft:
	li $v0, 4					# load syscall service print_string
	la $a0, twoTry				# load syscall argument for print_string
	syscall						# make syscall to print_string
	j getPassword2				# jump to getPassword2

oneTryLeft:
	li $v0, 4					# load syscall service print_string
	la $a0, oneTry				# load syscall argument for print_string
	syscall						# make syscall to print_string
	j getPassword2				# jump to getPassword2
	
noTriesLeft:
	li $v0, 4					# load syscall service print_string
	la $a0, noTry				# load syscall argument for print_string
	syscall						# make syscall to print_string
	j exit						# jump to getPassword2
	
goodSetup:
	li $v0, 4					# load syscall service print_string
	la $a0, goodPass			# load syscall argument for print_string
	syscall						# make syscall to print_string
	j exit						# jump to exit
	
exit:
	li $v0, 10					# load syscall service end_program
	syscall						# make syscall to end_program
	
	