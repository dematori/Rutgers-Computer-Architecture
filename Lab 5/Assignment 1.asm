# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 1

# Calculate the sum of even numbers inside a given array

			.data 0x10000480
ArrayA:		.word 1, 2, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144
	
			.text
			.globl main
main:
	la $t1, ArrayA
	li $t2, 0						# counter = 0
	li $t3, 12						# number of elements in ArrayA
	li $t4, 1						# mask
	loop:
		lw $t5, 0($t1)
		and $t6, $t5 $t4
		beq $t6, $t4, cont
		add $t2, $t2, $t5
	cont:
		addi $t1, $t1, 4
		addi $t3, $t3, -1
		bgt $t3, $0, loop
	
	li $v0, 10
	syscall
	
## ASSIGNMENT 1 PROBLEMS:
#		(a)  PC      = 00000000   EPC     = 00000000   Cause   = 00000000   BadVAddr= 00000000
#			 Status  = 3000ff10   HI      = 00000000   LO      = 00000000
#				General Registers
#			R0  (r0) = 00000000  R8  (t0) = 00000000  R16 (s0) = 00000000  R24 (t8) = 00000000
#			R1  (at) = 00000000  R9  (t1) = 100004b0  R17 (s1) = 00000000  R25 (t9) = 00000000
#			R2  (v0) = 0000000a  R10 (t2) = 000000bc  R18 (s2) = 00000000  R26 (k0) = 00000000
#			R3  (v1) = 00000000  R11 (t3) = 00000000  R19 (s3) = 00000000  R27 (k1) = 00000000
#			R4  (a0) = 00000000  R12 (t4) = 00000001  R20 (s4) = 00000000  R28 (gp) = 10008000
#			R5  (a1) = 00000000  R13 (t5) = 00000090  R21 (s5) = 00000000  R29 (sp) = 7fffe428
#			R6  (a2) = 7fffe430  R14 (t6) = 00000000  R22 (s6) = 00000000  R30 (s8) = 00000000
#			R7  (a3) = 00000000  R15 (t7) = 00000000  R23 (s7) = 00000000  R31 (ra) = 00000000

#			FIR    = 00009800    FCSR    = 00000000    FCCR   = 00000000   FEXR    = 00000000
#			FENR   = 00000000
#			      Double Floating Point Registers
#			FP0  = 0.000000      FP8  = 0.000000      FP16 = 0.000000      FP24 = 0.000000     
#			FP2  = 0.000000      FP10 = 0.000000      FP18 = 0.000000      FP26 = 0.000000     
#			FP4  = 0.000000      FP12 = 0.000000      FP20 = 0.000000      FP28 = 0.000000     
#			FP6  = 0.000000      FP14 = 0.000000      FP22 = 0.000000      FP30 = 0.000000     
#			      Single Floating Point Registers
#			FP0  = 0.000000      FP8  = 0.000000      FP16 = 0.000000      FP24 = 0.000000     
#			FP1  = 0.000000      FP9  = 0.000000      FP17 = 0.000000      FP25 = 0.000000     
#			FP2  = 0.000000      FP10 = 0.000000      FP18 = 0.000000      FP26 = 0.000000     
#			FP3  = 0.000000      FP11 = 0.000000      FP19 = 0.000000      FP27 = 0.000000     
#			FP4  = 0.000000      FP12 = 0.000000      FP20 = 0.000000      FP28 = 0.000000     
#			FP5  = 0.000000      FP13 = 0.000000      FP21 = 0.000000      FP29 = 0.000000     
#			FP6  = 0.000000      FP14 = 0.000000      FP22 = 0.000000      FP30 = 0.000000     
#			FP7  = 0.000000      FP15 = 0.000000      FP23 = 0.000000      FP31 = 0.000000     

#		(b) Set		V	LRU		Tag(h)	Data (h) Way 0							Acc
#			0		1	0		400012	00000001 00000001 00000002 00000003		
#			1		1	0		400012	00000005 00000008 0000000d 00000015
#			2		1	0		400012	00000022 00000037 00000059 00000090		hit
#			3		0	0		400012
#			EXPLANATION: 	The cache maps the elements of Array_A as a hexadecimal value in each slot.
#							Where each set of the cache is capable of storing up to 126 bits of information.
#							126 bits of information is equivalent to 4 hexadecimal values of size 8. 
#							The first bit in the data determins if the data is a hit or miss, but where when
#							the data is being retrieved from memory through a tag that is assigned to cache.
#							In my opinion, the cache is just a sorter that guides the assembler to the right
#							memory address. Since we have a 256-bit, and a 4-way set, we have 256 divided by 4
#							which gives us 64 bits divided by 4 which gives us 16 bits per cache line. So when
#							the decyption of .data, the last two four bits are the cache address, the next two
#							least significant bits are the index, the and the first two bits are ignored as well.
#							Thus, the .data 0x10000480 can be converted to binary which results in:
#							0001 0000 0000 0000 0000 0100 1000 0000. With the bits removed as mentioned above, we
#							get 0100 0000 0000 0000 0001 0010. Which will result in the tag of 400012. Once the
#							Data (h) Way 0 is filled, the tag will increment to 400013 which is a incremented by 4
#							in binary.

#		(c) Set		V	Tag (h)		Instructions (h)
#			0		1	8000		lui $1, 4096
#			1		1	8000		ori $9, $1, 1152
#			2		1	8000		ori $10, $0, 0
#			3		1	8000		ori $11, $0, 12
#			4		1	8000		ori $12, $0, 1
#			5		1	8000		lw $13, 0($9)
#			6		1	8000		and $14, $13,$12
#			7		1	8000		beq $14, $12, 8
#			8		1	8000		add $10, $10, $13
#			9		1	8000		addi $9, $9, 4
#			10		1	8000		addi $11, $11, -1
#			11		1	8000		slt $1, $0, $11
#			12		1	8000		bne $1, $0, -28
#			13		1	8000		ori $2, $0, 10
#			14		1	8000		8000
#			EXPLANATION:	The contents of the instruction cache obtains the instructions through reading
#							the actual program and converting the user registers to the machine registers.
#							These values of the instruction cache are acquired from the moment the instruction
#							is read, determined if the instruction is valid or not. If the instructino is valid,
#							the cache will miss and then store the instruction into the instruction cache. The
#							number of access is 96 because of the loops that access the number of times to run
#							run the program. Then the number of hits is the number of times that the instruction
#							accessed from the cache.
