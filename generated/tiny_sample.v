module top  (y, clk, wire3, wire2, wire1, wire0);
  output wire [(32'h1e):(32'h0)] y;
  input wire [(1'h0):(1'h0)] clk;
  input wire [(3'h7):(1'h0)] wire3;
  input wire signed [(2'h3):(1'h0)] wire2;
  input wire [(3'h7):(1'h0)] wire1;
  input wire [(3'h7):(1'h0)] wire0;
  wire signed [(2'h2):(1'h0)] wire8;
  wire [(3'h4):(1'h0)] wire7;
  wire signed [(2'h2):(1'h0)] wire6;
  reg [(3'h5):(1'h0)] reg11 = (1'h0);
  reg signed [(2'h3):(1'h0)] reg10 = (1'h0);
  reg signed [(2'h3):(1'h0)] reg9 = (1'h0);
  reg [(3'h6):(1'h0)] reg5 = (1'h0);
  reg [(3'h4):(1'h0)] reg4 = (1'h0);
  assign y = {wire8, wire7, wire6, reg11, reg10, reg9, reg5, reg4, (1'h0)};
  always
    @(posedge clk) begin
      reg4 <= wire0[(3'h7):(3'h5)];
      reg5 <= $unsigned((wire2 ~^ (reg4 & wire3)));
    end
  assign wire6 = wire2;
  assign wire7 = wire3;
  assign wire8 = (((reg5 ? wire1 : (8'ha8)) + (reg4 >= wire3)) > wire0);
  always
    @(posedge clk) begin
      reg9 <= wire3;
      if (wire7)
        begin
          reg10 <= (^~(~^(reg5 > wire7)));
        end
      else
        begin
          reg10 <= wire8;
          reg11 <= $unsigned($signed((wire3 && wire6)));
        end
    end
endmodule