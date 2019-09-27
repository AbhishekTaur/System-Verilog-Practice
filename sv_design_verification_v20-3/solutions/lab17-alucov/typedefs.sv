///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : typdefs.sv
// Title       : Opcode and state enum types
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the opcode and state type declarations
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

package typedefs;
//SystemVerilog: User-defined data types using enumerations
// CPU Operations
typedef enum logic [2:0] {HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP} opcode_t;
// Control Sequencer States
typedef enum logic [2:0] {INST_ADDR, INST_FETCH, INST_LOAD, IDLE,
                          OP_ADDR, OP_FETCH, ALU_OP, STORE} state_t;

endpackage : typedefs

