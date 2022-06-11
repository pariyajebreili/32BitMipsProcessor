module  data_memory (addr, rbar_w, write_data, read_data);
   
   // rbar_w: control signal - Not Read Or Write
   // rbar_w = 1 => Write
   // rbar_w = 0 => Read
   
      input rbar_w;
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

	always @(addr or rbar_w) begin
	      if(rbar_w == 1)
	      begin
	         // Write
	         Mem[addr] <= write_data;
	      end
	      else
	      begin
	         // Read
        	   read_data <= Mem[addr];      
         end
	end

endmodule