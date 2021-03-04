`timescale 1ns/1ns
`define Clock_period 1000
module clk_tb();

	reg clk;
	wire clk_1s;
	wire clk_5s;
	wire clk_10s;
	wire clk_half;
	clk_divide clk1(.clk(clk),.clk_out(clk_1s));
	cnt_5s clk2(.clk_out(clk_1s),.en_cnt_5s(1),.cnt_out_5s(clk_5s));
	cnt_10s clk3(.clk_out(clk_1s),.en_cnt_10s(1),.cnt_out_10s(clk_10s));
	clk_halfsecond clk4(.clk(clk),.clk_halfs(clk_half));
	initial begin
		clk = 1;
	end
	always#(`Clock_period/2) clk = ~clk;
	initial begin
	 #2_000_000_000;
	 #2_000_000_000;
	 #2_000_000_000;
	 #2_000_000_000;
	 #2_000_000_000;
	 #2_000_000_000;
	 $stop;
	end
endmodule
