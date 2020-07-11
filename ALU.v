//op , out, A, B
module alu(Alu_op,out,zero,A,B);
	input [2:0] Alu_op;
	input [31:0] A,B;
	output [31:0] out;
	output zero;
	//we pass the parameters to both logical and arimetric units
	wire [31:0] logic_out;
	wire [31:0] ari_out;



	arimetric_unit ari_unit(ari_out,Alu_op,A,B);
	logic_unit log_unit(logic_out,Alu_op,A,B);

	reg flag;
	always @ (*) begin
		case (Alu_op)
		  3'b010: flag <= 0; // ADD
          3'b110: flag <= 0; // SUB
          3'b000: flag <= 1; // AND
          3'b001: flag <= 1; // OR
          3'b111: flag <= 0; // SLT
		endcase
	end

	mux_32bits alu_mux(out, logic_out, ari_out, flag);

	assign zero = (out == 32'd0);

endmodule
