module MUXForAdderess (PcNext, ALUResult, branch, PcIn);
      
      initial PcIn = 0;
      input branch;	
	input [31:0] PcNext, ALUResult;
	
	output reg [31:0] PcIn;

	always @(*) 
      begin
		if(branch) 
            begin PcIn = ALUResult; end 
		else 
            begin  PcIn = PcNext ; end
	end

endmodule