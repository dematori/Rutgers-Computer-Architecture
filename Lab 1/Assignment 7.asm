# Jeffrey Huang
# Assignment 7

.data
	arrayA: .word 1:10
	arrayB: .word 0:10
	I: .word 2
	J: .word 7
	K: .word 1
.text 

main:
	lw $s1, I
	mul $s1, $s1, 4
	lw $s2, J
	mul $s2, $s2, 4
	lw $s3, K
	mul $s3, $s3, 4
	la $s4, arrayA
	la $s5, arrayB
	addi $t1, $s4($s1), $s4($s2)
	mul $t1, $t1, $s4($s2)
	sw $t1, $s5($s2)
	la $a0, $t0 
	li $v0, 1 			# load syscall print_int into $v0.
	syscall 			# make the syscall.
	li $v0, 10
	syscall