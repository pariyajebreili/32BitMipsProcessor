module mux_affter_regfile (alu_src, read_data2, extend32, alu_b);

	input alu_src;
	input [31:0] read_data2,extend32;	
	
	output reg [31:0] alu_b;
	
	always @(alu_src, read_data2, extend32) begin
		case (alu_src)
			0: alu_b <= read_data2 ;
			1: alu_b <= extend32;
		endcase
	end
endmodule