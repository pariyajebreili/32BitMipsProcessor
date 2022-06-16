`include "Mips.v"
`timescale 1ns/1ns

module tb_mips();
  	reg CLK,rst;
   integer i;
	wire Zero;
   wire [4:0]  write_reg;
   wire [3:0]  ALUControl;
	wire [31:0] PCNext,PCIn,Instruction,ReadData1,ReadData2,write_data_reg,read_data;
   

   initial
        begin
        rst=1;
        CLK=0;
        CLK=1;
        #50;
        rst=0;
        for(i=0;i<20;i=i+1)
        begin
            CLK=~CLK;
            #50;
        end
   end
	   
	MipsCPU mcpu(CLK, rst, PCIn,PCNext,Instruction,write_reg,ReadData1, ReadData2,ALUControl,Zero,read_data,write_data_reg);

      initial begin

        $dumpfile("Mips.vcd");
        $dumpvars(0,tb_mips); 

      end

endmodule