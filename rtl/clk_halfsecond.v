module clk_halfsecond(clk,clk_halfs);
	
	input clk;
	output reg clk_halfs;
	reg[17:0] cnt;
	
	initial begin
		cnt <= 18'd0;
		clk_halfs <= 1'b1;
	end
	
	always@(posedge clk)begin
		if(cnt < 18'd249_999)
			cnt = cnt + 1;
		else if(cnt == 18'd249_999)begin
			clk_halfs = ~clk_halfs;
			cnt = 18'b0;
		end
	end
	
endmodule
