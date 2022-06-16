module mux_before_regfile(rt, rd, reg_dst, write_reg);

	input [20:16] rt;
	input [15:11] rd;
	input reg_dst;
	
	output reg [4:0] write_reg;

	always @ (reg_dst, rt, rd) begin
		if(reg_dst == 1) begin  write_reg <= rd; end
		else  begin write_reg <= rt; end
	end

endmodule