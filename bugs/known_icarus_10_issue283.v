module testbench;
   wire y;
   reg  clk;
   reg [15:0] wire0;
   reg        reg1 = 1'h0;
   assign y = reg1;
   initial
     begin
        clk = 1'h0;
        wire0 = 1'h0;
        #10 $finish;
     end
   always #5 clk = ~clk;
   always @(posedge clk) $strobe("%b", y);
   always @(posedge clk) reg1 <= (wire0 >> {wire0 ~^ 1'b1, wire0});
endmodule
