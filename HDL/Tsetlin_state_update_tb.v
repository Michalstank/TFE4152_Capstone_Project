`timescale 1ps / 1ps
`include "Tsetlin_FSM.v"	

module tb_State_Transitions;
	reg b, clk;
	reg d1, d2, d3, d1_n, d2_n, d3_n;
	reg ds0, ds1, ds2;
	wire a;
	integer err = 0;
	
	function [2:0] next_state;
		input [2:0] c_state;
		input B;
		
		begin
			case(c_state)
				3'b000: next_state = (!B ? 3'b001 : 3'b000);
				3'b001: next_state = (!B ? 3'b010 : 3'b000);
				3'b010: next_state = (!B ? 3'b011 : 3'b001);
				3'b011: next_state = (B ? 3'b100 : 3'b010);
				3'b100: next_state = (B ? 3'b101 : 3'b011);
				3'b101: next_state = (B ? 3'b101 : 3'b100);
				default: next_state = 3'b000;
			endcase
		end		
	endfunction
	
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
		.A		(a)
	);
	
	//Test by moving from state 0 to 2
	
	integer i = 0;
	integer p = 0;
	initial begin
		reg [2:0] n_state;
		for(i = 0; i < 3; i = i + 1) begin
			b = 1'b0;
			
			d1 = i[2];
			d2 = i[1];
			d3 = i[0];
			
			d1_n = ~d1;
			d2_n = ~d2;
			d3_n = ~d3;
			wait(clk);
			
			n_state = next_state(i,b);
			if({ds2, ds1, ds0} !== n_state) begin
				err = err + 1;
				$error("ERROR tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			end else
			$display("LOG tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			wait(!clk);
		end
		
		p = 0;
		for(i = 3; i < 6; i = i + 1) begin
			b = 1'b1;
			
			d1 = i[2];
			d2 = i[1];
			d3 = i[0];
			
			d1_n = ~d1;
			d2_n = ~d2;
			d3_n = ~d3;
			wait(clk);
			
			n_state = next_state(i,b);
			if({ds2, ds1, ds0} !== n_state) begin
				err = err + 1;
				$error("ERROR tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			end else
			$display("LOG tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			wait(!clk);
		end
		
		p = 0;
		//Reverse and descend back to 0
		for(i = 5; i >= 0; i = i - 1) begin
		
			if(i > 3)
				b = 1'b1;
			else
				b = 1'b0;
			
			d1 = i[2];
			d2 = i[1];
			d3 = i[0];
				
			d1_n = ~d1;
			d2_n = ~d2;
			d3_n = ~d3;
			
			wait(clk);
			
			n_state = next_state(i,b);
			if({ds2, ds1, ds0} !== n_state) begin
				err = err + 1;
				$error("ERROR tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			end else
			$display("LOG tb_State_Transitions at i = %0d, d = %d %d %d, s = %d %d %d, expected = %d %d %d, clk = %4d", 
				i, d1, d2, d3, ds2, ds1, ds0, n_state[2], n_state[1], n_state[0], $time);
			wait(!clk);
		end
		$display("State Update Test finished with %0d errors.", err);
		$finish;
	end
endmodule