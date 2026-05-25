/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module arb_assertion(
  input logic clk,
  input logic rst_n,
  input logic [3:0] req,
  input logic [3:0] gnt
);
  //active reset check
  property p_rst_logic;
    @(posedge clk) (!rst_n) |-> (gnt == 4'b0000);
  endproperty
  a_reset_logic:assert property(p_rst_logic)
    else $error("RESET active and gnt is not zero!");
    
    //inactive reset check
    property p_rst_ia;
      @(posedge clk) $rose(rst_n) |-> (gnt==4'b0000);
    endproperty
    a_rst_ia: assert property(p_rst_ia)
      else $error("failed to initialize gnt at 0000!!");

    //Grant check
      property p_mutual_exclusion;
        @(posedge clk) disable iff(!rst_n) $onehot0(gnt);
      endproperty
      
      a_mutual_exclusion:assert property(p_mutual_exclusion)
        else $error("Multiple Grants detected!");
        
     ///no ghost grants
       property p_grant_valid;
         @(posedge clk) disable iff(!rst_n) (|gnt) |-> (|(gnt & $past(req)));
       endproperty
        
        a_grant_valid:assert property(p_grant_valid)
          else $error("Grant issued without a Request!");
          
     //glitch check
     property p_gnt_stable;
       @(posedge clk) disable iff(!rst_n) (gnt !=0 && |(req & gnt)) |=> (gnt!=0);
     endproperty
     a_gnt_stable:assert property(p_gnt_stable)
       else $error("grant not stable!!");
      
      // no starvation check
       property p_no_starvation;
         @(posedge clk) disable iff(!rst_n) req[0] |-> ##[1:10] gnt[0];
       endproperty
       a_no_starvation:assert property(p_no_starvation)
         else $error("There is starvation happening check the logic !!");
      
  
  
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
