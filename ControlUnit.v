module control_unit(opcode,reg_dst,reg_write, alu_src,mem_toreg, mem_read, mem_write,branch,branch_ne,j,alu_op);
	
	input [5:0] opcode;
	output reg reg_dst,reg_write, alu_src,j,mem_toreg, mem_read, mem_write,branch,branch_ne;
	output reg [3:0] alu_op;
 
   wire [5:0] LW = 6'b100011/*35*/, SW  = 6'b101011/*43*/, ADDI = 6'b001000/*8*/,
              SUBI  = 6'b100111/*42*/, ANDI  = 6'b101111/*50*/, ORI  = 6'b110010/*8*/,
	 	  BEQ   = 6'b000100/*4*/, J = 6'b000010/*2*/,RTYPE = 6'b000000/*0*/;
				  
	
	always @(*) begin
		//reset...
		reg_dst 		<= 0;
		alu_src 		<= 0;
		mem_toreg	<= 0;
		reg_write	<= 0;
		mem_read		<= 0;
		mem_write	<= 0;
		branch		<= 0;
		j		      <= 0;

		//select oprand
		case(opcode)	
			LW: begin
				alu_src 		<= 1;
				reg_write	<= 1;
				mem_read		<= 1;
				mem_write	<= 1;
				alu_op		<= 4'b0000;/*0*/
			end
			SW: begin
				alu_src 		<= 1;
				mem_write	<= 1;
				alu_op		<= 4'b0000;/*0*/
			end
			BEQ: begin
				branch		<= 1;
				alu_op		<= 4'b0001;/*1*/
			end
			ADDI: begin
				alu_src 		<= 1;
				reg_write	<= 1;
				alu_op		<= 4'b0010;/*2*/
			end
			SUBI: begin
				alu_src 		<= 1;
				reg_write	<= 1;
				alu_op		<= 4'b0011;/*3*/
			end
			ANDI: begin
				alu_src 		<= 1;
				reg_write	<= 1;
				alu_op		<= 4'b0101;/*5*/
			end
			ORI: begin
				alu_src 		<= 1;
				reg_write	<= 1;
				alu_op		<= 4'b0111;/*7*/
			end
			J: begin
				j              <= 1;
				// alu_op			<= 4'bxxxx;
			end
			RTYPE: begin
				reg_dst 		<= 1;
				reg_write		<= 1;
				alu_op		<= 4'b1111;
			end
		endcase
	end
endmodule