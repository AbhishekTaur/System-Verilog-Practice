timeunit 1ns;
timeprecision 1ns;

interface mem_inft(input bit clk);
	logic read;				// Read signal to memory
	logic write;			// Write signal to memory
	logic [4:0] addr;		// Address being accessed
	logic [7:0] data_in;    // Data to memory
	logic [7:0] data_out; 	// Data from memory

	// Module ports for the test bench
	modport test(output read, write, addr, data_in, input data_out, clk, import write_mem, import read_mem);
	
	// Module ports for the memory design
	modport design(input read, write, addr, data_in, clk, output data_out);

	// SYSTEMVERILOG: default task input argument values
task write_mem (input [4:0] waddr, input [7:0] wdata, input debug = 0);
  @(negedge clk);
  write <= 1;
  read  <= 0;
  addr  <= waddr;
  data_in  <= wdata;
  @(negedge clk);
  write <= 0;
  if (debug == 1)
    $display("Write - Address:%d  Data:%h", waddr, wdata);
endtask

// SYSTEMVERILOG: default task input argument values
task read_mem (input [4:0] raddr, output [7:0] rdata, input debug = 0);
   @(negedge clk);
   write <= 0;
   read  <= 1;
   addr  <= raddr;
   @(negedge clk);
   read <= 0;
   rdata = data_out;
   if (debug == 1) 
     $display("Read  - Address:%d  Data:%h", raddr, rdata);
endtask

endinterface : mem_inft
