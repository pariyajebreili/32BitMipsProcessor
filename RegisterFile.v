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


