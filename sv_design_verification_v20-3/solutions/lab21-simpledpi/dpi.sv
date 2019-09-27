///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : dpi.sv
// Title       : Direct Programming Interface (DPI) code
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple DPI calls to standard C library functions
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

`include "math.sv"
module dpi;

// Functions from C stdlib.h:
import "DPI" function int system ( input string s );
import "DPI" function string getenv ( input string name );

// Functions from C math.h:
import "DPI" function real sin ( input real arg );

string syscmd;
real x,y;

initial begin
  system( "echo 'hello world'");
  $display("date");
  system( "date");

  $display("UNIX PATH = %s", getenv( "PATH" ) );

  for (int i =0; i<8; i++) begin
  x = `M_PI_4 * i;  // from math.sv: pi/2
  y =  sin( x );
  $display("sin( %f ) = %f", x, y);
  end
end

endmodule
