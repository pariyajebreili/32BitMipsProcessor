`timescale 1ns/1ns
`include "MUXAfterRegisterFile.v"

module MUXAfterRegisterFileTest();
      reg ALUSrc;
      reg [31:0] ReadData2,Extend16to32;

      wire [31:0] Result;

      MUXAfterRegisterFile MUXAfterRegisterFile_inst(
          .ALUSrc(ALUSrc),
          .ReadData2(ReadData2),
          .Extend16to32(Extend16to32),
          .Result(Result)
      );


      initial 
      begin 
            ALUSrc = 1;
            ReadData2 = 32'h0001_0000;
            Extend16to32 = 32'h0000_0110;
            
            #20;
      end

      initial begin

        $dumpfile("MUXAfterRegisterFileTest.vcd");
        $dumpvars(0,MUXAfterRegisterFileTest);  

      end


endmodule