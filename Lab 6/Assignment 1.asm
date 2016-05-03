// Jeffrey Huang
// RUID: 159-00-4687
// NETID: jh1127
// Assignment 1

.data
	.reg	.s32	r2, r3, r4, r5;			// a, b, c, d = r10, r11, r12, r13
	.global	.s32	e[10];					// initializing space for array e
	.global .s32	f[10];					// intializing space for array f
	
main:
	add.s32 r0, 10, 0;						// initializing r0 (n) to 10
	add.s32 r1, 0, 0;						// initializing r1 (i) to 0
	add.s32 r2, 0, 0;						// initializing r2 (a) to 0
	add.s32 r3, 0, 0;						// initializing r3 (b) to 0
	add.s32 r4, 0, 0;						// initializing r4 (c) to 0
	add.s32 r5, 0, 0;						// initializing r5 (d) to 0
	
loop:
	setp.lt.s32 r6, r1, r0;					// set r6 to r1 < r0 
	@!r6 bra end;							// branch to end, if r1 (i) < r0 (n = 10)
	mul.s32 r7, r2, r3;						// r7 = r2(a) * r3(b)
	mul.s32 r8, r4, r5;						// r8 = r2(c) * r5(d)
	sub.s32 r9, r7, r8;						// r9 = r7 - r8 = (a * b) - (c * d)
	add.s32 r7, r7, r8;						// r7 = r7 + r8 = (a * b) + (c * d)
	mov.s32 e[r1], r9;						// moving r9 to e[i]
	mov.s32 f[r1], r7;						// moving r7 to f[i]
	add.s32 r2, r2, r3;						// a = a + b
	add.s32 r4, r4, r5;						// c = c + d
	add.s32 r1, r1, 1;						// i++
	@r6 bra loop;							// branch to loop, if !(i < n)
	
end:
	exit;									// ending the program