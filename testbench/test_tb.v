`timescale 1ns/1ns
`define Clock_period 10
module test_tb;

	reg clk;
	reg SW0;
	reg rst;
	reg BTN7;
	reg BTN5;
	reg BTN6;
	
	wire [7:0]led_R0;
	wire [7:0]led_G0;
	wire [7:0]row0;
	wire  [6:0]num_;
	wire  [7:0]DS;
	initial begin
		clk = 1;
		SW0 = 0;
		BTN7 = 0;
		BTN6 = 0;
		BTN5 = 0;
		rst = 0;
	end	
	
	always#(`Clock_period/2) clk = ~clk;
	
	test test(.SW0(SW0),.rst(rst),.clk(clk),.led_G(led_G0),
		.led_R(led_R0),.row(row0),.BTN7(BTN7),.BTN5(BTN5),.BTN6(BTN6),
		.num_(num_),.DS(DS));
	
	
	initial begin
	 #40_000_000;
	 SW0 = 1;
	 #40_000;
	 BTN6 = 1;
	 #20_000_000;
	 BTN6 = 0;
	 #2_000_000;
	 #2_000_000;
	 #2_000_000;
	 #2_000_000;
	 #2_000_000;
	 #2_000_000;
	 $stop;
	 end


endmodule
