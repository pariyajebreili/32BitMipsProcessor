`timescale 1ns/1ns
`include "MUXAfterDataMemory.v"

module MUXAfterDataMemoryTest();
      reg MemtoReg;	
	reg [31:0] ReadData, Result;
	
	wire [31:0] WriteData;

      MUXAfterDataMemory MUXAfterDataMemory_inst(
            .MemtoReg(MemtoReg),
            .ReadData(ReadData),
            .Result(Result),
            .WriteData(WriteData)
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