/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

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
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
