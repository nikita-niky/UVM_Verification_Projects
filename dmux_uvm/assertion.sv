module demux_assertion(
  input logic [31:0] d,
  input logic [1:0]  sel,
  input logic [31:0] y [4],
  input logic clk,
  input logic rst_n
);

  property p_sel_not_unknown;
    @(posedge clk) disable iff (!rst_n) !$isunknown(sel);
  endproperty
  
  assert_sel_stable: assert property (p_sel_not_unknown)
    else 
      $error("SVA", "SEL signal contains X/Z!");

  
  property p_d_not_unknown;
    @(posedge clk) disable iff (!rst_n) !$isunknown(d);
  endproperty
  
    assert_d_stable: assert property (p_d_not_unknown)
    else 
      $error("SVA", "Input D contains X/Z!");

  
  property p_mux_port0;
    @(posedge clk) disable iff (!rst_n) (sel == 2'b00) |=> (y[0] === $past(d));
  endproperty
    
  assert_port0: assert property (p_mux_port0) 
    else 
       $error("SVA", "Port 0 Data Mismatch!");

  
  property p_mux_port1;
    @(posedge clk) disable iff (!rst_n) (sel == 2'b01) |=> (y[1] === $past(d));
  endproperty
    
  assert_port1: assert property (p_mux_port1)
    else 
       $error("SVA", "Port 1 Data Mismatch!");


  property p_inactive_ports_zero;
    @(posedge clk) disable iff (!rst_n) 
    (sel == 2'b00) |=> (y[1] == 0 && y[2] == 0 && y[3] == 0);
  endproperty
    
  assert_inactive_check: assert property (p_inactive_ports_zero)
    else 
       $error("SVA", "Inactive port is not zero!");


  property p_reset_check;
    @(posedge clk) (!rst_n) |-> (y[0] == 0 && y[1] == 0 && y[2] == 0 && y[3] == 0);
  endproperty
    
  assert_reset: assert property (p_reset_check)
    else 
       $error("SVA", "Reset failed: Outputs not zero!");

endmodule