module MUXBeforeRegisterFile(rd, rt, RegDst, WriteRegister);
      
      input RegDst;
	input [20:16] rt;
	input [15:11] rd;
	
	output reg [4:0] WriteRegister;

	always @ (RegDst, rd, rt) 
      begin
		if(RegDst == 1) 
            begin WriteRegister = rd; end
		else  
            begin WriteRegister = rt; end
	end

endmodule