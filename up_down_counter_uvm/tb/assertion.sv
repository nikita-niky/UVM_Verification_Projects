/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

module counter_assertion(
  input logic clk,
  input logic rst,
  input logic load,
  input logic up_down,
  input logic [3:0] count_in,
  input logic [3:0] count,
  input logic max_tick,
  input logic min_tick
); 
  
  ///reset check
  property p_reset_check;
    @(posedge clk) rst |=> count==0;
  endproperty

  a_reset_check:assert property(p_reset_check)
    else $error("Reset failed count not 0");
    
    ///load check
  property p_load_check;
    @(posedge clk) disable iff (rst) load |=> (count == $past(count_in));
  endproperty

    a_load_check:assert property(p_load_check)
      else $error("LOAD failed : count mismatch");
      
	// up counting check
  property p_count_up;
    @(posedge clk) disable iff(rst) (!load && up_down)|=> (count == $past(count) + 1'b1);
  endproperty
    
  a_count_up:assert property(p_count_up)
    else $error("UP count not working!!");
        
        
   //down counting check
   property p_count_down;
     @(posedge clk) disable iff(rst) (!load && !up_down) |=> (count == $past(count) - 1'b1);
   endproperty
        
   a_count_down:assert property(p_count_down)
     else $error("DOWN count Not working!!");

     //max_tick check
   property p_max_tick;
     @(posedge clk) disable iff(rst) (count==4'b1111) |-> max_tick;
   endproperty

   a_max_check:assert property(p_max_tick)
     else $error("MAX tick diabled !");

     //MIN tick check
   property p_min_tick;
     @(posedge clk) disable iff(rst) (count==4'b0000) |-> min_tick;
   endproperty
   a_min_tick: assert property(p_min_tick)
     else $error("MIN TICK diabled !");
     
     
	// unknow count value check
   property p_count_x;
     @(posedge clk) (!rst) |-> !$isunknown(count) ;
   endproperty
   a_count_x:assert property(p_count_x)
     else $error("Disable RST but UNKNOWN count value !!");
     
     // boundary wrapping for up counter
   property p_wrap_up;
     @(posedge clk) disable iff(rst) (!load && up_down && count==4'b1111) |=> count==4'b0000;
   endproperty

   a_wrap_up:assert property (p_wrap_up)
     else $error("for UP counter its not wrapping to 0 !!");

    //boundary wrapping for down counter
    property p_wrap_down;
      @(posedge clk) disable iff(rst) (!load && !up_down && count==4'b0000) |=> count ==4'b1111;
    endproperty
       
    a_wrap_down:assert property(p_wrap_down)
      else $error("for DOWn counter its not wrapping to 15 !!");
      
      //reset priority over load
    property p_rst_load_priority;
      @(posedge clk) (rst && load) |=> count==4'b0000;
    endproperty
    a_rst_priority:assert property(p_rst_load_priority)
      else $error("LOAD is given priority even when rst is high !!");
   
  
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
