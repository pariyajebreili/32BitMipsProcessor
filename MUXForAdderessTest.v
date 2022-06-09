`timescale 1ns/1ns
`include "MUXForAdderess.v"

module MUXForAdderessTest();
      reg branchTargetAddress;	
	reg [31:0] PcNext, ALUResult;
	
	wire [31:0] PcIn;

      MUXForAdderess MUXForAdderess_inst(
            .branchTargetAddress(branchTargetAddress),
            .PcNext(PcNext),
            .ALUResult(ALUResult),
            .PcIn(PcIn)
      );
            


      initial 
      begin 
            MemtoReg = 1;
            ReadData = 32'h0000_0100;
            Result = 32'h0000_0101;
            
            #20;
      end

      initial begin

        $dumpfile("MUXAfterDataMemoryTest.vcd");
        $dumpvars(0,MUXAfterDataMemoryTest);  

      end


endmodule