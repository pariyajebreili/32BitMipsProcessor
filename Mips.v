module Mips(clk, rst, PcIn,PcNext,Instruction,WriteReg,ReadData1, ReadData2,ALUOperation,ALUSrc,zero,ReadData,WriteDataReg);	
	
	input clk,rst;
	output wire zero;
      output wire [4:0] WriteReg;
	// output wire [3:0] alu_crtl;
      /* 0000000000000000000000000000000000000000 */
	output wire [31:0] PcNext,PcIn,Instruction,ReadData1, ReadData2,WriteDataReg,ReadData;
	
	wire reg_dst, reg_write, mem_toreg,ALUSrc, mem_read, mem_write, branch;
	wire [1:0] ALUOperation;
	wire [31:0] add_alu_out,PcOutAlu,alu_out,shift_out,alu_b,extend32;

      wire [31:0] MemReadData;

	//Orginal Unit
	sign_extend SE16TO32(Instruction[15:0],extend32);
      /* 0000000000000000000000000000000000000000 */
      shift_left_2bit ADD_ALU_B(extend32,shift_out);	
      and(branch_zero_and,branch,zero);
	pc_adder PCADDER(pc,shift_out,add_alu_out);
	mux_after_alu mux4_0(pc,add_alu_out,branch_zero_and,PcOutAlu);

	PrgramCounter PC(.clk(clk), .rst(rst), .pc(PcOutAlu));
	IntructionMemory IM(.address(pc), .Instruction(Instruction));

      /* 0000000000000000000000000000000000000000 */
	mux_before_regfile BEF_RF(Instruction[20:16],Instruction[15:11],reg_dst,WriteReg);

      RegisterFile RF(.ReadRegister1(Instruction[25:21]), .ReadRegister2(Instruction[20:16]),
       .WriteData(WriteDataReg), .WriteReg(WriteReg),
      .RegWriteActive(reg_write), .ReadData1(ReadData1), .ReadData2(ReadData2));

      // register_file RF(reg_write,inst[25:21],inst[20:16],write_reg,write_data_reg,read_data1,read_data2);

      // ALU Unit

	mux_after_regfile AFT_RF(alu_src,ReadData2,extend32,alu_b);
      ALU alu(.Operand1(ReadData1), .Operand2(alu_b), .ALUControl(ALUOperation), .ALUResult(alu_out), .Zero(zero));
	// alu ADDRESS(alu_crtl,read_data1,alu_b,alu_out,zero);


	//Control Unit
      Controller controller(.func(Instruction[5:0]), .opcode(Instruction[31:26]),.reg_dst(reg_dst),.reg_write(reg_write), .alu_src(ALUSrc),
      .mem_to_reg(mem_toreg), .mem_read(mem_read), .mem_write(mem_write),.branch(branch),.ALUOperation(ALUOperation))

	// control_unit CONTROL(inst[31:26],reg_dst,reg_write,alu_src,mem_toreg,mem_read,mem_write,branch,branch_ne,j,alu_op);
	// alu_control_unit ALUCTRL(alu_op,inst[5:0],alu_crtl);

      // Data memory
      data_memory DataMemory(.addr(alu_out), .rbar_w(mem_write),
      .write_data(ReadData2), .ReadData(MemReadData));
	mux_affter_memory mu3_0(MemReadData,alu_out,mem_toreg,WriteDataReg);
       
      // data_memory DM(.address(alu_out), .data_in(read_data), .data_out(MemReadData));
	// data_memory  DM(clk,alu_out,mem_write,mem_read,,MemReadData);


	//Contivites Unit
	// shift_left_2bit ADD_ALU_B(extend32,shift_out);	
	


endmodule


module testbech();

      reg clk,rst;
      wire PcIn,PcNext,Instruction,WriteReg,ReadData1, ReadData2,ALUOperation,ALUSrc,zero,ReadData,WriteDataReg
      

      Mips UUT(clk, rst, PcIn,PcNext,Instruction,WriteReg,ReadData1, ReadData2,ALUOperation,ALUSrc,zero,ReadData,WriteDataReg)

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