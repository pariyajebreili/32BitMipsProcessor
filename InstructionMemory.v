module intruction_memory(clk, address, inst);

	input clk;
	input [31:0] address;
	
	output reg [31:0]	inst;
	
	reg [31:0] IMEM [0:127];
	
	initial begin
		//r-tpe  -> rd,rs,rt
		// IMEM[1]= 32'b000100_00011_00010_0000000000000010; //CONDITION :beq $i,$b,FORM_BODY [jump 2 => line 7]
		// IMEM[2]= 32'b000100_00101_00000_0000000000000011; //beq $t0,$0,EXIT [jump 3 => line 10]
		IMEM[1]= 32'b000000_00100_00001_00100_00000_100000;//add $mul,$mul,$a;
		// IMEM[2]= 32'b000000_00101_00011_00110_00000_100111;//add $mul,$mul,$a;

		//   lw $5, 3($1 = 4)
            IMEM[2] = 32'b10001100001001010000000000000011;
		IMEM[3]= 32'b000000_00101_00011_00100_00000_101011;
		IMEM[4]= 32'b000100_00111_00111_0000000000000111; //beq $t0,$0,EXIT [jump 3 => line 10]
	end
		always @( posedge clk) inst <= IMEM[address[31:2]];
endmodule
