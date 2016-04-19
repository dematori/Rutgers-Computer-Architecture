# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 4

# Registers:	$t0 -> n -> number of lines to be printed
#				$t1 -> h -> half the number of lines
#				$t2 -> s -> number of spaces to be printed
#				$t3 -> a -> number of asterisks to be printed
#				$t4 -> 
#				$t5 -> 
#				$t6 -> remainder from checker
#				$t7 -> number for even/odd checker
#				$s0 -> i -> counter

.data
	input: .asciiz "The number of lines? "
	asterisk: .asciiz "*"
	space: .asciiz " "
	newLine: .asciiz "\n"

.text

main:
## Initializing the base values
	li $s0, 1					# loading initial value of i
	li $t7, 2					# loading initial value of 2

	
## Get number of lines from user
	li $v0, 4					# load syscall service print_string
	la $a0, input				# load syscall argument for print_string
	syscall						# make syscall to print_string
	li $v0, 5					# load syscall service read_int
	syscall						# make syscall to read_int
	move $t0, $v0				# move number read into register $t0
	beqz $t0, exit				# if $t0 == 0, branch to exit
	addi $t1, $t0, 1			# n + 1
	div $t1, $t1, 2				# (n + 1) / 2
	j topLoop					# jump to topLoop
	
topLoop:
	bgt $s0, $t1, adjustment	# if i > half, branch to adjustment
	sub $t2, $t1, $s0			# (h - i) -> number of spaces
	mul $t3, $s0, 2				# (2 * i)
	sub $t3, $t3, 1				# (2 * i) - 1 -> number of asterisks
	j printSpacesTop			# jump to printSpacesTop
	
adjustment:
	rem $t6, $t0, $t7			# i % 2
	sub $s0, $s0, 1				# i = i - 1
	beqz $t6, botLoop			# i % 2 == 0
	sub $s0, $s0, 1				# i = i - 1
	bnez $t6, botLoop			# i % 2 != 0
	
botLoop:
	beqz $s0, exit				# if i == 0, branch to adjustment
	sub $t2, $t1, $s0			# (h - i) -> number of spaces
	mul $t3, $s0, 2				# (2 * i)
	sub $t3, $t3, 1				# (2 * i) - 1 -> number of asterisks
	j printSpacesBot
	
printSpacesTop:
	beqz $t2, printStarsTop		# if $t2 == 0, branch to printStars
	li $v0,4 					# load syscall service print_string
	la $a0, space				# load syscall argument for print_string
	syscall						# make syscall to print_string
	sub $t2, $t2, 1				# $t2--;
	j printSpacesTop			# jump to printSpacesTop
	
printStarsTop:
	beqz $t3, printNewLineTop	# if $t3 == 0, branch to printStars
	li $v0,4 					# load syscall service print_string
	la $a0, asterisk			# load syscall argument for print_string
	syscall						# make syscall to print_string
	sub $t3, $t3, 1				# $t3--;
	j printStarsTop				# jump to printStarsTop

printNewLineTop:
	li $v0,4 					# load syscall service print_string
	la $a0, newLine				# load syscall argument for print_string
	syscall						# make syscall to print_string
	addi $s0, $s0, 1			# i++	
	j topLoop					# jump to topLoop
	
printSpacesBot:
	beqz $t2, printStarsBot		# if $t2 == 0, branch to printStars
	li $v0,4 					# load syscall service print_string
	la $a0, space				# load syscall argument for print_string
	syscall						# make syscall to print_string
	sub $t2, $t2, 1				# $t2--;
	j printSpacesBot			# jump to printSpacesBot
	
printStarsBot:
	beqz $t3, printNewLineBot	# if $t3 == 0, branch to printStars
	li $v0,4 					# load syscall service print_string
	la $a0, asterisk			# load syscall argument for print_string
	syscall						# make syscall to print_string
	sub $t3, $t3, 1				# $t3--;
	j printStarsBot				# jump to printStarsBot
	
printNewLineBot:
	li $v0,4 					# load syscall service print_string
	la $a0, newLine				# load syscall argument for print_string
	syscall						# make syscall to print_string
	sub $s0, $s0, 1				# i--
	j botLoop					# jump to botLoop
	
exit:
	li $v0, 10					# load syscall service end_program
	syscall						# make syscall to end_program
	