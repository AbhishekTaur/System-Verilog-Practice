///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : register_test.sv
// Title       : Register Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the register testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module register_test;
timeunit 1ns;
timeprecision 100ps;

logic [7:0]   out  ;
logic [7:0]   data ;
logic         enable  ;
logic         rst_ = 1'b1;
logic         clk = 1'b1;

`define PERIOD 10

always
    #(`PERIOD/2) clk = ~clk;

// INSTANCE register 
 register r1 (.enable(enable), .clk(clk), .out(out), .data(data), .rst_(rst_));

  // Monitor Results
  initial
    begin
     $timeformat ( -9, 1, " ns", 9 );
     $monitor ( "time=%t enable=%b rst_=%b data=%h out=%h",
	        $time,   enable,   rst_,   data,   out );
     #(`PERIOD * 99)
     $display ( "REGISTER TEST TIMEOUT" );
     $finish;
    end

// Verify Results
  task expect_test (input [7:0] expects) ;
    if ( out !== expects )
      begin
        $display ( "out=%b, should be %b", out, expects );
        $display ( "REGISTER TEST FAILED" );
        $finish;
      end
  endtask

  initial
    begin
      @(negedge clk)
      { rst_, enable, data } = 10'b1_X_XXXXXXXX; @(negedge clk) expect_test ( 8'hXX );
      { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
      { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
      { rst_, enable, data } = 10'b1_1_10101010; @(negedge clk) expect_test ( 8'hAA );
      { rst_, enable, data } = 10'b1_0_01010101; @(negedge clk) expect_test ( 8'hAA );
      { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
      { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
      { rst_, enable, data } = 10'b1_1_01010101; @(negedge clk) expect_test ( 8'h55 );
      { rst_, enable, data } = 10'b1_0_10101010; @(negedge clk) expect_test ( 8'h55 );
      $display ( "REGISTER TEST PASSED" );
      $finish;
    end
endmodule
