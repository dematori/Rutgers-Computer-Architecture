# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# branch.asm - Loop and Branches Program
# Registers used:
# $t0 - used to hold the number of iteration
# $t1 - used to hold the counter value in each iteration
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter -- the string to print.

.text

main:
	li $t0, 5					# init the number of loop.
	li $t1, 0					# init the counter of the loop
	
loop:
	beq $t0, $t1, endloop		# if $t0 == $t1 then go to endloop
	addi $t1, $t1, 1			# increment the counter, i.e. $t1++
	b loop						# branch to loop label
	
endloop:
	li $v0, 10					# 10 is the exit syscall.
	syscall
	
# Note for Assignment 1
# "beq $t0, $t1, endloop" -> the loop will execute 6 times
# 	Reason: branch to endloop if $t0 == $t1
# "blt $t0, $t1, endloop" -> the loop will execute 7 times
# 	Reason: branch to endloop if $t0 < $t1
# "bge $t0, $t1, endloop" -> the loop will execute 0 times
# 	Reason: branch to endloop if $t0 >= $t1
# "bnez $t1, endloop" -> the loop will execute 1 time
# 	Reason: branch to endloop if $t1 != 0

