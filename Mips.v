`timescale 1ns/1ns
module Mips(clk, rst, pc_in, PCNext ,Instruction, ReadData1, ReadData2,  WriteDataReg,
      WriteReg, Zero, branch, RegDst, RegWrite, MemToReg, ALUSrc, MemRead, MemWrite, ALUOperation, MemReadData, alu_out, alu_b);
	
	input clk,rst;
	
      output wire [4:0] WriteReg;
	output wire [31:0] Instruction,ReadData1, ReadData2,WriteDataReg, alu_out, MemReadData;
	output wire [31:0] pc_in, PCNext, alu_b;
	
	
	output wire RegDst, RegWrite, MemToReg,ALUSrc,
	Zero, MemRead, MemWrite, branch;
	output wire [1:0] ALUOperation;
	wire [31:0] AddAluOut,ShiftOut,extend32;

      wire branch_zero_and;
      // wire [31:0] MemReadData;





	ProgramCounter PC(.clk(clk), .rst(rst), .PcIn(pc_in), .PcNext(pc_in));
   


	//Orginal Unit
	SignExtend SE16TO32(Instruction[15:0],extend32);


      and(branch_zero_and, branch, Zero);
      /* changed PCNext to pc_in.... */
	PcAdder PCADDER(.PcNext(pc_in), .ShiftOut(extend32),.AddAluOut(AddAluOut));
      /* changed PCNext to pc_in.... */
      /* why we can't change output to pc_in? */
	mux_2_to_1_32bits mux_after_pc_adder(.Input0(pc_in), .Input1(AddAluOut),
       .Selector(branch_zero_and), .Output1(PCNext));


      /* pc_in or PCNext? obviously pc_in but why it's not working.................. */
	IntructionMemory IM(.Address(pc_in), .Instruction(Instruction));

      
	mux_2_to_1_5bits mux_before_regfile(.Input0(Instruction[20:16]), .Input1(Instruction[15:11]),
       .Selector(RegDst), .Output1(WriteReg));

      RegisterFile RF(.rst(rst), .ReadRegister1(Instruction[25:21]), .ReadRegister2(Instruction[20:16]),
      .WriteData(WriteDataReg), .WriteReg(WriteReg),
      .RegWriteActive(RegWrite), .ReadData1(ReadData1), .ReadData2(ReadData2));


      // ALU Unit
	mux_2_to_1_32bits mux_after_regfile(.Input0(ReadData2), .Input1(extend32), .Selector(ALUSrc), .Output1(alu_b));
      ALU alu(.Operand1(ReadData1), .Operand2(alu_b), .ALUControl(ALUOperation), .ALUResult(alu_out), .Zero(Zero));


	//Control Unit
      Controller controller(.func(Instruction[5:0]), .opcode(Instruction[31:26]),.RegDst(RegDst),.RegWrite(RegWrite), .ALUSrc(ALUSrc),
      .MemToReg(MemToReg), .MemRead(MemRead), .MemWrite(MemWrite),.branch(branch),.ALUOperation(ALUOperation));


      // Data memory
      DataMemory DM(.Address(alu_out), .rbar_w(MemWrite),
      .WriteData(ReadData2), .ReadData(MemReadData));
	mux_2_to_1_32bits mux_affter_memory(.Input0(alu_out), .Input1(MemReadData), .Selector(MemToReg), .Output1(WriteDataReg));

	

endmodule


module testbech();

      reg clk,rst;
      wire ALUSrc,Zero;
      wire [4:0] WriteReg;
      wire [1:0] ALUOperation;
      wire [31:0] Instruction,alu_b, pc_in, PCNext, ReadData1, ReadData2, WriteDataReg, MemReadData, alu_out;
 
      integer i;
   
      Mips MIPS(clk, rst, pc_in, PCNext ,Instruction, ReadData1, ReadData2,  WriteDataReg,
      WriteReg, Zero, branch, RegDst, RegWrite, MemToReg, ALUSrc, MemRead, MemWrite, ALUOperation, MemReadData, alu_out, alu_b);
      
 
    initial begin
   
       rst = 1;
       clk = 0;
       clk = 1;
       
       #50;
       rst = 0;

          
       
       for(i = 0; i <= 20; i = i + 1)
       begin
          
          clk = ~clk;
          #50;
       end
       
   end

endmodule