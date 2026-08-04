/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module dec_2to4 (
    input  logic [1:0] sel,
    input  logic       en,
    output logic [3:0] y
);
    always_comb begin
    if (en) begin
        case (sel)
            2'b00: y = 4'b0001;
            2'b01: y = 4'b0010;
            2'b10: y = 4'b0100;
            2'b11: y = 4'b1000;
            default: y = 4'bxxxx; // Force X out if input is X
        endcase
    end 
      else begin
        y = 4'b0000;
    end
end
endmodule


bind dec_2to4 dec_assertion assert_inst(

  .sel(sel),
  .en(en),
  .y(y)
);
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
