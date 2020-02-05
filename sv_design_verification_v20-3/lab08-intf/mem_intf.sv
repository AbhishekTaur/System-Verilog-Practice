timeunit 1ns;
timeprecision 1ns;

interface mem_inft(input bit clk);
	logic read;				// Read signal to memory
	logic write;			// Write signal to memory
	logic [4:0] addr;		// Address being accessed
	logic [7:0] data_in;    // Data to memory
	logic [7:0] data_out; 	// Data from memory

	// Module ports for the test bench
	modport test(output read, write, addr, data_in, input data_out, clk);
	
	// Module ports for the memory design
	modport design(input read, write, addr, data_in, clk, output data_out);

endinterface : mem_inft
