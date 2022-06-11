`timescale 1ns/1ns
`include "Controller.v"


module ControllerTest();

      reg [5:0] opcode, func;
      wire reg_dst,reg_write, alu_src,mem_to_reg, mem_read, mem_write,branch;
      wire [1:0] alu_op;

      control_unit controller(func, opcode,reg_dst,reg_write, alu_src,mem_to_reg, mem_read, mem_write,branch,alu_op);

      initial
      begin
            opcode = 6'b000000;
            func   = 6'b100000;

            #20
            func   = 6'b100010;

            #20
            func   = 6'b100100;

            #20
            func   = 6'b100101;

            #20
            opcode = 6'b100011;
            func   = 6'bxxxxxx;

            #20
            opcode = 6'b101011;
            func   = 6'bxxxxxx;

            #20
            opcode = 6'b000100;
            func   = 6'bxxxxxx;
            

      end

      initial begin

        $dumpfile("ControllerTest.vcd");
        $dumpvars(0,ControllerTest);  

      end

endmodule