module sign_extend(out,num);

input num;
output reg[31:0] out;


always @(*)begin
	out <= $signed(num);
end

endmodule


/*
`timescale 1ns/1ns
module fms_behav_tb;
	reg num;
	wire [31:0]out;
	sign_extend mod(num,out);

	initial begin
		num = 1;
			$display("time\tnum\tout"); $monitor("%2d:\t%b\t%b",$time,num,out);
		#2 $finish;
	end
	always #1 num = ~num;

endmodule */
