module register(output logic [7:0]out, input logic [7:0]data, input logic clk, input logic rst_, input logic enable);
	timeunit 1ns;
	timeprecision 100ps;
		
	always_ff@(posedge clk iff (enable == 1) or negedge rst_) begin
		if(rst_ == 0) 	
			out <= 8'b0;
		else 
			out <= data	;
	end	
endmodule
