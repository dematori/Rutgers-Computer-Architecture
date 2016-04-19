# Jeffrey Huang
# RUID: 159004687
# NETID: jh1127
# Assignment 5

# Registers:	$f0  -> user input value
#				$f1  -> value of r
#				$f2  -> value of h
#				$f3  -> value of surface area = PI * r * r + PI * r * SQRT(h * h + r * r)
#				$f4  -> value of volume	= 1 / 3 * PI * r * r * h
#				$f5  -> PI * r
#				$f6  -> PI * r * r
#				$f7  -> SQRT(h * h + x * x)
#				$f8  -> 
#				$f9  -> 
#				$f10 -> 
#				$f11 -> value of pi = 3.14159265359
#				$f12 -> output argument for syscall
#				$f13 -> constant = 0.00001
#				$f14 -> counter starting at 0.00001
#				$f15 -> derivative coefficient = 0.5
#				$f16 -> base = h * h
#				$f17 ->

.data
	inputR:			.asciiz		"Enter value for r: "
	inputH:			.asciiz		"Enter value for h: "
	outputSurface:	.asciiz		"\nSurface area: "
	outputVolume:	.asciiz		"\nVolume: "
.text

main:
## Getting the value of r
	li $v0, 4					# loading syscall service for print_string
	la $a0, inputR				# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 6					# loading syscall service for read_float
	syscall						# making syscall to read_float
	mov.s $f1, $f0				# copying user input to $f1
## Getting the value of h
	li $v0, 4					# loading syscall service for print_string
	la $a0, inputH				# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 6					# loading syscall service for read_float
	syscall						# making syscall to read_float
	mov.s $f2, $f0				# copying user input to $f2
## Calculating the surface area of the cylinder
	li.s $f11, 3.14159265359	# loading the value of pi into $f11
	mul.s $f5, $f11, $f1		# PI * r
	mul.s $f6, $f5, $f1			# PI * r * r
	li.s $f13, 0.00001			# loading 0.00001 into $f13
	li.s $f14, 0.00001			# copying $f13 to $f14 = x_i
	li.s $f15, 0.5				# derivative coefficient = 0.5
	mul.s $f16, $f2, $f2		# h * h
	mul.s $f17, $f1, $f1		# r * r
	add.s $f16, $f16, $f17		# h * h + r * r
squareRoot:
	div.s $f7, $f16, $f14		# (h * h + r * r) / x_i
	add.s $f7, $f7, $f14		# (h * h + r * r) / x_i + x_i
	mul.s $f7, $f15, $f7		# 0.5 * ((h * h + r * r) / x_i + x_i)
	sub.s $f11, $f7, $f14		# 0.5 * ((h * h + r * r) / x_i + x_i) - x_i
	abs.s $f11, $f11			# | 0.5 * ((h * h + r * r) / x_i + x_i) - x_i |
	c.lt.s $f11, $f13			# if | 0.5 * ((h * h + r * r) / x_i + x_i) - x_i | < 0.00001
	bc1t surfaceArea			# then branch to surfaceArea
	mov.s $f14, $f7				# else x_i = x_(i+1)
	j squareRoot				# jump to squareRoot
surfaceArea:
	mul.s $f3, $f7, $f5			# PI * r * SQRT(h * h + x * x)
	add.s $f3, $f6, $f3			# PI * r * r + PI * r * SQRT(h * h + x * x)
## Printing out the surface area of the cylinder
	li $v0, 4					# loading syscall service for print_string
	la $a0, outputSurface		# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 2					# loading syscall service for print_float
	mov.s $f12, $f3				# loading syscall argument for print_float
	syscall						# making syscall to print_float
## Calculating the volume of the cylinder
	li.s $f5, 1.0				# loading numerator into $f5
	li.s $f7, 3.0				# loading denominator into $f7
	div.s $f5, $f5, $f7			# constant of function (1.0 / 3.0)
	mul.s $f4, $f5, $f6			# (1.0 / 3.0) * PI * r * r
	mul.s $f4, $f4, $f2			# (1.0 / 3.0) * PI * r * r * h
## Printing the volume of the cylinder
	li $v0, 4					# loading syscall service for print_string
	la $a0, outputVolume		# loading syscall argument for print_string
	syscall						# making syscall to print_string
	li $v0, 2					# loading syscall service for print_float
	mov.s $f12, $f4				# loading syscall argument for print_float
	syscall						# making syscall to print_float
	li $v0, 10					# loading syscall service for end_program
	syscall						# making syscall to end_program
	