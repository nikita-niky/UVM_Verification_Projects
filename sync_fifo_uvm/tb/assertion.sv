/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module fifo_assertion(

  input logic clk,
  input logic rst_n,
  
  input logic wr_en,
  input logic [7:0] wdata,
  
  input logic rd_en,
  input logic [7:0] rdata,

  input logic full,
  input logic empty
); 
  
  //RESET state
  property p_reset_chk;
    @(posedge clk) !rst_n |-> (empty && !full);
  endproperty
  a_reset_chk:assert property(p_reset_chk)
    else $error("RESET Error!!");
    
      
   //OVERFLOW chk
   property p_no_ovfl;
     @(posedge clk) disable iff(!rst_n) wr_en |-> !full;
   endproperty
      a_no_ovfl:assert property(p_no_ovfl)
        else $error("OVERFLOW happened");
        
   /// UNDERFLOW chk
    property p_no_underflow;
      @(posedge clk) disable iff(!rst_n) rd_en |-> !empty;
    endproperty
    a_no_underflow:assert property(p_no_underflow)
      else $error("UNDERFLOW happened");
      
    //FLAG MUTUAL exclusve chk
      property p_mutex_flag;
        @(posedge clk) disable iff(!rst_n) (full!==1'bx && empty!==1'bx)|-> !(full && empty);
      endproperty
      a_mutex_flag:assert property(p_mutex_flag)
        else $error("BOTH FLAGS are asserted same time ERROR!!");
        
        ///full to empty chk
        property p_full_to_empty;
          @(posedge clk) disable iff(!rst_n) full |=> ##[1:$] empty;
        endproperty
        a_full_to_empty:assert property(p_full_to_empty)
          else $error("THE fifo didnt check full to empty scenario!!");
        
        
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
