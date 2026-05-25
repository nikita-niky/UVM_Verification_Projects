// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================

module alu_assertion(
  input logic clk,
  input logic rst,
  input logic [3:0] a,
  input logic [3:0] b,
  input logic [2:0] op,
  input logic [3:0] res,
  input logic carry,
  input logic zero,
  input logic neg,
  input logic ovfl  
); 
  
    ///checking reset logic
      property p_reset_check;
        @(posedge clk) rst |=> (res==0 && carry==0 && zero==0 && neg==0 && ovfl==0);
      endproperty

      a_rst_check:assert property(p_reset_check) else $error("RESET logic not working");

      //checking flag assertions 
      //ZERO flag
      property p_zero_flag;
        @(posedge clk) disable iff(rst) (res==0) <-> zero;
      endproperty

      a_zero_flag: assert property(p_zero_flag) else $error("ZERO flag not asserted when result is =0");

        //NEGATIVE flag

      property p_neg_flag;
        @(posedge clk) disable iff(rst) (res[3]==1) |-> neg;
      endproperty
        a_neg_flag:assert property(p_neg_flag) else $error("NEG flag Not asserted for negative result");

        //Logical operation assertion

       property p_logic_clean_flag;
         @(posedge clk) disable iff(rst) (op>=3'b010) |-> (carry==0 && ovfl==0);
       endproperty

        a_logic_clean_flag: assert property(p_logic_clean_flag) else $error("Logical operation using flags which is wrong");
       
       // Bitwise AND Result
        property p_and_res;
          @(posedge clk) disable iff(rst) 
          (op == 3'b010) |=> (res == ($past(a) & $past(b)));
        endproperty
        a_and_res: assert property(p_and_res) else $error("AND logic failure");

        // Bitwise OR Result
        property p_or_res;
          @(posedge clk) disable iff(rst) 
          (op == 3'b011) |=> (res == ($past(a) | $past(b)));
        endproperty
        a_or_res: assert property(p_or_res) else $error("OR logic failure");

        // Bitwise XOR Result
        property p_xor_res;
          @(posedge clk) disable iff(rst) 
          (op == 3'b100) |=> (res == ($past(a) ^ $past(b)));
        endproperty
        a_xor_res: assert property(p_xor_res) else $error("XOR logic failure");

        // Bitwise NOT Result (Inverse of A)
        property p_not_res;
          @(posedge clk) disable iff(rst) 
          (op == 3'b101) |=> (res == (~$past(a)));
        endproperty
        a_not_res: assert property(p_not_res) else $error("NOT logic failure");

       
      //Arthmetic specific assertion
      // Carry Out Assertion (for ADD)
          property p_add_carry;
            @(posedge clk) disable iff(rst) (op == 3'b000 && ($past(a) + $past(b) > 15)) |=> carry;
          endproperty
          a_add_carry:assert property(p_add_carry) else $error("Carry flag not assserted when there is carry in addition");
            
       // Overflow Assertion (for ADD)
            // Positive + Positive should not result in a Negative bit
            property p_add_ovfl;
              @(posedge clk) disable iff (rst) (op==3'b000 && a[3]==0 && b[3] == 0) |->(res[3]==0);
            endproperty
            a_add_ovfl:assert property(p_add_ovfl) else $error("Overflow happend but didnt triggered the flag");

      // Subtraction Result Assertion
      property p_sub_res;
        @(posedge clk) disable iff(rst) (op==3'b001)|=> (res==($past(a) - $past(b)));
      endproperty
       
      a_sub_res: assert property(p_sub_res) else $error("Result not correct");

      // Subtraction Overflow (Signed)
	  // Positive - Negative = Negative OR Negative - Positive = Positive
        property p_sub_ovfl;
          @(posedge clk) disable iff (rst) (op == 3'b001 && $past(a[3]) != $past(b[3])) |=> (ovfl == (res[3] != $past(a[3])));
        endproperty
        a_sub_ovfl: assert property(p_sub_ovfl) else $error(" overfloe flag not triggered in SUB op code");
        
          //SUB borrow
          property p_sub_carry;
            @(posedge clk) disable iff(rst)
            (op == 3'b001 && ($past(a) < $past(b))) |=> (carry==1);
          endproperty
          a_sub_carry: assert property(p_sub_carry)  else $error("Borrow/Carry not set in SUB");

        // SHL: Result should be A multiplied by 2 (truncated to 4 bits)
            property p_shl_check;
              @(posedge clk) disable iff(rst) (op==3'b110) |=> (res==($past(a)<<1));
            endproperty
            a_shl_check:assert property(p_shl_check) else $error("SHL not working properly");

          //SHR: 
          // Shift Right Result Assertion
              property p_shr_res;
                @(posedge clk) disable iff (rst) 
                (op == 3'b111) |=> (res == ($past(a) >> 1));
              endproperty
              a_shr_res: assert property(p_shr_res) else  $error("SHR not working properly");
    
  
endmodule


// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================