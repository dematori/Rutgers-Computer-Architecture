# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 4

# Registers:	$f0  -> user input value
#				$f1  -> value for m
#				$f2  -> value for n
#				$f3  -> value for p
#				$f4  -> value for starting point = x
#				$f5  -> value for x_i
#				$f6  -> value of cons. = 0.00001
#				$f7  -> x ^ 2 -> m * x ^ 2 -> m * x ^ 2 + n * x + p -> value for x_(i+1)
#				$f8  -> n * x -> 2.0 -> x_(i+1) - x_i
#				$f9  -> m * x
#				$f10 -> 
#				$f11 ->
#				$f12 -> output argument for syscall

.data
	inputM:		.asciiz		"Enter value for m: "
	inputN:		.asciiz		"Enter value for n: "
	inputP:		.asciiz		"Enter value for p: "
	inputX:		.asciiz		"Enter starting point, x: "
	output:		.asciiz		"The answer is: "
	
.text

main:
## Getting the value of m
	li.s $f6, 0.00001				# loading 0.00001 as constant (cons.)
	li $v0, 4						# loading syscall service for print_string
	la $a0, inputM					# loading syscall argument for print_string
	syscall							# making syscall to print_string
	li $v0, 6						# loading syscall service for read_float
	syscall							# making syscall to read_float
	mov.s $f1, $f0					# copying user input to $f1
## Getting the value of n
	li $v0, 4						# loading syscall service for print_string
	la $a0, inputN					# loading syscall argument for print_string
	syscall							# making syscall to print_string
	li $v0, 6						# loading syscall service for read_float
	syscall							# making syscall to read_float
	mov.s $f2, $f0					# copying user input to $f2
## Getting the value of p
	li $v0, 4						# loading syscall service for print_string
	la $a0, inputP					# loading syscall argument for print_string
	syscall							# making syscall to print_string
	li $v0, 6						# loading syscall service for read_float
	syscall							# making syscall to read_float
	mov.s $f3, $f0					# copying user input to $f3
## Getting the value of x	
	li $v0, 4						# loading syscall service for print_string
	la $a0, inputX					# loading syscall argument for print_string
	syscall							# making syscall to print_string
	li $v0, 6						# loading syscall service for read_float
	syscall							# making syscall to read_float
	mov.s $f4, $f0					# copying user input to $f3
## Setting the value of x_i
	mov.s $f5, $f4					# copying the value of $f4 to $f5
	
loop:
## Getting value of f(x)
	mul.s $f7, $f4, $f4				# x * x = x ^ 2
	mul.s $f7, $f7, $f1				# m * x * x = m * x ^ 2
	mul.s $f8, $f2, $f4				# n * x
	add.s $f7, $f7, $f8				# m * x ^ 2 + n * x
	add.s $f7, $f7, $f3				# m * x ^ 2 + n * x + p = f(x)
## Getting value of f'(x)
	li.s $f8, 2.0					# $f8 -> 2.0
	mul.s $f8, $f1, $f8				# m * x
	mul.s $f8, $f4, $f8				# 2 * m * x
	add.s $f8, $f8, $f2				# 2 * m * x + n = f'(x)
## Getting value of x_(i + 1)
	div.s $f8, $f7, $f8				# f(x) / f'(x)
	sub.s $f5, $f5, $f8				# x_(i+1) = x_i - f(x) / f'(x)
	sub.s $f9, $f5, $f4				# x_(i+1) - x_i
	abs.s $f9, $f9					# | x_(i+1) - x_i |
	c.lt.s $f9, $f6					# if | x_(i+1) - x_i | < 0.00001
	bc1t printOutput				# then printOutput
	mov.s $f4, $f5					# else x_i = x_(i+1) 
	j loop							# jump to loop
	
printOutput:
	li $v0, 4						# loading syscall service for print_string
	la $a0, output					# loading syscall argument for print_string
	syscall							# making syscall to print_string
	li $v0, 2						# loading syscall service for print_float
	mov.s $f12, $f5					# loading syscall argument for print_float
	syscall							# making syscall to print_float
	j exit							# jump to exit
exit:
	li $v0, 10						# loading syscall service for end_program
	syscall							# making syscall to end_program

