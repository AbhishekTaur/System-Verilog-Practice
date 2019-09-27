///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mux_test.sv
// Title       : MUX testbench 
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the mux testbench
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ns

module t_mux ;

  parameter PERIOD = 10 ;

  logic        clock  ;
  logic [3:0]  ip1    ;
  logic [3:0]  ip2    ;
  logic [3:0]  ip3    ;
  logic [2:0]  sel    ;
  logic [3:0] mux_op ;


  mux mux1
  (
    .clock  ( clock  ),
    .ip1    ( ip1    ),
    .ip2    ( ip2    ),
    .ip3    ( ip3    ),
    .sel1   ( sel[0] ),
    .sel2   ( sel[1] ),
    .sel3   ( sel[2] ),
    .mux_op ( mux_op )
  ) ;

  always
    begin
      clock <= 0 ;
      #(PERIOD/2) ;
      clock <= 1 ;
      #(PERIOD/2) ;
    end

  initial
    begin : TEST
      @(posedge clock);
      #(PERIOD/4); // Keep changes away from clock edges
      ip1 <= 4'b0001 ;
      ip2 <= 4'b0010 ;
      ip3 <= 4'b0100 ;

      $display ("Starting 1st set of test vectors.");

      for (int i=0; i<=2; i++)
        begin
          sel <= 1<<i ;
          #(PERIOD) ;
        end

      $display ("Finished 1st set of test vectors.");

      ////////////////////////////////////////////////
      // Set a breakpoint on the next executable line.
      ////////////////////////////////////////////////

      $display ("Starting 2nd set of test vectors.");

      for (int i=0; i<=7; i++)
        begin
          sel <= i ;
          #(PERIOD) ;
        end

      $display ("Finished 2nd set of test vectors.");

      $stop ;
    end
   
endmodule
