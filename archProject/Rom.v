module Rom(input [7:0] address,
           output reg [7:0] data_out);
           
    always @(*) begin
        case(address)
            8'b00010000: data_out = 8'b00000000;
            8'b00010001: data_out = 8'b00000011;
            8'b00010010: data_out = 8'b00000110;
            8'b00010011: data_out = 8'b00001001;
            8'b00010100: data_out = 8'b00001100;
            8'b00010101: data_out = 8'b00001111;
            8'b00010110: data_out = 8'b00010010;
            8'b00010111: data_out = 8'b00010101;
            8'b00100000: data_out = 8'b00000000;
            8'b00100001: data_out = 8'b00000011;
            8'b00100010: data_out = 8'b00000100;
            8'b00100011: data_out = 8'b00000110;
            8'b00100100: data_out = 8'b00000111;
            8'b00100101: data_out = 8'b00001001;
            8'b00100110: data_out = 8'b00001010;
            8'b00100111: data_out = 8'b00001100;
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
    
endmodule

