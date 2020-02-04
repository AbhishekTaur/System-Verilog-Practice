// Importing the typedef
import typedefs::*;

module alu (
	input logic [7:0] accum,    // Accumulator
	input logic [7:0] data, // Data
	input opcode_t opcode,  // Opcode
	input clk, // Clock
	output logic [7:0] out, // Output of the ALU
	output logic zero // Zero signal
);

// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

// Block to define the zero value based on the accum value
always_comb begin
	if(accum == 0) begin
		zero = 1;
	end
	else begin
		zero = 0;
	end

end

// Block to define the out value based on the accum, data and opcode
always_ff @(negedge clk) begin
	unique case (opcode)
		HLT: out = accum;
		SKZ: out = accum;
		ADD: out = data + accum;
		AND: out = data & accum;
		XOR: out = data ^ accum;
		LDA: out = data;
		STO: out = accum;
		JMP: out = accum;
		default: out = 'x;
	endcase
end

endmodule