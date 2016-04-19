# Jeffrey Huang
# Used for assignment 8

#ex5.asm

.data 0x10000000
	ask: .asciiz "\nEnter a number:"
	ans: .asciiz "Answer: "
.text 0x00400000
.globl main

main:
	li $v0, 4				
	la $a0, ask				# Loads the ask string
	syscall					# Display the ask string
	li $v0, 5				# Read the input
	syscall
	move $t0, $v0			# n = $v0, Move the user input
	addi $t1, $0, 0			# i = 0
	addi $t2, $0, 189		# ans = 189, Starting case (m = 0)
	li $t3, 2
	
loop:
	beq $t1, $t0, END		# from i = 0 to n-1 (n times)
	addi $t1, $t1, 1		# i = i + 1
	div $t2, $t3			# LO = ans / 2, The result is stored on LO
	mflo $t2				# ans = LO, Copies the content of LO to t2
	j loop

END:
	li $v0, 4				
	la $a0, ans				# Loads the ans string
	syscall
	move $a0, $t2			# Loads the answer
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
# Any value other than 0 will not result in 189 being divided by 2 over
# and over the number of times greater than 0
# ie: input 1 -> 94
# ie: input 2 -> 47
# ie: input 3 -> 23
# ie: input 4 -> 11
# Once the input value is greater than or equal to 8, the value returned
# will be equivalent to 0 regardless of how many times it needs to be 
# divided again.
# Hence the solution to this program is 0.