/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module round_robin_arbiter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] req,
    output logic [3:0] gnt
);

  logic [3:0] mask;
  logic [3:0] masked_req;
  logic [3:0] masked_gnt;
  logic [3:0] raw_gnt;
  logic [3:0] next_gnt;
  

 
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      gnt <= 4'b0000;
      mask <= 4'b1111;
    end 
    else begin
      gnt <= next_gnt; 

      if (|next_gnt) begin
        case (next_gnt)
          4'b0001: mask <= 4'b1110; // Winner was 0, mask bits [0]
          4'b0010: mask <= 4'b1100; // Winner was 1, mask bits [1:0]
          4'b0100: mask <= 4'b1000; // Winner was 2, mask bits [2:0]
          4'b1000: mask <= 4'b0000; // Winner was 3, mask bits [3:0]
          default: mask <= 4'b1111;
        endcase
      end
    end
  end


  assign masked_req = req & mask;

  assign masked_gnt = masked_req & ~(masked_req - 1);
  
  assign raw_gnt    = req & ~(req - 1);
  
  assign next_gnt = (|masked_req) ? masked_gnt : raw_gnt;
 
 
endmodule


bind round_robin_arbiter arb_assertion chk (
  .clk(clk),
  .rst_n(rst_n),
  .req(req),
  .gnt(gnt)
);
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
