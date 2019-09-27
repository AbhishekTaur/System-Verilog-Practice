///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory interface testbench module  with class
// coverage
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

logic [7:0] rand_data; // stores data to write to memory
logic [7:0] rdata;      // stores data read from memory for checking

bit ok; // stores return value from randomize

typedef enum bit[1:0] {ascii, uc, lc, uclc} control_t;

class mem_class;
  rand  bit [7:0] data;
  randc bit [4:0] addr;

  control_t cntrl;

  constraint datadist { cntrl == ascii -> data inside {[8'h20:8'h7F]};
                        cntrl == uc    -> data inside {[8'h41:8'h5A]};
                        cntrl == lc    -> data inside {[8'h61:8'h7A]};
                        cntrl == uclc  -> data dist {[8'h41:8'h5a]:=4, [8'h61:8'h7a]:=1};}

  // Covergroup declaration
  // cannot have separate coverage for data_in and data_out
  covergroup cg1;
    caddr:  coverpoint addr;
    cdatin: coverpoint data{
            bins lc = {[8'h41:8'h5a]};
            bins uc = {[8'h61:8'h7a]};
            bins restof = default;
            }
  endgroup : cg1

 function new (input int darg = 0, aarg = 0);
   data = darg;
   addr = aarg;
   // create coverage instance
   cg1 = new();
 endfunction

endclass

mem_class memrnd;

// separate covergroup instance not needed for coverage in class
//  cg1 coverrand = new();


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
       mbus.write_mem (i, 0, 0);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, 0);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, i,0);
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata,0);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    memrnd = new(0,0);

    $display("Random Data Test - Upper/Lower case distribution");
    memrnd.cntrl = uclc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       mbus.write_mem (memrnd.addr, memrnd.data, 1);
       mbus.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
       // sample coverage from class
       memrnd.cg1.sample();
    end
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
