///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : flipflop_test.sv
// Title       : Flipflop Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Flipflop testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module testflop ();
timeunit 1ns;

logic reset;
logic [7:0] qin,qout;

// ---- clock generator code begin------
`define PERIOD 10
logic clk = 1'b1;

always
    #(`PERIOD/2)clk = ~clk;

// ---- clock generator code end------


flipflop DUV(.*);

default clocking cb @(posedge clk);
  default input #1step  output #4;
  input qout; 
  output reset, qin;
endclocking

  initial
   begin
    cb.qin <= '0;
    cb.reset <= 0;
    ##2 cb.reset <= 1;
    ##3 cb.reset <= 0;
    for (int i = 1; i < 8; i++)
      begin
         ##1 cb.qin <= i;
      end 
     ##3;
     $finish();
    end

endmodule
