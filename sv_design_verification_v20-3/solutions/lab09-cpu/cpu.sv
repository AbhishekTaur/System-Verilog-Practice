module cpu      (
                output logic halt  ,
                output logic load_ir  ,
                input  logic clk   ,
                input  logic cntrl_clk  ,
                input  logic alu_clk  ,
                input  logic fetch ,
                input  logic rst_
                );
//SystemVerilog: timeunit and timeprecision notation
timeunit 1ns;
timeprecision 100ps;

import typedefs::*;

logic    [7:0]   data_out, alu_out, accum, ir_out;
logic    [4:0]   pc_addr, ir_addr, addr;
opcode_t   opcode;
logic load_ac, mem_rd, mem_wr, inc_pc, load_pc, zero;

//SystemVerilog: .name port connections
register ac     ( .out  (accum  ),
                  .data (alu_out),
                  .clk,
                  .enable  (load_ac),
                  .rst_
                );

register ir     ( .out (ir_out),
                  .data(data_out),
                  .clk,
                  .enable (load_ir),
                  .rst_
                );

assign opcode =  opcode_t'(ir_out[7:5]);

assign ir_addr = ir_out[4:0]; 

counter  pc     ( .count  (pc_addr),
                  .data (ir_addr),
                  .clk  (clk),
                  .load (load_pc),
                  .enable (inc_pc),
                  .rst_
                );

alu      alu1   ( .out (alu_out),
                  .zero,
                  .clk (alu_clk),
                  .accum,
                  .data(data_out),
                  .opcode
                );

scale_mux #5 smx( .out (addr),
                  .in_a (pc_addr),
                  .in_b (ir_addr),
                  .sel_a (fetch) 
                );

mem      mem1   ( .clk(~cntrl_clk),
                  .read (mem_rd),
                  .write (mem_wr), 
                  .addr  ,
                  .data_in(alu_out) ,
                  .data_out(data_out)
                );


control  cntl   ( .load_ac,
                  .mem_rd,
                  .mem_wr,
                  .inc_pc,
                  .load_pc,
                  .load_ir,
                  .halt,
                  .opcode,
                  .zero,
                  .clk(cntrl_clk),
                  .rst_
                );

endmodule
