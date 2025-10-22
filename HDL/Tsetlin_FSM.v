`timescale 1ps / 1ps

// Next two modules taken from the lecture power point from 22.10.2025
	
module DFF6NAND(
	input  wire D  , 
	input  wire CLK, 
	output wire Q  , 
	output wire Qb
	);
	
	wire o1, o2, o3, o4;

	nand G1(o1, o4, o2);
	nand G2(o2, o1, CLK);
	nand G3(o3, o2, CLK, o4);
	nand G4(o4, o3, D);
	nand G5(Q , o2, Qb);
	nand G6(Qb, Q , o3);
	
endmodule

// Since the state machine has 6 states the lowest needed register count is 3 for a total of 8 options
module REG3DFF6NAND(
	input  wire D1 , 
	input  wire D2 ,
	input  wire D3 ,
	input  wire CLK,
	output wire Q1 ,
	output wire Q1N,
	output wire Q2 ,
	output wire Q2N,
	output wire Q3 ,
	output wire Q3N
	);
	
	DFF6NAND DFF1(D1, CLK, Q1, Q1N);
	DFF6NAND DFF2(D2, CLK, Q2, Q2N);
	DFF6NAND DFF3(D3, CLK, Q3, Q3N);
	
endmodule

module COMB_LOGIC(
	input  wire B  ,
	input  wire S0 ,
	input  wire S1 ,
	input  wire S2 ,
	input  wire S0_n,
	input  wire S1_n,
	input  wire S2_n,
	output wire DS0,
	output wire DS1,
	output wire DS2,
	output wire A
	);
	
	// Output for A
	// A = S0, B = S1, C = S2
	// !ABC + A!B
	
	wire o0, o1, o2, o3, o4, o5, o6, o7, o8, o9;
	
	// Used for state bit updates
	wire x0, x1, x2;
	wire y0, y1, y2;
	wire z0, z1, z2;
	wire i_b, ib;
	
	// !ABC
	nand A1 (o0, S0, S0);
	nand A2 (o1, S1, S2);
	nand A3 (o2, o1, o1);
	nand A4 (o3, o2, o0);
	nand A5 (o4, o3, o3);
	
	// A!B
	nand A6 (o5, S1, S1);
	nand A7 (o6, o5, S0);
	nand A8 (o7, o6, o6);
	
	// !ABC + A!B
	nand A9 (o8, o4, o4);
	nand A10(o9, o7, o7);
	nand A11(A , o8, o9);
	
	// State Taransitions
	
	nand ii_b(i_b, B, B);
	nand iib (ib , i_b, i_b);
	
	// S0
	// !AB!C + A!BD + !B!C!D
	// Not performing the double inversion needed for an AND gate since the end is an OR gate

	//!AB!C
	nand s0_0(x0, S0_n, S1, S2_n);

	// A!BD					  
	nand s0_1(x1, S0, S1_n, B);
	
	// !B!C!D
	nand s0_2(x2, S1_n, S2_n, ib);
	
	// Complete S0
	nand s0_3(DS0, x0, x1, x2);
	
	// S1
	// A!B!C!D + !AC!D + !AB!D
	
	// A!B!C!D
	nand s1_0(y0, S0, S1_n, S2_n, ib);
	
	// !AC!D
	nand s1_1(y1, S0_n, S2, ib);

	// !AB!D
	nand s1_2(y2, S0_n, S1, ib);
	
	// Complete S1
	nand s1_3(DS1, y0, y1, y2);
	
	// S2
	// !ABCD + A!BD + A!BC
	
	// !ABCD
	nand s2_0(z0, S0_n, S1, S2, B);
	
	// A!BD
	nand s2_1(z1, S0, S1_n, B);
	
	// A!BC
	nand s2_2(z2, S0, S1_n, S2);
	
	// Complete S2
	nand s2_3(DS2, z0, z1, z2);
endmodule

module Tsetlin_FSM (
	input  wire CLK, 
	input  wire B  , 	 
	output wire A
	);	
	
	wire s1 , s2 , s3, ds1, ds2, ds3;
	wire Q1N, Q2N, Q3N;	

	COMB_LOGIC 	comb (B , s1, s2, s3, Q1N, Q2N, Q3N, ds1, ds2, ds3, A);
	REG3DFF6NAND 	state(ds1, ds2, ds3, CLK, s1 , Q1N, s2 , Q2N, s3, Q3N);
endmodule
