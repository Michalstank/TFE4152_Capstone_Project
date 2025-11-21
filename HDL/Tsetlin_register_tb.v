`timescale 1ps / 1ps
`include "Tsetlin_FSM.v"

module tb_Register;
	reg d1, d2, d3;
	wire q1, q2, q3, q1n, q2n, q3n;
	reg clk, reset;
	integer err = 0;	
	
	REG3DFF6NAND state(
		.D1 	(d1) ,
		.D2 	(d2) ,
		.D3 	(d3) ,
		.CLK 	(clk),
		.RST_n	(reset),
		.Q1 	(q1) ,
		.Q2 	(q2) ,
		.Q3 	(q3) ,
		.Q1N 	(q1n),
		.Q2N 	(q2n),
		.Q3N 	(q3n)
	);
	
	// Clock Declaration
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	// Iterate over all possible forms of input with a for loop
	integer i;
	initial begin
		$display("REG3DFF6NAND Test Start...");
		
		$display("LOG: REG3DFF6NAND at i = %0d, d = %d %d %d, q = %d %d %d, clk = %d", i, d3, d2, d1, q3, q2, q1, $time);
		reset = 1'b0;
		#10;
		reset = 1'b1;
		
		for (i = 0; i < 8; i = i + 1) begin
			d1 = i[0];
			d2 = i[1];
			d3 = i[2];
			
			
			wait(clk == 1);
			
			if(d1 != q1 || d2 != q2 || d3 != q3) begin
				$error("ERROR: REG3DFF6NAND at i = %0d, d = %d %d %d, q = %d %d %d, clk = %d", i, d3, d2, d1, q3, q2, q1, $time);
				err = err + 1;
			end	else
			$display("LOG: REG3DFF6NAND at i = %0d, d = %d %d %d, q = %d %d %d, clk = %d", i, d3, d2, d1, q3, q2, q1, $time);
			
			wait(clk == 0);
		end
	
		$display("REG3DFF6NAND Test Completed with %0d errors.", err);
		$finish;
	end
endmodule