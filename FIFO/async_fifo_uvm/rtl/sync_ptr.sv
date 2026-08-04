/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module sync_ptr #(parameter ADDR_SIZE = 4) (
    input  logic [ADDR_SIZE:0] ptr_in,
    input  logic               clk, rst_n,
    output logic [ADDR_SIZE:0] ptr_out
);
    logic [ADDR_SIZE:0] sync_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {ptr_out, sync_reg} <= '0;
        end else begin
            {ptr_out, sync_reg} <= {sync_reg, ptr_in};
        end
    end
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
