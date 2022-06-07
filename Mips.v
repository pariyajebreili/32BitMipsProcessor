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




module intruction_memory(clk, address, inst);

	input clk;

	input [31:0] address;

	output reg [31:0]	inst;
	
	reg [31:0] IMEM [0:127];

	always @( posedge clk) inst <= IMEM[address[31:2]];
      
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