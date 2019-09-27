///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mux_asserted2.sv
// Title       : MUX module 
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the mux module with final (correct) assertions
// Notes       :
//
///////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ns

module mux
(
  input  logic       clock  ,
  input  logic [3:0] ip1    ,
  input  logic [3:0] ip2    ,
  input  logic [3:0] ip3    ,
  input  logic       sel1   ,
  input  logic       sel2   ,
  input  logic       sel3   ,
  output logic [3:0] mux_op  
) ;

always @(posedge clock)
  if (sel1 == 1)
    mux_op <= ip1 ;
  else
    if (sel2 == 1)
      mux_op <= ip2 ;
    else
      if (sel3 == 1)
        mux_op <= ip3 ;

// Assertions go here
//#### EDIT ###
  default clocking defclk @(negedge clock) ;
  endclocking

  property SELECT1;
    @(negedge clock) 
    (sel1 == 1'b1) |=> (mux_op == ip1);
  endproperty
  property SELECT2;
    @(negedge clock) 
    ((sel1 == 1'b0) & (sel2 == 1'b1)) |=> (mux_op == ip2);
  endproperty
  property SELECT3;
    @(negedge clock) 
    ((sel1 == 1'b0) & (sel2 == 1'b0) & (sel3 == 1'b1)) |=> (mux_op == ip3);
  endproperty

  A1: assert property (SELECT1) ;
  A2: assert property (SELECT2) ;
  A3: assert property (SELECT3) ;
//#### END OF EDIT ###
endmodule
