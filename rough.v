`timescale 1ns / 1ps

// defining field of IR----------------_______--------____------__--------
`define oper_type IR[31:27]
`define rdst IR[26:22]
`define rsrc1 IR[21:17]
`define imm_mode IR[16]
`define rsrc2 IR[15:11]
`define isrc IR[15:0] // when working in immediate mode 

// arithmetic operations -----------------------------------
`define movsgpr 5'b00000
`define mov 5'b00001
`define add 5'b00010
`define sub 5'b00011
`define mul 5'b00100

// logical instructions-----------------------------or, and, xor, xnor, nor, not, nand 
`define ror 5'b00101  // we are not using OR because it is a keyword. We can't use a keyword for naming a variable
`define rand 5'b00110
`define rxor 5'b00111
`define rxnor 5'b01000
`define rnand 5'b01001
`define rnor 5'b01010
`define rnot 5'b01011

module top();
    reg [31:0] IR;  // [31:27] bits are used for operation type, [26:22] are used for destination register address
                    // [21:17] are used for source register address 1, bit 16 is used for mode selection
                    // if mode is immediate address mode then [15:0] are used for storing operand otherwise [15:11] are used for source address 2
    
    reg [15:0] GPR [31:0]; // 32 general purpose registers of 16 bits each
    reg [15:0] SGPR;       // special general purpose register to store remaining 16 bits of product term
    reg [31:0] mul_result; // temporary register to store 32 bits of multiplication

    always @(*) begin
        case (`oper_type)
            // case 1: move special
            `movsgpr: begin
                GPR[`rdst] = SGPR;
            end
            // case 2: move
            `mov: begin
                if (`imm_mode)
                    GPR[`rdst] = `isrc;
                else
                    GPR[`rdst] = GPR[`rsrc2];
            end
            // case 3: addition
            `add: begin
                if (`imm_mode)
                    GPR[`rdst] = GPR[`rsrc1] + `isrc;
                else
                    GPR[`rdst] = GPR[`rsrc1] + GPR[`rsrc2];
            end
            // case 4: subtraction
            `sub: begin
                if (`imm_mode)
                    GPR[`rdst] = GPR[`rsrc1] - `isrc;
                else
                    GPR[`rdst] = GPR[`rsrc1] - GPR[`rsrc2];
            end
            // case 5: multiplication
            `mul: begin
                if (`imm_mode)
                    mul_result = GPR[`rsrc1] * `isrc;
                else
                    mul_result = GPR[`rsrc1] * GPR[`rsrc2];
                GPR[`rdst] = mul_result[15:0];
                SGPR = mul_result[31:16];
            end
            // case 6: logical OR
            `ror: begin
                if (`imm_mode)
                    GPR[`rdst] = GPR[`rsrc1] | `isrc;
                else
                    GPR[`rdst] = GPR[`rsrc1] | GPR[`rsrc2];
            end

            default: begin
                // Default case to handle undefined operations
                GPR[`rdst] = 16'b0;
            end
        endcase
    end
endmodule
