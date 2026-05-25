/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module p_enc (
  input logic[3:0] req,
  output logic [1:0] code,
  output logic valid
);
  
  always_comb begin
    
    code  = 2'b00;
    valid = 1'b0;

    casez (req)
     
      4'b1???: {valid, code} = {1'b1, 2'b11}; // Bit 3 is Code 3
      4'b01??: {valid, code} = {1'b1, 2'b10}; // Bit 2 is Code 2
    
      4'b001?: {valid, code} = {1'b1, 2'b01}; // Bit 1 is Code 1
    
      4'b0001: {valid, code} = {1'b1, 2'b00}; // Bit 0 is Code 0
    
      default: {valid, code} = {1'b0, 2'b00};
    
    endcase
  
  end
  

endmodule


bind p_enc p_enc_assertion assert_inst(
  .req(req),
  .code(code),
  .valid(valid)
);

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
