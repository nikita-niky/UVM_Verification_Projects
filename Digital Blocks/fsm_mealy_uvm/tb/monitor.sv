/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_monitor extends uvm_monitor;
  `uvm_component_utils(fsm_monitor)

  virtual fsm_if vif;
  fsm_item tr;

  uvm_analysis_port #(fsm_item) send;

  function new(string name = "fsm_monitor", uvm_component parent);
    super.new(name, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fsm_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
   
    forever begin
      tr = fsm_item::type_id::create("tr");
      
      @(vif.mon_cb);
      
      if(vif.mon_cb.rst_n) begin

        tr.rst_n          = vif.mon_cb.rst_n;
        tr.bit_in         = vif.mon_cb.bit_in;
        tr.pattern_found  = vif.mon_cb.pattern_found;
        tr.current_state  = state_t'(vif.mon_cb.current_state);

      `uvm_info("MON", $sformatf("rst_n=%0b | Sampled Bit: %b, State: %s, Found: %b",tr.rst_n,tr.bit_in, tr.current_state.name(), tr.pattern_found), UVM_LOW)     
     
       send.write(tr);
      
    end
      else begin
        `uvm_info("MON","negedge Reset ACTIVE", UVM_LOW)
        
        tr.rst_n          = vif.mon_cb.rst_n;
        tr.bit_in         = vif.mon_cb.bit_in;
        tr.pattern_found  = vif.mon_cb.pattern_found;
        tr.current_state  = state_t'(vif.mon_cb.current_state);

        `uvm_info("MON", $sformatf("rst_n=%0b | Sampled Bit: %b, State: %s, Found: %b",tr.rst_n,tr.bit_in, tr.current_state.name(), tr.pattern_found), UVM_LOW)   
        send.write(tr);

      end
    end
  endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
