`include "Mips.v"
`timescale 1ns/1ns

module tb_mips();
  	reg         clk,rst;
	wire        zero;
   wire [4:0]  write_reg;
   wire [3:0]  alu_crtl;
	wire [31:0] pc_next,
					pc_in,
					inst,
					read_data1,
					read_data2,
					write_data_reg,
					read_data;
   integer i;

   initial
        begin
        rst=1;
        clk=0;
        clk=1;
        #50;
        rst=0;
        for(i=0;i<20;i=i+1)
        begin
            clk=~clk;
            #50;
        end
   end
	   
	MipsCPU mcpu(clk, rst, pc_in,pc_next,inst,write_reg,read_data1, read_data2,alu_crtl,zero,read_data,write_data_reg);

      initial begin

        $dumpfile("Mips.vcd");
        $dumpvars(0,tb_mips); 

      end

endmodule