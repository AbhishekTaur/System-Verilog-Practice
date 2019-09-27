timeunit 1ns;
timeprecision 100ps;

module counter ( input        [4:0] data,
                 input              enable, load, clk, rst_,
		 output logic [4:0] count);

  always_ff@(posedge clk iff (load == 1 || enable == 1) or negedge rst_ )

  if (!rst_)
    count <= '0;
  else if (load)
    count <= data;
  else
    count <= count+1;

endmodule
