timeunit 1ns;
timeprecision 100ps;


module counter(input data, input load, input enable, input clk, input rst_, output count);
	
	logic load;
	logic [4:0]data;
	logic enable;
	logic clk;
	logic rst_;
	logic [4:0]count;
	
	always_ff @ (posedge clk iff rst_ == 1'b1 or negedge rst_) begin
		if(rst_ == 0) begin
			count = 0;
		end
		else if(load == 1'b1) begin
			count = data;
		end 
		else if(enable == 1'b1) begin
			count = count + 1;
		end
		else begin
			count = count;
		end
	end
endmodule
