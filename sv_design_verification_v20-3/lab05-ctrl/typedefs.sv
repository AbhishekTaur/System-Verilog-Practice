package typedefs;
	typedef enum logic [2:0] 
	{
		HLT = 3'b000,
		SKZ = 3'b001,
		ADD = 3'b010,
		AND = 3'b011,
		XOR = 3'b100,
		LDA = 3'b101,
		STO = 3'b110,
		JMP = 3'b111
	} opcode_t;

	typedef enum bit[2:0]
	{
		INST_ADDR = 3'b000,
		INST_FETCH = 3'b001,
		INST_LOAD = 3'b010,
		IDLE = 3'b011,
		OP_ADDR = 3'b100,
		OP_FETCH = 3'b101,
		ALU_OP = 3'b110,
		STORE = 3'b111
	} state_t;
endpackage: typedefs
