///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : counter Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the counter module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// Verilog2001: port and variable declarations in module definition
module counter  (
                output logic [4:0] count,
                input  logic [4:0] data ,
                input        clk  ,
                input        load ,
                input        rst_   
                );

// SystemVerilog: time unit and time precision declaration
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: always_ff 
always_ff @(posedge clk or negedge rst_)
// SystemVerilog: priority if
   priority if (!rst_)
       count <= 0;
   else if (load)
       count <= data;
// SystemVerilog: postincrement or assignment operator
   else count <= count +1;  //++;
//   else count += 1; 

endmodule
