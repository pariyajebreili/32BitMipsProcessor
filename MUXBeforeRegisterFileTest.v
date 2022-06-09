`timescale 1ns/1ns
`include "MUXBeforeRegisterFile.v"

module MUXBeforeRegisterFileTest();
      reg RegDst;
      reg [20:16] rt;
      reg [15:11] rd;

      wire [4:0] WriteRegister;

      MUXBeforeRegisterFile MUXBeforeRegisterFile_inst(
          .RegDst(RegDst),
          .rt(rt),
          .rd(rd),
          .WriteRegister(WriteRegister)
      );

      initial 
      begin 
            RegDst = 1;
            rt = 4'b0100;
            rd = 4'b0110;
            #20;
      end

      initial begin

        $dumpfile("MUXBeforeRegisterFileTest.vcd");
        $dumpvars(0,MUXBeforeRegisterFileTest);  

      end


endmodule