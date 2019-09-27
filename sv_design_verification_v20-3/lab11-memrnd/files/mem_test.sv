///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory interface testbench module with 
// clk port, modport and methods
// Notes       :
// Memory Specification: 8x32 memory
//   Memory is 8-bits wide and address range is 0 to 31.
//   Memory access is synchronous.
//   The Memory is written on the positive edge of clk when "write" is high.
//   Memory data is driven onto the "data" bus when "read" is high.
//   The "read" and "write" signals should not be simultaneously high.
//
///////////////////////////////////////////////////////////////////////////

module mem_test ( 
                  mem_intf.tb mbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, i, debug);
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
// SYSTEMVERILOG: post-increment
     error_status++;
   end
// SYSTEMVERILOG: function return
   return (error_status);
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
