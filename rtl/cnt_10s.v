module cnt_10s(clk_out,en_cnt_10s,cnt_out_10s);

	input clk_out;//周期1s时钟
	input en_cnt_10s;//计数使能信号
	output reg cnt_out_10s;//计数达10s输出信号
	reg [3:0]cnt_10s_;//十秒计数
	
	initial begin
		cnt_10s_ = 4'b0000;
		cnt_out_10s = 1'b0;
	end
	
	always@(posedge clk_out)begin

		
		if(en_cnt_10s)begin
			if(cnt_10s_ < 4'b1010)begin
				cnt_10s_ = cnt_10s_ + 4'b0001;//未达十秒时计时
			end
			else if (cnt_10s_ == 4'b1010)begin
				cnt_10s_ = 4'b0000;
				cnt_out_10s = 1;
			end
		end
		else if(!en_cnt_10s)begin
			cnt_out_10s = 0;
			cnt_10s_ = 4'b0000;
		end
	end
	

endmodule
