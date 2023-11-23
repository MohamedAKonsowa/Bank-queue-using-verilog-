module clock_divider (
    input         clk_in,   // Input clock from an external source
    output reg    clk_out   // Output clock with a frequency of 100 Hz
);

reg [15:0] counter = 0;

always @(posedge clk_in) begin
    if (counter == 49999) begin
        counter <= 0;
        clk_out <= ~clk_out;  // Toggle the output clock
    end else begin
        counter <= counter + 1'b1;
    end
end

endmodule





module Rom(input clk, input reset, input [7:0] address,
           output reg [7:0] data_out);
           
    always @(posedge clk or posedge reset) begin
if(reset)
begin
data_out = 8'b00000000;
end
else
begin
        case(address)
            8'b00010000: data_out = 8'b00000000;
            8'b00010001: data_out = 8'b00000011;
            8'b00010010: data_out = 8'b00000110;
            8'b00010011: data_out = 8'b00001001;
            8'b00010100: data_out = 8'b00010010;
            8'b00010101: data_out = 8'b00010101;
            8'b00010110: data_out = 8'b00011000;
            8'b00010111: data_out = 8'b00100001;
            8'b00100000: data_out = 8'b00000000;
            8'b00100001: data_out = 8'b00000011;
            8'b00100010: data_out = 8'b00000100;
            8'b00100011: data_out = 8'b00000110;
            8'b00100100: data_out = 8'b00000111;
            8'b00100101: data_out = 8'b00001001;
            8'b00100110: data_out = 8'b00010000;
            8'b00100111: data_out = 8'b00010010;
            8'b00110000: data_out = 8'b00000000;
            8'b00110001: data_out = 8'b00000011;
            8'b00110010: data_out = 8'b00000100;
            8'b00110011: data_out = 8'b00000101;
            8'b00110100: data_out = 8'b00000110;
            8'b00110101: data_out = 8'b00000111;
            8'b00110110: data_out = 8'b00001000;
            8'b00110111: data_out = 8'b00001001;
            default: data_out = 8'b00000000;
        endcase
end
    end
    
endmodule




module decoder_7seg (clk, reset, A, B, C, D, led_a, led_b, led_c, led_d, led_e, led_f, led_g);
input A, B, C, D, clk, reset;
output reg led_a; 
output reg led_b;
output reg led_c; 
output reg led_d; 
output reg led_e; 
output reg led_f; 
output reg led_g;
always @(posedge clk or posedge reset) begin
if(reset)
begin
led_a = 1'b0;
led_b = 1'b0;
led_c = 1'b0;
led_d = 1'b0;
led_e = 1'b0;
led_f = 1'b0;
led_g = 1'b0;
end
else
begin
led_a = ~(A | C | B&D | ~B&~D);
led_b = ~(~B | ~C&~D | C&D);
led_c = ~(B | ~C | D);
led_d = ~(~B&~D | C&~D | B&~C&D | ~B&C |A);
led_e = ~(~B&~D | C&~D);
led_f = ~(A | ~C&~D | B&~C | B&~D);
led_g = ~(A | B&~C | ~B&C | C&~D);
end
end

endmodule














module FSM(clk, reset, pcount, in, out, full, empty);
input clk, reset, in, out;
input [2:0] pcount;
reg [2:0] state;
output reg full, empty;
parameter 	s0 = 3'b000, // Empty
		s1 = 3'b001, // Add
		s2 = 3'b010, // NotFullOrEmpty
		s3 = 3'b011, // Subtract
		s4 = 3'b100; // Full

always @(posedge clk or posedge reset)

begin
if(reset)
begin
state = 0;
empty = 1;
full = 0;
end
else
begin


case(state)
s0: 	//Empty
	if(in == 1 && out == 0) // someone enteres the queue (state goes to addition state)
		begin
			state = s1; // s1 : Add
		end

s1: 	//Additiotn
	if(pcount == 7)  // becomes full after addititon (state goes to full state)
		begin
			state = s4; // s4 : Full
			full = 1;
			empty = 0;
		end
	else 		// isnt full after addition (state goes to not full or empty state)
		begin
			state = s2; // s2 : not full or empty
			full = 0;
			empty = 0;
		end

s2:	//Not Empty OR Full
	if(in == 1 && out == 0) 	// someone enteres the queue (state goes to addition state)
		begin
			state = s1; // s1 : Add
		end
	else if (in == 0 && out == 1)	// someone exits the queue (state goes to subtraction state)
		begin
			state = s3; // s3 : Subtract
		end

s3:	//Subtraction
	if(pcount == 0)  // becomes empty after subtraction (state goes to empty state)
		begin
			state = s0; // s0 : Empty
			full = 0;
			empty = 1;
		end
	else 		// isnt full after addition (state goes to not full or empty state)
		begin
			state = s2; // s2 : not full or empty
			full = 0;
			empty = 0;
		end
s4:	//Full
	if(in == 0 && out == 1)
		begin
			state = s3; // s3 : Subtract
		end
endcase 



end

end


endmodule




module up_down_counter (
  input clk, 
  input reset, 
  input in, 
  input out,
  output reg [2:0] pcount
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      pcount <= 3'b000;
    end else if (in && (pcount < 3'b111)) begin
      pcount <= pcount + 1'b1;
    end else if (out && (pcount > 3'b000)) begin
      pcount <= pcount - 1'b1;
    end
  end

endmodule

module synchronizer(input clk, input button, output result);
  reg state;
always@ (posedge clk)
begin
state <= button;
end
assign result = button & ~state;
endmodule

module abqm (
  input clk, 
  input reset, 
  input in, 
  input out,
  input [1:0]tcount,
  output wire Full_flag, 
  output wire Empty_flag,
  output wire [6:0]OutputSegmentRight,
  output wire [6:0]OutputSegmentLeft,
  output wire [6:0]OutputSegmentpcount
);

  
  wire CLK100Hz;
  clock_divider divider(clk,CLK100Hz);
  
  wire [2:0]pcount;
  
  wire sync_button_in;  
  wire sync_button_out;

  synchronizer sync_in (CLK100Hz, in, sync_button_in);
  synchronizer sync_out (CLK100Hz, out, sync_button_out);
  
  up_down_counter counter_inst (CLK100Hz, reset, sync_button_in, sync_button_out, pcount);
  
  FSM fsm_inst (
    .clk(CLK100Hz),
    .reset(reset),
    .in(sync_button_in),
    .out(sync_button_out),
    .pcount(pcount),
    .full(Full_flag),
    .empty(Empty_flag)
  );
  wire [3:0] address1;
  wire [3:0] address2;
  assign address1 = {2'b00, tcount};
  assign address2 = {1'b0, pcount};
  wire [7:0] Wait_Time;



  Rom rom_inst(CLK100Hz, reset, {address1,address2}, Wait_Time);

  
  decoder_7seg segRight(CLK100Hz, reset, Wait_Time[3],Wait_Time[2],Wait_Time[1],Wait_Time[0], OutputSegmentRight[0], OutputSegmentRight[1], OutputSegmentRight[2], OutputSegmentRight[3], 
			OutputSegmentRight[4], OutputSegmentRight[5], OutputSegmentRight[6]);
  decoder_7seg segLeft(CLK100Hz, reset, Wait_Time[7],Wait_Time[6],Wait_Time[5],Wait_Time[4], OutputSegmentLeft[0], OutputSegmentLeft[1], OutputSegmentLeft[2], OutputSegmentLeft[3], 
			OutputSegmentLeft[4], OutputSegmentLeft[5], OutputSegmentLeft[6]);
  decoder_7seg segPcount(CLK100Hz, reset, address2[3],address2[2],address2[1],address2[0], OutputSegmentpcount[0], OutputSegmentpcount[1], OutputSegmentpcount[2], OutputSegmentpcount[3], 
			OutputSegmentpcount[4], OutputSegmentpcount[5], OutputSegmentpcount[6]);




endmodule



