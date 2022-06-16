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