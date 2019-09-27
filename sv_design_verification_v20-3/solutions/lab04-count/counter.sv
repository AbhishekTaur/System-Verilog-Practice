
// Verilog2001: port and variable declarations in module definition
module counter  (
                output logic [4:0] count,
                input  logic [4:0] data ,
                input        clk  ,
                input        load ,
                input        enable ,
                input        rst_   
                );

// SystemVerilog: time unit and time precision declaration
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: always_ff 
always_ff @(posedge clk or negedge rst_)
   if (!rst_)
       count <= 0;
   else if (load)
       count <= data;
   else if (enable)
// SystemVerilog: postincrement or assignment operator
       count <= count +1;  //++;

endmodule
