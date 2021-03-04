module lcd1602(     
    //input pin
    Clk,
    Rst_n,
    line_rom1,
    line_rom2,
    
    //output pin
    RS, //date(H) or command(L)
    RW, //read(H) or write(L)
    EN, //enable pin
    DB  //date bus
);

//input pin define
input Clk;
input Rst_n;
input [127 : 0]line_rom1; //write date for line 1;
input [127 : 0]line_rom2; //write date for line 2;
//output pin define
output reg RS;
output RW;
output EN;
output reg [7 : 0]DB;
//temporary wire type
wire done; //delay_20ms successed
wire write_flg;
//temporary register type

/****************************************
*function begin
****************************************/

//delay 20ms
reg [19 : 0]count;
localparam delay_20ms = 20'd20_000;
//localparam delay_20ms = 20'd1000; //just for test;
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    count <= 20'd0;
else if(count < delay_20ms - 1'b1)
    count <= count + 1'b1;
else 
    count <= count;

//delay_20ms successed?    
assign done = (count == delay_20ms - 1'b1);

//coduct 500HZ clock for EN pin;
reg [16 : 0]count2; //500HZ
localparam delay_2ms = 17'd100_000;
//localparam delay_2ms = 100; //just for test;
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)  
    count2 <= 17'd0;
else if(done) begin
    if(count2 < delay_2ms - 1'b1)
        count2 <= count2 + 1'b1;
    else 
        count2 <= 17'd0;
end 
else 
    count2 <= 17'd0;
    
assign RW = 1'b0; // only write,never read;
assign EN = (count2 >= delay_2ms / 2) ? 1'b0 : 1'b1; 
assign write_flg = (count2 == delay_2ms - 1'b1) ? 1'b1 : 1'b0;

// 40 states
localparam IDLE = 8'h00;
//LCD1602 init
localparam DISP_SET = 8'h01; //display mode
localparam DISP_OFF = 8'h03; //display off
localparam CLR_SCR = 8'h02; //clear the LCD1602
localparam CURSOR_SET1 = 8'h06; //set cursor
localparam CURSOR_SET2 = 8'h07; //display only
//display 1th line 
localparam ROW1_ADDR = 8'h05;
localparam ROW1_0 = 8'h04;
localparam ROW1_1 = 8'h0C;
localparam ROW1_2 = 8'h0D;
localparam ROW1_3 = 8'h0F;
localparam ROW1_4 = 8'h0E;
localparam ROW1_5 = 8'h0A;
localparam ROW1_6 = 8'h0B;
localparam ROW1_7 = 8'h09;
localparam ROW1_8 = 8'h08;
localparam ROW1_9 = 8'h18;
localparam ROW1_A = 8'h19;
localparam ROW1_B = 8'h1B;
localparam ROW1_C = 8'h1A;
localparam ROW1_D = 8'h1E;
localparam ROW1_E = 8'h1F;
localparam ROW1_F = 8'h1D;
//display 2th line
localparam ROW2_ADDR = 8'h1C;
localparam ROW2_0 = 8'h14;
localparam ROW2_1 = 8'h15;
localparam ROW2_2 = 8'h17;
localparam ROW2_3 = 8'h16;
localparam ROW2_4 = 8'h12;
localparam ROW2_5 = 8'h13;
localparam ROW2_6 = 8'h11;
localparam ROW2_7 = 8'h10;
localparam ROW2_8 = 8'h30;
localparam ROW2_9 = 8'h31;
localparam ROW2_A = 8'h33;
localparam ROW2_B = 8'h32;
localparam ROW2_C = 8'h36;
localparam ROW2_D = 8'h37;
localparam ROW2_E = 8'h35;
localparam ROW2_F = 8'h34;

//FSM : alway1
reg [7 : 0]current_state, next_state;
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    current_state <= IDLE;
else if(write_flg)
    current_state <= next_state;
else 
    current_state <= current_state;
    
//FSM : alway2
always@(*) begin 
case(current_state)
    //LCD1602 init
    IDLE : next_state = DISP_SET;
    DISP_SET : next_state = DISP_OFF;
    DISP_OFF : next_state = CLR_SCR;
    CLR_SCR : next_state = CURSOR_SET1;
    CURSOR_SET1 : next_state = CURSOR_SET2;
    CURSOR_SET2 : next_state = ROW1_ADDR;
    //display 1th line 
    ROW1_ADDR : next_state = ROW1_0;
    ROW1_0 : next_state = ROW1_1;
    ROW1_1 : next_state = ROW1_2;
    ROW1_2 : next_state = ROW1_3;
    ROW1_3 : next_state = ROW1_4;
    ROW1_4 : next_state = ROW1_5;
    ROW1_5 : next_state = ROW1_6;
    ROW1_6 : next_state = ROW1_7;
    ROW1_7 : next_state = ROW1_8;
    ROW1_8 : next_state = ROW1_9;
    ROW1_9 : next_state = ROW1_A;
    ROW1_A : next_state = ROW1_B;
    ROW1_B : next_state = ROW1_C;
    ROW1_C : next_state = ROW1_D;
    ROW1_D : next_state = ROW1_E;
    ROW1_E : next_state = ROW1_F;
    ROW1_F : next_state = ROW2_ADDR;
    //display 2th line
    ROW2_ADDR : next_state = ROW2_0;
    ROW2_0 : next_state = ROW2_1;
    ROW2_1 : next_state = ROW2_2;
    ROW2_2 : next_state = ROW2_3;
    ROW2_3 : next_state = ROW2_4;
    ROW2_4 : next_state = ROW2_5;
    ROW2_5 : next_state = ROW2_6;
    ROW2_6 : next_state = ROW2_7;
    ROW2_7 : next_state = ROW2_8;
    ROW2_8 : next_state = ROW2_9;
    ROW2_9 : next_state = ROW2_A;
    ROW2_A : next_state = ROW2_B;
    ROW2_B : next_state = ROW2_C;
    ROW2_C : next_state = ROW2_D;
    ROW2_D : next_state = ROW2_E;
    ROW2_E : next_state = ROW2_F;
    ROW2_F : next_state = ROW1_ADDR;
    default : next_state = IDLE;
endcase 

end 

//FSM : always3-1
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    RS <= 1'b0;
else if(write_flg)begin
    if(next_state == IDLE || next_state == DISP_SET ||
       next_state ==DISP_OFF || next_state == CLR_SCR ||
       next_state ==CURSOR_SET1 || next_state == CURSOR_SET2 ||
       next_state == ROW1_ADDR ||next_state == ROW2_ADDR)
        RS <= 1'b0;//L : instruction
    else 
        RS <= 1'b1;//H : data
end 
else 
    RS <= RS;
    
//FSM : always3-2
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    DB <= 8'h00;
else if(write_flg)
    case(next_state)
    IDLE : DB <= 8'hxx;
    //LCD1602 init
    DISP_SET : DB <= 8'h38; //display mode : set 16*2, 5*8, 8 bits data
    DISP_OFF : DB <= 8'h08; //display off
    CLR_SCR : DB <= 8'h01; //clear LCD1602
    CURSOR_SET1 : DB <= 8'h06; //set cussor
    CURSOR_SET2 : DB <= 8'h0c; //display on 
    //display 1th line 
    ROW1_ADDR : DB <= 8'h80;
    ROW1_0 : DB <= line_rom1[127 : 120];
    ROW1_1 : DB <= line_rom1[119 : 112];
    ROW1_2 : DB <= line_rom1[111 : 104];
    ROW1_3 : DB <= line_rom1[103 : 96];
    ROW1_4 : DB <= line_rom1[95 : 88];
    ROW1_5 : DB <= line_rom1[87 : 80];
    ROW1_6 : DB <= line_rom1[79 : 72];
    ROW1_7 : DB <= line_rom1[71 : 64];
    ROW1_8 : DB <= line_rom1[63 : 56];
    ROW1_9 : DB <= line_rom1[55 : 48];
    ROW1_A : DB <= line_rom1[47 : 40];
    ROW1_B : DB <= line_rom1[39 : 32];
    ROW1_C : DB <= line_rom1[31 : 24];
    ROW1_D : DB <= line_rom1[23 : 16];
    ROW1_E : DB <= line_rom1[15 : 8];
    ROW1_F : DB <= line_rom1[7 : 0];
    //display 2th line 
    ROW2_ADDR : DB <= 8'hC0;
    ROW2_0 : DB <= line_rom2[127 : 120];
    ROW2_1 : DB <= line_rom2[119 : 112];
    ROW2_2 : DB <= line_rom2[111 : 104];
    ROW2_3 : DB <= line_rom2[103 : 96];
    ROW2_4 : DB <= line_rom2[95 : 88];
    ROW2_5 : DB <= line_rom2[87 : 80];
    ROW2_6 : DB <= line_rom2[79 : 72];
    ROW2_7 : DB <= line_rom2[71 : 64];
    ROW2_8 : DB <= line_rom2[63 : 56];
    ROW2_9 : DB <= line_rom2[55 : 48];
    ROW2_A : DB <= line_rom2[47 : 40];
    ROW2_B : DB <= line_rom2[39 : 32];
    ROW2_C : DB <= line_rom2[31 : 24];
    ROW2_D : DB <= line_rom2[23 : 16];
    ROW2_E : DB <= line_rom2[15 : 8];
    ROW2_F : DB <= line_rom2[7 : 0];
    endcase 
else 
    DB <= DB;

endmodule 