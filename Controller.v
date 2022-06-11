`define FUNC_ADD 6'b100000
`define FUNC_SUB 6'b100010
`define FUNC_AND 6'b100100
`define FUNC_OR  6'b100101

`define LW     6'b100011
`define SW     6'b101011
`define BEQ    6'b000100
`define RTYPE  6'b000000

module Controller(func, opcode,reg_dst,reg_write, alu_src,mem_to_reg, mem_read, mem_write,branch,alu_op);
	
	input [5:0] opcode, func;
	output reg reg_dst,reg_write, alu_src,mem_to_reg, mem_read, mem_write,branch;
	output reg [1:0] alu_op;
 
				  
	
	always @(*) begin

		reg_dst 	= 0;
		alu_src 	= 0;
		mem_to_reg	= 0;
		reg_write	= 0;
		mem_read	= 0;
		mem_write	= 0;
		branch	= 0;

		//select oprand
		case(opcode)	
			`LW: begin
				alu_src 	= 1;
				reg_write	= 1;
				mem_read	= 1;
                        mem_to_reg	= 1;
				alu_op	= 2'b10;/*0*/
			end
			`SW: begin
                        reg_dst     = 1'bx;
				alu_src 	= 1;
                        mem_to_reg   = 1'bx;
				mem_write	= 1;
				alu_op	= 2'b10;/*0*/
			end
			`BEQ: begin
                        reg_dst     = 1'bx;
                        mem_to_reg   = 1'bx;
				branch	= 1;
				alu_op	= 2'b11;/*1*/
			end
			`RTYPE: begin
				reg_dst 	= 1;
				reg_write	= 1;
                        case(func)
                              `FUNC_ADD : alu_op	= 2'b10;
                              `FUNC_SUB : alu_op	= 2'b11;
                              `FUNC_AND : alu_op	= 2'b00;
                              `FUNC_OR :  alu_op      = 2'b01;
                        endcase
			end
		endcase
	end
endmodule