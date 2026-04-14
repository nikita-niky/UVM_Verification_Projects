module mux_4to1 (
  input  logic [31:0] d [3:0],
  input  logic [1:0]  sel,
  output logic [31:0] y,
  input logic clk
);
  assign y = d[sel];
endmodule


bind mux_4to1 mux_assertions assert_inst (
    .clk(top.clk), // Accessing clk from top
    .d(d),
    .sel(sel),
    .y(y)
);