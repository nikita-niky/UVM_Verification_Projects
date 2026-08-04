/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module fifo_top_sva#( parameter ADDR_SIZE = 4,
    parameter DATA_SIZE = 8)
  
  (  
  input  logic [DATA_SIZE-1:0] wdata,
  input  logic                 winc,
  input  logic                 wclk,
  input  logic                 wrst_n,
  input  logic                 rinc,
  input  logic                 rclk, 
  input  logic                 rrst_n,
  input  logic [DATA_SIZE-1:0] rdata,
  input  logic                 wfull,
  input  logic                 rempty
);
  
  ///RESET check for wr
  property p_wrst_chk;
    @(posedge wclk) !wrst_n |-> (wfull==1'b0);
  endproperty
  a_wrst_chk:assert property(p_wrst_chk)
    else $error("wrst_n is active still fifo FULL!!");
 
 //RESET check for rd
 property p_rrst_chk;
   @(posedge rclk) !rrst_n |-> (rempty==1'b1) ;
 endproperty
 a_rrst_chk:assert property(p_rrst_chk)
   else $error("rrst_n is active and fifo not EMPTY");
   
   // OVERFLOW chk
   property p_ovfl_chk;
     @(posedge wclk) disable iff(!wrst_n) wfull |-> !winc;
   endproperty
   a_ovfl_chk:assert property(p_ovfl_chk)
     else $error("OVERFLOW !!, write ignored because full detected");
   
  //UNDERFLOW chk
     property p_udfl_chk;
       @(posedge rclk) disable iff(!rrst_n) rempty |-> !rinc;
     endproperty
     a_udfl_chk:assert property(p_udfl_chk)
       else $error("UNDERFLOW!!, Read ignored because FIFO empty");
       
   
endmodule
       
module fifo_sync_ptr_sva #(parameter ADDR_SIZE = 4,
                           parameter DATA_SIZE = 8)  
  ( 
    input  logic [ADDR_SIZE:0] ptr_in,
    input  logic               clk,
    input logic                rst_n,
    input logic [ADDR_SIZE:0] ptr_out
  );
    
    //// Stability: If input doesn't change, output should eventually match
    property p_sync_settle;
      @(posedge clk) disable iff(!rst_n) $stable(ptr_in) [*3] |-> (ptr_out==ptr_in);
    endproperty
    a_sync_settle:assert property(p_sync_settle)
      else $error("Sync not settle!");           


endmodule
      
             
module wptr_full_sva#(parameter ADDR_SIZE = 4,
                      parameter DATA_SIZE = 8) 
  (
    input  logic                 wclk,
    input  logic                 wrst_n,
    input  logic                 winc,
    input  logic [ADDR_SIZE:0]   wq2_rptr, 
    input  logic                 wfull,
    input  logic [ADDR_SIZE-1:0] waddr,
    input  logic [ADDR_SIZE:0]   wptr
  );
  
  // Verify Gray Conversion: wptr must always be the Gray equivalent of internal binary
    // Since wbin is internal, we check the Gray property:
  property p_wptr_is_gray;
    @(posedge wclk) disable iff(!wrst_n) $changed(wptr) |-> $countones(wptr ^ $past(wptr))==1;
  endproperty
  a_wptr_gray:assert property(p_wptr_is_gray)
    else $error("CDC Error: WPTR is not GRAY coded");
    
    // Verify Full Logic: MSB and 2nd MSB must be different from synchronized Rptr
    property p_full_logic;
      @(posedge wclk) disable iff(!wrst_n)
      (wptr[ADDR_SIZE:ADDR_SIZE-1] == ~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1] && 
       wptr[ADDR_SIZE-2:0]== wq2_rptr[ADDR_SIZE-2:0])|=> wfull;
    endproperty
    a_full_logic:assert property(p_full_logic)
      else $error("Full flag logic mismatch");
      
endmodule
      
      
      
module rptr_empty_sva#(parameter ADDR_SIZE = 4,
                       parameter DATA_SIZE = 8)
  (
    input logic                 rclk,
    input logic                 rrst_n,
    input logic                 rinc,
    input logic [ADDR_SIZE:0]   rq2_wptr,
    input logic                 rempty,
    input logic [ADDR_SIZE-1:0] raddr,
    input logic [ADDR_SIZE:0]   rptr
  );
  
  
  property p_rptr_is_gray;
    @(posedge rclk) disable iff(!rrst_n) $changed(rptr) |-> $countones(rptr ^ $past(rptr))==1;
  endproperty
  a_rptr_gray:assert property(p_rptr_is_gray)
    else $error("CDC Error: RPTR is not GRAY coded");
  
  // Verify Empty Logic: rptr == rq2_wptr
  property p_empty_logic;
    @(posedge rclk) disable iff(!rrst_n)
    (rptr == rq2_wptr) |=> rempty;
  endproperty
  a_empty_logic:assert property(p_empty_logic) 
    else $error("Empty flag logic mismatch");
      
  
endmodule
    
    

module fifo_mem_sva #(parameter ADDR_SIZE = 4,
                      parameter DATA_SIZE = 8)
  (
    input  logic                 wclk,
    input  logic                 winc,
    input  logic                 wfull,
    input  logic                 rclk,
    input  logic                 rrst_n,
    input  logic                 rinc,
    input  logic                 rempty,
    input  logic [ADDR_SIZE-1:0] waddr,
    input  logic [ADDR_SIZE-1:0] raddr,
    input  logic [DATA_SIZE-1:0] wdata,
    input  logic [DATA_SIZE-1:0] rdata 
  );
  // Ensure write address only changes if we are actually writing
  property p_waddr_stable;
    @(posedge wclk) (!winc || wfull) |=> $stable(waddr);
  endproperty
  a_waddr_stable:assert property(p_waddr_stable)
    else $error("waddr changed during a non-write cycle!");
    
    // X-Check: Address should never be 'X' during an active operation
    a_waddr_no_x: assert property (@(posedge wclk) winc |-> !$isunknown(waddr));
   a_rdata_no_x: assert property (@(posedge rclk) disable iff(!rrst_n) (rinc && !rempty) |-> !$isunknown(rdata));
      
  //READ adress only changes if we are actually reading
  property p_raddr_stable;
    @(posedge rclk) disable iff(!rrst_n) (!rinc || rempty) |=> $stable(raddr);
  endproperty
   a_raddr_stable:assert property(p_raddr_stable)
     else $error("raddr changed during a non-read cycle!");
     
    // 4. Data Stability 
  // rdata should only change if rinc is high and not empty 
    property p_rdata_stable;
    @(posedge rclk) disable iff(!rrst_n) (!rinc || rempty) |=> $stable(rdata);
  endproperty
  a_rdata_stable: assert property(p_rdata_stable)
    else $error("SVA ERROR: rdata changed while read was not active!");
  
  
endmodule

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
