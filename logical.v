module not_32bits(out, B);
	input [31:0] B;
	output [31:0] out;
	
	genvar counter;
	for(counter = 0; counter<32; counter = counter + 1) begin : nots 
		not not_de_1bit(out[counter], B[counter]);
	end
endmodule 

module xor_32bits(out, A, B);

	input [31:0] A, B;
	output [31:0] out;
	
	genvar counter;
	for (counter = 0; counter < 32; counter = counter + 1) begin : xors
		xor xor_de_1bit(out[counter] ,A[counter], B[counter]);
	end

endmodule

module or_32bits(out, A, B);
	
	input [31:0] A, B; 
	output [31:0] out;

	genvar counter;
	for (counter = 0; counter < 32; counter = counter + 1) begin : ors
		or or_de_1bit(out[counter] ,A[counter], B[counter]);
	end
endmodule

module and_32bits(out, A, B);
	input [31:0] A, B;
	output [31:0] out;

	genvar counter;
	for (counter = 0; counter < 32; counter = counter + 1) begin : ands
		and and_de_1bit(out[counter], A[counter], B[counter]);
	end
endmodule

module nor_32bits(out,A,B);
    input[31:0] A,B;
    output [31:0] out;
    wire [31:0]temp;

    or_32bits mod(temp, A, B);
    not_32bits mod_1(out,temp);

endmodule

module logic_unit(out, opcode,A,B);
	input [31:0] A,B;
	input [2:0] opcode;
	output [31:0] out;
	reg [3:0] operation;
	reg [31:0] dont_care;
	always @ (*) begin
		operation[0] = 0;
		operation[1] = 0;
		operation[2] = 0;
		operation[3] = 0;
		case (opcode)
		3'b000: begin operation[0] <= 1; operation[1] <= 0; operation[2] <= 0; operation[3] <= 0; end // AND
        3'b001: begin operation[0] <= 0; operation[1] <= 1; operation[2] <= 0; operation[3] <= 0; end // OR
		default: begin operation[0] <= 0; operation[1] <= 0; operation[2] <= 0; operation[3] <= 0; end
		endcase
	end

	wire [3:0][31:0] bus;
	wire [3:0][31:0] mux_input;
	and_32bits un_and(mux_input[0], A, B);
	mux_32bits primer_mux(bus[0], mux_input[0], dont_care, operation[0]);
	or_32bits un_or(mux_input[1], A, B);
	mux_32bits segundo_mux(bus[1], mux_input[1], bus[0], operation[1]);
	xor_32bits un_xor(mux_input[2], A, B);
	mux_32bits tercer_mux(bus[2],mux_input[2], bus[1], operation[2]);
	nor_32bits un_nor(mux_input[3], A, B);
	mux_32bits cuarto_mux(bus[3], mux_input[3], bus[2], operation[3]);
	assign out = bus[3];
endmodule
