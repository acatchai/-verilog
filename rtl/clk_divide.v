module clk_divide(clk,clk_out);
	
	input clk;
	output reg clk_out;
	reg[18:0] cnt;
	
	initial begin
		cnt <= 19'd0;
		clk_out <= 1'b1;
	end
	
	always@(posedge clk)begin
		if(cnt < 19'd499_999)
			cnt = cnt + 1;
		else if(cnt == 19'd499_999)begin
			clk_out = ~clk_out;
			cnt = 19'b0;
		end
	end
	
endmodule
