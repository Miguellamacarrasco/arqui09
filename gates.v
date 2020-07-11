module mux(out, A, B, flag);
	input A, B, flag;
	output out;
	assign out = (A & flag) | (B & !flag);
endmodule 


module mux_32bits(out, A, B, flag);

	input [31:0] A, B;
	input flag;
	output [31:0] out; 

	genvar counter;
	for (counter = 0; counter<32;counter = counter + 1) begin : muxes
		mux mux_de_1bit(out[counter] ,A[counter], B[counter], flag);
	end	
endmodule
