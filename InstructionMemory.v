module intruction_memory(clk, address, inst);

	input clk;
	input [31:0] address;
	output reg [31:0]	inst;
	reg [31:0] IMEM [0:127];
	
	initial begin
		//r-tpe  -> rd,rs,rt
		IMEM[1]= 32'b000000_00100_00001_00100_00000_100000;//add $mul,$mul,$a;
            IMEM[2] = 32'b10001100001001010000000000000011;// lw $5, 3($1 = 4)
		IMEM[3]= 32'b000000_00101_00011_00100_00000_101011;//add 
		IMEM[4]= 32'b000100_00111_00111_0000000000000111; //beq $t0,$0,EXIT [jump 3 => line 10]
	end

	always @( posedge clk) inst <= IMEM[address[31:2]];
endmodule
