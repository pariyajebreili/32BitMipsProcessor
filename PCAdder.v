module pc_adder(pc_next, shift_out, add_alu_out);

	input [31:0] pc_next;
	input [31:0] shift_out;
	
	output reg [31:0] add_alu_out;

	always @(*) begin
		add_alu_out <= pc_next + shift_out;
	end
endmodule