/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module p_enc_assertion(
   input logic [3:0] req,
   input logic [1:0] code,
   input logic valid
);

      property p_valid_high;
        @(req) (req!=4'b0000) |-> (valid == 1'b1);
      endproperty

      assert_valid_high: assert property(p_valid_high)
        else
          $error("Valid is LOW even though req is HIGH");

      property p_valid_low;
        @(req)(req==4'b0000) |-> (valid ==1'b0);
      endproperty

      asser_valid_low: assert property (p_valid_low)
        else
          $error("VALID is HIGH even though req is LOW");

      property p_bit_3_priority;
        @(req)(req[3]==1'b1)|-> (code==2'b11);
      endproperty
      
      assert_bit3:assert property(p_bit_3_priority)
        else
          $error("Priority voilation Bit 3 high but code not 3!");
               
          property p_invalid_zero;
 			 @(req) (valid == 1'b0) |-> (code == 2'b00);
			endproperty

		assert_invalid_zero: assert property(p_invalid_zero)
  			else 
              $error("ASSERT", "Valid is LOW but Code is non-zero!");
          

        ///this one is to check the priority
        always @(req) begin
 
          #1; 

          if (req[3] == 1'b1 && req[1] == 1'b1) begin
            assert(code == 2'b11) 
              $info("@%0t Priority is given to 3 (Req=%b, Code=%b)", $time, req, code);
            else 
              $error("@%0t PRIORITY Fail: Bit 3 & 1 high, but Got Code=%b", $time, code);
          end
        end
  
  

 
  
  
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
