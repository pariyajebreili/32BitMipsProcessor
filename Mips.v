/* Signals should be added to output? */
module Mips(clk, rst, pc ,Instruction, ReadData1, ReadData2,  WriteDataReg,
      WriteReg, Zero, branch, RegDst, RegWrite, MemToReg, ALUSrc, MemRead, MemWrite, ALUOperation);
	
	input clk,rst;
	
      output wire [4:0] WriteReg;
	output wire [31:0] pc,Instruction,ReadData1, ReadData2,WriteDataReg;
	
	output wire RegDst, RegWrite, MemToReg,ALUSrc,
	Zero, MemRead, MemWrite, branch;
	output wire [1:0] ALUOperation;
	wire [31:0] AddAluOut,alu_out,ShiftOut,alu_b,extend32;
      wire branch_zero_and;
      wire [31:0] MemReadData;

	//Orginal Unit
	SignExtend SE16TO32(Instruction[15:0],extend32);
      /* 0000000000000000000000000000000000000000 */
      /* maybe it's not needed. */
      // ShiftLeft2Bit ADD_ALU_B(extend32,ShiftOut);	

      and(branch_zero_and, branch, Zero);

      /* 0000000000000000000000000000000000000000 */
      /*  multiplying by 4 is not implemented in this module. maybe it's not needed.  */
	PcAdder PCADDER(.PcNext(pc), .ShiftOut(ShiftOut),.AddAluOut(AddAluOut));

	mux_2_to_1_32bits mux_after_pc_adder(.Input0(pc), .Input1(AddAluOut),
       .Selector(branch_zero_and), .Output1(pc));

	PrgramCounter PC(.clk(clk), .rst(rst), .pc(pc));

      
	IntructionMemory IM(.address(pc), .Instruction(Instruction));

      
	mux_2_to_1_5bits mux_before_regfile(.Input0(Instruction[20:16]), .Input1(Instruction[15:11]),
       .Selector(RegDst), .Output1(WriteReg));

      RegisterFile RF(.ReadRegister1(Instruction[25:21]), .ReadRegister2(Instruction[20:16]),
      .WriteData(WriteDataReg), .WriteReg(WriteReg),
      .RegWriteActive(RegWrite), .ReadData1(ReadData1), .ReadData2(ReadData2));


      // ALU Unit
	mux_2_to_1_32bits mux_after_regfile(.Input0(ReadData2), .Input1(extend32), .Selector(ALUSrc), .Output1(alu_b));
      ALU alu(.Operand1(ReadData1), .Operand2(alu_b), .ALUControl(ALUOperation), .ALUResult(alu_out), .Zero(Zero));


	//Control Unit
      Controller controller(.func(Instruction[5:0]), .opcode(Instruction[31:26]),.RegDst(RegDst),.RegWrite(RegWrite), .ALUSrc(ALUSrc),
      .MemToReg(MemToReg), .MemRead(MemRead), .MemWrite(MemWrite),.branch(branch),.ALUOperation(ALUOperation));


      // Data memory
      DataMemory DM(.addr(alu_out), .rbar_w(mem_write),
      .WriteData(ReadData2), .ReadData(MemReadData));
	mux_2_to_1_32bits mux_affter_memory(.Input0(MemReadData), .Input1(alu_out), .Selector(MemToReg), .Output1(WriteDataReg));

	

endmodule

      