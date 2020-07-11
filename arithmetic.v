module full_adder(out, carry_out, A, B, carry_in);
	input A, B, carry_in;
	output carry_out, out;
	wire half_adder_out, half_adder_carry, second_half_adder_carry;
	half_adder half_add(half_adder_out, half_adder_carry, A, B);
	half_adder second_half_add(out, second_half_adder_carry, half_adder_out, carry_in);
	or (carry_out, half_adder_carry, second_half_adder_carry);
endmodule

module half_adder(out, carry_out, A, B);
	input A, B;
	output out, carry_out;
	xor (out, A, B);
	and (carry_out, A, B);
endmodule


module addersubstractor(out, A, B, flag);
	input [31:0] A, B;
	input flag;
	output [31:0] out;
	wire negation_connection;
	wire [31:0] carry, negation_out, two_complement, mux_out;
	not_32bits n32b(negation_out, B);
	assign two_complement = negation_out + 1'b1;
	mux_32bits m32b(mux_out, two_complement, B, flag);
	half_adder first_addition(out[0], carry[0], A[0], mux_out[0]);
	genvar counter;
	for (counter = 1; counter < 32; counter = counter + 1) begin : additions
		full_adder full_addition(out[counter], carry[counter], A[counter], mux_out[counter], carry[counter-1]);
	end	
endmodule



module arimetric_out(out,add_out,flag);
	input flag;
	input [31:0] add_out;
	output [31:0]out;
	
	//grabs the sign of add_out and convets it to 32 bits
	wire [31:0] sign_extended;
	sign_extend s_extend(sign_extended, add_out[31]);
	
	//decides if the output is the sign or the result of the arimetric operation
	mux_32bits m32b(out,sign_extended, add_out,flag);	
endmodule


module arimetric_unit(out,opcode,A,B);
	input [31:0] A,B;
	input [2:0] opcode;
	output [31:0] out;
	
	//we pass trought the addersubstractor
	wire [31:0] adder_out;
	addersubstractor adder_sub(adder_out, A, B, opcode[2]);
	//we pass trought the arimetric out
	reg flag;
	always @ (*) begin
		if (opcode == 3'b111)
        flag <= 1;// SLT
		else flag <= 0;
	end
	arimetric_out ari_out(out,adder_out,flag);
endmodule 


//Intentamos implementar el carry look ahead pero interferia con la resta
//Esto funcionaba solo en la suma

//module CLA_4bit_begin(out, carry_out, A, B);
//	input [3:0] A, B;
//	output [3:0] out;
//	output carry_out;
//	genvar counter;
//	wire [3:0] carry;
//	assign carry_out = 	(((((((A[1] | B[1]) & (A[0] & B[0])) + A[1] & B[1]) & (A[2] | B[2])) | (A[2] & B[2])) & (A[3] | B[3])) | (A[3] & B[3]));
//	half_adder first_addition(out[0], carry[0], A[0], B[0]);
//	for (counter = 1; counter < 4; counter = counter + 1) begin : additions
//		full_adder full_addition(out[counter], carry[counter], A[counter], B[counter], carry[counter-1]);
//	end	
//
//endmodule

//module CLA_4bit(out, carry_out, A, B, carry_in);
//	input [3:0] A, B;
//	output [3:0] out;
//	input carry_in;
//	output carry_out;
//	genvar counter;
//	wire [4:0] carry;
//	assign carry[0] = carry_in;
//	//Recursividad?, JA!
//	assign carry_out = (((((((A[1] | B[1]) & (A[0] & B[0])) + A[1] & B[1]) & (A[2] | B[2])) | (A[2] & B[2])) & (A[3] | B[3])) | (A[3] & B[3])) | (carry_in & ((A[0] | B[0]) & (A[1] | B[1]) & (A[2] | B[2]) & (A[3] | B[3])));
//	for (counter = 0; counter < 4; counter = counter + 1) begin : additions
//		full_adder full_addition(out[counter], carry[counter+1], A[counter], B[counter], carry[counter]);
//	end	
//
//endmodule


//module addersubstractor(out, A, B, flag);
//	input [31:0] A, B;
//	wire [7:0] [3:0] A_divided, B_divided, out_divided;
//	input flag;
//	output [31:0] out;
//	wire [7:0] carry_4block;
//	wire [31:0] mux_out, negation_out, negation_two_complement;
//	not_32bits n32b(negation_out, B);
//	assign negation_two_complement = negation_out + 1'b1;
//	mux_32bits m32b(mux_out, negation_two_complement, B,flag);
//	genvar counter, second_counter, third_counter;
//	for (counter = 0; counter < 8; counter = counter + 1) begin : Cable_Division
//		for (second_counter = 0; second_counter < 4; second_counter = second_counter + 1) begin : section_4bit
//			assign A_divided[counter][second_counter] = A[(counter*4)+(second_counter)];
//			assign B_divided[counter][second_counter] = mux_out[(counter*4)+(second_counter)];
//			assign out[(counter*4)+(second_counter)] = out_divided[counter][second_counter];
//		end
//	end
//	CLA_4bit_begin first_CLA(out_divided[0],carry_4block[0],A_divided[0],B_divided[0]);
//	for (counter = 1; counter < 8; counter = counter + 1) begin : CLAs
//		CLA_4bit CLA(out_divided[counter],carry_4block[counter],A_divided[counter],B_divided[counter],carry_4block[counter-1]);
//	end
//	
//endmodule 


