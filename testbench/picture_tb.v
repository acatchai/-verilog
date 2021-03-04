`timescale 1ns/1ns
`define Clock_period 1000
module picture_tb();
	
	reg clk;
	reg en_all;
	reg [1:0]state;
	wire [7:0]led_R0;
	wire [7:0]led_G0;
	wire [7:0]row0;
	wire clk_halfs;
	picture picture1(
				.en_all(en_all),
				.clk_halfs(clk_halfs),
				.clk(clk),
				.led_G(led_G0),
				.led_R(led_R0),
				.row(row0),
				.state(state));
				
	clk_halfsecond clk_half1(.clk(clk),.clk_halfs(clk_halfs));			
	initial begin 
		clk = 1;
		state = 2'b00;
		en_all = 0;
	end
	always#(`Clock_period/2) clk = ~clk;
	
	initial begin
		#4_000_000;
		en_all = 1;
		#2_000_000_000;
		state = 2'b10;//右转
		#2_000_000_000;
		state = 2'b11;//刹车
		#2_000_000_000;
		state = 2'b01;//左转
		#2_000_000_000;
		$stop;
	end
endmodule
