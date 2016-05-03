// Jeffrey Huang
// RUID: 159-00-4687
// NETID: jh1127
// Assignment 3

// PTX ISA Version

.data
	
main:
//	add.u32 r1, 0, 10;		// given that n is already stored into r1
	add.f32	r2, 0, 0;		// initialize r2 as 0 -> output register
	add.f32 r3, 1, 0;		// initialize r3 as 1 -> factorial = k!
	
loop:
	cvt.f32.u32, r4, r1;	// converting counter to floating counter
factLoop:
	mul.f32 r3, r3, r4;		// r4 * r3
	sub.f32 r4, r4, 1.0;	// decrement r4 by 1
	set.lt.f32 r5, r4, 0;	// set r5 to r4 < 0
	@r5 bra summation;		// branch to summation if r4 < 0
	@!r5 bra factLoop;		// branch to factLoop if !(r4 < 0)
summation:
	rcp.f32 r6, r3;			// 1 / k!
	add.f32 r2, r2, r6;		// 1 / (k-1)! + 1 / k!
	sub.f32	r1, r1, 1.0;	// decrementing r1 by 1
	setp.eq.s32 r5, r1, 0;	// set r5 to r1 == 0
	@r5 bra endProgram;		// branch to printOutput if r1 == 0
	@!r5 bra loop;			// branch to loop if r1 != 0
endProgram:
	exit;					// end the program
	