# Jeffrey Huang
# RUID: 159-00-4687
# NETID: jh1127
# Assignment 5

## PTX ISA Version

.data
// Assuming that r1 contains the value of x where x exists in the [0,π/2]
main:
	div.f32 r2, 1, 3					// initializing value of $r2 to 1/3
	div.f32 r2, 1, 5					// initializing value of $r2 to 1/5
	div.f32 r2, 1, 7					// initializing value of $r2 to 1/7
	div.f32 r2, 1, 6					// initializing value of $r2 to 1/6
	div.f32 r2, 3, 40					// initializing value of $r2 to 3/40
	div.f32 r2, 2, 7					// initializing value of $r2 to 2/7
	
// sinh^-1(x)
mul.f32 $r8, $r1, $r1;					// x^2
	mul.f32 $r8, $r8, $r1; 				// x^3
	mul.f32 $r9, $r8, $r5; 				// x^3/6
	mul.f32 $r8, $r8, $r1; 				// x^4
	mul.f32 $r8, $r8, $r1; 				// x^5
	mul.f32 $r10, $r8, $r6; 			// 3x^5/40	
	mul.f32 $r8, $r8, $r1; 				// x^6
	mul.f32 $r8, $r8, $r1; 				// x^7	
	mul.f32 $r11, $r8, $r7;				// 2x^7/7
	sub.f32 $r63,$r1,$r9; 				// x - x^3/6
	add.f32 $r63,$r63,$r10; 			// x - x^3/6 + 3x^5/40
	sub.f32 $r63,$r63,$r11; 			// x - x^3/6 + 3x^5/40 - 2x^7/7

// tanh^-1(x)
	mul.f32 $r8, $r1, $r1;				// x^2
	mul.f32 $r8, $r8, $r1; 				// x^3
	mul.f32 $r9,$r8,$r2;				// x^3/3
	mul.f32 $r8,$r8,$r1;				// x^4
	mul.f32 $r8,$r8,$r1; 				// x^5
	mul.f32 $r10,$r8,$r3; 				// x^5/5
	mul.f32 $r8,$r8,$r1; 				// x^6
	mul.f32 $r8,$r8,$r1; 				// x^7
	mul.f32 $r11, $r8,$r4; 				// x^7/7
	add.f32 $r64,$r1,$r9; 				// x + x^3/3
	add.f32 $r64,$r64,$r10; 			// x + x^3/3 + x^5/5
	add.f32 $r64,$r64,$r11; 			// x + x^3/3 + x^5/5 + x^7/7
	exit;
	
// The PTX ISA Version of the MIPS code that accomplishes the same thing still takes 
// about the same amount of time since there is no need to print or take input from.