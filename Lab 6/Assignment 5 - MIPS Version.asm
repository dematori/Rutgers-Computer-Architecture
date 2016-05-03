# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 5

## MIPS Version

.data 
input:		.asciiz		"Enter value of x where 0 <= x <= π/2 : " 
output1:	.asciiz		"\n sinh^-1(x) =  " 
output2:	.asciiz		"\n tanh^-1(x) =  " 
  
.text 
main: 
	li $v0,4 						# loading syscall service to print_string
	la $a0,input 					# loading syscall argument for print_string
	syscall 						# making syscall service to print_string
	li $v0,6 						# loading syscall service to read_float
	syscall 						# making syscall service to read_float
	mov.s $f1, $f0 					# moving user input to $f1
	li.s $f2, 0.3333333 			# initializing value of $f2 to 1/3
	li.s $f3,0.20 					# initializing value of $f3 to 1/5
	li.s $f4,0.142857 				# initializing value of $f4 to 1/7
	li.s $f5, 0.166667 				# initializing value of $f5 to 1/6
	li.s $f6,0.075 					# initializing value of $f6 to 3/40
	li.s $f7, 0.267858 				# initializing value of $f7 to 2/7
## sinh^-1(x)
	mul.s $f8, $f1, $f1				# x^2
	mul.s $f8, $f8, $f1 			# x^3
	mul.s $f9, $f8, $f5 			# x^3/6
	mul.s $f8, $f8, $f1 			# x^4
	mul.s $f8, $f8, $f1 			# x^5
	mul.s $f10, $f8, $f6 			# 3x^5/40	
	mul.s $f8, $f8, $f1 			# x^6
	mul.s $f8, $f8, $f1 			# x^7	
	mul.s $f11, $f8, $f7			# 2x^7/7
	sub.s $f12,$f1,$f9 				# x - x^3/6
	add.s $f12,$f12,$f10 			# x - x^3/6 + 3x^5/40
	sub.s $f12,$f12,$f11 			# x - x^3/6 + 3x^5/40 - 2x^7/7
	li $v0,4 						# loading syscall service to print_string
	la $a0,output1					# loading syscall argument for print_string
	syscall 						# making syscall service to print_string
	li $v0,2 						# loading sysall service to print_float
	syscall 						# making syscall service to print_float
## tanh^-1(x)
	mul.s $f8, $f1, $f1				# x^2
	mul.s $f8, $f8, $f1 			# x^3
	mul.s $f9,$f8,$f2				# x^3/3
	mul.s $f8,$f8,$f1				# x^4
	mul.s $f8,$f8,$f1 				# x^5
	mul.s $f10,$f8,$f3 				# x^5/5
	mul.s $f8,$f8,$f1 				# x^6
	mul.s $f8,$f8,$f1 				# x^7
	mul.s $f11, $f8,$f4 			# x^7/7
	add.s $f12,$f1,$f9 				# x + x^3/3
	add.s $f12,$f12,$f10 			# x + x^3/3 + x^5/5
	add.s $f12,$f12,$f11 			# x + x^3/3 + x^5/5 + x^7/7
	la $a0,output2 					# loading syscall argument to print_string
	li $v0,4 						# loading syscall service to print_string
	syscall							# making syscall service to print_string
	li $v0, 2						# loading syscall argument to print_float
	syscall							# making syscall service to print_float
	li $v0, 10						# loading syscall service to end_program
	syscall							# making syscall service to end_program
