///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : scale_mux_test.sv
// Title       : MUX Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the mux testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module scale_mux_test;

  timeunit        1ns ;
  timeprecision 100ps ;

  localparam WIDTH  =  8 ;

  logic [WIDTH-1:0] out;     // mux output
  logic [WIDTH-1:0] in_a;    // mux_test data_a
  logic [WIDTH-1:0] in_b;    // mux_test data_b
  logic             sel_a;   // mux_test select a

  // Instantiate mux
  scale_mux #(WIDTH) mux8 (.out(out), .in_a(in_a), .in_b(in_b), .sel_a(sel_a));

  // Monitor Results
  initial
    begin
     $timeformat ( -9, 0, "ns", 3 ) ;
     $monitor ( "%t in_a=%h in_b=%h sel_a=%h out=%h",
	        $time,   in_a,   in_b,   sel_a,   out ) ;
    end

  // Verify Results
  task xpect (input [WIDTH-1:0] expects) ;
    if ( out !== expects )
      begin
        $display ( "out is %b and should be %b", out, expects ) ;
        $display ( "MUX TEST FAILED" );
        $finish ;
      end
  endtask

  // Apply Stimulus
  initial
    begin
      in_a='0; in_b='0; sel_a=0; #1ns xpect('0);
      in_a='0; in_b='0; sel_a=1; #1ns xpect('0);
      in_a='0; in_b='1; sel_a=0; #1ns xpect('1);
      in_a='0; in_b='1; sel_a=1; #1ns xpect('0);
      in_a='1; in_b='0; sel_a=0; #1ns xpect('0);
      in_a='1; in_b='0; sel_a=1; #1ns xpect('1);
      in_a='1; in_b='1; sel_a=0; #1ns xpect('1);
      in_a='1; in_b='1; sel_a=1; #1ns xpect('1);
      $display ( "MUX TEST PASSED" ) ;
      $finish(0) ;
    end

endmodule
