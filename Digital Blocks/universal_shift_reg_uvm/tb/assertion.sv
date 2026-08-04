/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module univ_sr_assertion(
  input logic clk,
  input logic rst,
  inout logic [1:0] mode,
  input logic sin_left,
  input logic sin_right,
  input logic [3:0] d_in,
  input logic [3:0] q_out
); 
  
  ///RESET check
  property p_rst_check;
    @(posedge clk) rst |=> (q_out==4'b0000);
  endproperty
  
  a_rst_check:assert property(p_rst_check)
    else $error("RST FAILED !!");
    
  //HOLD check
  property p_hold_check;
    @(posedge clk) disable iff(rst) (mode == 2'b00) |=> (q_out ==$past(q_out));
  endproperty

  a_hold_check:assert property(p_hold_check)
    else $error("HOLD FAILED: q_out changed during idle mode");
      
  //parallel load check
  property p_load_check;
    @(posedge clk) disable iff(rst) (mode==2'b11) |=> (q_out==$past(d_in));
  endproperty
  a_load_check:assert property(p_load_check)
    else $error("Parallel load failed!!");
        
  //shift right check
  property p_sr_check;
    @(posedge clk) disable iff(rst) (mode==2'b01) |=> (q_out[2:0]==$past(q_out[3:1])) && (q_out[3]==$past(sin_left));
  endproperty
  a_sr_check:assert property (p_sr_check)
    else $error("Shift Right function Failed!!");

  //shift left check
  property p_sl_check;
    @(posedge clk) disable iff(rst) (mode==2'b10) |=> (q_out[3:1]===$past(q_out[2:0])) && (q_out[0] == $past(sin_right));
  endproperty
  a_sl_check: assert property(p_sl_check)
    else $error("Shift left function Failed!!");   

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
