///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : alu.sv
// Title       : ALU Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the ALU module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

//  SystemVerilog: import package with opcode_t enum type declaration
import typedefs::*;
module alu (
	output logic [7:0]  out    ,
	output logic        zero   ,
	input  logic       clk    ,
	input  logic [7:0] accum  ,
	input  logic [7:0] data   ,
	input  opcode_t opcode  
	);
// SystemVerilog: time unit and time precision specification
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: unique case synthesis intent specification
  always @(negedge clk)
    unique case ( opcode )
      ADD : out <= accum + data;
      AND : out <= accum & data;
      XOR : out <= accum ^ data;
      LDA : out <=         data;
      HLT,
      SKZ,
      JMP,
      STO  : out <= accum;
//      default : out <= 8'bx;
    endcase

// SystemVerilog: always_comb synthesis intent specification
  always_comb 
    zero = ~(|accum);

endmodule
