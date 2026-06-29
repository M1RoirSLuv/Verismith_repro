module top(y, clk);
  output y;
  input clk;
  reg [5:0] reg1 = 0;
  reg signed [8:0] reg2 = 0;
  assign y = reg2;
  always @(posedge clk)
    for (reg1 = 0; reg1 < 2; reg1 = reg1 + 1)
      reg2 <= reg1[2:2];
endmodule
