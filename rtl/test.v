module test(lcd_DB,lcd_EN,lcd_RS,lcd_RW,SW0,rst,clk,led_G,led_R,row,BTN7,BTN5,BTN6,num_,DS);
	
	input BTN7;//左转按键
	input BTN5;//右转按键
	input BTN6;//刹车按键
	input clk;
	input SW0;
	input rst;
	wire BTN5_pulse;//消抖后
	wire BTN6_pulse;
	wire BTN7_pulse;
	reg en_cnt_10s;//10s使能计数信号
	reg en_cnt_5s;//5s使能计数信号
	wire clk_out;////分频后 周期1s时钟
	wire cnt_out_10s;//计数达10s输出信号
	wire cnt_out_5s;
	reg en_all = 0; 
	reg [1:0]state;//自行车所处状态 00 为正常 01 为左转 10为右转 11为刹车
	wire [127:0]line_rom1 ;
	wire [127:0]line_rom2 ;
	
	output [7:0]row;
	output [7:0]led_G;
	output [7:0]led_R;
	output [7:0]DS;
	
	output	lcd_RS;
	output lcd_RW;
	output lcd_EN;
	output [7:0]lcd_DB;
	
	output wire[6:0]num_;
	wire clk_halfs;
	initial begin 
		en_cnt_10s = 1'b0;
		en_cnt_5s = 1'b0;
		state = 2'b00;
	end
	


	picture pic1(.line_rom1(line_rom1),.line_rom2(line_rom2),.en_all(en_all),.clk_halfs(clk_halfs),.clk(clk),.led_G(led_G),.led_R(led_R),.row(row),.state(state));
	debounce d1(.clk(clk),.key(~BTN5),.key_pulse(BTN5_pulse),.rst(rst));
	debounce d2(.clk(clk),.key(~BTN6),.key_pulse(BTN6_pulse),.rst(rst));
	debounce d3(.clk(clk),.key(~BTN7),.key_pulse(BTN7_pulse),.rst(rst));
	clk_divide divide1(.clk(clk),.clk_out(clk_out));
	cnt_10s cnt_10s_1(.clk_out(clk_out),.en_cnt_10s(en_cnt_10s),.cnt_out_10s(cnt_out_10s));
	cnt_5s cnt_5s(.clk_out(clk_out),.en_cnt_5s(en_cnt_5s),.cnt_out_5s(cnt_out_5s));
	num num1(.en_all(en_all),.clk(clk),.clk_out(clk_out),.num(num_),.DS(DS));
	clk_halfsecond half1(.clk(clk),.clk_halfs(clk_halfs));
	lcd1602(     
		 //input pin
		 .Clk(clk),
		 .Rst_n(~rst),
		 .line_rom1(line_rom1),
		 .line_rom2(line_rom2),
		 
		 //output pin
		 .RS(lcd_RS), //date(H) or command(L)
		 .RW(lcd_RW), //read(H) or write(L)
		 .EN(lcd_EN), //enable pin
		 .DB(lcd_DB)  //date bus
		);
	always@(posedge clk)begin
		if(SW0 == 1)
			en_all = 1;
		if(SW0 == 0)
			en_all = 0;
	end
	
	always@(posedge clk)begin
		if(BTN5_pulse == 1)begin//右转
			state <= 2'b10;
			en_cnt_10s <= 1'b1;
		end
		else if(BTN6_pulse == 1)begin//刹车
			state <= 2'b11;
			en_cnt_5s <= 1'b1;
		end
		else if(BTN7_pulse == 1)begin//左转
			state <= 2'b01;
			en_cnt_10s <= 1'b1;
		end
		else if(cnt_out_10s)begin
			state <= 2'b00;
			en_cnt_10s <= 1'b0;
		end
		else if(cnt_out_5s)begin
			state <= 2'b00;
			en_cnt_5s <= 1'b0;
		end
		else if(!en_all)
			state <= 2'b00;
		
	end
	
	
endmodule
