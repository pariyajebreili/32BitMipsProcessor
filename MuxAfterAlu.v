module mux_after_alu (pc_next, add_alu_out, branch_zero_and, pc_in);
	input [31:0] pc_next, add_alu_out;
	input branch_zero_and;	
	
	output reg [31:0] pc_in;
	
	initial pc_in <= 0;

	always @(*) begin
		if(branch_zero_and) begin pc_in <= add_alu_out; end 
		else begin  pc_in <= pc_next ; end
	end
endmodule