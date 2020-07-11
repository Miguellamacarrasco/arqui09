//------------------------------------------------
// topmulti.sv
// As proposed by Prof. David Harris
// and unified memory
//------------------------------------------------

module top(input  logic        clk, reset, 
           output logic [31:0] writedata, adr, 
           output logic        memwrite);

  logic [31:0] readdata;
  
  // microprocessor (control & datapath)
  mips mips(clk, reset, adr, writedata, memwrite, readdata);

  // memory 
  mem mem(clk, memwrite, adr, writedata, readdata);

endmodule
