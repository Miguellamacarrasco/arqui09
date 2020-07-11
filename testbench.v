`timescale 1ns/1ns
module tb;
//control signals
reg clk, reset; 
reg [5:0] op, funct;
reg zero;
wire pcen, memwrite, irwrite, regwrite, alusrca, iord, memtoreg, regdst;
wire [1:0] alusrcb, pcsrc;
wire [2:0] alucontrol;
//test signals
reg [31:0] testvectors[31:0];
reg [31:0] vectornum;

always @ (*) begin
   #1 clk <= !clk;
end

always @ (negedge clk) begin 
    if (vectornum == 32'd7) $finish;
    if (iord == 0 && alusrca == 0 && alusrcb == 2'b01 && pcsrc == 2'b00 && irwrite == 1) vectornum = vectornum + 1; 
end

always @ (posedge clk) begin 
    op = testvectors[vectornum][31:26];
    funct = testvectors[vectornum][5:0];
end

controller crl(clk, reset, op, funct, zero, pcen, memwrite, irwrite, regwrite, alusrca, iord, memtoreg, regdst, alusrcb, pcsrc, alucontrol);

initial begin
    $readmemh("controller.tv", testvectors);
    $dumpfile("basura.vcd");
    $dumpvars(0);
    vectornum = 0; 
    clk = 1;
    reset = 1;
    zero = 1;
    #1;
    reset = 0;
    #1;
    #1;
    #1;
    #1;
    #1;
    
end



endmodule