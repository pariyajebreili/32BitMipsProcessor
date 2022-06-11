module MipsCPU(clk, rst, pc_in,pc_next,inst,write_reg,read_data1, read_data2,alu_op,ALUSrc,zero,read_data,write_data_reg);	
	
	input clk,rst;
	output wire zero;
      output wire [4:0] write_reg;
	// output wire [3:0] alu_crtl;
      /* 0000000000000000000000000000000000000000 */
	output wire [31:0] pc_next,pc_in,inst,read_data1, read_data2,write_data_reg,read_data;
	
	wire reg_dst, reg_write, mem_toreg,ALUSrc, mem_read, mem_write, branch;
	wire [1:0] alu_op;
	wire [31:0] add_alu_out,pc_out_alu,alu_out,shift_out,alu_b,extend32;

      wire [31:0] mem_read_data;

	//Orginal Unit
	sign_extend SE16TO32(inst[15:0],extend32);
      /* 0000000000000000000000000000000000000000 */
      shift_left_2bit ADD_ALU_B(extend32,shift_out);	
      and(branch_zero_and,branch,zero);
	pc_adder PCADDER(pc,shift_out,add_alu_out);
	mux_after_alu mux4_0(pc,add_alu_out,branch_zero_and,pc_out_alu);

	prgram_counter PC(.clk(clk), .rst(rst), .pc(pc_out_alu));
	intruction_memory IM(.address(pc), .inst(inst));

      /* 0000000000000000000000000000000000000000 */
	mux_before_regfile BEF_RF(inst[20:16],inst[15:11],reg_dst,write_reg);

      register_file RF(.ReadRegister1(inst[25:21]), .ReadRegister2(inst[20:16]),
       .WriteData(write_data_reg), .WriteReg(write_reg),
      .RegWriteActive(reg_write), .ReadData1(read_data1), .ReadData2(read_data2));

      // register_file RF(reg_write,inst[25:21],inst[20:16],write_reg,write_data_reg,read_data1,read_data2);

      // ALU Unit

	mux_after_regfile AFT_RF(alu_src,read_data2,extend32,alu_b);
      ALU alu(.Operand1(read_data1), .Operand2(alu_b), .ALUControl(alu_op), .ALUResult(alu_out), .Zero(zero));
	// alu ADDRESS(alu_crtl,read_data1,alu_b,alu_out,zero);


	//Control Unit
      Controller controller(.func(inst[5:0]), .opcode(inst[31:26]),.reg_dst(reg_dst),.reg_write(reg_write), .alu_src(ALUSrc),
      .mem_to_reg(mem_toreg), .mem_read(mem_read), .mem_write(mem_write),.branch(branch),.alu_op(alu_op))

	// control_unit CONTROL(inst[31:26],reg_dst,reg_write,alu_src,mem_toreg,mem_read,mem_write,branch,branch_ne,j,alu_op);
	// alu_control_unit ALUCTRL(alu_op,inst[5:0],alu_crtl);

      // Data memory
      data_memory DataMemory(.addr(alu_out), .rbar_w(mem_write),
      .write_data(read_data2), .read_data(mem_read_data));
	mux_affter_memory mu3_0(mem_read_data,alu_out,mem_toreg,write_data_reg);
       
      // data_memory DM(.address(alu_out), .data_in(read_data), .data_out(mem_read_data));
	// data_memory  DM(clk,alu_out,mem_write,mem_read,,mem_read_data);


	//Contivites Unit
	// shift_left_2bit ADD_ALU_B(extend32,shift_out);	
	


endmodule


module testbech();

      reg clk,rst;
      wire pc_in,pc_next,inst,write_reg,read_data1, read_data2,alu_op,ALUSrc,zero,read_data,write_data_reg
      

      MipsCPU UUT(clk, rst, pc_in,pc_next,inst,write_reg,read_data1, read_data2,alu_op,ALUSrc,zero,read_data,write_data_reg)

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