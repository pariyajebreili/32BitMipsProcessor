module PrgramCounter(clk, rst, PcIn, PcNext);

	input clk, rst;
	input [31:0] PcIn;
	
	output reg [31:0] PcNext;
	
	always @(posedge clk) 
      begin
		if (rst == 1) 
		    PcNext = 0;
		else 
		    PcNext = PcIn + 1; 
	end
endmodule


// module PrgramCounter(clk, rst, pc);

//     input clk, rst;

//     inout [31:0] pc;
   
//     reg [31:0] PC_reg;
	
// 	always @(posedge clk or rst) begin
// 		if (rst == 1) 
// 		    PC_reg <= 0;
// 		else 
// 		    PC_reg <= pc + 1; 
// 	end


//     assign pc = PC_reg;

    
// endmodule