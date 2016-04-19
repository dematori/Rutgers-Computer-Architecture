# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 1

# Registers:	$t0 -> temporary value holder for choice
#				$t1 -> output value
#				$t2 -> 
#				$t3 -> temporary register for computations
#				$t4 -> temporary register for computations
#				$t5 -> temporary register for computations
#				$t6 -> temporary register for computations
#				$t7 -> temporary register for computations
#				$t8 -> 
#				$t9 -> 
#				$s0 -> value of A
#				$s1 -> value of B
#				$s2 -> 
#				$s3 -> 
#				$s4 -> 
#				$s5 -> 


.data
	EnterA: 		.asciiz 	"Enter A: "
	EnterB: 		.asciiz 	"Enter B: "
	Choices: 		.asciiz		"Please select one from the following operations: \n1) A and B,\n2) A or B,\n3) A xnor B,\n4) A xor B,\n5) A nand B,\n6) Exit."
	EnterChoice:	.asciiz		"\nYour choice: "
	Choice1:		.asciiz		"A and B = "
	Choice2:		.asciiz		"A or B = "
	Choice3:		.asciiz		"A xnor B = "
	Choice4:		.asciiz		"A xor B = "
	Choice5:		.asciiz		"A nand B = "
	
.text

main:
## Getting integer A
	li $v0, 4							# loading syscall service for print_string
	la $a0, EnterA						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 5							# loading syscall service for read_int
	syscall								# making syscall for read_int
	move $s0, $v0						# copying user input into register $s0
## Getting integer B
	li $v0, 4							# loading syscall service for print_string
	la $a0, EnterB						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 5							# loading syscall service for read_int
	syscall								# making syscall for read_int
	move $s1, $v0						# copying user input into register $s0
## Printing choices
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choices						# loading syscall argument for print_string
	syscall								# making syscall for print_string
select:
	li $v0, 4							# loading syscall service for print_string
	la $a0, EnterChoice					# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 5							# loading syscall service for read_int
	syscall								# making syscall for read_int
	move $t0, $v0						# copying user input into register $t0
	beq $t0, 1, first					# if choice == 1, branch to first
	beq $t0, 2, second					# if choice == 2, branch to second
	beq $t0, 3, third					# if choice == 2, branch to third
	beq $t0, 4, fourth					# if choice == 2, branch to fourth
	beq $t0, 5, fifth					# if choice == 2, branch to fifth
	beq $t0, 6, exit					# if choice == 6, branch to exit

first:
	#nor $t3, $s0, $s0					# A nor A
	#nor $t4, $s1, $s1					# B nor B
	#nor $t1, $t3, $t4					# (A nor A) nor (B nor B)
	and $t1, $s0, $s1					# A and B
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choice1						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 1							# loading syscall service for print_integer
	move $a0, $t1							# loading syscall argument for print_integer
	syscall								# making syscall for print_integer
	j select							# jump to select
	
second:
	#nor $t3, $s0, $s1					# A nor B
	#nor $t1, $t3, $t3					# (A nor B) nor (A nor B)
	or $t1, $s0, $s1					# A or B
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choice2						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 1							# loading syscall service for print_integer
	move $a0, $t1						# loading syscall argument for print_integer
	syscall								# making syscall for print_integer
	j select							# jump to select

third:
	nor $t3, $s0, $s1					# A nor B
	nor $t4, $s0, $t3					# A nor (A nor B)
	nor $t5, $s1, $t3					# B nor (A nor B)
	nor $t1, $t5, $t4					# (A nor (A nor B)) nor (B nor (A nor B))
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choice3						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 1							# loading syscall service for print_integer
	move $a0, $t1						# loading syscall argument for print_integer
	syscall								# making syscall for print_integer
	j select							# jump to select
	
fourth:
	nor $t3, $s0, $s0					# A nor A -> $t3
	nor $t4, $s1, $s1					# B nor B -> $t4
	nor $t5, $s0, $s1					# A nor B -> $t5
	nor $t6, $t3, $t4					# (A nor A) nor (B nor B)
	nor $t1, $t6, $t5					# ((A nor A) nor (B nor B)) nor (A nor B)
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choice4						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 1							# loading syscall service for print_integer
	move $a0, $t1						# loading syscall argument for print_integer
	syscall								# making syscall for print_integer
	j select							# jump to select
	
fifth:
	nor $t3, $s0, $s0					# A nor A -> $t3
	nor $t4, $s1, $s1					# B nor B -> $t4	
	nor $t5, $t3, $t4					# (A nor A) nor (B nor B)
	nor $t1, $t5, $t5					# ((A nor A) nor (B nor B)) nor ((A nor A) nor (B nor B))
	li $v0, 4							# loading syscall service for print_string
	la $a0, Choice5						# loading syscall argument for print_string
	syscall								# making syscall for print_string
	li $v0, 1							# loading syscall service for print_integer
	move $a0, $t1							# loading syscall argument for print_integer
	syscall								# making syscall for print_integer
	j select							# jump to select
	
exit:
	li $v0, 10							# loading syscall service for end_program
	syscall								# making syscall for end_program