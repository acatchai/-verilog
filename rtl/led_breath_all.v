module led_breath_all(state,,row,led_G,led_R,clk);

	input clk;
	output [7:0]led_G;
	output reg[7:0]led_R;
	output reg[7:0]row;
	input [1:0]state;

	reg[2:0]sw;
	reg[7:0]en_breath;
		initial begin
		sw = 3'b000;
	end
	
	breath_led breath_led_0(.en_breath(en_breath[0]),.clk(clk),.led(led_G[0]));
	breath_led breath_led_1(.en_breath(en_breath[1]),.clk(clk),.led(led_G[1]));
	breath_led breath_led_2(.en_breath(en_breath[2]),.clk(clk),.led(led_G[2]));
	breath_led breath_led_3(.en_breath(en_breath[3]),.clk(clk),.led(led_G[3]));
	breath_led breath_led_4(.en_breath(en_breath[4]),.clk(clk),.led(led_G[4]));
	breath_led breath_led_5(.en_breath(en_breath[5]),.clk(clk),.led(led_G[5]));
	breath_led breath_led_6(.en_breath(en_breath[6]),.clk(clk),.led(led_G[6]));
	breath_led breath_led_7(.en_breath(en_breath[7]),.clk(clk),.led(led_G[7]));
	
	
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
	
	if(state == 2'b00) begin//处于正常行驶状态

		case(sw)
			3'b000:begin en_breath=8'b0001_1000;led_R=8'b0000_0000;end
         3'b001:begin en_breath=8'b0001_1000;led_R=8'b0000_0000;end
	      3'b010:begin en_breath=8'b0001_1000;led_R=8'b0000_0000;end
	      3'b011:begin en_breath=8'b0001_1000;led_R=8'b0000_0000;end
	      3'b100:begin en_breath=8'b1111_1111;led_R=8'b0000_0000;end
	      3'b101:begin en_breath=8'b0111_1110;led_R=8'b0000_0000;end
	      3'b110:begin en_breath=8'b0011_1100;led_R=8'b0000_0000;end
	      3'b111:begin en_breath=8'b0001_1000;led_R=8'b0000_0000;end
		endcase
	end
	
	
	
	end


endmodule
