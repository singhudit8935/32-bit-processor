`include "IR_and_GPR.v"
module tb;
integer i=0;
top dut();

//updating all GPR to 2
initial begin
    for(i=0; i<32; i=i+1) begin
        dut.GPR[i]=2;
        
    end
end






endmodule