module ShiftLeft2Bit (ShiftIn, shift_out);

  input [31:0] ShiftIn;
  output reg [31:0] shift_out;
  
  always @(ShiftIn) begin
    shift_out = ShiftIn << 2;
  end 
  
endmodule