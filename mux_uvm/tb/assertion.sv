/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module mux_assertions (
    input  logic        clk,
    input  logic [31:0] d [3:0],
    input  logic [1:0]  sel,
    input  logic [31:0] y
);

    // -- PROPERTY 1: Basic Functional Correctness --
    // Verify that the output matches the selected input on every clock edge
    property p_mux_logic;
        @(posedge clk) (y == d[sel]);
    endproperty
    ast_mux_logic: assert property (p_mux_logic) 
                   else $error("SVA ERROR: Output y (%h) != d[%0d] (%h)", y, sel, d[sel]);

    // -- PROPERTY 2: No Unknowns (X-Propagation) --
    // Verify that output y is never X or Z when inputs are valid
    property p_no_x_out;
        @(posedge clk) !$isunknown(y);
    endproperty
    ast_no_x_out: assert property (p_no_x_out)
                  else $error("SVA ERROR: Unknown value detected on output y!");
      
      property p_no_x_sel;
        @(posedge clk) !$isunknown(sel);
    endproperty
      
      ast_no_x_sel: assert property (p_no_x_sel)
        else
          $error("SVA", "SELECT LINE IS X/Z!");

    // -- PROPERTY 3: Select Line Coverage --
    // Ensure all 4 paths are actually exercised (Coverage through Assertions)
    cp_sel_0: cover property (@(posedge clk) sel == 2'b00);
    cp_sel_1: cover property (@(posedge clk) sel == 2'b01);
    cp_sel_2: cover property (@(posedge clk) sel == 2'b10);
    cp_sel_3: cover property (@(posedge clk) sel == 2'b11);

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
