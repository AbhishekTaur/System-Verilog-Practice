///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : register.sv
// Title       : Register Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the register module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module register (
// Verilog2001: port and variable declarations in module definition
// SystemVerilog: logic data type
                output logic [7:0] out,
                input  logic [7:0] data ,
                input        clk  ,
                input        enable  ,
                input        rst_
                );
// SystemVerilog: time unit and time precision declaration
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: always_ff - sequential behavior intent specification
// SystemVerilog: iff conditional execution
always_ff @(posedge clk iff (enable == 1) or negedge rst_)
    if (!rst_)
      out <= 0;
    else 
      out <= data;

endmodule
