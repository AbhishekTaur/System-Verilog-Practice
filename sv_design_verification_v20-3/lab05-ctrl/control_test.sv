///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control_test.sv
// Title       : Control Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module control_test;
timeunit 1ns;
timeprecision 100ps;

// import package for opcode_t and state_t types
import typedefs::*;

logic        rst_ =1'b1;
logic        zero ;

opcode_t opcode;
state_t  lstate;

logic  load_ac, mem_rd, mem_wr, inc_pc, load_pc, load_ir, halt;

integer      response_num;
integer      stimulus_num;
logic [6:0]  response_mem[1:550];
logic [3:0]  stimulus_mem[1:64];
logic [3:0]  stimulus_reg;
logic [6:0]  response_net;

// ---- clock generator code begin------
`define PERIOD 10
logic clk = 1'b1;

always
    #(`PERIOD/2)clk = ~clk;

// ---- clock generator code end------

control  ctrl   ( .load_ac(load_ac), .mem_rd(mem_rd), .mem_wr(mem_wr), .inc_pc(inc_pc), 
                  .load_pc(load_pc), .load_ir(load_ir), .halt(halt), .opcode(opcode), 
                  .zero(zero), .clk(clk), .rst_(rst_) );

assign response_net = { mem_rd,load_ir,halt,inc_pc,load_ac,load_pc,mem_wr };

assign zero = stimulus_reg[3];

// check your type name if you get an error here:-
assign opcode = opcode_t'(stimulus_reg[2:0]);

// temp variable to monitor state
assign lstate = ctrl.state;

  // Monitor Results
  initial
    begin
      $timeformat ( -9, 1, "ns", 9 );
      $monitor ("%t rst_=%b ph=%s \t zer=%b op=%s rd=%b l_ir=%b hlt=%b inc=%b l_ac=%b l_pc=%b wr=%b",
      $time, rst_, lstate.name(), zero, opcode.name(),
      mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr );
// SystemVerilog: time units in literals
      #12000ns
      $display ( "CONTROLLER TEST TIMEOUT" );
      $finish;
    end

  // Apply & check Stimulus
  initial begin
    $readmemb ( "stimulus.pat", stimulus_mem );
    $readmemb ( "response.pat", response_mem );
    stimulus_reg = 0;
    stimulus_num = 0;
    response_num = 0;
    @ ( negedge clk ) rst_ = 0;
    @ ( negedge clk ) rst_ = 1;
    // SystemVerilog: do...while loop and named block
    do begin : ApplyStim
      @(negedge clk);
      response_num = response_num + 1 ;
      if ( response_net !== response_mem[response_num] ) begin
        $display ( "CONTROLLER TEST FAILED" );
        $display ( "{mem_rd,load_ir,halt,inc_pc,load_ac,load_pc,mem_wr}" );
        $display ( "is        %b", response_net );
        $display ( "should be %b", response_mem[response_num] );
        // cannot currently use name method on a hierarchical path
        $display ( "state: %s   opcode: %s  zero: %b", lstate.name(), opcode.name(), zero);
        $stop;
      end // response_net
      if (response_num[2:0] == 3'b111) begin
        stimulus_num++;
        stimulus_reg = stimulus_mem[stimulus_num];
      end
    end : ApplyStim // SystemVerilog: end named block
    while ( stimulus_num <= 64 );
    $display ( "CONTROLLER TEST PASSED" );
    $finish;
  end

endmodule
