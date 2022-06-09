module MUXAfterRegisterFile (ALUSrc, ReadData2, Extend16to32, Result);
      
      input ALUSrc;
      input [31:0] ReadData2,Extend16to32;

	output reg [31:0] Result;
	
	always @(ALUSrc, ReadData2, Extend16to32) 
      begin
		case (ALUSrc)
			0: Result = ReadData2 ;
			1: Result = Extend16to32;
		endcase
	end

endmodule