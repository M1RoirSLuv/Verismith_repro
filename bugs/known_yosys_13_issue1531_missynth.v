module top (y, clk, w);
   output reg y = 1'b0;
   input clk, w;
   reg [1:0] i = 2'b00;
   always @(posedge clk)
     for (i = 1'b0; i < 2'b01; i = i + 2'b01)
       y <= w || i[1:1];
endmodule
