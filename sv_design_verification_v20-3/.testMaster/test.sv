interface intfc;
  logic i1, i0, s; // test output to mux  input
  logic o;         // mux  output to test input
  modport mux_port (output o,  input i1, i0, s);
  modport tst_port ( input o, output i1, i0, s);
endinterface : intfc


module mux (interface ifp);
  always_comb
    unique case (ifp.s)
      1'b0  : ifp.o = ifp.i0;
      1'b1  : ifp.o = ifp.i1;
      default ifp.o = 1'bx;
    endcase
MUX_ASSERT: assert property (@(ifp.o) ifp.o==ifp.s?ifp.i1:ifp.i0);
endmodule : mux


program test (interface ifp, input bit clk);

  class randclass;
    randc logic [2:0] randvar;
  endclass : randclass

  randclass r1 = new;

  default clocking c1 @(posedge clk);
    default input #1step output negedge;
    input o=ifp.o; output i1=ifp.i1,i0=ifp.i0,s=ifp.s;
  endclocking : c1

  function void check (input logic e);
    if (ifp.o !== e)
      begin
        $display("o is %b and should be %b", ifp.o, e);
        $display("TEST FAILED");
        $finish;
      end
  endfunction : check

  initial
    begin
      for (int unsigned i=1;i<=8;++i)
        begin
          int ok;
          assert (r1.randomize());
          {ifp.i1,ifp.i0,ifp.s} <= r1.randvar;
          ##1 check(ifp.s?ifp.i1:ifp.i0);
        end
      $display("TEST PASSED");
      $finish;
    end

endprogram : test


module top;
  bit clk=0;
  intfc if1();
  mux   mx1(.ifp(if1.mux_port));
  test  tb1(.ifp(if1.tst_port), .clk);
  always #10 clk = ~clk;
endmodule : top
