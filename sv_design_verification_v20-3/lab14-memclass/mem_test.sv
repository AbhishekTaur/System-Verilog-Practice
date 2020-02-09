///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module mem_test (
                  mem_inft.test mem_inf
                  // output logic read, 
                  // output logic write, 
                  // output logic [4:0] addr, 
                  // output logic [7:0] data_in,     // data TO memory
                  // input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 100ps;

class memclass;
  randc bit [4:0] addr;
  randc bit [7:0] data;

  function new(bit [4:0] addr, bit [7:0] data);
    this.addr = addr;
    this.data = data;
  endfunction : new
endclass : memclass

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] randdata;
memclass memory = new('0, '0);
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
       mem_inf.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       mem_inf.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mem_inf.write_mem (i, i, debug);
    for (int i = 0; i<32; i++)
      begin
       mem_inf.read_mem (i, rdata, debug);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Random data = read data Test");
// SYSTEMVERILOG: random test
    for(int i = 0; i < 32; i++) 
      begin
        //int ok = randomize(randdata) with {randdata dist {[8'h41:8'h5a]:=4, [8'h61:8'h7a]:=1};};;
        int ok = memory.randomize();
        if(ok) begin
          mem_inf.write_mem(memory.addr, memory.data, debug);
        end
        else
          $display("ERROR while doing randomization");
      end
    for(int i = 0; i < 32; i++)
      begin
        mem_inf.read_mem(memory.addr, rdata, debug);
        // check each memory location for rdata = randdata
        error_status = checkit(memory.addr, rdata, memory.data);
      end

//SYSTEMVERILOG: print the number of errors
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
