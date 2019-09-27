///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_intf.sv
// Title       : Memory interface
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory interface with clk port
// Notes       :
//
///////////////////////////////////////////////////////////////////////////


interface mem_intf(input logic clk);
//SYSTEMVERILOG: timeunit and timeprecision notation
  timeunit 1ns;
  timeprecision 100ps;

//SYSTEMVERILOG: logic data types
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic [4:0] addr;
  logic read;
  logic write;

endinterface : mem_intf
