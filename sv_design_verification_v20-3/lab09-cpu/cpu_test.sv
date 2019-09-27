
module cpu_test; 
timeunit 1ns;
timeprecision 100ps;

import typedefs::*;

logic          rst_;
logic [12*8:1] testfile;
opcode_t   topcode;
logic [31:0]   test_number;

logic clk, alu_clk, cntrl_clk, clk2, fetch, halt;
logic load_ir;

// clock generator
`define PERIOD 10
logic master_clk = 1'b1;

logic [3:0] count;

always
    #(`PERIOD/2) master_clk = ~master_clk;


always @(posedge master_clk or negedge rst_)
   if (~rst_)
     count <= 3'b0;
   else
     count <= count + 1;

assign cntrl_clk = ~count[0];
assign clk  = count[1];
assign fetch = ~count[3];
assign alu_clk = ~(count == 4'hc);
// end of clock generator

cpu     cpu1    (
                .halt  (halt  ),
                .load_ir(load_ir),
                .clk   (clk   ),     
                .alu_clk   (alu_clk),    
                .cntrl_clk   (cntrl_clk),    
                .fetch (fetch ),
                .rst_  (rst_  )
                );


  // Monitor Results

  initial
    $timeformat ( -9, 1, " ns", 12 );


  // Apply Stimulus

  initial  
    forever
      begin
        $display ( "" );
        $display ( "****************************************" );
        $display ( "THE FOLLOWING DEBUG TASKS ARE AVAILABLE:" );
        $display ( "1- The basic CPU diagnostic.            " );
        $display ( "2- The advanced CPU diagnostic.         " );
        $display ( "3- The Fibonacci program.               " );
        $display ( "****************************************" );
        $display ( "" );
        $display ( "Enter ' deposit test_number # ; run' \n" );
        test_number = 1;
        $stop; // wait for test number
        
        if ( test_number > 3 )
          begin
            $display ( "Test number %d is not between 1 and 3", test_number );
          end
        else
       //for (int test_number = 1; test_number<3; test_number++)
          begin
            case ( test_number )
              1: begin
                   $display ( "CPUtest1 - BASIC CPU DIAGNOSTIC PROGRAM \n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 17 hex\n" );
                 end
              2: begin
                   $display ( "CPUtest2 - ADVANCED CPU DIAGNOSTIC PROGRAM\n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 10 hex\n" );
                 end
              3: begin
                   $display ( "CPUtest3 - FIBONACCI NUMBERS to 144\n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 0C hex\n" );
                 end
            endcase
            testfile = { "CPUtest", 8'h30+test_number[7:0], ".dat" };
            $readmemb ( testfile, cpu1.mem1.memory );
            rst_ = 1;
            repeat (2) @(negedge master_clk);
            rst_ = 0;
            repeat (2) @(negedge master_clk);
            rst_ = 1;
            $display("     TIME       PC    INSTR    OP   ADR   DATA\n");
            $display("  ----------    --    -----    --   ---   ----\n");
            while ( !halt )
              @( posedge clk )
              // hierarchical pathname reference
              if ( load_ir )
                begin
                  #(`PERIOD/2)
                  topcode =  cpu1.opcode;
                  $display ( "%t    %h    %s      %h    %h     %h     %h",
                    $time,cpu1.pc_addr,topcode.name(),cpu1.opcode,
                    cpu1.addr,cpu1.alu_out,cpu1.data_out );
                  if ((test_number == 3) && (topcode == JMP))
                   $display ( "Next Fibonacci number is %d",
                     cpu1.mem1.memory[5'h1B] );
                end
            if ( test_number == 1 && cpu1.pc_addr != 5'h17
              || test_number == 2 && cpu1.pc_addr != 5'h10
              || test_number == 3 && cpu1.pc_addr != 5'h0C )
              begin
                $display ( "CPU TEST FAILED" );
                $finish;
              end
            $display ( "\nCPU TEST %0d PASSED",test_number );
          end
      end

endmodule
