module testbech();

      reg clk,rst;
      wire pc,Instruction,WriteReg,ReadData1, ReadData2,
      ALUOperation,ALUSrc,Zero,ReadData,WriteDataReg;
      
/*
      Mips UUT(clk, rst, pc,Instruction,WriteReg,ReadData1, ReadData2,
      ALUOperation,ALUSrc,Zero,ReadData,WriteDataReg);
*/
      initial begin
            rst = 1;
            clk = 0;
            rst = 0;
            #100;
            clk = 1;
            #100;
            clk = 0;
            #100;
            rst = 1;
            #100;
            rst = 0;
            #100;
            clk = 1;
            #100;
      end

endmodule