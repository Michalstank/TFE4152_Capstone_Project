`timescale 1ps / 1ps

// Next two modules taken from the lecture power point from 22.10.2025
	
module DFF6NAND(
	input  wire D  , 
	input  wire CLK,
	input  wire RST_n,
	output wire Q  , 
	output wire Qb
	); 
	
	wire o1, o2, o3, o4;
	wire reset_input;

	nand G1(o1, o4, o2);
	nand G2(o2, o1, CLK);
	nand G3(o3, o2, CLK, o4);
	nand G4(o4, o3, reset_input);
	nand G5(Q , o2, Qb);
	nand G6(Qb, Q , o3);
	
	assign reset_input  = RST_n ? D : 1'b0;
endmodule

// Since the state machine has 6 states the lowest needed register count is 3 for a total of 8 options
module REG3DFF6NAND(
	input  wire D1 , 
	input  wire D2 ,
	input  wire D3 ,
	input  wire CLK,
	input  wire RST_n,
	output wire Q1 ,
	output wire Q1N,
	output wire Q2 ,
	output wire Q2N,
	output wire Q3 ,
	output wire Q3N
	);
	
	DFF6NAND DFF1(D1, CLK, RST_n, Q1, Q1N);
	DFF6NAND DFF2(D2, CLK, RST_n, Q2, Q2N);
	DFF6NAND DFF3(D3, CLK, RST_n, Q3, Q3N);
	
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

	wire B_n;
	nand ibb (B_n, B, B);
	
	// Output for A
	// A = S0, B = S1, C = S2
	// !ABC + A!B	
	wire a0, a1;
	
	// A!B
	nand A1_a (a0, S0, S1_n);
	
	// !ABC
	nand A3_a (a1, S0_n, S1, S2);

	// A= !ABC + A!B
	nand A5_a (A, a1, a0);
	
	
	
	// S0
	// !AB!C + A!BD + !B!C!D
	wire s0_0, s0_1, s0_2;
	
	// !AB!C
	nand S0_0(s0_0, S0_n, S1, S2_n);
	
	// A!BD
	nand S0_1(s0_1, S0, S1_n, B);
	
	// !B!C!D
	nand S0_2(s0_2, S1_n, S2_n, B_n);
	
	// S0 =
	nand S0_3(DS0, s0_0, s0_1, s0_2);
	
	
	
	// S1
	// A!B!C!D + !AC!D + !AB!D
	wire s1_0, s1_1, s1_2;
	
	// A!B!C!D
	nand S1_0(s1_0, S0, S1_n, S2_n, B_n);
	
	// !AC!D
	nand S1_1(s1_1, S0_n, S2, B_n);
	
	// !AB!D
	nand S1_2(s1_2, S0_n, S1, B_n);
	
	// S1 =
	nand S1_3(DS1, s1_0, s1_1, s1_2);

	
	
	// S2
	// !ABCD + A!BD + A!BC
	wire s2_0, s2_1, s2_2;
	
	// !ABCD
	nand S2_0(s2_0, S0_n, S1, S2, B);
	
	// A!BD
	nand S2_1(s2_1, S0, S1_n, B);
	
	// A!BC
	nand S2_2(s2_2, S0, S1_n, S2);
	
	// Complete S2
	nand S2_3(DS2, s2_0, s2_1, s2_2);
endmodule

module Tsetlin_FSM (
	input  wire CLK,
	input  wire RST_n,
	input  wire B  , 	 
	output wire A
	);	
	
	wire s1 , s2 , s3, ds1, ds2, ds3;
	wire Q1N, Q2N, Q3N;

	COMB_LOGIC 		comb (B  , s1 , s2 , s3 , Q1N  , Q2N, Q3N, ds1, ds2, ds3, A);
	REG3DFF6NAND 	state(ds1, ds2, ds3, CLK, RST_n, s1 , Q1N, s2 , Q2N, s3, Q3N);
endmodule
