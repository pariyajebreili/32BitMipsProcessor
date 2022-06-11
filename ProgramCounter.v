module PrgramCounter(clk, rst, PcIn, PcNext);

	input clk, rst;
	input [31:0] PcIn;
	
	output reg [31:0] PcNext;
	
	always @(posedge clk) 
      begin
		if (rst == 1) 
		    PcNext = 0;
		else 
		    PcNext = PcIn + 4; 
	end
endmodule
