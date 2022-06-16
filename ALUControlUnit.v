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
	else if (alu_op == 5) begin alu_crtl <= 0;      end   //and
	else if (alu_op == 7) begin alu_crtl <= 1;      end   //or
	else
		case(func)
			AND: 		alu_crtl  <= 0; 	
			OR : 		alu_crtl  <= 1; 	
			ADD: 		alu_crtl  <= 2; 
			SUB: 		alu_crtl  <= 3; 
			// JR : 		alu_crtl  <= 10;
			// JALR:    alu_crtl  <= 11;	
			default: alu_crtl  <= 15; //should not happen
		endcase
	end
endmodule