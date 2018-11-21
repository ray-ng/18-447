// A simple multi-bit D flip-flop

module dff(d, q, clk, rst);

  parameter n = 1;

  output [n-1:0] q;
  input  [n-1:0] d;
  input          clk;
  input          rst;

  reg [n-1:0] state;
  assign #(1) q = state;

  always @(posedge clk) begin
    state = !rst ? 0 : d;
  end

endmodule
