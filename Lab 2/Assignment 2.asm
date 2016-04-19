# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 2

# Pseudocode:	The procedure of the code for finding the largest prime number under 300 is easier to be brute 
#				forced than other methods that involve finding a large prime number. If i need to find multiple
# 				prime numbers then a different method would be more efficient. However, given the condition
#				that the target is going to be less than 300. I primarily found the largest prime number under 
#				300 to be 293. Hence the procedure for finding the prime number involves two loops. The first 
#				loop involves checking the remainder of the number. If the remainder is equal to 0, then the
#				number is not a prime number. As a result, we don't continue checking the number and then 
#				proceed to check the next number. The second loop is check the prime number condition
#				then if the condition is not met, the number that is being checked will be decremented.
#				This process will repeat until the remainder condition is never 0 and then the program will
#				print out the prime number in console.

.text

main:
	li $t0, 299
	li $t1, 2

loop:
	beq $t0, $t1, endloop		# end condition is where if the remainder is the same as the number being checked.
	rem $t2, $t0, $t1			# finds the remainder of the number.
	beq $t2, $0, decrement 		# If during any time the reaminder  is equal to 0, the number is NOT a prime and 
								# decremented.
	add $t1, 1 					# Current divisor does not result in a remainder with the current number. Check
								# a different divisor.
	j loop						# jumps to loop

decrement:
	sub $t0, $t0, 1 			# decrements the current checking number by 1
	li $t1, 2 					# changes the divisor back to the initial value of 2
	j loop						# jumps back to loop

endloop:
	li $v0, 1					# setting the syscall argument to print integer
	move $a0, $t0				# moving the prime number to the argument register
	syscall						# syscall to print the prime number
	li $v0, 10					# setting the syscall argument to end the program
	syscall						# syscall to end the program;
	
