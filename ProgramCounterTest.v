`timescale 1ns/1ns
`include "ProgramCounter.v"

module PrgramCounterTest();
	reg clk, rst;
	reg [31:0] PcIn;
   
      wire [31:0] PcNext;

      PrgramCounter UUT(clk, rst, PcIn, PcNext);    

      initial 
      begin 
            PcIn=16'h0001;
            rst = 1;
            clk = 0;
            #10
            rst = 0;
            #10;
            clk = 1;
            #10;
            clk = 0;
            #10;
            rst = 1;
            #10;
            rst = 0;
            #10;
            clk = 1;
            #10; 

      end

      initial begin

        $dumpfile("PrgramCounterTest.vcd");
        $dumpvars(0,PrgramCounterTest);  

      end

endmodule