module mux_affter_memory (read_data, alu_out, mem_toreg, write_data_reg);

	input [31:0] read_data, alu_out;
	input mem_toreg;	
	
	output reg [31:0] write_data_reg;
	
	always @(*) begin
		case (mem_toreg)
			0: write_data_reg <= alu_out ;
			1: write_data_reg <= read_data;
		endcase
	end
endmodule