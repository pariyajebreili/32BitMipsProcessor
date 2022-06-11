module prgram_counter(clk, rst, pc_in, pc_next);

	input clk, rst;
	input [31:0] pc_in;
	
	output reg [31:0] pc_next;
	
	always @(posedge clk) 
      begin
		if (rst == 1) 
		    pc_next <= 0;
		else 
		    pc_next <= pc_in + 4; 
	end
endmodule
