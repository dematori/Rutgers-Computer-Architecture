# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 6

# Registers:	$t0 -> hex string provided by user
#				$t1 -> temporary byte holder for hex string
#				$t2 -> copy of $t0 address
#				$t3 -> determines if input is good hexadecimal
#				$t4 -> hexadecimal value is a number 0 - 9
#				$t5 -> hexadecimal value is a letter A - F
#				$t6 -> temporary truth value holder
#				$t7 -> temporary truth value holder
#				$t8 -> counter for power
#				$t9 -> factor for division
#				$s0 -> output string in binary of hex
#				$s1 -> copy of original address of $s0

.data
	hex:		.asciiz		"Hex string: "
	binary:		.asciiz		"Its binary value: "
	badHex:		.asciiz		"Invalid hex string"
	zero:		.asciiz		"0"
	one:		.asciiz		"1"
	space:		.asciiz		" "
	
.text

main:
## Getting user hex string input
	li $v0, 4					# load syscall service print_string
	la $a0, hex					# load syscall argument for print_string
	syscall						# make syscall for print_string
	li $v0, 8					# load syscall service read_string
	syscall						# make syscall for read_string
	move $t0, $a0				# moving user input to register $t0
	move $t2, $t0					# copying original address to register $t1
	j check						# jump to check
	
check:
	lb $t1, 0($t0)				# load byte from address to register $t1
	beq $t1, 10, startConvert		# if $t1 == 0, branch to startConvert
	add $t0, 1					# increment address by 1
	sge $t6, $t1, '0'			# ch >= '0'
	sle $t7, $t1, '9'			# ch <= '9'
	and $t4, $t6, $t7			# (ch >= '0' && ch <= '9')
	sge $t6, $t1, 'A'			# ch >= 'A'
	sle $t7, $t1, 'F'			# ch <= 'F'
	and $t5, $t6, $t7			# (ch >= 'A' && ch <= 'F')
	or $t3, $t4, $t5			# (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'F')
	beqz $t3, badExit			# if $t3 == 0, branch to badExit
	j check						# jump to check
	
startConvert:
	move $t0, $t2				# putting original address back to register $t0
	li $v0, 4					# load syscall service print_string
	la $a0, binary				# load syscall argument for print_string
	syscall						# make syscall for print_string
	j convert					# jump to convert
	
convert:
	move $t4, $zero				# clearing register
	move $t5, $zero				# clearing register
	lb $t1, 0($t0)				# load byte from address to register $t1
	beq $t1, 10, goodExit		# if $t1 == 10, branch to goodExit
	add $t0, 1					# increment address by 1
	li $t8, 3					# counter = 3
	sge $t6, $t1, '0'			# ch >= '0'
	sle $t7, $t1, '9'			# ch <= '9'
	and $t4, $t6, $t7			# (ch >= '0' && ch <= '9')
	beqz $t4, convertChar		# if $t4 == 0, branch to convertChar
	sge $t6, $t1, 'A'			# ch >= 'A'
	sle $t7, $t1, 'F'			# ch <= 'F'
	and $t5, $t6, $t7			# (ch >= 'A' && ch <= 'F')
	beqz $t5, convertNum		# if $t5 == 0, branch to convertNum


convertNum:
	sub $t1, $t1, 48			# ascii offset for 0- 9
	j convertToBin				# jump to convertToBin
	
convertChar:
	sub $t1, $t1, 55			# ascii offset for A - F
	j convertToBin				# jump to convertToBin
	
convertToBin:
	bltz $t8, printSpace		# if $t8 < 0, branch to convert
	sub $t8, $t8, 1				# $t8--
	move $t4, $t8				# load counter to temporary counter
	li $t9, 1					# initializing factor
	j factor					# jump to factor	
	
factor:
	bltz $t4, checkFactor		# if $t4 < 0, branch to checkFactor
	sub $t4, $t4, 1				# $t4--
	mul $t9, $t9, 2				# 2 ^ n
	j factor					# jump to factor
	
checkFactor:
	bgt $t1, $t9, printOne		# if $t1 > $t9, branch to printOne
	blt $t1, $t9, printZero		# if $t1 < $t9, branch to printZero
	beq $t1, $t9, printOne		# if $t1 = $t9, branch to printOne
	
printOne:
	sub $t1, $t1, $t9			# $t1 = $t1 - $t9
	li $v0, 4					# load syscall service print_string
	la $a0, one					# load syscall argument for print_string
	syscall						# make syscall for print_string
	j convertToBin				# jump to convertToBin
	
printZero:
	li $v0, 4					# load syscall service print_string
	la $a0, zero				# load syscall argument for print_string
	syscall						# make syscall for print_string
	j convertToBin				# jump to convertToBin
	
printSpace:
	li $v0, 4					# load syscall service print_string
	la $a0, space				# load syscall argument for print_string
	syscall						# make syscall for print_string
	j convert					# jump to convert
	
badExit:
	li $v0, 4					# load syscall service print_string
	la $a0, badHex				# load syscall argument for print_string
	syscall						# make syscall for print_string
	li $v0, 10					# load syscall service end_program
	syscall						# load syscall for end_program
	
goodExit:
	li $v0, 10					# load syscall service end_program
	syscall						# make syscall for end_program
	
	
	