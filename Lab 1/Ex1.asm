# Name : Jeffrey Huang

# Exercise 1 is used in assignments 1 and 2

.data 0x10000000
.text 0x00400000
.globl main

main:
	addi $10,  $0, 8						# add immediate : $10 = $0 + 8
	li $11, 6								# Place (load immediate) 6 into register $11.
	# calculate the $11 -th power of $10
	add $8, $0, $10							# add : $8 = $0 + $10
	li $12, 2								# load 2 into $12
	
powerloop:
	bgt $12, $11, powerexit					# go to powerexit if $12 > $11
	sub $11, $11, 1							# subtract : $11 = $11 - 1
	mul $10, $10, $8						# multiply : $10 = $10 * $8
	j powerloop								# jump to powerloop
	
powerexit:
	# power operation loop is over
	# Is the result in $10 correct? The result in $10 is hexadecimal
	li $2, 10								# load 10 into $2
	syscall									# End program