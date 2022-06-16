module MipsCPU(CLK, rst, PCIn,PCNext,Instruction,WriteReg,ReadData1, ReadData2,ALUControl,Zero,read_data,write_data_reg);	
	
	input CLK,rst;
	output wire Zero;
      output wire [4:0] WriteReg;
	output wire [3:0] ALUControl;
	output wire [31:0] PCNext,PCIn,Instruction,ReadData1, ReadData2,write_data_reg,read_data;
	
	wire reg_dst, reg_write, mem_toreg,ALUCtl, mem_read, mem_write, branch,branch_ne, j,branch_Zero_and,bne_nZero_and,branching;
	wire [3:0] alu_op;
	wire [31:0] add_alu_out,pc_out_alu,alu_out,shift_out,alu_b,extend32;

	//Orginal Unit
	prgram_counter PC(CLK,rst,PCIn,PCNext);
	intruction_memory IM(CLK,PCIn,Instruction);
	reg_file RF(CLK,reg_write,Instruction[25:21],Instruction[20:16],WriteReg,write_data_reg,ReadData1,ReadData2);
	data_memory  DM(CLK,alu_out,mem_write,mem_read,ReadData2,read_data);

	//Control Unit
	control_unit CONTROL(Instruction[31:26],reg_dst,reg_write,alu_src,mem_toreg,mem_read,mem_write,branch,branch_ne,j,alu_op);
	alu_control_unit ALUCTRL(alu_op,Instruction[5:0],ALUControl);

	//Contivites Unit
	mux_before_regfile BEF_RF(Instruction[20:16],Instruction[15:11],reg_dst,WriteReg);
	mux_affter_regfile AFT_RF(alu_src,ReadData2,extend32,alu_b);
	sign_extend SE16TO32(Instruction[15:0],extend32);
	shift_left_2bit ADD_ALU_B(extend32,shift_out);	
	alu ADDRESS(ALUControl,ReadData1,alu_b,alu_out,Zero);
	pc_adder PCADDER(PCNext,shift_out,add_alu_out);	
	
	and(branch_Zero_and,branch,Zero);
	and(bne_Zero_and,branch_ne,~Zero);
	or(branching,branch_Zero_and,bne_Zero_and);

	mux_after_alu mux4_0(PCNext,add_alu_out,branching,pc_out_alu);
	mux_affter_memory mu3_0(read_data,alu_out,mem_toreg,write_data_reg);
	JCall JUPM(pc_out_alu,ReadData1,j,PCIn);

endmodule

module alu (ALUControl, A, B, alu_out, Zero);
	input [3:0] ALUControl;
	input [31:0] A,B;
	output Zero;
	output reg [31:0] alu_out;
   
	assign Zero   = (alu_out == 0);
	// assign n_Zero = (alu_out != 0);

	always @(ALUControl, A, B) begin
		case (ALUControl)
			0: alu_out = A & B;
			1: alu_out = A | B;
			2: alu_out = A + B;
			3: alu_out = A - B;
			
			default: alu_out = 0;
		endcase
	end
endmodule


module alu_control_unit (alu_op, func, ALUControl);
  
	input      [3:0]  alu_op;
	input      [5:0]  func;
	output reg [3:0]  ALUControl;
	wire       [5:0]  AND   = 6'b100100, OR  = 6'b100101, ADD  = 6'b100000, SUB = 6'b100010; 


	always @(alu_op, func) begin
	if      (alu_op == 0) begin ALUControl <= 2;      end   //LW and SW use add
	else if (alu_op == 1) begin ALUControl <= 3;      end   // branch use subtract
	else if (alu_op == 2) begin ALUControl <= 2;      end   //add
	else if (alu_op == 3) begin ALUControl <= 3;      end   //sub
	else if (alu_op == 4) begin ALUControl <= 0;      end   //and
	else if (alu_op == 5) begin ALUControl <= 1;      end   //or
	else
		case(func)
			AND: 		ALUControl  <= 0; 	
			OR : 		ALUControl  <= 1; 	
			ADD: 		ALUControl  <= 2; 
			SUB: 		ALUControl  <= 3; 
		endcase
	end
endmodule


module control_unit(opcode,reg_dst,reg_write, alu_src,mem_toreg, mem_read, mem_write,branch,branch_ne,j,alu_op);
	
	input [5:0] opcode;
	output reg reg_dst,reg_write, alu_src,j,mem_toreg, mem_read, mem_write,branch,branch_ne;
	output reg [3:0] alu_op;
 
   wire [5:0] LW = 6'b100011/*35*/, SW  = 6'b101011/*43*/,BEQ   = 6'b000100/*4*/, J = 6'b000010/*2*/,RTYPE = 6'b000000/*0*/;
				  
	
	always @(*) begin
		//reset...
		reg_dst = 0;
		alu_src = 0;
		mem_toreg = 0;
		reg_write = 0;
		mem_read = 0;
		mem_write = 0;
		branch = 0;
		j = 0;

		//select oprand
		case(opcode)	
			LW: begin
				alu_src = 1;
				reg_write = 1;
				mem_read = 1;
				mem_write = 1;
				alu_op = 4'b0000;//0
			end
			SW: begin
				alu_src = 1;
				mem_write = 1;
				alu_op = 4'b0000;//0
			end
			BEQ: begin
				branch = 1;
				alu_op = 4'b0001;/*1*/
			end
			J: begin
				j  = 1;
			end
			RTYPE: begin
				reg_dst = 1;
				reg_write = 1;
				alu_op = 4'b1111;
			end
		endcase
	end
endmodule


module  data_memory (CLK, addr,mem_write, mem_read,write_data,read_data);

	input wire CLK,mem_write, mem_read;
	input wire [31:0] addr,write_data;
	output reg [31:0] read_data;

      reg [31:0] Mem[0:255];

      integer i;

      initial begin
		read_data <= 0;
		for (i = 0; i < 256; i = i + 1) begin
			Mem[i] = i;
		end
      end

      always @(posedge CLK) begin
		if (mem_write == 1) begin
			Mem[addr] = write_data;
		end
		if (mem_read == 1) begin
			read_data = Mem[addr];
		end
      end

endmodule

module intruction_memory(CLK, address, Instruction);

	input CLK;
	input [31:0] address;
	output reg [31:0]	Instruction;
	reg [31:0] IMEM [0:127];
	
	initial begin
		//r-tpe  -> rd,rs,rt
		IMEM[1]= 32'b000000_00100_00001_00100_00000_100000;//add $mul,$mul,$a;
            IMEM[2] = 32'b10001100001001010000000000000011;// lw $5, 3($1 = 4)
		IMEM[3]= 32'b000000_00101_00011_00100_00000_101011;//add 
		IMEM[4]= 32'b000100_00111_00111_0000000000000111; //beq $t0,$0,EXIT [jump 3 => line 10]
	end

	always @( posedge CLK) Instruction <= IMEM[address[31:2]];
endmodule


module JCall(pc_out_alu,ReadData1,j,PCIn);
	input [31:0] pc_out_alu, ReadData1;
	input j;	
	
	output reg [31:0] PCIn;
	
	always @(*) begin
		if   (j) begin PCIn = ReadData1; end
		else     begin PCIn = pc_out_alu;     end
	end
endmodule


module mux_after_alu (PCNext, add_alu_out, branch_Zero_and, PCIn);
	input [31:0] PCNext, add_alu_out;
	input branch_Zero_and;	
	
	output reg [31:0] PCIn;
	
	initial PCIn <= 0;

	always @(*) begin
		if(branch_Zero_and) begin PCIn <= add_alu_out; end 
		else begin  PCIn <= PCNext ; end
	end
endmodule


module mux_affter_memory (read_data, alu_out, mem_toreg, write_data_reg);

	input [31:0] read_data, alu_out;
	input mem_toreg;	
	
	output reg [31:0] write_data_reg;
	
	always @(*) begin
		case (mem_toreg)
			0: write_data_reg = alu_out ;
			1: write_data_reg = read_data;
		endcase
	end
endmodule


module mux_affter_regfile (alu_src, ReadData2, extend32, alu_b);

	input alu_src;
	input [31:0] ReadData2,extend32;	
	
	output reg [31:0] alu_b;
	
	always @(alu_src, ReadData2, extend32) begin
		case (alu_src)
			0: alu_b = ReadData2 ;
			1: alu_b = extend32;
		endcase
	end
endmodule

module mux_before_regfile(rt, rd, reg_dst, write_reg);

	input [20:16] rt;
	input [15:11] rd;
	input reg_dst;
	
	output reg [4:0] write_reg;

	always @ (reg_dst, rt, rd) begin
		if(reg_dst == 1) begin  write_reg = rd; end
		else  begin write_reg = rt; end
	end

endmodule

module pc_adder(PCNext, shift_out, add_alu_out);

	input [31:0] PCNext;
	input [31:0] shift_out;
	
	output reg [31:0] add_alu_out;

	always @(*) begin
		add_alu_out = PCNext + shift_out;
	end
endmodule

module prgram_counter(CLK, rst, PCIn, PCNext);

	input CLK, rst;
	input [31:0] PCIn;
	
	output reg [31:0] PCNext;
	
	always @(posedge CLK) begin
		if (rst == 1) 
		    PCNext = 0;
		else 
		    PCNext = PCIn + 4; 
	end
	
endmodule

module reg_file(CLK, reg_write, read_reg1, read_reg2, write_reg, write_data, ReadData1, ReadData2);

	input CLK;
	input reg_write;
	input [4:0] read_reg1, read_reg2, write_reg;
	input [31:0] write_data;
		
	output [31:0] ReadData1, ReadData2;
	
	reg [31:0] reg_mem [0:31];

	initial begin
		reg_mem[0] = 0;
		reg_mem[1] = 4;
		reg_mem[2] = 8;
            reg_mem[3] = 12; 
            reg_mem[4] = 16;
            reg_mem[5] = 16;
            reg_mem[6] = 16;
            reg_mem[7] = 16;
            reg_mem[8] = 60;
            reg_mem[9] = 13;

	end
	
	assign ReadData1 = reg_mem[read_reg1];
	assign ReadData2 = reg_mem[read_reg2];
	
	always @(posedge CLK) begin
		if (reg_write == 1)
			reg_mem[write_reg] = write_data;
	end	
endmodule


module shift_left_2bit (ShiftIn, shift_out);

	input [31:0] ShiftIn;
	output reg [31:0] shift_out;
	
	always @(ShiftIn) begin
		shift_out = ShiftIn << 2;
	end 
	
endmodule

module sign_extend (in16, out32);

	input [15:0] in16;
	output reg [31:0] out32;

	always @(in16) out32[31:0] <= in16[15:0];
	
endmodule