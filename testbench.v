`timescale 1ns/1ns
module tb;
    reg clk, reset;
    wire [31:0] writedata, adr;
    wire memwrite;
    top tp(clk, reset, writedata, adr, memwrite);
    always @ (*) begin #1 clk <= !clk; end
    always @ (posedge clk) begin 
        if(adr == 32'h4c)begin
            if(writedata == 32'h5)  $display("Simulation succesfull");
            $finish;
        end
    end
    initial begin
        $dumpfile("data_path.vcd");
        $dumpvars(0);
        clk = 0;
        reset = 1;
        #1;
        reset = 0;
        #1;
        #1;
        #1;
        #1;
        #1;
        #1;
        #1;
        #1;
        #1;


    end
endmodule