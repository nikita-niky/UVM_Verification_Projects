import fsm_enum::*;
module fsm_assertion(
  input logic clk,
  input logic rst_n,
  input logic bit_in,
  input logic pattern_found,

  input state_t current_state
);
  //active Reset check
  property p_rst_active_check;
    @(posedge clk) (!rst_n) |-> (current_state== IDLE) ;
  endproperty
  a_p_rst_active_check:assert property(p_rst_active_check)
    else $error("rst_n active and state is not idle");
    
 //inactive reset check
 property p_rst_inactive_check;
   @(posedge clk) $rose(rst_n) |-> (current_state == IDLE) ;
 endproperty
    a_rst_inactive_check:assert property(p_rst_inactive_check)
      else $error("FSM failed to initialize to IDLE after reset release!");
      
 //state check 
 property p_fsm_transition;
   @(posedge clk) disable iff(!rst_n)
   (current_state == IDLE && bit_in==1)|=> (current_state==S1) or
   (current_state == S1 && bit_in==0)|=> (current_state==S10) or
   (current_state == S10 && bit_in==1)|=> (current_state==S101) or
     (current_state == S101 && bit_in==1)|=> (current_state==S1011);
 endproperty
 
 a_fsm_transition: assert property(p_fsm_transition)
   else $error("FSM transition failed %0t",$time);
   
 property p_out_state_check;
   @(posedge clk) disable iff(!rst_n) (current_state == S1011) |-> (pattern_found==1);
 endproperty
   a_out_state_check: assert property(p_out_state_check)
     else $error("Pattern found id high in wrong state");
     
     a_idle_to_s1:   assert property (@(posedge clk) disable iff(!rst_n) (current_state == IDLE && bit_in==1) |=> (current_state==S1));
 a_s1_to_s10:    assert property (@(posedge clk) disable iff(!rst_n) (current_state == S1   && bit_in==0) |=> (current_state==S10));
 a_s10_to_s101:  assert property (@(posedge clk) disable iff(!rst_n) (current_state == S10  && bit_in==1) |=> (current_state==S101));
 a_s101_to_s1011:assert property (@(posedge clk) disable iff(!rst_n) (current_state == S101 && bit_in==1) |=> (current_state==S1011));
 a_s10_recovery: assert property (@(posedge clk) disable iff(!rst_n) (current_state == S10  && bit_in==0) |=> (current_state==IDLE));
  

endmodule