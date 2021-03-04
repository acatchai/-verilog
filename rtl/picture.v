module picture(line_rom1,line_rom2,en_all,clk_halfs,clk,led_G,led_R,row,state);
	input clk;
	input en_all;
	input [1:0]state;
	reg en_breath = 0;
	input clk_halfs;
	output reg [127:0]line_rom1;
	output reg [127:0]line_rom2;
	reg [2:0]sw;//8种情况控制行数
	output reg[7:0]led_G;
	output reg[7:0]led_R;
	output reg[7:0]row;
	wire led;
	breath_led breathled1(.en_breath(en_breath),.clk(clk),.led(led));
	
	initial begin
		sw = 3'b000;
	end

	
	reg [7:0]left_line1 = 8'b0001_0000;
	reg [7:0]left_line2 = 8'b0011_0000;
	reg [7:0]left_line3 = 8'b0111_0000;
	reg [7:0]left_line4 = 8'b1111_1110;
	
	reg[7:0]right_line1 = 8'b0000_1000;
	reg[7:0]right_line2 = 8'b0000_1100;
	reg[7:0]right_line3 = 8'b0000_1110;
	reg[7:0]right_line4 = 8'b0111_1111;
	
	always@(posedge clk_halfs)begin
		if(en_all)begin
			if(state == 2'b01)begin
				left_line1 = {left_line1[6:0],left_line1[7]};
				left_line2 = {left_line2[6:0],left_line2[7]};
				left_line3 = {left_line3[6:0],left_line3[7]};
				left_line4 = {left_line4[6:0],left_line4[7]};
			end
			else begin
				left_line1 = 8'b0001_0000;
				left_line2 = 8'b0011_0000;
				left_line3 = 8'b0111_0000;
				left_line4 = 8'b1111_1110;
			end
		end
	end
	
	always@(posedge clk_halfs)begin
		if(en_all)begin	
			if(state == 2'b10)begin
				right_line1 = {right_line1[0],right_line1[7:1]};
				right_line2 = {right_line2[0],right_line2[7:1]};
				right_line3 = {right_line3[0],right_line3[7:1]};
				right_line4 = {right_line4[0],right_line4[7:1]};
			end
			else begin
				right_line1 = 8'b0000_1000;
				right_line2 = 8'b0000_1100;
				right_line3 = 8'b0000_1110;
				right_line4 = 8'b0111_1111;
			end
		end
	end
	
	
	
	always@(posedge clk)begin
	 if(sw < 3'b111)
		sw = sw + 1'b1;
	else if(sw == 3'b111)
		sw = 3'b000;
	else
		sw = 3'b000;
	end
	
	always@(posedge clk)begin
			case(sw)
				3'b000: row = 8'b1111_1110;
				3'b001: row = 8'b1111_1101;
				3'b010: row = 8'b1111_1011;
				3'b011: row = 8'b1111_0111;
				3'b100: row = 8'b1110_1111;
				3'b101: row = 8'b1101_1111;
				3'b110: row = 8'b1011_1111;
				3'b111: row = 8'b0111_1111;
				default: ;
			endcase
	end
	
	always@(posedge clk)begin
	if(en_all)begin
		if(state == 2'b11)begin
			line_rom1 = "STOP            ";
			line_rom2 = "            STOP";
			case(sw)                                                							//case语句，一定要跟default语句
				3'b000:		begin led_R=8'b1000_0001;led_G=8'b0000_0000;end  //从0——最下一行开始扫描   //条件跳转，其中“_”下划线只是为了阅读方便，无实际意义  
				3'b001:		begin led_R=8'b0100_0010;led_G=8'b0000_0000;end                          //位宽'进制+数值是Verilog里常数的表达方法，进制可以是b、o、d、h（二、八、十、十六进制）
				3'b010:		begin led_R=8'b0010_0100;led_G=8'b0000_0000;end	
				3'b011:		begin led_R=8'b0001_1000;led_G=8'b0000_0000;end	
				3'b100:		begin led_R=8'b0001_1000;led_G=8'b0000_0000;end	
				3'b101:		begin led_R=8'b0010_0100;led_G=8'b0000_0000;end	
				3'b110: 		begin led_R=8'b0100_0010;led_G=8'b0000_0000;end	
				3'b111:		begin led_R=8'b1000_0001;led_G=8'b0000_0000;end		
				default: ;
			endcase
		end

		if(state == 2'b01)begin//左转
			line_rom1 = "TURN LEFT       ";
			line_rom2 = "  TURN LEFT     ";
			case(sw)                                                							
				3'b000:		begin led_R=8'b0000_0000;led_G=left_line1;end  
				3'b001:		begin led_R=8'b0000_0000;led_G=left_line2;end                         
				3'b010:		begin led_R=8'b0000_0000;led_G=left_line3;end	
				3'b011:		begin led_R=8'b0000_0000;led_G=left_line4;end	
				3'b100:		begin led_R=8'b0000_0000;led_G=left_line4;end	
				3'b101:		begin led_R=8'b0000_0000;led_G=left_line3;end	
				3'b110: 		begin led_R=8'b0000_0000;led_G=left_line2;end	
				3'b111:		begin led_R=8'b0000_0000;led_G=left_line1;end		
				default: ;
			endcase
		end
		
		
		

		
		
		if(state == 2'b10)begin//右转
			line_rom1 = "TURN RIGHT      ";
			line_rom2 = "  TURN RIGHT    ";
			case(sw)                                                							//case语句，一定要跟default语句
				3'b000:		begin led_R=8'b0000_0000;led_G=right_line1;end  //从0——最下一行开始扫描   //条件跳转，其中“_”下划线只是为了阅读方便，无实际意义  
				3'b001:		begin led_R=8'b0000_0000;led_G=right_line2;end                          //位宽'进制+数值是Verilog里常数的表达方法，进制可以是b、o、d、h（二、八、十、十六进制）
				3'b010:		begin led_R=8'b0000_0000;led_G=right_line3;end	
				3'b011:		begin led_R=8'b0000_0000;led_G=right_line4;end	
				3'b100:		begin led_R=8'b0000_0000;led_G=right_line4;end	
				3'b101:		begin led_R=8'b0000_0000;led_G=right_line3;end	
				3'b110: 		begin led_R=8'b0000_0000;led_G=right_line2;end	
				3'b111:		begin led_R=8'b0000_0000;led_G=right_line1;end		
				default: ;
			endcase
		end
		if(state == 2'b00)begin
			line_rom1 = "GO STRAIGHT     ";
			line_rom2 = "  GO STRAIGHT   ";
			en_breath = 1;
			case(sw)                                                							
			3'b000:		begin led_R=8'b0000_0000;
									led_G[0]= 0;
									led_G[1]= 0;
									led_G[2]= 0;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]= 0;
									led_G[6]= 0;
									led_G[7]= 0;
							end
			3'b001:		begin led_R=8'b0000_0000;
									led_G[0]= 0;
									led_G[1]= 0;
									led_G[2]= 0;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]= 0;
									led_G[6]= 0;
									led_G[7]= 0;
							end                          
		   3'b010:		begin led_R=8'b0000_0000;
									led_G[0]= 0;
									led_G[1]= 0;
									led_G[2]= 0;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]= 0;
									led_G[6]= 0;
									led_G[7]= 0;
							end	
		   3'b011:		begin led_R=8'b0000_0000;
									led_G[0]= 0;
									led_G[1]= 0;
									led_G[2]= 0;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]= 0;
									led_G[6]= 0;
									led_G[7]= 0;
							end	
		   3'b100:		begin led_R=8'b0000_0000;
									led_G[0]=led;
									led_G[1]=led;
									led_G[2]=led;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]=led;
									led_G[6]=led;
									led_G[7]=led;
							end	
			3'b101:		begin led_R=8'b0000_0000;
									led_G[0]=0;
									led_G[1]=led;
									led_G[2]=led;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]=led;
									led_G[6]=led;
									led_G[7]=0;
							end	
			3'b110: 		begin led_R=8'b0000_0000;
									led_G[0]=0;
									led_G[1]=0;
									led_G[2]=led;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]=led;
									led_G[6]=0;
									led_G[7]=0;
							end	
			3'b111:		begin led_R=8'b0000_0000;
									led_G[0]=0;
									led_G[1]=0;
									led_G[2]=0;
									led_G[3]=led;
									led_G[4]=led;
									led_G[5]=0;
									led_G[6]=0;
									led_G[7]=0;
							end		
			default: ;
		endcase
		end
		if(state != 2'b00)begin
			en_breath = 0;
		end
	end
	if(!en_all)begin
			line_rom1 = "OPEN SW0        ";
			line_rom2 = "      OPEN SWO  ";
		case(sw)                                                							//case语句，一定要跟default语句
			3'b000:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end  //从0——最下一行开始扫描   //条件跳转，其中“_”下划线只是为了阅读方便，无实际意义  
			3'b001:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end                          //位宽'进制+数值是Verilog里常数的表达方法，进制可以是b、o、d、h（二、八、十、十六进制）
			3'b010:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end	
			3'b011:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end	
			3'b100:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end	
			3'b101:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end	
			3'b110: 		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end	
			3'b111:		begin led_R=8'b0000_0000;led_G=8'b0000_0000;end		
			default: ;
		endcase
	end
	end
	
endmodule
