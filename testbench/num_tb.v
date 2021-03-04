`timescale 1ns/1ns
`define Clock_period 1000
module num_tb();
	
	reg clk;
	reg en_all;
	wire [6:0]num;
	wire clk_out;
	wire [7:0]DS;
	
	initial begin 
		clk = 1;
		en_all = 0;
	end
	clk_divide clk_division(.clk(clk),.clk_out(clk_out));
	always#(`Clock_period/2) clk = ~clk;
	num num1(
			.en_all(en_all),
			.clk(clk),
			.clk_out(clk_out),
			.num(num),
			.DS(DS));
			
	initial begin
		#4_000_000;
		en_all = 1;
		#2_000_000_000;
		#2_000_000_000;
		#2_000_000_000;
		#2_000_000_000;
		#2_000_000_000;
		#2_000_000_000;
		#2_000_000_000;
		$stop;
	end
endmodule
