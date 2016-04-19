# Jeffrey Huang
# Assignment 4 Question 3

.data
    buffer: .space 100
    ask:  .asciiz "Please type a string:\n"
    tell:  .asciiz "The string that you entered:\n"

.text

main:
    la $a0, ask		# Load and print string asking for string
    li $v0, 4		# load syscall print_string into $v0	
    syscall			# make the syscall.
    li $v0, 8       # take user input
    la $a0, buffer  # load byte space into address
    li $a1, 100     # allot the byte space for string
    move $t0, $a0   # save string to t0
    syscall			# make the syscall.
    la $a0, tell    # print string with tell header
    li $v0, 4		# load syscall print_string into $v0
    syscall			# make the syscall.
    la $a0, buffer  # reload byte space to primary address
    move $a0, $t0   # primary address = t0 address (load pointer)
    li $v0, 4       # print string
    syscall			# make the syscall.
    li $v0, 10      # syscall code 10 is for exit.
    syscall			# make the syscall.