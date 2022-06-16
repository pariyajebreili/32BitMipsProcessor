module alu (alu_crtl, A, B, alu_out, zero);
	input [3:0] alu_crtl;
	input [31:0] A,B;
	output zero;
	output reg [31:0] alu_out;
   
	assign zero   = (alu_out == 0);
	// assign n_zero = (alu_out != 0);

	always @(alu_crtl, A, B) begin
		case (alu_crtl)
			0: alu_out = A & B;
			1: alu_out = A | B;
			2: alu_out = A + B;
			3: alu_out = A - B;
			
			default: alu_out = 0;
		endcase
	end
endmodule