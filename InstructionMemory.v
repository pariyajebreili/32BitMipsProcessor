
module IntructionMemory(Address, Instruction);

	input [31:0] Address;

	output reg [31:0] Instruction;
	
	reg [31:0] IMEM [0:127];

	always @(Address) Instruction = IMEM[Address];


    initial
    begin
          // add $3, $2, $1
          IMEM[0]  = 32'b00000000001000100001100000100000;
          
          // sub $10, $5, $9    
          IMEM[1]  = 32'b00000001001001010101000000100010;
          /*
          IMEM[2]  = 32'b;
          IMEM[3]  = 32'b;
          IMEM[4]  = 32'b;
          IMEM[5]  = 32'b;
          IMEM[6]  = 32'b;
          IMEM[7]  = 32'b;
          IMEM[8]  = 32'b;
          IMEM[9]  = 32'b;
          IMEM[10] = 32'b;
          IMEM[11] = 32'b;
          IMEM[12] = 32'b;
          IMEM[13] = 32'b;
          IMEM[14] = 32'b;
          IMEM[15] = 32'b;
          */
    end
      
endmodule