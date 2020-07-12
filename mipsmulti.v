//-------------------------------------------------------
// mipsmulti.sv
// From David_Harris and Sarah_Harris book design
// Multicycle MIPS processor
//------------------------------------------------

module mips(input        clk, reset,
            output [31:0] adr, writedata,
            output        memwrite,
            input [31:0] readdata);

  wire        zero, pcen, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst;
  wire [1:0]  alusrcb, pcsrc;
  wire [2:0]  alucontrol;
  wire [5:0]  op, funct;

  controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol); 
  datapath dp(clk, reset, 
              pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst,
              alusrcb, pcsrc, alucontrol,
              op, funct, zero,
              adr, writedata, readdata);
endmodule

module controller(input         clk, reset,
                  input   [5:0] op, funct,
                  input         zero,
                  output        pcen, memwrite, irwrite, regwrite,
                  output        alusrca, iord, memtoreg, regdst,
                  output  [1:0] alusrcb, pcsrc,
                  output  [2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch, pcwrite;

  
  // Main Decoder and ALU Decoder subunits.
  maindec md(clk, reset, op,
             pcwrite, memwrite, irwrite, regwrite,
             alusrca, branch, iord, memtoreg, regdst, 
             alusrcb, pcsrc, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcen = pcwrite || (branch && zero);
  // ADD CODE HERE
  // Add combinational logic (i.e. an assign statement) 
  // to produce the PCEn signal (pcen) from the branch, 
  // zero, and pcwrite signals
 
endmodule

module maindec(input        clk, reset, 
               input   [5:0] op, 
               output        pcwrite, memwrite, irwrite, regwrite,
               output        alusrca, branch, iord, memtoreg, regdst,
               output  [1:0] alusrcb, pcsrc,
               output  [1:0] aluop);

  parameter   FETCH   = 4'b0000; // State 0
  parameter   DECODE  = 4'b0001; // State 1
  parameter   MEMADR  = 4'b0010;	// State 2
  parameter   MEMRD   = 4'b0011;	// State 3
  parameter   MEMWB   = 4'b0100;	// State 4
  parameter   MEMWR   = 4'b0101;	// State 5
  parameter   RTYPEEX = 4'b0110;	// State 6
  parameter   RTYPEWB = 4'b0111;	// State 7
  parameter   BEQEX   = 4'b1000;	// State 8
  parameter   ADDIEX  = 4'b1001;	// State 9
  parameter   ADDIWB  = 4'b1010;	// state 10
  parameter   JEX     = 4'b1011;	// State 11

  parameter   LW      = 6'b100011;	// Opcode for lw
  parameter   SW      = 6'b101011;	// Opcode for sw
  parameter   RTYPE   = 6'b000000;	// Opcode for R-type
  parameter   BEQ     = 6'b000100;	// Opcode for beq
  parameter   ADDI    = 6'b001000;	// Opcode for addi
  parameter   J       = 6'b000010;	// Opcode for j

  reg [3:0]  state, nextstate;
  reg [14:0] controls;

  // state register
  always @(posedge clk or posedge reset) begin			
    if(reset) state <= FETCH;
    else state <= nextstate;
  end
  // ADD CODE HERE
  // Finish entering the next state logic below.  We've completed the first 
  // two states, FETCH and DECODE, for you.




  // next state logic
  always @(*) begin
    case(state)
      FETCH:   nextstate <= DECODE;
      DECODE:  case(op)
                 LW:      nextstate <= MEMADR;
                 SW:      nextstate <= MEMADR;
                 RTYPE:   nextstate <= RTYPEEX;
                 BEQ:     nextstate <= BEQEX;
                 ADDI:    nextstate <= ADDIEX;
                 J:       nextstate <= JEX;
                 default: nextstate <= 4'bx; // should never happen
               endcase
 		// Add code here
      MEMADR: case(op) LW: nextstate <= MEMRD; SW: nextstate <= MEMWR;  endcase
      MEMRD: nextstate <= MEMWB;
      MEMWB: nextstate <= FETCH;
      MEMWR: nextstate <= FETCH;
      RTYPEEX: nextstate <= RTYPEWB;
      RTYPEWB: nextstate <= FETCH;
      BEQEX:   nextstate <= FETCH;
      ADDIEX:  nextstate <= ADDIWB;
      ADDIWB:  nextstate <= FETCH;
      JEX: nextstate <= FETCH;
      default: nextstate <= 4'bx; // should never happen
    endcase
  end

  // output logic
  assign {pcwrite, memwrite, irwrite, regwrite, 
          alusrca, branch, iord, memtoreg, regdst,
          alusrcb, pcsrc, aluop} = controls;

  // ADD CODE HERE
  // Finish entering the output logic below.  We've entered the
  // output logic for the first two states, S0 and S1, for you.
  always @ (*) begin
    case(state)
      FETCH:   controls <= 15'h5010;
      DECODE:  controls <= 15'h0030;
      MEMADR: controls <= 15'h0420;
      MEMRD:  controls <= 15'h0100;
      MEMWB: controls <= 15'h0880;
      MEMWR: controls <= 15'h2100;
      RTYPEEX: controls <= 15'h0402;
      RTYPEWB: controls <= 15'h0840;
      BEQEX: controls <= 15'h0605;
      ADDIEX: controls <= 15'h0420;
      ADDIWB: controls <= 15'h0800;
      JEX: controls <= 15'h4008;

    // your code goes here      
    
	 
      default: controls <= 15'hxxxx; // should never happen
    endcase
  end
endmodule

module aludec(input  [5:0] funct,
              input  [1:0] aluop,
              output reg [2:0] alucontrol);

  // ADD CODE HERE
  // Complete the design for the ALU Decoder.
  // Your design goes here.  Remember that this is a combinational 
  // module. 
  always @ (*) begin 
    case(aluop) 
      2'b10: 
        case(funct) 
          6'h20: alucontrol <= 3'b010; //ADD
          6'h22: alucontrol <= 3'b110; //SUB
          6'h24: alucontrol <= 3'b000; //AND
          6'h25: alucontrol <= 3'b001; //OR
          6'h2A: alucontrol <= 3'b111; //SLT
          default: alucontrol <= 3'bxxx;
        endcase
      2'b00: alucontrol <= 3'b010;
      2'b01: alucontrol <= 3'b110;
      default: alucontrol <= 3'bxxx;
    endcase
  end

  // Remember that you may also reuse any code from previous labs.

endmodule

module regfile(input          clk, 
               input          we3, 
               input   [4:0]  ra1, ra2, wa3, 
               input   [31:0] wd3, 
               output  [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) rf[wa3] <= wd3;	
        assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
        assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module sl2(input  [31:0] a,
           output  [31:0] y);

  // shift left by 2
  assign y = {a[25:0], 2'b00};
endmodule

module signext(input   [15:0] a,
               output   [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule



// Complete the datapath module below for Lab 11.
// You do not need to complete this module for Lab 10

// The datapath unit is a structural verilog module.  That is,
// it is composed of instances of its sub-modules.  For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated.

module datapath(input          clk, reset,
                input          pcen, irwrite, regwrite,
                input          alusrca, iord, memtoreg, regdst,
                input   [1:0]  alusrcb, pcsrc, 
                input   [2:0]  alucontrol,
                output  [5:0]  op, funct,
                output         zero,
                output  [31:0] adr, 
                output  reg [31:0]writedata, 
                input   [31:0] readdata);

  // Below are the internal signals of the datapath module.

  wire [4:0]  writereg;
  wire [31:0] pcnext;
  reg [31:0]  pc;
  reg [31:0] instr, data;
  wire [31:0] srca, srcb;
  reg [31:0] a;
  wire [31:0] aluresult;
  reg [31:0] aluout;
  wire [31:0] signimm;   // the sign-extended immediate
  wire [31:0] signimmsh;	// the sign-extended immediate shifted left by 2
  wire [31:0] wd3, rd1, rd2; // the wires for the register

  always @ (*) begin
    if (reset) begin pc <= 0; end 
  end

  
  // Register Logic

  //Using clock to pass instrucciontion the instructions
  always @ (posedge clk) begin
    if(irwrite)  instr <=  readdata;
    data <= readdata;
  end
  // using a mux for writereg (A3)                
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);

  // using a mux for wd3 (WD3)
  mux2 #(32)  Wd3Mux(aluout, data, 
                  memtoreg, wd3);
    
  // op and funct fields to controller
  assign op = instr[31:26];
  assign funct = instr[5:0];

  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 wd3, rd1, rd2);
  //changing a and b only in clk
  always @ (posedge clk) begin
    a <= rd1;
    writedata <= rd2;
  end
  //sign extend and l2
  
  signext     se(instr[15:0], signimm);
  sl2         immsh(signimm, signimmsh);
  
  //Logic for Alu 
  mux2 #(32)  srabmux(pc, a, alusrca,
                      srca);

  mux4 #(32)  srcbmux(writedata, 32'd4, signimm, signimmsh, alusrcb,
                      srcb);


  alu         alu(alucontrol, aluresult, zero,srca, srcb);

  always @ (posedge clk)begin
    aluout <= aluresult;
  end  



  //Pc logic
  mux3 #(32)  pcnextMux(aluresult, aluout, {pc[31:28], {instr[25:0], 2'b00} }, pcsrc,
                     pcnext );

  always @ (posedge clk)begin
    if(pcen) pc <= pcnext;
  end

  //return Adr
    mux2 #(32)  adrmux(pc, aluout, iord,
                      adr);



  // Your datapath hardware goes below.  Instantiate each of the submodules
  // that you need.  Remember that alu's, mux's and various other 
  // versions of parameterizable modules are available in mipsparts.sv
  // from Lab 9. You'll likely want to include this verilog file in your
  // simulation.

  // We've included parameterizable 3:1 and 4:1 muxes below for your use.

  // Remember to give your instantiated modules applicable names
  // such as pcreg (PC register), wdmux (Write Data Mux), etc.
  // so it's easier to understand.

  // ADD CODE HERE



  // datapath
endmodule





module mux2 #(parameter WIDTH = 8)
             (input   [WIDTH-1:0] d0, d1, 
              input               s, 
              output  [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module mux3 #(parameter WIDTH = 8)
             (input   [WIDTH-1:0] d0, d1, d2,
              input   [1:0]       s, 
              output  [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input   [WIDTH-1:0] d0, d1, d2, d3,
              input   [1:0]       s, 
              output reg [WIDTH-1:0] y);

   always @ (*) begin
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
   end
endmodule