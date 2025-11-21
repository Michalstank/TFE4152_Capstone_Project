`timescale 1ps / 1ps
`include "Tsetlin_FSM.v"

`define TEST_CNT 100

module tb_Whole_system;
	reg b;
	reg clk, rst_n;
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
	
	function reg is_a;
		input  [2:0] l_state;
		
		begin
			case(l_state)
				3'b000: is_a = 1'b0;
				3'b001: is_a = 1'b0;
				3'b010: is_a = 1'b0;
				3'b011: is_a = 1'b1;
				3'b100: is_a = 1'b1;
				3'b101: is_a = 1'b1;
				default: is_a = 1'b0;
			endcase
		end
	endfunction

	
	reg [2:0] current_state;
	
	Tsetlin_FSM fsm(
		.CLK (clk),
		.RST_n (rst_n),
		.B (b),
		.A (a)
	);
	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	always @(posedge clk or posedge rst_n) begin
		if(!rst_n)
			b = 1'b0;
		else
			b = $urandom_range(1);
	end
	
	integer i = 0;
	initial begin
	   rst_n = 1'b0;
	   $display("LOG: Reset = %d, A = %d, B = %d, time = %d", rst_n, a, b, $time);
	   #10;
	   $display("LOG: Reset = %d, A = %d, B = %d, time = %d", rst_n, a, b, $time);
	   #10;
	   $display("LOG: Reset = %d, A = %d, B = %d, time = %d", rst_n, a, b, $time);
	   #10;
	   rst_n = 1'b1;
	   current_state = 3'b000;
	   
	   for(i = 0; i < `TEST_CNT; i = i + 1) begin
		   @(posedge clk) begin
			   if(is_a(current_state) != a) begin
				   $error("ERROR: Reset = %d, A = %d, B = %d, time = %d, Expected A = %d", rst_n, a, b, $time, is_a(current_state));
			   	   err = err + 1;
			   end else
				   $display("LOG: Reset = %d, A = %d, B = %d, time = %d", rst_n, a, b, $time);
		   end
		   current_state = next_state(current_state, b);
	   end
	   $display("Entire System test finished with %d Errors.", err);
	   $finish;
	end
	
endmodule 
