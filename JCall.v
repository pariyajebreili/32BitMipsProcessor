module JCall(pc_out_alu,read_data1,j,pc_in);
	input [31:0] pc_out_alu, read_data1;
	input j;	
	
	output reg [31:0] pc_in;
	
	always @(*) begin
		if   (j) begin pc_in <= read_data1; end
		else     begin pc_in <= pc_out_alu;     end
	end
endmodule
