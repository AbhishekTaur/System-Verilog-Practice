`timescale 1ns/100ps

module scale_mux #(parameter WIDTH=1)(input in_a, input in_b, input sel_a, output out);
	logic [WIDTH-1:0]in_a;
	logic [WIDTH-1:0]in_b;
	logic sel_a;
	logic [WIDTH-1:0]out;

	always_comb begin
		unique casex(sel_a)
			1'b1 : out = in_a;
			1'b0 : out = in_b;
			default: out = 'bx;
		endcase
	end	
endmodule
