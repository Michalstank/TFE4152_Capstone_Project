`timescale 1ps / 1ps
`include "Tsetlin_FSM.v"

module tb_Output_Signal;	
	reg d1, d2, d3, d1_n, d2_n, d3_n;
	wire q1, q2, q3;
	reg clk, a;
	integer err = 0;
	
	//Placeholder signals
	reg b;
	wire ds0, ds1, ds2;
	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end	 
	
	COMB_LOGIC out_a_test(
		.B 		(b)	  ,
		.S0 	(d1)  ,
		.S1 	(d2)  ,
		.S2 	(d3)  ,
		.S0_n 	(d1_n),
		.S1_n 	(d2_n),
		.S2_n 	(d3_n),
		.DS0 	(ds0),
		.DS1 	(ds1),
		.DS2 	(ds2),
		.A 		(a)
	);
	
	integer i;
	initial begin
		$display("Output signal Test Start...");
		
		for (i = 0; i < 6; i = i + 1) begin
			d1 = i[2];
			d2 = i[1];
			d3 = i[0];
			
			d1_n = ~i[2];
			d2_n = ~i[1];
			d3_n = ~i[0];
			
			wait(clk);
			
			if (((i >= 3) && !a) || ((i < 3) && a)) begin
				err = err + 1;
				$error("ERROR tb_Output_Signal at i = %0d, d = %d %d %d, a = %d, clk = %d", i, d1, d2, d3, a, $time);
			end	else
				$display("LOG tb_Output_Signal at i = %0d, d = %d %d %d, a = %d, clk = %d", i, d1, d2, d3, a, $time);
			
			wait(!clk);
		end
		
		$display("Output Signal Test Completed with %0d errors.", err);
		$finish;
	end
endmodule