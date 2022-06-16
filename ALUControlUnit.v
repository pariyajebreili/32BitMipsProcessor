module alu_control_unit (alu_op, func, alu_crtl);
  
	input      [3:0]  alu_op;
	input      [5:0]  func;
	output reg [3:0]  alu_crtl;
	wire       [5:0]  AND   = 6'b100100, OR  = 6'b100101, ADD  = 6'b100000, SUB = 6'b100010; 


	always @(alu_op, func) begin
	if      (alu_op == 0) begin alu_crtl <= 2;      end   //LW and SW use add
	else if (alu_op == 1) begin alu_crtl <= 3;      end   // branch use subtract
	else if (alu_op == 2) begin alu_crtl <= 2;      end   //add
	else if (alu_op == 3) begin alu_crtl <= 3;      end   //sub
	else if (alu_op == 4) begin alu_crtl <= 0;      end   //and
	else if (alu_op == 5) begin alu_crtl <= 1;      end   //or
	else
		case(func)
			AND: 		alu_crtl  <= 0; 	
			OR : 		alu_crtl  <= 1; 	
			ADD: 		alu_crtl  <= 2; 
			SUB: 		alu_crtl  <= 3; 
		endcase
	end
endmodule

module  data_memory (clk, addr,mem_write, mem_read,write_data,read_data);

	input wire clk,mem_write, mem_read;
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

   always @(posedge clk) begin
		if (mem_write == 1) begin
			Mem[addr] <= write_data;
		end
		if (mem_read == 1) begin
			read_data <= Mem[addr];
		end
   end

endmodule

module mux_affter_memory (read_data, alu_out, mem_toreg, write_data_reg);

	input [31:0] read_data, alu_out;
	input mem_toreg;	
	
	output reg [31:0] write_data_reg;
	
	always @(*) begin
		case (mem_toreg)
			0: write_data_reg <= alu_out ;
			1: write_data_reg <= read_data;
		endcase
	end
endmodule

module mux_affter_regfile (alu_src, read_data2, extend32, alu_b);

	input alu_src;
	input [31:0] read_data2,extend32;	
	
	output reg [31:0] alu_b;
	
	always @(alu_src, read_data2, extend32) begin
		case (alu_src)
			0: alu_b <= read_data2 ;
			1: alu_b <= extend32;
		endcase
	end
endmodule

module mux_before_regfile(rt, rd, reg_dst, write_reg);

	input [20:16] rt;
	input [15:11] rd;
	input reg_dst;
	
	output reg [4:0] write_reg;

	always @ (reg_dst, rt, rd) begin
		if(reg_dst == 1) begin  write_reg <= rd; end
		else  begin write_reg <= rt; end
	end

endmodule

module pc_adder(pc_next, shift_out, add_alu_out);

	input [31:0] pc_next;
	input [31:0] shift_out;
	
	output reg [31:0] add_alu_out;

	always @(*) begin
		add_alu_out <= pc_next + shift_out;
	end
endmodule


module prgram_counter(clk, rst, pc_in, pc_next);

	input clk, rst;
	input [31:0] pc_in;
	
	output reg [31:0] pc_next;
	
	always @(posedge clk) begin
		if (rst == 1) 
		    pc_next <= 0;
		else 
		    pc_next <= pc_in + 4; 
	end
	
endmodule

module reg_file(clk, reg_write, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);

	input clk;
	input reg_write;
	input [4:0] read_reg1, read_reg2, write_reg;
	input [31:0] write_data;
		
	output [31:0] read_data1, read_data2;
	
	reg [31:0] reg_mem [0:31];

	initial begin
		reg_mem[0] <= 0;
		reg_mem[1] <= 4;
		reg_mem[2] <= 8;
            reg_mem[3] <= 12; 
            reg_mem[4] <= 16;
            reg_mem[5] <= 16;
            reg_mem[6] <= 16;
            reg_mem[7] <= 16;
            reg_mem[8] <= 60;
            reg_mem[9] <= 13;
            reg_mem[10] <= 13;
            reg_mem[14] <= 1;
		reg_mem[31] <=16;//lable Exit
	end
	
	assign read_data1 = reg_mem[read_reg1];
	assign read_data2 = reg_mem[read_reg2];
	
	always @(posedge clk) begin
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