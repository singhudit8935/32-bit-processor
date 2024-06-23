`timescale 1ns / 1ps

//defining field of IR
`define oper_type IR[31:27]
`define rdst IR[26:22]
`define rsrc1 IR[21:17]
`define imm_mod IR[16]
`define rsrc2 IR[15:11]
`define isrc IR[15:0] // when working in immediate mode 

// arithmetic operations 
`define movsgpr 5'b00000
`define mov 5'b00001
`define add 5'b00010
`define sub 5'b00011
`define mul 5'b00100

module top();
    reg[31:0] IR;  // [31-27] bits are used for operation type , [26-22] are used for destination register address
                   // [21-27] are used for source register address 1, bit 16 is used for mode selection
                   // if mode is immediate address mode then [15-0] are used for storing operand otherwise [15-11] are used for source address 2
    
    reg[15:0] GPR[31:0];     //adding 16 general purpose registers of 32 bits each
    reg[15:0] SGPR  ;             //adding a speacial gneral purpose register to store remaining 16 bits of product term
    reg[31:0] mul_result;      // adding a temporary reg to store 32 bits of multiplication

    always @(*) begin
        case (`oper_type)
            //case1 of move special
            `movsgpr: begin
                GPR[`rdst] = SGPR;
            end
            //case2 of move
            `mov: begin
                if(`imm_mod)
                    GPR[`rdst]= `isrc;
                else
                    GPR[`rdst]= `rsrc2;
                end
            //case 3 of addition
            `add: begin
                if(`imm_mod)
                    GPR[`rdst]= GPR[`rsrc1] + `isrc;
                else
                    GPR[`rdst]= GPR[`rsrc1] + GPR[`rsrc2];
            end
            //case 4 of subtraction
            `sub : begin
                 if(`imm_mod)
                    GPR[`rdst]= GPR[`rsrc1] - `isrc;
                else
                    GPR[`rdst]= GPR[`rsrc1] - GPR[`rsrc2];
            end
            //case 5 of multiplication
            `mul: begin
                 if(`imm_mod)
                   mul_result = GPR[`rsrc1] * `isrc;
                else
                    mul_result= GPR[`rsrc1] * GPR[`rsrc2];
            end
        endcase
    end
  

endmodule