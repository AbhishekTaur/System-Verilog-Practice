// Controller Module
// SystemVerilog package covered in detail in day2 of the class
import typedefs::*;

module control  (
                output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t opcode  ,
                input             zero    ,
                input             clk     ,
                input             rst_   
                );
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: typedef and enumeration types declared in typedefs package
//typedef enum logic [2:0] {HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP} opcode_t;
//typedef enum logic [2:0] {INST_ADDR, INST_FETCH, INST_LOAD, IDLE,
//                          OP_ADDR, OP_FETCH, ALU_OP, STORE}state_t;

state_t state;

logic aluop;

assign aluop = (opcode inside {ADD, AND, XOR, LDA});

always_ff @(posedge clk or negedge rst_)
  if (!rst_)
     state <= INST_ADDR;
  else
     state <= state.next();

always_comb  begin
  // default assignments to outputs to avoid latches
  {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr}  =  7'b000_0000;
  unique case (state)
    INST_ADDR : ;
    INST_FETCH: mem_rd = 1;    
    INST_LOAD : begin         
                mem_rd = 1;   
                load_ir = 1;  
                end
    IDLE      : begin
                mem_rd = 1; 
                load_ir = 1;
                end
    OP_ADDR   : begin      
                inc_pc = 1;
                halt = (opcode == HLT);
                end
    OP_FETCH  : mem_rd = aluop;
    ALU_OP    : begin          
                load_ac = aluop;
                mem_rd = aluop;
                inc_pc = ((opcode == SKZ) && zero);
                load_pc = ( opcode == JMP);
                end
    STORE     : begin
                load_ac = aluop;
                mem_rd = aluop;
                inc_pc = (opcode == JMP);
                load_pc = ( opcode == JMP);
                mem_wr = ( opcode == STO);
                end
  endcase
  end

endmodule
