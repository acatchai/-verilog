module picture_line_ctr(clk,sw,row);

	input clk;
	output reg[2:0]sw;//点阵行数控制；
	output reg[7:0]row;
	
	initial begin
		sw = 3'b000;
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
			3'b000: row = 1111_1110;
			3'b001: row = 1111_1101;
			3'b010: row = 1111_1011;
			3'b011: row = 1111_0111;
			3'b100: row = 1110_1111;
			3'b101: row = 1101_1111;
			3'b110: row = 1011_1111;
			3'b111: row = 0111_1111;
			default: ;
		endcase
	end
		
	
endmodule