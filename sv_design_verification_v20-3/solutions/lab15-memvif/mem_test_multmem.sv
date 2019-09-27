///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory interface testbench module  
//               with virtual interface connected to multiple memories
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
                  mem_intf.tb mbus1,
                  mem_intf.tb mbus2
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

logic [7:0] rand_data; // stores data to write to memory
logic [7:0] rdata;      // stores data read from memory for checking

bit ok; // stores return value from randomize


class mem_class;
  rand  bit [7:0] data;
  randc bit [4:0] addr;

        bit [7:0] rdata;

 virtual interface mem_intf vif;
 
  constraint datadist { data dist {[8'h41:8'h5a]:=4, [8'h61:8'h7a]:=1};}

 function new (input int darg = 0, aarg = 0);
  data = darg;
  addr = aarg;
 endfunction

 function void configure(virtual interface mem_intf aif);
   vif = aif;
   if (vif == null) $display ("vif configure error");
 endfunction

  task write_mem (input debug = 0 );
    @(negedge vif.clk);
    vif.write <= 1;
    vif.read  <= 0;
    vif.addr  <= addr;
    vif.data_in  <= data;
    @(negedge vif.clk);
    vif.write <= 0;
    if (debug == 1)
      $display("Write - Address:%d  Data:%h %c", addr, data, data);
  endtask
  
  task read_mem (input debug = 0 );
     @(negedge vif.clk);
     vif.write <= 0;
     vif.read  <= 1;
     vif.addr  <= addr;
     @(negedge vif.clk);
     vif.read <= 0;
     rdata = vif.data_out;
     if (debug == 1) 
       $display("Read  - Address:%d  Data:%h %c", addr, rdata, rdata);
  endtask

endclass

mem_class memrnd1, memrnd2;


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

  // "clearing the memory" and "data = address" tests removed

    memrnd1 = new(0,0);
    memrnd1.configure(mbus1);

    memrnd2 = new(0,0);
    memrnd2.configure(mbus2);

    $display("Random Data Test to Memory 1");
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd1.randomize();
       memrnd1.write_mem (1);
       memrnd1.read_mem  (1);
       error_status = checkit (memrnd1.addr, memrnd1.rdata, memrnd1.data);
    end
    printstatus(error_status);

    $display("Random Data Test to Memory 2");
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd2.randomize();
       memrnd2.write_mem (1);
       memrnd2.read_mem  (1);
       error_status = checkit (memrnd2.addr, memrnd2.rdata, memrnd2.data);
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
