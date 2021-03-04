module cnt_5s(clk_out,en_cnt_5s,cnt_out_5s);

	input clk_out;//周期1s时钟
	input en_cnt_5s;//计数使能信号
	output reg cnt_out_5s;//计数达5s输出信号
	reg [3:0]cnt_5s_;//十秒计数
	
	initial begin
		cnt_5s_ = 4'b0000;
		cnt_out_5s = 1'b0;
	end
	
	always@(posedge clk_out)begin

		
		if(en_cnt_5s)begin
			if(cnt_5s_ < 4'b0101)begin
				cnt_5s_ = cnt_5s_ + 4'b0001;//未达十秒时计时
			end
			else if (cnt_5s_ == 4'b0101)begin
				cnt_5s_ = 4'b0000;
				cnt_out_5s = 1;
			end
		end
		else if(!en_cnt_5s)begin
			cnt_out_5s = 0;
			cnt_5s_ = 4'b0000;
		end
	end
	

endmodule
