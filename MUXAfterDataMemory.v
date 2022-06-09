module MUXAfterDataMemory (Result, ReadData, MemtoReg, WriteData);

      input MemtoReg;	
	input [31:0] ReadData, Result;
	
	output reg [31:0] WriteData;
	
	always @(*) 
      begin
		case (MemtoReg)
			0: WriteData = Result ;
			1: WriteData = ReadData;
		endcase
	end

endmodule
