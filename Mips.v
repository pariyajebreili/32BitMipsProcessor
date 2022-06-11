module Mips(clk, rst, PcIn,PcNext,Instruction,WriteReg,ReadData1, ReadData2,ALUOperation,ALUSrc,zero,ReadData,WriteDataReg);	
	
	input clk,rst;
	output wire zero;
      output wire [4:0] WriteReg;
	// output wire [3:0] alu_crtl;
      /* 0000000000000000000000000000000000000000 */
	output wire [31:0] PcNext,PcIn,Instruction,ReadData1, ReadData2,WriteDataReg,ReadData;
	
	wire RegDst, RegWrite, MemToReg,ALUSrc, MemRead, MemWrite, branch;
	wire [1:0] ALUOperation;
	wire [31:0] AddAluOut,PcOutAlu,alu_out,ShiftOut,alu_b,extend32;

      wire [31:0] MemReadData;

	//Orginal Unit
	sign_extend SE16TO32(Instruction[15:0],extend32);
      /* 0000000000000000000000000000000000000000 */
      ShiftLeft2Bit ADD_ALU_B(extend32,ShiftOut);	
      and(branch_zero_and,branch,zero);
	PcAdder PCADDER(pc,ShiftOut,AddAluOut);
	mux_after_alu mux4_0(pc,AddAluOut,branch_zero_and,PcOutAlu);

	PrgramCounter PC(.clk(clk), .rst(rst), .pc(PcOutAlu));
	IntructionMemory IM(.address(pc), .Instruction(Instruction));

      /* 0000000000000000000000000000000000000000 */
	mux_before_regfile BEF_RF(Instruction[20:16],Instruction[15:11],reg_dst,WriteReg);

      RegisterFile RF(.ReadRegister1(Instruction[25:21]), .ReadRegister2(Instruction[20:16]),
      .WriteData(WriteDataReg), .WriteReg(WriteReg),
      .RegWriteActive(reg_write), .ReadData1(ReadData1), .ReadData2(ReadData2));


      // ALU Unit

	mux_after_regfile AFT_RF(alu_src,ReadData2,extend32,alu_b);
      ALU alu(.Operand1(ReadData1), .Operand2(alu_b), .ALUControl(ALUOperation), .ALUResult(alu_out), .Zero(zero));


	//Control Unit
      Controller controller(.func(Instruction[5:0]), .opcode(Instruction[31:26]),.RegDst(RegDst),.RegWrite(RegWrite), .ALUSrc(ALUSrc),
      .MemToReg(MemToReg), .MemRead(MemRead), .MemWrite(MemWrite),.branch(branch),.ALUOperation(ALUOperation))


      // Data memory
      DataMemory DataMemory(.addr(alu_out), .rbar_w(mem_write),
      .WriteData(ReadData2), .ReadData(MemReadData));
	mux_affter_memory mu3_0(MemReadData,alu_out,MemToReg,WriteDataReg);

	

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