# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 2

.data
		.global	.s32	y[10];		// initializing space for array y
		.global	.s32	z[10];		// initializing space for array z
									// r0 = 64 bit data extending to r1
									// r1 = base address for array x
main:
	add.s32	r2, 0, 0;				// initializing r2 (pos) to 0
	add.s32	r3, 0, 0;				// initializing r3 (neg) to 0
	add.s32 r4, 0, 0;				// initializing r4 (zero) to 0
	add.s32 r5, 1, 0;				// initializing r5 (i) to 1
	add.s32 r7, 0, 0;				// initializing r7 (offset) to 0
	
loop:
	ld.global.s32 r8, [r1+r7];		// load memory value in x[i] into r8
	setp.eq.s32 r6, r8, 0;			// set r6 to r8 == 0
	@r6	bra zero;					// if r8 == 0, branch to zero
	setp.lt.s32 r6, r8, 0;			// set r6 to r8 < 0
	@r6 bra negative;				// if r8 < 0, branch to negative
	@!r6 bra positive;				// if r8 > 0, branch to positive
	
zero:
	add.s32 r4, r4, 1;				// incrementing the zero counter (zero)
	@r6 bra increment;				// branch to increment
	
negative:
	mov.s32 y[r3], r8;				// moving x[i] to y[neg]
	add.s32 r3, r3, 1;				// incrementing the negative counter (neg)
	@r6 bra increment;				// branch to increment
	
positive:
	mov.s32 z[r2], r2;				// moving x[i] to z[pos]
	add.s32 r2, r2, 1;				// incrementing the positive counter (pos)
	@r6 bra increment;				// branch to increment
	
increment:
	add.s32 r7, r7, 4;				// increments offset by 4 for word
	add.s32 r5, r5, 1;				// incrementing i by 1
	setp.le.s32 r6, r5, 10;			// set r6 to i <= 10
	@r6 bra loop;					// branch to loop, if i <= 10
	@!r6 bra end;					// branch to end, if !(i <= 10)
	
end:
	exit;							// ending the program
	