module sign_extend (in16, out32);

	input [15:0] in16;
	output reg [31:0] out32;

	always @(in16) out32[31:0] <= in16[15:0];
	
endmodule