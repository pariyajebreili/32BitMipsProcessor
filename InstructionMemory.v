`timescale 1ns/1ns
module IntructionMemory(Address, Instruction);

	input [31:0] Address;

	output reg [31:0] Instruction;
	
	reg [31:0] IMEM [0:127];

	always @(Address) Instruction = IMEM[Address];


    initial
    begin
          // add $3, $2, $1
           //IMEM[0]  = 32'b00000000001000100001100000100000;
          
          // sub $10, $5, $9    
           //IMEM[1]  = 32'b00000001001001010101000000100010;

         // add $10, $10, $0;
           //IMEM[2]  = 32'b00000001010000000101000000100000;

        // add $20, $20, $0;
           //IMEM[3]  = 32'b00000010100000001010000000100000;

        //   add $3, $3, $0;
           //IMEM[0]  = 32'b00000000000000110001100000100000;

        // add $20, $5, $6
            IMEM[0] = 32'b00000000110001011010000000100000;

        // sub $21, $3, $4
            IMEM[1] = 32'b00000000011001001010100000100010;

        // sub $3, $2, $1
            IMEM[2]  = 32'b00000000001000100001100000100010;

         //add $4, $2, $1
         IMEM[3]  = 32'b00000000001000100010000000100000;
         

         
        //  add $7, $3, $3
         IMEM[4]  = 32'b00000000101001010011100000100000; // this will work because it's not $7 in rs and rt

         // add $4, $3, $3;
         IMEM[5] = 32'b00000000011000110010000000100000;

        // add $4, $3, $0;
         IMEM[6] = 32'b00000000000000110010000000100000; // working fine

        // **************************** BUGS ARE IN INSTRUCTION WHICH HAVE SAME $rd and $rs or $rt like add $4, $4, $2....

        // lw $5, 3($1 = 4)
        IMEM[7] = 32'b10001100001001010000000000000011;
        
        //add $5 = 8, $5 = 4, $1 = 4
        //IMEM[1] = 32'b00000000101000010010100000100000;
        //IMEM[2] = 32'b00000000101000010010100000100000;

        // sw , 0($2)

          
    end
      
endmodule