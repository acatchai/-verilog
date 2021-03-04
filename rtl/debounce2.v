module debounce2(clk,key,key_pulse);

	input clk;//时钟
	input key;//输入按键状态 按下时为1 抬起时为0
	output key_pulse;//输出信号

	reg key_rst;//当前按键状态
	reg key_rst_pre;//上一时钟时按键的状态
	reg key_20ms;
	wire key_edge;//检测到时钟出现上升沿时 产生一时钟周期高电平信号；
	
	always @(posedge clk) begin
		  key_rst <= key;//取当前时钟下按键状态     
		  key_rst_pre <= key_rst; //将之前存储的按键状态转给“上一时钟”信号
	end
	
	assign key_edge = key_rst & (~key_rst_pre);
	
	reg[14:0]cnt;
	
	always@(posedge clk)begin
		if(key_pulse)
			cnt = 15'b0;
		else if(cnt == 15'd19_999)
			cnt = 15'b0;
		else 
			cnt = cnt + 1;
	end
	
	always@(posedge clk)
		if(cnt <= 15'd19_999)
			key_20ms = 0;
		else if(cnt == 15'd19_999)begin
			key_20ms = key;
		end
	assign key_pulse = key_20ms & 1;
endmodule
