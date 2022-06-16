`include "ALU.v"
`include "ALUControlUnit.v"
`include "ControlUnit.v"
`include "DataMemory.v"
`include "InstructionMemory.v"
`include "MuxAfterALU.v"
`include "MuxAfterMemory.v"
`include "MuxAfterRegister.v"
`include "MuxBeforRegister.v"
`include "PCAdder.v"
`include "JCall.v"
`include "ProgramCounter.v"
`include "RegisterFile.v"
`include "ShiftLeftTwoBit.v"
`include "SignExtend.v"

module MipsCPU(clk, rst, pc_in,pc_next,inst,write_reg,read_data1, read_data2,alu_crtl,zero,read_data,write_data_reg);	
	
	input clk,rst;
	output wire zero;
      output wire [4:0] write_reg;
	output wire [3:0] alu_crtl;
	output wire [31:0] pc_next,pc_in,inst,read_data1, read_data2,write_data_reg,read_data;
	
	wire reg_dst, reg_write, mem_toreg,ALUCtl, mem_read, mem_write, branch,branch_ne, j,branch_zero_and,bne_nzero_and,branching;
	wire [3:0] alu_op;
	wire [31:0] add_alu_out,pc_out_alu,alu_out,shift_out,alu_b,extend32;

	//Orginal Unit
	prgram_counter PC(clk,rst,pc_in,pc_next);
	intruction_memory IM(clk,pc_in,inst);
	reg_file RF(clk,reg_write,inst[25:21],inst[20:16],write_reg,write_data_reg,read_data1,read_data2);
	data_memory  DM(clk,alu_out,mem_write,mem_read,read_data2,read_data);

	//Control Unit
	control_unit CONTROL(inst[31:26],reg_dst,reg_write,alu_src,mem_toreg,mem_read,mem_write,branch,branch_ne,j,alu_op);
	alu_control_unit ALUCTRL(alu_op,inst[5:0],alu_crtl);

	//Contivites Unit
	mux_before_regfile BEF_RF(inst[20:16],inst[15:11],reg_dst,write_reg);
	mux_affter_regfile AFT_RF(alu_src,read_data2,extend32,alu_b);
	sign_extend SE16TO32(inst[15:0],extend32);
	shift_left_2bit ADD_ALU_B(extend32,shift_out);	
	alu ADDRESS(alu_crtl,read_data1,alu_b,alu_out,zero);
	pc_adder PCADDER(pc_next,shift_out,add_alu_out);	
	
	and(branch_zero_and,branch,zero);
	and(bne_zero_and,branch_ne,~zero);
	or(branching,branch_zero_and,bne_zero_and);

	mux_after_alu mux4_0(pc_next,add_alu_out,branching,pc_out_alu);
	mux_affter_memory mu3_0(read_data,alu_out,mem_toreg,write_data_reg);
	JCall JUPM(pc_out_alu,read_data1,j,pc_in);

endmodule