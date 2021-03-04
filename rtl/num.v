module num(en_all,clk,clk_out,num,DS);
	input en_all;
	input clk;
	input clk_out;
	
	output reg [6:0]num;
	
	
	reg [4:0]cnt_left;
	reg [4:0]cnt_right;
	reg [4:0]cnt;
	output reg [7:0]DS;

	initial begin 
		DS = 8'b1110_1111;
		
		cnt_left = 4'b0;
		cnt_right = 4'b0;
	end
	
	always@(posedge clk)begin
		
		DS[4] <= ~DS[4];
		DS[5] <= ~DS[5];
		
	end
	always@(posedge clk_out)begin
		if(en_all)begin
			if(cnt_right < 4'b1001)
				cnt_right = cnt_right + 1;
			else if(cnt_right == 4'b1001)begin
				cnt_right <= 4'b0;
				cnt_left <= cnt_left + 1;
			end
			if(cnt_left == 4'b1010)begin
				cnt_left <= 4'b0000;
			end	
		end
		if(!en_all)begin
			cnt_left <= 0;
			cnt_right <= 0;
		end
	end
	always@(posedge clk)begin
		if(en_all)begin
			case(cnt)
				4'b0000: num = 7'h3f;
				4'b0001: num = 7'h06;
				4'b0010: num = 7'h5b;
				4'b0011: num = 7'h4f; 
				4'b0100: num = 7'h66;
				4'b0101: num = 7'h6d;
				4'b0110: num = 7'h7d;
				4'b0111: num = 7'h07;
				4'b1000: num = 7'h7f;
				4'b1001:	num = 7'h6f;
			endcase		
		end
		else if(!en_all)
			num = 7'b0000000;
	end
	
	always@(posedge clk)begin
		if(DS[4] == 0)
			cnt = cnt_right;
		else if(DS[5] == 0)
			cnt = cnt_left;
		
	end
endmodule
	